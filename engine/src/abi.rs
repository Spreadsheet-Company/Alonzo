//! The engine's C surface (ENGINE.1's second slice, 2026-10-09): the twelve
//! exports of `SPEC.md` section 4.6, which the host shim calls (`web/host.js`)
//! and `tools/check_host_exports.ps1` holds name for name: eleven functions
//! and the module's memory. Each is a thin door onto `crate::cartridge`, which
//! is the language's machine with the engine's manifest and devices around
//! it, except the twelfth, [`alonzo_expand`] (`SPEC.3`'s second slice,
//! 2026-10-10), a door onto `crate::pass`, which takes no handle and touches
//! no grid: the pass is an act of its own before any load.
//!
//! **Memory and the record**, byte for byte as the language's own surface
//! has them (`vla-lang/src/abi.rs`): the host allocates every input with
//! [`alonzo_alloc`] and frees inputs and records alike with [`alonzo_free`]
//! and the length each had; every answer is one record, four little-endian
//! `u32` (status, line, id length, text length), then the id's bytes and the
//! text's bytes, its total length written to `out_len`. Status 0: the text is
//! the answer. Status 1: a refusal, the id the catalog's, the text its
//! words, the line the row it stands on or 0. Status 2: an input that is not
//! UTF-8, named. The plane's answer is the one record whose text is bytes and
//! not UTF-8.
//!
//! **The handles** live in one table for the module's life, from 1, never
//! reused, at most 16 at once (`vla_lang::machine::Handles`). The language's
//! own `vla_*` functions are compiled in and exported by nothing, its `c-abi`
//! feature never being turned on here.

use std::alloc::{alloc, dealloc, Layout};
use std::cell::RefCell;

use vla_lang::machine::{unloaded_row, written_row, Handles, Viewed};
use vla_lang::messages::Refusal;

use crate::cartridge::Cartridge;
use crate::pass;

const STATUS_OK: u32 = 0;
const STATUS_REFUSED: u32 = 1;
const STATUS_NOT_UTF8: u32 = 2;

/// The surface's version, the page's (`SPEC.md` section 8.1): it stays while
/// an export is added and no signature changes its meaning.
pub const ABI_VERSION: u32 = 1;

thread_local! {
    // On wasm32-unknown-unknown a thread-local is a plain static, and the
    // module's import section stays empty.
    static CARTRIDGES: RefCell<Handles<Cartridge>> = const { RefCell::new(Handles::new()) };
}

/// The engine's version and the language's, as the page's module line names them.
pub fn version_text() -> String {
    format!(
        "alonzo {} (vla-lang {})",
        env!("CARGO_PKG_VERSION"),
        vla_lang::VERSION
    )
}

fn layout(len: u32) -> Layout {
    Layout::array::<u8>((len as usize).max(1)).expect("a byte array fits in memory")
}

/// The surface's version, a bare number.
#[no_mangle]
pub extern "C" fn alonzo_abi_version() -> u32 {
    ABI_VERSION
}

/// Allocate `len` bytes the host may write into (an input) or that the
/// module hands back (a record). A zero length gets one byte.
///
/// # Safety
/// The caller owns the buffer and frees it with [`alonzo_free`] and the same
/// `len`.
#[no_mangle]
pub unsafe extern "C" fn alonzo_alloc(len: u32) -> *mut u8 {
    unsafe { alloc(layout(len)) }
}

/// Free a buffer [`alonzo_alloc`] returned, or a record a call returned, with
/// the length it was allocated with. A null pointer is ignored.
///
/// # Safety
/// `ptr` came from [`alonzo_alloc`], directly or as a record, with this
/// `len`, and is not used again.
#[no_mangle]
pub unsafe extern "C" fn alonzo_free(ptr: *mut u8, len: u32) {
    if !ptr.is_null() {
        unsafe { dealloc(ptr, layout(len)) }
    }
}

/// The bytes at `ptr`; a null pointer or a zero length is the empty slice.
unsafe fn bytes<'a>(ptr: *const u8, len: u32) -> &'a [u8] {
    if ptr.is_null() || len == 0 {
        &[]
    } else {
        unsafe { std::slice::from_raw_parts(ptr, len as usize) }
    }
}

/// A record handed to the host, allocated with [`alonzo_alloc`]'s layout.
fn record(status: u32, line: u32, id: &str, text: &[u8], out_len: *mut u32) -> *mut u8 {
    let total = 16 + id.len() + text.len();
    let mut buf: Vec<u8> = Vec::with_capacity(total);
    buf.extend_from_slice(&status.to_le_bytes());
    buf.extend_from_slice(&line.to_le_bytes());
    buf.extend_from_slice(&(id.len() as u32).to_le_bytes());
    buf.extend_from_slice(&(text.len() as u32).to_le_bytes());
    buf.extend_from_slice(id.as_bytes());
    buf.extend_from_slice(text);
    unsafe {
        let p = alonzo_alloc(total as u32);
        if p.is_null() {
            return p;
        }
        std::ptr::copy_nonoverlapping(buf.as_ptr(), p, total);
        if !out_len.is_null() {
            *out_len = total as u32;
        }
        p
    }
}

fn answer(text: &[u8], out_len: *mut u32) -> *mut u8 {
    record(STATUS_OK, 0, "", text, out_len)
}

fn refused(line: u32, r: &Refusal, out_len: *mut u32) -> *mut u8 {
    record(STATUS_REFUSED, line, &r.id, r.text.as_bytes(), out_len)
}

/// An input as text, or the status-2 record naming it.
fn text<'a>(b: &'a [u8], what: &str, out_len: *mut u32) -> Result<&'a str, *mut u8> {
    std::str::from_utf8(b).map_err(|_| {
        record(
            STATUS_NOT_UTF8,
            0,
            "",
            format!("{what} not UTF-8").as_bytes(),
            out_len,
        )
    })
}

/// The engine's version and the language's as a status-0 record.
///
/// # Safety
/// `out_len` is writable or null.
#[no_mangle]
pub unsafe extern "C" fn alonzo_version_text(out_len: *mut u32) -> *mut u8 {
    answer(version_text().as_bytes(), out_len)
}

/// `load`: a cartridge's bytes, and a name for the file used in the File
/// sheet and nowhere else, made into a grid under a new handle, answered
/// `(cartridge <handle> "<title>" <mode> <w> <h> <rate>)`; refused with the
/// row's line, or `grid-handle-limit` when 16 grids are live.
///
/// # Safety
/// Each pointer came from [`alonzo_alloc`] with its length, or is null with
/// 0; `out_len` is writable or null.
#[no_mangle]
pub unsafe extern "C" fn alonzo_load(
    cart: *const u8,
    cart_len: u32,
    name: *const u8,
    name_len: u32,
    out_len: *mut u32,
) -> *mut u8 {
    let cart_text = match text(
        unsafe { bytes(cart, cart_len) },
        "the cartridge is",
        out_len,
    ) {
        Ok(t) => t,
        Err(p) => return p,
    };
    let name_text = match text(unsafe { bytes(name, name_len) }, "the name is", out_len) {
        Ok(t) => t,
        Err(p) => return p,
    };
    if let Err(r) = CARTRIDGES.with(|c| c.borrow().room()) {
        return refused(0, &r, out_len);
    }
    let cartridge = match Cartridge::load(cart_text, name_text, cart_len as usize) {
        Ok(c) => c,
        Err(e) => return refused(e.line, &e.refusal, out_len),
    };
    CARTRIDGES.with(|c| {
        let mut table = c.borrow_mut();
        match table.insert(cartridge) {
            Ok(handle) => {
                let row = table
                    .get(handle)
                    .map(|cart| cart.row(handle))
                    .unwrap_or_default();
                answer(row.as_bytes(), out_len)
            }
            Err(r) => refused(0, &r, out_len),
        }
    })
}

/// `describe`: the manifest as read, a row a device sheet the grid holds,
/// and the budget.
///
/// # Safety
/// `out_len` is writable or null.
#[no_mangle]
pub unsafe extern "C" fn alonzo_describe(handle: u32, out_len: *mut u32) -> *mut u8 {
    CARTRIDGES.with(|c| match c.borrow().get(handle) {
        Ok(cart) => answer(cart.describe().as_bytes(), out_len),
        Err(r) => refused(0, &r, out_len),
    })
}

/// `write`: rows, one a line, the engine's checks first and then the
/// machine's write, all or none, answered `(written <n>)`.
///
/// # Safety
/// `rows` came from [`alonzo_alloc`] with `rows_len`, or is null with 0;
/// `out_len` is writable or null.
#[no_mangle]
pub unsafe extern "C" fn alonzo_write(
    handle: u32,
    rows: *const u8,
    rows_len: u32,
    out_len: *mut u32,
) -> *mut u8 {
    CARTRIDGES.with(|c| {
        let mut table = c.borrow_mut();
        let cart = match table.get_mut(handle) {
            Ok(cart) => cart,
            Err(r) => return refused(0, &r, out_len),
        };
        let rows_text = match text(unsafe { bytes(rows, rows_len) }, "the rows are", out_len) {
            Ok(t) => t,
            Err(p) => return p,
        };
        match cart.write(rows_text) {
            Ok(n) => answer(written_row(n).as_bytes(), out_len),
            Err(e) => refused(e.line, &e.refusal, out_len),
        }
    })
}

/// `step`: the Clock's frame first when a frame begins, then at most
/// `budget` cells, 0 for no limit, answered `(step <frame> <evaluated> <of>
/// done|yielded)`.
///
/// # Safety
/// `out_len` is writable or null.
#[no_mangle]
pub unsafe extern "C" fn alonzo_step(handle: u32, budget: u32, out_len: *mut u32) -> *mut u8 {
    CARTRIDGES.with(|c| match c.borrow_mut().get_mut(handle) {
        Ok(cart) => answer(cart.step(budget as usize).row().as_bytes(), out_len),
        Err(r) => refused(0, &r, out_len),
    })
}

/// `view`: a projection's name (`grid` or `plane`, and since `vla-lang` 0.9.3
/// `values`, the record without its formulas, which the language answers and
/// the engine passes through), a sheet's name and a window (`A1:F20`; empty
/// for the sheet's extent), answered with the record's lines or the plane's
/// bytes.
///
/// # Safety
/// Each pointer came from [`alonzo_alloc`] with its length, or is null with
/// 0; `out_len` is writable or null.
#[allow(clippy::too_many_arguments)]
#[no_mangle]
pub unsafe extern "C" fn alonzo_view(
    handle: u32,
    projection: *const u8,
    projection_len: u32,
    sheet: *const u8,
    sheet_len: u32,
    window: *const u8,
    window_len: u32,
    out_len: *mut u32,
) -> *mut u8 {
    CARTRIDGES.with(|c| {
        let table = c.borrow();
        let cart = match table.get(handle) {
            Ok(cart) => cart,
            Err(r) => return refused(0, &r, out_len),
        };
        let projection = match text(
            unsafe { bytes(projection, projection_len) },
            "the projection is",
            out_len,
        ) {
            Ok(t) => t,
            Err(p) => return p,
        };
        let sheet = match text(
            unsafe { bytes(sheet, sheet_len) },
            "the sheet's name is",
            out_len,
        ) {
            Ok(t) => t,
            Err(p) => return p,
        };
        let window = match text(
            unsafe { bytes(window, window_len) },
            "the window is",
            out_len,
        ) {
            Ok(t) => t,
            Err(p) => return p,
        };
        let window = (!window.is_empty()).then_some(window);
        match cart.view(projection, sheet, window) {
            Ok(Viewed::Text(t)) => answer(t.as_bytes(), out_len),
            Ok(Viewed::Bytes(b)) => answer(&b, out_len),
            Err(r) => refused(0, &r, out_len),
        }
    })
}

/// `unload`: the grid freed and its handle never given again, answered
/// `(unloaded <handle>)`.
///
/// # Safety
/// `out_len` is writable or null.
#[no_mangle]
pub unsafe extern "C" fn alonzo_unload(handle: u32, out_len: *mut u32) -> *mut u8 {
    CARTRIDGES.with(|c| match c.borrow_mut().remove(handle) {
        Ok(_) => answer(unloaded_row(handle).as_bytes(), out_len),
        Err(r) => refused(0, &r, out_len),
    })
}

/// The texts a door hands the pass, in one buffer: a path, a NUL, its text,
/// a NUL, and so on, as Frazaro's translate takes its phrasebooks NUL
/// separated. An empty buffer is no text, and a last path with no text after
/// it is none either, so an include of it is refused by name.
fn included(all: &str) -> Vec<(String, String)> {
    if all.is_empty() {
        return Vec::new();
    }
    let parts: Vec<&str> = all.split('\0').collect();
    parts
        .chunks_exact(2)
        .map(|pair| (pair[0].to_string(), pair[1].to_string()))
        .collect()
}

/// `expand`: the pass (`SPEC.md` section 7.8), a cartridge's source, its
/// path, and the texts it may include, expanded into the cartridge's text,
/// the bytes the command line writes (`examples/expand.rs`); refused with the
/// source line of the form that raised the refusal. It takes no handle and
/// touches no grid: the pass is an act of its own, and the load that may
/// follow it is another.
///
/// # Safety
/// Each pointer came from [`alonzo_alloc`] with its length, or is null with
/// 0; `out_len` is writable or null.
#[no_mangle]
pub unsafe extern "C" fn alonzo_expand(
    source: *const u8,
    source_len: u32,
    path: *const u8,
    path_len: u32,
    files: *const u8,
    files_len: u32,
    out_len: *mut u32,
) -> *mut u8 {
    let source = match text(
        unsafe { bytes(source, source_len) },
        "the source is",
        out_len,
    ) {
        Ok(t) => t,
        Err(p) => return p,
    };
    let path = match text(unsafe { bytes(path, path_len) }, "the path is", out_len) {
        Ok(t) => t,
        Err(p) => return p,
    };
    let files = match text(
        unsafe { bytes(files, files_len) },
        "the texts to include are",
        out_len,
    ) {
        Ok(t) => t,
        Err(p) => return p,
    };
    match pass::expand(source, path, &included(files)) {
        Ok(e) => answer(e.text.as_bytes(), out_len),
        Err(e) => refused(e.line, &e.refusal, out_len),
    }
}

#[cfg(test)]
mod tests {
    //! The surface as a host meets it: inputs allocated with the module's
    //! allocator, every answer read as the record's bytes and freed with the
    //! length it holds. One test, since the handle table is the thread's for
    //! the module's life and a second test on the same thread would see it.
    use super::*;

    const LIFE: &str = include_str!("../../cartridges/life/life.vla");
    const LIFE_SOURCE: &str = include_str!("../../cartridges/life/life.source.vla");
    const COMMON: &str = include_str!("../../cartridges/common.vla");
    const LIFE_SOURCE_PATH: &str = "cartridges/life/life.source.vla";

    /// A record as the host reads it, the text still bytes.
    struct Rec {
        status: u32,
        line: u32,
        id: String,
        text: Vec<u8>,
    }

    impl Rec {
        fn text(&self) -> &str {
            std::str::from_utf8(&self.text).unwrap()
        }
    }

    /// An input in the module's memory: its pointer and length.
    fn put(bytes: &[u8]) -> (*mut u8, u32) {
        let len = bytes.len() as u32;
        let p = unsafe { alonzo_alloc(len) };
        unsafe { std::ptr::copy_nonoverlapping(bytes.as_ptr(), p, bytes.len()) };
        (p, len)
    }

    fn free(input: (*mut u8, u32)) {
        unsafe { alonzo_free(input.0, input.1) };
    }

    fn take(p: *mut u8, out_len: u32) -> Rec {
        let b = unsafe { std::slice::from_raw_parts(p, out_len as usize) }.to_vec();
        unsafe { alonzo_free(p, out_len) };
        let word = |i: usize| u32::from_le_bytes([b[i], b[i + 1], b[i + 2], b[i + 3]]);
        let (status, line, id_len, text_len) = (word(0), word(4), word(8) as usize, word(12));
        assert_eq!(
            16 + id_len + text_len as usize,
            b.len(),
            "the record's length"
        );
        Rec {
            status,
            line,
            id: String::from_utf8(b[16..16 + id_len].to_vec()).unwrap(),
            text: b[16 + id_len..].to_vec(),
        }
    }

    fn load(cart: &[u8], name: &str) -> Rec {
        let (c, n) = (put(cart), put(name.as_bytes()));
        let mut len = 0u32;
        let p = unsafe { alonzo_load(c.0, c.1, n.0, n.1, &mut len) };
        free(c);
        free(n);
        take(p, len)
    }

    fn write(handle: u32, rows: &str) -> Rec {
        let r = put(rows.as_bytes());
        let mut len = 0u32;
        let p = unsafe { alonzo_write(handle, r.0, r.1, &mut len) };
        free(r);
        take(p, len)
    }

    fn step(handle: u32, budget: u32) -> Rec {
        let mut len = 0u32;
        let p = unsafe { alonzo_step(handle, budget, &mut len) };
        take(p, len)
    }

    /// The pass through the surface, the texts to include NUL separated as a
    /// host joins them.
    fn expand(source: &[u8], path: &str, files: &[(&str, &str)]) -> Rec {
        let joined: Vec<String> = files.iter().map(|(p, t)| format!("{p}\0{t}")).collect();
        let (s, p, f) = (
            put(source),
            put(path.as_bytes()),
            put(joined.join("\0").as_bytes()),
        );
        let mut len = 0u32;
        let r = unsafe { alonzo_expand(s.0, s.1, p.0, p.1, f.0, f.1, &mut len) };
        free(s);
        free(p);
        free(f);
        take(r, len)
    }

    fn lf(s: &str) -> String {
        s.replace("\r\n", "\n")
    }

    fn view(handle: u32, projection: &str, sheet: &str, window: &str) -> Rec {
        let (a, s, w) = (
            put(projection.as_bytes()),
            put(sheet.as_bytes()),
            put(window.as_bytes()),
        );
        let mut len = 0u32;
        let p = unsafe { alonzo_view(handle, a.0, a.1, s.0, s.1, w.0, w.1, &mut len) };
        free(a);
        free(s);
        free(w);
        take(p, len)
    }

    #[test]
    fn the_surface_as_a_host_meets_it() {
        assert_eq!(alonzo_abi_version(), 1);
        let mut len = 0u32;
        let v = take(unsafe { alonzo_version_text(&mut len) }, len);
        assert_eq!(v.status, 0);
        assert!(
            v.text().starts_with("alonzo 0.1.0 (vla-lang "),
            "{}",
            v.text()
        );

        // The pass, an act of its own (SPEC.3's second slice): Life's source
        // and the library it includes expanded into Life's cartridge, the
        // command line's bytes, CRLF as it writes them.
        let library = [("cartridges/common.vla", COMMON)];
        let built = expand(LIFE_SOURCE.as_bytes(), LIFE_SOURCE_PATH, &library);
        assert_eq!(
            (built.status, built.id.as_str()),
            (0, ""),
            "{}",
            built.text()
        );
        assert_eq!(built.text(), lf(LIFE).replace('\n', "\r\n"));
        // An include the door did not hand in: refused at the include's line.
        let alone = expand(LIFE_SOURCE.as_bytes(), LIFE_SOURCE_PATH, &[]);
        assert_eq!(
            (alone.status, alone.id.as_str()),
            (1, "vla-include-cannot-read")
        );
        let include_line = LIFE_SOURCE
            .lines()
            .position(|l| l.trim() == "(include \"../common.vla\")")
            .expect("Life's source includes the library")
            + 1;
        assert_eq!(alone.line as usize, include_line, "the include's own line");
        // A source that is not UTF-8, named; and a last path with no text
        // after it is no text, so its include is refused by name.
        let raw = expand(&[0x28, 0xff, 0xfe, 0x29], LIFE_SOURCE_PATH, &library);
        assert_eq!((raw.status, raw.text()), (2, "the source is not UTF-8"));
        let (s, p, f) = (
            put(LIFE_SOURCE.as_bytes()),
            put(LIFE_SOURCE_PATH.as_bytes()),
            put(b"cartridges/common.vla"),
        );
        let mut len = 0u32;
        let unpaired = take(
            unsafe { alonzo_expand(s.0, s.1, p.0, p.1, f.0, f.1, &mut len) },
            len,
        );
        free(s);
        free(p);
        free(f);
        assert_eq!(unpaired.id, "vla-include-cannot-read");

        // Life loads under handle 1 and says what it is: the pass took none.
        let l = load(LIFE.as_bytes(), "life.vla");
        assert_eq!((l.status, l.id.as_str()), (0, ""), "{}", l.text());
        assert_eq!(l.text(), "(cartridge 1 \"Life\" plane 320 200 30)");
        let mut len = 0u32;
        let d = take(unsafe { alonzo_describe(1, &mut len) }, len);
        assert!(
            d.text().contains("(budget 30 62964 1888920 2000000)\n"),
            "{}",
            d.text()
        );

        // A refused load: the manifest's own words and the line, status 1.
        let bad = load(
            LIFE.replacen("(rate 30)", "(rate 121)", 1).as_bytes(),
            "life.vla",
        );
        assert_eq!((bad.status, bad.id.as_str()), (1, "cart-manifest-invalid"));
        let rate_line = LIFE
            .lines()
            .position(|l| l.contains("(rate 30)"))
            .expect("Life's manifest gives its rate")
            + 1;
        assert_eq!(bad.line as usize, rate_line, "the rate's own line");
        // Bytes that are not UTF-8, named, status 2.
        let raw = load(&[0x28, 0xff, 0xfe, 0x29], "bad.vla");
        assert_eq!((raw.status, raw.text()), (2, "the cartridge is not UTF-8"));

        // The writes: one that lands, one the engine refuses, one the
        // machine refuses.
        let w = write(1, "(cell \"Palette\" \"B1\" \"#FF8800\")");
        assert_eq!((w.status, w.text()), (0, "(written 1)"));
        let f = write(1, "(formula \"Clock\" \"B1\" \"=1\")");
        assert_eq!((f.status, f.id.as_str()), (1, "cart-device-cell-formula"));
        let t = write(1, "(cell \"Screen.last\" \"B1\" 1)");
        assert_eq!((t.status, t.id.as_str()), (1, "grid-write-last"));

        // A step that yields, a write it refuses, and the step's end.
        let s = step(1, 1000);
        assert_eq!(s.text(), "(step 1 1000 62964 yielded)");
        let during = write(1, "(cell \"Palette\" \"C1\" \"x\")");
        assert_eq!(during.id, "grid-write-during-step");
        let clock = view(1, "grid", "Clock", "B1");
        assert!(
            clock.text().contains("(cell \"Clock\" \"B1\" 1)\n"),
            "{}",
            clock.text()
        );

        // The plane of a window: a byte a cell; nothing computed yet reads 0.
        let p = view(1, "plane", "Screen", "A1:LH200");
        assert_eq!((p.status, p.text.len()), (0, 64_000));
        assert!(
            p.text.iter().all(|&b| b == 0),
            "the frame in progress is not shown"
        );

        // The view's refusals and an unknown handle, the language's ids.
        assert_eq!(view(1, "photo", "Screen", "").id, "view-projection-unknown");
        assert_eq!(view(1, "grid", "Nowhere", "").id, "view-sheet-unknown");
        assert_eq!(step(9, 0).id, "grid-handle-unknown");

        // The unload, its handle never given again.
        let mut len = 0u32;
        let u = take(unsafe { alonzo_unload(1, &mut len) }, len);
        assert_eq!(u.text(), "(unloaded 1)");
        let mut len = 0u32;
        let again = take(unsafe { alonzo_unload(1, &mut len) }, len);
        assert_eq!(again.id, "grid-handle-unknown");
        let small = "(cartridge \"tiny\"\n  (spec 2)\n  (title \"Tiny\")\n  (rate 0)\n  (screen grid 4 3)\n  (seed 1))\n(cell \"Board\" \"A1\" 1)\n";
        let next = load(small.as_bytes(), "tiny.vla");
        assert_eq!(next.text(), "(cartridge 2 \"Tiny\" grid 4 3 0)");
    }
}

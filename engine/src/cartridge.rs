//! The cartridge (ENGINE.1's second slice, 2026-10-09): what the engine adds
//! to the language's machine, and nothing else (`SPEC.md` section 4.6): the
//! manifest, the device sheets' layouts and their checks, the engine's own
//! sheets, the Clock's frame at every step, and `describe`. The grid, its
//! rows, its twins, its step, its views and their refusals are the
//! language's, `vla_lang::machine`, called here in Rust.
//!
//! **The load**, in section 4.2's order: a file holding a `defmacro` or an
//! `include` refused as a cartridge's source, which the pass expands and
//! the load never does (`SPEC.3`, `crate::pass`); the manifest read with the
//! language's reader, a later `(spec ...)` refused before anything else in
//! it; the rows after it read into a draft of the grid (`read_rows`); the
//! device checks over the draft; the engine's own sheets made in it before
//! the graph reads them, the Clock and the File always and the Input sheet
//! when the cartridge holds none, so that the host's eighteen rows always
//! land, a write making no sheet; then the machine over the draft, which
//! refuses a cycle, a function it does not compute and a construct it does
//! not read. Nothing is computed: the frame is 0, or a save's frame.
//!
//! **The write**: the engine's checks over every row first, then the
//! machine's write, all or none; checking first is the only order that keeps
//! a write atomic, since the machine holds no undo an engine could call
//! after it. A write while a frame is in progress goes straight to the
//! machine, which refuses it whatever it holds. Since `ENGINE.3` the checks
//! hold the Clock's values too: a person's write of the frame is refused,
//! the step's own write being the frame's only one, and the rate and the
//! seed are held to their ranges.
//!
//! **The refusals** are the engine's own catalogue, `data/messages.vla`, the
//! `cart` family, read by the language's mechanism; every other id is the
//! language's.

use std::sync::OnceLock;

use vla_lang::calc::{self, graph::is_formula, library};
use vla_lang::form::Form;
use vla_lang::machine::{read_rows, Draft, LineRefusal, Machine, Step, Viewed};
use vla_lang::messages::{self, Catalogue, Refusal};
use vla_lang::printer::write_datum;
use vla_lang::reader::read_forms;
use vla_lang::sheet::{number_text, parse_a1_range, A1Range, Cell, Content, MAX_ROW};

/// The engine's half of the catalogue, embedded at build time: no file is
/// read when the module runs.
const CATALOGUE_TEXT: &str = include_str!("../data/messages.vla");

fn catalogue() -> &'static Catalogue {
    static CATALOGUE: OnceLock<Catalogue> = OnceLock::new();
    CATALOGUE.get_or_init(|| Catalogue::parse(CATALOGUE_TEXT))
}

/// A refusal from the engine's catalogue, or from the language's for an id
/// the engine does not hold.
pub fn raise(id: &str, slots: &[(&str, &str)]) -> Refusal {
    catalogue()
        .raise(id, slots)
        .unwrap_or_else(|| messages::raise(id, slots))
}

fn refused(line: u32, id: &str, slots: &[(&str, &str)]) -> LineRefusal {
    LineRefusal {
        line,
        refusal: raise(id, slots),
    }
}

// ---- the manifest (section 7.2) -------------------------------------------

/// The versions of `SPEC.md` this engine reads. Version 3 adds no row and no
/// directive, so a cartridge written to it loads as a version 2 cartridge.
pub const SPECS: [u32; 3] = [1, 2, 3];
/// The highest rate, in frames a second; 0 is a step on every edit.
pub const MAX_RATE: u32 = 120;
/// The highest seed, so that a Park and Miller cell never sticks at 0.
pub const MAX_SEED: u32 = 2_147_483_646;
/// The largest window each mode draws (section 10): plane, then grid.
pub const PLANE_MAX: (u32, u32) = (320, 200);
pub const GRID_MAX: (u32, u32) = (80, 50);
/// The charter's line, two million formula cells a second, which describe's
/// budget row prints beside the cartridge's own.
pub const LINE: u64 = 2_000_000;

const REQUIRED: [&str; 5] = ["spec", "title", "rate", "screen", "seed"];
const OPTIONAL: [&str; 3] = ["author", "licence", "notes"];

/// The Screen's mode: a byte a cell through the Palette, or the record.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Mode {
    Plane,
    Grid,
}

impl Mode {
    pub fn word(self) -> &'static str {
        match self {
            Mode::Plane => "plane",
            Mode::Grid => "grid",
        }
    }
}

/// The dice: the manifest's number, or a number the host chooses.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Seed {
    Number(u32),
    Host,
}

/// The manifest as read.
#[derive(Clone, Debug, PartialEq)]
pub struct Manifest {
    pub name: String,
    pub spec: u32,
    pub title: String,
    pub rate: u32,
    pub mode: Mode,
    pub width: u32,
    pub height: u32,
    pub seed: Seed,
    /// Every directive as the manifest spells it, in its order.
    pub directives: Vec<String>,
}

/// A whole number as a row writes it: digits alone.
fn whole(f: &Form) -> Option<u64> {
    match f {
        Form::Sym(s) if !s.is_empty() && s.len() <= 12 && s.bytes().all(|b| b.is_ascii_digit()) => {
            s.parse().ok()
        }
        _ => None,
    }
}

/// A cartridge's name: lowercase letters, digits and hyphens, as a distro's.
fn name_ok(name: &str) -> bool {
    !name.is_empty()
        && name
            .bytes()
            .all(|b| b.is_ascii_lowercase() || b.is_ascii_digit() || b == b'-')
}

fn quoted(text: &str) -> String {
    write_datum(&Form::string(text))
}

impl Manifest {
    /// The manifest form read, or the refusal naming what is wrong, on the
    /// line of the directive it stands on.
    pub fn read(form: &Form) -> Result<Manifest, LineRefusal> {
        let invalid =
            |line: u32, what: &str| refused(line, "cart-manifest-invalid", &[("what", what)]);
        let list = match form {
            Form::List(l) if matches!(l.items.first(), Some(Form::Sym(h)) if h == "cartridge") => l,
            _ => {
                let line = form.as_list().map(|l| l.line).unwrap_or(0);
                return Err(invalid(
                    line,
                    "is not the file's first form, which is (cartridge \"name\" ...)",
                ));
            }
        };
        let line = list.line;
        let name = match list.items.get(1) {
            Some(Form::Str(n)) if name_ok(n) => n.clone(),
            Some(Form::Str(n)) => {
                return Err(invalid(line, &format!("names the cartridge {}", quoted(n))))
            }
            _ => return Err(invalid(line, "gives the cartridge no name")),
        };
        let directives = &list.items[2..];
        // A later page first: its directives are unknown here, and the spec
        // is the answer that names why.
        for item in directives {
            if let Form::List(d) = item {
                if let [Form::Sym(head), arg] = d.items.as_slice() {
                    if head == "spec" {
                        if let Some(n) = whole(arg) {
                            if !SPECS.iter().any(|s| u64::from(*s) == n) {
                                return Err(refused(
                                    d.line.max(line),
                                    "cart-spec-unsupported",
                                    &[("spec", &n.to_string())],
                                ));
                            }
                        }
                    }
                }
            }
        }
        let mut seen: Vec<String> = Vec::new();
        let mut written: Vec<String> = Vec::new();
        let (mut spec, mut title, mut rate) = (0u32, String::new(), 0u32);
        let (mut mode, mut width, mut height) = (Mode::Plane, 0u32, 0u32);
        let mut seed = Seed::Host;
        for item in directives {
            let text = write_datum(item);
            let (head, args, at) = match item {
                Form::List(d) => match d.items.first() {
                    Some(Form::Sym(h)) => (h.as_str(), &d.items[1..], d.line.max(line)),
                    _ => {
                        return Err(invalid(
                            line,
                            &format!("holds {text}, which is no directive"),
                        ))
                    }
                },
                _ => {
                    return Err(invalid(
                        line,
                        &format!("holds {text}, which is no directive"),
                    ))
                }
            };
            if !REQUIRED.contains(&head) && !OPTIONAL.contains(&head) {
                return Err(invalid(
                    at,
                    &format!("holds {text}, a directive this version does not know"),
                ));
            }
            if seen.iter().any(|s| s == head) {
                return Err(invalid(at, &format!("gives ({head} ...) twice")));
            }
            seen.push(head.to_string());
            let wrong = |shape: &str| invalid(at, &format!("gives {text}, where {shape}"));
            match head {
                "spec" => match args {
                    [n] if whole(n).is_some() => spec = whole(n).unwrap_or(0) as u32,
                    _ => return Err(wrong("(spec ...) holds the page's version, 1 or 2")),
                },
                "title" => match args {
                    [Form::Str(t)] => title = t.clone(),
                    _ => return Err(wrong("(title ...) holds one text")),
                },
                "rate" => match args {
                    [n] if whole(n).is_some_and(|n| n <= u64::from(MAX_RATE)) => {
                        rate = whole(n).unwrap_or(0) as u32
                    }
                    _ => return Err(wrong("(rate ...) is a whole number from 0 to 120")),
                },
                "screen" => {
                    let read = match args {
                        [Form::Sym(m), w, h] => match (m.as_str(), whole(w), whole(h)) {
                            ("plane", Some(w), Some(h)) => Some((Mode::Plane, w, h, PLANE_MAX)),
                            ("grid", Some(w), Some(h)) => Some((Mode::Grid, w, h, GRID_MAX)),
                            _ => None,
                        },
                        _ => None,
                    };
                    match read {
                        Some((m, w, h, (mw, mh)))
                            if (1..=u64::from(mw)).contains(&w) && (1..=u64::from(mh)).contains(&h) =>
                        {
                            (mode, width, height) = (m, w as u32, h as u32)
                        }
                        _ => {
                            return Err(wrong(
                                "(screen ...) is plane at most 320 by 200 or grid at most 80 by 50, the width then the height",
                            ))
                        }
                    }
                }
                "seed" => match args {
                    [Form::Sym(h)] if h == "host" => seed = Seed::Host,
                    [n] if whole(n).is_some_and(|n| (1..=u64::from(MAX_SEED)).contains(&n)) => {
                        seed = Seed::Number(whole(n).unwrap_or(1) as u32)
                    }
                    _ => {
                        return Err(wrong(
                            "(seed ...) is a whole number from 1 to 2147483646, or host",
                        ))
                    }
                },
                _ => match args {
                    [Form::Str(_)] => {}
                    _ => return Err(wrong(&format!("({head} ...) holds one text"))),
                },
            }
            written.push(text);
        }
        for r in REQUIRED {
            if !seen.iter().any(|s| s == r) {
                return Err(invalid(line, &format!("has no ({r} ...)")));
            }
        }
        Ok(Manifest {
            name,
            spec,
            title,
            rate,
            mode,
            width,
            height,
            seed,
            directives: written,
        })
    }

    /// The Screen's window from `A1`, the declared width and height.
    pub fn window(&self) -> String {
        A1Range {
            top: 1,
            left: 1,
            bottom: self.height,
            right: self.width,
        }
        .text()
    }
}

// ---- the device sheets (section 3) ----------------------------------------

/// A rectangle of cells, rows and columns from 1: top, left, bottom, right.
type Rect = (u32, u32, u32, u32);

/// A device sheet.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Device {
    Screen,
    Palette,
    Input,
    Keys,
    Clock,
    Audio,
    File,
    Camera,
    Write,
}

/// The devices, in the order describe lists them.
pub const DEVICES: [Device; 9] = [
    Device::Screen,
    Device::Palette,
    Device::Input,
    Device::Keys,
    Device::Clock,
    Device::Audio,
    Device::File,
    Device::Camera,
    Device::Write,
];

impl Device {
    pub fn name(self) -> &'static str {
        match self {
            Device::Screen => "Screen",
            Device::Palette => "Palette",
            Device::Input => "Input",
            Device::Keys => "Keys",
            Device::Clock => "Clock",
            Device::Audio => "Audio",
            Device::File => "File",
            Device::Camera => "Camera",
            Device::Write => "Write",
        }
    }

    /// An input the host writes before a step, or an effect it reads after.
    pub fn direction(self) -> &'static str {
        match self {
            Device::Input | Device::Clock => "input",
            _ => "effect",
        }
    }

    /// The device a sheet's name is, compared without case as the model
    /// compares sheet names.
    pub fn of(name: &str) -> Option<Device> {
        DEVICES
            .iter()
            .copied()
            .find(|d| d.name().eq_ignore_ascii_case(name))
    }

    /// Where its cells may be, row bands from the top; the Screen's window is
    /// the manifest's.
    fn layout(self) -> &'static [Rect] {
        match self {
            Device::Screen => &[],
            Device::Palette => &[(1, 1, 16, 3)],
            Device::Input => &[(1, 1, 10, 5), (11, 1, 18, 2)],
            Device::Keys => &[(1, 1, 10, 5)],
            Device::Clock => &[(1, 1, 3, 2)],
            Device::Audio => &[(1, 1, 5, 4)],
            Device::File => &[(1, 1, 3, 2)],
            Device::Camera => &[(1, 1, 2, 2)],
            Device::Write => &[(1, 1, MAX_ROW, 3)],
        }
    }

    /// The cells the host writes, which hold values and never formulas.
    fn host_cells(self) -> &'static [Rect] {
        match self {
            Device::Input => &[(1, 2, 10, 5), (11, 2, 18, 2)],
            Device::Clock => &[(1, 2, 3, 2)],
            Device::File => &[(1, 2, 2, 2)],
            _ => &[],
        }
    }

    /// The cells no derived write lands in: the Input sheet, the Clock and
    /// the File's first two rows (section 3.9).
    fn derived_blocked(self) -> &'static [Rect] {
        match self {
            Device::Input => &[(1, 1, 18, 5)],
            Device::Clock => &[(1, 1, 3, 2)],
            Device::File => &[(1, 1, 2, 2)],
            _ => &[],
        }
    }
}

fn spell(r: Rect) -> String {
    A1Range {
        top: r.0,
        left: r.1,
        bottom: r.2,
        right: r.3,
    }
    .text()
}

fn spell_all(sheet: &str, rects: &[Rect]) -> String {
    rects
        .iter()
        .map(|r| format!("{sheet}!{}", spell(*r)))
        .collect::<Vec<_>>()
        .join(" and ")
}

fn intersects(a: Rect, b: Rect) -> bool {
    a.0 <= b.2 && b.0 <= a.2 && a.1 <= b.3 && b.1 <= a.3
}

/// Whether a rectangle lies inside a layout of row bands, sorted from the top.
fn within(r: Rect, bands: &[Rect]) -> bool {
    let mut row = r.0;
    loop {
        let Some(b) = bands.iter().find(|b| b.0 <= row && row <= b.2) else {
            return false;
        };
        if r.1 < b.1 || r.3 > b.3 {
            return false;
        }
        if r.2 <= b.2 {
            return true;
        }
        row = b.2 + 1;
    }
}

/// The cell's address, `B2`.
fn address(row: u32, col: u32) -> String {
    spell((row, col, row, col))
}

/// What a cell holds, as a refusal names it.
fn held(cell: Option<&Cell>) -> String {
    match cell.map(|c| &c.content) {
        None => "nothing".to_string(),
        Some(Content::Number(n)) => number_text(*n).unwrap_or_else(|| n.to_string()),
        Some(Content::Text(t)) => quoted(t),
        Some(Content::Bool(b)) => b.to_string(),
        Some(Content::Error(e)) => e.clone(),
        Some(_) => "a formula".to_string(),
    }
}

/// A colour as the Palette spells one: `#` and six hexadecimal digits.
fn is_colour(t: &str) -> bool {
    t.len() == 7 && t.starts_with('#') && t[1..].bytes().all(|b| b.is_ascii_hexdigit())
}

/// The functions whose value is the wall clock's or the dice's.
const VOLATILE: [&str; 4] = ["NOW", "TODAY", "RAND", "RANDBETWEEN"];

/// The device checks of section 4.2 over the rows' grid, before the engine's
/// own sheets are made: the Screen, every device sheet's layout and its host
/// cells, the Palette in plane mode, and the volatile functions anywhere.
fn check_devices(draft: &Draft, m: &Manifest, camera: bool) -> Result<(), LineRefusal> {
    let book = &draft.workbook;
    let line =
        |si: usize, row: u32, col: u32| draft.lines.get(&(si, row, col)).copied().unwrap_or(0);
    for (si, sheet) in book.sheets.iter().enumerate() {
        let Some(device) = Device::of(&sheet.name) else {
            continue;
        };
        for (&(row, col), cell) in &sheet.cells {
            let target = format!("{}!{}", sheet.name, address(row, col));
            if device == Device::Screen {
                if !camera && (row > m.height || col > m.width) {
                    return Err(refused(
                        line(si, row, col),
                        "cart-screen-outside",
                        &[("target", &target), ("window", &m.window())],
                    ));
                }
                continue;
            }
            let at = (row, col, row, col);
            if !within(at, device.layout()) {
                return Err(refused(
                    line(si, row, col),
                    "cart-device-cell-outside",
                    &[
                        ("target", &target),
                        ("sheet", &sheet.name),
                        ("layout", &spell_all(&sheet.name, device.layout())),
                    ],
                ));
            }
            if is_formula(&cell.content) && device.host_cells().iter().any(|h| intersects(*h, at)) {
                return Err(refused(
                    line(si, row, col),
                    "cart-device-cell-formula",
                    &[
                        ("target", &target),
                        ("cells", &spell_all(&sheet.name, device.host_cells())),
                    ],
                ));
            }
        }
    }
    if m.mode == Mode::Plane {
        check_palette(draft)?;
    }
    for (si, sheet) in book.sheets.iter().enumerate() {
        for (&(row, col), cell) in &sheet.cells {
            let text = match &cell.content {
                Content::Formula(t) | Content::DynamicFormula(t) => t,
                Content::SharedMaster { text, .. } => text,
                _ => continue,
            };
            if let Some(f) = calc::calls(text)
                .into_iter()
                .find(|f| VOLATILE.contains(&f.as_str()))
            {
                return Err(refused(
                    line(si, row, col),
                    "cart-formula-volatile",
                    &[
                        ("cell", &format!("{}!{}", sheet.name, address(row, col))),
                        ("function", &f),
                    ],
                ));
            }
        }
    }
    Ok(())
}

/// The Palette of a plane cartridge: sixteen rows, the index in order in
/// column A and a colour, or a formula, in column B (section 3.2).
fn check_palette(draft: &Draft) -> Result<(), LineRefusal> {
    let book = &draft.workbook;
    let Some(si) = book.find_sheet("Palette") else {
        return Err(refused(
            0,
            "cart-palette-invalid",
            &[(
                "what",
                "The cartridge draws in plane mode and holds no Palette sheet",
            )],
        ));
    };
    let sheet = &book.sheets[si];
    let line = |row: u32, col: u32| draft.lines.get(&(si, row, col)).copied().unwrap_or(0);
    for row in 1..=16u32 {
        let index = row - 1;
        let a = sheet.cells.get(&(row, 1));
        if !matches!(a.map(|c| &c.content), Some(Content::Number(n)) if *n == f64::from(index)) {
            let what = format!(
                "The Palette's A{row} holds {}, where the index {index} belongs",
                held(a)
            );
            return Err(refused(
                line(row, 1),
                "cart-palette-invalid",
                &[("what", &what)],
            ));
        }
        let b = sheet.cells.get(&(row, 2));
        let fine = match b.map(|c| &c.content) {
            Some(Content::Text(t)) => is_colour(t),
            Some(c) => is_formula(c),
            None => false,
        };
        if !fine {
            let what = format!(
                "The Palette's B{row} holds {}, which is no colour #RRGGBB",
                held(b)
            );
            return Err(refused(
                line(row, 2),
                "cart-palette-invalid",
                &[("what", &what)],
            ));
        }
    }
    Ok(())
}

/// The Input sheet's labels, row by row (section 3.3).
pub const INPUT_LABELS: [&str; 18] = [
    "up",
    "down",
    "left",
    "right",
    "a",
    "b",
    "x",
    "y",
    "start",
    "select",
    "mouse-x",
    "mouse-y",
    "mouse-left",
    "mouse-right",
    "mouse-middle",
    "mouse-wheel",
    "key",
    "code",
];

/// One cell of the engine's own written into the draft, its style kept when
/// the rows wrote the cell, and counted when it is new.
fn put(draft: &mut Draft, si: usize, row: u32, col: u32, content: Content) {
    let sheet = &mut draft.workbook.sheets[si];
    let style = sheet.cells.get(&(row, col)).map(|c| c.style);
    if style.is_none() {
        draft.cells += 1;
    }
    sheet.set(
        row,
        col,
        Cell {
            content,
            style: style.unwrap_or(0),
        },
    );
}

/// A cell's value when it is a whole number within a range.
fn whole_in(cell: Option<&Cell>, low: f64, high: f64) -> Option<f64> {
    match cell.map(|c| &c.content) {
        Some(Content::Number(n)) if n.fract() == 0.0 && *n >= low && *n <= high => Some(*n),
        _ => None,
    }
}

/// A person's value into the Clock's column B, judged cell by cell, the frame
/// first (`ENGINE.3`, section 3.5). The frame is the engine's alone, written as
/// the first act of every step, so a value written there would be undone
/// unseen; the step writes it through the machine and never through this
/// check. The rate is 0 or a whole number of frames a second from 1 to 120,
/// which the host reads after each step and steps at, the teacher of section
/// 9; the seed is a whole number from 1 to 2147483646, so that a Park and
/// Miller cell seeded from it never sticks at 0. A formula or a derived row
/// there is refused before this, as a cell the host writes.
fn check_clock(line: u32, sheet: &str, range: &A1Range, value: &Form) -> Result<(), LineRefusal> {
    if range.left > 2 || range.right < 2 {
        return Ok(());
    }
    for row in range.top.max(1)..=range.bottom.min(3) {
        let what = match (row, whole(value)) {
            (1, _) => "is the Clock's frame, which the engine writes as the first act of every step, so a write there would be undone unseen: the frame is the only clock".to_string(),
            (2, Some(n)) if n <= u64::from(MAX_RATE) => continue,
            (2, _) => format!(
                "holds the Clock's rate, 0 or a whole number of frames a second from 1 to {MAX_RATE}, and {} is not one",
                write_datum(value)
            ),
            (_, Some(n)) if (1..=u64::from(MAX_SEED)).contains(&n) => continue,
            _ => format!(
                "holds the Clock's seed, a whole number from 1 to {MAX_SEED}, so that a Park and Miller cell never sticks at 0, and {} is not one",
                write_datum(value)
            ),
        };
        let target = format!("{sheet}!{}", address(row, 2));
        return Err(refused(
            line,
            "cart-write-clock",
            &[("target", &target), ("what", &what)],
        ));
    }
    Ok(())
}

/// The engine's own sheets made in the draft (section 4.2): the Clock's
/// three cells, the File's two, and the Input sheet when the cartridge holds
/// none. Answers a save's frame, the whole number above 0 its rows wrote in
/// `Clock!B1`, or 0.
fn make_own_sheets(draft: &mut Draft, m: &Manifest, name: &str, size: usize) -> u64 {
    let clock = draft.workbook.ensure_sheet("Clock");
    let saved = whole_in(
        draft.workbook.sheets[clock].cells.get(&(1, 2)),
        1.0,
        9_007_199_254_740_991.0,
    )
    .unwrap_or(0.0);
    let kept_seed = whole_in(
        draft.workbook.sheets[clock].cells.get(&(3, 2)),
        1.0,
        f64::from(MAX_SEED),
    );
    put(draft, clock, 1, 1, Content::Text("frame".to_string()));
    put(draft, clock, 1, 2, Content::Number(saved));
    put(draft, clock, 2, 1, Content::Text("rate".to_string()));
    put(draft, clock, 2, 2, Content::Number(f64::from(m.rate)));
    put(draft, clock, 3, 1, Content::Text("seed".to_string()));
    match (m.seed, kept_seed) {
        (Seed::Number(n), _) => put(draft, clock, 3, 2, Content::Number(f64::from(n))),
        // A save of a cartridge whose host chose the seed keeps the choice;
        // otherwise the seed waits for the host.
        (Seed::Host, Some(n)) => put(draft, clock, 3, 2, Content::Number(n)),
        (Seed::Host, None) => {
            if draft.workbook.sheets[clock].cells.remove(&(3, 2)).is_some() {
                draft.cells -= 1;
            }
        }
    }
    let file = draft.workbook.ensure_sheet("File");
    let shown = if name.is_empty() {
        "the cartridge"
    } else {
        name
    };
    put(draft, file, 1, 1, Content::Text("name".to_string()));
    put(draft, file, 1, 2, Content::Text(shown.to_string()));
    put(draft, file, 2, 1, Content::Text("size".to_string()));
    put(draft, file, 2, 2, Content::Number(size as f64));
    put(draft, file, 3, 1, Content::Text("save".to_string()));
    if draft.workbook.find_sheet("Input").is_none() {
        let input = draft.workbook.ensure_sheet("Input");
        for (i, label) in INPUT_LABELS.iter().enumerate() {
            let row = i as u32 + 1;
            put(draft, input, row, 1, Content::Text((*label).to_string()));
            let last = if row <= 10 { 5 } else { 2 };
            let fill = if row >= 17 {
                Content::Text(String::new())
            } else {
                Content::Number(0.0)
            };
            for col in 2..=last {
                put(draft, input, row, col, fill.clone());
            }
        }
    }
    saved as u64
}

// ---- the cartridge ---------------------------------------------------------

/// A loaded cartridge: the language's machine, with the manifest and the
/// fact the engine checks the Screen's writes by.
pub struct Cartridge {
    machine: Machine,
    manifest: Manifest,
    camera: bool,
}

impl std::fmt::Debug for Cartridge {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Cartridge")
            .field("manifest", &self.manifest)
            .field("camera", &self.camera)
            .field("machine", &self.machine)
            .finish()
    }
}

impl Cartridge {
    /// A cartridge's text loaded into a grid, `name` the file's name as the
    /// host gave it and `size` its length in bytes, for the File sheet.
    pub fn load(text: &str, name: &str, size: usize) -> Result<Cartridge, LineRefusal> {
        let forms = read_forms(text).map_err(|refusal| LineRefusal { line: 0, refusal })?;
        let Some(first) = forms.first() else {
            return Err(refused(
                0,
                "cart-manifest-invalid",
                &[("what", "is missing: the file holds no form")],
            ));
        };
        // A source is the pass's to expand and never the load's: refused
        // before its manifest, which a source may open on an include before.
        if let Some(source) = forms
            .iter()
            .find(|f| f.head_is("defmacro") || f.head_is("include"))
        {
            let head = if source.head_is("defmacro") {
                "defmacro"
            } else {
                "include"
            };
            return Err(refused(
                source.as_list().map(|l| l.line).unwrap_or(0),
                "cart-source-unexpanded",
                &[("form", &format!("({head} ...)"))],
            ));
        }
        let manifest = Manifest::read(first)?;
        let mut draft = read_rows(&forms[1..])?;
        let camera = draft.workbook.find_sheet("Camera").is_some();
        check_devices(&draft, &manifest, camera)?;
        let frame = make_own_sheets(&mut draft, &manifest, name, size);
        let mut machine = Machine::new(draft, library::language())?;
        if frame > 0 {
            machine
                .resume_at(frame)
                .map_err(|refusal| LineRefusal { line: 0, refusal })?;
        }
        Ok(Cartridge {
            machine,
            manifest,
            camera,
        })
    }

    pub fn manifest(&self) -> &Manifest {
        &self.manifest
    }

    pub fn machine(&self) -> &Machine {
        &self.machine
    }

    /// The load's answer: `(cartridge <handle> "<title>" <mode> <w> <h> <rate>)`.
    pub fn row(&self, handle: u32) -> String {
        let m = &self.manifest;
        format!(
            "(cartridge {handle} {} {} {} {} {})",
            quoted(&m.title),
            m.mode.word(),
            m.width,
            m.height,
            m.rate
        )
    }

    /// `describe`: the manifest's directives, one a row; a `device` row for
    /// each device sheet the grid holds, the Screen at its window and the
    /// rest at their layouts' extents; then the budget, the formula cells a
    /// frame, their product with the rate, and the charter's line; then the
    /// machine's census (Frazaro's `KERNEL.30`, laid here; `vla-lang` 0.9.2),
    /// the plan's row, a `readers` row for each sheet whose changes are
    /// followed, and a `shape` row for each shape with the path each of its
    /// reads takes, so that what a cartridge costs a frame is read before a
    /// frame runs (`SPEC.md` section 2's rules, each read off a row).
    pub fn describe(&self) -> String {
        let mut out = String::new();
        for d in &self.manifest.directives {
            out.push_str(d);
            out.push('\n');
        }
        // A sheet's place is the machine's to say: since vla-lang 0.9.0 the
        // grid it lends is borrowed mutably, its twins' cells made first.
        for device in DEVICES {
            match self.machine.find_sheet(device.name()) {
                Some(si) if si < self.machine.sheets() => {}
                _ => continue,
            }
            let range = match device {
                Device::Screen => self.manifest.window(),
                _ => {
                    let l = device.layout();
                    let (top, left) = (l[0].0, l[0].1);
                    let bottom = l.iter().map(|r| r.2).max().unwrap_or(top);
                    let right = l.iter().map(|r| r.3).max().unwrap_or(left);
                    spell((top, left, bottom, right))
                }
            };
            out.push_str(&format!(
                "(device {} {} {})\n",
                quoted(device.name()),
                quoted(&range),
                device.direction()
            ));
        }
        let formulas = self.machine.formulas().0 as u64;
        let rate = u64::from(self.manifest.rate);
        out.push_str(&format!(
            "(budget {rate} {formulas} {} {LINE})\n",
            rate * formulas
        ));
        out.push_str(&self.machine.census());
        out
    }

    /// Rows written, the engine's checks first, then the machine's write,
    /// all or none: the cells changed.
    pub fn write(&mut self, text: &str) -> Result<usize, LineRefusal> {
        if !self.machine.in_progress() {
            let forms = read_forms(text).map_err(|refusal| LineRefusal { line: 0, refusal })?;
            for form in &forms {
                self.check_row(form)?;
            }
        }
        self.machine.write(text)
    }

    /// The engine's checks of one written row, section 4.3 and section 3.9:
    /// a row the machine would refuse whatever its target is left to it.
    fn check_row(&self, form: &Form) -> Result<(), LineRefusal> {
        let Form::List(l) = form else { return Ok(()) };
        let [Form::Sym(head), Form::Str(sheet), Form::Str(addr), value] = l.items.as_slice() else {
            return Ok(());
        };
        if !matches!(head.as_str(), "cell" | "formula" | "derived") {
            return Ok(());
        }
        let Some(range) = parse_a1_range(addr) else {
            return Ok(());
        };
        let Some(si) = self.machine.find_sheet(sheet) else {
            return Ok(());
        };
        if si >= self.machine.sheets() {
            return Ok(());
        }
        let Some(name) = self.machine.sheet_name(si) else {
            return Ok(());
        };
        let Some(device) = Device::of(name) else {
            return Ok(());
        };
        let target = format!("{sheet}!{addr}");
        let at = (range.top, range.left, range.bottom, range.right);
        if device == Device::Screen {
            let m = &self.manifest;
            if !self.camera && (range.bottom > m.height || range.right > m.width) {
                return Err(refused(
                    l.line,
                    "cart-screen-outside",
                    &[("target", &target), ("window", &m.window())],
                ));
            }
            return Ok(());
        }
        if !within(at, device.layout()) {
            return Err(refused(
                l.line,
                "cart-device-cell-outside",
                &[
                    ("target", &target),
                    ("sheet", name),
                    ("layout", &spell_all(name, device.layout())),
                ],
            ));
        }
        if head == "formula" && device.host_cells().iter().any(|h| intersects(*h, at)) {
            return Err(refused(
                l.line,
                "cart-device-cell-formula",
                &[
                    ("target", &target),
                    ("cells", &spell_all(name, device.host_cells())),
                ],
            ));
        }
        if head == "derived" && device.derived_blocked().iter().any(|b| intersects(*b, at)) {
            return Err(refused(
                l.line,
                "cart-write-derived",
                &[
                    ("target", &target),
                    ("cells", &spell_all(name, device.derived_blocked())),
                ],
            ));
        }
        if head == "cell" && device == Device::Clock {
            check_clock(l.line, sheet, &range, value)?;
        }
        Ok(())
    }

    /// One step: when no frame is in progress, the next frame's number into
    /// `Clock!B1` first, the step's first act (section 3.5), so a frame that
    /// yields across calls is numbered once; then the machine's step.
    pub fn step(&mut self, budget: usize) -> Step {
        if !self.machine.in_progress() {
            let next = self.machine.frame() + 1;
            let written = self
                .machine
                .write(&format!("(cell \"Clock\" \"B1\" {next})"));
            debug_assert!(
                written.is_ok(),
                "the Clock is the engine's own: {written:?}"
            );
        }
        self.machine.step(budget)
    }

    /// A view, as the machine answers it: the engine adds nothing.
    pub fn view(
        &self,
        projection: &str,
        sheet: &str,
        window: Option<&str>,
    ) -> Result<Viewed, Refusal> {
        self.machine.view(projection, sheet, window)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const LIFE: &str = include_str!("../../cartridges/life/life.vla");

    /// The plane's test card (ENGINE.2): every kind of value under a panning Camera.
    const TESTCARD: &str = include_str!("../../cartridges/testcard/testcard.vla");

    const COLOURS: [&str; 16] = [
        "#000000", "#FFFFFF", "#0000AA", "#00AA00", "#00AAAA", "#AA0000", "#AA00AA", "#AA5500",
        "#AAAAAA", "#555555", "#5555FF", "#55FF55", "#55FFFF", "#FF5555", "#FF55FF", "#FFFF55",
    ];

    /// The rule of Life over the previous frame, on the cell it is written
    /// in, the first frame the Seed sheet's cell.
    const RULE: &str = "=IF(Clock!$B$1=1,Seed!B2,IF(OR(SUM(Screen.last!A1:C3)-Screen.last!B2=3,AND(Screen.last!B2=1,SUM(Screen.last!A1:C3)-Screen.last!B2=2)),1,0))";

    /// A small Life, 12 by 10, its interior `B2:K9` the rule and its first
    /// frame the Seed sheet: a glider and a blinker.
    const SEEDED: [(u32, u32); 8] = [
        (2, 3),
        (3, 4),
        (4, 2),
        (4, 3),
        (4, 4),
        (7, 8),
        (7, 9),
        (7, 10),
    ];

    fn manifest(rate: u32, extra: &str) -> String {
        format!(
            "(cartridge \"small\"\n  (spec 2)\n  (title \"Small\")\n  (rate {rate})\n  (screen plane 12 10)\n  (seed 1){extra})\n"
        )
    }

    fn palette() -> String {
        let mut out = String::new();
        for (i, c) in COLOURS.iter().enumerate() {
            out.push_str(&format!(
                "(cell \"Palette\" \"A{r}\" {i})\n(cell \"Palette\" \"B{r}\" \"{c}\")\n",
                r = i + 1
            ));
        }
        out
    }

    fn small_rows() -> String {
        let mut out = String::from(
            "(sheet \"Screen\" visible)\n(sheet \"Palette\" visible)\n(sheet \"Seed\" visible)\n",
        );
        out.push_str(&palette());
        out.push_str("(cell \"Seed\" \"B2:K9\" 0)\n");
        out.push_str(&format!(
            "(formula \"Screen\" \"B2:K9\" \"{}\")\n",
            RULE.replace('"', "\\\"")
        ));
        out
    }

    /// The small Life's text with each `(row col)` of the Seed set alive.
    fn small(rate: u32) -> String {
        let seeds: String = SEEDED
            .iter()
            .map(|(r, c)| format!("(cell \"Seed\" \"{}\" 1)\n", address(*r, *c)))
            .collect();
        // The Seed's fill and its cells would write a cell twice, so the
        // fill covers the rows the pattern leaves alone and the pattern's
        // rows are written cell by cell.
        let mut rows = small_rows().replace("(cell \"Seed\" \"B2:K9\" 0)\n", "");
        for r in 2..=9u32 {
            for c in 2..=11u32 {
                if !SEEDED.contains(&(r, c)) {
                    rows.push_str(&format!("(cell \"Seed\" \"{}\" 0)\n", address(r, c)));
                }
            }
        }
        format!("{}{rows}{seeds}", manifest(rate, ""))
    }

    fn load(text: &str) -> Result<Cartridge, LineRefusal> {
        Cartridge::load(text, "small.vla", text.len())
    }

    fn id_of(r: Result<Cartridge, LineRefusal>) -> String {
        match r {
            Ok(_) => "loaded".to_string(),
            Err(e) => e.refusal.id,
        }
    }

    fn text_of(r: Result<Cartridge, LineRefusal>) -> String {
        match r {
            Ok(_) => "loaded".to_string(),
            Err(e) => format!("{} line {}: {}", e.refusal.id, e.line, e.refusal.text),
        }
    }

    fn plane(c: &Cartridge) -> Vec<u8> {
        match c.view("plane", "Screen", Some("A1:L10")) {
            Ok(Viewed::Bytes(b)) => b,
            other => panic!("the plane: {other:?}"),
        }
    }

    fn cell_text(c: &Cartridge, sheet: &str, addr: &str) -> String {
        let record = match c.view("grid", sheet, Some(addr)) {
            Ok(Viewed::Text(t)) => t,
            other => panic!("the record: {other:?}"),
        };
        record
            .lines()
            .find(|l| l.starts_with("(cell ") || l.starts_with("(value "))
            .unwrap_or("")
            .to_string()
    }

    /// Life by hand over a 12 by 10 grid whose border stays dead.
    fn reference(generation: usize) -> Vec<u8> {
        let (w, h) = (12usize, 10usize);
        let mut g = vec![0u8; w * h];
        for (r, c) in SEEDED {
            g[(r as usize - 1) * w + (c as usize - 1)] = 1;
        }
        for _ in 0..generation {
            let mut n = vec![0u8; w * h];
            for r in 1..h - 1 {
                for c in 1..w - 1 {
                    let mut sum = 0;
                    for dr in 0..3 {
                        for dc in 0..3 {
                            sum += g[(r + dr - 1) * w + (c + dc - 1)];
                        }
                    }
                    let me = g[r * w + c];
                    let others = sum - me;
                    n[r * w + c] = u8::from(others == 3 || (me == 1 && others == 2));
                }
            }
            g = n;
        }
        g
    }

    /// Every formula cell of the grid, its twins' among them. The grid is
    /// lent mutably since vla-lang 0.9.0, which makes the twins' cells
    /// first, so the test reads the machine's own field.
    fn formulas(c: &mut Cartridge) -> Vec<(usize, u32, u32, Content)> {
        let mut out = Vec::new();
        for (si, sheet) in c.machine.workbook().sheets.iter().enumerate() {
            for (&(row, col), cell) in &sheet.cells {
                if is_formula(&cell.content) {
                    out.push((si, row, col, cell.content.clone()));
                }
            }
        }
        out
    }

    #[test]
    fn the_catalogue_holds_every_id_the_engine_raises() {
        let ids = [
            ("cart-manifest-invalid", vec![("what", "x")]),
            ("cart-spec-unsupported", vec![("spec", "3")]),
            (
                "cart-screen-outside",
                vec![("target", "x"), ("window", "x")],
            ),
            ("cart-palette-invalid", vec![("what", "x")]),
            (
                "cart-device-cell-formula",
                vec![("target", "x"), ("cells", "x")],
            ),
            (
                "cart-device-cell-outside",
                vec![("target", "x"), ("sheet", "x"), ("layout", "x")],
            ),
            (
                "cart-formula-volatile",
                vec![("cell", "x"), ("function", "x")],
            ),
            ("cart-write-derived", vec![("target", "x"), ("cells", "x")]),
            ("cart-source-unexpanded", vec![("form", "x")]),
            ("cart-write-clock", vec![("target", "x"), ("what", "x")]),
        ];
        assert_eq!(catalogue().count(), ids.len(), "every entry is raised");
        for (id, slots) in &ids {
            let r = catalogue()
                .raise(id, slots)
                .expect("the id is the engine's");
            assert!(
                !r.text.contains("RaiseMsg"),
                "{id} fills every slot: {}",
                r.text
            );
            assert!(!r.text.contains('{'), "{id} leaves no slot: {}", r.text);
            assert_eq!(r.source, "Alonzo-Cart");
        }
        // An id the engine does not hold is the language's.
        assert_eq!(
            raise("grid-handle-unknown", &[("handle", "9")]).id,
            "grid-handle-unknown"
        );
        assert!(!raise("grid-handle-unknown", &[("handle", "9")])
            .text
            .contains("RaiseMsg"));
    }

    #[test]
    fn a_manifest_defect_is_refused_by_name() {
        let good = small(30);
        assert_eq!(id_of(load(&good)), "loaded");
        let cases: [(&str, &str, &str); 12] = [
            ("  (rate 30)\n", "", "has no (rate ...)"),
            ("(rate 30)", "(rate 121)", "where (rate ...)"),
            ("(rate 30)", "(rate 30) (rate 30)", "gives (rate ...) twice"),
            (
                "(screen plane 12 10)",
                "(screen plane 321 10)",
                "where (screen ...)",
            ),
            (
                "(screen plane 12 10)",
                "(screen grid 81 10)",
                "where (screen ...)",
            ),
            (
                "(screen plane 12 10)",
                "(screen photo 12 10)",
                "where (screen ...)",
            ),
            ("(seed 1)", "(seed 0)", "where (seed ...)"),
            ("(seed 1)", "(seed 2147483647)", "where (seed ...)"),
            ("(title \"Small\")", "(title Small)", "where (title ...)"),
            (
                "(seed 1)",
                "(seed 1) (colour 3)",
                "a directive this version does not know",
            ),
            (
                "(cartridge \"small\"",
                "(cartridge \"Small\"",
                "names the cartridge \"Small\"",
            ),
            ("(seed 1)", "(seed 1) (notes 3)", "where (notes ...)"),
        ];
        for (from, to, want) in cases {
            assert_eq!(
                good.matches(from).count(),
                1,
                "the anchor {from} is in the text once"
            );
            let text = text_of(load(&good.replacen(from, to, 1)));
            assert!(
                text.starts_with("cart-manifest-invalid"),
                "{from} -> {to}: {text}"
            );
            assert!(text.contains(want), "{from} -> {to}: {text}");
        }
        let no_form = text_of(load("; nothing but a comment\n"));
        assert!(no_form.starts_with("cart-manifest-invalid"), "{no_form}");
        let not_first = text_of(load(&format!("(sheet \"Screen\" visible)\n{good}")));
        assert!(not_first.contains("first form"), "{not_first}");
    }

    #[test]
    fn a_later_spec_is_refused_before_its_directives() {
        let text = small(30).replacen("(spec 2)", "(spec 4)\n  (layers 2)", 1);
        let r = load(&text).expect_err("a later page is refused");
        assert_eq!(r.refusal.id, "cart-spec-unsupported");
        assert_eq!(r.line, 2, "the spec's own line");
        assert!(r.refusal.text.contains("(spec 4)"), "{}", r.refusal.text);
        assert!(r.refusal.text.contains("(spec 3)"), "{}", r.refusal.text);
        // Version 3 adds no row and no directive: the earlier pages' and its
        // own load alike.
        for spec in ["(spec 1)", "(spec 3)"] {
            assert_eq!(
                id_of(load(&small(30).replacen("(spec 2)", spec, 1))),
                "loaded",
                "{spec}"
            );
        }
    }

    #[test]
    fn a_source_is_refused_before_its_manifest() {
        // A source opening on its include, as Appendix C's patch does, and
        // one defining its own macro after the manifest: the pass's to
        // expand, never the load's, each refused at the line of the form.
        let good = small(30);
        let opens = format!("(include \"../common.vla\")\n{good}");
        let r = load(&opens).expect_err("a source is refused");
        assert_eq!(r.refusal.id, "cart-source-unexpanded");
        assert_eq!(r.line, 1);
        assert!(
            r.refusal.text.contains("(include ...)"),
            "{}",
            r.refusal.text
        );
        let defines = format!("{good}(DEFMACRO (one a) (cell \"Screen\" a 1))\n");
        let r = load(&defines).expect_err("a source is refused");
        assert_eq!(r.refusal.id, "cart-source-unexpanded");
        assert!(
            r.refusal.text.contains("(defmacro ...)"),
            "{}",
            r.refusal.text
        );
        assert_eq!(r.line as usize, good.lines().count() + 1);
        // What the pass writes from a source is a cartridge, and loads.
        let source = format!("(defmacro (one a) (cell \"Screen\" a 1))\n{good}(one \"A1\")\n");
        let e = crate::pass::expand(&source, "small.source.vla", &[]).expect("expands");
        assert_eq!(id_of(load(&e.text)), "loaded");
    }

    #[test]
    fn the_device_checks_refuse_at_load() {
        let good = small(30);
        let cases: [(&str, &str, &str); 9] = [
            (
                "cart-screen-outside",
                "(cell \"Screen\" \"M1\" 1)\n",
                "Screen!M1",
            ),
            (
                "cart-device-cell-outside",
                "(cell \"Clock\" \"C1\" 1)\n",
                "Clock!C1",
            ),
            (
                "cart-device-cell-outside",
                "(cell \"Input\" \"C11\" 1)\n",
                "Input!C11",
            ),
            (
                "cart-device-cell-formula",
                "(formula \"Clock\" \"B1\" \"=1\")\n",
                "Clock!B1",
            ),
            (
                "cart-device-cell-formula",
                "(formula \"Input\" \"B5\" \"=1\")\n",
                "Input!B5",
            ),
            (
                "cart-formula-volatile",
                "(formula \"Seed\" \"A1\" \"=RAND()\")\n",
                "RAND",
            ),
            (
                "cart-formula-volatile",
                "(formula \"Seed\" \"A1\" \"=1+now()\")\n",
                "NOW",
            ),
            (
                "cart-device-cell-outside",
                "(cell \"Palette\" \"C1\" \"dead\")\n(cell \"Palette\" \"A17\" 16)\n",
                "Palette!A17",
            ),
            ("loaded", "(cell \"Screen\" \"L10\" 1)\n", ""),
        ];
        for (want, row, named) in cases {
            let text = text_of(load(&format!("{good}{row}")));
            assert!(text.starts_with(want), "{row}: {text}");
            assert!(text.contains(named), "{row}: {text}");
        }
        // The Palette: an index out of order, a colour that is no colour, a
        // formula allowed, and a plane cartridge with no Palette at all.
        let swapped = good.replacen(
            "(cell \"Palette\" \"A5\" 4)",
            "(cell \"Palette\" \"A5\" 7)",
            1,
        );
        let text = text_of(load(&swapped));
        assert!(
            text.contains("The Palette's A5 holds 7, where the index 4 belongs"),
            "{text}"
        );
        let blue = good.replacen("\"#0000AA\"", "\"blue\"", 1);
        let text = text_of(load(&blue));
        assert!(text.contains("The Palette's B3 holds \"blue\""), "{text}");
        let cycled = good.replacen(
            "(cell \"Palette\" \"B3\" \"#0000AA\")",
            "(formula \"Palette\" \"B3\" \"=\\\"#0000AA\\\"\")",
            1,
        );
        assert_eq!(id_of(load(&cycled)), "loaded");
        let grid = good.replacen("(screen plane 12 10)", "(screen grid 12 10)", 1);
        let bare = grid.replace(&palette(), "");
        assert_eq!(id_of(load(&bare)), "loaded", "grid mode needs no Palette");
        let emptied = good.replace(&palette(), "");
        let text = text_of(load(&emptied));
        assert!(
            text.contains("The Palette's A1 holds nothing, where the index 0 belongs"),
            "{text}"
        );
        let plane_bare = emptied.replace("(sheet \"Palette\" visible)\n", "");
        let text = text_of(load(&plane_bare));
        assert!(text.contains("holds no Palette sheet"), "{text}");
        // A Camera sheet frees the Screen's extent.
        let camera =
            format!("{good}(cell \"Camera\" \"A1\" \"row\")\n(cell \"Screen\" \"M1\" 1)\n");
        assert_eq!(id_of(load(&camera)), "loaded");
        // The line is the row's.
        let r = load(&format!("{good}(cell \"Clock\" \"C1\" 1)\n")).expect_err("refused");
        assert_eq!(r.line as usize, good.lines().count() + 1);
    }

    #[test]
    fn the_engine_makes_its_own_sheets() {
        let text = small(30);
        let c = load(&text).expect("loads");
        assert_eq!(cell_text(&c, "Clock", "B1"), "(cell \"Clock\" \"B1\" 0)");
        assert_eq!(cell_text(&c, "Clock", "B2"), "(cell \"Clock\" \"B2\" 30)");
        assert_eq!(cell_text(&c, "Clock", "B3"), "(cell \"Clock\" \"B3\" 1)");
        assert_eq!(
            cell_text(&c, "Clock", "A3"),
            "(cell \"Clock\" \"A3\" \"seed\")"
        );
        assert_eq!(
            cell_text(&c, "File", "B1"),
            "(cell \"File\" \"B1\" \"small.vla\")"
        );
        assert_eq!(
            cell_text(&c, "File", "B2"),
            format!("(cell \"File\" \"B2\" {})", text.len())
        );
        assert_eq!(
            cell_text(&c, "Input", "A18"),
            "(cell \"Input\" \"A18\" \"code\")"
        );
        assert_eq!(cell_text(&c, "Input", "E10"), "(cell \"Input\" \"E10\" 0)");
        assert_eq!(
            cell_text(&c, "Input", "B17"),
            "(cell \"Input\" \"B17\" \"\")"
        );
        // every sheet's name, its twins' among them, as the machine says it
        let names: Vec<&str> = (0..).map_while(|i| c.machine().sheet_name(i)).collect();
        assert_eq!(
            names,
            [
                "Screen",
                "Palette",
                "Seed",
                "Clock",
                "File",
                "Input",
                "Screen.last",
                "Palette.last",
                "Seed.last",
                "Clock.last",
                "File.last",
                "Input.last"
            ]
        );
        // The cartridge's own Input sheet is left as it wrote it.
        let own = load(&format!("{text}(cell \"Input\" \"A1\" \"jump\")\n")).expect("loads");
        assert_eq!(
            cell_text(&own, "Input", "A1"),
            "(cell \"Input\" \"A1\" \"jump\")"
        );
        assert!(cell_text(&own, "Input", "B1").is_empty(), "no cell made");
        // A seed the host chooses leaves Clock!B3 empty, and describe says so.
        let host = load(&text.replacen("(seed 1)", "(seed host)", 1)).expect("loads");
        assert!(cell_text(&host, "Clock", "B3").is_empty());
        assert!(host.describe().contains("(seed host)\n"));
        // A seed the rows wrote that is no seed is taken out, and out of the count.
        let odd = format!(
            "{}(cell \"Clock\" \"B3\" \"x\")\n",
            text.replacen("(seed 1)", "(seed host)", 1)
        );
        let odd = load(&odd).expect("loads");
        assert!(cell_text(&odd, "Clock", "B3").is_empty());
        assert_eq!(odd.machine().loaded().cells, host.machine().loaded().cells);
        // No name: the cartridge.
        let unnamed = Cartridge::load(&text, "", text.len()).expect("loads");
        assert_eq!(
            cell_text(&unnamed, "File", "B1"),
            "(cell \"File\" \"B1\" \"the cartridge\")"
        );
    }

    #[test]
    fn the_write_checks_come_before_the_machine() {
        let mut c = load(&small(30)).expect("loads");
        let cases: [(&str, &str); 10] = [
            (
                "(formula \"Clock\" \"B1\" \"=1\")",
                "cart-device-cell-formula",
            ),
            ("(derived \"Input\" \"B5\" 1)", "cart-write-derived"),
            ("(derived \"Clock\" \"A1\" 1)", "cart-write-derived"),
            ("(cell \"Input\" \"F1\" 1)", "cart-device-cell-outside"),
            ("(cell \"Screen\" \"A11\" 1)", "cart-screen-outside"),
            ("(cell \"Nowhere\" \"A1\" 1)", "grid-sheet-unknown"),
            ("(cell \"Screen.last\" \"B1\" 1)", "grid-write-last"),
            ("(derived \"Screen\" \"B2\" 1)", "grid-write-derived"),
            ("(colour \"Screen\" \"B2\" 1)", "grid-row-unknown"),
            // The machine refuses line 1, the engine line 2: the engine's checks run first.
            (
                "(cell \"Nowhere\" \"A1\" 1)\n(formula \"Clock\" \"B2\" \"=1\")",
                "cart-device-cell-formula",
            ),
        ];
        for (rows, want) in cases {
            let r = c.write(rows).expect_err(rows);
            assert_eq!(r.refusal.id, want, "{rows}: {}", r.refusal.text);
        }
        let derived = c
            .write("(derived \"Input\" \"B5\" 1)")
            .expect_err("refused");
        assert!(
            derived.refusal.text.contains("Input!B5"),
            "{}",
            derived.refusal.text
        );
        // What lands: a person's value into a host cell, a value over a formula,
        // a derived value into a value cell of the cartridge's own sheet.
        assert_eq!(c.write("(cell \"Input\" \"B5\" 1)"), Ok(1));
        assert_eq!(c.write("(cell \"Screen\" \"B2\" 1)"), Ok(1));
        assert_eq!(c.write("(derived \"Seed\" \"B2\" 1)"), Ok(1));
        // A write during a yielded step is the machine's, whatever it holds.
        let s = c.step(10);
        assert!(!s.done);
        let r = c
            .write("(formula \"Clock\" \"B1\" \"=1\")")
            .expect_err("refused");
        assert_eq!(r.refusal.id, "grid-write-during-step");
    }

    /// ENGINE.3, decision 2: a person's write into the Clock. The frame is
    /// refused, the rate and the seed are held to their ranges, a range is
    /// judged cell by cell from the frame, the labels stay a person's, a
    /// refused write changes nothing, and the step's own write of the frame
    /// goes on as before.
    #[test]
    fn the_clock_s_cells_are_held_at_a_write() {
        let mut c = load(&small(30)).expect("loads");
        let refused = [
            ("(cell \"Clock\" \"B1\" 5)", "Clock!B1 is the Clock's frame"),
            ("(cell \"Clock\" \"B2\" 121)", "and 121 is not one"),
            ("(cell \"Clock\" \"B2\" -1)", "and -1 is not one"),
            ("(cell \"Clock\" \"B2\" 2.5)", "and 2.5 is not one"),
            (
                "(cell \"Clock\" \"B2\" \"fast\")",
                "and \"fast\" is not one",
            ),
            ("(cell \"Clock\" \"B2\" true)", "Clock's rate"),
            (
                "(cell \"Clock\" \"B3\" 0)",
                "Clock!B3 holds the Clock's seed",
            ),
            (
                "(cell \"Clock\" \"B3\" 2147483647)",
                "and 2147483647 is not one",
            ),
            ("(cell \"Clock\" \"B3\" \"x\")", "and \"x\" is not one"),
            (
                "(cell \"Clock\" \"B1:B3\" 9)",
                "Clock!B1 is the Clock's frame",
            ),
            (
                "(cell \"clock\" \"A2:B2\" 300)",
                "clock!B2 holds the Clock's rate",
            ),
            (
                "(cell \"Clock\" \"B2\" 10)\n(cell \"Clock\" \"B1\" 2)",
                "Clock!B1 is the Clock's frame",
            ),
        ];
        for (rows, want) in refused {
            let r = c.write(rows).expect_err(rows);
            assert_eq!(
                r.refusal.id, "cart-write-clock",
                "{rows}: {}",
                r.refusal.text
            );
            assert!(r.refusal.text.contains(want), "{rows}: {}", r.refusal.text);
            assert!(
                r.refusal.text.ends_with("(SPEC.md section 3.5)."),
                "{}",
                r.refusal.text
            );
        }
        // Nothing a refused write held landed, the rate of the last case among it.
        assert_eq!(cell_text(&c, "Clock", "B2"), "(cell \"Clock\" \"B2\" 30)");
        // What lands: a rate of 0, 1 and 120, a seed at both its ends, both at
        // once over a range the frame is not in, and a label.
        for (rows, n) in [
            ("(cell \"Clock\" \"B2\" 0)", 1),
            ("(cell \"Clock\" \"B2\" 1)", 1),
            ("(cell \"Clock\" \"B2\" 120)", 1),
            ("(cell \"Clock\" \"B3\" 1)", 0), // the seed it holds: nothing changed
            ("(cell \"Clock\" \"B3\" 2147483646)", 1),
            ("(cell \"Clock\" \"B3\" 1)", 1),
            ("(cell \"Clock\" \"B2:B3\" 5)", 2),
            ("(cell \"Clock\" \"A1\" \"tick\")", 1),
        ] {
            assert_eq!(c.write(rows), Ok(n), "{rows}");
        }
        assert_eq!(cell_text(&c, "Clock", "B2"), "(cell \"Clock\" \"B2\" 5)");
        assert_eq!(cell_text(&c, "Clock", "B3"), "(cell \"Clock\" \"B3\" 5)");
        // The step writes the frame as before, past the person's check.
        for frame in 1..=2u64 {
            assert!(c.step(0).done);
            assert_eq!(
                cell_text(&c, "Clock", "B1"),
                format!("(cell \"Clock\" \"B1\" {frame})")
            );
        }
    }

    #[test]
    fn the_clock_is_written_once_a_frame() {
        let mut c = load(&small(30)).expect("loads");
        let mut calls = 0;
        for frame in 1..=3u64 {
            loop {
                calls += 1;
                let s = c.step(7);
                assert_eq!(s.frame, frame);
                assert_eq!(
                    cell_text(&c, "Clock", "B1"),
                    format!("(cell \"Clock\" \"B1\" {frame})")
                );
                if s.done {
                    break;
                }
            }
        }
        assert_eq!(
            calls,
            3 * 80_usize.div_ceil(7),
            "eighty formula cells in sevens"
        );
    }

    #[test]
    fn a_small_life_is_the_reference_frame_by_frame() {
        let mut c = load(&small(30)).expect("loads");
        assert_eq!(
            plane(&c),
            vec![0u8; 120],
            "nothing is computed before the first step"
        );
        for frame in 1..=12usize {
            let before = formulas(&mut c);
            let s = c.step(0);
            assert!(s.done && s.frame == frame as u64 && s.of == 80, "{s:?}");
            assert_eq!(plane(&c), reference(frame - 1), "frame {frame}");
            assert_eq!(
                formulas(&mut c),
                before,
                "frame {frame} wrote no formula (AD-7)"
            );
        }
        // A budget never changes a value.
        let mut chunked = load(&small(30)).expect("loads");
        let mut whole = load(&small(30)).expect("loads");
        for _ in 0..5 {
            while !chunked.step(3).done {}
            whole.step(0);
            assert_eq!(plane(&chunked), plane(&whole));
        }
    }

    #[test]
    fn a_save_resumes_at_its_frame() {
        let mut original = load(&small(30)).expect("loads");
        for _ in 0..3 {
            original.step(0);
        }
        // A save: the manifest, then every sheet that is no twin viewed whole.
        let mut save = manifest(30, "");
        let names: Vec<String> = (0..original.machine().sheets())
            .filter_map(|i| original.machine().sheet_name(i).map(str::to_string))
            .collect();
        for name in &names {
            match original.view("grid", name, None) {
                Ok(Viewed::Text(t)) => save.push_str(&t),
                other => panic!("{name}: {other:?}"),
            }
        }
        let mut resumed = Cartridge::load(&save, "small-3.vla", save.len()).expect("a save loads");
        assert_eq!(resumed.machine().frame(), 3);
        assert_eq!(plane(&resumed), plane(&original), "the save holds frame 3");
        let a = original.step(0);
        let b = resumed.step(0);
        assert_eq!((a.frame, b.frame), (4, 4));
        assert_eq!(plane(&resumed), plane(&original), "frame 4 from the save");
        assert_eq!(plane(&resumed), reference(3));
    }

    /// Since `vla-lang` 0.9.2 the census follows the budget (`KERNEL.30`,
    /// laid here): the small Life is one shape in one run of its 80 cells,
    /// the Seed, the Clock and the Screen's twin each followed to it.
    #[test]
    fn describe_prints_the_manifest_the_devices_and_the_budget() {
        let c = load(&small(30)).expect("loads");
        let d = c.describe();
        assert_eq!(
            d,
            "(spec 2)\n(title \"Small\")\n(rate 30)\n(screen plane 12 10)\n(seed 1)\n\
             (device \"Screen\" \"A1:L10\" effect)\n(device \"Palette\" \"A1:C16\" effect)\n\
             (device \"Input\" \"A1:E18\" input)\n(device \"Clock\" \"A1:B3\" input)\n\
             (device \"File\" \"A1:B3\" effect)\n(budget 30 80 2400 2000000)\n\
             (plan (shapes 1) (texts 1) (formulas 80) (levels 1) (runs 1) (lanes 80) (alone 0) \
             (every-frame 0) (cycles 0))\n\
             (readers \"Seed\" 1)\n(readers \"Clock\" 1)\n(readers \"Screen.last\" 1)\n\
             (shape 0 \"Screen\" \"B2\" \"=IF(Clock!R1C2=1,Seed!RC,IF(OR(SUM(Screen.last!R[-1]C[-1]:R[1]C[1])\
             -Screen.last!RC=3,AND(Screen.last!RC=1,SUM(Screen.last!R[-1]C[-1]:R[1]C[1])-Screen.last!RC=2)),1,0))\" \
             (cells 80) (levels 0 0 1 80) (runs 1 80 80 80) (alone 0) (reads slot array lookup once start))\n"
        );
        assert_eq!(c.row(4), "(cartridge 4 \"Small\" plane 12 10 30)");
    }

    #[test]
    fn life_loads_and_describes_itself() {
        let c = Cartridge::load(LIFE, "life.vla", LIFE.len()).expect("Life loads");
        assert_eq!(c.row(1), "(cartridge 1 \"Life\" plane 320 200 30)");
        let d = c.describe();
        for want in [
            "(spec 2)\n",
            "(title \"Life\")\n",
            "(seed 1)\n",
            "(licence \"0BSD\")\n",
            "(device \"Screen\" \"A1:LH200\" effect)\n",
            "(device \"Palette\" \"A1:C16\" effect)\n",
            "(device \"Input\" \"A1:E18\" input)\n",
            "(device \"Clock\" \"A1:B3\" input)\n",
            "(device \"File\" \"A1:B3\" effect)\n",
            "(budget 30 62964 1888920 2000000)\n",
            // The census (KERNEL.30, laid here): one shape, one level, one
            // run of every cell, its twin read as an array and its Clock
            // once a run or at the frame's start.
            "(plan (shapes 1) (texts 1) (formulas 62964) (levels 1) (runs 1) (lanes 62964) \
             (alone 0) (every-frame 0) (cycles 0))\n",
            "(readers \"Clock\" 2)\n(readers \"Screen.last\" 1)\n",
            " (cells 62964) (levels 0 0 1 62964) (runs 1 62964 62964 62964) (alone 0) \
             (reads slot array once start))\n",
        ] {
            assert!(d.contains(want), "describe holds {want}: {d}");
        }
        assert!(
            !d.contains("(device \"Write\""),
            "Life has no Write sheet: {d}"
        );
    }

    /// Every committed cartridge's `describe`, its manifest, its devices,
    /// its budget and its census (`KERNEL.30`, laid here), held to a golden,
    /// `engine/testdata/describe/<name>.vla`, its comment lines aside, so that
    /// a change of a cartridge's plan, made by the cartridge or by the
    /// language, shows as a diff. `ALONZO_BLESS=1 cargo test describe` writes
    /// the goldens again, for a change made on purpose and read before it is
    /// committed.
    #[test]
    fn every_cartridge_describes_itself_as_its_golden() {
        let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR"));
        let goldens = root.join("testdata/describe");
        let bless = std::env::var_os("ALONZO_BLESS").is_some();
        let mut folders: Vec<std::path::PathBuf> = std::fs::read_dir(root.join("../cartridges"))
            .expect("cartridges/")
            .filter_map(|e| e.ok().map(|e| e.path()))
            .filter(|p| p.is_dir())
            .collect();
        folders.sort();
        let read = |p: &std::path::Path| {
            std::fs::read_to_string(p).unwrap_or_else(|e| panic!("{}: {e}", p.display()))
        };
        let mut described = Vec::new();
        for dir in folders {
            let name = dir
                .file_name()
                .and_then(|n| n.to_str())
                .expect("a folder's name")
                .to_string();
            let text = read(&dir.join(format!("{name}.vla")));
            let c = Cartridge::load(&text, &format!("{name}.vla"), text.len())
                .unwrap_or_else(|e| panic!("{name} loads: {}", e.refusal.text));
            let d = c.describe();
            let path = goldens.join(format!("{name}.vla"));
            if bless {
                std::fs::create_dir_all(&goldens).expect("the goldens' folder");
                let head = format!(
                    "; The engine's describe of cartridges/{name}/{name}.vla: the manifest, the devices, the\n\
                     ; budget and the machine's census (KERNEL.30). ALONZO_BLESS=1 cargo test describe\n\
                     ; writes it again.\n"
                );
                std::fs::write(&path, head + &d).expect("a golden written");
            } else {
                let golden = read(&path).replace("\r\n", "\n");
                let body: String = golden
                    .lines()
                    .filter(|l| !l.starts_with(';'))
                    .map(|l| format!("{l}\n"))
                    .collect();
                assert!(
                    d == body,
                    "{name}'s describe is not its golden, {}; if the change is meant, \
                     ALONZO_BLESS=1 cargo test describe writes it again:\n{d}",
                    path.display()
                );
            }
            described.push(name);
        }
        assert_eq!(
            described,
            [
                "gridcard",
                "gun",
                "inputcard",
                "kairos",
                "life",
                "sand",
                "soundcard",
                "testcard"
            ],
            "the cartridges committed under cartridges/"
        );
    }

    // ---- ENGINE.3: the input card ----

    /// The input card (ENGINE.3): the Input and Clock devices drawn.
    const INPUTCARD: &str = include_str!("../../cartridges/inputcard/inputcard.vla");

    /// The Input sheet's eighteen rows as the host writes them before a step:
    /// the held buttons as (button, player) from 0, the pointer's Screen cell,
    /// its three buttons, the wheel's notches, and the last key and its code.
    fn input_rows(
        held: &[(u32, u32)],
        pointer: (u32, u32),
        buttons: [u32; 3],
        notches: i32,
        key: (&str, &str),
    ) -> String {
        let mut out = String::new();
        for b in 0..10u32 {
            for p in 0..4u32 {
                let v = u32::from(held.contains(&(b, p)));
                out.push_str(&format!(
                    "(cell \"Input\" \"{}\" {v})\n",
                    address(b + 1, p + 2)
                ));
            }
        }
        out.push_str(&format!(
            "(cell \"Input\" \"B11\" {})\n(cell \"Input\" \"B12\" {})\n",
            pointer.0, pointer.1
        ));
        for (i, v) in buttons.iter().enumerate() {
            out.push_str(&format!("(cell \"Input\" \"B{}\" {v})\n", 13 + i));
        }
        out.push_str(&format!(
            "(cell \"Input\" \"B16\" {notches})\n(cell \"Input\" \"B17\" {})\n(cell \"Input\" \"B18\" {})\n",
            quoted(key.0),
            quoted(key.1)
        ));
        out
    }

    /// A cell's value as its record spells it, the row's last field.
    fn value_of(c: &Cartridge, sheet: &str, addr: &str) -> String {
        let row = cell_text(c, sheet, addr);
        let open = row
            .find(&format!("\"{addr}\" "))
            .map(|i| i + addr.len() + 3);
        open.map(|i| row[i..row.len() - 1].to_string())
            .unwrap_or_default()
    }

    /// Twelve frames of the host's writes, the Write sheet's row carried as
    /// the host carries it, and every count held to the log: a press on its
    /// rising edge, a second player's column, a click and its frame, the
    /// wheel and the Camera it pans, the keys, the dice from the seed, and the
    /// cursor drawn at the pointer's Screen cell through the Camera's window.
    #[test]
    fn the_input_card_counts_what_it_is_given() {
        let mut c =
            Cartridge::load(INPUTCARD, "inputcard.vla", INPUTCARD.len()).expect("the card loads");
        assert!(
            cell_text(&c, "Clock", "B3").is_empty(),
            "the seed is the host's"
        );
        assert_eq!(c.write("(cell \"Clock\" \"B3\" 12345)"), Ok(1));
        let mut pending: Option<String> = None;
        for frame in 1..=12u32 {
            if let Some(row) = pending.take() {
                assert_eq!(c.write(&row), Ok(1), "{row}");
            }
            let held: &[(u32, u32)] = match frame {
                3..=5 => &[(3, 0)],     // right, player 1
                7 => &[(4, 0), (0, 1)], // a, player 1; up, player 2
                _ => &[],
            };
            let pointer = if frame >= 9 { (8, 4) } else { (0, 0) };
            let buttons = if frame == 9 || frame == 10 {
                [1, 0, 0]
            } else {
                [0, 0, 0]
            };
            let notches = if frame == 11 { 3 } else { 0 };
            let key = match frame {
                7 => ("i", "KeyI"),
                8 => ("q", "KeyQ"),
                _ => ("", ""),
            };
            c.write(&input_rows(held, pointer, buttons, notches, key))
                .expect("the Input rows");
            let before = formulas(&mut c);
            assert!(c.step(0).done);
            assert_eq!(
                formulas(&mut c),
                before,
                "frame {frame} wrote no formula (AD-7)"
            );
            // The Write sheet's row, as the host reads it after the step.
            if value_of(&c, "Write", "B2") == "\"B20\"" {
                pending = Some(format!(
                    "(derived \"Tally\" \"B20\" {})",
                    value_of(&c, "Write", "C2")
                ));
            }
        }
        let mut dice: u64 = 12345;
        for _ in 2..=12 {
            dice = dice * 16807 % 2_147_483_647;
        }
        for (addr, want) in [
            ("B1", "0".to_string()),
            ("B4", "1".to_string()),
            ("B5", "1".to_string()),
            ("C1", "1".to_string()),
            ("B11", "8".to_string()),
            ("B12", "4".to_string()),
            ("B13", "1".to_string()),
            ("B14", "0".to_string()),
            ("B16", "3".to_string()),
            ("B17", "2".to_string()),
            ("B18", "\"KeyQ\"".to_string()),
            ("B19", dice.to_string()),
            ("B20", "9".to_string()),
        ] {
            assert_eq!(value_of(&c, "Tally", addr), want, "Tally!{addr}");
        }
        assert_eq!(
            value_of(&c, "Camera", "B2"),
            "4",
            "three notches pan to column 4"
        );
        let window = match c.view("plane", "Screen", Some("D1:AQ24")) {
            Ok(Viewed::Bytes(b)) => b,
            other => panic!("the plane: {other:?}"),
        };
        let at = |row: usize, col: usize| window[(row - 1) * 40 + (col - 1)];
        assert_eq!(
            at(4, 5),
            15,
            "the cursor at the Screen's H4, the window's fifth column"
        );
        assert_eq!(at(6, 6), 2, "right, pressed once and let go: colour 1 + 1");
        assert_eq!(
            [at(20, 6), at(20, 7), at(20, 8), at(20, 9)],
            [1, 1, 11, 11],
            "frame 12's four low bits, 0011 from bit 0"
        );
    }

    /// The Write sheet's rows as the host reads them after a step (SPEC.md
    /// section 3.9, `web/host.js`'s `_readWrite`): from row 2, a sheet in
    /// column A, an address in B and a value in C, each row the next frame's
    /// derived write, spelled as the record spells its values. A row without
    /// a sheet, an address or a value, or whose value is an error, writes
    /// nothing; a cartridge without a Write sheet has none.
    fn derived_rows(c: &Cartridge) -> Vec<String> {
        let Ok(Viewed::Text(record)) = c.view("grid", "Write", None) else {
            return Vec::new();
        };
        let mut cells = std::collections::BTreeMap::new();
        for line in record.lines() {
            let Some(rest) = line
                .strip_prefix("(cell \"Write\" \"")
                .or_else(|| line.strip_prefix("(value \"Write\" \""))
            else {
                continue;
            };
            let Some((addr, value)) = rest.split_once("\" ") else {
                continue;
            };
            let (col, row) = addr.split_at(1);
            if let Ok(row) = row.parse::<u32>() {
                if row >= 2 {
                    let value = value.strip_suffix(')').unwrap_or(value).to_string();
                    cells.insert((row, col.to_string()), value);
                }
            }
        }
        let rows: std::collections::BTreeSet<u32> = cells.keys().map(|(r, _)| *r).collect();
        let text = |s: &&String| s.starts_with('"') && s.as_str() != "\"\"";
        rows.into_iter()
            .filter_map(|r| {
                let at = |col: &str| cells.get(&(r, col.to_string()));
                let (sheet, addr, value) = (at("A")?, at("B")?, at("C")?);
                (text(&sheet) && text(&addr) && !value.starts_with('('))
                    .then(|| format!("(derived {sheet} {addr} {value})"))
            })
            .collect()
    }

    /// SHA-256 (FIPS 180-4) in upper-case hex: a replay names the cartridge it
    /// was recorded from by the digest of the cartridge's text with LF line
    /// ends (SPEC.md section 7.6), as the page's host computes it for its
    /// player and `tools/check_cartridge.ps1` for the files. Written here in
    /// the tests alone: the engine crate depends on the language and nothing
    /// else (AD-5), and the module itself digests nothing.
    fn sha256_hex(bytes: &[u8]) -> String {
        const K: [u32; 64] = [
            0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4,
            0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe,
            0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f,
            0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
            0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc,
            0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
            0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116,
            0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
            0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7,
            0xc67178f2,
        ];
        let mut h: [u32; 8] = [
            0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab,
            0x5be0cd19,
        ];
        // The message padded: a 1 bit, zeros to 56 bytes in the last block,
        // then the length in bits, big-endian.
        let mut message = bytes.to_vec();
        let length = (bytes.len() as u64).wrapping_mul(8);
        message.push(0x80);
        while message.len() % 64 != 56 {
            message.push(0);
        }
        message.extend_from_slice(&length.to_be_bytes());
        for block in message.chunks(64) {
            let mut w = [0u32; 64];
            for (word, four) in w.iter_mut().zip(block.chunks(4)) {
                *word = u32::from_be_bytes([four[0], four[1], four[2], four[3]]);
            }
            for i in 16..64 {
                let s0 = w[i - 15].rotate_right(7) ^ w[i - 15].rotate_right(18) ^ (w[i - 15] >> 3);
                let s1 = w[i - 2].rotate_right(17) ^ w[i - 2].rotate_right(19) ^ (w[i - 2] >> 10);
                w[i] = w[i - 16]
                    .wrapping_add(s0)
                    .wrapping_add(w[i - 7])
                    .wrapping_add(s1);
            }
            // The working variables a to h as one array, v[0] to v[7].
            let mut v = h;
            for (k, wi) in K.iter().zip(w.iter()) {
                let s1 = v[4].rotate_right(6) ^ v[4].rotate_right(11) ^ v[4].rotate_right(25);
                let ch = (v[4] & v[5]) ^ (!v[4] & v[6]);
                let t1 = v[7]
                    .wrapping_add(s1)
                    .wrapping_add(ch)
                    .wrapping_add(*k)
                    .wrapping_add(*wi);
                let s0 = v[0].rotate_right(2) ^ v[0].rotate_right(13) ^ v[0].rotate_right(22);
                let maj = (v[0] & v[1]) ^ (v[0] & v[2]) ^ (v[1] & v[2]);
                let t2 = s0.wrapping_add(maj);
                v = [
                    t1.wrapping_add(t2),
                    v[0],
                    v[1],
                    v[2],
                    v[3].wrapping_add(t1),
                    v[4],
                    v[5],
                    v[6],
                ];
            }
            for (x, y) in h.iter_mut().zip(v) {
                *x = x.wrapping_add(y);
            }
        }
        h.iter().map(|x| format!("{x:08X}")).collect()
    }

    /// The digest a replay names its cartridge by, held to FIPS 180-2's
    /// vectors, the five the page's own SHA-256 is held to by the loop
    /// oracle's replay case.
    #[test]
    fn the_replay_s_digest_is_sha_256() {
        let a_million = "a".repeat(1_000_000);
        let vectors = [
            ("", "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855"),
            ("abc", "BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD"),
            (
                "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
                "248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1",
            ),
            (
                "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu",
                "CF5B16A778AF8380036CE59E7B0492370B249B11E8F07A51AFAC45037AFEE9D1",
            ),
            (
                a_million.as_str(),
                "CDC76E5C9914FB9281A1C7E284D73E67F1809A48A497200E046D39CCC7112CD0",
            ),
        ];
        for (text, want) in vectors {
            assert_eq!(sha256_hex(text.as_bytes()), want, "{} bytes", text.len());
        }
    }

    /// One committed replay played as SPEC.md section 7.6 plays one, by this
    /// test and not by the host: read with the language's reader, its
    /// header's digest held to the cartridge's text with LF line ends, so
    /// that it plays only on the file it was recorded from, as the page's
    /// player refuses any other; the cartridge loaded, the header's seed
    /// written when the manifest asks the host for one and else its
    /// manifest's, then for every frame the derived
    /// writes the last frame's Write sheet left, each its own write, the
    /// frame's rows, spelled back by the language's printer, as one write,
    /// and the step; its end the golden beside it, its window's record byte
    /// for byte. After each step `held` is given the cartridge, the frame
    /// and the frame's rows, so that a cartridge with a rule written by hand
    /// holds every frame to it (Sand's, CART.2's second slice).
    fn play_to_golden(
        name: &str,
        cart: &str,
        replay: &str,
        golden: &str,
        held: &mut dyn FnMut(&Cartridge, u32, &[Form]),
    ) {
        let forms = read_forms(replay).unwrap_or_else(|e| panic!("{name}'s replay reads: {e:?}"));
        let items = |f: &Form| match f {
            Form::List(l) => l.items.clone(),
            other => panic!("{name}: a list: {other:?}"),
        };
        let seed = items(&forms[0])
            .iter()
            .find_map(|d| match d {
                Form::List(l) => match l.items.as_slice() {
                    [Form::Sym(k), Form::Sym(n)] if k == "seed" => Some(n.clone()),
                    _ => None,
                },
                _ => None,
            })
            .unwrap_or_else(|| panic!("{name}: the header's seed"));
        // The header's digest, (cartridge "<SHA-256>"), and the cartridge's own.
        let digest = items(&forms[0])
            .iter()
            .find_map(|d| match d {
                Form::List(l) => match l.items.as_slice() {
                    [Form::Sym(k), Form::Str(hex)] if k == "cartridge" => Some(hex.clone()),
                    _ => None,
                },
                _ => None,
            })
            .unwrap_or_else(|| panic!("{name}: the header's cartridge digest"));
        let measured = sha256_hex(cart.replace("\r\n", "\n").as_bytes());
        assert_eq!(
            digest, measured,
            "{name}: the replay was recorded from the cartridge whose SHA-256 is {digest}, and {name}.vla's is {measured}: a replay plays only on the file it was recorded from (SPEC.md section 7.6)"
        );
        // Each frame one form, (frame n row ...), its rows the frame's one write.
        let frames: Vec<(u32, Vec<Form>)> = forms[1..]
            .iter()
            .map(|f| match items(f).as_slice() {
                [Form::Sym(head), Form::Sym(n), rows @ ..] if head == "frame" => {
                    (n.parse().expect("a frame's number"), rows.to_vec())
                }
                other => panic!("{name}: a frame: {other:?}"),
            })
            .collect();
        let last = frames.last().expect("a frame").0;
        let mut c = Cartridge::load(cart, &format!("{name}.vla"), cart.len())
            .unwrap_or_else(|e| panic!("{name} loads: {}", e.refusal.text));
        if c.describe().contains("(seed host)\n") {
            assert_eq!(c.write(&format!("(cell \"Clock\" \"B3\" {seed})")), Ok(1));
        } else {
            assert!(
                c.describe().contains(&format!("(seed {seed})\n")),
                "{name}: the replay's seed {seed} is its manifest's"
            );
        }
        let mut written = frames.iter().peekable();
        let mut pending: Vec<String> = Vec::new();
        for frame in 1..=last {
            for row in pending.drain(..) {
                c.write(&row)
                    .unwrap_or_else(|e| panic!("{name}, frame {frame}: {row}: {e:?}"));
            }
            let rows: &[Form] = match written.next_if(|(n, _)| *n == frame) {
                Some((_, rows)) => rows,
                None => &[],
            };
            if !rows.is_empty() {
                let text: Vec<String> = rows.iter().map(write_datum).collect();
                c.write(&text.join("\n")).unwrap_or_else(|e| {
                    panic!("{name}, frame {frame}: the rows, which landed when they were recorded: {e:?}")
                });
            }
            assert!(c.step(0).done, "{name}, frame {frame}");
            held(&c, frame, rows);
            pending = derived_rows(&c);
        }
        assert!(
            written.next().is_none(),
            "{name}: every frame of the replay played"
        );
        let golden = golden.replace("\r\n", "\n");
        let (_, body) = golden.split_once('\n').expect("the licence line");
        let (sheet, window) = body
            .lines()
            .find_map(|l| l.strip_prefix("(window \""))
            .and_then(|s| s.strip_suffix("\")"))
            .and_then(|s| s.split_once("\" \""))
            .unwrap_or_else(|| panic!("{name}: the golden's window row"));
        match c.view("grid", sheet, Some(window)) {
            Ok(Viewed::Text(record)) => {
                assert_eq!(record, body, "{name}: the replay ends in its golden")
            }
            other => panic!("{name}: the {sheet}'s record: {other:?}"),
        }
    }

    /// Every committed replay (ENGINE.3's second slice, made general by
    /// ENGINE.4's): each folder of `cartridges/` holding `<name>.replay.vla`
    /// played to `<name>.golden.vla` beside it, the files read as they stand
    /// in the tree: the input card's, Sand's and the sound card's. Sand's
    /// holds its Screen to the hand-written sand at every frame (CART.2's
    /// second slice), as the page's replay case holds it to the page's.
    #[test]
    fn every_committed_replay_plays_to_its_golden() {
        let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../cartridges");
        let mut folders: Vec<std::path::PathBuf> = std::fs::read_dir(&root)
            .expect("cartridges/")
            .filter_map(|e| e.ok().map(|e| e.path()))
            .filter(|p| p.is_dir())
            .collect();
        folders.sort();
        let read = |p: std::path::PathBuf| {
            std::fs::read_to_string(&p).unwrap_or_else(|e| panic!("{}: {e}", p.display()))
        };
        let mut played = Vec::new();
        for dir in folders {
            let name = dir
                .file_name()
                .and_then(|n| n.to_str())
                .expect("a folder's name")
                .to_string();
            let replay = dir.join(format!("{name}.replay.vla"));
            if !replay.exists() {
                continue;
            }
            let cart = read(dir.join(format!("{name}.vla")));
            let golden = read(dir.join(format!("{name}.golden.vla")));
            let mut hand = SandHand::default();
            let mut held = |c: &Cartridge, frame: u32, rows: &[Form]| {
                if name == "sand" {
                    hand.holds(c, frame, rows);
                }
            };
            play_to_golden(&name, &cart, &read(replay), &golden, &mut held);
            if name == "sand" {
                assert!(
                    hand.painted > 0,
                    "Sand's replay paints, and its frames are held to the hand-written sand's brush"
                );
            }
            played.push(name);
        }
        assert_eq!(
            played,
            ["inputcard", "sand", "soundcard"],
            "the replays committed under cartridges/"
        );
    }

    // ---- CART.1: the gun, the benchmark's second fixture ----

    /// Gosper's glider gun (CART.1): its pattern a Seed sheet the first frame reads.
    const GUN: &str = include_str!("../../cartridges/gun/gun.vla");

    /// A cartridge's Screen whole, 320 by 200, as the plane reads it.
    fn screen(c: &Cartridge) -> Vec<u8> {
        match c.view("plane", "Screen", Some("A1:LH200")) {
            Ok(Viewed::Bytes(b)) => b,
            other => panic!("the plane: {other:?}"),
        }
    }

    /// The gun's Seed read off the cartridge's rows, `(cell "Seed" "J14" 1)`,
    /// as a plane of 320 by 200, and not off the engine's grid.
    fn gun_seed() -> Vec<u8> {
        let mut g = vec![0u8; 320 * 200];
        for line in GUN.lines() {
            let Some(rest) = line.trim().strip_prefix("(cell \"Seed\" \"") else {
                continue;
            };
            let (addr, value) = rest.split_once('"').expect("a Seed row's address");
            assert_eq!(value.trim(), "1)", "a Seed row holds 1: {line}");
            let a = vla_lang::sheet::parse_a1_range(addr).expect("a Seed row's address");
            g[(a.top as usize - 1) * 320 + (a.left as usize - 1)] = 1;
        }
        g
    }

    /// One generation of Life by hand over a plane of 320 by 200, the border dead.
    fn next_generation(g: &[u8]) -> Vec<u8> {
        let w = 320usize;
        let mut n = vec![0u8; g.len()];
        for r in 1..199 {
            for c in 1..w - 1 {
                let i = r * w + c;
                let mut others = 0;
                for j in [
                    i - w - 1,
                    i - w,
                    i - w + 1,
                    i - 1,
                    i + 1,
                    i + w - 1,
                    i + w,
                    i + w + 1,
                ] {
                    others += g[j];
                }
                n[i] = u8::from(others == 3 || (g[i] == 1 && others == 2));
            }
        }
        n
    }

    /// The text of the Screen's one formula row of a cartridge.
    fn screen_formula(text: &str) -> &str {
        let line = text
            .lines()
            .find(|l| l.starts_with("(formula \"Screen\" \"B2:LG199\" "))
            .expect("the Screen's formula row");
        line.trim_end()
    }

    #[test]
    fn the_gun_s_first_frame_is_its_seed_and_its_second_the_rule() {
        let mut c = Cartridge::load(GUN, "gun.vla", GUN.len()).expect("the gun loads");
        assert_eq!(
            c.row(1),
            "(cartridge 1 \"Gosper's glider gun\" plane 320 200 30)"
        );
        assert_eq!(
            c.machine().formulas(),
            (62_964, 1),
            "the rule is one shape over the interior"
        );
        let seed = gun_seed();
        assert_eq!(
            seed.iter().filter(|b| **b == 1).count(),
            36,
            "the gun's 36 cells"
        );
        assert_eq!(c.step(0).row(), "(step 1 62964 62964 done)");
        assert_eq!(screen(&c), seed, "frame 1 is the Seed");
        c.step(0);
        assert_eq!(
            screen(&c),
            next_generation(&seed),
            "frame 2 is the Seed's first generation"
        );
    }

    #[test]
    fn the_two_fixtures_differ_only_in_their_first_frame() {
        // Life's rule word for word after the first frame's branch, so that the
        // floors of the soup and of the gun time the same formula (CART.1).
        let life = screen_formula(LIFE);
        let gun = screen_formula(GUN);
        let tail = ",IF(OR(SUM(Screen.last!A1:C3)-Screen.last!B2=3,AND(Screen.last!B2=1,SUM(Screen.last!A1:C3)-Screen.last!B2=2)),1,0))\")";
        assert!(life.ends_with(tail), "Life's rule: {life}");
        assert!(gun.ends_with(tail), "the gun's rule: {gun}");
        assert!(gun.contains("=IF(Clock!$B$1=1,Seed!B2,IF(OR("));
        assert_eq!(gun, format!("(formula \"Screen\" \"B2:LG199\" \"{RULE}\")"));
    }

    // ---- ENGINE.2: the plane is the record of the same window, byte for value ----

    /// A value of the record as `SPEC.md` section 3.1 reads it into the plane, from the
    /// record's spelling alone: a whole number from 0 to 254 is itself, and any other value,
    /// a fraction, a number past 254, a text, a truth value, an error, is 255.
    fn record_byte(v: &Form) -> u8 {
        match v {
            Form::Sym(s) if s == "true" || s == "false" => 255,
            Form::Sym(s) => {
                let n: f64 = s
                    .parse()
                    .unwrap_or_else(|_| panic!("the record holds {s}, which is no value"));
                if (0.0..=254.0).contains(&n) && n.fract() == 0.0 {
                    n as u8
                } else {
                    255
                }
            }
            Form::Str(_) | Form::List(_) => 255,
        }
    }

    /// The bytes the record of a window says the plane holds (section 3.1, section 13): a
    /// `cell` row's value, a formula's `value` row; an absent cell, and a formula with no
    /// value row, 0.
    fn record_bytes(c: &Cartridge, sheet: &str, w: Rect) -> Vec<u8> {
        let text = match c.view("grid", sheet, Some(&spell(w))) {
            Ok(Viewed::Text(t)) => t,
            other => panic!("the record of {sheet}!{}: {other:?}", spell(w)),
        };
        let width = (w.3 - w.1 + 1) as usize;
        let mut out = vec![0u8; width * (w.2 - w.0 + 1) as usize];
        for form in read_forms(&text).expect("the record reads") {
            let Form::List(l) = &form else { continue };
            let [Form::Sym(head), Form::Str(_), Form::Str(addr), value] = l.items.as_slice() else {
                continue;
            };
            if head != "cell" && head != "value" {
                continue;
            }
            let a = parse_a1_range(addr).expect("a cell's address");
            out[(a.top - w.0) as usize * width + (a.left - w.1) as usize] = record_byte(value);
        }
        out
    }

    fn plane_of(c: &Cartridge, sheet: &str, w: Rect) -> Vec<u8> {
        match c.view("plane", sheet, Some(&spell(w))) {
            Ok(Viewed::Bytes(b)) => b,
            other => panic!("the plane of {sheet}!{}: {other:?}", spell(w)),
        }
    }

    /// The plane of a window held to the record of the same window, byte for value, the
    /// first cell where they differ named.
    fn plane_is_record(c: &Cartridge, sheet: &str, w: Rect, at: &str) {
        let (plane, record) = (plane_of(c, sheet, w), record_bytes(c, sheet, w));
        assert_eq!(
            plane.len(),
            record.len(),
            "{at}: the window {sheet}!{}",
            spell(w)
        );
        let width = (w.3 - w.1 + 1) as usize;
        if let Some(i) = plane.iter().zip(&record).position(|(p, r)| p != r) {
            panic!(
                "{at}: in the window {sheet}!{}, {} holds {} in the plane and {} by the record",
                spell(w),
                address(w.0 + (i / width) as u32, w.1 + (i % width) as u32),
                plane[i],
                record[i]
            );
        }
    }

    /// `ENGINE.2`'s equality (`SPEC.md` section 13) over the test card, every frame from 0
    /// to 24: the window the Camera places, read off the Camera's own record, which pans one
    /// column a frame and wraps after 21; the Screen's whole extent; a window past it; and
    /// the twin's window. At frame 5, a value, a formula and a derived row written inside
    /// the window between two steps, each held at once, and a derived row refused. Every arm
    /// of section 3.1 is reached: a colour, a byte past the palette, 255 for every other
    /// kind of value, 0 for an empty cell and for a formula with no value.
    #[test]
    fn the_test_card_s_plane_is_its_record_every_frame() {
        let mut c =
            Cartridge::load(TESTCARD, "testcard.vla", TESTCARD.len()).expect("the test card loads");
        let mut seen = std::collections::BTreeSet::new();
        for frame in 0..=24u32 {
            let camera = record_bytes(&c, "Camera", (1, 2, 2, 2));
            let (row, col) = (u32::from(camera[0]), u32::from(camera[1]));
            let pan = if frame == 0 { 1 } else { 1 + frame % 21 };
            assert_eq!((row, col), (1, pan), "the Camera at frame {frame}");
            let window = (row, col, row + 23, col + 39);
            let at = format!("frame {frame}");
            plane_is_record(&c, "Screen", window, &at);
            seen.extend(plane_of(&c, "Screen", window));
            plane_is_record(&c, "Screen", (1, 1, 22, 56), &format!("{at}, the extent"));
            plane_is_record(
                &c,
                "Screen",
                (20, 50, 26, 60),
                &format!("{at}, past the extent"),
            );
            plane_is_record(&c, "Screen.last", window, &format!("{at}, the twin"));
            if frame == 5 {
                for (row, what) in [
                    (
                        format!("(cell \"Screen\" \"{}\" 200)", address(3, col + 2)),
                        "a value",
                    ),
                    (
                        format!(
                            "(formula \"Screen\" \"{}\" \"=Clock!$B$1\")",
                            address(4, col + 2)
                        ),
                        "a formula",
                    ),
                    (
                        format!("(derived \"Screen\" \"{}\" 3)", address(5, col + 2)),
                        "a derived row",
                    ),
                ] {
                    c.write(&row).unwrap_or_else(|e| panic!("{row}: {e:?}"));
                    let at = format!("frame 5, after {what} written");
                    plane_is_record(&c, "Screen", window, &at);
                    plane_is_record(&c, "Screen", (1, 1, 22, 56), &at);
                }
                let refused = format!("(derived \"Screen\" \"{}\" 3)", address(13, col));
                assert!(c.write(&refused).is_err(), "{refused} lands on a formula");
                plane_is_record(&c, "Screen", window, "frame 5, after a derived row refused");
            }
            assert!(c.step(0).done, "frame {} completes", frame + 1);
        }
        for b in [0u8, 1, 15, 16, 100, 254, 255] {
            assert!(
                seen.contains(&b),
                "the windows never held the byte {b}: {seen:?}"
            );
        }
    }

    /// The same equality over Life, the engine's own cartridge, whose whole window's record
    /// is tens of megabytes, 62,964 formula rows of some 430 characters each: its four
    /// corners, each crossing the edge of the Screen's extent into the dead border, and a
    /// band of two rows across its whole width, at frame 0, where no formula has a value,
    /// and at frame 1, the soup.
    #[test]
    fn life_s_plane_is_its_record_at_its_corners_and_a_band() {
        let mut c = Cartridge::load(LIFE, "life.vla", LIFE.len()).expect("Life loads");
        let windows = [
            (1, 1, 20, 20),
            (1, 301, 20, 320),
            (181, 1, 200, 20),
            (181, 301, 200, 320),
            (100, 1, 101, 320),
        ];
        for frame in 0..=1 {
            for w in windows {
                plane_is_record(&c, "Screen", w, &format!("Life, frame {frame}"));
            }
            if frame == 0 {
                assert!(c.step(0).done, "Life's frame 1 completes");
            }
        }
        let live: usize = windows
            .iter()
            .map(|&w| {
                plane_of(&c, "Screen", w)
                    .iter()
                    .filter(|&&b| b == 1)
                    .count()
            })
            .sum();
        assert!(live > 0, "the soup reached none of the windows");
    }

    // ---- CART.2: Sand, the first game ----

    /// Sand (CART.2): a falling-sand toy, the floors' third fixture.
    const SAND: &str = include_str!("../../cartridges/sand/sand.vla");

    use crate::sand;

    /// One of Sand's sheets whole, 320 by 200, as the plane reads it.
    fn sand_plane(c: &Cartridge, sheet: &str) -> Vec<u8> {
        match c.view("plane", sheet, Some("A1:LH200")) {
            Ok(Viewed::Bytes(b)) => b,
            other => panic!("the {sheet}'s plane: {other:?}"),
        }
    }

    /// Where a plane first differs from the hand-written sand, by its cell.
    fn sand_differs(got: &[u8], want: &[u8]) -> Option<String> {
        got.iter().zip(want).position(|(a, b)| a != b).map(|i| {
            format!(
                "{} reads {} where the hand-written sand holds {}",
                address((i / sand::W + 1) as u32, (i % sand::W + 1) as u32),
                got[i],
                want[i]
            )
        })
    }

    /// Each value row of a sheet's window, by its address.
    fn sand_values(
        c: &Cartridge,
        sheet: &str,
        window: &str,
    ) -> std::collections::HashMap<String, String> {
        let Ok(Viewed::Text(record)) = c.view("grid", sheet, Some(window)) else {
            panic!("the {sheet}'s record");
        };
        let head = format!("(value \"{sheet}\" \"");
        record
            .lines()
            .filter_map(|l| l.strip_prefix(head.as_str()))
            .filter_map(|rest| rest.split_once("\" "))
            .map(|(addr, v)| (addr.to_string(), v.trim_end_matches(')').to_string()))
            .collect()
    }

    /// The Screen, the Stay sheet and the Side sheet after a frame, each held
    /// to the hand-written sand's.
    fn sand_holds(c: &Cartridge, frame: usize, want: &[u8], stay: &[u8], side: &[u8]) {
        for (sheet, plane) in [("Screen", want), ("Stay", stay), ("Side", side)] {
            if let Some(d) = sand_differs(&sand_plane(c, sheet), plane) {
                panic!("the {sheet} sheet at frame {frame}: {d}");
            }
        }
    }

    /// Sand's opening held to the hand-written sand: the Screen, the Stay
    /// sheet and the Side sheet at every frame, every grain of each material
    /// kept, the Tally the last frame's sums, and the rule one fill a formula,
    /// which decision 2 asks of every board (a fill a row made 398 shapes, and
    /// a frame's start 369 ms). The opening rains sand and water, half the
    /// soup's grains each (decision 19). The toy steps at a rate of 60 and
    /// reads its brush from the Gate's three columns since the playtest pass
    /// (2026-10-12).
    #[test]
    fn sand_s_opening_is_the_hand_written_sand_and_keeps_every_grain() {
        let mut c = Cartridge::load(SAND, "sand.vla", SAND.len()).expect("Sand loads");
        assert_eq!(c.row(1), "(cartridge 1 \"Sand\" plane 320 200 60)");
        let (cells, shapes) = c.machine().formulas();
        assert_eq!(
            shapes, 15,
            "one fill a formula: Parity, the Brush's four, the Gate's three, State, Stay, Side, the Screen's two and the Tally's two"
        );
        assert!(
            c.describe()
                .contains(&format!("(budget 60 {cells} {} 2000000)\n", cells * 60)),
            "{}",
            c.describe()
        );
        let mut want = sand::opening(1);
        let (_, mut stay, mut side) = sand::step(&sand::empty(sand::SAND), None, sand::SAND);
        let (mut last, mut last_side) = (sand::empty(sand::EMPTY), side.clone());
        for frame in 1..=4 {
            if frame > 1 {
                let before = sand::counts(&want);
                (last, last_side) = (want.clone(), side.clone());
                (want, stay, side) = sand::step(&want, None, sand::SAND);
                assert_eq!(
                    sand::counts(&want),
                    before,
                    "frame {frame} keeps every grain of each material"
                );
            }
            assert!(c.step(0).done, "Sand's frame {frame} completes");
            sand_holds(&c, frame, &want, &stay, &side);
        }
        let n = sand::counts(&want);
        assert!(
            n[sand::SAND as usize] > 3_000 && n[sand::WATER as usize] > 3_000,
            "the soup is three eighths of the board's top third, half of it water: {n:?}"
        );
        // The Tally, computed at frame 4 from the twins, holds frame 3's sums.
        let tally = sand_values(&c, "Tally", "A2:B199");
        for row in sand::TOP..=sand::BOTTOM {
            let (codes, occupied) = sand::tally(&last, &last_side, row);
            assert_eq!(tally[&format!("A{row}")], codes.to_string(), "Tally!A{row}");
            assert_eq!(
                tally[&format!("B{row}")],
                occupied.to_string(),
                "Tally!B{row}"
            );
        }
    }

    /// One frame of a person's hand on Sand: the pointer's column and row, the
    /// left and right buttons, the wheel's notches and the key pressed.
    type Gesture = ((u32, u32), u32, u32, i32, &'static str);

    /// One gesture written to Sand's Input sheet, and the frame stepped: the
    /// material picked and the brush's radius moved as the cartridge moves
    /// them, and the disc the hand-written sand paints this frame, if any.
    fn sand_gesture(
        c: &mut Cartridge,
        frame: usize,
        &((col, row), left, right, notches, key): &Gesture,
        material: &mut u8,
        radius: &mut i64,
    ) -> Option<sand::Brush> {
        *material = match key {
            "1" => sand::SAND,
            "2" => sand::WALL,
            "3" => sand::WATER,
            "0" => sand::EMPTY,
            _ => *material,
        };
        *radius = (*radius - i64::from(notches)).clamp(1, 8);
        let code = match key {
            "" => String::new(),
            k => format!("Digit{k}"),
        };
        c.write(&input_rows(
            &[],
            (col, row),
            [left, right, 0],
            notches,
            (key, code.as_str()),
        ))
        .expect("the Input sheet takes the host's rows");
        assert!(c.step(0).done, "frame {frame} completes");
        assert_eq!(
            value_of(c, "Brush", "B3"),
            radius.to_string(),
            "the radius at frame {frame}"
        );
        (left + right > 0 && col > 0 && row > 0).then_some(sand::Brush {
            row: i64::from(row),
            col: i64::from(col),
            radius: *radius,
            material: if right == 1 { sand::EMPTY } else { *material },
        })
    }

    /// A replay of Sand on the hand-written sand (CART.2's second slice), the
    /// brush as `sand_gesture` reads it: the Input sheet's cells as the
    /// replay's rows leave them, since a replay logs a cell only in the frame
    /// it changes; the material and the radius as the State and the Brush keep
    /// them, sand and 3 at the first frame, then a key's pick and the wheel's
    /// notches; the disc the left or the right button paints while the
    /// pointer is over the Screen, empty under the right; and the board, the
    /// opening from the Clock's seed at the first frame. Each frame's Screen
    /// is held to it.
    #[derive(Default)]
    struct SandHand {
        input: std::collections::HashMap<String, Form>,
        material: u8,
        radius: i64,
        board: Vec<u8>,
        painted: usize,
    }

    impl SandHand {
        fn holds(&mut self, c: &Cartridge, frame: u32, rows: &[Form]) {
            for row in rows {
                if let Form::List(l) = row {
                    if let [Form::Sym(head), Form::Str(sheet), Form::Str(addr), value] =
                        l.items.as_slice()
                    {
                        if head == "cell" && sheet == "Input" {
                            self.input.insert(addr.clone(), value.clone());
                        }
                    }
                }
            }
            let number = |addr: &str| match self.input.get(addr) {
                Some(Form::Sym(n)) => n.parse::<f64>().expect("a number in the Input sheet"),
                _ => 0.0,
            };
            let (col, row, left, right, wheel) = (
                number("B11"),
                number("B12"),
                number("B13"),
                number("B14"),
                number("B16"),
            );
            let key = match self.input.get("B17") {
                Some(Form::Str(k)) => k.clone(),
                _ => String::new(),
            };
            if frame == 1 {
                let seed = value_of(c, "Clock", "B3").parse().expect("the seed");
                (self.material, self.radius) = (sand::SAND, 3);
                self.board = sand::opening(seed);
            } else {
                self.material = match key.as_str() {
                    "1" => sand::SAND,
                    "2" => sand::WALL,
                    "3" => sand::WATER,
                    "0" => sand::EMPTY,
                    _ => self.material,
                };
                self.radius = (self.radius - wheel as i64).clamp(1, 8);
                let brush = (left + right > 0.0 && col > 0.0 && row > 0.0).then_some(sand::Brush {
                    row: row as i64,
                    col: col as i64,
                    radius: self.radius,
                    material: if right == 1.0 {
                        sand::EMPTY
                    } else {
                        self.material
                    },
                });
                self.painted += usize::from(brush.is_some());
                self.board = sand::step(&self.board, brush.as_ref(), self.material).0;
            }
            if let Some(d) = sand_differs(&sand_plane(c, "Screen"), &self.board) {
                panic!("Sand's replay, frame {frame}: {d}");
            }
        }
    }

    /// A session of the brush, frame by frame, each frame held to the
    /// hand-written sand: the left button paints the material picked, the
    /// right paints empty, the wheel sizes the disc from 1 to 8, the keys 1,
    /// 2 and 0 pick sand, wall and empty, the floor shows the pick, and a
    /// button held with the pointer off the Screen paints nothing. A frame with
    /// no paint keeps every grain.
    #[test]
    fn sand_paints_with_the_left_button_erases_with_the_right_and_the_wheel_sizes_the_brush() {
        let mut c = Cartridge::load(SAND, "sand.vla", SAND.len()).expect("Sand loads");
        assert!(c.step(0).done, "frame 1, the soup");
        let mut want = sand::opening(1);
        let session: [Gesture; 9] = [
            ((100, 60), 1, 0, 0, ""),
            ((104, 62), 1, 0, -2, ""),
            ((150, 120), 0, 1, 0, ""),
            ((150, 120), 0, 0, 0, "2"),
            ((60, 40), 1, 0, 1, ""),
            ((318, 199), 1, 0, 9, ""),
            ((60, 40), 0, 0, 0, "0"),
            ((200, 100), 1, 0, 0, ""),
            ((0, 0), 1, 0, -20, "1"),
        ];
        let (mut material, mut radius) = (sand::SAND, 3i64);
        let mut painted = 0;
        for (i, gesture) in session.iter().enumerate() {
            let frame = i + 2;
            let brush = sand_gesture(&mut c, frame, gesture, &mut material, &mut radius);
            let before = sand::counts(&want);
            want = sand::step(&want, brush.as_ref(), material).0;
            if let Some(d) = sand_differs(&sand_plane(&c, "Screen"), &want) {
                panic!("frame {frame}, the brush {brush:?}: {d}");
            }
            if brush.is_some() {
                painted += 1;
            } else {
                assert_eq!(
                    sand::counts(&want),
                    before,
                    "frame {frame} keeps every grain"
                );
            }
        }
        assert_eq!(painted, 6, "six frames painted");
    }

    /// Water (CART.2's third slice, decision 21), on a board that opens empty:
    /// Sand's rows with the soup's two thresholds at 0, its rule as it stands.
    /// The key 3 picks water and the floor shows it; a disc of water falls and
    /// spreads along the floor; the right button erases water; and a lone
    /// grain of water painted against the left wall falls to the floor and
    /// shimmers there, out and back each frame, since water never settles.
    /// Every frame the Screen, Stay and Side are the hand-written sand's, and
    /// a frame with no paint keeps every material.
    #[test]
    fn sand_s_water_falls_spreads_is_erased_and_never_settles() {
        let (sand_under, water_under) = ("<12582911,2,", "<25165822,3,0");
        assert_eq!(
            (
                SAND.matches(sand_under).count(),
                SAND.matches(water_under).count()
            ),
            (1, 1),
            "the opening's two thresholds, once each"
        );
        let text = SAND
            .replace(sand_under, "<0,2,")
            .replace(water_under, "<0,3,0");
        let mut c = Cartridge::load(&text, "sand.vla", text.len()).expect("the empty Sand loads");
        let (_, mut stay, mut side) = sand::step(&sand::empty(sand::SAND), None, sand::SAND);
        let mut want = sand::empty(sand::SAND);
        assert!(c.step(0).done, "frame 1, the board empty");
        sand_holds(&c, 1, &want, &stay, &side);
        // The pointer on the wall's column B with a radius of 1 covers the one
        // cell of the interior beside it, C197: a lone grain against the wall.
        let session: [Gesture; 22] = [
            ((0, 0), 0, 0, 0, "3"),
            ((160, 194), 1, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((160, 197), 0, 1, 0, ""),
            ((0, 0), 0, 0, 2, ""),
            ((2, 197), 1, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
            ((0, 0), 0, 0, 0, ""),
        ];
        let (mut material, mut radius) = (sand::SAND, 3i64);
        let water = |b: &[u8]| sand::counts(b)[sand::WATER as usize];
        let mut wall = Vec::new();
        for (i, gesture) in session.iter().enumerate() {
            let frame = i + 2;
            let brush = sand_gesture(&mut c, frame, gesture, &mut material, &mut radius);
            let before = sand::counts(&want);
            (want, stay, side) = sand::step(&want, brush.as_ref(), material);
            sand_holds(&c, frame, &want, &stay, &side);
            match (frame, brush) {
                (3, _) => assert!(water(&want) > 20, "frame 3 paints a disc of water"),
                (6, _) => assert!(
                    water(&want) < before[sand::WATER as usize],
                    "frame 6 erases water"
                ),
                (8, _) => assert_eq!(
                    want[sand::at(197, 3)],
                    sand::WATER,
                    "frame 8 paints a lone grain against the wall"
                ),
                (_, None) => assert_eq!(
                    sand::counts(&want),
                    before,
                    "frame {frame} keeps every material"
                ),
                (_, Some(b)) => panic!("frame {frame} paints, unplanned: {b:?}"),
            }
            assert_eq!(
                want[sand::at(sand::H, sand::LEFT)],
                sand::WATER,
                "the floor shows water, picked at frame 2, at frame {frame}"
            );
            wall.push((want[sand::at(199, 3)], want[sand::at(199, 4)]));
        }
        // The lone grain reaches the floor at frame 10 and moves each frame
        // after it: right from the wall, then back, a shimmer with no end.
        let after: Vec<_> = wall[8..].to_vec();
        assert!(
            after.len() >= 8
                && after.iter().enumerate().all(|(k, &cells)| cells
                    == if k % 2 == 0 {
                        (sand::WATER, sand::EMPTY)
                    } else {
                        (sand::EMPTY, sand::WATER)
                    }),
            "the grain against the wall shimmers on the floor: {after:?}"
        );
    }

    // ---- CART.4: Kairos, the stacking game ----

    /// Kairos (CART.4): the stacking game, the first game with a goal, a win
    /// and a loss.
    const KAIROS: &str = include_str!("../../cartridges/kairos/kairos.vla");

    use crate::kairos::{self, End, Game, Phase, Settings};

    /// One frame's Input rows as the host writes them: the stop's button, a,
    /// and the minor prize's, b, both player 1's (the Input sheet's B5 and B6).
    fn kairos_inputs(stop: bool, take: bool) -> String {
        let mut held = Vec::new();
        if stop {
            held.push((4, 0));
        }
        if take {
            held.push((5, 0));
        }
        input_rows(&held, (0, 0), [0, 0, 0], 0, ("", ""))
    }

    /// Each cell of a sheet's window by its address: a value cell's value or
    /// a formula's last value, as the record spells it, a text unquoted.
    fn kairos_cells(
        c: &Cartridge,
        sheet: &str,
        window: &str,
    ) -> std::collections::HashMap<String, String> {
        let Ok(Viewed::Text(record)) = c.view("grid", sheet, Some(window)) else {
            panic!("the {sheet}'s record");
        };
        let mut out = std::collections::HashMap::new();
        for line in record.lines() {
            for head in [
                format!("(value \"{sheet}\" \""),
                format!("(cell \"{sheet}\" \""),
            ] {
                if let Some((addr, v)) = line
                    .strip_prefix(head.as_str())
                    .and_then(|rest| rest.split_once("\" "))
                {
                    let v = v.trim_end_matches(')').trim_matches('"');
                    out.insert(addr.to_string(), v.to_string());
                }
            }
        }
        out
    }

    /// What the bot does in one game: the level it misses at, the levels it
    /// stops half over the row beneath, whether it takes the minor prize, how
    /// many frames into a place it waits before it presses, and how many
    /// moves a row makes before the bot may stop it, at least one.
    #[derive(Clone, Copy, Default)]
    struct KairosPlan {
        miss_at: Option<usize>,
        partial_at: &'static [usize],
        take_minor: bool,
        late: u32,
        travel: u32,
    }

    /// A player that watches the game by hand after each frame and presses as
    /// a person would, a key down for one frame and up the next: on the place
    /// its plan means, after the row has moved once; at the offer, and after a
    /// game's end, once it has waited.
    struct KairosBot {
        plans: Vec<KairosPlan>,
        game: usize,
        stop: bool,
        take: bool,
        waited: u32,
    }

    impl KairosBot {
        fn new(plans: Vec<KairosPlan>) -> KairosBot {
            KairosBot {
                plans,
                game: 1,
                stop: false,
                take: false,
                waited: 0,
            }
        }

        fn decide(&mut self, g: &Game) -> (bool, bool) {
            let plan = self.plans.get(self.game - 1).copied();
            let (mut stop, mut take) = (false, false);
            match (g.phase, plan) {
                (Phase::Sliding, Some(p)) if g.frame > 0 => {
                    let row = g.row();
                    let over = row & g.beneath;
                    let period = g.settings.period[g.level - 1];
                    let want = if p.miss_at == Some(g.level) {
                        over == 0
                    } else if p.partial_at.contains(&g.level) {
                        over != 0 && over != row
                    } else {
                        over == row
                    };
                    let place = g.since % period;
                    stop = g.since >= period * p.travel.max(1)
                        && want
                        && place >= p.late.min(period - 1)
                        && !self.stop;
                }
                (Phase::Offer, Some(p)) => {
                    self.waited += 1;
                    if self.waited > 30 && !self.stop && !self.take {
                        if p.take_minor {
                            take = true;
                        } else {
                            stop = true;
                        }
                    }
                }
                (Phase::Over, Some(_)) if g.ready() => {
                    self.waited += 1;
                    if self.waited > 20 && !self.stop {
                        stop = true;
                        self.game += 1;
                    }
                }
                _ => {}
            }
            if g.phase == Phase::Sliding || g.phase == Phase::Stopped {
                self.waited = 0;
            }
            (self.stop, self.take) = (stop, take);
            (stop, take)
        }
    }

    /// One frame of Kairos held to the game by hand: the board through the
    /// plane projection, the cells of the State the game keeps, and the four
    /// voices.
    fn kairos_holds(c: &Cartridge, g: &Game, frame: u32, upright: bool) {
        let window = if upright { "A1:G15" } else { "A1:O7" };
        let board = match c.view("plane", "Screen", Some(window)) {
            Ok(Viewed::Bytes(b)) => b,
            other => panic!("the board: {other:?}"),
        };
        let want = if upright {
            g.board_upright()
        } else {
            g.board()
        };
        let width = if upright {
            kairos::COLUMNS
        } else {
            kairos::LEVELS
        };
        if let Some(i) = board.iter().zip(&want).position(|(a, b)| a != b) {
            panic!(
                "frame {frame}: the board's {} reads {} where the game by hand holds {} ({:?}, level {}, {} frames into the phase)",
                address((i / width + 1) as u32, (i % width + 1) as u32),
                board[i],
                want[i],
                g.phase,
                g.level,
                g.since
            );
        }
        let st = kairos_cells(c, "State", "B1:B26");
        let num = |a: &str| {
            st.get(a)
                .and_then(|v| v.parse::<f64>().ok())
                .unwrap_or(f64::NAN)
        };
        let mut held = vec![
            ("B1, the phase", num("B1"), f64::from(g.phase.code())),
            (
                "B2, the frames since it began",
                num("B2"),
                f64::from(g.since),
            ),
            ("B3, the level", num("B3"), g.level as f64),
            ("B4, the width", num("B4"), f64::from(g.width)),
            ("B5, the left end", num("B5"), f64::from(g.left)),
            ("B6, the direction", num("B6"), f64::from(g.direction)),
            (
                "B17, what stayed",
                num("B17"),
                f64::from(g.beneath.count_ones()),
            ),
            ("B22, where it stopped", num("B22"), f64::from(g.stopped)),
            ("B25, the result", num("B25"), f64::from(g.end.code())),
            ("B26, the games", num("B26"), f64::from(g.games)),
        ];
        if let Some((first, last)) = kairos::ends(g.beneath) {
            held.push(("B23, the run's first", num("B23"), f64::from(first)));
            held.push(("B24, the run's last", num("B24"), f64::from(last)));
        }
        for (what, got, want) in held {
            assert!(
                got == want,
                "frame {frame}: State!{what} is {got}, the game by hand's {want}"
            );
        }
        let au = kairos_cells(c, "Audio", "B2:D5");
        for (k, v) in g.voices().iter().enumerate() {
            let r = k + 2;
            let wave = au.get(&format!("B{r}")).cloned().unwrap_or_default();
            let number = |col: &str| {
                au.get(&format!("{col}{r}"))
                    .and_then(|x| x.parse::<f64>().ok())
                    .unwrap_or(f64::NAN)
            };
            let (note, volume) = (number("C"), number("D"));
            assert!(
                wave == v.wave && note == v.note && volume == v.volume,
                "frame {frame}: voice {} is {wave} {note} {volume}, the game by hand's {} {} {}",
                k + 1,
                v.wave,
                v.note,
                v.volume
            );
        }
    }

    /// The Tally at a session's end, the game by hand's counts.
    fn kairos_tally_holds(c: &Cartridge, g: &Game) {
        let t = kairos_cells(c, "Tally", "A1:D23");
        let num = |a: &str| {
            t.get(a)
                .and_then(|v| v.parse::<f64>().ok())
                .unwrap_or(f64::NAN)
        };
        for lv in 1..=kairos::LEVELS {
            let r = lv + 1;
            let got = [
                num(&format!("B{r}")),
                num(&format!("C{r}")),
                num(&format!("D{r}")),
            ];
            let want = [g.reached[lv - 1], g.stacked[lv - 1], g.fell[lv - 1]].map(f64::from);
            assert_eq!(got, want, "the Tally's level {lv}: reached, stacked, fell");
        }
        let got = ["B18", "B19", "B20", "B21", "B22", "B23"].map(num);
        let want = [g.games, g.presses, g.moves, g.minors, g.majors, g.falls].map(f64::from);
        assert_eq!(
            got, want,
            "the Tally's games, presses, moves, minor prizes, major prizes and falls"
        );
    }

    /// What a session of Kairos did: each game's end with its level, and how
    /// often a row turned at the board's last column and at its first, so that
    /// a session can say its rows travelled the whole board.
    struct KairosRun {
        cartridge: Cartridge,
        game: Game,
        ends: Vec<(End, usize)>,
        turns: [u32; 2],
    }

    /// Kairos played by the bot over a cartridge's text for a number of
    /// frames, every frame held: a person's edits written before the first
    /// frame, and the Write sheet's rows issued before each frame as the host
    /// issues them.
    fn kairos_session(
        text: &str,
        settings: Settings,
        edits: &[&str],
        plans: Vec<KairosPlan>,
        frames: u32,
        upright: bool,
    ) -> KairosRun {
        let mut c = Cartridge::load(text, "kairos.vla", text.len()).expect("Kairos loads");
        for e in edits {
            assert_eq!(c.write(e), Ok(1), "{e}");
        }
        let mut g = Game::new(settings);
        let mut bot = KairosBot::new(plans);
        let mut pending: Vec<String> = Vec::new();
        let (mut ends, mut turns) = (Vec::new(), [0u32; 2]);
        for frame in 1..=frames {
            let (stop, take) = bot.decide(&g);
            for row in pending.drain(..) {
                c.write(&row)
                    .unwrap_or_else(|e| panic!("frame {frame}: {row}: {e:?}"));
            }
            c.write(&kairos_inputs(stop, take))
                .expect("the Input sheet takes the host's rows");
            assert!(c.step(0).done, "frame {frame} completes");
            pending = derived_rows(&c);
            let was = g.direction;
            g.step(stop, take);
            if g.moved && g.direction != was {
                turns[usize::from(g.direction == 1)] += 1;
            }
            if g.phase == Phase::Over && g.since == 0 {
                ends.push((g.end, g.level));
            }
            kairos_holds(&c, &g, frame, upright);
        }
        KairosRun {
            cartridge: c,
            game: g,
            ends,
            turns,
        }
    }

    /// Four games of Kairos played by the bot, every frame held to the game by
    /// hand (decision 11 of the second scoping): the major prize won, every
    /// row bouncing off both ends of the board before its stop; a fall at
    /// level 6, after stops half over the row beneath at levels 2 and 5; the
    /// minor prize taken; and a fall at level 13 after going on past the minor
    /// prize. Then the Tally is the game's, and the tower cleared after the
    /// last game's hold. The plan is the one the scoping measured.
    #[test]
    fn kairos_plays_four_games_every_frame_the_game_by_hand() {
        let c = Cartridge::load(KAIROS, "kairos.vla", KAIROS.len()).expect("Kairos loads");
        assert_eq!(c.row(1), "(cartridge 1 \"Kairos\" plane 15 7 60)");
        assert_eq!(
            c.machine().formulas(),
            (350, 64),
            "350 formula cells in 64 shapes, the State's 31 cells each its own"
        );
        let plans = vec![
            KairosPlan {
                travel: 13,
                ..KairosPlan::default()
            },
            KairosPlan {
                miss_at: Some(6),
                partial_at: &[2, 5],
                ..KairosPlan::default()
            },
            KairosPlan {
                take_minor: true,
                ..KairosPlan::default()
            },
            KairosPlan {
                miss_at: Some(13),
                partial_at: &[3],
                ..KairosPlan::default()
            },
        ];
        let run = kairos_session(KAIROS, Settings::default(), &[], plans, 4_500, false);
        assert_eq!(
            run.ends,
            [
                (End::Major, 15),
                (End::Fell, 6),
                (End::Minor, 11),
                (End::Fell, 13)
            ]
        );
        assert!(
            run.turns[0] >= 15 && run.turns[1] >= 15,
            "every row of the first game turned at the board's last column and at its first: {:?}",
            run.turns
        );
        kairos_tally_holds(&run.cartridge, &run.game);
        assert!(
            run.game.tower.iter().all(|&m| m == 0),
            "the tower cleared after the last game's hold"
        );
    }

    /// The cabinet's rigging, in the open (decision 5): a person's edit sets
    /// level 2's window, and the bot presses a number of frames into a place of
    /// ten, over the row beneath. A press in the window's frames stops the row
    /// where it stands; a press on the frame after them, or later, stops it a
    /// column on, so a light falls. Under the honest window, its period, the
    /// late press stops the row where it stands. Every frame is held to the
    /// game by hand given the same window.
    #[test]
    fn kairos_s_window_rigged_in_the_open_stops_the_row_a_column_on() {
        // (the window, the frames into a place the press comes, the lights that fall)
        let cases: [(u32, u32, u32); 4] = [(1, 4, 1), (2, 2, 1), (2, 1, 0), (10, 4, 0)];
        for (window, late, falls) in cases {
            let mut settings = Settings::default();
            settings.window[1] = window;
            let edit = format!("(cell \"Levels\" \"D3\" {window})");
            let edits: &[&str] = if window == 10 { &[] } else { &[edit.as_str()] };
            let plans = vec![KairosPlan {
                late,
                ..KairosPlan::default()
            }];
            let run = kairos_session(KAIROS, settings, edits, plans, 160, false);
            let g = &run.game;
            assert!(
                g.level >= 3,
                "a window of {window}: past level 2 by frame 160, at {}",
                g.level
            );
            assert_eq!(
                g.fell[1], falls,
                "a window of {window}, a press {late} frames into a place: the lights that fell at level 2"
            );
        }
    }

    /// A press stops the row where the person saw it (decision 4): pressed in
    /// the frame the row would move, the stop takes the last frame's place,
    /// and the row does not move. Level 1's period is 10: the row appears in
    /// frame 1, holds its place through frame 10, and would move in frame 11.
    #[test]
    fn kairos_stops_where_the_row_was_seen() {
        let mut c = Cartridge::load(KAIROS, "kairos.vla", KAIROS.len()).expect("Kairos loads");
        let mut g = Game::new(Settings::default());
        for frame in 1..=11u32 {
            let stop = frame == 11;
            c.write(&kairos_inputs(stop, false)).expect("the inputs");
            assert!(c.step(0).done, "frame {frame} completes");
            g.step(stop, false);
            kairos_holds(&c, &g, frame, false);
        }
        assert_eq!(
            (g.phase, g.stopped, g.left),
            (Phase::Stopped, 1, 1),
            "stopped where the row was seen, not a column on"
        );
        let mut idle = Game::new(Settings::default());
        for _ in 1..=11u32 {
            idle.step(false, false);
        }
        assert_eq!(idle.left, 2, "without the press, frame 11 moves the row");
    }

    /// The cabinet stood up (decision 7): the same source with one word and
    /// the manifest's window changed, expanded by the pass, has the same plan
    /// and plays the same games, every frame the board by hand standing up,
    /// and its State, its voices and its Tally the sideways build's. Read off
    /// the folder at run time, as the pass's golden is: a package without the
    /// repository's `cartridges/` has no source to turn.
    #[test]
    fn kairos_stands_up_by_one_word_and_its_window() {
        let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../cartridges");
        let (Ok(source), Ok(library)) = (
            std::fs::read_to_string(root.join("kairos").join("kairos.source.vla")),
            std::fs::read_to_string(root.join("common.vla")),
        ) else {
            eprintln!("no cartridges/ beside the crate: the source is the repository's");
            return;
        };
        assert_eq!(
            (
                source.matches("(board \"sideways\")").count(),
                source.matches("(screen plane 15 7)").count()
            ),
            (1, 1),
            "the word and the window, once each"
        );
        let upright = source
            .replace("(board \"sideways\")", "(board \"upright\")")
            .replace("(screen plane 15 7)", "(screen plane 7 15)");
        let files = [("cartridges/common.vla".to_string(), library)];
        let built = crate::pass::expand(&upright, "cartridges/kairos/kairos.source.vla", &files)
            .unwrap_or_else(|r| panic!("the upright source: line {} {}", r.line, r.refusal.text));
        let c = Cartridge::load(&built.text, "kairos.vla", built.text.len())
            .expect("the upright build loads");
        assert_eq!(c.row(1), "(cartridge 1 \"Kairos\" plane 7 15 60)");
        assert_eq!(
            c.machine().formulas(),
            (350, 64),
            "the sideways build's plan"
        );
        let plans = vec![
            KairosPlan::default(),
            KairosPlan {
                miss_at: Some(6),
                partial_at: &[2, 5],
                ..KairosPlan::default()
            },
        ];
        let run = kairos_session(&built.text, Settings::default(), &[], plans, 800, true);
        assert_eq!(run.ends, [(End::Major, 15), (End::Fell, 6)]);
        kairos_tally_holds(&run.cartridge, &run.game);
    }
}

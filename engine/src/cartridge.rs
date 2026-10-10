//! The cartridge (ENGINE.1's second slice, 2026-10-09): what the engine adds
//! to the language's machine, and nothing else (`SPEC.md` section 4.6): the
//! manifest, the device sheets' layouts and their checks, the engine's own
//! sheets, the Clock's frame at every step, and `describe`. The grid, its
//! rows, its twins, its step, its views and their refusals are the
//! language's, `vla_lang::machine`, called here in Rust.
//!
//! **The load**, in section 4.2's order: the manifest read with the
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
//! machine, which refuses it whatever it holds.
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

/// The versions of `SPEC.md` this engine reads.
pub const SPECS: [u32; 2] = [1, 2];
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
    /// frame, their product with the rate, and the charter's line.
    pub fn describe(&self) -> String {
        let mut out = String::new();
        for d in &self.manifest.directives {
            out.push_str(d);
            out.push('\n');
        }
        let book = self.machine.workbook();
        for device in DEVICES {
            match book.find_sheet(device.name()) {
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
        let [Form::Sym(head), Form::Str(sheet), Form::Str(addr), _] = l.items.as_slice() else {
            return Ok(());
        };
        if !matches!(head.as_str(), "cell" | "formula" | "derived") {
            return Ok(());
        }
        let Some(range) = parse_a1_range(addr) else {
            return Ok(());
        };
        let book = self.machine.workbook();
        let Some(si) = book.find_sheet(sheet) else {
            return Ok(());
        };
        if si >= self.machine.sheets() {
            return Ok(());
        }
        let Some(device) = Device::of(&book.sheets[si].name) else {
            return Ok(());
        };
        let target = format!("{sheet}!{addr}");
        let name = &book.sheets[si].name;
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

    fn formulas(c: &Cartridge) -> Vec<(usize, u32, u32, Content)> {
        let mut out = Vec::new();
        for (si, sheet) in c.machine().workbook().sheets.iter().enumerate() {
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
        let text = small(30).replacen("(spec 2)", "(spec 3)\n  (layers 2)", 1);
        let r = load(&text).expect_err("a later page is refused");
        assert_eq!(r.refusal.id, "cart-spec-unsupported");
        assert_eq!(r.line, 2, "the spec's own line");
        assert!(r.refusal.text.contains("(spec 3)"), "{}", r.refusal.text);
        assert_eq!(
            id_of(load(&small(30).replacen("(spec 2)", "(spec 1)", 1))),
            "loaded"
        );
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
        let names: Vec<&str> = c
            .machine()
            .workbook()
            .sheets
            .iter()
            .map(|s| s.name.as_str())
            .collect();
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
            let before = formulas(&c);
            let s = c.step(0);
            assert!(s.done && s.frame == frame as u64 && s.of == 80, "{s:?}");
            assert_eq!(plane(&c), reference(frame - 1), "frame {frame}");
            assert_eq!(
                formulas(&c),
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
        let names: Vec<String> = original.machine().workbook().sheets
            [..original.machine().sheets()]
            .iter()
            .map(|s| s.name.clone())
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

    #[test]
    fn describe_prints_the_manifest_the_devices_and_the_budget() {
        let c = load(&small(30)).expect("loads");
        let d = c.describe();
        assert_eq!(
            d,
            "(spec 2)\n(title \"Small\")\n(rate 30)\n(screen plane 12 10)\n(seed 1)\n\
             (device \"Screen\" \"A1:L10\" effect)\n(device \"Palette\" \"A1:C16\" effect)\n\
             (device \"Input\" \"A1:E18\" input)\n(device \"Clock\" \"A1:B3\" input)\n\
             (device \"File\" \"A1:B3\" effect)\n(budget 30 80 2400 2000000)\n"
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
        ] {
            assert!(d.contains(want), "describe holds {want}: {d}");
        }
        assert!(
            !d.contains("(device \"Write\""),
            "Life has no Write sheet: {d}"
        );
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
}

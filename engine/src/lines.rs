//! A file's lines, read into a cartridge's sheets and written back as the
//! file they were read from, by templates the cartridge says on its Format
//! sheet (`CART.16`'s second slice; `docs/SPEC.md` section 3.11).
//!
//! A template is a line of the file written out with holes: literal text,
//! and `{B:text}`, a hole whose value stands in column B of the line's row.
//! One template is both directions, matched to read a line and filled to
//! write one, so that a line read and written is the line it was. The engine
//! knows no file's format: the first slice's hand, `afterlife.rs`, knew a
//! reel's thirteen relations, and here they are thirteen rows of a sheet,
//! held to that hand by the tests.
//!
//! **A hole** names a column and a kind, how the file spells a value:
//! `name`, a lowercase letter and then letters, digits and underscores;
//! `word`, a run with no space in it, ended by the template's next
//! character; `text`, in double quotes, a quote and a backslash escaped;
//! `whole`, digits; `rest`, to the line's end; and `note`, the comment at a
//! line's end. Kinds share a hole by a bar, `{B:name|text}`, read by the
//! first that fits and written by the first that can spell the cell. A stop,
//! `{B:text@23}`, writes the value at that column of the line, spaces before
//! it and one at least. And `{A=reel}` is a column bound to a text of its
//! own: read where the text stands and written by it, which is how several
//! kinds of line share a sheet and each row says which it is. A brace of the
//! line's own is written twice.
//!
//! **What a cell holds.** A text's cell holds its words as the file writes
//! them between its quotes, but for a quote, which the cell holds plain: a
//! line's break is the two characters `\n` and a backslash is written twice,
//! in the cell as in the file, the first slice's rule. A whole number lands
//! as a number where a number holds it exactly and writes it back the same,
//! and as its digits' text otherwise, so that no digit is lost. Every other
//! kind lands as a text.
//!
//! **Reading is lenient where a file is loose, and writing is one way.** A
//! run of spaces may stand before a hole and after one, and a space in a
//! template reads any run of them; a line of spaces alone is an empty line.
//! A line is read by the first template that reads it whole. A comment line
//! and an empty line go to the sheet of the line that follows them, and
//! those after the last to its sheet. Written, the sheets go out in the
//! Format sheet's order, a row a line, so a file whose kinds stand
//! interleaved comes back a sheet at a time: what the page says at an open,
//! before a person edits, by writing the file back and naming its first
//! line that would change.

use std::collections::BTreeMap;

use vla_lang::sheet::{MAX_COLUMN, MAX_ROW};

/// The Format sheet's rows (section 3.11): the file's type, its comment's
/// leader, the row a sheet's first line stands on, and its line end, each in
/// column B beside its label; a row of headers; then a kind of line a row,
/// its sheet in column A and its template in column B, a hundred at most.
pub const TYPE_ROW: u32 = 1;
pub const COMMENT_ROW: u32 = 2;
pub const FIRST_ROW_ROW: u32 = 3;
pub const LINE_END_ROW: u32 = 4;
pub const HEADER_ROW: u32 = 5;
pub const FIRST_LINE_ROW: u32 = 6;
pub const MAX_LINES: u32 = 100;
/// The Format sheet's last row.
pub const LAST_ROW: u32 = FIRST_LINE_ROW + MAX_LINES - 1;
/// The furthest column of a line a stop may name.
pub const MAX_STOP: usize = 1024;

/// How the file spells a hole's value.
#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum Kind {
    Name,
    Word,
    Text,
    Whole,
    Rest,
}

impl Kind {
    fn of(word: &str) -> Option<Kind> {
        Some(match word {
            "name" => Kind::Name,
            "word" => Kind::Word,
            "text" => Kind::Text,
            "whole" => Kind::Whole,
            "rest" => Kind::Rest,
            _ => return None,
        })
    }

    fn said(self) -> &'static str {
        match self {
            Kind::Name => "a name, a lowercase letter and then letters, digits and underscores",
            Kind::Word => "a word, with no space in it",
            Kind::Text => "a text in double quotes",
            Kind::Whole => "a whole number",
            Kind::Rest => "the rest of the line",
        }
    }
}

/// Kinds as a refusal names them: one, or each joined by `or`.
fn said_all(kinds: &[Kind]) -> String {
    kinds
        .iter()
        .map(|k| k.said())
        .collect::<Vec<_>>()
        .join(", or ")
}

/// A part of a template.
#[derive(Clone, PartialEq, Eq, Debug)]
enum Part {
    /// The line's own characters, read as they stand, a space as any run.
    Literal(String),
    /// A column bound to a text of its own, `{A=reel}`.
    Bound { column: u32, literal: String },
    /// A hole: its column, its kinds in order, its stop, and for a word the
    /// character of the template that ends it.
    Hole {
        column: u32,
        kinds: Vec<Kind>,
        stop: Option<usize>,
        until: Option<char>,
    },
    /// The comment at a line's end, `{C:note@49}`: a template's last part.
    Note { column: u32, stop: Option<usize> },
}

/// A kind of line: the sheet whose rows it reads and writes, the row of the
/// Format sheet that says it, and its template as written and as read.
#[derive(Clone, Debug)]
pub struct Template {
    pub sheet: String,
    pub row: u32,
    pub text: String,
    parts: Vec<Part>,
}

/// A column's letters, `A` for 1 and `AA` for 27.
pub fn letters(mut column: u32) -> String {
    let mut out = Vec::new();
    while column > 0 {
        out.push(b'A' + ((column - 1) % 26) as u8);
        column = (column - 1) / 26;
    }
    out.reverse();
    String::from_utf8(out).unwrap_or_default()
}

/// A column from its letters, in either case: one to three, to `XFD`.
fn column_of(name: &str) -> Option<u32> {
    if name.is_empty() || name.len() > 3 {
        return None;
    }
    let n = name.bytes().fold(0u32, |n, b| {
        n * 26 + u32::from(b.to_ascii_uppercase() - b'A' + 1)
    });
    (n <= MAX_COLUMN).then_some(n)
}

/// A name, as a file writes one bare: a lowercase letter, then letters,
/// digits and underscores.
pub fn is_name(text: &str) -> bool {
    let mut chars = text.chars();
    chars.next().is_some_and(|c| c.is_ascii_lowercase())
        && chars.all(|c| c.is_ascii_alphanumeric() || c == '_')
}

fn is_whole(text: &str) -> bool {
    !text.is_empty() && text.bytes().all(|b| b.is_ascii_digit())
}

/// One hole's inside, the text between its braces, as a part.
fn hole(inside: &str) -> Result<Part, String> {
    let count = inside
        .chars()
        .take_while(|c| c.is_ascii_alphabetic())
        .count();
    let (name, rest) = inside.split_at(count);
    let Some(column) = column_of(name) else {
        return Err(format!(
            "holds the hole {{{inside}}}, which names no column: a hole begins with a column's letters, as {{A:name}} does"
        ));
    };
    if let Some(literal) = rest.strip_prefix('=') {
        if literal.is_empty() {
            return Err(format!(
                "holds the hole {{{inside}}}, which binds its column to no text: {{A=reel}} binds column A to reel"
            ));
        }
        return Ok(Part::Bound {
            column,
            literal: literal.to_string(),
        });
    }
    let Some(said) = rest.strip_prefix(':') else {
        return Err(format!(
            "holds the hole {{{inside}}}, which says neither a kind, as {{A:name}} does, nor a text of its own, as {{A=reel}} does"
        ));
    };
    let (kinds, stop) = match said.rsplit_once('@') {
        Some((kinds, at)) => {
            let stop = at
                .parse::<usize>()
                .ok()
                .filter(|n| is_whole(at) && (1..=MAX_STOP).contains(n));
            let Some(stop) = stop else {
                return Err(format!(
                    "holds the hole {{{inside}}}, whose stop is no column of a line: a whole number from 1 to {MAX_STOP}"
                ));
            };
            (kinds, Some(stop))
        }
        None => (said, None),
    };
    if kinds == "note" {
        return Ok(Part::Note { column, stop });
    }
    let mut list = Vec::new();
    for word in kinds.split('|') {
        match Kind::of(word) {
            Some(kind) if !list.contains(&kind) => list.push(kind),
            Some(_) => {
                return Err(format!(
                    "holds the hole {{{inside}}}, which names the kind {word} twice"
                ))
            }
            None if word == "note" => {
                return Err(format!(
                    "holds the hole {{{inside}}}, where note shares a hole: a line's comment is a hole of its own, the template's last"
                ))
            }
            None => {
                return Err(format!(
                    "holds the hole {{{inside}}}, which names the kind {word:?}: a hole's kinds are name, word, text, whole, rest and note"
                ))
            }
        }
    }
    Ok(Part::Hole {
        column,
        kinds: list,
        stop,
        until: None,
    })
}

impl Template {
    /// A template read, or what is wrong with it, in words that follow the
    /// cell's name. `comment` is the file's comment's leader, empty for none.
    pub fn parse(sheet: &str, row: u32, text: &str, comment: &str) -> Result<Template, String> {
        let chars: Vec<char> = text.chars().collect();
        let mut parts: Vec<Part> = Vec::new();
        let mut literal = String::new();
        let mut i = 0;
        while i < chars.len() {
            match (chars[i], chars.get(i + 1)) {
                ('{', Some('{')) => {
                    literal.push('{');
                    i += 2;
                }
                ('}', Some('}')) => {
                    literal.push('}');
                    i += 2;
                }
                ('}', _) => {
                    return Err(
                        "holds a closing brace that closes no hole: a brace of the line's own is written twice, }}"
                            .to_string(),
                    )
                }
                ('{', _) => {
                    let Some(close) = chars[i + 1..].iter().position(|c| *c == '}') else {
                        return Err(
                            "holds a hole that is not closed: a brace of the line's own is written twice, {{"
                                .to_string(),
                        );
                    };
                    let inside: String = chars[i + 1..i + 1 + close].iter().collect();
                    if !literal.is_empty() {
                        parts.push(Part::Literal(std::mem::take(&mut literal)));
                    }
                    parts.push(hole(&inside)?);
                    i += close + 2;
                }
                (c, _) => {
                    literal.push(c);
                    i += 1;
                }
            }
        }
        if !literal.is_empty() {
            parts.push(Part::Literal(literal));
        }
        // What every template keeps.
        let mut seen: Vec<u32> = Vec::new();
        let last = parts.len().saturating_sub(1);
        for (k, part) in parts.iter().enumerate() {
            let column = match part {
                Part::Literal(_) => continue,
                Part::Bound { column, .. } | Part::Hole { column, .. } => *column,
                Part::Note { column, .. } => {
                    if k != last {
                        return Err(
                            "holds its comment's hole before its end: a line's comment is the template's last part"
                                .to_string(),
                        );
                    }
                    if comment.is_empty() {
                        return Err(
                            "holds a comment's hole, and the Format sheet's B2 says no comment's leader"
                                .to_string(),
                        );
                    }
                    *column
                }
            };
            if seen.contains(&column) {
                return Err(format!(
                    "names column {} twice: a column holds one part of a line",
                    letters(column)
                ));
            }
            seen.push(column);
            if let Part::Hole { kinds, .. } = part {
                if kinds.contains(&Kind::Rest) && k != last {
                    return Err(
                        "holds a hole of the rest of the line before its end: nothing stands after the rest"
                            .to_string(),
                    );
                }
            }
        }
        if seen.is_empty() {
            return Err(
                "holds no hole: a line's row holds what its holes read, and a line with none is an empty row"
                    .to_string(),
            );
        }
        // A line that begins as a comment does is read as a comment.
        let begins = match parts.first() {
            Some(Part::Literal(s)) => s.as_str(),
            Some(Part::Bound { literal, .. }) => literal.as_str(),
            _ => "",
        };
        if !comment.is_empty() && begins.starts_with(comment) {
            return Err(format!(
                "begins with {comment}, the comment's leader: a line that begins so is read as a comment"
            ));
        }
        // A word ends at the template's next character.
        let mut ends: Vec<Option<char>> = Vec::with_capacity(parts.len());
        for (k, part) in parts.iter().enumerate() {
            ends.push(match parts.get(k + 1) {
                Some(Part::Literal(s)) => s.chars().next().filter(|c| *c != ' '),
                Some(Part::Bound { literal, .. }) => literal.chars().next(),
                Some(Part::Hole { .. }) => {
                    if matches!(part, Part::Hole { kinds, .. } if kinds.contains(&Kind::Word)) {
                        return Err(
                            "holds a word with a hole straight after it: a word ends at the text after it, so some text stands there"
                                .to_string(),
                        );
                    }
                    None
                }
                Some(Part::Note { .. }) | None => None,
            });
        }
        for (part, end) in parts.iter_mut().zip(ends) {
            if let Part::Hole { until, .. } = part {
                *until = end;
            }
        }
        Ok(Template {
            sheet: sheet.to_string(),
            row,
            text: text.to_string(),
            parts,
        })
    }

    /// The columns its parts name, in the template's order.
    fn columns(&self) -> impl Iterator<Item = u32> + '_ {
        self.parts.iter().filter_map(|part| match part {
            Part::Literal(_) => None,
            Part::Bound { column, .. } | Part::Hole { column, .. } | Part::Note { column, .. } => {
                Some(*column)
            }
        })
    }

    /// The text it binds a column to, if it binds that column.
    fn bound(&self, at: u32) -> Option<&str> {
        self.parts.iter().find_map(|part| match part {
            Part::Bound { column, literal } if *column == at => Some(literal.as_str()),
            _ => None,
        })
    }
}

/// What a cell holds, as a grid's record or a load's draft says it: a
/// number by its spelling.
#[derive(Clone, Debug, PartialEq)]
pub enum Held {
    Text(String),
    Number(String),
    Truth(bool),
    Error(String),
    Formula,
}

impl Held {
    /// Whether the cell holds nothing a line says: the empty text.
    fn is_empty(&self) -> bool {
        matches!(self, Held::Text(t) if t.is_empty())
    }

    /// The cell as a refusal names it.
    fn shown(&self) -> String {
        match self {
            Held::Text(t) => format!("{t:?}"),
            Held::Number(n) => n.clone(),
            Held::Truth(b) => b.to_string(),
            Held::Error(e) => e.clone(),
            Held::Formula => "a formula".to_string(),
        }
    }
}

fn shown(cell: &Option<Held>) -> String {
    cell.as_ref()
        .map_or_else(|| "nothing".to_string(), Held::shown)
}

/// A sheet a file's lines stand on: its name as the Format sheet first
/// writes it, its templates by their index, the columns they name, sorted,
/// and, where it holds more than one kind of line, the column each binds to
/// a text of its own.
#[derive(Clone, Debug)]
pub struct Tab {
    pub name: String,
    pub templates: Vec<usize>,
    pub columns: Vec<u32>,
    pub key: Option<u32>,
}

/// The Format sheet as read.
#[derive(Clone, Debug)]
pub struct Format {
    /// The file's type, a dot and letters and digits: `.pl`.
    pub kind: String,
    /// The comment's leader, or empty for a file with no comments.
    pub comment: String,
    /// The row a sheet's first line stands on.
    pub first_row: u32,
    /// Whether a line ends CR LF, else LF.
    pub crlf: bool,
    pub templates: Vec<Template>,
    /// The sheets, in the order their first lines stand on the Format sheet,
    /// which is the order they are written in.
    pub tabs: Vec<Tab>,
}

/// What is wrong on the Format sheet: the cell, and the words.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Flaw {
    pub row: u32,
    pub column: u32,
    pub what: String,
}

fn flaw(row: u32, column: u32, what: String) -> Flaw {
    Flaw { row, column, what }
}

/// A file's type as the Format sheet says one: a dot, then 1 to 15 letters
/// and digits.
pub fn is_type(text: &str) -> bool {
    text.strip_prefix('.').is_some_and(|rest| {
        (1..=15).contains(&rest.len()) && rest.bytes().all(|b| b.is_ascii_alphanumeric())
    })
}

impl Format {
    /// The Format sheet read from its cells, a row and a column from 1, or
    /// the first thing wrong on it.
    pub fn of(cell: impl Fn(u32, u32) -> Option<Held>) -> Result<Format, Flaw> {
        let value = |row: u32, column: u32| -> Result<Option<Held>, Flaw> {
            match cell(row, column) {
                Some(Held::Formula) => Err(flaw(
                    row,
                    column,
                    format!(
                        "The Format sheet's {}{row} holds a formula: a file's lines are said as values, which a file is read by before any frame computes",
                        letters(column)
                    ),
                )),
                Some(held) if held.is_empty() => Ok(None),
                other => Ok(other),
            }
        };
        let kind = match value(TYPE_ROW, 2)? {
            Some(Held::Text(t)) if is_type(&t) => t,
            other => {
                return Err(flaw(
                    TYPE_ROW,
                    2,
                    format!(
                        "The Format sheet's B{TYPE_ROW} holds {}, where the file's type belongs: a dot and then 1 to 15 letters and digits, as .txt is",
                        shown(&other)
                    ),
                ))
            }
        };
        let comment = match value(COMMENT_ROW, 2)? {
            None => String::new(),
            Some(Held::Text(t))
                if t.chars().count() <= 8 && !t.chars().any(|c| c == ' ' || c.is_control()) =>
            {
                t
            }
            other => {
                return Err(flaw(
                    COMMENT_ROW,
                    2,
                    format!(
                        "The Format sheet's B{COMMENT_ROW} holds {}, where the comment's leader belongs: one to eight characters with no space among them, as % is, or nothing for a file with no comments",
                        shown(&other)
                    ),
                ))
            }
        };
        let first_row = match value(FIRST_ROW_ROW, 2)? {
            Some(Held::Number(n)) if is_whole(&n) => n.parse::<u32>().ok(),
            _ => None,
        }
        .filter(|n| (1..=MAX_ROW).contains(n));
        let Some(first_row) = first_row else {
            return Err(flaw(
                FIRST_ROW_ROW,
                2,
                format!(
                    "The Format sheet's B{FIRST_ROW_ROW} holds {}, where the row a sheet's first line stands on belongs: a whole number from 1",
                    shown(&cell(FIRST_ROW_ROW, 2))
                ),
            ));
        };
        let crlf = match value(LINE_END_ROW, 2)? {
            None => false,
            Some(Held::Text(t)) if t.eq_ignore_ascii_case("LF") => false,
            Some(Held::Text(t)) if t.eq_ignore_ascii_case("CRLF") => true,
            other => {
                return Err(flaw(
                    LINE_END_ROW,
                    2,
                    format!(
                        "The Format sheet's B{LINE_END_ROW} holds {}, where the file's line end belongs: LF or CRLF",
                        shown(&other)
                    ),
                ))
            }
        };
        let mut templates: Vec<Template> = Vec::new();
        for row in FIRST_LINE_ROW..=LAST_ROW {
            let sheet = match value(row, 1)? {
                None => continue,
                Some(Held::Text(t)) => t,
                other => {
                    return Err(flaw(
                        row,
                        1,
                        format!(
                            "The Format sheet's A{row} holds {}, where a sheet's name belongs",
                            shown(&other)
                        ),
                    ))
                }
            };
            let text = match value(row, 2)? {
                Some(Held::Text(t)) => t,
                other => {
                    return Err(flaw(
                        row,
                        2,
                        format!(
                            "The Format sheet's B{row} holds {}, where the line of the {sheet} sheet belongs, written out with a hole a column",
                            shown(&other)
                        ),
                    ))
                }
            };
            let template = Template::parse(&sheet, row, &text, &comment).map_err(|why| {
                flaw(
                    row,
                    2,
                    format!("The Format sheet's B{row}, {text:?}, {why}"),
                )
            })?;
            templates.push(template);
        }
        if templates.is_empty() {
            return Err(flaw(
                FIRST_LINE_ROW,
                1,
                format!(
                    "The Format sheet says no line: from row {FIRST_LINE_ROW} a sheet's name stands in column A beside its line in column B"
                ),
            ));
        }
        let mut tabs: Vec<Tab> = Vec::new();
        for (k, template) in templates.iter().enumerate() {
            let at = match tabs
                .iter()
                .position(|tab| tab.name.eq_ignore_ascii_case(&template.sheet))
            {
                Some(at) => at,
                None => {
                    tabs.push(Tab {
                        name: template.sheet.clone(),
                        templates: Vec::new(),
                        columns: Vec::new(),
                        key: None,
                    });
                    tabs.len() - 1
                }
            };
            tabs[at].templates.push(k);
            for column in template.columns() {
                if !tabs[at].columns.contains(&column) {
                    tabs[at].columns.push(column);
                }
            }
        }
        for tab in &mut tabs {
            tab.columns.sort_unstable();
            if tab.templates.len() < 2 {
                continue;
            }
            // The column every line of the sheet binds, each to its own text.
            let first = &templates[tab.templates[0]];
            tab.key = first.columns().find(|column| {
                let mut said: Vec<&str> = Vec::new();
                tab.templates.iter().all(|k| {
                    templates[*k].bound(*column).is_some_and(|literal| {
                        !said.contains(&literal) && {
                            said.push(literal);
                            true
                        }
                    })
                })
            });
            if tab.key.is_none() {
                let second = &templates[tab.templates[1]];
                return Err(flaw(
                    second.row,
                    2,
                    format!(
                        "The Format sheet's B{} is another line of the {} sheet, and a sheet's lines are told apart by a column each binds to a text of its own, as {{A=reel}} and {{A=speaker}} do",
                        second.row, tab.name
                    ),
                ));
            }
        }
        Ok(Format {
            kind,
            comment,
            first_row,
            crlf,
            templates,
            tabs,
        })
    }
}

// ---- the reader --------------------------------------------------------------

/// What the reader lays in a cell.
#[derive(Clone, Debug, PartialEq)]
pub enum Laid {
    Text(String),
    Number(f64),
}

/// A line as its row: its cells by their columns, none for an empty line.
pub type Row = Vec<(u32, Laid)>;

/// Where a template stopped reading a line: the character, from 0, and what
/// it wanted there.
#[derive(Clone, Debug)]
struct Miss {
    at: usize,
    want: String,
}

fn miss(at: usize, want: impl Into<String>) -> Miss {
    Miss {
        at,
        want: want.into(),
    }
}

/// The further of two misses, the first where they tie.
fn further(a: Miss, b: Miss) -> Miss {
    if b.at > a.at {
        b
    } else {
        a
    }
}

fn skip_spaces(chars: &[char], mut i: usize) -> usize {
    while chars.get(i) == Some(&' ') {
        i += 1;
    }
    i
}

/// A whole number's cell: a number where a double holds its digits exactly
/// and writes them back the same, else its digits as a text.
fn whole_cell(digits: &str) -> Laid {
    let canonical = digits == "0" || !digits.starts_with('0');
    match digits.parse::<f64>() {
        Ok(n) if canonical && digits.len() <= 15 => Laid::Number(n),
        _ => Laid::Text(digits.to_string()),
    }
}

/// One kind read at a place: where it ends and what its cell holds.
fn take(
    kind: Kind,
    chars: &[char],
    start: usize,
    until: Option<char>,
) -> Result<(usize, Laid), Miss> {
    let mut i = start;
    match kind {
        Kind::Name => {
            if !chars.get(i).is_some_and(|c| c.is_ascii_lowercase()) {
                return Err(miss(start, kind.said()));
            }
            while chars
                .get(i)
                .is_some_and(|c| c.is_ascii_alphanumeric() || *c == '_')
            {
                i += 1;
            }
            Ok((i, Laid::Text(chars[start..i].iter().collect())))
        }
        Kind::Whole => {
            while chars.get(i).is_some_and(|c| c.is_ascii_digit()) {
                i += 1;
            }
            if i == start {
                return Err(miss(start, kind.said()));
            }
            let digits: String = chars[start..i].iter().collect();
            Ok((i, whole_cell(&digits)))
        }
        Kind::Word => {
            while chars.get(i).is_some_and(|c| *c != ' ' && Some(*c) != until) {
                i += 1;
            }
            if i == start {
                return Err(miss(start, kind.said()));
            }
            Ok((i, Laid::Text(chars[start..i].iter().collect())))
        }
        Kind::Rest => Ok((
            chars.len(),
            Laid::Text(chars[start.min(chars.len())..].iter().collect()),
        )),
        Kind::Text => {
            if chars.get(i) != Some(&'"') {
                return Err(miss(start, kind.said()));
            }
            i += 1;
            let mut text = String::new();
            loop {
                match (chars.get(i), chars.get(i + 1)) {
                    (None, _) => {
                        return Err(miss(
                            chars.len(),
                            "the quote that closes a text, on its own line",
                        ))
                    }
                    (Some('"'), _) => return Ok((i + 1, Laid::Text(text))),
                    (Some('\\'), Some('\\')) => text.push_str("\\\\"),
                    (Some('\\'), Some('"')) => text.push('"'),
                    (Some('\\'), Some('n')) => text.push_str("\\n"),
                    (Some('\\'), _) => {
                        return Err(miss(
                            i + 1,
                            "a backslash, a quote or n after a text's backslash, the escapes this reader knows",
                        ))
                    }
                    (Some(c), _) => {
                        text.push(*c);
                        i += 1;
                        continue;
                    }
                }
                i += 2;
            }
        }
    }
}

/// What the comment's column holds of a comment at a line's end: its words,
/// where it is its leader, one space and words that begin with neither; and
/// the comment as written where it is anything else, which the writer knows
/// by its leader.
fn note_cell(comment: &str, leader: &str) -> String {
    match comment
        .strip_prefix(leader)
        .and_then(|rest| rest.strip_prefix(' '))
    {
        Some(words)
            if !words.is_empty() && !words.starts_with(' ') && !words.starts_with(leader) =>
        {
            words.to_string()
        }
        _ => comment.to_string(),
    }
}

/// A template's parts from one on, read from a place of a line to its end.
fn read_parts(
    parts: &[Part],
    chars: &[char],
    mut i: usize,
    leader: &str,
    out: &mut Row,
) -> Result<(), Miss> {
    let Some((part, rest)) = parts.split_first() else {
        let end = skip_spaces(chars, i);
        return if end == chars.len() {
            Ok(())
        } else {
            Err(miss(end, "the line's end"))
        };
    };
    match part {
        Part::Literal(text) => {
            for c in text.chars() {
                if c == ' ' {
                    i = skip_spaces(chars, i);
                } else if chars.get(i) == Some(&c) {
                    i += 1;
                } else {
                    return Err(miss(i, format!("{c:?}")));
                }
            }
            read_parts(rest, chars, i, leader, out)
        }
        Part::Bound { column, literal } => {
            for c in literal.chars() {
                if chars.get(i) == Some(&c) {
                    i += 1;
                } else {
                    return Err(miss(i, format!("{literal:?}")));
                }
            }
            out.push((*column, Laid::Text(literal.clone())));
            let read = read_parts(rest, chars, i, leader, out);
            if read.is_err() {
                out.pop();
            }
            read
        }
        Part::Hole {
            column,
            kinds,
            until,
            ..
        } => {
            let mut worst: Option<Miss> = None;
            for kind in kinds {
                // The rest of a line is read as it stands, its spaces its own.
                let start = if *kind == Kind::Rest {
                    i
                } else {
                    skip_spaces(chars, i)
                };
                let tried = take(*kind, chars, start, *until).and_then(|(end, laid)| {
                    out.push((*column, laid));
                    let read = read_parts(rest, chars, skip_spaces(chars, end), leader, out);
                    if read.is_err() {
                        out.pop();
                    }
                    read
                });
                match tried {
                    Ok(()) => return Ok(()),
                    Err(m) => {
                        worst = Some(match worst {
                            Some(w) => further(w, m),
                            None => m,
                        })
                    }
                }
            }
            Err(worst.unwrap_or_else(|| miss(i, "a value")))
        }
        Part::Note { column, .. } => {
            let at = skip_spaces(chars, i);
            if at == chars.len() {
                return Ok(());
            }
            let rest_of_line: String = chars[at..].iter().collect();
            if !rest_of_line.starts_with(leader) {
                return Err(miss(
                    at,
                    format!("a comment, which begins {leader}, or the line's end"),
                ));
            }
            out.push((*column, Laid::Text(note_cell(&rest_of_line, leader))));
            Ok(())
        }
    }
}

/// A file as read: each sheet's rows from its first, in the Format sheet's
/// order, a row its cells by their columns, an empty row an empty line; and
/// whether its lines end CR LF.
#[derive(Clone, Debug, PartialEq)]
pub struct Read {
    pub tabs: Vec<Vec<Row>>,
    pub crlf: bool,
}

impl Read {
    /// Its lines, every row of every sheet.
    pub fn lines(&self) -> usize {
        self.tabs.iter().map(Vec::len).sum()
    }
}

/// A file no template reads: the line, from 1, and why.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Unread {
    pub line: usize,
    pub what: String,
}

/// A line waiting for the sheet of the line that follows it.
enum Waiting {
    Empty,
    Comment(String),
}

/// A file's text read into rows by the Format sheet's templates, a line a
/// row. A comment line and an empty line go to the sheet of the line that
/// follows them, and those after the last to its sheet, the empty lines at
/// the file's very end dropped, since no sheet holds an empty row after its
/// last. A line no template reads is refused by its number, with the
/// template that read furthest and what it wanted there.
pub fn read(format: &Format, text: &str) -> Result<Read, Unread> {
    let crlf = text
        .find('\n')
        .is_some_and(|at| at > 0 && text.as_bytes()[at - 1] == b'\r');
    let text = text.replace("\r\n", "\n");
    let mut lines: Vec<&str> = text.split('\n').collect();
    if lines.last() == Some(&"") {
        lines.pop();
    }
    let room = (MAX_ROW - format.first_row + 1) as usize;
    let mut tabs: Vec<Vec<Row>> = vec![Vec::new(); format.tabs.len()];
    let mut waiting: Vec<Waiting> = Vec::new();
    let mut last = 0;
    let settle = |tab: usize, waiting: &mut Vec<Waiting>, rows: &mut Vec<Row>| {
        let first = format.tabs[tab].columns[0];
        for line in waiting.drain(..) {
            rows.push(match line {
                Waiting::Empty => Vec::new(),
                Waiting::Comment(words) => vec![(first, Laid::Text(words))],
            });
        }
    };
    for (n, line) in lines.iter().enumerate() {
        let at = n + 1;
        if line.chars().all(|c| c == ' ' || c == '\t') {
            waiting.push(Waiting::Empty);
            continue;
        }
        if !format.comment.is_empty() && line.starts_with(&format.comment) {
            waiting.push(Waiting::Comment(line.to_string()));
            continue;
        }
        let chars: Vec<char> = line.chars().collect();
        let mut nearest: Option<(usize, Miss)> = None;
        let mut found: Option<(usize, Row)> = None;
        for (k, template) in format.templates.iter().enumerate() {
            let mut cells = Vec::new();
            match read_parts(&template.parts, &chars, 0, &format.comment, &mut cells) {
                Ok(()) => {
                    found = Some((k, cells));
                    break;
                }
                Err(m) => {
                    let nearer = match &nearest {
                        Some((_, n)) => m.at > n.at,
                        None => true,
                    };
                    if nearer {
                        nearest = Some((k, m));
                    }
                }
            }
        }
        let Some((k, cells)) = found else {
            let (k, m) = nearest.unwrap_or((0, miss(0, "a line")));
            let template = &format.templates[k];
            return Err(Unread {
                line: at,
                what: format!(
                    "line {at} is no line the Format sheet says, no comment and not empty. The nearest is the {} sheet's, {}, which reads it to its column {} and wants {} there",
                    template.sheet,
                    template.text,
                    m.at + 1,
                    m.want
                ),
            });
        };
        let tab = format
            .tabs
            .iter()
            .position(|tab| tab.templates.contains(&k))
            .unwrap_or(0);
        settle(tab, &mut waiting, &mut tabs[tab]);
        tabs[tab].push(cells);
        last = tab;
        if tabs[tab].len() > room {
            return Err(Unread {
                line: at,
                what: format!(
                    "line {at} has no row: the {} sheet's lines stand from row {} and a sheet ends at row {MAX_ROW}",
                    format.tabs[tab].name, format.first_row
                ),
            });
        }
    }
    while matches!(waiting.last(), Some(Waiting::Empty)) {
        waiting.pop();
    }
    settle(last, &mut waiting, &mut tabs[last]);
    if tabs[last].len() > room {
        return Err(Unread {
            line: lines.len(),
            what: format!(
                "the file's last lines have no row: the {} sheet's lines stand from row {} and a sheet ends at row {MAX_ROW}",
                format.tabs[last].name, format.first_row
            ),
        });
    }
    Ok(Read { tabs, crlf })
}

// ---- the writer --------------------------------------------------------------

/// A sheet's cells as a grid holds them, by row and column from 1.
pub type Cells = BTreeMap<(u32, u32), Held>;

/// Spaces to a column, from 1, and one at least: what stands past its stop is
/// followed by one space.
fn pad(text: &mut String, stop: usize) {
    let width = text.chars().count();
    for _ in 0..(stop - 1).saturating_sub(width).max(1) {
        text.push(' ');
    }
}

/// A text as a file writes it, in double quotes. The cell holds a line's
/// break as a backslash and n and a backslash twice, as the file does, and
/// both pass through; its quote is escaped. A line's break of the cell's
/// own, which a paste may bring, is written as the file writes one. And a
/// backslash before anything else is refused, since the file would say
/// another thing by it.
fn quoted(text: &str) -> Result<String, String> {
    let how = "a line's break is written \\n, and a backslash twice";
    let mut out = String::from("\"");
    let mut chars = text.chars();
    while let Some(c) = chars.next() {
        match c {
            '\\' => match chars.next() {
                Some(next @ ('\\' | 'n')) => {
                    out.push('\\');
                    out.push(next);
                }
                Some(next) => return Err(format!("a backslash stands before {next:?}: {how}")),
                None => return Err(format!("a backslash ends the text: {how}")),
            },
            '"' => out.push_str("\\\""),
            '\n' => out.push_str("\\n"),
            '\r' => {}
            c => out.push(c),
        }
    }
    out.push('"');
    Ok(out)
}

fn breaks(text: &str) -> bool {
    text.contains('\n') || text.contains('\r')
}

/// A cell's value as one of a hole's kinds writes it, the first that can.
fn spelled(kinds: &[Kind], value: &str, until: Option<char>) -> Result<String, String> {
    let mut why: Option<String> = None;
    for kind in kinds {
        let tried = match kind {
            Kind::Name if is_name(value) => Ok(value.to_string()),
            Kind::Whole if is_whole(value) => Ok(value.to_string()),
            Kind::Word
                if !value.is_empty()
                    && !breaks(value)
                    && !value.chars().any(|c| c == ' ' || Some(c) == until) =>
            {
                Ok(value.to_string())
            }
            Kind::Rest if !breaks(value) => Ok(value.to_string()),
            Kind::Rest => {
                Err("holds a line's break, and the rest of a line is one line".to_string())
            }
            Kind::Text => quoted(value).map_err(|why| format!("holds a text no line says: {why}")),
            _ => continue,
        };
        match tried {
            Ok(text) => return Ok(text),
            Err(e) => why = why.or(Some(e)),
        }
    }
    Err(why.unwrap_or_else(|| {
        if value.is_empty() {
            format!("is empty, and its line wants {}", said_all(kinds))
        } else {
            format!("holds {value:?}, which is not {}", said_all(kinds))
        }
    }))
}

/// A row no line says: its cell's column, or none for the row whole, and why.
type Unsaid = (Option<u32>, String);

/// A row's cells as the file's line, without its end: the row's cells by
/// column, each its spelling, an empty cell absent.
fn line_of(format: &Format, tab: &Tab, cells: &BTreeMap<u32, String>) -> Result<String, Unsaid> {
    if cells.is_empty() {
        return Ok(String::new());
    }
    let first = tab.columns[0];
    let leader = format.comment.as_str();
    if let Some(words) = cells.get(&first) {
        if !leader.is_empty() && words.starts_with(leader) && cells.len() == 1 {
            if breaks(words) {
                return Err((
                    Some(first),
                    "holds a comment with a line's break in it, and a comment is one line"
                        .to_string(),
                ));
            }
            return Ok(words.clone());
        }
    }
    let template = match tab.key {
        None => &format.templates[tab.templates[0]],
        Some(key) => {
            let said = cells.get(&key).map_or("", String::as_str);
            let found = tab
                .templates
                .iter()
                .map(|k| &format.templates[*k])
                .find(|t| t.bound(key) == Some(said));
            let Some(found) = found else {
                let known: Vec<&str> = tab
                    .templates
                    .iter()
                    .filter_map(|k| format.templates[*k].bound(key))
                    .collect();
                return Err((
                    Some(key),
                    if said.is_empty() {
                        format!(
                            "is empty, and it says which line of the {} sheet its row is: {}",
                            tab.name,
                            known.join(", ")
                        )
                    } else {
                        format!(
                            "holds {said:?}, which is no line of the {} sheet: its lines are {}",
                            tab.name,
                            known.join(", ")
                        )
                    },
                ));
            };
            found
        }
    };
    if let Some(stray) = cells.keys().find(|c| !template.columns().any(|t| t == **c)) {
        return Err((
            Some(*stray),
            format!(
                "holds something, and its row's line, {}, has no column {}",
                template.text,
                letters(*stray)
            ),
        ));
    }
    let cell = |column: u32| cells.get(&column).map_or("", String::as_str);
    let mut text = String::new();
    for part in &template.parts {
        match part {
            Part::Literal(s) => text.push_str(s),
            Part::Bound { literal, .. } => text.push_str(literal),
            Part::Hole {
                column,
                kinds,
                stop,
                until,
            } => {
                let written =
                    spelled(kinds, cell(*column), *until).map_err(|why| (Some(*column), why))?;
                if let Some(stop) = stop {
                    pad(&mut text, *stop);
                }
                text.push_str(&written);
            }
            Part::Note { column, stop } => {
                let words = cell(*column);
                if words.is_empty() {
                    continue;
                }
                if breaks(words) {
                    return Err((
                        Some(*column),
                        "holds a comment with a line's break in it, and a comment is one line"
                            .to_string(),
                    ));
                }
                match stop {
                    Some(stop) => pad(&mut text, *stop),
                    None => text.push(' '),
                }
                if !words.starts_with(leader) {
                    text.push_str(leader);
                    text.push(' ');
                }
                text.push_str(words);
            }
        }
    }
    Ok(text)
}

/// The sheets' rows written as the file: the sheets in the Format sheet's
/// order, each from its first row to the last that holds anything in a
/// column its lines name, a row a line, each ended as the Format sheet says.
/// `sheets` holds each sheet's cells, in the order of `format.tabs`. A row no
/// line says is refused by its cell, or by its row.
pub fn write(format: &Format, sheets: &[Cells]) -> Result<String, String> {
    let end = if format.crlf { "\r\n" } else { "\n" };
    let mut out = String::new();
    for (tab, cells) in format.tabs.iter().zip(sheets) {
        let mut rows: BTreeMap<u32, BTreeMap<u32, String>> = BTreeMap::new();
        for ((row, column), held) in cells {
            if *row < format.first_row || !tab.columns.contains(column) || held.is_empty() {
                continue;
            }
            let text = match held {
                Held::Text(t) => t.clone(),
                Held::Number(n) => n.clone(),
                Held::Truth(b) => b.to_string(),
                Held::Error(e) => {
                    return Err(format!(
                        "{}!{}{row} holds the error {e}, which no line of a file says",
                        tab.name,
                        letters(*column)
                    ))
                }
                Held::Formula => continue,
            };
            rows.entry(*row).or_default().insert(*column, text);
        }
        let Some(last) = rows.keys().next_back().copied() else {
            continue;
        };
        let none = BTreeMap::new();
        for row in format.first_row..=last {
            let text = line_of(format, tab, rows.get(&row).unwrap_or(&none)).map_err(
                |(column, why)| match column {
                    Some(column) => format!("{}!{}{row} {why}", tab.name, letters(column)),
                    None => format!("{}, row {row}: {why}", tab.name),
                },
            )?;
            out.push_str(&text);
            out.push_str(end);
        }
    }
    Ok(out)
}

#[cfg(test)]
mod tests {
    use super::*;

    /// A Format sheet from its head and its lines, as a cartridge's rows
    /// write one.
    fn sheet(kind: &str, comment: &str, lines: &[(&str, &str)]) -> Cells {
        let mut cells = BTreeMap::new();
        cells.insert((TYPE_ROW, 2), Held::Text(kind.to_string()));
        cells.insert((COMMENT_ROW, 2), Held::Text(comment.to_string()));
        cells.insert((FIRST_ROW_ROW, 2), Held::Number("2".to_string()));
        cells.insert((LINE_END_ROW, 2), Held::Text("LF".to_string()));
        for (k, (tab, line)) in lines.iter().enumerate() {
            let row = FIRST_LINE_ROW + k as u32;
            cells.insert((row, 1), Held::Text(tab.to_string()));
            cells.insert((row, 2), Held::Text(line.to_string()));
        }
        cells
    }

    fn format_of(kind: &str, comment: &str, lines: &[(&str, &str)]) -> Result<Format, Flaw> {
        let cells = sheet(kind, comment, lines);
        Format::of(|row, column| cells.get(&(row, column)).cloned())
    }

    /// Afterlife's thirteen lines, as its cartridge says them.
    pub(crate) const REEL: [(&str, &str); 13] = [
        ("Summary", "{A=reel}({B:whole}).{C:note@49}"),
        ("Summary", "{A=speaker}({B:text}).{C:note@49}"),
        ("Summary", "{A=about}({B:text}).{C:note@49}"),
        ("Summary", "{A=language}({B:name|text}).{C:note@49}"),
        ("Summary", "{A=opening}({B:name}).{C:note@49}"),
        ("Summary", "{A=generated}({B:text}).{C:note@49}"),
        ("Responses", "response({A:name}, {B:text}).{C:note@49}"),
        ("Answers", "answers({A:name},{B:text@24}).{C:note@49}"),
        (
            "Follows",
            "follow({A:name},{B:text@23},{C:name@64}).{D:note@49}",
        ),
        ("Anytime", "ask({A:text},{B:name@48}).{C:note@49}"),
        ("Tells", "tells({A:name},{B:name@20}).{C:note@49}"),
        ("Needs", "needs({A:name},{B:name@22}).{C:note@49}"),
        ("Unknown", "unknown({A:name}).{B:note@49}"),
    ];

    pub(crate) fn reel() -> Format {
        format_of(".pl", "%", &REEL).expect("Afterlife's lines read")
    }

    /// What a file's rows are in a grid: each sheet's cells from the first
    /// row, as a load lays them and a record gives them back.
    pub(crate) fn laid(format: &Format, read: &Read) -> Vec<Cells> {
        read.tabs
            .iter()
            .map(|rows| {
                let mut cells = Cells::new();
                for (i, row) in rows.iter().enumerate() {
                    for (column, cell) in row {
                        let held = match cell {
                            Laid::Text(t) => Held::Text(t.clone()),
                            Laid::Number(n) => Held::Number(format!("{n}")),
                        };
                        cells.insert((format.first_row + i as u32, *column), held);
                    }
                }
                cells
            })
            .collect()
    }

    fn round(format: &Format, text: &str) -> Result<String, String> {
        let read = read(format, text).map_err(|u| u.what)?;
        write(format, &laid(format, &read))
    }

    fn texts(row: &[(u32, Laid)]) -> Vec<String> {
        let width = row.iter().map(|(c, _)| *c).max().unwrap_or(0) as usize;
        let mut out = vec![String::new(); width];
        for (column, cell) in row {
            out[*column as usize - 1] = match cell {
                Laid::Text(t) => t.clone(),
                Laid::Number(n) => format!("{n}"),
            };
        }
        out
    }

    /// The hand's small reel of every relation (`afterlife.rs`), which the
    /// templates read into the rows the hand reads and write back as it was.
    const SMALL: &str = "% A reel of every relation.\n\
        \n\
        reel(1).\n\
        speaker(\"Ada \\\"the first\\\" Byron\").\n\
        language(en).\n\
        opening(hello).\n\
        \n\
        % response(Name, Said)\n\
        \n\
        response(hello, \"Hello.\\n\\nSit down.\").\n\
        response(slash, \"A backslash: \\\\.\").\n\
        response(unsure, \"\").\n\
        \n\
        answers(slash,         \"What is that mark?\").\n\
        \n\
        follow(hello,         \"What is that mark?\",                    slash).\n\
        follow(hello,         \"What is that mark, and where does it come from?\", slash).\n\
        \n\
        ask(\"What is that mark?\",                      slash).\n\
        \n\
        tells(slash,       the_mark).                   % \"A backslash\"\n\
        needs(hello,         the_mark).                 %% kept as written\n\
        \n\
        unknown(unsure).\n\
        % The end.\n";

    #[test]
    fn the_templates_read_a_reel_as_the_hand_reads_it() {
        let format = reel();
        let by_templates = read(&format, SMALL).expect("the templates read it");
        let by_hand = crate::afterlife::read(SMALL).expect("the hand reads it");
        assert_eq!(by_templates.lines(), by_hand.lines());
        for (t, (rows, hand)) in by_templates.tabs.iter().zip(&by_hand.tabs).enumerate() {
            let rows: Vec<Vec<String>> = rows.iter().map(|row| texts(row)).collect();
            assert_eq!(&rows, hand, "{}'s rows", format.tabs[t].name);
        }
        // The format's whole number is a number in its cell, and no other is.
        assert_eq!(
            by_templates.tabs[0][2],
            [(1, Laid::Text("reel".to_string())), (2, Laid::Number(1.0))]
        );
        assert_eq!(round(&format, SMALL).as_deref(), Ok(SMALL));
    }

    #[test]
    fn a_reel_whose_relations_are_interleaved_comes_back_a_sheet_at_a_time() {
        let format = reel();
        let mixed = "response(hello, \"Hello.\").\n\
            % what leads there\n\
            answers(hello, \"Hello?\").\n\
            opening(hello).\n\
            response(bye,\"Goodbye.\")  .\n";
        // a period apart from its parenthesis is no fact, as the hand refuses it
        assert!(round(&format, mixed).is_err());
        let mixed = mixed.replace("  .", ".") + "language(\"en\").\nlanguage(\"en-US\").\n\n\n";
        let written = round(&format, &mixed).expect("reads and writes");
        assert_eq!(
            written,
            "opening(hello).\n\
             language(en).\n\
             language(\"en-US\").\n\
             response(hello, \"Hello.\").\n\
             response(bye, \"Goodbye.\").\n\
             % what leads there\n\
             answers(hello,         \"Hello?\").\n"
        );
        assert_eq!(
            written,
            crate::afterlife::write(&crate::afterlife::read(&mixed).expect("the hand reads"))
                .expect("the hand writes"),
            "as the hand writes it"
        );
        assert_eq!(round(&format, &written).as_deref(), Ok(written.as_str()));
    }

    /// Every line the hand refuses, the templates refuse, by its number.
    #[test]
    fn what_no_template_reads_is_refused_by_its_line() {
        let format = reel();
        for text in [
            "  response(a, \"b\").\n",
            "a :- b.\n",
            "\n\nplays(a).\n",
            "response(a).\n",
            "response(A, \"b\").\n",
            "response('a b', \"b\").\n",
            "response(a, b).\n",
            "reel(one).\n",
            "response(a, \"b\\t\").\n",
            "response(a, \"b).\n",
            "response(a, \"b\") .\n",
            "response(a, \"b\"). and more\n",
            "response(a, \"b\"\"c\").\n",
        ] {
            assert!(crate::afterlife::read(text).is_err(), "the hand: {text:?}");
            let refused = read(&format, text).expect_err(text);
            let line = text.matches('\n').count();
            assert_eq!(refused.line, line, "{text:?}");
            assert!(
                refused.what.starts_with(&format!("line {line} is no line")),
                "{}",
                refused.what
            );
        }
        // The nearest template is named, with where it stopped and what it wanted.
        let refused = read(&format, "response(a, b).\n").expect_err("a bare second argument");
        assert_eq!(
            refused.what,
            "line 1 is no line the Format sheet says, no comment and not empty. The nearest is the Responses sheet's, response({A:name}, {B:text}).{C:note@49}, which reads it to its column 13 and wants a text in double quotes there"
        );
        let refused = read(&format, "response(a, \"b\\t\").\n").expect_err("an escape");
        assert!(
            refused.what.ends_with(
                "reads it to its column 16 and wants a backslash, a quote or n after a text's backslash, the escapes this reader knows there"
            ),
            "{}",
            refused.what
        );
    }

    fn row(format: &Format, tab: usize, cells: &[&str]) -> Result<String, String> {
        let mut sheets = vec![Cells::new(); format.tabs.len()];
        for (k, cell) in cells.iter().enumerate() {
            if !cell.is_empty() {
                sheets[tab].insert((3, k as u32 + 1), Held::Text(cell.to_string()));
            }
        }
        write(format, &sheets)
    }

    #[test]
    fn a_row_is_its_line_and_what_no_line_says_is_refused_by_its_cell() {
        let f = reel();
        // a comment at column 49, and an ask's second argument at 48
        let (to_49, to_48) = (" ".repeat(22), " ".repeat(30));
        for (tab, cells, line) in [
            (
                1,
                &["hello", "Hello."][..],
                "response(hello, \"Hello.\").".to_string(),
            ),
            (1, &["hello"][..], "response(hello, \"\").".to_string()),
            (
                1,
                &["hello", "Hello.", "% as written"][..],
                format!("response(hello, \"Hello.\").{to_49}% as written"),
            ),
            (
                1,
                &["hello", "Hello.", "a note"][..],
                format!("response(hello, \"Hello.\").{to_49}% a note"),
            ),
            (
                1,
                &["hello", "He said \"sit\".\\n\\nA backslash: \\\\."][..],
                "response(hello, \"He said \\\"sit\\\".\\n\\nA backslash: \\\\.\").".to_string(),
            ),
            (
                1,
                &["hello", "One.\r\n\r\nTwo."][..],
                "response(hello, \"One.\\n\\nTwo.\").".to_string(),
            ),
            // a text may begin as a comment does, where its row holds more than it
            (
                4,
                &["% of what?", "hello"][..],
                format!("ask(\"% of what?\",{to_48}hello)."),
            ),
            (4, &["% a comment"][..], "% a comment".to_string()),
        ] {
            let line = format!("\n{line}\n");
            assert_eq!(
                row(&f, tab, cells).as_deref(),
                Ok(line.as_str()),
                "{cells:?}"
            );
            assert_eq!(
                crate::afterlife::read(&line).map(|reel| reel.lines()),
                Ok(2),
                "the hand reads it: {line:?}"
            );
        }
        for (tab, cells, why) in [
            (
                1,
                &["hello", "C:\\temp"][..],
                "Responses!B3 holds a text no line says: a backslash stands before 't': a line's break is written \\n, and a backslash twice",
            ),
            (
                1,
                &["hello", "ends with \\"][..],
                "Responses!B3 holds a text no line says: a backslash ends the text",
            ),
            (
                1,
                &["Hello", "Hello."][..],
                "Responses!A3 holds \"Hello\", which is not a name, a lowercase letter and then letters, digits and underscores",
            ),
            (
                1,
                &["", "Hello."][..],
                "Responses!A3 is empty, and its line wants a name",
            ),
            (
                1,
                &["% a note", "Hello."][..],
                "Responses!A3 holds \"% a note\", which is not a name",
            ),
            (
                1,
                &["hello", "Hello.", "two\nlines"][..],
                "Responses!C3 holds a comment with a line's break in it",
            ),
            (
                0,
                &["plays", "x"][..],
                "Summary!A3 holds \"plays\", which is no line of the Summary sheet: its lines are reel, speaker, about, language, opening, generated",
            ),
            (
                0,
                &["", "x"][..],
                "Summary!A3 is empty, and it says which line of the Summary sheet its row is",
            ),
            (
                0,
                &["reel", "one"][..],
                "Summary!B3 holds \"one\", which is not a whole number",
            ),
            (
                3,
                &["hello", "A line?"][..],
                "Follows!C3 is empty, and its line wants a name",
            ),
        ] {
            let refused = row(&f, tab, cells).expect_err(why);
            assert!(refused.starts_with(why), "{refused}");
        }
        // A cell beside a sheet's columns is the sheet's own, and no line's.
        let mut sheets = vec![Cells::new(); f.tabs.len()];
        sheets[1].insert((2, 1), Held::Text("hello".to_string()));
        sheets[1].insert((2, 5), Held::Text("a count of its words".to_string()));
        sheets[1].insert((9, 5), Held::Number("7".to_string()));
        sheets[1].insert((1, 1), Held::Text("Name".to_string()));
        assert_eq!(
            write(&f, &sheets).as_deref(),
            Ok("response(hello, \"\").\n")
        );
        // An error in a line's cell is refused, and a number is its digits.
        sheets[1].insert((2, 2), Held::Number("42".to_string()));
        assert_eq!(
            write(&f, &sheets).as_deref(),
            Ok("response(hello, \"42\").\n")
        );
        sheets[1].insert((2, 2), Held::Error("#N/A".to_string()));
        assert_eq!(
            write(&f, &sheets).unwrap_err(),
            "Responses!B2 holds the error #N/A, which no line of a file says"
        );
    }

    /// Three files that are not a reel, each by a line or two.
    #[test]
    fn a_template_reaches_files_that_are_no_reel() {
        // A file of settings: a word, an equals sign, the rest.
        let env = format_of(".env", "#", &[("Settings", "{A:word}={B:rest}")]).expect("reads");
        let text = "# the service\nPORT=8080\nNAME=a b = c\nEMPTY=\n\nPATH=C:\\bin\n";
        let read_env = read(&env, text).expect("reads");
        assert_eq!(
            texts(&read_env.tabs[0][2]),
            ["NAME", "a b = c"],
            "a word ends at the template's next character, and the rest holds its own"
        );
        assert_eq!(texts(&read_env.tabs[0][3]), ["EMPTY", ""]);
        assert_eq!(round(&env, text).as_deref(), Ok(text));
        // Written loosely, it is read, and written one way.
        assert_eq!(
            round(&env, "  PORT =8080\n   \nNAME=x\n").as_deref(),
            Ok("PORT=8080\n\nNAME=x\n")
        );
        // A number where the file writes one, and a text beside it, in one hole.
        let typed =
            format_of(".env", "#", &[("Settings", "{A:word}={B:whole|rest}")]).expect("reads");
        let read_typed = read(
            &typed,
            "PORT=8080\nZIP=00501\nBIG=12345678901234567890\nNAME=x1\n",
        )
        .expect("reads");
        assert_eq!(read_typed.tabs[0][0][1], (2, Laid::Number(8080.0)));
        assert_eq!(
            read_typed.tabs[0][1][1],
            (2, Laid::Text("00501".to_string())),
            "digits a number would write otherwise stay a text"
        );
        assert_eq!(
            read_typed.tabs[0][2][1],
            (2, Laid::Text("12345678901234567890".to_string()))
        );
        assert_eq!(read_typed.tabs[0][3][1], (2, Laid::Text("x1".to_string())));
        assert_eq!(
            write(&typed, &laid(&typed, &read_typed)).as_deref(),
            Ok("PORT=8080\nZIP=00501\nBIG=12345678901234567890\nNAME=x1\n")
        );
        // Facts for a solver, two sheets, and a line with braces of its own.
        let facts = format_of(
            ".lp",
            "%",
            &[
                ("Edges", "edge({A:name},{B:name})."),
                ("Sets", "set({A:name}, {{{B:whole}}})."),
            ],
        )
        .expect("reads");
        let text = "edge(a,b).\nset(s, {3}).\nedge(b,c).\n";
        assert_eq!(
            round(&facts, text).as_deref(),
            Ok("edge(a,b).\nedge(b,c).\nset(s, {3}).\n")
        );
        // A hosts file: two words, the second the rest; its line ends kept.
        let hosts = format_of(".txt", "#", &[("Hosts", "{A:word} {B:rest}")]).expect("reads");
        let text = "127.0.0.1    localhost\r\n::1 ip6 loop\r\n";
        let read_hosts = read(&hosts, text).expect("reads");
        assert!(read_hosts.crlf);
        assert_eq!(texts(&read_hosts.tabs[0][1]), ["::1", "ip6 loop"]);
        let mut crlf = hosts.clone();
        crlf.crlf = true;
        assert_eq!(
            write(&crlf, &laid(&crlf, &read_hosts)).as_deref(),
            Ok("127.0.0.1 localhost\r\n::1 ip6 loop\r\n")
        );
        // A word may not hold what would end it, nor a space.
        let mut sheets = vec![Cells::new()];
        sheets[0].insert((2, 1), Held::Text("A=B".to_string()));
        assert_eq!(
            write(&env, &sheets).unwrap_err(),
            "Settings!A2 holds \"A=B\", which is not a word, with no space in it"
        );
    }

    #[test]
    fn a_format_sheet_is_refused_by_its_cell() {
        let one = |line: &str| format_of(".pl", "%", &[("Facts", line)]).map(|_| ());
        for (line, why) in [
            ("fact({A:nam}).", "which names the kind \"nam\""),
            ("fact({1:name}).", "which names no column"),
            ("fact({A}).", "which says neither a kind"),
            ("fact({A=}).", "which binds its column to no text"),
            ("fact({A:name@0}).", "whose stop is no column of a line"),
            ("fact({A:name@x}).", "whose stop is no column of a line"),
            ("fact({A:name|name}).", "which names the kind name twice"),
            ("fact({A:name|note}).", "where note shares a hole"),
            ("fact({A:name}, {A:text}).", "names column A twice"),
            (
                "fact({A:note}, {B:name}).",
                "holds its comment's hole before its end",
            ),
            (
                "fact({A:rest}).",
                "holds a hole of the rest of the line before its end",
            ),
            (
                "fact({A:word}{B:name}).",
                "holds a word with a hole straight after it",
            ),
            ("fact(a).", "holds no hole"),
            ("fact({A:name).}", "which names the kind \"name).\""),
            ("fact({A:name", "holds a hole that is not closed"),
            (
                "fact(}{A:name}).",
                "holds a closing brace that closes no hole",
            ),
            ("%fact({A:name}).", "begins with %, the comment's leader"),
        ] {
            let refused = one(line).expect_err(line);
            assert_eq!((refused.row, refused.column), (6, 2), "{line}");
            assert!(
                refused
                    .what
                    .starts_with(&format!("The Format sheet's B6, {line:?}, "))
                    && refused.what.contains(why),
                "{line}: {}",
                refused.what
            );
        }
        assert!(
            format_of(".pl", "", &[("Facts", "fact({A:name}).{B:note}")])
                .expect_err("a note with no leader")
                .what
                .contains("says no comment's leader")
        );
        // The head.
        let head = |change: &dyn Fn(&mut Cells)| {
            let mut cells = sheet(".pl", "%", &[("Facts", "fact({A:name}).")]);
            change(&mut cells);
            Format::of(|row, column| cells.get(&(row, column)).cloned())
                .map(|_| ())
                .map_err(|f| (f.row, f.column, f.what))
        };
        assert_eq!(head(&|_| ()), Ok(()));
        let refused = head(&|c| {
            c.insert((TYPE_ROW, 2), Held::Text("pl".to_string()));
        })
        .expect_err("a type with no dot");
        assert_eq!((refused.0, refused.1), (1, 2));
        assert!(refused
            .2
            .starts_with("The Format sheet's B1 holds \"pl\", where the file's type belongs"));
        let refused = head(&|c| {
            c.insert((COMMENT_ROW, 2), Held::Text("% %".to_string()));
        })
        .expect_err("a leader with a space");
        assert_eq!((refused.0, refused.1), (2, 2));
        let refused = head(&|c| {
            c.insert((FIRST_ROW_ROW, 2), Held::Number("1.5".to_string()));
        })
        .expect_err("half a row");
        assert_eq!((refused.0, refused.1), (3, 2));
        assert!(refused
            .2
            .starts_with("The Format sheet's B3 holds 1.5, where the row"));
        let refused = head(&|c| {
            c.insert((LINE_END_ROW, 2), Held::Text("CR".to_string()));
        })
        .expect_err("a line end of neither kind");
        assert_eq!((refused.0, refused.1), (4, 2));
        assert_eq!(
            head(&|c| {
                c.remove(&(LINE_END_ROW, 2));
                c.remove(&(COMMENT_ROW, 2));
            }),
            Ok(()),
            "a line end left out is LF, and a file may have no comments"
        );
        let refused = head(&|c| {
            c.insert((7, 2), Held::Formula);
            c.insert((7, 1), Held::Text("Facts".to_string()));
        })
        .expect_err("a formula");
        assert_eq!((refused.0, refused.1), (7, 2));
        assert!(refused
            .2
            .starts_with("The Format sheet's B7 holds a formula"));
        let refused = head(&|c| {
            c.insert((6, 2), Held::Number("7".to_string()));
        })
        .expect_err("a number for a line");
        assert!(refused.2.starts_with(
            "The Format sheet's B6 holds 7, where the line of the Facts sheet belongs"
        ));
        let refused = head(&|c| {
            c.remove(&(6, 1));
        })
        .expect_err("no line");
        assert!(refused.2.starts_with("The Format sheet says no line"));
        // A sheet's lines are told apart by a column each binds.
        let two = format_of(
            ".pl",
            "%",
            &[("Pets", "cat({A:name})."), ("pets", "dog({A:name}).")],
        )
        .expect_err("two lines nothing tells apart");
        assert_eq!((two.row, two.column), (7, 2));
        assert!(two.what.starts_with(
            "The Format sheet's B7 is another line of the Pets sheet, and a sheet's lines are told apart"
        ));
        let same = format_of(
            ".pl",
            "%",
            &[
                ("Pets", "{A=cat}({B:name})."),
                ("Pets", "{A=cat}({B:name}, {C:whole})."),
            ],
        );
        assert!(same.is_err(), "the same text twice tells nothing apart");
        let told = format_of(
            ".pl",
            "%",
            &[
                ("Pets", "{A=cat}({B:name})."),
                ("Pets", "{A=dog}({B:name}, {C:whole})."),
            ],
        )
        .expect("told apart");
        assert_eq!(told.tabs[0].key, Some(1));
        assert_eq!(told.tabs[0].columns, [1, 2, 3]);
        // A cat's row holds no third column.
        let mut sheets = vec![Cells::new()];
        for (column, text) in [(1, "cat"), (2, "tom"), (3, "9")] {
            sheets[0].insert((2, column), Held::Text(text.to_string()));
        }
        assert_eq!(
            write(&told, &sheets).unwrap_err(),
            "Pets!C2 holds something, and its row's line, {A=cat}({B:name})., has no column C"
        );
    }
}

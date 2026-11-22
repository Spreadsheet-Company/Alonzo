//! Afterlife's sheet by hand (`CART.16`; `docs/REARVIEW.md`): a reel's facts
//! read into the rows of eight tabs, and the tabs' rows written back as the
//! file they were read from, compiled for the tests alone; the door at the
//! command line, `examples/afterlife.rs`, includes the same file by its path.
//!
//! A reel is Afterlife's: one person's recorded answers and the lines that
//! lead from one to the next, written as ground Prolog facts in one file,
//! thirteen relations of one to three arguments. The mapping is the owner's
//! (2026-11-21). A tab is a relation; the six facts of one argument share
//! the Summary, whose first column names the relation. A column is an
//! argument, and every tab has one column more, its last, for the comment at
//! a line's end. A row is a line: an empty row an empty line, and a row whose
//! first cell starts with a percent sign a comment line. Row 1 of a tab
//! holds its headers, which no file holds, so a line of the file is a row
//! from 2. And the writer aligns each relation's arguments as the file does,
//! at the stops below, which write Walter Alder's reel back byte for byte.
//!
//! A text's cell holds its words as the file writes them between its quotes,
//! but for a quote, which the cell holds plain: a line's break is the two
//! characters `\n` and a backslash is written twice, in the cell as in the
//! file. So a paragraph's break is seen in a cell and can be typed into one,
//! where a line's break of the cell's own would be drawn as nothing; and no
//! cell of the cartridge holds one, which a source's pass at the command
//! line and in the page write with different line ends.
//!
//! Three things the writer says in one way, whatever the file said. A reel
//! whose relations stand interleaved comes back a relation a tab, each
//! relation's lines in their order, the comments and the empty lines before
//! a fact going with it. A language's tag is written bare where it is an
//! atom, as Walter's is, and in quotes elsewhere. And a fact's line ends at
//! its period or its comment, with no space after.
//!
//! Nothing here judges a reel: a name that no response has and a line that
//! leads nowhere are Afterlife's compiler's to say. What is refused is what
//! no tab can hold or no file can say, by the line or by the tab and the
//! row: a line that is no fact, comment or empty line; a relation that is no
//! reel's; an escape the reader does not know; a name that is no name.

use vla_lang::form::Form;
use vla_lang::printer::write_datum;
use vla_lang::reader::read_forms;

/// What an argument is, which says how the file writes it.
#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum Kind {
    /// A name, a response's or a thing's: a lowercase letter, then lowercase
    /// letters, digits and underscores, forty at most, written bare.
    Name,
    /// A text, written in double quotes.
    Text,
    /// A whole number, written bare: the format's.
    Whole,
    /// A language's tag, which a file writes bare or in quotes.
    Tag,
}

/// A relation: its name, its arguments in order, and the column, from 1, at
/// which each argument after the first starts where the file aligns it. A
/// relation with no stop writes one space after its comma.
pub struct Relation {
    pub name: &'static str,
    pub kinds: &'static [Kind],
    pub stops: &'static [usize],
}

/// A tab: its name, its headers, the last of them the comment's, and the
/// relations whose facts it holds.
pub struct Tab {
    pub name: &'static str,
    pub headers: &'static [&'static str],
    pub relations: &'static [Relation],
}

impl Tab {
    /// The Summary holds six relations and names each row's in its first
    /// column; every other tab is one relation's.
    pub fn names_its_relation(&self) -> bool {
        self.relations.len() > 1
    }

    /// The column of a line's own comment, from 0: the tab's last.
    pub fn comment(&self) -> usize {
        self.headers.len() - 1
    }
}

/// The column, from 1, at which the comment at a line's end starts.
pub const COMMENT_STOP: usize = 49;

/// The eight tabs in the file's order, which is the writer's.
pub const TABS: [Tab; 8] = [
    Tab {
        name: "Summary",
        headers: &["Fact", "Value", "Comment"],
        relations: &[
            Relation {
                name: "reel",
                kinds: &[Kind::Whole],
                stops: &[],
            },
            Relation {
                name: "speaker",
                kinds: &[Kind::Text],
                stops: &[],
            },
            Relation {
                name: "about",
                kinds: &[Kind::Text],
                stops: &[],
            },
            Relation {
                name: "language",
                kinds: &[Kind::Tag],
                stops: &[],
            },
            Relation {
                name: "opening",
                kinds: &[Kind::Name],
                stops: &[],
            },
            Relation {
                name: "generated",
                kinds: &[Kind::Text],
                stops: &[],
            },
        ],
    },
    Tab {
        name: "Responses",
        headers: &["File Name", "Said", "Comment"],
        relations: &[Relation {
            name: "response",
            kinds: &[Kind::Name, Kind::Text],
            stops: &[],
        }],
    },
    Tab {
        name: "Answers",
        headers: &["File Name", "Question", "Comment"],
        relations: &[Relation {
            name: "answers",
            kinds: &[Kind::Name, Kind::Text],
            stops: &[24],
        }],
    },
    Tab {
        name: "Follows",
        headers: &["From", "Asked", "To", "Comment"],
        relations: &[Relation {
            name: "follow",
            kinds: &[Kind::Name, Kind::Text, Kind::Name],
            stops: &[23, 64],
        }],
    },
    Tab {
        name: "Anytime",
        headers: &["Asked", "To", "Comment"],
        relations: &[Relation {
            name: "ask",
            kinds: &[Kind::Text, Kind::Name],
            stops: &[48],
        }],
    },
    Tab {
        name: "Tells",
        headers: &["Name", "Thing", "Comment"],
        relations: &[Relation {
            name: "tells",
            kinds: &[Kind::Name, Kind::Name],
            stops: &[20],
        }],
    },
    Tab {
        name: "Needs",
        headers: &["Name", "Thing", "Comment"],
        relations: &[Relation {
            name: "needs",
            kinds: &[Kind::Name, Kind::Name],
            stops: &[22],
        }],
    },
    Tab {
        name: "Unknown",
        headers: &["Name", "Comment"],
        relations: &[Relation {
            name: "unknown",
            kinds: &[Kind::Name],
            stops: &[],
        }],
    },
];

/// A row: its cells' texts from column A, an empty text an empty cell.
pub type Row = Vec<String>;

/// A reel as the tabs hold it: each tab's rows from row 2, in order.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Reel {
    pub tabs: Vec<Vec<Row>>,
}

impl Reel {
    /// A reel of no line.
    pub fn empty() -> Reel {
        Reel {
            tabs: vec![Vec::new(); TABS.len()],
        }
    }

    /// Its lines, every row of every tab.
    pub fn lines(&self) -> usize {
        self.tabs.iter().map(Vec::len).sum()
    }

    /// Its facts, the rows that are neither empty nor a comment's.
    pub fn facts(&self) -> usize {
        self.tabs
            .iter()
            .flatten()
            .filter(|row| {
                held(row)
                    .first()
                    .is_some_and(|first| !first.starts_with('%'))
            })
            .count()
    }
}

/// A row's cells to the last that holds anything.
fn held(row: &[String]) -> &[String] {
    let last = row
        .iter()
        .rposition(|cell| !cell.is_empty())
        .map_or(0, |i| i + 1);
    &row[..last]
}

/// A name, as Afterlife's reader takes one.
pub fn is_name(text: &str) -> bool {
    let mut chars = text.chars();
    chars.next().is_some_and(|c| c.is_ascii_lowercase())
        && chars.all(|c| c.is_ascii_lowercase() || c.is_ascii_digit() || c == '_')
        && text.len() <= 40
}

/// A text a file writes bare and Prolog reads as an atom.
fn is_atom(text: &str) -> bool {
    let mut chars = text.chars();
    chars.next().is_some_and(|c| c.is_ascii_lowercase())
        && chars.all(|c| c.is_ascii_alphanumeric() || c == '_')
}

/// The tab and the relation of a relation's name.
fn relation(name: &str) -> Option<(usize, &'static Tab, &'static Relation)> {
    TABS.iter().enumerate().find_map(|(t, tab)| {
        tab.relations
            .iter()
            .find(|r| r.name == name)
            .map(|r| (t, tab, r))
    })
}

// ---- the reader --------------------------------------------------------------

/// An argument as a line writes it: its text as a cell holds it, a quote
/// plain and a line's break and a backslash as the file writes them, and
/// whether it stood in quotes.
struct Written {
    text: String,
    quoted: bool,
}

/// A fact's line taken apart: the relation's name, its arguments, and the
/// comment after its period, from its percent sign.
fn fact(line: &str) -> Result<(String, Vec<Written>, Option<String>), String> {
    let chars: Vec<char> = line.chars().collect();
    let mut i = 0;
    while chars
        .get(i)
        .is_some_and(|c| c.is_ascii_lowercase() || c.is_ascii_digit() || *c == '_')
    {
        i += 1;
    }
    if i == 0 || !chars[0].is_ascii_lowercase() || chars.get(i) != Some(&'(') {
        return Err("the line is no fact, no comment and not empty".to_string());
    }
    let name: String = chars[..i].iter().collect();
    i += 1;
    let mut written = Vec::new();
    loop {
        while chars.get(i) == Some(&' ') {
            i += 1;
        }
        if chars.get(i) == Some(&'"') {
            i += 1;
            let mut text = String::new();
            loop {
                match (chars.get(i), chars.get(i + 1)) {
                    (None, _) => {
                        return Err("a text's quotes are not closed on its line".to_string())
                    }
                    (Some('"'), _) => {
                        i += 1;
                        break;
                    }
                    (Some('\\'), Some('\\')) => text.push_str("\\\\"),
                    (Some('\\'), Some('"')) => text.push('"'),
                    (Some('\\'), Some('n')) => text.push_str("\\n"),
                    (Some('\\'), other) => {
                        let after =
                            other.map_or("the line's end".to_string(), |c| format!("{c:?}"));
                        return Err(format!(
                            "a backslash before {after} is an escape this reader does not know: \
                             it knows a backslash, a quote and n, a line's break"
                        ));
                    }
                    (Some(c), _) => {
                        text.push(*c);
                        i += 1;
                        continue;
                    }
                }
                i += 2;
            }
            written.push(Written { text, quoted: true });
        } else {
            let start = i;
            while chars.get(i).is_some_and(|c| *c != ',' && *c != ')') {
                i += 1;
            }
            let text: String = chars[start..i].iter().collect();
            let text = text.trim_end_matches(' ').to_string();
            if text.is_empty() {
                return Err("an argument is missing".to_string());
            }
            written.push(Written {
                text,
                quoted: false,
            });
        }
        while chars.get(i) == Some(&' ') {
            i += 1;
        }
        match chars.get(i) {
            Some(',') => i += 1,
            Some(')') => {
                i += 1;
                break;
            }
            _ => {
                return Err(
                    "an argument is followed by a comma or by the closing parenthesis".to_string(),
                )
            }
        }
    }
    if chars.get(i) != Some(&'.') {
        return Err("a fact ends with a period after its parenthesis".to_string());
    }
    let rest: String = chars[i + 1..].iter().collect();
    let rest = rest.trim_start_matches(' ');
    if rest.is_empty() {
        Ok((name, written, None))
    } else if rest.starts_with('%') {
        Ok((name, written, Some(rest.to_string())))
    } else {
        Err("after a fact's period stands a comment or nothing".to_string())
    }
}

/// What the comment's column holds of a comment at a line's end: its words,
/// where it is a percent sign, one space and words that begin with neither;
/// and the comment as written where it is anything else, which the writer
/// knows by its percent sign.
fn comment_cell(comment: &str) -> String {
    match comment.strip_prefix("% ") {
        Some(words) if !words.is_empty() && !words.starts_with(' ') && !words.starts_with('%') => {
            words.to_string()
        }
        _ => comment.to_string(),
    }
}

/// A reel's file read into the tabs' rows, a line a row. A comment and an
/// empty line go to the tab of the fact that follows them, and those after
/// the last fact to its tab, the empty lines at the file's very end dropped,
/// since no sheet holds an empty row after its last.
pub fn read(text: &str) -> Result<Reel, String> {
    let text = text.replace("\r\n", "\n");
    let mut lines: Vec<&str> = text.split('\n').collect();
    if lines.last() == Some(&"") {
        lines.pop();
    }
    let mut reel = Reel::empty();
    let mut waiting: Vec<Row> = Vec::new();
    let mut last = 0;
    for (n, line) in lines.iter().enumerate() {
        let at = n + 1;
        if line.is_empty() {
            waiting.push(Row::new());
            continue;
        }
        if line.starts_with('%') {
            waiting.push(vec![line.to_string()]);
            continue;
        }
        let (name, written, comment) = fact(line).map_err(|why| format!("line {at}: {why}"))?;
        let Some((t, tab, relation)) = relation(&name) else {
            return Err(format!("line {at}: {name} is no relation of a reel's"));
        };
        if written.len() != relation.kinds.len() {
            return Err(format!(
                "line {at}: {name} takes {} and the line gives {}",
                counted(relation.kinds.len()),
                written.len()
            ));
        }
        let mut row = Row::new();
        if tab.names_its_relation() {
            row.push(name.clone());
        }
        for (k, (argument, kind)) in written.iter().zip(relation.kinds).enumerate() {
            let fits = match kind {
                Kind::Name => !argument.quoted && is_name(&argument.text),
                Kind::Text => argument.quoted,
                Kind::Whole => {
                    !argument.quoted && argument.text.chars().all(|c| c.is_ascii_digit())
                }
                Kind::Tag => argument.quoted || is_atom(&argument.text),
            };
            if !fits {
                return Err(format!(
                    "line {at}: {name}'s {} is {}, and the line writes {}",
                    ordinal(k),
                    said(*kind),
                    if argument.quoted {
                        format!("{:?}", argument.text)
                    } else {
                        argument.text.clone()
                    }
                ));
            }
            row.push(argument.text.clone());
        }
        if let Some(comment) = comment {
            row.resize(tab.comment(), String::new());
            row.push(comment_cell(&comment));
        }
        reel.tabs[t].append(&mut waiting);
        reel.tabs[t].push(row);
        last = t;
    }
    while waiting.last().is_some_and(|row| row.is_empty()) {
        waiting.pop();
    }
    reel.tabs[last].append(&mut waiting);
    Ok(reel)
}

fn counted(n: usize) -> String {
    match n {
        1 => "one argument".to_string(),
        2 => "two arguments".to_string(),
        _ => format!("{n} arguments"),
    }
}

fn ordinal(k: usize) -> &'static str {
    ["first argument", "second argument", "third argument"][k]
}

fn said(kind: Kind) -> &'static str {
    match kind {
        Kind::Name => "a name, a lowercase letter and then lowercase letters, digits and underscores, forty at most",
        Kind::Text => "a text in double quotes",
        Kind::Whole => "a whole number",
        Kind::Tag => "a language's tag",
    }
}

// ---- the writer --------------------------------------------------------------

/// Spaces to a column, from 1, and one at least: what stands past its stop is
/// followed by one space.
fn pad(text: &mut String, stop: usize) {
    let width = text.chars().count();
    for _ in 0..(stop - 1).saturating_sub(width).max(1) {
        text.push(' ');
    }
}

/// A text as a fact writes it, in double quotes. The cell holds a line's
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
                None => return Err(format!("a backslash ends a text: {how}")),
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

/// A row as the file's line, without its end.
fn line(tab: &Tab, row: &[String]) -> Result<String, String> {
    let cells = held(row);
    let Some(first) = cells.first() else {
        return Ok(String::new());
    };
    if first.starts_with('%') {
        if cells.len() > 1 {
            return Err(
                "a comment's row holds its words in its first cell, and this one holds more"
                    .to_string(),
            );
        }
        if first.contains('\n') {
            return Err("a comment is one line, and this one holds a line's break".to_string());
        }
        return Ok(first.clone());
    }
    if cells.len() > tab.headers.len() {
        return Err(format!(
            "a cell stands past the tab's last column, {}",
            tab.headers[tab.comment()]
        ));
    }
    let cell = |k: usize| cells.get(k).map_or("", String::as_str);
    let (relation, from) = if tab.names_its_relation() {
        let Some(relation) = tab.relations.iter().find(|r| r.name == first.as_str()) else {
            let known: Vec<&str> = tab.relations.iter().map(|r| r.name).collect();
            return Err(format!(
                "{first:?} is no fact of the {}'s, which are {}",
                tab.name,
                known.join(", ")
            ));
        };
        (relation, 1)
    } else {
        (&tab.relations[0], 0)
    };
    let mut text = format!("{}(", relation.name);
    for (k, kind) in relation.kinds.iter().enumerate() {
        let value = cell(from + k);
        let header = tab.headers[from + k];
        let written = match kind {
            Kind::Name if is_name(value) => value.to_string(),
            Kind::Whole if !value.is_empty() && value.chars().all(|c| c.is_ascii_digit()) => {
                value.to_string()
            }
            Kind::Tag if is_atom(value) => value.to_string(),
            Kind::Tag if !value.is_empty() => quoted(value)?,
            Kind::Text => quoted(value)?,
            _ if value.is_empty() => {
                return Err(format!(
                    "its {header} is empty, and {} wants {}",
                    relation.name,
                    said(*kind)
                ))
            }
            _ => return Err(format!("its {header}, {value:?}, is not {}", said(*kind))),
        };
        if k > 0 {
            text.push(',');
            match relation.stops.get(k - 1) {
                Some(stop) => pad(&mut text, *stop),
                None => text.push(' '),
            }
        }
        text.push_str(&written);
    }
    text.push_str(").");
    let comment = cell(tab.comment());
    if !comment.is_empty() {
        if comment.contains('\n') {
            return Err("a comment is one line, and this one holds a line's break".to_string());
        }
        pad(&mut text, COMMENT_STOP);
        if !comment.starts_with('%') {
            text.push_str("% ");
        }
        text.push_str(comment);
    }
    Ok(text)
}

/// The tabs' rows written as the reel's file: the tabs in their order, a row
/// a line, each ended by a line feed. A row no line can say is refused by its
/// tab and its row, as the sheet numbers it.
pub fn write(reel: &Reel) -> Result<String, String> {
    let mut out = String::new();
    for (tab, rows) in TABS.iter().zip(&reel.tabs) {
        for (i, row) in rows.iter().enumerate() {
            let text =
                line(tab, row).map_err(|why| format!("{}, row {}: {why}", tab.name, i + 2))?;
            out.push_str(&text);
            out.push('\n');
        }
    }
    Ok(out)
}

// ---- the tabs' rows, in a source and from a grid ------------------------------------

/// The line a source's block begins at, as the source holds it.
pub const BLOCK_BEGIN: &str = "; ---- the reel, written by cargo run --release --example afterlife: edit walter.prolog, never these lines ----";

/// The line it ends at.
pub const BLOCK_END: &str = "; ---- the reel's end ----";

/// A reel as the lines of a source's block: a row that holds anything one
/// call of the source's `line`, its tab, its row and its cells from column A,
/// a text each; but a whole number a number, where a number holds its digits
/// exactly and writes them back the same, as the page's reader lays one
/// (`lines.rs`, the second slice), so that the cartridge the pass writes is
/// the cartridge a file opened makes.
pub fn block(reel: &Reel) -> Vec<String> {
    let mut out = Vec::new();
    for (tab, rows) in TABS.iter().zip(&reel.tabs) {
        for (i, row) in rows.iter().enumerate() {
            let cells = held(row);
            if cells.is_empty() {
                continue;
            }
            let from = usize::from(tab.names_its_relation());
            let kinds: &[Kind] = if cells[0].starts_with('%') {
                &[]
            } else if tab.names_its_relation() {
                tab.relations
                    .iter()
                    .find(|r| r.name == cells[0])
                    .map_or(&[][..], |r| r.kinds)
            } else {
                tab.relations[0].kinds
            };
            let mut call = format!("(line {} {}", write_datum(&Form::string(tab.name)), i + 2);
            for (k, cell) in cells.iter().enumerate() {
                let whole = k >= from
                    && kinds.get(k - from) == Some(&Kind::Whole)
                    && !cell.is_empty()
                    && cell.len() <= 15
                    && cell.bytes().all(|b| b.is_ascii_digit())
                    && (cell == "0" || !cell.starts_with('0'));
                call.push(' ');
                if whole {
                    call.push_str(cell);
                } else {
                    call.push_str(&write_datum(&Form::string(cell)));
                }
            }
            call.push(')');
            out.push(call);
        }
    }
    out
}

/// The source with its block written again: the lines between the two
/// markers replaced, each line ending as the source's do, a text's own break
/// among them. `None` for a source without both markers, in order.
pub fn with_block(source: &str, block: &[String]) -> Option<String> {
    let eol = if source.contains("\r\n") {
        "\r\n"
    } else {
        "\n"
    };
    let lines: Vec<&str> = source.split(eol).collect();
    let begin = lines.iter().position(|l| *l == BLOCK_BEGIN)?;
    let end = lines.iter().position(|l| *l == BLOCK_END)?;
    if end <= begin {
        return None;
    }
    let mut out: Vec<String> = lines[..=begin].iter().map(|l| l.to_string()).collect();
    out.extend(block.iter().map(|l| l.replace('\n', eol)));
    out.extend(lines[end..].iter().map(|l| l.to_string()));
    Some(out.join(eol))
}

/// A cell's or a range's places: each a column from 0 and a row from 1.
fn places(address: &str) -> Option<Vec<(usize, usize)>> {
    fn corner(text: &str) -> Option<(usize, usize)> {
        let letters = text.chars().take_while(|c| c.is_ascii_alphabetic()).count();
        if letters == 0 || letters == text.len() {
            return None;
        }
        let column = text[..letters].chars().fold(0usize, |n, c| {
            n * 26 + (c.to_ascii_uppercase() as usize - 'A' as usize + 1)
        });
        Some((column - 1, text[letters..].parse().ok()?))
    }
    let (from, to) = match address.split_once(':') {
        Some((a, b)) => (corner(a)?, corner(b)?),
        None => (corner(address)?, corner(address)?),
    };
    let mut out = Vec::new();
    for row in from.1..=to.1 {
        for column in from.0..=to.0 {
            out.push((column, row));
        }
    }
    Some(out)
}

/// A reel from a grid: the tabs' `values` records, in the tabs' order, each
/// cell's value its text, a formula's its last. Row 1 is the headers'. A cell
/// past a tab's last column is refused, since no line holds it, and so is a
/// cell that holds an error.
pub fn of_records(records: &[String]) -> Result<Reel, String> {
    let mut reel = Reel::empty();
    for (t, (tab, record)) in TABS.iter().zip(records).enumerate() {
        let forms = read_forms(record).map_err(|r| format!("{}: {}", tab.name, r.text))?;
        for form in &forms {
            let Form::List(list) = form else { continue };
            let [Form::Sym(head), Form::Str(sheet), Form::Str(address), value, ..] =
                list.items.as_slice()
            else {
                continue;
            };
            if !matches!(head.as_str(), "cell" | "value") || !sheet.eq_ignore_ascii_case(tab.name) {
                continue;
            }
            let Some(places) = places(address) else {
                return Err(format!("{}: {address} is no cell and no range", tab.name));
            };
            let text = match value {
                Form::Str(text) | Form::Sym(text) => text,
                Form::List(_) => {
                    if places.iter().all(|(_, row)| *row < 2) {
                        continue;
                    }
                    return Err(format!(
                        "{}, {address}: the cell holds an error, which no line of a reel says",
                        tab.name
                    ));
                }
            };
            if text.is_empty() {
                continue;
            }
            for (column, row) in places {
                if row < 2 {
                    continue;
                }
                if column >= tab.headers.len() {
                    return Err(format!(
                        "{}, row {row}: a cell stands past the tab's last column, {}",
                        tab.name,
                        tab.headers[tab.comment()]
                    ));
                }
                let rows = &mut reel.tabs[t];
                if rows.len() < row - 1 {
                    rows.resize(row - 1, Row::new());
                }
                let cells = &mut rows[row - 2];
                if cells.len() <= column {
                    cells.resize(column + 1, String::new());
                }
                cells[column] = text.clone();
            }
        }
    }
    Ok(reel)
}

#[cfg(test)]
mod tests {
    use super::*;

    /// A small reel of every relation, with a comment at a line's end, a
    /// text of two paragraphs, a quote and a backslash, and a question long
    /// enough to reach past its stop.
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
    fn a_reel_of_every_relation_comes_back_as_it_was_written() {
        let reel = read(SMALL).expect("reads");
        assert_eq!((reel.lines(), reel.facts()), (25, 14));
        assert_eq!(reel.tabs[0][0], ["% A reel of every relation."]);
        assert_eq!(reel.tabs[0][3], ["speaker", "Ada \"the first\" Byron"]);
        assert_eq!(
            reel.tabs[1][1],
            ["% response(Name, Said)"],
            "a comment goes with the fact after it"
        );
        assert_eq!(
            reel.tabs[1][3],
            ["hello", "Hello.\\n\\nSit down."],
            "a line's break as the file writes it, a backslash and n"
        );
        assert_eq!(
            reel.tabs[1][4],
            ["slash", "A backslash: \\\\."],
            "and a backslash twice"
        );
        assert_eq!(reel.tabs[1][5], ["unsure", ""]);
        assert_eq!(
            reel.tabs[5][1],
            ["slash", "the_mark", "\"A backslash\""],
            "a comment's words, without its percent sign"
        );
        assert_eq!(reel.tabs[6][0], ["hello", "the_mark", "%% kept as written"]);
        let unknown: [&[&str]; 3] = [&[], &["unsure"], &["% The end."]];
        assert_eq!(
            reel.tabs[7], unknown,
            "and a comment after the last fact stays with it"
        );
        assert_eq!(write(&reel).as_deref(), Ok(SMALL));
    }

    #[test]
    fn a_reel_whose_relations_are_interleaved_comes_back_a_relation_a_tab() {
        let mixed = "response(hello, \"Hello.\").\n\
            % what leads there\n\
            answers(hello, \"Hello?\").\n\
            opening(hello).\n\
            response(bye, \"Goodbye.\").\n\
            language(\"en\").\n\
            language(\"en-US\").\n\
            \n\
            \n";
        let written = write(&read(mixed).expect("reads")).expect("writes");
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
            write(&read(&written).expect("reads again")).as_deref(),
            Ok(written.as_str()),
            "and stands"
        );
    }

    #[test]
    fn what_no_tab_holds_is_refused_by_its_line() {
        for (text, why) in [
            ("  response(a, \"b\").\n", "line 1: the line is no fact"),
            ("a :- b.\n", "line 1: the line is no fact"),
            (
                "\n\nplays(a).\n",
                "line 3: plays is no relation of a reel's",
            ),
            (
                "response(a).\n",
                "line 1: response takes two arguments and the line gives 1",
            ),
            (
                "response(A, \"b\").\n",
                "line 1: response's first argument is a name",
            ),
            (
                "response('a b', \"b\").\n",
                "line 1: response's first argument is a name",
            ),
            (
                "response(a, b).\n",
                "line 1: response's second argument is a text in double quotes",
            ),
            (
                "reel(one).\n",
                "line 1: reel's first argument is a whole number",
            ),
            (
                "response(a, \"b\\t\").\n",
                "line 1: a backslash before 't' is an escape this reader does not know",
            ),
            (
                "response(a, \"b).\n",
                "line 1: a text's quotes are not closed",
            ),
            (
                "response(a, \"b\") .\n",
                "line 1: a fact ends with a period",
            ),
            (
                "response(a, \"b\"). and more\n",
                "line 1: after a fact's period stands a comment or nothing",
            ),
            (
                "response(a, \"b\"\"c\").\n",
                "line 1: an argument is followed by a comma",
            ),
        ] {
            let refused = read(text).expect_err(text);
            assert!(refused.starts_with(why), "{text:?}: {refused}");
        }
    }

    #[test]
    fn what_no_line_says_is_refused_by_its_tab_and_its_row() {
        let rows = |t: usize, cells: &[&str]| {
            let mut reel = Reel::empty();
            reel.tabs[t].push(Row::new());
            reel.tabs[t].push(cells.iter().map(|c| c.to_string()).collect());
            write(&reel)
        };
        assert_eq!(
            rows(1, &["hello", "Hello."]).as_deref(),
            Ok("\nresponse(hello, \"Hello.\").\n")
        );
        assert_eq!(
            rows(1, &["hello"]).as_deref(),
            Ok("\nresponse(hello, \"\").\n"),
            "a response nobody wrote down"
        );
        assert_eq!(
            rows(1, &["hello", "Hello.", "% as written"]).as_deref(),
            Ok("\nresponse(hello, \"Hello.\").                      % as written\n"),
            "a comment at column 49, as written where it has its percent sign"
        );
        assert_eq!(
            rows(1, &["hello", "Hello.", "a note"]).as_deref(),
            Ok("\nresponse(hello, \"Hello.\").                      % a note\n"),
            "and given one where it has none"
        );
        assert_eq!(
            rows(1, &["hello", "He said \"sit\".\\n\\nA backslash: \\\\."]).as_deref(),
            Ok("\nresponse(hello, \"He said \\\"sit\\\".\\n\\nA backslash: \\\\.\").\n"),
            "a quote escaped, a line's break and a backslash as the cell writes them"
        );
        assert_eq!(
            rows(1, &["hello", "One.\r\n\r\nTwo."]).as_deref(),
            Ok("\nresponse(hello, \"One.\\n\\nTwo.\").\n"),
            "and a line's break a paste brought written as the file writes one"
        );
        for (t, cells, why) in [
            (
                1,
                &["hello", "C:\\temp"][..],
                "Responses, row 3: a backslash stands before 't': a line's break is written \\n, and a backslash twice",
            ),
            (
                1,
                &["hello", "ends with \\"][..],
                "Responses, row 3: a backslash ends a text",
            ),
            (
                1,
                &["Hello", "Hello."][..],
                "Responses, row 3: its File Name, \"Hello\", is not a name",
            ),
            (
                1,
                &["", "Hello."][..],
                "Responses, row 3: its File Name is empty",
            ),
            (
                1,
                &["hello", "Hello.", "a note", "more"][..],
                "Responses, row 3: a cell stands past the tab's last column, Comment",
            ),
            (
                1,
                &["% a note", "Hello."][..],
                "Responses, row 3: a comment's row holds its words in its first cell",
            ),
            (
                1,
                &["hello", "Hello.", "two\nlines"][..],
                "Responses, row 3: a comment is one line",
            ),
            (
                0,
                &["plays", "x"][..],
                "Summary, row 3: \"plays\" is no fact of the Summary's",
            ),
            (
                0,
                &["reel", "one"][..],
                "Summary, row 3: its Value, \"one\", is not a whole number",
            ),
            (
                3,
                &["hello", "A line?"][..],
                "Follows, row 3: its To is empty",
            ),
        ] {
            let refused = rows(t, cells).expect_err(why);
            assert!(refused.starts_with(why), "{refused}");
        }
    }

    #[test]
    fn a_grid_s_records_are_read_as_the_tabs_rows() {
        let mut records = vec![String::new(); TABS.len()];
        records[1] = "(sheet \"Responses\" visible)\n\
            (cell \"Responses\" \"A1\" \"File Name\")\n\
            (cell \"Responses\" \"B1\" \"Said\")\n\
            (cell \"Responses\" \"A3\" \"hello\")\n\
            (cell \"Responses\" \"B3\" \"Hello.\n\nSit down.\")\n\
            (cell \"Responses\" \"A4:A5\" \"\")\n\
            (formula \"Responses\" \"A6\" \"=A3\")\n\
            (value \"Responses\" \"A6\" \"hello\")\n\
            (cell \"Responses\" \"B6\" 7)\n"
            .to_string();
        let reel = of_records(&records).expect("reads");
        assert_eq!(
            reel.tabs[1],
            [
                vec![],
                vec!["hello".to_string(), "Hello.\n\nSit down.".to_string()],
                vec![],
                vec![],
                vec!["hello".to_string(), "7".to_string()]
            ]
        );
        records[1] = "(cell \"Responses\" \"D2\" \"stray\")\n".to_string();
        assert_eq!(
            of_records(&records).expect_err("a stray cell"),
            "Responses, row 2: a cell stands past the tab's last column, Comment"
        );
    }
}

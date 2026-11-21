//! Afterlife's sheet at the command line (`CART.16`'s first slice;
//! `docs/REARVIEW.md`): a reel's file read into the cartridge's tabs, and a
//! save of the cartridge written back as a reel's file, by the reader and the
//! writer of `engine/src/afterlife.rs`, the engine's tests' own file.
//!
//! ```text
//! cargo run --release --example afterlife                              # Walter's reel written into the source's block
//! cargo run --release --example afterlife -- --check                   # the same, compared and written nowhere
//! cargo run --release --example expand                                 # then the cartridge, as after any edit
//! cargo run --release --example afterlife -- sheet <reel.pl> <out.vla> # any reel as a cartridge, for the page's Open
//! cargo run --release --example afterlife -- reel <save.vla> <out.pl>  # a save of it, written back as a reel
//! ```
//!
//! With no word, the golden, `cartridges/afterlife/walter.pl`, is read and its
//! rows are written into the block of `cartridges/afterlife/afterlife.source.vla`
//! between its two markers, the lines around the block as they stand; the
//! pass then expands the source into the cartridge. `sheet` does both for any
//! reel and writes the cartridge where it is told, the repository untouched:
//! a reel of a person who lived is never committed. `reel` loads a save, or
//! any cartridge of these tabs, reads each tab's cells and writes the file
//! they say; a row no line can say is refused by its tab and its row.
//!
//! Prints `(reel "<file>" (lines <n>) (facts <m>) written|same|differs)`, or
//! `(sheet "<reel>" "<cartridge>" (lines <n>) (facts <m>) (rows <r>) (loads yes))`,
//! or `(reel "<save>" "<reel>" (lines <n>) (facts <m>) written)`; a refusal as
//! `(refused "<file>" "<words>")`. Exits 0 when it wrote, or, checking, the
//! block is the same; 1 when it refused or the block differs; 2 for words it
//! does not know. `cargo test` holds the golden's round trip, byte for byte.

use std::collections::BTreeSet;
use std::path::Path;
use std::process::ExitCode;

use alonzo::cartridge::Cartridge;
use alonzo::pass::{expand, file_name, folder_of, includes};
use vla_lang::form::Form;
use vla_lang::machine::Viewed;
use vla_lang::printer::write_datum;

#[path = "../src/afterlife.rs"]
#[allow(dead_code)]
mod afterlife;

/// The source, below the repository's root.
const SOURCE: &str = "cartridges/afterlife/afterlife.source.vla";

/// The golden, Walter Alder's reel.
const GOLDEN: &str = "cartridges/afterlife/walter.pl";

/// A text as a row quotes it.
fn quoted(text: &str) -> String {
    write_datum(&Form::string(text))
}

fn refused(file: &str, why: &str) -> ExitCode {
    println!("(refused {} {})", quoted(file), quoted(why));
    ExitCode::from(1)
}

/// The texts the source includes, read from the repository under the keys
/// the pass resolves them by, each once, as `examples/expand.rs` gathers them.
fn gather(root: &Path, text: &str) -> Vec<(String, String)> {
    let folder = folder_of(SOURCE).to_string();
    let mut files = Vec::new();
    let mut seen = BTreeSet::new();
    let mut queue = includes(text, &folder);
    while let Some(key) = queue.pop() {
        if !seen.insert(key.clone()) {
            continue;
        }
        if let Ok(body) = std::fs::read_to_string(root.join(&key)) {
            queue.extend(includes(&body, &folder));
            files.push((key, body));
        }
    }
    files
}

/// The source with a reel's rows in its block.
fn source_of(root: &Path, reel: &afterlife::Reel) -> Result<(String, String), String> {
    let held = std::fs::read_to_string(root.join(SOURCE)).map_err(|e| format!("{SOURCE}: {e}"))?;
    let written = afterlife::with_block(&held, &afterlife::block(reel)).ok_or_else(|| {
        format!(
            "{SOURCE} holds no block from {:?} to {:?}, in that order",
            afterlife::BLOCK_BEGIN,
            afterlife::BLOCK_END
        )
    })?;
    Ok((held, written))
}

/// The golden's rows written into the source's block, or compared with it.
fn golden(root: &Path, check: bool) -> ExitCode {
    let text = match std::fs::read_to_string(root.join(GOLDEN)) {
        Ok(text) => text,
        Err(e) => return refused(GOLDEN, &e.to_string()),
    };
    let reel = match afterlife::read(&text) {
        Ok(reel) => reel,
        Err(why) => return refused(GOLDEN, &why),
    };
    let (held, written) = match source_of(root, &reel) {
        Ok(pair) => pair,
        Err(why) => return refused(SOURCE, &why),
    };
    let row = format!(
        "(reel {} (lines {}) (facts {})",
        quoted(SOURCE),
        reel.lines(),
        reel.facts()
    );
    if check {
        if written == held {
            println!("{row} same)");
            ExitCode::SUCCESS
        } else {
            println!("{row} differs)");
            ExitCode::from(1)
        }
    } else {
        if let Err(e) = std::fs::write(root.join(SOURCE), written) {
            return refused(SOURCE, &e.to_string());
        }
        println!("{row} written)");
        ExitCode::SUCCESS
    }
}

/// Any reel as a cartridge: its rows in the source's block, the source
/// expanded by the pass, and the cartridge written where it is told.
fn sheet(root: &Path, from: &str, to: &str) -> ExitCode {
    let text = match std::fs::read_to_string(from) {
        Ok(text) => text,
        Err(e) => return refused(from, &e.to_string()),
    };
    let reel = match afterlife::read(&text) {
        Ok(reel) => reel,
        Err(why) => return refused(from, &why),
    };
    let (_, source) = match source_of(root, &reel) {
        Ok(pair) => pair,
        Err(why) => return refused(SOURCE, &why),
    };
    let expansion = match expand(&source, SOURCE, &gather(root, &source)) {
        Ok(expansion) => expansion,
        Err(r) => {
            return refused(
                SOURCE,
                &format!("line {}: {}: {}", r.line, r.refusal.id, r.refusal.text),
            )
        }
    };
    if let Err(r) = Cartridge::load(&expansion.text, file_name(to), expansion.text.len()) {
        return refused(
            to,
            &format!("line {}: {}: {}", r.line, r.refusal.id, r.refusal.text),
        );
    }
    if let Err(e) = std::fs::write(to, &expansion.text) {
        return refused(to, &e.to_string());
    }
    println!(
        "(sheet {} {} (lines {}) (facts {}) (rows {}) (loads yes))",
        quoted(from),
        quoted(to),
        reel.lines(),
        reel.facts(),
        expansion.rows
    );
    ExitCode::SUCCESS
}

/// A save, or any cartridge of these tabs, written back as a reel's file.
fn reel(from: &str, to: &str) -> ExitCode {
    let text = match std::fs::read_to_string(from) {
        Ok(text) => text,
        Err(e) => return refused(from, &e.to_string()),
    };
    let cartridge = match Cartridge::load(&text, file_name(from), text.len()) {
        Ok(cartridge) => cartridge,
        Err(r) => {
            return refused(
                from,
                &format!("line {}: {}: {}", r.line, r.refusal.id, r.refusal.text),
            )
        }
    };
    let mut records = Vec::new();
    for tab in &afterlife::TABS {
        match cartridge.view("values", tab.name, None) {
            Ok(Viewed::Text(record)) => records.push(record),
            Ok(_) => return refused(from, &format!("{}: its values are no record", tab.name)),
            Err(r) => return refused(from, &format!("{}: {}: {}", tab.name, r.id, r.text)),
        }
    }
    let read = match afterlife::of_records(&records) {
        Ok(read) => read,
        Err(why) => return refused(from, &why),
    };
    let written = match afterlife::write(&read) {
        Ok(written) => written,
        Err(why) => return refused(from, &why),
    };
    if let Err(e) = std::fs::write(to, written) {
        return refused(to, &e.to_string());
    }
    println!(
        "(reel {} {} (lines {}) (facts {}) written)",
        quoted(from),
        quoted(to),
        read.lines(),
        read.facts()
    );
    ExitCode::SUCCESS
}

fn main() -> ExitCode {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let words: Vec<&str> = args.iter().map(String::as_str).collect();
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("..");
    match words.as_slice() {
        [] => golden(&root, false),
        ["--check"] => golden(&root, true),
        ["sheet", from, to] => sheet(&root, from, to),
        ["reel", from, to] => reel(from, to),
        _ => {
            eprintln!(
                "afterlife: it takes no word, or --check, or sheet <reel.pl> <out.vla>, or reel <save.vla> <out.pl>"
            );
            ExitCode::from(2)
        }
    }
}

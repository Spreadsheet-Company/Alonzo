//! Afterlife's sheet at the command line (`CART.16`; `docs/REARVIEW.md`): a
//! reel's file read into the cartridge's tabs, and a save of the cartridge
//! written back as a reel's file, by the two acts the page's Open and Save
//! take since the second slice, `Cartridge::opened` and
//! `Cartridge::file_text`, the cartridge's Format sheet saying the reel's
//! lines (`engine/src/lines.rs`; `docs/SPEC.md` section 3.11).
//!
//! ```text
//! cargo run --release --example afterlife                              # Walter's reel written into the source's block
//! cargo run --release --example afterlife -- --check                   # the same, compared and written nowhere
//! cargo run --release --example expand                                 # then the cartridge, as after any edit
//! cargo run --release --example afterlife -- sheet <reel> <out.vla>       # any reel as a cartridge, which the page's Open opens
//! cargo run --release --example afterlife -- reel <save.vla> <out.prolog> # a save of it, written back as a reel
//! ```
//!
//! With no word, the golden, `cartridges/afterlife/walter.prolog`, is read and its
//! rows are written into the block of `cartridges/afterlife/afterlife.source.vla`
//! between its two markers, the lines around the block as they stand, by the
//! first slice's hand, `engine/src/afterlife.rs`, the engine's tests' own
//! file; the pass then expands the source into the cartridge, and `cargo
//! test` holds that cartridge to the one a file opened makes. `sheet` is the
//! page's Open: the committed cartridge with any reel's lines in its tabs,
//! written where it is told, the repository untouched, since a reel of a
//! person who lived is never committed; it loads what it wrote and writes the
//! file back, as the page does at an open, and says the first line that would
//! change. `reel` is the page's Save: a save loaded, or any cartridge of these
//! tabs, and the file its tabs say written; a row no line says is refused by
//! its cell.
//!
//! Prints `(reel "<file>" (lines <n>) (facts <m>) written|same|differs)`, or
//! `(sheet "<reel>" "<cartridge>" (lines <n>) (loads yes) same|(differs <line>))`,
//! or `(reel "<save>" "<reel>" (lines <n>) written)`; a refusal as
//! `(refused "<file>" "<words>")`. Exits 0 when it wrote, or, checking, the
//! block is the same; 1 when it refused or the block differs; 2 for words it
//! does not know. `cargo test` holds the golden's round trip, byte for byte.

use std::path::Path;
use std::process::ExitCode;

use alonzo::cartridge::Cartridge;
use alonzo::pass::file_name;
use vla_lang::form::Form;
use vla_lang::printer::write_datum;

#[path = "../src/afterlife.rs"]
#[allow(dead_code)]
mod afterlife;

/// The source, below the repository's root.
const SOURCE: &str = "cartridges/afterlife/afterlife.source.vla";

/// The cartridge the pass writes from it, which a reel is opened under.
const CARTRIDGE: &str = "cartridges/afterlife/afterlife.vla";

/// The golden, Walter Alder's reel.
const GOLDEN: &str = "cartridges/afterlife/walter.prolog";

/// A text as a row quotes it.
fn quoted(text: &str) -> String {
    write_datum(&Form::string(text))
}

fn refused(file: &str, why: &str) -> ExitCode {
    println!("(refused {} {})", quoted(file), quoted(why));
    ExitCode::from(1)
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

/// The first line, from 1, at which two files part, or none where they are
/// one file: the page's word at an open (section 3.11).
fn first_change(file: &str, written: &str) -> Option<usize> {
    let (mut a, mut b) = (file.split('\n'), written.split('\n'));
    let mut line = 1;
    loop {
        match (a.next(), b.next()) {
            (None, None) => return None,
            (x, y) if x == y => line += 1,
            _ => return Some(line),
        }
    }
}

/// Any reel as a cartridge, the page's Open: the committed cartridge with the
/// reel's lines in its tabs, written where it is told; then loaded, and the
/// file written back from it, the first line that would change said.
fn sheet(root: &Path, from: &str, to: &str) -> ExitCode {
    let file = match std::fs::read_to_string(from) {
        Ok(text) => text,
        Err(e) => return refused(from, &e.to_string()),
    };
    let cartridge = match std::fs::read_to_string(root.join(CARTRIDGE)) {
        Ok(text) => text,
        Err(e) => return refused(CARTRIDGE, &e.to_string()),
    };
    let opened = match Cartridge::opened(&cartridge, &file) {
        Ok(opened) => opened,
        Err(r) => return refused(from, &format!("{}: {}", r.refusal.id, r.refusal.text)),
    };
    let loaded = match Cartridge::load(&opened, file_name(to), opened.len()) {
        Ok(loaded) => loaded,
        Err(r) => {
            return refused(
                to,
                &format!("line {}: {}: {}", r.line, r.refusal.id, r.refusal.text),
            )
        }
    };
    let back = match loaded.file_text() {
        Ok(back) => back,
        Err(r) => return refused(to, &format!("{}: {}", r.id, r.text)),
    };
    if let Err(e) = std::fs::write(to, &opened) {
        return refused(to, &e.to_string());
    }
    println!(
        "(sheet {} {} (lines {}) (loads yes) {})",
        quoted(from),
        quoted(to),
        file.lines().count(),
        match first_change(&file, &back) {
            None => "same".to_string(),
            Some(line) => format!("(differs {line})"),
        }
    );
    ExitCode::SUCCESS
}

/// A save, or any cartridge of these tabs, written back as a reel's file: the
/// page's Save.
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
    let written = match cartridge.file_text() {
        Ok(written) => written,
        Err(r) => return refused(from, &format!("{}: {}", r.id, r.text)),
    };
    if let Err(e) = std::fs::write(to, &written) {
        return refused(to, &e.to_string());
    }
    println!(
        "(reel {} {} (lines {}) written)",
        quoted(from),
        quoted(to),
        written.lines().count()
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
                "afterlife: it takes no word, or --check, or sheet <reel> <out.vla>, or reel <save.vla> <out.prolog>"
            );
            ExitCode::from(2)
        }
    }
}

//! The pass at the command line (`SPEC.3`; `SPEC.md` section 7.8): each
//! cartridge's source expanded by `alonzo::pass` into the cartridge beside
//! it, then the cartridge loaded, as an act of its own, to say whether it
//! loads. The pass reads no file; this door reads the source and every text
//! it includes and hands them in, so the page's door, which hands in the
//! texts it embeds, runs the same pass to the same bytes.
//!
//! ```text
//! cargo run --release --example expand                 # every cartridges/<name>/<name>.source.vla
//! cargo run --release --example expand -- --check      # the same, compared and written nowhere
//! cargo run --release --example expand -- cartridges/life/life.source.vla
//! ```
//!
//! A source is `<name>.source.vla`, and its cartridge is `<name>.vla` in the
//! same folder (decision 28 of the scoping, `REARVIEW.md`). An include is
//! resolved against the source's own folder, every include of an included
//! text too, as the reference resolves each against the workbook's.
//!
//! Prints one row a source:
//! `(expanded "<source>" "<cartridge>" (rows <n>) (loads yes))`, or with
//! `--check` `(checked "<source>" "<cartridge>" same|differs|missing)`, or
//! `(refused "<source>" (line <n>) <id> "<words>")`, then
//! `(expand-done <sources>)`. Exits 0 when every source expanded and every
//! cartridge loads (and, checking, is the same), 1 when one did not, and 2
//! for a word it does not know.

use std::collections::BTreeSet;
use std::path::{Path, PathBuf};
use std::process::ExitCode;

use alonzo::cartridge::Cartridge;
use alonzo::pass::{cartridge_path, expand, file_name, folder_of, includes};
use vla_lang::form::Form;
use vla_lang::printer::write_datum;

/// A text as a row quotes it.
fn quoted(text: &str) -> String {
    write_datum(&Form::string(text))
}

/// Every source under the repository's `cartridges/`, relative to its root.
fn default_sources(root: &Path) -> Vec<String> {
    let mut out = Vec::new();
    let dir = root.join("cartridges");
    let Ok(entries) = std::fs::read_dir(&dir) else {
        return out;
    };
    for entry in entries.flatten() {
        let folder = entry.path();
        if !folder.is_dir() {
            continue;
        }
        let name = entry.file_name().to_string_lossy().to_string();
        if folder.join(format!("{name}.source.vla")).is_file() {
            out.push(format!("cartridges/{name}/{name}.source.vla"));
        }
    }
    out.sort();
    out
}

/// The texts a source may include, read from `base` under the keys the pass
/// resolves them by: its includes, and theirs, each against the source's
/// own folder, each read once. A text that cannot be read is left out, and
/// the pass refuses it by name.
fn gather(base: &Path, path: &str, text: &str) -> Vec<(String, String)> {
    let folder = folder_of(path).to_string();
    let mut files = Vec::new();
    let mut seen = BTreeSet::new();
    let mut queue = includes(text, &folder);
    while let Some(key) = queue.pop() {
        if !seen.insert(key.clone()) {
            continue;
        }
        if let Ok(body) = std::fs::read_to_string(base.join(&key)) {
            queue.extend(includes(&body, &folder));
            files.push((key, body));
        }
    }
    files
}

fn lf(s: &str) -> String {
    s.replace("\r\n", "\n")
}

fn main() -> ExitCode {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let check = args.iter().any(|a| a == "--check");
    let mut given = Vec::new();
    for a in &args {
        match a.as_str() {
            "--check" => {}
            a if a.starts_with("--") => {
                eprintln!("expand: an unknown option, {a}");
                return ExitCode::from(2);
            }
            a => given.push(a.replace('\\', "/")),
        }
    }
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("..");
    let (base, sources): (PathBuf, Vec<String>) = if given.is_empty() {
        (root.clone(), default_sources(&root))
    } else {
        (PathBuf::from("."), given)
    };
    if sources.is_empty() {
        eprintln!("expand: no <name>.source.vla to expand");
        return ExitCode::from(2);
    }

    let mut fine = true;
    for path in &sources {
        let Some(target) = cartridge_path(path) else {
            eprintln!("expand: {path} is not a <name>.source.vla");
            return ExitCode::from(2);
        };
        let text = match std::fs::read_to_string(base.join(path)) {
            Ok(t) => t,
            Err(e) => {
                println!(
                    "(refused {} (line 0) vla-file-not-found {})",
                    quoted(path),
                    quoted(&e.to_string())
                );
                fine = false;
                continue;
            }
        };
        let files = gather(&base, path, &text);
        let expansion = match expand(&text, path, &files) {
            Ok(e) => e,
            Err(r) => {
                println!(
                    "(refused {} (line {}) {} {})",
                    quoted(path),
                    r.line,
                    r.refusal.id,
                    quoted(&r.refusal.text)
                );
                fine = false;
                continue;
            }
        };
        if check {
            let verdict = match std::fs::read_to_string(base.join(&target)) {
                Ok(held) if lf(&held) == lf(&expansion.text) => "same",
                Ok(_) => "differs",
                Err(_) => "missing",
            };
            fine &= verdict == "same";
            println!("(checked {} {} {verdict})", quoted(path), quoted(&target));
            continue;
        }
        if let Err(e) = std::fs::write(base.join(&target), &expansion.text) {
            println!(
                "(refused {} (line 0) vla-file-not-replaced {})",
                quoted(&target),
                quoted(&e.to_string())
            );
            fine = false;
            continue;
        }
        // The load, an act of its own after the pass's.
        let loads = match Cartridge::load(&expansion.text, file_name(&target), expansion.text.len())
        {
            Ok(_) => "(loads yes)".to_string(),
            Err(r) => {
                fine = false;
                format!(
                    "(loads no (line {}) {} {})",
                    r.line,
                    r.refusal.id,
                    quoted(&r.refusal.text)
                )
            }
        };
        println!(
            "(expanded {} {} (rows {}) {loads})",
            quoted(path),
            quoted(&target),
            expansion.rows
        );
    }
    println!("(expand-done {})", sources.len());
    if fine {
        ExitCode::SUCCESS
    } else {
        ExitCode::from(1)
    }
}

//! Seiyaku's book written (`CART.14`, decisions 7 and 8; `docs/REARVIEW.md`):
//! the generator of `engine/src/seiyaku.rs`, the engine's tests' own file,
//! digs 128 puzzles, 32 a grade, each with one solution, from its fixed seed,
//! and this door writes them into the block of
//! `cartridges/seiyaku/seiyaku.source.vla` between its two markers, one line
//! a puzzle, the lines around the block as they stand. The pass then expands
//! the source into the cartridge, as for any edit of it:
//!
//! ```text
//! cargo run --release --example seiyaku              # the book written into the source
//! cargo run --release --example seiyaku -- --check   # the same, compared and written nowhere
//! cargo run --release --example expand               # then the cartridge, as after any edit
//! ```
//!
//! Prints `(book "<source>" (puzzles <n>) (grades <a> <b> <c> <d>) (ms <t>) written|same|differs)`.
//! Exits 0 when the book was written or, checking, is the same; 1 when the
//! source holds no block, or, checking, its book differs; 2 for a word it does
//! not know. `cargo test` holds the same bytes, and every puzzle's one
//! solution by both solvers.

use std::path::Path;
use std::process::ExitCode;
use std::time::Instant;

#[path = "../src/seiyaku.rs"]
#[allow(dead_code)]
mod seiyaku;

fn main() -> ExitCode {
    let mut check = false;
    for arg in std::env::args().skip(1) {
        match arg.as_str() {
            "--check" => check = true,
            other => {
                eprintln!("seiyaku: {other:?} is no word of this door's; it takes --check alone");
                return ExitCode::from(2);
            }
        }
    }
    let rel = "cartridges/seiyaku/seiyaku.source.vla";
    let path = Path::new(env!("CARGO_MANIFEST_DIR")).join("..").join(rel);
    let source = match std::fs::read_to_string(&path) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("seiyaku: {rel}: {e}");
            return ExitCode::from(1);
        }
    };
    let started = Instant::now();
    let book = seiyaku::write_book(seiyaku::BOOK_SEED, seiyaku::PER_GRADE);
    let ms = started.elapsed().as_secs_f64() * 1000.0;
    let Some(written) = seiyaku::with_book(&source, &book) else {
        eprintln!(
            "seiyaku: {rel} holds no block from {:?} to {:?}, in that order",
            seiyaku::BOOK_BEGIN,
            seiyaku::BOOK_END
        );
        return ExitCode::from(1);
    };
    let mut grades = [0usize; 4];
    for (_, g) in &book {
        grades[usize::from(*g - 1)] += 1;
    }
    let row = format!(
        "(book \"{rel}\" (puzzles {}) (grades {} {} {} {}) (ms {ms:.0})",
        book.len(),
        grades[0],
        grades[1],
        grades[2],
        grades[3]
    );
    if check {
        if written == source {
            println!("{row} same)");
            ExitCode::SUCCESS
        } else {
            println!("{row} differs)");
            ExitCode::from(1)
        }
    } else {
        if let Err(e) = std::fs::write(&path, written) {
            eprintln!("seiyaku: {rel}: {e}");
            return ExitCode::from(1);
        }
        println!("{row} written)");
        ExitCode::SUCCESS
    }
}

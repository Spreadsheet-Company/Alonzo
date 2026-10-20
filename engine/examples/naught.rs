//! Naught's bench written (`CART.9`, decisions 3 and 4; `docs/REARVIEW.md`):
//! the netlist of `engine/src/naught.rs`, the engine's tests' own file, a
//! 16-bit ripple adder and an 8 by 8 multiplier laid by fill, and this door
//! writes it into the block of `cartridges/naught/naught.source.vla` between
//! its two markers, a line a row, the lines around the block as they stand.
//! The pass then expands the source into the cartridge, as for any edit of
//! it:
//!
//! ```text
//! cargo run --release --example naught              # the bench written into the source
//! cargo run --release --example naught -- --check   # the same, compared and written nowhere
//! cargo run --release --example expand              # then the cartridge, as after any edit
//! ```
//!
//! Prints `(bench "<source>" (gates <n>) (depth <d>) (rows <r>) written|same|differs)`.
//! Exits 0 when the bench was written or, checking, is the same; 1 when the
//! source holds no block, or, checking, its bench differs; 2 for a word it
//! does not know. `cargo test` holds the same bytes, and every gate of the
//! bench to the netlist evaluated by hand.

use std::path::Path;
use std::process::ExitCode;

#[path = "../src/naught.rs"]
#[allow(dead_code)]
mod naught;

use naught::{Laid, Lay, Net, Switches, Wiring};

fn main() -> ExitCode {
    let mut check = false;
    for arg in std::env::args().skip(1) {
        match arg.as_str() {
            "--check" => check = true,
            other => {
                eprintln!("naught: {other:?} is no word of this door's; it takes --check alone");
                return ExitCode::from(2);
            }
        }
    }
    let rel = "cartridges/naught/naught.source.vla";
    let path = Path::new(env!("CARGO_MANIFEST_DIR")).join("..").join(rel);
    let source = match std::fs::read_to_string(&path) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("naught: {rel}: {e}");
            return ExitCode::from(1);
        }
    };
    let (adder, multiplier) = naught::BENCH;
    let net = Net::bench(adder, multiplier);
    let lines = Laid::new(&net, Lay::Fill, Switches::Values, Wiring::Now).block();
    let Some(written) = naught::with_block(&source, &lines) else {
        eprintln!(
            "naught: {rel} holds no block from {:?} to {:?}, in that order",
            naught::BLOCK_BEGIN,
            naught::BLOCK_END
        );
        return ExitCode::from(1);
    };
    let row = format!(
        "(bench \"{rel}\" (gates {}) (depth {}) (rows {})",
        net.gates.len(),
        net.depth(),
        lines.len()
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
            eprintln!("naught: {rel}: {e}");
            return ExitCode::from(1);
        }
        println!("{row} written)");
        ExitCode::SUCCESS
    }
}

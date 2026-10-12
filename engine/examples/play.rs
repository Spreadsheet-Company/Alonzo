//! The playtest pass's session (`CART.2`, 2026-10-12; `REARVIEW.md`, the
//! item's entry, "The playtest pass"): Sand played as the host plays it, the
//! Input sheet's eighteen rows written before every step, through a session
//! of eight phases, and every frame's plane held to the sand written by hand,
//! `engine/src/sand.rs`, before any time is printed.
//!
//! ```text
//! cargo run --release --example play                       # cartridges/sand/sand.vla
//! cargo run --release --example play -- path/to/sand.vla   # another build of the same rule
//! ```
//!
//! **Why a session.** The frame floors time Sand's opening, frames 2 to 31,
//! the board raining at once. A person also settles the board, paints, keys a
//! material and erases. The pass's first session found what the opening never
//! reaches: every press, every release and every material key computed all
//! 189,017 cells, 17 to 26 ms natively, where a stroke's frames take 1 to 2.
//!
//! **The phases**, 1,100 frames: the opening's rain, frames 1 to 200; the
//! board settled, to 400; a stroke of sand, the left button held across the
//! upper air for 120 frames; the sand settling, 80; the key `3`, then a stroke
//! of water, 120; the lake left to shimmer, 180; a stroke erased with the
//! right button, 120; and 80 after it. The brush keeps its opening radius.
//!
//! **What it prints.** For each phase, the median, the 95th percentile and the
//! longest of its steps, frames 1 and 2 left out, as every frame after a load
//! computes every cell; the sand and water on the board after the phase; then
//! the steps' total. Each step is one `step` with no budget, timed alone, the
//! write before it and the hold after it outside the time. These are a
//! playtest's numbers and no floor: run it opted out of Windows' power
//! throttling and on the performance cores, as `tools/bench_frames.ps1` runs
//! the frame floors' runner, for numbers to compare.
//!
//! Exits 0 when every frame equals the sand by hand, and 1, naming the frame
//! and the cell, when one does not or the cartridge is refused.

#[path = "../src/sand.rs"]
#[allow(dead_code)]
mod sand;

use std::path::PathBuf;
use std::process::ExitCode;
use std::time::Instant;

use alonzo::cartridge::{Cartridge, Seed};
use vla_lang::machine::Viewed;

/// One frame's input as the host writes it: the pointer's cell, the left and
/// right buttons, and the key pressed this frame.
#[derive(Clone, Copy)]
struct Input {
    pointer: (u32, u32),
    left: u32,
    right: u32,
    key: &'static str,
}

const IDLE: Input = Input {
    pointer: (0, 0),
    left: 0,
    right: 0,
    key: "",
};

/// A phase: its name, its frames, and the input of its `k`th frame of `n`.
struct Phase {
    name: &'static str,
    frames: usize,
    input: fn(usize, usize) -> Input,
}

const PHASES: [Phase; 8] = [
    Phase {
        name: "the opening's rain, frames 3 to 200",
        frames: 200,
        input: |_, _| IDLE,
    },
    Phase {
        name: "settled, 201 to 400",
        frames: 200,
        input: |_, _| IDLE,
    },
    Phase {
        name: "a stroke of sand, 120 frames",
        frames: 120,
        input: |k, n| Input {
            pointer: stroke(k, n, (20, 40), (300, 70)),
            left: 1,
            ..IDLE
        },
    },
    Phase {
        name: "the sand settling, 80",
        frames: 80,
        input: |_, _| IDLE,
    },
    Phase {
        name: "the key 3, then a stroke of water, 120",
        frames: 120,
        input: |k, n| match k {
            0 => Input { key: "3", ..IDLE },
            _ => Input {
                pointer: stroke(k, n, (300, 40), (20, 60)),
                left: 1,
                ..IDLE
            },
        },
    },
    Phase {
        name: "a lake shimmering, 180",
        frames: 180,
        input: |_, _| IDLE,
    },
    Phase {
        name: "a stroke erased, 120",
        frames: 120,
        input: |k, n| Input {
            pointer: stroke(k, n, (20, 150), (300, 180)),
            right: 1,
            ..IDLE
        },
    },
    Phase {
        name: "after it, 80",
        frames: 80,
        input: |_, _| IDLE,
    },
];

/// The pointer's cell at frame `k` of a stroke of `n` frames from one cell to
/// another, a straight line.
fn stroke(k: usize, n: usize, from: (u32, u32), to: (u32, u32)) -> (u32, u32) {
    let t = k as f64 / (n.max(2) - 1) as f64;
    let at = |a: u32, b: u32| (f64::from(a) + (f64::from(b) - f64::from(a)) * t).round() as u32;
    (at(from.0, to.0), at(from.1, to.1))
}

/// The Input sheet's eighteen rows as the host writes them (`SPEC.md` section
/// 3.3): no player's button held, the pointer, its three buttons, no wheel,
/// and the key twice, as itself and as its code.
fn rows(i: &Input) -> String {
    let mut out = String::new();
    for b in 1..=10u32 {
        for col in ['B', 'C', 'D', 'E'] {
            out.push_str(&format!("(cell \"Input\" \"{col}{b}\" 0)\n"));
        }
    }
    let code = match i.key {
        "" => String::new(),
        k => format!("Digit{k}"),
    };
    out.push_str(&format!(
        "(cell \"Input\" \"B11\" {})\n(cell \"Input\" \"B12\" {})\n(cell \"Input\" \"B13\" {})\n(cell \"Input\" \"B14\" {})\n(cell \"Input\" \"B15\" 0)\n(cell \"Input\" \"B16\" 0)\n(cell \"Input\" \"B17\" \"{}\")\n(cell \"Input\" \"B18\" \"{code}\")\n",
        i.pointer.0, i.pointer.1, i.left, i.right, i.key
    ));
    out
}

fn plane(c: &Cartridge) -> Result<Vec<u8>, String> {
    match c.view("plane", "Screen", Some("A1:LH200")) {
        Ok(Viewed::Bytes(b)) => Ok(b),
        Ok(Viewed::Text(_)) => Err("the plane answered text".to_string()),
        Err(r) => Err(format!("the plane was refused: {}", r.text)),
    }
}

fn play(path: &PathBuf) -> Result<(), String> {
    let text = std::fs::read_to_string(path)
        .map_err(|e| format!("{}: cannot be read: {e}", path.display()))?;
    let mut c = Cartridge::load(&text, "sand.vla", text.len()).map_err(|e| {
        format!(
            "{}: refused at line {}: {}",
            path.display(),
            e.line,
            e.refusal.text
        )
    })?;
    let seed = match c.manifest().seed {
        Seed::Number(n) => u64::from(n),
        Seed::Host => {
            return Err(format!(
                "{}: the opening needs the manifest's seed",
                path.display()
            ))
        }
    };
    let (mut material, radius) = (sand::SAND, 3i64);
    let (mut want, mut frame, mut total) = (Vec::new(), 0usize, 0.0);
    for phase in &PHASES {
        let mut times = Vec::with_capacity(phase.frames);
        for k in 0..phase.frames {
            frame += 1;
            let input = (phase.input)(k, phase.frames);
            material = match input.key {
                "1" => sand::SAND,
                "2" => sand::WALL,
                "3" => sand::WATER,
                "0" => sand::EMPTY,
                _ => material,
            };
            c.write(&rows(&input)).map_err(|e| {
                format!(
                    "frame {frame}: the Input rows were refused: {}",
                    e.refusal.text
                )
            })?;
            let t = Instant::now();
            let s = c.step(0);
            let ms = t.elapsed().as_secs_f64() * 1e3;
            if !s.done || s.frame != frame as u64 {
                return Err(format!("frame {frame}: the step answered {}", s.row()));
            }
            want = if frame == 1 {
                sand::opening(seed)
            } else {
                let (col, row) = input.pointer;
                let brush =
                    (input.left + input.right > 0 && col > 0 && row > 0).then_some(sand::Brush {
                        row: i64::from(row),
                        col: i64::from(col),
                        radius,
                        material: if input.right == 1 {
                            sand::EMPTY
                        } else {
                            material
                        },
                    });
                sand::step(&want, brush.as_ref(), material).0
            };
            let got = plane(&c).map_err(|e| format!("frame {frame}: {e}"))?;
            if let Some(i) = got.iter().zip(&want).position(|(a, b)| a != b) {
                return Err(format!(
                    "(play-differs (frame {frame}) (cell {i}) (engine {}) (reference {}))",
                    got[i], want[i]
                ));
            }
            if frame > 2 {
                times.push(ms);
                total += ms;
            }
        }
        times.sort_by(f64::total_cmp);
        let at = |q: f64| times[((times.len() - 1) as f64 * q).round() as usize];
        let counts = sand::counts(&want);
        println!(
            "{}: median {:.2} ms, p95 {:.2}, longest {:.2}; after it {} sand and {} water",
            phase.name,
            at(0.5),
            at(0.95),
            at(1.0),
            counts[sand::SAND as usize],
            counts[sand::WATER as usize]
        );
    }
    println!("frames 3 to {frame}: {total:.0} ms stepping, every frame held to the sand by hand");
    Ok(())
}

fn main() -> ExitCode {
    let path = match std::env::args().nth(1) {
        Some(p) => PathBuf::from(p),
        None => PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../cartridges/sand/sand.vla"),
    };
    match play(&path) {
        Ok(()) => ExitCode::SUCCESS,
        Err(e) => {
            eprintln!("{e}");
            ExitCode::FAILURE
        }
    }
}

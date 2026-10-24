//! The playtest pass's session (`CART.2`, 2026-10-12; `docs/REARVIEW.md`, the
//! item's entry, "The playtest pass"): Sand played as the host plays it, the
//! Input sheet's eighteen rows written before every step, through a session
//! of eight phases, and every frame's plane held to the sand written by hand,
//! `engine/src/sand.rs`, before any time is printed. Since `CART.12`
//! (decision 8, 2026-10-18), a cartridge named superposition is played by the
//! floors' scripted player instead, at rate 0: each act's Input rows written
//! as the host writes them and the act stepped to its settle's end, through
//! four phases, two worlds at the cartridge's 15%, one at 9%, the percolation
//! threshold's, where an opening winds across the lattice, and one at 15%
//! again, each act's time and frames printed by move; every act's Tally held
//! to the lattice written by hand, `engine/src/superposition.rs`, and the
//! whole lattice at each phase's end.
//!
//! ```text
//! cargo run --release --example play                       # cartridges/sand/sand.vla
//! cargo run --release --example play -- path/to/sand.vla   # another build of the same rule
//! cargo run --release --example play -- cartridges/superposition/superposition.vla
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

use std::path::{Path, PathBuf};
use std::process::ExitCode;
use std::time::Instant;

use alonzo::cartridge::{Cartridge, Seed, Settle};
use vla_lang::calc::{Computed, Value, Values};
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

/// The Input sheet's eighteen rows as the host writes them (`docs/SPEC.md` section
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
    let played = match std::fs::read_to_string(&path) {
        Ok(text) if text.contains("(cartridge \"superposition\"") => {
            play_superposition(&path, &text)
        }
        _ => play(&path),
    };
    match played {
        Ok(()) => ExitCode::SUCCESS,
        Err(e) => {
            eprintln!("{e}");
            ExitCode::FAILURE
        }
    }
}

// ---- Superposition's session (CART.12, decision 8) -------------------------

/// The hand-written lattice, the engine's tests' own file: the rule, the
/// scripted player and the deepest deal.
#[path = "../src/superposition.rs"]
#[allow(dead_code)]
mod superposition;

use superposition::{Inputs, Lattice, Move, Player};

/// The seed the host would choose, fixed here, and the player's.
const SP_SEED: u64 = 20_261_018;
const SP_PLAYER: u64 = 7;

/// A phase of Superposition's session: its name, its acts drawn by the
/// player, and what comes before them: a branch, an edit of the probability,
/// or nothing.
struct SpPhase {
    name: &'static str,
    before: &'static str,
    acts: usize,
}

const SP_PHASES: [SpPhase; 4] = [
    SpPhase {
        name: "the first world at 15%, the deal and 299 acts",
        before: "",
        acts: 300,
    },
    SpPhase {
        name: "a branch to the second world, its deal and 99 acts",
        before: "branch",
        acts: 100,
    },
    SpPhase {
        name: "the probability edited to 9%, the percolation threshold's, a branch, its deal and 19 acts",
        before: "(cell \"Constants\" \"B1\" 0.09)",
        acts: 20,
    },
    SpPhase {
        name: "the probability edited back to 15%, a branch, its deal and 49 acts",
        before: "(cell \"Constants\" \"B1\" 0.15)",
        acts: 50,
    },
];

/// One act through the engine and its settle, the act's rows written as one
/// write first: the time from the write to the settle's last step, and the
/// frames, the hand following them.
fn sp_act(
    c: &mut Cartridge,
    hand: &mut Lattice,
    rows: &str,
    i: &Inputs,
) -> Result<(f64, usize), String> {
    let t = Instant::now();
    if !rows.is_empty() {
        c.write(rows)
            .map_err(|e| format!("the act's rows were refused: {}", e.refusal.text))?;
    }
    let mut frames = 0;
    loop {
        let s = c.step(0);
        frames += 1;
        if !s.done {
            return Err(format!("the step answered {}", s.row()));
        }
        match c.settle() {
            Settle::Settled => break,
            Settle::Settling => {}
            Settle::Unsettled => {
                return Err(format!(
                    "frame {}: the act did not settle inside its K",
                    s.frame
                ))
            }
        }
    }
    let ms = t.elapsed().as_secs_f64() * 1e3;
    let mut now = i.clone();
    for _ in 0..frames {
        hand.frame(&now);
        now = now.released();
    }
    Ok((ms, frames))
}

/// A cell's computed number, NaN where it holds no number.
fn sp_number(c: &Cartridge, sheet: usize, row: u32, col: u32) -> f64 {
    match c.machine().computed((sheet, row, col)) {
        Some(Computed::Value(Value::Number(n))) => n,
        Some(Computed::Value(Value::Empty)) | None => 0.0,
        _ => f64::NAN,
    }
}

/// The lattice held to the hand: each row's sum on the Tally, and with
/// `whole` every site of the Field.
fn sp_hold(c: &Cartridge, hand: &Lattice, whole: bool, at: &str) -> Result<(), String> {
    let n = hand.n;
    let field = c.machine().find_sheet("Field").ok_or("no Field")?;
    let tally = c.machine().find_sheet("Tally").ok_or("no Tally")?;
    for r in 1..=n {
        let got = sp_number(c, tally, r, n / 32 + 2);
        if got != hand.row_sum(r) as f64 {
            return Err(format!(
                "(play-differs ({at}) (tally-row {r}) (engine {got}) (reference {}))",
                hand.row_sum(r)
            ));
        }
        if whole {
            for col in 1..=n {
                let got = sp_number(c, field, r, col);
                if got != hand.site(r, col) as f64 {
                    return Err(format!("(play-differs ({at}) (row {r}) (column {col}) (engine {got}) (reference {}))", hand.site(r, col)));
                }
            }
        }
    }
    Ok(())
}

/// The nearest rank's quantile of sorted times.
fn rank(sorted: &[f64], q: f64) -> f64 {
    let n = sorted.len();
    sorted[((q * n as f64).ceil() as usize).clamp(1, n) - 1]
}

/// Superposition played as a person who knows the lattice would play it
/// (`CART.12`, decision 8): the floors' scripted player through four phases,
/// two worlds at the cartridge's 15%, one at 9% where an opening winds across
/// the lattice, and one at 15% again, each act's Input rows written as the
/// host writes them at rate 0 (version 6) and each act stepped to its
/// settle's end; every act's Tally held to the hand, and the whole lattice at
/// each phase's end.
fn play_superposition(path: &Path, text: &str) -> Result<(), String> {
    let t = Instant::now();
    let mut c = Cartridge::load(text, "superposition.vla", text.len()).map_err(|e| {
        format!(
            "{}: refused at line {}: {}",
            path.display(),
            e.line,
            e.refusal.text
        )
    })?;
    let load_ms = t.elapsed().as_secs_f64() * 1e3;
    c.write(&format!("(cell \"Clock\" \"B3\" {SP_SEED})"))
        .map_err(|e| format!("the seed was refused: {}", e.refusal.text))?;
    let mut hand = Lattice::new(512, SP_SEED, 0.15);
    let (settle_ms, settle) = sp_act(&mut c, &mut hand, "", &Inputs::default())?;
    println!(
        "superposition: load {load_ms:.1} ms; {} formula cells; the load's act and its settle {settle} frames, {settle_ms:.1} ms; the seed {SP_SEED}, the player's {SP_PLAYER}",
        c.machine().formulas().0
    );
    let mut player = Player::new(SP_PLAYER);
    let mut known: Option<Vec<String>> = None;
    let (mut total, mut frames_all) = (0.0, settle);
    for phase in &SP_PHASES {
        let (mut times, mut by): (Vec<f64>, std::collections::BTreeMap<Move, Vec<f64>>) =
            (Vec::new(), Default::default());
        let (mut frames, mut deepest) = (0, 0);
        if phase.before.starts_with('(') {
            // a person's edit of the probability, an act of its own, the hand
            // reading it as the lattice does
            hand.probability = phase
                .before
                .trim_end_matches(')')
                .rsplit(' ')
                .next()
                .and_then(|v| v.parse().ok())
                .ok_or("the edit's probability")?;
            let (ms, n) = sp_act(&mut c, &mut hand, phase.before, &Inputs::default())?;
            frames += n;
            total += ms;
        }
        if !phase.before.is_empty() {
            let branch = Inputs {
                sheet: "Field".to_string(),
                command: "branch".to_string(),
                ..Inputs::default()
            };
            let rows = act_rows(&branch, &mut known);
            let (ms, n) = sp_act(&mut c, &mut hand, &rows, &branch)?;
            frames += n;
            total += ms;
        }
        for _ in 0..phase.acts {
            let (kind, inputs) = player.act(&hand);
            let rows = act_rows(&inputs, &mut known);
            let (ms, n) = sp_act(&mut c, &mut hand, &rows, &inputs)?;
            sp_hold(&c, &hand, false, &format!("an act of {}", phase.name))?;
            times.push(ms);
            by.entry(kind).or_default().push(ms);
            frames += n;
            deepest = deepest.max(n);
            total += ms;
        }
        sp_hold(&c, &hand, true, &format!("the end of {}", phase.name))?;
        frames_all += frames;
        times.sort_by(f64::total_cmp);
        let observed = (1..=512)
            .flat_map(|r| (1..=512).map(move |col| (r, col)))
            .filter(|&(r, col)| hand.site(r, col) != superposition::UNOBSERVED)
            .count();
        println!(
            "{}: {} acts over {frames} frames, each from its rows to its settle's end: median {:.2} ms, p95 {:.2}, longest {:.2}, the longest settle {deepest} frames; after it {observed} sites out of superposition in world {}",
            phase.name,
            times.len(),
            rank(&times, 0.5),
            rank(&times, 0.95),
            times[times.len() - 1],
            hand.world + 1
        );
        let moves: Vec<String> = Move::ALL
            .iter()
            .filter_map(|m| {
                let mut v = by.get(m)?.clone();
                v.sort_by(f64::total_cmp);
                Some(format!(
                    "{} {}, median {:.2} ms, longest {:.2}",
                    m.words(),
                    v.len(),
                    rank(&v, 0.5),
                    v[v.len() - 1]
                ))
            })
            .collect();
        println!("  by move: {}", moves.join("; "));
    }
    println!("the session: {frames_all} frames, {total:.0} ms in its acts, every act's Tally held to the lattice by hand and the whole lattice at each phase's end");
    Ok(())
}

/// The Input rows an act writes at rate 0, as the host writes them: the rows
/// that differ from those last written, all seven at the first act, the
/// engine's release of the press and the command held there.
fn act_rows(i: &Inputs, known: &mut Option<Vec<String>>) -> String {
    const AT: [&str; 7] = ["B11", "B12", "B13", "B14", "B15", "B19", "B20"];
    let want = vec![
        i.column.to_string(),
        i.row.to_string(),
        u8::from(i.left).to_string(),
        u8::from(i.right).to_string(),
        u8::from(i.middle).to_string(),
        format!("\"{}\"", i.sheet),
        format!("\"{}\"", i.command),
    ];
    let rows: Vec<String> = (0..7)
        .filter(|&k| known.as_ref().map_or(true, |kn| kn[k] != want[k]))
        .map(|k| format!("(cell \"Input\" \"{}\" {})", AT[k], want[k]))
        .collect();
    let mut kept = want;
    for k in [2, 3, 4] {
        kept[k] = "0".to_string();
    }
    kept[6] = "\"\"".to_string();
    *known = Some(kept);
    rows.join("\n")
}

//! The native runner of the frame floors (`CART.1`; `docs/REARVIEW.md`, the
//! item's scoping, decisions 2, 3, 5 and 7), and since `ENGINE.9` of the
//! size ladder: a cartridge loaded through the engine's own `Cartridge`,
//! stepped frame by frame and timed, every frame's plane held to a Life, or
//! a Sand, written by hand before any number is printed, since a fast wrong
//! answer is no floor.
//!
//! ```text
//! cargo run --release --example frames                  # the three fixtures and the ladder's four rungs, 31 frames each, the baseline rows
//! cargo run --release --example frames -- --check       # 4 frames each: the frames, the allocations and the memory held
//! cargo run --release --example frames -- --frames 61 cartridges/gun/gun.vla
//! ```
//!
//! **The reference.** Life computed every cell every generation, the honest
//! comparison `docs/CHARTER.md` section 7 names: the soup of `life.vla` from its
//! own arithmetic and the manifest's seed, or the pattern of a cartridge's
//! `Seed` sheet read off its rows, then Conway's rule with the border dead,
//! over the fixture's whole board. It is a third Life outside the engine,
//! beside the page's and the engine test's. For the gun it also holds the
//! pattern's published facts (LifeWiki, "Gosper glider gun"): period 30, 36
//! cells, one glider of 5 a period, each held every 30 generations through
//! 720, before the first glider meets the window's border at 740, the
//! generation where the bounded plane and Golly's stop agreeing. Since
//! `CART.2` (2026-10-11), the cartridge named `sand` is held to the
//! hand-written sand the engine's tests hold it to, `engine/src/sand.rs`,
//! included here by its path: the opening, Life's soup as grains, then the
//! rule, every frame after the first keeping every grain.
//!
//! **The ladder** (`ENGINE.9`, 2026-10-14). A fixture whose source stands
//! beside it and states its board as a parameter, `board-size`, climbs the
//! size ladder: the pass builds the source again with the ladder's definition
//! after its own (`alonzo::pass::expand_with`; `engine/src/ladder.rs`,
//! included here by its path), on boards of four and sixteen times the
//! window's area, 640 by 400 and 1280 by 800, each under a still Camera at
//! its top-left. Each rung is a fixture of its own, `life-x4` and
//! `life-x16`, `gun-x4` and `gun-x16`, timed and held as the window's is,
//! every frame over its whole board, and named by the SHA-256 over LF of the
//! cartridge the pass wrote (`engine/src/sha256.rs`, included by its path),
//! which the page prints too, so that the instrument holds the two halves to
//! the same rows. Sand states no board and stays at its one rung. After the
//! rows the runner reads the slope off the rungs: each rung's frame, load and
//! memory over the window's, and the exponent against the formula cells.
//!
//! **The timings.** Each frame is one `step` with no budget, timed alone; the
//! steady frames are the second onward, and their median is the floor's
//! number, in cells evaluated a second (the step's formula cells over the
//! median) and in frames a second (one over it), one measurement in two
//! units. A steady frame under 2 ms, the page's own line, is timed again past
//! them in runs of consecutive frames, as the page times one (`CART.1`,
//! 2026-10-10), each run one span with nothing viewed inside it, and every
//! frame stepped held again on a second instance stepped untimed. The rows
//! say `Run`, the frames a run, 1 where a frame is timed alone. Since
//! `ENGINE.9` the runs are ten of 64 frames, frames N + 1 to N + 640, back to
//! back, the last frame held after them: for the gun at N = 31, frames 32 to
//! 671, inside its facts' span, where every rung of the ladder holds the same
//! cells. Past it the window's gliders die at its border from generation 740
//! while a larger board's fly on, and the runs before, doubled from 2 frames
//! until a run lasted 2 ms and so timing frames 158 to 3,997, would read a
//! larger board dearer for its gliders and not its size (measured in the
//! item's scoping), so the runner refuses `--frames` past 80 where the gun is
//! timed. Each run's last frame was held between the runs until then, and on
//! a large board the reference's generations and the plane's view swept
//! megabytes through the cache before the next run, which its first frames
//! paid for: the gun's top rung read 1.36 times the window's so, and 1.16 and
//! 1.21 with nothing between the runs (measured in the item's build).
//! `Instant` reads nanoseconds, so the reason for runs was not the clock's
//! step, as it is the page's, but the clock this runner read beside every
//! frame until 2026-10-12: a frame timed alone came right after it, and
//! the gun's frames 2 to 31 read 22 to 48 microseconds with it in one sitting
//! and 12.3 to 13.2 without it, where the floors' margin is 10%. A frame's
//! time under 1 ms prints to a tenth of a microsecond, as the page prints it.
//! Three times before a fixture's first frame, and three times after its
//! steady frames or runs, the hand-written Life runs a fixed workload, the
//! soup's first generations, and is timed too: the processor's clock seen from
//! a computation that never changes. When its readings move more than 10%,
//! their range over their median or their median from the runner's start, the
//! run is not a baseline, and the runner says so and prints no rows. It is
//! never read between two frames (`CART.1`'s decision 5, reopened 2026-10-12):
//! read beside every frame, it slowed the frame after it, Life's steady frames
//! from 2.7 to 2.9 ms to 3.1 to 3.2 and Sand's by 3%, in four alternated pairs
//! over `vla-lang` 0.9.1. A run throttled while it runs now shows as its two
//! sides apart.
//! On the owner's machine Windows throttles a background process about three
//! seconds into a run, by about 40% (measured 2026-10-09); `tools/bench_frames.ps1`
//! starts this runner with its process opted out of that.
//!
//! **The memory** (`ENGINE.9`). After a fixture's timing, and in the check, a
//! fresh instance of it is loaded and stepped four frames, each frame viewed
//! and held as the host views one, while the runner's allocator counts the
//! heap's live bytes from before the load: their high-water mark is the row's
//! `Memory`, the bytes the load and the first frames needed at once, exact
//! for a build, as the page's module memory is, and the bytes held after the
//! fourth frame are printed beside it. The reference's planes are made before
//! the count begins, and the language makes its head table and its catalogs
//! on first use, so a load counted nowhere makes them before anything is.
//!
//! **The check.** With `--check` the runner times nothing it claims: it steps
//! each fixture four frames on that counted instance, holds them to the
//! reference, holds the gun to its facts and Sand to its grains, counts the
//! heap's allocations and reallocations in the second frame after the load,
//! and the heap's high-water bytes, exact on every run, so that
//! `tools/check_frame_floors.ps1` holds them to ceilings, and each rung's
//! digest to the measured one, on every push where no time can be held. It
//! counts only there: counting while timing costs a frame about a tenth
//! (measured in `CART.1`'s scoping).
//!
//! The runner is an example and not a member of the workspace, so the lock
//! holds no third package and the engine still depends on the language crate
//! alone (`AD-5`); its allocator is its own and ships in nothing.

use std::alloc::{GlobalAlloc, Layout, System};
use std::collections::BTreeSet;
use std::hint::black_box;
use std::path::{Path, PathBuf};
use std::process::ExitCode;
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::time::Instant;

use alonzo::cartridge::{Cartridge, Manifest, Seed};
use alonzo::pass::{expand_with, folder_of, includes};
use vla_lang::machine::{Step, Viewed, CELLS};
use vla_lang::reader::read_forms;
use vla_lang::sheet::parse_a1_range;

// The hand-written sand, the engine's tests' own file; the runner steps the
// opening and paints nothing, so the brush is the tests' alone.
#[path = "../src/sand.rs"]
#[allow(dead_code)]
mod sand;

// The ladder's rungs and the definition that builds a source on one, the
// engine's tests' own file (ENGINE.9).
#[path = "../src/ladder.rs"]
mod ladder;

// SHA-256, the engine's tests' own, which names each rung's cartridge.
#[path = "../src/sha256.rs"]
mod sha256;

// ---- the allocator: the system's, counted when asked ----------------------

static COUNTING: AtomicBool = AtomicBool::new(false);
static ALLOCS: AtomicU64 = AtomicU64::new(0);
static REALLOCS: AtomicU64 = AtomicU64::new(0);
static SIZING: AtomicBool = AtomicBool::new(false);
static LIVE: AtomicU64 = AtomicU64::new(0);
static PEAK: AtomicU64 = AtomicU64::new(0);

/// The system's allocator, counting allocations and reallocations while
/// `COUNTING` is set, and the heap's live bytes and their high-water mark
/// while `SIZING` is (`ENGINE.9`). The runner steps on one thread, so a count
/// is a load and a store and never a locked add.
struct Counted;

fn tally(counter: &AtomicU64) {
    if COUNTING.load(Ordering::Relaxed) {
        counter.store(counter.load(Ordering::Relaxed) + 1, Ordering::Relaxed);
    }
}

/// Bytes taken while sizing, the high-water mark moved with them.
fn grow(bytes: usize) {
    if SIZING.load(Ordering::Relaxed) {
        let live = LIVE.load(Ordering::Relaxed) + bytes as u64;
        LIVE.store(live, Ordering::Relaxed);
        if live > PEAK.load(Ordering::Relaxed) {
            PEAK.store(live, Ordering::Relaxed);
        }
    }
}

/// Bytes given back while sizing; a block taken before the count began is
/// given back to nothing below 0.
fn shrink(bytes: usize) {
    if SIZING.load(Ordering::Relaxed) {
        let live = LIVE.load(Ordering::Relaxed).saturating_sub(bytes as u64);
        LIVE.store(live, Ordering::Relaxed);
    }
}

unsafe impl GlobalAlloc for Counted {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        tally(&ALLOCS);
        let p = unsafe { System.alloc(layout) };
        if !p.is_null() {
            grow(layout.size());
        }
        p
    }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        tally(&ALLOCS);
        let p = unsafe { System.alloc_zeroed(layout) };
        if !p.is_null() {
            grow(layout.size());
        }
        p
    }

    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        shrink(layout.size());
        unsafe { System.dealloc(ptr, layout) }
    }

    unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, new_size: usize) -> *mut u8 {
        tally(&REALLOCS);
        let p = unsafe { System.realloc(ptr, layout, new_size) };
        if !p.is_null() {
            if new_size >= layout.size() {
                grow(new_size - layout.size());
            } else {
                shrink(layout.size() - new_size);
            }
        }
        p
    }
}

#[global_allocator]
static GLOBAL: Counted = Counted;

/// `SIZING` set for this value's life, so that a refusal on the way out of a
/// counted instance still ends the count.
struct Sizing;

impl Sizing {
    fn begin() -> Sizing {
        LIVE.store(0, Ordering::Relaxed);
        PEAK.store(0, Ordering::Relaxed);
        SIZING.store(true, Ordering::Relaxed);
        Sizing
    }
}

impl Drop for Sizing {
    fn drop(&mut self) {
        SIZING.store(false, Ordering::Relaxed);
    }
}

// ---- the reference: Life by hand ------------------------------------------

/// A board: the Screen's cells a fixture's rule covers, the window's own,
/// `A1:LH200`, or a rung of the ladder's (`ENGINE.9`).
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Board {
    w: usize,
    h: usize,
}

/// The window: the plane the manifest declares, 320 by 200.
const WINDOW: Board = Board {
    w: ladder::WINDOW.0,
    h: ladder::WINDOW.1,
};

impl Board {
    fn cells(self) -> usize {
        self.w * self.h
    }

    /// The whole board as a range, `A1:LH200` for the window.
    fn range(self) -> String {
        format!("A1:{}{}", ladder::letters(self.w), self.h)
    }
}

/// The clock: the hand-written Life's generations in a batch, and the
/// batches, the best of which is the clock's reading; the readings at the
/// runner's start, and on each side of a fixture's frames.
const PROBE_GENERATIONS: usize = 20;
const PROBE_BATCHES: usize = 3;
const START_READINGS: usize = 5;
const SIDE_READINGS: usize = 3;

/// The most the hand-written Life's time may move across a run, in percent.
const CLOCK_SPREAD_MAX: f64 = 10.0;

/// A steady frame quicker than this, timed alone, is timed again in runs of
/// consecutive frames, the page's twenty steps of Chrome's clock: `RUNS`
/// runs of `RUN_FRAMES` frames each, from the frame after the last one timed
/// alone (`ENGINE.9`, decision 5).
const RUN_MS: f64 = 2.0;
const RUNS: usize = 10;
const RUN_FRAMES: usize = 64;

/// The frames a counted instance steps, the check's and the memory's.
const CHECK_FRAMES: usize = 4;

/// The gun's published facts: a period, the cells of one glider, and the last
/// generation they are held to, before a glider meets the window's dead
/// border at 740.
const GUN_PERIOD: usize = 30;
const GUN_CELLS: usize = 36;
const GLIDER_CELLS: usize = 5;
const GUN_THROUGH: usize = 720;

/// The soup of `life.vla`'s first frame over a board, its own arithmetic: two
/// linear forms of the seed, the row and the column modulo a prime, their
/// product `h`, and a cell alive when `h * h` modulo the prime is under three
/// eighths of it.
fn soup(seed: u64, b: Board) -> Vec<u8> {
    let p: u64 = 67_108_859;
    let t: u64 = 25_165_822;
    let mut g = vec![0u8; b.cells()];
    for r in 2..b.h as u64 {
        for c in 2..b.w as u64 {
            let a = (seed * 1_103_515 + r * 1_597_334 + c * 1_830_421 + 12_345) % p;
            let x = (seed * 2_012_345 + r * 1_209_487 + c * 1_949_213 + 54_321) % p;
            let h = (a * x) % p;
            g[(r as usize - 1) * b.w + (c as usize - 1)] = u8::from((h * h) % p < t);
        }
    }
    g
}

/// A cartridge's `Seed` sheet as a plane of a board, read off its rows,
/// `(cell "Seed" "J14" 1)`, and not off the engine's grid.
fn seeded(text: &str, b: Board) -> Vec<u8> {
    let mut g = vec![0u8; b.cells()];
    for line in text.lines() {
        let Some(rest) = line.trim().strip_prefix("(cell \"Seed\" \"") else {
            continue;
        };
        let Some((addr, value)) = rest.split_once('"') else {
            continue;
        };
        if value.trim().trim_end_matches(')').trim() != "1" {
            continue;
        }
        if let Some(a) = parse_a1_range(addr) {
            let (row, col) = (a.top as usize, a.left as usize);
            if (1..=b.h).contains(&row) && (1..=b.w).contains(&col) {
                g[(row - 1) * b.w + (col - 1)] = 1;
            }
        }
    }
    g
}

/// One generation of Conway's rule over a board into `n`, whose border is
/// left as it is, dead.
fn generation_into(g: &[u8], n: &mut [u8], b: Board) {
    let w = b.w;
    for r in 1..b.h - 1 {
        for c in 1..w - 1 {
            let i = r * w + c;
            let others = g[i - w - 1]
                + g[i - w]
                + g[i - w + 1]
                + g[i - 1]
                + g[i + 1]
                + g[i + w - 1]
                + g[i + w]
                + g[i + w + 1];
            n[i] = u8::from(others == 3 || (g[i] == 1 && others == 2));
        }
    }
}

/// One generation of Conway's rule over a board, the border dead.
fn generation(g: &[u8], b: Board) -> Vec<u8> {
    let mut n = vec![0u8; b.cells()];
    generation_into(g, &mut n, b);
    n
}

fn live(g: &[u8]) -> usize {
    g.iter().filter(|b| **b == 1).count()
}

/// `B5` for a plane's index on a board.
fn cell_name(i: usize, b: Board) -> String {
    format!("{}{}", ladder::letters(i % b.w + 1), i / b.w + 1)
}

/// The gun's facts held on the hand-written Life from its first generation:
/// every `GUN_PERIOD` generations through `GUN_THROUGH`, the gun's box equal
/// to the first generation's and the population `GUN_CELLS` plus a glider's
/// cells a period. The periods held, or the first fact that failed. On every
/// rung of the ladder, whose borders the stream meets later than the window's.
fn gun_facts(start: &[u8], b: Board) -> Result<usize, String> {
    if live(start) != GUN_CELLS {
        return Err(format!(
            "the Seed holds {} live cells, not the gun's {GUN_CELLS}",
            live(start)
        ));
    }
    let (mut top, mut left) = (b.h, b.w);
    for (i, x) in start.iter().enumerate() {
        if *x == 1 {
            top = top.min(i / b.w);
            left = left.min(i % b.w);
        }
    }
    let boxed = |g: &[u8]| -> Vec<u8> {
        let mut v = Vec::with_capacity(9 * 36);
        for r in top..(top + 9).min(b.h) {
            for c in left..(left + 36).min(b.w) {
                v.push(g[r * b.w + c]);
            }
        }
        v
    };
    let first = boxed(start);
    let mut g = start.to_vec();
    for n in 1..=GUN_THROUGH {
        g = generation(&g, b);
        if n % GUN_PERIOD == 0 {
            let k = n / GUN_PERIOD;
            if boxed(&g) != first {
                return Err(format!(
                    "at generation {n} the gun's box is not its first generation's"
                ));
            }
            if live(&g) != GUN_CELLS + GLIDER_CELLS * k {
                return Err(format!(
                    "at generation {n} the plane holds {} live cells, not {}",
                    live(&g),
                    GUN_CELLS + GLIDER_CELLS * k
                ));
            }
        }
    }
    Ok(GUN_THROUGH / GUN_PERIOD)
}

/// The hand-written Life over a fixed workload on the window, timed:
/// milliseconds a generation, the processor's clock as a computation that
/// never changes sees it. Two planes kept for the probe's life, stepped into
/// each other, so the probe allocates nothing; a generation untimed first,
/// to warm them after the step that ran before; the best of a few batches,
/// so an interruption is not read as the clock.
struct Probe {
    fixed: Vec<u8>,
    a: Vec<u8>,
    b: Vec<u8>,
}

impl Probe {
    fn new(fixed: Vec<u8>) -> Probe {
        let a = fixed.clone();
        let b = vec![0u8; fixed.len()];
        Probe { fixed, a, b }
    }

    fn read(&mut self) -> f64 {
        let mut best = f64::INFINITY;
        for _ in 0..PROBE_BATCHES {
            self.a.copy_from_slice(&self.fixed);
            generation_into(&self.a, &mut self.b, WINDOW);
            let t = Instant::now();
            for _ in 0..PROBE_GENERATIONS / 2 {
                generation_into(black_box(&self.a), &mut self.b, WINDOW);
                generation_into(black_box(&self.b), &mut self.a, WINDOW);
            }
            black_box(&self.a);
            best = best.min(t.elapsed().as_secs_f64() * 1e3);
        }
        best / (PROBE_GENERATIONS / 2 * 2) as f64
    }
}

fn median(v: &[f64]) -> f64 {
    let mut s = v.to_vec();
    s.sort_by(f64::total_cmp);
    let n = s.len();
    if n == 0 {
        0.0
    } else if n % 2 == 1 {
        s[n / 2]
    } else {
        (s[n / 2 - 1] + s[n / 2]) / 2.0
    }
}

/// How far a clock's reading is from the one at the start, in percent; 0 when
/// there is no start.
fn drift(now: f64, start: f64) -> f64 {
    if start <= 0.0 {
        0.0
    } else {
        (now / start - 1.0) * 100.0
    }
}

/// The least and the most of some readings.
fn range(v: &[f64]) -> (f64, f64) {
    let lo = v.iter().copied().fold(f64::INFINITY, f64::min);
    let hi = v.iter().copied().fold(0.0, f64::max);
    (lo, hi)
}

fn thousands(n: u64) -> String {
    let s = n.to_string();
    let mut out = String::new();
    for (i, ch) in s.chars().enumerate() {
        if i > 0 && (s.len() - i) % 3 == 0 {
            out.push(',');
        }
        out.push(ch);
    }
    out
}

/// A frame's time as the rows print it, the page's own rule: to a tenth of a
/// millisecond from 1 ms, and to a tenth of a microsecond under it, so that a
/// frame of 20 microseconds is not printed as nothing (CART.1, 2026-10-10).
fn ms(x: f64) -> String {
    if x >= 1.0 {
        format!("{x:.1}")
    } else {
        format!("{x:.4}")
    }
}

// ---- the fixtures: a file, and the rungs its source climbs ----------------

/// A cartridge the floors measure: a file, or a rung of the size ladder the
/// pass built from the file's source (`ENGINE.9`).
struct Fixture {
    /// The row's name: the manifest's, with `-x4` or `-x16` after it for a rung.
    name: String,
    text: String,
    /// Where the text came from, for words: the file, or the source.
    from: PathBuf,
    manifest: Manifest,
    board: Board,
    /// A rung's multiple of the window's area, and its cartridge's SHA-256
    /// over LF.
    rung: Option<(usize, String)>,
}

/// A cartridge's manifest read as the load reads it, so that a fixture is
/// named and its first frame known before any instance of it is loaded.
fn manifest_of(text: &str, from: &Path) -> Result<Manifest, String> {
    let forms =
        read_forms(text).map_err(|r| format!("{}: cannot be read: {}", from.display(), r.text))?;
    let form = forms
        .iter()
        .find(|f| f.head_is("cartridge"))
        .ok_or_else(|| format!("{}: holds no manifest", from.display()))?;
    Manifest::read(form).map_err(|r| {
        format!(
            "{}: its manifest is refused at line {}: {}",
            from.display(),
            r.line,
            r.refusal.text
        )
    })
}

/// The texts a source may include, read under the keys the pass resolves
/// them by, as `examples/expand.rs` reads them: its includes, and theirs,
/// each against the source's own folder, each read once.
fn gather(path: &str, text: &str) -> Vec<(String, String)> {
    let folder = folder_of(path).to_string();
    let mut files = Vec::new();
    let mut seen = BTreeSet::new();
    let mut queue = includes(text, &folder);
    while let Some(key) = queue.pop() {
        if !seen.insert(key.clone()) {
            continue;
        }
        if let Ok(body) = std::fs::read_to_string(&key) {
            queue.extend(includes(&body, &folder));
            files.push((key, body));
        }
    }
    files
}

/// The fixture a file holds, then the rungs its source climbs: none where no
/// source stands beside it, `<name>.source.vla`, or the source states no
/// board.
fn fixtures_of(path: &Path) -> Result<Vec<Fixture>, String> {
    let text = std::fs::read_to_string(path)
        .map_err(|e| format!("{}: cannot be read: {e}", path.display()))?;
    let manifest = manifest_of(&text, path)?;
    let name = manifest.name.clone();
    let mut out = vec![Fixture {
        name: name.clone(),
        text,
        from: path.to_path_buf(),
        manifest,
        board: WINDOW,
        rung: None,
    }];
    let Some(stem) = path.file_stem().map(|s| s.to_string_lossy().to_string()) else {
        return Ok(out);
    };
    let source_path = path.with_file_name(format!("{stem}.source.vla"));
    let Ok(source) = std::fs::read_to_string(&source_path) else {
        return Ok(out);
    };
    if !ladder::climbs(&source) {
        return Ok(out);
    }
    let key = source_path.to_string_lossy().replace('\\', "/");
    let files = gather(&key, &source);
    for (times, w, h) in ladder::RUNGS {
        let e = expand_with(&source, &key, &files, &ladder::definition(w, h)).map_err(|r| {
            format!(
                "{key}: the pass refused the board of {w} by {h} at line {}: {}",
                r.line, r.refusal.text
            )
        })?;
        let digest = sha256::sha256_hex(e.text.replace("\r\n", "\n").as_bytes());
        let manifest = manifest_of(&e.text, &source_path)?;
        out.push(Fixture {
            name: format!("{name}-x{times}"),
            text: e.text,
            from: source_path.clone(),
            manifest,
            board: Board { w, h },
            rung: Some((times, digest)),
        });
    }
    Ok(out)
}

/// What one fixture's timed run measured.
struct Run {
    name: String,
    cells: usize,
    load_ms: f64,
    times: Vec<f64>,
    clocks: Vec<f64>,
    facts: Option<usize>,
    /// Sand's frames after the first, each keeping every grain.
    conserved: Option<usize>,
    /// The frames a run, 1 where each steady frame is timed alone.
    run: usize,
    /// Where the steady frames were timed in runs: the median of frames 2 to
    /// N timed alone, and the frames stepped in all, each held on a second
    /// instance.
    alone: Option<(f64, usize)>,
    /// The counted instance's measure, the memory among it (`ENGINE.9`).
    counts: Option<Counts>,
}

impl Run {
    fn steady(&self) -> Vec<f64> {
        self.times.iter().skip(1).copied().collect()
    }

    /// How far the clock moved between its readings before the fixture's
    /// frames and after them: their range over their median, in percent. Each
    /// reading is the best of its batches, so one batch interrupted is not a
    /// moved clock, and a run throttled after its start reads slower after.
    fn spread(&self) -> f64 {
        let m = median(&self.clocks);
        if m <= 0.0 || self.clocks.is_empty() {
            return 0.0;
        }
        let (lo, hi) = range(&self.clocks);
        (hi - lo) / m * 100.0
    }
}

/// What a counted instance measured: its frames held, the second frame's
/// allocations, and the heap (`ENGINE.9`).
struct Counts {
    frames: usize,
    allocs: u64,
    reallocs: u64,
    /// The heap's high-water mark from before the load to after the last
    /// frame.
    memory: u64,
    /// The heap the cartridge holds after its last frame.
    resident: u64,
    /// The cells its grid holds, which the language's `CELLS` caps.
    grid: usize,
    /// Its formula cells.
    cells: usize,
}

fn plane(c: &Cartridge, b: Board) -> Result<Vec<u8>, String> {
    match c.view("plane", "Screen", Some(&b.range())) {
        Ok(Viewed::Bytes(bytes)) => Ok(bytes),
        Ok(Viewed::Text(_)) => Err("the plane answered text".to_string()),
        Err(r) => Err(format!("the plane was refused: {}", r.text)),
    }
}

fn load(text: &str, path: &Path) -> Result<Cartridge, String> {
    Cartridge::load(text, "frames.vla", text.len()).map_err(|e| {
        format!(
            "{}: refused at line {}: {}",
            path.display(),
            e.line,
            e.refusal.text
        )
    })
}

fn is_sand(fx: &Fixture) -> bool {
    fx.manifest.name == "sand"
}

/// The reference's first frame: the Seed's rows, the soup of the manifest's
/// seed, or Sand's opening, on the fixture's board.
fn first_plane(fx: &Fixture) -> Result<Vec<u8>, String> {
    if fx.text.contains("(cell \"Seed\"") {
        return Ok(seeded(&fx.text, fx.board));
    }
    match (fx.manifest.seed, is_sand(fx)) {
        (Seed::Number(n), false) => Ok(soup(u64::from(n), fx.board)),
        (Seed::Number(n), true) if fx.board == WINDOW => Ok(sand::opening(u64::from(n))),
        (Seed::Number(_), true) => Err(format!(
            "{}: Sand's reference holds the window's board alone",
            fx.name
        )),
        (Seed::Host, _) => Err(format!("{}: a soup needs the manifest's seed", fx.name)),
    }
}

/// The reference one frame on: Conway's generation, or Sand's step, which
/// keeps every grain.
fn next(fx: &Fixture, f: usize, want: &[u8]) -> Result<Vec<u8>, String> {
    if !is_sand(fx) {
        return Ok(generation(want, fx.board));
    }
    let before = sand::counts(want);
    let after = sand::step(want, None, sand::SAND).0;
    if sand::counts(&after) != before {
        return Err(format!(
            "(frames-grains \"{}\" (frame {f}) (before {before:?}) (after {:?}))",
            fx.name,
            sand::counts(&after)
        ));
    }
    Ok(after)
}

/// The reference's planes for frames 1 to `n`, made before a count begins.
fn planes(fx: &Fixture, n: usize) -> Result<Vec<Vec<u8>>, String> {
    let mut out = vec![first_plane(fx)?];
    for f in 2..=n {
        let after = next(fx, f, &out[f - 2])?;
        out.push(after);
    }
    Ok(out)
}

/// The plane after frame `f` held to the reference.
fn hold(cart: &Cartridge, name: &str, f: usize, want: &[u8], b: Board) -> Result<(), String> {
    let got = plane(cart, b).map_err(|e| format!("{name}: {e}"))?;
    if got.len() != want.len() {
        return Err(format!(
            "{name}: the plane holds {} cells, the board {}",
            got.len(),
            want.len()
        ));
    }
    if let Some(i) = got.iter().zip(want).position(|(a, w)| a != w) {
        return Err(format!(
            "(frames-differ \"{name}\" (frame {f}) (cell \"{}\") (engine {}) (reference {}))",
            cell_name(i, b),
            got[i],
            want[i]
        ));
    }
    Ok(())
}

/// Frames `f0` to `f0 + n - 1` stepped as one span with nothing viewed inside
/// it, timed; then each step's answer said to be its frame and done.
fn span(
    cart: &mut Cartridge,
    name: &str,
    f0: usize,
    n: usize,
    answers: &mut Vec<Step>,
) -> Result<f64, String> {
    answers.clear();
    answers.reserve(n);
    let t = Instant::now();
    for _ in 0..n {
        answers.push(cart.step(0));
    }
    let ms = t.elapsed().as_secs_f64() * 1e3;
    for (j, s) in answers.iter().enumerate() {
        if s.frame != (f0 + j) as u64 || !s.done {
            return Err(format!("{name}: the step answered {}", s.row()));
        }
    }
    Ok(ms)
}

/// A fresh instance of a fixture, loaded and stepped a frame for each of the
/// reference's `wants`, each frame viewed and held as the host views one,
/// with the second frame's allocations counted and the heap's bytes counted
/// from before the load (`ENGINE.9`, decision 6). The reference's planes are
/// made before the count begins, so the bytes counted are the engine's and
/// the planes it hands back, a transient the host's blit makes too.
fn measure(fx: &Fixture, wants: &[Vec<u8>]) -> Result<Counts, String> {
    let sizing = Sizing::begin();
    let mut cart = load(&fx.text, &fx.from)?;
    let (mut allocs, mut reallocs) = (0, 0);
    for (i, want) in wants.iter().enumerate() {
        let f = i + 1;
        let counted = f == 2;
        if counted {
            ALLOCS.store(0, Ordering::Relaxed);
            REALLOCS.store(0, Ordering::Relaxed);
            COUNTING.store(true, Ordering::Relaxed);
        }
        let s = cart.step(0);
        if counted {
            COUNTING.store(false, Ordering::Relaxed);
            allocs = ALLOCS.load(Ordering::Relaxed);
            reallocs = REALLOCS.load(Ordering::Relaxed);
        }
        if s.frame != f as u64 || !s.done {
            return Err(format!("{}: the step answered {}", fx.name, s.row()));
        }
        hold(&cart, &fx.name, f, want, fx.board)?;
    }
    let (memory, resident) = (PEAK.load(Ordering::Relaxed), LIVE.load(Ordering::Relaxed));
    drop(sizing);
    Ok(Counts {
        frames: wants.len(),
        allocs,
        reallocs,
        memory,
        resident,
        grid: cart.machine().loaded().cells,
        cells: cart.machine().formulas().0,
    })
}

/// A cartridge stepped `frames` frames, timed, every frame held to the
/// reference. Where the steady frames timed alone read under `RUN_MS`, they
/// are timed again past them in `RUNS` runs of `RUN_FRAMES` consecutive
/// frames, back to back, the last frame held to the reference after them,
/// and every frame stepped is held on a second instance stepped untimed
/// (2026-10-12; the runs' length and their order since `ENGINE.9`).
fn run(fx: &Fixture, frames: usize, probe: &mut Probe) -> Result<Run, String> {
    let first = first_plane(fx)?;
    let facts = if fx.manifest.name == "gun" {
        Some(gun_facts(&first, fx.board).map_err(|e| format!("{}: {e}", fx.name))?)
    } else {
        None
    };
    let start = Instant::now();
    let mut cart = load(&fx.text, &fx.from)?;
    let load_ms = start.elapsed().as_secs_f64() * 1e3;
    if cart.manifest().width as usize != WINDOW.w || cart.manifest().height as usize != WINDOW.h {
        return Err(format!(
            "{}: the Screen's window is {} by {}, not the benchmark's {} by {}",
            fx.name,
            cart.manifest().width,
            cart.manifest().height,
            WINDOW.w,
            WINDOW.h
        ));
    }
    let mut r = Run {
        name: fx.name.clone(),
        cells: cart.machine().formulas().0,
        load_ms,
        times: Vec::with_capacity(frames),
        clocks: Vec::with_capacity(2 * SIDE_READINGS),
        facts,
        conserved: is_sand(fx).then_some(0),
        run: 1,
        alone: None,
        counts: None,
    };
    // The clock before the fixture's first frame, and after its steady frames
    // below; never between two frames, where it slowed the frame after it.
    r.clocks.extend((0..SIDE_READINGS).map(|_| probe.read()));
    let mut want = first.clone();
    for f in 1..=frames {
        if f > 1 {
            want = next(fx, f, &want)?;
            r.conserved = r.conserved.map(|n| n + 1);
        }
        let t = Instant::now();
        let s = cart.step(0);
        let ms = t.elapsed().as_secs_f64() * 1e3;
        if s.frame != f as u64 || !s.done {
            return Err(format!("{}: the step answered {}", r.name, s.row()));
        }
        hold(&cart, &r.name, f, &want, fx.board)?;
        r.times.push(ms);
    }
    let alone = median(&r.steady());
    if alone >= RUN_MS {
        r.clocks.extend((0..SIDE_READINGS).map(|_| probe.read()));
        return Ok(r);
    }

    // The steady frames again, past them, in RUNS runs of RUN_FRAMES
    // consecutive frames, the same frames on every machine and every rung.
    if r.facts.is_some() && frames + RUNS * RUN_FRAMES > GUN_THROUGH {
        return Err(format!(
            "{}: its runs would end at frame {}, past generation {GUN_THROUGH}, where the gun's boards stop holding the same cells",
            r.name,
            frames + RUNS * RUN_FRAMES
        ));
    }
    // The runs back to back, no reference computed and no plane viewed
    // between them: on a large board both sweep megabytes through the cache,
    // which the next run's first frames paid for (ENGINE.9). The last frame
    // is held after the last run, and every frame on the second instance.
    let (mut times, mut answers) = (Vec::with_capacity(RUNS), Vec::new());
    let mut f = frames + 1;
    for _ in 0..RUNS {
        let ms = span(&mut cart, &r.name, f, RUN_FRAMES, &mut answers)?;
        f += RUN_FRAMES;
        times.push(ms / RUN_FRAMES as f64);
    }
    r.clocks.extend((0..SIDE_READINGS).map(|_| probe.read()));
    for g in frames + 1..f {
        want = next(fx, g, &want)?;
    }
    hold(&cart, &r.name, f - 1, &want, fx.board)?;
    drop(cart);
    // Every frame held all the same: the fixture stepped again on a second
    // instance, untimed, each frame's plane held to the reference.
    let mut second = load(&fx.text, &fx.from)?;
    let mut w = first;
    for g in 1..f {
        if g > 1 {
            w = next(fx, g, &w)?;
        }
        let s = second.step(0);
        if s.frame != g as u64 || !s.done {
            return Err(format!(
                "{}: the second instance answered {}",
                r.name,
                s.row()
            ));
        }
        hold(&second, &r.name, g, &w, fx.board)?;
    }
    r.times.truncate(1);
    r.times.extend(times);
    r.run = RUN_FRAMES;
    r.alone = Some((alone, f - 1));
    Ok(r)
}

// ---- the slope (ENGINE.9, decision 8) ---------------------------------------

/// How a quantity grows against the formula cells over the ladder, from the
/// window's rung to the top one: the exponent, 1 where it grows as the cells do.
fn exponent(v1: f64, v16: f64, c1: f64, c16: f64) -> f64 {
    (v16 / v1).ln() / (c16 / c1).ln()
}

fn shape(e: f64) -> &'static str {
    if e < 0.9 {
        "less than linear"
    } else if e <= 1.1 {
        "linear"
    } else {
        "more than linear"
    }
}

fn megabytes(bytes: u64) -> String {
    format!("{:.1}", bytes as f64 / 1e6)
}

/// The slope read off the runs: for each fixture that climbed the ladder, its
/// frame, load and memory at each rung, each over the window's, and the
/// exponent against the formula cells; for the gun, its idle frame at the top
/// rung against the prediction that it costs what it costs on the window.
fn slope(runs: &[Run]) -> Vec<String> {
    let mut out = Vec::new();
    for base in runs.iter().filter(|r| !r.name.contains("-x")) {
        let mut all = vec![base];
        for (times, _, _) in ladder::RUNGS {
            if let Some(r) = runs
                .iter()
                .find(|r| r.name == format!("{}-x{times}", base.name))
            {
                all.push(r);
            }
        }
        if all.len() != 3 {
            continue;
        }
        let cells: Vec<f64> = all.iter().map(|r| r.cells as f64).collect();
        let frame: Vec<f64> = all.iter().map(|r| median(&r.steady())).collect();
        let load: Vec<f64> = all.iter().map(|r| r.load_ms).collect();
        let memory: Vec<f64> = all
            .iter()
            .map(|r| r.counts.as_ref().map_or(0, |c| c.memory) as f64)
            .collect();
        let (c1, c16) = (cells[0], cells[2]);
        let idle = base.name == "gun";
        let fe = exponent(frame[0], frame[2], c1, c16);
        let le = exponent(load[0], load[2], c1, c16);
        let me = exponent(memory[0], memory[2], c1, c16);
        out.push(format!(
            "  {}: the {} frame {}, {} and {} ms over {}, {} and {} formula cells, {:.2} and {:.2} times the window's, the exponent {fe:.2}, {}; the load {:.1}, {:.1} and {:.1} ms, the exponent {le:.2}, {}; the memory {}, {} and {} MB, the exponent {me:.2}, {}",
            base.name,
            if idle { "idle" } else { "steady" },
            ms(frame[0]),
            ms(frame[1]),
            ms(frame[2]),
            thousands(c1 as u64),
            thousands(cells[1] as u64),
            thousands(c16 as u64),
            frame[1] / frame[0],
            frame[2] / frame[0],
            shape(fe),
            load[0],
            load[1],
            load[2],
            shape(le),
            megabytes(memory[0] as u64),
            megabytes(memory[1] as u64),
            megabytes(memory[2] as u64),
            shape(me)
        ));
        if idle {
            let ratio = frame[2] / frame[0];
            let verdict = if ratio <= 1.0 + CLOCK_SPREAD_MAX / 100.0 {
                format!(
                    "the prediction, the window's cost, held within the floors' margin of {CLOCK_SPREAD_MAX:.0}%"
                )
            } else {
                format!(
                    "the prediction, the window's cost, missed by {:.0}%, past the floors' margin of {CLOCK_SPREAD_MAX:.0}%",
                    (ratio - 1.0) * 100.0
                )
            };
            out.push(format!(
                "  {}: at {:.0} times the window's formula cells its idle frame costs {ratio:.2} times the window's: {verdict}",
                base.name,
                c16 / c1
            ));
        }
    }
    out
}

// ---- the runner -----------------------------------------------------------

fn default_cartridges() -> Vec<PathBuf> {
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("..");
    ["life", "gun", "sand"]
        .iter()
        .map(|n| root.join("cartridges").join(n).join(format!("{n}.vla")))
        .collect()
}

fn main() -> ExitCode {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let check = args.iter().any(|a| a == "--check");
    let mut frames = if check { CHECK_FRAMES } else { 31 };
    let mut paths = Vec::new();
    let mut i = 0;
    while i < args.len() {
        match args[i].as_str() {
            "--check" => {}
            "--frames" => {
                i += 1;
                match args.get(i).and_then(|a| a.parse::<usize>().ok()) {
                    Some(n) if n >= 2 => frames = n,
                    _ => {
                        eprintln!("frames: --frames wants a whole number of at least 2");
                        return ExitCode::from(2);
                    }
                }
            }
            a if a.starts_with("--") => {
                eprintln!("frames: an unknown option, {a}");
                return ExitCode::from(2);
            }
            a => paths.push(PathBuf::from(a)),
        }
        i += 1;
    }
    if paths.is_empty() {
        paths = default_cartridges();
    }

    // The fixtures: each file's, then the rungs of the ladder its source
    // climbs, built by the pass.
    let mut fixtures = Vec::new();
    for p in &paths {
        match fixtures_of(p) {
            Ok(v) => fixtures.extend(v),
            Err(e) => {
                println!("{e}");
                eprintln!("frames: FAILED, {e}");
                return ExitCode::FAILURE;
            }
        }
    }
    let gun_runs_end = frames + RUNS * RUN_FRAMES;
    if !check && gun_runs_end > GUN_THROUGH && fixtures.iter().any(|f| f.manifest.name == "gun") {
        eprintln!(
            "frames: --frames {frames} would carry the gun's runs to frame {gun_runs_end}, past generation {GUN_THROUGH}, where the ladder's boards stop holding the same cells: at most {}",
            GUN_THROUGH - RUNS * RUN_FRAMES
        );
        return ExitCode::from(2);
    }
    // The language's tables made on first use, made here by a load counted
    // nowhere, so that no fixture's memory holds them.
    if let Some(fx) = fixtures.first() {
        match load(&fx.text, &fx.from) {
            Ok(mut c) => {
                c.step(0);
                let _ = plane(&c, fx.board);
            }
            Err(e) => {
                println!("{e}");
                eprintln!("frames: FAILED, {e}");
                return ExitCode::FAILURE;
            }
        }
    }

    if check {
        // The check's rows, one a fixture, read by tools/check_frame_floors.ps1.
        for fx in &fixtures {
            let measured = planes(fx, CHECK_FRAMES).and_then(|wants| {
                let facts = if fx.manifest.name == "gun" {
                    Some(gun_facts(&wants[0], fx.board).map_err(|e| format!("{}: {e}", fx.name))?)
                } else {
                    None
                };
                measure(fx, &wants).map(|c| (c, facts))
            });
            let (c, facts) = match measured {
                Ok(m) => m,
                Err(e) => {
                    println!("{e}");
                    eprintln!("frames: FAILED, {e}");
                    return ExitCode::FAILURE;
                }
            };
            let digest = fx
                .rung
                .as_ref()
                .map(|(_, d)| format!(" (digest \"{d}\")"))
                .unwrap_or_default();
            let held = facts.map(|n| format!(" (facts {n})")).unwrap_or_default()
                + &(if is_sand(fx) {
                    format!(" (conserved {})", c.frames - 1)
                } else {
                    String::new()
                });
            println!(
                "(frames-check \"{}\" (frames {}) (equal {}) (cells {}) (allocs {}) (reallocs {}) (memory {}){digest}{held})",
                fx.name, c.frames, c.frames, c.cells, c.allocs, c.reallocs, c.memory
            );
        }
        println!("(frames-check-done {})", fixtures.len());
        return ExitCode::SUCCESS;
    }

    // The clock at the start, before anything heavy has run: Windows throttles
    // a background process only a few seconds in, so these readings are the
    // processor's own, and a run throttled from then on is slower than them.
    let mut probe = Probe::new(soup(1, WINDOW));
    let readings: Vec<f64> = (0..START_READINGS).map(|_| probe.read()).collect();
    let start_clock = median(&readings);
    let mut runs = Vec::new();
    for fx in &fixtures {
        let measured = run(fx, frames, &mut probe).and_then(|mut r| {
            let wants = planes(fx, CHECK_FRAMES)?;
            r.counts = Some(measure(fx, &wants)?);
            Ok(r)
        });
        match measured {
            Ok(r) => runs.push(r),
            Err(e) => {
                println!("{e}");
                eprintln!("frames: FAILED, {e}");
                return ExitCode::FAILURE;
            }
        }
    }

    println!(
        "frames: the native runner, {} on {}, {} cartridge(s), {frames} frames each, every frame equal to the hand-written Life or Sand",
        std::env::consts::ARCH,
        std::env::consts::OS,
        runs.len()
    );
    let mut steady_all = true;
    for (r, fx) in runs.iter().zip(&fixtures) {
        let steady = r.steady();
        let med = median(&steady);
        let (lo, hi) = range(&steady);
        let clock = median(&r.clocks);
        let (clock_lo, clock_hi) = range(&r.clocks);
        let spread = r.spread();
        let drift = drift(clock, start_clock);
        let by = if r.name == "sand" { "Sand" } else { "Life" };
        let which = match r.alone {
            None => format!("frames 2 to {}: median", r.times.len()),
            Some((_, stepped)) => format!(
                "frames {} to {stepped} in {} runs of {}, each run one span: a frame's median",
                stepped + 1 - steady.len() * r.run,
                steady.len(),
                r.run
            ),
        };
        println!(
            "{}: load {:.1} ms; {} formula cells; frame 1 {} ms; {which} {} ms (min {}, max {}), {} cells a second, {:.3} frames a second",
            r.name,
            r.load_ms,
            thousands(r.cells as u64),
            ms(r.times[0]),
            ms(med),
            ms(lo),
            ms(hi),
            thousands((r.cells as f64 / (med / 1e3)).round() as u64),
            1e3 / med
        );
        if let Some((alone, stepped)) = r.alone {
            println!(
                "  frames 2 to {frames} alone read a median of {} ms, under {RUN_MS} ms, so the steady frames were timed in runs past them, back to back; the last frame held to the hand-written {by} after them, and every frame from 1 to {stepped} on a second instance stepped untimed",
                ms(alone)
            );
        }
        if let Some(c) = &r.counts {
            let board = match &fx.rung {
                None => format!("the window's board, {} by {}", fx.board.w, fx.board.h),
                Some((times, digest)) => format!(
                    "a board of {} by {}, {times} times the window's area, under a still Camera, built by the pass from {}, the cartridge's SHA-256 over LF {digest}",
                    fx.board.w,
                    fx.board.h,
                    fx.from.display()
                ),
            };
            println!(
                "  {board}; the grid {} cells of the language's {} ({} to spare); the memory, the heap's high-water mark over a load and {} frames, {} bytes, {:.1} a grid cell, and {} held after them",
                thousands(c.grid as u64),
                thousands(CELLS as u64),
                thousands(CELLS.saturating_sub(c.grid) as u64),
                c.frames,
                thousands(c.memory),
                c.memory as f64 / c.grid.max(1) as f64,
                thousands(c.resident)
            );
        }
        // a frame quicker than the clock's own generation is that many times faster (CART.1, 2026-10-10)
        let against = if med >= clock {
            format!("{:.0} times slower than it", med / clock)
        } else {
            format!("{:.0} times faster than it", clock / med)
        };
        let steadies = if r.run > 1 { "runs" } else { "frames" };
        println!(
            "  the clock: the hand-written Life {clock:.3} ms a generation, read {SIDE_READINGS} times before frame 1 and {SIDE_READINGS} after the steady {steadies} ({clock_lo:.3} to {clock_hi:.3}), spread {spread:.1}%, {drift:+.1}% from {start_clock:.3} at the start; the engine {against}"
        );
        if let Some(n) = r.facts {
            println!(
                "  the gun's facts: period {GUN_PERIOD}, {GUN_CELLS} cells and {GLIDER_CELLS} more a period, held {n} periods, through generation {GUN_THROUGH}"
            );
        }
        if let Some(n) = r.conserved {
            println!(
                "  the grains: every material's count kept in each of the {n} frames after the first"
            );
        }
        if spread > CLOCK_SPREAD_MAX || drift.abs() > CLOCK_SPREAD_MAX {
            steady_all = false;
            println!(
                "  the clock moved during the run, a spread of {spread:.1}% and {drift:+.1}% from the start, more than {CLOCK_SPREAD_MAX}%: power throttling or a thermal limit; these frames are not a baseline"
            );
        }
    }
    let slope = slope(&runs);
    if !slope.is_empty() {
        println!("the size ladder (ENGINE.9), natively: each rung over the window's, and the exponent against the formula cells, 1 where a quantity grows as the cells do");
        for line in &slope {
            println!("{line}");
        }
    }
    if !steady_all {
        println!("no baseline rows: run again with the process in the foreground, or through tools/bench_frames.ps1, which opts it out of Windows' power throttling");
        return ExitCode::from(3);
    }
    println!("the baseline rows, for tools/check_frame_floors.ps1:");
    for r in &runs {
        let steady = r.steady();
        let med = median(&steady);
        let (lo, hi) = range(&steady);
        println!(
            "    @{{ Runner = 'native'; Fixture = '{}'; Cells = {}; Frames = {}; Run = {}; Load = {:.1}; Memory = {}; FirstFrame = {}; FrameP50 = {}; FrameMin = {}; FrameMax = {}; CellsPerSecond = {}; FramesPerSecond = {:.3}; ClockMs = {:.3}; ClockSpread = {:.1}; ClockDrift = {:.1} }}",
            r.name,
            r.cells,
            steady.len() * r.run,
            r.run,
            r.load_ms,
            r.counts.as_ref().map_or(0, |c| c.memory),
            ms(r.times[0]),
            ms(med),
            ms(lo),
            ms(hi),
            (r.cells as f64 / (med / 1e3)).round() as u64,
            1e3 / med,
            median(&r.clocks),
            r.spread(),
            drift(median(&r.clocks), start_clock)
        );
    }
    for fx in &fixtures {
        if let Some((_, digest)) = &fx.rung {
            println!(
                "    @{{ Rung = '{}'; Width = {}; Height = {}; Digest = '{digest}' }}",
                fx.name, fx.board.w, fx.board.h
            );
        }
    }
    ExitCode::SUCCESS
}

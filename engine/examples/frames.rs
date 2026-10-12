//! The native runner of the frame floors (`CART.1`; `REARVIEW.md`, the
//! item's scoping, decisions 2, 3, 5 and 7): a cartridge loaded through the
//! engine's own `Cartridge`, stepped frame by frame and timed, every frame's
//! plane held to a Life, or a Sand, written by hand before any number is
//! printed, since a fast wrong answer is no floor.
//!
//! ```text
//! cargo run --release --example frames                  # the three fixtures, 31 frames each, the baseline rows
//! cargo run --release --example frames -- --check       # 4 frames each, the frames and the allocations held
//! cargo run --release --example frames -- --frames 61 cartridges/gun/gun.vla
//! ```
//!
//! **The reference.** Life computed every cell every generation, the honest
//! comparison `CHARTER.md` section 7 names: the soup of `life.vla` from its
//! own arithmetic and the manifest's seed, or the pattern of a cartridge's
//! `Seed` sheet read off its rows, then Conway's rule with the border dead.
//! It is a third Life outside the engine, beside the page's and the engine
//! test's. For the gun it also holds the pattern's published facts (LifeWiki,
//! "Gosper glider gun"): period 30, 36 cells, one glider of 5 a period, each
//! held every 30 generations through 720, before the first glider meets the
//! border at 740, the generation where the bounded plane and Golly's stop
//! agreeing. Since `CART.2` (2026-10-11), the cartridge named `sand` is held
//! to the hand-written sand the engine's tests hold it to, `engine/src/sand.rs`,
//! included here by its path: the opening, Life's soup as grains, then the
//! rule, every frame after the first keeping every grain.
//!
//! **The timings.** Each frame is one `step` with no budget, timed alone; the
//! steady frames are the second onwards, and their median is the floor's
//! number, in cells evaluated a second (the step's formula cells over the
//! median) and in frames a second (one over it), one measurement in two units.
//! A steady frame under 2 ms, the page's own line, is timed again past them in
//! runs of consecutive frames, as the page times one (`CART.1`, 2026-10-10):
//! the run doubled from 2 until it lasts 2 ms, `N - 1` runs, each one span
//! with nothing viewed inside it, each run's last frame held to the reference,
//! and every frame stepped held again on a second instance stepped untimed.
//! The rows say `Run`, the frames a run, 1 where a frame is timed alone.
//! `Instant` reads nanoseconds, so the reason was not the clock's step, as it
//! is the page's, but the clock this runner read beside every frame until
//! 2026-10-12: a frame timed alone came right after it, and the gun's frames 2
//! to 31 read 22 to 48 microseconds with it in one sitting and 12.3 to 13.2
//! without it, where the floors' margin is 10%. Its runs read 42.4 to 44.5
//! microseconds a frame across launches and an added load, over frames 158 to
//! 3997, the frames the page times (`CART.2`, 2026-10-12). A frame's time
//! under 1 ms prints to a tenth of a microsecond, as the page prints it.
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
//! **The check.** With `--check` the runner times nothing it claims: it steps
//! each fixture four frames, holds them to the reference, holds the gun to its
//! facts and Sand to its grains, and counts the heap's allocations and reallocations in the second
//! frame after a fresh load, exact on every run, so that
//! `tools/check_frame_floors.ps1` holds them to ceilings on every push where no
//! time can be held. It counts only there: counting while timing costs a frame
//! about a tenth (measured in the scoping).
//!
//! The runner is an example and not a member of the workspace, so the lock
//! holds no third package and the engine still depends on the language crate
//! alone (`AD-5`); its allocator is its own and ships in nothing.

use std::alloc::{GlobalAlloc, Layout, System};
use std::hint::black_box;
use std::path::{Path, PathBuf};
use std::process::ExitCode;
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::time::Instant;

use alonzo::cartridge::{Cartridge, Seed};
use vla_lang::machine::{Step, Viewed};
use vla_lang::sheet::parse_a1_range;

// The hand-written sand, the engine's tests' own file; the runner steps the
// opening and paints nothing, so the brush is the tests' alone.
#[path = "../src/sand.rs"]
#[allow(dead_code)]
mod sand;

// ---- the allocator: the system's, counted when asked ----------------------

static COUNTING: AtomicBool = AtomicBool::new(false);
static ALLOCS: AtomicU64 = AtomicU64::new(0);
static REALLOCS: AtomicU64 = AtomicU64::new(0);

/// The system's allocator, counting allocations and reallocations while
/// `COUNTING` is set. The runner steps on one thread, so a count is a load and
/// a store and never a locked add.
struct Counted;

fn tally(counter: &AtomicU64) {
    if COUNTING.load(Ordering::Relaxed) {
        counter.store(counter.load(Ordering::Relaxed) + 1, Ordering::Relaxed);
    }
}

unsafe impl GlobalAlloc for Counted {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        tally(&ALLOCS);
        unsafe { System.alloc(layout) }
    }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        tally(&ALLOCS);
        unsafe { System.alloc_zeroed(layout) }
    }

    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        unsafe { System.dealloc(ptr, layout) }
    }

    unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, new_size: usize) -> *mut u8 {
        tally(&REALLOCS);
        unsafe { System.realloc(ptr, layout, new_size) }
    }
}

#[global_allocator]
static GLOBAL: Counted = Counted;

// ---- the reference: Life by hand ------------------------------------------

/// The plane's size, `A1:LH200`.
const W: usize = 320;
const H: usize = 200;

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
/// consecutive frames, a run doubled from 2 until it lasts this long, the
/// page's twenty steps of Chrome's clock; and the longest run tried.
const RUN_MS: f64 = 2.0;
const RUN_MAX: usize = 65_536;

/// The gun's published facts: a period, the cells of one glider, and the last
/// generation they are held to, before a glider meets the dead border at 740.
const GUN_PERIOD: usize = 30;
const GUN_CELLS: usize = 36;
const GLIDER_CELLS: usize = 5;
const GUN_THROUGH: usize = 720;

/// The soup of `life.vla`'s first frame, its own arithmetic: two linear forms
/// of the seed, the row and the column modulo a prime, their product `h`, and
/// a cell alive when `h * h` modulo the prime is under three eighths of it.
fn soup(seed: u64) -> Vec<u8> {
    let p: u64 = 67_108_859;
    let t: u64 = 25_165_822;
    let mut g = vec![0u8; W * H];
    for r in 2..H as u64 {
        for c in 2..W as u64 {
            let a = (seed * 1_103_515 + r * 1_597_334 + c * 1_830_421 + 12_345) % p;
            let b = (seed * 2_012_345 + r * 1_209_487 + c * 1_949_213 + 54_321) % p;
            let h = (a * b) % p;
            g[(r as usize - 1) * W + (c as usize - 1)] = u8::from((h * h) % p < t);
        }
    }
    g
}

/// A cartridge's `Seed` sheet as a plane, read off its rows,
/// `(cell "Seed" "J14" 1)`, and not off the engine's grid.
fn seeded(text: &str) -> Vec<u8> {
    let mut g = vec![0u8; W * H];
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
            if (1..=H).contains(&row) && (1..=W).contains(&col) {
                g[(row - 1) * W + (col - 1)] = 1;
            }
        }
    }
    g
}

/// One generation of Conway's rule over the plane into `n`, whose border is
/// left as it is, dead.
fn generation_into(g: &[u8], n: &mut [u8]) {
    for r in 1..H - 1 {
        for c in 1..W - 1 {
            let i = r * W + c;
            let others = g[i - W - 1]
                + g[i - W]
                + g[i - W + 1]
                + g[i - 1]
                + g[i + 1]
                + g[i + W - 1]
                + g[i + W]
                + g[i + W + 1];
            n[i] = u8::from(others == 3 || (g[i] == 1 && others == 2));
        }
    }
}

/// One generation of Conway's rule over the plane, the border dead.
fn generation(g: &[u8]) -> Vec<u8> {
    let mut n = vec![0u8; W * H];
    generation_into(g, &mut n);
    n
}

fn live(g: &[u8]) -> usize {
    g.iter().filter(|b| **b == 1).count()
}

/// `B5` for a plane's index.
fn cell_name(i: usize) -> String {
    let (row, mut col) = (i / W + 1, i % W + 1);
    let mut letters = Vec::new();
    while col > 0 {
        letters.push(b'A' + ((col - 1) % 26) as u8);
        col = (col - 1) / 26;
    }
    letters.reverse();
    format!("{}{row}", String::from_utf8(letters).unwrap_or_default())
}

/// The gun's facts held on the hand-written Life from its first generation:
/// every `GUN_PERIOD` generations through `GUN_THROUGH`, the gun's box equal
/// to the first generation's and the population `GUN_CELLS` plus a glider's
/// cells a period. The periods held, or the first fact that failed.
fn gun_facts(start: &[u8]) -> Result<usize, String> {
    if live(start) != GUN_CELLS {
        return Err(format!(
            "the Seed holds {} live cells, not the gun's {GUN_CELLS}",
            live(start)
        ));
    }
    let (mut top, mut left) = (H, W);
    for (i, b) in start.iter().enumerate() {
        if *b == 1 {
            top = top.min(i / W);
            left = left.min(i % W);
        }
    }
    let boxed = |g: &[u8]| -> Vec<u8> {
        let mut v = Vec::with_capacity(9 * 36);
        for r in top..(top + 9).min(H) {
            for c in left..(left + 36).min(W) {
                v.push(g[r * W + c]);
            }
        }
        v
    };
    let first = boxed(start);
    let mut g = start.to_vec();
    for n in 1..=GUN_THROUGH {
        g = generation(&g);
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

/// The hand-written Life over a fixed workload, timed: milliseconds a
/// generation, the processor's clock as a computation that never changes sees
/// it. Two planes kept for the probe's life, stepped into each other, so the
/// probe allocates nothing; a generation untimed first, to warm them after the
/// step that ran before; the best of a few batches, so an interruption is not
/// read as the clock.
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
            generation_into(&self.a, &mut self.b);
            let t = Instant::now();
            for _ in 0..PROBE_GENERATIONS / 2 {
                generation_into(black_box(&self.a), &mut self.b);
                generation_into(black_box(&self.b), &mut self.a);
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

// ---- one fixture ----------------------------------------------------------

/// What one fixture's run measured.
struct Run {
    name: String,
    cells: usize,
    load_ms: f64,
    times: Vec<f64>,
    clocks: Vec<f64>,
    allocs: u64,
    reallocs: u64,
    facts: Option<usize>,
    /// Sand's frames after the first, each keeping every grain.
    conserved: Option<usize>,
    /// The frames a run, 1 where each steady frame is timed alone.
    run: usize,
    /// Where the steady frames were timed in runs: the median of frames 2 to
    /// N timed alone, and the frames stepped in all, each held on a second
    /// instance.
    alone: Option<(f64, usize)>,
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

fn plane(c: &Cartridge) -> Result<Vec<u8>, String> {
    match c.view("plane", "Screen", Some("A1:LH200")) {
        Ok(Viewed::Bytes(b)) => Ok(b),
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

/// The reference one frame on: Conway's generation, or Sand's step, which
/// keeps every grain.
fn next(name: &str, f: usize, want: &[u8], is_sand: bool) -> Result<Vec<u8>, String> {
    if !is_sand {
        return Ok(generation(want));
    }
    let before = sand::counts(want);
    let after = sand::step(want, None, sand::SAND).0;
    if sand::counts(&after) != before {
        return Err(format!(
            "(frames-grains \"{name}\" (frame {f}) (before {before:?}) (after {:?}))",
            sand::counts(&after)
        ));
    }
    Ok(after)
}

/// The plane after frame `f` held to the reference.
fn hold(cart: &Cartridge, name: &str, f: usize, want: &[u8]) -> Result<(), String> {
    let got = plane(cart).map_err(|e| format!("{name}: {e}"))?;
    if let Some(i) = got.iter().zip(want).position(|(a, b)| a != b) {
        return Err(format!(
            "(frames-differ \"{name}\" (frame {f}) (cell \"{}\") (engine {}) (reference {}))",
            cell_name(i),
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

/// A cartridge stepped `frames` frames, every frame held to the reference;
/// `check` counts the second frame's allocations and times nothing it claims.
/// Where the steady frames timed alone read under `RUN_MS`, they are timed
/// again past them in runs of consecutive frames, `frames - 1` runs, each
/// run's last frame held to the reference, and every frame stepped is held on
/// a second instance stepped untimed (2026-10-12).
fn run(path: &Path, frames: usize, check: bool, probe: &mut Probe) -> Result<Run, String> {
    let text = std::fs::read_to_string(path)
        .map_err(|e| format!("{}: cannot be read: {e}", path.display()))?;
    let start = Instant::now();
    let mut cart = load(&text, path)?;
    let load_ms = start.elapsed().as_secs_f64() * 1e3;
    let name = cart.manifest().name.clone();
    if cart.manifest().width as usize != W || cart.manifest().height as usize != H {
        return Err(format!(
            "{name}: the Screen is {} by {}, not the benchmark's {W} by {H}",
            cart.manifest().width,
            cart.manifest().height
        ));
    }
    let is_sand = name == "sand";
    let first = if text.contains("(cell \"Seed\"") {
        seeded(&text)
    } else {
        match (cart.manifest().seed, is_sand) {
            (Seed::Number(n), false) => soup(u64::from(n)),
            (Seed::Number(n), true) => sand::opening(u64::from(n)),
            (Seed::Host, _) => return Err(format!("{name}: a soup needs the manifest's seed")),
        }
    };
    let facts = if name == "gun" {
        Some(gun_facts(&first).map_err(|e| format!("{name}: {e}"))?)
    } else {
        None
    };
    let mut r = Run {
        name,
        cells: cart.machine().formulas().0,
        load_ms,
        times: Vec::with_capacity(frames),
        clocks: Vec::with_capacity(2 * SIDE_READINGS),
        allocs: 0,
        reallocs: 0,
        facts,
        conserved: is_sand.then_some(0),
        run: 1,
        alone: None,
    };
    // The clock before the fixture's first frame, and after its steady frames
    // below; never between two frames, where it slowed the frame after it.
    if !check {
        r.clocks.extend((0..SIDE_READINGS).map(|_| probe.read()));
    }
    let mut want = first.clone();
    for f in 1..=frames {
        if f > 1 {
            want = next(&r.name, f, &want, is_sand)?;
            if is_sand {
                r.conserved = r.conserved.map(|n| n + 1);
            }
        }
        let counted = check && f == 2;
        if counted {
            ALLOCS.store(0, Ordering::Relaxed);
            REALLOCS.store(0, Ordering::Relaxed);
            COUNTING.store(true, Ordering::Relaxed);
        }
        let t = Instant::now();
        let s = cart.step(0);
        let ms = t.elapsed().as_secs_f64() * 1e3;
        if counted {
            COUNTING.store(false, Ordering::Relaxed);
            r.allocs = ALLOCS.load(Ordering::Relaxed);
            r.reallocs = REALLOCS.load(Ordering::Relaxed);
        }
        if s.frame != f as u64 || !s.done {
            return Err(format!("{}: the step answered {}", r.name, s.row()));
        }
        hold(&cart, &r.name, f, &want)?;
        r.times.push(ms);
    }
    let alone = median(&r.steady());
    if check {
        return Ok(r);
    }
    if alone >= RUN_MS {
        r.clocks.extend((0..SIDE_READINGS).map(|_| probe.read()));
        return Ok(r);
    }

    // The steady frames again, past them, in runs of k consecutive frames, k
    // doubled from 2 until a run lasts RUN_MS: a run that reads under it is
    // stepped and held, and not counted.
    let (mut times, mut answers) = (Vec::new(), Vec::new());
    let (mut f, mut k) = (frames + 1, 2);
    while times.len() < frames - 1 {
        if k > RUN_MAX {
            return Err(format!(
                "{}: {RUN_MAX} frames in a row still read under {RUN_MS} ms",
                r.name
            ));
        }
        let ms = span(&mut cart, &r.name, f, k, &mut answers)?;
        for g in f..f + k {
            want = next(&r.name, g, &want, is_sand)?;
        }
        hold(&cart, &r.name, f + k - 1, &want)?;
        f += k;
        if times.is_empty() && ms < RUN_MS {
            k *= 2;
            continue;
        }
        times.push(ms / k as f64);
    }
    r.clocks.extend((0..SIDE_READINGS).map(|_| probe.read()));
    // Every frame held all the same: the fixture stepped again on a second
    // instance, untimed, each frame's plane held to the reference.
    let mut second = load(&text, path)?;
    let mut w = first;
    for g in 1..f {
        if g > 1 {
            w = next(&r.name, g, &w, is_sand)?;
        }
        let s = second.step(0);
        if s.frame != g as u64 || !s.done {
            return Err(format!(
                "{}: the second instance answered {}",
                r.name,
                s.row()
            ));
        }
        hold(&second, &r.name, g, &w)?;
    }
    r.times.truncate(1);
    r.times.extend(times);
    r.run = k;
    r.alone = Some((alone, f - 1));
    Ok(r)
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
    let mut frames = if check { 4 } else { 31 };
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

    // The clock at the start, before anything heavy has run: Windows throttles
    // a background process only a few seconds in, so these readings are the
    // processor's own, and a run throttled from then on is slower than them.
    let mut probe = Probe::new(soup(1));
    let start_clock = if check {
        0.0
    } else {
        let readings: Vec<f64> = (0..START_READINGS).map(|_| probe.read()).collect();
        median(&readings)
    };
    let mut runs = Vec::new();
    for p in &paths {
        match run(p, frames, check, &mut probe) {
            Ok(r) => runs.push(r),
            Err(e) => {
                println!("{e}");
                eprintln!("frames: FAILED, {e}");
                return ExitCode::FAILURE;
            }
        }
    }

    if check {
        // The check's rows, one a fixture, read by tools/check_frame_floors.ps1.
        for r in &runs {
            let facts = r.facts.map(|n| format!(" (facts {n})")).unwrap_or_default()
                + &r.conserved
                    .map(|n| format!(" (conserved {n})"))
                    .unwrap_or_default();
            println!(
                "(frames-check \"{}\" (frames {}) (equal {}) (cells {}) (allocs {}) (reallocs {}){facts})",
                r.name,
                r.times.len(),
                r.times.len(),
                r.cells,
                r.allocs,
                r.reallocs
            );
        }
        println!("(frames-check-done {})", runs.len());
        return ExitCode::SUCCESS;
    }

    println!(
        "frames: the native runner, {} on {}, {} cartridge(s), {frames} frames each, every frame equal to the hand-written Life or Sand",
        std::env::consts::ARCH,
        std::env::consts::OS,
        runs.len()
    );
    let mut steady_all = true;
    for r in &runs {
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
                "  frames 2 to {frames} alone read a median of {} ms, under {RUN_MS} ms, so the steady frames were timed in runs past them; each run's last frame held to the hand-written {by}, and every frame from 1 to {stepped} on a second instance stepped untimed",
                ms(alone)
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
            "    @{{ Runner = 'native'; Fixture = '{}'; Cells = {}; Frames = {}; Run = {}; Load = {:.1}; FirstFrame = {}; FrameP50 = {}; FrameMin = {}; FrameMax = {}; CellsPerSecond = {}; FramesPerSecond = {:.3}; ClockMs = {:.3}; ClockSpread = {:.1}; ClockDrift = {:.1} }}",
            r.name,
            r.cells,
            steady.len() * r.run,
            r.run,
            r.load_ms,
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
    ExitCode::SUCCESS
}

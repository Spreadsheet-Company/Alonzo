//! The native runner of the frame floors (`CART.1`; `REARVIEW.md`, the
//! item's scoping, decisions 2, 3, 5 and 7): a cartridge loaded through the
//! engine's own `Cartridge`, stepped frame by frame and timed, every frame's
//! plane held to a Life written here by hand before any number is printed,
//! since a fast wrong answer is no floor.
//!
//! ```text
//! cargo run --release --example frames                  # both fixtures, 31 frames each, the baseline rows
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
//! agreeing.
//!
//! **The timings.** Each frame is one `step` with no budget, timed alone; the
//! steady frames are the second onwards, and their median is the floor's
//! number, in cells evaluated a second (the step's formula cells over the
//! median) and in frames a second (one over it), one measurement in two units.
//! Beside every frame the hand-written Life runs a fixed workload, the soup's
//! first generations, and is timed too: the processor's clock seen from a
//! computation that never changes. When that time moves more than 10% across
//! the steady frames, its 10th to its 90th percentile over its median, the run
//! is not a baseline, and the runner says so and prints no rows.
//! On the owner's machine Windows throttles a background process about three
//! seconds into a run, by about 40% (measured 2026-10-09); `tools/bench_frames.ps1`
//! starts this runner with its process opted out of that.
//!
//! **The check.** With `--check` the runner times nothing it claims: it steps
//! each fixture four frames, holds them to the reference, holds the gun to its
//! facts, and counts the heap's allocations and reallocations in the second
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
use vla_lang::machine::Viewed;
use vla_lang::sheet::parse_a1_range;

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

/// The clock beside each frame: the hand-written Life's generations in a
/// batch, and the batches, the best of which is the clock's reading.
const PROBE_GENERATIONS: usize = 20;
const PROBE_BATCHES: usize = 3;
const START_READINGS: usize = 5;

/// The most the hand-written Life's time may move across a run, in percent.
const CLOCK_SPREAD_MAX: f64 = 10.0;

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
}

impl Run {
    fn steady(&self) -> Vec<f64> {
        self.times.iter().skip(1).copied().collect()
    }

    /// The clock's readings beside the steady frames, the ones measured.
    fn steady_clocks(&self) -> Vec<f64> {
        self.clocks.iter().skip(1).copied().collect()
    }

    /// How far the clock moved: its readings' 10th to 90th percentile over
    /// their median, in percent, so that one reading interrupted is not a
    /// moved clock and a throttled tenth of the run is.
    fn spread(&self) -> f64 {
        let mut c = self.steady_clocks();
        let m = median(&c);
        if m <= 0.0 || c.is_empty() {
            return 0.0;
        }
        c.sort_by(f64::total_cmp);
        let at = |q: f64| c[((c.len() - 1) as f64 * q).round() as usize];
        (at(0.9) - at(0.1)) / m * 100.0
    }
}

fn plane(c: &Cartridge) -> Result<Vec<u8>, String> {
    match c.view("plane", "Screen", Some("A1:LH200")) {
        Ok(Viewed::Bytes(b)) => Ok(b),
        Ok(Viewed::Text(_)) => Err("the plane answered text".to_string()),
        Err(r) => Err(format!("the plane was refused: {}", r.text)),
    }
}

/// A cartridge stepped `frames` frames, every frame held to the reference;
/// `check` counts the second frame's allocations and times nothing it claims.
fn run(path: &Path, frames: usize, check: bool, probe: &mut Probe) -> Result<Run, String> {
    let text = std::fs::read_to_string(path)
        .map_err(|e| format!("{}: cannot be read: {e}", path.display()))?;
    let start = Instant::now();
    let mut cart = Cartridge::load(&text, "frames.vla", text.len()).map_err(|e| {
        format!(
            "{}: refused at line {}: {}",
            path.display(),
            e.line,
            e.refusal.text
        )
    })?;
    let load_ms = start.elapsed().as_secs_f64() * 1e3;
    let name = cart.manifest().name.clone();
    if cart.manifest().width as usize != W || cart.manifest().height as usize != H {
        return Err(format!(
            "{name}: the Screen is {} by {}, not the benchmark's {W} by {H}",
            cart.manifest().width,
            cart.manifest().height
        ));
    }
    let mut want = if text.contains("(cell \"Seed\"") {
        seeded(&text)
    } else {
        match cart.manifest().seed {
            Seed::Number(n) => soup(u64::from(n)),
            Seed::Host => return Err(format!("{name}: a soup needs the manifest's seed")),
        }
    };
    let facts = if name == "gun" {
        Some(gun_facts(&want).map_err(|e| format!("{name}: {e}"))?)
    } else {
        None
    };
    let mut r = Run {
        name,
        cells: cart.machine().formulas().0,
        load_ms,
        times: Vec::with_capacity(frames),
        clocks: Vec::with_capacity(frames),
        allocs: 0,
        reallocs: 0,
        facts,
    };
    for f in 1..=frames {
        if f > 1 {
            want = generation(&want);
        }
        if !check {
            r.clocks.push(probe.read());
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
        let got = plane(&cart).map_err(|e| format!("{}: {e}", r.name))?;
        if let Some(i) = got.iter().zip(&want).position(|(a, b)| a != b) {
            return Err(format!(
                "(frames-differ \"{}\" (frame {f}) (cell \"{}\") (engine {}) (reference {}))",
                r.name,
                cell_name(i),
                got[i],
                want[i]
            ));
        }
        r.times.push(ms);
    }
    Ok(r)
}

// ---- the runner -----------------------------------------------------------

fn default_cartridges() -> Vec<PathBuf> {
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("..");
    ["life", "gun"]
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
            let facts = r.facts.map(|n| format!(" (facts {n})")).unwrap_or_default();
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
        "frames: the native runner, {} on {}, {} cartridge(s), {frames} frames each, every frame equal to the hand-written Life",
        std::env::consts::ARCH,
        std::env::consts::OS,
        runs.len()
    );
    let mut steady_all = true;
    for r in &runs {
        let steady = r.steady();
        let med = median(&steady);
        let (lo, hi) = range(&steady);
        let clocks = r.steady_clocks();
        let clock = median(&clocks);
        let (clock_lo, clock_hi) = range(&clocks);
        let spread = r.spread();
        let drift = drift(clock, start_clock);
        println!(
            "{}: load {:.1} ms; {} formula cells; frame 1 {:.1} ms; frames 2 to {}: median {:.1} ms (min {:.1}, max {:.1}), {} cells a second, {:.3} frames a second",
            r.name,
            r.load_ms,
            thousands(r.cells as u64),
            r.times[0],
            r.times.len(),
            med,
            lo,
            hi,
            thousands((r.cells as f64 / (med / 1e3)).round() as u64),
            1e3 / med
        );
        println!(
            "  the clock: the hand-written Life {clock:.3} ms a generation beside every steady frame ({clock_lo:.3} to {clock_hi:.3}), spread {spread:.1}%, {drift:+.1}% from {start_clock:.3} at the start; the engine {:.0} times slower than it",
            med / clock
        );
        if let Some(n) = r.facts {
            println!(
                "  the gun's facts: period {GUN_PERIOD}, {GUN_CELLS} cells and {GLIDER_CELLS} more a period, held {n} periods, through generation {GUN_THROUGH}"
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
            "    @{{ Runner = 'native'; Fixture = '{}'; Cells = {}; Frames = {}; Load = {:.1}; FirstFrame = {:.1}; FrameP50 = {:.1}; FrameMin = {:.1}; FrameMax = {:.1}; CellsPerSecond = {}; FramesPerSecond = {:.3}; ClockMs = {:.3}; ClockSpread = {:.1}; ClockDrift = {:.1} }}",
            r.name,
            r.cells,
            steady.len(),
            r.load_ms,
            r.times[0],
            med,
            lo,
            hi,
            (r.cells as f64 / (med / 1e3)).round() as u64,
            1e3 / med,
            median(&r.steady_clocks()),
            r.spread(),
            drift(median(&r.steady_clocks()), start_clock)
        );
    }
    ExitCode::SUCCESS
}

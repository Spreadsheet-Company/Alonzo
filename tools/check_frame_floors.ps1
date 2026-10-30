<#
check_frame_floors.ps1 - the engine's first number: the owner's measured
baseline of Life's frames, the benchmark cartridge's two fixtures over the
native runner and the engine's module, since CART.2 Sand's, and since
ENGINE.9 the size ladder's, Life and the gun at four and sixteen times the
window's area, and since CART.12 Superposition's three, the large board's
idle frame, an act's latency and its deepest cascade, each row with its
memory, held to floors that never go down; and on every push where a runner
is built, the frames held to a hand-written Life, Sand or Superposition,
their allocations and the heap's bytes to ceilings that never go up, each
rung of the ladder to the cartridge measured, and the cascade to the deal
measured.

WHY: CART.1 (docs/ROADMAP.md; docs/REARVIEW.md, its scoping, decisions 4 to 7).
docs/CHARTER.md section 7 names the engine's measure, cells evaluated a second,
on the benchmark cartridge, Conway's Life at 320 by 200, against section 3's
line of two million a second; the honest comparison is a Life that computes
every cell every generation. This check holds that number where it can be
held. A timing is a measurement on the owner's machine (AD-4), so the timed
floors are the owner's run of tools/bench_frames.ps1, pasted below, as the
blit's and the render's floors are pasted. The allocations a frame makes are
a property of the code and not of the machine, exact on every run, and the
scoping's profile named allocation the step's largest cost, so they are held
on every push that builds the runner, where no time can be.

WHAT IT HOLDS, from the baseline pasted below:
  - a date, an environment line, the vla-lang pin it was measured at, and
    each fixture's SHA-256 over LF bytes; the pin equal to Cargo.toml's, or
    Cargo.toml's a registry release this file names as the measured commit's
    source byte for byte, and each digest equal to the fixture's, or the
    fixture's a rebuild of the measured file's rows this file names, so that
    a language moved or a fixture edited without a new measurement fails by
    name, and every change to the language is measured on the benchmark
    before it lands here (SPEC.3 rebuilt both fixtures by the pass from
    their sources, their rows unchanged: decision 30, docs/REARVIEW.md); and
    since ENGINE.9 each rung of the size ladder named by its cartridge's
    SHA-256 over LF, $baselineRungs, the cartridge the pass builds from Life's
    or the gun's source on a larger board, which this file cannot build, so
    the runner's check mode holds it where a runner is built;
  - the environment line saying, as the instrument writes it, that both
    halves ran opted out of Windows' power throttling and on the performance
    cores, or on a machine of one kind of core: the instrument's guards
    against measuring the power policy and the scheduler (CART.1's decisions
    5 and 13), since a run on an efficiency core is 23% slower with a clock
    that looks steady, and no other rule here would see it;
  - fourteen rows, native and wasm, life, gun and sand, and since ENGINE.9
    the size ladder's life-x4, life-x16, gun-x4 and gun-x16, each once
    (sand's two since CART.2, 2026-10-11: Sand's opening, Life's soup as
    grains, the charter's test of a chain two hundred rows deep), each with
    its Memory a whole number above 0, the heap's high-water mark over a
    load and four frames natively and the module's memory after frame 4 in
    the browser (ENGINE.9, decision 6): at least 30 steady
    frames; the clock's spread and its drift from the run's start within
    10% (the instrument's own guard against Windows' power throttling,
    measured to slow a background run by about 40% three seconds in; the
    clock read before a fixture's frames and after them since 2026-10-12,
    CART.1's decision 5 reopened, its spread the two sides apart, since read
    beside every frame it slowed the frame after it); cells
    a second equal to frames a second times the formula cells within half a
    percent, one measurement in two units, and each a finite number above 0
    (since 2026-10-10, CART.1: a gun frame quicker than the page's clock of
    0.1 ms read 0 ms timed alone, its rates infinite; the instrument now
    times such frames in runs of consecutive steps, a row's Run the frames a
    run, 1 where a frame is timed alone; the native runner too since
    2026-10-12, a frame under 2 ms, for the margin's sake below);
  - the floors, a dated history: each entry's floor at least the entry
    before it, row by row, unless the entry gives its reason (a correctness
    fix that costs speed, say, which the commit message repeats); each row's
    cells a second at least the latest floor. A row enters the history at
    the first entry that holds it, every entry after that holds it too, and
    the latest entry holds every row (since CART.2, whose two rows entered
    a history that was Life's alone). The floor is the baseline less
    a margin of 10%, the spread measured between sessions (4% natively, 7%
    in wasm) rounded up, on frames of about 100 ms (CART.1). A frame of
    microseconds timed alone spreads past it: the native gun's frames 2 to
    31 read 17.6 to 26.9 microseconds in one evening and 22 to 48 in one
    sitting the next day, where its runs of 128 read 42.4 to 44.5 across
    launches and an added load (CART.2, 2026-10-12). So both halves time a
    frame under 2 ms in runs, and a row timed one way where the baseline
    before it was timed the other measures other frames: the instrument
    re-bases its floor on the run, and where that is lower the entry's
    reason says so. So does a row whose fixture is not the file the
    baseline before it measured (CART.2's decision 24), since cells a
    second count a fixture's cells: Sand with water steps its opening in
    slice 1's time over half again the cells. Since ENGINE.9 (decision 5)
    the runs are of a fixed length over frames 32 to 671, back to back,
    ten of 64 natively and five of 128 in the browser, inside the gun's
    published facts' span, where every rung's board holds the same cells,
    so a row whose Run differs from the baseline's before it is re-based.
    tools/bench_frames.ps1 prints the history with its run's entry added
    last, to paste whole.
  - the history appended to and never pasted over: every entry the last
    commit's copy of this file holds is still here, in its order, at the
    head of the history, read with git (SKIPPED where git or the commit is
    not there to ask). Without it, an entry pasted over the one before it
    would erase the record, and a slower run's entry pasted over the latest
    would lower a floor with no reason written, past the rule above (the
    second baseline's paste lost the first entry, 2026-10-10);
  - the bars, 2,000,000 cells a second (docs/CHARTER.md section 3) and the
    charter's 30 frames a second, printed with the distance; out of reach
    when the first baseline was pasted, they were not gated, and a floor
    that reaches one makes it a gate from then on, since a floor never goes
    down;
  - the size ladder's slope, printed and never gated (ENGINE.9, decision
    8): for life and the gun, each rung's frame, load and memory over the
    window's, the exponent against the formula cells, and the gun's idle
    frame at sixteen times the area against the prediction that it costs
    what it costs on the window;
  - since CART.12 (decision 8, 2026-10-18), Superposition's six rows, three
    a half, each over the committed lattice of 512 by 512, whose one file
    $baselineFixtures names: the idle frame, superposition, timed in runs of
    1,000 as the gun is; an act's latency, superposition-act, the scripted
    player's 200 acts at 15%, its Frames the acts, its Steps the frames they
    took, and its cells a second taken at the session's 95th percentile,
    FrameP95, so that its frames a second, acts here, are one over its p95
    within 5% (the browser's p95 reads its clock's tenths of a millisecond);
    and the deepest cascade by time, superposition-cascade, the lattice at
    8% observed at the end of its largest opening's widest path, its frames a
    second its Frames over CascadeMs, the act and its settle timed whole,
    with its Seed, Probability, Deal, Rings and sites Opened. Each half plays
    the session and finds the deal by its own hand, so the two act rows hold
    the same Frames and Steps and the two cascade rows the same cascade, or
    the halves measured other work.
  - since CART.9 (decision 6, 2026-10-20), naught's four rows, two a half:
    the regularity premium, the same netlist, a 4,096-bit adder and a 64 by
    64 multiplier, 44,544 gates, laid by fill, naught-f, each role one shape,
    and shuffled among the same cells, naught-s, every gate its own shape,
    both built by the pass from cartridges/naught/naught.source.vla and each
    named in $baselineRungs by its cartridge's SHA-256 over LF, as a rung of
    the ladder is. A row's steady frame is frames 2 to 31, every switch a
    hash of the frame; it carries its idle frame, IdleP50, a switch's cone,
    ConeP50, and its census, the Shapes and the Levels the language plans,
    which the two halves hold alike; and the premium, each shuffled number
    over the filled, is printed for each half and never gated.
An empty baseline fails, since a floor with no number is no floor.

WITH A BUILT RUNNER (target/release/examples/frames, or -Runner): its check
mode, each fixture four frames, and since ENGINE.9 each rung of the ladder
its source climbs, every frame equal to the runner's own Life or Sand over
its whole board, the gun held to its published facts at every rung and
Sand's opening to its grains, every frame after the first keeping each
material's count; the allocations and reallocations of each fixture's
second frame after a fresh load, and the heap's high-water bytes over the
load and the four frames, at most the ceilings below; and each rung's
digest the baseline's. Since CART.12 Superposition's three counted
instances, each its acts settled and every frame's Tally held to the
runner's own lattice, the whole lattice at each settle's end: the idle
row's two idle acts, the second counted; the session's first twelve acts,
the twelfth counted; and the cascade, counted whole, its deal, rings and
sites opened the baseline's native cascade row's. Since CART.9 naught's two
fixtures, every gate held to the netlist by hand at each of four frames,
each one's digest the baseline's rung and its census, its shapes and
levels, the baseline's row's. A count under its ceiling is printed so the
ceiling can be lowered.
SKIPPED without a runner: the ratchets job builds none, and the crate job
builds it before this check runs.

-Control proves the judgment: a clean table passes, a table with a floor
lowered for a written reason passes, and so do a pin moved to a registry
release the table names as the measured source, a fixture rebuilt with
the rows the table names as the measured ones, and a row entering the
history at a later entry (CART.2); an empty baseline, a row
missing, a smoke run's few frames, a row under its floor, a floor lowered
with no reason, no floor at all, the pin moved, the pin moved to a release
of another source, a fixture's digest changed, a fixture rebuilt with rows
the table does not name, a clock
that moved, frames a second that disagree with cells a second, a frame read
as 0 ms whose rates are infinite (CART.1, 2026-10-10), a run not
opted out of the throttling, a run not on the performance cores, a row
dropped from an entry after it entered the history, a latest entry
without a row's floor, a row without its memory, a rung's row missing, a
rung the baseline names no digest for, an act row without its p95, an act
row whose acts a second are not one over its p95, a cascade row without its
deal, two halves' sessions apart, two halves' cascades apart, a naught row
without its idle frame, two halves' census apart and a naught rung the
baseline names no digest for must each fail; the history, read
from text as the commit's copy is: an entry
added after the committed ones passes, and so does a history unchanged,
and an entry pasted over a committed one and a committed entry edited in
place must each fail; then fake runners: a clean one passes, and one whose
frame differs, one whose allocations pass the ceiling, one whose heap
passes its ceiling, one that never holds the gun's facts, one that never
holds Sand's grains, one that leaves out a fixture, one that leaves out a
rung, one whose rung is another cartridge, one whose cascade is another
deal, one that settles no act, one whose census is another and one that
prints no census must each fail.

House style (tools/check_*.ps1): PowerShell 5.1 and pwsh alike, host-free,
no browser, no network; a hardcoded, reviewable baseline; exit 0 clean,
exit 1 with every problem named.

Usage:  powershell -File tools\check_frame_floors.ps1
        powershell -File tools\check_frame_floors.ps1 -Runner target\release\examples\frames.exe
        powershell -File tools\check_frame_floors.ps1 -Control
#>
param(
    [string]$Root = '',
    [string]$Runner = '',
    [switch]$Control
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
if ($Root -eq '') { $Root = $repoRoot }
$onWindows = [System.Environment]::OSVersion.Platform -eq [System.PlatformID]::Win32NT

# --- the baseline, hand-maintained: the owner's run of tools/bench_frames.ps1 ---
# Paste the block the instrument prints over the seven lines below, whole
# (six until ENGINE.9 added $baselineRungs), and
# the history it prints over $floorHistory, whole: it is this file's history
# with the run's entry added last (the instrument writes both to
# target/bench_frames.txt as well, to copy from). A later run that is slower
# than the floor is a finding to record in docs/REARVIEW.md, never a number to
# paste over a faster one.
# 2026-10-09, the first baseline: the owner's run, over vla-lang at c0686a9,
# both halves opted out of Windows' power throttling and every clock within
# 2.3% (CART.1's first slice). Copied from the terminal, whose line wrap
# dropped two spaces, one in the environment line and one in the last row,
# put back before the commit, and the floor entry set inside the history's
# parentheses; no value was touched. Its rows, the second having replaced
# them: native life 217,984 cells a second (frame p50 288.8 ms), native gun
# 207,634 (303.2), wasm life 228,710 (275.3), wasm gun 219,731 (286.6); its
# floors are the history's first entry.
# 2026-10-10, the second: the owner's run over f5dc344 (KERNEL.25, the
# evaluator's hot path), both halves opted out and on the performance cores
# (CART.1's second slice), copied from target/bench_frames.txt whole. Its
# floor entry was pasted over the first instead of after it; the first was
# put back before the commit, and no value was touched. Its rows, the third
# having replaced them: native life 622,904 cells a second (frame p50 101.1
# ms), native gun 651,551 (96.6), wasm life 460,600 (136.7), wasm gun
# 466,400 (135.0); its floors are the history's second entry.
# 2026-10-11, the third: the owner's run over vla-lang 0.9.0 (KERNEL.20's
# first four slices, KERNEL.26 and KERNEL.27: a frame computes only the
# cells a change reaches), both halves opted out and on the performance
# cores, pasted from target/bench_frames.txt whole, no value touched. The
# gun's browser row is timed in runs of 128 frames, its frames 158 to 3997
# (CART.1's frame timer, 0dfe551), each row naming its frames a run. Its
# floors pass the charter's line of two million cells a second and Life's
# thirty frames a second, so both bars are gates from this entry on. Its
# rows, the fourth having replaced them: native life 22,453,863 cells a
# second (frame p50 2.8 ms), native gun 4,128,786,885 (0.0152), wasm life
# 14,815,059 (4.3), wasm gun 1,026,674,140 (0.0613); its floors are the
# history's third entry.
# 2026-10-11, the fourth: the owner's run with CART.2's first slice, the
# same pin, Sand's opening measured beside Life's two fixtures, both halves
# opted out and on the performance cores, pasted from target/bench_frames.txt
# whole, no value touched. Sand's rows enter the history at this entry. The
# run measured Life's two native rows slower than the third on unchanged
# code: the same runner, built from 96fe7a5's engine, and the slice's
# measured the same in an A/B that evening, the clock beside every frame and
# the browser's rows unchanged (docs/REARVIEW.md, CART.2). The instrument then
# printed every floor as the run less 10%, so the pasted entry lowered both,
# and the check refused it. At the owner's word the entry keeps native
# life's floor, which the run clears, and lowers the native gun's with its
# reason; the instrument has since printed the higher of the latest floor and
# the run less 10%.
# 2026-10-12, the fifth: the owner's run over vla-lang 0.9.1 with CART.2's
# third slice, water, and CART.1's frame timer as it now stands (the clock
# read before a fixture's frames and after them, the native gun in runs of
# 128), both halves opted out and on the performance cores, after the
# owner's hand test of the slice passed. Pasted from target/bench_frames.txt
# whole, no value touched; the terminal's copy, given in chat, had dropped
# two spaces at its line wraps. Its entry re-bases the native gun's floor,
# with its reason, timed in runs where the fourth timed it alone, and Sand's
# two rows on water's cartridge, both higher; Life's two rows are held,
# native life clearing its floor again at 2.8 ms. Its rows, the sixth having
# replaced them: native life 22,561,677 cells a second (frame p50 2.8 ms),
# native gun 1,489,473,470 (0.0423, runs of 128), native sand 15,329,970
# (12.3), wasm life 15,741,000 (4.0), wasm gun 1,033,255,383 (0.0609), wasm
# sand 10,618,933 (17.8); its floors are the history's fifth entry.
# 2026-10-12, the sixth: the owner's run with CART.2's playtest pass built,
# Sand's brush read from the Gate's rows, its rate of 60 and the host's tick
# on the frame's grid, after the owner's hand test, no stall on any click.
# Pasted from target/bench_frames.txt whole, no value touched; the chat's
# copy had dropped a space at a line wrap. Its entry re-bases Sand's two rows
# lower on the row gate's cartridge, their reasons written: over vla-lang
# 0.9.1 each marked cell reads its row's gate and splits its lanes, and the
# opening's frames take 15.8 ms natively and 22.5 in the browser against the
# fifth's 12.3 and 17.8, until a run reads a held column once, asked of
# Frazaro the same day (docs/REARVIEW.md, CART.2). Life's and the gun's rows are
# held, native life's floor raised to 20,500,000. (This note was cut short at
# a quotation mark when it was spliced in, and was restored with the
# seventh.) Its rows, the seventh having replaced them: native life
# 22,781,677 cells a second (frame p50 2.8 ms), native gun 1,489,542,292
# (0.0423, runs of 128), native sand 12,009,228 (15.8), wasm life 15,546,667
# (4.0), wasm gun 1,020,176,202 (0.0617), wasm sand 8,390,909 (22.5); its
# floors are the history's sixth entry.
# 2026-10-12, the seventh: the owner's run with Sand's opening raining from
# the board's top third, rows 2 to 67, so that its first seconds keep sixty
# frames a second. Pasted from target/bench_frames.txt whole, no value
# touched; the chat's copy had dropped a space at a line wrap. Its entry
# re-bases Sand's two rows on the new cartridge, both higher, its reason
# blank since no floor goes down: 5.6 ms natively and 8.3 in the browser
# against the sixth's 15.8 and 22.5. The rise is the workload, a third of the
# grains falling, and not the engine, which with the language is the sixth's.
# From this entry Sand's rows measure a gentler opening than the worst a
# person can make; a fixture of the whole board falling, for the floors
# alone, is slice 4's to weigh (docs/REARVIEW.md, CART.2; REPO.5's since CART.2's
# close). Life's and the gun's rows are held, the wasm gun's floor raised to
# 935,000,000. Its rows, the eighth having replaced them: native life
# 22,500,402 cells a second (frame p50 2.8 ms), native gun 1,487,370,607
# (0.0423, runs of 128), native sand 33,998,149 (5.6), wasm life 14,815,059
# (4.2), wasm gun 1,039,921,548 (0.0605), wasm sand 22,796,988 (8.3); its
# floors are the history's seventh entry.
# 2026-10-12, the eighth: the owner's run over vla-lang 0.9.2, Frazaro's
# KERNEL.33, the playtest pass's three asks (a plan's edges found once a
# shape, a held column read once across a row, a row of single cells reached
# as one span), and KERNEL.30, the census describe prints, which the module
# carries (682,679 bytes). Pasted from target/bench_frames.txt whole, no value
# touched; the chat's copy had dropped a space at a line wrap. Sand's rows
# rise on the same fixture, so the rise is the language's and not the
# workload's: natively 3.7 ms a frame where the seventh had 5.6, and in the
# browser 6.1 where it had 8.3; its load 133 ms natively and 159 in the
# browser, where it was 502 and 586. Life's and the gun's frames hold, their
# loads nearly halved. Its entry raises Sand's two floors, to 45,500,000 and
# 27,900,000, and the wasm life and gun floors, native life's kept.
# 2026-10-14, the ninth: the owner's run with ENGINE.9 built, the size ladder,
# over vla-lang 0.9.2 and the respelled cartridges this file's $sameRows names
# as the measured rows. Since that build the instrument's block holds fourteen
# rows, the ladder's eight beside the six, every row with its Memory, and a
# line more, $baselineRungs, each rung by its cartridge's digest; the ladder's
# eight rows enter the history at this entry. The gun is timed in runs over
# frames 32 to 671, where every rung's board holds the same cells, so the
# native gun's floor is re-based on its runs of 64, higher, and the wasm gun's
# rises on the same window; Sand's wasm floor rises too, and no floor goes
# down, so the entry gives no reason. Its rows: native life 22,168,081 cells
# a second (frame p50 2.8 ms), life-x4 18,062,791 (14.1), life-x16 17,668,708
# (57.7), gun 2,435,008,762 (0.0259, runs of 64), gun-x4 9,009,638,808
# (0.0282), gun-x16 30,857,609,682 (0.0330), sand 49,557,371 (3.8); wasm life
# 15,546,667 (4.0), life-x4 14,146,184 (18.0), life-x16 14,538,047 (70.1), gun
# 1,679,040,000 (0.0375, runs of 128), gun-x4 5,803,977,142 (0.0438), gun-x16
# 23,734,551,273 (0.0430), sand 32,623,276 (5.8). The ladder's slope: Life's
# frame, load and memory in proportion to the cells; the gun's idle frame 1.27
# times the window's natively and 1.15 in the browser at sixteen times the
# area, the prediction missed. Its floors are the history's ninth entry.
# 2026-10-14, the tenth: the instrument's run over vla-lang 0.9.3, Frazaro's
# KERNEL.34 to KERNEL.37 (a formula written into a running grid in its
# cells' time, a changed cell checked against the readers kept where it
# stands, a frame's end copying whatever share changed, and a window's values
# without its formulas' texts), which the module carries (749,135 bytes,
# 66,464 more than 0.9.2's). Run by the session preparing REPO.4's first
# release, at the owner's word to make the release ready and push it, and not
# by the owner's own hand as the nine before it were: the same machine and
# the same instrument, both halves opted out and on the performance cores,
# every clock's spread within 6.7%, pasted from target/bench_frames.txt whole,
# no value touched; the owner's own run is the next entry whenever it is
# made. No row fell under its floor. Its entry keeps ten floors and raises
# four, the native gun's two rungs, the wasm gun's at four times the area and
# wasm Life's at sixteen, and gives no reason, since none goes down. The heap
# rose about two bytes a formula cell, the language's (the ceilings' note
# below). The gun's idle frame at sixteen times the area costs 1.08 times the
# window's natively, within the margin, where over 0.9.2 it cost 1.27, and
# 1.18 times in the browser. Its rows: native life 21,505,935 cells a second
# (frame p50 2.9 ms), life-x4 17,871,966 (14.2), life-x16 17,484,609 (58.3),
# gun 2,223,464,563 (0.0283, runs of 64), gun-x4 9,409,493,370 (0.0270),
# gun-x16 33,422,954,144 (0.0305), sand 48,383,921 (3.9); wasm life
# 14,815,059 (4.2), life-x4 13,951,868 (18.2), life-x16 14,569,200 (70.0),
# gun 1,611,878,400 (0.0391, runs of 128), gun-x4 6,500,454,400 (0.0391),
# gun-x16 22,125,429,151 (0.0461), sand 32,070,339 (5.9). Its floors are the
# history's tenth entry.
# 2026-10-15, the eleventh: the owner's run over vla-lang 0.9.4, Frazaro's
# KERNEL.42 (a window's changes, a fourth projection), which the module
# carries (766,043 bytes), with ENGINE.14 to ENGINE.18 built. Pasted from
# target/bench_frames.txt whole, no value touched; every clock's spread within
# 5.5%. No row fell under its floor. Its entry keeps twelve floors and raises
# two, native Life's at sixteen times the area and wasm Life's at four, and
# gives no reason, since none goes down. The heap's six Memory rows of Life
# and the gun rose by 1,536 bytes, the language's (the ceilings' note below).
# Its rows: native life 21,922,253 cells a second (frame p50 2.9 ms), life-x4
# 17,767,671 (14.3), life-x16 17,992,950 (56.7), gun 2,308,884,432 (0.0273,
# runs of 64), gun-x4 8,881,130,147 (0.0286), gun-x16 32,792,411,576 (0.0311),
# sand 48,418,588 (3.9); wasm life 14,815,059 (4.3), life-x4 14,635,389
# (17.3), life-x16 14,517,352 (70.3), gun 1,679,040,001 (0.0375, runs of 128),
# gun-x4 6,500,454,400 (0.0391), gun-x16 23,310,719,963 (0.0438), sand
# 32,070,339 (5.9). Its floors are the history's eleventh entry.
# 2026-10-17, the twelfth: the instrument's run over vla-lang 0.10.0, Frazaro's
# KERNEL.43, KERNEL.44 and KERNEL.31 (a fill's cells read and folded as slices
# of numbers, a cell computed alone by its formula compiled once, and a sheet
# read in the frame being computed read as an array, every answer the same to
# the bit), with KERNEL.47 and VLA.4, and the release profile at opt-level 3,
# the owner's choice that day of the question CART.1's decision 10 left to
# ENGINE.6, where "s" had kept the module small; the module carries both
# (1,038,643 bytes). Run by the session preparing the 0.2.0 release, at the
# owner's word that the pins be moved before it, and not by the owner's own
# hand, as the tenth was not: the same machine and the same instrument, both
# halves opted out and on the performance cores, every clock's spread within
# 3.4%. Three runs were made back to back over the same builds, every row
# within 5% across them but the gun's in the browser, within 8%; this is the
# second, the median of the three on eight of the fourteen rows, pasted from
# target/bench_frames.txt whole, no value touched. Two runs at "s" the same
# day, the first refused by the instrument for Sand's native clock spread of
# 10.8%, and an earlier run at 3 measured the choice (docs/REARVIEW.md,
# ENGINE.1's record of the pin). No row fell under its floor; its entry
# raises all fourteen and gives no reason, since none goes down. The heap's
# seven Memory rows rose, the language's (the ceilings' note below). Its rows:
# native life 30,658,065 (2.1) cells a second (frame p50, ms),
# life-x4 24,523,176 (10.4), life-x16 24,770,720 (41.2),
# gun 3,318,670,784 (0.0190), gun-x4 12,835,586,447 (0.0198),
# gun-x16 45,071,308,911 (0.0226), sand 63,576,037 (3.0);
# wasm life 25,699,592 (2.5), life-x4 23,955,094 (10.6),
# life-x16 22,688,409 (45.0), gun 2,599,803,901 (0.0242),
# gun-x4 10,156,960,038 (0.0250), gun-x16 35,281,089,843 (0.0289),
# sand 48,516,666 (3.9). Its floors are the history's twelfth entry.
# 2026-10-18, the thirteenth: the instrument's run over vla-lang 0.10.1, Frazaro's
# KERNEL.48 (a frame's count of the formula cells it changed, on each sheet,
# and of those it computed, which CART.12's settle reads; a frame costs what
# it cost, by its notes), with CART.12 built: the page's version 6 and
# Superposition, the large board, whose three rows enter the history at this
# entry, the idle frame, an act's latency at the session's 95th percentile and
# the deepest cascade at 8%, each half held to a lattice by hand. The module
# carries both (1,042,949 bytes). Run by the session finishing CART.12, at the
# owner's word to finish it over the new pin, and not by the owner's own hand,
# as the twelfth was not: the same machine and the same instrument, both
# halves opted out and on the performance cores, every clock's spread within
# 4.5%. Six runs were made that day, three after a build and three without,
# and every one refused itself, on the gun at four or sixteen times the area:
# natively 0.0227 to 0.0285 ms at sixteen times, in the browser 0.0289 to
# 0.0398. An A/B of the twelfth baseline's own module and runner, rebuilt
# byte for byte from 275f1e0, against this pin's, run alternately under the
# same guards, read the two alike (docs/REARVIEW.md, ENGINE.1's record of the
# pin to 0.10.1), so the spread is the run's and not the engine's. This is
# the third run, pasted from target/bench_frames.txt whole but for one floor:
# its browser half clean, its one refusal the native gun at sixteen times the
# area, 0.7% under its floor, which its entry lowers by hand to this run's
# less 10%, the reason written. Its entry raises six floors and enters
# Superposition's six. Superposition's rows across the six runs: natively
# the idle frame 0.0043 to 0.0045 ms, an act's p95 0.449 to 0.487 ms, the
# cascade 136.9 to 141.3 ms; in the browser 0.0052 to 0.0054, 0.6 or 0.7
# (the page's clock), and 174.4 to 188.8. The heap's seven Memory rows rose by
# four bytes a sheet, the language's (the ceilings' note below). Its rows:
# native life 30,929,901 (2.0) cells a second (frame p50, ms), life-x4
# 25,327,183 (10.0), life-x16 24,711,390 (41.3), gun 3,411,094,087 (0.0185),
# gun-x16 40,224,334,268 (0.0254), superposition 187,027,969,981 (0.0043),
# superposition-act 1,755,838,646 (p95 0.4549), superposition-cascade (141.3
# ms over 777 frames); wasm gun-x16 35,281,089,843 (0.0289), superposition
# (0.0053), superposition-act (p95 0.7), superposition-cascade (174.4 ms).
# Its floors are the history's thirteenth entry.
# 2026-10-19, the fourteenth: the owner's run of the instrument at CART.12's hand
# test, the same pin, module and fixtures as the thirteenth (vla-lang 0.10.1,
# 1,042,949 bytes), both halves opted out and on the performance cores, every
# clock's spread within 3.4%. No row fell under its floor. Pasted from
# target/bench_frames.txt whole but for one floor: its entry raised the wasm
# superposition-act floor from 1,020,000,000 to 1,190,000,000, the run's act p95
# of 0.6 ms less 10%, and the page reads that p95 in tenths of a millisecond,
# 0.6 or 0.7 from run to run (six runs of the thirteenth's day read 0.7 four
# times), so a floor from 0.6 would refuse a run that reads 0.7; the floor is
# kept at the latest, 1,020,000,000, the 0.7's. Its entry raises six other
# floors: native gun 3,060,000,000 to 3,100,000,000, native sand 58,600,000 to
# 59,900,000, native superposition-act 1,580,000,000 to 1,590,000,000, native
# superposition-cascade 3,950,000,000 to 3,960,000,000, wasm gun-x16
# 31,700,000,000 to 32,600,000,000 and wasm sand 43,600,000 to 44,800,000. Its
# rows: native life 29,041,096 (2.2) cells a second (frame p50, ms), life-x4
# 25,236,815 (10.1), life-x16 24,347,797 (41.9), gun 3,448,458,346 (0.0183),
# gun-x4 12,041,892,483 (0.0211), gun-x16 39,140,091,149 (0.0261), sand
# 66,606,238 (2.8), superposition 185,544,276,157 (0.0043), superposition-act
# 1,767,103,982 (p95 0.4520), superposition-cascade 4,409,626,974 (140.7 ms
# over 777 frames); wasm life 26,235,000 (2.4), life-x4 22,876,036 (11.1),
# life-x16 22,365,000 (45.6), gun 2,599,803,851 (0.0242), gun-x4 10,156,960,038
# (0.0250), gun-x16 36,261,119,760 (0.0281), sand 49,793,421 (3.8),
# superposition 150,703,963,620 (0.0053), superposition-act 1,331,218,280 (p95
# 0.6), superposition-cascade 3,308,176,904 (187.6 ms). Its floors are the
# history's fourteenth entry.
# 2026-10-19, the fifteenth: this session's run of the instrument at CART.12's
# second hand test, over the board moved to A1 and bound there (superposition.vla
# D157A425..., 636 rows, 44 shapes, 798,731 formula cells as before) and the
# module that reads version 6's bound (1,045,898 bytes), the same machine, both
# halves opted out and on the performance cores. No row fell under its floor; the
# rows of the fixtures that did not move kept their floors, each slower than the
# run that set it and above it, but native life-x4, raised 22,700,000 to
# 22,900,000, and native gun-x16, 36,200,000,000 to 40,400,000,000, its
# thirteenth's lowering made good. The six Superposition rows measure another
# file, and three are re-based, each floor this run's less 10%, as the
# instrument's reason says: native superposition 168,000,000,000 to
# 158,000,000,000, native superposition-cascade 3,960,000,000 to 3,630,000,000,
# and wasm superposition-cascade 3,200,000,000 to 3,070,000,000. Native
# superposition-act rose, 1,590,000,000 to 1,730,000,000. The wasm
# superposition-act floor is kept at 1,020,000,000 where the entry raised it to
# 1,190,000,000 from a p95 of 0.6 ms: the page reads that p95 in tenths of a
# millisecond, 0.6 or 0.7 from run to run, as the fourteenth's note says. Its
# rows: native superposition 175,806,085,952 cells a second (frame p50 0.0045
# ms), superposition-act 1,923,725,915 (p50 0.3114, p95 0.4152),
# superposition-cascade 153.6 ms over 777 frames; wasm superposition
# 150,703,963,620 (0.0053), superposition-act 1,331,218,280 (p50 0.4, p95 0.6),
# superposition-cascade 181.8 ms. The cascade is the measured one's: the
# board's worlds kept, its deal at SO501 where the board at B2 had it at SP502,
# 775 rings, 209,446 sites. The native cascade read 153.6 ms against the
# fourteenth's 140.7 while the act's p95 read 0.415 against 0.452: the box's
# branch adds one comparison to every observed site a frame recomputes, and the
# run's own noise the rest. Its floors are the history's fifteenth entry.
# 2026-10-23, the seventeenth: the pin moved to vla-lang 0.11.0, this
# session's three runs of the instrument at the owner's word to pin, the
# machine otherwise quiet (13 to 23% load, no build running), both halves
# opted out of the throttling and on the performance cores; the third's block,
# the module 1,819,745 bytes, 0.11.0's library. Every value the same: each
# fixture's frames held to its hand as before. The language's grid as written
# (KERNEL.49) raised the board's rows most: native superposition 795,390,360,486
# cells a second (frame p50 0.0010 ms), its floor 163,000,000,000 to
# 715,000,000,000, and wasm superposition 570,522,152,573, 135,000,000,000 to
# 513,000,000,000; superposition-act natively 2,148,859,295 (p95 0.3717), its
# floor to 1,930,000,000, and the cascade 4,767,719,037, to 4,290,000,000; the
# ladder's life rungs about 14% and 18% natively, and naught-s 2,948,008 natively
# and 2,318,640 in the browser. And it slowed the grids whose fills read one
# another's cells, which its notes say it plans cell by cell: native naught-f
# 10,681,201 (4.9 ms), 10% under the sixteenth's 11,838,275, its floor lowered
# with the entry's reason, and Sand 62,322,755 natively and 44,003,488 in the
# browser, 6% and 10% under, wasm sand's floor lowered the same way. The gun's
# idle frames in the browser, wasm gun 2,066,510,782 (0.0305 ms) and gun-x4
# 8,784,398,008 (0.0289), lowered for their spread between runs, the
# 2026-10-18 entry's finding for such rows; wasm superposition-act kept at
# 1,020,000,000, the fifteenth's reason. Its floors are the history's
# seventeenth entry.
$baselineDate = '2026-10-23'
$baselineEnvironment = 'Intel(R) Core(TM) Ultra 7 265KF, 20 cores | Microsoft Windows 11 Home 10.0.26200 | rustc 1.99.0 (b940084d7 2026-09-28) | chrome 155.0.8059.79 headless | the engine''s module 1,819,745 bytes | vla-lang at 0.11.0 | power throttling opted out: the runner yes, 41 browser process(es) | on the performance cores, 8 of 20 logical processors (efficiency class 1): the runner yes, 42 browser process(es)'
$baselinePin = '0.11.0'
$baselineFixtures = @{ 'life' = '60220BAE07BBC3C15F671C7CAAE62B6DD6D14B67B9141150EC0023AFA0FFE0F4'; 'gun' = '64C9A6BA206003F15B73084FE90781BE60E34089D577CE0589DBAF5C737A0725'; 'sand' = 'F872498DEAFBCCB60133501B18E35BEC38A470C4A9AE8064505510D061EAD857'; 'superposition' = 'D157A4254B513FFB5B1814FB9F031CB15468BB0165C70A94F6183D0B3B625AE8' }
$baselineRungs = @{ 'life-x4' = 'D841A88328E95AABB7603CC97B902447346E9A705E32C01770AE74319A252285'; 'life-x16' = '944AEF5CA1FD41FF9973CB4A31B04C98595A408F7F50E7C6FA50B8E0ADE56613'; 'gun-x4' = '09E2744A4117AE2FBF33369EC3BD0BED5F2A69FA532C09BB86DB6FEA3F05B863'; 'gun-x16' = 'B762A925CD57929507CAB39F93812F36EB1196AA3B8693A7E9E1CC1999A83B59'; 'naught-f' = '4DD37928DEEE1DC7400DED593EA70D8D284E2C14D734384ABFC7A466F6CE74C3'; 'naught-s' = 'A6F8498C083D9F1A7B7A4D436159564DFDDB4CB3D80AFC016ACB6505D8CD73FE' }
$baseline = @(
    @{ Runner = 'native'; Fixture = 'life'; Cells = 62964; Frames = 30; Run = 1; Load = 10.2; Memory = 2525819; FirstFrame = 3.5; FrameP50 = 2.0; FrameMin = 1.6; FrameMax = 3.0; CellsPerSecond = 30876057; FramesPerSecond = 490.376; ClockMs = 0.335; ClockSpread = 1.2; ClockDrift = -0.0 },
    @{ Runner = 'native'; Fixture = 'life-x4'; Cells = 253924; Frames = 30; Run = 1; Load = 39.5; Memory = 9477744; FirstFrame = 14.1; FrameP50 = 8.7; FrameMin = 6.6; FrameMax = 11.8; CellsPerSecond = 29353170; FramesPerSecond = 115.598; ClockMs = 0.335; ClockSpread = 0.9; ClockDrift = 0.0 },
    @{ Runner = 'native'; Fixture = 'life-x16'; Cells = 1019844; Frames = 30; Run = 1; Load = 152.6; Memory = 21030408; FirstFrame = 56.9; FrameP50 = 35.0; FrameMin = 27.5; FrameMax = 52.8; CellsPerSecond = 29128455; FramesPerSecond = 28.562; ClockMs = 0.335; ClockSpread = 0.6; ClockDrift = 0.1 },
    @{ Runner = 'native'; Fixture = 'gun'; Cells = 62964; Frames = 640; Run = 64; Load = 10.3; Memory = 2451537; FirstFrame = 2.5; FrameP50 = 0.0194; FrameMin = 0.0109; FrameMax = 0.0281; CellsPerSecond = 3245044291; FramesPerSecond = 51538.090; ClockMs = 0.335; ClockSpread = 0.8; ClockDrift = 0.1 },
    @{ Runner = 'native'; Fixture = 'gun-x4'; Cells = 253924; Frames = 640; Run = 64; Load = 39.7; Memory = 9403462; FirstFrame = 10.0; FrameP50 = 0.0196; FrameMin = 0.0115; FrameMax = 0.0286; CellsPerSecond = 12966159493; FramesPerSecond = 51063.151; ClockMs = 0.335; ClockSpread = 1.1; ClockDrift = -0.1 },
    @{ Runner = 'native'; Fixture = 'gun-x16'; Cells = 1019844; Frames = 640; Run = 64; Load = 152.9; Memory = 20956126; FirstFrame = 40.2; FrameP50 = 0.0210; FrameMin = 0.0122; FrameMax = 0.0293; CellsPerSecond = 48672644295; FramesPerSecond = 47725.578; ClockMs = 0.335; ClockSpread = 0.5; ClockDrift = 0.1 },
    @{ Runner = 'native'; Fixture = 'sand'; Cells = 189215; Frames = 30; Run = 1; Load = 217.9; Memory = 10182809; FirstFrame = 11.1; FrameP50 = 3.0; FrameMin = 3.0; FrameMax = 5.6; CellsPerSecond = 62322755; FramesPerSecond = 329.375; ClockMs = 0.335; ClockSpread = 0.7; ClockDrift = 0.1 },
    @{ Runner = 'native'; Fixture = 'superposition'; Cells = 798731; Frames = 10000; Run = 1000; Load = 8.7; Memory = 10817526; FirstFrame = 89.7; FrameP50 = 0.0010; FrameMin = 0.0010; FrameMax = 0.0011; CellsPerSecond = 795390360486; FramesPerSecond = 995817.566; ClockMs = 0.335; ClockSpread = 0.4; ClockDrift = -0.1 },
    @{ Runner = 'native'; Fixture = 'superposition-act'; Cells = 798731; Frames = 200; Run = 1; Steps = 780; Load = 8.8; Memory = 10819392; FirstFrame = 0.8063; FrameP50 = 0.2592; FrameP95 = 0.3717; FrameMin = 0.2175; FrameMax = 0.8063; CellsPerSecond = 2148859295; FramesPerSecond = 2690.342; ClockMs = 0.335; ClockSpread = 1.1; ClockDrift = 0.1 },
    @{ Runner = 'native'; Fixture = 'superposition-cascade'; Cells = 798731; Frames = 777; Run = 1; Load = 9.0; Memory = 10824346; FirstFrame = 0.2876; FrameP50 = 0.1676; FrameMin = 0.0028; FrameMax = 0.5055; CascadeMs = 130.2; Seed = 1; Probability = 0.08; Deal = 'SO501'; Rings = 775; Opened = 209446; CellsPerSecond = 4767719037; FramesPerSecond = 5969.117; ClockMs = 0.336; ClockSpread = 0.7; ClockDrift = 0.3 },
    @{ Runner = 'native'; Fixture = 'naught-f'; Cells = 52865; Frames = 30; Run = 1; Load = 20.1; Memory = 3382521; FirstFrame = 6.8; FrameP50 = 4.9; FrameMin = 4.7; FrameMax = 5.4; IdleP50 = 0.0009; ConeP50 = 0.6224; Shapes = 32; Levels = 8194; CellsPerSecond = 10681201; FramesPerSecond = 202.047; ClockMs = 0.335; ClockSpread = 0.7; ClockDrift = 0.2 },
    @{ Runner = 'native'; Fixture = 'naught-s'; Cells = 52865; Frames = 30; Run = 1; Load = 488.0; Memory = 128662774; FirstFrame = 17.3; FrameP50 = 17.9; FrameMin = 12.7; FrameMax = 21.7; IdleP50 = 0.0009; ConeP50 = 2.0; Shapes = 44548; Levels = 8194; CellsPerSecond = 2948008; FramesPerSecond = 55.765; ClockMs = 0.335; ClockSpread = 1.5; ClockDrift = 0.1 },
    @{ Runner = 'wasm'; Fixture = 'life'; Cells = 62964; Frames = 30; Run = 1; Load = 18.9; Memory = 3801088; FirstFrame = 11.4; FrameP50 = 2.6; FrameMin = 1.9; FrameMax = 5.2; CellsPerSecond = 24216923; FramesPerSecond = 384.615; ClockMs = 0.295; ClockSpread = 1.7; ClockDrift = 0.0 },
    @{ Runner = 'wasm'; Fixture = 'life-x4'; Cells = 253924; Frames = 30; Run = 1; Load = 31.4; Memory = 11206656; FirstFrame = 18.2; FrameP50 = 10.3; FrameMin = 7.8; FrameMax = 15.6; CellsPerSecond = 24652816; FramesPerSecond = 97.087; ClockMs = 0.295; ClockSpread = 1.7; ClockDrift = 0.0 },
    @{ Runner = 'wasm'; Fixture = 'life-x16'; Cells = 1019844; Frames = 30; Run = 1; Load = 124.0; Memory = 24379392; FirstFrame = 70.8; FrameP50 = 43.0; FrameMin = 33.4; FrameMax = 62.0; CellsPerSecond = 23717302; FramesPerSecond = 23.256; ClockMs = 0.295; ClockSpread = 1.7; ClockDrift = 0.0 },
    @{ Runner = 'wasm'; Fixture = 'gun'; Cells = 62964; Frames = 640; Run = 128; Load = 8.4; Memory = 3801088; FirstFrame = 4.0; FrameP50 = 0.0305; FrameMin = 0.0156; FrameMax = 0.0430; CellsPerSecond = 2066510782; FramesPerSecond = 32820.513; ClockMs = 0.295; ClockSpread = 1.7; ClockDrift = 0.0 },
    @{ Runner = 'wasm'; Fixture = 'gun-x4'; Cells = 253924; Frames = 640; Run = 128; Load = 31.1; Memory = 11141120; FirstFrame = 16.2; FrameP50 = 0.0289; FrameMin = 0.0156; FrameMax = 0.0367; CellsPerSecond = 8784398008; FramesPerSecond = 34594.595; ClockMs = 0.295; ClockSpread = 1.7; ClockDrift = 0.0 },
    @{ Runner = 'wasm'; Fixture = 'gun-x16'; Cells = 1019844; Frames = 640; Run = 128; Load = 118.0; Memory = 24379392; FirstFrame = 64.1; FrameP50 = 0.0273; FrameMin = 0.0172; FrameMax = 0.0398; CellsPerSecond = 37297152000; FramesPerSecond = 36571.429; ClockMs = 0.295; ClockSpread = 1.7; ClockDrift = 0.0 },
    @{ Runner = 'wasm'; Fixture = 'sand'; Cells = 189215; Frames = 30; Run = 1; Load = 280.2; Memory = 11599872; FirstFrame = 18.4; FrameP50 = 4.3; FrameMin = 4.2; FrameMax = 10.7; CellsPerSecond = 44003488; FramesPerSecond = 232.558; ClockMs = 0.290; ClockSpread = 3.4; ClockDrift = -1.7 },
    @{ Runner = 'wasm'; Fixture = 'superposition'; Cells = 798731; Frames = 5000; Run = 1000; Load = 12.3; Memory = 69271552; FirstFrame = 128.6; FrameP50 = 0.0014; FrameMin = 0.0013; FrameMax = 0.0016; CellsPerSecond = 570522152573; FramesPerSecond = 714285.726; ClockMs = 0.293; ClockSpread = 1.7; ClockDrift = -0.8 },
    @{ Runner = 'wasm'; Fixture = 'superposition-act'; Cells = 798731; Frames = 200; Run = 1; Steps = 780; Load = 11.1; Memory = 82837504; FirstFrame = 1.5; FrameP50 = 0.5000; FrameP95 = 0.6000; FrameMin = 0.3000; FrameMax = 2.8; CellsPerSecond = 1331218280; FramesPerSecond = 1666.667; ClockMs = 0.293; ClockSpread = 1.7; ClockDrift = -0.8 },
    @{ Runner = 'wasm'; Fixture = 'superposition-cascade'; Cells = 798731; Frames = 777; Run = 1; Load = 12.2; Memory = 69271552; FirstFrame = 0.4000; FrameP50 = 0.2000; FrameMin = 0.0000; FrameMax = 0.8000; CascadeMs = 183.2; Seed = 1; Probability = 0.08; Deal = 'SO501'; Rings = 775; Opened = 209446; CellsPerSecond = 3387630935; FramesPerSecond = 4241.266; ClockMs = 0.293; ClockSpread = 1.7; ClockDrift = -0.8 },
    @{ Runner = 'wasm'; Fixture = 'naught-f'; Cells = 52865; Frames = 30; Run = 1; Load = 29.6; Memory = 7929856; FirstFrame = 9.5; FrameP50 = 6.2; FrameMin = 5.8; FrameMax = 6.7; IdleP50 = 0.0008; ConeP50 = 0.8000; Shapes = 32; Levels = 8194; CellsPerSecond = 8526613; FramesPerSecond = 161.290; ClockMs = 0.290; ClockSpread = 0.0; ClockDrift = -1.7 },
    @{ Runner = 'wasm'; Fixture = 'naught-s'; Cells = 52865; Frames = 30; Run = 1; Load = 387.9; Memory = 106430464; FirstFrame = 20.4; FrameP50 = 22.8; FrameMin = 19.9; FrameMax = 28.2; IdleP50 = 0.0010; ConeP50 = 4.1; Shapes = 44548; Levels = 8194; CellsPerSecond = 2318640; FramesPerSecond = 43.860; ClockMs = 0.295; ClockSpread = 1.7; ClockDrift = 0.0 }
)

# --- the floors, in cells a second, a dated history that never goes down ---
# One entry a measurement, one a line inside the parentheses, a comma after
# the entry before it: @{ Date = 'yyyy-mm-dd'; Pin = '<vla-lang pin>';
# Reason = ''; Floors = @{ 'native life' = n; 'native gun' = n; 'native sand'
# = n; 'wasm life' = n; 'wasm gun' = n; 'wasm sand' = n } }, and since
# ENGINE.9 the size ladder's eight, 'native life-x4' to 'wasm gun-x16'. An
# entry lower than the one before it in any row needs its Reason. A row enters
# at the first entry holding it and stays in every entry after: the three
# entries below are Life's alone, Sand's rows enter with the owner's run that
# measures them (CART.2, decision 11), and so do the ladder's (ENGINE.9).
$floorHistory = @(
    @{ Date = '2026-10-09'; Pin = 'c0686a9'; Reason = ''; Floors = @{ 'native life' = 196000; 'native gun' = 186000; 'wasm life' = 205000; 'wasm gun' = 197000 } },
    @{ Date = '2026-10-10'; Pin = 'f5dc344'; Reason = ''; Floors = @{ 'native life' = 560000; 'native gun' = 586000; 'wasm life' = 414000; 'wasm gun' = 419000 } },
    @{ Date = '2026-10-11'; Pin = '0.9.0'; Reason = ''; Floors = @{ 'native life' = 20200000; 'native gun' = 3710000000; 'wasm life' = 13300000; 'wasm gun' = 924000000 } },
    @{ Date = '2026-10-11'; Pin = '0.9.0'; Reason = 'the native gun only, at the owner''s word (CART.2): on the code measured at 02:00 it read 17.6 to 26.9 microseconds a frame in nine runs that evening, two runners alternated, against 15.2; the clock beside every frame and the gun in the browser unchanged; a frame of 20 microseconds varies between sessions by more than the margin of 10%'; Floors = @{ 'native life' = 20200000; 'native gun' = 2770000000; 'native sand' = 9490000; 'wasm life' = 13600000; 'wasm gun' = 929000000; 'wasm sand' = 6810000 } },
    @{ Date = '2026-10-12'; Pin = '0.9.1'; Reason = 'native gun re-based: timed in runs of 128 from this entry, where the baseline before it timed its frames alone, and a frame under 2 ms timed alone, right after the clock, varied between sessions past the margin (CART.1''s frame timer); its floor is this run''s less 10%'; Floors = @{ 'native life' = 20300000; 'native gun' = 1340000000; 'native sand' = 13700000; 'wasm life' = 14100000; 'wasm gun' = 929000000; 'wasm sand' = 9550000 } },
    @{ Date = '2026-10-12'; Pin = '0.9.1'; Reason = 'native sand re-based: its fixture is another file, 177E8863..., where the baseline before it measured 3DFFD0BE..., and cells a second count a fixture''s cells (CART.2''s decision 24); its floor is this run''s less 10%; wasm sand re-based: its fixture is another file, 177E8863..., where the baseline before it measured 3DFFD0BE..., and cells a second count a fixture''s cells (CART.2''s decision 24); its floor is this run''s less 10%'; Floors = @{ 'native life' = 20500000; 'native gun' = 1340000000; 'native sand' = 10800000; 'wasm life' = 14100000; 'wasm gun' = 929000000; 'wasm sand' = 7550000 } },
    @{ Date = '2026-10-12'; Pin = '0.9.1'; Reason = ''; Floors = @{ 'native life' = 20500000; 'native gun' = 1340000000; 'native sand' = 30500000; 'wasm life' = 14100000; 'wasm gun' = 935000000; 'wasm sand' = 20500000 } },
    @{ Date = '2026-10-12'; Pin = '0.9.2'; Reason = ''; Floors = @{ 'native life' = 20500000; 'native gun' = 1340000000; 'native sand' = 45500000; 'wasm life' = 14300000; 'wasm gun' = 942000000; 'wasm sand' = 27900000 } },
    @{ Date = '2026-10-14'; Pin = '0.9.2'; Reason = ''; Floors = @{ 'native life' = 20500000; 'native life-x4' = 16200000; 'native life-x16' = 15900000; 'native gun' = 2190000000; 'native gun-x4' = 8100000000; 'native gun-x16' = 27700000000; 'native sand' = 45500000; 'wasm life' = 14300000; 'wasm life-x4' = 12700000; 'wasm life-x16' = 13000000; 'wasm gun' = 1510000000; 'wasm gun-x4' = 5220000000; 'wasm gun-x16' = 21300000000; 'wasm sand' = 29300000 } },
    @{ Date = '2026-10-14'; Pin = '0.9.3'; Reason = ''; Floors = @{ 'native life' = 20500000; 'native life-x4' = 16200000; 'native life-x16' = 15900000; 'native gun' = 2190000000; 'native gun-x4' = 8460000000; 'native gun-x16' = 30000000000; 'native sand' = 45500000; 'wasm life' = 14300000; 'wasm life-x4' = 12700000; 'wasm life-x16' = 13100000; 'wasm gun' = 1510000000; 'wasm gun-x4' = 5850000000; 'wasm gun-x16' = 21300000000; 'wasm sand' = 29300000 } },
    @{ Date = '2026-10-15'; Pin = '0.9.4'; Reason = ''; Floors = @{ 'native life' = 20500000; 'native life-x4' = 16200000; 'native life-x16' = 16100000; 'native gun' = 2190000000; 'native gun-x4' = 8460000000; 'native gun-x16' = 30000000000; 'native sand' = 45500000; 'wasm life' = 14300000; 'wasm life-x4' = 13100000; 'wasm life-x16' = 13100000; 'wasm gun' = 1510000000; 'wasm gun-x4' = 5850000000; 'wasm gun-x16' = 21300000000; 'wasm sand' = 29300000 } },
    @{ Date = '2026-10-17'; Pin = '0.10.0'; Reason = ''; Floors = @{ 'native life' = 27500000; 'native life-x4' = 22000000; 'native life-x16' = 22200000; 'native gun' = 2980000000; 'native gun-x4' = 11500000000; 'native gun-x16' = 40500000000; 'native sand' = 57200000; 'wasm life' = 23100000; 'wasm life-x4' = 21500000; 'wasm life-x16' = 20400000; 'wasm gun' = 2330000000; 'wasm gun-x4' = 9140000000; 'wasm gun-x16' = 31700000000; 'wasm sand' = 43600000 } },
    @{ Date = '2026-10-18'; Pin = '0.10.1'; Reason = 'native gun-x16 lowered: measured under its floor, 40,224,334,268 cells a second against 40,500,000,000, 0.7% under; its frame, the gun''s idle frame over a board of a million formula cells, read 0.0227 to 0.0285 ms natively and 0.0289 to 0.0398 in the browser over this instrument''s six runs of the day, every run refusing one gun row or two, and the twelfth baseline''s own module and runner, rebuilt byte for byte from 275f1e0, run alternately with this pin''s under the same guards, read 0.0227 to 0.0231 natively and 0.0281 to 0.0391 in the browser, where this pin''s read 0.0226 to 0.0231 and 0.0289 to 0.0336: the two engines alike, and a frame of twenty to forty microseconds varying between runs past the floors'' margin (CART.12; docs/REARVIEW.md, ENGINE.1''s record of the pin to 0.10.1); its floor is this run''s less 10%'; Floors = @{ 'native life' = 27800000; 'native life-x4' = 22700000; 'native life-x16' = 22200000; 'native gun' = 3060000000; 'native gun-x4' = 11500000000; 'native gun-x16' = 36200000000; 'native sand' = 58600000; 'native superposition' = 168000000000; 'native superposition-act' = 1580000000; 'native superposition-cascade' = 3950000000; 'wasm life' = 23600000; 'wasm life-x4' = 21500000; 'wasm life-x16' = 20400000; 'wasm gun' = 2330000000; 'wasm gun-x4' = 9430000000; 'wasm gun-x16' = 31700000000; 'wasm sand' = 43600000; 'wasm superposition' = 135000000000; 'wasm superposition-act' = 1020000000; 'wasm superposition-cascade' = 3200000000 } },
    @{ Date = '2026-10-19'; Pin = '0.10.1'; Reason = ''; Floors = @{ 'native life' = 27800000; 'native life-x4' = 22700000; 'native life-x16' = 22200000; 'native gun' = 3100000000; 'native gun-x4' = 11500000000; 'native gun-x16' = 36200000000; 'native sand' = 59900000; 'native superposition' = 168000000000; 'native superposition-act' = 1590000000; 'native superposition-cascade' = 3960000000; 'wasm life' = 23600000; 'wasm life-x4' = 21500000; 'wasm life-x16' = 20400000; 'wasm gun' = 2330000000; 'wasm gun-x4' = 9430000000; 'wasm gun-x16' = 32600000000; 'wasm sand' = 44800000; 'wasm superposition' = 135000000000; 'wasm superposition-act' = 1020000000; 'wasm superposition-cascade' = 3200000000 } },
    @{ Date = '2026-10-19'; Pin = '0.10.1'; Reason = 'native superposition re-based: its fixture is another file, D157A425..., where the baseline before it measured 3F430491..., and cells a second count a fixture''s cells (CART.2''s decision 24); its floor is this run''s less 10%; native superposition-cascade re-based: its fixture is another file, D157A425..., where the baseline before it measured 3F430491..., and cells a second count a fixture''s cells (CART.2''s decision 24); its floor is this run''s less 10%; wasm superposition-cascade re-based: its fixture is another file, D157A425..., where the baseline before it measured 3F430491..., and cells a second count a fixture''s cells (CART.2''s decision 24); its floor is this run''s less 10%'; Floors = @{ 'native life' = 27800000; 'native life-x4' = 22900000; 'native life-x16' = 22200000; 'native gun' = 3100000000; 'native gun-x4' = 11500000000; 'native gun-x16' = 40400000000; 'native sand' = 59900000; 'native superposition' = 158000000000; 'native superposition-act' = 1730000000; 'native superposition-cascade' = 3630000000; 'wasm life' = 23600000; 'wasm life-x4' = 21500000; 'wasm life-x16' = 20400000; 'wasm gun' = 2330000000; 'wasm gun-x4' = 9430000000; 'wasm gun-x16' = 32600000000; 'wasm sand' = 44800000; 'wasm superposition' = 135000000000; 'wasm superposition-act' = 1020000000; 'wasm superposition-cascade' = 3070000000 } },
    @{ Date = '2026-10-20'; Pin = '0.10.1'; Reason = 'native superposition-act lowered: measured under its floor, 1,633,396,728 cells a second at the p95 against 1,730,000,000, 5.6% under; the act''s p95, about half a millisecond, read 1,612,000,000 to 1,940,000,000 cells a second over the five runs a session measured that day on this machine, a sixth refusing itself when its clock moved, and those runs refused in turn native gun, native superposition-act, wasm gun-x16 and wasm superposition-cascade, one row to three a run, every one a frame or an act under a millisecond: the floors'' margin of 10% inside the machine''s spread between runs for such rows that day, as the 2026-10-18 entry found for the gun''s (CART.9''s hand test of its second slice; docs/REARVIEW.md, CART.9''s record); its floor is this run''s less 10%'; Floors = @{ 'native life' = 27800000; 'native life-x4' = 23200000; 'native life-x16' = 22200000; 'native gun' = 3100000000; 'native gun-x4' = 11800000000; 'native gun-x16' = 40400000000; 'native sand' = 59900000; 'native superposition' = 163000000000; 'native superposition-act' = 1470000000; 'native superposition-cascade' = 3690000000; 'native naught-f' = 10600000; 'native naught-s' = 2290000; 'wasm life' = 23600000; 'wasm life-x4' = 21500000; 'wasm life-x16' = 20400000; 'wasm gun' = 2330000000; 'wasm gun-x4' = 9430000000; 'wasm gun-x16' = 32600000000; 'wasm sand' = 44800000; 'wasm superposition' = 135000000000; 'wasm superposition-act' = 1020000000; 'wasm superposition-cascade' = 3070000000; 'wasm naught-f' = 7430000; 'wasm naught-s' = 1960000 } },
    @{ Date = '2026-10-23'; Pin = '0.11.0'; Reason = 'the pin moved to vla-lang 0.11.0 (Frazaro''s release of KERNEL.8''s library, KERNEL.49''s grid as written, KERNEL.50, KERNEL.53, KERNEL.54 and KERNEL.56, 2026-10-23), measured by this session''s three runs of the day, the third''s block; four rows lowered, each measured under its floor in one of the three and each floor the lowest run less 10%: native naught-f 10,544,004 cells a second against 10,600,000 in the first, 0.5% under, and 10,544,004 to 10,681,201 over the three against the 0.10.1 baseline''s 11,838,275, 10% slower, the bench laid by fill being a grid whose fills read one another''s cells, which the release''s notes say 0.11.0 plans cell by cell (Sand''s frames 8% slower there; native sand read 62,163,050 to 62,395,713 against 66,493,885, above its floor); wasm sand 44,003,488 against 44,800,000 in the third, the same cause in the browser; and wasm gun 2,066,510,782 against 2,330,000,000 and wasm gun-x4 8,784,398,008 against 9,430,000,000 in the third, the gun''s idle frame of twenty to thirty microseconds, read 2,066,510,782 to 2,442,239,947 and 8,784,398,008 to 9,559,491,832 over the three, the spread between runs past the floors'' margin that the 2026-10-18 entry found for such rows; and wasm superposition-act kept at 1,020,000,000 where the run raised it to 1,190,000,000, the page reading its p95 in tenths of a millisecond, 0.6 or 0.7 from run to run, as the fifteenth''s note says (docs/REARVIEW.md, ENGINE.1''s record of the pin to 0.11.0)'; Floors = @{ 'native life' = 27800000; 'native life-x4' = 26400000; 'native life-x16' = 26200000; 'native gun' = 3100000000; 'native gun-x4' = 11800000000; 'native gun-x16' = 43800000000; 'native sand' = 59900000; 'native superposition' = 715000000000; 'native superposition-act' = 1930000000; 'native superposition-cascade' = 4290000000; 'native naught-f' = 9480000; 'native naught-s' = 2650000; 'wasm life' = 23600000; 'wasm life-x4' = 22100000; 'wasm life-x16' = 21300000; 'wasm gun' = 1850000000; 'wasm gun-x4' = 7900000000; 'wasm gun-x16' = 33500000000; 'wasm sand' = 39600000; 'wasm superposition' = 513000000000; 'wasm superposition-act' = 1020000000; 'wasm superposition-cascade' = 3070000000; 'wasm naught-f' = 7670000; 'wasm naught-s' = 2080000 } }
)

# --- releases of a measured source: a registry release of the language whose
#     crate is a measured git commit's source byte for byte measures the same,
#     so the baseline's pin may name the commit while Cargo.toml names the
#     release. Each entry is a reviewed fact, checked file by file by whoever
#     adds it, with its record in docs/REARVIEW.md (ENGINE.1's second slice, the
#     note on the registry pin). ---
# 2026-10-10: vla-lang 0.8.1 on crates.io is f5dc344's vla-lang/ byte for
# byte: of the crate's 34 files, 27 equal the commit's blobs, its two data
# files are the same text with the CRLF ends the git checkout built from as
# well, and its manifest is cargo's normalized one, whose original is the
# commit's; published from the release commit 3235bf9, whose vla-lang/ is
# f5dc344's. The engine's frames and allocations are the same over both.
$sameSource = @{ '0.8.1' = 'f5dc344' }

# --- fixtures whose bytes moved and whose rows did not ---
# A fixture's SHA-256 over LF bytes named as the measured fixture's own rows,
# rebuilt: a digest the baseline names stands for its file, and a digest here
# for that file's rows written again, so the measured grid is the one loaded.
# 2026-10-10, SPEC.3 (decision 30): life.vla and gun.vla rebuilt by the pass
# from life.source.vla and gun.source.vla. Each rebuilt file's forms printed
# flat are byte for byte the measured file's; loaded, every sheet's record is
# equal; stepped, every plane is equal at frames 1 to 3 (Life 23,683, 23,179
# and 19,753 live cells, the gun 36, 39 and 43). Only the comments and the
# manifest's layout moved, and the pass carries no comment, so these bytes
# move again only with a row.
# 2026-10-14, at the owner's word: life.vla, gun.vla and sand.vla respelled in
# American English, the manifest's license directive, Life's notes, and the
# Palette's two gray names, text cells of the same length that no formula
# reads (C9 and C10 in Life and the gun, C11 in Sand). Every other row is byte
# for byte the measured file's; each file's census, its describe golden, is
# unchanged; and the runner's check mode holds every frame to the Life and
# the Sand written by hand and every allocation count under its ceiling.
# 2026-10-19, CART.12's hand test: superposition.vla gained three column rows,
# the Observer's A and B and the Constants' A, so that the labels and the seed
# read whole where the screen had cut the seed to #######. A width is a sheet's
# setting, no cell: no formula reads it, and no timed span views a sheet. Every
# other row is byte for byte the measured file's; its census, the describe
# golden, is unchanged; and the runner's check mode holds every frame to the
# Superposition written by hand, every allocation count and the heap under
# their ceilings.
# 2026-10-29, ENGINE.28's close: superposition.vla's manifest gained its
# keyboard's sheets, (game "Field" "Observer"), (read "Field" "Observer") and
# (work "Constants"), the host's rule for a person's keys and rows, which no
# step reads. Every row is byte for byte the measured file's; its census is
# unchanged, the describe golden gaining the three directives alone; and the
# runner's check mode holds every frame to the Superposition written by hand.
# 2026-10-29, after ENGINE.28's close: superposition.vla's twelve format rows,
# the looks' every site draws through, each gained a site's right and bottom
# edges in the gridlines' gray, so that the Field keeps its grid under its
# looks' fills; formats no formula reads, no row more. Every other row is byte
# for byte the measured file's; its census is unchanged; and the runner's check
# mode holds every frame to the Superposition written by hand.
$sameRows = @{
    '7220F8E1FBFF7A3B7F00DE9ECA5754E9A1877A8D1A766A251EB3811D0C937D89' = '90B24FF2E98530FF530C9E573DAC0E2FB4F5968ABE378D0A673C3E9DCA8D70DB'
    '5E54AAE0676BBF2B20A3213C73D836F7ED93C68D7D38A5C24D27C45B0ACF8BD7' = '0BD138CBE43825F93EA2235F755DE6A46F18CCF7B7DAEC33B6D38D8365E64234'
    '60220BAE07BBC3C15F671C7CAAE62B6DD6D14B67B9141150EC0023AFA0FFE0F4' = '7220F8E1FBFF7A3B7F00DE9ECA5754E9A1877A8D1A766A251EB3811D0C937D89'
    '64C9A6BA206003F15B73084FE90781BE60E34089D577CE0589DBAF5C737A0725' = '5E54AAE0676BBF2B20A3213C73D836F7ED93C68D7D38A5C24D27C45B0ACF8BD7'
    'F872498DEAFBCCB60133501B18E35BEC38A470C4A9AE8064505510D061EAD857' = '814983F85A9DA90155F0F58C6FE201C8750E588BF202BD54B18763C41DC594C7'
    '5DB1DC272DA0F55CBECA7B813DC7E255EE39114864D7C01354533B14553D49D2' = '3F430491CFE11A5CA0F5BD7CC16E1B4685576FCFE52C8AC87C19CAAE3B31ED4C'
    '49FA359E94245A4EA9667861735DEFA03FB0EEFBD23B5BE688CD99181F0363E6' = 'D157A4254B513FFB5B1814FB9F031CB15468BB0165C70A94F6183D0B3B625AE8'
    'E9C11E6A2E90F3E00524D68D65666F54CF415CB743F86C21A6D49DC06BBA9816' = 'D157A4254B513FFB5B1814FB9F031CB15468BB0165C70A94F6183D0B3B625AE8'
}

# --- the allocation ceilings, the second frame after a fresh load, exact ---
# 2026-10-09, CART.1's first slice, the runner's check mode over vla-lang at
# c0686a9: Life's soup 4,470,549 allocations and 1,129,229 reallocations, 71.0
# and 17.9 a formula cell; the gun 4,848,335 and 1,129,229, 77.0 a cell, its
# Seed sheet making each reference fold one sheet's name more (docs/REARVIEW.md,
# the scoping's profile). The same integers on every run and every machine:
# no step calls the platform. Lowered when the language allocates less;
# raised only by a reviewed act with its reason in the commit message.
# 2026-10-10, CART.1's second slice, over vla-lang at f5dc344 (KERNEL.25, the
# evaluator's hot path): the soup 251,957 and 5, the gun 251,958 and 5, 4.0
# allocations a formula cell, what is left being the arguments of the four
# strict calls (Frazaro's reading of its own item); the gun's extra sheet no
# longer costs an allocation a reference.
# 2026-10-11, the pin moved to vla-lang 0.9.0 (KERNEL.20's first four slices,
# KERNEL.26 and KERNEL.27): the soup 80 and 5, the gun 80 and 5, where a
# function's arguments no longer cost an allocation and a frame keeps its
# values by position; 0.0013 allocations a formula cell.
# 2026-10-11, CART.2's first slice, over vla-lang 0.9.0: Sand's opening, its
# second frame the rule's first over the soup, 509 allocations and 5
# reallocations, the same on every run; 0.0040 a formula cell over 126,449.
# 2026-10-12, the pin moved to vla-lang 0.9.1 (KERNEL.28): every count the
# same. CART.2's third slice the same day: Sand with water, a third sheet in
# the rule (Side, its fill and its twin) and its opening half water, 516
# allocations and 5 reallocations, the same on every run; 0.0027 a formula
# cell over 189,017. Raised with the fixture it measures, as its rows are
# re-based (CART.2's decision 24), and not for a language that allocates more.
# 2026-10-12, CART.2's playtest pass: the brush read from the Gate's rows, a
# third Gate column (189,215 formula cells) and the rate of 60, every count
# the same, 516 and 5. Then the opening raining from the board's top third,
# rows 2 to 67: 509 allocations and 5 reallocations, the same on every run,
# the ceiling lowered with the fixture it measures.
# 2026-10-14, ENGINE.9, over vla-lang 0.9.2: the size ladder's four rungs, 82
# allocations and 5 reallocations each, two more than the window's at either
# size, so no count grows with the board; and every fixture's Memory, the
# heap's high-water mark in bytes over a fresh load and its first four frames,
# each viewed and held as the host views one, counted by the runner's
# allocator after a load counted nowhere has made the language's tables. The
# same bytes on every run: 466 a formula cell for Life's soup at the window,
# 462 at four times the area and 460 at sixteen, the gun's within a tenth of
# a megabyte of Life's, Sand's 425 over three sheets. Measured on Windows; the type
# sizes the engine allocates are the same on a 64-bit Linux, so the crate
# job's runner reads the same, and a platform that reads fewer bytes passes
# with its note to lower the ceiling. Raised only with a reason, as a count is.
# 2026-10-14, the pin moved to vla-lang 0.9.3 (REPO.4, for the first release):
# every count the same, and every Memory raised, the same bytes on two runs.
# Life's soup holds 127,384 bytes more at its high-water mark, about two a
# formula cell, its rungs 509,640 and 2,041,480 more, the gun's the same, and
# Sand's 368 more. The reason is the language's: since 0.9.3 a frame's end
# copies every cell it changed into the twins, whatever share of the grid
# changed, keeping room among its changes for every formula cell (Frazaro's
# KERNEL.36, by 0.9.3's notes four bytes a formula cell), where 0.9.2 walked
# the twin once more than half the cells changed.
# 2026-10-15, the pin moved to vla-lang 0.9.4 (KERNEL.42, a window's
# changes): every count the same, and the six Memory ceilings of Life and the
# gun raised by exactly 1,536 bytes at every rung, the same bytes on every
# run. The reason is the language's: since 0.9.4 a frame's end keeps room for
# 64 changes that a record spells as it spelled them before (ALIKE, in
# vla-lang's src/machine/mod.rs), 24 bytes each, a constant a grid whatever
# its size. Sand's high-water mark stands where it stood, its peak elsewhere.
# 2026-10-17, the pin moved to vla-lang 0.10.0 (for the 0.2.0 release): every
# count of Life and the gun the same, Sand's second frame two allocations
# fewer, 507, the ceiling lowered; and every Memory raised, the same bytes on
# every run, at opt-level "s" and at 3 alike. Life's soup holds 566,028 bytes
# more at its high-water mark, about nine a formula cell, its rungs 2,285,666
# and 9,180,546 more, the gun's 573,102, 2,292,740 and 9,187,620, and Sand's
# 852,649, about four and a half. The reason is the language's: since 0.10.0 a
# previous frame's sheet that a formula reads keeps its values as an array of
# numbers beside its cells, which a fill's cells read as slices, by 0.10.0's
# notes nine bytes a cell (Frazaro's KERNEL.43); a sheet read in the frame
# being computed keeps one too (KERNEL.31); and each formula shape holds its
# program, compiled once (KERNEL.44).
# 2026-10-18, the pin moved to vla-lang 0.10.1 (KERNEL.48, a frame's changed
# cells counted, which CART.12's settle reads): every count the same, and every
# Memory raised by four bytes a sheet, the same bytes on every run: Life's soup
# 20 (five sheets), its rungs and the gun 24, the gun's rungs 28, Sand 48
# (twelve sheets). The reason is the language's: since 0.10.1 a frame keeps
# its count of the formula cells it changed on each sheet, a 32-bit count a
# sheet (Machine::changed_on). And CART.12's three counted instances of
# Superposition, the lattice of 512 by 512 (798,731 formula cells), each its
# load settled first: the idle row's second idle act, its two frames, 22
# allocations and 5 reallocations; the session's twelfth act, 560 and 37 over
# its frames; and the cascade at 8%, 777 frames, 4,146 and 63, about five a
# frame. The engine's work alone: a first build counted the runner's own list
# of an act's step times too, 1 allocation more an act and the cascade's 8
# reallocations. Their heap's high-water mark is the same 336,414,302 bytes, 421 a grid
# cell, reached at the load's first frame, which computes every cell, and
# never by an act. The same integers on every run.
# 2026-10-19, CART.12's hand test: Superposition's three Memory ceilings
# raised by 256 bytes, to 336,414,558, the same bytes on every run, and every
# count of allocations the same. The reason is the cartridge's: the hand test
# widened the Observer's A and B and the Constants' A, three column rows, and a
# sheet holds its columns' widths, a constant whatever the lattice's size.
# 2026-10-19, CART.12's second hand test: the board moved to A1, each of its
# Field and Readings four fills where it was one, a box's rule reading the
# Readings of its eight neighbors, and the bound read. The three Memory
# ceilings raised by 2,262,165 bytes, to 338,676,723, 0.7%, the same bytes on
# every run; a board built with the same fills and without the eight Readings
# references holds the same peak within 0.1 MB, so the bytes are the split's,
# the language's own per-cell cost of a fill's parts. The cascade's counted act
# 28 allocations more, 4,174, its frames reading more shapes; the idle and the
# session's counts the same, 22 and 560.
# 2026-10-20, CART.9's first slice: naught's two fixtures, the bench of a
# 4,096-bit adder and a 64 by 64 multiplier, 52,865 formula cells with the
# switches' stimulus, by the session's run of the runner's check mode: the
# second frame 22 allocations and 5 reallocations in both; the heap's
# high-water mark 23,358,901 bytes laid by fill, 441.9 a formula cell, and
# 135,862,660 shuffled, 2,570.0 a formula cell, 5.8 times: the regularity
# premium's memory, every gate its own shape.
# 2026-10-20, CART.9's hand test of its second slice: the manifest's notes,
# which the fixtures carry, 78 characters longer, naming a switch typed on its
# cell: the heaps 78 and 117 bytes more, 23,358,979 and 135,862,777, the
# counts the same, and the two digests 4DD37928... and A6F8498C....
# 2026-10-23, the pin moved to vla-lang 0.11.0: every heap lowered, and
# Life's, the gun's and Sand's counts. The reason is the language's: since
# 0.11.0 a grid keeps its formulas as written, each fill's formula once over
# its rectangles, 13.5 to 18.6 bytes a formula cell where it held about 400
# (Frazaro's KERNEL.49, by 0.11.0's notes), and a frame's plan allocates less:
# Life's soup 2,525,819 bytes at its high-water mark, 40.1 a formula cell where
# it held 30,045,529, its rungs 9,477,744 and 21,030,408, the gun's 2,451,537,
# 9,403,462 and 20,956,126; Sand's 10,182,809; Superposition's three
# 10,817,526, 10,819,392 and 10,824,346 where each held 338,676,723; naught's
# bench 3,382,521 laid by fill and 128,662,774 shuffled. The second frames' counts
# 23 allocations for Life and the gun at every rung, where they made 80 and 82,
# and Sand 427 where 507; Superposition's act 346 where 560, its cascade 3,947
# where 4,174; naught's 22 as before; the reallocations the same. The same
# integers and bytes on every run.
# 2026-10-29, ENGINE.28's close: Superposition's manifest names its keyboard's
# sheets, (game "Field" "Observer"), (read "Field" "Observer") and (work
# "Constants"), which the cartridge's manifest holds once loaded: its three
# heaps 1,020 bytes more each, 10,818,546, 10,820,412 and 10,825,366, the
# counts and the grid's own bytes the same.
$allocationCeilings = [ordered]@{
    'life'     = @{ Allocs = 23; Reallocs = 5; Memory = 2525819 }
    'life-x4'  = @{ Allocs = 23; Reallocs = 5; Memory = 9477744 }
    'life-x16' = @{ Allocs = 23; Reallocs = 5; Memory = 21030408 }
    'gun'      = @{ Allocs = 23; Reallocs = 5; Memory = 2451537 }
    'gun-x4'   = @{ Allocs = 23; Reallocs = 5; Memory = 9403462 }
    'gun-x16'  = @{ Allocs = 23; Reallocs = 5; Memory = 20956126 }
    'sand'     = @{ Allocs = 427; Reallocs = 5; Memory = 10182809 }
    'superposition'         = @{ Allocs = 22; Reallocs = 5; Memory = 10818546 }
    'superposition-act'     = @{ Allocs = 346; Reallocs = 37; Memory = 10820412 }
    'superposition-cascade' = @{ Allocs = 3947; Reallocs = 63; Memory = 10825366 }
    'naught-f'              = @{ Allocs = 22; Reallocs = 5; Memory = 3382521 }
    'naught-s'              = @{ Allocs = 22; Reallocs = 5; Memory = 128662774 }
}

# --- the rules ---
$requiredRows = @('native life', 'native gun', 'native sand', 'wasm life', 'wasm gun', 'wasm sand',
                  'native life-x4', 'native life-x16', 'native gun-x4', 'native gun-x16',
                  'wasm life-x4', 'wasm life-x16', 'wasm gun-x4', 'wasm gun-x16',
                  'native superposition', 'native superposition-act', 'native superposition-cascade',
                  'wasm superposition', 'wasm superposition-act', 'wasm superposition-cascade',
                  'native naught-f', 'native naught-s', 'wasm naught-f', 'wasm naught-s')
# Superposition's rows (CART.12): the act rows' and the cascade rows' own fields, which each half's row carries
# and the two halves hold alike.
$actFields = @('Frames', 'Steps')
$cascadeFields = @('Frames', 'Seed', 'Probability', 'Deal', 'Rings', 'Opened')
$p95Tolerance = 0.05
# Naught's rows (CART.9): each carries its idle frame, a switch's cone and its census, which the two
# halves hold alike.
$naughtFields = @('IdleP50', 'ConeP50', 'Shapes', 'Levels')
$censusFields = @('Shapes', 'Levels')
# The size ladder's rungs (ENGINE.9), each named in $baselineRungs by its cartridge's SHA-256 over LF.
$ladderRungs = @('life-x4', 'life-x16', 'gun-x4', 'gun-x16')
# The cartridges the pass builds for the floors, each named by its digest: the ladder's rungs and since
# CART.9 naught's two placements of one bench, built from its source by the runner and by the page.
$builtRungs = @($ladderRungs + @('naught-f', 'naught-s'))
$fixtureFiles = [ordered]@{ 'life' = 'cartridges/life/life.vla'; 'gun' = 'cartridges/gun/gun.vla'; 'sand' = 'cartridges/sand/sand.vla'; 'superposition' = 'cartridges/superposition/superposition.vla' }
$minFrames = 30
$clockMax = 10.0
$unitsTolerance = 0.005
$barCells = 2000000
$barFrames = 30
# What the instrument's environment line says of a run's guards: both halves
# opted out of the throttling, and both on the performance cores, or a
# machine with one kind of core, left unpinned.
$optedOutSays = 'power throttling opted out: the runner yes, [1-9]\d* browser process'
$coresSay = 'on the performance cores, \d+ of \d+ logical processors \(efficiency class \d+\): the runner yes, [1-9]\d* browser process|one kind of core, \d+ logical processors, unpinned'

function Get-LfDigest([string]$path) {
    $text = [System.IO.File]::ReadAllText($path) -replace "`r`n", "`n"
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { $hash = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($text)) } finally { $sha.Dispose() }
    return (($hash | ForEach-Object { $_.ToString('X2') }) -join '')
}

# The pin of vla-lang as Cargo.toml writes it: a git rev, or a registry version.
function Get-Pin([string]$dir) {
    $toml = [System.IO.File]::ReadAllText((Join-Path $dir 'Cargo.toml'))
    $m = [regex]::Match($toml, '(?m)^vla-lang\s*=\s*\{[^}\r\n]*rev\s*=\s*"([0-9a-f]+)"')
    if ($m.Success) { return $m.Groups[1].Value }
    $m = [regex]::Match($toml, '(?m)^vla-lang\s*=\s*"=?([0-9][0-9.]*)"')
    if ($m.Success) { return $m.Groups[1].Value }
    return ''
}

function Format-Count([double]$n) { return ([long][math]::Round($n)).ToString('N0', [System.Globalization.CultureInfo]::InvariantCulture) }

# The static judgment of a pasted baseline: the problems, and the lines to print.
function Test-Baseline($rows, [string]$date, [string]$environment, [string]$pin, [string]$currentPin, $fixtures, $currentDigests, $history, $same, $sameRowsOf = @{}, $rungs = @{}) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = New-Object System.Collections.Generic.List[string]
    if ($null -eq $rows -or @($rows).Count -eq 0) {
        $problems.Add('the baseline is empty: run tools/bench_frames.ps1 on the owner''s machine and paste the block it prints into this file, with its floor line')
        return @{ Problems = $problems; Lines = $lines }
    }
    if ($date -notmatch '^\d{4}-\d{2}-\d{2}$') { $problems.Add("the baseline has no date (yyyy-mm-dd): '$date'") }
    if ($environment -eq '') { $problems.Add('the baseline has no environment line') }
    else {
        if ($environment -notmatch $optedOutSays) { $problems.Add('the baseline''s environment does not say both halves ran opted out of Windows'' power throttling: a background run is about 40% slower three seconds in, so measure with tools/bench_frames.ps1') }
        if ($environment -notmatch $coresSay) { $problems.Add('the baseline''s environment does not say both halves ran on the performance cores: an efficiency core steps about 23% slower with a clock that looks steady, so measure with tools/bench_frames.ps1 as CART.1''s second slice left it') }
    }
    if ($pin -eq '') { $problems.Add('the baseline names no pin of vla-lang') }
    elseif ($pin -ne $currentPin) {
        if ($null -ne $same -and $same.ContainsKey($currentPin) -and [string]$same[$currentPin] -eq $pin) { $lines.Add(("  the pin: measured at vla-lang {0}; Cargo.toml pins {1}, the same source byte for byte by this file's table" -f $pin, $currentPin)) }
        else { $problems.Add("the baseline was measured at vla-lang $pin, and Cargo.toml pins $currentPin`: the language moved, so run tools/bench_frames.ps1 again and paste its block") }
    }
    foreach ($name in @($currentDigests.Keys)) {
        if (-not $fixtures.ContainsKey($name)) { $problems.Add("the baseline names no SHA-256 for the fixture $name") }
        elseif ($fixtures[$name] -ne $currentDigests[$name]) {
            if ($null -ne $sameRowsOf -and $sameRowsOf.ContainsKey($currentDigests[$name]) -and [string]$sameRowsOf[$currentDigests[$name]] -eq $fixtures[$name]) { $lines.Add(("  the fixture {0}: the measured file's rows, rebuilt, by this file's table ({1}...)" -f $name, $currentDigests[$name].Substring(0, 8))) }
            else { $problems.Add("the fixture $name is not the one measured: its SHA-256 over LF bytes is $($currentDigests[$name]), the baseline's $($fixtures[$name]); measure again") }
        }
    }
    # Each rung of the size ladder named by the cartridge the pass built for it (ENGINE.9), which the
    # runner's check mode holds where a runner is built.
    foreach ($rung in $builtRungs) {
        if ($null -eq $rungs -or -not $rungs.ContainsKey($rung) -or [string]$rungs[$rung] -notmatch '^[0-9A-F]{64}$') {
            $problems.Add("the baseline names no SHA-256 for the rung $rung`: paste the block tools/bench_frames.ps1 prints, whose `$baselineRungs line names each rung's cartridge, the size ladder's (ENGINE.9) and naught's (CART.9)")
        }
    }

    $byKey = @{}
    foreach ($r in @($rows)) {
        $key = ([string]$r.Runner) + ' ' + ([string]$r.Fixture)
        if ($byKey.ContainsKey($key)) { $problems.Add("the row $key is pasted twice") }
        $byKey[$key] = $r
    }
    foreach ($key in $byKey.Keys) { if ($requiredRows -notcontains $key) { $problems.Add("the row $key is none of the $($requiredRows.Count) the baseline holds") } }

    # The floors' history, entry by entry, row by row.
    $latest = $null
    if ($null -eq $history -or @($history).Count -eq 0) {
        $problems.Add('no floor yet: add the floor line tools/bench_frames.ps1 printed at the end of $floorHistory')
    } else {
        # A row enters the history at the first entry that holds it, and stays (CART.2).
        $prev = $null
        $entered = @{}
        foreach ($e in @($history)) {
            if ([string]$e.Date -notmatch '^\d{4}-\d{2}-\d{2}$') { $problems.Add("a floor entry has no date: '$($e.Date)'") }
            if ($null -eq $e.Floors) { $problems.Add("the floor entry of $($e.Date) holds no floors"); continue }
            foreach ($key in $requiredRows) {
                if (-not $e.Floors.ContainsKey($key)) {
                    if ($entered.ContainsKey($key)) { $problems.Add("the floor entry of $($e.Date) has no floor for $key, which entered the history at $($entered[$key]): a row in the history stays in every entry after it") }
                    continue
                }
                if (-not $entered.ContainsKey($key)) { $entered[$key] = [string]$e.Date }
                if ($null -ne $prev -and $prev.Floors.ContainsKey($key) -and [double]$e.Floors[$key] -lt [double]$prev.Floors[$key] -and ([string]$e.Reason).Trim() -eq '') {
                    $problems.Add(("the floor of {0} went down at {1}, from {2} to {3}, with no reason written: a floor never goes down unless its entry says why" -f $key, $e.Date, (Format-Count $prev.Floors[$key]), (Format-Count $e.Floors[$key])))
                }
            }
            $prev = $e
        }
        $latest = @($history)[-1]
        if ($null -ne $latest.Floors) {
            foreach ($key in $requiredRows) {
                if (-not $latest.Floors.ContainsKey($key)) { $problems.Add("the latest floor entry, of $($latest.Date), has no floor for $key`: paste the history tools/bench_frames.ps1 prints, whose entry holds every row") }
            }
        }
    }

    foreach ($key in $requiredRows) {
        if (-not $byKey.ContainsKey($key)) { $problems.Add("the row $key is missing from the baseline"); continue }
        $r = $byKey[$key]
        $cells = [double]$r.Cells; $cps = [double]$r.CellsPerSecond; $fps = [double]$r.FramesPerSecond
        if ($cells -le 0) { $problems.Add("the row $key names no formula cells"); continue }
        # A rate that is no finite number above 0 is no floor: a frame quicker than the page's clock once
        # read 0 ms timed alone (CART.1, 2026-10-10), and the instrument now times such frames in runs.
        if ([double]::IsNaN($cps) -or [double]::IsInfinity($cps) -or $cps -le 0 -or [double]::IsNaN($fps) -or [double]::IsInfinity($fps) -or $fps -le 0) {
            $problems.Add(("the row {0}: {1} cells a second and {2} frames a second, where each must be a finite number above 0: a frame read as 0 ms is no measurement, so measure again with tools/bench_frames.ps1, whose page times a frame quicker than its clock in runs" -f $key, $r.CellsPerSecond, $r.FramesPerSecond))
            continue
        }
        if ([int]$r.Frames -lt $minFrames) { $problems.Add("the row $key holds $($r.Frames) steady frames, under the instrument's $minFrames (a short run is not the baseline)") }
        if ([double]$r.ClockSpread -gt $clockMax -or [math]::Abs([double]$r.ClockDrift) -gt $clockMax) { $problems.Add(("the row {0}: the clock moved during its run, a spread of {1}% and a drift of {2}%, beyond {3}%: a throttled run is not the baseline" -f $key, $r.ClockSpread, $r.ClockDrift, $clockMax)) }
        if ($cps -le 0 -or [math]::Abs($cps - $fps * $cells) -gt $unitsTolerance * $cps) { $problems.Add(("the row {0}: {1} cells a second is not {2} frames a second times {3} formula cells" -f $key, (Format-Count $cps), $fps, (Format-Count $cells))) }
        # Since ENGINE.9 every row carries its memory: the heap's high-water bytes natively, the module's
        # memory in the browser, a whole number above 0.
        $memory = 0.0
        if (-not $r.ContainsKey('Memory') -or -not [double]::TryParse([string]$r.Memory, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$memory) -or $memory -le 0 -or $memory -ne [math]::Floor($memory)) {
            $problems.Add("the row $key names no memory: since ENGINE.9 each row carries its Memory, the heap's high-water bytes natively and the module's memory in the browser, a whole number above 0, so paste the block tools/bench_frames.ps1 prints")
        }
        # Superposition's act rows (CART.12): cells a second at the session's 95th percentile, so its frames a
        # second, acts, one over its p95; its cascade rows: frames a second its frames over the cascade's time.
        if ([string]$r.Fixture -eq 'superposition-act') {
            $p95 = 0.0
            if (-not $r.ContainsKey('FrameP95') -or -not [double]::TryParse([string]$r.FrameP95, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$p95) -or $p95 -le 0) {
                $problems.Add("the row $key names no FrameP95: an act's latency is held at the session's 95th percentile (CART.12, decision 8), so paste the block tools/bench_frames.ps1 prints")
            } elseif ([math]::Abs($fps * $p95 / 1000.0 - 1.0) -gt $p95Tolerance) {
                $problems.Add(("the row {0}: {1} acts a second is not one over its 95th percentile of {2} ms: its cells a second are taken at the p95" -f $key, $fps, $p95))
            }
            if (-not $r.ContainsKey('Steps') -or [int]$r.Steps -lt [int]$r.Frames) { $problems.Add("the row $key names no Steps, the frames its acts took, at least one an act") }
        }
        if ([string]$r.Fixture -eq 'superposition-cascade') {
            $missing = @($cascadeFields | Where-Object { -not $r.ContainsKey($_) -or ([string]$r[$_]).Trim() -eq '' })
            $cascadeMs = 0.0
            if (-not $r.ContainsKey('CascadeMs') -or -not [double]::TryParse([string]$r.CascadeMs, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$cascadeMs) -or $cascadeMs -le 0) { $missing += 'CascadeMs' }
            if ($missing.Count -gt 0) { $problems.Add(("the row {0} names no {1}: the deepest cascade carries its time, its seed, probability, deal, rings and sites opened (CART.12, decision 8)" -f $key, ($missing -join ', '))) }
            elseif ([math]::Abs($fps - [double]$r.Frames / ($cascadeMs / 1000.0)) -gt $unitsTolerance * $fps) { $problems.Add(("the row {0}: {1} frames a second is not its {2} frames over {3} ms" -f $key, $fps, $r.Frames, $cascadeMs)) }
        }
        # Naught's rows (CART.9): the idle frame, a switch's cone and the census, each a number above 0.
        if ([string]$r.Fixture -like 'naught-*') {
            $missing = @($naughtFields | Where-Object { $v = 0.0; -not $r.ContainsKey($_) -or -not [double]::TryParse([string]$r[$_], [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$v) -or $v -le 0 })
            if ($missing.Count -gt 0) { $problems.Add(("the row {0} names no {1}: a naught row carries its idle frame, a switch's cone and its census, the shapes and the levels (CART.9, decision 6)" -f $key, ($missing -join ', '))) }
        }
        $floorText = 'no floor'
        if ($null -ne $latest -and $null -ne $latest.Floors -and $latest.Floors.ContainsKey($key)) {
            $floor = [double]$latest.Floors[$key]
            $floorText = ("floor {0} ({1:N3} frames a second)" -f (Format-Count $floor), ($floor / $cells))
            if ($cps -lt $floor) { $problems.Add(("the row {0}: {1} cells a second, under its floor of {2}" -f $key, (Format-Count $cps), (Format-Count $floor))) }
            if ($floor -ge $barCells) { $floorText += ', the line a gate' }
        }
        # the distance to each bar, short of it or, once a floor has passed it (2026-10-11), over it
        $toLine = if ($cps -ge $barCells) { '{0:N1} times over' -f ($cps / $barCells) } else { '{0:N1} times short' -f ($barCells / $cps) }
        $toRate = if ($fps -ge $barFrames) { '{0:N1} times over' -f ($fps / $barFrames) } else { '{0:N1} times short' -f ($barFrames / $fps) }
        $lines.Add(("  {0}: {1} cells a second, {2:N3} frames a second, frame p50 {3} ms; {4}; {5:N1}% of the line of {6}, {7}; the rate of {8} frames a second, {9}; the clock's spread {10}%, drift {11}%" -f
            $key, (Format-Count $cps), $fps, $r.FrameP50, $floorText, (100.0 * $cps / $barCells), (Format-Count $barCells), $toLine, $barFrames, $toRate, $r.ClockSpread, $r.ClockDrift))
    }
    # Each half plays Superposition's session and finds its cascade's deal by its own hand (CART.12): the halves
    # measured the same work only when their act rows and their cascade rows agree.
    foreach ($pair in @(@('superposition-act', $actFields, 'session'), @('superposition-cascade', $cascadeFields, 'cascade'))) {
        $n = $byKey['native ' + $pair[0]]; $w = $byKey['wasm ' + $pair[0]]
        if ($null -eq $n -or $null -eq $w) { continue }
        $apart = @($pair[1] | Where-Object { ([string]$n[$_]) -ne ([string]$w[$_]) })
        if ($apart.Count -gt 0) { $problems.Add(("the two halves' {0} rows are not the same {1}: {2}" -f $pair[0], $pair[2], (@($apart | ForEach-Object { "$_ $($n[$_]) natively and $($w[$_]) in the browser" }) -join '; '))) }
        else { $lines.Add(("  {0}: the same {1} in both halves, {2}" -f $pair[0], $pair[2], (@($pair[1] | ForEach-Object { "$_ $($n[$_])" }) -join ', '))) }
    }
    # Each half lays naught's bench by the same generator (CART.9): the halves measured the same
    # cartridges only when their rows print the same census.
    foreach ($fixture in @('naught-f', 'naught-s')) {
        $n = $byKey['native ' + $fixture]; $w = $byKey['wasm ' + $fixture]
        if ($null -eq $n -or $null -eq $w) { continue }
        $apart = @($censusFields | Where-Object { ([string]$n[$_]) -ne ([string]$w[$_]) })
        if ($apart.Count -gt 0) { $problems.Add(("the two halves' {0} rows are not the same census: {1}" -f $fixture, (@($apart | ForEach-Object { "$_ $($n[$_]) natively and $($w[$_]) in the browser" }) -join '; '))) }
        else { $lines.Add(("  {0}: the same census in both halves, {1} shapes in {2} levels" -f $fixture, $n.Shapes, $n.Levels)) }
    }
    foreach ($line in @(Get-Slope $byKey)) { $lines.Add($line) }
    foreach ($line in @(Get-Premium $byKey)) { $lines.Add($line) }
    return @{ Problems = $problems; Lines = $lines }
}

# The regularity premium read off a baseline's rows (CART.9, decision 6): for each half, naught-s's
# load, memory, first frame, steady frame, idle frame and cone over naught-f's. Printed, never gated:
# the floors hold each row.
function Get-Premium($byKey) {
    $out = New-Object System.Collections.Generic.List[string]
    foreach ($half in @('native', 'wasm')) {
        $f = $byKey["$half naught-f"]; $s = $byKey["$half naught-s"]
        if ($null -eq $f -or $null -eq $s) { continue }
        $over = @(foreach ($k in @('Load', 'Memory', 'FirstFrame', 'FrameP50', 'IdleP50', 'ConeP50')) { $a = [double]$f[$k]; $b = [double]$s[$k]; if ($a -gt 0) { '{0:N1}' -f ($b / $a) } else { 'n/a' } })
        $out.Add(('  the regularity premium, {0}: naught-s over naught-f, the load {1} times, the memory {2}, the first frame {3}, the steady frame {4}, the idle frame {5}, a switch''s cone {6}; {7} shapes against {8}' -f
            $half, $over[0], $over[1], $over[2], $over[3], $over[4], $over[5], $s.Shapes, $f.Shapes))
    }
    return $out.ToArray()
}

# The size ladder's slope read off a baseline's rows (ENGINE.9, decision 8): for each half, life's
# steady frame and the gun's idle frame, load and memory at each rung over the window's, and the
# exponent against the formula cells, ln(v16 / v1) / ln(c16 / c1), linear from 0.9 to 1.1; the gun's
# idle frame at the top rung against the prediction that it costs what it costs on the window, within
# the floors' margin. Printed, never gated: the floors hold each row.
function Get-Slope($byKey) {
    $out = New-Object System.Collections.Generic.List[string]
    function Shape([double]$e) { if ($e -lt 0.9) { return 'less than linear' } elseif ($e -le 1.1) { return 'linear' } else { return 'more than linear' } }
    foreach ($half in @('native', 'wasm')) {
        foreach ($fixture in @('life', 'gun')) {
            $keys = @("$half $fixture", "$half $fixture-x4", "$half $fixture-x16")
            if (@($keys | Where-Object { -not $byKey.ContainsKey($_) }).Count -gt 0) { continue }
            $v = @($keys | ForEach-Object { $byKey[$_] })
            $cells = @($v | ForEach-Object { [double]$_.Cells })
            $frame = @($v | ForEach-Object { [double]$_.FrameP50 })
            $load = @($v | ForEach-Object { [double]$_.Load })
            $memory = @($v | ForEach-Object { if ($_.ContainsKey('Memory')) { [double]$_.Memory } else { 0.0 } })
            if (@($cells + $frame + $load | Where-Object { $_ -le 0 }).Count -gt 0) { continue }
            $span = [math]::Log($cells[2] / $cells[0])
            $fe = [math]::Log($frame[2] / $frame[0]) / $span
            $le = [math]::Log($load[2] / $load[0]) / $span
            $memoryText = 'no memory'
            if ($memory[0] -gt 0 -and $memory[2] -gt 0) {
                $me = [math]::Log($memory[2] / $memory[0]) / $span
                $memoryText = ('the memory {0:N1}, {1:N1} and {2:N1} MB, the exponent {3:N2}, {4}' -f ($memory[0] / 1e6), ($memory[1] / 1e6), ($memory[2] / 1e6), $me, (Shape $me))
            }
            $kind = if ($fixture -eq 'gun') { 'idle' } else { 'steady' }
            $out.Add(('  the size ladder, {0} {1}: the {2} frame {3}, {4} and {5} ms, {6:N2} and {7:N2} times the window''s at {8:N0} and {9:N0} times its cells, the exponent {10:N2}, {11}; the load {12}, {13} and {14} ms, the exponent {15:N2}, {16}; {17}' -f
                $half, $fixture, $kind, $v[0].FrameP50, $v[1].FrameP50, $v[2].FrameP50, ($frame[1] / $frame[0]), ($frame[2] / $frame[0]), ($cells[1] / $cells[0]), ($cells[2] / $cells[0]), $fe, (Shape $fe),
                $v[0].Load, $v[1].Load, $v[2].Load, $le, (Shape $le), $memoryText))
            if ($fixture -eq 'gun') {
                $ratio = $frame[2] / $frame[0]
                $verdict = if ($ratio -le 1.0 + $clockMax / 100.0) { 'the prediction, the window''s cost, held within the floors'' margin of {0}%' -f $clockMax } else { 'the prediction, the window''s cost, missed by {0:N0}%, past the floors'' margin of {1}%' -f (($ratio - 1.0) * 100.0), $clockMax }
                $out.Add(('  the size ladder, {0} gun: at {1:N0} times the window''s cells its idle frame costs {2:N2} times the window''s: {3}' -f $half, ($cells[2] / $cells[0]), $ratio, $verdict))
            }
        }
    }
    return $out.ToArray()
}

# The shell a fake runner's script runs under.
function Get-Shell { if (Get-Command powershell -ErrorAction SilentlyContinue) { return 'powershell' }; return 'pwsh' }

# A runner's check mode: its rows, or why not; a runner may be the program or
# a script standing in for it (-Control's fakes).
function Invoke-Runner([string]$runner, $paths) {
    $old = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        if ($runner -like '*.ps1') { $out = & (Get-Shell) -NoProfile -ExecutionPolicy Bypass -File $runner --check @paths 2>$null }
        else { $out = & $runner --check @paths 2>$null }
        $code = $LASTEXITCODE
    } finally { $ErrorActionPreference = $old }
    return @{ Text = (@($out) -join "`n"); Code = $code }
}

# The dynamic judgment: the runner's check mode over the fixtures, and since ENGINE.9 the rungs of
# the size ladder their sources climb, each rung's digest held to the baseline's where it names one.
function Test-Runner([string]$runner, $paths, $ceilings, $rungs = @{}, $cascade = $null, $census = @{}) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = New-Object System.Collections.Generic.List[string]
    $run = Invoke-Runner $runner $paths
    if ($run.Code -ne 0) {
        $problems.Add(("the runner's check failed (exit {0}): {1}" -f $run.Code, (($run.Text -split "`n") | Select-Object -First 3) -join ' | '))
        return @{ Problems = $problems; Lines = $lines }
    }
    $want = @($ceilings.Keys).Count
    if ($run.Text -notmatch ('\(frames-check-done ' + $want + '\)')) { $problems.Add("the runner's check did not finish the $want fixtures: " + $run.Text) }
    foreach ($name in @($ceilings.Keys)) {
        $m = [regex]::Match($run.Text, '\(frames-check "' + [regex]::Escape($name) + '" \(frames (\d+)\) \(equal (\d+)\) \(cells (\d+)\) \(allocs (\d+)\) \(reallocs (\d+)\) \(memory (\d+)\)(?: \(digest "([0-9A-F]{64})"\))?(?: \(facts (\d+)\))?(?: \(conserved (\d+)\))?(?: \(settled (\d+)\))?(?: \(deal "([A-Z]+\d+)"\) \(rings (\d+)\) \(opened (\d+)\))?(?: \(shapes (\d+)\) \(levels (\d+)\) \(alone (\d+)\))?\)')
        if (-not $m.Success) { $problems.Add("the runner's check printed no row for the fixture $name"); continue }
        $frames = [int]$m.Groups[1].Value; $equal = [int]$m.Groups[2].Value; $cells = [double]$m.Groups[3].Value
        $allocs = [long]$m.Groups[4].Value; $reallocs = [long]$m.Groups[5].Value; $memory = [long]$m.Groups[6].Value
        $by = if ($name -eq 'sand') { 'Sand' } elseif ($name -like 'superposition*') { 'Superposition' } elseif ($name -like 'naught-*') { 'netlist' } else { 'Life' }
        if ($frames -lt 2 -or $equal -ne $frames) { $problems.Add("$name`: $equal of $frames frames equal to the hand-written $by") }
        if ($name -like 'superposition*' -and -not $m.Groups[10].Success) { $problems.Add("$name`: the runner settled no act of the counted instance, which settles every act (CART.12)") }
        if ($name -eq 'superposition-cascade') {
            if (-not $m.Groups[11].Success) { $problems.Add("superposition-cascade: the runner named no deal, rings or sites opened for the cascade") }
            elseif ($null -ne $cascade -and ($m.Groups[11].Value -ne [string]$cascade.Deal -or $m.Groups[12].Value -ne [string]$cascade.Rings -or $m.Groups[13].Value -ne [string]$cascade.Opened)) {
                $problems.Add(("superposition-cascade: the cascade is not the baseline's: the deal at {0}, {1} rings and {2} sites opened, the baseline's at {3}, {4} and {5}; the cartridge, the hand or the language moved, so measure again" -f $m.Groups[11].Value, $m.Groups[12].Value, $m.Groups[13].Value, $cascade.Deal, $cascade.Rings, $cascade.Opened))
            }
        }
        if ($name -like 'naught-*') {
            if (-not $m.Groups[14].Success) { $problems.Add("$name`: the runner printed no census for the fixture, its shapes, levels and cells alone (CART.9)") }
            elseif ($null -ne $census -and $census.ContainsKey($name) -and ([string]$census[$name].Shapes -ne $m.Groups[14].Value -or [string]$census[$name].Levels -ne $m.Groups[15].Value)) {
                $problems.Add(("{0}: the census is not the baseline's: {1} shapes in {2} levels, the baseline's {3} in {4}; the language, the source or the generator moved, so measure again" -f $name, $m.Groups[14].Value, $m.Groups[15].Value, $census[$name].Shapes, $census[$name].Levels))
            }
        }
        if (($name -eq 'gun' -or $name -like 'gun-x*') -and -not $m.Groups[8].Success) { $problems.Add("$name`: the runner did not hold the gun to its published facts") }
        if ($name -eq 'sand' -and (-not $m.Groups[9].Success -or [int]$m.Groups[9].Value -ne $frames - 1)) { $problems.Add("sand: the runner did not hold the opening to its grains, each material's count kept in every frame after the first") }
        $c = $ceilings[$name]
        $note = ''
        if ($allocs -gt [long]$c.Allocs) { $problems.Add(("{0}: the second frame's allocations rose to {1}, above the ceiling of {2}: a change made the evaluator allocate more" -f $name, (Format-Count $allocs), (Format-Count $c.Allocs))) }
        elseif ($allocs -lt [long]$c.Allocs) { $note += (", under the ceiling of {0}: lower it in this file" -f (Format-Count $c.Allocs)) }
        if ($reallocs -gt [long]$c.Reallocs) { $problems.Add(("{0}: the second frame's reallocations rose to {1}, above the ceiling of {2}" -f $name, (Format-Count $reallocs), (Format-Count $c.Reallocs))) }
        elseif ($reallocs -lt [long]$c.Reallocs) { $note += (", reallocations under the ceiling of {0}: lower it in this file" -f (Format-Count $c.Reallocs)) }
        if ($memory -gt [long]$c.Memory) { $problems.Add(("{0}: the heap's high-water mark over a load and four frames rose to {1} bytes, above the ceiling of {2}: a change made the grid hold more (ENGINE.9)" -f $name, (Format-Count $memory), (Format-Count $c.Memory))) }
        elseif ($memory -lt [long]$c.Memory) { $note += (", the heap under its ceiling of {0} bytes: lower it in this file" -f (Format-Count $c.Memory)) }
        if ($builtRungs -contains $name) {
            if (-not $m.Groups[7].Success) { $problems.Add("$name`: the runner printed no digest for the rung, the cartridge the pass built for it") }
            elseif ($null -ne $rungs -and $rungs.ContainsKey($name) -and [string]$rungs[$name] -ne $m.Groups[7].Value) {
                $problems.Add(("{0}: the rung is not the cartridge measured: the pass built one whose SHA-256 over LF is {1}, the baseline's {2}; a source, the library or the ladder's definition moved, so measure again" -f $name, $m.Groups[7].Value, $rungs[$name]))
            }
        }
        $facts = if ($m.Groups[8].Success) { ', the gun''s facts held ' + $m.Groups[8].Value + ' periods' } elseif ($m.Groups[9].Success) { ', every grain kept in ' + $m.Groups[9].Value + ' frames' } else { '' }
        if ($m.Groups[10].Success) { $facts += ', ' + $m.Groups[10].Value + ' acts settled' }
        if ($m.Groups[11].Success) { $facts += (', the deal at {0}, {1} rings, {2} sites opened' -f $m.Groups[11].Value, $m.Groups[12].Value, (Format-Count $m.Groups[13].Value)) }
        if ($m.Groups[14].Success) { $facts += (', {0} shapes in {1} levels, {2} cells alone' -f (Format-Count $m.Groups[14].Value), (Format-Count $m.Groups[15].Value), (Format-Count $m.Groups[16].Value)) }
        $counted = if ($name -like 'superposition*') { 'the counted act' } else { 'the second frame' }
        $lines.Add(("  {0}: {1} of {2} frames equal to the hand-written {3}{4}; {11} {5} allocations ({6:N4} a cell) and {7} reallocations; the heap {8} bytes ({9:N1} a cell){10}" -f $name, $equal, $frames, $by, $facts, (Format-Count $allocs), ($allocs / [math]::Max(1, $cells)), (Format-Count $reallocs), (Format-Count $memory), ($memory / [math]::Max(1, $cells)), $note, $counted))
    }
    return @{ Problems = $problems; Lines = $lines }
}

# The history's entries as a file's text holds them, one a line, each trimmed
# of its comma: read, never run, so the commit's copy is read the same way.
function Get-HistoryLines($text) {
    $entries = New-Object System.Collections.Generic.List[string]
    $inside = $false
    foreach ($line in @($text)) {
        if (-not $inside) { if ($line -match '^\$floorHistory = @\(\s*$') { $inside = $true }; continue }
        if ($line -match '^\)\s*$') { break }
        $t = $line.Trim().TrimEnd(',').Trim()
        if ($t -ne '' -and -not $t.StartsWith('#')) { $entries.Add($t) }
    }
    return $entries.ToArray()
}

# Whether a history kept every entry it was committed with, in order, at its
# head: a history is appended to and never pasted over.
function Test-HistoryKept($committed, $working) {
    $problems = New-Object System.Collections.Generic.List[string]
    $c = @($committed); $w = @($working)
    for ($i = 0; $i -lt $c.Count; $i++) {
        if ($i -ge $w.Count -or $w[$i] -cne $c[$i]) {
            $problems.Add(("the floor history lost or changed its entry {0} of {1} as committed, {2}: a history is appended to and never pasted over, so put that entry back and add the new one after it" -f ($i + 1), $c.Count, $c[$i]))
            break
        }
    }
    return @{ Problems = $problems }
}

if ($Control) {
    $ok = $true
    $verdicts = New-Object System.Collections.Generic.List[string]
    $digests = @{ 'life' = ('A' * 64); 'gun' = ('B' * 64); 'sand' = ('D' * 64); 'superposition' = ('E' * 64) }
    # the size ladder's rungs, each by its cartridge's digest (ENGINE.9)
    $controlRungs = @{ 'life-x4' = ('1' * 64); 'life-x16' = ('2' * 64); 'gun-x4' = ('3' * 64); 'gun-x16' = ('4' * 64); 'naught-f' = ('5' * 64); 'naught-s' = ('6' * 64) }
    $controlCensus = @{ 'naught-f' = @{ Shapes = 32; Levels = 8194 }; 'naught-s' = @{ Shapes = 44548; Levels = 8194 } }
    $ladderKeys = @($requiredRows | Where-Object { $_ -like '*-x*' })
    $controlCascade = @{ Deal = 'SP502'; Rings = 775; Opened = 209446 }
    function Row([string]$runner, [string]$fixture, [double]$cps, [int]$cells = 62964, [double]$memory = 30000000) {
        $ms = $cells / $cps * 1000
        return @{ Runner = $runner; Fixture = $fixture; Cells = $cells; Frames = 30; Load = 160.0; Memory = $memory; FirstFrame = 200.0; FrameP50 = $(if ($ms -ge 1) { [math]::Round($ms, 1) } else { [math]::Round($ms, 4) }); FrameMin = 270.0; FrameMax = 290.0;
                  CellsPerSecond = $cps; FramesPerSecond = [math]::Round($cps / $cells, 3); ClockMs = 0.180; ClockSpread = 5.0; ClockDrift = -1.0 }
    }
    # the size ladder's rows for one half: life and the gun at four and sixteen times the window's area
    function Ladder([string]$runner) { return @((Row $runner 'life-x4' 220000 253924 117000000), (Row $runner 'life-x16' 215000 1019844 469000000), (Row $runner 'gun-x4' 210000 253924 117000000), (Row $runner 'gun-x16' 205000 1019844 469000000)) }
    # Superposition's three rows for one half (CART.12): the idle frame, the session's act at its p95, the cascade
    function Lattice([string]$runner) {
        $idle = Row $runner 'superposition' 150000000000 798731 336000000; $idle.Frames = 10000; $idle.Run = 1000
        $act = Row $runner 'superposition-act' 1700000000 798731 336000000; $act.Frames = 200; $act.Steps = 780; $act.FrameP95 = [math]::Round(1000 / $act.FramesPerSecond, 4)
        $cascade = Row $runner 'superposition-cascade' 4500000000 798731 336000000; $cascade.Frames = 777; $cascade.CascadeMs = [math]::Round(777 / $cascade.FramesPerSecond * 1000, 1)
        $cascade.FramesPerSecond = [math]::Round(777 / ($cascade.CascadeMs / 1000), 3); $cascade.CellsPerSecond = $cascade.FramesPerSecond * 798731
        foreach ($k in @('Seed', 'Probability', 'Deal', 'Rings', 'Opened')) { $cascade[$k] = @{ Seed = 1; Probability = 0.08; Deal = 'SP502'; Rings = 775; Opened = 209446 }[$k] }
        return @($idle, $act, $cascade)
    }
    # naught's two rows for one half (CART.9): by fill and shuffled, each with its idle frame, cone and census
    function Bench([string]$runner) {
        $f = Row $runner 'naught-f' 11000000 52865 23400000; $f.IdleP50 = 0.0145; $f.ConeP50 = 0.54; $f.Shapes = 32; $f.Levels = 8194
        $s = Row $runner 'naught-s' 2700000 52865 135900000; $s.IdleP50 = 0.0445; $s.ConeP50 = 2.4; $s.Shapes = 44548; $s.Levels = 8194
        return @($f, $s)
    }
    # native life, native gun, native sand, wasm life, wasm gun, wasm sand, then the ladder's eight, then Superposition's six
    function Clean { return @((Row 'native' 'life' 225000), (Row 'native' 'gun' 214000), (Row 'native' 'sand' 10600000 126449), (Row 'wasm' 'life' 233000), (Row 'wasm' 'gun' 223000), (Row 'wasm' 'sand' 7700000 126449)) + @(Ladder 'native') + @(Ladder 'wasm') + @(Lattice 'native') + @(Lattice 'wasm') + @(Bench 'native') + @(Bench 'wasm') }
    # an entry's floors: Life's four, Sand's two when given, and with Sand's the ladder's eight and Superposition's six
    $latticeFloors = @{ 'superposition' = 100000000000; 'superposition-act' = 1500000000; 'superposition-cascade' = 4000000000; 'naught-f' = 9000000; 'naught-s' = 2000000 }
    function Floors([double]$a, [double]$b, [double]$c, [double]$d, [double]$e = -1, [double]$f = -1) {
        $fl = @{ 'native life' = $a; 'native gun' = $b; 'wasm life' = $c; 'wasm gun' = $d }
        if ($e -ge 0) { $fl['native sand'] = $e; foreach ($k in $ladderKeys) { $fl[$k] = 200000 }; foreach ($k in $latticeFloors.Keys) { $fl['native ' + $k] = $latticeFloors[$k]; $fl['wasm ' + $k] = $latticeFloors[$k] } }
        if ($f -ge 0) { $fl['wasm sand'] = $f }
        return $fl
    }
    $history = @(@{ Date = '2026-10-09'; Pin = 'abc1234'; Reason = ''; Floors = (Floors 202000 192000 209000 200000 9500000 6900000) })
    $controlEnvironment = 'a control machine | power throttling opted out: the runner yes, 25 browser process(es) | on the performance cores, 8 of 20 logical processors (efficiency class 1): the runner yes, 25 browser process(es)'
    function Judge($rows, $hist, [string]$currentPin, $current, [string]$environment = $controlEnvironment, $same = @{}, $rowsOf = @{}, $rungs = $controlRungs) { return Test-Baseline $rows '2026-10-09' $environment 'abc1234' $currentPin $digests $current $hist $same $rowsOf $rungs }
    function Expect([string]$name, $result, [string]$want) {
        $hit = @($result.Problems | Where-Object { $_ -like "*$want*" }).Count
        if ($want -eq '') {
            if ($result.Problems.Count -eq 0) { $verdicts.Add("$name`: passes, as it should") }
            else { $script:ok = $false; $verdicts.Add("$name`: FAILED but should pass: " + ($result.Problems -join ' | ')) }
        } elseif ($hit -ge 1) { $verdicts.Add("$name`: fails, as it should") }
        elseif ($result.Problems.Count -eq 0) { $script:ok = $false; $verdicts.Add("$name`: PASSED but should fail with '$want'") }
        else { $script:ok = $false; $verdicts.Add("$name`: fails, but without '$want': " + ($result.Problems -join ' | ')) }
    }
    Expect 'the clean table' (Judge (Clean) $history 'abc1234' $digests) ''
    $lowered = @($history[0], @{ Date = '2026-10-10'; Pin = 'abc1234'; Reason = 'a correctness fix that costs a frame 3%'; Floors = (Floors 196000 192000 209000 200000 9500000 6900000) })
    Expect 'a floor lowered for a written reason' (Judge (Clean) $lowered 'abc1234' $digests) ''
    Expect 'an empty baseline' (Judge @() $history 'abc1234' $digests) 'empty'
    Expect 'a row missing' (Judge @((Clean)[0..4]) $history 'abc1234' $digests) 'wasm sand is missing'
    $smoke = Clean; $smoke[1].Frames = 3
    Expect 'a smoke run' (Judge $smoke $history 'abc1234' $digests) 'steady frames, under'
    $slow = Clean; $slow[3] = Row 'wasm' 'life' 199000
    Expect 'a row under its floor' (Judge $slow $history 'abc1234' $digests) 'under its floor'
    $down = @($history[0], @{ Date = '2026-10-10'; Pin = 'abc1234'; Reason = ''; Floors = (Floors 196000 192000 209000 200000 9500000 6900000) })
    Expect 'a floor lowered with no reason' (Judge (Clean) $down 'abc1234' $digests) 'went down'
    Expect 'no floor at all' (Judge (Clean) @() 'abc1234' $digests) 'no floor yet'
    # A row entering the history (CART.2): Life's entry, then one holding Sand's rows too.
    $lifeOnly = @{ Date = '2026-10-09'; Pin = 'abc1234'; Reason = ''; Floors = (Floors 202000 192000 209000 200000) }
    $entering = @($lifeOnly, @{ Date = '2026-10-12'; Pin = 'abc1234'; Reason = ''; Floors = (Floors 202000 192000 209000 200000 9500000 6900000) })
    Expect 'a row entering the history at a later entry' (Judge (Clean) $entering 'abc1234' $digests) ''
    $dropped = @($history[0], @{ Date = '2026-10-12'; Pin = 'abc1234'; Reason = ''; Floors = (Floors 202000 192000 209000 200000 9500000) })
    Expect 'a row dropped after it entered the history' (Judge (Clean) $dropped 'abc1234' $digests) 'stays in every entry after it'
    Expect 'a latest entry without a row''s floor' (Judge (Clean) @($lifeOnly) 'abc1234' $digests) 'has no floor for native sand'
    Expect 'the pin moved' (Judge (Clean) $history 'def5678' $digests) 'the language moved'
    Expect 'a release of the measured source' (Judge (Clean) $history '0.9.9' $digests $controlEnvironment @{ '0.9.9' = 'abc1234' }) ''
    Expect 'a release of another source' (Judge (Clean) $history '0.9.9' $digests $controlEnvironment @{ '0.9.9' = 'def5678' }) 'the language moved'
    $edited = @{ 'life' = ('A' * 64); 'gun' = ('C' * 64); 'sand' = ('D' * 64) }
    Expect 'a fixture edited' (Judge (Clean) $history 'abc1234' $edited) 'is not the one measured'
    Expect 'a fixture rebuilt with the measured rows' (Judge (Clean) $history 'abc1234' $edited $controlEnvironment @{} @{ ('C' * 64) = ('B' * 64) }) ''
    Expect 'a fixture rebuilt with other rows' (Judge (Clean) $history 'abc1234' $edited $controlEnvironment @{} @{ ('C' * 64) = ('A' * 64) }) 'is not the one measured'
    $moved = Clean; $moved[0].ClockSpread = 12.5
    Expect 'a clock that moved' (Judge $moved $history 'abc1234' $digests) 'the clock moved'
    $units = Clean; $units[3].FramesPerSecond = [math]::Round($units[3].FramesPerSecond * 1.02, 3)
    Expect 'frames a second against cells a second' (Judge $units $history 'abc1234' $digests) 'is not'
    $timeless = Clean; $timeless[3].FrameP50 = 0.0; $timeless[3].CellsPerSecond = [double]::PositiveInfinity; $timeless[3].FramesPerSecond = [double]::PositiveInfinity
    Expect 'a frame read as 0 ms, its rates infinite' (Judge $timeless $history 'abc1234' $digests) 'a finite number above 0'
    $coresPart = 'on the performance cores, 8 of 20 logical processors (efficiency class 1): the runner yes, 25 browser process(es)'
    $oneKind = $controlEnvironment.Replace($coresPart, 'one kind of core, 20 logical processors, unpinned')
    Expect 'a machine of one kind of core' (Judge (Clean) $history 'abc1234' $digests $oneKind) ''
    $notOptedOut = $controlEnvironment.Replace('opted out: the runner yes', 'opted out: the runner no')
    Expect 'a run not opted out of the throttling' (Judge (Clean) $history 'abc1234' $digests $notOptedOut) 'opted out of Windows'
    $anyCore = $controlEnvironment.Replace(' | ' + $coresPart, '')
    Expect 'a run not on the performance cores' (Judge (Clean) $history 'abc1234' $digests $anyCore) 'performance cores'
    # The size ladder (ENGINE.9): a row's memory, a rung's row, a rung's digest.
    $noMemory = Clean; $noMemory[9].Remove('Memory')
    Expect 'a row without its memory' (Judge $noMemory $history 'abc1234' $digests) 'names no memory'
    $clean = @(Clean)
    Expect 'a rung''s row missing' (Judge @($clean | Where-Object { -not ($_.Runner -eq 'wasm' -and $_.Fixture -eq 'gun-x16') }) $history 'abc1234' $digests) 'wasm gun-x16 is missing'
    $fewerRungs = @{ 'life-x4' = ('1' * 64); 'life-x16' = ('2' * 64); 'gun-x4' = ('3' * 64) }
    Expect 'a rung the baseline names no digest for' (Judge (Clean) $history 'abc1234' $digests $controlEnvironment @{} @{} $fewerRungs) 'no SHA-256 for the rung gun-x16'
    # Superposition (CART.12): an act row's p95, a cascade row's deal, and the halves alike.
    function Find($rows, [string]$runner, [string]$fixture) { return @($rows | Where-Object { $_.Runner -eq $runner -and $_.Fixture -eq $fixture })[0] }
    $noP95 = Clean; (Find $noP95 'native' 'superposition-act').Remove('FrameP95')
    Expect 'an act row without its p95' (Judge $noP95 $history 'abc1234' $digests) 'names no FrameP95'
    $offP95 = Clean; $r95 = Find $offP95 'wasm' 'superposition-act'; $r95.FrameP95 = [math]::Round($r95.FrameP95 * 1.2, 4)
    Expect 'an act row whose acts a second are not one over its p95' (Judge $offP95 $history 'abc1234' $digests) 'is not one over its 95th percentile'
    $noDeal = Clean; (Find $noDeal 'native' 'superposition-cascade').Remove('Deal')
    Expect 'a cascade row without its deal' (Judge $noDeal $history 'abc1234' $digests) 'names no Deal'
    $sessions = Clean; (Find $sessions 'wasm' 'superposition-act').Steps = 781
    Expect 'two halves'' sessions apart' (Judge $sessions $history 'abc1234' $digests) 'not the same session'
    $cascades = Clean; (Find $cascades 'wasm' 'superposition-cascade').Deal = 'B2'
    Expect 'two halves'' cascades apart' (Judge $cascades $history 'abc1234' $digests) 'not the same cascade'
    # naught (CART.9): a row's own fields, the halves' census alike, and each placement's digest.
    $noIdle = Clean; (Find $noIdle 'native' 'naught-s').Remove('IdleP50')
    Expect 'a naught row without its idle frame' (Judge $noIdle $history 'abc1234' $digests) 'names no IdleP50'
    $censusApart = Clean; (Find $censusApart 'wasm' 'naught-s').Shapes = 44547
    Expect 'two halves'' census apart' (Judge $censusApart $history 'abc1234' $digests) 'not the same census'
    $fewerBuilt = @{}; foreach ($k in $controlRungs.Keys) { if ($k -ne 'naught-s') { $fewerBuilt[$k] = $controlRungs[$k] } }
    Expect 'a naught rung the baseline names no digest for' (Judge (Clean) $history 'abc1234' $digests $controlEnvironment @{} @{} $fewerBuilt) 'no SHA-256 for the rung naught-s'

    # The history, read from text as the commit's copy of this file is read.
    $entryA = "@{ Date = '2026-10-09'; Pin = 'abc1234'; Reason = ''; Floors = @{ 'native life' = 202000; 'wasm life' = 209000 } }"
    $entryB = "@{ Date = '2026-10-10'; Pin = 'def5678'; Reason = ''; Floors = @{ 'native life' = 560000; 'wasm life' = 414000 } }"
    function HistoryText([string[]]$entries) {
        $t = @('# the floors', '$floorHistory = @(')
        for ($k = 0; $k -lt $entries.Count; $k++) { $t += ('    ' + $entries[$k] + $(if ($k -lt $entries.Count - 1) { ',' } else { '' })) }
        return ($t + @(')', '', '$allocationCeilings = @{'))
    }
    $editedA = $entryA.Replace('202000', '201000')
    if ($editedA -eq $entryA) { $ok = $false; $verdicts.Add('the edited entry: its mutant did not apply') }
    Expect 'an entry added after the committed one' (Test-HistoryKept (Get-HistoryLines (HistoryText @($entryA))) (Get-HistoryLines (HistoryText @($entryA, $entryB)))) ''
    Expect 'a history unchanged' (Test-HistoryKept (Get-HistoryLines (HistoryText @($entryA, $entryB))) (Get-HistoryLines (HistoryText @($entryA, $entryB)))) ''
    Expect 'an entry pasted over a committed one' (Test-HistoryKept (Get-HistoryLines (HistoryText @($entryA))) (Get-HistoryLines (HistoryText @($entryB)))) 'never pasted over'
    Expect 'a committed entry edited in place' (Test-HistoryKept (Get-HistoryLines (HistoryText @($entryA))) (Get-HistoryLines (HistoryText @($editedA, $entryB)))) 'never pasted over'

    # The fake runners: scripts printing what a runner's check prints, at the
    # ceilings as they stand, so a lowered ceiling moves the fakes with it.
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_frame_floors_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        function CheckRow([string]$name, [string]$facts, [int]$cells = 62964, [long]$plus = 0, [long]$heapPlus = 0, [string]$digest = '') {
            $c = $allocationCeilings[$name]
            $d = if ($digest -ne '') { $digest } elseif ($controlRungs.ContainsKey($name)) { $controlRungs[$name] } else { '' }
            $digestPart = if ($d -ne '') { ' (digest "' + $d + '")' } else { '' }
            return ('(frames-check "{0}" (frames 4) (equal 4) (cells {1}) (allocs {2}) (reallocs {3}) (memory {4}){5}{6})' -f $name, $cells, ($c.Allocs + $plus), $c.Reallocs, ($c.Memory + $heapPlus), $digestPart, $facts)
        }
        function Done($rows) { return @($rows) + @('(frames-check-done ' + @($rows).Count + ')') }
        $lifeRow = CheckRow 'life' ''
        $lifeX4 = CheckRow 'life-x4' '' 253924
        $lifeX16 = CheckRow 'life-x16' '' 1019844
        $gunRow = CheckRow 'gun' ' (facts 24)'
        $gunX4 = CheckRow 'gun-x4' ' (facts 24)' 253924
        $gunX16 = CheckRow 'gun-x16' ' (facts 24)' 1019844
        $sandRow = CheckRow 'sand' ' (conserved 3)' 189215
        $latticeRows = @((CheckRow 'superposition' ' (settled 3)' 798731), (CheckRow 'superposition-act' ' (settled 13)' 798731), (CheckRow 'superposition-cascade' ' (settled 2) (deal "SP502") (rings 775) (opened 209446)' 798731))
        $naughtRows = @((CheckRow 'naught-f' ' (shapes 32) (levels 8194) (alone 12785)' 52865), (CheckRow 'naught-s' ' (shapes 44548) (levels 8194) (alone 44545)' 52865))
        $fakes = @(
            @{ Name = 'a clean runner'; Lines = (Done (@($lifeRow, $lifeX4, $lifeX16, $gunRow, $gunX4, $gunX16, $sandRow) + $latticeRows + $naughtRows)); Exit = 0; Want = '' },
            @{ Name = 'a runner whose frame differs'; Lines = @('(frames-differ "life" (frame 3) (cell "B5") (engine 1) (reference 0))'); Exit = 1; Want = 'check failed' },
            @{ Name = 'a runner allocating more'; Lines = (Done (@((CheckRow 'life' '' 62964 1), $lifeX4, $lifeX16, $gunRow, $gunX4, $gunX16, $sandRow) + $latticeRows + $naughtRows)); Exit = 0; Want = 'rose to' },
            @{ Name = 'a runner whose heap passes its ceiling'; Lines = (Done (@($lifeRow, $lifeX4, (CheckRow 'life-x16' '' 1019844 0 1), $gunRow, $gunX4, $gunX16, $sandRow) + $latticeRows + $naughtRows)); Exit = 0; Want = 'high-water mark over a load and four frames rose to' },
            @{ Name = 'a runner without the gun''s facts'; Lines = (Done (@($lifeRow, $lifeX4, $lifeX16, $gunRow, $gunX4, $gunX16.Replace(' (facts 24)', ''), $sandRow) + $latticeRows + $naughtRows)); Exit = 0; Want = 'published facts' },
            @{ Name = 'a runner without Sand''s grains'; Lines = (Done (@($lifeRow, $lifeX4, $lifeX16, $gunRow, $gunX4, $gunX16, $sandRow.Replace(' (conserved 3)', '')) + $latticeRows + $naughtRows)); Exit = 0; Want = 'to its grains' },
            @{ Name = 'a runner leaving out a fixture'; Lines = (Done (@($lifeRow, $lifeX4, $lifeX16, $gunRow, $gunX4, $gunX16) + $latticeRows + $naughtRows)); Exit = 0; Want = 'no row for the fixture sand' },
            @{ Name = 'a runner leaving out a rung'; Lines = (Done (@($lifeRow, $lifeX4, $lifeX16, $gunRow, $gunX4, $sandRow) + $latticeRows + $naughtRows)); Exit = 0; Want = 'no row for the fixture gun-x16' },
            @{ Name = 'a runner whose rung is another cartridge'; Lines = (Done (@($lifeRow, $lifeX4, $lifeX16, $gunRow, (CheckRow 'gun-x4' ' (facts 24)' 253924 0 0 ('9' * 64)), $gunX16, $sandRow) + $latticeRows + $naughtRows)); Exit = 0; Want = 'is not the cartridge measured' },
            @{ Name = 'a runner whose cascade is another deal'; Lines = (Done (@($lifeRow, $lifeX4, $lifeX16, $gunRow, $gunX4, $gunX16, $sandRow) + @($latticeRows[0], $latticeRows[1], $latticeRows[2].Replace('(deal "SP502")', '(deal "B2")')) + $naughtRows)); Exit = 0; Want = 'the cascade is not the baseline''s' },
            @{ Name = 'a runner that settles no act'; Lines = (Done (@($lifeRow, $lifeX4, $lifeX16, $gunRow, $gunX4, $gunX16, $sandRow) + @($latticeRows[0].Replace(' (settled 3)', ''), $latticeRows[1], $latticeRows[2]) + $naughtRows)); Exit = 0; Want = 'settled no act' },
            @{ Name = 'a runner whose census is another'; Lines = (Done (@($lifeRow, $lifeX4, $lifeX16, $gunRow, $gunX4, $gunX16, $sandRow) + $latticeRows + @($naughtRows[0], $naughtRows[1].Replace('(shapes 44548)', '(shapes 44547)')))); Exit = 0; Want = 'the census is not the baseline''s' },
            @{ Name = 'a runner that prints no census'; Lines = (Done (@($lifeRow, $lifeX4, $lifeX16, $gunRow, $gunX4, $gunX16, $sandRow) + $latticeRows + @($naughtRows[0].Replace(' (shapes 32) (levels 8194) (alone 12785)', ''), $naughtRows[1]))); Exit = 0; Want = 'printed no census' }
        )
        $i = 0
        foreach ($f in $fakes) {
            $i++
            $path = Join-Path $tmp ("fake$i.ps1")
            $body = (@($f.Lines | ForEach-Object { "Write-Output '" + ($_ -replace "'", "''") + "'" }) -join "`r`n") + "`r`nexit " + $f.Exit + "`r`n"
            [System.IO.File]::WriteAllText($path, $body, (New-Object System.Text.UTF8Encoding($false)))
            Expect $f.Name (Test-Runner $path @('life.vla', 'gun.vla', 'sand.vla', 'superposition.vla', 'naught.vla') $allocationCeilings $controlRungs $controlCascade $controlCensus) $f.Want
        }
    } finally {
        Remove-Item -Recurse -Force -LiteralPath $tmp -ErrorAction SilentlyContinue
    }
    foreach ($v in $verdicts) { Write-Output ('control: ' + $v) }
    if ($ok) {
        Write-Output ("OK: control: the judgment passes the clean table, a reasoned lowering, a row entering the history, a machine of one kind of core, a release of the measured source and a fixture rebuilt with the measured rows, and fails twenty-eight mutants of the table; the history passes an entry added and a history unchanged, and fails an entry pasted over and one edited in place; over thirteen fake runners it passes the clean one and fails twelve, each for its own reason")
        exit 0
    }
    Write-Output 'FAIL: control: the judgment did not behave as the header says'
    exit 1
}

Write-Output '=== THE FRAME FLOORS: LIFE''S, THE SIZE LADDER''S, SAND''S, SUPERPOSITION''S AND NAUGHT''S CELLS A SECOND, NATIVELY AND IN THE BROWSER, HELD TO FLOORS THAT NEVER GO DOWN (CART.1, CART.2, ENGINE.9, CART.12, CART.9) ==='
$problems = New-Object System.Collections.Generic.List[string]
$currentDigests = @{}
foreach ($name in $fixtureFiles.Keys) {
    $path = Join-Path $Root $fixtureFiles[$name]
    if (Test-Path -LiteralPath $path) { $currentDigests[$name] = Get-LfDigest $path } else { $problems.Add("the fixture $($fixtureFiles[$name]) is missing") }
}
$static = Test-Baseline $baseline $baselineDate $baselineEnvironment $baselinePin (Get-Pin $Root) $baselineFixtures $currentDigests $floorHistory $sameSource $sameRows $baselineRungs
if ($baselineDate -ne '') { Write-Output ("  measured {0}: {1}" -f $baselineDate, $baselineEnvironment) }
$static.Lines | ForEach-Object { Write-Output $_ }
foreach ($p in $static.Problems) { $problems.Add($p) }

# The history against the last commit's copy of this file, where git can say.
$working = @(Get-HistoryLines ([System.IO.File]::ReadAllLines($PSCommandPath)))
if ($null -eq (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Output '  the history against the commit: SKIPPED, no git to ask'
} else {
    $old = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { $committedText = @(& git -C $Root show 'HEAD:tools/check_frame_floors.ps1' 2>$null); $gitCode = $LASTEXITCODE } finally { $ErrorActionPreference = $old }
    if ($gitCode -ne 0 -or $committedText.Count -eq 0) {
        Write-Output '  the history against the commit: SKIPPED, no committed copy of this file to read'
    } else {
        $committed = @(Get-HistoryLines $committedText)
        $kept = Test-HistoryKept $committed $working
        foreach ($p in $kept.Problems) { $problems.Add($p) }
        if ($kept.Problems.Count -eq 0) { Write-Output ("  the history: {0} entries, the last commit's {1} kept at its head in order" -f $working.Count, $committed.Count) }
    }
}

if ($Runner -eq '') {
    $candidate = Join-Path $Root ('target/release/examples/frames' + $(if ($onWindows) { '.exe' } else { '' }))
    if (Test-Path -LiteralPath $candidate) { $Runner = $candidate }
}
if ($Runner -eq '') {
    Write-Output '  the runner: SKIPPED, none built (cargo build --release --example frames); the frames, the allocation and heap ceilings and the rungs'' digests are held where it is'
} elseif (-not (Test-Path -LiteralPath $Runner)) {
    $problems.Add("the runner $Runner does not exist")
} else {
    Write-Output ("  the runner: {0}, built {1}, in its check mode" -f $Runner, (Get-Item -LiteralPath $Runner).LastWriteTime.ToString('yyyy-MM-dd HH:mm'))
    # naught's committed bench beside the fixtures: the runner builds its two placements from the
    # source beside it (CART.9), which its rungs' digests name.
    $paths = @($fixtureFiles.Values | ForEach-Object { Join-Path $Root $_ }) + @(Join-Path $Root 'cartridges/naught/naught.vla')
    $measuredCascade = @($baseline | Where-Object { $_.Runner -eq 'native' -and $_.Fixture -eq 'superposition-cascade' })
    $measuredCensus = @{}
    foreach ($r in @($baseline | Where-Object { $_.Runner -eq 'native' -and ([string]$_.Fixture) -like 'naught-*' })) { $measuredCensus[[string]$r.Fixture] = $r }
    $dyn = Test-Runner $Runner $paths $allocationCeilings $baselineRungs $(if ($measuredCascade.Count -eq 1) { $measuredCascade[0] } else { $null }) $measuredCensus
    $dyn.Lines | ForEach-Object { Write-Output $_ }
    foreach ($p in $dyn.Problems) { $problems.Add($p) }
}
Write-Output ''
if ($problems.Count -eq 0) {
    Write-Output '=== CHECK: clean - the twenty-four rows at or above their floors, the pin, the fixtures and the rungs the measured ones, and, with a runner, every frame equal, every count under its ceiling and the cascade the measured one ==='
    exit 0
}
Write-Output "=== CHECK: $($problems.Count) problem(s) ==="
$problems | ForEach-Object { Write-Output "  $_" }
exit 1

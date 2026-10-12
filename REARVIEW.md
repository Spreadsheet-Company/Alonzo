# ALONZO REARVIEW

*The record behind `ROADMAP.md`, as `Frazaro/docs/BETA_REARVIEW.md` is behind Frazaro's: the closed ledger, one line an item, and under it the full account of each sitting and each item, so that the roadmap stays short and nothing is lost. A living document while the repository forms, like the charter; append-only from the day the owner freezes it. Started 2026-10-08.*

# THE CLOSED LEDGER

## 🌍 THE REPOSITORY

- ✅ **`REPO.1` — the skeleton, and the first commit.** *Built, committed and closed 2026-10-08; the root commit, `2728312`, 21 files.* `LICENSE` (Apache-2.0, `CHARTER.md` §9; the owner's call, made at this commit), `README.md` (what Alonzo is, in the charter's three sentences, and what it is not), `CONTRIBUTING.md` (DCO inbound and no CLA, as `CUTS.md` decided for Frazaro; a contribution enters by a device or a cartridge, as Frazaro's enter by a seam), `REUSE.toml`, `.gitignore`, `rust-toolchain.toml` (stable with the wasm target, as Frazaro pins it), and `Cargo.toml` for the `alonzo` crate, `cdylib` and `rlib`, no dependency yet. *Oracle, met:* `cargo build --target wasm32-unknown-unknown` of the empty crate, 32 bytes, and `REPO.2`'s check green on it at zero imports. *Scoped:* 2026-10-08, nine decisions, all approved, `AD-5` adopted among them. Predicted `~days`; cost hours of writing and the owner's calls. (more: the full entry under THE ITEMS, SCOPED)
- ✅ **`REPO.2` — the import allowlist check.** *Built, owner-tested and closed 2026-10-08; committed `5bf66e6` and pushed the same day.* `tools/check_host_imports.ps1`, the twin of Frazaro's `check_core_imports.ps1`: it reads the wasm's import section off the artifact and holds it to a list written in the script, one module name, `alonzo`, and under it the host's functions as `SPEC.1` names them, exactly, every import listed, every listed name imported, the count pinned beside the list; the forbidden names first, `fetch` first among them, then the rest of the network, anything that opens a socket, any WASI module and the names generated glue writes, failing even when listed; the list empty and the count zero until `SPEC.1` names the first. `tools/check_spdx.ps1`, the licence map verified against the tree. `tools/run_checks.ps1`, one line a check, the floor at 2, the two controls as its extras, `pwsh` where `powershell.exe` is absent. `.github/workflows/checks.yml`, the runner under Windows PowerShell 5.1 and under pwsh beside the wasm it builds, on every push and pull request. *Oracle, met:* the artifact at 0 imports; both controls; the runner green and its floor tripped on a scratch copy; a Rust-built module with one import read as `alonzo.blit (func)` by this check and Frazaro's twin alike; the owner's own run, 2 checks and 2 verifiers, `ALL GREEN`; the pwsh half at the first push, CI's run `37803504536` on `2ea5999`, both jobs green. *Found:* on rustc 1.99 an `extern "C"` block without `#[link(wasm_import_module = ...)]` does not link, so `env` is never a silent default. *Scoped:* 2026-10-08, eight decisions, all approved. Predicted `~days`; cost hours of writing. (more: the full entry under THE ITEMS, SCOPED)

## 📜 THE SPECIFICATION

- ✅ **`SPEC.1` — the page: the device sheets and the four calls.** *Drafted, approved, committed and closed 2026-10-08, in a second session beside `REPO.2`; the commits `eed93b0`, `7b633da` and the closing one.* `SPEC.md`, version 1, in the charter's register and marks: the cell as the unit, with two projections, a byte for a game and text for the spreadsheet; the previous frame as a read-only twin sheet `X.last`, so a rule reads it by an ordinary reference and the frame adds no mechanism to the evaluator; the acyclic rule and the step as recalculation with a budget in cells and a snapshot at its end; seven device sheets cell by cell, Screen, Palette, Input, Keys, Clock, Audio and File; the four calls, `load`, `write`, `step`, `view`, with an explicit handle and `abi.rs`'s record, eleven exports and zero imports; the host's loop; seven determinism rules and the replay as the oracle; the cartridge as one file, the manifest with every directive required and the treaty's rows with range fills, so that load is the inverse of view and Frazaro is the compiler; reflection as `AD-6`; the limits stated, the seventeen decisions, what is not in this version, the fan-out, the sources; three appendices, Life as the shape of a cartridge, three formulas every cartridge writes, and the Fragments patch in VLA with its module library, its eurorack reading, the artist's patch notes codified and the golden patch. *Oracle:* the page read by the owner, who approved all seventeen recommendations and adopted `AD-6`, which amended the charter the same hour; the tests the `vla-lang` cut and `ENGINE.2` write from the page are named in §13 and belong to those items. *Scoped:* 2026-10-08, seventeen decisions, all approved. Predicted `~days`; cost one day and three commits. (more: the full entry under THE ITEMS, SCOPED)
- ✅ **`SPEC.2` — the page, version 2: the grid writes the grid in values, one model with two renderers, rate zero, the Camera, and `AD-7`.** *Minted, scoped, built, approved and closed 2026-10-08, the same evening, at the owner's word; committed with the horizon, `docs/ALGEBRA.md`, in two commits.* `SPEC.md`, version 2, rewritten in place: a Write sheet of value rows the host carries between frames (§3.9), the formula half declined under the `GENSYM` veto's `eval` clause; one model with two renderers, a `look` row mapping a value to a style and a `row` row, both asked of oracle 11 (§1, §3.1, §7.3); `(rate 0)`, a step on every edit (§5); a Camera sheet the host views the window by (§3.8); one write per cell refused at load (§7.3); the limits restated with the compute line as a budget `describe` prints (§10); and `AD-7`, the step computes values and never formulas, held by a test (§2, §6, §9, §13), adopted by the owner at the approval and written into the charter first as its seventh rule, with the frame paragraph, §1's thesis exact at rate zero and §8's pointer to the horizon. *Oracle:* the page read by the owner, who approved all seven recommendations (§11, 18 to 24) in the words "if `AD-7` solidifies the design we've discussed in SPEC and ALGEBRA, then it's adopted"; the five tests §13 names belong to the cut and to `ENGINE.1` and `ENGINE.2`. *Scoped:* 2026-10-08, seven decisions, all approved. Predicted `~days`; cost one evening. (more: the full entry under THE ITEMS, SCOPED)
- ✅ **`SPEC.3` — the page, version 3: the cartridge's source, and the pass between it and the rows.** *Filed, scoped, built in two slices, owner-tested and closed 2026-10-10; the first slice committed `993cf8e`, the second at the close.* `SPEC.md`, version 3, rewritten in place, the charter amended first (rules 1 and 7, §8, the frame paragraph). A cartridge is written as a source, VLA with its author's template macros and the reference's includes, and the pass expands it into version 2's rows: an act of its own between the source and the load, whose output, the cartridge, is the artifact a person reads, saves and diffs, wherever it runs (the owner's refinement, decision 25). The engine never expands, and refuses a source handed to the load by name, `cart-source-unexpanded`. The pass is one pure function of the engine's crate over `vla-lang`'s own expander, `engine/src/pass.rs`, and knows no macro by name (the owner's guiding principle: macros are the author's, to collapse the boilerplate between thought and rows). It has two doors to the same bytes: the command line, `cargo run --release --example expand`, and the page, the module's twelfth export `alonzo_expand` behind the engine panel's Build, a press of its own before Load. `cartridges/console.vla` is the library the sources include (`palette`, `cga-palette`, `live`; renamed `cartridges/common.vla` 2026-10-10 and given `on`, `cells` and `formulas`); the three cartridges were written as sources and rebuilt with their rows unchanged, the frame floors' digests carried by `$sameRows`; `(spec 3)` is read; and the loader takes no data form, every convenience being a macro (decision 29). *Oracle, met:* `cargo test`'s golden, every cartridge with a source its expansion byte for byte and loading; `check_cartridge.ps1`'s folder rule and its twenty mutants; the loop oracle's eleventh case, the page's pass over every source equal to the command line's bytes, its mutant library failing it; the module at 514,688 bytes with no import and twelve exports, `?frames=1` measured on it alternately with the first slice's and costing nothing measurable; `run_checks.ps1` ALL GREEN, the owner's runs among them. Measured and named for the next version (§12): a template macro reaches a row by arithmetic, and a column or a sheet only by the names its caller writes, so the generality the owner's principle asks for is the language's expand-time object model, a Frazaro item; beside it the picture, the formula dialect and modules. Predicted `~days`; cost one day, the scoping and both slices. (more: the full entry under THE ITEMS, SCOPED)

## 🔧 THE ENGINE

- ✅ **`ENGINE.1` — the host shim and the loop.** *Built in two slices, owner-tested and closed 2026-10-09; the first slice committed `984722a` and pushed, the second committed at the close.* `web/host.js`, the shim: the module instantiated with an empty import object and its ABI asked first, the memory pair with every view made fresh, `SPEC.md` §5's fixed timestep with its accumulator capped at 250 ms and no frame skipped, the derived writes before the Input sheet's eighteen rows and each person's edit its own write, the step with a budget in cells that yields so the page never freezes, the effects read through the frame's own Camera and Palette, the plane blitted crisp at whole device pixels, rate zero a step on every edit, frame 0 drawn at every load, every event a sentence in a log that counts its repeats, and every refusal marked and painted red; `web/fake.js`, the permanent double, its ids the module's; and `engine/`, the `alonzo` crate over `vla-lang`'s machine, pinned by git at `KERNEL.22`'s commit until the language was on crates.io, which it reached as 0.8.1 where the slice expected 0.9.0 (pinned exactly since 2026-10-10): the eleven exports, the manifest, the device layouts checked at load and before every write, the engine's own Clock, File and Input sheets, the Clock's frame first at each step, and its own catalogue of eight refusals, in a module of 456,328 bytes that imports nothing and exports the eleven names. Life computed on it by the language at 226,000 to 236,000 cells a second in wasm, about two generations a second in the page. *Oracle, met:* `cargo test`, 12; the loop oracle's nine cases under headless Chrome and Edge at two ratios, Life's plane equal byte for byte to a reference Life at frames 1 and 11, and eleven refusals answered with the same id by the double and the module; five checks with their controls, `check_cartridge.ps1`, `check_host_loop.ps1` at seven mutant pages, `check_blit_floors.ps1` over the owner's baseline, `check_host_exports.ps1` and `check_engine_deps.ps1`; `run_checks.ps1` at 11 checks and 11 verifiers, `ALL GREEN`; the owner's hand tests, three rounds for each slice. *Found:* the soup wanted the square of its hash; a write is atomic, so each refusable row is its own write; the language's grid texts open `Line {line}`, sent to Frazaro; a reload left the last run's picture until frame 0 was drawn at the load. *Scoped:* 2026-10-08 and 2026-10-09, fourteen and fifteen decisions, all approved, the second slice's first changed by the owner to the git route. Predicted `~days` after the cut; cost two days. (more: the two full entries under THE ITEMS, SCOPED)
- ✅ **`ENGINE.2` — the frame path.** *Scoped, built in two slices, owner-tested and closed 2026-10-09; the first slice committed `1278279`, the second at the close.* The plane the host draws, held to the view record of the same window, byte for value, the record the oracle (`CHARTER.md` §3): two engine tests that read the record with the language's reader and map it by `SPEC.md` §3.1's words alone, over `cartridges/testcard/testcard.vla`, the plane's test card, every kind of value a Screen cell can hold under a Camera that pans a column a frame, and over Life at its corners; a tenth case of the page's loop oracle that holds the window the host draws through to the Camera's, its bytes to the record and the canvas's pixels to the Palette or magenta, over the double and over the module; the double's plane reading a formula without a value as 0, as its record says; a cartridge picker in the engine's panel. The scoping measured the plane view first, 2.5 to 5.5 ms a frame in wasm, the language's lookup of each formula cell's value and not the record's copies, so no new export, and asked it of Frazaro, which keeps a sheet's plane at the frame's end (`KERNEL.24`, `c0686a9`, beside `KERNEL.23`'s reworded refusals); the pin moved there, where a view of Life's window costs 0.003 ms; then `redraw()` and the blit instrument's third case, the frame path over the engine's module, its frame p95 0.5 ms against the bar of 2.0. *Oracle, met:* `cargo test`, 14, over both pins; the loop oracle's ten cases at two ratios, three mutant pages failing the new one by name; `check_blit_floors.ps1` over the owner's second baseline, three cases from one fullscreen run; `run_checks.ps1` at 11 checks and 11 verifiers, `ALL GREEN`; the owner's hand test. *Found:* a stale-bytes mutant read green until the test's writes were aimed inside the window the Camera had panned to; a source restored with `Copy-Item` keeps an older write time, so Cargo keeps a mutant's build; no real-time number of an asynchronous page can be had headless; the double's fit row drifted from a p95 of 0.9 to 1.1 ms between the two baselines, inside its bar. *Scoped:* 2026-10-09, ten decisions, all approved. Predicted `~days`; cost one day, Frazaro's two items beside it. (more: the full entry under THE ITEMS, SCOPED)
- ✅ **`ENGINE.3` — the Input and Clock devices.** *Scoped, built in two slices, owner-tested and closed 2026-10-10; the first slice committed `e1e4935`, the second at the close.* `ENGINE.1` had built most of the line, and the scoping measured what it left. The Clock's three cells are held at a person's write by the engine's tenth refusal, `cart-write-clock`, and by the double alike: the frame refused, being the step's own first act and the only clock; the rate 0 or a whole number from 1 to 120; the seed a whole number from 1 to 2147483646. The host chooses the seed at a `(seed host)` load from the browser's random source, no clock among it, and writes it into `Clock!B3`. It reads the Clock's rate after each step and steps at it, `SPEC.md` §9's teacher made real. It writes the pointer as the Screen's own cell through the Camera the person sees. The input card, `cartridges/inputcard/`, is written as a source over the library, which gained the Keys sheet's macros, and draws every cell the host writes before a step. And the replay, §7.6 made exact. The host records every load's run as frames, each one form holding its rows (the form amended after the close at the owner's word): the Input sheet's cells that changed, whole at the first frame and after a person's edit of the sheet, and each person's edit that landed, in its frame, the derived writes never. The header names the cartridge by a SHA-256 of its LF text that the host computes itself, synchronously, and names the seed. The player loads the cartridge again with that seed and plays each frame's rows as one write after the derived writes, through the loop or all at once, a person's edits refused while it plays; Play the replay and Copy the replay sit in the panel. The card's replay, the loop oracle's own run of it, and its golden, the `Tally` sheet at its end, are committed beside it and read by `check_cartridge.ps1`, and every committed replay is played to its golden. *Oracle, met:* `cargo test`, 27, the Clock's refusals, the card's counts over twelve frames, and the replay played with the engine alone to its golden; the loop oracle at thirteen cases under headless Chrome at two ratios, `input` holding every window of 26 frames to the card computed by hand from a log of keys, clicks, the wheel, the teacher's rate of 1 and a person's edit of the Input sheet, and `replay` holding the host's digest to FIPS 180-2's five vectors, a run over the double played to its digest all at once and through the loop, six bad replays refused in words, and the card's replay played to every frame of its run and to its golden, with `parity` at fourteen refusals; the controls, `check_host_loop.ps1`'s at eighteen mutant pages, `check_cartridge.ps1`'s at twenty-nine mutants and `check_web_offline.ps1`'s at thirteen; `run_checks.ps1` at 12 checks and 12 verifiers, `ALL GREEN`; the owner's hand tests, two rounds for the first slice and one for the second, all four cartridges replayed. *Found:* the owner's hand test found a latent `ENGINE.1` defect, the backlog held to 250 ms, so that a rate under four frames a second never stepped and the teacher's rate of 1 froze the loop, now held to the larger of 250 ms and one frame's interval; a PowerShell hashtable with a key named `keys` answers `.Keys` with that key's value; a write of the value a cell already holds answers `(written 0)`; a recorder that keeps its record of the Input sheet across a person's edit of it loses the next frame's release, so the record forgets on such an edit; under headless virtual time the animation frames come in bursts. *Scoped:* 2026-10-10, thirteen decisions, all approved. Predicted `~days`; cost one day, both slices and the fix. (more: the full entry under THE ITEMS, SCOPED)
- ✅ **`ENGINE.4` — the Audio device.** *Scoped, built in two slices, owner-tested and closed 2026-10-10; the first slice committed `4244819`, the second at the close.* Every item before it read the Audio sheet after each step and sounded nothing, so the scoping measured Web Audio under headless Chrome first: a context made before a person's gesture stays suspended; under a virtual clock the audio clock is the wall's; a wave cannot be scheduled; a gain set at once clicks 17 to 24 times a wave's own step, and `setTargetAtTime` at 3 ms no more than 1.33. The host sounds the four voices with the graph's own nodes, an oscillator and a gain a voice into one shared gain, and computes no sample (`CHARTER.md` §8). Each frame's voices sound at the end of the last frame's sound on the audio clock, within 100 ms ahead of it, so a rhythm in the cells is a rhythm in the sound; a late frame starts the timeline again 50 ms ahead, and a frame past the window is skipped. A voice's gain is its volume over four, every change approaches its value at 3 ms, and a wave change is a new oscillator through a dip. A cell that is no voice is silent and said once. A Sound button makes the context at a person's press, and every stop of the loop silences the voices. The sound card, `cartridges/soundcard/`, is written as a source over the library, which gained `audio`: the four waves, a scale, two chords and a slide under a swell, a tick on every press, a Knobs sheet, a Log of the last 32 frames and a waterfall. Its replay and golden, the Log at the replay's end, are committed beside it, and `cargo test`'s player now plays every committed replay. `check_web_offline.ps1` holds the host to the graph's oscillators and gains. *Oracle, met:* the loop oracle at fifteen cases under headless Chrome at two ratios. `audio` holds every call the host makes on a double of the graph to the page's own arithmetic, over the double by edits and over 240 frames of the card computed by hand. `sound` renders the host's voices offline and holds each frame's pitch within 0.1%, its rms within 4%, a rest below 0.0001 and an onset under 1.5 times the wave's own: the worst 0.0052%, 0.06% and 1.00, every rest 0 exactly. `replay` plays both committed replays to every frame and to their goldens. The controls: `check_host_loop.ps1`'s twenty-four mutant pages, X, the time constant in milliseconds in host and page alike, heard only by the render; `check_cartridge.ps1`'s thirty-two mutants; `check_web_offline.ps1`'s twenty-one. `cargo test`, 27, both replays played natively to their goldens; `run_checks.ps1` at 12 checks and 12 verifiers, `ALL GREEN`; the owner's hand tests with the speakers on, the loop, the ticks, the knob, Pause, a hidden page, the rate and the card's replay heard again. *Found:* an `OfflineAudioContext` awaited idle burns a headless virtual-time budget, and a chain of 0 ms tasks paces it; a context holds at most 32 channels; PowerShell's names fold case, so a mutant's `$jS` was the host's `$js`; Chrome tells a page whose window another covers that it is hidden, and the hidden page is silent; the rests render 0 exactly. *Scoped:* 2026-10-10, thirteen decisions, all approved. Predicted `~days`; cost one day, both slices. (more: the full entry under THE ITEMS, SCOPED)

## 🕹 THE CARTRIDGES

- ✅ **`CART.1` — Life, the benchmark cartridge.** *Scoped 2026-10-09, built in two slices, owner-tested and closed 2026-10-10; the first slice committed `da26122`, the second at the close.* Life on the 320 by 200 Screen as the engine's benchmark, every cell one shape of its eight neighbours in the previous frame, over two fixtures: the soup of `cartridges/life/life.vla`, and Gosper's glider gun, `cartridges/gun/gun.vla`, its pattern a Seed sheet the first frame reads and its rule Life's word for word. `engine/examples/frames.rs`, the native runner, an example and no member, holds every frame to a Life written by hand and the gun to its published facts through generation 720, watches the clock beside every frame, and counts a frame's allocations exactly in its check mode; the page's `?frames=1` steps the module over both at its load, held to the page's Life; `tools/bench_frames.ps1`, the instrument, runs both halves opted out of Windows' power throttling and on the performance cores, and prints the block to paste; `tools/check_frame_floors.ps1`, the twelfth check, holds four rows to floors in a dated history that never goes down and is never pasted over, the pin and the fixtures to the measured ones and the environment to the instrument's guards, and, with a built runner, the frames and the allocation ceilings on every push. The scoping's profile named the bottleneck, the naive evaluator's own hot path, allocation first, and Frazaro removed the first of it bit for bit (`KERNEL.25`, `f5dc344`); the pin moved there and the floors rose: the soup from 217,984 cells a second natively and 228,710 in wasm to 622,904 and 460,600, a frame's allocations from 4,470,549 to 251,957, about a third and a quarter of `CHARTER.md` §3's line, with `KERNEL.20`'s array of the twin the next ask. *Oracle, met:* `cargo test`, 16, over both pins; the runner's frames and the gun's facts; `?frames=1` under headless Chrome; the check's control at three clean tables, twelve table mutants, two clean histories, two history mutants and five fake runners; `run_checks.ps1` at 12 checks and 12 verifiers, `ALL GREEN`; the owner's two runs of the instrument, pasted as the floors' two baselines, and the gun seen firing in the page. *Found:* Windows throttles a background process about three seconds into a run, about 40% slower, and only Chrome's four flags with every process opted out hold headless Chrome flat; an efficiency core steps 23% slower with a clock that looks steady, and the performance cores run at two clocks 6% apart; counting allocations while timing costs a frame a tenth; a terminal's line wrap drops spaces from a copied block, and a floor entry pasted over the history erased the first, so the instrument writes its block to a file and prints the history whole, and the check holds the history against the commit. *Scoped:* 2026-10-09, twelve decisions, all approved, and two more in the second slice, 2026-10-10. Predicted `~days`; cost two days, Frazaro's `KERNEL.25` beside it. (more: the full entry under THE ITEMS, SCOPED)

# THE SITTINGS

## 2026-10-08 — the boundary, in four sittings, and the first measurement

**The first sitting: the charter as first written.** The previous session scoped Alonzo as a consumer of `frazaro-core` that renders the view record, with rule 2 leaving it only the frame loop, sprites and input once Frazaro's bricks were laid. The owner read that as "a kernel of a kernel" and asked for the boundary to be drawn so that it could be measured.

**The second sitting: Frazaro has no clock, Alonzo is the clock.** The rule proposed: if a thing's output can be a golden it is Frazaro's; if it can only be measured it is Alonzo's. The KERNEL line sorted by it: pure, and Frazaro's, `KERNEL.1`, `2`, `4`, `6`, `7`, `8`, `10`, `11`, `12`, `18`, `20`, `21`, the transcription half of `9` and the diff half of `13`; clocked, and Alonzo's, `KERNEL.5`, the bar of `9`, the modes of `13`, `14`, the wiring of `15` and `16`, `17`, `19`. The owner consented in principle on one condition: Alonzo must be a self-contained substrate for the games after Frazaro, and Frazaro must own nothing such a game needs.

**The third sitting: three names.** The condition exposed a hole: Alonzo would have depended on `frazaro-core` for the language, the grid, the evaluator and the view record, none of which is an interlingual contract. The repair was the owner's own instinct, a VLA crate. A census of `core/src` on the day, each file assigned by what it references, put the language at about 4,300 of 30,559 lines: reader, form, printer, expand, headtable, intrinsics, messages' mechanism, version, the grid, the view record with the row spelling it needs, and the Projection trait. The crate names: `vla-lang`, since `vla` on crates.io is a yanked crate of 2023 and names are not released, and `alonzo`, free that day. The mapping that settled the engine's shape: Alonzo is Varvara to VLA's uxn, its devices mapped into the grid as sheets, Screen, Audio, Input, Clock, File, and its whole contract four calls, load, write cells, step, view. The owner made the charter a living document while the repository forms and the charter was rewritten in place: four rules and the frame.

**The frame model corrected.** The owner asked whether a frame could be asynchronous and whether that would parallelize the dependency graph. It corrected a sentence written that afternoon: a frame is a dependency graph over two buffers, the last frame readable anywhere and this frame wherever the reads are acyclic, so a synchronous automaton and a scan-order one are both special cases; the Margolus trick is unneeded, since a sand rule is a downward chain of formulas. Parallelism is the graph's width at each level and the critical path its depth, so the synchronous frame is the most parallel and scan order the least; the cheap parallelism is vectorizing a shared R1C1 formula, and threads are a device.

**The games' order.** The owner proposed Life second and Sand third. Agreed, for the house's reason, the instrument before the operation: Life has depth one and one formula and isolates the engine's ceiling; Sand adds the intra-frame graph, the mouse and a palette; a falling-block game adds tables, a seeded bag, keys and sound. Two refinements: Life ships in this repository as the floor's fixture and the engine's demo, so the first game repository is Sand; and the quarter of the charter's §6 prediction runs from Sand's release, the engine's own release counted beside it. The honest comparison for the Life number is a Life that computes every generation, not HashLife.

**The renderer benchmark, measured.** `KERNEL.3`'s instrument (`Frazaro/docs/PROTOCOL.md` §7), run by the owner on 2026-10-08, the table as the page printed it:

Environment: Google Chrome 154.0.8037.93 on Windows; pixel ratio 1.5; screen 2560 by 1440; fullscreen yes; frame interval 16.7 ms (about 60 Hz); frazaro 0.8.0 view over 10,000 lines: 20,006 record lines in 893 ms (native debug door); record 20,006 lines, extent A1:B10000, 10,000 cells (5,000 values, 5,000 formulas), read in 13.5 ms.

| renderer | window (rows x cols) | cells with text | render ms | first paint ms | scroll p50 ms | p95 ms | max ms | jump ms | frames over 16.7 ms of N | over 1.5x interval | clears 16 ms |
|---|---|---|---|---|---|---|---|---|---|---|---|
| DOM (virtualized) | normal (40 x 15) | 40 | 0.4 | 16.6 | 16.6 | 16.7 | 16.8 | 16.5 | 7 of 120 | 0 of 120 | no |
| canvas | normal (40 x 15) | 40 | 0.8 | 16.8 | 16.6 | 16.7 | 16.8 | 16.6 | 10 of 120 | 0 of 120 | no |
| DOM (virtualized) | full-screen (71 x 26) | 71 | 1.2 | 16.7 | 16.6 | 16.7 | 16.8 | 16.6 | 8 of 120 | 0 of 120 | no |
| canvas | full-screen (71 x 26) | 71 | 1.2 | 16.4 | 16.5 | 16.6 | 16.7 | 16.7 | 5 of 120 | 0 of 120 | yes |

The reading is in `CHARTER.md` §7: the rule's 16.7 ms threshold is the display's own interval, so its yes-or-no column reads timer jitter; by the page's robust column both renderers clear both windows; by the rule's letter only the canvas clears the full-screen window; the choice is canvas under either reading, subject to the crispness check by eye, which the owner reports separately. This table is kept here alone: it is the run that exposed the instrument's clock, and `PROTOCOL.md` §9.2's header was amended before anything was pasted into it.

**The renderer benchmark, measured again, the instrument amended.** `PROTOCOL.md` §7 as amended 2026-10-08 after the run above (a draw's cost read on the main thread from a task queued after the frame's rendering; a dropped frame read off the next animation frame, later than one and a half intervals; holds the frame when no step was dropped and both the three-row step's and the whole-page step's p95 are under one interval; the sparse record at the protocol's two windows, then a dense record of 600 rows by 52 columns, every cell filled, at full screen at four cell sizes), run by the owner on 2026-10-08, the twelve rows and the summary as the page printed them:

Environment: Google Chrome 154.0.8037.93 on Windows, a 2560 by 1440 CSS screen at a ratio of 1.5, 60 Hz (a 16.7 ms interval), fullscreen; the native debug door 0.8.0; the sparse record 20,006 lines, the dense record 62,406 lines.

| renderer | record | cell px | window (rows x cols) | cells with text | first draw ms | step p50 ms | step p95 ms | page p95 ms | max ms | sync p50 ms | dropped of N | holds the frame |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DOM (virtualized) | sparse | 20 x 96 | normal (40 x 15) | 40 | 3.2 | 1.6 | 1.8 | 1.9 | 2.4 | 0.1 | 0 of 140 | yes |
| canvas | sparse | 20 x 96 | normal (40 x 15) | 40 | 1.4 | 0.4 | 0.9 | 0.7 | 1.0 | 0.2 | 0 of 140 | yes |
| DOM (virtualized) | sparse | 20 x 96 | full-screen (71 x 26) | 71 | 7.5 | 3.6 | 4.1 | 3.8 | 4.4 | 0.1 | 0 of 140 | yes |
| canvas | sparse | 20 x 96 | full-screen (71 x 26) | 71 | 1.7 | 0.6 | 1.1 | 1.4 | 1.4 | 0.4 | 0 of 140 | yes |
| DOM (virtualized) | dense | 20 x 96 | full-screen (71 x 26) | 1846 | 19.1 | 6.9 | 7.4 | 14.3 | 15.4 | 0.2 | 0 of 140 | yes |
| canvas | dense | 20 x 96 | full-screen (71 x 26) | 1846 | 6.6 | 3.0 | 3.7 | 5.5 | 5.5 | 1.5 | 0 of 140 | yes |
| DOM (virtualized) | dense | 16 x 80 | full-screen (89 x 31) | 2759 | 23.1 | 10.2 | 10.6 | 24.9 | 25.6 | 0.2 | 0 of 140 | no |
| canvas | dense | 16 x 80 | full-screen (89 x 31) | 2759 | 8.9 | 4.4 | 5.0 | 7.6 | 8.1 | 2.3 | 0 of 140 | yes |
| DOM (virtualized) | dense | 12 x 64 | full-screen (119 x 39) | 4641 | 43.3 | 17.3 | 17.7 | 39.5 | 41.9 | 0.2 | 8 of 140 | no |
| canvas | dense | 12 x 64 | full-screen (119 x 39) | 4641 | 16.3 | 7.5 | 8.2 | 13.1 | 13.6 | 3.9 | 0 of 140 | yes |
| DOM (virtualized) | dense | 10 x 48 | full-screen (143 x 52) | 7436 | 68.3 | 28.8 | 29.4 | 61.1 | 69.2 | 0.3 | 41 of 140 | no |
| canvas | dense | 10 x 48 | full-screen (143 x 52) | 7436 | 25.5 | 13.0 | 13.9 | 22.5 | 23.7 | 6.1 | 0 of 140 | no |

DOM (virtualized): step cost 3.92 ms per 1,000 cells (-0.6 ms fixed); page cost 8.19 ms per 1,000 cells (0.8 ms fixed); largest dense load that held the frame: 1,846 cells; capacity at one frame interval, by the page cost: about 1,942 cells. Canvas: step cost 1.79 ms per 1,000 cells (-0.5 ms fixed); page cost 3.07 ms per 1,000 cells (-0.6 ms fixed); largest dense load that held the frame: 4,641 cells; capacity at one frame interval, by the page cost: about 5,644 cells. The page's verdict: neither holds the frame at 7,436 cells with text; the DOM held 1,846 and canvas 4,641; the larger capacity decides (§8.1 step 4), and the viewport caps its density there.

The reading is in `CHARTER.md` §7: canvas, by §8.1 step 4 as amended; the DOM's cost is the browser's paint walk over every element on screen, its script's part 0.3 ms at every size. The same run outside fullscreen gave the same shape and the same decision; the backing store is the CSS size times the ratio by the page's own line, and the eye's verdict on crispness is the owner's to add. Recorded on the Frazaro side the same day, uncommitted on the day of writing: `PROTOCOL.md` §9.2 and §9.3's dated entries, `CALLOSUM.md`'s slot as a dated measurement, and canvas in `KERNEL.5`'s roadmap entry.

**Why the roadmap's order.** As Frazaro's rear-view chooses an order: how many later steps each makes cheap, times how much of it already stands, over its size.

| Step | Later steps it makes cheap | What stood on 2026-10-08 |
|---|---|---|
| `REPO.1`, `REPO.2` | every later import is held to a list from the first | Frazaro's `check_core_imports.ps1` at zero, the twin's shape and its control |
| `SPEC.1` | the `vla-lang` cut's ABI, the loop, the frame path, every cartridge | `abi.rs`'s record shape; the view record, oracle 11; the distro manifest as the cartridge's precedent |
| `KERNEL.5`, laid here | the frame path, the first game's grid | the six view goldens; `bench_view.html`'s canvas renderer; `KERNEL.3`'s numbers |
| `ENGINE.1` | every device, every cartridge | the page's debounced rebuild as the one loop today; `SD-34` |
| `ENGINE.2` | `CART.1`'s number | the derived caution of `CHARTER.md` §3 |
| `CART.1` | `ENGINE.6`, the §7 number, the §6 test | nothing; the floor is why it precedes any accelerator |

**The specification, approved, and Fragments.** `SPEC.1` was drafted in a second session while `REPO.2` was built in the first, the two meeting at an import count of zero, and the owner approved all seventeen of its recommendations the same day: the cell as the unit, the previous frame as a twin sheet, the explicit handle, the one-file cartridge, zero imports, and reflection as `AD-6`, which became the charter's sixth rule the same hour and amended `AD-5`'s second sentence and the charter's §2. Three notes of the owner's shaped the page as it was written: the cell is the basic unit of the engine, a colour for a game and text for the spreadsheet (§1 there); reflection over the whole stack is to be sanctified, Frazaro feeling like Emacs and Excel at once (§9); and a cartridge to be called *Fragments*, after State Azure's generative ambient modular performance, with the question whether a modular synthesizer's generative nature can be replicated with wave functions as VLA forms. The answer, written into `SPEC.md` §12 and filed as `CART.5`: at the frame rate, yes, every control signal a formula of the last frame and every module a macro Frazaro expands into rows, a patch a sheet, a control voltage a cell, the control log golden by the replay; the waveform and audio-rate modulation stay the Web Audio graph's, which is a modular synthesizer by construction and rented under rule 3; the patch as a sheet and a MIDI port are the two later versions of the page it asks for.

## 2026-10-08, evening — the four readers, the algebra, and the veto's reach

**The sitting of the four readers.** The owner, in the mood for design theory rather than engineering, asked whether the day's standing decisions were already pigeonholing an open-ended exploration of spreadsheet design theory, and what Peirce, Church, McCarthy and Graham would each say a cell-oriented game-engine substrate should bring to a spreadsheet; then what cell-oriented programming looks like against PyGame, with the hunch that macros erase boilerplate by an order of magnitude, and an aside on the stacking game played with massive cells, seven wide and unbounded. The session's answer is `docs/ALGEBRA.md` §1 to §5: the triad in the formula bar and blank not being zero (Peirce); the frame as Lustre's instant, the twin as `pre`, relative references as de Bruijn indices, the clock calculus (Church); the frame problem written by hand in every keep-last cell, and the law of inertia the `write` call already implements for the host (McCarthy); the demo in ten seconds, the succinctness claim as a prediction, the veto read against its own reasons, the controls crowd (Graham); seven course corrections ranked, with what stands; the stacker in cells; the crowds.

**The sitting of the algebra.** The owner's fourth question: Alonzo began as a linear algebra visualizer; could it carry extensive linear algebra for the engine's transforms and for constraint satisfaction, the moon rather than the mud? The answer, `docs/ALGEBRA.md` §6 and §7: the frame is already an iterative solver, Jacobi being the synchronous frame and Gauss-Seidel the scan-order one; a transform is six cells; a physics contact solve and Cassowary's constraints are one simplex family; the Jacobian over the dependency graph is one projection that pays sensitivity, Newton's `GOAL`, the constraint Jacobian and the spectrum; a linear region of a frame is one sparse multiply, the fourth speed advantage; `OPTIMIZE` plus a simplex theory is an SMT solver; the eight-rung ladder and the three cracks, floating point, which crate, the cost of an LP solver. The owner declined their own phrase "under the hood" for the reframe and gave the file its thesis, everything exposed to the formula language. The file was written that night at the owner's word, under `docs/`, the first file there.

**The veto's reach.** The owner asked whether the `GENSYM` veto is valid outside Frazaro, `eval` feeling like a sacrifice. Found on the shelf that evening: the veto's text carries `eval` by its own words, "runtime-arbitrary-code-execution is the same wall's other, more obvious breach", kept permanently; and the expander lives in `vla-lang` since the cut, so the veto is the language's and binds the engine. The reading: the veto's reasons bind unevenly here, reproducibility not at all, the trace to a person fully, security weakly in a total and sandboxed formula language, and an unstated reason hardest, that every speed and algebra claim of the horizon is a static property of a fixed formula set. What the page already allowed is eval by a person, the REPL, `M-:` as a live `write`; what it never allowed is eval by the program. The rule that follows, the step computes values and never formulas, held by a test, became `SPEC.2`'s candidate `AD-7`, adopted at the approval the same evening; the Write sheet proposed under McCarthy's name was narrowed to values the same hour and the correction written into the horizon. Gensym's half is the cheap one: a macro naming fields under the caller's name is a record and not a gensym, and the prelude's loud-collision doctrine needs the loader to refuse a cell written twice, since cells are silent.

**The next step, and the gate.** Asked what to do next here, the session recommended `SPEC.2` first, the contract before the four calls are written against it, then `ENGINE.1`'s host half against a fake module with the Life cartridge and a static cartridge check as its fixture and the plane blit measured as the engine's second number; and named the gate, `KERNEL.7` and the four calls in Frazaro's tree, then the language crate's first publish. The owner sent the gate to the Frazaro session and opened `SPEC.2` here.

## 2026-10-10 — the annals, read for the frame

**The sitting of the annals.** The owner asked, as a meta-analysis, which concepts of computer science Alonzo should keep in mind for speed, monotonicity, extensibility and elegance without breaking its determinism, naming continuations, category theory, reflection and multiple dispatch, and anything else from the literature that would make it a beautiful engine to build on. The session's answer is `docs/ALGEBRA.md` §10, written the same day at the owner's word, under one rule: an idea may change speed or structure and never a value. In it: the budgeted step as a continuation kept as data, a save as the whole program's, and rollback play over the replay; a cartridge as a coalgebra, so that an accelerator's oracle is bisimulation searched with generated inputs, and the frame as the normal form of causal commutative arrows, which is why a patch costs nothing at run time; lenses for the view and the load; `AD-6` as the right reflection, with the rule that reflection is deterministic or invisible to formulas, and Halide's schedule as a possible sheet; multiple dispatch as the function library's, for specialization and the expression problem; abstract interpretation choosing bits for Life, DBSP's changes over Frazaro's incremental frame (`e128d3c`), exact rewrites only, staging and Futamura; monotone time, compatibility and lattices; effects and handlers, sheet-defined functions and `LET`; out of the tar pit and the frames as a scan; four determinism guardrails, each worth a check; and an order to take them in. None is an item.

**The entity-component reading.** Asked the same hour what the gaming crowd's reading meant: a sheet is an archetype table, a row an entity, a column a component and a shape a system, with the resources, events, change detection, schedule and pool beside them, what the reading gains and where it does not fit. `docs/ALGEBRA.md` §10.6.

## 2026-10-11 — the textbook opponent

**The sitting of the board games.** The owner asked for three cartridges, backgammon, chess and go, each with a deterministic opponent that codifies the printed training guides, a few heuristics, the top opening lines and a short lookahead, with abduction and without any statistical model, and invited pushback. The session's answer is `docs/ALGEBRA.md` §11, written the same night at the owner's word, under one rule: the opponent is cells. In it: a cartridge's formulas reach the language's fourteen functions and nothing else, so Frazaro's `PROLOG` reaches no game, `PORT.9` filing the engines in the core, while Datalog's half survives, rules as formulas and recursion one round a frame through the twin; lookahead as width and not depth, Shannon's Type B and Bernstein's seven plausible moves, with Chess 4.0's lesson beside them, so the opponent is to be legible and not strong; even backgammon's doubles a beam; backgammon first on BKG 9.8's precedent, chess with perft as its rules' oracle, go on nine by nine under Tromp and Taylor's rules; abduction in two places, the other side's threats read off what its move changed and the opponent's own move explained by the cone of its choice cell; the book's provenance and the weights as the honest cost of having no statistics; and the shape the three share, a Mind sheet of candidate rows and heuristic columns, each heuristic a template macro, shown beside the board in the panel's live sheet. The three were filed the same hour as `CART.6`, `CART.7` and `CART.8` and committed at the owner's word, `ccf8b7c`.

**The owner's answers, the same night.** The filing committed. No order yet: the owner weighs Sand, `CART.2`, for the engine mechanics the spreadsheet application needs, even if games are more fun in the short term, and decides after a day off. 0BSD for the three, free and open for the tinkerers, the sitting finding no argument for another licence and one caution, that a guide's facts are free and its prose is not, and that a copyleft program's sources and data files are never copied into a cartridge. And this record. `docs/ALGEBRA.md` §11.7.

# THE ITEMS, SCOPED

*Each open item's full account, written before it is built, as Frazaro's rear-view scopes an item: the substrate verified by reading, never assumed from a document; the work; the decisions that are the owner's, each with the sitting's recommendation and the alternative it declined; the catch; the oracle; the size as a prediction.*

## `REPO.1` — the skeleton, and the first commit

*Scoped 2026-10-08 at the owner's call, so that the foundation is laid by decision and not by default.*

**Substrate, verified.** Everything the skeleton copies exists in `Frazaro/` and was read on the day. `rust-toolchain.toml`: stable, the `wasm32-unknown-unknown` target, `clippy` and `rustfmt`, with its note on the msvc linker and the `-gnu` override. `.gitattributes`: LF stored for everything; `.rs`, the Cargo files and the toolchain file LF on checkout; `.vla` CRLF on checkout, because the reference's line reader needs it; `.wasm` binary. `.gitignore`: `target/`, the built page, the scratch folder, Excel's lock files; `Cargo.lock` committed, since a workspace with a binary commits it. The root `Cargo.toml`: a workspace with `resolver = "2"`, the package fields shared (`edition = "2021"`, `rust-version = "1.75"`, `license`, `repository`), an exact `=` pin on the sibling crate under `[workspace.dependencies]`, and a release profile of `panic = "abort"`, `lto = true`, `codegen-units = 1`, `opt-level = "s"`, `strip = true`, which is what keeps the wasm's import section empty of an unwinder. `core/Cargo.toml`: `crate-type = ["rlib", "cdylib"]`, `readme`, `keywords`, `categories`, the licence and the repository crates.io shows a visitor, held by `check_crate_package.ps1`. `LICENSE` (Apache-2.0's text), `LICENSES/` with the four texts REUSE needs, `NOTICE` naming the territories, `REUSE.toml` resolving every path to one identifier with later tables winning, `TRADEMARK.md` ("the code forks and the name does not, which is why this file exists on the same day as the licences"), `CONTRIBUTING.md` (DCO 1.1 by `git commit -s`, no CLA; inbound equals outbound, the table of territories; what a change needs; the seams). The checks: `tools/check_core_imports.ps1` takes `-Path` to any wasm and has a `-Control`, so it can read Alonzo's artifact before Alonzo's own twin exists; `run_checks.ps1` holds a hand-maintained floor on the count. CI: `checks.yml`, the ratchets on `windows-latest` under PowerShell 5.1 and the crate job on `ubuntu-latest` under `pwsh` with `dtolnay/rust-toolchain@stable`, the wasm built in release and kept as an artifact. The commit convention: `<ID>: <the claim, in plain English>`, the body with the defect and the fix, then `Pins:`, `Floors:` and `Docs:`; the owner's own commits carry no sign-off, the DCO being asked of contributors. The first publish of a crate is by hand from the owner's machine, Trusted Publishing after it (`DEPLOY.md`).

**The work.** The files below and one empty crate; nothing that runs.

| File | What it is | Copied, adapted, or decided |
|---|---|---|
| `LICENSE`, `LICENSES/Apache-2.0.txt`, `LICENSES/CC-BY-4.0.txt`, `LICENSES/0BSD.txt` | the texts | copied; the set is decision 2's |
| `NOTICE` | "Alonzo, Copyright 2026 <holder>", the territories in one paragraph | adapted; the holder is decision 1's |
| `REUSE.toml` | the engine, the documents and the cartridges resolved to identifiers | decision 2 |
| `TRADEMARK.md` | the name's policy, in Frazaro's shape | decision 3 |
| `README.md` | the charter's three sentences, what it is not, how to build, what the first release shows | adapted from `core/README.md`'s register |
| `CONTRIBUTING.md` | DCO; inbound equals outbound; what a change needs, a device or a cartridge, an oracle for every accelerator; the checks to run | adapted |
| `SECURITY.md` | how to report; the no-network rule and the allowlist as what a reviewer checks on the artifact | new, short; decision 9 |
| `.gitattributes`, `.gitignore`, `rust-toolchain.toml` | as Frazaro's, less the Excel lines | copied |
| `Cargo.toml` at the root | the workspace, one member, the shared fields, the release profile | decisions 4 to 6 |
| `engine/Cargo.toml`, `engine/src/lib.rs`, `engine/README.md` | the `alonzo` crate, empty, with its page | decisions 5 to 7 |
| `Cargo.lock` | written by the first build, committed | the copied rule |
| `CHARTER.md`, `ROADMAP.md`, `REARVIEW.md` | as they stand, living | nothing |

**The decisions, the owner's.** Each with the sitting's recommendation and the alternative it declined.

1. **The licence, and the holder.** Apache-2.0 for the engine, for the charter's four reasons (§9); the alternatives, `MIT OR Apache-2.0` and MPL-2.0, are weighed there. The copyright holder named in `NOTICE` and `REUSE.toml`: Spreadsheet Company, as Frazaro's, or the owner's own name. One line, the owner's.
2. **The territories.** Three: Apache-2.0 for the engine (`engine/**`, `web/**`, `tools/**`, the Cargo and toolchain files, `REUSE.toml`, `.gitignore`); CC-BY-4.0 for the documents (`*.md` at the root, and `docs/**` if it comes); 0BSD for the cartridges (`cartridges/**`), the house's own terms for what is made to be copied, as Frazaro's `examples/` are, since Life is the demo a stranger copies to start a cartridge of their own. The alternative is two territories, the cartridges under the engine's Apache-2.0: one text fewer, and a NOTICE obligation on every copied cartridge. Recommended: three. The analogue of `OUTPUT-EXCEPTION.md`, a game's own terms, is written the day the first game ships (§9), not here.
3. **The name.** A `TRADEMARK.md` in Frazaro's shape on the same day as the licence, for Frazaro's own reason: the code forks and the name does not. It says what may be done without asking (say "built on Alonzo"; keep the crate's name as a dependency) and that a fork of the engine takes another name. "Alonzo" is a given name and a weaker mark than a coined word, which the file need not pretend otherwise; the policy is still worth stating. Recommended: yes, short. If the owner declines, the charter's "the name is the owner's" stands alone.
4. **The home.** `Spreadsheet-Company/Alonzo` beside Frazaro, so that the crate's `repository` field, the sibling crate's and §6's count all read one organization; or a repository under the owner's own account. Recommended: the organization. The remote is the owner's to create, and nothing is pushed until the owner says.
5. **The layout.** A workspace at the root with one member, `engine/`, holding the `alonzo` crate, mirroring Frazaro's `core/` and `cli/`: the frame floors (`CART.1`) need a headless native runner that steps a cartridge and times it in CI with no browser, that runner is a second crate, and a workspace from the first commit costs nothing and spares the move. Beside it, when their items come: `web/` (the host shim as a template and the build script that writes one HTML file, no `fetch`), `cartridges/` (Life first), `tools/` (the checks and the builders). The four governance documents stay at the root, as Frazaro keeps its own; `docs/` is made the day a long document needs it. The alternative is the crate at the root, one level flatter, and a move the day the runner comes. Recommended: the workspace.
6. **The manifest.** `name = "alonzo"`. `version = "0.1.0"`, Alonzo's own line and not the corpus's, since the engine is not an implementation of the language, and `vla-lang` will be pinned exactly when it is a dependency. `edition = "2021"` and `rust-version = "1.75"`, matching `frazaro-core` and so `vla-lang`, so that the three crates build under one toolchain. `license = "Apache-2.0"`; `repository` from decision 4; `description`; `readme = "README.md"`, the crate's page in `engine/`, written for a first-time visitor on crates.io as `core/README.md` is; `keywords` (`wasm`, `game-engine`, `spreadsheet`, `lisp`, `cellular-automaton`) and `categories` (`game-engines`, `wasm`). `crate-type = ["rlib", "cdylib"]`. `[dependencies]` empty until `ENGINE.1`. `publish = false` until the first release and removed as a step of it, so that no rehearsal can upload an engine that renders nothing. The alternative on the edition is 2024, which buys nothing here and costs the match. Recommended as stated.
7. **Imports by hand, no generated glue.** The engine's imports are `extern "C"` functions the host shim provides, named one by one (a blit, a note, the input and clock writes, the file read), and the crate depends on `vla-lang` and nothing else, as `frazaro-core` depends on nothing and names its C surface by hand in `abi.rs`. The alternative is `wasm-bindgen` with `web-sys`, which writes the canvas and audio calls faster and costs the thing `REPO.2` exists for: dozens of `__wbindgen_*` imports and a generated JavaScript file, so that the allowlist reads a toolchain's names rather than the host's and the shim is generated rather than read. Recommended: by hand. This is a candidate standing decision, `AD-5`, for the owner to bless or decline: *the engine's imports are the host's functions, named by hand and held to a list; the engine crate depends on the language crate and nothing else.*
8. **The first commit.** Everything above and the three living documents, as `REPO.1: the skeleton, and the first commit`, with `Pins:` (the empty crate builds for wasm32 with zero imports), `Floors:` (none yet) and `Docs:` (the three), made by the owner. The documents stay living after it; the owner freezes them by a dated line when the repository has formed, not by the commit.
9. **A `SECURITY.md`.** A dozen lines: how to report, privately; the no-network rule (`SD-13` across the road) and `REPO.2`'s allowlist as what a reviewer checks on the artifact rather than takes on faith; the threat model deferred to the day the engine runs a stranger's cartridge. GitHub shows the file on the repository's security tab. Recommended: yes, since it costs an hour and says the one thing an IT reviewer asks first. The owner may fold it into `README.md` instead.

**The catch.** Five traps, each met once already in Frazaro. A PowerShell 5.1 script saved without a byte-order mark is read as ANSI, so `REPO.2`'s scripts are ASCII or carry the mark. Line endings are measured with `tr` or PowerShell and never with `grep`, which normalizes them. A `cargo build` for `wasm32-unknown-unknown` of an empty `cdylib` succeeds and writes a module with no exports and no imports, which is the oracle and not a mistake. The msvc linker needs the Visual Studio C++ build tools, present on the owner's machine, and `cargo` is called by its full path where the shell lacks `~\.cargo\bin`. A path dependency on `../Frazaro/vla-lang` works on the owner's machine and not in CI, so `ENGINE.1`'s CI waits for the cut's first publish, Frazaro's next release.

**Oracle.** On the empty crate: `cargo build --workspace`, `cargo fmt --all -- --check`, `cargo clippy --workspace --all-targets -- -D warnings`, `cargo test --workspace`, and `cargo build --release -p alonzo --target wasm32-unknown-unknown`; then Frazaro's `tools/check_core_imports.ps1 -Path target/wasm32-unknown-unknown/release/alonzo.wasm` printing zero imports, the stopgap until `REPO.2`'s twin exists; and `git status` clean after the commit.

**Size.** `~days`, of which the writing is hours and the rest is the owner's calls and the commit. (*prediction*)

*Built 2026-10-08, awaiting the owner's test and commit.* The owner approved all nine recommendations and adopted `AD-5`, which became the charter's fifth rule the same hour. What landed: `LICENSE` and `LICENSES/` (Apache-2.0, CC-BY-4.0, 0BSD, copied from Frazaro); `NOTICE`; `REUSE.toml` with the three territories; `TRADEMARK.md`; `README.md` and `engine/README.md`, each written for a first-time visitor; `CONTRIBUTING.md`; `SECURITY.md`; `.gitattributes`, `.gitignore` and `rust-toolchain.toml` in Frazaro's shape; the workspace `Cargo.toml` with one member and the release profile; `engine/Cargo.toml` (`alonzo` 0.1.0, edition 2021, Rust 1.75, `publish = false`, `rlib` and `cdylib`, no dependency) and `engine/src/lib.rs`, a doc comment and no code; `Cargo.lock`, written by the first build. The oracle, run on the day on the owner's machine (cargo 1.99.0, stable, the msvc linker): `cargo build --workspace`, `cargo fmt --all -- --check`, `cargo clippy --workspace --all-targets -- -D warnings` and `cargo test --workspace` clean; `cargo build --release -p alonzo --target wasm32-unknown-unknown` wrote a module of 32 bytes; Frazaro's `check_core_imports.ps1 -Path` on it reported an empty import section, 0 imports, exit 0 (*measurement*). The size was as predicted, hours of writing. The owner's calls stand as made: Apache-2.0 with Spreadsheet Company as the holder, `Spreadsheet-Company/Alonzo` as the home, and the first commit, which is the owner's to make. *Committed 2026-10-08 at the owner's word, `2728312`, the root commit, 21 files.* *Closed 2026-10-08 at the owner's word, the last clause of its oracle met the same day: `REPO.2`'s check green on it at zero imports.*

## `REPO.2` — the import allowlist check

*Scoped 2026-10-08, after `REPO.1`'s commit and before the first import exists, so that the day `SPEC.1` names one it is held to a list from its first build.*

**Substrate, verified.** Everything the item copies was read on the day, by file and never by assumption.

- *The twin.* `Frazaro/tools/check_core_imports.ps1`, 134 lines, LF, no byte-order mark, ASCII throughout (*measurement*, the first bytes and `tr`). The reader: the magic `\0asm` and version 1, then sections of an id byte, a LEB128 size and a payload, walked by size; id 2 is the import section, its payload a LEB128 count and then entries of a module name, a field name, a kind byte and that kind's description, a function's type index, a table's element type and limits, a memory's limits, a global's value type and mutability; an unknown kind stops the walk and keeps the count, the unparsed entries named as such. Every name is printed as `module.field (kind)` when the count is wrong, so a failure says what was imported. `-Path` reads any module; with no `-Path` and no artifact at `target/wasm32-unknown-unknown/release/frazaro_core.wasm` it prints SKIPPED and exits 0, since a check that fails on every machine without cargo is ignored on all of them, and CI, which always has the artifact, is where the pin bites. `-Control` proves the reader on two modules built in memory, the eight-byte header alone (0 imports) and the header with an import section naming `a.b` as a function of type 0 (1 import, named). Run on the day against Alonzo's artifact with `-Path`: `OK ... (32 bytes, 0 imports)`, exit 0; its control green (*measurement*, 2026-10-08).
- *The artifact.* `target/wasm32-unknown-unknown/release/alonzo.wasm`, 32 bytes, `REPO.1`'s build: the header, a table section (id 4), a memory section (id 5) and an export section (id 7) exporting `memory`, and no import section at all (*measurement*, the bytes dumped). "Zero imports" on the empty crate is the absence of the section; the reader's arm for id 2 is never entered, which is why the control's in-memory modules, and not the artifact, are what prove the arm.
- *The runner.* `Frazaro/tools/run_checks.ps1`, 245 lines: globs `check_*.ps1` in its own folder and skips itself by name; runs each under `powershell.exe -NoProfile -ExecutionPolicy Bypass -File` with `$ErrorActionPreference` set to Continue around the call, since under Stop a child's stderr line terminates the runner before the total prints; one line a check with its seconds; the failing checks' last twenty lines; `-Filter`, `-ShowAll`, `-WithExtras` over a hand-maintained list of the other verifiers with their arguments (the controls among them, `check_core_imports.ps1 -Control` the last); `-ToolsDir`, so the runner can be pointed at a broken folder and shown red; and the floor, `$expectedAtLeast`, 52 today, hand-maintained with a dated line per raise, compared against the count found, a filtered run exempt. It names `powershell.exe`, so as written it cannot run on the ubuntu job.
- *The licence check.* `Frazaro/tools/check_spdx.ps1`, 148 lines, no `-Control`: parses the subset of `REUSE.toml` the project writes, `[[annotations]]` tables with `path` as a list or one string and the identifier, later tables winning; every identifier has `LICENSES/<id>.txt`; every tracked file (`git ls-files`) whose extension is in a hardcoded list resolves to one licence through a glob-to-regex (`**/` any depth, `**` anything, `*` within a segment); the load-bearing in-file headers, a hand-kept list, in the first twelve lines and agreeing with the map, the 0BSD runtime module's above its inject boundary. Frazaro's Rust sources carry no SPDX header, none of them (*measurement*), so a Rust file's licence is the map's alone.
- *CI.* `Frazaro/.github/workflows/checks.yml`, 103 lines: `on` push to `main` and `pull_request`; the `ratchets` job on `windows-latest`, `shell: pwsh` driving `& powershell -NoProfile -ExecutionPolicy Bypass -File` over every `check_*.ps1` sorted, each in a `::group::`, so the checks themselves run under Windows PowerShell 5.1; the `core` job on `ubuntu-latest`, `dtolnay/rust-toolchain@stable` with `targets: wasm32-unknown-unknown` and `components: clippy, rustfmt`, then `cargo build --workspace`, `cargo fmt --all -- --check`, `cargo clippy --workspace --all-targets -- -D warnings`, `cargo test --workspace`, the wasm release build, the import check and the goldens' checks under `pwsh -NoProfile -File`, and `actions/upload-artifact@v4` keeping the wasm and the page.
- *The map.* Alonzo's `REUSE.toml`: three territories, the engine's Apache-2.0 over `engine/**`, `web/**`, `tools/**`, the Cargo and toolchain files, the map, `.gitignore`, `.gitattributes` and `.github/**`; 0BSD over `cartridges/**`; CC-BY-4.0 over `*.md`, `docs/**` and `NOTICE`; and its own comment promising `tools/check_spdx.ps1` at `REPO.2`. Every one of the 21 tracked files resolves to one of the three by hand today: the seven root documents and `NOTICE` to CC-BY-4.0; the nine engine files to Apache-2.0, `engine/README.md` among them, since `*` does not cross a `/` in the specification's globs or in Frazaro's converter and `engine/**` is its only match, the crate's page staying with the crate as the map's comment says; `LICENSE` and the three texts under `LICENSES/` outside the check, as in Frazaro.
- *The promises.* `SECURITY.md`: the check reads the section, holds it to an allowlist written in the script and fails on any other, `fetch` first among them, on every push; "until it exists" Frazaro's check with `-Path` must print zero. `CONTRIBUTING.md`: a device's name is added to the allowlist the check holds, the list grows by a reviewed line and never a generated one; run `tools/run_checks.ps1`, one line a check and one total, before a pull request; "until it exists" the cargo oracle. `README.md`: the section read on every push and held to a list, today zero. `Cargo.toml`'s comment and `engine/Cargo.toml`'s: the check named, the stopgap named. `REUSE.toml`'s comment: the licence check at `REPO.2`. Each "until it exists" retires with the item.
- *The house style for a check*, from the Frazaro memory and the three newest checks read on the day (`check_kernel_boundary.ps1`, `check_distro.ps1`, `check_study_fixture.ps1`): PowerShell 5.1, host-free, a hardcoded and reviewable baseline that pins how many; `-Control` first, on a scratch copy or in memory, the clean case passing and each mutant proving it applied before it is asked to fail, a green mutant an alarm; `return ,$list` from every function returning a collection and no `Write-Output` inside a function whose value a caller reads; a native tool run without `2>&1` under Stop; a `.ps1` saved ASCII or with a byte-order mark (Frazaro's are ASCII, no mark, LF); line endings measured with `tr` or a byte read, never grep; a script written with the Write tool, never a heredoc.
- *The machine.* Windows PowerShell 5.1.26100; no `pwsh` installed (`where.exe` and `winget` both say so); cargo and rustc 1.99.0 stable, the msvc linker, the wasm target installed; `gh` 2.100.0; no node and no wasm tooling, so the only writer of an import section on this machine other than the control's own bytes is the Rust toolchain. The remote `Spreadsheet-Company/Alonzo` exists, public, `main` pushed to `36f62bb` at the owner's word, so `checks.yml` runs on the owner's next push. The Rust rule the oracle leans on: an `extern "C"` block on `wasm32-unknown-unknown` imports from module `env` unless `#[link(wasm_import_module = "...")]` names another, and an import nothing calls is dropped by the linker; both to be confirmed by the oracle's scratch crate before the check's messages assume them.

**The work.** Four scripts and a workflow, and the promises kept.

| File | What it is | Copied, adapted, or decided |
|---|---|---|
| `tools/check_host_imports.ps1` | the twin's reader arm for arm; the forbidden list first, the allowlist and its count beside it; `-Path`; SKIPPED with exit 0 when no artifact and no `-Path`; every import printed on failure; `-Control` on modules built in memory | adapted; decisions 1 to 4 |
| `tools/check_spdx.ps1` | the map parsed, every tracked file resolved, every identifier's text, the cartridge header rule; `-Control` on a scratch tree | adapted; decision 5 |
| `tools/run_checks.ps1` | the runner, the floor at 2, the two controls as its extras; `pwsh` where `powershell.exe` is absent | adapted; decision 6 |
| `.github/workflows/checks.yml` | `ratchets` on `windows-latest` under 5.1; `crate` on `ubuntu-latest`: build, fmt, clippy, test, the wasm release build, the checks under pwsh, the wasm kept | adapted; decisions 7 and 8 |
| `SECURITY.md`, `CONTRIBUTING.md`, `Cargo.toml`, `REUSE.toml` | the "until it exists" sentences retired, the present tense | the promises kept |
| `ROADMAP.md`, `REARVIEW.md`, `Delta/CLAUDE.md`, the memory | 🟡 and what landed | nothing new |

**The decisions, the owner's.** Each with the sitting's recommendation and the alternative it declined.

1. **The import naming convention.** One module name for every host function, so that an entry reads `module.field` and the allowlist is a list of such pairs. Rust's default module for an `extern "C"` block is `env`, which is also where Emscripten and every toolchain's glue put theirs, so an allowlist over `env.*` could not tell a hand-declared import from a stranger's by its module. Recommended: `alonzo`, declared once as `#[link(wasm_import_module = "alonzo")]` on the engine's one `extern "C"` block, so that the shim's import object reads `{ alonzo: { ... } }`, every entry reads `alonzo.<function>`, and `TRADEMARK.md` already lets a fork keep the names the engine defines. Alternatives: `host`, the charter's own phrase, literal and a shade less distinctive; `env`, the default, no annotation, declined for the reason above; a module per device, `screen.blit`, `audio.note`, which reads as the device list and hands `SPEC.1` five names to own instead of one. The check compares pairs and takes any convention; the convention is the owner's and `SPEC.1` writes it down. `SPEC.1` owns the field names, so the list is empty today and the count must be zero. An unknown `env.*` import is also told, in its own failure line, that an `extern` block lacks its `#[link]`.
2. **Where the list lives.** In the script, hardcoded, in the house's style: the allowlist is a baseline, and the manual edit under review is the friction `CONTRIBUTING.md` promises, a line added by a reviewer and never by a generator. The alternative is a data file, or `SPEC.md`'s table read by the script, which would hold the two to each other at the cost of letting a document edit widen the allowlist, the opposite of the friction wanted. Recommended: in the script; `SPEC.1`'s page lists the same names in prose, and a check holding the two equal is `SPEC.1`'s to add if the owner wants it.
3. **The forbidden list, named first.** Names that fail even when listed, so that no reviewed line can admit one, and whose failure line says *forbidden* and why rather than *unknown*: the network, first, `fetch`, `WebSocket`, `XMLHttpRequest`, `EventSource`, `sendBeacon`, `WebTransport`, `RTCPeerConnection` and `RTCDataChannel`, and anything that opens a socket, `socket`, `sock_` (WASI's socket calls) and `connect`, matched as case-folded substrings of `module.field`, so `prefetch` and `websocket` fall with them; second, any module whose name begins `wasi`, since a WASI import means the module was built for a system interface and could reach the clock, the file system or a socket through it, and the engine is built for `wasm32-unknown-unknown`; third, `__wbindgen` and the `wbg` module, the names generated glue writes into the section, which is `AD-5`'s pin on the artifact. Recommended: all three families, the network names first and `fetch` first among them. The alternative is the network names alone, with WASI and glue failing only as unknown names: the same exit code, a weaker message, and a reviewed line could admit them.
4. **The count beside the list, and equality.** The twin pins `$expectedImports = 0`. Here the section must equal the list exactly: every import listed, every listed name imported, and the count pinned beside the list as the twin pins it, 0 today, raised in the same commit as the line it counts, two statements of one fact and both under review. The reason for equality and not a subset is the linker: an import nothing calls is dropped from the section, so a listed name that is not imported is a declaration the code no longer takes, a dormant line nobody reviews again, and it should fail as *missing* until it is removed or called. Recommended: equality. The alternative is the subset rule, every import listed and nothing more, which is what the twin's shape gives for free and which lets the list carry dead names.
5. **`check_spdx.ps1` lands now**, as `REUSE.toml` promises, adapted to the three territories. Every tracked file except `LICENSE` and `LICENSES/*` must resolve to one identifier, not only those of a listed extension: the tree is 21 files and every one is covered today, the REUSE specification's own lint asks for every file, and a file at a new path then fails until the map names it, which is the review the map wants. Every identifier's text is in `LICENSES/`. The load-bearing header is a territory rule and not a per-file list: every file under `cartridges/` carries `SPDX-License-Identifier: 0BSD` in its first twelve lines (`;` for a `.vla`), since a cartridge is made to be copied and the notice travels with the copy, as the 0BSD runtime module's does in Frazaro; vacuous today, it bites at `CART.1`. Rust sources carry no header, as Frazaro's do not. `-Control` on a scratch tree with a synthetic file list, so it needs no repository: the clean copy passes; a file at an unmapped path fails; a licence text removed fails; a cartridge without its header fails. Recommended: now. The alternative is to defer it to `CART.1`, the first day a second territory holds a file, since today the map can be checked by eye; declined because the promise is dated to this item, the check is small, and a runner with one check has no floor worth the name.
6. **The runner.** Frazaro's shape, the floor at 2 with its dated line, the two controls as its `-WithExtras` list, `-Filter`, `-ShowAll` and `-ToolsDir` as they are; one adaptation of four lines: each check runs under `powershell.exe` where that exists and under `pwsh` where it does not, the shell named in the output, so the same runner serves the ubuntu job and the oracle's "under both" is one invocation per shell. The alternative is Frazaro's runner verbatim, Windows only, with the ubuntu job calling the check by hand as Frazaro's does. Recommended: the adaptation.
7. **CI's shape.** `ratchets` on `windows-latest` as one step, `powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_checks.ps1 -WithExtras`, so the floor and the controls run in CI too, where Frazaro's job loops the checks by hand and its floor runs only on a developer's machine; with no cargo on that job the import check says SKIPPED, as Frazaro's does, and the `crate` job is where it bites. `crate` on `ubuntu-latest`: `dtolnay/rust-toolchain@stable` with the wasm target, clippy and rustfmt; `cargo build --workspace`, `cargo fmt --all -- --check`, `cargo clippy --workspace --all-targets -- -D warnings`, `cargo test --workspace`; `cargo build --release -p alonzo --target wasm32-unknown-unknown`; `pwsh -NoProfile -File tools/run_checks.ps1 -WithExtras`, the import check on the artifact and both controls under pwsh 7; `actions/upload-artifact@v4` keeping `alonzo.wasm`. Triggers as Frazaro's, a push to `main` and every pull request. The alternative is Frazaro's file with the names changed. Recommended as stated.
8. **The pwsh half of the oracle.** There is no `pwsh` on the owner's machine, so the check's run under PowerShell 7 happens on the ubuntu job at the owner's next push, or locally after the owner installs PowerShell 7 (`winget install Microsoft.PowerShell`), which is the owner's call and not the session's. Recommended: the session verifies 5.1 locally and writes nothing that differs between the two shells (the one such difference, the executable's name, is decision 6's), and CI is the pwsh half; the owner installs pwsh only if they want the half local.

**The catch.** Seven, each met once in Frazaro or found on the day.
- An import nothing calls is dropped by the linker, so the oracle's scratch module must export a function that calls its import, and the engine's section can lag its declarations; decision 4's equality is what makes the lag visible.
- The reader walks sections by size and validates nothing: it counts the entries of a module a browser would refuse, and an unknown kind stops the entry walk and keeps the count, the twin's rule, copied with its message.
- `#[link(wasm_import_module = "...")]` binds one `extern` block; a second block without it imports from `env` and fails as an unknown module, and the failure line says why.
- PowerShell 5.1: `return ,$list`; no `Write-Output` inside a function whose value the caller reads; Continue around the child process; ASCII only, measured by a scan for bytes over 0x7F after writing; LF and no byte-order mark, as the twins are; the Write tool and never a heredoc.
- `git ls-files` needs the repository; the licence check's control takes a synthetic list and needs none.
- On `windows-latest` both shells exist, `powershell` 5.1 and `pwsh` 7; on `ubuntu-latest` only `pwsh`; on the owner's machine only `powershell` today.
- A commit message passed with `-m` under PowerShell 5.1 must hold no double quotes, or be passed with `-F` (met 2026-10-08).

**Oracle.** On the empty crate, under 5.1 on the owner's machine and under pwsh 7 on the ubuntu job:
- `cargo build --release -p alonzo --target wasm32-unknown-unknown`, then `powershell -File tools\check_host_imports.ps1` prints OK, 0 imports against an empty list, exit 0; with the artifact absent and no `-Path`, SKIPPED and exit 0.
- `-Control`, on modules built in memory, each a valid module (a type section with one signature, then the import section): the empty module passes against the empty list; a module importing `alonzo.blit` fails against the empty list and passes once `alonzo.blit` is listed and the count is 1; `alonzo.fetch` fails as forbidden even when listed; `wasi_snapshot_preview1.sock_accept` and `__wbindgen_placeholder__.__wbindgen_throw` fail as forbidden; `alonzo.other` against a list of `alonzo.blit` fails twice, the unknown name and the missing one; `env.blit` fails as unknown with the `#[link]` hint. Each mutant proves it applied: the reader names the import it was built with before the judgment is asked.
- Beyond the twin's bytes: a scratch crate in the scratchpad, one `extern "C"` import under `#[link(wasm_import_module = "alonzo")]` and an exported function that calls it, built for `wasm32-unknown-unknown` in release; `-Path` on it prints `alonzo.<name> (func)` and fails against the empty list; the same crate without the attribute prints `env.<name> (func)`. This proves the reader on a section the Rust toolchain wrote, the one independent writer on the machine, and confirms the two Rust rules the catch leans on.
- `check_spdx.ps1` OK on the tree, every tracked file resolved, three identifiers with texts; `-Control` green, the clean copy and three mutants.
- `run_checks.ps1`: 2 checks, 2 passed, floor met, `ALL GREEN`; `-WithExtras` 2 of 2; `-ToolsDir` on a scratch copy with one check removed trips the floor and exits 1.
- `checks.yml` read beside Frazaro's step for step; its first run is the owner's next push, which this session does not make.
- `git status` showing only the files in the table.

**Size.** `~days`, of which the writing is hours and the rest the owner's calls, the push and the first CI run. (*prediction*)

*Built 2026-10-08; owner-tested and closed the same day.* The owner approved all eight recommendations. What landed: `tools/check_host_imports.ps1` (the twin's reader arm for arm, one record per import; the forbidden list first, fourteen case-folded patterns in three families, each with the reason it gives; the allowlist, empty, and `$expectedImports = 0` beside it, the two held equal; the judgment in order, forbidden, unknown, missing, the count, an `env` import told what it means; `-Path`, and a `-Path` that names no file failing rather than skipping; SKIPPED with exit 0 only when there is no artifact and no `-Path`; every import printed on failure; `-Control` on twelve modules built in memory, each a valid module with a type section, every mutant proving it applied by the names the reader reads back before the judgment is asked, then an import of an unknown kind and bytes that are not a module); `tools/check_spdx.ps1` (every tracked file but the licence texts resolved through the map by `-cmatch` on the specification's globs, every identifier's text, the `cartridges/` header rule over eleven text extensions, a failed `git ls-files` refused; `-Control` on a scratch tree with a synthetic file list, the clean copy and four mutants, each asserting it applied); `tools/run_checks.ps1` (Frazaro's shape, the floor at 2 with its dated line, the two controls as extras, the shell chosen and named in the header); `.github/workflows/checks.yml` (the two jobs of decision 7); the promises kept in `SECURITY.md`, `CONTRIBUTING.md`, `Cargo.toml`, `REUSE.toml` and `README.md`'s table. The oracle, run on the day on the owner's machine under Windows PowerShell 5.1.26100 (*measurement*): the artifact OK, 32 bytes, 0 imports, pinned at 0; the control's twelve cases, the unknown kind and the non-module as the header says; `check_spdx.ps1` OK, 17 tracked files resolved (Apache-2.0 9, CC-BY-4.0 8), its control green; `run_checks.ps1 -WithExtras` 2 checks and 2 verifiers, `ALL GREEN`, and `-ToolsDir` on a scratch folder with one check removed tripping the floor, exit 1; the scratch crate with one import under `#[link(wasm_import_module = "alonzo")]` built to 84 bytes and read as `alonzo.blit (func)` by this check and by Frazaro's twin alike, failing against the empty list as unknown and count. The catch's two Rust rules were put to the scratch crate. The second held: an import nothing calls is dropped, a 58-byte module with no import section. The first did not, and it is the item's one correction to its scoping: on rustc 1.99.0 an `extern "C"` block without `#[link(wasm_import_module = ...)]` does not link at all (`rust-lld: undefined symbol: blit`), so `env` is not a silent default the engine could fall into but the catch-all module of C glue and toolchains, and the check's hint on an `env` import says so instead of blaming a missing attribute. The pwsh half of the oracle is the ubuntu job's at the owner's push, as decision 8 said. The size was as predicted, hours of writing. *Owner-tested 2026-10-08: `run_checks.ps1 -WithExtras`, 2 checks and 2 verifiers, `ALL GREEN`, the licence control at 0.4 s. Closed at the owner's word and committed, `5bf66e6`.* *Pushed 2026-10-08 at the owner's word, `36f62bb..2ea5999`, with `SPEC.1`'s three commits and the benchmark's second run; the first run of `checks.yml`, `37803504536` on `2ea5999` (*measurement*): `ratchets` on `windows-latest`, the runner under Windows PowerShell 5.1 with its floor and both controls, success; `crate` on `ubuntu-latest`, the workspace built, format-checked, linted and tested, the wasm built, the runner under pwsh with the import check on the artifact and both controls, success, `alonzo.wasm` kept. So the check ran under both shells, the pwsh half of the oracle is met, and the item's record is whole. The run's only annotations are the platform's: the two first-party actions target Node 20 and are run on 24 until their next releases are taken, and `ubuntu-latest` becomes Ubuntu 26 from 2026-10-19.*

## `CART.4` — a stacking game in Stacker's shape

*Filed and scoped 2026-10-08, the owner's favourite; built after `ENGINE.4`.*

**Substrate, verified.** The cabinet's rules, from the encyclopedia's article read on the day (the charter's §10): LAI Games, 2004; fifteen rows; a row of three blocks sliding side to side, faster on each row; the button stops it; blocks not above the row beneath are removed and a complete miss ends the game; two blocks from level four and one from level ten; the minor prize at eleven rows, the major at fifteen; the regular setting's win ratio about one in eight hundred and the Mega cabinet's one in fifteen hundred, through a success window the operator's manual describes while calling the game one of skill. In the engine: the two-buffer frame (the charter's §4), which gives a button's rising edge as this frame's cell against last frame's, and a frozen row as a cell holding its own last value; and the devices the roadmap lays, Input and Clock (`ENGINE.3`) and Audio (`ENGINE.4`).

**The work.** The cells, as the roadmap's entry lays them: a Board, a State and a Speed sheet, the Input button, the Clock, the Audio cells; about twenty formulas. And a replay: the Input sheet recorded frame by frame as a sheet of its own, played back by the loop in place of the live button, so that a game is reproducible from its replay and a golden Board can be held at its end.

**The decisions, the owner's.** The name, since Stacker is LAI Games' product name and the cartridge takes its own, as the falling-block game does. The width, the cabinet's seven or another. Whether the minor prize is a stop the player may take, as the cabinet offers, or a light alone. The orientation, the owner's thought of 2026-10-08: the cabinet's grid is tall because a cabinet is, and a monitor is wide; an Orientation cell that the Screen formulas read, so that the stack grows upward or sideways by a transpose, costs a cell and nothing in the rule. Recommended, as a cell of the cartridge rather than an option of the Screen device, so that the engine stays small (rule 3's spirit). It is not scope creep while it is a transpose, and it would become so the day it changed the rule.

**The catch.** The speed must be a formula of the row and not a lookup into a table until `KERNEL.8` lands the lookups. A one-button game tempts a hold-to-repeat, and the rising edge is the rule. The window the cabinet hides is here a cell, and that is the point: a cartridge's difficulty is read, not suspected.

**Oracle.** The replay golden: a recorded Input sheet and the Board it ends in, compared whole; `tools/check_cartridge_replays.ps1` in the house's shape, one line a cartridge, the shape every cartridge with input takes after this one.

*Noted 2026-10-10 by `ENGINE.3`'s second slice (decisions 7, 8 and 11 of its scoping, below):* the recorder and the player are the host's. A replay is `SPEC.md` §7.6's rows, the Input sheet's cells that changed and each person's edit that landed, in its frame, not "the Input sheet recorded frame by frame as a sheet of its own": such a sheet would carry no person's edit, and its loader would be a second reader of the same facts. This item records a game in the page and commits its replay and its golden beside the cartridge, `<name>.replay.vla` and `<name>.golden.vla`, with their two places in the page. `tools/check_cartridge.ps1` reads them, and the loop oracle's `replay` case plays every committed replay to its golden on the module. `tools/check_cartridge_replays.ps1` is not written.

**Size.** `~days` after `ENGINE.4`. (*prediction*)

## `SPEC.1` — the page: the device sheets and the four calls

*Scoped and drafted 2026-10-08, in tandem with `REPO.2`'s build in the same tree, since the two share no file but the roadmap and this record: `REPO.2` holds the allowlist empty until this page names the host's functions, and this page names none (decision 1), so the two meet at a count of zero. The owner's two notes during the drafting, that the cell is the basic unit of the engine and that reflection over the whole stack is to be sanctified, became the page's §1 and §9.*

**Substrate, verified.** Read by file on the day, never assumed from a document. `core/src/abi.rs` (972 lines): the record, four little-endian `u32` then the id and the text; status 0, 1 and 2; the allocator pair; `frazaro_build_xlsx` as the one record whose text is bytes; `frazaro_view`'s inputs, the sheet and the window as text, empty for the extent; `frazaro_abi_version` staying 1 while exports are added. `core/src/view.rs` (692): the `Grid` projection and its sink of lines; `window_of`'s two refusals; `view_text`; the free oracle against `reflect`. `core/src/kernel.rs` (291): the five seams as data, `Projection` over a `Window`, `HostProfile`. `core/src/sheet/mod.rs` (588): the model, `Content` with the shared master and children, `A1Range`, `MAX_ROW` and `MAX_COLUMN`, `find_sheet` without case, `set_formula` filling a range as Excel fills one. `core/src/distro.rs` (551): the manifest reader, one form, every defect refused as `distro-manifest-invalid` with what is wrong, the name's shape, `#rrggbb` shades, the paths checked and never resolved. `core/src/refers.rs`, `sheet_needs_quotes`: quotes for a character outside letters, digits, `_` and `.`, a leading digit or a reference-shaped name, the owner's pass of 2026-10-04, which is what lets `Screen.last!B2` stand unquoted. `core/src/reflect/mod.rs` and `print.rs`: `Row`, `Value` (a number as the file's text, text, a truth value, an error, a date) and `Visibility` with its three words. `conformance/README.md`, oracle 11 (lines 977 to 1072): the record's order and spelling, the free oracle, the command. `web/CALLOSUM.md` §7: decision 1, "no model handle in the module's memory", with its own escape hatch, "taken only when a measurement at real sizes says so", and decision 8, the local folder and the picker. `web/index.template.html` (lines 170 to 270, 530 to 560): the page's `putBytes`, `readRecord` and `call`, a fresh view over `memory.buffer` at every read, `instantiate` with an empty import object, the ABI number refused when wrong. `docs/BETA_ROADMAP.md`: `KERNEL.5` (canvas, 4,641 cells with text at 60 Hz, *measurement*), `KERNEL.7` (the subset's floor, the cycle refused by name), `KERNEL.8` (lookups, spills), `KERNEL.12` (projections as a seam, a contributor's third implementation), `KERNEL.20` (vectorized evaluation of a shared formula). `distros/english/distro.vla` and its README, the manifest's shape and the folder's terms per kind. This repository: `CHARTER.md` §2 to §8, `ROADMAP.md`'s `SPEC.1` entry with its five decisions, `REPO.2`'s scoping (decision 1, the module name `alonzo`; decision 2, the list in the script and a check holding the page to it as `SPEC.1`'s to add; decision 5, the 0BSD header rule over `cartridges/`), `CART.4`'s scoping (the rising edge through the two buffers, the replay oracle). The outside facts, each read on the day and listed in `SPEC.md` §14: Varvara's device ports and vectors; TIC-80's memory map, the palette at `0x3FC0` and the input registers at `0xFF80`; PICO-8's `_update` at 30 and 60, `btnp`'s repeat, `pal`; Fiedler's accumulator and its 0.25 s cap; MDN on `Memory.grow` detaching the buffer, on `KeyboardEvent.code` against `key`, on the Page Visibility API; Wilson's audio-clock scheduling; the Doom demo as a per-tic input log replayed by the same version; Park and Miller's minimal standard; WebAssembly's nondeterminism note (NaN payloads alone); the CGA's sixteen colours and the EGA's 320 by 200 in sixteen; Excel's iterative calculation (100 iterations, 0.001, converge, diverge or alternate) and its sheet-name rules; ICAEW's tenth principle.

**The work.** One document, `SPEC.md` at the root, under the map's `*.md` rule (CC-BY-4.0), in the charter's register and marks; the roadmap's line and this record; a row in `README.md`'s table; the map's line in `Delta/CLAUDE.md`. No code: the item's oracle is the tests the `vla-lang` cut and `ENGINE.2` write from the page, and the crate stays empty, so `REPO.2`'s oracle on it is untouched.

| Section of `SPEC.md` | What it fixes |
|---|---|
| §1 the unit | the cell, with two projections, a byte for a game and text for the spreadsheet; sprites as ranges, physics as formulas, the host's pixel rented |
| §2 the grid and the frame | the `.last` twins as the second buffer; the acyclic rule; the step as recalculation with a budget, a snapshot and a clock cell |
| §3 the device sheets | Screen (plane or grid), Palette, Input, Keys, Clock, Audio, File, cell by cell, with the reserved names and what a new device is |
| §4 the four calls | the handle; `load`, `write`, `step`, `view` with their records; the exports beside them; the refusal families |
| §5 the frame's order | the host's loop: the accumulator and its cap, the inputs, the step and its budget, the effects, the draw and the sound |
| §6 determinism | seven rules, the replay as the oracle, what is exact across machines and why |
| §7 the cartridge | one file, the manifest with every directive required, the rows as the printers print them with range fills, Frazaro as the compiler, a save as a cartridge, the replay |
| §8 the host | eleven exports, zero imports, the shim's duties, how a device or an optimization enters |
| §9 reflection | `AD-6`, proposed there and adopted by the owner the same day, and the Emacs reading in a table |
| §10 to §13 | the limits stated, seventeen decisions, what is not in this version, the oracle and the fan-out |

**The decisions, the owner's.** Seventeen, each with the draft's recommendation and the alternative declined, listed in `SPEC.md` §11; the sections assume the recommendations. The five the roadmap named: the resolution (at most 320 by 200, a smaller size declared), the palette (sixteen rows of a Palette sheet, the index a byte), the Input sheet's cells (ten buttons for four players, the pointer in Screen cells, the last key twice), the Clock (frame, rate and seed), the handle (explicit, from `load`, never reused). The twelve the drafting found, the first three carrying the most weight: **zero imports**, the host pulling every effect and pushing every input through the exports, so `REPO.2`'s count stays zero and a replay is exact across browsers, with two amendments asked of the charter (§2's "will have imports" to "may have"; `AD-5`'s second sentence to begin "Each import, when one is needed,"); **the previous frame as a sheet**, `X.last`, read-only and viewable, over a `LAST()` function, so that the frame adds no mechanism to the evaluator and the previous frame is a thing a person can open; **`AD-6`, reflection**, every state of the engine a cell of a named sheet, viewable and writable through the two calls, with the Keys sheet as its first fruit. Then: volatile functions refused at load; grid mode as a cartridge mode; one file with range fills; every manifest directive required; magenta for a cell that is not a colour; a `value` row for oracle 11 once values exist; the audio voice as wave, note and volume; the page's licence as the map has it.

**The catch.** Five. A `.last` reference must add no edge to the frame's graph, or the acyclic check refuses every rule that reads its own cell; the cut's evaluator must treat the twins as values, which they are. The snapshot must be taken at the end of a step and never at its start, or a write between steps lands in both buffers and a rising edge never rises; §2 states the order so the cut cannot get it backwards. A write during a yielded step would make a frame a function of inputs it did not begin with; it is refused by name. The plane's byte must treat an empty cell as 0 and an error as 255, or the equality test against the record has no rule for absence. A sheet named with 27 characters or more has a twin Excel cannot name; the limit is 26 and stated.

**Oracle.** The page is read by the owner against the roadmap's five questions and answers each in §11; every claim about Frazaro's code cites the file and the lines read; every outside fact has its source in §14; `tools/run_checks.ps1`, the peer's, resolves `SPEC.md` to CC-BY-4.0 under the map and stays green; the line endings are LF with no byte-order mark, as the three living documents are. The item's own oracle, the tests written from the page, belongs to the cut and to `ENGINE.2` and is named in §13.

**Size.** `~days`, of which the reading and the writing were one sitting. (*prediction*, met)

*Drafted 2026-10-08; all seventeen recommendations approved by the owner the same day and `AD-6` adopted; awaiting the owner's commit.* What landed with the draft: `SPEC.md` (the page, fourteen sections and two appendices, Life's cartridge as the shape); the roadmap's `SPEC.1` line marked built; this entry; the `README.md` row; the map's line. What the approval added the same day: `CHARTER.md` amended in place, §2's "will have imports" to "may have" with the zero-import design stated, §4 retitled for six rules with `AD-5`'s second sentence beginning "Each import, when one is needed," and `AD-6` as the sixth rule, the frame paragraph and the uxn lesson pointing at the page, §6 and §10 carrying Fragments; `ROADMAP.md`'s register gained `AD-6` and `AD-5`'s amendment, and `CART.5` was filed at the owner's naming with the family's next free number raised; `README.md`'s rules gained the sixth and its table reads six rules and `AD-6`; `CONTRIBUTING.md`'s "A device" bullet now begins with the sheet's layout and makes the import the exception; `SPEC.md` itself records the approval in its header and §11, the amendments as made in §8.2 and §13, the MIDI port and the patch among the reserved-names section's candidates (§3.8 then, §3.10 since version 2), and §12's paragraph on the score, the patch and the port, Fragments' answer, with its sources in §14. Not touched: `engine/`, whose crate stays empty and whose doc comments name three rules, to be brought to six the day `ENGINE.1` opens the crate. For the commit: `REPO.2` closed under this work in `5bf66e6`, so every hunk of this item is now against that HEAD: `SPEC.md` new, and one file each of `CHARTER.md`, `ROADMAP.md`, `REARVIEW.md`, `README.md` and `CONTRIBUTING.md`, with the `CONTRIBUTING.md` hunk sitting inside the bullet `REPO.2` rewrote. *Committed 2026-10-08 at the owner's word, `eed93b0`, six files, by hunk beside the Frazaro session's re-measurement in `CHARTER.md` §7 and this file, which stayed out.* Appendix C, a Fragments patch in VLA, the patch as a person writes it, its expansion into rows and three macros of its module library, with what exists and what waits, added the same day at the owner's word and committed on its own, with the one clarification it needed in §3.5, the host's seed range.

*Closed 2026-10-08 at the owner's word, after they read the page: the roadmap's line moved to the ledger's specification section above, with the cost recorded, one day and three commits against the predicted `~days`.* The closing commit carries the last additions: Appendix C.5, Fragments in Fragments, the eurorack reading of `fragments.vla` and `modular.vla` (where the sines are and why version 1 has no effect; each module of the artist's notes by its role against its construct in cells, and whether version 1 holds it; Lorenz's system as the notes' weather), the patch notes codified in the patch's shape, the sheet-music argument with Csound, VCV Rack, Pure Data and the MIDI file as exhibits, and the golden patch: a module as a row and a cable as a reference, a feedback cable as a `.last` reference a frame late, the cable list as `reflect`'s `refers` relation, the sizing of a faithful Fragments as a dated prediction for `CART.5`'s scoping (about seventy module rows and a hundred connections, the audio half the patch sheet's), the four categorical points (software duplicates the rack in kind, MIDI carries control and not audio, the recordings are the one gap, the render is beyond every substrate), and the two goldens that hold `modular.vla`, the expansion and the replay. Every patch source reads one argument a line with a comment per argument, the owner's rule, stated once in Appendix C's intro. The re-measurement a Frazaro session had added to `CHARTER.md` §7 and this file's sitting was committed first and on its own, `52612a7`, so that the close carries one claim. What the page hands on is §13's; what it leaves open by name is §12's; `SPEC.2` is minted the day a version is wanted.

## `KERNEL.5` — the viewport, laid here: the Screen device over the view record

*Scoped 2026-10-08, after `SPEC.1`'s close and `PORT.12`'s cut, the first brick rule 2 allows: the ID is Frazaro's and stays in its registers, the code lands here as the Screen device in grid mode (`SPEC.md` §3.1), and Frazaro's ledger closes it. Frazaro's tree was read by file and written nowhere, two other sessions being in it on the day.*

**Substrate, verified.** Read on the day, by file and never by assumption.

- *The record.* `Frazaro/vla-lang/src/view.rs` (567 lines): `Grid::project` prints every sheet of the model as `(sheet "<name>" visible)` in tab order, the word hard-coded, so the reader's other two words, `hidden` and `very-hidden` (`rows.rs`, `Visibility::word`), are what a `.last` twin will print the day `SPEC.md` §4.5 lists one; then the window as the model spells the sheet and a reference spells a rectangle, the extent or `none`, `gridlines on|off`, a `column` row for each column of the window's span that has settings (the width as `number_text` or `none`, `shown|hidden`, a format or `none`), the `format` rows for 0 and every format the window uses, ascending (the fill as six hex digits or `none`, `general|text`, `wrap|nowrap`), and the cells in row-major order: a `cell` row spelled by `rows.rs` (a number as the file's text, a string, `true`, `false`, `(error "#NUM!")`, a date as `(date "...")`), a `formula` row with `=` first and the future prefixes stripped, a shared child's text moved, then `style` when not 0 and `sentence` when a sentence wrote it; `window_of`'s two refusals; `view_text` joins with a line feed. `conformance/README.md` lines 977 to 1072, oracle 11: the order in words, the comparison byte for byte after line endings are normalized to LF and trailing blank lines dropped, the free oracle against `reflect`, the six rows. `tools/check_view_golden.ps1`: each golden's line count a floor, the fixed order read off the golden itself, the first differing line named, SKIPPED without a door, a `-Control` with a fake, a mutant and a moved row: the shape the fixture check here copies.
- *The six goldens*, `scripts/view/`, last changed in `0e5cbc6` (`KERNEL.4`, 2026-10-07), CRLF in the working copy and LF in the blob, measured with `tr` (*measurement*): `fixture_frazaro` 66 lines, 2,189 bytes LF (the Frazaro sheet whole: columns B and C at widths 72 and 60 with formats 1 and 3, gridlines off, four formats, eighteen cells each with a style and a sentence); `fixture_output` 21 lines, 609 bytes (window A1:F20 over an extent of B1:D4, two values, five formulas, their sentences); `fixture_output_b2_c3` 15, 410 (the clip, four cells); `fixture_data` 9, 221 (one cell, `west`); `into_output` 11, 319 (a text and a formula reading another sheet); `into_checks` 9, 272 (one formula). Their SHA-256 over LF bytes, the pins, begin `1e084bbd`, `31ce3956`, `a50431c3`, `3b86d067`, `0fd381bd` and `e6881c6b`. The tree's debug door reproduces `fixture_output` whole on the day.
- *The door and the 10,000-line record.* `target/debug/frazaro.exe --version` prints `frazaro 0.8.0 (core abi 1)`, the tree's version; `view` landed in `0e5cbc6`, after the `v0.8.0` tag (`ae99e89`, 2026-10-06), so the door on crates.io has no `view` and nothing in CI can print a record through a published door until Frazaro's next release (*measurement*: `git log v0.8.0..HEAD -- cli/src/main.rs`). Written on the day into the scratchpad from `bench_view.ps1`'s rule (an odd line `Put i into cell Ai.`, an even line `Put formula "=A(i-1)*2" into cell Bi.`, LF) and viewed by that door over `Output` with no window: 20,006 lines, 660,738 bytes LF, SHA-256 beginning `8c9432bd`, printed in 847 ms, 79,886 bytes under gzip (*measurement*). The record is the rule's own output: six header rows (`Frazaro` and `Output` as sheets, the window and the extent `A1:B10000`, gridlines on, format 0), then for each row a `cell` or a `formula` row and its `sentence` row, and an awk of that rule reproduces the door's text byte for byte (*measurement*).
- *The seed*, `tools/bench_view.template.html` (847 lines) and `bench_view.ps1` (178): `readRecord`, a reader of the forms into a `Map` by `row,col` with `displayOf`'s spelling (a string as itself, a number as printed, `true` and `false` as `TRUE` and `FALSE`, an `(error ...)` or `(date ...)` as the text inside), 20,006 lines read in 13.5 ms on the owner's machine; `geometryOf` and `makeScroller` (a scrolling `div` with the browser's own scrollbar, a sticky canvas and a spacer of the extent's height); `CanvasRenderer` (the backing store the CSS size times the ratio, `setTransform(dpr)`, a clear and a white fill, gridlines at CSS half-pixels, a text measured only when its length says it might overflow and then clipped, the row and column headers); `DomRenderer`; `measuredDraw` and `afterRendering` (a draw's main-thread cost from before the call to a 0 ms task queued after the frame's rendering; a dropped frame the next animation frame later than one and a half intervals); `percentile` (nearest rank); `sizedWindow` and `fullWindow` (the screen's CSS size less the headers and the scrollbar); `cellsWithText`; `frameInterval` (the median of thirty idle deltas); the smoke mode (`?smoke=1`, 8 and 2 steps, a 0 ms pacer, a 300 s watchdog, `<pre id="smoke">`); the Markdown table whose header is `PROTOCOL.md` §9.2's. What the seed lacks for a viewport, by reading: the `column` rows are parsed and never used (every column 96 px), the `format` rows parsed and never drawn, hidden columns, horizontal scroll (`overflow-x: hidden`), selection, frozen panes, resizing, the keyboard, sheet tabs, and device-pixel snapping.
- *The decision and its numbers.* `docs/PROTOCOL.md` §7 as amended, §8.1 step 4, §9.2's entry and §9.3: canvas, holding through 4,641 cells with text at a page p95 of 13.1 ms, a capacity of about 5,644, the eye's verdict on crispness still the owner's (the backing-store line said yes); `CHARTER.md` §7 and this file's sitting hold both runs.
- *The page's split in Frazaro.* `web/index.template.html` (551 lines): one inline script in an IIFE under `'use strict'` with `var`s and no library, the placeholders housed in `<script type="text/plain">` blocks, `WebAssembly.instantiate(bytes, {})`, the ABI number refused when wrong, the three Frazaro Lavender shades as CSS variables at the top; `tools/build_web.ps1` (168): each placeholder exactly as many times as the template has places, `</script` refused in every inlined text, UTF-8 without a BOM, the built page gitignored; `tools/check_web_offline.ps1` (183): the tag tokens and the code tokens (`fetch(`, `XMLHttpRequest`, `WebSocket`, `EventSource`, `sendBeacon`, `import(`, `importScripts`, `@import`, `url(`, `http://`, `https://`), the one allowed anchor pinned whole and once and removed before the scan, a charset, the placeholders' counts, each `{{BOOK:name}}` held to the distro's dialects both ways, the built page held to the tag list, `-Control` on six mutants; `web/README.md` (138): the page for a visitor, then *For contributors*, the template as the source, the ABI, the two checks; `.github/workflows/checks.yml`: the core job runs `build_web.ps1 -NoBuild` then the offline check and keeps the page, the ratchets job loops the checks by hand; `tools/check_crate_data.ps1`: a copy held to its source byte for byte with the one `Copy-Item` that mends a drift, the shape Frazaro's copy of the viewport will take.
- *The commandments and the roadmap.* `web/CALLOSUM.md` §7 decision 5: a viewport, not an Excel clone: scroll, select, resize columns, freeze headers, a formula bar, precedents and dependents lit; no fill handle, no drag-move, no in-cell editing beyond the bar. §13: of `SD-20` to `SD-37`, four bind the viewport (`SD-23`, its state is the interface's and no program's; `SD-32`, it paints what the record declares and nothing else; `SD-34`, a draw is one window and never the sheet; `SD-35`, the grid is not the accessible path, which is the program's), and five are the first game's chrome (`SD-20` the selection as the next noun, `SD-24` the bar's three lines, `SD-25` the refusal in both panes, `SD-26` the modes, `SD-28` the grid first and explain-this-cell), which the viewport serves with events and marks and never decides. `docs/BETA_ROADMAP.md` line 465 and `docs/BETA_REARVIEW.md` line 18209: the entry with its renderer written in, the where-the-code-lands note of 2026-10-08, the oracle "the view golden drives a rendering test; `check_web_offline.ps1` unchanged", the catch "the fill handle is the first temptation refused".
- *The specification.* §1: the host decides how many device pixels a cell gets, an integer, so the image is crisp at the machine's ratio; §3.1 grid mode: the text, the number formats and the fills the record declares (`SD-32`); §4.5: the record byte for byte as the door prints it, the `.last` sheets listed `hidden` after the cartridge's own so a viewport shows the tabs and the previous frame on request, the `value` row `KERNEL.7` adds; §8.1 and §8.3: eleven exports and no import, the shim draws the record through the viewport and never calls `fetch`; §9: the host keeps `SD-23`'s state and nothing else.
- *The machine and the runners.* Windows PowerShell 5.1.26100, no `pwsh`, no node; Google Chrome 154.0.8037.93 and Microsoft Edge 154.0.4258.62 present (*measurement*). The recipe of the `KERNEL.3` memory put to both on the day with a 1.5 KB page that counts thirty animation frames, fills a canvas and reads one pixel back: Chrome under `--headless=new --disable-gpu --run-all-compositor-stages-before-draw --disable-frame-rate-limit --disable-gpu-vsync --virtual-time-budget=60000 --dump-dom` printed the thirty frames in 825 ms at a median delta of 12.0 ms, the fill read back as 247,244,252 exactly, `isSecureContext` true on `file://`, and under `--force-device-scale-factor=1.5` the page saw a ratio of 1.5; Edge did the same through `Start-Process` with redirected output, its frames at a 0 ms delta, and launched from Bash its launcher detached and dumped nothing (*measurement*): the virtual clock gives numbers and not a measurement, and an equality needs no clock. The runner images (actions/runner-images, 20260927): `ubuntu-24.04` carries Google Chrome 154.0.8037.57, Chromium 154.0.8037.0, ChromeDriver, Edge 154.0.4258.37, Firefox 156.0 and PowerShell 7.6.6; `windows-2025` Chrome 154.0.8037.58, Edge 154.0.4258.37, Firefox 156.0.1 and PowerShell 7.6.6 beside Windows PowerShell 5.1 (*exhibit*; `REPO.2`'s first run proved the shells). So both jobs have a Chromium for the deterministic oracle.
- *This repository.* `.gitattributes`: `*.js` and `*.html` LF, `*.vla` CRLF on checkout, which git's `eol=crlf` applies on every platform, so a vendored golden is CRLF in every working copy and LF in the blob; `.gitignore` already ignores `web/index.html` under an `ENGINE.1` comment; `REUSE.toml` maps `web/**` and `tools/**` to Apache-2.0, and Frazaro maps `scripts/**` the same, so a vendored golden changes no territory and carries no header, as Frazaro's carry none; `run_checks.ps1` at a floor of 2 with the two controls as extras and `pwsh` where `powershell.exe` is absent; `checks.yml`'s two jobs; `check_host_imports.ps1` at 0 on an empty crate; `CONTRIBUTING.md` already promising that "the render floors are hand-maintained baselines in `tools/`"; `engine/src/lib.rs`'s doc comment naming this item as the Screen device over the view record. ECMA-376 Part 1 §18.3.1.13, the `col` element: a column's stored width is in characters of the default font's widest digit with five pixels of padding folded in, and its pixels are `Truncate(((256 x width + Truncate(128 / MDW)) / 256) x MDW)`; with the maximum digit width 7 of Calibri 11 at 96 DPI, which is what the writer's files assume, 72 is 504 px and 60 is 420 px, and a column with no row is Excel's default, 64 px (*exhibit*; *derived*).

**The work.** A script, a page, seven fixtures, a builder, four checks and the record.

| File | What it is | Copied, adapted, or decided |
|---|---|---|
| `web/viewport.js` | the viewport: the reader of the record, the model, the geometry in device pixels, the renderer with its draw list, the interactions, the tab strip, the API and its events; plain script, no module, no import, no library; about a thousand lines | the seed's reader and renderer adapted; decisions 1, 6 to 10 |
| `web/index.template.html` | the page: the viewport over the fixtures with a picker, the tabs and a paste box; `?oracle=1` and `?bench=1` as the instrument's modes, each judged on one `<pre>`; `{{VIEWPORT_JS}}` and one `{{FIXTURE:name}}` a fixture | adapted from Frazaro's template and the seed; decisions 2 and 4 |
| `web/fixtures/*.vla` | the six goldens as Frazaro's blobs hold them, and `sparse_10000.vla`, the door's record of the 10,000-line program | copied; decision 3 |
| `web/README.md` | the page for a visitor, then the API for the first game, method by method and event by event | adapted; decision 9 |
| `tools/build_web.ps1` | the twin: the placeholders counted, `</script` refused, the page written UTF-8 without a BOM; no module yet | adapted; decision 2 |
| `tools/check_web_offline.ps1` | the twin: the tokens over the template and the viewport's source, no anchor, a charset, the placeholders, each fixture place held to `web/fixtures/` both ways, the built page held to the tag list; `-Control` | adapted; decision 11 |
| `tools/check_view_fixtures.ps1` | each fixture's SHA-256 over LF bytes, its line-count floor and oracle 11's order; the sparse record held to the rule; `-Frazaro <tree>` and `-Door <exe>`; `-Control` | decision 3 |
| `tools/check_render_oracle.ps1` | the built page under a headless Chromium at ratios 1 and 1.5, every case's draws equal to the record, the counts at their floors; SKIPPED without a browser or a page; `-Control` on mutant pages | decision 4 |
| `tools/check_render_floors.ps1` | the baseline table, hand-maintained, held to the roadmap's bars and never lowered; `-Control` | decisions 4 and 5 |
| `tools/run_checks.ps1`, `.github/workflows/checks.yml` | the floor 2 to 6, the four controls as extras; both jobs build the page before the runner and keep it | decisions 11 and 12 |
| `ROADMAP.md`, `REARVIEW.md`, `README.md`, `CONTRIBUTING.md`, `Delta/CLAUDE.md`, the memory | *Scoped* now, 🟡 and what landed after; the table's rows; the contributor's path for the viewport | decision 13 |

**The decisions, the owner's.** Each with the sitting's recommendation and the alternative it declined.

1. **Where the viewport lives, and in what language.** Plain JavaScript in `web/viewport.js`, no framework, no module syntax, no import, inlined into the page at build and taken by Frazaro's page as a file; the engine crate stays empty until `ENGINE.1` and the allowlist at zero. The draw call is the host's (rule 3; `SPEC.md` §8.3 gives the shim the drawing of the record through the viewport), the record is text, the rasterizer and the shaper are rented, and the renderer the benchmark chose is already JavaScript on the canvas's 2D context; a wasm boundary between a text record and a canvas would be crossed twice a frame for nothing, since the module cannot draw. The alternative: Rust in the crate rasterizing the grid into a plane of bytes the shim blits, which is `ENGINE.2`'s path for a game's Screen and would here rebuild the text rasterizer rule 3 rents, measured on nothing, with fonts in the crate; declined under rule 3 and `AD-3`'s spirit. Recommended: JavaScript, the language of the host shim from here on, `ENGINE.1` writing its loop beside this file.
2. **The page's shape.** One template, `web/index.template.html`, one built file from it, gitignored, in Frazaro's split; the seven fixtures as placeholders the way the dialects are, `{{FIXTURE:fixture_frazaro}}` and so on, each a `<script type="text/plain">` block, held to the folder both ways by the offline twin; the viewport's source a file of its own, `web/viewport.js`, inlined under `{{VIEWPORT_JS}}`, so it is reviewed as a file and shipped in one page that runs from disk and fetches nothing. The page's default is the viewport over the fixtures (a picker, the tabs, the status line with the record's counts, a paste box for a record of one's own, read and never saved); `?oracle=1` and `?bench=1` are the instrument's modes, each judged on one `<pre>` as the seed's smoke mode was, so the oracle and the floors read the page the owner looks at and no second page. The alternative is Frazaro's split, the instrument as a second template under `tools/` with a builder of its own: two pages holding the same fixtures, two builders, one more offline check, and an instrument nobody opens; declined because here the instrument is kept, the floors read it, and the page is the host shim's own and not yet the product's (`ENGINE.1` makes it the engine's; the modes stay as its self-tests). Recommended: one template with modes.
3. **The fixtures.** The six goldens vendored under `web/fixtures/` byte for byte as Frazaro's blobs hold them, LF, so a diff against `scripts/view/` is empty and a Frazaro regeneration is a copy; pinned in `tools/check_view_fixtures.ps1` by the SHA-256 of their bytes with line endings normalized to LF, since `*.vla` gives CRLF on checkout here as there and a runner's checkout is not the owner's, their line counts as floors that never go down and oracle 11's fixed order read off each, the check's shape Frazaro's own; the Frazaro commit they came from, `0e5cbc6`, written beside the table; `-Frazaro <tree>` compares each to that tree's golden when a tree is named and SKIPS otherwise, so CI never needs Frazaro. The 10,000-line record vendored too, `web/fixtures/sparse_10000.vla`, the door's own output (660,738 bytes; about 80 KB in the pack), pinned by its hash and held by two more witnesses: the check regenerates the text from the rule in PowerShell and compares it whole, which costs nothing and catches a vendored copy that drifted from the program it claims; and `-Door <frazaro.exe>` has a door print it again when one is named. The alternatives: a record generated in CI through a published door, which is not available, the door on crates.io having no `view` until Frazaro's next release, after which it becomes a `-Door` run in CI and the pin stays; a record generated in the page from the rule and vendored nowhere, zero bytes, declined because the page would then draw a text no door printed and the house's rule is that a fixture is the door's output, never typed and never generated by hand; `cargo install --git` of Frazaro at a pinned commit in the job, minutes a run and a coupling to a tree that is four commits ahead of its remote. Recommended: vendored, pinned and witnessed by the rule.
4. **The floors' instrument, and what CI gates.** Two instruments. CI gates the deterministic oracle: `?oracle=1` loads each fixture into the viewport at a fixed CSS size, draws synchronously, and compares the viewport's own draw list, every operation recorded with its kind, its cell, its device-pixel rectangle and its text, to the oracle's independent computation from the record and the rules of decision 8 (the widths, the row height, the scroll, the frozen panes, the alignment by a value's kind, the fill by the style, wrap, gridlines, the headers), both ways: every cell of the record inside the window drawn once where the record puts it with its text and its fill, nothing drawn that the record does not hold, every line and every text at integer device pixels (lines at a half), which is the crispness geometry at any ratio; and one pixel probe a case through `getImageData`, a styled cell's centre its fill, a gridline its colour, a plain cell white. The cases: each golden at its own window; the sparse record at 40 by 15 at the top, the middle and the end, with two rows and one column frozen, and with a column resized through the API. One line a case with its counts into `<pre id="oracle">`; `tools/check_render_oracle.ps1` runs a headless Chromium twice, at `--force-device-scale-factor` 1 and 1.5, reads the dump, and holds each case's asserted cells to a floor; the browser is `$env:ALONZO_BROWSER`, else Chrome, Edge or Chromium at the known paths on Windows and on the `PATH` on Linux; SKIPPED with exit 0 without a browser or without a built page, as the import check skips without an artifact, since a check that fails on every machine without a browser is ignored on all of them and CI, which has both, is where it bites. The owner measures the timing: `?bench=1` is the seed's harness over the sparse record at the normal window and the full-screen one, 120 steps of three rows and 20 page steps, first draw, step p50 and p95, page p95, max, sync p50, dropped of N, holds; the owner runs it in Chrome in fullscreen and pastes its table into `tools/check_render_floors.ps1`'s baseline, a hand-maintained table with the date and the environment line, and the check holds that table to the roadmap's bars, the scroll p95 under one and a half intervals and the max under two, the first draw under 100 ms, at both windows, and to its shape, never lowered. The alternative, a live timing on a shared runner, is declined on the day's measurement: under a virtual-time budget Edge delivered thirty frames in 10 ms, and a number that is not a measurement must not be a floor. Recommended as stated.
5. **The first baseline, and the eye.** The baseline is empty until the owner runs; a check over an empty baseline fails, since a floor with no number is no floor, so the build's commit waits on the owner's run in Chrome in fullscreen, pasted in by the session; and the crispness verdict by eye, which `PROTOCOL.md` §8.1 step 2 still owes, is taken on the page's HiDPI panel (the same text in a DOM cell and in the viewport's canvas at the machine's ratio, the backing-store line beside it) and recorded in the check's header, in this record and, by a Frazaro session, in `PROTOCOL.md` §9.2. The alternative is a baseline from this session's own run, which is not the owner's machine in fullscreen and would be replaced the same day. Recommended: the owner's run first.
6. **The interactions in this item.** Scroll: the wheel, the browser's scrollbars on both axes, the keyboard (the arrows moving the selection and bringing it into view, Page Up and Down, Home and End, Ctrl+Home and Ctrl+End). Select: a click, a drag, Shift+click, Shift+arrows; a column header selects the column, a row header the row, the corner the sheet; the selection spelled as the grammar spells it, `B2`, `B2:C3`, `C:C`, `2:2`, the sheet's name, in the `select` event, so `SD-20`'s noun is the viewport's spelling and not the page's. Resize columns: a drag on the boundary in the column header, the width the host's state over the record's (`SD-23`), a `columnresize` event so `KERNEL.9`'s recorder can one day transcribe it. Freeze headers: `freeze(rows, cols)`, the frozen rows and columns drawn fixed and the scroll split, with a control on the demo page. The sheet tabs: one a `sheet` row, `hidden` and `very-hidden` sheets under a "hidden sheets" toggle so the `.last` twins show on request (`SPEC.md` §4.5); a tab whose record is not loaded raises a `sheet` event asking the host for it (the demo says so; Frazaro's page will call `frazaro_view`, `ENGINE.1` `alonzo_view`). Crisp at the device pixel ratio: the layout in device pixels, the backing store the CSS size times the ratio, lines at integer plus a half, text at integer positions, every size an integer of device pixels, the canvas remade when the ratio changes. Marks: `mark(name, ranges, style)` draws a named highlight the host computes, the refusal markers of `SD-25`, the cells a sentence wrote, `KERNEL.11`'s lit precedents, and the viewport decides none of them. A double-click or Enter on a cell raises `cellopen` with the cell and its sentence row, `SD-28`'s explain act being the host's. Frazaro's half, by its roadmap's own line: the bar's three lines, the two-way link and the noun, the refusal in the row, the modes, the pane. Never: the fill handle, drag-move, in-cell editing. Not in this version: touch, a context menu, printing, row resizing (the record has no row-height row), column reordering. Recommended as stated.
7. **What a cell shows, and a formula before the value row.** A `cell` row shows its value as `reflect` spells it, aligned as Excel aligns it under General: a string as itself, left; a number as the file's text, right; `true` and `false` as `TRUE` and `FALSE`, centred; an error as its text, centred; a date as the text inside, right; under a `text` format everything left. A `formula` row, before `KERNEL.7`'s `value` row exists, shows the formula's text as the bar shows it, `=B2*2`, left, in the formula colour Frazaro's page already gives a formula (`#0a6b4f`), so that a formula cell is told from a value at a glance and the bar the first game adds shows the same text; the day the `value` row arrives the viewport draws the value and the text goes to the bar, a change of one arm. Alternatives: a blank cell, which hides that a formula is there; or CALLOSUM §7 decision 3's `not computed here` with the function named, a label for a formula outside the subset once recalculation exists, which before it would cover every formula and say nothing. Overflow: a `nowrap` text spills into empty neighbours to the right as Excel's does and stops at the first cell that holds anything; a number never spills and is clipped (Excel shows `###`); `wrap` breaks the text at the column's width and draws the lines that fit the row's height, clipped, since the record has no row height. Recommended as stated.
8. **The record rows honoured: all that exist today.** `sheet` (the tabs, with the reader's three words), `window` (the record's scope: the viewport's scroll extent is the window and never less than one screen), `extent` (the status line; the row-header width sized to the extent's last row), `gridlines` (drawn or not), `column` (the width by ECMA-376's rule with a maximum digit width of 7, `hidden` skipped, a column format applied as the fill of its empty cells), `format` (the fill, `general` or `text`, `wrap` or `nowrap`), `cell`, `formula`, `style`, `sentence` (carried on the cell, exposed through the API and the `select` event, drawn by nothing). An unknown row, the `value` row among them until it is honoured, is counted and the status line says how many; a malformed row is counted too, never refused: the viewport draws what it can read, since refusals are the door's and the viewport is not a second implementation of the record. The constants: the default column 64 px, the default row 20 px, the headers one row high, the font 13 px `system-ui` as the seed's; the colours options with the house's greys as defaults, a lavender selection and the formula green (`SD-32`'s spirit: the viewport paints the record and the host's declared colours and nothing of its own). Recommended as stated.
9. **The API the first game consumes.** One constructor over an element and a record, `new AlonzoViewport(element, options)`, the element a box the host owns and the viewport fills with its own scroller, canvas and tab strip, since the browser's scrollbars, which the seed measured and rule 3 rents, need a scrolling box around the canvas; `options.record` a record's text. Methods: `load(text)` (a record; its sheet becomes a tab, replacing an earlier record of that sheet), `show(sheet)`, `sheets()`, `scrollTo(row, col)`, `select(text)`, `selection()`, `freeze(rows, cols)`, `columnWidth(letters, px)`, `mark(name, ranges, style)` and `unmark(name)`, `cellAt(clientX, clientY)`, `cell(row, col)`, `geometry()`, `draws()` (the last draw's list, the oracle's), `redraw()`, `destroy()`; events through `on(name, fn)` and `off`: `select`, `scroll`, `columnresize`, `sheet`, `cellopen`; every method and event documented in `web/README.md` with its arguments. A global, `AlonzoViewport`, set by an IIFE under `'use strict'` with `var`s, no module syntax, as the house's pages are written, so the file inlines into any page and loads as a file in a test page alike. Frazaro's page takes `web/viewport.js` as a copy held byte for byte by a check on its side, in `check_crate_data.ps1`'s shape with a pinned hash since CI has no sibling tree and the `Copy-Item` that mends a drift named; the copying is a Frazaro item the owner mints. The alternative, "over a canvas" to the letter, with the scrollbars drawn by the viewport: one element and no wrapper, at the cost of rebuilding the browser's scrollbar, its inertia and its accessibility, which rule 3 forbids until a measurement asks. Recommended: the element.
10. **The scroll model.** This version: a record of any extent, whole, windowed by the viewport itself: the reader holds the cells in a `Map` by row and column (the seed's shape, 20,006 lines in 13.5 ms on the owner's machine), and a draw reads the window's cells alone, so a draw costs the window and never the sheet (`SD-34`, and the capacity measured). `ENGINE.1`'s path is the live windowed call through the handle, the viewport asking for the window it shows: `load` of a record whose `window` row is smaller than its extent already draws that window and raises `scroll` with the window wanted, so the live path adds a host loop and no viewport change. The alternative, windowed from the first with the page calling `frazaro_view` per scroll, is Frazaro's page's and not this item's, and the record's cost says no: 847 ms for 20,006 lines natively is not a frame. Recommended: whole records now, the windowed call when `ENGINE.1` has a handle.
11. **The checks, each with `-Control` in the house's style.** Four new, one adapted. `check_web_offline.ps1`: the tag tokens and the code tokens as Frazaro's, the code tokens read over the template and over `web/viewport.js`, since the script is inlined and the built page is scanned for tags alone; no anchor at all (the allowed list empty, the page having no link); a charset; each placeholder's count; each `{{FIXTURE:name}}` once and a file under `web/fixtures/`, and every file there a place; the built page held to the tag list; six mutants. `check_view_fixtures.ps1`: the seven pins, floors and orders, the rule; mutants: a byte changed, a line dropped, a format row moved below a cell, the rule's text changed. `check_render_oracle.ps1`: mutant pages built from the template by the builder's `-Template` over a mutated `viewport.js` with an asserted single anchor each: the text padding changed, which the oracle must fail naming the cells; the last cell's draw dropped; the oracle's block cut; each mutant proving it applied by the page printing the constants it read before the judgment. `check_render_floors.ps1`: mutants of the baseline table, a p95 over the bar, a max over, a first draw over, a case missing, an empty table. The runner's floor from 2 to 6, the four controls joining the extras; the oracle's control runs the browser four times, so the extras take about a minute. Recommended as stated.
12. **CI's shape.** Both jobs build the page before the runner, so the oracle runs under both shells and both operating systems: the ratchets job on `windows-latest` gains a step, `powershell -File tools/build_web.ps1`, which needs no cargo since the page has no module yet, then the runner with extras, the oracle under the image's Chrome or Edge; the crate job builds the page under pwsh after the wasm and runs the runner, the oracle under Chrome on `ubuntu-latest`, and keeps `web/index.html` beside `alonzo.wasm`. The browser is found by the check and never by the workflow, `$env:ALONZO_BROWSER` for a machine that needs it. The alternative, the oracle on the ubuntu job alone, is declined as `REPO.2` declined it: both halves. Recommended as stated.
13. **The bookkeeping across the road.** The scoping and the build record live here, under the Frazaro ID, as the roadmap's line says laid here; `ROADMAP.md`'s line gains *Scoped* now and 🟡 *built* after the build, and leaves this file the day Frazaro's ledger closes the item (`AD-2`; the roadmap's own header); Frazaro's ledger line in `docs/BETA_REARVIEW.md` is a Frazaro session's to write by hunk, since that tree is shared, its roadmap line already carrying the laid-in-Alonzo note; the handle item, `KERNEL.6`, `KERNEL.7` and the copy into Frazaro's page are not this session's. Recommended beside it: when Frazaro closes the item, one line in this file's closed ledger under a `## 🔧 THE ENGINE` heading, pointing at Frazaro's line and the commits here, so this repository's record is whole without a second ledger; the alternative is no line here. Recommended: the pointer line, dated when Frazaro's closes.

**The catch.** Eleven, each met on the day or once in Frazaro.
- A CSS half-pixel line at a ratio of 1.5 is 0.75 device pixels and blurs over two; the seed drew its gridlines so, which may be the open verdict; the viewport lays out in device pixels and the oracle holds the integrality at 1 and 1.5, so the eye judges the crisp arrangement.
- The record's width is Excel's stored width, which already folds in the padding, not `ColumnWidth`'s displayed characters; the pixel rule with a maximum digit width of 7 is Calibri 11's at 96 DPI, and a host with another default font paints other pixels; the viewport's rule is stated and pinned, not Excel's pixels promised.
- `eol=crlf` converts on checkout on every platform; the vendored copies are CRLF in every working copy; the pin is over LF bytes and the check says which ending it found, so a runner's checkout cannot fail the pin.
- Edge's launcher detaches from a Bash redirect and dumps nothing; the check launches through `Start-Process` with redirected output on Windows and a direct call on Linux, a scratch `--user-data-dir`, `--no-first-run`, `--no-default-browser-check`; a browser absent is SKIPPED and never red.
- Under a virtual-time budget the animation-frame clock is not a clock; the oracle draws synchronously and needs no frame, and a headless harness number is never recorded.
- `getImageData` under `--disable-gpu` is software-rendered and exact for a fill; text pixels are the rasterizer's and never asserted; a fill probe reads the centre of a cell, never its border.
- A 660 KB `text/plain` script block: read once as `textContent`, 10,000 `Map` entries, 13.5 ms on the owner's machine; `</script` in a fixture would end the block and the builder refuses it, as Frazaro's does; and the offline scan's code tokens must be absent from the viewport's text, a comment included.
- A mutant must prove it applied: the oracle prints the constants it read in its header line, and the control reads them back before it asks the mutant to fail.
- The goldens exercise `text` and `general`, `wrap` and `nowrap`, fills, widths, gridlines off, a clip and a formula reading another sheet; no golden holds a hidden column, a hidden sheet or a date, so those arms are honoured by code and listed as unexercised until a door prints one.
- PowerShell 5.1 as `REPO.2` met it: ASCII or a byte-order mark, `return ,$list`, no `Write-Output` inside a function whose value a caller reads, Continue around the child process, a commit message by `-F`.
- Frazaro's tree is shared by two sessions on the day and nothing is written there; the Frazaro-side edits are named in decision 13 and left.

**Oracle.** On the owner's machine under Windows PowerShell 5.1, then on both jobs:
- `tools/build_web.ps1` writes `web/index.html`, every placeholder filled once, and `check_web_offline.ps1` is OK on the template, the viewport's source and the built page, its control green on six mutants.
- `check_view_fixtures.ps1` OK: seven pins, seven floors, oracle 11's order in each, the rule reproducing the sparse record whole; `-Frazaro ../Frazaro` equal on the owner's machine and `-Door ../Frazaro/target/debug/frazaro.exe` printing the sparse record again; its control green.
- `check_render_oracle.ps1` OK under headless Chrome and headless Edge at ratios 1 and 1.5: every case's draws equal to the record both ways, every coordinate integral, the probes exact, the counts at their floors (the six goldens' 18, 7, 4, 1, 2 and 1 cells; the sparse windows' 40 each); its control: three mutant pages fail, each naming its defect and each proving it applied.
- The owner's run of the page: the six fixtures drawn, scrolled on both axes, selected by click, drag and keyboard with the spelling shown, a column resized, panes frozen, the tabs switched, a tab without a record saying so, a pasted record drawn; then `?bench=1` in Chrome in fullscreen, the table copied into `check_render_floors.ps1`'s baseline by the session, and the crispness verdict by eye on the HiDPI panel, which closes `PROTOCOL.md` §8.1's open clause.
- `check_render_floors.ps1` OK over that baseline: the scroll p95 under 25 ms and the max under 33.4 ms at a 16.7 ms interval, the first draw under 100 ms, at both windows; its control green on five mutants.
- `run_checks.ps1 -WithExtras`: 6 checks and 6 verifiers, `ALL GREEN`, the floor at 6; `-ToolsDir` on a scratch copy with one check removed trips it.
- The cargo oracle unchanged and `check_host_imports.ps1` at 0 imports on the 32-byte artifact; `git status` shows nothing under `engine/`.
- CI green on both jobs at the owner's push: the oracle under Chrome on ubuntu and under the windows image's browser, the page kept as an artifact.
- `git status` showing only the files in the table.

**Size.** `~days` of writing (the viewport about a thousand lines, the page, the builder, four checks with their controls, the README), then the owner's runs; the roadmap's `~weeks` for the item covers Frazaro's half too. (*prediction*)

*Built 2026-10-08, awaiting the owner's run.* The owner approved all thirteen recommendations, with two questions answered first: whether a Rust-rasterized plane could replace the viewport later (yes: the viewport is a layout that turns the record and the host's state into device-pixel rectangles and a painter that puts them on the canvas, and a rasterizer in the crate replaces the painter alone, answering a new projection the shim blits, at the cost rule 3 names, fonts and a shaper in the crate; a glyph atlas drawn with `drawImage` is the cheaper rung before it; which rung and when is a measurement's call under `AD-3`), and why an element and not a canvas (the scrollbars: the benchmark's numbers were taken on a scrolling box with the browser's own scrollbar, a bare canvas would have the viewport drawing scrollbars and reproducing inertia, and the tab strip is DOM). What landed: `web/viewport.js` (1,000 lines: the rules of the record as constants, `RULES` exported for an oracle to read back; the reader into a model with the value kinds; the geometry in device pixels, a screen of slack rows and columns past the window; the painter with its draw list, four quadrants under frozen panes, the headers, the selection and the marks; a nowrap text spilling into empty neighbours and a look-back of eight columns for one that reaches the window from off-screen, a text whose clip never reaches the quadrant not drawn at all; the mouse, the keyboard, the column-edge drag, the tabs with a hidden-sheets toggle; the API and the five events; `AlonzoViewport` as the one global); `web/index.template.html` (the page with its picker, the freeze controls, the paste box, the HiDPI panel; the oracle under `?oracle=1`, twelve cases, its expectations computed from the record by its own constants and its own geometry, never the viewport's; the harness under `?bench=1`, the seed's, over the viewport, printing the Markdown table and the baseline lines; `&smoke=1` for a headless shape run); `web/fixtures/`, the seven records, each storing Frazaro's exact blob (the six SHA-1s equal, *measurement*); `web/README.md`; `tools/build_web.ps1`; the four checks with their controls, `check_web_offline.ps1` (seven mutants), `check_view_fixtures.ps1` (four), `check_render_oracle.ps1` (three mutant pages, each proving it applied: the padding mutant's page prints `pad=5` and fails twelve positions, the dropped column fails one cell not drawn, the cut element leaves no block), `check_render_floors.ps1` (seven table mutants); `run_checks.ps1` at a floor of 6 with the six controls as extras; `checks.yml` building the page in both jobs and keeping it. The oracle, run on the day on the owner's machine under Windows PowerShell 5.1.26100 (*measurement*): `check_render_oracle.ps1` clean under headless Chrome 154.0.8037.93 and under headless Edge 154.0.4258.62, at ratios 1 and 1.5, twelve cases each, 1.2 s a run under Chrome; the six goldens' 18, 7, 4, 1, 2 and 1 cells, the sparse windows' 39 (the tab strip takes a row of the forty), the frozen case's 110 gridlines, every coordinate integral, every probe exact; `check_view_fixtures.ps1` clean, and with `-Frazaro ../Frazaro -Door ../Frazaro/target/debug/frazaro.exe` every copy the tree's golden whole and the sparse record printed again by the door whole; `check_web_offline.ps1` clean on the template, the script and the built page (778,631 characters); `run_checks.ps1 -WithExtras`: 6 checks, 5 passed and the floors failing as designed on the empty baseline, 6 verifiers passed; `check_host_imports.ps1` still at 0 on the 32-byte artifact and nothing under `engine/` touched. Five corrections to the scoping, each found on the day. The body quadrant's rows were bounded by the column count in the painter, and the oracle's expectation carried the same mistake from the same hand, so the two agreed at nineteen texts where forty were due: the counts in the oracle's line exposed it, and the floors now hold them. A pixel probe at a cell's centre reads glyph ink, its own text's or a neighbour's spilled into it, so the probes read a corner inside the cell. Under a headless browser's virtual time no animation frame follows a scroll at all, while frames flow freely otherwise (probed on five tiny pages), and any pending timer beyond a 0 ms chain is a leap target that spends the budget in a second; the harness's smoke mode therefore waits on a task and not a frame, and the instrument's real path stays the scroll; the oracle never needed a frame. `$IsWindows` is a read-only automatic variable under PowerShell 7, so the oracle check names its own; and a function returning `,$list` to a caller that wraps the result in `@()` counts one element where there are none, Frazaro's twin returning without the comma, which the offline check now does too. The size was as predicted, a day of writing. What remains is the owner's: open `web/index.html` and work the viewport by hand; open `web/index.html?bench=1` in Chrome, press Fullscreen, press Copy when the run is done and paste the baseline lines into `tools/check_render_floors.ps1` with the date, which turns the runner `ALL GREEN`; give the crispness verdict by eye on the HiDPI panel, recorded here, in the check's header and, by a Frazaro session, in `PROTOCOL.md` §9.2; then the commit at the owner's word, the push, and CI's first run of the oracle on both jobs.

*Owner-tested 2026-10-08; committed and pushed the same day at the owner's word.* The owner worked the page by hand, the three sheets of the first program, a range dragged across C2:C4 with the column and the rows lit in the headers, a record pasted, at a ratio of 1.5, and sent four screenshots. Then `?bench=1` in Google Chrome 154.0.8037.93 in fullscreen on a 2560 by 1440 CSS screen at a ratio of 1.5, 60 Hz, a 16.6 ms interval, the sparse record read in 12.0 ms (*measurement*, the owner's, the first baseline, pasted into `tools/check_render_floors.ps1` as the page printed it):

| renderer | record | cell px | window (rows x cols) | cells with text | first draw ms | step p50 ms | step p95 ms | page p95 ms | max ms | sync p50 ms | dropped of N | holds the frame |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| viewport (canvas) | sparse | 20 x 64 | normal (38 x 15) | 38 | 8.2 | 0.7 | 0.9 | 0.9 | 1.1 | 0.4 | 0 of 140 | yes |
| viewport (canvas) | sparse | 20 x 64 | full-screen (69 x 39) | 69 | 8.3 | 1.2 | 1.4 | 1.8 | 2.5 | 0.9 | 0 of 140 | yes |

Against the roadmap's bars: the step p95 under one and a half intervals (24.9 ms) by a factor of twenty-seven at the normal window and seventeen at full screen, the max under two (33.2 ms) by thirteen and thirty, the first draw, which here includes reading the 20,006 lines, under 100 ms by twelve, no step dropped. Against `KERNEL.3`'s canvas renderer measured on the same machine (`CHARTER.md` §7, the second run): the same cost at the normal window (step p95 0.9 against 0.9, page p95 0.9 against 0.7), and a millisecond more at full screen (1.4 against 1.1, max 2.5 against 1.4), where the viewport draws thirty-nine columns of 64 px to the seed's twenty-six of 96, the headers, the gridlines of the slack and the selection; a tenth of the budget, as the charter's §7 said a spreadsheet's window would cost. `run_checks.ps1 -WithExtras` on the baseline: 6 checks and 6 verifiers, `ALL GREEN`. One defect found by the screenshots and fixed the same hour: the line under the grid kept the last sheet's selection after a tab switch, since `show()` put the selection back at A1 without saying so; the viewport now raises `select` when a sheet is shown, the README says so, and the oracle is unchanged, since a selection op was already drawn at A1. The crispness verdict by eye, the owner's, 2026-10-08, on the HiDPI panel at the ratio of 1.5: **crisp**, which closes the clause `PROTOCOL.md` §8.1 left open when canvas was chosen (the entry there is a Frazaro session's). The owner's note beside the verdict, that a canvas allows no text selection, is answered by the host's state: the selected cells' texts are the viewport's through `selection()` and `cell()`, and a Copy act over them, Ctrl+C writing the selection's texts tab-separated to the clipboard as every spreadsheet does, is a few lines for the first game's chrome or a later version of this file, not minted here.

## `SPEC.2` — the page, version 2

*Minted, scoped and built 2026-10-08, the same evening as the sittings above, at the owner's word: the contract settled before the language crate's four calls are written against it, the owner's own principle that an early mistake multiplies by the time it is reassessed.*

**Substrate, verified.** Read on the day, by file. `SPEC.md` version 1 whole, 751 lines, the sections and the three appendices as `SPEC.1`'s entry lists them. `docs/ALGEBRA.md`, written the same evening: §2.3 (the Write sheet and its narrowing), §3 (the seven corrections and what stands), §4 (the stacker in cells), §2.1 and §2.2 (the transparent blank, the theorem, the clock calculus). `Frazaro/docs/BETA_ROADMAP.md`, the `GENSYM` entry, read whole: the veto's words, `eval` carried, "kept here, permanently". `Frazaro/scripts/prelude.vla` lines 15 to 24: the anti-gensym doctrine and its reliance on VBA's compiler being loud about a collision. `Frazaro/vla-lang/src/expand.rs` lines 74 to 80: the seventeen LISTOPS primitives, `car`, `cdr`, `cddr`, `cons`, `list`, `null?`, `eq?`, `equal?`, `quote-if`, `cond` and the six expand-time comparisons, so a macro can walk a list it was handed. The record's look rows, `Frazaro/scripts/view/*.vla` and `conformance/README.md` lines 1000 to 1012: `(format <index> <fill|none> general|text wrap|nowrap)` and `(style "<sheet>" "<addr>" <index>)`, a `column` row with a width and `shown|hidden`, and no row-height row anywhere (*measurement*: the six goldens hold `column`, `format`, `style`, `gridlines`, `sheet`, `window`, `extent` and no `row`), which is why the `row` row is asked of oracle 11 and not assumed. `Frazaro/vla-lang/src/view.rs` and `sheet.rs`: `column_letters`, `column_width_attr`, nothing for a height. `Frazaro/vla-lang/src/`: no `vla_load`, no `vla_step`, no handle (*measurement*, `grep` on the day), so nothing is written against version 1's calls yet and the amendment costs nothing built. This repository: `ROADMAP.md`'s families table with `SPEC.2` next free; `CART.4`'s scoping, the Board as formulas keeping their last value, which version 2's Write sheet replaces with values; `REARVIEW.md`'s `SPEC.1` entry and its catch.

**The work.** `SPEC.md` rewritten in place as version 2; the roadmap's line; this entry and the evening's sitting; the README's row; the map's line in `Delta/CLAUDE.md`; a dated line in `docs/ALGEBRA.md` §8. No code: the crate stays empty and `REPO.2`'s oracle on it is untouched. The charter is not amended here: `AD-7` and the pointer to the horizon are the owner's amendments at the approval, as `AD-6` was.

| Section of `SPEC.md` | What version 2 changes |
|---|---|
| preamble | version 2, the seven decisions named, `SD-30` among the decisions that bind |
| §1 the unit | two renderers of one model, not two modes; the camera as cells the host reads |
| §2 the frame | the theorem, each frame a total function and the cartridge a productive stream transformer; the step computes values and never formulas; the Write sheet named |
| §3 the devices | the Screen's declared size as the window's; the `look` rows in grid mode; the Palette's twin in the record; Input and Clock at rate 0; two new sheets, Camera (§3.8) and Write (§3.9); the reserved names, now §3.10 |
| §4 the calls | `load` refuses a cell written twice and takes a `value` row as a last value, and loads a `(spec 1)` cartridge; `step` writes no formula; `view` honours the Camera through its window and asks oracle 11 for `look` and `row`; `describe` prints the budget; two refusals |
| §5 the order | the derived writes before the inputs; the Camera and the Write sheet among the effects; rate zero's loop |
| §6 determinism | rule 1 at rate 0; rule 4 with derived writes adding nothing; rule 8, the step computes values and never formulas |
| §7 the cartridge | `(rate 0)`; `(spec 2)` with `(spec 1)` loading too; the `look`, `row` and `value` rows; one write per cell; the replay without derived writes |
| §8 the host | the shim's three new duties; the reserved names cited as §3.10 |
| §9 reflection | the candidate `AD-7`, what it keeps and refuses; the Emacs table's `M-:` row and a hook row |
| §10 the limits | the Screen's limits as the draw's, over the window; rate 0; the compute line a budget `describe` prints |
| §11 to §14 | decisions 18 to 24; §12 without the withdrawn sentence and with the composite named for version 3; §13's five tests and the hand-offs; §14's four new sources |
| Appendices | A without its double write; B with a fourth formula, the tower frozen by a write and the Camera over it |

**The decisions, the owner's.** Seven, each with the sitting's recommendation and the alternative declined, listed in `SPEC.md` §11 as 18 to 24 and argued in `docs/ALGEBRA.md` §2 and §3: the Write sheet of values (alternative: keep-last formulas alone, or formula rows beside the value rows, declined under the veto); one model with two renderers through a `look` row (alternative: two modes, the fills of grid mode fixed); rate zero (alternative: the spreadsheet as a special case of the host outside the manifest); the Camera sheet (alternative: an offset the Screen's formulas read through `INDEX`, the whole budget on scrolling); `AD-7` held by a test (alternative: the veto cited in prose); one write per cell (alternative: last wins, silently); the limits restated with the compute line as a budget (alternative: a refusal at load above two million a second, which would refuse a solver cartridge at a rate of 600 that runs honestly slow).

**The catch.** Six. A derived write into a formula cell would remove a rule from the grid, which is the program changing the formula set; it is refused, deterministically, and printed, never silent (`SD-30`). Derived writes must apply before the frame's own writes, or a person's edit could be overwritten by last frame's effect. At rate 0 a derived write must not itself trigger a step, or a Write row that is never empty steps the grid forever. A `value` row in a save follows its `formula` row and must not count as a second write of the cell, or every save would refuse to load under the twice-written rule. The Camera's window may run past the Screen's extent and must read blank, never refuse, since it is read after a step. The plane still reads a blank as 0: the transparent blank waits for the composite projection, so that half a change is not made.

**Oracle.** The page read by the owner against the seven decisions; every claim about Frazaro's code and the record cites the file and lines read; `tools/run_checks.ps1` green; the line endings LF with no byte-order mark, as the living documents are; no stale reference to the reserved-names section as §3.8, which is §3.10 now. The item's own tests, the five of §13, belong to the cut and to `ENGINE.1` and `ENGINE.2`.

**Size.** `~days`, of which the writing was one evening. (*prediction*)

*Built 2026-10-08, awaiting the owner's reading.* What landed: `SPEC.md` as version 2, the table above section by section; `ROADMAP.md`'s `SPEC.2` line marked built, the family's next free number raised to `SPEC.3`, the candidate `AD-7` noted under the register, and the order's sentence naming `SPEC.2` before the four calls; this entry and the evening's sitting above; `README.md`'s row for the page; the map's line; `docs/ALGEBRA.md` §8's dated line. Not touched: `CHARTER.md`, `engine/`, the checks.

*Approved 2026-10-08, the same evening: all seven recommendations, and `AD-7` adopted, in the owner's words, "if `AD-7` solidifies the design we've discussed in SPEC and ALGEBRA, then it's adopted."* What the approval added: `CHARTER.md` amended in place first, as the register requires: §4 retitled for seven rules with its intro naming the seventh, rule 7 written in the rules' own shape with what it keeps, what it refuses and the test that holds it, the frame paragraph naming the Camera and the Write sheet and the page's second version, §1's thesis line made exact by rate zero, §8 naming the program-written formula among what is not built with the pointer to `docs/ALGEBRA.md`, and the preamble's `GENSYM` line carrying `eval`; `ROADMAP.md`'s register gained `AD-7` in the charter's words and the `SPEC.2` line reads approved, awaiting the commit; `SPEC.md`'s preamble, §2, §6, §9, §11 and §13 read adopted where they read candidate; `README.md`'s rules gained the seventh and its table reads seven rules and `AD-7`; `CONTRIBUTING.md`'s cartridge bullet says a cartridge's formulas are fixed at load and the step writes none, and `SECURITY.md`'s last paragraph says so as what a reviewer checks; the map's line and the memory. *Closed 2026-10-08 at the owner's word, the same evening: the roadmap's line moved to the ledger's specification section above, with the cost recorded, one evening against the predicted `~days`; committed at the owner's word, the horizon first and then the page with its close, two commits.*

## `ENGINE.1` — the host shim and the loop: the first slice, the host half against a fake module

*Scoped 2026-10-08, the evening after `SPEC.2`'s close, at the owner's word: the host half of the loop built now against a double of the engine's eleven exports, so that the day the language crate's four calls exist and are published the shim changes nothing and only the module behind it does. The gate stands as the roadmap states it: `vla-lang` has no handle, no `load`, no `write`, no `view` and no plane, and is not on crates.io, so nothing in this slice calls the real module; `engine/` stays empty and the allowlist at zero. The one real module touched is the empty crate's 32-byte wasm, for the instantiation path and the ABI-version refusal. The second slice, the same shim over the real module, waits on the gate and closes the item.*

**Substrate, verified.** Read on the day, by file and never by assumption; Frazaro's tree read and written nowhere.

- *The page's contract with a module.* `Frazaro/web/index.template.html` lines 206 to 230: `putBytes` allocates with the module's allocator and copies into a fresh `Uint8Array` over `memory.buffer`; `readRecord` reads the four little-endian `u32` through a fresh `DataView`, the id and the text through a fresh `Uint8Array`, copies the text out and frees the record; `call` allocates four bytes for the length, calls the export with the arguments and the out pointer, reads the length, frees the four bytes and reads the record; a `raw` flag returns the text as bytes for the one record that is not UTF-8. Lines 535 to 545: `WebAssembly.instantiate(bytes, {})` with the empty import object, `frazaro_abi_version()` compared to the page's constant and refused with a sentence when it differs. `Frazaro/core/src/abi.rs` lines 107 to 125, `record`: the status, the line, the id's length and the text's length as `to_le_bytes`, then the id, then the text, allocated with the allocator's own layout and the total written to `*out_len`; lines 335 to 347, `frazaro_view`'s signature: every text a pointer and a `u32` length, `out_len` last, a window empty for the extent. The memory pair and the record are the shape `SPEC.md` §4.6 gives the engine, name for name.
- *The artifact.* `target/wasm32-unknown-unknown/release/alonzo.wasm`, 32 bytes, `REPO.1`'s build: a table, a memory and one export, `memory`; no `alonzo_abi_version`; `tools/check_host_imports.ps1` OK at 0 imports on the day (*measurement*). Instantiated with an empty import object it loads, and the shim's first question, the ABI number, has no export to ask: the refusal path of `SPEC.md` §8.1 on a real module.
- *The gate.* `Frazaro` at `ceda5ad` (`PORT.12`); its working tree holds an untracked `vla-lang/src/calc/` (five files) beside modified `lib.rs`, `messages.rs`, `sheet.rs`, `view.rs` and `data/messages.vla`, another session's `KERNEL.7` slice 1, uncommitted: a formula parser, the dependency graph, evaluation in topological order, a cycle refused by name, the error values, a registry seam, and `Calc::step(budget) -> Progress { evaluated, of, done }`, the shape §4.4's record spells. Its own doc comment names what is not there: the handle and the four calls, the `.last` twins' snapshot and the plane, "the item after `PORT.12`". No `vla_load`, `vla_write`, `vla_view` or handle anywhere in `vla-lang/src/` (*measurement*, `grep`). The crate carries the workspace's version and is not published. So the double is the only module the shim can run against today, and `Progress` is what the double's `step` record mirrors.
- *The record's spelling.* `web/fixtures/fixture_output.vla` and `fixture_frazaro.vla`: `(sheet "<name>" visible)`, `(window "<sheet>" "<range>")`, `(extent ...)`, `(gridlines "<sheet>" on|off)`, `(column "<sheet>" "<letters>" <width|none> shown|hidden <style|none>)`, `(format <n> <fill|none> general|text wrap|nowrap)`, `(cell "<sheet>" "<addr>" <value>)` with a string's `\"` escaped, `(formula ...)` with `=` first, `(style ...)`, `(sentence ...)`; `vla-lang/src/rows.rs`'s `quoted` writes a string as `WriteDatum` does. `web/viewport.js`'s `readRecord` (lines 213 to 288) reads every row into a model with the counts, and its `Reader` (lines 88 to 140) reads any form, comments included; `Viewport.readRecord` is exported (line 1199), the `Reader` is not.
- *The page, the builder and the checks.* `web/index.template.html` (825 lines): three modes by the query string, the fixtures as `<script type="text/plain">` blocks, the oracle's expectations in the page and never the viewport's, `?bench=1`'s `measuredDraw` (a draw's main-thread cost to a 0 ms task after the frame's rendering, a dropped frame off the next animation frame), `frameInterval` as the median of thirty deltas, the Markdown table and the baseline lines printed for a paste, `&smoke=1` waiting on a task and never a frame. `tools/build_web.ps1` (101 lines): each placeholder exactly as many times as the template has places, `</script` refused, UTF-8 without a mark, `-Template`, `-ViewportJs`, `-FixturesDir` and `-Out` for a control's mutant page. `tools/check_web_offline.ps1`: the tag tokens on the template and the built page, the code tokens on the template and the viewport's source, each `{{FIXTURE:name}}` held to the folder both ways, seven mutants. `tools/check_render_oracle.ps1`: the headless recipe, `Start-Process -Wait` with redirected output, `$onWindows`, the two scales, the floors by case, SKIPPED without a page or a browser, three mutant pages each proving it applied. `tools/check_render_floors.ps1`: the baseline's shape, the bars, seven table mutants, an empty baseline failing by design. `tools/check_view_fixtures.ps1`: the pins over LF bytes, the floors, oracle 11's order read off each record. `tools/check_spdx.ps1`: the `cartridges/` header rule over eleven text extensions, vacuous today. `tools/run_checks.ps1` at a floor of 6 with six controls; `.github/workflows/checks.yml` building the page in both jobs before the runner. `.gitattributes`: `*.vla text eol=crlf`, `*.js` and `*.html` LF; `.gitignore` already ignoring `web/index.html` under an `ENGINE.1` comment; `REUSE.toml` resolving `cartridges/**` to 0BSD.
- *The specification.* §3.1 the plane's bytes and the magenta past the palette; §3.3 the eighteen Input rows and no Input at rate 0; §3.4 the Keys sheet by `code`; §3.5 the Clock's three cells; §3.8 the Camera as the view's window; §3.9 the Write sheet's rules and `cart-write-derived`; §4.2 to §4.7 the four calls, the eleven exports, the record and the refusal ids; §5 the frame's six steps and rate zero; §6's eight rules; §7 the cartridge, Appendix A's Life, one write per cell; §8.1 the empty import object and the ABI number refused; §8.3 the shim's duties; §10 the limits; §13 the three tests the shim owes. `ROADMAP.md`: `ENGINE.1`, `ENGINE.2` (the plane blitted whole, held equal to the record), `ENGINE.3` (the Input rows each frame), `CART.1` (Life, the soup and the gun, the frame floors); `AD-1` to `AD-7`. `docs/ALGEBRA.md` §3 corrections 1 and 3 and §7: why the Write sheet and the Camera exist, the gather cost. `web/CALLOSUM.md` §13: `SD-23`, the interface's own state; `SD-30`, nothing fails silently and nothing succeeds invisibly; `SD-34`, the grid never freezes, its progress a sentence.
- *The machine.* Windows PowerShell 5.1.26100, no `pwsh`; Google Chrome 154 and Microsoft Edge 154 at their known paths; cargo 1.99.0; the six checks and six controls `ALL GREEN` at `a8f5577`, the tree clean and 2 ahead of `origin/main`; seven other Alonzo sessions on the machine, all idle, so a commit here stages by hunk, HEAD plus this item's own.
- *The traps, each met once.* Under a headless browser's virtual time no animation frame follows a scroll and a pending timer beyond a 0 ms chain spends the budget; Edge's launcher detaches from a Bash redirect; `$IsWindows` is read-only under pwsh 7; `return ,$list` to a caller that wraps in `@()` counts one where there are none; a pixel probe at a cell's centre reads glyph ink; a PowerShell 5.1 script without a byte-order mark is read as ANSI; line endings are measured with PowerShell or `tr`, never `grep`; the living documents are LF; `Memory.grow` detaches every earlier buffer, even `grow(0)` (MDN, `SPEC.md` §14); `putImageData` ignores the context's transform and its smoothing flag, so a scaled blit is `putImageData` into a plane-sized canvas and `drawImage` from it.

**The work.** Two scripts, a cartridge, three checks, the page and the builder grown, two checks extended, and the record.

| File | What it is | Copied, adapted, or decided |
|---|---|---|
| `web/fake.js` | the double: `AlonzoFake`, the eleven exports over a real `WebAssembly.Memory` with a bump allocator that counts live allocations, the record of four `u32` then id and text, status 0, 1 and 2, the refusals by id; `load` reading the manifest's directives and never a row; `describe`; `write` applying `cell` and `derived` rows to a hard-coded grid and refusing twins, host-written cells and formula cells; `step` yielding on a budget over a declared cost of width times height cells; `view` as the plane filled from the frame number or as a device sheet's record; `unload`; the memory grown on a schedule; `AlonzoFake.RULES` for an oracle to read | decision 1 |
| `web/host.js` | the shim: `AlonzoHost`, the instantiation with an empty import object and the ABI number refused, the memory pair with every view made fresh, the four calls, the loop of §5 with the accumulator and its cap, the derived writes before the inputs, the eighteen Input rows from the keys through the Keys sheet and the pointer, the budget in cells, the effects read after the step, the Camera as the window, the blit through the Palette, rate zero, the status sentences, the events; plain script, no module, no import; records read with the viewport's reader | decisions 2 to 8 |
| `web/viewport.js` | one addition: `AlonzoViewport.readForms(text)`, the reader it already has, exposed | decision 2 |
| `web/index.template.html` | the engine panel: the module line, the cartridge's text in a box with Load, the plane canvas, the status line and its log, the edit row, Run and Pause, a device sheet shown live in a viewport; `?loop=1`, the host loop's oracle on one `<pre>`; `?blit=1`, the blit's instrument; `{{HOST_JS}}`, `{{FAKE_JS}}`, `{{CARTRIDGE:life}}`, `{{ALONZO_WASM}}` | decisions 12 and 13 |
| `cartridges/life/life.vla` | Life at `(spec 2)`: the manifest with every directive, the sixteen Palette rows one cell each, the rule over `B2:LG199` with a soup from the seed, the 0BSD header; CRLF on checkout | decision 10 |
| `tools/check_cartridge.ps1` | the static check over `cartridges/`: the manifest, the reserved names, the row kinds, one write per cell, the Screen within its size, the Palette's sixteen rows, no volatile function, the header; a baseline that pins how many; `-Control` on a scratch copy with mutants | decision 11 |
| `tools/check_host_loop.ps1` | the loop's oracle under a headless Chromium at ratios 1 and 1.5, the page's `?loop=1` cases held OK and their counts to floors; SKIPPED without a browser or a page; `-Control` on mutant pages | decision 12 |
| `tools/check_blit_floors.ps1` | the blit's baseline, the owner's `?blit=1` run in Chrome in fullscreen pasted in, held to the bars; empty until the owner runs, which fails by design; `-Control` on tables made in memory | decision 9 |
| `tools/build_web.ps1` | the four new placeholders, the cartridges folder held to its places both ways, the wasm inlined as base64 when the artifact exists and left empty when it does not | decision 13 |
| `tools/check_web_offline.ps1` | the code tokens over the two new scripts, the new placeholders counted, each `{{CARTRIDGE:name}}` held to `cartridges/<name>/<name>.vla` both ways; two more mutants | decision 13 |
| `tools/run_checks.ps1`, `.github/workflows/checks.yml` | the floor 6 to 9, the three controls joining the extras; the workflow unchanged in shape | decision 14 |
| `SPEC.md` | one dated correction, the `derived` row, in §3.9, §4.3, §4.7 and §5 step 2, if decision 3 is approved | decision 3 |
| `web/README.md`, `README.md`, `ROADMAP.md`, `REARVIEW.md`, `Delta/CLAUDE.md`, the memory | the page and the shim's API; the table's rows; *Scoped* now, 🟡 and what landed after | decision 14 |

**The decisions, the owner's.** Each with the sitting's recommendation and the alternative it declined.

1. **The double, and what it reads of a cartridge.** `web/fake.js` is the permanent test double of the engine's module: the shim must behave identically against it and, later, the real one, so it answers the eleven exports' JavaScript-side contract to the byte, over a real `WebAssembly.Memory` whose buffer detaches when it grows, which the double does on a schedule (at every `load` and every seventeenth `step`, `AlonzoFake.RULES.growEvery`), so that a shim holding a stale view fails in the oracle rather than in a game. Its allocator is a bump allocator that counts live allocations and checks every `free` against the pointer and length it gave, so the oracle can assert that the host freed every input and every record, which §4.6 demands. What it reads of a cartridge: the manifest's directives, `spec`, `title`, `rate`, `screen` and `seed`, each by one regular expression, refusing a missing or malformed one as `cart-manifest-invalid` naming it and a `(spec n)` it does not read as `cart-spec-unsupported`, since the manifest is the engine's own to read (§4.6: what `alonzo_load` adds to `vla_load` is the manifest and the device checks); the rows after the manifest it never reads, and the grid it answers from is hard-coded and declared in `RULES`: the Screen's cells inside the declared size as formula cells, the device sheets at their §3 layouts as value cells, the Palette the CGA's sixteen, the Keys TIC-80's defaults for player 1, a `State` sheet of value cells, every sheet with a `.last` twin. A write row's three fields it reads with one regular expression, to refuse a twin (`cart-write-last`), a formula into a host-written cell (`cart-device-cell-formula`), an unknown sheet (the `view-sheet-unknown` shape, naming the ones it holds) and, for a `derived` row, a formula cell, a twin or a host-written cell (`cart-write-derived`); a person's formula row it keeps as a formula cell's text and evaluates nothing. Its `step` declares a cost of width times height cells a frame, evaluates nothing and counts: a budget below the remainder yields with `(step <frame> <evaluated> <of> yielded)`, the next call continues, a `write` between a yield and the completion is refused `cart-write-during-step`; when a frame completes the plane's bytes are filled from the frame number (eight-by-eight tiles cycling through the sixteen colours, one row swept by a byte past the palette so magenta is seen, one error byte), the previous plane kept as the twin's, the Write sheet's rows set by a rule of the frame (row 2 writes the frame number into `State!B1`; every seventh frame a row into `Screen!A1`, a formula cell; every eleventh a row into `Input!B5`, host-written; every thirteenth a row into `Screen.last!B1`, a twin), and the frame number advanced. `describe` prints the manifest's directives, a `device` row per device sheet and `(budget <rate> <w*h> <rate*w*h> 2000000)`, its own declared cost. *Alternative:* a double configured by the page, the cartridge's bytes ignored and the rate, the size and the title passed as options; declined because then the shim's load path, bytes in and the record's one row read, is never exercised against a real file, and rate zero would need a second configured double instead of a second cartridge text. *Alternative:* a double that loads the rows into a grid; declined by `AD-1`, the loader being the language's. Recommended: the double as stated.
2. **The two scripts, and the reader the host uses.** The shim is `web/host.js`, `AlonzoHost` the one global, and the double `web/fake.js`, `AlonzoFake`, each a plain script in the viewport's shape, no module syntax, no import, no library, inlined by the builder under `{{HOST_JS}}` and `{{FAKE_JS}}` and scanned by the offline check as the viewport's source is. The host reads every record through `AlonzoViewport.readRecord` (a device sheet's record into cells by address) and a new `AlonzoViewport.readForms` (the four calls' own rows, `cartridge`, `written`, `step`, `unloaded`), so the shim holds no reader of its own and `AD-1`'s line is kept where the viewport already drew it: the record is the interface, and the viewport's reader is the host's one reader of it. *Alternative:* one file for both, or the host with a reader of its own; declined, the first because the first game takes the host alone and the double ships only for the page's self-tests, the second because a second reader of the record is a second implementation of it. Recommended: two scripts and the viewport's reader.
3. **The `derived` row.** `SPEC.md` §3.9 and §5 step 2 have the host issue a Write-sheet row "as a `cell` row" through `write`, and §3.9 has the module refuse a derived write into a formula cell as `cart-write-derived`, while §4.3 lets a person's `cell` row replace a formula, the REPL `AD-7` keeps; a `cell` row cannot be both, and the module cannot tell a derived write from a person's by the row alone. Found on the day, by writing the double: the page is corrected, under its own rule that where the page and the code disagree the page is corrected. Recommended: a row kind for the write call's input, `(derived "<sheet>" "<addr or range>" <value>)`, the `cell` row's twin, which the host issues for every Write-sheet row and the module holds to §3.9's rules; a cartridge never holds one (the static check refuses it) and a replay never logs one; one dated correction in §3.9, §4.3, §4.7 and §5 step 2, the ABI number unchanged since no signature changed its meaning. *Alternative:* a flag argument on `alonzo_write`, an ABI change for one bit, or `SPEC.3` minted for the row; declined, the first for its cost and the second because a correction is what the page's preamble allows without a version. *Alternative:* the host deciding by asking `view` whether the target is a formula cell; declined by `AD-6`, the host holding nothing but the interface's state, and by the cost, a view a row a frame.
4. **The loop, its clock and its budget.** The fixed timestep of §5 over `requestAnimationFrame`'s timestamp: the first tick primes the clock and runs no frame; each later tick adds the elapsed time, capped at 250 ms (`AlonzoHost.RULES.capMs`), to the accumulator and runs one frame for each interval it holds, subtracting the interval, never interpolating and never skipping; the page hidden stops the ticking and the accumulator is reset on return. The budget: the first call of a cartridge 16,000 cells (`RULES.firstBudget`), then the cells the last call did per millisecond times a slice of half the display's interval (the interval measured as the median of the first thirty deltas, the bench's rule), at least 1,000 and at most the frame's own total, so the step reports work and the host turns its time into cells as §4.4 says; within a tick the host calls `step` again while the frame is unfinished and the slice is unspent, then yields to the browser; a frame that yields across ticks is drawn when it completes and its progress is a sentence meanwhile. For the oracle the host's clock and its budget are injectable (`options.now`, `options.budget`), so the yield count is a function of the log. *Alternative:* a budget in milliseconds inside the module, declined by §4.4; no budget, declined by `SD-34`; a loop by `setInterval`, declined by Fiedler and §5. Recommended as stated.
5. **The inputs, all eighteen rows.** Each frame at a rate above zero one `write` of the Input sheet: the ten buttons for players 1 to 4, forty cells, from a set of held `KeyboardEvent.code`s (`keydown` adds, `keyup` removes, `blur` clears, so a key released while the window is unfocused never sticks) mapped through the Keys sheet the host read after the last step; the pointer's Screen column and row over the plane canvas through the blit's scale, 0 when off; the three buttons and the wheel's notches; the last key as `key` and `code` or empty; forty-eight cells, the fake answering `(written n)` for the ones that changed. A person's edit, from the page's edit row, is queued and issued in the same call after the Input rows (§5 step 3), so it wins over a derived write to the same cell. At rate 0 the Input sheet is never written (§3.3). This takes `ENGINE.3`'s host half, since the loop must write the sheet whole and the pointer costs ten lines; `ENGINE.3` keeps the Clock's frame cell seen to advance in the real module and the gamepad named in §3.10. *Alternative:* the button rows alone and zeros for the pointer until `ENGINE.3`; declined, a half-written sheet being a sheet nobody can read. Recommended as stated.
6. **The effects, read by record.** After a completed step the host asks `view` for the plane of the Screen's window, then for the record of each effect sheet, Palette, Audio, File, Keys, Camera and Write, six small records a frame read with the viewport's reader; it keeps from them only what the next frame needs, the palette's table, the key map, the Camera's two cells, the pending derived rows, the Audio rows and the File's `save` value it shows and does not yet render (`ENGINE.4`, `ENGINE.5`), which with the pointer's place, the held keys, the accumulator and the budget is `SD-23`'s list as §8.3 extends it, and holds no model. The Camera: a whole number from 1 in each cell, else 1 and a sentence (§3.8); the window passed to the next frame's plane view is the declared width and height placed there, spelled as a range. *Alternative:* one record of every device, which the page does not define; declined. Recommended as stated.
7. **The status line, under `SD-30` and `SD-34`.** Every event a sentence, the latest in the status line and the last twenty in a log beside it, so that nothing fails silently and nothing succeeds invisibly: the load (`Loaded Life: a 320 by 200 plane at 30 frames a second, seed 1, from the fake module.`), a yield (`frame 42, 20,000 of 64,000 cells`), a refused derived write with its id and the module's words (`frame 7: a derived write into Screen!A1 was refused: cart-write-derived, ...`), the Camera moving the window (`frame 13: the Camera placed the window at C7:LJ206.`), a Camera cell that is not a whole number from 1, an edit at rate zero (`edit 3 of Camera!B1: stepped once; frame 3.`), the ABI refusal (`This page expects the engine ABI 1 and the module says 2.`; `The module exports no alonzo_abi_version: the crate is empty (REPO.1); the loop runs against the fake module.`), a `save` edge named for `ENGINE.5`. *Alternative:* a status line alone; declined because a refusal at thirty frames a second is gone before it is read. Recommended: the line and the log.
8. **The blit.** The plane's bytes through the palette's table, 256 entries of RGBA with magenta past the palette's count, into one `ImageData` of the window's size reused frame to frame, `putImageData` into a plane-sized offscreen canvas, then `drawImage` onto the visible canvas with `imageSmoothingEnabled` false at an integer scale `s = floor(min(boxW·dpr / w, boxH·dpr / h))`, at least 1, the visible canvas's backing store `w·s` by `h·s` device pixels and its CSS size that over the ratio, so a cell is a square of whole device pixels and the image is crisp at the machine's ratio (§1); the palette's table rebuilt only when the Palette's record changes. *Alternative:* a WebGL texture of indices with the palette in a fragment shader, the escape hatch §5 names, taken when a measurement on `CART.1` names the blit as the bottleneck; a `fillRect` a cell, 64,000 calls a frame, declined on sight. Recommended as stated.
9. **The blit's instrument, and its bar.** `?blit=1` runs the double at 320 by 200 for 120 frames at the integer scale that fits the box, in the owner's fullscreen run the screen, and again at a scale of 1, each frame's cost measured by `KERNEL.3`'s method, from before the view call to a task queued after the frame's rendering, a dropped frame read off the next animation frame, and prints the table and the baseline lines for `tools/check_blit_floors.ps1`, whose baseline is empty until the owner's run in Chrome in fullscreen is pasted in, as the render floors were. The bar, derived from the charter's frame budget: at 30 frames a second the step at the two-million line takes the whole 33 ms interval, and at 60 the interval is 16.7 ms, so the draw must be a small fraction of either; recommended, the blit p95 under 2.0 ms, an eighth of a 60 Hz interval and a sixteenth of a 30 Hz one, the max under 4.0 ms, no frame dropped and the page's own verdict yes, at both scales. *Prediction* (2026-10-08): the view call's copy of 64,000 bytes under 0.1 ms, the palette fill of 64,000 pixels under 0.5 ms, the two draws under 1 ms at the fitting scale of 7 on the owner's screen (2240 by 1400 device pixels), so a p50 under 1.5 ms and a p95 under 2.0. A headless number is never a floor; a number that misses the bar is a finding to record, not a floor to lower. *Alternative:* a bar in intervals as the render floors have it, one and a half intervals; declined as no bar at all for a blit. Recommended as stated.
10. **The Life cartridge.** `cartridges/life/life.vla`, Appendix A's shape at `(spec 2)` with every directive, `author`, `licence` and `notes` included, one argument a line with a comment per line as the owner's rule has every patch source; two `sheet` rows; the sixteen Palette rows as forty-eight `cell` rows, one write per cell, index 0 black `dead`, index 1 white `alive`, and the CGA's other fourteen in order from 2, so that a cell holding 1 draws white and the rule stays arithmetic over 0 and 1; one `formula` row over `B2:LG199`: on the first frame a soup, otherwise Conway's rule over `Screen.last`. The soup, a soup worth the name: `MOD(a*b, 67108859) < 25165822`, `a` and `b` two linear forms of the seed, `ROW()` and `COLUMN()` reduced modulo the prime `2^26 - 5`, so that every product stays under `2^53` and the hash is exact in doubles for any seed up to 2147483646, at a density of three eighths; measured at the build in PowerShell over the 320 by 200 grid for the seed 1, the density, the lag-one correlation along rows and columns and the longest run recorded in the build record, since no evaluator exists here to draw it; `CART.1` picks the final soup and adds the gun. Only functions of `KERNEL.7`'s day-one list: `IF`, `OR`, `AND`, `SUM`, `MOD`, `ROW`, `COLUMN`, the comparisons and the arithmetic. The header `; SPDX-License-Identifier: 0BSD` as the first line; the file CRLF on disk, measured. *Alternative:* Appendix A's toy hash verbatim, a stride of two primes modulo 7; declined, the owner having asked for a soup worth the name and the appendix calling its own a toy. Recommended as stated.
11. **The cartridge check.** `tools/check_cartridge.ps1`, a static check over every `.vla` under `cartridges/`, reading the file with a reader of forms written in the script (comments, strings with `\"` and `\\`, numbers, symbols, lists), and holding each to §7: the header as the first line; the manifest form first, its name lowercase letters, digits and hyphens, every required directive present once and in range (`spec` 1 or 2, `title` a text, `rate` a whole number 0 to 120, `screen` `plane` at most 320 by 200 or `grid` at most 80 by 50, `seed` a whole number from 1 to 2147483646 or `host`), the optional ones at most once, an unknown directive refused; every row after it one of §7.3's kinds in its shape, a `derived` row refused; the reserved names (no sheet ending in `.last`, every sheet's name at most 26 characters, a device sheet's cells inside its §3 layout, no formula in a host-written cell); one write per cell across rows and range fills, both lines named, a `value` row after its `formula` row excepted; the Screen's cells within the declared size when no Camera sheet exists; in plane mode the Palette's sixteen rows in order with `#RRGGBB` colours in column B; no `NOW`, `TODAY`, `RAND` or `RANDBETWEEN` in any formula. A baseline that pins how many cartridges (one) and each cartridge's row count as a floor. `-Control` on a scratch copy of the Life file with twelve mutants, each asserting its anchor once and proving it applied before the check is asked: a directive dropped, a rate of 121, a screen 321 wide, a cell written twice, a cell outside the Screen, a Palette index out of order, a colour that is not `#RRGGBB`, `NOW()` in the rule, a sheet named `Board.last`, the header dropped, an unknown row kind, a formula into `Input!B1`. Whether the check is minted as a repository item is the owner's call: recommended, it rides under `ENGINE.1` as the fixture's own check, the fixture and the check landing together; *alternative:* `REPO.4 — the cartridge check`, a line of its own.
12. **The loop's oracle.** `?loop=1` runs, synchronously and with no frame awaited, the host over the double against a fixed input log the page holds, driving `host.tick(ts)` with synthetic timestamps and the host's clock and budget injected, and prints one line a case into `<pre id="loop">` with its counters: the frames stepped, the step calls and the yields, the Input rows written, the derived writes applied and refused, the windows the plane was viewed through, the sentences printed, the live allocations and the misfrees at the end, the end state's digest. Every expectation is computed in the page from the log, the accumulator's arithmetic re-done over the timestamps, the Input rows from the key events, the derived counts from the double's declared rule, the digest from a second double driven directly by the oracle's own loop with no host between, and never by calling the host. The cases: `rate30`, forty frames with keys held over frames, the pointer placed, the Camera moved by an edit and the window following, a person's edit of `State!B1` in the frame a derived write targets it, the edit winning, a stalled tick of one second running seven frames and no more; `rate0`, the same text with `(rate 30)` replaced by `(rate 0)` (the anchor asserted once), four edits stepping four frames with the Input sheet never written and the derived writes issued before each edit's step; `yield`, a budget of 1,000 over 64,000 cells, sixty-four calls a frame and the progress sentence's text; `abi`, a double at ABI 2 refused with the sentence, a double without the export refused, and the inlined module when the page holds one refused for want of the export, else `none built in`; `refusals`, a manifest without `rate`, a `(spec 3)`, a write into an unknown sheet, each refused by id and printed; `memory`, the double's memory grown on its schedule and every view made fresh, no allocation live at the end; `scale`, the integer scale and the backing store at the box's size and the ratio, and a pixel probe at a corner inside a cell of a known byte, black for 0 and magenta for a byte past the palette. `tools/check_host_loop.ps1` runs the page under a headless Chromium at `--force-device-scale-factor` 1 and 1.5 in `check_render_oracle.ps1`'s shape, reads the element, holds every case OK and its counts to floors, SKIPPED with exit 0 without a page or a browser; `-Control` on three mutant pages built by the builder from mutated sources, each proving it applied: the cap raised to 2,500 ms (`var ACCUMULATOR_CAP_MS = 250;`, the header printing `cap=2500`), which the stalled tick must fail; the derived writes issued after the inputs, which the edit-wins case must fail; the oracle's element cut from the template, which the check must fail for want of the block. *Alternative:* a loop under real animation frames in the headless browser; declined by the day's trap, no frame follows a scroll under virtual time and a timer spends the budget, and because an equality needs no clock. Recommended as stated.
13. **The page and the builder.** The engine panel above the viewport's: the module line (`the fake module`, or the built wasm's refusal), the cartridge's text in a box, editable, with Load, so that a person turns `(rate 30)` into `(rate 0)` and sees the loop change its shape, which is the only second cartridge this slice needs; the plane canvas in a box the blit sizes; the status line and the log; the edit row, one row in the one notation issued as a person's write (`(cell "Camera" "B1" 7)`); Run and Pause; a picker of a device sheet whose record a second viewport shows after each step, the Write sheet, the Camera, the Palette, the Clock, the Input sheet, which is `AD-6` seen. `tools/build_web.ps1` fills `{{HOST_JS}}` and `{{FAKE_JS}}` once each, `{{CARTRIDGE:life}}` with `cartridges/life/life.vla` normalized to LF (the folder held to the places both ways, as the fixtures are), and `{{ALONZO_WASM}}` with the artifact as base64 when it exists, else with nothing, the page then saying no module was built in, so the ratchets job, which has no cargo, builds a page and the crate job builds one with the module; `check_web_offline.ps1` scans the two scripts for the code tokens and holds the new placeholders and places. CI unchanged in shape, both jobs building the page before the runner. *Alternative:* a second template for the engine's page, declined as `KERNEL.5` declined it, two pages holding the same fixtures. Recommended as stated.
14. **The bookkeeping.** `run_checks.ps1`'s floor from 6 to 9, three checks and not the two the brief counted, the blit floors being a check of their own as the render floors are, and the three controls joining the extras, nine verifiers; `ROADMAP.md`'s `ENGINE.1` line gains *Scoped* now and the built marker for the first slice after, the item staying open until the second slice runs the same shim over the real module; this entry; `README.md`'s table with a `cartridges/` row; `web/README.md` with the page and the shim's API; the map's line; the memory. The commit at the owner's word, `ENGINE.1: the host half of the loop against a fake module, with Life and the cartridge check`, with Pins, Floors and Docs, its message by `-F`. Recommended as stated.

**The catch.** Each met once, or foreseen by reading.
- `putImageData` ignores the transform and the smoothing flag, so the blit is two draws; `ImageData` wants a `Uint8ClampedArray`, built once and reused.
- `Memory.grow` detaches every earlier buffer, so the host makes every `DataView` and `Uint8Array` fresh and the double grows on a schedule to prove it.
- The animation frame's timestamp is the clock, never `performance.now()` beside it, or the accumulator drifts by the callback's latency; the first tick runs no frame.
- A yielding step and the inputs: a `write` during a yield is refused by the module, so the host issues the next frame's writes only after `done`.
- At rate 0 a derived write must not step the grid, or a Write row that is never empty steps it forever; the pending rows wait for the next edit.
- Keys stick when the window loses focus; `blur` clears the set.
- `check_web_offline.ps1`'s code tokens are scanned over the scripts' comments too, so no address and no `url(` is written in a comment.
- The cartridge's `.vla` is CRLF in the working copy and LF in the blob; the builder normalizes it, the check normalizes it, and the file is written CRLF and measured.
- PowerShell 5.1 as every check met it: ASCII, `return ,$list`, no `Write-Output` inside a function a caller reads, Continue around the browser, the Write tool and never a heredoc, a commit message by `-F`.
- The tree is shared; the roadmap and this file are staged by hunk, HEAD plus this item's own.

**Oracle.** On the owner's machine under Windows PowerShell 5.1, then on both jobs:
- `run_checks.ps1 -WithExtras` at 9 checks and 9 verifiers `ALL GREEN` with the new floors, after the owner's blit table is pasted; before it, 8 of 9 with the blit floors failing by design.
- `check_host_loop.ps1` green under headless Chrome and Edge at both ratios, every case OK, every count at its floor; its control: three mutant pages fail, each for its own reason, each proving it applied.
- `check_cartridge.ps1` green on Life and red on each of its twelve mutants under `-Control`.
- `check_web_offline.ps1` green on the template, the three scripts and the built page.
- The owner's run of the page by hand: the loop running against the fake at 30 frames a second, the plane's tiles cycling and the magenta row sweeping; a device sheet's record changing in the viewport each frame; a row typed in the edit row and the status line saying so; the Camera moved by an edit and the window following; a derived write refused and printed with its id; the cartridge's `(rate 30)` edited to `(rate 0)` and reloaded, an edit stepping once and the frame number counting edits; then `?blit=1` in Chrome in fullscreen, the table pasted into `check_blit_floors.ps1` by the session.
- `check_host_imports.ps1` still at 0 on the 32-byte artifact; nothing under `engine/` touched; `git status` showing only the files in the table.
- CI green on both jobs at the owner's push.

**Size.** `~days`: the double about four hundred lines, the shim about six hundred, the page's panel and two modes about five hundred, the cartridge about sixty, the three checks about a thousand together, then the owner's runs. (*prediction*)

*The first slice built 2026-10-08, awaiting the owner's run.* The owner approved all fourteen recommendations. What landed: `web/fake.js` (595 lines: `AlonzoFake`, the eleven exports over a real `WebAssembly.Memory`, a bump allocator that counts what is live, checks every free and starts its arena again when nothing is live, the memory grown by zero pages at every load and every seventeenth allocation; the manifest's five directives each by one regular expression, the rows never read; the grid declared in `AlonzoFake.RULES`, the plane's tiles and its magenta sweep, the CGA palette, TIC-80's keys, the Write sheet's rule of the frame, and a history cell in `State!B2` that folds every frame's `State!B1` and Input sheet into one number by Park and Miller's step, so the end state's digest witnesses the order of every write; `stats`, `digest` and `peek` for an oracle, never for the host); `web/host.js` (659 lines: `AlonzoHost`, the ABI asked first and every export checked, the memory pair with every view made fresh, the loop of section 5, the eighteen Input rows, the effects, the blit, rate zero, the sentences and the log, `runFrameSync` for the instrument); `web/viewport.js`'s one addition, `AlonzoViewport.readForms`; `cartridges/life/life.vla` (103 lines, CRLF, 51 rows); the page's engine panel, `?loop=1` and `?blit=1` (the template 825 to 1,409 lines); `tools/check_cartridge.ps1`, `tools/check_host_loop.ps1` and `tools/check_blit_floors.ps1`, each with its control; `tools/build_web.ps1` with the four new placeholders; `tools/check_web_offline.ps1` over the three scripts with two more mutants; `tools/run_checks.ps1` at a floor of 9 with nine controls; the workflow's comments; `SPEC.md`'s dated correction; `web/README.md`, `README.md`, the roadmap's line, this record, the map's line and the memory.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1.26100 (*measurement*): `check_host_loop.ps1` clean under headless Chrome 154.0.8037.93 and Edge 154.0.4258.62 at ratios 1 and 1.5, seven cases, 1.2 s a run, the counts the log's on every browser and ratio: rate30 42 frames, 42 Input writes, 41 derived writes landed and 11 refused, 4 edits written and 1 refused, 3 windows, 22 sentences, 111 detachments, `State!B1` holding 999 after the frame of its edit; rate0 4 frames for 4 edits, no Input row written, 3 windows; yield 9 frames in 608 step calls and 599 yields, every progress sentence the log's, the edit made during a yielded step held to the next frame; memory 14 frames and 637 detachments, one an allocation; abi 4 refusals, the 32-byte module among them; refusals 5; scale 2 at a ratio of 1 and 3 at 1.5, six pixels read back exact through the palette, black, a colour and magenta; no allocation live and no misfree anywhere. Its control: the cap raised to 2,500 ms printed `cap=2500` and failed the stall, the host at frame 60 where the log said 37; the derived writes swapped after the inputs left `State!B1` at 16 where the edit wrote 999, and the digest differed in three cases; the cut element left no block. `check_cartridge.ps1` clean on Life, 51 rows, 63,012 cells written, 62,964 of them formula cells, 0.6 s; its control fails thirteen mutants. `check_web_offline.ps1` clean on the template, the three scripts and the built page (897,379 characters, the 32-byte module inlined); its control fails nine. `check_blit_floors.ps1` fails on its empty baseline as designed; its control fails seven. The render oracle unchanged, twelve cases clean; the blit's instrument run end to end under `&smoke=1`. `run_checks.ps1 -WithExtras`: 9 checks, 8 passed and the blit floors failing as designed, 9 verifiers passed. `check_host_imports.ps1` still at 0 on the 32-byte artifact, nothing under `engine/` touched.

Five corrections to the scoping, each found on the day. **The write is atomic, so each refusable row is its own write.** Writing the double showed that a write call has to change nothing when it refuses a row, or the record's one status cannot say what landed; then a person's edit in the inputs' call, as section 5's step 3 had it, would refuse the frame's inputs whenever the edit was refused, and a replay's frames would depend on how its rows were grouped into calls. So the host issues each person's edit, like each derived row, as a write of its own, and the dated correction to `SPEC.md` covers §5 step 3 beside the four places decision 3 named. **The soup is the square of the scoping's hash.** Decision 10's `MOD(a*b, P) < T` measured well on density (0.372 to 0.376 over four seeds) and on neighbours (a lag-one correlation under 0.006), and failed the test of 2×2 blocks, a chi-square of 268 to 332 on 15 degrees of freedom where about 15 is due, with every longest run exactly 15 cells: a product of two linear forms is a quadratic in the row and the column, whose mixed second difference is constant, so the fourth cell of every block is fixed by the other three. Squaring it, `MOD(h*h, P) < T` with `h = MOD(a*b, P)`, measured 10.4 to 19.2 on the blocks, 5.7 to 8.0 on 7 for row triples, longest runs of 19 to 28 cells, density 0.374 to 0.377, every product still under 2^53; a second modulus in place of the square, `MOD(h*M, Q)` with Q = 2^26 - 27, failed worse, 345 to 400. So the cartridge carries the square, and its comment says why. On the seed 1, a reference Life outside the engine (every cell every generation, the border dead) went from 23,683 live cells of 62,964 to 14,482 at generation 10, 6,026 at 100, 3,502 at 500, 2,459 at 1,000 and 1,945 at 2,000, a random soup's decay; that measures the soup and not the engine. **The fitting scale on the owner's screen is 10, not 7.** Decision 9's prediction divided the screen's CSS pixels by the plane and left out the ratio: 2560 by 1440 at 1.5 is 3,840 by 2,160 device pixels, so the plane fits at 10, 3,200 by 2,000; the prediction's times stand to be tested at that scale. **The host reads records through `readForms` alone.** `readRecord` counts a `value` row as unknown and keeps nothing of it, and a real module's Write sheet will carry its values in such rows, so the host takes a sheet's cells from the forms, the `value` row after its formula included; the viewport's reader stays the host's one reader, and `readRecord` is the device sheets' viewport's. **The frame is drawn through its own Camera.** The host reads the Camera and the Palette before it views the plane, so that a frame is drawn through the window and the colours that frame computed; a window from the previous frame's Camera would make a scrolling world shudder by a frame. Section 3.8's "the next frame" is read as the frame the host draws next, the one the step just computed. Beside the five: the yield case needed a third knob, `callsPerTick`, beside decision 4's injected clock and budget, so that the oracle can count a tick's calls without a clock; and the cartridge check's control has thirteen mutants, the twelve of decision 11 and the house's rename of a watched file out of the glob, which the count must catch.

What the plane shows today is the fake module's declared tiles, never Life: Life runs the day the language crate's evaluator steps it, in the second slice and in `CART.1`. A headless run of the plain page shows no frame at all, and that is the browser's clock and not the loop: under a virtual-time budget the animation frames advance only beside a chain of 0 ms tasks, which the page has no reason to keep. On a scratch page holding the same scripts, the production loop under headless Chrome at a ratio of 1.5 ran 60 frames by `requestAnimationFrame` beside such a chain, the budget measured after one yielded call, the plane at 3 device pixels a cell, the refusals and the save edges in the log, a viewport loaded beside it or not; without the chain no frame ran (*measurement*). So the oracle drives the loop by hand, and the owner's hand test in a real browser is the plain page's. The size was as predicted, a day of writing, the shim and the double longer than estimated (659 and 595 lines against six and four hundred) and the checks shorter (847 lines against a thousand). What remains is the owner's: open `web/index.html` and work the engine's panel by hand (the loop running, a device sheet changing in the viewport, a row typed in the edit box and the status saying so, the Camera moved by an edit and the window following, a derived write refused and printed with its id, the cartridge's `(rate 30)` edited to `(rate 0)` and loaded, an edit stepping once); then `web/index.html?blit=1` in Chrome, Fullscreen, Copy when it is done, and the baseline lines pasted into `tools/check_blit_floors.ps1` with the date, which turns the runner `ALL GREEN` at 9 checks and 9 verifiers; then the commit at the owner's word.

*The owner's hand test, a first round, 2026-10-09, in Chrome at a ratio of 1.5, five screenshots.* The loop ran against the fake module past frame 3,202, at 3 device pixels a cell. The window followed an edit of the Camera's row to A7:LH206, and the six rows past the bottom of the Screen were drawn as colour 0. The derived refusals were printed on the frames divisible by 7, 11 and 13, 994 of them by frame 3,202, the count the rule gives. On a fresh load, a Palette edit turned every index-0 cell orange. A range of value cells written over formula cells held a red rectangle still while the pattern flowed around it, a person's write replacing formulas as `AD-7` allows. A Camera edit to the row it already held moved nothing and said nothing. A write into `Screen.last` was refused: the count of edits written stayed at three. Its sentence was pushed out of the twenty-line log within two seconds by the fake's derived refusals, which come about nine a second at 30 frames; that is noted as a finding and not changed. One change at the owner's word: each derived refusal said its clause twice, once in the host's words and once in the module's, and ended in a line number a one-row write always carries. The host now prints the module's words once with the id in brackets, names the cell itself only when the module's words do not, and gives a line only for a write of more than one row. The loop oracle's expectations moved to the new wording, and a pin of its own fails any sentence that says its refusal twice or names a line; it was proved on a scratch host restating the clause, which failed rate30 by name. The frame line's "1 edits" and "1 yields" were corrected. `run_checks.ps1 -WithExtras` after the change: 9 checks, 8 passed and the blit floors waiting; 9 verifiers passed.

*The second round, 2026-10-09.* The owner wrote `(rate 0)` in the edit box, which the host refused as not a row: the directive is the cartridge's, in its text under "The cartridge". That refusal too was pushed out of the log at once, and the owner asked for repeats to be collapsed with counts, "because new messages are impossible to screenshot or copy as quickly as they're pushed out of the buffer". The log now holds one line an event, keyed by the sentence without its frame: a repeat raises its line's count and its last frame (`5 times, frames 7 to 35: ...`), pushes nothing out and leaves the status line to the last new event. The page draws the log in place, so a repeat changes only its own line and the others can be selected and copied; it follows a new line only when the list was already at its bottom. A Copy the log button puts the lines on the clipboard. The loop oracle's rate30 case now holds each target's refused derived writes to one line counting what the model counted (5, 3 and 3), and the refused edit of `Screen.last` still in the log at the end, 14 lines for 22 sentences. On a scratch host whose log kept every sentence apart, rate30 failed by name. The instrument's note in blit mode named the render floors' check, and now names its own. The blit, the engine's second number, measured by the owner the same day (*measurement*: Google Chrome 154.0.8037.93, fullscreen on a 2560 by 1440 CSS screen at a ratio of 1.5, 60 Hz, 120 frames a case):

| case | scale | plane in device px | first ms | view p50 ms | blit p50 ms | sync p50 ms | frame p50 ms | frame p95 ms | max ms | dropped of N | holds the frame |
|---|---|---|---|---|---|---|---|---|---|---|---|
| fit | 10 | 3200 x 2000 | 1.3 | 0.1 | 0.1 | 0.6 | 0.7 | 0.9 | 1.6 | 0 of 120 | yes |
| scale-1 | 1 | 320 x 200 | 0.8 | 0.2 | 0.1 | 0.6 | 0.7 | 1.1 | 2.1 | 0 of 120 | yes |

Against the bars: the frame p95 under 2.0 ms by a factor of two at both scales, the max under 4.0 ms, no frame dropped. Against the prediction written before the run: met, a p50 of 0.7 ms against 1.5 and a p95 of 0.9 against 2.0, at the fitting scale of 10 the correction above gave. The view's copy of 64,000 bytes and the palette's blit each measured 0.1 ms at the median, so the whole frame path minus the evaluator, the writes, the reads, the view and the blit, costs about a twentieth of a 60 Hz interval and a fortieth of a 30 Hz one; the plane is not where a frame's time will go, and the evaluator has the rest. Pasted into `tools/check_blit_floors.ps1` as its first baseline. `run_checks.ps1 -WithExtras`: 9 checks and 9 verifiers, `ALL GREEN`.

*The third round, 2026-10-09: rate zero.* The owner changed the cartridge's `(rate 30)` to `(rate 0)` under "The cartridge" and loaded it: the plane stopped, the host said "Loaded Life: a 320 by 200 plane at rate 0, a step on every edit" and "The budget: 64,000 formula cells a step, one step an edit", and the edit `(cell "State" "B1" 5)` stepped the grid once, frame 1, the step yielding twice on the cold budget, the first after a load being measured before the host knows the machine's speed, and the frame still one. The log kept the rate-30 run above it collapsed, 126, 80 and 68 refusals and 35 save edges, each one line. With that, every item of the hand test is met: the loop running against the fake, a device sheet changing in the viewport, a row typed in the edit box and the status saying so, the Camera moved by an edit and the window following, a derived write refused and printed, rate zero stepping once for an edit, and the blit table pasted. *Owner-tested 2026-10-09.* Found in the last screenshot and fixed at the owner's word: the device sheet's viewport refreshed every sixth frame, which at rate zero is every sixth edit, so after frame 1 the Write sheet still showed its rows as loaded and not the State row frame 1 wrote. The panel now keeps the loaded rate from the host's `load` event and, at rate zero, shows the device sheet after every frame; while the loop runs it stays at every sixth. Proved on a scratch copy of the page driven headless, which is possible here because rate zero steps on the edit itself and needs no animation frame: the rate set to 0, the cartridge loaded, the edit written, and the device sheet's last record read back through a probe on the viewport's `load`. Before the fix it held the header row alone; after it, `(cell "Write" "A2" "State")` and its row. `run_checks.ps1 -WithExtras`: 9 checks and 9 verifiers, `ALL GREEN`. *Committed 2026-10-09 at the owner's word, the first slice whole in one commit; the item stays open for its second slice, the same host over the engine's own module, which waits on the language crate's handle and four calls.*

*Noted 2026-10-10 by `ENGINE.3`'s hand test:* decision 4's cap held the backlog as well as a tick's time to 250 ms, so a rate under four frames a second was never owed a frame, a cartridge at `(rate 1)` to `(rate 3)` never stepped, and the oracle's model had copied the line. `ENGINE.3` holds the backlog to the larger of 250 ms and one frame's interval (that item's entry, below).

## `ENGINE.1` — the second slice: the same host over the engine's own module

*Scoped 2026-10-09, at the owner's word, the day `KERNEL.22` closed in Frazaro: the `alonzo` crate over `vla-lang`'s machine, answering the eleven exports the host already drives, so that the page's loop runs Life as the language computes it and the fake module stays the double the oracle drives. The gate, read on the day, is half met: the handle and the four calls are committed in Frazaro as `6cca2e1`, and they are on no remote and in no registry, Frazaro being six commits ahead of its `origin/main` and `vla-lang` never published, at 0.8.0 by the workspace's version. Asked the same day, the owner chose the route this workspace reserved at `REPO.1`, the language crate from crates.io at exactly `=0.9.0`, and the scoping now: nothing lands here until Frazaro's 0.9.0 is on crates.io, and the build follows the publish. This slice closes the item.*

**Substrate, verified.** Read on the day, by file and never by assumption; Frazaro's tree read and written nowhere, its crates built only into scratch targets.

- *The gate.* `Frazaro` at `6cca2e1` (`KERNEL.22`, owner-tested and closed 2026-10-09), its `origin/main` at `ae99e89`, the 0.8.0 release, so `PORT.12`, `KERNEL.7` and `KERNEL.22` are on no remote (*measurement*: `git status -sb`, `git ls-remote`); the workspace's version `0.8.0`, which `vla-lang` carries, and a `## 0.9.0` section in `docs/RELEASES.md` written ahead of the release, its first note the machine. The other sessions' uncommitted hunks in Frazaro's tree touch nothing under `vla-lang/`. This workspace's `Cargo.toml` has reserved `vla-lang = "=0.9.0"` under `[workspace.dependencies]`, commented, since `REPO.1`; a git dependency on Frazaro would fetch an 11.11 MiB pack (*measurement*).
- *What the language gives an engine.* `vla-lang/src/machine/mod.rs`: `Machine::load` and `Machine::new(draft, library)`, `write(text)` over `cell`, `formula` and `derived` rows applied in order, all or none, `step(budget)`, `view(projection, sheet, window)`, `resume_at(frame)`, `loaded()`, `formulas()`, `frame()`, `in_progress()`; the rows `(loaded ...)`, `(written n)`, `(step f e of done|yielded)` and `(unloaded h)`; `Handles<T>`, from 1, never reused, sixteen live, refusing `grid-handle-unknown` and `grid-handle-limit`. `machine/load.rs`: `read_rows(&[Form]) -> Result<Draft, LineRefusal>`, the record's inverse, and `Draft { workbook, values, lines, cells }` with every field public, so that an engine reads and writes the grid between the two calls, which is why the load is two. `sheet.rs`: `Workbook::ensure_sheet` and `find_sheet`, `Sheet::set`, `Cell` and `Content` public. `calc::library::language()`, the fourteen day-one functions; `calc::calls(text)`, the functions a formula's text calls. `messages.rs`: `Catalogue::parse` and `raise`, public so that, in the module's words, "a crate above this one holds a catalogue of its own and falls through to the language's". `abi.rs`: nine `vla_*` functions, exported only under the `c-abi` feature, since a library crate's C export is exported again by every module built on it. `machine/plane.rs`: a whole number from 0 to 254 is itself, an empty cell and a formula before its first value 0, anything else 255; its doc calls the plane "a projection by name beside the grid's record, not an implementation of `Projection`". `data/messages.vla`: the `grid` family's eleven texts, eight of them opening `Line {line}`.
- *The hand-off.* The Frazaro session's reply of 2026-10-09, given in the chat as the house gives a prompt: the Rust route (the cartridge read with `read_forms`, the manifest set aside, `read_rows(&forms[1..])`, the devices checked on the draft, the volatile functions scanned by the engine since the language refuses them as `calc-function-not-computed` without naming the Clock, the Clock and File cells written into the draft, then `Machine::new`); the C surface; a table of the double's ids against the module's; six points for this page to settle.
- *A crate over the machine, measured.* A scratch crate of one export over `Machine::load`, `step` and `view`, `vla-lang` by path, built `--release --target wasm32-unknown-unknown` under this workspace's profile: 8.5 s, 322,494 bytes, exporting `memory` and its one function and nothing else, and `tools/check_host_imports.ps1 -Path` on it `OK` at 0 imports (*measurement*). The language's own module with its C surface, built into a scratch target: 425,446 bytes, the Frazaro session's figure.
- *Life in wasm, measured.* The language's module driven through its C surface from a scratch page under headless Google Chrome 154.0.8037.93, Life's rows with the manifest set aside and the Clock's three cells added, as the engine's load will make them, two runs: the instance in 1.2 ms; the load 131 ms, `(loaded 1 3 63018 62964)`, the memory from 1.1 MB to 21.4 MB; the first frame, the soup, 189 ms; frames 2 to 11 a median of 267 to 278 ms, 226,000 to 236,000 cells a second, 93 to 97% of the native 244,000; 23,683 live cells at frame 1 and 14,482 at frame 11, generations 0 and 10 as the reference Life outside the engine counted them at the first slice; frame 12 stepped again on a second handle in budgets of 2,000 cells, 32 calls in 266 to 337 ms, its plane equal to the unchunked frame's byte for byte; the plane view of the 320 by 200 window 3.0 to 5.4 ms a frame, where the fake's was 0.1 ms in the blit's baseline; a device sheet's record 0.5 to 0.6 ms; the record of any sheet listing every sheet, the twins `hidden` after the cartridge's own; the memory 61 MB with two Life grids loaded; a write into `Screen.last!B1` answered `grid-write-last` and a derived row into `Screen!B2` `grid-write-derived`, each text opening `Line 1` (*measurements*).
- *The host's contract with a module.* `web/host.js`: the ten functions and `memory` checked at `attach`, after `alonzo_abi_version`; the answers read with `readForms`, `(cartridge <h> "<title>" <mode> <w> <h> <rate>)`, describe's `(seed ...)`, `(device "<sheet>" "<range>" <direction>)` and `(budget ...)`, `(step ...)`, a sheet's cells by its `cell` and `value` rows; the Input sheet's eighteen rows written every frame at a rate above zero, whatever the cartridge holds; `words(r, oneRow)`, the module's words, then ` (line N)` for a write of more than one row, then `[id]`; `FIRST_BUDGET` 16,000 cells and `SLICE_FRACTION` 0.5; no branch on an id anywhere. `web/index.template.html`: a built-in module that attaches is preferred and the fake is the fallback, its reason said; the `abi` case expects the built-in module refused for want of `alonzo_abi_version`, the empty crate's answer; the device-sheet picker holds the fake's nine sheets with `Write` selected. `web/fake.js`: SPEC §4.7's proposed ids, `cart-handle-unknown`, `cart-write-during-step`, `cart-write-last`, `cart-projection-unknown`, `cart-write-derived` for a formula cell, a twin and a host-written cell alike, and `view-sheet-unknown` for a write; `LAYOUT`, `HOST_CELLS` and `DERIVED_BLOCKED`; describe listing all nine devices.
- *The rest.* `engine/` is `REPO.1`'s crate, empty, `publish = false`, its `[dependencies]` empty with the comment that the language crate joins at `ENGINE.1`; the crate job of `.github/workflows/checks.yml` builds, formats, lints and tests the workspace, builds the wasm and the page, and runs the runner under pwsh; `REUSE.toml` resolves `engine/**` to Apache-2.0; `.gitattributes` gives `*.vla` CRLF on checkout. `run_checks.ps1` at `984722a`: 9 checks, `ALL GREEN`; the tree clean and three ahead of `origin/main`.

**The work.** The engine crate, two checks, the double's ids, two corrections and a sentence in the host, the page's oracle grown, SPEC's dated corrections, and the record.

| File | What it is | Copied, adapted, or decided |
|---|---|---|
| `Cargo.toml`, `engine/Cargo.toml`, `Cargo.lock` | the reserved pin made real, `vla-lang = "=0.9.0"`, and `vla-lang.workspace = true`, the engine's one dependency | decision 1 |
| `engine/src/abi.rs` | the eleven exports over the handles; the memory pair and the record byte for byte as the language's | decision 2 |
| `engine/src/cartridge.rs` | the manifest read with the language's reader; the device layouts; the checks at load and at a write; the engine's own sheets; the Clock's frame; describe | decisions 3 to 6 |
| `engine/data/messages.vla` | the `cart` family, eight entries, read by `vla_lang::messages::Catalogue` | decision 7 |
| `engine/src/lib.rs`, `engine/README.md` | the crate's doc and page: what it holds now | decision 15 |
| `web/fake.js` | the ids the module answers | decision 8 |
| `web/host.js` | the first budget, the line said once, the sentence for `(seed host)` | decision 9 |
| `web/index.template.html` | the picker from the grid's sheets; `?loop=1`'s `engine` and `parity` cases with a reference Life; `abi`'s last attempt | decisions 10 and 11 |
| `tools/check_host_exports.ps1` | the export section held to the eleven names | decision 12 |
| `tools/check_engine_deps.ps1` | `AD-5`'s second sentence on the manifests and the lock | decision 12 |
| `tools/check_host_loop.ps1` | the two cases required of a page that holds a module; a fourth mutant page | decision 11 |
| `tools/run_checks.ps1`, `.github/workflows/checks.yml` | the floor 9 to 11, two controls joining the extras; the crate job unchanged in shape, its comment naming the dependency | decision 12 |
| `SPEC.md` | the dated corrections | decision 14 |
| `ROADMAP.md`, `REARVIEW.md`, `README.md`, `web/README.md`, `CONTRIBUTING.md`, `SECURITY.md`, `Delta/CLAUDE.md`, the memory | the line, this record, the tables and pages | decision 15 |

**The decisions, the owner's.** The first was taken on the day; each of the rest with the sitting's recommendation and the alternative it declined.

1. **The route: the language crate from crates.io at exactly 0.9.0, and the build after its publish; taken by the owner on the day.** `[workspace.dependencies]` gains the line `REPO.1` reserved, `vla-lang = "=0.9.0"`, and `engine/Cargo.toml`'s `[dependencies]` its one line, `vla-lang.workspace = true`; `Cargo.lock` records the registry's checksum, and CI fetches the crate as any build does, a fetch of the build's and never of the engine's, which is what `SD-13` governs. The build begins when crates.io lists `vla-lang` 0.9.0, which Frazaro's release and the crate's first upload by hand make so (`Frazaro/docs/DEPLOY.md`, "Publishing the crates"). *Alternatives, declined by the owner:* a git dependency pinned to `6cca2e1` after a push of Frazaro's six commits, which would have unblocked the commit this week; a path dependency on a sibling tree, which the crate job, checking out this repository alone, cannot resolve. What the wait costs, named so that it is weighed rather than met: a gap this engine finds in the language after 0.9.0 is a 0.9.1, where before the cut it is a commit; reading alone found one (decision 13), so this scoping's findings are recommended to reach Frazaro before the cut.
2. **The engine's surface: eleven exports of its own over the language's Rust calls, and the language's C surface exported by nothing.** `engine/src/abi.rs` holds `alonzo_abi_version` (1), `alonzo_version_text`, `alonzo_alloc` and `alonzo_free` with the language's layout, `alonzo_load`, `alonzo_describe`, `alonzo_write`, `alonzo_step`, `alonzo_view` and `alonzo_unload`, each `#[no_mangle] extern "C"`, every answer the record of §4.6 built as `vla-lang/src/abi.rs` builds its own, byte for byte, an input that is not UTF-8 answered with status 2 naming it; the grids in a `vla_lang::machine::Handles` of the engine's cartridges, each the machine with its manifest and its device layout beside it, in a thread-local static as the language's table is. The version text is `alonzo 0.1.0 (vla-lang 0.9.0)`, so that the page's module line names both. The language's `c-abi` feature is never turned on, so its nine `vla_*` functions are compiled into the module and exported by nothing, which decision 12's check holds. *Alternative:* the page driving the language's own module through `vla_*`, with the manifest and the devices in JavaScript; declined, since the device checks are the engine's by §4.6, testable natively only in Rust, and a door into the grid past them is what `KERNEL.22` gated its C surface to prevent. *Alternative:* the language's surface re-exported beside the engine's; declined for the same door.
3. **The load, in §4.2's order, over the language's two calls.** The bytes read as UTF-8, else status 2, and by `read_forms`. The first form must be `(cartridge "<name>" ...)` with §7.2's directives, every required one once and in range and the optional ones at most once, an unknown one refused, each defect `cart-manifest-invalid` naming what is wrong, and a `(spec n)` other than 1 or 2 `cart-spec-unsupported`. Then `read_rows(&forms[1..])`, whose refusals are the language's with the row's own line (`grid-row-unknown`, `grid-row-malformed`, `grid-cell-written-twice`, `grid-sheet-name-invalid`, `grid-too-many-cells`). Then the device checks over `draft.workbook`, by the layouts the double declares: a Screen cell outside the declared size when there is no Camera sheet (`cart-screen-outside`); in plane mode a Palette whose `A1:A16` are not the numbers 0 to 15 in order, or one of whose `B1:B16` holds a value that is not `#RRGGBB` text (`cart-palette-invalid`; a formula there is allowed, a palette's cycling being a formula, and its value is the host's to judge after a step, as the host already does); a formula in a cell the host writes (`cart-device-cell-formula`); a cell of a device sheet outside its layout (`cart-device-cell-outside`); a formula anywhere whose text calls `NOW`, `TODAY`, `RAND` or `RANDBETWEEN`, read by `calc::calls` (`cart-formula-volatile`, naming the cell, the function and the Clock). Then the engine's own sheets, made in the draft before the graph reads them: the Clock's labels, its `frame` 0 or a save's frame (decision 5), its `rate`, and its `seed` from the manifest, `Clock!B3` left empty under `(seed host)`; the File's labels, its `name` as the host gave it or `the cartridge`, its `size` in bytes; and, when the cartridge holds none, the Input sheet with its eighteen labels and zeros. Then `Machine::new` under the language's library, whose refusals are recalculation's (`calc-cycle`, `calc-function-not-computed`, `calc-construct-not-read`), and the answer, `(cartridge <handle> "<title>" <mode> <w> <h> <rate>)`. SPEC's proposed `cart-sheet-reserved` is not minted: a name ending in `.last` is the language's `grid-sheet-name-invalid`, and a device sheet used for something else is a cell outside its layout. *Alternative:* no Input sheet made, the host writing its rows only when describe lists one; declined, since a cartridge that reads `Input!B5` would then have to declare a sheet it never writes, and the rule the page keeps for the Clock and the File, that the engine's input devices exist in every grid, is the one a stranger cannot get wrong.
4. **The write: the engine's checks over every row first, then the machine's write, all or none.** For each `cell`, `formula` or `derived` row naming a sheet the grid holds, the engine refuses a formula into a cell the host writes (`cart-device-cell-formula`), a cell outside a device sheet's layout (`cart-device-cell-outside`), a Screen cell outside the declared size when there is no Camera sheet (`cart-screen-outside`), and a derived row into a cell the host writes, the Input sheet, the Clock or the File's first two rows (`cart-write-derived`, the id narrowed to the engine's half of §3.9). Every other row it leaves to the machine, which refuses a sheet it does not hold (`grid-sheet-unknown`), a twin (`grid-write-last`), a derived row over a formula (`grid-write-derived`), a range past the cap (`grid-too-many-cells`), a row it does not take or cannot read (`grid-row-unknown`, `grid-row-malformed`) and a write during a yielded step (`grid-write-during-step`), and applies the rest in order or none. A write refused by both names the engine's refusal: checking first is the only order that keeps a write atomic, the machine holding no undo an engine could call after it. A person's value into a cell the host writes is not refused, §9's tester writing a press by hand, and neither is a person's write over a formula, `AD-7`'s REPL. *Alternative:* the engine's checks after the machine's write; declined, a refusal then needing an undo that does not exist.
5. **The step writes the Clock's frame first, and a save resumes at its frame.** When no frame is in progress, `alonzo_step` writes the next frame's number into `Clock!B1` through the machine's write and then steps with the budget, so that the frame number is the step's first act (§3.5) and a frame that yields across calls is numbered once; the answer is the machine's row. At load, a `Clock!B1` the rows wrote as a whole number above 0 is a save's frame: the engine keeps it and calls `resume_at` with it, so the next step is the frame after it (§7.5, the hand-off's instruction); any other value there is replaced by 0. Writing a save stays `ENGINE.5`'s. *Alternative:* the frame written by the host beside the Input rows; declined by §3.5, the frame being the engine's and the host's only clock the animation frame's.
6. **`describe`: the manifest as read, the device sheets the grid holds, and the budget.** One row a directive, in the manifest's order and spelling; a `(device "<sheet>" "<range>" input|effect)` row for each device sheet the grid holds, the Screen at its declared window and the rest at their layouts' extents, in the double's spelling; then `(budget <rate> <formula-cells> <their product> 2000000)`, Life's `(budget 30 62964 1888920 2000000)`. A device the cartridge does not hold is not listed, so the host views only sheets that exist. *Alternative:* all nine listed, as the double lists them; declined, the host would then view a Write sheet Life does not have and print its refusal.
7. **The engine's refusals, a catalogue of its own: `engine/data/messages.vla`, read by the language's mechanism.** The `cart` family, eight entries in the catalogue's shape, `(message <id> 5 "Alonzo-Cart" "<template>")`: `cart-manifest-invalid`, `cart-spec-unsupported`, `cart-screen-outside`, `cart-palette-invalid`, `cart-device-cell-formula`, `cart-device-cell-outside`, `cart-formula-volatile` and `cart-write-derived`, each text naming its target as `sheet!addr` when it has one, so that the host prints the module's words alone; embedded with `include_str!`, parsed once by `vla_lang::messages::Catalogue::parse`, the language's catalogue answering every other id. A Rust test holds every id the engine raises to the file, with every slot filled. *Alternative:* the texts as Rust strings; declined, `SD-2`'s shape being one template a refusal, read and counted as data, and the mechanism existing for exactly this.
8. **The double answers what the module answers.** `web/fake.js` takes the module's ids: `grid-handle-unknown`, `grid-write-during-step`, `grid-write-last` for a write into a twin, derived or not, `grid-sheet-unknown` for a write into a sheet it does not hold, `view-projection-unknown`, `grid-write-derived` for a derived row into a formula cell, and `cart-write-derived` kept for one into a cell the host writes; its texts stay its own, each naming its target as the module's do; its describe is unchanged, since it holds every device. The loop oracle's pins follow: `rate30`'s three refused derived targets become `grid-write-derived`, `cart-write-derived` and `grid-write-last`, its refused edit of `Screen.last` `grid-write-last`, and the `refusals` case's edit of `Nowhere` `grid-sheet-unknown`. *Alternative:* the double keeping SPEC's proposed ids; declined, a double that answers other ids than its module's being no double.
9. **Two corrections to the host, and one sentence.** The first budget falls from 16,000 cells to 2,000: on the real module 16,000 cells are about 70 ms of the main thread on the first call of a cartridge, a visible freeze, and 2,000 are about 9 ms, inside a slice; the oracle's cases fix their budgets, so none should move, which the build confirms. The host's own ` (line N)` is left off when the module's words already name that line, as the language's `grid-*` texts do, so that a refused load does not say its line twice; a one-row write prints the words as they are. And a `(seed host)` cartridge loads with a sentence saying that the host does not choose a seed yet, the seed being `ENGINE.3`'s with the rest of the Clock, and that `Clock!B3` is empty until then (`SD-30`). The slice of half the display's interval stays: Life on the real module at about 230,000 cells a second steps about 115,000 a second in that slice, about 1.8 generations a second with the progress sentence between them, which is `SD-34`'s slowness in plain sight; `CART.1`'s floors and `ENGINE.6`'s accelerators are where it rises. *Alternative:* a slice of 0.8, about 2.9 generations a second; declined, since a tick that completes a frame also views and blits, about 5 ms on the real module, and would overrun a 60 Hz interval.
10. **The page.** The device-sheet picker is filled at load from the sheets the grid holds, read off a record's `(sheet ...)` rows, the twins after the cartridge's own; the Screen and its twin are shown through a 20 by 20 window at the Camera's place, since a whole Screen's record is 62,964 formula rows, tens of megabytes, which nothing in the page asks for. The module line names the engine and its version, the fake staying the fallback when no module is built in or one is refused, with the reason. `?blit=1` stays on the fake, measuring the host's own frame path, and its floors stand; the real plane view's cost, 3.0 to 5.4 ms a frame headless, is recorded here as a finding and not a floor, for `ENGINE.2`, whose item is that path, and for the language (decision 13). It corrects one sentence of the first slice's record: the frame path minus the evaluator is about a twentieth of a 60 Hz interval over the fake, and about a quarter over the module, whose view is computed and not copied.
11. **The loop's oracle over the real module.** `?loop=1` gains two cases that run when a module is built in. `engine`: the host over the module loads Life and reads its cartridge row, its describe's five devices and its budget; eleven frames by manual ticks at a budget of 0, the plane at frames 1 and 11 equal byte for byte to a reference Life the page computes in JavaScript, its soup the cartridge formula's own arithmetic, exact in doubles for any seed below 2^31, and Conway's rule over a dead border, with the reference's live counts, 23,683 and 14,482, pinned as the first slice's measurement; frame 2 again on a second host in budgets of 2,000, equal to the unchunked frame 2; the module's memory grown at load and every view still read right. `parity`: eleven refusals issued to the double and to the module, each answered with the same status and id: a manifest without its rate, a `(spec 3)`, bytes that are not UTF-8, an edit of a sheet the grid does not hold, an edit of `Screen.last`, a formula into `Clock!B1`, a derived row into a formula cell and one into `Input!B5`, a write during a yielded step, a projection the grid does not have, and a step of a handle not loaded. And `abi`'s last attempt changes: the built-in module attaches with ABI 1 and its version, where the empty crate was refused. Without a module, on the ratchets job, the two cases say `none built in`, and `tools/check_host_loop.ps1` requires them only of a page that holds one. A fourth mutant page, the reference Life's survival rule changed, must fail `engine`, proving the comparison bites. A run grows by about 4 s, the eleven frames of Life (*prediction*). *Alternative:* the real module's Life checked by its live counts alone; declined, a plane equal byte for byte saying more for the same frames, and the counts staying as the reference's own witness.
12. **Two checks: the exports and the dependency.** `tools/check_host_exports.ps1`: the engine's export section, section 7, equal to §8.1's eleven names exactly, the twin of `check_host_imports.ps1` and of Frazaro's `check_wasm_exports.ps1`, so that an export added by accident, or the language's `vla_*` let through by a feature turned on, fails on every push; SKIPPED without an artifact as the import check is; `-Control` on modules built in memory. SPEC §13 named it as a candidate repository item. `tools/check_engine_deps.ps1`: `AD-5`'s second sentence on the files: `engine/Cargo.toml`'s `[dependencies]` one line, `vla-lang.workspace = true`, with no `[dev-dependencies]` or `[build-dependencies]`; the workspace's pin exactly `=0.9.0`; `Cargo.lock` holding exactly two packages, `alonzo` and `vla-lang` from the crates.io registry with a checksum; `frazaro-core` nowhere (`AD-1`); `-Control` on scratch copies with five mutants, a second dependency, a git source, a range pin, `frazaro-core` and a dev-dependency. Both ride under `ENGINE.1`, as the cartridge check rode with the first slice, the list and the lock being what this slice writes; `run_checks.ps1` from 9 to 11 with two more controls. *Alternative:* `REPO.4` and `REPO.5` minted for them; the owner's call.
13. **Found for Frazaro before 0.9.0 is cut; the owner's to route.** (a) The `grid-*` texts open with `Line {line}`, so every one-row write the host makes, an edit or a derived row, prints `Line 1 ...`, the line the owner had trimmed from the host's sentences at the first hand test; recommended, the texts name the target and leave the line to the record's field, as `view-*` and `calc-*` do, reworded before the cut, decision 9's correction standing either way. Beside it, `grid-write-last` fills `{source}` with the sheet's name alone, `write Screen`, which reads as if `Screen!B1` was meant. (b) `calc-function-not-computed`'s second sentence, open by the owner's word, reaches an engine's refused load as written. (c) The plane view's cost is the language's, a map lookup for each formula cell of the window; the snapshot that fills the twins already walks every cell at a frame's end, where a sheet's bytes could be kept; `KERNEL.20`'s and `ENGINE.2`'s, not 0.9.0's. A prompt for the Frazaro session goes in the chat, never on disk.
14. **SPEC's dated corrections, the page corrected where the code is right.** §3.1: a formula before its first value reads 0, as an empty cell does. §4.2: the Clock's, the File's and, when absent, the Input's cells are made before the graph reads them, and a load whose rows hold a save's frame resumes there. §4.3: rows apply in order and a refused row undoes the rows before it; a value may be `(error "#N/A")`; a write makes no sheet; a cell outside a device sheet's layout is refused at a write as at a load; the engine's checks come before the language's. §4.5 and §13: the plane is a projection by name beside the `Projection` trait and not its second implementation, which `KERNEL.12` leaves open. §4.7: the ids as minted, the machine's the language's (`grid-handle-unknown`, `grid-write-during-step`, `grid-write-last`, `grid-cell-written-twice`, `grid-sheet-unknown`, `grid-write-derived` for a formula cell, `view-projection-unknown`, `calc-cycle`) with the new ones (`grid-handle-limit`, `grid-sheet-name-invalid`, `grid-too-many-cells`, `view-window-too-large`, `calc-construct-not-read`), the engine's eight, `cart-write-derived` narrowed to a cell the host writes, and `cart-sheet-reserved` withdrawn. §10: two stated limits, 1,048,576 cells a grid beside its twins and as many a plane window. The ABI number stays 1, no signature having changed its meaning. And a dated note on `ENGINE.5`'s line: a save of Life is 34.2 MB, past §10's 16 MiB, and drops its `name` rows, which no record prints; the save's shape is that item's to decide. The speed, 226,000 to 236,000 cells a second in wasm against `CART.1`'s bar of two million, is recorded in this entry and on `CART.1`'s line.
15. **The bookkeeping.** `ROADMAP.md`'s `ENGINE.1` line gains this scoping now and the built marker after, and leaves for the ledger at the owner's test and commit, closing the item; this entry and its build record; `README.md`'s table and the rules' line on the exports; `engine/README.md`'s "what this crate holds today" and the crate's doc; `web/README.md` on the module and the two cases; `CONTRIBUTING.md` on where an engine refusal goes; `SECURITY.md` on the exports pinned beside the imports and the one dependency pinned; the workflow's comment naming the dependency; the map's line; the memory. The commit at the owner's word, `ENGINE.1: the same host over the engine's own module, Life computed by the language`, its message by `-F`.

**The catch.** Each met once, or foreseen by reading.
- A `#[no_mangle]` in the engine is exported, and a `vla_*` would be too if any member of a workspace build turned the language's `c-abi` feature on, which Frazaro measured; the export check holds the list name for name.
- The handle table is a thread-local static for the module's life, so the C surface's test is one test, as the language's is.
- Life natively in a debug build is several times slower than in release (*prediction*); the native tests use a small board, and the full board is the page's, in wasm.
- The machine refuses a write while a frame is in progress, so the engine writes the Clock only when none is.
- The catalogue is CRLF on checkout and LF in the blob; `Catalogue::parse` normalizes it.
- A whole Screen's record is tens of megabytes; no view of a whole Screen is asked by the page or the oracle.
- The 32-byte artifact of `REPO.1` left in a local `target/` fails the export check until the engine is rebuilt; CI always builds first.
- PowerShell 5.1 as every check met it: ASCII, `return ,$list`, `$onWindows`, the Write tool and never a heredoc, a commit message by `-F`.
- The tree is shared; this file and the roadmap are staged by hunk, HEAD plus this item's own.

**Oracle.** On the owner's machine under Windows PowerShell 5.1, then on both jobs:
- `cargo build --workspace`, `cargo fmt --all -- --check`, `cargo clippy --workspace --all-targets -- -D warnings` and `cargo test --workspace` green, the engine's tests among them: every manifest refusal, every device refusal at load and at a write, the engine's checks before the language's, the Clock written once a frame across yields, a save's frame resumed, describe's rows for Life, a small Life against a Life written in the test frame by frame with its formulas equal before and after each step (`AD-7`), and the eleven exports through their functions.
- `cargo build --release -p alonzo --target wasm32-unknown-unknown`: a module of about 330 KB (*prediction*); `check_host_imports.ps1` at 0, `check_host_exports.ps1` at the eleven names, `check_engine_deps.ps1` at two packages.
- `check_host_loop.ps1` under headless Chrome and Edge at both ratios with the module built in: `engine`, `parity` and the changed `abi` clean, the first slice's cases clean under the new ids; its control, four mutant pages failing each for its own reason.
- `run_checks.ps1 -WithExtras` at 11 checks and 11 verifiers, `ALL GREEN`.
- The owner's hand test of `web/index.html`: the module line naming the engine and the language; Life's soup, then its generations at about two a second with the progress sentence between; a Palette edit recolouring the dead cells; a range of Screen cells written as a value holding still while Life flows around it; the picker showing the Clock's frame counting; the cartridge at `(rate 0)` loaded and an edit stepping one generation.
- CI green on both jobs at the owner's push.

**Size.** `~days`: the engine about eight hundred lines with its tests, the page's two cases with the reference Life about three hundred, the two checks about five hundred, the rest small; the build begins on the publish. (*prediction*)

*Approved 2026-10-09, the same day, with decision 1 changed at the owner's word:* "I've changed my mind and decided to use the vla-lang github dependency for now: `vla-lang = { git = "https://github.com/Spreadsheet-Company/Frazaro", rev = "6cca2e1" }`. We can change over to a Rust crate once Frazaro is in a good place to push 0.9.0. Recommendations approved; proceed." So the workspace pins the language crate by git at the commit of `KERNEL.22` until 0.9.0 is on crates.io, and the build began at once, the wait having been the publish's.

*The second slice built 2026-10-09, awaiting the owner's run.* The commit `6cca2e1` was still on no remote (Frazaro's `origin/main` at `ae99e89`), and a push is the owner's act, so Cargo fetched it from the local Frazaro clone for one command: the git command line (`CARGO_NET_GIT_FETCH_WITH_CLI`) with git's `url.<local>.insteadOf` rewriting the GitHub address, set in that command's environment alone. `Cargo.lock` therefore records the source CI will compute, `git+https://github.com/Spreadsheet-Company/Frazaro?rev=6cca2e1#6cca2e18260871d0930306e1a8f81c2976ff662a`, and Cargo's git cache holds the commit, so every later build here needs no override; the crate job resolves it the day the commit is on the remote, and fails to resolve it before. What landed: the pin in `Cargo.toml`, the engine's one line in `engine/Cargo.toml`, the lock; `engine/src/abi.rs` (499 lines: the eleven exports, the record and the memory pair as the language's, the handles in a `Handles<Cartridge>`, one test as a host meets the surface), `engine/src/cartridge.rs` (1,543 lines after `cargo fmt`, more than half of them its eleven tests: the manifest read with the language's reader, a later `(spec ...)` refused first, the nine device layouts, the checks at load and at a write, the engine's own sheets, the Clock's frame, `describe`, the catalogue), `engine/src/lib.rs` (the crate's doc), `engine/data/messages.vla` (the `cart` family, eight entries, CRLF as `.gitattributes` gives every `.vla`); `tools/check_host_exports.ps1` (299 lines, eight control modules and a non-module) and `tools/check_engine_deps.ps1` (250 lines, a scratch copy and seven mutants); `web/fake.js` (the module's ids, and its write in the engine's order, decision 8's addition below); `web/host.js` (the first budget, the line said once, the seed's sentence); `web/index.template.html` (the sheet picker, the module's bytes in the about line, `abi`'s last attempt, `engine`, `parity`, the reference Life, the ids in the pins); `tools/check_host_loop.ps1` (nine cases, the floors over the module, a stale page refused, the fourth mutant); `tools/run_checks.ps1` at a floor of 11 with eleven controls; the workflow's comments; `SPEC.md`'s dated corrections in §3.1, §4.2, §4.3, §4.5, §4.6, §4.7 and §10; the roadmap's notes on `ENGINE.2`, `ENGINE.5` and `CART.1`; `README.md`, `engine/README.md`, `web/README.md`, `CONTRIBUTING.md`, `SECURITY.md`, the map's line and the memory.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1 (*measurement*): `cargo build --workspace`, `cargo fmt --all -- --check` and `cargo clippy --workspace --all-targets -- -D warnings` clean, `cargo test -p alonzo` 12 passed in under a second in a debug build, Life's load among them; the module, `cargo build --release -p alonzo --target wasm32-unknown-unknown`, 456,328 bytes, `check_host_imports.ps1` at 0 imports, `check_host_exports.ps1` at exactly the eleven names (and, pointed at the language's own C-surface module, 20 problems, a real door refused), `check_engine_deps.ps1` at two packages; `check_host_loop.ps1` clean under headless Chrome 154 at ratios 1 and 1.5, nine cases, 5.5 s a run: the first slice's seven with their counts and digests unchanged under the new ids; `abi` 3 refusals and the module attached as `alonzo 0.1.0 (vla-lang 0.8.0)`; `engine` 11 frames, the planes at frames 1 and 11 equal byte for byte to the reference Life, 23,683 and 14,482 live cells, frame 2 equal in 64 calls of 2,000 cells, the memory grown at the load, 5 devices described; `parity` 11 of 11. Its control: the four mutant pages each failed for its own reason, the survival rule changed failing `engine` at frame 11, in 28.7 s. A page built with `-NoWasm`, the artifact set aside for that run, passed with `engine` and `parity` at `module 0`, the ratchets job's case. `run_checks.ps1 -WithExtras`: 11 checks and 11 verifiers, `ALL GREEN`, in 76 s. The plain page under headless Chrome, probed: the module line `The engine module, alonzo 0.1.0 (vla-lang 0.8.0).`, the picker filled with Screen, Palette, Clock, File and Input and their twins, the load and budget sentences in the log; under a virtual-time budget the loop ran 26 frames of the real Life, where the first slice saw no frame against the fake, which is the clock's business and not a measurement.

Found in the build, each corrected or recorded. **The size missed.** The module is 456,328 bytes against the prediction of about 330 KB: the scoping's probe called the machine's load, step and view and never its write, whose settling re-plans the graph, nor a manifest reader, a printer or a second catalogue; and the engine is about 2,090 lines with its tests against the prediction of 800, `cargo fmt` and the tests the most of it. **The language's version.** The engine's version text reads `vla-lang 0.8.0`: the crate at `6cca2e1` carries Frazaro's workspace version until 0.9.0's bump, which is honest and is what the page prints. **A trap the control caught.** `check_engine_deps.ps1`'s own control failed its clean copy: a list of one returned through an `if` expression unrolls to its string in PowerShell, and `[0]` then read a character; both reads are wrapped in `@()`. And its rule for `AD-1` first read whole files, where both manifests name `frazaro-core` in comments to say why; it reads table lines and locked packages now. **Three additions beyond the scoping's text.** The double's write takes the engine's order, its own checks over every row before the language's, and not only the ids decision 8 named, so that `parity` holds for a write of many rows as for one. The sheet panel refreshes about five times a second instead of every sixth frame, since the real Life draws about two frames a second and a sixth frame would be three seconds. And the loop check refuses a page built beside the engine's artifact that does not hold it, byte count for byte count, so that a stale page cannot pass the floors over the module by holding none.

What remains is the owner's. Open `web/index.html` in Chrome: the module line names the engine and the language; Life's soup appears, then its generations at about two a second with the progress sentence between them; an edit `(cell "Palette" "B1" "#FF8800")` turns the dead cells orange; `(cell "Screen" "B2:K11" 1)` holds a block alive while Life flows around it; the picker shows the Clock's frame counting, and `Screen.last` the previous frame; the cartridge's `(rate 30)` edited to `(rate 0)` and loaded, an edit steps one generation; an edit of `Screen.last` is refused in the language's words, which open `Line 1` until Frazaro rewords its grid family (decision 13). Then the commit at the owner's word, staged by hunk; then, at the owner's word, Frazaro's push before this repository's, since the crate job fetches `6cca2e1` from Frazaro's remote.

*The owner's hand test, 2026-10-09, in Chrome at a ratio of 1.5.* Every item met: the module line `The engine module, alonzo 0.1.0 (vla-lang 0.8.0).`; Life's soup, then its generations, the progress sentence between them; the Palette edit turning the dead cells orange; the block `B2:K11` held alive while Life flowed around it, the frame's total falling from 62,964 cells to 62,864 (`frame 98, 30,540 of 62,864 cells`), the hundred formulas the person's write replaced with values, `AD-7`'s REPL seen in the step's own count, and the twin `Screen.last` showing the block in the previous frame; the edit of `Screen.last` refused; rate zero stepping one generation for an edit. *Owner-tested 2026-10-09.* Found in it, the owner's question and not a failed item: a reload at `(rate 0)` seemed to pause the old run rather than start a new one, where `(rate 10)` restarted it. The grid was new both times, the old handle unloaded and a fresh grid loaded at frame 0 with nothing computed; the canvas was stale, since the host paints the plane only when a frame completes (`web/host.js`, `_complete`) and a load completes none, so at rate zero the old run's last frame stayed on the canvas, and the frame line with it, until the first edit stepped frame 1, the soup; at a rate above zero the soup is drawn within about half a second and the reload reads as the restart it is. That is the page showing a grid that no longer exists, against `SD-30`; the fix offered, the host drawing the fresh grid's plane at load, frame 0, and the frame line saying so.

*Fixed the same day at the owner's word ("Build the cartridge load fix now.").* The host draws the new grid's frame 0 at the end of every load, the plane viewed through the Camera's window and blitted, nothing computed, so Life's reload paints a black plane, every formula without a value reading 0, and a cartridge with values on its Screen shows them; and an unload empties the canvas and drops the host's copy of the plane, so a load refused after a good one leaves no picture of a grid the module no longer holds, which the same reading found on the refusal path. The `load` event carries the window and the scale, and the page's frame line says `Frame 0, the window A1:LH200, 2 device pixels a cell: the cartridge as loaded, nothing computed until an edit steps it.` (or `until the first step.` at a rate above zero), or after a refused load `No cartridge is loaded: the last load was refused, and the log says why.` The oracle's model foresees the frame-0 view at each load through the same window, since the fake module records every plane view. Pins: `scale`, which has a canvas, reloads at rate 0 after frame 1 and reads its six cells opaque black, then loads a cartridge without its rate and reads them transparent; `engine` reloads Life at rate 0 after frame 11 on the real module and holds a plane of 64,000 zeros at frame 0. Two more mutant pages prove them: a host that draws no frame 0 fails `scale` at the reload, and a host that leaves the canvas at an unload fails it at the refused load. On the day (*measurement*): `check_host_loop.ps1` clean at both ratios, `scale` counting `reloaded 6, cleared 6` and `engine` `reloaded 1`, the first slice's digests unchanged, `memory`'s detachments 642 where they were 637, the views the loads add; its control failed six mutants of six in 40.1 s; a scratch page built from a `(rate 0)` copy of Life, probed headless, showed the frame line above with the plane sized at the load.

*The owner's second round, 2026-10-09:* every item of the fix's hand test met, the reload at rate 0 black at once, an edit stepping the soup in green, the refused load emptying the plane, the restored rate restarting Life; and, by the way, `(rate 30)` written as the manifest's first directive loaded as well, the directives being named and not positional, as §7.2 has them and both the engine and the double read them. One note at the owner's word: the frame line after a refused load is red now, `#a2262b`, the colour the viewport's status line gives a refusal, and its normal grey again at the next load; probed headless on a scratch page built from a Life without its rate, `frame-line refused` with the sentence, and on the `(rate 0)` page `frame-line`. `run_checks.ps1`: 11 checks, `ALL GREEN`.

*Then at the owner's word, "For now, I think all refusals should be the same color (red until the palette changes)":* every refusal the page shows is that red. The host marks a sentence as a refusal when it says one, through one method, `_refuse`, which `_fail` calls too: the fourteen places a refusal or a failure is said, the module's (a load, a write, a derived row, the Input rows, a step, a view, the plane, describe, unload) and the host's own (an edit that is no row, an edit with no cartridge, a Write row that is no write, a plane of the wrong size, the loop stopped by an error); a notice of a value the host coerced, a Camera cell read as 1 or a Palette colour painted magenta, is not one, nothing having been refused. The mark rides on the sentence, on the `status` event and on each log entry, and the page paints the status line red while it shows a refusal, each refused line of the log, and the frame line after a refused load; text alone could not have told them, the module's words for a derived write naming no refusal. Pins: every sentence of the four loop cases that holds a catalogue id in brackets is marked and no other is; the `refusals` case counts its five refusals marked, two of them the host's own with no id to show (bytes that are not UTF-8, and a derived row offered as an edit). A seventh mutant page, a host whose `_refuse` marks nothing, fails `rate30` by name. On the day (*measurement*): the loop check clean at both ratios, `refusals` at `marked 5`; its control failed seven mutants of seven in 45.9 s; probed headless, the refused load's frame line, status line and its one log line red, the `(rate 0)` page's two log lines and both lines plain.

*Committed and closed 2026-10-09 at the owner's word, "Commit, then suggest next steps", the owner's screenshot of the same day showing a refused edit red in the log: the second slice whole in one commit with the item's close, the roadmap's line moved to the ledger's engine section above. Not pushed: the crate job resolves the language crate only once Frazaro's `6cca2e1` is on its remote, so Frazaro's push comes first.*

*Noted 2026-10-10, decision 1's registry pin.* Frazaro released the language as 0.8.1, not the 0.9.0 this entry expected, the day `CART.1` closed, and the owner relayed its session's word: pin it. Done the same day over the tree of `CART.1`'s close, `cc3b448`, in a commit of its own (*measurement*, 2026-10-10):
- *The pin.* `Cargo.toml` pins `vla-lang = "=0.8.1"`, its comment rewritten. `Cargo.lock` holds the registry's source and the crate's checksum, `3c44ebaf...`, fetched by cargo from crates.io, a fetch of the build's.
- *The source, byte for byte.* The crate's 34 files were read against Frazaro's tree at `f5dc344`. Twenty-seven equal its blobs. Its two data files, `messages.vla` and `headtable.vla`, are the same text with CRLF ends, which the git checkout the engine built from had too, byte for byte. Its manifest is cargo's normalized one, and its original equals the commit's, the version inherited from Frazaro's workspace. The crate names its source as the release commit `3235bf9`, whose `vla-lang/` equals `f5dc344`'s.
- *The engine unchanged.* `cargo build`, `fmt --check`, `clippy -D warnings` and 16 tests clean; the runner's check mode at 251,957 and 251,958 allocations and 5 reallocations, every frame equal, as at `f5dc344`. The module is 461,817 bytes, 64 more, because it embeds the source paths of the language's panic locations and the registry's paths are longer than the git checkout's.
- *Found:* those paths are absolute, twelve of them, the builder's home folder among them, and the git pin's module carried eleven the same way. A module built on a person's machine names their account. Not changed here.
- *`tools/check_engine_deps.ps1`* holds either kind of pin by its baseline: a git rev locked to its full commit with no checksum, or one exact version locked to the registry with the crate's checksum. The baseline itself is now read first, so the check cannot be satisfied by moving its own baseline to a branch or a range. Its control: eight mutants for a registry pin, and seven for a git one, proved on a scratch copy of the git pin as committed; and five baselines, the git one and the registry one passing, and a range, a branch and a registry with no checksum failing.
- *`tools/check_frame_floors.ps1`* names the releases whose source is a measured commit's, `0.8.1` as `f5dc344`'s. The owner's baseline, measured at `f5dc344`, holds under the registry pin without a second run, which would only have measured noise and, as a new floor entry, lowered half the floors without a reason. Its control gains a release of the measured source passing and a release of another failing.
- *The rest.* The engine's version text reads `alonzo 0.1.0 (vla-lang 0.8.1)`. The README says where the language comes from, and the ledger's line for this item names the release that came. Where this entry says 0.9.0, the release came as 0.8.1. A git pin may return for `KERNEL.20` until the release after it, and both checks take it as they took this one.
- *The oracle:* `run_checks.ps1 -WithExtras`, 12 checks and 12 verifiers, `ALL GREEN`, over the page rebuilt with the new module.

*The live sheet at a stop, 2026-10-10, after `ENGINE.4`'s close, at the owner's word: "implement the refresh upon stopping so that the live sheet and clock frame maintain parity to the human eye".*

The defect. The owner's screenshot of `ENGINE.4`'s replay showed the live sheet's `Clock!B1` at 234 under a frame line at 240.
- The panel draws the live sheet about five times a second while the loop runs (this slice's owner's hand test, 2026-10-09, when the sheet lagged the edits), and the frame line every frame. Nothing drew the sheet when the loop stopped, so every stop left it up to 200 ms behind.
- The host stops in seven places and the panel's Pause makes an eighth, and the page heard of none of them: the host said `status`, `load` and `frame` and nothing at a stop.

What landed:
- `web/host.js`: `stop()` says `stop`, `{ frame }`, when a running loop stops: Pause, a replay's end, a refused step, a load or an unload. The header names the four events.
- `web/index.template.html`: the panel draws the live sheet at a `stop` whose frame it does not already show.
- The loop oracle's `replay` case holds the event: the replay played through the loop says its stop once, at its last frame (`stopped 1`).
- `tools/check_host_loop.ps1`: the floor, and a twenty-fifth control page, Y, a host that never says it stopped.
- `web/README.md`: the event and the panel's sheet. `tools/run_checks.ps1`'s words.

The oracle, on the day (*measurement*):
- A headless probe of the plain page, built in scratch, wrapped the viewport's `load` to keep the last record of the Clock the panel drew. It played the sound card, paused it twice and then played its replay to its end, comparing the frame line with the drawn `Clock!B1` at each stop. Before the fix: frame 14 against 8 at both pauses, and 105 against 99 where the replay stood when the probe looked. After it: 10 and 10 at both pauses, and 240 and 240 at the replay's end.
- `check_host_loop.ps1` at both ratios: fifteen cases, `replay` at `stopped 1`. Its control, twenty-five mutant pages in 125.3 s; Y failed the replay case by name, "said the loop stopped 0 time(s), where it says so once, at its last frame".
- `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`, in 246.8 s.

*Owner-tested 2026-10-10 and committed the same day at the owner's word, "Tests pass, commit.", under `ENGINE.1`'s ID. Not pushed.*

*Found:* in the headless probe, Run after a Pause stepped no frame in 2 s of virtual time, on the page before the fix as well, while a replay played after it ran its frames. A headless Chrome makes animation frames while something is drawn: a replay's load draws frame 0, and a bare Run draws nothing before its first frame. The owner's hand test of `ENGINE.4` found Run resuming in a real Chrome, so this is the probe's, not the page's.

*The pin at `vla-lang` 0.9.0, 2026-10-11, at the owner's word that Frazaro's 0.9.0 was cut and published to GitHub and crates.io.*

The release is Frazaro's `2eb54b7`, tagged `v0.9.0`.
- `KERNEL.20`'s first four slices, `KERNEL.26` and `KERNEL.27`: a frame computes only the cells a change reaches, a filled formula at all its cells at once, the twins' cells made only when read.
- `VLA.1`'s limits, refused by name, and `VLA.3`'s ten expand-time primitives.
- No git rev was pinned between 0.8.1 and it.

What moved:
- `Cargo.toml`'s pin and the lock: the checksum `248b3ecf...`, still two packages.
- `KERNEL.27`'s one change, `Machine::workbook` taking `&mut self`. `describe` and `check_row` ask the machine for a sheet's place and name (`find_sheet`, `sheet_name`). Of the tests, `formulas` borrows the machine's own field mutably, and two read the sheets' names from the machine.
- `check_engine_deps.ps1`'s baseline.
- `check_frame_floors.ps1`'s allocation ceilings: 80 and 5 a frame for both fixtures, where they were 251,957 and 251,958.
- The library's `keys-from`, which joins its addresses by `&expand` where it fused them by the leading-quote trick, and its header.
- `SPEC.md` §7.8's dated correction.
- And ENGINE.2's heading in this file, which the record of the live sheet's fix (`ea87ed0`) had dropped. Its note was inserted before that heading, and the heading was not written back.

The oracle, on the day (*measurement*):
- `cargo test`: 27, both replays played natively to their goldens.
- `expand --check`: five sources the same, before the library's change and after it.
- The module: 635,687 bytes (from 516,175), 0 imports, 12 exports.
- The loop oracle's fifteen cases at both ratios, every count and digest as before:
  - Life frame for frame equal to the page's own at generations 0 and 10;
  - both replays to their goldens;
  - the page's pass of five sources the command line's bytes.
- `check_engine_deps.ps1` and its control's 8 mutants.
- The runner's check mode: every frame equal to the hand-written Life, and the gun's facts held.

A preview run of `tools/bench_frames.ps1` the same day, every guard met:
- Life 3.2 ms a frame natively (309 frames a second) and 4.3 in headless Chrome (235).
- The gun 0.031 ms natively, and 0.061 in Chrome, timed in 30 runs of 128 as the page now times a frame quicker than its clock.
- The README's thirty frames a second is cleared in the browser nearly eight times. A floor never goes down, so floors from a baseline of this kind pass the charter's line of two million cells a second and make the check's two bars gates from then on.

*The floors' third baseline, the owner's run of `tools/bench_frames.ps1` over 0.9.0 the same day, both halves opted out of the throttling and on the performance cores, pasted from `target/bench_frames.txt` whole (*measurement*):*

| row | frame p50 | frames a second | cells a second | floor |
|---|---|---|---|---|
| native life | 2.8 ms | 356.6 | 22,453,863 | 20,200,000 |
| native gun | 0.0152 ms | 65,573.8 | 4,128,786,885 | 3,710,000,000 |
| wasm life | 4.3 ms | 235.3 | 14,815,059 | 13,300,000 |
| wasm gun | 0.0613 ms, in 30 runs of 128 (frames 158 to 3997) | 16,305.7 | 1,026,674,140 | 924,000,000 |

- The soup is 36 times the second baseline natively and 32 times in the browser.
- Every floor passes the charter's line of two million cells a second and Life's thirty frames a second, so both bars are gates from this entry on: Life at 7.4 times the line and 7.8 times its rate in the browser.
- "Cells a second" stays the floors' unit, the frame's formula cells over its time, though a frame no longer computes every cell.
- With it:
  - `check_frame_floors.ps1` prints the distance to a bar it has passed as "times over", where it printed "0.1 times short";
  - the two READMEs' sentences on Life's speed take the run's numbers.
- `run_checks.ps1 -WithExtras` then: 12 checks and 12 verifiers, `ALL GREEN`, in 149.8 s. The loop check's control took 70.5 s where it took 125: its pages step the faster engine.

*Committed 2026-10-11 at the owner's word, "Commit, push to remote, then suggest next steps", under `ENGINE.1`'s ID as the 0.8.1 move was, and pushed the same day with the six commits before it, `ENGINE.4`'s two among them.*

*The pin at `vla-lang` 0.9.1, 2026-10-12, at the owner's word: "0.9.1 is cut and deployed to GitHub and crates.io; proceed with implementing slice 3 of CART.2 as scoped". That scoping's decision 24 has the floors' fifth baseline measure the pin, water's cartridge and the gun's runs in one run of the owner's, so the pin moved first.*

The release is Frazaro's `cb3cd12`, tagged `v0.9.1`.
- `KERNEL.28`, `CART.2`'s decision 14's ask: a run computes the language's `ROW`, `COLUMN`, `MOD`, `INT`, `ABS`, `SIN` and `CHOOSE` across its cells, by the library's own meanings.
- No public interface changed, and no git rev was pinned between 0.9.0 and it.

What moved:
- `Cargo.toml`'s pin and its comment, and the lock: the checksum `712a4ef4...`, still two packages.
- `check_engine_deps.ps1`'s baseline and its header.
- `SPEC.md` §2's note: rule 5's dated correction. A cell's place may be computed at each cell, and `CHOOSE` costs what `IF` does, as Frazaro's session measured on Sand (relayed); Sand keeps its `Parity` column, about 1% cheaper.

The oracle, on the day, before `CART.2`'s third slice changed anything (*measurement*):
- `cargo test --release`: 29.
- The runner's check mode: every count the same, Life and the gun 80 and 5, Sand 509 and 5.
- `check_engine_deps.ps1` and its control's 8 mutants and 5 baselines.
- The module: 643,503 bytes, from 635,687 (+1.2%).

The floors hold the pin they were measured at, so `check_frame_floors.ps1` fails until the fifth baseline, which is `CART.2`'s third slice's (that item's entry).

*Committed 2026-10-12 at the owner's word, "Commit, then walk CART.1's optimization route again over CART.2", in one commit with `CART.2`'s third slice. The floors' check fails on the pin without the fifth baseline, and the fifth baseline measured water's cartridge, so no commit can hold the one without the other. Not pushed.*

*The host's tick on the frame's grid, 2026-10-12, found by `CART.2`'s playtest pass (that item's entry) and built with its row gate at the owner's word: "Your adjudications for implementing the four decisions are more informed than mine, so I trust your judgment. Proceed." Uncommitted, awaiting the owner's hand test.*

The defect (*measurement*, headless Chrome 154, the real host on a 60 Hz schedule of real time):
- A tick's time went into the accumulator as it came. The display's timestamps come to a tenth of a millisecond, 16.6 or 16.7 ms apart where a frame at 60 is 16.667.
- With the remainder at its threshold, a tick a few hundredths of a millisecond short owed no frame, and the next owed two. Sand at a rate of 60 computed its 60 frames a second and presented 38 to 40.
- At the rate of 30 the same jitter put a gap of 50 ms among the 33s, a p95 of 51 to 60 ms.
- The state comes and goes: the same page presented 56 to 60 a second in some runs and settled at 40 in others, after one long tick.

What landed:
- `web/host.js`:
  - `SNAP_MS`, a quarter of a millisecond, among the rules as `snapMs`;
  - `_snapped`, by which `tick` puts a delta within `SNAP_MS` of the grid onto it. The grid's step is the frame's interval over the whole number of display intervals it spans, or the frame's own interval where it is shorter.
  - The display's interval is still measured from the deltas as they come. A display off the grid by more is timed as before.
- The page: the loop oracle's header prints `snap=`, and a seventeenth case, `pace`. Over the double, under a clock the case keeps, the ticks come at 60 a second with their times to a tenth of a millisecond, 16.7, 16.6 and 16.7 ms apart in turn. At a rate of 60 every tick after the first presents one frame, and at 30 every second tick, never two at once and never two ticks running without one.
- `tools/check_host_loop.ps1`: the case's floors (60 ticks at each rate, 60 frames at 60 and 30 at 30), seventeen cases, and mutant AA. A host whose tolerance is 0 must say `snap=0`, and its second tick at 60 presents none, which the `pace` case fails by name. Twenty-seven mutants.
- `SPEC.md` §5 step 1's dated correction, `web/README.md`, and `run_checks.ps1`'s line for the control.

Why a quarter of a millisecond: the loop oracle's ticks come 17 ms apart, a third of a millisecond off the grid of 16.667. A tolerance of 1 ms, the first prototype's, would have put them on it and moved their counts. A quarter holds the jitter measured and leaves every other case's counts as they were.

The oracle, on the day (*measurement*):
- `check_host_loop.ps1` at both ratios: seventeen cases OK, the sixteen's counts unchanged, `pace` 120 ticks with 60 frames at 60 and 30 at 30. Its control: the real page clean, and twenty-seven mutants each failing for its own reason.
- In Chrome, the snap in a scratch copy of the host and then in the build, the canvas left out:
  - at 60 every second presents 59 to 60 frames, its gaps a median of 16.7 ms and a p95 of 17.0;
  - at 30 the p95 is 33.7 to 33.8 ms, where it was 51 to 60.

  `CART.2`'s record has the table.

*Owner-tested 2026-10-12 with `CART.2`'s row gate: Sand at sixty frames a second and "No stalls on clicks". Committed the same day at the owner's word, "Commit, then proceed", on its own and before the row gate. It leaves the floors as they stood. Not pushed.*

## `ENGINE.2` — the frame path: the plane held to the record of the same window

*Scoped 2026-10-09, at the owner's word, the day `ENGINE.1` closed: the Screen read out of the module's memory as bytes and blitted whole, held equal to the view record of the same window by a test, the record being the oracle (`CHARTER.md` §3), and the window the Camera's (`SPEC.md` §13's two oracles for this item). The scoping finds the path itself already laid, since `ENGINE.1` had to draw something: the host views the plane, copies the bytes out and blits them through the Palette. What is missing is the oracle, a fixture that reaches every arm of the byte's rule, and the cost the second slice measured, which is the language's. So the scoping is mostly a measurement, made before any claim, and its first finding moves the cost to Frazaro.*

**Substrate, verified.** Read on the day, by file and never by assumption; Frazaro's tree read and written nowhere, its crate built only from a scratch copy of the pinned commit.

- *The pre-flight.* This tree clean at `730213b`, one commit ahead of `origin/main` (`984722a`), CI's last run green there; `run_checks.ps1 -WithExtras` at 11 checks and 11 verifiers, `ALL GREEN`. Frazaro at `6cca2e1`, six commits ahead of its `origin/main` (`ae99e89`), its last CI green there, two peers' work uncommitted in its tree (`U.32`, `KERNEL.3`) and none of it under `vla-lang/`; its registry's next free `KERNEL` number is `KERNEL.23` (`docs/ID_REGISTRY.md`).
- *The rule, in the language.* `vla-lang/src/machine/plane.rs` at `6cca2e1`: a window of a sheet as a byte a cell, row-major; a cell holding a number is `byte(n)`, itself when a whole number from 0 to 254 and 255 otherwise; a text, a truth value or an error is 255; a formula's computed value the same way, a computed value that is not a number 255, a not-computed one 255, and a formula with no value 0; an absent cell 0. It walks the window's rows in the sheet's ordered map of cells and looks each formula cell's value up in the machine's map of values, a `HashMap` keyed by the cell under the standard library's hash.
- *The record, in the language.* `vla-lang/src/view.rs`: a `cell` row spells a number by `sheet::number_text`, Rust's shortest spelling that reads back to the same double, and never Excel's fifteen digits; a `value` row after a formula row spells the computed value by `Value::spell`, the same for a number, `0` for a zero of either sign, a text quoted, `true` or `false`, `(error "#DIV/0!")`, `(not-computed ...)`; no value row while the formula has none. So the record read back gives every value bit for bit, and "byte for value" is exact: `3.0000000000000004` prints whole and reads 255 on both sides, where a reader rounding to fifteen digits would call it the colour 3.
- *The machine around both.* `machine/mod.rs`: a write's settling forgets the value of every cell it changed, so a formula written between steps has no value until the next, 0 in the plane and no value row in the record; the snapshot at the end of every frame already walks every cell of every sheet and looks up every formula's value in the same map, to fill the twins; a function outside the subset and a cycle are refused at load and at a write, so no value of an engine's grid is ever not computed, and that arm of the rule is the language's to test (`the_plane_is_a_byte_a_cell_and_agrees_with_the_record` there, over one small sheet). The loader's values (`machine/load.rs`): a finite number in the row's spelling, an exponent allowed; a text, the empty one included; `true`, `false`; `(error "...")`. The language's fourteen functions: `IF`, `AND`, `OR`, `NOT`, `SUM`, `MIN`, `MAX`, `ABS`, `INT`, `MOD`, `ROW`, `COLUMN`, `CHOOSE`, `SIN`.
- *The path, in this repository.* `web/host.js`: after a frame completes, the Camera and the Palette read through their records, then `alonzo_view` with the projection `plane`, the record's text the bytes, copied out with `slice` and freed, and the blit through a table of 256 colours, magenta past the Palette; at every load the same for frame 0. `engine/src/cartridge.rs`'s `view` adds nothing to the machine's. `engine/src/abi.rs` builds every record into a vector and copies it into memory the host frees. Nothing in the frame path prints the Screen; only the device sheets are read as records.
- *The double.* `web/fake.js`'s plane gives 255 for a Screen formula outside the declared size (`e.f ? 255 : byteOf(e)`), while its record prints that formula with no value row, which §3.1 reads as 0: the one place the double and the module would answer the equality differently, reached by none of the nine cases.
- *The floors and the oracle.* `tools/check_blit_floors.ps1` holds the owner's baseline of the frame path over the double, two cases, `fit` and `scale-1`, under bars of 2.0 ms at the p95 and 4.0 at the max; `tools/check_host_loop.ps1` holds nine cases at two ratios and proves itself on seven mutant pages; `tools/check_engine_deps.ps1` pins the language by two baseline lines, `$langSpec` and `$langSource`; `tools/check_cartridge.ps1` pins one cartridge.
- *The cost, measured.* A scratch copy of this workspace and of `vla-lang` at `6cca2e1`, the engine's module built `--release --target wasm32-unknown-unknown` under this workspace's profile with one scratch export added that runs a part of a view a given number of times, driven from a scratch page under headless Google Chrome 154.0.8037.93 without virtual time, Life loaded and stepped, two runs (*measurements*, 2026-10-09): Life's plane of `A1:LH200` costs 0.33 to 0.35 ms inside the module at frame 0, when the map of values is empty, and 2.5 to 5.5 ms at frames 1 and 11, run to run; the record's copies, a 64,000-byte record built and freed, 0.002 to 0.004 ms; the host's whole path at most 0.3 ms above the module's part; the Clock's record 0.006 to 0.018 ms and the Palette's 0.023 to 0.032; the palette loop in JavaScript under 0.4 ms cold and under the timer's grain warm; a step 187 to 192 ms at frame 1 and a median of 277 to 289 at frames 2 to 11. So the plane's cost is the lookup of 62,964 formula values in a hashed map, nine tenths of it, and nothing the host or the record does: an export with no record would save three microseconds.
- *Two prototypes, measured the same way, in scratch copies of the language and never in Frazaro's tree.* V1, the machine's three maps and the plan's map of places under the Fx hash, an in-crate hasher of twenty lines: the plane 1.6 to 1.9 ms, a step 233 to 234 ms, sixteen percent faster. V2, each sheet's bytes kept over its extent by the snapshot's own walk, at most 1,048,576 of them, dropped when a write touches the sheet, and a plane view copying rows out of them when they are there and walking as before when not: the plane 0.002 to 0.006 ms; a step 276 to 278 ms, unchanged against the base's spread; the load unchanged. The language's 112 tests pass under both, and this engine's 12 over both.
- *The oracle, tried.* A scratch equality test over a scratch test card and over Life passes on the base and on V2 in a debug build, 0.7 s for the card's twenty-five frames and 2.5 s for Life's corners and a band at frames 0 and 1, Life's load 0.94 s and its step 1.03 s of that. A mutant of V2 whose bytes are never dropped fails it by name, `after a value written: Screen!F1:AS24 at H3: the plane 2 and the record 200`; the first draft of the test let the mutant pass, its writes landing in columns the Camera had panned away from. `tools/check_cartridge.ps1` on a scratch tree holding the card reads it whole, 112 rows, 960 cells, 393 of them formulas, every rule of §7 holding, and fails only on its two pins.

**The work.** The oracle in two places, a fixture, one line of the double, a picker, three checks moved, and in a second slice a method of the host, a case of the blit's instrument and the pin.

| File | What it is | Copied, adapted, or decided |
|---|---|---|
| `cartridges/testcard/testcard.vla` | the plane's test card, 0BSD, CRLF | decision 2 |
| `engine/src/cartridge.rs` | two tests: the test card's plane equal to its record every frame, and Life's at its corners and a band | decision 1 |
| `web/index.template.html` | `?loop=1`'s tenth case, `plane`; the engine panel's cartridge picker and the card's place; in the second slice `?blit=1`'s third case | decisions 1, 6 and 8 |
| `web/fake.js` | a formula without a value reads 0 in the plane wherever it stands | decision 7 |
| `web/host.js` | `redraw()`, the last complete frame drawn again, in the second slice | decision 6 |
| `tools/check_host_loop.ps1` | ten cases, the tenth's floors, three mutant pages more | decision 9 |
| `tools/check_cartridge.ps1` | two cartridges, the card's floor | decision 9 |
| `tools/check_blit_floors.ps1` | three cases from one run, in the second slice | decision 6 |
| `Cargo.toml`, `Cargo.lock`, `tools/check_engine_deps.ps1` | the pin moved to Frazaro's commit, in the second slice | decisions 4 and 5 |
| `ROADMAP.md`, `REARVIEW.md`, `README.md`, `web/README.md`, `engine/README.md`, `Delta/CLAUDE.md`, the memory | the line, this record, the tables and pages | decision 10 |

**The decisions, the owner's.** Each with the sitting's recommendation and the alternative it declined.

1. **The oracle in two places, each where it bites: an engine test, and a case of the page's loop oracle.** In Rust, beside the engine's other tests: the test card loaded and stepped twenty-five frames, and at each the window the Camera places, read off the Camera's own record, the Screen's whole extent, a window past it and the twin's window, each plane equal to the record of the same window; at frame 5 a value, a formula and a derived row written inside the window, each compared at once, and a refused derived row; the record read with the language's reader and mapped by §3.1's words alone, a whole number from 0 to 254 itself and any other value 255, an absent cell and a formula with no value row 0, the first differing cell named; and Life at its four corners, which cross the edge of its extent, and a band across its whole width, at frames 0 and 1. In the page, `?loop=1`'s tenth case, `plane`: the host draws the test card over the engine's module by manual ticks for twenty-four frames, and at frame 0 and after each frame the page holds the host's window to the Camera's, by its own arithmetic of the card's formula and by the Camera's record; the host's plane to the record of that window, by its own reading of §3.1; and the canvas's pixels at probe cells to the Palette's record, magenta past it, black for 0, each probe at a cell's corner as `KERNEL.5` learned; over the double the same, the Camera moved by edits and a formula written outside the declared size. *Alternative:* the Rust test alone, which never sees the window the host chooses or the colours it draws; or the page alone, which `cargo test` cannot run, and so neither a stranger without a browser nor the crate job's gate.
2. **A test card as the fixture, `cartridges/testcard/testcard.vla`, Life beside it.** A plane of 40 by 24 cells on a Screen 56 columns wide and 22 rows high, which a Camera pans one column a frame from 1 to 21 and back, so the window's right edge passes the Screen's last column and the columns past it read blank; rows 1 to 8 the sixteen colours as bars three columns wide, then numbers that are no colour, 16, 100 and 254, which the plane carries as themselves and the host paints magenta, and 255, 256, -1, 0.5 and 1e300, which it carries as 255; rows 10 and 11 one value of each other kind, a text, a text that spells a number, the empty text, both truth values, the seven error values, a number one unit in the last place from a colour, 1e-300, -0, and 7 written as 7.0; rows 13 to 16 formulas that compute each kind, a colour cycling with the frame, a byte that passes 255 at frame 16, a fraction every other frame, `0.1*3*10`, `1/0`, a text, a truth value, `SIN`, a negative, a counter through its own twin, a reference to an empty cell; rows 18 to 22 one formula filled over the whole width, a stripe that moves; and the Camera's formula with a `value` row, a save's spelling, so frame 0 is drawn at column 1 without the host's sentence about an empty Camera. It ships as the second cartridge, so that a person loads what the oracle checks and sees the colours, magenta wherever a value is no colour, and the pan. *Alternative:* the cases written inline in each test, two copies that drift and nothing a person can load; or Life alone, whose cells are 0 and 1, whose window has no Camera and holds no value of another kind.
3. **No new export: the plane stays the record's text, and the host reads it as it does.** Measured above, the record's copies cost three microseconds of a frame and the host's whole share at most 0.3 ms, so the table of `SPEC.md` §4.6 stays at eleven, `check_host_exports.ps1`'s list and the ABI number stay, and the double keeps its shape. "Read out of the module's memory as a typed array" is what the host already does, the record's bytes into a `Uint8Array` and blitted whole, never printed. *Alternative:* an `alonzo_plane` export writing into a buffer the engine keeps and the host views in place, which would save those microseconds at the price of a twelfth export, a second shape of answer beside §4.6's one record, its twin in the double and the check's list.
4. **The cost is the language's, asked of Frazaro as a new item: the plane kept at the frame's end, `KERNEL.23` by its registry's next free number, minted there.** What it asks is V2's shape: the snapshot that fills the twins already looks up every formula's value at a frame's end, and keeps the byte beside it; a write drops the bytes of the sheets it touched, the walk answering until the next frame; the walk stays as the reference. Its oracle is its own test, the kept bytes equal to the walk at every frame and after every kind of write, and from here this item's equality, which holds the plane to the record through the kept bytes and through the walk, and failed the stale-bytes mutant by name. The prompt for the Frazaro session is given in the chat and kept nowhere on disk. *Alternatives:* the cost accepted, the item closing with it recorded, every plane cartridge paying 2.5 to 5.5 ms a frame, a sixth to a third of a 60 Hz interval once its step is cheap, and the module's frame path unable to hold the blit's bars; or V1's cheaper hash, which takes a third off the view and a sixth off a step, and is `KERNEL.20`'s ground, the evaluator's speed: given to the Frazaro session as a finding for that line and not asked here.
5. **Two slices, the instrument before the operation.** The first, now, over `6cca2e1`: the oracle, the card, the double's line, the picker and the checks (decisions 1, 2, 7, 8 and 9), a commit of its own that holds whatever the language's commit does next. The second, after Frazaro's commit: the pin moved to it in `Cargo.toml`, `Cargo.lock` and `check_engine_deps.ps1`'s two baseline lines in one commit, the equality run again over the kept bytes, the blit's third case and the owner's baseline (decision 6), and the item closed. Frazaro's push before this repository's, at the owner's word, since the crate job resolves the pin from Frazaro's remote. *Alternative:* one commit after Frazaro's, holding the oracle back for the language's schedule; or no second slice, which is decision 4's first alternative.
6. **The blit's instrument gains a third case, `engine`, the frame path minus the evaluator over the engine's module, in the second slice; one baseline of three rows under the same bars.** Life loaded over the module and stepped once to its soup, untimed; then 120 frames of a new method of the host, `redraw()`, the last complete frame drawn again, the Camera and the Palette read as they stand, the plane viewed through the window and blitted, no step and no other effect read, at the scale that fits the screen. `check_blit_floors.ps1` requires the three cases from one run under the bars it holds now, p95 under 2.0 ms and max under 4.0, and its control gains a mutant, the third case missing. *Prediction*, written before the owner's run: the view's p50 0.0 ms and the frame's p95 under 1.0, as the double's fit case; over `6cca2e1` the same case would read a view of 2.5 to 5.5 ms and fail its bar (*derived* from the measurement above), which is why it waits for the second slice. *Alternative:* the third case over `runFrameSync`, whose frame would be Life's 270 ms of evaluation; a page of its own; or no case, the module's frame path never measured on a real display.
7. **The double reads a formula without a value as 0 wherever it stands, as §3.1 and its own record say.** One line of `web/fake.js`'s plane; the tenth case over the double holds it. *Alternative:* the double refusing a formula outside its declared size, which would answer a write the module accepts.
8. **The engine panel picks its cartridge.** A select of the cartridges built into the page, Life and the test card, filling the cartridge's text and the file's name the load passes, which is `life.vla` today whatever was loaded. *Alternative:* the card reachable only by pasting its text, so that the oracle's fixture is never seen.
9. **The checks.** `check_host_loop.ps1`: ten cases, the tenth's floors over the double and, when the page holds the module, over the module; its control gains three mutant pages, a host that reads the Camera after the plane, whose plane is a frame late and must fail `plane` by name; a host whose blit masks a byte to the Palette, `pal[bytes[i] & 15]`, so that a byte past the Palette draws as a colour and the probes must fail; and the double's old 255, which must fail `plane` over the double. `check_cartridge.ps1`: two cartridges, the card's floor of 112 rows. `check_web_offline.ps1` unchanged: the template's second cartridge place holds by its rule as written. `check_blit_floors.ps1` and `check_engine_deps.ps1` in the second slice. No new check, so `run_checks.ps1` stays at 11. *Alternative:* a check of its own for the equality, a twelfth harness over the same browser run.
10. **The bookkeeping, and the commits.** `ROADMAP.md`'s `ENGINE.2` line gains this scoping and Frazaro's item as a dependency of its second slice, the built marker after the first, and leaves for the ledger when the second is tested and committed; this entry and its two build records; `README.md`'s rows for `cartridges/` and `web/`; `web/README.md` on the card, the tenth case and, in the second slice, `redraw()` and the third case; `engine/README.md` on the frame path; the map's line; the memory. `SPEC.md` is corrected only where the build finds a sentence the code contradicts, and none is foreseen: §3.1, §4.5 and §13 say what the build does. The commits at the owner's word, by `-F`, staged by hunk: `ENGINE.2: the plane held to the record of the same window, byte for value, through the Camera, with a test card`, and `ENGINE.2: the frame path over the engine's module, the plane kept by the language at the frame's end and held to the blit's bars`.

**The catch.** Each met once, or foreseen by reading.
- A file restored with `Copy-Item` keeps its source's write time, older than a mutant's build, and Cargo's freshness check then keeps the mutant: a clean run read the mutant's result once (met on the day). A control that edits a crate's source restores it by writing it, never by copying it back.
- A test's writes must land inside the window it compares: the Camera had panned past the first draft's targets, and a stale-bytes mutant read green (met on the day).
- A whole Screen's record is tens of megabytes, Life's 62,964 formula rows of some 430 characters each: Life's equality is its corners and a band, the whole window's is the card's, about 48 KB a frame.
- The record's numbers are the shortest round trip: a reader that rounds, or compares spellings, calls `3.0000000000000004` a colour or `-0` no number.
- A Camera formula has no value at frame 0; the card's `value` row gives the first window, which `check_cartridge.ps1` takes after its formula row.
- Not computed cannot reach an engine's grid; its 255 is the language's test.
- In-module timings are wall-clock over 50 to 100 calls under the timer's grain of 0.1 ms in a headless browser: numbers for a scoping, never a floor, which is the owner's run.
- PowerShell 5.1 as every check met it: ASCII, `return ,$list`, `$onWindows`, the Write tool and never a heredoc, a commit message by `-F`.
- The tree is shared: the ledgers staged by hunk, HEAD plus this item's own; and the pin's move resolves in CI only once Frazaro's commit is on its remote.

**Oracle.** On the owner's machine under Windows PowerShell 5.1, then on both jobs:
- `cargo build --workspace`, `cargo fmt --all -- --check`, `cargo clippy --workspace --all-targets -- -D warnings` and `cargo test --workspace` green, the two equality tests among the engine's fourteen.
- The module built; `check_host_imports.ps1` at 0, `check_host_exports.ps1` at the eleven names, `check_engine_deps.ps1` at two packages, at the moved pin in the second slice.
- `check_host_loop.ps1` under headless Chrome at both ratios with the module built in: ten cases clean; its control failing ten mutant pages, each for its own reason.
- `check_cartridge.ps1` at two cartridges, its control's thirteen mutants failing.
- `run_checks.ps1 -WithExtras` at 11 checks and 11 verifiers, `ALL GREEN`.
- The owner's hand test of `web/index.html`: the test card picked and loaded, the sixteen bars, magenta wherever a value is no colour, the window panning a column a frame and wrapping after 21, black past the Screen's last column, the stripe moving; an edit inside the window seen at the next frame; Life picked again, running as before.
- In the second slice: Frazaro's item green by its own tests; the pin moved and the equality green over it; the owner's `?blit=1` in Chrome in fullscreen pasted, three rows; CI green at the owner's pushes, Frazaro's first.

**Size.** `~days`: the card about 150 lines, the two Rust tests about 200, the page's case about 180 and the picker 30, the checks about 120, the double one line; the second slice small on this side, `redraw()`, the instrument's case, the floors and the pin, beside Frazaro's item of about fifty lines and its test. (*prediction*)

*Approved 2026-10-09, the same day, all ten, in the owner's words: "Your recommendations for the ten decisions are approved." Decision 4's prompt had gone to a Frazaro session first, which minted and closed two items rather than one and handed back the same day: `KERNEL.23` (`d77ce10`), the machine's refusals naming what they refuse, the row's line left to the answer's own field; and `KERNEL.24` (`c0686a9`), the plane kept at the frame's end, with one change from the prototype at the owner's approval there, that only a sheet once viewed as a plane keeps its bytes, from the next frame's end, so the first view after a load still walks and a sheet never drawn as a plane pays nothing. Both are committed on Frazaro's main and on no remote, Frazaro nine commits ahead of its own. So the second slice's gate was met before the first was built, and both slices were built the same day, the first over `6cca2e1` and the second over `c0686a9`, each for its own commit.*

*The first slice built 2026-10-09, awaiting the owner's run.* What landed: `cartridges/testcard/testcard.vla`, the test card as decision 2 designs it, CRLF as `.gitattributes` gives a cartridge, 112 rows, 960 cells, 393 of them formulas; `engine/src/cartridge.rs`'s two tests, `the_test_card_s_plane_is_its_record_every_frame` and `life_s_plane_is_its_record_at_its_corners_and_a_band`, the record read with the language's `read_forms` and mapped by `record_byte`, §3.1's words, the first differing cell named, and at frame 5 the three writes aimed inside the window the Camera has panned to; `web/fake.js`'s `byteOf`, which reads an absent cell and a formula with no value as 0 wherever it stands, and the Screen's branch no longer forcing 255 on a formula outside the declared size; `web/index.template.html`: the card's place beside Life's, a table of the cartridges built in, the picker above the panel's buttons, the file's name a load passes (`life.vla` whatever was loaded, before), the header comment, and the tenth case, `plane`, over the double for twelve frames and over the module for twenty-four, at a fixed three device pixels a cell so the probes' arithmetic is the page's own, the record read by `recordByte` and `recordBytes` (a row for a cell outside the window named as the record's defect), and each run's two edits pinned as landed, so that an edit refused could not leave the equality holding by default; `tools/check_host_loop.ps1`: ten cases, the tenth's floors over the double and over the module, `New-MutantPage` taking a double of its own, and three mutant pages, the Camera read after the plane, the blit masking a byte to the palette, and the double's old 255; `tools/check_cartridge.ps1`: two cartridges, the card's floor of 112 rows; `tools/run_checks.ps1`'s line for the loop's control; `README.md`, `web/README.md` and `engine/README.md`.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1 (*measurement*): `cargo fmt --all -- --check` and `cargo clippy --workspace --all-targets -- -D warnings` clean; `cargo test --workspace` 14 passed in 2.5 s in a debug build; the module rebuilt, 456,328 bytes as before, the tests being no part of it; the page built with two cartridges; `check_host_loop.ps1` clean under headless Chrome 154 at both ratios, ten cases, the first nine's counts and digests unchanged, `plane` over the double 12 frames, 13 of them equal to the record with frame 0, 2 windows and 40 pixels read back, and over the module 24 frames, 25 equal, 21 windows, 96 pixels and 31 distinct bytes; its control failing ten mutant pages each for its own reason, in 65 s; `check_cartridge.ps1` at two cartridges and its control's thirteen mutants failing; `run_checks.ps1 -WithExtras` at 11 checks and 11 verifiers, `ALL GREEN`, in 126 s.

Found in the build: `check_cartridge.ps1`'s control expected the rename of Life out of the glob to leave `found 0 cartridge(s)`, true of one cartridge only; the count it wants is read off the baseline now, one less than pinned. `check_spdx.ps1` reads the tracked files, so the card's header is held from the card's first staging and not before; run against a scratch index holding the card, it read two headers and passed.

*The second slice built 2026-10-09, over `c0686a9`, awaiting the owner's run.* The pin: `Cargo.toml`'s rev from `6cca2e1` to `c0686a9`, fetched as before from the local Frazaro clone through git's `insteadOf` for one command, so that `Cargo.lock` records the source CI will compute, `git+https://github.com/Spreadsheet-Company/Frazaro?rev=c0686a9#c0686a90a977323bd27220034734d4af46ee884d`; and `check_engine_deps.ps1`'s two baseline lines with it, its control's commit and rev now read off those two lines, so that the next move of the pin touches them alone. What else landed: `web/host.js`'s `redraw()`, the last complete frame drawn again with no step and no effect read beyond the Camera and the Palette, and its comment on a refusal's line corrected for `KERNEL.23`'s words; `web/index.template.html`'s third case of `?blit=1`, `engine`, the instrument's measuring loop taking the module or the double, over the module Life's first frame stepped once, untimed, then `redraw()` 120 times; `tools/check_blit_floors.ps1`: three cases from one run under the same bars, the engine case at a fitting scale as the fit case is, its control's eighth mutant, the engine case missing; `tools/run_checks.ps1`'s lines; `web/README.md` and `README.md`.

The oracle over the new pin, on the day (*measurement*): `cargo fmt` and `clippy -D warnings` clean; `cargo test --workspace` 14 passed in 2.5 s, the two equality tests now through the language's kept bytes from the end of frame 1 and through its walk after each write between steps; the module 458,702 bytes, 2,374 more than over `6cca2e1`, 0 imports and the eleven exports; `check_engine_deps.ps1` at two packages and its control's seven mutants failing; `check_host_loop.ps1` clean at both ratios, ten cases, every count and digest as over `6cca2e1`, `KERNEL.23`'s new words reaching no pin, since every case pins ids, and module words only where no refusal is expected; the `?blit=1` smoke under a virtual clock running its three cases; `check_blit_floors.ps1`'s control failing eight mutants and the check itself failing on one problem, `the case engine is missing from the baseline`, as the first baseline failed until it was pasted; `run_checks.ps1 -WithExtras` 10 checks passing and that one failing, 11 verifiers passing, in 110 s.

The language's view in wasm, measured as the scoping measured it, for the Frazaro session that asked (*measurement*, two runs, Chrome 154 headless with no virtual time, the scratch export beside the engine's eleven): Life's plane of `A1:LH200` 0.33 ms inside the module at frame 0, the first view walking and marking the sheet as `KERNEL.24` designs it; 0.003 ms at frames 1 and 11, the kept bytes, against 2.5 to 5.5 ms over `6cca2e1`; the host's whole path under the timer's grain of 0.1 ms; a step 188 to 192 ms at frame 1 and a median of 271 to 275 ms at frames 2 to 11, unchanged; Life exact, 23,683 and 14,482 live cells at frames 1 and 11.

Found in the build: no real-time number of the instrument can be had headless: `--dump-dom` writes the page at its load, before an asynchronous page has measured anything, `--timeout` does not hold it, and under a virtual clock the measured work takes no time at all. The frame path's numbers are the owner's run, which is what the floors were built around; the language's view, a synchronous call, was timed by the scoping's bench instead.

What remains is the owner's. Open `web/index.html` in Chrome: pick the test card above the panel's buttons; the sixteen colours as bars, magenta wherever a value is no colour, black where a cell is empty, the window panning a column a frame and wrapping after 21, black past the Screen's last column, the stripe moving; an edit `(cell "Screen" "H3" 200)` turns that cell magenta from the next frame, whenever the window holds column H; pick Life again, which runs as before. Then `web/index.html?blit=1` in Chrome, Fullscreen, wait for Done, Copy, and paste the three rows and the two lines above them into `tools/check_blit_floors.ps1` with `$baselineDate`, replacing the two rows there; `run_checks.ps1 -WithExtras` must then be `ALL GREEN`. Then the two commits at the owner's word, staged by hunk; and the pushes at the owner's word, Frazaro's first, since the crate job resolves `c0686a9` from Frazaro's remote.

*The owner's run, 2026-10-09.* The hand test met every item, in the owner's words "Hand test produced expected results.": the test card's bars, its magenta and its pan, an edit seen in its frame, and Life as before. And `?blit=1` in Google Chrome 154.0.8037.98 in fullscreen at a ratio of 1.5, pasted into `tools/check_blit_floors.ps1` whole as its second baseline (*measurement*): `fit` at 10 device pixels a cell, frame p50 0.7 ms, p95 1.1, max 1.6, view p50 0.2; `scale-1` p50 0.7, p95 1.0, max 1.3; `engine`, the new case, Life's first frame redrawn over the module at 10 device pixels a cell, frame p50 0.3 ms, p95 0.5, max 0.8, view p50 0.1, blit p50 0.1; no frame dropped in any case, and all three holding the frame. *Against the prediction:* the engine case's p95 under 1.0 met at 0.5; its view p50 of 0.0 missed by one grain of the 0.1 ms timer, the module's own share being 0.003 ms. It draws less than the double's fit case, which runs the whole frame where it redraws, so the two agree on the view and the blit and not on the frame. *Found:* the double's fit row moved from the first baseline's p95 of 0.9 ms and view of 0.1 to 1.1 and 0.2, Chrome a patch newer and another run, both far inside the bars; the first baseline's two rows are kept in the check's comment, the second run having replaced them whole, so the paste hides nothing. `run_checks.ps1 -WithExtras`: 11 checks and 11 verifiers, `ALL GREEN`, in 112 s. *Owner-tested 2026-10-09; the two commits await the owner's word.*

*Committed and closed 2026-10-09 at the owner's word, "Commit both slices independently then suggest next steps": the first slice as `1278279`, its tree the one the checks ran over before the second slice was begun, staged from that state's own files; the second with the item's close, the roadmap's line moved to the ledger's engine section above. Not pushed: the owner pushes once Frazaro's tree is clean, Frazaro's first, since the crate job resolves `c0686a9` from Frazaro's remote.*

## `CART.1` — Life, the benchmark cartridge

*Scoped 2026-10-09, at the owner's word, the day `ENGINE.2` closed: Life on the 320 by 200 Screen as the engine's own benchmark, a seeded soup and a glider gun as its two fixtures, cells evaluated a second and frames a second as floors that never go down, `CHARTER.md` §3's two million a second the first bar, the naive evaluation the reference and a known pattern's generation matched to Golly's. The scoping finds half of the item already standing, since `ENGINE.1` needed a cartridge: Life's rule over the interior as one shape, its Palette, its soup, exact at generations 0 and 10. What is missing is the gun, the instrument, the floors and the oracle, and the profile that names where a step's time goes, so that `ENGINE.6` and `KERNEL.20` open on a number. The profile was measured before any claim, natively and in WebAssembly, in scratch copies and never in Frazaro's tree; its first finding moves most of the cost to Frazaro, and its second changes how anything on this machine can be timed at all.*

**Substrate, verified.** Read on the day, by file and never by assumption.

- *The pre-flight.* This tree clean at `2d1f909`, three commits ahead of `origin/main` (`984722a`), CI's last run green there (`37908827347`); `run_checks.ps1 -WithExtras` at 11 checks and 11 verifiers, `ALL GREEN`. Frazaro at `a8dd627`, a peer's `U.32` committed after `c0686a9`, ten commits ahead of its `origin/main`, its last CI green at the 0.8.0 release; five files uncommitted there by other sessions, none under `vla-lang/`; its registry's next free number `KERNEL.25`.
- *The step, in the language* (`vla-lang` at `c0686a9`, Cargo's checkout, read-only). `Machine::step` evaluates each formula cell in the order and inserts its value into the frame's map of values, then swaps the two maps, counts the frame and runs the snapshot, which fills the twins and keeps the plane. `Shapes::evaluate` looks the cell up in the plan's map of places and of unread texts, then evaluates the shape's one parse at the cell's offset. `Env::read` looks the cell up in the frame's map of values, then in the plan's places, then in the sheet's B-tree of cells. `Ctx::call` upper-cases the function's name into a new string for the map of forms, and again for the map of strict functions, both keyed by `String`. A reference goes through `graph::areas_at`, whose `Workbook::find_sheet` folds the wanted name into a new string and then folds every sheet's name in turn until one matches. Life's grid holds ten sheets with the twins, and `Screen.last` is the sixth. Each reference returns a fresh `Vec<Area>`, and `Arg::Area` clones the reference's written text. `Ctx::each` collects `cells_in`'s walk into a `Vec` before reading each cell again through `Env::read`; `SUM` collects its numbers into a `Vec`, `AND` and `OR` their truth values, and every strict call its arguments. `AND` and `OR` are strict, so neither short-circuits. Life's steady formula, `IF(Clock!$B$1=1, soup, IF(OR(SUM(Screen.last!A1:C3)-Screen.last!B2=3, AND(...)),1,0))`, makes six calls and six references, one to the Clock and five to the twin, and walks two ranges of nine cells.
- *The engine.* `Cartridge::step` writes the frame's number into `Clock!B1` through the machine's `write` before it steps; the write parses one row and settles three cells. Its `view` adds nothing to the machine's.
- *This repository.* `cartridges/life/life.vla`, 51 rows, the rule over `B2:LG199` as one formula row; the page's `lifeReference` in the loop oracle's engine case and the engine test's small Life are the two references outside the engine; `build_web.ps1` wants a folder per cartridge and `check_web_offline.ps1` reads its places off the folders; `check_cartridge.ps1` pins two cartridges and a row floor each; `check_engine_deps.ps1` pins the lock at two packages; CI's crate job runs `cargo test` and `clippy --all-targets`, which compile and lint a crate's examples, and builds the module with `-p alonzo --target wasm32-unknown-unknown`, which builds none.
- *The machine of the measurements:* the owner's, an Intel Core Ultra 7 265KF of twenty cores, 31.7 GB, Windows 11 Home 10.0.26200, rustc 1.99.0, Google Chrome 154.0.8037.98 run headless with no virtual clock. Every scratch build ran under this workspace's release profile.

**The profile, measured.** A scratch workspace held copies of `vla-lang` at `c0686a9` and of this engine, and a scratch runner, an example of the engine's copy. The runner loads a cartridge through `Cartridge`, steps it, times each frame and holds every frame's plane to a hand-written Life before it prints a number. Its allocator counts allocations, or bumps and never frees. Each ablation was a scratch change to the language behind a feature. The module's half was a scratch page that steps the engine's module through its exports at its load, synchronously, and holds every frame to a Life written in JavaScript. All of these are *measurements*, 2026-10-09.

- *Where a steady frame of the soup goes, natively.* A step of 273 to 284 ms, 222,000 to 230,000 cells a second, the soup's first frame 206 to 218 ms and the load 160 to 183 ms. The evaluation is 283.0 ms of a 288.7 ms frame and the snapshot 5.7 ms; the Clock's write is under the timer's notice. Per formula cell, counted exactly: 6 calls, 10 lookups of a library name, each allocating its upper case; 6 references, each a `find_sheet`, 39 folded names a cell; 2 range walks; 21.9 reads, 20.9 of them the twin's, each a lookup in the map of values, one in the plan's places and one in a B-tree; 1 insert into the map of values. That makes 71.0 allocations and 17.9 reallocations a cell: 4,470,532 and 1,129,229 a frame, 159 MB, the same integers in every frame and every run. A bump allocator that never frees runs the same frames in 212 ms, so the allocator itself, allocation and free, is about a quarter of the step.
- *What each cost is worth: the ablations, each removing one cost, every frame still equal to the hand-written Life.* Natively, from the median of three runs and the base of 273.2 ms:
  - `find_sheet` comparing names by `eq_ignore_ascii_case`, which is the fold's own test byte for byte: 187.5 ms, the largest single cost at a third of the step.
  - The library's lookup of a name already in upper case without upper-casing it: 261.0.
  - A reference's written text shared and not cloned: 267.5.
  - A single sheet's area held inline and not in a `Vec`: 267.2.
  - `SUM`, `AND` and `OR` folding as they walk, the walk not collected: 243.2.
  - The value maps and the plan's places under an in-crate Fx hash: 243.6.
  - A twin's read going straight to its cell, past both maps: 242.3.

  The five that remove allocations make 123.5 ms together, and the two over the maps 240.5; all seven make 93.8 ms, 671,000 cells a second, 2.9 times the base. Two prototypes went past them. The twin's values kept by the snapshot as an array over its extent, so that a read is an index, gives 67.4 ms with the six others. With a range walked over that array as well, the step is 46.4 ms, 1,357,000 cells a second, 5.9 times the base: two thirds of the bar natively, and still short of it.
- *The same in WebAssembly* (two runs each): the base 270.0 ms, 233,000 cells a second; `find_sheet` alone 215.3; the five allocation fixes 176.3; the two map fixes 225.3; all seven 134.8, twice the base; with the dense twin 90.3; with its range walk 59.8, 1,053,000 cells a second, 4.5 times the base. The reading: the module's allocator is cheaper than Windows' heap and its hashing dearer, so the allocation fixes buy less in the browser and the map fixes more. One build can move the two numbers by different amounts, in either direction.
- *The workspace's own lever:* `opt-level = 3` in place of `"s"` makes the base 253.5 ms natively and 262.8 in wasm, all seven 86.2 and 124.8, every prototype 43.2 and 52.4. That is 3 to 12% faster, for a module 13% larger (517,268 bytes against 458,091).
- *The honest comparison* (`CHARTER.md` §7), a Life that computes every cell every generation, hand-written. It takes 0.10 to 0.13 ms a generation natively, about 500 million cells a second, and 0.22 to 0.31 ms in JavaScript. The engine's general evaluator is about 2,200 times slower than that Life natively on the soup.
- *The gun* (the scratch draft of decision 1, Gosper's gun from its published RLE with its top-left at `J10`), held by the hand-written Life:
  - Its 9 by 36 box at every generation that is a multiple of 30 equals generation 0's, through generation 900.
  - Its population is 36 plus 5 a period, exactly, through generation 720, which is 156.
  - The first live cell stands beside the dead border at generation 740.
  - From 750 the population alternates between 156 and 160, the stream dying on the border.
  - The engine's 31 frames all equal the hand-written Life, 41 live cells at frame 31.

  A steady frame of the gun costs 297 to 300 ms natively and 285 to 288 in wasm, against the soup's 280 to 284 and 273 to 275: the naive evaluator's cost per cell does not depend on what lives in it, as predicted, but the gun's grid holds one sheet more. Its `Seed` sheet stands before the engine's own and its twin after them, so each of a cell's six references folds one name more, 77 allocations a cell against 71. A reference costs more for every sheet the grid holds, which is the profile's first finding seen from the side.
- *The finding that changes how this machine can time anything.* A process the desktop deems in the background is throttled by Windows about three seconds into a run, the power throttling Windows calls EcoQoS.
  - The hand-written Life alone runs 0.101 to 0.105 ms a generation for three seconds and 0.13 to 0.16 ms after.
  - The soup's frames 2 to 10 take 266 to 291 ms and every frame from the twelfth 351 to 512, whether the process is pinned to the first eight cores or the last twelve. Rests of one to ten seconds do not reliably restore the clock.
  - With the throttling forced on, the steady frames take 358 to 531 ms, a median of 454. With the process opted out of it through `SetProcessInformation`, frames 2 to 31 take 273 to 290 ms, a median of 281.
  - Headless Chrome is throttled the same way, its frames from the twelfth taking 285 to 406 ms. Chrome's own flags against backgrounding (`--disable-renderer-backgrounding`, `--disable-background-timer-throttling`, `--disable-backgrounding-occluded-windows`, `--disable-features=UseEcoQoSForBackgroundProcess`) alone leave it throttled (a median of 303), and so does opting its processes out alone (312). Both together hold all 31 frames at 241 to 264 ms, a median of 256.

  The earlier figures stand: `ENGINE.1`'s 226,000 to 236,000 cells a second, `ENGINE.2`'s 271 to 289 ms and `KERNEL.22`'s 0.258 s came from runs of eleven frames or fewer, whose medians fall inside the unthrottled window. A run longer than three seconds in a background process is not a measurement of the engine on this machine, and a floor measured that way would be a floor of the power policy. Across sessions, unthrottled, the soup's median reads 273 to 284 ms natively and 256 to 275 in wasm, a spread of 4% and 7%.

**The bottleneck, named.** The naive evaluator's own overheads come before any accelerator. First, the allocations of its hot path: a reference's sheet found by folding names, the library's names upper-cased, the label cloned, the area list, the collected walks and arguments, together 55% of a native step and 35% of a wasm step. Second, the hashing of the two value maps and the plan's places on every read. Third, the twin's B-tree, read 21 times a cell and walked a row at a time twice. Removing all three, bit for bit, measures 5.9 times faster natively and 4.5 times in wasm, before anything `ENGINE.6` or `KERNEL.20` would add: the vectorized shape, block memoization or dirty regions. Each of those is then measured from the cheaper base, which is where it can be seen.

**The work.** A cartridge, a runner, a page mode, an instrument, a check, three checks moved, and in a second slice the pin and the floors raised.

| File | What it is | Copied, adapted, or decided |
|---|---|---|
| `cartridges/gun/gun.vla` | Gosper's glider gun, 0BSD, CRLF: a `Seed` sheet of 36 values the first frame reads, then Life's rule word for word, one shape over 62,964 cells | decision 1 |
| `engine/examples/frames.rs` | the native runner: cartridges through the engine's `Cartridge`, every frame held to a hand-written Life, the gun's facts, the allocations counted, the hand-written Life timed beside every frame, the rows printed; a check mode | decisions 2, 3, 5 and 7 |
| `engine/src/cartridge.rs` | a test: the gun's first two frames, the `Seed` sheet and its first generation | decision 2 |
| `web/index.template.html` | the gun's place and picker; `?frames=1`, the engine's module stepped over both fixtures at the page's load, every frame held to the page's reference Life, the rows printed | decisions 1 and 4 |
| `tools/bench_frames.ps1` | the instrument: the runner and the page run on the owner's machine with Windows' power throttling opted out, one baseline block printed | decisions 4 and 5 |
| `tools/check_frame_floors.ps1` | the baseline held: its shape, its pin and digests, the floors that never go down, the bars' distance; with a built runner, the frames and the allocation ceilings | decisions 6 and 7 |
| `tools/check_cartridge.ps1`, `tools/run_checks.ps1`, `.github/workflows/checks.yml` | three cartridges and the gun's floor; the floor at 12 and the new control; the crate job builds the runner before the runner script | decisions 7 and 12 |
| `Cargo.toml`, `Cargo.lock`, `tools/check_engine_deps.ps1` | the header's "native runner" sentence now an example; in the second slice, the pin moved | decisions 3 and 11 |
| `SPEC.md` | §6 rule 5 and §7.6, dated corrections | decisions 2 and 4 |
| `CHARTER.md` §7, `ROADMAP.md`, `REARVIEW.md`, `README.md`, `engine/README.md`, `web/README.md`, `Delta/CLAUDE.md`, the memory | the second number measured, the line, this record, the pages | decisions 8 and 12 |

**The decisions, the owner's.** Each with the sitting's recommendation and the alternative it declined.

1. **The fixtures: Life's soup as it stands, and the gun a cartridge of its own, `cartridges/gun/gun.vla`.** The soup's file is untouched, so its pins, 23,683 and 14,482 live cells at frames 1 and 11, and its digest hold. The gun is Gosper's, from its published RLE (36 cells, 9 by 36), its top-left at `Screen!J10`, so that its stream runs south-east for 740 generations before a glider meets the dead border. Its pattern is a `Seed` sheet of 36 values the first frame reads, `=IF(Clock!$B$1=1,Seed!B2,...)`, as the engine's small-Life test seeds its board, and the rest of the formula is the soup's rule word for word, so the two fixtures differ only in their first frame and in the sheet. It ships as the page's third cartridge, where it can be seen firing. *Alternative:* a switch cell inside `life.vla`, choosing soup or gun, which changes the soup's file and the fixture its pins were measured on; or the pattern written as the Screen's values, which cannot be, every Screen cell being the rule.
2. **What "matches Golly's" means: the gun's published facts, held on the hand-written Life to generation 720, and the engine's every frame held to the hand-written Life.** Golly is not in this repository, and its plane is unbounded where Life's border is dead; the two agree on the gun until generation 740 (measured). LifeWiki's Gosper glider gun gives the oracle: period 30, 36 cells, one glider of 5 a period, travelling diagonally at c/4. The runner holds its own Life to that every 30 generations through 720, the box equal to generation 0's and the population 36 plus 5 a period, and holds the engine's plane to its own Life at every frame it steps. That makes three Lifes outside the engine: the runner's, the page's and the engine test's small one. `SPEC.md` §7.6's "`CART.1`'s Screen at generation `n` against Golly's" gets a dated correction: the Screen held to the hand-written Life at every frame, and the gun to its published facts. *Alternatives:* the owner's one run of Golly on the gun in a bounded plane of the cartridge's interior, rule `B3/S23:P318,198`, its population at generation 900 (156 by the runner's Life) pasted beside the facts, an outside witness past the border, at the price of installing Golly; or a stored golden of generation `n`, which needs Golly to write it.
3. **The native runner is an example of the engine crate, `engine/examples/frames.rs`.** It adds no package to the lock and no dependency, so `check_engine_deps.ps1` and `AD-5` stand as they are. `cargo test` compiles it, `clippy --all-targets` lints it, the module's build never builds it, and `cargo run --release --example frames` is how a contributor runs it. Its counting allocator is its own `#[global_allocator]`, inside the example and in nothing that ships. `Cargo.toml`'s header, which reserved "the native runner the frame floors need" as a workspace member, says so. *Alternatives:* a workspace member `runner/`, a third package in the lock that `check_engine_deps.ps1` pins at two, a second manifest and nothing an example does not already do; or a binary in `engine/src/bin/`, which the module's build would compile for wasm too.
4. **Where the floors are measured: on the runner and on the module both, four rows from one instrument, `tools/bench_frames.ps1`.** The instrument builds what it needs: the runner, the module and the page. It runs the runner over both fixtures, then the page's new `?frames=1` mode over both under headless Chrome. It prints one baseline block: the date, the machine, Chrome's and rustc's versions, the pin, the fixtures' digests, and four rows (native and wasm, soup and gun) of frames, the first frame, the steady median, minimum and maximum, cells a second and frames a second, with a suggested floor line. The owner runs it and pastes it, as the blit's baseline is pasted. Both halves, because the profile shows them moving apart: the same build moved the native step by 55% and the module's by 35%. A floor on one would misreport the other, and the charter's bar is the module's ("in WebAssembly, is what Alonzo would be"). `SPEC.md` §6 rule 5's "a floor is held on the runner" gets a dated correction: a floor held on the runner and on the module both, the two measured apart by a factor of 1.4 on one build. *Alternatives:* the runner alone, the rule's letter, the browser never measured again; or the page alone run by hand in a foreground Chrome as the blit is, the product's number with no native one for a contributor.
5. **Windows' power throttling, handled where it bites.** The instrument starts the runner and opts its process out through `SetProcessInformation`. It starts Chrome with the four flags against backgrounding and opts out every Chrome process as it appears, the only combination measured to hold. Both the runner and the page time the hand-written Life beside every frame, and refuse to print baseline lines when its time moves more than 10% across the run, so that a throttled or thermally limited run names itself instead of passing as a regression. *Alternatives:* foreground runs by hand only, which the throttling never touches while the window keeps focus, and which the clock check would still guard; or runs short enough to end inside three seconds, today ten frames of Life, a median of too few.
6. **What a floor is while the bar is out of reach: the baseline less a margin of 10%, a floor that never goes down, the bar printed as the distance.**
   - Each of the four rows has its floor in cells a second, and the same floor in frames a second: one measurement in two units, the frame being the step's formula cells.
   - The margin is the measured spread across sessions, 4% natively and 7% in wasm, rounded up.
   - The floors keep a dated history in the check. Each entry is at least the one before it, row by row; a lower entry needs a reason written beside it, a correctness fix that costs speed say, which the commit message repeats.
   - Each pasted row must clear its floor.
   - The bars are `CHARTER.md` §3's 2,000,000 cells a second and Life's rate, 30 frames a second, printed with the distance ("231,000 cells a second, 11.6% of the line"). A floor crossing a bar makes the bar a gate from then on, since the floor never goes down.
   - The baseline names the pin it was measured at and each fixture's SHA-256 over LF bytes, so a pin moved or a fixture edited without a new baseline fails by name: every change to the language is then measured on the benchmark before it lands here, which is what the item is for.
   - An empty baseline fails, as every owner-measured floor here does.

   *Alternatives:* the bar gated now, red until `KERNEL.20` or `ENGINE.6` land; the raw measurement as the floor, which the next clean run fails by noise; frames a second dropped as redundant, which the roadmap's line names.
7. **A deterministic floor beside the timed ones: the allocations a steady frame, exact, a ceiling that never goes up, held on every push.**
   - The runner counts the heap's allocations and reallocations in each frame through its own allocator: 4,470,532 and 1,129,229 for the soup, 4,848,318 and 1,129,229 for the gun, the same integers in every run.
   - No step calls the platform, so the count is a property of the code and not of the machine. The crate job is its first proof on Linux.
   - `check_frame_floors.ps1` runs a built runner in its check mode, four frames of each fixture and the gun's facts on its own Life. It holds every frame equal to the hand-written Life and each count under its ceiling, and notes a count fallen below its ceiling so the ceiling can be lowered.
   - It says SKIPPED where no runner is built, as on the ratchets job; the crate job builds the runner first, so the gate runs there. It times nothing.
   - The profile names allocation as the largest cost, and the count moves only with the code, where a timing on this machine moves 4 to 7% between sessions and 40% under the power policy. So a regression of the measured bottleneck fails on the push that makes it, where a timing finds it at the owner's next run.

   *Alternatives:* timings alone, regressions found late; or the language's own counts of reads and lookups, a feature of `vla-lang` and so Frazaro's to add, named for later.
8. **The profile recorded, and the order it gives.** This entry holds it; `CHARTER.md` §7's "Measurement to come" becomes the owner's baseline when it is pasted. `ENGINE.6`'s line gains a dated note: the naive evaluator's overheads come first, measured at 5.9 and 4.5 times with the frames unchanged, and every accelerator is measured from the cheaper base. `KERNEL.20`'s line in Frazaro gets the same, through the prompt of decision 9. *Alternative:* the profile left in this entry alone.
9. **What to ask of Frazaro, and in what order: one item now, the evaluator's hot path, `KERNEL.25` by its registry's next free number, minted there.**
   - What it asks is the seven measured fixes, each bit for bit: `find_sheet` without folding into new strings; a library name in upper case looked up as it stands; a reference's label shared; a single sheet's area inline; `SUM`, `AND` and `OR` folding as they walk, the walk uncollected; the machine's maps and the plan's places under an in-crate Fx hash; and a twin's read past both maps.
   - Measured: 2.9 times natively and 2.0 times in wasm, about 300 lines of change in the prototypes.
   - Its oracle is the language's own tests, Life's against its reference, and from here the runner's frames, `ENGINE.2`'s equality tests and the allocation ceilings, which fall from 71 a cell.
   - Named as the next ask, not this one: the twin's values kept as an array over its extent, the plane's `Raster`'s twin, and a range walked over it. That is a change of the language's store of values, with its memory and its kept state to design, measured at 5.9 and 4.5 times with the seven. It is `KERNEL.20`'s ground, where the vectorized shape needs the same array.
   - The prompt for the Frazaro session is given in the chat and kept nowhere on disk.

   *Alternatives:* everything into `KERNEL.20`, a quarter's item, the cheap half waiting on the vectorized half; nothing asked until this item closes; or one item per fix.
10. **The release profile stays at `opt-level = "s"`.** Level 3 is 3 to 12% faster here and the module 13% larger, against the 2.9 to 5.9 times the language's fixes measure. A finding for `ENGINE.6`, decided after the language's item, when the step is cheaper and a tenth of it is worth more. *Alternative:* level 3 now, the first baseline taken on it.
11. **Two slices, the instrument before the operation, as `ENGINE.2` was.** The first, now, over `c0686a9`: everything above and the owner's first baseline. The second, after Frazaro's commit: the pin moved in `Cargo.toml`, `Cargo.lock` and `check_engine_deps.ps1`'s two baseline lines in one commit, the instrument run again, the floors raised and the allocation ceilings lowered, the floors' first rise, and the item closed. Frazaro's push before this repository's, at the owner's word. *Alternative:* the item closed after the first slice and the pin moved by a commit of its own later, the floors' first rise then belonging to no item.
12. **The checks and the bookkeeping.**
    - `check_frame_floors.ps1`, the twelfth check. Its control fails, each for its own reason: an empty baseline; a row missing; a smoke run's few frames; a row under its floor; a floor lowered without a reason; the pin moved; a fixture's digest changed; the clock's spread over 10%; frames a second that do not equal cells a second over the formula cells; a fake runner whose frame differs; and one whose count passes its ceiling. A clean fake runner passes.
    - `check_cartridge.ps1` at three cartridges, the gun's row floor, and its rename mutant reading the count off the baseline as before.
    - `run_checks.ps1` at a floor of 12 with 12 controls; CI's crate job building the runner before the runner script.
    - `ROADMAP.md`'s line gains this scoping, the built marker after the first slice, and leaves for the ledger at the close. `README.md`'s rows for `cartridges/` and `tools/`; `engine/README.md` on the runner; `web/README.md` on `?frames=1`; the map's line; the memory.
    - The commits at the owner's word, by `-F`, staged by hunk: `CART.1: Life, the benchmark cartridge, with a glider gun, a native runner and the frame floors held to the owner's baseline`, and `CART.1: the pin moved to the evaluator's hot path, the frame floors raised by its measurement`.

    *Alternative:* the runner's check left out of CI, the allocation ceilings then held only by the owner's runs.

**The catch.** Each met once, or foreseen by reading.
- Windows throttles a background process about three seconds in, and headless Chrome with it; the measurement above is the trap and decision 5 the answer. A run that names itself throttled is to be run again, never pasted.
- `--dump-dom` writes the page at its load, so `?frames=1` runs synchronously at the load, about twenty seconds for both fixtures today; a person who opens it by hand in Chrome sees the tab frozen that long, which the page says before it starts.
- The gun's extra sheet costs it 6% against the soup until `find_sheet` stops folding, so the floors are per fixture and never one number for both.
- The fixtures' digests over LF bytes, the cartridges being CRLF on checkout and LF in the blob.
- A switch passed through `powershell -File` as a string does not bind (met in the scratch harness); a hashtable splat binds by name.
- A source restored with `Copy-Item` keeps its older write time, so Cargo keeps a mutant's build; the control here edits no Rust.
- Rust's empty `f64` sum is negative zero, and a sum that streams must start there to keep the bits, as the scratch `SUM` did.
- PowerShell 5.1 as every check met it: ASCII, `return ,$list`, `$onWindows`, the Write tool and never a heredoc, a commit message by `-F`.
- The tree is shared: the ledgers staged by hunk, HEAD plus this item's own; and a moved pin resolves in CI only once Frazaro's commit is on its remote.

**Oracle.** On the owner's machine under Windows PowerShell 5.1, then on both jobs:
- `cargo build --workspace`, `cargo fmt --all -- --check`, `cargo clippy --workspace --all-targets -- -D warnings` and `cargo test --workspace` green, the gun's test among the engine's fifteen.
- The runner over both fixtures, 31 frames each: every frame equal to its own Life, the gun's facts through generation 720, the allocation counts above, and the clock check quiet with the throttling opted out.
- `?frames=1` under headless Chrome: both fixtures, every frame equal to the page's reference.
- `check_frame_floors.ps1`'s control failing its mutants, each for its own reason; the check itself failing on the empty baseline until the owner's paste.
- `check_cartridge.ps1` at three cartridges and its control's mutants failing.
- `run_checks.ps1 -WithExtras` at 12 checks and 12 verifiers.
- The owner's run of `tools/bench_frames.ps1`, its block pasted, then `ALL GREEN`; the gun picked in the page and seen firing.
- In the second slice: Frazaro's item green by its own tests, the pin moved, the instrument run again, the floors raised; CI green at the owner's pushes, Frazaro's first.

**Size.** `~days`, as the roadmap has it (*prediction*): the gun about 130 lines; the runner about 450; the test 50; the page's mode about 180; the instrument about 280; the check about 380; the rest small. In Frazaro, beside it, the hot path's item, about 300 lines and its tests by the prototypes.

*Approved 2026-10-09, the same day, all twelve, in the owner's words: "All 12 recommendations are approved, and the Frazaro handoff message has been delivered to its session to scope and implement KERNEL.25 while you implement slice 1 of CART.1 as scoped." So the language's hot path is being built in Frazaro beside this slice, and the second slice waits on its commit.*

*The first slice built 2026-10-09, over `c0686a9`, awaiting the owner's run.*

What landed:
- `cartridges/gun/gun.vla`, 0BSD and CRLF, 88 rows. Gosper's glider gun, its 36 cells decoded by hand from the published RLE and checked equal to the scoping's generated set; the Palette as Life's; the rule Life's character for character after the first frame's branch.
- `engine/examples/frames.rs`, the runner, as decisions 2, 3, 5 and 7 have it. Each frame is one step with no budget, timed alone, and its plane held to a Life written by hand: the soup from life.vla's own arithmetic and the manifest's seed, or the Seed's rows read off the text. The gun's facts are held on that Life through generation 720. The clock is watched beside every frame. In the check mode, four frames each and the second frame's allocations counted. The rows are printed in the check's own syntax.
- `engine/src/cartridge.rs`, two tests: `the_gun_s_first_frame_is_its_seed_and_its_second_the_rule`, and `the_two_fixtures_differ_only_in_their_first_frame`, which holds both rules to one text after the first branch.
- `web/index.template.html`: the gun's place and its entry in the picker; `?frames=1` (decision 4); the oracle's `Driver` with a `raw` call returning a record's text as bytes, which `call` now decodes; and `lifeGeneration` and `lifeGenerationInto` beside `lifeReference`, which uses them.
- `tools/bench_frames.ps1`, the instrument.
- `tools/check_frame_floors.ps1`, the twelfth check. The allocation ceilings are written in it from the runner's count, a number of the code; the timed baseline and the floor history are left empty for the owner's run.
- `tools/check_cartridge.ps1` at three cartridges, the gun's floor 88; `tools/run_checks.ps1` at a floor of 12, the twelfth control; CI's crate job building the runner before the runner script.
- The two manifests' comments; `engine/src/lib.rs`'s doc.
- `SPEC.md`'s dated corrections to §6 rule 5 and §7.6.
- `CHARTER.md` §7's measurement in place of "Measurement to come".
- `ROADMAP.md`'s line and `ENGINE.6`'s dated note.
- `README.md`, `engine/README.md`, `web/README.md`, `CONTRIBUTING.md`, the map's line, the memory.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1 (*measurement*):
- `cargo build`, `fmt --check` and `clippy --all-targets -D warnings` clean; `cargo test --workspace` 16 passed in 3.3 s, the gun's two among them.
- The module 458,702 bytes as before, the example being no part of it; 0 imports and the eleven exports.
- The runner's check mode in 2.7 s: both fixtures four frames each, every frame equal to its Life, the gun's facts held 24 periods. The second frame makes 4,470,549 allocations and 1,129,229 reallocations for the soup and 4,848,335 and 1,129,229 for the gun, the scoping's integers exactly.
- Its measuring mode, opted out of the throttling, 31 frames each: the soup's steady median 279.9 to 292.2 ms across runs (215,000 to 225,000 cells a second), the gun's 293.6 to 304.6 (207,000 to 214,000). It was refused as a baseline with the throttling forced on (spreads of 27.9 and 49.1%) and when run as a plain background process on the scoping's first design (152 and 210%).
- The page's `?frames=1` under headless Chrome 154 in 19.6 s: every frame equal to the page's Life; the soup's steady median 270.1 to 271.0 ms (232,000 to 233,000 cells a second), the gun's 282.2 to 284.1 (222,000 to 223,000); the clock's spread 1.9 to 5.9%.
- The instrument end to end in about 45 s with `-NoBuild`: 40 browser processes opted out, its block printed with a floor line of 202,000, 192,000, 209,000 and 200,000 cells a second.
- `check_frame_floors.ps1`'s control in 1.2 s: the clean table and a reasoned lowering pass; ten mutants of the table fail, each for its own reason; of five fake runners the clean one passes and four fail. The check fails on one problem, the empty baseline, as every owner-measured floor here did until its first paste; its runner half passes.
- `check_cartridge.ps1` at three cartridges, every rule of section 7 holding for the gun, and its control's thirteen mutants failing.
- `check_host_loop.ps1` at both ratios: ten cases, every count and digest as before the refactor of its `Driver` and its reference Life.
- `check_web_offline.ps1`: three cartridge places.
- `check_spdx.ps1` over a scratch index holding the four new files: 54 resolved (0BSD 3, Apache-2.0 41, CC-BY-4.0 10), three cartridge headers, the shared index untouched.
- `run_checks.ps1 -WithExtras`: 12 checks, 11 passing and the frame floors failing by design; 12 verifiers passing.

Corrected in the build, against the scoping:
- *Counting and timing are kept apart.* An atomic count of every allocation slowed the scratch's frames by about a tenth (310 against 276 ms), so the runner counts only in its check mode, on the second frame after a fresh load. That is an exact number the same in every run, and its timed frames are never counted.
- *The clock check, rebuilt three times.* The scoping's form, the range of the hand-written Life's time over its median, refused a clean run: right after a step that churns the heap, a probe allocating a fresh plane a generation moved up to 15%. The probe now keeps two planes and steps one into the other, runs a generation untimed to warm them, and reads the best of three batches of twenty. The spread is the 10th to the 90th percentile over the median of the steady frames' readings, so a lone outlier is not a moved clock and a throttled tenth of the run is. And because a run throttled from start to finish is slow but steady, a drift from five readings taken at the process's start, before Windows throttles anything, joined it. Clean runs read 4.6 to 6.2% and within 3% of the start, under the 10% both must hold.
- *Windows' throttling is intermittent as well as late.* Of the build's four plain background runs of 31 frames, one was throttled from the eleventh frame and three were not, where the scoping's long background runs were throttled almost every time; which is why the check stands even when a run comes out clean.
- *Two engine tests where the scoping counted one.*

What remains is the owner's. Open `web/index.html` (built) and pick the glider gun above the panel's buttons: the gun fires a glider every thirty frames, south-east, about one every seventeen seconds at the host's pace today; the Seed sheet is in the sheet picker; Life and the test card run as before. Then `powershell -File tools\bench_frames.ps1`, which builds and measures in a couple of minutes, and paste its block over the baseline lines of `tools/check_frame_floors.ps1` and its floor line into `$floorHistory`; `run_checks.ps1 -WithExtras` must then be `ALL GREEN`. Then the commit at the owner's word, by `-F`, staged by hunk: `CART.1: Life, the benchmark cartridge, with a glider gun, a native runner and the frame floors held to the owner's baseline`. The second slice follows Frazaro's commit of the hot path.

*The owner's run, 2026-10-09.* The hand test, by a screenshot: the glider gun picked and running over the engine's module at frame 107, the gun at the top-left firing a stream of gliders south-east, the step's progress sentence at 31,192 of 62,964 cells, the Seed sheet among the tabs beside Screen, Palette, Clock, File and Input, six twins hidden; the Clock at frame 107, rate 30, seed 1. And `tools/bench_frames.ps1` run on the owner's machine, its block pasted into `tools/check_frame_floors.ps1` as the floors' first baseline (*measurement*, both halves opted out of the throttling, 41 browser processes):

| runner, fixture | frame p50 ms | min to max | cells a second | frames a second | clock spread, drift | floor |
|---|---|---|---|---|---|---|
| native, soup | 288.8 | 273.2 to 295.8 | 217,984 | 3.462 | 2.3%, 0.0% | 196,000 |
| native, gun | 303.2 | 296.0 to 310.8 | 207,634 | 3.298 | 1.8%, 0.0% | 186,000 |
| wasm, soup | 275.3 | 265.5 to 304.7 | 228,710 | 3.632 | 1.9%, -1.9% | 205,000 |
| wasm, gun | 286.6 | 276.3 to 308.4 | 219,731 | 3.490 | 1.9%, -1.9% | 197,000 |

Every frame of both runs equal to its Life, and the gun's facts held 24 periods. `run_checks.ps1 -WithExtras` on the owner's run: 12 checks and 12 verifiers passing. *Against the scoping's measurement*: the owner's medians, 288.8 ms natively and 275.3 in wasm, sit at the slow edge of the scoping's unthrottled 273 to 284 and 256 to 275, the native one 1.7% past it and well inside the floor's margin of 10%; the gun's frame costs 5.0% more than the soup's natively and 4.1% in wasm, against the scoping's 6% and 4 to 5%. `CHARTER.md` §7's measurement and `engine/README.md`'s are the owner's numbers now (decision 8).

*Found in the owner's run.* The block was copied from the terminal, whose line wrap dropped two spaces, one in the environment line (`throttlingopted`) and one in the last row (`ClockDrift= -1.9`). And the floor line went in as `$floorHistory = @{ ... }`, one hashtable in place of the array the header describes, because the instrument said "at the end of `$floorHistory`" of a history that held `@()`. The check read all three correctly, and nothing was wrong with a value. The two spaces were put back, and the entry was set inside `@( ... )` so that the second slice's entry is one line more; the check's comment says so. The instrument now also writes its block to `target/bench_frames.txt`, to copy from, and names the history's parentheses in its line for the floor. A run of it after the change wrote the thirteen lines there, its numbers within the baseline's noise and not pasted.

*Owner-tested 2026-10-09; committed 2026-10-10 at the owner's word, "Commit slice 1 of CART.1", with the README's row for `web/` counting the three cartridges and the frame floors' mode, found stale at the commit. Not pushed: the crate job resolves `c0686a9` from Frazaro's remote, so Frazaro's push comes first.*

*The second slice, scoped and built 2026-10-10, at the owner's word, given with the first slice's commit: "The Frazaro session just committed KERNEL.25 ..., so slice 2 of CART.1 is ready for scoping and implementation." Decision 11 had scoped it; Frazaro's handoff brought three findings for the instrument, which this scoping measured before deciding anything.*

**Substrate, verified.**

- *The pre-flight.* This tree at `da26122`, the first slice's commit, clean and four commits ahead of `origin/main`; `run_checks.ps1 -WithExtras` at 12 checks and 12 verifiers, `ALL GREEN`, just before that commit. Frazaro at `f5dc344` (`f5dc344aeae5e3efdad03b6a7dbf7b1783e313fe`), `KERNEL.25`'s commit over `4156b3c`, `KERNEL.3`'s close, twelve commits ahead of its `origin/main`; four files uncommitted there by other sessions, none under `vla-lang/`.
- *What the language's item changed*, by its session's handoff, read against the commit: the seven fixes of decision 9, each bit for bit. `find_sheet` compares by `eq_ignore_ascii_case`; a library name already in upper case is looked up as it stands; a reference's label is borrowed from the parse (`Arg<'e>`, a `Cow`); one area is held in place (`Areas`); `cells_in` is an iterator, `SUM`, `MIN`, `MAX`, `AND` and `OR` folding as they walk; the machine's maps and the plan's places hash with an Fx hash written in the crate (`src/fx.rs`); and a twin's read goes straight to the twin. One shape the scoping left open was decided there by measurement: the walkers take their fold as a type parameter, 98 ms a frame against 104 with `dyn`. None of the changed types is one the engine uses, the four calls keep their signatures, and `vla-lang` still has no dependency, so the lock stays at two packages.
- *What it measured*, with a read-only snapshot of this repository's runner, on one performance core at High priority, opted out of the throttling (*measurement*, Frazaro's):
  - a steady frame of the soup 98.9 to 100.5 ms (its base 280.0 to 283.0), about 630,000 cells a second;
  - the gun 97.3 to 100.1 ms (293.9 to 296.2);
  - the load 52 to 54 ms (166 to 169);
  - the ladder, each fix added to the ones before it, 282.3, 191.5, 177.5, 164.0, 159.2, 129.6, 102.3 and 101.0 ms, 2.80 times, where the scoping's prototypes made 2.91;
  - the check mode's counts, 251,957 allocations and 5 reallocations for the soup and 251,958 and 5 for the gun, 4.0 a cell, the four strict calls' argument lists.
- *Its three findings for the instrument.*
  - The processor's cores are of two kinds: logical processors 0, 1, 6 to 9, 18 and 19 are the performance cores, and the other twelve are efficiency cores. On an efficiency core the base steps in 371 to 382 ms and the seven fixes in 128, and an unpinned background run can land on either.
  - The runner's probe reads 0.175 ms a generation on a performance core and 0.216 on an efficiency one, not the profile's 0.101 to 0.105, because the probe changed, not the machine.
  - Pinned and at High priority, the probe's spread passed 10% in 7 of 24 runs, while the frames' medians held within 5%.
- *Named for later, `KERNEL.20`'s,* whose line in Frazaro's roadmap carries the dated note: the twin's values as an array over its extent, and a range walked over it, the scoping's 46.4 ms natively and 59.8 in wasm with the seven.

**Measured here, over the new pin.** *Measurement*, 2026-10-10, on the owner's machine, with this repository's runner and page.

- *The pin.* `Cargo.lock` moved by its one source line, fetched through git's `insteadOf` from the local clone, since `f5dc344` is not yet on Frazaro's remote. `cargo build`, `fmt --check` and `clippy --all-targets -D warnings` are clean. `cargo test` passes 16 in 1.4 s, against 3.3 s before. The module is 461,753 bytes, 3,051 more, with 0 imports and the eleven exports.
- *The check mode.* 251,957 allocations and 5 reallocations a frame for the soup, 251,958 and 5 for the gun: Frazaro's integers exactly. That is 4.0 a cell, where it was 71.0 and 77.0; the gun's extra sheet no longer costs a fold a reference.
- *The runner,* 31 frames of each fixture, opted out of the throttling, at Normal priority:
  - Unpinned, six runs: the soup's steady median 97.8 to 99.2 ms, about 640,000 cells a second, and the gun's 97.2 to 97.7. Every clock's spread was under 6.4% and within 4% of the start.
  - Pinned to the eight performance cores, six runs: 97.3 to 99.0 ms and 96.9 to 98.4, the same as unpinned.
  - Pinned to the twelve efficiency cores, two runs: 120.9 to 121.5 ms and 120.0 to 120.6, 23% slower. The probe read 0.211 ms with a spread of 1.0 to 1.4% and a drift under 1%, so both runs passed the clock check, whose first readings ran on the same kind of core.
  - On one performance core at High priority, Frazaro's setup, ten runs: 98.6 to 100.1 ms on logical processor 1, and 103.4 to 104.8 on logical processor 0, which Windows gives more of its own work. Every spread was 0.3 to 5.7%.

  Twenty-two runs on the performance cores, in those three ways and Frazaro's, none refused, and none of the runs since: Frazaro's 7 refusals in 24 did not reproduce here.
- *The probe's two readings.* On the performance cores the probe reads either 0.174 to 0.176 ms a generation or 0.184 to 0.187, 6% apart, and the frames move with it, because the performance cores run at two clocks. A run that moves between them reads a spread of 4 to 6%, which is what clean runs have read since the first slice, inside the 10%.
- *The page's `?frames=1`* under headless Chrome 154, with the four flags and every process opted out, five runs: the soup's steady median 136.9 to 141.0 ms (446,712 to 460,095 cells a second) and the gun's 131.6 to 137.3 (458,587 to 478,632). That is about twice as fast as the first baseline's 275.3 and 286.6; the scoping's prototype of the seven measured 134.8. The module now steps about 1.4 times slower than the native runner, where at `c0686a9` it was 5% faster. The scoping's reading holds: the allocation fixes buy less in the browser, whose allocator was already the cheaper.
- *The gun* costs what the soup costs, or a little less, its extra sheet now free.
- *The instrument end to end,* with `-NoBuild`, pinned (decision 13), in 19 to 20 s. Its block's rows were 615,978 and 612,593 cells a second natively and 446,712 and 458,587 in wasm, and its floor line 554,000, 551,000, 402,000 and 412,000; 25 browser processes were opted out and on the performance cores. Not pasted: the baseline is the owner's run.
- *Decision 10's question, asked again over the cheaper step.* `opt-level = 3` against `"s"`, interleaved, three runs each:
  - natively 91.6 to 92.0 ms against 99.6 to 100.7 for the soup, and 90.4 to 91.1 against 96.8 to 99.4 for the gun, about 8% faster;
  - in wasm 129.1 to 130.7 against 136.9 to 138.7, and 127.8 to 129.5 against 136.0 to 136.8, about 5.5% faster;
  - the module 520,383 bytes, 12.7% larger.

  At level 3 the hand-written Life runs slower, 0.337 ms a generation against 0.185, so the probe is a clock only within one build. The profile stays at `"s"`, as decision 10 has it: the finding goes to `ENGINE.6`'s line, which decides it.

**The second slice's decisions.** Decision 11 is the slice: the pin moved in `Cargo.toml`, `Cargo.lock` and `check_engine_deps.ps1`'s two baseline lines in one commit, the instrument run again, the floors raised, the allocation ceilings lowered, and the item closed. Frazaro's findings ask two more of the instrument. Each carries the build's recommendation; both were built at the owner's word, "ready for scoping and implementation", and are open to the owner's veto before the commit.

13. **Both halves run on the performance cores.**
    - The instrument reads the logical processors of the highest efficiency class off the system's CPU sets (`GetSystemCpuSetInformation`).
    - It sets its own affinity to them before it starts the runner and Chrome, and puts its own back after. Both inherit the affinity from their creation, and Chrome's children inherit it from Chrome.
    - It holds every Chrome process it finds on those cores, as it opts each out of the throttling.
    - The environment line names the cores and counts the processes on them. A machine of one kind of core is left unpinned and says so.
    - `check_frame_floors.ps1` holds that line: a pasted baseline must say both halves ran opted out of the throttling and on the performance cores, or on a machine of one kind of core. A block from an older instrument, or rows written by hand, then fail by name, since no other rule sees which core a run was on.

    Why: an efficiency core's frames are 23% slower and its runs pass the clock check. An unpinned baseline could be a floor of the scheduler, too low by a fifth, and a later run on the wrong core could fall under an honest floor. *Alternatives:* the core kind only named in the baseline, which tells a bad baseline apart but does not prevent one; one core pinned, Frazaro's setup, 4% slower on logical processor 0 and sharing that core with whatever Windows runs there; High priority, not measured to matter here.
14. **The probe as it stands:** twenty generations, the best of three batches, held to a spread and a drift of 10%. Frazaro's 7 refusals in 24 did not reproduce in 22 runs here, Frazaro's setup among them. The spread clean runs read is the cores' two clocks, which the frames share, and a refused run is run again, as decision 5 says. *Alternative:* a probe three times longer, a third of a frame on every frame, against a noise not seen here.

**What landed.**

- `Cargo.toml`: the pin at `f5dc344`, its comment naming `KERNEL.25`. `Cargo.lock`: the one source line. `tools/check_engine_deps.ps1`: the two baseline lines, and the header's sentence on where the pin has stood.
- `tools/bench_frames.ps1` (decision 13): a header paragraph on the second trap; the CPU sets read through `GetSystemCpuSetInformation`; the affinity inherited from the start and held through the poll; the cores in the environment line.
- `tools/check_frame_floors.ps1`:
  - the allocation ceilings lowered to 251,957 and 5 for the soup and 251,958 and 5 for the gun, under a dated comment;
  - the environment line held to the instrument's two guards (decision 13), with a third clean case in the control, a machine of one kind of core, and two mutants, a run not opted out and a run not on the performance cores;
  - the control's fake runners printing the ceilings as they stand, so that a lowered ceiling moves them with it, where the old fakes, written at the first counts, would have failed the clean case;
  - the paste's instruction naming the history's parentheses and the file the block is written to.
- `tools/run_checks.ps1`: the control's line, three clean cases and twelve mutants.
- `CHARTER.md` §7 and `engine/README.md`: the second measurement beside the first. `ROADMAP.md`: the line's second slice, and `ENGINE.6`'s dated note with the opt-level finding and the next ask, `KERNEL.20`'s. The map's line; the memory.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1 (*measurement*):
- `cargo build`, `fmt --check` and `clippy --all-targets -D warnings` clean over `f5dc344`; `cargo test --workspace` 16 passed.
- `check_engine_deps.ps1` at the new pin, and its control's seven mutants failing, their commit read off the new baseline.
- `check_frame_floors.ps1`: the runner's check mode with every frame equal, the gun's facts held 24 periods, and both counts exactly at their new ceilings. Two problems, by design, both the first baseline's: it was measured at `c0686a9` where the pin is `f5dc344`, and its environment line names no cores. The check fails until the owner's run is pasted. Its control: 3 clean cases, 12 table mutants and 5 fake runners, the fakes now at the new ceilings.
- The paste simulated on a scratch copy of the check: the instrument's block from `target/bench_frames.txt` over the baseline lines and its floor entry as the history's second line, the copy run against this tree. It reads clean: both guards found in the line, every floor risen over the first entry, every row over its floor, the runner's half as above.
- `check_host_loop.ps1` at both ratios over the new module, the engine case's Life equal to the page's at frames 1 and 11 as before, and its control's ten mutant pages failing.
- `run_checks.ps1 -WithExtras`: 12 checks, 11 passing and the frame floors failing by design; 12 verifiers passing.

What remains is the owner's.
1. `powershell -File tools\bench_frames.ps1`, which builds and measures in about a minute.
2. From `target\bench_frames.txt`, copy the block over the six baseline lines of `tools/check_frame_floors.ps1`, and its floor entry as the second line inside `$floorHistory = @( ... )`, with a comma after the first.
3. `run_checks.ps1 -WithExtras` must then be `ALL GREEN`.
4. Open `web/index.html` and pick Life, then the gun: both run as before, about twice as fast.
5. The commit at the owner's word, by `-F`, staged by hunk: `CART.1: the pin moved to the evaluator's hot path, the frame floors raised by its measurement`, with the item's close, the roadmap's line moved to the ledger.
6. The pushes at the owner's word, Frazaro's first, since the crate job resolves `f5dc344` from Frazaro's remote.

*The second slice built 2026-10-10 over `f5dc344`, awaiting the owner's run.*

*The owner's run, 2026-10-10.* `tools/bench_frames.ps1` on the owner's machine, both halves opted out of the throttling and on the performance cores, its block copied from `target/bench_frames.txt` into `tools/check_frame_floors.ps1` as the floors' second baseline (*measurement*):

| runner, fixture | frame p50 ms | min to max | cells a second | frames a second | clock spread, drift | floor |
|---|---|---|---|---|---|---|
| native, soup | 101.1 | 96.7 to 109.7 | 622,904 | 9.893 | 5.8%, +0.5% | 560,000 |
| native, gun | 96.6 | 94.5 to 102.2 | 651,551 | 10.348 | 5.8%, -3.9% | 586,000 |
| wasm, soup | 136.7 | 132.8 to 144.8 | 460,600 | 7.315 | 2.0%, -1.9% | 414,000 |
| wasm, gun | 135.0 | 130.5 to 137.6 | 466,400 | 7.407 | 2.0%, -1.9% | 419,000 |

Every frame of both runs was equal to its Life, and the gun's facts held 24 periods. `run_checks.ps1 -WithExtras` on the owner's run: 12 checks and 12 verifiers, `ALL GREEN`.

- *Against the first baseline:* 2.86 and 3.14 times as fast natively, 2.01 and 2.12 in wasm. Every floor rises, the floors' first rise: 196,000 to 560,000, 186,000 to 586,000, 205,000 to 414,000 and 197,000 to 419,000.
- *Against the build's measurement:* every median inside the build's ranges or within half a millisecond of them.
- *The gun* now steps faster than the soup, by 4.5% natively and 1.2% in wasm, where at `c0686a9` it was 5.0% and 4.1% slower: its extra sheet is free.
- *`CHARTER.md` §7, `engine/README.md` and the roadmap's lines* carry the owner's numbers now (decision 8).

*Found in the owner's run.*

- *The block went in whole and exact.* Copied from the file, it no longer passes through the terminal's line wrap.
- *The floor entry was pasted over the history's first entry instead of after it, and the check passed.* A history that can lose entries holds nothing: a slower run's entry pasted over the latest would lower a floor with no reason written, past decision 6's rule. The first entry was put back before the commit, no value touched, and the check's comment says so. Two fixes:
  - The instrument now prints the whole history, the check's entries as they stand and its own run's last, to paste over the check's history whole, which is the gesture the owner made.
  - `check_frame_floors.ps1` holds the history against the last commit's copy of itself, read with git. Every committed entry must still be there, in order, at the head of the history; SKIPPED without git or a commit.
  - Its control gains two clean cases, an entry added and a history unchanged, and two mutants, an entry pasted over and one edited in place.

  The new check, run over the paste as it was, fails it by name; over the history put back, it is clean. The instrument's new block, run after the change, printed the history's two entries and a third, not pasted.
- *The first baseline's rows,* which the paste replaced as it should, are kept in the check's comment beside the history's first entry.
- *The environment line's two counts differ by one:* 29 browser processes opted out and 30 on the performance cores. One process took the cores and not the opt-out. The page's clocks held, a spread of 2.0% and a drift of -1.9% across runs of about ten seconds, so it was not the process that steps.

`run_checks.ps1 -WithExtras` after the fixes: 12 checks and 12 verifiers, `ALL GREEN`.

*Owner-tested 2026-10-10; the commit awaits the owner's word, with the item's close.*

*Committed and closed 2026-10-10 at the owner's word, "Commit CART.1": the second slice with the item's close, the roadmap's line moved to the ledger's new cartridges section above. Not pushed. Frazaro was pushed first the same day, with its release 0.8.1, so the crate job resolves `f5dc344` from Frazaro's remote.*

*Noted 2026-10-10, after the close:* the pin moved on to the registry, `vla-lang = "=0.8.1"`, the source of `f5dc344` byte for byte, and `check_frame_floors.ps1` names that release as the measured commit's source, so the second baseline holds without being measured again (`ENGINE.1`'s second slice, the note on the registry pin).

*The frame timer, 2026-10-10, after `ENGINE.4`'s close, at the owner's word.*

The defect. Frazaro's `KERNEL.26`, then built and uncommitted, stepped the gun in about 20 µs, and the owner relayed its report: `tools/bench_frames.ps1` died with "Cannot convert value NaN to Int64".
- The page's `?frames=1` timed each frame alone with `performance.now()`, which Chrome gives a page that is not cross-origin isolated in steps of 0.1 ms. The gun's steady median read 0, and its row printed `CellsPerSecond = Infinity`.
- `Get-RoundedDown` made NaN of that row.
- Pasted, the row would have broken `check_frame_floors.ps1` too, an unquoted `Infinity` in a hashtable literal. Its units test would have passed it as NaN.

The owner was given two ways: time several frames at once, or refuse the figure and hold the floor as under the clock. The owner chose the first: "proceed with your recommended fix for the timer fix (time several frames at once)".

What landed:
- `web/index.template.html`'s instrument reads its clock's step first, five readings of the smallest change it sees. It times frames 2 to N alone, as before.
  - When their median reads under twenty steps (2 ms in Chrome), it times the steady frames again past them. They run in runs of consecutive steps, the run doubled from 2 until one reads twenty steps, `N - 1` runs in all. Each run is one span with no view or read inside it, and its frame is the span over the run.
  - Each run's last frame is held to the page's Life on the instance timed. The whole fixture is then stepped again on a second instance, untimed, every frame held, so every frame is still held.
  - The rows gain `Run`, the frames a run, and `Frames` counts the frames timed. Times under 1 ms print to 0.1 µs, and the page never prints a rate that is no time.
- `engine/examples/frames.rs`: the same printing, `Run = 1` (its `Instant` reads nanoseconds, so it times every frame alone), and a clock line that says "times faster" for a frame quicker than the clock's own generation.
- `tools/bench_frames.ps1` refuses a row whose rates are no finite number above 0, in words, and prints no block.
- `tools/check_frame_floors.ps1` refuses such a row by name, its control at fifteen mutants. `tools/run_checks.ps1`'s words.

The oracle, on the day on the owner's machine (*measurement*):
- `tools/bench_frames.ps1` at the pin, 0.8.1, every frame read alone as before: the wasm soup 137.5 ms a frame, the gun 142.1, the native 101.1 and 101.4. Its block was printed, its rows saying `Run = 1`. It was not pasted, a baseline being the owner's run.
- The same instrument in a scratch copy of the tree whose `vla-lang` was Frazaro's `b1f0b55` (`KERNEL.26`, committed by then) by a path, read and never written:
  - natively, the soup 4.9 ms a frame and the gun 0.0354 ms;
  - in the page, the soup 6.6 ms (152 frames a second) timed alone;
  - the gun's frames 2 to 31 read a median of 0 ms alone, so frames 94 to 2013 were timed in 30 runs of 64: a frame's median 0.0953 ms (0.0328 to 0.1297), 10,492 frames a second;
  - every frame from 1 to 2013 was held on the second instance.
- The page as committed before the fix, built over the same module, printed the owner's row, `FrameP50 = 0.0; ... CellsPerSecond = Infinity`. The new `bench_frames.ps1` refused it: "the row wasm gun says CellsPerSecond = Infinity; ...: a rate that is no finite number above 0 is no floor, so no block is printed".
- `check_frame_floors.ps1` clean, its control's fifteen mutants each failing, the new one "a frame read as 0 ms, its rates infinite". `check_host_loop.ps1` at both ratios and `check_web_offline.ps1` clean over the rebuilt page. `cargo fmt`, `clippy -D warnings` and `cargo test` (27) clean.
- `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`, in 201.2 s.

*Found:*
- Frame 2 alone cannot decide how a fixture is timed. The first try did, and over `KERNEL.26` the gun's second frame read over 2 ms where every later one read 0, so its steady median was 0 and the page's own guard refused it. After a load the language may compute a frame whole before it computes only the cells a change reaches (`KERNEL.20`'s fourth slice), so the median of frames 2 to N decides.
- A row timed in runs measures the frames it names: the wasm gun's 94 to 2013 where the native row's are 2 to 31. The gun's work a frame moves with its gliders and the border, and a faster engine's runs are longer and later, so each history entry is the procedure's own, and its rows say which frames.
- The clock's own probe reads the same 0.1 ms steps, so the two wasm rows print the same spread and drift; at about 5 ms a reading it holds its 10% guard.

*Committed 2026-10-10 at the owner's word, "Commit the timer fix", under `CART.1`'s ID. Not pushed. The baseline over `KERNEL.26` is the owner's own run of `tools/bench_frames.ps1` after the pin moves, which is the owner's call.*

*The native frame timer, 2026-10-12, at the owner's word: "Fix the floors' margin for microsecond frames". Found by `CART.2`'s fourth baseline (that item's entry, the owner's run).*

The defect. The native runner timed every frame alone, since `Instant` reads nanoseconds and the page's trap above was its clock's step.
- The gun's frames 2 to 31 read 15.2 µs at the third baseline and 20.4 at the fourth. That evening, nine runs of unchanged code read 17.6 to 26.9.
- The floors' margin is 10%, measured between sessions on frames of about 100 ms (`CART.1`'s scoping).
- So the fourth baseline lowered the native gun's floor at the owner's word, and the next was likely to meet the same refusal.

What was measured on the owner's machine, the runner opted out of the throttling and on the performance cores, the clock beside the frames reading 0.180 to 0.184 ms throughout (*measurement*):

| how the gun's frames were timed | launches | a frame's median, µs |
|---|---|---|
| frames 2 to 31 alone, the clock read before each, as committed | 44 | 22.3 to 47.5 |
| the same, four memory-heavy processes held on the efficiency cores | 6 | 36.8 to 43.6 |
| the same, pinned to one performance core | 6 | 15.1 to 19.0 |
| the same, the clock shortened to 4 generations, or to 2 (scratch builds) | 6 | 13.2 to 22.7 |
| the same, the clock read after the frame (a scratch build) | 3 | 16.2 to 37.1 |
| the same, the clock taken away (a scratch build) | 4 | 12.3 to 13.2 |
| runs of 128, frames 158 to 3997, the clock read before each run | 22 | 42.4 to 44.1 |
| the same, four memory-heavy processes held on the efficiency cores | 3 | 43.3 to 44.5 |
| the same, the clock shortened, read after or taken away (scratch builds) | 13 | 41.9 to 43.2 |
| the same, pinned to one performance core | 6 | 41.7 to 41.8 |
| runs of 256, frames 286 to 7965 | 3 | 42.6 to 42.9 |

- The clock is 60 generations of Life by hand, about 11 ms, read right before each frame. The frame after it is what scatters: the longer the clock, the slower and wider the frame. A thread free to move among the eight performance cores pays more than one held to a single core.
- A run amortizes the clock over its 128 frames. Its median stood between 41.7 and 44.5 µs whatever the clock's length or place, the load beside it, the cores or the run's length.
- Later frames cost more: the gliders meet the border at generation 740 and leave debris. Runs of 128 and of 256 read the same, so a run doubled on a quicker day measures the same number.

What landed:
- `engine/examples/frames.rs`:
  - A steady frame under 2 ms (the page's own line, twenty steps of Chrome's clock) is timed again past frames 2 to N, in runs of consecutive frames, the run doubled from 2 until it lasts 2 ms, `N - 1` runs.
  - Each run is one span with nothing viewed inside it, and each run's last frame is held to the reference. The fixture is then stepped again on a second instance, untimed, every frame held.
  - The rows say `Run` and the frames timed, as the page's do. The clock is read before each run.
  - On the owner's machine the native gun is timed in runs of 128 over frames 158 to 3997, the page's own frames. Life and Sand, about 3 and 12 ms a frame, are timed alone as before.
- `tools/bench_frames.ps1`:
  - The header's fourth trap.
  - A row timed in runs where the check's baseline timed it alone, or the other way about, measures other frames. So its floor is re-based on the run, the run less 10%, whatever the latest floor, and where that is lower the entry's reason says so. Every other row keeps the rule of 2026-10-11: the higher of the latest floor and the run less 10%.
  - A line naming each row re-based.
- `tools/check_frame_floors.ps1`'s header says the same. Its judgment is unchanged: a lowering with a reason written already passes.

The oracle, on the owner's machine (*measurement*):
- `cargo fmt --check` and `clippy --workspace --all-targets -D warnings` are clean.
- The runner's check mode is unchanged: 80 and 5, 80 and 5, 509 and 5.
- The runner over the three fixtures: every frame equal to the reference, the gun's 3,997 frames on the second instance among them.
- `tools/bench_frames.ps1 -NoBuild` end to end. *My run, and its block was not pasted:*
  - the native gun in runs of 128, 43.0 µs a frame, 1,465,770,406 cells a second;
  - its entry re-basing the native gun's floor to 1,310,000,000, the reason written;
  - the wasm rows as the fourth baseline's: Life 4.2 ms, the gun 61.7 µs, Sand 17.0 ms.
- That block spliced into a scratch copy of the check: the history kept, the re-based floor and its reason accepted. The one problem was native life, below.
- `check_frame_floors.ps1` and its control are clean, the tree's baseline untouched.

*Found, and left for the owner:* the clock before each frame slows Life's frames too, by an amount that changes between sessions.
- Without the clock, Life's frames read 2.7 to 2.8 ms (4 launches). With it they read 3.0 to 3.5 the same night, where the third baseline read 2.8 and the fourth 3.1.
- Shortened, the clock left Life at 2.7 to 3.1 ms; read after the frame instead, 3.0 to 3.5.
- Native life's floor is 20,200,000 cells a second, 3.12 ms a frame. My run of the instrument that night read 3.4 ms, and the instrument named the row NOT A BASELINE.
- A millisecond frame is not in this fix's reach. Where the clock is read is `CART.1`'s decision 5, which is the owner's to reopen; until then, a baseline refused on that row is run again at a quieter time, as the instrument says.

*Decision 5 reopened, 2026-10-12, at the owner's word, "proceed with implementing slice 3 of CART.2 as scoped". That scoping's decision 24 recommended it before the floors' fifth baseline, as a fix of its own under this item's ID.*

What changed, in both halves:
- `engine/examples/frames.rs`: the hand-written Life is read three times before a fixture's first frame and three times after its steady frames or runs, and never between two frames or two runs.
  - A row's `ClockMs` is the six readings' median, `ClockSpread` their range over that median, and `ClockDrift` the median against the runner's start.
  - So a run throttled while it runs reads slower after than before, and one throttled throughout reads slower than the start; either past 10% prints no rows, as before.
- The page's `?frames=1` the same, its rows the same fields.
- `bench_frames.ps1`, `check_frame_floors.ps1`, the two READMEs and the runner's header say so. The check's judgment is unchanged.

Natively, four launches of each runner alternated, over `vla-lang` 0.9.1 and slice 1's fixtures, opted out and on the performance cores (*measurement*, the medians of frames 2 to 31, ms):

| | the clock beside every frame | before and after |
|---|---|---|
| native life | 3.1 to 3.2 | 2.7 to 2.9 |
| native sand | 12.0 to 12.2 | 11.7 to 11.8 |
| native gun, runs of 128 | 0.0426 to 0.0434 | 0.0423 to 0.0428 |
| native gun, frames 2 to 31 alone | 0.0255 to 0.0408 | 0.0120 to 0.0132 |
| the clock's spread | 0.4 to 1.5% | 0.7 to 2.0% |

- Native life clears its floor of 3.12 ms again, where the clock beside its frames put it at 3.1 to 3.5.
- The gun's frames alone read as with no clock at all, 12 to 13 µs. Its row stays in runs, the page's frames, and the fifth baseline re-bases it (`CART.2`'s decision 24).

In the browser, thirteen launches of each page alternated, and three of a third page whose frames 2 to 31 each wait 15 ms with no work before they step (*measurement*, ms):

| | the clock beside every frame | before and after | a pause of 15 ms |
|---|---|---|---|
| wasm life | 4.3 to 4.6 | 4.0 to 4.3 | 4.2 to 4.4 |
| wasm sand | 16.5 to 17.1 | 17.2 to 18.3 | 16.8 to 17.2 |
| wasm gun, runs of 128 | 0.0609 to 0.0617 | 0.0602 to 0.0641 | 0.0609 to 0.0617 |

- Life gains, as it does natively.
- Sand loses about 3%. A pause with no work in it gives back the old numbers, so in the browser it is the time between frames, not the clock's work, that moves Sand's frame. A game's loop has that time, a frame every 33 ms at the rate of 30.
- Not pursued: a floor compares a row with itself, and Sand's rows are re-based at the fifth baseline on water's cartridge.

*Committed 2026-10-12 at the owner's word, "Commit, then walk CART.1's optimization route again over CART.2", with the frame timer above, under this item's ID. Not pushed. The commit after it holds `CART.2`'s third slice and the floors' fifth baseline, the owner's run over this code, which re-bases the native gun's floor and Sand's two rows and holds the rest.*

## `SPEC.3` — the page, version 3: the cartridge's source, and the pass between it and the rows

*Scoped 2026-10-10 at the owner's word, the day the item was filed from the owner's reading of `cartridges/life/life.vla`, whose forty-eight Palette rows "read as a little redundant and cluttery, which is almost the purpose of writing new macros anyway". The model the owner confirmed at the filing: authors write VLA with macros, a pass writes the cartridge as fully expanded rows, and the engine loads the rows and never expands. The scoping measured what the language's expander can say about a cartridge before deciding anything. It worked in a scratch crate over `vla-lang` 0.8.1 and a scratch copy of the engine, never in either repository's tree. Its first finding settles most of the rest: the expander as published already writes every one of today's rows from a source a third their length, byte for byte. The owner refined the model while the scoping ran, and the decisions take the refinement as their first premise.*

*The owner's refinement, 2026-10-10, given during the scoping:* "the expansion pass may run in the page as well as from a command line. The expander, and any later encoder, are pure functions that compile to wasm (an assembler from WebAssembly's text to its binary is one; a module can return the bytes it writes through its memory for the host to compile). So the scoping should hold that the pass is a separate act from load, its output the artifact a person can read, save and diff, and not where the pass physically runs; weigh the in-page pass beside the command-line tool when deciding which tool runs it."

**Substrate, verified.** Read on the day, by file and never by assumption.

- *The pre-flight.*
  - This tree at `357cee8`, level with `origin/main`. `ROADMAP.md` holds the previous session's two filings uncommitted, `REPO.4` and `SPEC.3` with the families' next free numbers. They await the owner's word and are never staged with this item.
  - `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`.
  - Frazaro at `3235bf9`, the release of 0.8.1, level with its remote. Nine files under `vla-lang/` are uncommitted there by its own sessions, `VLA.1`'s depth limit among them (below).
- *The page.* `SPEC.md` version 2 whole, 802 lines.
  - §7.1: one file. A folder of files "is the source layout a tool flattens into the one file, and is not what the engine loads; the tool is a later item's".
  - §7.2: every directive given, nothing defaulted.
  - §7.3: the rows the printers print, the range fill the one addition, one write per cell, the prelude's loud collision carried into cells.
  - §3.2: sixteen rows, and "the engine supplies none, since a default nobody wrote is a decision nobody can read"; the CGA's sixteen offered for a cartridge to copy.
  - §12: the folder-to-file tool not in version 2. Fragments' modules are "template macros ... that Frazaro expands into formula rows at build time".
  - Appendix A: Life's Palette "sixteen rows one each".
  - Appendix C: a patch as a source of module calls, one argument a line, opening on `(include "modular.vla")` before its manifest; C.2, "Frazaro expands the macros at build time".
- *The charter.*
  - §4's preface: the owner's condition that Frazaro own nothing a game needs.
  - Rule 1: the language crate holds the reader and the expander; "a game written in English is translated by Frazaro at build time and ships as VLA".
  - Rule 4: `AD-4`, the line of the clock.
  - Rule 7: macros "stay, at the viewport and at build time in Frazaro's expander".
  - §8: "Alonzo reads no VLA and computes no cell".
- *The language*, `vla-lang` 0.8.1, the registry's copy, `f5dc344`'s source.
  - `expand.rs`, the reference's macro system ported: template substitution with a rest parameter; the quasiquote bundle; `symbol`, which fuses atoms, a fused text that opens on a quote mark being a string by the reader's own marker.
  - Seventeen expand-time primitives: `car`, `cdr`, `cddr`, `cons`, `list`, `null?`, `eq?`, `equal?`, `quote-if`, `cond`, and `+expand` with six comparisons, over numeric literals only, through VBA's `Val` and `Str$`.
  - No gensym. A trampoline unwraps a macro's own `begin` in tail position and refuses a chain past 5,000 applications. Every macro-made form carries line 0.
  - `Expander::collect` defines every `defmacro` before anything expands.
  - `reader.rs`: a string escapes `\"` and `\\` and nothing else; "nothing here splices" an include.
  - `printer.rs`: `write_datum` writes a form flat; `write_pretty` breaks at 90 columns.
  - `machine/load.rs`: `read_rows` takes twelve row kinds and skips four by name. Anything else is `grid-row-unknown`, so a `begin` never loads.
  - The catalogue's language half holds the reference's include refusals: `vla-include-cannot-read`, `vla-include-too-deep` and `vla-include-must-stand-alone`.
- *Frazaro.*
  - Its door has no command that expands a VLA text into rows. `build` and `view` translate English, then walk the expanded VLA into a model that carries the `Frazaro` sheet of sentences (`core/src/api.rs`, `english_view`); `compile` writes VBA.
  - Its core recognizes a whole-line include and refuses it by name: "the core cannot read the file, so it refuses by name where the VBA would splice; a door that reads files splices first" (`core/src/emit/mod.rs`).
  - The reference's splice (`VLA.bas`, P.L7, `SpliceIncludes`): a line standing alone, raw text before the tokenizer, a relative name resolved against the workbook's folder, nesting capped at 16. A map carries each spliced line to its file's line, an included line's anchor being its include's line.
  - In flight, uncommitted in its tree: `VLA.1`, a depth limit of 64 lists at the reader and in the expander's walk, scoped there the same day.
- *This repository.*
  - `engine/src/cartridge.rs`'s load: the forms read; the manifest the first of them; `read_rows` over the rest; the device checks; the engine's own sheets; the machine.
  - `check_cartridge.ps1` holds every `.vla` under `cartridges/` as a cartridge, against a pinned count of three. `build_web.ps1` and `check_web_offline.ps1` take a cartridge as the file of its folder's name, and the page's build fails on a folder holding none.
  - `check_frame_floors.ps1` pins `life.vla`'s and `gun.vla`'s SHA-256 over LF bytes, `90B24FF2...` and `0BD138CB...`: today's files, confirmed on the day. It carries the registry pin by `$sameSource`.
  - The cartridges' text is read outside the engine in three places, each by the row: the engine's tests (the Screen's formula row by its opening, the gun's Seed rows a line each), the native runner (the Seed rows), and the page's frame oracle (the Seed rows and `(seed N)`).
  - `check_host_exports.ps1` pins the module's eleven exports. `web/fake.js`, the page's double, refuses a `(spec ...)` other than 1 or 2, with the engine's id and words of its own.
  - Every `.vla` is CRLF on checkout and LF in the blob.

**The measurements.** *Measurement*, 2026-10-10, on the owner's machine, the scratch crates built under this workspace's release profile. The timings were neither pinned nor opted out of the throttling: they are magnitudes, never floors.

- *A template macro writes the Palette from sixteen entries.* `palette` takes the entries as a rest parameter and hands them on whole through `quasiquote`. It recurses in tail position through `quote-if`, `null?`, `car` and `cdr`, and computes each row's address: `+expand` gives the row, and `symbol` fuses it after a quote mark, `(symbol "\"A" (+expand index 1))` making `"A1"`. Life's sixteen take 34 applications.
- *A template macro writes a pattern's cells.* `live` puts a 1 in each cell named: the gun's 36 Seed cells are nine calls, one a row of the pattern, in 45 applications.
- *A palette has a name.* `cga-palette`, a macro with no parameter, calls `palette` with §3.2's sixteen and writes the test card's Palette.
- *The rows are the same rows.* Each of the three cartridges was written as a source: the manifest as it stands, the Palette and the Seed as calls, every other row as it stands.
  - Expanded, each source's forms printed flat are byte for byte today's file's forms printed flat: 2,375, 3,117 and 4,339 bytes.
  - Loaded through the engine, every sheet's record equals today's.
  - Stepped, every plane is equal at frames 1 to 3: Life 23,683, 23,179 and 19,753 live cells; the gun 36, 39 and 43; the test card's window 40, 40 and 32 cells of colour 1.
- *What it cannot say.*
  - A picture written as a string, a character a cell, is refused: `car` of a string is `vla-car-expected-list`, and 0.8.1 has no primitive that splits a text.
  - A picture as a list of marks, its columns spelled by the caller, works: the gun's seed as nine rows of 36 marks expands to its 36 cells in 657 applications.
  - One `live` call of 6,000 cells is refused, `vla-macro-self-expansion-limit`, at 5,000 applications in a chain.
- *What it costs.*
  - Life's source with the library: 0.35 ms. The gun's 0.55, the test card's 0.45. Today's files merely read and printed: 0.09 to 0.19.
  - The load the pass feeds: 60 ms for Life and 56 for the gun natively.
  - A walk over a list copies the list at each step, so a macro's cost grows with the square of what it walks: the gun's picture of marks 4.0 ms, a full Screen's 64,000 marks 3.6 to 4.5 s.
  - The deepest list any of the three expansions makes is 3 deep, the library recursing in tail position.
- *The pass as one function of the engine crate.* A scratch copy of the engine took a `pass` module: the includes spliced as the reference splices them, every form expanded, each `begin` flattened, and the layout written. A native example over it built the three sources, each opening on `(include "../devices.vla")`. Each built cartridge's forms equal today's, and each loads.
- *The same pass in the page.* The scratch module put the pass behind a twelfth export, `alonzo_expand`.
  - Its size: 512,901 bytes against 461,817, +51,084 or 11.1%.
  - Imports still none, by `check_host_imports.ps1 -Path`; `check_host_exports.ps1` fails on the twelfth name, as it should.
  - Under headless Chrome 154 the export answers each source with the native pass's bytes exactly, in 0.3 to 0.5 ms. The module instantiates synchronously in 1.2 ms.

**The census.** Each cartridge as it stands, as a source over the library (the scratch sources carry only the header comment; a real source keeps today's comments), and as the pass writes it (*measurement*):

| cartridge | today: lines, lines of forms, rows after the manifest | as a source: lines, lines of forms, forms after the manifest | as built |
|---|---|---|---|
| Life | 103, 60, 51 (the Palette's 48) | 31, 30, 4 | 62, 60, 51 |
| the gun | 150, 97, 88 (the Palette's 48, the Seed's 36) | 41, 40, 14 | 99, 97, 88 |
| the test card | 160, 121, 112 (the Palette's 48) | 76, 75, 65 | 123, 121, 112 |
| the library | | 49, 41 | |

- The Palette is the clutter: 94% of Life's rows, 55% of the gun's, 43% of the test card's.
- The gun's Seed is the second.
- The test card's 41 Screen value rows are already ranges, each a kind of value of its own, and no form shortens them.
- A palette directive the loader took would cost the same lines as a macro call, sixteen entries one a line, and would change the loader as well.

**The work.** Two slices: the page, the pass and the command line first; the pass in the page second.

| File | What it is | Slice; decisions |
|---|---|---|
| `SPEC.md` | rewritten in place as version 3: §7.8, the source and the pass, new; §7.1, §7.2 and §7.4 amended; the load's refusal of a source in §4.2; the twelfth export in §4.6 and §8.1; §11's decisions 25 to 35; §12 (the folder-to-file tool in, the picture, the module and the encoder named); §13's oracles; Appendices A and C in the source's shape | 1; all |
| `CHARTER.md` | rule 1, rule 7, §8 and the frame paragraph, amended first | 1; 34 |
| `engine/src/pass.rs` | the pass: a source, its path and the texts it may include, to the cartridge's text; its tests, among them the golden over every source the folder holds | 1; 25 to 28 |
| `engine/examples/expand.rs` | the command line: each source's cartridge written beside it, then loaded as an act of its own; `--check` compares and writes nothing | 1; 26 |
| `engine/src/cartridge.rs`, `engine/data/messages.vla`, `web/fake.js` | `cart-source-unexpanded`; `(spec 3)` read by the engine and the double | 1; 31, 32 |
| `cartridges/console.vla` | the library: `palette`, `cga-palette`, `live` | 1; 27, 29 |
| `cartridges/<name>/<name>.source.vla` | the three sources, today's comments kept | 1; 28, 30 |
| `cartridges/<name>/<name>.vla` | the three cartridges, rebuilt, their rows unchanged | 1; 28, 30 |
| `tools/check_cartridge.ps1` | the folder rule; sources and libraries told apart and counted; each source's cartridge and banner; `(spec 3)`; a source refused; the control's mutants | 1; 28, 31, 32 |
| `tools/check_frame_floors.ps1` | `$sameRows`, and two control cases | 1; 30 |
| `engine/src/abi.rs`, `tools/check_host_exports.ps1` | `alonzo_expand`, the twelfth export; the baseline at twelve | 2; 26 |
| `web/host.js`, `web/index.template.html`, `tools/build_web.ps1`, `tools/check_web_offline.ps1` | the host's `expand`; the engine panel's Build, a press of its own before Load; the sources and the library embedded, their places held | 2; 26 |
| `tools/check_host_loop.ps1` | the loop oracle's eleventh case: the page's pass over every embedded source equal to its embedded cartridge; a mutant page | 2; 26 |
| `README.md`, `engine/README.md`, `web/README.md`, `CONTRIBUTING.md`, `ROADMAP.md`, this file, `Delta/CLAUDE.md`, the memory | the pages | 1 and 2; 35 |

**The decisions, the owner's.** Numbered after §11's last, as the page's own decisions are. Each with the sitting's recommendation and the alternative it declines.

25. **The pass is an act of its own between the source and the load; its output is the cartridge, the artifact a person reads, saves and diffs; where it runs is not what it is.** This is the owner's refinement made the page's rule.
    - The load takes rows and never expands. The pass takes a source and the texts it includes, writes rows, and never loads.
    - Every door runs the same pass. A door may run the load after it, as an act of its own, to say whether the cartridge loads.
    - Each door hands the person the artifact to read before anything loads it.

    *Alternatives:* expansion inside the load, which loses the artifact: a person loads text they never see as rows, a save writes rows the source never held, load is no longer the inverse of view, and every port of the engine carries an expander in its load. Or the pass defined as a build tool of the repository, the command line its one door, so that the page could not build what it loads.
26. **One pass and two doors: a pure function of the engine crate over the language's expander, run at the command line by an example and in the page by a twelfth export.**
    - `engine/src/pass.rs` holds the pass. `vla_lang::expand::Expander` does every act of expansion: template macros, the seventeen primitives, no gensym, no eval. The pass adds what a door adds: it splices the texts it is handed, flattens `begin`, and writes the cartridge's layout.
    - `engine/examples/expand.rs` is the command line: it reads the files and writes the cartridges. As an example of the crate it adds no package and no dependency, so `AD-5` and the lock of two packages stand, as they did for the runner.
    - `alonzo_expand`, the module's twelfth export, gives the page the same pass. Measured: +51,084 bytes, imports none, the native bytes exactly, 0.3 to 0.5 ms a source. The ABI stays 1, an export added and no signature changed, §4.6's own discipline.
    - `AD-4`'s line is the clock, and the pass carries none. Its golden half, the expansion, is the language's code already. Its other half is a door's (the splice, which Frazaro's core leaves to "a door that reads files") and the cartridge's own layout, which is this page's. The engine's manifest reader and device checks are pure functions of this repository on the same reading.
    - The command line comes first, since the repository's builds and the golden need it. The page's door is the second slice.

    *Alternatives:*
    - Frazaro's door, a new `frazaro expand`. That is a Frazaro item and a release before any cartridge builds, puts the core in every game's build, and runs against the owner's condition that Frazaro own nothing a game needs (`CHARTER.md` §4).
    - The general half, a text's includes spliced and its forms expanded into rows, in `vla-lang` as a Frazaro item. Not needed while 0.8.1's expander suffices; it is where that half moves the day a second door wants it.
    - The command line alone, so that the page cannot build.
    - A second module for the pass: a third package in the lock that `check_engine_deps.ps1` pins at two, and a second compile in the page.
27. **The source, the include and the library.**
    - A source is a VLA text:
      - its licence line first (§7.1);
      - any `(include "path")` line, standing alone, spliced before the reader;
      - template macros, every one defined before any form expands, as the language's first pass defines them;
      - the manifest, the first form that is no macro, copied as written and never expanded, so the source states what the cartridge is;
      - then rows and macro calls, in any mix.
    - An include follows the reference's P.L7. A relative path resolves against the source's own folder, as the reference resolves against the workbook's, nested includes included. Includes nest 16 deep at most, and a refusal uses the language's own ids.
    - Each door hands the pass the texts it may include: the command line reads them from disk, the page passes the libraries it embeds.
    - The repository's library is `cartridges/console.vla`, a file beside the cartridges' folders, 0BSD with them. It holds `palette` (the Palette's sixteen rows from sixteen entries, one argument a line with its comment), `cga-palette` (§3.2's table as a palette with a name), and `live` (a 1 in each cell named, a pattern's live cells).

    *Alternatives:* libraries named to the door, as Frazaro's door takes `--prelude`, which leaves the source silent about what it reads and gives two doors two conventions. Or the include in `vla-lang`, a Frazaro item; but the language reads no file, so a door splices first all the same, as Frazaro's core already says.
28. **The layout in the repository, and the golden.**
    - A cartridge stays the file of its folder's name, `cartridges/<name>/<name>.vla`. That is the rule `build_web.ps1` and `check_web_offline.ps1` keep already, and `check_cartridge.ps1` learns it in place of its glob of every `.vla`.
    - Its source, when it has one, is `cartridges/<name>/<name>.source.vla`, beside it. A library is a file of `cartridges/` itself. Both are committed.
    - The cartridge is the pass's output byte for byte:
      - line 1, the source's licence line;
      - line 2, a banner naming the source, with no digest in it, so that a comment edited in a source never moves its cartridge's bytes;
      - the manifest, one directive a line;
      - the rows, one a line;
      - CRLF, as every `.vla` in the working tree.
    - Held by `cargo test`: the pass over every source in the folder equals its cartridge, LF over LF, and each cartridge loads.
    - Held by `check_cartridge.ps1`, statically: every source has its cartridge, every banner names a source that is there, and the counts are pinned.
    - A cartridge with no source is hand-written, as every version 2 cartridge is, and stays a cartridge.

    *Alternatives:* the source alone committed and the cartridge a build artifact. Then the ratchets job, the page's build and the runner would each need the pass first, and a clone would hold nothing to load. Or a stamp of the source's digest in the banner: a stale cartridge caught without cargo, at the price of the cartridge's bytes, and the frame floors' digests, moving with every comment of its source.
29. **The data forms the loader takes: none in version 3. Every convenience is a macro of a library.**
    - The loader takes version 2's rows. Load stays the inverse of view with its one addition, the range fill, and a port of the engine implements no sugar.
    - The named palette is a macro, `cga-palette`, its sixteen stated in the library and never in the engine.
    - The table row is a macro. `table` is the reader's row for an Excel Table already, skipped by the load.
    - The picture row is not in this version (§12).
      - A template macro cannot read a string in 0.8.1 (measured).
      - A picture of marks works, but it is quadratic and spells its columns by hand.
      - Each route to a picture written as a string is a later version's, decided by the first cartridge that wants one: a row the loader takes; a built-in of the pass; or an expand-time primitive in the language, a Frazaro item with the VBA reference first (`SD-18`).
      - Until then a pattern is `live`, one call a row of it.

    *Alternatives:* the palette as a manifest directive the engine expands at load. Then the manifest holds a device's contents, every port carries the table, and a save drops the directive for forty-eight rows. Or the picture now, by any of its three routes.
30. **The fixtures are rebuilt from their sources with their rows unchanged, and a `$sameRows` map carries the frame floors' digests to the rebuilt bytes, as `$sameSource` carries the registry pin.**
    - Measured: each rebuilt cartridge's forms are today's byte for byte, and it loads and steps to today's grid.
    - `check_frame_floors.ps1` accepts a fixture whose SHA-256 the map names as the measured file's rows rebuilt, verified on the day the map is written.
    - Two control cases: a mapped digest passes, an unmapped one fails.
    - Thereafter a fixture's bytes move only with its rows, since the pass carries no comment and the banner no digest, and a moved row is measured again as before.

    *Alternatives:* the owner's run of `tools/bench_frames.ps1` again, its baseline lines pasted, the history untouched, each row clearing its floor by its margin. Or the fixtures kept hand-written, which leaves the reading that filed this item unanswered. Or a digest over the forms printed flat, which needs a PowerShell twin of the language's printer in the check.
31. **A source handed to the load is refused by name: `cart-source-unexpanded`.**
    - A file holding a `defmacro` or an `include` among its top-level forms is refused before its manifest is read, at the first such form's line.
    - The words say it is a source, which the pass expands into the rows a load takes.
    - It is the ninth id of the engine's catalogue, and `check_cartridge.ps1` holds the same rule.
    - The page's double reads the manifest alone and is not asked to know it.

    *Alternative:* the language's `grid-row-unknown`, or, for a source that opens on an include, the manifest's "is not the file's first form". Each names a form and not the act that was missed.
32. **`(spec 3)` is read by the engine, with nothing new to read.**
    - Version 3 adds no row and no directive, so a cartridge written to it is a version 2 cartridge.
    - The engine, the double and `check_cartridge.ps1` read 1 to 3, and `cart-spec-unsupported` says so.
    - The three fixtures keep `(spec 2)`, the version of the rows they use, so that their manifests and their measured rows stand as they are.

    *Alternatives:* the engine unchanged, refusing `(spec 3)` to an author who wrote the page's own number. Or the fixtures moved to `(spec 3)`, a row changed and the frame floors to measure again.
33. **What the horizon needs from this version, and no more.**
    - The pass is named as an act with an artifact.
    - The source is neutral to its target.
    - A cartridge carries data and never code.
    - The module and its reaches are named in §12, and the emitter stays unminted.
    - The owner's end goal, VLA macros expanding into WebAssembly's text, is one more target of the same act: the same source, includes and template macros.
      - A later version's encoder writes a module's text. It is the charter's third backend, the language's, a pure function compiled to wasm like the pass.
      - An assembler writes the module's bytes, and the host compiles them and nothing else does.
      - The text stands beside the bytes as the artifact a person reads, as the cartridge stands beside its source.
    - A cartridge that carries a module reaches six things by name, which that version decides:
      - `AD-5`: a second module's imports, and how a step would reach a function its module does not hold with an empty import section;
      - `AD-6`: a module's memory is state that is no cell;
      - `AD-7`: code enters by the load, as a formula does, and never by a step;
      - §6 and the replay: a module importing nothing is deterministic but for a NaN's payload bits, and the replay names its digest;
      - `SD-13`: instantiated with an empty import object;
      - and where the assembler runs.

    *Alternatives:* the emitter minted now in Frazaro's registers, an ID ahead of any cartridge that needs code. Or a `(module ...)` directive reserved now, a directive that does nothing.
34. **The charter amended first, in four places.**
    - Rule 7's "at build time in Frazaro's expander" reads "at build time in the language's expander, through the pass (`SPEC.md` §7.8)". The expander has been the language's since `PORT.12`.
    - Rule 1's sentence on a game written in English gains its twin: a cartridge written in VLA is expanded through the pass by the language's expander, so that a game's build needs the language and never the core.
    - §8's "Alonzo reads no VLA" gains its clause: the pass reads a source through the language's reader and expander and adds no parser of its own.
    - The frame paragraph names the page's third version.

    *Alternative:* the page alone changed, and the charter's rule 7 left naming Frazaro's expander.
35. **The slices, the checks and the bookkeeping.**
    - Slice 1, the page and the command line: the page rewritten as version 3; the charter's four amendments; the pass with its tests; the command line; the library; the three sources and their rebuilt cartridges; the ninth refusal and `(spec 3)`; `check_cartridge.ps1` and its control; `check_frame_floors.ps1`'s map and its two cases.
    - Slice 2, the page's door: the twelfth export and its baseline; the host's `expand`; the Build press; the sources and the library embedded and their places held; the loop oracle's eleventh case with its mutant page; the double's Build declined in words, since the double holds no expander. Slice 2's own scoping, at its build, measures `?frames=1` on the larger module beside the floors.
    - `run_checks.ps1` stays at 12 checks and 12 verifiers, the golden being `cargo test`'s.
    - The roadmap's line gains its scoping note and its built marker once the owner has committed the two filings it sits in.
    - The commits are made at the owner's word, by `-F`, staged by hunk: `SPEC.3: the page, version 3, a cartridge's source and the pass that expands it into the rows the engine loads`, and `SPEC.3: the pass in the page, the same bytes as the command line's, an act of its own before the load`.

    *Alternative:* one slice, or the page's door left to `ENGINE.5`, the File device, which picks and saves a person's files.

**The catch.** Each met once in the scratch work, or foreseen by reading.

- `check_cartridge.ps1` holds every `.vla` under `cartridges/` as a cartridge against a pinned count. A source or a library there fails it until it learns the folder rule the page's build already keeps.
- The frame floors pin the fixtures' bytes, and a rebuilt fixture's bytes differ from today's where its rows do not (comments, the manifest's layout): decision 30. The replay of §7.6 names a cartridge by its bytes' digest as well. A cartridge rebuilt with the same rows is the same cartridge to the engine and another to a replay; no replay exists yet, and the first, `CART.4`'s, is written over a built cartridge.
- A template walk over a list copies the list at each step, so a library macro walks dozens of items and never thousands. A chain stops at 5,000 applications. When the pin passes `VLA.1`, a list nested deeper than 64 is refused in the expander's walk as well: the library's macros recurse in tail position, where the trampoline keeps the output 3 deep (measured).
- An address is a string only by the reader's marker. `(symbol "\"A" n)` fuses a text that opens on a quote mark, which `symbol` makes a string; the library says so where it does it.
- Every `.vla` is CRLF on checkout and LF in the blob. The pass writes CRLF, as the language's own `expand_text` joins its lines, and every comparison is over LF.
- The cartridges' rows are read off their text in three places outside the engine, each by its line. The pass writes one row a line, spelled as today (measured).
- `2>&1` on a native command in Windows PowerShell 5.1 turns its standard error into error records and can stop a script. Met in the scratch harness; written around with `$ErrorActionPreference = 'Continue'`.
- The tree is shared, and `ROADMAP.md` holds the previous session's filings of `REPO.4` and `SPEC.3`, uncommitted. This item's notes on its own roadmap line wait for the owner's commit of the filings, so that no hunk carries both.
- The engine's tests already read the cartridges from outside the crate (`include_str!` of `../../cartridges/`), and the pass's golden reads the folder at run time. The crate's package will carry neither, which is `REPO.4`'s to settle, as `VLA.1` settles the language's.
- Slice 2 grows the module by a ninth (measured: 11.1%). The step's code is the same, but the module's bytes are not the module the frame floors measured, so slice 2 measures `?frames=1` on it beside the floors.

**Oracle.** On the owner's machine under Windows PowerShell 5.1, then on both jobs:

- `cargo build`, `fmt --check`, `clippy --all-targets -D warnings` and `cargo test --workspace`. The pass's tests and its golden: every cartridge with a source equal to the pass over it, LF over LF, and loading. The engine's tests over the rebuilt cartridges as before.
- `check_cartridge.ps1` clean, and its control's mutants failing.
- `check_frame_floors.ps1` clean over the rebuilt fixtures: the runner's frames equal, its counts at their ceilings, and its control with the two new cases.
- `check_host_loop.ps1` with Life at frames 1 and 11 at 23,683 and 14,482 live cells, as before.
- `run_checks.ps1 -WithExtras` at 12 checks and 12 verifiers, `ALL GREEN`.
- In slice 2: the module at twelve exports with none imported, and the loop oracle's new case at both ratios, the page's pass over every source equal to its cartridge byte for byte, its mutant page failing it.
- The owner's reading of the page, version 3, against the decisions. The owner's hand test: each source read beside its cartridge; each cartridge picked and run in the page as before; in slice 2, a source built in the page, read, and loaded by a press of its own.

**Size.** `~days` (*prediction*).
- Slice 1, about a day: the pass about 250 lines and its tests 200, the command line 120, the library 60, the three sources, the check 120 lines more, and the page's prose.
- Slice 2, about a day: the export 50, the host 40, the page 150, the oracle's case 80, the places 40.

*Scoped 2026-10-10; the eleven decisions await the owner.*

*Approved 2026-10-10, the same day, all eleven, in the owner's words: "Decisions 25 to 35 approved." The two filings were committed first and on their own, at the owner's word: `a41c86d` (`REPO.4`) and `f830a33` (`SPEC.3`). With the approval came a guiding principle, in the owner's words:* "the point isn't to solve the macro one built-in macro at a time, because that doesn't allow users/constributers/developers to define their own macros, nor does it generalize to the row/column/sheet level which is the fundamental object model of ALonzo. The 'palette', 'live', and 'cga-palette' are species of the larger problem, which is that hand-typing boilerplate is not conducive to rapid iteration, and rapid iteration is the psychological barrier between creative flow and task abandonment. ... it still stands as a guiding principle behind requiring the extensibility of VLA to collapse the cognitive burden of boilerplate down to a minium so that macro expansion can do the rote boring task of expanding human thought into WASM module code."

*What the build takes from it.*
- The pass knows no macro by name. Every macro is an author's `defmacro`, in a source or a library the source includes. The repository's library is a file like any other, written to be read, copied and outgrown. The page says so, and a test holds a source that defines its own macro.
- The principle's second half is where the measurements put the limit of the template expander. A macro reaches a row by arithmetic (`+expand`), but reaches a column and a sheet only by the names its caller lists, and cannot split a text. Its walk over a list is quadratic, and a chain stops at 5,000.
- So the generality the principle asks for, at the row, the column and the sheet, is an expand-time object model the language must give: an address from a row and a column number and back, a column's letters from its number, a text split into its characters, and arithmetic past addition. That is a change to `vla-lang`, so a Frazaro item, the VBA reference first (`SD-18`).
- The page names it in §12 as the next step of the pass, with the formula dialect beside it (an expression such as `(- note 12)` written as `=note-12`, `frazaro-core`'s emitter today), and the emitter to WebAssembly after both. This item builds the pass and asks nothing of the language. The prompt for the Frazaro session goes in the chat, at the owner's call.

*The first slice built 2026-10-10, over `vla-lang` 0.8.1, awaiting the owner's test.*

What landed:
- `CHARTER.md`, amended first (decision 34): rule 1's VLA road beside the English one; rule 7's macros "at build time in the language's expander, through the pass"; §8's clause that the pass reads a source through the language's reader and expander and adds no parser; the frame paragraph's third version.
- `SPEC.md`, rewritten in place as version 3:
  - the preamble;
  - §4.2's refusal of a source, and every version 1 and 2 cartridge a version 3 one;
  - §4.6's twelfth export and §8.1's count, both marked as the second slice's;
  - §4.7's ninth refusal;
  - §7.1's correction, the tool the pass;
  - §7.2's `(spec 3)`;
  - §7.3's rows the pass writes;
  - §7.4's VLA road;
  - §7.6's note that a replay names the cartridge and never its source;
  - §7.8, new, the source and the pass;
  - §9's `defmacro` row;
  - §10's two limits, includes 16 deep and 5,000 applications;
  - §11's decisions 25 to 35;
  - §12, the folder-to-file tool gone from what is not built, and the pass's next steps named;
  - §13's four oracles and the hand-offs;
  - §14's sources;
  - Appendix A's note;
  - Appendix C as a source, its library in the pass's row shape, C.2 to C.4 corrected.
- `engine/src/pass.rs`, the pass: the includes spliced as the reference splices them, the language's expander, the manifest copied, `begin` flattened, the layout written, CRLF, and its seven tests, the golden over the repository's folder among them.
- `engine/examples/expand.rs`, the command line: each source's cartridge written beside it and then loaded, as an act of its own; `--check` compares and writes nothing.
- `engine/src/cartridge.rs`: `(spec 3)` read, and `cart-source-unexpanded` before the manifest, with its test. `engine/data/messages.vla`: the ninth refusal, and `cart-spec-unsupported` naming three versions. `engine/src/lib.rs`: the module and its line.
- `cartridges/console.vla`, the library: `palette`, `cga-palette` and `live`, with the rules every macro there keeps.
- The three sources, `cartridges/<name>/<name>.source.vla`, today's comments kept, and the three cartridges rebuilt by the pass.
- `tools/check_cartridge.ps1`: the folder rule, three pins, the banner held both ways, the source refused, `(spec 3)`, and its control. `tools/check_frame_floors.ps1`: `$sameRows`, its two control cases, its header and closing line. `tools/run_checks.ps1`: the floor's dated line and the two controls' lines.
- `web/fake.js`, the double reading `(spec 3)`; `web/index.template.html`, the loop oracle's two later pages as `(spec 4)`.
- `README.md`, `engine/README.md`, `CONTRIBUTING.md`; the roadmap's line; the map's line; the memory.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1 (*measurement*):
- `cargo fmt --check` and `clippy --workspace --all-targets -D warnings` clean; `cargo test --workspace` 24 passed, 16 before and 8 new, the golden among them, every cartridge with a source equal to its expansion and loading.
- `cargo run --release --example expand`: 51, 88 and 112 rows, each cartridge loading; `--check` the same.
- The three rebuilt cartridges against today's files, by the scratch probe: their forms printed flat byte for byte today's; every sheet's record equal; every plane equal at frames 1 to 3.
- The module 462,379 bytes, 562 more for the ninth refusal's words and its check; 0 imports and the eleven exports; the pass in no export, so none of it in the module until the second slice.
- `check_frame_floors.ps1` clean, both fixtures carried by the table, the runner's frames equal and its allocations at the ceilings, 251,957 and 251,958: the measured grid, by the code's own count. Its control: five clean cases and fourteen mutants.
- `check_cartridge.ps1` clean: three cartridges, three sources, one library. Its control: two clean cases and twenty mutants, each failing for its own reason.
- `check_host_loop.ps1` at both ratios: the engine case's Life at 23,683 and 14,482 live cells at frames 1 and 11, as before; parity 11 of 11.
- `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`.

Corrected in the build, against the scoping:
- *A test held a layout, not a claim.* `abi.rs`'s test pinned "the rate's own line" as line 11, the hand-written file's; the rebuilt manifest puts `(rate 30)` on line 6. The test now finds the line in the text.
- *The page's oracle used `(spec 3)` as its later page*, in the refusals case and the parity case; both now say `(spec 4)`, and parity still answers 11 of 11.
- *Appendix C's library wrote the build walker's forms*, which the pass would hand to the load as rows it refuses. It is rewritten in the pass's row shape, and its block, cut out of the page, writes C.2's rows exactly.
- *Two limits measured beyond the scoping*: a parameter named like a row it writes replaces that row's head (`name` turned `(name name ...)` into `("beat" "beat" ...)`), and a nested expression cannot become a formula by template (`vla-symbol-arg-is-list`). Both are in §7.8, and the second in §12.
- *Windows PowerShell 5.1's `2>&1` on a native command* broke a comparison loop in the scratch harness, which then ran under bash.

What remains is the owner's.
1. Read `SPEC.md` §7.8 and a source beside its cartridge: `cartridges/life/life.source.vla` and `cartridges/life/life.vla`.
2. `cargo run --release --example expand -- --check`, and then, if you like, edit a palette entry in a source, expand, and see the cartridge move and `cargo test` hold it.
3. Open `web/index.html` (built) and run Life, the gun and the test card as before.
4. `run_checks.ps1 -WithExtras`, `ALL GREEN`.
5. The commit at the owner's word, by `-F`, staged by hunk: `SPEC.3: the page, version 3, a cartridge's source and the pass that expands it into the rows the engine loads`. Then the second slice, the pass in the page.

*The owner's test, 2026-10-10.*
- `cargo run --release --example expand -- --check` read `same` for the gun, Life and the test card, `(expand-done 3)`.
- The three cartridges ran in `web/index.html` as before.
- `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`.

*Owner-tested 2026-10-10; committed 2026-10-10 at the owner's word, "Commit, then scope and implement slice 2". Not pushed.*

*The second slice, scoped at its build and built 2026-10-10, over the first's commit `993cf8e`, awaiting the owner's test.*

The scoping at the build. Decisions 26 and 35 fixed what the slice holds: the twelfth export and its baseline, the host's `expand`, the Build press, the sources and the library in the page with their places held, the loop oracle's eleventh case with its mutant page, the double's build declined in words, and `?frames=1` measured on the larger module. These are the choices the build made inside them, each the owner's to overrule at the test.
- *The export's texts come in one buffer.* `alonzo_expand(source, path, texts)` takes the texts a source may include as one buffer: each path, then its text, with a NUL between each and the next, as Frazaro's translate takes its phrasebooks (*shelf*). An empty buffer is no text, and an unpaired last path is none either, so an include of it is refused by name. A text holding a NUL cannot be handed in, and no VLA text holds one. *Alternative:* a length before each text, which no door here needs.
- *The host asks for the export at the act, not at the attach.* The host's `attach` still demands the ten functions the loop calls, and `expand` asks for `alonzo_expand` when a person builds. So the double, which holds no expander, still drives the loop, and so does a module of the first eleven names. Over either, the build is declined in the host's words, marked as a refusal: "The module exports no alonzo_expand, so it holds no pass to build a cartridge from life.source.vla: the engine's module holds one (SPEC.md section 7.8)." *Alternatives:* the twelfth demanded at the attach, which refuses the loop's permanent test double; or a twelfth export in the double that answers a refusal under an id the catalogue does not hold.
- *Build is a press of its own, and its output is the artifact.* The engine panel's Build the cartridge sits beside Load the cartridge.
  - It hands the pass the source's box, the path the command line uses (`cartridges/<name>/<name>.source.vla`, so that the banner and the include's key are the same), and every library the page holds, as edited in the library's box.
  - It puts the cartridge the pass wrote in the cartridge's box and opens it to be read. It loads nothing and stops nothing (decision 25), so a cartridge running goes on running; Load the cartridge loads the box, as before.
  - The panel's details hold the source, then the cartridge, then the library, in the pass's order.
- *The page's texts.* Two families of places: `{{SOURCE:name}}`, a cartridge's source, and `{{LIBRARY:name}}`, a file of `cartridges/` itself, the folder rule `check_cartridge.ps1` keeps. `build_web.ps1` and `check_web_offline.ps1` hold each family both ways, and the texts are inlined LF, as every text the page holds.
- *The oracle's case, `pass`, the eleventh.*
  - Over the double, a build declined in words, marked as a refusal.
  - Over the module: every source the page holds, expanded by the host's `expand`, equal to its cartridge as the command line wrote it, CRLF, the page holding the file LF; an include not handed in refused at the include's own line, read off the record; the first load after the pass handle 1, so the pass took none; and a build between two frames leaving the loop running, the next frame stepped.
  - Its mutant page: a scratch copy of `cartridges/` whose library writes the Palette's names to column D. The case fails it by name at the first row the change moves: `life: the page's pass differs from cartridges/life/life.vla, the command line's, at line 16, "(cell \"Palette\" \"D1\" \"dead\")" where the file holds "(cell \"Palette\" \"C1\" \"dead\")"`.
- *`?frames=1` on the larger module* (*measurement*, 2026-10-10, the owner's machine, `tools/bench_frames.ps1`, both halves on the performance cores and opted out of the throttling). The module of the first slice (A, 462,379 bytes, built from `993cf8e`) and this slice's (B, 514,688) were run alternately, the page swapped and the native runner the same build each time, so that the native half is the clock between them:

| run | module | native soup, gun | wasm soup, gun | the clock, native and wasm |
|---|---|---|---|---|
| A0 | 462,379 | 618,854, 625,462 | 460,431, 462,800 | 0.185, 0.255 ms |
| B0 | 514,688 | 602,557, 603,274 | 452,328, 459,591 | 0.186, 0.260 ms |
| B1 | 514,688 | 608,536, 614,915 | 457,421, 462,800 | 0.185, 0.257 ms |
| A1 | 462,379 | 610,222, 617,757 | 455,436, 456,261 | 0.185, 0.255 ms |
| B2 | 514,688 | 604,718, 618,526 | 453,958, 458,087 | 0.186, 0.260 ms |
| A2 | 462,379 | 607,836, 615,950 | 436,644, 458,420 | 0.185, 0.260 ms |
| B3 | 514,688 | 607,805, 614,198 | 453,305, 454,286 | 0.185, 0.257 ms |
| A3 | 462,379 | 606,779, 609,455 | 436,190, 457,255 | 0.186, 0.260 ms |

  - The pass's 52,309 bytes cost the frame nothing measurable. The larger module's soup ran 452,328 to 457,421 cells a second against 436,190 to 460,431 for the smaller, and its gun 454,286 to 462,800 against 456,261 to 462,800.
  - The native half, the same binary every time, moved 2.7% between runs, and the page's own clock 2%: the spread is the machine's.
  - Every run clears the floors, 414,000 and 419,000 in wasm, by 5% at the least, and this slice's module by 8%. No floor moves, and no baseline is pasted: these are this session's numbers, never the owner's.

What landed:
- `engine/src/abi.rs`: `alonzo_expand`, the twelfth export, a door onto `crate::pass` that takes no handle, with the texts read from one buffer; the surface test runs the pass before Life's load, so that the load's handle 1 proves the pass took none, and holds Life's source with the library to Life's cartridge, CRLF, an include not handed in to `vla-include-cannot-read` at its line, a source not UTF-8 to status 2, and an unpaired path to no text.
- `tools/check_host_exports.ps1`: the list at twelve; its control nine modules, the ninth the first eleven names, which fails on the missing pass.
- `web/host.js`: `expand(source, path, files)`, its sentence, and its decline over a module without the export.
- `web/index.template.html`: the Build press; the source, the cartridge and the library in the panel's details; the sources and the library embedded; the raw driver reading the record's line; the oracle's `pass` case.
- `tools/build_web.ps1` and `tools/check_web_offline.ps1`: the two families of places, both ways; the offline control's mutants eleven, a stray source place and the library without its place.
- `tools/check_host_loop.ps1`: eleven cases, the `pass` floors, and the library mutant, applicable over the module.
- `web/fake.js`'s header: it doubles the eleven names the loop calls, and not the twelfth.
- `SPEC.md`: §4.6's paragraph and table, the buffer and the act; §7.8's door and oracle; §8.1's note; §13's line. `README.md`, `engine/README.md`, `web/README.md` and `CONTRIBUTING.md`. `tools/run_checks.ps1`: the dated line and three controls' lines.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1 (*measurement*):
- `cargo fmt --check` and `clippy --workspace --all-targets -D warnings` clean; `cargo test --workspace` 24 passed, the surface test holding the export.
- The module 514,688 bytes, 52,309 more than the first slice's (11.3%; the scoping's scratch measured 51,084 over a smaller base); 0 imports; the twelve exports, by `check_host_exports.ps1`, its control nine modules and a non-module.
- `check_web_offline.ps1` clean: 7 fixture places, 3 cartridge, 3 source and 1 library place. Its control: eleven mutants.
- `check_host_loop.ps1` at both ratios: the first ten cases' counts and digests as before, Life at 23,683 and 14,482 live cells, parity 11 of 11; `pass` declined 1 over the double, and over the module 3 sources, 3 the same as the command line's (251 rows after their manifests), the include refused at its line, handle 1 at the first load after the pass, the loop run on. Its control: eleven mutant pages, each failing for its own reason.
- The panel driven in headless Chrome by a probe script appended to a scratch copy of the page. Over the module, Build put Life's cartridge in its box, equal to the embedded file, and opened it; a library edited to column D built a cartridge with `(cell "Palette" "D1" "dead")`; a source including a file the page does not hold was refused, "include: cannot read '../nowhere.vla' (looked at 'cartridges/nowhere.vla') (line 13) [vla-include-cannot-read]", the box kept and the line red; and the gun picked, its source built to 88 rows. Over the double, every press declined in words, red, the box untouched.

Corrected in the build, against the scoping:
- *A failure's words quoted the line ends.* The case's first draft showed a differing line with its `\r`. It now shows the lines bare, and names a line that differs in its end alone.

What remains is the owner's.
1. Open `web/index.html` (built), then The source and the cartridge. Press Build the cartridge, read what it wrote, and press Load the cartridge. Change a palette entry in the source, or a macro in the library at the bottom, build and load again, and see the cartridge move.
2. If you like, `powershell -File tools\build_web.ps1 -NoWasm -Out <somewhere>.html` and press Build over the double, to read the decline.
3. `run_checks.ps1 -WithExtras`, `ALL GREEN`.
4. The commit at the owner's word, by `-F`, staged by hunk: `SPEC.3: the pass in the page, the same bytes as the command line's, an act of its own before the load`, with the item's close, the roadmap's line moved to the ledger.

*The owner's test, 2026-10-10.*
- Life built in the page and loaded: the log said "Built life.vla from life.source.vla by the pass: its manifest and 51 rows, and nothing loaded.", the cartridge's box held the built cartridge, and Life ran.
- Index 0's colour changed in the source, `("#000000" "dead")` to `("#FF00FF" "dead")`, then built and loaded: the cartridge's box held `(cell "Palette" "B1" "#FF00FF")`, and the plane's dead cells were drawn in it. The log counted three builds and five loads, each repeat in the line it first made.
- `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`.

*Owner-tested 2026-10-10; committed and closed 2026-10-10 at the owner's word, "Commit, then suggest next steps": the second slice with the item's close, the roadmap's line moved to the ledger's specification section above. Not pushed.*

*Noted 2026-10-10, decision 27's library, at the owner's word.* The owner proposed `cells` and `formulas`, each naming a sheet once over a run of value or formula rows; `on` beside them takes rows, or calls of a macro, each written without its sheet. The library took all three and, holding macros of no one device now, was renamed `cartridges/common.vla`, the owner's pick of three names: `shared` was set aside because a shared formula is already a formula filled over a range here, which `formulas` writes, and `mutual` reads as given both ways.
- *The macros.* Each walks its entries in tail position, as `live` does, so a call is for dozens of rows and never thousands. `on` puts its sheet second in each form it is given, so it takes a row or a call of any macro whose first argument is a sheet: the gun's nine `live` calls sit in one `(on "Seed" ...)`.
- *The sources.* The gun's Seed in that `on`. The test card's Camera in an `on`; its bars, its numbers that are no colour and its other kinds in three `cells` calls, one a comment block, each entry with what it is; its formulas in one `formulas`. The input card's Camera and Write sheet in an `on` each, the Tally's labels in `cells` and its counts in `formulas`, the Panel's lamps in `formulas`. A row that names its sheet once stays a row: Life's rule and the gun's, the test card's stripe, the input card's Screen and `Tally!B20`. Every cartridge's rows are unchanged byte for byte, so the frame floors' digests and the replay's golden stand.
- *Measured first,* in a scratch copy: the input card's Camera, Tally and Write sections and the gun's Seed, rewritten over the three macros, expanded by the pass to the committed cartridges byte for byte, `on` around `live` included.
- *The rest.* Each source's include line; the page's library place, `{{LIBRARY:common}}`, with its element, its path and the loop oracle's include line; the engine's tests; three checks, `check_cartridge.ps1`'s dated baseline, `check_web_offline.ps1`'s control and `check_host_loop.ps1`'s mutant K; `SPEC.md` §7.8, decision 27 and the fan-out; the README and the engine's and the page's. The entries above keep the name they were written with.
- *The oracle:* `expand --check` the same for all four; `cargo test` 27; the loop oracle's `pass` case at both ratios, 4 sources the same as the command line's, 387 rows; `run_checks.ps1 -WithExtras`, 12 checks and 12 verifiers, `ALL GREEN`.

## `ENGINE.3` — the Input and Clock devices: the host's seed, the Clock's three cells, the pointer in the Screen's own cells, an input card, and the replay

*Scoped 2026-10-10 at the owner's word, the day `SPEC.3` closed. The roadmap's line: "keys and the mouse, position and buttons, written into the Input sheet's cells each frame before the step; the frame number in the Clock sheet; nothing else is a clock". `ENGINE.1` built most of that line, as its own decision 5 said it would, and handed this item the remainder by name: the Clock's frame seen to advance on the real module and the gamepad kept named (the first slice's decision 5), and the seed, "with the rest of the Clock" (the second slice's decision 9). So the scoping measured the gap first, in scratch copies, and its findings are where the decisions start. The host chooses no seed. The Clock's cells take any value a person writes, and two of them to no effect. The pointer is written as the window's cell where the page says the Screen's. The page's own example of the dice is refused by its own layout. And nothing records or plays a replay, though the page calls the replay the oracle of every cartridge with input. The owner's standing brief governs every decision: determinism first, a replay is a proof and a floor is a number.*

**Substrate, verified.** Read on the day, by file and never by assumption; Frazaro's tree read and written nowhere.

- *The pre-flight.*
  - This tree clean at `10debee`, four commits ahead of `origin/main` (`357cee8`): `SPEC.3`'s two and the two filings before them, unpushed. CI's last run, `38041178863` on `357cee8`, green on both jobs.
  - `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`; the loop check's control, eleven mutant pages, in 43.5 s.
  - Frazaro clean at `494100a`, five ahead of its remote (`KERNEL.20`'s two slices, `VLA.1`, `VLA.2`'s filing, `VLA.3`), none released. This workspace pins `vla-lang` at `=0.8.1` and this item needs none of them.
- *What `ENGINE.1` built of the line* (`web/host.js`).
  - At every frame above rate 0, `_issueInputs` writes the eighteen Input rows of `_inputRows` in one write: forty button cells, players 1 to 4 through the key map `_readKeys` reads off the Keys sheet after each step; the pointer's column and row, its three buttons, the wheel's notches since the last frame; the last key as `key` and `code`, then cleared. A person's edits follow, each its own write. At rate 0 the sheet is never written.
  - `_pointerFrom` maps a mouse event to the canvas's cell, 1 to the width and the height, 0 off the canvas; `pointerAt` keeps it; `_inputRows` writes it as it stands.
  - `load` reads `(seed ...)` off `describe`, and under `(seed host)` says: "The cartridge asks the host for its seed, which this host does not choose yet (the Clock is ENGINE.3's): Clock!B3 stays empty until it does."
  - The loop oracle holds the Input rows over the double: `rate30` (keys held over frames, the pointer, its buttons, the wheel, a key no button binds, all folded into the double's history cell and compared by digest with the oracle's own model), `rate0` (no Input row written), `yield` and `memory`.
- *What the engine does* (`engine/src/cartridge.rs`).
  - `make_own_sheets`: the Clock's labels; `B1` 0, or a save's frame; `B2` the manifest's rate; `B3` the manifest's seed, or empty under `(seed host)` unless a save kept one. The File's two cells. The Input sheet with its eighteen labels and zeros when the cartridge holds none.
  - `step`: the next frame's number into `Clock!B1` through the machine's own write, before the machine steps, once a frame across yields.
  - `check_row`, the engine's checks of a written row: a cell outside a device's layout, a formula into a cell the host writes, a derived row into one. Nothing about a value.
  - The loop oracle's `engine` and `plane` cases already depend on `B1` advancing on the module: Life's soup is its first frame's (`Clock!$B$1=1`), and the test card's Camera is `1+MOD(Clock!B1,21)`.
- *The double* (`web/fake.js`): the Clock's three cells as value cells, `B3` holding 1 under `(seed host)`; its write refuses what `check_row` refuses, and the `parity` case holds eleven refusals equal.
- *The page*, `SPEC.md` version 3.
  - §3.3: the Input's eighteen rows, "the pointer's Screen column, 1 to the width; 0 when the pointer is off the Screen"; the rising edge `=AND(Input!B5=1, Input.last!B5=0)`; no Input at rate 0.
  - §3.4: the Keys sheet. §3.8: the Camera.
  - §3.5: the Clock's three cells and who writes each, the engine at each step and at load and the host's one write of the seed; the dice as Park and Miller's step "in a fourth cell the cartridge adds", `=MOD(Clock.last!B4*16807, 2147483647)`.
  - §3.10 and §12: the gamepad, a candidate device, not in this version; the key matrix not either.
  - §5, the frame's order; §6, rules 2 to 5.
  - §7.6, the replay: a header naming the spec, the cartridge's digest and the seed; `(frame n)` blocks of rows; the derived writes never logged; the golden a sheet at the end, as `view` prints it, compared whole.
  - §9: "a teacher opens the Clock and slows the rate to one frame a second to watch a rule think", which the charter's rule 6 repeats.
- *`CART.4`'s scoping.* "A replay: the Input sheet recorded frame by frame as a sheet of its own, played back by the loop in place of the live button", and `tools/check_cartridge_replays.ps1`, one line a cartridge. It was written the day before §7.6 gave the replay its form.

**The measurements.** *Measurement*, 2026-10-10, on the owner's machine: native probes in a scratch copy of this workspace over `vla-lang` 0.8.1 (two examples, `probe_clock.rs` and `probe_card.rs`, scratch only), and a scratch page over today's module, 514,688 bytes, under headless Google Chrome 154 and Microsoft Edge 154, opened from `file://`. The timings are magnitudes, never floors.

- *The seed.* A `(seed host)` cartridge loads with `Clock!B3` empty. `(cell "Clock" "B3" 12345)` written after the load answers `(written 1)`, and a formula `=Clock!B3` holds 12345 at frame 1. The host's write needs no new call.
- *The frame.* `(cell "Clock" "B1" 5)` written between two steps lands, a view shows 5, and the next step's first act writes 2 over it. A person's write is undone, and nothing says so.
- *The rate.* `Clock!B2` takes 1, 999, `"fast"`, 0, -3 and 2.5, each `(written 1)`. With 1 written, `=Clock!B1/Clock!B2` reads 3 at frame 3, while the host goes on stepping at the manifest's 30: the grid and the loop disagree.
- *The seed at a write.* `Clock!B3` takes 0, -5, 2147483647 and `"x"`. A seed of 0 sticks a Park and Miller cell at 0 for ever, which §3.5's range exists to prevent.
- *The page's dice.* §3.5's example, the dice in `Clock!B4`, is refused at load, `cart-device-cell-outside`: "Clock!B4 is outside the layout of the Clock sheet, Clock!A1:B3". A write there is refused the same way: the page's example breaks the page's layout rule. In a cartridge's own sheet, `=IF(Clock!B1=1,Clock!B3,MOD(State.last!B2*16807,2147483647))` from the seed 2147483646 was exact in doubles at all 40 frames, against integer arithmetic. `MOD(-1,9)` is 8, Excel's answer.
- *The rising edge.* `=AND(Input!B5=1,Input.last!B5=0)` over eight frames of writes (1, 1, 0, 1, 1, 0, 0, 1) was true at frames 1, 4 and 8 and false at the rest. A counter, `=State.last!B2+IF(AND(...),1,0)`, a cell reading its own twin, counted 3. The edge works through the twins as the page says; no test held it until now.
- *The pointer under a Camera.* The test card was loaded over the module in a scratch page and the pointer put on the canvas's top-left cell through the host's own `_pointerFrom`, for six frames. The window drawn before each frame moved from `A1:AN24` to `F1:AS24`, one column a frame, and the host wrote `Input!B11` 1 and `B12` 1 every frame. The host writes the window's cell; the Screen's cell under the pointer went from `A1` to `F1`. Without a Camera the two are the same; with one they part by the Camera's offset.
- *What a `file://` page gets.* In both browsers `isSecureContext` is true, `crypto.subtle` an object and `crypto.getRandomValues` a function. `crypto.subtle.digest` of `"abc"` answered FIPS 180-2's vector, `BA7816BF...`, as a promise, which the headless dump waited for under its virtual-time budget.
- *An input card, prototyped.* A plane of 40 by 24 on a Screen 48 wide:
  - the buttons of four players, each press counted on its rising edge in a `Tally` sheet laid out as the Input sheet is, one range row over `B1:E10`;
  - the mouse's clicks counted the same way; the wheel's notches summed, and the Camera panned by them, `=1+MOD(Tally!B16,9)`; the frames a key went down in, and the last key's code kept as text; the dice;
  - a Write row that records a click's frame as a value;
  - a `Panel` sheet of lamps, and the Screen one formula over `A1:AV24` that draws a cursor where `ROW()=Input!$B$12` and `COLUMN()=Input!$B$11`, and the Panel's cell elsewhere: the composite §3.1 names.

  Loaded natively in 1.5 ms, 1,294 formula cells, `(budget 30 1294 38820 2000000)`; a step 0.3 to 0.5 ms. Twelve frames of writes as the host makes them: right held over three frames counted 1 press; player 2's up 1; a click 1, and its frame written by the derived write, `(derived "Tally" "B20" 9)` landed; three notches 3, and the Camera at column 4; the dice at frame 12 equal to the integer arithmetic's. With the pointer written as the Screen's column 8, the window `D1:AQ24`'s cell at its column 5 held the cursor.

**The census.** What the line asks, against what stands:

| the device | what stands | what is open |
|---|---|---|
| Input: ten buttons, four players | written every frame through the Keys sheet; held by `rate30` over the double | nothing on the module reads them; no test holds the rising edge |
| Input: the pointer, its buttons, the wheel | written every frame | under a Camera the column and the row are the window's, not the Screen's |
| Input: `key` and `code` | written every frame, cleared after | nothing |
| Clock: the frame | the engine's, the step's first act | a person's write lands and is lost unseen |
| Clock: the rate | the manifest's, written at load | any value lands, and the loop never reads it: §9's teacher has no effect |
| Clock: the seed | the manifest's, written at load | `(seed host)` gets none; any value lands, a stuck dice among them |
| the replay | its form, §7.6 | no recorder, no player, no digest, no golden |
| the oracle on the module | Life and the test card read the Clock | no cartridge reads the Input |

**The work.** Two slices: the Clock and the pointer, with the card and its oracle; then the replay.

| File | What it is | Slice; decisions |
|---|---|---|
| `web/host.js` | the seed chosen and written at load; the rate read after each step; the pointer through the Camera; in slice 2 the recorder, the player and the digest | 1, 2; 1, 3, 4, 8 to 10 |
| `engine/src/cartridge.rs`, `engine/data/messages.vla` | `cart-write-clock`, the tenth refusal: the frame refused at a write, the rate and the seed checked; the tests | 1; 2 |
| `web/fake.js` | the same refusal, the double's twin | 1; 2 |
| `cartridges/console.vla` | the Keys sheet's macros beside the palette's | 1; 5 |
| `cartridges/inputcard/inputcard.source.vla`, `inputcard.vla` | the input card, a source over the library, and the cartridge the pass writes | 1; 5 |
| `web/index.template.html` | the card in the picker; the loop oracle's twelfth case, `input`; three more refusals in `parity`; the pointer in the model; in slice 2 the panel's replay and the thirteenth case, `replay` | 1, 2; 4 to 6, 10, 11 |
| `tools/check_host_loop.ps1` | twelve cases, then thirteen; the floors; the mutant pages | 1, 2; 6, 11 |
| `tools/check_cartridge.ps1` | four cartridges and four sources; in slice 2 the replay and its golden as kinds of the folder | 1, 2; 5, 11 |
| `tools/build_web.ps1`, `tools/check_web_offline.ps1` | in slice 2, the places of the replay and the golden | 2; 11 |
| `cartridges/inputcard/inputcard.replay.vla`, `inputcard.golden.vla` | the card's replay, and its `Tally` sheet at the end | 2; 11 |
| `SPEC.md` | dated corrections: §3.3, §3.5, §4.3, §4.7, §5, §6, §8.3; in slice 2, §7.6 | 1, 2; 12 |
| `REARVIEW.md` (this entry; a dated note on `CART.4`'s), `ROADMAP.md` (this line; a note on `CART.4`'s), `README.md`, `web/README.md`, `engine/README.md`, `Delta/CLAUDE.md`, the memory | the pages | 1, 2; 13 |

**The decisions, the owner's.** Each with the sitting's recommendation and the alternative it declines.

1. **The host's seed: chosen once at load from the browser's random source, and written into `Clock!B3` as the host's one write. No new call, and no new ABI.**
   - Under `(seed host)` the host takes a whole number from 1 to 2147483646 from `crypto.getRandomValues` (measured: present on a `file://` page in both browsers). It writes `(cell "Clock" "B3" <n>)` after the load, before frame 0 is drawn, and says so: "The cartridge asks the host for its seed: the host chose 1840027551, in Clock!B3; a replay records it."
   - At rate 0 the write steps nothing, being no person's edit.
   - A host option, `seed`, names the number in place of the random one, as `now` and `budget` are named for the oracle. The player of decision 10 passes the replay's.
   - Under `(seed <n>)` the host writes nothing: the manifest's number is the seed.
   - §3.5 and §6 rule 2 are corrected in place. The seed is the browser's random number and no time, so rule 2's exception goes: the host writes no time into any cell, ever.

   *Alternatives:* the wall clock, `Date.now()`, as the page words it, which gives two loads in one millisecond the same seed and keeps the one time a cell would ever hold. Or the seed as an argument of `alonzo_load`: ABI 2, every caller and the double changed, for what one write already does.
2. **The Clock's three cells at a write: the frame refused, the rate and the seed held to their ranges. One new refusal, `cart-write-clock`, the engine's tenth.**
   - `B1`, the frame: refused. The step writes it first, every frame, so a person's value there is lost unseen (measured), which `SD-30` forbids. The frame is the only clock, and the engine's alone.
   - `B2`, the rate: 0, or a whole number from 1 to 120, §10's range. Anything else is refused (measured: 999, `"fast"`, -3 and 2.5 land today).
   - `B3`, the seed: a whole number from 1 to 2147483646, §3.5's range. Anything else is refused (measured: 0, -5, 2147483647 and `"x"` land today, and 0 sticks the dice).
   - A range over the Clock is judged cell by cell. The labels in column A stay a person's to write. A formula and a derived row are refused there already.
   - The words, one template with a slot: "{target} {what} (SPEC.md section 3.5)", the slot being "is the frame, which the engine writes as the first act of every step: the frame is the only clock"; or "holds the rate, 0 or a whole number of frames a second from 1 to 120, and {value} is not one"; or "holds the seed, a whole number from 1 to 2147483646, so that a Park and Miller cell never sticks at 0, and {value} is not one".
   - The double refuses the same with the same id, and `parity` grows from eleven refusals to fourteen.

   *Alternatives:* every Clock cell refused at a write, the seed excepted before the first step, which refuses the teacher of decision 3 and amends the charter's rule 6 first. Or nothing refused, the frame's write left to vanish silently.
3. **The rate is the teacher's: the host reads `Clock!B2` after each step, and steps at it.**
   - The charter's rule 6 and §9 name the act: "a teacher opens the Clock and slows the rate to one frame a second to watch a rule think". Today the write lands and nothing follows (measured).
   - After each completed step the host reads the Clock with the other effects (§5, step 5): one small record, 0.006 to 0.018 ms (`ENGINE.2`'s measurement of the Clock's record). A rate that moved sets the loop's interval, and the host says so: "frame 61: the Clock's rate is now 1 frame a second (Clock!B2); the loop steps at it."
   - From a rate to 0, the loop stops ticking and steps on edits, and the Input sheet keeps what it last held. From 0 to a rate, the ticks resume with nothing owed: the accumulator and its last timestamp reset.
   - The write is a person's edit, so a replay logs it and plays it back, and a formula that reads the rate reads the loop's own.
   - A save loads at its manifest's rate, as today; the save's shape is `ENGINE.5`'s.

   *Alternative:* the rate fixed by the manifest and `B2` refused at a write, with the charter's rule 6 and §9 amended first to drop the teacher.
4. **The pointer in the Screen's own cells: the window's cell under it plus the Camera's offset, through the window the person sees.**
   - §3.3's "the pointer's Screen column" is read as the Screen sheet's column, so that `ROW()=Input!B12` and `COLUMN()=Input!B11` find the cell under the pointer wherever the Camera stands. It is then "the same in both modes", as §3.3 has it, a grid cartridge's pointer being a sheet's own cell.
   - Which Camera: the one the person sees, the Camera of the frame last drawn, which the host holds. The row names the cell the person pointed at, even in a frame whose formulas move the Camera.
   - "1 to the width" stays exact without a Camera; 0 when the pointer is off the canvas; a window cell past the Screen's extent is still a cell of the sheet, written as one.
   - `pointerAt(col, row)` stays the window's cell, the host's own state (`SD-23`), and `_inputRows` adds the Camera. The double's model in the oracle does the same arithmetic.
   - A dated correction of §3.3's rows 11 and 12.

   *Alternative:* the window's cell, as the host writes it today (measured), and every cartridge with a Camera adding `Camera.last!B2-1` itself. It must be `Camera.last` and not `Camera`, since the person saw the last frame's window: a trap set for every author.
5. **The input card: `cartridges/inputcard/`, the Input and Clock devices drawn, written as a source over the library.**
   - The prototype's shape, above: `(screen plane 40 24)` on a Screen 48 wide, `(rate 30)`, `(seed host)`, `(spec 3)`.
     - The lamps of ten buttons for four players, white while held, and otherwise a colour that moves on with each press; the three mouse buttons; the wheel, which pans the Camera; the frame's bits and the dice's; a cursor where the pointer is, coloured by the button held.
     - A `Tally` sheet laid out as the Input sheet is, so a reader finds each count beside the row it counts.
     - A Write row, so that slice 2's replay must re-derive a derived write.
   - The Keys sheet binds two players: player 1 to §3.4's defaults, player 2 to `I`, `K`, `J`, `L` and six more, so the forty-cell matrix is seen working beyond its first column.
   - The source calls the library's `cga-palette`, and two macros the library gains: one writes the Keys sheet's ten labels, one a player's column of ten codes, each called one argument a line with what it is.
   - The fourth cartridge: `check_cartridge.ps1` pins four cartridges, four sources and one library, and the card's rows as a floor. The template gains `{{CARTRIDGE:inputcard}}` and `{{SOURCE:inputcard}}`, and the picker its line.

   *Alternatives:* the oracle over Life and the test card alone, neither of which reads the Input. Or the card written by hand, against the owner's word that a cartridge is written as a source.
6. **The oracle on the module: the loop oracle's twelfth case, `input`, and three mutant pages.**
   - The host over the engine's module loads the card with the seed named, and is driven by manual ticks over a fixed log: keys held across frames; a press of player 2's; a key no button binds; the pointer placed through `_pointerFrom` on a canvas at a fixed scale; a click and a right click; three notches; an edit of `Clock!B1`, refused; the rate written to 10, then back to 30.
   - Every expectation is the page's own: the presses, clicks, notches and keys from the log; the dice by integer arithmetic from the seed; the frames the ticks run at each rate, by the accumulator's arithmetic; the Camera from the card's formula, and so the Screen cell under the pointer. They are read back through the records of `Tally` and `Clock` and the plane of the window, never by asking the host.
   - Its pins: the rising edge, a held button counted once; the four players' columns; the cursor under the pointer after the Camera moved; the seed in `Clock!B3` and in the dice; the frame's bits; the rate followed; `cart-write-clock` said and marked as a refusal.
   - Over the double, `rate30`'s model writes the pointer through the double's Camera, which its edits move, so its digest holds decision 4 there too.
   - `parity`: fourteen refusals, decision 2's three added.
   - The control's mutant pages, each proving it applied: L, the pointer written without the Camera, which `input` must fail at the cursor; M, the rate not read after a step, which `input` must fail at the frames counted; N, the seed not written, which `input` must fail at `Clock!B3`.

   *Alternative:* a native test alone, which holds the card's formulas and never the host's pointer, seed or rate.
7. **The replay is this item's second slice: the recorder and the player belong to the host.**
   - The host is the only writer of the inputs and the only one that knows which writes landed, so the log can be kept nowhere else. §6 rule 4 makes the replay the oracle of every cartridge with input, `CART.4` first, and this item's own card needs it.
   - `CART.4` then writes its cartridge and commits its replay and its golden, as the input card does here.

   *Alternative:* the recorder and the player `CART.4`'s, as its scoping had them, this item closing on its first slice and `CART.4` growing by a day.
8. **The replay's form: §7.6 made exact by dated notes.**
   - The header is `(replay "<name>" (spec <n>) (cartridge "<SHA-256>") (seed <n>))`.
     - The spec is the page's version the host implements, 3 today; a player reads 1 to 3.
     - The digest is SHA-256 over the cartridge's text with its line ends as LF, in upper-case hex: the bytes `check_frame_floors.ps1` already digests, so that a CRLF checkout and the page's text box name one file.
     - The seed is `Clock!B3` as it stood after the load.
   - A row is logged only when its write landed, a refusal being a function of the frame; a derived row never.
   - The Input rows are logged as the cells that changed, against the replay's own record of the sheet. A person's edit of the Input sheet makes that record unknown, so the next frame logs all forty-eight. Each person's edit is its row, in order, in its frame.
   - A frame with no row is not written, except the last, so that a replay names its length.
   - The player issues each frame's rows as one write, after the derived writes, then steps to done. A write grouped so lands as the live ones did, since every logged row landed (§4.3's correction).
   - `CART.4`'s "a sheet of its own" is superseded by §7.6's rows: a sheet of forty-eight cells a frame would carry no person's edit, and its loader would be a second reader of the same facts. A dated note on `CART.4`'s scoping and on its roadmap line says so.

   *Alternative:* all forty-eight Input rows logged every frame, about 2.3 MB a minute where the deltas of a pointer that never rests are about 120 KB (*derived*: 1,262 bytes a frame against 66, at 30 frames a second).
9. **The digest in the host: a synchronous SHA-256 in `web/host.js`.**
   - About forty lines, held in the oracle to FIPS 180-2's vectors and, through the committed replay's header, to PowerShell's SHA-256 of the same bytes in `check_cartridge.ps1`.
   - Synchronous, so the loop, the player and the oracle stay as they are; and present in every context a page opens in.

   *Alternatives:* `crypto.subtle`, measured present on `file://` in both browsers but answering with a promise, so the player and the loop oracle would wait on it; and absent from a page served over plain `http` from another machine, which is no secure context. Or a thirteenth export, a SHA-256 in Rust in the engine: the export check at thirteen, and the double, which would hold none, declining every replay.
10. **The recorder and the player, in the host and in the panel.**
    - The recorder keeps every load's log from frame 0, capped at 8 MiB of text, past which it stops and says so (*derived*: about an hour of a pointer that never rests). `host.replayText()` answers it.
    - `host.play(text)` refuses in words another cartridge's digest, a later spec, a derived row and frames out of order. It reloads the cartridge with the replay's seed, then plays at the cartridge's rate through the loop, the replay's rows in place of the live inputs, a person's edits refused while it plays; at its last frame it pauses and says so. `host.play(text, true)` plays every frame at once, for the oracle.
    - The recorder keeps recording while a replay plays, so a replay played and copied is the replay played: the round trip.
    - The panel: Copy the replay; a box to paste one into, with Play the replay, the card's own replay offered there; the frame line saying "replaying frame 41 of 180".

    *Alternative:* the player alone, replays written by hand, which leaves out the person's act: play, and keep what was played.
11. **The replay's files, and their checks: no new check.**
    - A cartridge's folder may hold its replay, `<name>.replay.vla`, and its golden, `<name>.golden.vla`: the record `view` prints of the sheet at the replay's end, after its licence line, compared whole. One replay a cartridge in this version.
    - `check_cartridge.ps1` holds them statically: the folder rule's two kinds; the header's name the folder's, its digest PowerShell's over the cartridge's LF bytes, its seed the manifest's when the manifest names one; the frames ascending from 1; every row a `cell` or `formula` row; the golden a record whose window row names its sheet.
    - `check_host_loop.ps1`'s thirteenth case, `replay`, holds them on the module, where §6 rule 5 says a replay golden is held. The card's committed replay plays to its golden byte for byte. The `input` case's live run, copied and played on a fresh host, ends in the same `Tally`, and over the double in the same digest. The player's own recording equals what it played. The refusals are said in words.
    - Three mutant pages, each failing `replay` by name: O, the recorder dropping a person's edits; P, the player skipping the derived writes; Q, the record of the Input sheet kept across a person's edit of it.
    - `run_checks.ps1` stays at 12 checks and 12 verifiers.

    *Alternative:* `CART.4`'s `tools/check_cartridge_replays.ps1`, a thirteenth check over the same folder and the same browser run.
12. **The page: dated corrections, and no `SPEC.4`. The gamepad stays named, and the charter is not amended.**
    - Every change makes the page exact where it is silent, or corrects it where the code is right: §3.3 (the pointer), §3.5 (the three cells at a write, the seed's source, the dice in a cartridge's own sheet), §4.3 and §4.7 (the tenth refusal), §5 step 5 (the rate read), §6 rule 2, §8.3 (the shim's duties), and in slice 2 §7.6 (decision 8). No device, row, directive or call is added.
    - The gamepad stays where §3.10 and §12 name it, a candidate that fills the Input's columns B to E; taking it is `SPEC.4`, at the owner's word.
    - The charter's rule 6 names the teacher, whom decision 3 makes real; nothing in the charter changes.

    *Alternatives:* `SPEC.4` filed for the Clock's rules and the replay's form; or the gamepad filed now.
13. **The slices, the checks and the bookkeeping.**
    - Slice 1, the Clock and the pointer: decisions 1 to 6, their corrections, and the card. `check_host_loop.ps1` at twelve cases and fourteen mutant pages.
    - Slice 2, the replay: decisions 7 to 11, §7.6's notes, and the card's replay and golden. `check_host_loop.ps1` at thirteen cases and seventeen mutant pages.
    - The roadmap's line gains this scoping now and its built marker after each slice, and leaves for the ledger at the second slice's commit, closing the item.
    - The commits, at the owner's word, by `-F`, staged by hunk: `ENGINE.3: the Clock's three cells held, the host's seed chosen at load, and the pointer in the Screen's own cells, with an input card`; then `ENGINE.3: the replay, every write a host makes from a load kept and played back to the same frames, with the input card's golden`.

    *Alternative:* one slice.

**The catch.** Each met once in the scratch work, or foreseen by reading.

- The engine writes the Clock's frame through the machine's own write, past `check_row`, so refusing `B1` to a person refuses nothing to the step. A test holds both.
- A rate moved to 0 leaves the Input sheet as it last stood, a button held then held still, since rate 0 writes no Input (§3.3); the sentence says so. A rate moved from 0 must reset the loop's last timestamp, or the first tick owes a quarter of a second.
- The pointer's Camera is the one the person saw: the host's `camera`, set when the frame was drawn, never the Camera sheet as the next step leaves it.
- A browser repeats `keydown` while a key is held, so `key` and `code` name a held key again on each repeat, as typing does, while the buttons stay put. Kept, and said in §3.3's correction.
- The double puts 1 in `Clock!B3` under `(seed host)`, its own constant, which the host's write now replaces.
- The card is small, 1,294 formula cells and a step of about 0.3 ms natively, so the `input` case adds little to the oracle's run.
- The library gains macros. No existing cartridge calls them, so Life's, the gun's and the test card's rows and digests do not move, and the frame floors stand; mutant page K's anchor, the palette's row, stays in the library once.
- A text box holds a cartridge with LF ends, and the working tree holds it with CRLF: the digest is over LF, or the page and a check would name two files.
- The engine's text and the double's for the new refusal are twins in id and not in words, as `parity` holds them.
- PowerShell 5.1 as every check met it: ASCII, `return ,$list`, `$onWindows`, `2>&1` on a native command, the Write tool and never a heredoc, a commit message by `-F`.
- The tree is shared: this file, the roadmap and the page are staged by hunk, HEAD plus this item's own.

**Oracle.** On the owner's machine under Windows PowerShell 5.1, then on both jobs.

- `cargo fmt --check`, `clippy --workspace --all-targets -D warnings` and `cargo test --workspace`: the engine's tests of `cart-write-clock` (the frame refused, a rate and a seed at their edges, the step's own write untouched); the card loading and stepping to its counts; the pass's golden over the card's source.
- `check_cartridge.ps1`: four cartridges, four sources, one library, its twenty mutants still failing; in slice 2 the replay's kinds, with mutants of their own.
- `check_host_loop.ps1` at both ratios: twelve cases, then thirteen; `parity` at 14; the mutant pages, fourteen, then seventeen, each failing for its own reason.
- `run_checks.ps1 -WithExtras` at 12 checks and 12 verifiers, `ALL GREEN`.
- The owner's hand test.
  - Slice 1: the input card picked; keys pressed and their lamps lit and moved on; player 2 on `I`, `K`, `J` and `L`; a click and the cursor's colour; the wheel panning the card, the cursor still under the pointer; the seed said in the log; `(cell "Clock" "B2" 1)` and the card stepping once a second, then `(cell "Clock" "B2" 30)`; `(cell "Clock" "B1" 5)` refused, in red.
  - Slice 2: play the card, Copy the replay, reload, paste it, Play the replay, and watch the same run; then the card's own replay, to its end.

**Size.** `~days` (*prediction*).
- Slice 1, about a day: the host about 60 lines, the engine about 60 and its tests 120, the double 30, the card's source about 110 and the library's macros 30, the oracle's case about 250, the checks about 80, and the page's prose.
- Slice 2, about a day: the recorder, the player and the digest about 250 lines, the panel 80, the oracle's case about 200, the checks about 150, the two files, and §7.6.

*Scoped 2026-10-10; the thirteen decisions await the owner.*

*Approved 2026-10-10, the same day, all thirteen, in the owner's words: "Recommendaitons approved; proceed." The first slice is built first, decisions 1 to 6; the second waits for its test.*

*The first slice built 2026-10-10, over `10debee` and `vla-lang` 0.8.1, awaiting the owner's test.*

What landed:
- `engine/src/cartridge.rs`: `check_clock`, called from `check_row` for a `cell` row into the Clock, each cell of the range judged from the frame: the frame refused, the rate held to 0 or a whole number from 1 to 120, the seed to a whole number from 1 to 2147483646, each spelled in digits alone as the manifest's reader reads them. The step's own write of the frame goes through the machine and never through the check. Two tests: `the_clock_s_cells_are_held_at_a_write` (twelve refused writes, a range among them and a write of two rows whose second is refused, which leaves the first unwritten; the rate at 0, 1 and 120 and the seed at both its ends landing; a label; the step writing the frame after) and `the_input_card_counts_what_it_is_given` (twelve frames of Input rows as the host writes them, the Write row carried as the host carries it, every count, the dice, the Camera, the cursor, a lamp and the frame's bits held to the log, and no formula written, `AD-7`).
- `engine/data/messages.vla`: the tenth refusal, `cart-write-clock`, "{target} {what} (SPEC.md section 3.5)."
- `web/host.js`: `_seed`, the seed chosen at a `(seed host)` load from `crypto.getRandomValues` (or the `seed` option) and written into `Clock!B3` before frame 0 is drawn, with its sentence; `_readClock`, the rate read after each step with the other effects and followed, the tick loop taking its interval from the rate the last frame left and stopping when a frame sets it to 0, a tick at rate 0 stepping the edits a rate's last frame left waiting; the pointer written as the Screen's own cell through the Camera of the frame last drawn; the `frame` event carrying the rate; the header and the options' comment.
- `web/fake.js`: `clockRefusal`, the same judgment under the same id in the engine's order, in the double's words.
- `cartridges/console.vla`: `button-labels` (the ten labels in a sheet's column A) and `keys` with `keys-from` (a player's column of the Keys sheet, the column's letter fused before the row).
- `cartridges/inputcard/inputcard.source.vla` and the cartridge the pass writes, `inputcard.vla`: 136 rows, 1,517 cells, 1,411 of them formula cells; the source calls `cga-palette`, `button-labels` twice and `keys` twice, one argument a line.
- `web/index.template.html`: the card in the picker and its two places; the model writing the pointer through the double's Camera and `rate30` pinning it by name (the window's column 40 and row 25 under the Camera at row 7 and column 3 written as column 42 and row 31); `parity` at fourteen; the twelfth case, `input`; the panel following the rate.
- `tools/check_host_loop.ps1`: twelve cases, the floors (`rate30`'s pointer, `parity` 14, `pass` 4 and 4, `input`'s sixteen counts), three mutant pages, L, M and N. `tools/check_cartridge.ps1`: four cartridges and four sources, the card's floor. `tools/run_checks.ps1`: the dated line and the control's words.
- `SPEC.md`'s dated corrections: §3.3 (the pointer's rows and the paragraph after them), §3.5 (the table, the dice in a cartridge's own sheet, and a paragraph of the three cells), §4.3, §4.7 (the tenth id), §5 step 5, §6 rule 2, §8.3. `README.md`, `web/README.md`, `engine/README.md`.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1 (*measurement*):
- `cargo fmt --check` and `clippy --workspace --all-targets -D warnings` clean; `cargo test --workspace` 26 passed, 24 before and the two new; the pass's golden over four sources among them.
- `cargo run --release --example expand`: the card's 136 rows, loading; Life's, the gun's and the test card's cartridges written again byte for byte as they stood.
- The module 516,175 bytes, 1,487 more for the Clock's check and its words; 0 imports, the twelve exports.
- `check_host_loop.ps1` at both ratios, twelve cases: `input` over the module 26 frames, each window equal to the card computed by hand, the seed named, 4 presses (1 of player 2's), 2 clicks, 3 notches, 4 key frames and the last code, the dice, the click's frame 11 carried by the derived write, the pointer's last column 8, the cursor seen in 16 frames, a button held in 6, the rate followed 3 ways, `cart-write-clock` said once and marked; `parity` 14 of 14; `pass` 4 sources the same, 387 rows; `rate30` with the pointer pinned. The first eleven cases' other counts are as before but for two things, each measured against HEAD's page built in a scratch folder. The detachments rose, `rate30` 124, `rate0` 13, `yield` 99 and `memory` 712, where HEAD's page counted 111, 12, 96 and 642: the Clock's record the host now views after each frame. And `rate30`'s digest moved, 7a8f8c44 where HEAD's was 2bdc8ef3, since the double's history folds the pointer the host now writes through the double's Camera; mutant L, the pointer without the Camera, gives HEAD's digest again.
- Its control, fourteen mutant pages in 54.6 s, each failing for its own reason. L, the pointer without the Camera, failed `rate30` ("written as column 40 and row 25, not the Screen's column 42 and row 31") and `input` at frame 16, the cursor drawn at the window's second column where the card by hand has it at the fifth. M, the rate never read, failed `input` when a tick of 34 ms ran frame 19 at the rate of 10. N, the seed never written, failed `input` at `Clock!B3`, empty, and at the seed's bits from frame 1.
- `check_cartridge.ps1`: four cartridges, four sources, one library; its control's twenty mutants failing. `check_frame_floors.ps1` with the runner rebuilt over this slice: every frame equal, the allocations 251,957 and 251,958, as before.
- `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`.
- The plain page's panel, probed headless: the card picked and loaded, its budget said (1,411 formula cells a frame, 42,330 a second), the host's seed chosen and named, 2058400448 on that run, and frame 0 drawn at 17 device pixels a cell with no notice of an empty Camera.

Corrected in the build, against the scoping:
- *The card's Camera holds a value row*, `(value "Camera" "B2" 1)`, a save's spelling as the test card's, or every load says the Camera's column is empty before the first step.
- *A PowerShell trap:* a hashtable holding a key named `keys` answers `.Keys` with that key's value, so the floor table's loop walked the number 4. The counter is `typed`.
- *The seed's sentence* said "a replay records it", which is the second slice's to make true; it names the seed and the cell alone.
- *The case drives the host through its listeners*, `keydown`, `keyup`, `mousemove` and `wheel` dispatched to the canvas, where the scoping named `_pointerFrom` alone: every Input row it checks passed through the host's own event path.
- *`rate30` pins the pointer by name*, where the scoping had its digest alone hold decision 4 over the double, so that mutant L fails there in words.
- *The loop's interval* is taken from the rate the last frame left, inside the tick's loop, and a tick returns when one of its frames set the rate to 0: the scoping's "the ticks resume with nothing owed" needed both, or a tick could run a frame at rate 0 with no edit.
- *A write of the value a cell already holds* answers `(written 0)`: the first draft of the Clock's test expected 1 for the seed the small cartridge already held.
- *The card is larger than the prototype*, 1,411 formula cells where it had 1,294: a ruler, the rate's bar, the seed's bits and the keys' lamps.

What remains is the owner's.
1. Open `web/index.html` (built) in Chrome and pick the Input card. The log names the seed the host chose.
2. Click the plane, so it takes the keys. Press the arrows, Z, X, A, S, Enter and Space: player 1's lamps in column I light white while held and move to another colour after each press. Press I, K, J, L, U, O, Y, P, 9 and 0 for player 2's, in column J.
3. Move the mouse over the plane: a white cursor follows it; hold the left, right or middle button and it turns red, green or blue, the mouse's lamps lighting beside the buttons'. Type any key and the lamp beside them flashes.
4. Turn the wheel: the card pans, the ruler and the wheel's lamp moving, and the cursor stays under the pointer.
5. Write `(cell "Clock" "B2" 1)` in the edit row: the log says the rate is now 1 frame a second and the card steps once a second; then `(cell "Clock" "B2" 30)`. Write `(cell "Clock" "B1" 5)`: refused, in red, `[cart-write-clock]`.
6. `run_checks.ps1 -WithExtras`, `ALL GREEN`.
7. The commit at the owner's word, by `-F`, staged by hunk: `ENGINE.3: the Clock's three cells held, the host's seed chosen at load, and the pointer in the Screen's own cells, with an input card`. Then the second slice, the replay.

*The owner's hand test, a first round, 2026-10-10, in Chrome at a ratio of 1.5, three screenshots and the runner's output.*
- The input card ran, and each key pressed moved its lamp to another colour: players 1 and 2, the mouse's buttons, the wheel's lamp, the bits of the frame, the seed and the dice. The log counted the windows the wheel panned the Camera to, from `A1:AN24` to `I1:AV24`, and the Clock sheet held the seed the host chose, 83396106.
- `(cell "Clock" "B1" 5)`, written over Life after a reload, was refused in red, `[cart-write-clock]`.
- `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`.
- **Found:** `(cell "Clock" "B2" 1)` froze the loop. The log said the rate was now 1 frame a second, and no frame followed; the plane stopped answering keys and clicks; and `(cell "Clock" "B2" 30)` did nothing. The engine had not crashed: the host had starved.
  - The host held its accumulator to 250 ms, a tick's time and the backlog alike (`ENGINE.1`, decision 4). At a rate of 1 a frame is owed only when the backlog holds 1,000 ms, so none ever was.
  - The edit of 30 is issued at the next frame's begin, as every edit is at a rate above 0, and so waited for a frame that never began.
  - The defect was `ENGINE.1`'s, and latent: a cartridge whose manifest said `(rate 1)`, `(rate 2)` or `(rate 3)` would never have stepped. `SPEC.md` §5 caps a tick's elapsed time alone; the backlog's cap was the host's addition. The oracle's model had copied the host's line, and the `input` case slowed the rate to 10 only, whose interval of 100 ms fits under the cap.

*Fixed the same day, at the report.*
- The backlog is held to the larger of 250 ms and one frame's interval, and a tick's time still to 250 ms, so a stall at 30 frames a second still runs seven frames and never thirty, `rate30`'s stall unchanged. A rate that moves starts the backlog again with nothing owed, so a rise from 1 to 30 runs no burst of a second's frames.
- The oracle's model takes the same rule. The `input` case writes the owner's rate of 1 at frame 18 and 30 again at frame 21, and paces its ticks by its own arithmetic of §5 as corrected: at the rate of 1, three ticks of 250 ms run no frame and the fourth runs one, for three frames, each checked after every tick. Its `rate` count is 5: three frames paced so, and the two sentences.
- A fifteenth mutant page, O, holds the backlog to 250 ms as it was, and fails `input` by name: "after 4 ticks of 250 ms at the Clock's rate of 1 the host is at frame 18, not 19". Mutant M, the rate never read, now fails it when a tick of 250 ms runs frames at 30 "before its interval was owed".
- `SPEC.md` §5, step 1, corrected in place and dated; `web/README.md` and the host's header with it; a dated note on `ENGINE.1`'s first slice above.

The oracle, run on the day (*measurement*):
- `check_host_loop.ps1` at both ratios, every case OK, `input` at `rate 5`; its control fifteen mutant pages, each failing for its own reason.
- The plain page's real loop, probed headless with the input card picked and stepped by animation frames under a virtual clock: the rate of 1, written through the edit box, landed at frame 22, then 3 frames in 4 s; the rate of 30 landed at frame 26 and the card ran on, 15 frames in the next 3 s of that clock, which measures no speed. On the same page with the old cap restored, the frame stayed at 22 and the edit of 30 was never written: the owner's freeze, reproduced.

What remains for the hand test: `(cell "Clock" "B2" 1)` on the input card, the card stepping once a second; then `(cell "Clock" "B2" 30)`, landing within a second and the card running at 30 again.

*The owner's second round, 2026-10-10.*
- `(cell "Clock" "B2" 1)` on the input card: the card dropped to one frame a second. `(cell "Clock" "B2" 30)`: back to thirty.
- The double space found in the roadmap's `KERNEL.5` line during the build was the owner's, an accident, and the owner took it out; no hunk of this slice touched it.

*Owner-tested 2026-10-10; the first slice committed 2026-10-10 at the owner's word, "Commit slice 1, then proceed with slice 2 of ENGINE.3". Not pushed.*

*The second slice built 2026-10-10, over `e1e4935` and `vla-lang` 0.8.1, awaiting the owner's test. The same day Frazaro's session sent word, through the owner, of `VLA.3` (`494100a`, the expand-time object model) and of `KERNEL.20`'s third slice (`71f90f7`), both unpushed and unreleased, with a request to move the pin. The pin stays at `=0.8.1`: moving it is the owner's call, and this slice needs neither.*

What landed:
- `web/host.js`, the replay (`SPEC.md` §7.6):
  - The recorder: from each load, every write that landed before each step, logged at the frame's end under `(frame n)`. The Input rows are logged as the cells that changed against the replay's own record of the sheet, which knows nothing at the first frame and nothing after a person's edit of the Input sheet. A person's edit is logged as its row, spelled back as the reader read it, so a replay is one row a line. The derived writes are never logged. A frame with no row is left out but the last, and the recorder stops at 8 MiB and says so. `replayText()` answers it.
  - The player: `play(text, all)` reads a replay whole and refuses in words, with nothing loaded, another cartridge's digest, a later page, a derived row, a row before the first frame, frames out of order, and a seed that is not the manifest's `(seed n)`. It loads the cartridge again with the replay's seed and plays each frame's rows as one write in place of the live inputs and edits, after the derived writes, which stay where the live loop issues them. It plays through the loop at the cartridge's rate, or every frame at once for the oracle. A person's edit is refused while it plays, the loop pauses at the last frame and says so, and the `frame` event carries the replay's last frame.
  - A synchronous SHA-256, with `AlonzoHost.sha256` and `AlonzoHost.SPEC` for the oracle.
- `web/index.template.html`:
  - the replay's and the golden's places, and the card's entry;
  - the panel's Play the replay and Copy the replay, and a box under The replay that offers a picked cartridge's own replay; the frame line says "Replaying frame 12 of 26";
  - the `input` case's log gains a person's edit of the Input sheet at frame 9 (player 2's fifth button), which its hand model follows, and the case keeps its live run;
  - the thirteenth case, `replay`.
- `cartridges/inputcard/inputcard.replay.vla` (the licence line, the header, 26 frames, 19 of them written, 130 rows, the seed 12345) and `inputcard.golden.vla` (the `Tally` sheet's record over `A1:E20`, 143 rows). Both are the page's own output, built in scratch: the replay as the host recorded the `input` case's run, the golden the `Tally`'s record at that run's end. The header's digest equals PowerShell's SHA-256 of the card's LF bytes.
- `engine/src/cartridge.rs`: `the_input_card_s_replay_plays_to_its_golden`, a player of the engine's own. It loads the card, writes the header's seed, then for each frame issues the derived write the last frame's Write row left and the frame's rows as one write, and steps; the `Tally`'s record at the end is the golden, byte for byte.
- `tools/build_web.ps1`: the `{{REPLAY:name}}` and `{{GOLDEN:name}}` places, held both ways.
- `tools/check_web_offline.ps1`: those places, and thirteen mutants.
- `tools/check_cartridge.ps1`: the folder's two new kinds, each pinned at 1. `Test-Replay` reads the licence line, the header (the folder's name, the spec, the digest against PowerShell's, the seed against the manifest's), the ascending frames, and cell and formula rows alone. `Test-Golden` reads one `window` row naming a sheet the record holds, every cell, formula and value row that sheet's, and a replay beside it. Twenty-nine mutants; a mutant may now name its file and a pattern.
- `tools/check_host_loop.ps1`: thirteen cases, the floors, and mutant pages P, Q and R. `tools/run_checks.ps1`: the dated line and the controls' words.
- `SPEC.md`:
  - §5 step 3 corrected: a replay's frame is one write;
  - §7.2 corrected: no clock in the seed;
  - §7.6 noted, the form made exact;
  - §8.3 noted.
- `README.md`, `web/README.md` (whose `input` line said the rate went to 10: it goes to 1 since the first slice's fix), `engine/README.md`.
- `CART.4`'s dated notes, on its scoping above and on its roadmap line.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1 (*measurement*):
- `cargo fmt --check` and `clippy --workspace --all-targets -D warnings` clean. `cargo test --workspace` 27 passed, the replay's among them. The module is the first slice's, 516,175 bytes, the engine having changed in its tests alone.
- `check_host_loop.ps1` at both ratios, thirteen cases. The first twelve's counts are unchanged but for `input`: 5 presses, 2 of them player 2's, and a button held in 7 frames, from the edit of frame 9. `replay`:
  - the 5 vectors;
  - over the double, a live run of 24 frames played on a fresh host to its digest, all at once and through the loop; the player's recording its replay; an edit refused while it played; 6 replays refused in words, the cartridge loaded untouched;
  - over the module, the committed replay its digest's and seed's and equal to the `input` case's run as recorded; the three edits that landed logged in their frames and the refused one nowhere; the Input sheet logged whole at frames 1 and 10; the 26 frames played each equal to the live run's window; the golden; the round trip.
- Its control, eighteen mutant pages in 69.3 s, each failing for its own reason. Over the double each of P, Q and R also ended in another digest.
  - P, a recorder that drops a person's edits, failed `replay`: "the replay of the input case's live run does not log the edit (cell "Input" "C5" 1) in frame 9, where it landed".
  - Q, a player that skips the derived writes, failed it: the committed replay "ends in a Tally that is not its golden ... at line 143, "(cell \"Tally\" \"B20\" 0)" against "(cell \"Tally\" \"B20\" 11)"", the click's frame never derived.
  - R, a recorder that keeps its record of the Input sheet across a person's edit, failed it: "frame 10 of the live run's replay logs 0 Input row(s), not the sheet's 48 after a person's edit of the Input sheet in frame 9".
- `check_cartridge.ps1`: the four cartridges as before; the replay "19 frame(s) written of 26, 130 row(s), the seed 12345"; the golden "the record of Tally's window A1:E20, 143 row(s)". Its control, twenty-nine mutants in 17.9 s. `check_web_offline.ps1`'s control, thirteen.
- `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`, in 129 s.
- The plain page's panel, probed headless under a virtual clock with the input card picked:
  - the replay's box offered the card's replay, 3,332 characters;
  - Play the replay ran it on the real loop, the frame line going from "Replaying frame 7 of 26" to "26 of 26";
  - an edit written meanwhile was refused in red;
  - the log said the rate was 1 at frame 18 and 30 at frame 21, then "frame 26: the replay ended at its last frame; the loop is paused";
  - Copy the replay put the replay played in the box, byte for byte its text less the licence line. The headless page's clipboard was closed, and the status said so.
  - Under that clock the animation frames come in bursts, so the probe measures no speed. A first probe that ended at 9.5 s of it caught the replay at frame 19, and a longer one saw it to its end.

Corrected in the build, against the scoping:
- *The mutant pages are P, Q and R*, where decision 11 named O, P and Q: O went to the first slice's backlog cap. So the control holds eighteen pages, where decision 13 counted seventeen.
- *The `input` case's log gains a person's edit of the Input sheet.* Without one, mutant R could not fail. Its floors rise accordingly.
- *The committed replay is the `input` case's own run*, as the host recorded it, so the oracle pins the recorder's bytes as well as the player's. Its golden is the `Tally` at that run's end, which the `input` case holds to the counts computed by hand.
- *The case's double half drives a live run of its own*, since the card does not run on the double: keys, the pointer, derived writes, and edits of the State and the Input sheets. The double's digest witnesses every write's order.
- *Every committed replay is played to its golden*, not the card's alone, so `CART.4` adds its two files and their places and nothing else.
- *A player of the engine's own, in `cargo test`*, which the scoping did not name. The golden is then reproduced by two implementations, the host's player and the engine's test (`SD-18`'s shape).
- *Two refusals more than the scoping's four*: a row before the first frame, and a seed that is not the manifest's `(seed n)`. After the reload the player also holds `Clock!B3` to the replay's seed.
- *Copy the replay puts the replay in its box as well*, so a page whose clipboard is closed still shows it, and Play then plays it.

Noted, not changed:
- Under `(seed host)` the host chooses a seed at every load, a save's included, whose `Clock!B3` may already hold one. §7.5 has a save resume with its seed, so this is `ENGINE.5`'s to settle when a save exists. A replay of a save's run names the seed it ran with, so it plays either way.

The size, against the prediction (*measurement*, the diff's added lines): the host 262 with its digest, against about 250; the page 254, the panel and the case, against 280; the engine's test 66, not predicted. The checks came to 345 against about 150, the static reading of a replay and a golden, with its nine mutants, being most of it. The writing took about half a day, against a day.

What remains is the owner's.
1. Open `web/index.html` (built) in Chrome, pick the Input card, and open The replay under the panel: its box holds the card's own replay, the loop oracle's run of the card.
2. Press Play the replay. The frame line reads "Replaying frame 1 of 26" onward. At frame 18 the card drops to one frame a second for three frames, then runs at thirty. At frame 26 it pauses, and the log says so.
3. Write an edit while it plays: refused, in red.
4. Press Run, and the card runs on live. Play it for a while, press Copy the replay, reload the page, pick the Input card, paste the copy into the box over the card's own, press Play the replay, and watch the same run.
5. `run_checks.ps1 -WithExtras`, `ALL GREEN`.
6. The commit at the owner's word, by `-F`, staged by hunk: `ENGINE.3: the replay, every write a host makes from a load kept and played back to the same frames, with the input card's golden`, with the item's close, the roadmap's line moved to the ledger's engine section.

*The owner's test of the second slice, 2026-10-10, in Chrome at a ratio of 1.5, with a screenshot.*
- A replay copied and played back worked. An edit written while a replay played was refused in red: "The edit (cell "Palette" "B1" "#FF8800") was not written: a replay is playing, frame 25 of 75, ...".
- All four cartridges replayed. The screenshot shows Life replaying its frame 48 of 75 from the seed 1, the log counting a replay played to its end and a second one playing.
- Picking the input card put its own replay in the box, with no copy needed.
- `run_checks.ps1 -WithExtras`: `ALL GREEN`.
- Seen in the screenshot and left as it is: after Copy the replay, the box's label, "the run since the last load, as the host recorded it", is set in the code type its file path takes.

*Owner-tested 2026-10-10; committed and closed 2026-10-10 at the owner's word, "Tests pass; commit, then suggest next steps": the second slice with the item's close, the roadmap's line moved to the ledger's engine section above. Not pushed.*

*Amended 2026-10-10 after the close, at the owner's word, "Proceed with implementing the nested replay form."* Reading the committed replay, the owner asked whether each frame's rows should sit inside the frame's form, `(frame 1 (cell "Input" "B1" 0) ...)`. The replay wrote a `(frame n)` head and the rows after it, which reads like a diff's hunks. The flat form was `SPEC.1`'s draft of §7.6, modelled on a line-oriented log, and decision 8 kept it without weighing the other. Nesting won on the merits:
- One form a frame is the one write the player issues for it.
- A row before the first frame cannot be written.
- A frame is a unit a tool counts, cuts or splices by taking forms.
- The header and the manifest already nest.

The flat form's advantages were small: every row stays a whole line inside the form, and a streaming recorder cut short would leave its file readable, while this recorder writes each frame whole.

What changed:
- `web/host.js`: the recorder writes a frame as `(frame n`, then its rows one a line, indented, the closing parenthesis on the last; a frame with no row is `(frame n)`. The player reads frames as forms and refuses, in words, a form outside them.
- `cartridges/inputcard/inputcard.replay.vla` is regenerated from the `input` case's run, its frames and rows the same, 19 frames written of 26 and 130 rows. The golden came out of the same run byte for byte the committed one.
- `tools/check_cartridge.ps1` reads a replay's frames as forms. Its mutant "a row before the first frame" became "a row outside the frames", and the derived row and the frames out of order were set inside the forms; still twenty-nine.
- The page's oracle reads a replay's frames with the viewport's reader. Its six refusals keep their count, the row before the first frame now a row outside the frames.
- The engine's test reads the replay with the language's reader and spells each row back with its printer, where it had split lines.
- `SPEC.md` §7.6, a dated correction of the example's form; `web/README.md`; the panel's text.

The oracle, run on the day (*measurement*):
- `cargo test`, 27.
- `check_host_loop.ps1` clean at both ratios, `replay`'s counts as before. Its control, eighteen mutant pages in 74.5 s.
- `check_cartridge.ps1`'s control, twenty-nine mutants in 20.2 s.
- `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`, in 142 s.
- The plain page, probed headless, played the card's nested replay to frame 26, and Copy the replay gave back its 3,560 characters, the same text.

*Committed 2026-10-10 at the owner's word, "Commit.", under the closed item's ID. Not pushed.*

## `ENGINE.4` — the Audio device: the four voices on the audio clock, the graph's own nodes, a sound card, and the schedule held

*Scoped 2026-10-10 at the owner's word, the day `ENGINE.3` closed and was pushed. The roadmap's line: "The Web Audio graph's own nodes, an oscillator and a gain per voice, driven from the Audio sheet's cells read after the step; no synthesizer of its own (`CHARTER.md` §8). Needed by: `CART.3`." `CART.4` needs it too, a tick per move, a tone per freeze and a fanfare at the top, and `CART.5`'s four voices play under a playhead. Every item before this one left the Audio sheet the same way: read after each step, and sounded nowhere. So the scoping measured what a page gets from Web Audio before deciding anything, in scratch pages under headless Chrome 154 and in a scratch copy of the workspace: the two clocks, the clicks, the waves, the cost, and a sound card. The owner's standing brief governs every decision: determinism first, a replay is a proof and a floor is a number. The sound is never golden (`SPEC.md` §6); what the host schedules from the cells is a function of them, and can be held.*

**Substrate, verified.** Read on the day, by file and never by assumption; Frazaro's tree read and written nowhere.

- *The pre-flight.*
  - This tree clean at `d8bd24d`, level with `origin/main`. CI's run on it, `38072688050`, green on both jobs.
  - `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`; the loop check's control, eighteen mutant pages, in 69.4 s.
  - `vla-lang` pinned at `=0.8.1`. Frazaro's 0.8.2 is unreleased, and this item needs none of it.
  - During the scoping a peer session began a new §10 of `docs/ALGEBRA.md`, uncommitted; this item touches that file nowhere.
- *The engine* (`engine/src/cartridge.rs`). `Device::Audio`'s layout is `A1:D5`, with no cell the host writes and none a derived write is kept from. `describe` names it when a cartridge holds it; a cell outside it is refused at load and at a write. The engine makes no Audio sheet of its own, and no cartridge in the repository holds one.
- *The host* (`web/host.js`).
  - `_readAudio` reads the four rows after each step into `this.audio`, `{voice, wave, note, volume}` as the record holds them, after the plane is drawn and before the File, the Write sheet and the Clock. Nothing reads `this.audio`, and nothing in `web/` makes an audio context.
  - `stop()` is called by `attach`, a load, an unload, a refused step, the end of a replay and Pause. A hidden page sets `hidden`, and the tick returns while it holds.
- *The double* (`web/fake.js`). An Audio sheet of value cells: the header, then voices 1 to 4 each `square`, 69 and volume 0. Its `describe` lists every device, and its digest folds every sheet, the Audio sheet among them.
- *The page.* The device sheet's picker offers Audio; nothing turns a sound on.
- *The language's library* (`vla-lang` 0.8.1, `library::language`): `IF`, `AND`, `OR`, `NOT`, `SUM`, `MIN`, `MAX`, `ABS`, `INT`, `MOD`, `ROW`, `COLUMN`, `CHOOSE` and `SIN`. A sound card needs nothing more: `CHOOSE` over texts for a wave, `INT` and `MOD` for a sequence.
- *The specification*, version 3.
  - §3.6: the table, the frequency the host's, the cells holding for one frame, rendered for `1/rate` seconds against the audio clock with a lookahead and never against the animation clock; noise, envelopes and samples not in this version.
  - §5: step 5, the effects read after the step; step 6, the sound; rate zero, a voice holding until the next step.
  - §6's last line: the host's draw and sound measured, never golden. §8.3: the shim "drives the four voices (`ENGINE.4`)". §10: four voices. §11, decision 16: wave, note and volume. §12 and §14 (Wilson's "A Tale of Two Clocks"). Appendix C's voice forms, and C.5: control signals are cells, audio rate is the graph's.
- *The charter.* §4: rule 3, rent from the browser; rule 4 (`AD-4`), what can only be measured is Alonzo's. §8: "A sound synthesizer beyond the Web Audio graph's own nodes" is not built.
- *The checks.* `check_web_offline.ps1` forbids the tag `<audio` over the template and the built page, into which `web/host.js` is inlined. No code token names Web Audio.

**The measurements.** *Measurement*, 2026-10-10, on the owner's machine: scratch pages opened from `file://` under headless Google Chrome 154 and read by `--dump-dom`, and a scratch copy of this workspace over `vla-lang` 0.8.1 with an example of its own. Timings are magnitudes, never floors.

- *What a page gets.* `AudioContext` and `OfflineAudioContext` exist, and `isSecureContext` is true. Without a person's gesture a context is made suspended and its `resume()` stays pending; with `--autoplay-policy=no-user-gesture-required` it runs at once. The sample rate is 48,000, the base latency 0.01 s, the output latency 0.
- *The two clocks, parted.* Under a virtual-time budget the page's clock, its timers, `performance.now` and `Date`, is virtual, and the audio clock is the wall's. `currentTime` went from 0 to 0.76 s during one busy task of about 0.76 s of wall time, then stood at 0.76 across 2 s of idle virtual time. No headless check can read a real context's clock against the page's, so an oracle of the schedule must drive its own. (And within a task neither `Date` nor `performance.now` moves: a scratch probe's busy wait on `Date` never ended.)
- *The offline render.* An `OfflineAudioContext` renders under headless Chrome. Awaited idle under a virtual-time budget it burns the budget at a growing rate: four renders of 1 s took 5 ms, 0.6 ms, 935 ms and 8,975 ms of virtual time, and the fifth never finished. A chain of 0 ms tasks beside it holds virtual time to the clamped 4 ms a task: 28 channels of 1 s rendered in 9.9 s of virtual time, 2,491 tasks, about a second of wall time. A context holds at most 32 channels, the Web Audio specification's limit: a page that asked for 34 printed nothing, and batches of 24 rendered.
- *The graph's own waves*, Chrome's, at 440 Hz and gain 1: a square's peak 0.9910 and rms 0.8440; a triangle's 0.9907 and 0.5775; a sawtooth's 0.9715 and 0.4863; a sine's 1.0000 and 0.7071; each 440.0 zero crossings a second.
- *Four voices summed.* Four squares at gain 1 (A, C sharp, E, A) peak at 3.81, which a real output clips at 1. At gain 1/4 they peak at 0.953.
- *The note's range.* Note 127, 12,543.9 Hz, renders at 12,542.9 Hz by its zero crossings. 30,000 Hz, past the Nyquist frequency of 24,000, renders silence. Every note from 0 to 127 lies below the Nyquist frequency of every sample rate from 25,088 a second (*derived*).
- *A wave is no AudioParam.* An oscillator's `type` set while an offline render stood suspended at 0.5013 s changed the wave there: rms 0.7069 before, 0.8440 after. A wave changed in JavaScript is heard when the JavaScript runs, never at a time on the audio clock.
- *The click*, read as the largest step between two samples over the wave's own largest step:
  - a gain set at once from 0 to 1 at mid-cycle: 17 times for a sine and 24 for a triangle at 440 Hz; from 1 to 0, 17 times for a sine;
  - a linear ramp of 1, 2 or 5 ms: 1.00 to 1.26 at 440 Hz; from 55 to 220 Hz, up to 1.33 at 2 ms and 1.36 at 5 ms;
  - `setTargetAtTime`'s approach, the worst of four phases from 55 to 440 Hz: a time constant of 1.5 ms up to 2.65 (a triangle at 55 Hz), 2 ms up to 1.99, 3 ms up to 1.33; a release from 1 to 0 at 1.5 ms up to 3.63;
  - a square's own edges, a step of 1.22, dwarf all of these.
- *A wave change at full gain*, the old oscillator stopped and a new one started at one time: a sine to a triangle 31 times the wave's own, a triangle to a sine 25 times; a square to a sine, or a sine to a sawtooth, no larger than the square's or the sawtooth's own edge. Through a dip, the gain approaching 0 and the new oscillator started five time constants later: 1.00 to 1.12.
- *One frame's pitch and loudness.* A note held one frame at 30 frames a second, measured over its middle by interpolated zero crossings, was within 0.010% of 440·2^((note−69)/12) for notes 36 to 96 on all four waves. A frame's rms was within 1.8% of the gain times the wave's own.
- *The automation, as the Web Audio specification has it.* `cancelScheduledValues(t)` removed the later event and kept the earlier (peaks 0.5, 0.25, 0.25); of two values set at one time, the later won; a frequency set to 880 at 0.5 s read 440.4 Hz before and 880.0 after.
- *The schedule's cost on the main thread*, by totals, since headless Chrome coarsens `performance.now` to 0.1 ms. Four voices each changing note and volume, a cancel and three events a voice: 0.0034 to 0.0041 ms a frame over 1,500 frames, three runs. Four new oscillators a frame, the worst case of a wave change: 0.042 to 0.046 ms. A timeline grown 1,500 frames ahead: no growth. The read of the Audio sheet is already paid (`ENGINE.1`).
- *A sound card, prototyped natively.* 117 rows and 1,592 formula cells, `(budget 30 1592 47760 2000000)`, loaded in 1.64 ms, a step 0.171 ms at the median and 0.209 at the 95th over 240 frames. Its sections, its tick on a press, a knob edited to `"saw"` and back, its Log and its waterfall each held the values designed (decision 9).
- *Derived.* Scheduled when a frame completes, by the animation clock, a rhythm carries the display's quantization. At 25 frames a second on a 60 Hz display, a frame owed every 40 ms runs at the first display interval after it, 10, 3.3, 13.3, 6.7 and 0 ms late in turn, so a beat every four frames comes 150 to 166.7 ms apart where the cells say 160. Scheduled on the audio clock from the last frame's end, it comes every 160 ms exactly.

**The census.** What the line asks, against what stands:

| the device | what stands | what is open |
|---|---|---|
| the layout | `A1:D5`, checked by the engine at load and at a write; `describe` names it | nothing |
| the read | the host reads rows 2 to 5 after each step | no cell judged: a wave, a note or a volume that is no voice passes unseen |
| the sound | nothing: no audio context in `web/` | the whole of §3.6 |
| the two clocks | §3.6's sentence and §14's source | no rule for a late frame, a burst, rate 0, a pause, a hidden page or a replay |
| starting | nothing | the autoplay policy: a context made before a gesture is suspended (measured) |
| a cartridge that sounds | none in the repository | a fixture |
| the oracle | nothing | the schedule held nowhere, the sound measured nowhere |
| the double | four value cells a voice, silent at volume 0 | a person's edits can drive them |

**The work.** Two slices: the voices, with the sound card and the schedule's oracle; then the measured render and the card's replay.

| File | What it is | Slice; decisions |
|---|---|---|
| `web/host.js` | the voices: the timeline, the nodes, the approach and the dip, a cell that is no voice, Sound on and off, silence at a stop; the options `audio` and `audioNow`; the counters | 1; 1 to 6 |
| `web/index.template.html` | the Sound button and the frame line's counts; the sound card in the picker and its places; the double of the graph and the fourteenth case, `audio`; in slice 2 the fifteenth, `sound`, and the card's replay and golden | 1, 2; 5, 7 to 10 |
| `cartridges/common.vla` | the `audio` macro, Appendix C's | 1; 9 |
| `cartridges/soundcard/soundcard.source.vla`, `soundcard.vla` | the sound card, a source over the library, and the cartridge the pass writes | 1; 9 |
| `cartridges/soundcard/soundcard.replay.vla`, `soundcard.golden.vla` | the card's replay, the `audio` case's run as recorded, and its Log at the end | 2; 10 |
| `engine/src/cartridge.rs` | the replay's player in `cargo test`, made general over every folder holding a replay (tests only; the module unchanged) | 2; 10 |
| `tools/check_host_loop.ps1` | fourteen cases, then fifteen; the floors; mutant pages S to W, then X | 1, 2; 7, 8 |
| `tools/check_cartridge.ps1` | five cartridges and five sources; the Audio sheet's value cells judged, with mutants; in slice 2 two replays and two goldens | 1, 2; 9, 10 |
| `tools/check_web_offline.ps1` | the shim's Web Audio names held, with mutants; the card's places | 1, 2; 11 |
| `tools/run_checks.ps1` | the dated line and the controls' words; the floor stays at 12 and 12 | 1, 2; 13 |
| `SPEC.md` | dated corrections: §3.6, §5, §8.3, §13, §14 | 1, 2; 12 |
| `REARVIEW.md` (this entry), `ROADMAP.md` (this line; notes on `CART.4` and `CART.5` at the close), `README.md`, `web/README.md`, `engine/README.md`, `Delta/CLAUDE.md`, the memory | the pages | 1, 2; 13 |

**The decisions, the owner's.** Each with the sitting's recommendation and the alternative it declines.

1. **The two clocks: each frame's voices sound at a time on the audio clock, the end of the last frame's sound, kept inside a window ahead of the clock. A late frame starts the timeline again, and a frame past the window is not sounded.**
   - A frame's time is the last frame's time plus `1/rate`, the rate the host read after the last frame and steps at. While the loop keeps up, the frames lie end to end on the audio clock, so a rhythm in the cells is a rhythm in the sound whatever the display's interval: Wilson's lesson (§14).
   - The window runs from the audio clock's now to twice the lookahead ahead of it. The lookahead is 50 ms.
   - A frame whose time has already passed starts the timeline again, at now + 50 ms. A cartridge too heavy for its rate then sounds its frames as they come, each frame's voices holding until the next, as its screen does.
   - A frame whose time lies past the window is not sounded, and the timeline stays where it was. A burst after a stall, seven frames at 30, sounds its first frames and skips the rest, as its screen presents only its last; the next frame in time is sounded where the timeline left off.
   - At rate 0 every step sounds at now + 50 ms, and a voice holds until the next step (§5).
   - The host sounds only while its audio context runs (decision 5). A frame computed while it does not is not scheduled, and the next one starts the timeline.
   - A restart and a skip are the renderer's, as the blit's scale is, so no sentence says them; the frame line counts them while the sound is on.
   - A press reaches its tick after its frame, the lookahead and the device's own output latency.

   *Alternatives:* each frame at now + 50 ms when it completes, the animation clock in the rhythm: at 25 frames a second on a 60 Hz display a beat every four frames comes 150 to 166.7 ms apart where the cells say 160 (*derived* above). The timeline unbounded, a stall's burst adding up to seven frames of lag for good. A burst cancelled and pulled back, with oscillators already scheduled to start and stop to undo. A lookahead of 100 ms, Wilson's example: safer against a long task, and twice the lag behind the picture; or 25 ms, a tick heard sooner, and every long task a restart.
2. **The voices: the graph's own nodes and nothing else, an oscillator and a gain a voice into one gain into the destination. The frequency is the host's 440·2^((note−69)/12), set at the frame's time, so a slide is a staircase at the frame rate. The gain is the volume over four. Only what changed is scheduled.**
   - The gains are made when the sound is first turned on and kept for the host's life; a voice's oscillator is made when the voice first sounds, replaced at a wave change, and stopped at an unload.
   - A voice's gain is its volume divided by four, so four voices at full volume never clip: four squares at gain 1 peak at 3.81, at a quarter at 0.953 (measured). A voice alone at full volume is a quarter of full scale. The gain the voices share is 1.
   - The frequency is set at the frame's time by `setValueAtTime`, the oscillator keeping its phase. A fraction of a note is a fraction of a semitone (§3.6), and a slide the cells write moves once a frame, as a chip's registers are written once a frame; to interpolate across the frame would need the next frame before this one sounds.
   - A voice whose wave, note and volume are the ones last scheduled schedules nothing, so a held drone costs no event. A silent voice changes neither its oscillator's wave nor its pitch, only its gain.

   *Alternatives:* the gain the volume itself, louder alone and clipping under two loud voices. A compressor on the shared gain, a node of the graph's own that changes the sound by its level, so a synthesizer of its own in all but name. Every voice every frame, twelve events a frame whatever happens.
3. **The click: every change of a voice's gain approaches its new value through the graph's `setTargetAtTime`, with a time constant of 3 ms. A wave change is a new oscillator, through a dip when the voice is sounding.**
   - `setTargetAtTime` starts from wherever the gain stands, so a frame needs no record of the last one's level, and a stop needs no `cancelAndHoldAtTime`, which Firefox lacks. At 3 ms the approach is within 1% after 14 ms, under half a frame at 30, and no onset step exceeds 1.33 times the wave's own down to 55 Hz (measured; 2.65 at 1.5 ms). It is the graph's automation, never a sample the host computes (`CHARTER.md` §8).
   - A wave cannot be scheduled: the type is set when the JavaScript runs (measured). So a wave change stops the voice's oscillator and starts a new one of the new wave at one time on the audio clock. When the voice was sounding, the gain approaches 0 from the frame's time, the switch comes five time constants later, 15 ms, and the gain approaches its new value from there: 1.00 to 1.12 times the wave's own, against 25 to 31 at once (measured). When the voice was silent, the switch is at the frame's time.

   *Alternatives:* gains set at once, an onset 17 to 24 times the wave's own. A linear ramp, as clean at 5 ms, but needing the last level, at a stop too. The type set when the frame is scheduled, 50 ms early, under the previous frame's sound. Four oscillators a voice, one a wave, against the line's one oscillator a voice. A column for the approach, an envelope, which §12 leaves to a later version.
4. **A cell that is no voice: the voice is silent for the frame, and the host says so once, as it says a Camera cell. A rest needs nothing else.**
   - The volume is read first: empty is 0, and a number from 0 to 1 is itself. At 0 the voice is silent and its wave and note are not judged, so a rest is volume 0 whatever the other cells hold, and an unused voice is an empty row.
   - Above 0, the wave is one of the four words, compared without case as the model compares names, and the note a number from 0 to 127, MIDI's range, a fraction allowed; every one is below every Nyquist frequency from 25 kHz (measured).
   - Anything else in any of the three, a text, a truth value, an error value or a number out of range, silences the voice for the frame. The host says it once for each cell and each value shown: "frame 12: voice 2's wave, Audio!B3, is "saw", not square, triangle, sawtooth or sine; the voice is silent." It is a notice and not a refusal, with no id: the Audio sheet is read after a step and never refused, as the Camera is (§3.8).
   - It judges only while the sound is on, the sentence being about what is heard.

   *Alternatives:* an error tone, magenta's twin, declined, since a sound cannot be glanced past as a pixel can and the sentence carries the defect. The volume clamped and the note clamped, a wrong note heard as a right one. A refusal at a write, which an effect never takes.
5. **Starting the sound: a Sound button in the engine's panel. The audio context is made at its first press, the person's act Chrome's autoplay policy asks for. Sound off silences the voices and suspends the context. The panel says when a cartridge's voices are silent for want of it.**
   - Made at the press, the context runs at once, a press being a gesture. Made at the page's load it would stay suspended until one (measured), and the console would warn.
   - At the load of a cartridge holding an Audio sheet while the sound is off: "The cartridge has an Audio sheet: press Sound on to hear its four voices (the browser lets a page sound only after a person's act)." A browser without Web Audio says so, and the sheet is still read.
   - The sound is the person's to turn on, as the plane takes the keys at a click: a click on the plane or a key does not turn it on.
   - The audio context is the host's own state (§8.3, `SD-23`). Nothing about the sound a cartridge makes is the host's.

   *Alternatives:* the first click or key on the page turns the sound on, so a page sounds when a person meant to give it the keys. A context made at load, resumed at the first gesture.
6. **When the loop stops, the voices stop. At Pause, a hidden page, the end of a replay, a refused step and an unload, every voice's later events are cancelled and its gain approaches 0 from the audio clock's now. When the loop starts, the frame the grid holds sounds at once.**
   - Every one of these but the hidden page goes through the host's `stop()`, and the hidden page through its own flag; the silence is made there and nowhere else.
   - A start (Run, a load's start, a replay's, a page shown again) sounds the current frame's voices at now + 50 ms, so a paused card resumes where it stood, and frame 0 sounds at a load as it is drawn.
   - After a cancel the host forgets what it last scheduled, so the next frame sets every voice whole.
   - An unload also stops the oscillators after the release, and the next load makes new ones at its first sounding frame.

   *Alternatives:* the voices hold their last frame through a pause and in a background tab, a drone no game's pause makes. The context suspended at every stop, an asynchronous act at every Pause.
7. **The oracle of the schedule: a double of the graph in the page, every node and every call recorded with its time on a clock the oracle drives, held frame by frame to the page's own arithmetic of decisions 1 to 6. It is the loop oracle's fourteenth case, `audio`, over the double and over the module, with five mutant pages. Both kinds of oracle the brief named are recommended: this one, and decision 8's.**
   - The host takes two options for it, `audio` (a context in place of the one it makes) and `audioNow` (the audio clock), as it takes `now` and `budget` today. The panel never passes them.
   - Over the double, its Audio sheet written by a person's edits (a voice's note, volume and wave, a defect and its end): frames on time; a late frame, the audio clock jumped ahead; a stall's burst, its first frames sounded and the rest skipped; Pause and Run; the page hidden and shown; rate 0; an unload. Its floors are `Min`.
   - Over the module, the sound card of decision 9 for 240 frames: presses, each a tick; a knob turned into a defect and back; the Clock's rate moved to 10 and back. Every frame's Audio sheet equals the card computed by hand from the log, and every event equals the page's arithmetic. Its floors are `WithModule`.
   - The expectations use the oracle's own constants, 50 ms, 3 ms and a quarter, never the host's, as the accumulator's 250 ms is the oracle's own.
   - The control's pages, each failing the case by name: S, a gain set at once; T, every frame at now + 50 ms, the animation clock; U, a voice's gain its volume; V, no silence at a stop; W, a wave changed at once while the voice sounds.
   - The thirteen cases before it make no audio context, so the host schedules nothing in them and their counts stay.

   *Alternatives:* the measured render alone (decision 8), which can say a sound is wrong and not which call made it. A native test, which holds the card and never the host.
8. **The measured half: an offline render of frames through the host's own voices, the pitch and the loudness of each measured against the graph's own waves. It is the fifteenth case, `sound`, measured and never golden (§6).**
   - Over the double at its rate: a sequence of voice states written by edits, the four waves, notes from 36 to 96, a rest and a wave changed while the voice sounds. It is rendered into an `OfflineAudioContext` by the host's own voices on the oracle's clock, paced by a chain of 0 ms tasks (measured).
   - Each frame's middle is held: its pitch within 0.1% of its note's, its rms within 4% of the volume over four times the wave's own measured in the same page, a rest under 0.0001, and no onset step over 1.5 times the wave's own.
   - One control page, X: the time constant written in milliseconds where the graph takes seconds, in the host and in the oracle's own arithmetic alike. `audio` passes it, and only the render hears the voice that never arrives.
   - The case awaits its render, the first case that does. The loop element is printed when the render lands, and the check's virtual-time budget rises if a run needs it.

   *Alternatives:* the double alone, blind to a misreading of the graph that the host and the oracle share. A check of its own under `?sound=1`, a thirteenth check for one case.
9. **The fixture: a sound card, `cartridges/soundcard/`, written as a source over the library. It plays the voices' features in four sections of two seconds and a tick on every press, with a Knobs sheet a person turns, a Log of the last 32 frames' voices, and a waterfall on the Screen.**
   - `(spec 3)`, `(rate 30)`, `(screen plane 48 24)`, `(seed 1)`. A Score sheet holds the section, the step within it, and the rising edges of the presses.
   - The sections, each 60 frames: A4 through the four waves, half a second each, the wave changing under the sound; a scale, C major up, seven frames a note with a rest between; a chord, C major then A minor on voices 1 to 3; a slide on voice 2 from note 48 by 0.4 a frame, under a swell of its volume.
   - Voice 4 is a tick: one frame at volume 1 on the rising edge of any of player 1's ten buttons or the left mouse button, its wave and note the Knobs sheet's.
   - The Knobs sheet holds the tick's wave and note, and a volume every voice is multiplied by. A knob is a cell (Appendix C), and a person's edit of the tick's wave to `"saw"` is the defect decision 4 says.
   - The Log holds the frame and the four voices' cells, a shift register over its twin 32 frames deep: the control log `CART.5`'s oracle names. The waterfall lights the Screen's top row at each sounding voice's note, 48 to 95, in its colour, and moves the rows below down one each frame.
   - The library gains `audio`, the Audio sheet's header row and voice numbers, the macro Appendix C's patch already calls; no cartridge's bytes move.
   - `check_cartridge.ps1` judges the Audio sheet's value cells statically as decision 4 judges them in the host, with mutants.

   *Alternatives:* the input card given an Audio sheet, its digest, replay and golden moved, and two devices shown on one card. No Log, the golden the Audio sheet's four rows at the end.
10. **The replay: the sound card's replay and golden are committed, and played by the `replay` case and, natively, by the engine's player made general.**
    - The replay is the `audio` case's run over the module as the host recorded it, and the golden is the Log's record at its end, 32 frames of the four voices, note for note.
    - The `replay` case already plays every committed replay to its golden over the module. It gains the card's live run held equal to its committed replay, as the input card's is.
    - `cargo test`'s player was written for the input card alone, its derived write hard-coded. It plays every folder's replay to its golden, the Write sheet's rows read as the host reads them.

    *Alternatives:* a second native test, copied for the card. None.
11. **The charter's §8 held on the shim: `check_web_offline.ps1` forbids in `web/host.js` every Web Audio name that would make a synthesizer of the host's own or reach past the graph's nodes.**
    - The names: `createScriptProcessor`, `AudioWorklet` and `audioWorklet`, `createBuffer` (and so `createBufferSource`), `createPeriodicWave`, `createMediaElementSource`, `createMediaStreamSource`, `getUserMedia` and `addModule`.
    - They are held over the shim alone, since the page's oracle reads a render's samples to measure it.
    - Mutants plant each kind in a copy of the shim, each failing by name.

    *Alternatives:* the rule in prose alone; or `SPEC.4`.
12. **The page: dated corrections of version 3, and no `SPEC.4`; the charter unchanged.**
    - §3.6: the timeline, the gain over four, the approach and the dip, the note's range and a voice that is no voice, and the sound while the loop runs. §5's step 6 and rate zero. §8.3. §13's oracle. §14's sources: MDN's `AudioParam` and `OscillatorNode`, and Chrome's autoplay policy.
    - No row, column, directive or call is added, and §3.6's table keeps its four columns.

    *Alternatives:* `SPEC.4` for the timeline. The approach as a column, an envelope, which is §12's.
13. **The slices, the checks and the bookkeeping.**
    - Slice 1, the voices: decisions 1 to 7, 9 without its replay, 11 and 12. `check_host_loop.ps1` at fourteen cases and twenty-three mutant pages; `check_cartridge.ps1` at five cartridges and five sources; `run_checks.ps1` at 12 and 12.
    - Slice 2, the measure and the replay: decisions 8 and 10. Fifteen cases and twenty-four pages; two replays and two goldens.
    - No floor for the schedule's cost, under a hundredth of the blit's frame of 0.7 ms (measured above; `ENGINE.1`'s baseline).
    - The roadmap's line gains this scoping now and 🟡 after the first slice is built, and leaves for the ledger at the second's commit, closing the item.
    - The commits, at the owner's word, by `-F`, staged by hunk: `ENGINE.4: the Audio sheet's four voices sounded by the graph's own nodes on the audio clock, with a sound card`; then `ENGINE.4: the sound measured by an offline render, and the sound card's replay played to its golden`.

    *Alternative:* one slice.

**The catch.** Each met once in the scratch work, or foreseen by reading.

- The double's digest folds every sheet, the Audio sheet among them, so the double half drives its voices by edits: no rule changes in the double, and no case's printed digest moves.
- `<audio` is a forbidden tag on the built page, which inlines the shim: no comment there may write it.
- The frame's sound is scheduled after the Clock's rate is read, so a rate written in a frame sets that frame's length. The mutant anchors H (the three reads) and M (`if (d.clock) this._readClock();`) stay whole: the sound is a line after them.
- A late frame starts the timeline again with no cancel, since the last frame's events have all passed; only a stop cancels.
- Under virtual time an offline render needs a chain of 0 ms tasks, and a busy wait on `Date` or `performance.now` never ends.
- A real context's clock is the wall's under virtual time, so nothing headless reads one: the oracle's clock is its own.
- An offline context holds at most 32 channels.
- PowerShell 5.1 as every check met it: ASCII, `return ,$list`, `$onWindows`, `2>&1` on a native command, the Write tool and never a heredoc, a commit message by `-F`.
- The tree is shared, a peer's `docs/ALGEBRA.md` among it: this file, the roadmap and the page are staged by hunk, HEAD plus this item's own.

**Oracle.** On the owner's machine under Windows PowerShell 5.1, then on both jobs.

- `cargo fmt --check`, `clippy --workspace --all-targets -D warnings` and `cargo test --workspace`: the pass's golden over five sources; in slice 2 the general player over two replays.
- `check_cartridge.ps1`: five cartridges, five sources, one library, the Audio judgment's mutants among its control's; in slice 2 two replays and two goldens.
- `check_host_loop.ps1` at both ratios: fourteen cases, then fifteen; the control's pages, twenty-three then twenty-four, each failing for its own reason.
- `check_web_offline.ps1`'s control with its new mutants.
- `run_checks.ps1 -WithExtras` at 12 checks and 12 verifiers, `ALL GREEN`.
- The owner's hand test, in Chrome with the speakers on.
  - Slice 1: pick the Sound card and press Sound on. Hear the four waves under one note, the scale, the two chords and the slide with its swell, an eight-second loop, with no click at a wave change or a note's start. Press Z or an arrow: a tick. Write `(cell "Knobs" "B1" "saw")`: the log says voice 4's wave is no wave, and the tick is silent; `(cell "Knobs" "B1" "square")`: a square tick. Pause: silence; Run: the sound again. Another tab and back: silence, then the sound. `(cell "Clock" "B2" 10)`: the music at a third of its speed; then 30. Sound off.
  - Slice 2: play the card's replay and hear the run again.

**Size.** `~days` (*prediction*).
- Slice 1, about a day: the host about 220 lines, the page's double and case about 450, the card's source about 170, the checks about 150, and the page's prose.
- Slice 2, about half a day: the render's case about 200 lines, the engine's player about 80, the two files.

*Scoped 2026-10-10; the thirteen decisions await the owner.*

*Approved 2026-10-10, the same day, all thirteen, in the owner's words: "All thirteen decisions approved. Proceed." With the approval the owner restated the roadmap's markers: 🟡 marks an item under construction, and ✅ is earned by a successful build whose tests pass; the line went to 🟡 the same hour, and the roadmap's legend says so. The first slice is built first, decisions 1 to 7, 9 without its replay, 11 and 12; the second waits for its test.*

*The first slice built 2026-10-10, over `5ecfa38` (a peer's commit of `docs/ALGEBRA.md` §10 and its sitting, which moved HEAD during the build and took none of this slice's hunks) and `vla-lang` 0.8.1, awaiting the owner's test.*

What landed:
- `web/host.js`, the sound:
  - `_sound`, a frame's four voices on the audio clock by decision 1's window, after the Clock's rate is read; `_graph`, the shared gain and a gain a voice, made once for a context; `_voiceOf` and `_voiceBad`, decision 4's judgment and its notice; `_voiceAt`, `_oscillator` and `_target`, decisions 2 and 3, only what changed, the approach by `setTargetAtTime` at 3 ms and the dip of five time constants.
  - `_silence` in `stop()`, and `_visibility`, through which the page's `visibilitychange` now runs; `_release` at an unload; `_resound` in `start()` and at a page shown again, which reads the Audio sheet only while the sound is on.
  - `soundOn`, `soundOff` and `soundIs`; the options `audio` and `audioNow`; the counters `sounded`, `restarts`, `skipped` and `silences`; `_wantSound`, the notice that a voice would sound while the sound is off, once a load.
  - The header, the rules' comment and `AlonzoHost.RULES` with the sound's constants.
- `web/index.template.html`: the Sound on button and the frame line's sound counts; the sound card in the picker, its two places and its entry; and the loop oracle's fourteenth case, `audio`: `GraphDouble`, a double of the Web Audio graph; `SoundModel`, the page's own arithmetic of decisions 1 to 6 with its own constants; `sndWant`, decision 4; and the case, over the double by edits, with the sound off, and over the module with the sound card computed by hand.
- `cartridges/common.vla`: `audio`, the Audio sheet's header and the voices' numbers. `cartridges/soundcard/soundcard.source.vla` (133 lines) and the cartridge the pass writes, `soundcard.vla`, 117 rows, 1,679 cells, 1,592 of them formula cells; every other cartridge unchanged byte for byte.
- `tools/check_host_loop.ps1`: fourteen cases, the floors of `audio` and `pass` at 5 sources, and mutant pages S to W. `tools/check_cartridge.ps1`: five cartridges and five sources, the Audio sheet's value cells judged, thirty-two mutants. `tools/check_web_offline.ps1`: the shim's eight Web Audio names, twenty-one mutants. `tools/run_checks.ps1`: the dated line and the controls' words.
- `SPEC.md`'s dated corrections: §3.6 (the timeline, the voices, a voice that is no voice, when it sounds), §5 step 6 and rate zero, §8.3, §13, §14's sources. `README.md`, `web/README.md`, `engine/README.md`.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1 (*measurement*):
- `cargo fmt --check` and `clippy --workspace --all-targets -D warnings` clean; `cargo test --workspace` 27 passed, the pass's golden holding five sources. The module unchanged, 516,175 bytes: this slice is the host's.
- `cargo run --release --example expand -- --check`: five sources, each `same`.
- `check_host_loop.ps1` at both ratios, fourteen cases. The first thirteen's counts and digests are what they were (`rate30` 7a8f8c44 with 124 detachments), but for `pass`, 5 sources the same and 504 rows. `audio`:
  - over the double: 43 frames, 41 sounded (the frames and three starts, less five skipped), 80 calls on the double of the graph each equal to the page's arithmetic, 3 oscillators, 5 restarts (the start, the long task, the stall, the run after the pause, the page shown), 5 skipped (the stall's burst), 3 silences (the pause, the page hidden, the unload), 2 notices said once each and marked no refusal, 3 frames at rate 0; and with the sound off, the one notice that the voices would sound, nothing sounded;
  - over the engine's module, the sound card: 240 frames, every frame's Audio sheet equal to the card computed by hand and every call to the arithmetic, 241 sounded, 248 calls, 5 ticks, 1 frame silenced by the wave `"saw"` and its one notice, 10 frames at the rate of 10, the waterfall drawn by hand 240 times.
- Its control, twenty-three mutant pages in 107.1 s, each failing for its own reason. The five new ones failed at the first call their reason makes the first to differ, in both halves:
  - S, a gain set at once: "over the double, frame 2: the host's call 21 on the graph is "gain 2 gain set 0.125 at 0.11666666666666667", and the page's arithmetic says "gain 2 gain target 0.125 at 0.11666666666666667 tau 0.003"";
  - T, every frame a lookahead from now: "the host's call 18 on the graph is "oscillator 6 frequency set 440 at 0.11800000000000001", and the page's arithmetic says "oscillator 6 frequency set 440 at 0.11666666666666667"";
  - U, a voice's gain its volume: "gain 2 gain target 0.5" where the arithmetic says 0.125;
  - V, no silence at a stop: "over the double, the pause: the host's call 39 on the graph is missing, and the page's arithmetic says "gain 2 gain cancel 1.57"";
  - W, a wave changed at once: "the host's call 23 on the graph is "oscillator 6 stop 0.31666666666666665", and the page's arithmetic says "gain 2 gain target 0 at 0.31666666666666665 tau 0.003"".
- `check_cartridge.ps1`: five cartridges, five sources, the replay and its golden as before; its control's thirty-two mutants, the three new ones (`"triangel"`, a note of 130, a volume of `"loud"`) failing by name. `check_web_offline.ps1`: the shim names none of the eight; its control's twenty-one mutants, each Web Audio name planted failing by its name.
- `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`, in 176 s, the loop check's control 108.3 s of it.
- The plain page's panel, probed headless with the autoplay flag over the module: the sound card picked, Sound on pressed (the button then reads Sound off), "Sound on: the Audio sheet's four voices sound on the audio clock, 50 ms ahead of it.", the frame line counting 4 frames sounded, 2 restarts and 12 skipped by frame 14, since under a virtual clock the frames come far faster than the audio clock, which is the wall's (the scoping's measurement); Pause, then Sound off ("Sound off."); no script error. The real context is made and driven; what it sounds like is the owner's to hear.

Corrected in the build, against the scoping:
- *The notice while the sound is off is said at the first frame a voice would sound*, "frame n: the Audio sheet's voices would sound now: press Sound on to hear them (...)", where decision 5 said it at the load. The double declares an Audio sheet, so a load-time sentence would have been said at every load of every case over it, about voices at volume 0; at the first frame a volume is above 0 it is true and said once a load. The `audio` case holds it with the sound off.
- *The start sounds the frame the grid holds only while the sound is on*, reading the Audio sheet then: an extra view at every load would have moved the thirteen cases' allocation and detachment counts, which this slice leaves exactly as they were.
- *A hidden page goes through `_visibility`*, which the listener calls and the oracle calls directly, since a page cannot set `document.hidden`.
- *A stop silences once*: a voice already silent since its last silence is left alone, so the second `stop()` an unload makes logs nothing.
- *An unload stops the oscillators ten time constants after the silence, and Sound off suspends the context after that release*, not at once, so the release is heard to its end.
- *A PowerShell trap, met in the control:* `$jS`, a mutant's judgment, was `$js`, the host's text the next mutant read, since names fold case; renamed.

The size, against the prediction (*measurement*, the diff's added lines): the host 242 against about 220; the page 336, the double, the arithmetic, the case and the panel, against about 450; the card's source 133 against about 170; the checks 160 against about 150. The writing took about half a day, against a day.

What remains is the owner's, in Chrome with the speakers on.
1. Open `web/index.html` (built) and pick the Sound card. The log says the voices would sound now, and to press Sound on.
2. Press Sound on. Hear the eight-second loop: A4 through the square, the triangle, the sawtooth and the sine, half a second each, with no click at a change of wave; C major up, each note starting cleanly after its rest; C major held for a second, then A minor; voice 2 sliding up two octaves while it swells and fades. The notes fall down the plane in each voice's colour.
3. Click the plane and press Z, or an arrow: a tick, a short sawtooth at C6, each press.
4. Write `(cell "Knobs" "B1" "saw")`: at the next press the log says voice 4's wave, Audio!B5, is "saw", not a wave, and the tick is silent; write `(cell "Knobs" "B1" "square")` and the tick is a square.
5. Press Pause: the sound stops. Press Run: it sounds again. Switch to another tab and back: silence, then the sound.
6. Write `(cell "Clock" "B2" 10)`: the loop plays at a third of its speed, each note longer; then `(cell "Clock" "B2" 30)`.
7. Press Sound off: silence, and the button reads Sound on.
8. `run_checks.ps1 -WithExtras`, `ALL GREEN`.
9. The commit at the owner's word, by `-F`, staged by hunk: `ENGINE.4: the Audio sheet's four voices sounded by the graph's own nodes on the audio clock, with a sound card`. Then the second slice: the offline render's measure and the card's replay.

*The owner's hand test, 2026-10-10, in Chrome with the speakers on, with a screenshot.*
- The sound card sounded after Sound on, its waterfall falling down the plane; the screenshot's frame line at frame 1893 reads "The sound: 1772 frames sounded, 4 restarts, 0 skipped.", and its log holds the notice of frame 1 that the voices would sound now, then "Sound on: ...".
- `(cell "Knobs" "B1" "saw")`, written at frame 1488: the tick silent, and at the next press, frame 1529, the log said "voice 4's wave, Audio!B5, is "saw", not square, triangle, sawtooth or sine; the voice is silent." `(cell "Knobs" "B1" "square")`: the tick again.
- Pause: silence; Run: the music again. Another cartridge picked: silence; the sound card picked again: the music, without Sound on pressed again, the sound being the page's switch and not a cartridge's (decision 5). And, beyond the steps, the browser's window left for another paused the page and silenced it: Chrome told the page it was hidden, and the hidden page is silent (decision 6).
- `(cell "Clock" "B2" 10)`: the music at a third of its speed; `(cell "Clock" "B2" 30)`: its own pace again.
- The tests pass.

*Owner-tested 2026-10-10; the first slice committed 2026-10-10 at the owner's word, "Tests pass; commit, then proceed with scoping and implementing slice 2 of ENGINE.4". Not pushed.*

*The second slice, scoped 2026-10-10 at that word, over `4244819` (the first slice's commit; two ahead of `origin/main` with the peer's `5ecfa38`) and `vla-lang` 0.8.1.* Decisions 8 and 10 stand as approved. The scoping fixes what they left open, and nothing in it is a new decision for the owner.
- *The sequence* (decision 8). One voice sounds at a time, so that a zero crossing is one voice's. Each state is held three frames over the double at its rate of 30, 48 frames after the start:
  - voice 1, a square at note 36, then 96;
  - voice 2, a triangle at 60, then a rest that keeps its oscillator, then the triangle again on it, the onset the approach must make clean over a wave already running, then a sine through the dip, then note 72 at volume 1;
  - voice 3, a sawtooth at 48;
  - voice 4, a sine at 84, then a triangle through the dip;
  - a rest between voices and to the end.
- *The windows.* Each frame is read between its own times on the page's arithmetic (`SoundModel` now keeps each frame's `at`), a millisecond inside each end, so that a frame at 30, 31.3 ms read, spans two periods of note 36 and holds a whole one between its crossings.
  - A frame is *settled* when its voice's gain and wave are the last frame's. A note changed alone is settled, the oscillator keeping its phase; its pitch and rms are held.
  - A rest is held only after a frame of silence. A release frame is the approach's and is not held.
  - A frame where a gain or a wave moves is held by its steps alone, against the larger of the wave's own steps before and after.
- *The waves' own.* They are rendered in a second `OfflineAudioContext`, a channel for each note and wave the sequence sounds (8), at gain 1: the rms over whole periods and the largest step, over 0.1 s to 0.45 s.
- *The wait.* `runLoopOracle` runs the cases in order and waits on a case that answers a promise, `sound`, the last; a watchdog of 15 s of the page's clock says a render that never lands.
- *The replay* (decision 10). The `audio` case records its run over the module and holds it equal to the committed replay; the replay case holds every frame of the card's replay to the card computed by hand, and its end to the golden.
- *The general player.* `cargo test` reads `cartridges/` at test time and plays every folder that holds a replay to its golden.
  - The seed is written only when the manifest says `(seed host)`, and is otherwise the manifest's, as the host has it.
  - Each frame's derived writes are read off the Write sheet as `_readWrite` reads them.
  - The list of replays played is pinned.

*During the build the owner relayed word of Frazaro's `KERNEL.26`, built but not committed: Life's soup about 5.0 ms a frame natively and 6.6 in headless Chrome, the gun about 20 µs. It breaks `tools/bench_frames.ps1`, which says "Cannot convert value NaN to Int64": the page's `?frames=1` times each frame alone by a 0.1 ms timer, the gun's median reads 0, and its row's cells a second is infinite. That is `CART.1`'s instrument and the pin move's, and is not this item's; the options went to the owner in the report, and the memory keeps them.*

*The second slice built 2026-10-10, over `4244819` and `vla-lang` 0.8.1, awaiting the owner's test.*

What landed:
- `web/index.template.html`:
  - the loop oracle's fifteenth case, `sound`: the host's own voices over the double, handed an `OfflineAudioContext` with the oracle's clock beside it, the sequence rendered and every frame held to decision 8's measure, the graph's own waves rendered beside it, the render paced by a chain of 0 ms tasks;
  - `runLoopOracle` waiting on a case that answers a promise;
  - `SoundModel` keeping each frame's time;
  - the sound card's log and its hand computation (`CARD_FRAMES`, `CARD_PRESS`, `cardRateAfter`, `cardRows`, `cardDiff`) moved out of the `audio` case, which now holds its run as recorded equal to the committed replay;
  - the replay case playing the sound card's replay to every frame of the card by hand and to its golden;
  - the card's two places and its entry, the panel's words on the card's replay, and the header's.
- `cartridges/soundcard/soundcard.replay.vla` (the licence line, the header, 240 frames, 18 of them written, 88 rows, the seed 1) and `soundcard.golden.vla` (the Log's record over `A1:M32`, 856 rows, the last 32 frames of the four voices). Both are the page's own output, built in scratch from the `audio` case's run. The header's digest equals PowerShell's SHA-256 of the card's LF bytes.
- `engine/src/cartridge.rs`: `every_committed_replay_plays_to_its_golden`, with `play_to_golden` and `derived_rows`, in place of the input card's own test (tests only; the module unchanged).
- `tools/check_host_loop.ps1`: fifteen cases, the floors of `sound`, of `replay`'s two replays and of `audio`'s recorded run; page X; the header's count of pages corrected, since the first slice had left it at eighteen.
- `tools/check_cartridge.ps1`: two replays and two goldens. `tools/run_checks.ps1`: the dated line and the controls' words.
- `SPEC.md`'s dated notes: §7.6, the second replay and the general player; §13, the measure. `README.md`, `web/README.md`, `engine/README.md`.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1 (*measurement*):
- `check_host_loop.ps1` at both ratios, fifteen cases, about 4 s a run. The first twelve's counts and digests are what they were.
  - `sound`: 49 frames sounded and rendered. 19 settled frames, each within 0.1% of its note's pitch and 4% of its rms: the worst 0.0052% and 0.06%. 17 rests, every sample 0 exactly. 8 frames where a gain or a wave moved, the worst step 1.00 times the wave's own, 2 of them a dip. 5 releases. 4 waves and 6 notes heard across a span of 60. The two renders took 1,140 to 1,791 ms of the page's virtual clock over six runs, printed as `renderMs` and never a floor; a run at either ratio took 4.3 to 4.4 s of wall time, as before.
  - `replay`: 2 replays, each played to its golden and recording itself; the sound card's 240 frames each the card by hand.
  - `audio`: the card's run as recorded is its committed replay.
- Its control, twenty-four mutant pages in 117.6 s, each failing for its own reason. Page X, the time constant written in milliseconds in the host and the page's arithmetic alike, passed `audio` and failed `sound` at its first settled frame: "the sound, frame 4 (voice 1, a square at note 36): its rms 0.0035, and the volume over four times the square's own 0.2119, 98.4% apart, over 4%". Its rests rang on too, a sample of 0.0158 where none reaches 0.0001.
- `cargo fmt --check` and `clippy --workspace --all-targets -D warnings` clean.
- `cargo test --workspace`: 27 passed, the general player among them, both replays played natively to their goldens, so the page's player and the engine alone end in the same Log. A golden with one value moved (`Log!C1` 57 to 58) failed it by name, "soundcard: the replay ends in its golden"; the file was put back byte for byte.
- `cargo run --release --example expand -- --check`: five sources, each `same`.
- `check_cartridge.ps1`: five cartridges, five sources, two replays and two goldens; its control's thirty-two mutants in 37.7 s.
- `check_web_offline.ps1`: the 2 replay and 2 golden places, each its file's; its control's twenty-one mutants.
- `run_checks.ps1 -WithExtras`: 12 checks and 12 verifiers, `ALL GREEN`, in 203.5 s, the loop check's control 117.8 s of it.

Corrected in the build, against the scoping:
- *The card's live run is held equal to its committed replay in the `audio` case,* where decision 10 put it in the replay case. The `audio` case runs after `replay`, and the order of the cases stays as it was. The replay case holds every frame of the card's replay to the card computed by hand, which holds more than a live run's frames would.
- *A frame where a voice's gain or wave moves is held by its steps alone,* and its pitch and loudness by the frames that hold the state. Decision 8 held "each frame's middle", but a dip leaves no settled span in a frame at 30: the switch comes 15 ms in, and the new wave settles 15 ms after that.
- *A release's steps are not held to 1.5,* decision 8 naming onsets. The approach to 0 adds the gain's own slope to a slow wave's: up to about 2.3 times a triangle's own step at note 36 (*derived*).
- *The rests measured 0 exactly,* where the scoping's 0.0001 had allowed for the approach's tail a frame later (*measurement*).
- *The check's virtual-time budget rose from 20 s to 60 s,* and the case's watchdog stands at 45 s. Decision 8 allowed the rise when a run needs it. The render's pacer spends the page's clock in step with the wall's, 1.1 to 1.7 s here, so a runner many times slower must not read as a failure. A passing run costs nothing more, since a page with nothing left to do skips to the budget's end: 4.4 s a ratio, as at 20 s.

The size, against the prediction (*measurement*, the diff's added lines): the page 244, the case, the wait, the card's hand computation moved and the replay's hold, against about 200; the engine's player 124, replacing 38, against about 80; the two files.

What remains is the owner's, in Chrome with the speakers on.
1. Open `web/index.html` (rebuilt), pick the Sound card and press Sound on.
2. Open The replay: the box holds the card's own replay, `cartridges/soundcard/soundcard.replay.vla`. Press Play the replay. The card loads again and plays its 240 frames, the frame line saying "Replaying frame n of 240":
   - the loop's first eight seconds;
   - a tick at the presses of frames 5, 20, 70, 130 and 200, and none at 105, while the knob says "saw", with the log's notice of it;
   - frames 150 to 159 at a third of the speed.

   It pauses at its end, and the log says so.
3. `run_checks.ps1 -WithExtras`, `ALL GREEN`.
4. The commit at the owner's word, by `-F`, staged by hunk, with the item's close: `ENGINE.4: the sound measured by an offline render, and the sound card's replay played to its golden`. The roadmap's line moves to the ledger's engine section, with dated notes on `CART.4` and `CART.5`.

*The owner's test of the second slice, 2026-10-10, in Chrome with the speakers on, with a screenshot.*
- The sound card's replay played from the box to its end, and passed the hearing test. The frame line at its end: "Replaying frame 240 of 240, ... The sound: 242 frames sounded, 2 restarts, 0 skipped." That is one start and one sounding more than the replay's own start and 240 frames: a second start of the timeline, after a late frame or the page shown again, either by design (decisions 1 and 6).
- The log, in order:
  - "Playing the replay of soundcard: 240 frames from the seed 1, at the cartridge's rate; a person's edits wait until it ends.";
  - frame 105's notice of the wave `"saw"`;
  - the rate at 10 from frame 150 and at 30 from frame 160;
  - "frame 240: the replay ended at its last frame; the loop is paused, and Run carries on from here with the live inputs."
- Seen in the screenshot, and not this item's: the live sheet below the plane showed `Clock!B1` at 234 while the frame line said 240. The panel refreshes the live sheet about five times a second while the loop runs, and nothing refreshes it when the loop stops, so a pause leaves it up to 200 ms behind. It was named to the owner and not fixed here. (*Fixed after the close at the owner's word, the same day:* the host says when a running loop stops, and the panel draws the sheet then; the note is at the end of `ENGINE.1`'s second slice above.)

*Owner-tested 2026-10-10; committed and closed 2026-10-10 at the owner's word, "Replay results attached as screenshot, and pass the hearing test. Commit, then proceed with your recommended fix for the timer fix (time several frames at once)": the second slice with the item's close, the roadmap's line moved to the ledger's engine section above. Not pushed.*

## `CART.2` — Sand: a falling-sand toy on the 320 by 200 Screen, a chain two hundred rows deep, measured against the charter's bar

*Scoped 2026-10-11 at the owner's word. Sand goes ahead of `CART.4` and `REPO.4`, which the earlier plan put first, for the reason in `docs/ALGEBRA.md` §11.7: it exercises the engine mechanics the spreadsheet needs, and Life does not. Life has depth one and reads only its twin. Sand is a chain two hundred rows deep that reads the live sheet. The gains `KERNEL.26` and `KERNEL.27` took on Life had left Frazaro's `chain` and `sums` fixtures flat. So Sand is the first game, and also the instrument that says which language mechanics to ask of Frazaro next. Its bar is the charter's test, 320 by 200 at thirty frames a second in the browser, chosen because it can fail it.*

*The scoping measured before it proposed anything:*
- *It wrote candidate rules as scratch cartridges, their formulas generated by a program.*
- *It stepped them from a scratch copy of this workspace over the same pin, natively and in headless Chrome, every frame held to a sand written by hand before any time was kept.*
- *A scratch copy of the language, with counters and timers added, split a frame into its parts.*

*Nothing in this tree changed before this entry. Frazaro's tree was read, never written, and only where this entry says.*

**Substrate, verified.** Read on the day, by file and never by assumption.

- *The pre-flight.* This tree is clean at `de31eea`, two commits ahead of `origin/main`: `ccf8b7c` filed `CART.6` to `CART.8`, and `de31eea` recorded the sitting of 2026-10-11. CI's run on `96fe7a5`, `38126957969`, is green on both jobs. `run_checks.ps1 -WithExtras` gives 12 checks and 12 verifiers, `ALL GREEN`, and `vla-lang` is pinned at `=0.9.0`. Frazaro is clean at `5607910`. It was read in three places: its registry, whose next free numbers are `KERNEL.28` and `VLA.4`; its roadmap's `KERNEL.20` line; and the four programs of `scripts/recalc/bench/`.
- *The language's step.* Read in `vla-lang` 0.9.0 as the registry holds it, the source the pin compiles: the headers of `calc/vector.rs`, `calc/reach.rs` and `machine/mod.rs`, then the code they name.
  - *The order* is by level, then shape, then cell, a cell's level being one past the deepest formula it reads. A run is a shape's cells on one sheet, consecutive in the order and reading none of one another, evaluated node by node in lanes of 256.
  - *Lane by lane:* operators, comparisons, `IF` (each branch at the cells that take it), and the aggregates the run has folded itself since `KERNEL.26`: `SUM`, `MIN`, `MAX`, `AND`, `OR` and `NOT`.
  - *Cell by cell:* a strict function (`ROW`, `COLUMN`, `MOD`, `INT`, `ABS`, `SIN`) is called at each cell with its arguments made there. `CHOOSE`, a defined name and a range where one value is wanted go to the evaluator one cell at a time.
  - *Reads.* A twin's read is an index into its array (`Dense`); only twins have one. A live sheet's formula cell is found by its position in a grid of positions and its value cloned. A range over a live sheet goes to the library at each cell.
  - *Reach.* A changed cell is followed to the cells that read it by each shape's references turned round. A part of a formula that is the same at every cell (a constant, a reference every `$` holds, and the operators over them) is compared once at the frame's start. That holds only when every cell it reads is a value cell or a twin's, and a call is never such a part.
  - *The frame's end.* The changed cells are copied into the twins while at most half the cells changed; otherwise every sheet is walked. The next frame is computed whole when more than half the order changed.
  - *Shapes.* A shared formula's shape is keyed by its master, so two fills of one formula are two shapes. Two plain cells of one R1C1 text are one shape.
- *The engine.* `Cartridge::load`, `write`, `step` and `view`, driven as `CART.1`'s runner drives them. No device Sand needs is missing, and the engine changes nowhere.
- *The host* (`web/host.js`). The Input sheet's eighteen rows carry what Sand reads: the pointer in the Screen's own cells; the three buttons, with the context menu suppressed over the plane; the wheel's notches; and the last key. A tick's steps may spend half the display's interval (`SLICE_FRACTION`, 0.5).
- *The checks.* `check_cartridge.ps1` pins five cartridges, five sources, one library, two replays and two goldens, with a row floor for each cartridge. `check_frame_floors.ps1` holds four rows, and every entry of its history must hold a floor for each of them; its allocation ceilings are 80 and 5 a fixture. The page holds four places a cartridge folder.
- *The machine of the measurements* is the owner's: an Intel Core Ultra 7 265KF under Windows 11 Home 10.0.26200, rustc 1.99.0, and Google Chrome 154.0.8037.98 headless.
  - Every timing ran on the performance cores, opted out of Windows' power throttling. For the runner that is its own process; for Chrome, its four flags and every one of its processes, as the instrument does it.
  - Beside every frame the reference's own step was timed as a clock. Spreads were 2 to 8%, drifts within 6%.

**The candidate rule.** A scan order down the board, as the charter has it (§4, §6), in two sheets. Its first rule: a sheet reads itself this frame only in the row beneath.

- *`Stay`* is one fill over the interior, saying whether the cell's occupant stays after the row's departures. Its row *r* reads `Stay`'s row *r*+1 this frame and `Screen.last`'s row *r*. A grain moves:
  - straight down, when the cell beneath is free;
  - else to its first diagonal, the side its direction names, when that cell is free and no grain falls straight into it;
  - else to the other diagonal, when that cell is free and taken neither straight nor by the grain whose first choice it is.
- *The direction* alternates by row, right first on an even row. Of the two grains that could take a cell on a diagonal, exactly one has it as its first choice. So a fixed priority settles every conflict, read from the last frame's row and this frame's row beneath, never from the row beside.
- *`Screen`* is one fill over the interior, holding the cell's material at the frame's end. Its row *R* reads `Stay`'s row *R* this frame, which is another sheet, so there is no cycle and no broken run. It also reads `Screen.last`'s rows *R*-1 and *R*.
  - A cell whose occupant stayed keeps it.
  - A free cell receives the grain above it; failing that, the grain whose first choice it is, from above on one side; failing that, the grain whose second choice it is.
  - The receiving cell chooses, and its choice is the grain's own move computed again. A grain moves at most once a frame and is never duplicated or lost.
- *The border.* Walls and empty never move. The interior is `C2:LF199`, 316 by 198 cells. The side walls are two wide, `A:B` and `LG:LH`, because the second choice's conflict reads two columns aside. Row 200 is the floor, and row 1 is empty, so nothing falls from it. `Stay`'s border holds 1, occupied.
- *The brush* is a disc, each of its rows read through a gate. A `Gate` sheet holds two cells a board row: the brush's column, and the square of the disc's half-width there (-999 and -1 outside its band). The test sits behind a part every `$` holds, `Input!$B$13+Input!$B$14=0`, so a frame with no button held evaluates no brush at all. A painted cell takes the brush's material, and its occupancy follows the paint.
- *Water, when it is in,* falls as sand does. A water grain that stayed then moves sideways one cell, into a free cell of its row, its direction's side first. The row's sideways moves are resolved in a third sheet, `Side`, between `Stay` and the row above. So the row above falls into the cells as the water left them.

A peer session's note, relayed by the owner during the measuring, proposed the rule the brief had already set, which every candidate keeps: within a frame, read only the row beneath, never the row beside. A row that reads itself collapses its lanes to one, and every cell then costs what `chain`'s does, at least 9 ms a frame natively. The measurement bears the prediction out: below, the chain costs 7% over the same work done flat.

**The measurements.** *Measurement*, 2026-10-11, on the machine above.

- *How the runner works.* A scratch runner loads each candidate through the engine's `Cartridge`. It writes the pointer's cells as the host writes them, steps with no budget, and times each frame alone. After each frame it views the plane and holds it to the reference. The reference is a sand written by hand, in which grains propose and receivers claim in three passes a row; it shares no predicate with the formulas. In every frame with no painting, the runner also holds each material's count to the frame before.
- *Every frame equalled the reference:* every frame of every run, well over ten thousand frames across the scenarios and variants below, water's among them.
- *The browser half* is a scratch page holding the engine's own module, 635,687 bytes, built from this tree's source over the same pin. It steps each case at its load and holds every frame to the native frame by a hash of its plane.

*What a frame costs, and what makes a frame whole.* The first candidate tested the brush at every cell, and alternated the direction by cell, `MOD(ROW()+COLUMN(),2)`. Frames 2 to 31, medians in ms:

| case | native | browser | cells changed a frame |
|---|---|---|---|
| the opening: Life's soup as sand, 3/8 of the interior | 17.8 (max 21.6); then 12.9, 8.0, 3.3 a second | 24.2 (max 27.4); then 17.5, 11.0, 4.5 | 26,035 falling to 4,592 |
| a soup of half the interior | 16.1 (max 20.0); then 11.1 | 21.9 (max 27.2); then 14.5 | 26,743 |
| a block of 99 full rows falling | 0.35 | 0.4 | 632 |
| a stream poured onto a pile, 600 frames | 0.04 | 0.05, the mean | 9 |
| the pile settling, 150 frames after 750 of pouring | 0.03 to 0.04 | 0.05 to 0.1, the mean | 2 to 4 |
| the brush moving, tested at every cell | 20.0 | 26.4 | 96 to 371 |
| the brush moving, gated a row | 1.1 to 1.3 | 1.5 to 1.9 | 96 to 371 |
| the pointer moving, no button, through the Brush cells | 0.02 | 0.02, the mean | 0 |
| the pointer moving, no button, read raw | 21.0 | 27.6 | 0 |
| the direction by the frame's parity: a soup; pouring | 19.4; 19.7 | 26.1; 27.6 | |
| one sheet, each cell its material and a flag for the cell above | 36.2 | 42.3 | |

What the table shows:
- *Coherent motion is nearly free.* Reach recomputes only what changed: a block falls as its two edges, a stream as its tip, and a pile's surface is a few cells a frame.
- *A noisy soup is the worst case.* It changes about half the board each frame, at the frame's-end line, so its frames are nearly whole. A solid block, which the brief's "full board falling at once" might also mean, is the cheapest motion of all.
- *Some terms make every frame whole.* A term that changes every frame, beside a call such as `ROW()`, reaches every cell every frame. The frame's parity, the raw pointer and a brush tested at every cell each turn a pour costing 0.04 ms into a whole frame of about 20.
- *The flagged single sheet* pays for `MOD` and `INT` around every read, calls made at each cell.

*Where a frame goes.* A scratch copy of the language with counters and timers ran the soup of half, frames 2 to 13, 18.3 ms natively:
- *Evaluating the runs:* 14.8 ms, 81%. That is 117,139 cells in 396 runs, two runs a level, 126 ns a cell. A frame makes 209,428 reads of the live sheet and 293,828 of twins. No cell was evaluated alone, and none cell by cell inside a run.
- *The frame's start:* 3.0 ms, 16%, marking the readers of about 30,000 changed twin cells.
- *The frame's end:* 0.57 ms, 3%, by the copy; the walk, at the first frame after the load, takes 5.1 ms.

The ablations, each changing the rule and so not held to the reference:

| ablation | ms | against 18.3 | what it shows |
|---|---|---|---|
| every this-frame read made a twin read: no chain, two runs, one level | 17.1 | 7% | the 200 levels and the live reads |
| the direction's three calls removed | 15.6 | 15% | the strict calls of the direction |
| the direction written through `CHOOSE` | 24.6 | +38% | 29,898 cells a frame evaluated cell by cell |

With `CHOOSE`, whole frames take 30.9 ms against 19.4, +60%.

*A cliff the cartridge must not write.* The same rule written one fill a row, as a macro walking rows would write it, makes 398 shapes where one fill a formula makes 4. Its frame's start takes 369 ms of a 387 ms frame, against 3 ms, since each changed cell is checked against every shape.

*The candidate, refined by the profile.* Three changes, each held to the reference in every case.
- *The guard.* The brush test is entered only while a button is held. The guard must read the Input sheet's value cells. A first version over `Brush!$B$1`, a formula, made every painting frame whole, as the reach header says it would. The opening went from 17.8 to 13.5 ms natively, −24%.
- *The codes.* Wall 1, sand 2 and water 3, so that "movable" is one comparison, `>=2`. Water −8%, sand unchanged.
- *The direction through a twin.* The direction is read from a sheet computed once, whose twin the rule reads as an index. Over a 64,000-cell sheet, the cell's parity went from 13.8 to 11.7 ms. Alternating by row, from a single column of 200 cells, `Parity!A1:A200`, it is 11.8 ms natively and the fastest in the browser.

The candidate the decisions recommend, frames 2 to 31:

| case | native | browser | cells changed a frame |
|---|---|---|---|
| the opening | 11.8 (max 16.7); then 8.4, 5.2, 2.2 a second | 16.3 (max 19.8); then 12.1, 7.7, 3.2 | 26,030 falling to 4,588 |
| a soup of half | 10.8 (max 14.2); then 7.5 | 16.2 (max 18.2); then 10.3 | 26,746 |
| the brush moving | 0.9 to 1.3 | 1.3 to 2.0 | 96 to 442 |
| the pile settling, 900 frames | 0.04 | 0.03 to 0.12, the mean | a few |
| water and sand, a quarter each | 20.4 (max 24.1); then 12.8, 6.4, 0.2 | 28.0 (max 33.0); then 18.6, 8.8, 0.3 | 33,346 falling to 80 |
| water poured, 600 frames | 0.2 rising to 1.4, the first candidate | 0.2 rising to 2.1 | 28 to 178 |

- *The profile of the candidate's opening,* 12.0 ms natively: evaluation 8.9 ms, 74%, at 76 ns a cell, with no function called at any cell; the frame's start 2.7 ms, 22%; the frame's end 0.4 ms. Water's frame, 22.7 ms, splits into 16.5, 5.5 and 0.65.
- *Formula cells:* 125,734 for sand and 188,302 with water. Sand's are `Stay` and `Screen`, 62,568 each, the gate's 396, the brush's 2 and the parity's 200.
- *The load* takes 386 ms natively and 457 in the browser, 669 and 785 with water. It computes the first frame in 35 and 40 ms.
- *Browser against native:* the browser takes 1.36 to 1.5 times the native runner, as Life takes 1.5.

*Water* was designed, held to the reference with conservation, and measured above. A soup of water and sand costs about twice a soup of sand, its third sheet in the chain making 597 runs. Its worst second, a quarter sand and a quarter water, is under the module's bar at the median (28.0 ms) and over it at its heaviest frames (33.0). Pouring water costs a few milliseconds.

*The host's slice.* *Derived*, since a headless page runs on virtual time and gives no real-time number (`ENGINE.2`'s finding).
- A tick's steps may spend half the display's interval. So a step of *s* ms completes every 2*s* ms of wall time, which presents 1000 ⁄ 2*s* frames a second, capped at the rate.
- The candidate's opening averages 16.7 ms over its first second, so the page presents it at about 30 frames a second, at the edge.
- Water's worst second, at 28 ms, is presented at about 18.
- With three quarters of the interval, steps up to 25 ms are presented at 30, and water's first second at about 27.

*The pass.* Four probes of `alonzo::pass::expand`:
- A macro whose expansion is a formula's text works as a row's argument, including from inside another macro's row.
- A bare `&expand` works as a row's argument and inside the library's `formulas`. So a formula can be written one part a line, with a comment on each.
- Nested primitives with parameters build addresses by arithmetic.
- A macro's text inside `&expand` is refused (`vla-expand-arg-is-list`, "argument 2 is a list"). So a rule cannot yet be composed from separately named predicates, which is the owner's principle applied at the formula's own level.

*The rest.*
- *Allocations,* counted as `CART.1`'s runner counts them: 89 in frame 2 and 27 in every steady frame, for the first candidate. The build counts the candidate's.
- *A debug build,* which `cargo test` runs, loads Sand in 1.8 s and steps a soup frame in 181 ms, eleven times release, and a painting frame in 9.3 ms.
- *`describe`'s budget row* says `(budget 30 125734 3772020 2000000)`, over the console's line. So the host says at load that the cartridge "will run slowly, in plain sight", which Sand does not. The line counts every formula cell every frame, while on Sand's worst frames the engine evaluates about 7 million cells a second in the browser.

**The bar, read.** The charter picked Sand because it can fail §3's floor, "every one of its 64,000 cells" working every frame through a chain two hundred deep. Measured, sand does not fail it. Reach computes only what changed, so a toy's typical frames cost tens of microseconds. The worst stretch measured, the opening soup, is stepped at 16.3 ms in the browser, 61 frames a second, and presented at 30 by the host as it stands. Water's first second is stepped at 28.0 ms (max 33.0): within the module's bar, and over the host's slice. The test could have failed and did not. That is the engine's work since `KERNEL.20`, seen through a game it was not tuned on. Most of the margin, though, came from the cartridge's own writing: the profile's three refinements took the opening from 17.8 ms to 11.8 natively. That is what decision 2 writes down.

**The census.** What the line asks, against what stands:

| what Sand needs | what stands | what is open |
|---|---|---|
| a chain of rows read this frame | the step in a topological order; runs a row wide; reach; the twins | nothing in the language: the chain costs 7% |
| the pointer, the buttons, the wheel, the last key | the Input sheet's rows (`ENGINE.3`); the context menu suppressed | nothing in the host |
| the board drawn | the plane and the Palette (`ENGINE.1`, `ENGINE.2`) | nothing |
| the bar | the module steps the worst stretch in 16.3 ms, and water's in 28.0 | the host presents water's at about 18 frames a second (decision 9) |
| a reference | Life's three | a sand by hand, in Rust and in JavaScript |
| the floors | Life's soup and gun: four rows, their history and their ceilings | Sand's two rows, a row entering the history, its ceiling |
| a replay | the recorder, the player, and the general players of the page and of `cargo test` | a session, and a golden that a Screen of formulas cannot be (decision 12) |
| a source | the pass, `common.vla`, `&expand` | a formula's parts named as macros (`vla-expand-arg-is-list`; decision 14) |
| the checks | the folder rule and the pins | six cartridges and six sources; three replays and three goldens |
| a repository | none | the last slice, at the owner's word (decision 15) |

**The work.** Four slices.

| File | What it is | Slice; decisions |
|---|---|---|
| `cartridges/sand/sand.source.vla`, `sand.vla` | the toy: `Stay`, `Screen`, `Parity`, `Gate`, `Brush`, `State` and `Tally` sheets and the Palette; the opening a soup from the seed; one `&expand` a formula, a part a line | 1; 1 to 8, 12 |
| `cartridges/common.vla` | if wanted, a macro for a wall's frame around a sheet | 1; 5 |
| a hand-written sand, in one file the engine's tests and the runner include; `engine/src/cartridge.rs`'s tests | the opening's first frames equal to the hand-written sand; a frame with no painting conserving each material; a painting frame's paint | 1; 13 |
| `engine/examples/frames.rs` | the sand fixture: 31 frames held to the hand-written sand, the clock beside them, its allocations in the check mode | 1; 11, 13 |
| `web/index.template.html` | Sand's four places and its picker entry; `?frames=1` stepping Sand held to the page's own sand | 1, 2; 11, 13 |
| `tools/bench_frames.ps1` | Sand's two rows in the block to paste | 1; 11 |
| `tools/check_frame_floors.ps1` | six rows; the fixture's digest; a row entering the history at a dated entry; Sand's allocation ceiling; the control's new cases | 1; 11 |
| `tools/check_cartridge.ps1` | six cartridges and six sources, then three replays and three goldens; Sand's row floor | 1, 2; 12 |
| `cartridges/sand/sand.replay.vla`, `sand.golden.vla` | the owner's painting session, and the `Tally` sheet's record at its end | 2; 12 |
| `web/host.js` and the loop oracle | the slice at three quarters, the oracle's own constant with it | 3; 9 |
| water in the source, both references, its floor row | `Side`, the material, its key | 3; 10 |
| `SPEC.md` | dated notes: what a rule costs (decision 2); the slice (decision 9) | 1, 3; 2, 9 |
| `CHARTER.md` §6 and §7, `ROADMAP.md`, `REARVIEW.md`, `README.md`, `engine/README.md`, `web/README.md`, `Delta/CLAUDE.md`, the memory | the measurement, the line, this record, the pages | 1 to 3; 16 |
| the game's repository | its own scoping, at the owner's word | 4; 15 |

**The decisions, the owner's.** Each with the sitting's recommendation and the alternative it declines.

1. **The rule: a scan order in two sheets, `Stay` and `Screen`, the receiving cell choosing by a fixed priority.** `Stay`'s row reads its own row beneath this frame; `Screen`'s row reads `Stay`'s same row and the twin. Measured, it equals the reference in every frame of every case and conserves every material; its worst stretch is 16.3 ms in the browser.

   *Alternatives:*
   - One sheet whose cells carry their material and the fate of the cell above: half the cells and no second sheet, but 36.2 ms natively and 42.3 in the browser, since its `MOD` and `INT` around every read are calls at each cell.
   - A synchronous rule over the last frame alone (the Margolus neighbourhood, or a pull rule), which leaves gaps in every falling column. It is the workaround of a substrate that can read only the last frame, which this one is not (`CHARTER.md` §6).
   - A rule reading the row beside, which can close a cycle the load refuses, and collapses a row's run (the peer session's warning, and the brief's).
2. **What a rule costs, written down as six rules a cartridge keeps.** They go into a dated note of `SPEC.md` beside §2's step, and into Sand's source. Each is measured above.
   1. A sheet reads itself this frame only in the row beneath; another sheet's same row is free.
   2. One fill a formula: 398 shapes made a frame's start 369 ms.
   3. No term that changes every frame, and no raw pointer, in a cell's formula. Each goes through a cell that holds still when idle, or every frame is whole.
   4. A test that is rarely true sits behind a part every `$` holds, over value cells or twins only: the guard, −24%.
   5. A value fixed for the grid's life is computed once and read through its twin, not called at each cell: the parity, −15% for sand and about −20% for water. No `CHOOSE` goes in a board's formula: +38%.
   6. A class of materials is one comparison: water −8%.

   *Alternatives:* the rules in Sand's source alone, where the next cartridge's author would not look; or none written, each cartridge finding them again.
3. **The direction: alternating by row, read from a column computed once through its twin.** `Parity!A1:A200` holds `=MOD(ROW(),2)`, and the rule reads `Parity.last!$A2=0`, right first on an even row. It uses no frame and no seed. Measured in the browser, the opening takes 16.3 ms with it, against 19.3 with the cell's parity computed at each cell, and 17.2 with the parity read from a sheet of the whole board.

   The column is part of the rule: an edit that breaks its alternation lets two grains claim one cell. Its header says so, as Life's rule says its border is dead. The brief's randomness over the seed, the frame and the cell becomes randomness over the seed and the cell, in the opening alone.

   *Alternatives:*
   - The parity computed at each cell: the simplest to read, and 15 to 26% dearer.
   - The frame's parity, which reaches every cell every frame: a pour at 27.6 ms in the browser against 0.05.
   - A direction drawn from the seed for each cell, which lets two grains choose one cell first and needs a rule that reads both.
4. **The materials and their codes: empty 0, wall 1, sand 2, and water 3 when it is in; the eraser paints empty.** "Movable" is `>=2`, one comparison.

   *Alternative:* sand 1, wall 2 and water 3, where "movable" is `OR(=1,=3)`, water 8% dearer.
5. **The board: the Screen itself, walls framing it.**
   - The interior is `C2:LF199`, 62,568 cells a sheet.
   - The side walls are two wide, since the second choice's conflict reads two columns aside.
   - Row 1 is empty above the interior.
   - Row 200 is the floor. Its occupancy is `Stay`'s row 200, so its Screen cells are read by no formula and can show the current material's swatch (decision 7).
   - The Palette maps the codes: 0 black, 1 a wall's grey, 2 sand, 3 water.

   *Alternative:* a `Board` sheet a Screen formula draws. It costs 62,568 more formula cells in a whole frame, and frees the Screen for a frame of any picture.
6. **The brush: a disc gated a row, entered only while a button is held.** The left button paints the material, the right paints empty, and the wheel sizes the radius from 1 to 8, in a cell anyone can read.
   - `Brush!B1:B4` hold the column, the row, the radius and the material; the column and the row are -999 while no button is held.
   - `Gate!A2:B199` hold, for each row, the brush's column and the square of the half-width.
   - A cell's formula is `IF(Input!$B$13+Input!$B$14=0, rule, IF(gate test, paint, rule))`.
   - Solid, no spray.

   Measured in the browser: the moving brush costs 1.3 to 2.0 ms, against 26.4 tested at every cell. The pointer moving with no button costs 0.02, against 27.6 for the raw pointer. A press and a release each compute one whole frame.

   *Alternatives:*
   - The test at every cell, or the raw pointer: whole frames.
   - The brush through the Write sheet into a `Paint` sheet of values. It would reach only the brush's cells, but a frame late, with the address's letters made by `CHOOSE`; named, not measured.
   - A spray, a hash of the frame behind the gate, which reaches the brush's band every frame; named, its cost the moving brush's.
7. **The material: picked by the number keys through the Input sheet's `key` row.** A `State` cell keeps it over its twin, and a swatch in the floor row shows it. The keys: `1` sand, `2` wall, `3` water when it is in, `0` empty.

   *Alternatives:*
   - A strip of swatches the pointer clicks, which takes rows of the Screen and a second gate.
   - The Keys sheet's buttons cycling the material, which hides the choice behind a count of presses.
8. **The opening: Life's soup as sand, the floors' fixture.** The first frame is a soup from the seed, by Life's own arithmetic and threshold: 3/8 of the interior, the cells alive in Life's first frame being Sand's grains. The toy opens raining sand. That is the heaviest stretch measured: 16.3 ms in the browser, then 12.1, 7.7 and 3.2 a second as it settles. The floors measure its first thirty frames, a stretch a person reaches only by filling the board.

   *Alternative:* the toy opens empty and a second cartridge holds the soup, as the gun does beside Life, with a test holding the two rules to one text.
9. **The rate is 30.** The host's slice stays at half the display's interval for sand, and rises to three quarters with water's slice. As the host stands, it presents sand's worst stretch at about 30 frames a second. Water's first second, stepped at 28 ms, it would present at about 18; at three quarters, at about 27. The change is a dated correction of `SPEC.md` §5 step 4 and of the host's constant, with the loop oracle's own constant beside it.

   *Alternatives:* the slice raised now, with nothing yet that needs it; or never raised, water's first second presented at about 18 and said so.
10. **Water: the third slice, measured into the floors, its first second stated.**
    - The rule above, with a third sheet, `Side`, and its row in the floors beside sand's.
    - Its bar is printed as a distance, and becomes a gate once crossed, as `CART.1`'s bars did.
    - Its worst second is stepped under the bar, at 28.0 ms, and presented at about 27 frames a second with decision 9.

    *Alternatives:*
    - Deferred to an item of its own, `CART.9` (the next free), until a language ask lands.
    - A sideways rule over the last frame alone: one sheet fewer, and a water that waits a frame to spread (named, not measured).
    - Water in the first slice, before sand's floors stand.
11. **The floors: Sand's two rows beside Life's, the opening's frames 2 to 31, natively and in the browser.**
    - `check_frame_floors.ps1` lets a row enter the history at a dated entry, every later entry holding it.
    - Sand has an allocation ceiling from the runner's count.
    - The fixture's SHA-256 over LF bytes is held with the others.
    - Sand clears 30 frames a second at its first floor, so that bar is a gate from that entry on.

    *Alternatives:* Sand timed by an instrument of its own, outside the floors and their history; or floors on a scenario of painting, which measures the gate and not the chain.
12. **The replay and its golden: the owner's own painting session of about ten seconds, recorded in the page at the first slice's hand test; its golden a `Tally` sheet.**
    - `Tally` has a row for each board row: the sum of the row's codes and the count of its occupied cells. It reads them from the twins `Screen.last` and `Stay.last`, which the run folds as arrays.
    - With the codes of decision 4, the settled board's counts of sand and walls are exact for each row. With water, they are a checksum.
    - Its record is about 25 KB, compared whole after the session ends with the board settled.
    - The page's oracle holds every frame of the replay to its own sand, and `cargo test` plays the replay natively to the golden.

    *Alternatives:*
    - A window of the Screen, whose every cell prints its formula's text, about 1.3 KB a cell with the guard: half a megabyte for 20 by 20.
    - The loop oracle's scripted session, reproducible by its own script, but no person's painting.
13. **The references: one sand by hand in Rust, in one file the runner and the engine's tests both include, and one in JavaScript in the page.** That gives two references and the engine, where Life has three references outside it.

    *Alternative:* the Rust sand alone, the page held to the native frames' hashes, as the scoping's page was. That is lighter, but it holds the module to the runner rather than to a rule.
14. **What to ask of Frazaro: one item now, minted by its registry's next free number (`KERNEL.28` today): the language's remaining functions lane-wise in a run.**
    - *The ask:* `ROW`, `COLUMN`, `MOD`, `INT`, `ABS` and `SIN` computed over a run's lanes, bit for bit, as `KERNEL.26` computes the aggregates, and `CHOOSE` over lanes. It follows `KERNEL.26`'s own choice, where the owner's call had the aggregates re-implemented for the run and left every other function to the library at each cell.
    - *Sand's evidence:* a rule written plainly pays 15 to 17% of its worst frame for the parity, 26% with water by the ablation, and 38% if it uses `CHOOSE`. The cartridge works around it with a column read through its twin, which the item would make unneeded.
    - *What it moves:* all three of Frazaro's recalc fixtures, which meets the owner's criterion of 2026-10-11, a mechanic Sand found that pays the spreadsheet:
      - `column`'s A, `=ROW()` over 20,000 cells;
      - `chain`'s A, `=MOD(ROW()*7,13)` over 19,999;
      - `sums`' B to M, `=MOD(ROW()*31+COLUMN()*17,97)+$P$1` over 24,000;
      - and Life's opening soup.

    *Named, not asked:*
    - *The frame's start,* 22 to 24% of Sand's worst frames, marking the readers of tens of thousands of changed twin cells. It moves none of the three fixtures, whose edits reach through a part or a short list; a pasted column would show it.
    - *One formula's fills as one shape,* `KERNEL.20`'s ground of content addressing. It moves no fixture, each being one fill a formula; Sand avoids the cliff by decision 2.
    - *A macro's text inside `&expand`,* by the next free `VLA` number (`VLA.4` today), so that a rule's predicates are named macros. It moves no fixture, being expand time.

    The prompt for the Frazaro session is given in the chat at the approval and kept nowhere on disk.

    *Alternatives:* nothing asked until this item closes; or all four asked together.
15. **Where the code lives: here, under `cartridges/sand/`, through the first three slices; the game's repository founded as the last slice, at the owner's word, with its own scoping.**
    - Until then the files live here, since a floor's fixture lives beside the check that reads it (`CHARTER.md` §7).
    - The repository depends on Alonzo by git revision, the route `ENGINE.1`'s second slice took with `vla-lang` before its release, and on `vla-lang` from crates.io at the same pin.
    - `AD-1`'s `cargo tree` check runs in its CI.
    - When `alonzo` is published (`REPO.4`), the pin moves to the registry, as Alonzo's own did.
    - The release, and with it the quarter of `CHARTER.md` §6's prediction, is the owner's.

    *Alternatives:* `REPO.4` first, so the repository pins a published `alonzo` from its first commit; or the repository founded now, before the toy stands.
16. **The slices, the checks and the bookkeeping.**
    - *Slice 1, the toy and its oracle:* decisions 1 to 8, 11 and 13, with decision 12's `Tally`. `check_cartridge.ps1` goes to six cartridges and six sources, and `check_frame_floors.ps1` to six rows; `run_checks.ps1`'s floor stays at 12 and 12. Then the owner's hand test, and the owner's run of `tools/bench_frames.ps1`, pasted as the floors' fourth baseline.
    - *Slice 2, the replay:* decision 12, from the owner's session of the first slice's hand test.
    - *Slice 3, water:* decisions 9 and 10.
    - *Slice 4, the repository:* decision 15, with its own scoping.
    - The roadmap's line goes to 🟡 at the approval. It leaves for the ledger at the third slice's commit, since the fourth, a repository's founding, is one the owner may hold back.
    - The host's load sentence over the budget line becomes "may run slowly", since Sand does not, a dated correction of `ENGINE.1`'s.
    - The commits are made at the owner's word, by `-F`, staged by hunk.

    *Alternative:* one slice for the toy and its replay together, the replay recorded before the floors stand.

**The catch.** Each met once in the scratch work, or foreseen by reading.
- A part compared at the frame's start must read only value cells or twins; one that reads a formula makes the shape whole at every change. The guard over `Brush!$B$1` made every painting frame whole until it read `Input!$B$13`.
- A frame-dependent term, or the raw pointer, beside a call such as `ROW()` reaches every cell every frame, and nothing says so but the frame's time.
- Each fill is a shape of its own, so a source whose macro writes a fill a row pays at the frame's start in proportion to its shapes.
- `CHOOSE` and every strict function are cell by cell inside a run. Operators, comparisons, `IF` and the aggregates are not.
- The view record prints each formula cell's text, so a Screen of formulas cannot be a golden: hence the `Tally`.
- A debug build is eleven times slower. `cargo test`'s sand cases step a few frames, and the replay is about ten seconds.
- The loop check's control plays every committed replay on each of its mutant pages, so a long replay multiplies its time by the number of pages.
- `check_frame_floors.ps1` requires every row in every entry, so a new row needs the rule changed first, and its control needs a case for it.
- The engine's tests include the sand cartridge as they include Life's, one more file for the gap `REPO.4`'s first note counts.
- The parity column, the gate and `Stay` are parts of the rule that a person can edit and break; each sheet's header says what holds it.
- The fixture's digest is over LF bytes, while the cartridge is CRLF on checkout.
- PowerShell 5.1, as every check has met it, with one trap more: an array passed through `powershell -File` arrives as one string.
- The tree is shared: `REARVIEW.md`, the roadmap and the page are staged by hunk, HEAD plus this item's own.

**Oracle.** On the owner's machine under Windows PowerShell 5.1, then on both jobs.
- `cargo fmt --check`, `clippy --workspace --all-targets -D warnings` and `cargo test --workspace`. The tests:
  - the opening's first frames equal to the hand-written sand;
  - a frame with no painting conserving each material;
  - a painting frame's paint;
  - the pass's golden over six sources;
  - in slice 2, the replay played to its golden;
  - in slice 3, water's frames.
- The runner over Sand: 31 frames, each equal to the hand-written sand, the clock beside them, and its check mode's allocations at the ceiling.
- `?frames=1` under headless Chrome: Sand's frames equal to the page's sand.
- `check_frame_floors.ps1`'s control, its new cases among the rest, each mutant failing for its own reason. The check itself fails on the missing rows until the owner's paste.
- `check_cartridge.ps1` and `check_web_offline.ps1`, with their controls.
- `check_host_loop.ps1` at both ratios, its replay case over Sand's replay in slice 2.
- `run_checks.ps1 -WithExtras`: `ALL GREEN`.
- The owner's hand tests.
  - *Slice 1:*
    - open the page and pick Sand, and watch the opening rain and the frame line through it;
    - paint sand with the left button, walls after `2`, and empty with the right;
    - turn the wheel;
    - open `Stay`, `Parity` and `Tally` in the sheet picker;
    - run `tools/bench_frames.ps1`, and paste its block.
  - *Slice 2:* play the replay.
  - *Slice 3:* pour water into a basin of sand.

**Size.** `~weeks`, as the roadmap has it (*prediction*).
- *Slice 1,* about two days: the source about 250 lines, the Rust sand about 200, the page's about 180, the runner's fixture about 150, the page's mode about 120, the checks about 250, and the pages.
- *Slice 2,* about half a day.
- *Slice 3,* about a day.
- *Slice 4,* its own scoping.

*Scoped 2026-10-11; the sixteen decisions await the owner.*

*Approved 2026-10-11, the same day, all sixteen, in the owner's words: "Recommendations approved; proceed with implementing CART.2 as scoped." The roadmap's line went to 🟡 the same hour. Decision 14's prompt for the Frazaro session was given in the chat and is kept nowhere on disk; `KERNEL.28` was still its registry's next free number, at Frazaro's `5607910`. The first slice is built first: decisions 1 to 8, 11 and 13, with decision 12's `Tally`.*

*The first slice built 2026-10-11, over `de31eea` and `vla-lang` 0.9.0, awaiting the owner's test. A peer session filed the kit (`KIT.1` to `KIT.4`) and `ENGINE.7` in `ROADMAP.md` during the build, uncommitted; this slice takes none of those hunks.*

What landed:
- `cartridges/sand/sand.source.vla` (203 lines) and the cartridge the pass writes, `sand.vla`: 81 rows, 4,697 bytes, 128,420 cells, 126,449 of them formula cells in 13 shapes.
  - The header says how to play, what the board is, the rule in words, and decision 2's six rules.
  - Sheets: `Screen`, `Stay`, `Parity`, `Brush`, `Gate`, `State`, `Tally` and the Palette (0 empty, 1 wall, 2 sand, 3 water for the third slice, then the CGA's).
  - Every formula is one `&expand`, a part a line, each with a comment.
- `engine/src/sand.rs` (212 lines), the sand by hand.
  - Each row's grains propose, from the bottom row up, and the cells beneath them claim, in three passes.
  - `opening`, Life's soup as grains; `step`, which returns the board and the `Stay` sheet together; `counts`; `tally`.
  - Compiled for the tests alone (`lib.rs`), and included by the runner by its path.
- `engine/src/cartridge.rs`, two tests:
  - *the opening*: frames 1 to 4, the Screen and the `Stay` sheet each equal to the sand by hand, every grain kept, the `Tally` the last frame's sums, the rule 13 shapes, and `describe`'s budget;
  - *the brush*: nine frames of a session, each the sand by hand's.
- `engine/src/pass.rs`: the golden's floor is six sources.
- `engine/examples/frames.rs`: Sand is the third default fixture, held to the sand by hand, its grains kept every frame after the first. Its check row adds `(conserved n)`.
- `web/index.template.html`:
  - Sand's two places, its entry and the picker's option, and the panel's sentence;
  - `sandEmpty`, `sandOpening` and `sandStep`, the page's sand;
  - `?frames=1` over three fixtures, each held to its own rule.
- `web/host.js`: "it may run slowly" (decision 16).
- `tools/check_frame_floors.ps1`:
  - six rows;
  - a row enters the history at the first entry that holds it, every later entry holds it, and the latest entry holds every row;
  - Sand's fixture and its allocation ceiling, 509 and 5;
  - the runner's check over three fixtures, Sand's grains held;
  - the control, 33 cases.
- `tools/bench_frames.ps1`: three fixtures, six rows, Sand's digest in the block.
- `tools/check_cartridge.ps1`: six cartridges and six sources, and Sand's floor of 81 rows.
- `tools/check_host_loop.ps1`: the `pass` case's floor is 6 sources.
- `tools/run_checks.ps1`: the dated line and the verifiers' words.
- `SPEC.md`: §2's note, the six rules of decision 2, and §4.6's correction (decision 16).
- `CHARTER.md`: §6's measurement and §7's line.
- `README.md`, `engine/README.md` and `web/README.md`.

The oracle, run on the day on the owner's machine under Windows PowerShell 5.1 (*measurement*):
- `cargo fmt --check` and `clippy --workspace --all-targets -D warnings` are clean.
- `cargo test --workspace`: 29 passed in 3.6 s, and the pass's golden holds six sources. The module is unchanged at 635,687 bytes, since the sand by hand is the tests'.
  - *The opening*: the budget row `(budget 30 126449 3793470 2000000)`. At frame 4 the `Tally` holds frame 3's sums in all 198 rows.
  - *The brush*:
    - frames 2 and 3 paint sand, at radius 3 and then 5 after two notches away;
    - frame 4, the right button, paints empty;
    - frame 5, the key `2` alone, paints nothing and keeps every grain, and the floor turns grey;
    - frame 6 paints walls at radius 4;
    - frame 7 paints a wall at the interior's corner, `LF199`, at radius 1, the disc clipped by the floor and the wall;
    - frame 8, the key `0`, again paints nothing;
    - frame 9 paints empty with the left button;
    - frame 10 holds the left button with the pointer off the Screen and paints nothing, while the key `1` picks sand back and twenty notches stop the radius at 8.
  - A mutant of the sand by hand, the disc's edge `<` where it is `<=`, failed at frame 2 at `CY60`, the disc's rightmost cell, and the file was put back.
- `cargo run --release --example expand -- --check`: six sources, each `same`.
- The runner's check mode: Life and the gun at 80 and 5, as before. Sand: 4 of 4 frames equal, every grain kept in 3, and 509 allocations and 5 reallocations in its second frame, the same on three runs.
- The runner over the three fixtures, opted out and on the performance cores. *This is my run, not the floors'.* Sand's opening, frames 2 to 31: a median of 11.9 and 11.7 ms in two runs (10.0 to 15.2), its load 305 and 287 ms. The scoping's candidate had 11.8 ms.
- `tools/bench_frames.ps1 -NoBuild` end to end. *My run, and its block was not pasted.* It prints `frames ok`, three cartridges, every frame equal to the page's Life or Sand. Sand's opening in the browser: a median of 17.0 ms (14.4 to 18.9), 58.7 frames a second.
- An A/B in the scoping's scratch page, one Chrome, two runs, frames 2 to 31:

  | cartridge | ms |
  |---|---|
  | this slice's | 16.75, 16.80 |
  | the scoping's candidate | 16.70, 16.75 |
  | this slice's without its `Tally` | 16.25, 16.55 |

  So the rule written once costs nothing, and the `Tally` costs 2 to 3% in the browser. Its load is 300 to 306 ms against the candidate's 456 to 461.
- `check_frame_floors.ps1` reports five problems, each Sand's missing measurement:
  - the baseline names no digest for `sand`;
  - the latest floor entry has no floor for `native sand` or `wasm sand`;
  - the two rows are missing from the baseline.

  It reports nothing else, and with the runner it holds the three fixtures within their ceilings. Its control: 33 cases. Six tables pass and seventeen mutants fail; the history passes two and fails two; of six fake runners one passes and five fail.
- `check_cartridge.ps1`: six cartridges, its control's 32 mutants. `check_web_offline.ps1`: six cartridge places and six sources, its control's 21 mutants.
- `check_host_loop.ps1` at both ratios: every case OK, `pass` with 6 sources the same and 585 rows. Its control: 25 mutant pages in 71.6 s.
- `run_checks.ps1 -WithExtras`: 12 checks, 11 passed, and `check_frame_floors.ps1` failing on Sand's missing rows as designed; 12 verifiers passed.

Corrected in the build, against the scoping:
- *The guard is written once.* The candidate wrote `IF(guard, rule, IF(test, paint, rule))`, the rule twice. The slice writes `IF(IF(guard, FALSE, test), paint, rule)`. `IF` partitions its lanes by its condition, so while no button is held the condition is `FALSE` at every lane and no test is made. The A/B above measures no difference. `Stay`'s formula row is 422 characters against the candidate's 752, and the Screen's 835 against 1,215.
- *The guard reads both buttons* (`Input!$B$13+Input!$B$14=0`), as decision 6 has it.
  - The brush's column and row are -999 while the pointer is off the Screen too, since the host writes 0 there, and a disc at row 0, column 0 reaches `C2` from radius 4.
  - The host also lets the buttons go when the pointer leaves the canvas.
- *The swatch is the floor's whole interior row*, `C200:LF200 = State!$B$1`. The floor is sand-coloured with sand picked, grey with walls and black with empty.
- *The radius and the material start from the Clock's frame*, 3 and sand, a cell each. Each is computed every frame and reaches nothing while unchanged. These are rule 3's cells that hold still.
- *The `Tally` covers the interior's rows, 2 to 199*, its labels `codes` and `occupied` in row 1, where the board has nothing.
- *No library macro for the walls.* The kit's ratchet, noted the same day at the owner's word (`ROADMAP.md`), moves a pattern into the library at its second appearance, and Sand's walls are its first. So decision 5's "if wanted" is not wanted.
- *The sand by hand returns the `Stay` sheet with the board*, so the engine's tests hold both of the rule's sheets and the `Tally`. The runner and the page hold the Screen.
- *The allocation ceiling is 509 and 5*, where the scoping counted 89 at frame 2 for its first candidate. The count is this cartridge's; it was not traced further. The ceiling pins it, and a lowering would be a later finding.
- *The engine's tests now include eight files of `cartridges/`*, Sand's cartridge among them: one more for the gap `REPO.4`'s first note counts.
- *A trap of my own, caught by the instrument.* A `perl` substitution delimited by `|` read the pattern's `\|\|` as an empty alternative. It matched at the file's start, and put the line declaring `sandText` before `<!doctype html>`.
  - The offline check and the build passed it.
  - Under headless Chrome the text before the doctype moved the template's header comment into the body. The instrument read that comment's `<pre id="frames">` first and printed no rows.
  - The line was moved, every diff of the slice was read again, and the run was repeated.

The size, against the prediction (*measurement*, the diff's added lines):

| part | added lines | predicted |
|---|---|---|
| the source | 203 | about 250 |
| the Rust sand | 212 | about 200 |
| the engine's tests | 182 | not predicted apart |
| the page's sand and its mode | 79 | about 300 |
| the runner's fixture | 45 | about 150 |
| the checks and the instrument | 142 | about 250 |

The writing took one sitting, against about two days.

What remains is the owner's, in Chrome.
1. Open `web/index.html` (built) and pick Sand.
   - The log says "Loaded Sand: a 320 by 200 plane at 30 frames a second, seed 1, ...".
   - Then: "The budget: 126,449 formula cells a frame at 30 frames a second, 3,793,470 a second, over the console's line of 2,000,000: it may run slowly, in plain sight."
   - The opening rains sand, three eighths of the board falling at once, and settles into piles in a few seconds; the floor is sand-coloured. Watch the frame line through it.
2. Click the plane and paint sand with the left button: a disc of radius 3 where the pointer is, falling as it is painted.
   - Turn the wheel away from you: the brush grows to 8. Turn it towards you: it shrinks to 1.
3. Press `2` and paint walls; the floor turns grey, and sand piles on the walls.
   - Press `0`: the floor turns black, and the left button paints empty.
   - The right button erases whatever is picked.
   - Press `1` to paint sand again.
4. Pick `Stay`, `Parity` and `Tally` in the sheet picker.
5. For the second slice, record the painting session (decision 12):
   - press Load the cartridge with Sand picked;
   - paint for about ten seconds while the soup falls and after;
   - wait until nothing moves;
   - press Copy the replay, and keep the text, pasted into the chat or into a file.
6. Run `tools/bench_frames.ps1`, and paste its block from `target/bench_frames.txt` into `tools/check_frame_floors.ps1` whole: the baseline lines over the baseline, the history over `$floorHistory`. This is the floors' fourth baseline, and Sand's rows enter the history. Then `run_checks.ps1 -WithExtras` is `ALL GREEN`.
7. The commit at the owner's word, by `-F`, staged by hunk: HEAD plus this slice's own, the roadmap's `CART.2` hunk among them and the peer's kit hunks left. The title: `CART.2: Sand, a falling-sand toy on the 320 by 200 Screen, every frame held to a sand by hand and its opening measured into the floors`.

*The owner's run, 2026-10-11, evening.*
- *The painting session*, recorded in the page and handed over in the chat for the second slice: a replay of 781 frames, 165 of them written.
  - The wheel was turned away fifteen notches, so the radius stopped at 8.
  - Sand was painted twice; then `2` and walls; then `1` and sand again.
  - The pointer left the plane at frame 317.

  A scratch player over the engine played it whole, every write landing:
  - the plane last changed at frame 619;
  - at its end the `Tally` counts 27,731 grains of sand and 197 cells of wall;
  - its record of `A2:B199` is 31,950 bytes;
  - in a debug build it took 1.9 s to load and 11.9 s to step, which is the second slice's cost to `cargo test`.

  It is kept in the session's scratchpad until the second slice commits it.
- *`tools/bench_frames.ps1`*, its block pasted whole: the fourth baseline. Sand's opening measured 12.0 ms natively (10,552,014 cells a second, 83.4 frames a second) and 16.7 ms in the browser (7,571,796, 59.9). `check_frame_floors.ps1` refused the entry: the floors of native life and the native gun went down with no reason written.
- *The finding.* Life's native row measured 3.1 ms against the third baseline's 2.8, and the gun's 20.4 µs against 15.2. The code is the code the third baseline measured: nothing under `engine/`, `Cargo.toml` or `Cargo.lock` changed after `96fe7a5`, its commit at 02:02.
  - An A/B that evening set HEAD's runner, built in the scoping's scratch copy of this workspace (its engine, runner, manifest and lock HEAD's), against the slice's. They alternated three times, opted out of throttling and on the performance cores:

    | | HEAD's runner | the slice's runner |
    |---|---|---|
    | Life | 3.1, 3.2, 2.9 ms | 3.1, 3.3, 3.2 ms |
    | the gun | 24.9, 25.7, 21.5 µs | 26.9, 22.2, 23.8 µs |

  - The clock beside every frame read 0.181 to 0.182 ms, the third baseline's own.
  - The browser's rows were the third's: Life 4.2 against 4.3 ms, the gun 0.0609 against 0.0613.
  - The processes sampled used about a fifth of a core each.

  So the slice did not move them, and the clock does not see what did. Nine runs of the gun's native frame that evening read 17.6 to 26.9 µs. A frame of 20 µs varies between sessions by more than the floors' 10% margin, which `CART.1` measured on frames of 100 ms. Native life's floor, kept below, holds this run by 0.7%, and four of the evening's nine runs measured under it, so the next baseline may meet the same finding.
- *The instrument's defect*, this slice's to own, since its instruction was to paste the block whole.
  - `bench_frames.ps1` printed every row's floor as the run less 10%. So a run slower in any row lowered that row's floor, which the check refuses with no reason written.
  - Every earlier baseline was faster in every row, so none met it.
  - The instrument now prints the higher of the latest floor and the run less 10%, and names a row measured under its latest floor, a finding and not a baseline.
  - Tested on the owner's rows and the committed history: native life kept at 20,200,000; the native gun kept at 3,710,000,000 and named as under it; both wasm floors raised; Sand's entering.
- *At the owner's word* ("Keep run, lower gun"), the fourth entry:
  - keeps native life's floor at 20,200,000, which the run clears;
  - lowers the native gun's to 2,770,000,000, its reason written in the entry;
  - raises wasm life's to 13,600,000 and wasm gun's to 929,000,000;
  - enters Sand's at 9,490,000 natively and 6,810,000 in the browser.

  Sand clears the charter's thirty frames a second at its first floor, 75 and 54 frames a second, so that bar is a gate for it from this entry on (decision 11). `check_frame_floors.ps1` is clean, and `run_checks.ps1 -WithExtras` reports 12 checks and 12 verifiers, `ALL GREEN`.

*The first slice committed 2026-10-11 at the owner's word, after the run above: "Commit, then suggest next steps (also numbering the remaining slices in CART.2)". The roadmap's line numbers the four slices. Not pushed.*

*Pushed 2026-10-12 at the owner's word, `96fe7a5..11a61c1`, with `ccf8b7c` and `de31eea`. CI run `38215740585` is green on both jobs: crate in 5m31s, ratchets in 8m21s. On Linux, `cargo test` passed 29, and the floors' check passed with its runner, so Sand's frames equal the sand by hand there and its allocations fit the ceiling Windows measured. The run's one annotation is Node 20's deprecation for `actions/checkout@v4`.*

*2026-10-12, at the owner's word: the floors' margin for microsecond frames, met at the fourth baseline above, is fixed in the native runner and the instrument; the record is `CART.1`'s, "The native frame timer". Native Life's own scatter, from the clock read before each frame, is left there for the owner.*

**Slice 3, water: its scoping.**

*Scoped 2026-10-12 at the owner's word: "Fix the floors' margin for microsecond frames, then proceed with scoping slice 3 of CART.2". Decisions 9 and 10 set the slice's ground: water through a third sheet, `Side`, its row in the floors beside sand's, and the host's slice raised to three quarters of the display's interval. The scoping measured before it proposed:*
- *It wrote the rule into a scratch copy of the tree at `11a61c1`, with the day's margin fix, and a scratch sand by hand with water.*
- *Every frame of every case was held to that sand natively, on the Screen, `Stay` and `Side`, before any time was kept.*
- *The browser half is the item's scratch page again: the engine's own module, 635,687 bytes, holding every frame to the native frame's hash.*

*Nothing in this tree changed for it.*

**Substrate, verified.** Read on the day, by file.
- *The cartridge* is as slice 1 landed it:
  - `Stay` and `Screen`, one fill each over `C2:LF199`;
  - the Palette's index 3 already "water, to come", `#3060E0`;
  - `State!B1` reading the keys 1, 2 and 0;
  - 81 rows and 126,449 formula cells, in 13 shapes.
- *The host.* `web/host.js` holds `SLICE_FRACTION = 0.5`, the share of the display's interval a tick's steps may spend. `SPEC.md` §5 step 4 says "a fraction of the display's interval that leaves room for the draw" and names no number.
- *The loop oracle* prints the host's rule, `slice=0.5`, and holds no slice of its own: every case drives the host by a budget of cells or a count of calls. So decision 9's "the loop oracle's own constant beside it" has nothing to stand beside yet (decision 20).
- *The replay* names the SHA-256 of the cartridge it was recorded from.
  - The page's player refuses another cartridge: "a replay plays only on the file it was recorded from".
  - `check_cartridge.ps1` holds the digest to the cartridge beside it.
  - `cargo test`'s player reads the seed and not the digest.

  So a slice that rewrites `sand.vla` meets any replay recorded on slice 1's (decision 22).
- *The floors* hold six rows, Sand's fixture digest and Sand's allocation ceiling, 509 and 5. Since today the native runner times a frame under 2 ms in runs, and the instrument re-bases a row whose timing changed (`CART.1`'s record, "The native frame timer").
- *The language.* The pin is `vla-lang` 0.9.0. Frazaro's `KERNEL.28`, decision 14's ask, was committed as `ec369a5` the same day and ships in 0.9.1 at the owner's release, as Frazaro's session reported it, relayed by the owner. A run now computes `ROW`, `COLUMN`, `MOD`, `INT`, `ABS`, `SIN` and `CHOOSE` itself. No public interface changed, so the pin moves by its version alone. The slice's measurements are 0.9.0's.
- *The machine* is the item's. Every timing ran on the performance cores, opted out of the throttling.
  - The scratch runner timed each frame alone, with only the hold between frames and no clock beside them, since the clock slows the frame after it (`CART.1`'s record of today).
  - The scratch page kept its clock beside every frame, as the item's did.

**The candidate as the item's scoping wrote it.** Water falls as sand does. A grain of water that stayed then moves one cell sideways, into a cell of its row left free, its direction's side first.
- `Side` holds each cell's occupancy after the row's sideways moves.
- `Stay` reads `Side` beneath it where it read `Stay`.
- The Screen keeps or receives by `Side`.

Written into slice 1's cartridge, every frame of six cases equals the sand by hand with water.

*One property the item's scoping did not name: water never settles.* A grain beside free room moves into it. The next frame its first side is free again, so it moves back. A lake's edge shimmers, and a board holding water is never still. Once the pouring stops, the shimmer costs 0.17 to 0.29 ms a frame natively and 0.2 to 0.5 in the browser (*measurement*).

*What it costs.* Frames 2 to 31, medians in ms, natively pinned and in headless Chrome (*measurement*):

| case | slice 1 | the item's spelling | refined, below |
|---|---|---|---|
| the opening, sand alone, natively | 11.65 to 11.74 | 19.35 to 19.64 | 11.43 to 12.25 |
| the same in the browser | 16.7 to 16.9 | 27.95 to 28.4 | 16.9 to 17.5 |
| a soup of sand and water, a quarter each, natively | | 20.40 to 20.67 | 12.37 to 12.79 |
| the same in the browser | | 29.0 to 29.65 | 17.7 to 18.75 |

The item's spelling makes every board two thirds dearer, a board with no water in it too.

*Where it went.* Five spellings of `Side` over the sand-only opening, natively, pinned (*measurement*):

| `Side`'s formula | ms |
|---|---|
| a copy of `Stay`, `=Stay!C2` | 11.8 to 12.2 |
| the copy behind a row's guard: a column folding the row's last frame, `MAX(Screen.last!C2:LF2)`, 3 when it held water | 12.1 to 12.3 |
| the same, with a branch no cell takes holding the rule's references | 15.1 to 15.6 |
| the rule behind the row's guard | 14.8 to 16.0 |
| the rule, the item's spelling | 19.0 to 20.1 |

- A third sheet in the chain costs nothing as such. The copy runs at slice 1's time, with a chain four hundred levels deep.
- The references cost, whether or not their branch is taken. When a cell changes, the language marks its readers through every reference of every formula, whichever branch its cells take. A branch no cell takes, holding the rule's references, cost about 3 ms of 15.3.
- In the soup about 26,000 cells change a frame, and the item's `Side`, reading five cells of the last frame, gives each of them five readers more to mark.

*The refinement: `Side` reads `Stay` alone.*
- `Stay` says what stayed: 1 for a wall or a grain of sand, and 2 for water.
- `Side` then reads its own row of `Stay`, and nothing of the last frame.
- A cell painted over water with anything but empty is 2, so the item's paint holds: the grain a painted cell held still moves as the rule says.

Every frame of every case equals the sand by hand, its `Stay` now 0, 1 or 2 (*measurement*):
- the opening, 60 frames; the soup of a quarter each, 120; water poured, 300; water painted round a circle, 120; water poured for 150 frames then left for 450; the pointer moving with no button, 60;
- the second frame's allocations: 515 and 5, where slice 1's are 509 and 5;
- under the floors' own runner, its clock beside every frame: the opening at 12.0 ms and 83 frames a second, where slice 1 reads 11.7 to 12.0 ms.

With `Side` reading `Stay` alone, the row's guard is no longer worth its sheet. Without it the rule ran the opening at 12.05 ms and the soup of a quarter each at 12.66, against 12.6 and 13.1 with it (one run each, unpinned).

*The heaviest seconds of the refined rule in the browser,* frames 2 to 31 (*measurement*):

| case | median ms | max ms |
|---|---|---|
| the opening, sand alone | 16.9 to 17.5 | 30.3 |
| Life's soup, half its grains water (one run) | 20.0 | 33.2 |
| a soup of a quarter each | 17.7 to 18.75 | 30.6 |
| water poured into the falling soup | 22.6 | 39.7 |
| water painted round a circle into the falling soup | 24.85 | 43.2 |
| a lake left to shimmer | 0.2 to 0.5 | |

The maxima are two kinds of whole frame:
- the second frame, computed whole after the load: 189,017 formula cells, about 30 ms in the browser;
- the press of a button, which computes one whole frame (decision 6), 43 ms with the brush entered at every cell.

*The host's slice, derived* as the item's scoping derived it: a step of *s* ms is presented at 1,000 × *f* ⁄ *s* frames a second, capped at the rate of 30, where *f* is the share of the interval the steps may spend.

| a step of | at half the interval | at three quarters |
|---|---|---|
| 16.9 ms, the opening of sand | 29.6 | 30 |
| 20.0 ms, Life's soup half water | 25.0 | 30 |
| 22.6 ms, water poured into the soup | 22.1 | 30 |
| 24.85 ms, water painted into the soup | 20.1 | 30 |

*The owner's session, played on both rules.* The painting session of 781 frames was recorded on slice 1's cartridge. Played natively on it, and on the refined rule with the same opening:
- the plane last changes at frame 619 on both;
- the `Tally` ends with every value equal, codes 55,659 and occupied 27,928;
- its record differs by two rows only, the sheet list's `Side` and `Side.last`.

So water's rule leaves a session without water as it was, measured over a person's painting.

*The unit.* Cells a second are the formula cells over a frame's time. The refined opening steps in slice 1's time with 189,017 formula cells where slice 1 has 126,449. It reads 15,716,644 cells a second against 10,566,784, at the same 83 frames a second. So a fixture that gains cells is not compared across the change by cells a second (decision 24).

**The decisions, the owner's.** Numbered on from the item's sixteen. Each with the recommendation and the alternatives it declines.

17. **Water's rule as decision 10 has it, spelled so that `Side` reads `Stay` alone, `Stay` saying 2 for water that stayed.** Measured above:
    - a board with no water costs what slice 1 costs, natively and in the browser;
    - a soup of a quarter each costs 12.4 to 12.8 ms natively and 17.7 to 18.8 in the browser;
    - water never settles: a lake's edge shimmers, at 0.2 to 0.5 ms a frame in the browser, and the header says so.

    *Alternatives:*
    - The item's spelling, `Side` re-reading the last frame: the plainest to read, and two thirds dearer on every board.
    - The item's spelling behind a row's guard, a `Wet` column: a quarter cheaper than that, still 29% over slice 1, and a sheet more.
    - A water that settles, with no second side, so that a grain stops when its first side is taken. There is no shimmer, but a lake's rows pack against alternate walls and its surface never levels (named, not measured).
18. **The material: water 3, the key `3`, the Palette's blue already.** The floor turns blue with water picked, and the right button erases water as it erases anything. Sand and water fall alike, and neither sinks through the other.

    *Alternative:* density, sand sinking through water by swapping with the grain beneath it. A swap moves a grain up, which the scan's one-way chain cannot say without another sheet (named, not measured).
19. **The opening and the floors' fixture: Life's soup, half its grains water. Sand's two rows measure it, and no row is added.**
    - The grains are Life's first frame's, as before: sand where the soup's square is under three sixteenths of the prime, water where it is under three eighths.
    - So the toy opens raining both, and the fixture's frames run both materials' paths.
    - In the browser its first second steps at 20.0 ms: 25 frames a second at half the interval, 30 at three quarters.
    - The rows keep their names and are re-based at the fifth baseline, since the cartridge they measure changed (decision 24).

    *Alternatives:*
    - Decision 10 as approved: a second cartridge, `cartridges/water/`, the gun's way beside Life. Its rule would be Sand's word for word, held by a test or, by the kit's ratchet, moved into a library both include; its opening a soup of sand and water; and its two rows added. Its premise was that water costs twice what sand does. Refined, it costs about a tenth more, so its rows would measure much what Sand's do, at the price of a second copy of the rule.
    - The opening as it is, sand alone, and water in no row: the toy opens as now, and nothing measures water.
20. **The host's slice at three quarters of the display's interval, as decision 9 has it, held by a loop case of its own.** The measurements above keep it needed: water poured or painted into the falling soup steps at 22.6 to 24.85 ms, presented at 20 to 22 frames a second at half the interval and at 30 at three quarters.
    - `SPEC.md` §5 step 4's dated correction names the share, and `web/host.js`'s constant follows it.
    - The loop oracle gains a case, `slice`, over the double. The oracle's clock advances a fixed time at each step call, a frame takes many calls, and the case counts a tick's calls against its own share, three quarters. A mutant page at half fails it.

    *Alternatives:* the constant changed with its rule printed, as now, and no case to hold it; or half the interval kept, water's heaviest seconds presented at 20 to 25.
21. **The references and the oracle: the sand by hand gains water, in Rust and in JavaScript.**
    - `engine/src/sand.rs`: after a row's falls, its water that stayed claims a free cell of its row in two passes, its direction's side first. `step` returns the Screen, `Stay` (0, 1 or 2) and `Side`; `counts` counts four materials; the opening takes the soup's two thresholds. The scratch reference is written.
    - The page's `sandStep` does the same, for `?frames=1`.
    - `cargo test`:
      - the opening's frames 1 to 4, the Screen, `Stay` and `Side` each equal to the sand by hand;
      - every material kept in a frame with no painting;
      - a session with water: the key `3`, a disc of water, the right button erasing water, a grain against the wall, a lone grain's shimmer;
      - the budget row.
    - The runner's Sand fixture holds the four materials' counts in every frame after the first, as `(conserved n)` does now.
22. **The replay and the new cartridge: slice 3 first, then slice 2 records its session on the toy with water.** That is one session, recorded on the finished toy, and the page's sand gains the brush and water together. The owner's session of slice 1 has served already, as the evidence above that water leaves a dry session's every value as it was. It is kept in the session's scratchpad and transcript, and its measurement here.

    *Alternatives:*
    - Slice 2 first, as numbered, and slice 3 carries its replay to the new cartridge: the session re-recorded by playing it there, its frames the same, its golden regenerated. `SPEC.md` §7.6 would gain a dated note on carrying a replay, since today a replay plays only on the file it was recorded from. With decision 19's opening, the carried session's golden changes in its values too.
    - Slice 2 first, and slice 3 replaces its replay with a session with water: two recordings.
23. **What a rule costs: a seventh rule.** "A fact a later sheet needs is carried in the value of a sheet it already reads, and not read again from the twin. Each reference is a reader marked at every change, in a branch no cell takes as well." It goes into `SPEC.md` §2's note beside the six, and into Sand's header. Measured: `Side` re-reading the last frame made every board two thirds dearer, and a branch no cell takes cost about 3 ms of a 15 ms frame.

    *Alternative:* the finding in Sand's source alone.
24. **The fifth baseline: the owner's run after slice 3, with a row re-based when its fixture changes.**
    - The instrument re-bases a row whose fixture is not the one the check's baseline measured, as it re-bases a row timed another way since today, and the entry's reason says so. Cells a second count the cells: the refined opening runs at slice 1's 83 frames a second and reads 49% more cells a second.
    - At that run, Sand's two rows are re-based, and so is the native gun's, timed in runs of 128 since today's fix. Life's rows are held.
    - *When.* The pin's move to `vla-lang` 0.9.1 needs a baseline of its own, since the check holds the measured pin. Recommended: the fifth baseline waits for that move, so that one run of the owner's measures the pin, water's cartridge and the gun's runs together. If 0.9.1 is not released by slice 3's commit, the run is taken at 0.9.0 and the pin's move takes the sixth.
    - *The clock, before that run.* The clock read before each frame slows the frame after it, by an amount that changes between sessions (`CART.1`'s record of today). Native Life read 3.0 to 3.5 ms with it that night and 2.7 to 2.8 without, where its floor wants 3.12, and my run of the instrument named that row NOT A BASELINE.
      - *Recommended:* `CART.1`'s decision 5 reopened before the fifth baseline, as a fix of its own under `CART.1`'s ID. The clock is read before a fixture's steady frames and after them, so that a throttled run still shows as drift, and the change is measured in both halves.
      - *Its alternative:* the clock as it is, and a refused row run again at a quieter time, as the instrument says.
25. **What to ask of Frazaro: nothing new. `KERNEL.28` has landed there, and what it changes here comes with the pin's move to 0.9.1.**
    - *Measured by Frazaro's session* on Sand natively, frames 2 to 31, three alternated pairs, 0.9.0 against 0.9.1:
      - the direction read through `Parity`'s twin, 11.7 ms before and after;
      - `MOD(ROW(),2)` at each cell, 13.5 to 11.8;
      - `CHOOSE(MOD(ROW(),2)+1,...)`, 29.6 to 12.0;
      - the soup's first frame, 34.8 to 23.6.

      The allocations are unchanged, Sand's 509 and 5 among them, and the engine's tests pass over it by path, 29 of 29.
    - *For this slice:* the `Parity` column stays. It costs nothing, and dropping it would cost about 1%. Decision 19's opening computes the soup twice in its first frame, which 0.9.1 makes cheap; that frame is not floored.
    - *With the pin's move,* not with this slice unless the move lands first: rule 5 of `SPEC.md` §2's note gains a dated correction. A cell's place may be computed at each cell, and `CHOOSE` costs what `IF` does.
    - *Named, not asked:* reach by branch, where a reference marks its readers only when a cell takes its branch. It would make a guard's untaken branch free, about 3 ms of a 15 ms frame as measured here. It moves none of Frazaro's fixtures, whose formulas hold no untaken branch of references.
26. **The bookkeeping.**
    - The roadmap's line leaves for the ledger with the commit of the later of slices 2 and 3. Slice 4, the repository, stays the owner's.
    - `CHARTER.md` §6 gains water's measurement, the READMEs the material, and Sand's header the rule and its shimmer.
    - The commits are made at the owner's word, by `-F`, staged by hunk.

**The work.**

| File | What changes | Decisions |
|---|---|---|
| `cartridges/sand/sand.source.vla`, `sand.vla` | `Side`, its border and formula; `Stay` reading `Side` beneath and saying 2 for water; the Screen keeping by `Side`; the key `3`; the opening half water; the header | 17 to 19, 23 |
| `engine/src/sand.rs` | water: the sideways pass, `Stay` 0 to 2, `Side`, four materials, the opening's two thresholds | 21 |
| `engine/src/cartridge.rs` | the opening's frames and sheets, a session with water, the rule's shapes and budget | 21 |
| `engine/examples/frames.rs` | Sand's opening by its two thresholds, four materials kept | 21 |
| `web/index.template.html` | `sandStep` with water and `sandOpening`; the loop's `slice` case | 20, 21 |
| `web/host.js` | the slice at three quarters | 20 |
| `tools/check_host_loop.ps1` | the `slice` case and its mutant page | 20 |
| `tools/bench_frames.ps1`, `tools/check_frame_floors.ps1` | a row re-based when its fixture changed; Sand's allocation ceiling | 24 |
| `tools/check_cartridge.ps1` | Sand's row floor, 86 | 17 |
| `SPEC.md` | §2's seventh rule; §5's slice; rule 5's correction if the pin's move to 0.9.1 lands first | 20, 23, 25 |
| `CHARTER.md`, the READMEs, `ROADMAP.md`, `REARVIEW.md`, `Delta/CLAUDE.md`, the memory | the measurement, the pages, the line, the record | 26 |

**The catch.**
- A reference costs at every change whether or not its branch is taken, so a guard that skips work does not skip the references inside it.
- Water never settles, so a replay that ends with water has no settled frame: its golden is its last frame's.
- `Stay`'s 2 changes the `Tally`'s occupied column on a wet board, a sum of 0, 1 and 2. It stays a checksum, as decision 12 has it with water; or the column reads `Side.last`, 0 or 1 a cell, which the build weighs.
- The page's player refuses a replay recorded on another cartridge, and `check_cartridge.ps1` holds a replay's digest. Whichever of slices 2 and 3 comes second records or carries the replay.
- The first frame computes the soup's arithmetic twice, once for each threshold: 62 ms natively and 66 in the browser at 0.9.0, once, and less at 0.9.1, whose runs compute `MOD` themselves.
- A whole frame of 189,017 cells is about 30 ms in the browser, and a button's press computes one.

**Oracle.**
- `cargo fmt --check`, `clippy -D warnings` and `cargo test`: decision 21's tests and every test before them.
- The runner's check mode: Sand's frames equal, its four materials kept, its allocations within a ceiling the build measures.
- `?frames=1` under headless Chrome: Sand's frames equal to the page's sand with water.
- `check_host_loop.ps1` at both ratios: the `slice` case passing, and its mutant page failing.
- `check_frame_floors.ps1` and its control: a row re-based when its fixture changed, its reason in the entry.
- `check_cartridge.ps1` and `check_web_offline.ps1`; `run_checks.ps1 -WithExtras`, `ALL GREEN`.
- The owner's hand test:
  - open Sand and watch it rain sand and water, and the frame line through the opening;
  - press `3` and pour water into a basin of sand and walls;
  - erase water with the right button;
  - watch a lake's edge shimmer.

  Then the fifth baseline: the owner's run of `tools/bench_frames.ps1`, pasted.

**Size.** About a day (*prediction*, the item's): about 60 lines of the source changed, about 60 of the Rust sand, about 70 of the page's sand and 60 for its slice case, about 150 of tests, and about 40 of the instruments.

*Scoped 2026-10-12; decisions 17 to 26 await the owner.*

*Approved 2026-10-12, the same day, decisions 17 to 26 as recommended: "0.9.1 is cut and deployed to GitHub and crates.io; proceed with implementing slice 3 of CART.2 as scoped." So the pin moved first (`ENGINE.1`'s record, "The pin at `vla-lang` 0.9.1"), and `CART.1`'s decision 5 was reopened before the fifth baseline (`CART.1`'s record, "Decision 5 reopened").*

**Slice 3, water: what landed.** Built 2026-10-12 over `5aee496` and `vla-lang` 0.9.1; it awaits the owner's hand test and the floors' fifth baseline.
- `cartridges/sand/sand.source.vla` and `sand.vla`:
  - decision 17's rule, its rows the ones the scoping measured in its scratch copy, the half-water candidate: `Side`, its border and its one fill; `Stay` saying 2 for water that stays; the Screen keeping by `Side`;
  - the key `3`, the Palette's index 3 named "water", and the opening Life's soup half water, sand under three sixteenths of the prime and water under three eighths (decisions 18 and 19);
  - the header's rule, its shimmer and the seventh rule (decision 23);
  - one row the scoping left to the build: the Tally's occupied column reads `Side.last`, 0 or 1 a cell, so that on a wet board it still counts occupied cells (the catch);
  - 86 rows, 189,017 formula cells in 14 shapes.
- `engine/src/sand.rs`: the scoping's scratch reference with the committed file's docs. After a row's falls, its water that stays claims a free cell of its row in two passes. `step` answers the Screen, `Stay` (0 to 2) and `Side`; `counts` counts four materials; the opening takes the two thresholds; `tally` sums `Side`.
- `engine/src/cartridge.rs` (decision 21):
  - the opening's four frames held on the Screen, `Stay` and `Side`, every material kept, 14 shapes, the budget row, the Tally over `Side.last`;
  - the painting session, its gestures now one helper both sessions share, the key `3` mapped;
  - a new test, `sand_s_water_falls_spreads_is_erased_and_never_settles`. Sand's rows with the opening's two thresholds at 0, so the board opens empty. Then the key 3, the floor turning to water; a disc of water that falls and spreads; the right button erasing water; the wheel to a radius of 1; a lone grain painted against the left wall, by pointing at the wall's own column; and fifteen frames after it. Every frame's three sheets equal the sand by hand, and from frame 10 the grain on the floor moves out from the wall and back each frame.
- `engine/examples/frames.rs`: Sand's opening by the two thresholds, and four materials kept every frame, through the shared file.
- The page: `sandOpening` and `sandStep` with water; the loop oracle's sixteenth case, `slice` (decision 20).
- `web/host.js`: `SLICE_FRACTION` 0.75.
- `tools/check_host_loop.ps1`: the `slice` case's floors, sixteen cases, and mutant Z, a host at half the interval, whose header says `slice=0.5` and whose ticks the case fails by name, ten calls where it owes fifteen.
- `tools/bench_frames.ps1` (decision 24): a row whose fixture is not the file the check's baseline measured, nor its rows rebuilt, is re-based on the run, the entry's reason written where that lowers its floor.
- `tools/check_frame_floors.ps1`: Sand's allocation ceiling, 516 and 5, raised with the fixture it measures; the header.
- `tools/check_cartridge.ps1`: Sand's row floor, 86.
- `SPEC.md`: §2's seventh rule and rule 5's correction; §5 step 4's correction, three quarters.
- `CHARTER.md` §6, the three READMEs, and `ROADMAP.md`'s line, which stays until slice 2's commit (decision 26).

The `slice` case, by its own arithmetic. The double is stepped in calls of 1,000 cells, 64 a frame of Life. The case keeps the host's clock, which stands still but at a step call, where it moves 1 ms. Ticks come 20 ms apart, so the host's interval is 20 ms, and a tick may spend 15 of it. Every tick after the first makes 15 calls: 585 in 39 ticks, the host at frame 9 (*measurement*, both ratios).

The oracle, on the day (*measurement*):
- `cargo fmt --check` and `clippy --all-targets -D warnings`: clean.
- `cargo test`: 30, the three Sand tests among them.
- The runner's check mode: Life 80 and 5, the gun 80 and 5, Sand 516 and 5; every frame equal and every material kept.
- `expand`: six sources, Sand's 86 rows. `check_cartridge.ps1`: clean.
- `check_host_loop.ps1` at both ratios: sixteen cases OK, every count at its floor. Its control: the real page clean, and twenty-six mutants each failing for its own reason, Z among them.
- `tools/bench_frames.ps1` end to end. *My run, and its block was not pasted:*
  - `frames ok`, Sand's frames equal to the page's sand with water;
  - natively, Life 2.7 ms, the gun 42.8 µs in runs of 128, Sand 12.5 ms (80 frames a second, 15,174,044 cells a second);
  - in the browser, Life 4.0 ms, the gun 60.9 µs, Sand 18.7 ms (53 frames a second, 10,107,861 cells a second);
  - its entry re-bases the native gun's floor to 1,320,000,000 with its reason, and Sand's two rows on their new fixture, both higher than before: 13,600,000 natively and 9,090,000 in the browser.
- `check_frame_floors.ps1`: two problems, both the fifth baseline's to clear: the pin measured is 0.9.0, and Sand's fixture is not the one measured. Its control: clean.
- `run_checks.ps1 -WithExtras`: 12 checks, 11 passed and `check_frame_floors.ps1` failing on those two problems alone; 12 verifiers, all passed.

*Found:* the opening's first frame, the soup computed twice, steps in about 41 ms natively and 42 in the browser at 0.9.1, where the scoping read 62 and 66 at 0.9.0, as `KERNEL.28` predicted. It is not floored.

*For slice 4, the owner's question of 2026-10-12, asked with the approval:* "An 'arcade' repo with each cartridge listed as a subdirectory feels cleaner, at least from a build and maintenance perspective, than provisioning distinct repos for each cartridge. It's worth adjudicating before slice 4. My gut says an arcade repo, but I'm open to being wrong."

Recommended in the session: one arcade repository for the house's games, beside the engine's, each game a folder.
- *The kit.* Every source includes `common.vla`, and the kit's ratchet proves a move into the kit by every client's bytes unchanged (`ROADMAP.md`, "The order, and why"). In one repository that proof is one commit and one CI run. Across repositories it is a version of the kit and a bump in every game.
- *One of everything.* One pin of the engine and of the language, one CI, one licence map (every cartridge 0BSD), one deployed page whose cartridge picker is already built. Each repository is the owner's word, its settings, its CI and its Pages; six games are filed.
- *The charter's test is kept.* `CHARTER.md` §6 counts forks and pull requests on this repository and on `vla-lang`'s, from the release of the first game. The arcade's first release, Sand aboard, starts the quarter as a game repository's would, with a dated line in §6. And a game's pull requests stay out of the count the hypothesis is about, as they would not if the games lived in this repository.
- *Where it could be wrong.* A repository of its own is the more legible thing for a falling-sand community to find, star and fork. If the owner wants Sand itself to be what people star, that argues for its own repository. A game that grows a community of its own can still leave the arcade later, its folder split out with its history.
- *What slice 4's scoping would weigh either way:*
  - Sand as the engine's floors fixture: a frozen copy kept here beside Life, or the floors losing their chain two hundred rows deep;
  - the engine consumed as a stranger consumes it, `alonzo` from crates.io after `REPO.4`, or a pinned git rev before it;
  - where the kit lives: here, shipped with the engine, the arcade holding a copy checked byte for byte, or with the games.

Unadjudicated.

*Owner-tested 2026-10-12, the same day: "All the hand tests pass". The owner's run of `tools/bench_frames.ps1` is the floors' fifth baseline, pasted from `target/bench_frames.txt` whole, no value touched; the terminal's copy, given in chat, had dropped two spaces at its line wraps (*measurement*):*

| row | frame p50 | frames a second | cells a second | floor |
|---|---|---|---|---|
| native life | 2.8 ms | 358.3 | 22,561,677 | 20,300,000 |
| native gun | 0.0423 ms, in 30 runs of 128 (frames 158 to 3997) | 23,656.0 | 1,489,473,470 | 1,340,000,000, re-based with its reason |
| native sand | 12.3 ms | 81.1 | 15,329,970 | 13,700,000, re-based on water's cartridge |
| wasm life | 4.0 ms | 250.0 | 15,741,000 | 14,100,000 |
| wasm gun | 0.0609 ms, in 30 runs of 128 | 16,410.3 | 1,033,255,383 | 929,000,000 |
| wasm sand | 17.8 ms | 56.2 | 10,618,933 | 9,550,000, re-based on water's cartridge |

- Native life clears its floor again, at 2.8 ms, its clock read before the fixture's frames and after them.
- `run_checks.ps1`: 12 checks, `ALL GREEN`.

*The owner's question the same day, after the hand test:* "loading the Sand game now hangs the page for a half second and the game feels much slower, visually, than Life. Which items on the roadmap will address Sand's performance in the same way Life moved from single digit fps to over 200 fps?" Answered in the session from three measurements made for it, in scratch and nothing in this tree (*measurement*, the owner's machine, opted out and on the performance cores).

*The loop as a person sees it.* The real host over the engine's module in headless Chrome, ticked on a 60 Hz schedule of real time for ten seconds, every frame drawn; four runs each of Life and Sand, and two of Sand at a rate of 60:

| | load | frames drawn, each second | ticks past the display's interval |
|---|---|---|---|
| Life | 93 to 98 ms | 29, then 30 every second | 2, at seconds 4 and 8 |
| Sand | 568 to 590 ms | 29, then 30 every second | 19 to 23 in four runs; in the two that named their seconds, all but four in the first |
| Sand at a rate of 60 | 563 to 574 ms | 44 to 48, then 71 to 75 (the backlog run), then 60 | 29 to 33, most in the first second |

- Sand draws as many frames as Life does, at its rate of thirty.
- Its motion is a cell a frame, so the opening's rain takes about six and a half seconds to reach the floor. At a rate of 60 it draws 60 a second from its third second.

*Where the load goes,* natively, through a copy of `vla-lang` 0.9.1 with timers in its load and its step:
- Sand's load is 491 ms. Of it, the plan's dependency edges take 341 ms: 2,370,747 edges resolved a cell at a time, each reference's area walked in the sheet's tree and each cell found in a hash of positions. Then the rows 29 ms, placing the shapes 19, Tarjan 25, the order 23 and the first walk 11.
- Life's load is 73 ms, its edges 30.
- Frames 1 and 2 are computed whole after a load: Sand's in 40.6 ms (the first walk 23.8 of it) and 19.2.

*Where a steady frame goes,* frames 3 to 31:
- Sand: 12.6 ms. Marking the readers of 30,531 changed cells takes 3.4 (27%); evaluating 110,346 cells in 600 runs, 8.6 (78 ns a cell); the frame's end, 0.5.
- Life: 2.7 ms, 41,663 cells at 57 ns, its marking 0.34.
- A cell costs about what Life's does. Sand evaluates almost three cells for each one that changes, and marks ten times Life's readers.

*Read against both roadmaps:* no item, filed here or in Frazaro, is aimed at these costs. `KERNEL.25`, `KERNEL.20`'s slices, `KERNEL.26`, `KERNEL.27` and `KERNEL.28` were found by profiling Life and Sand's opening, and have all landed; they are why Sand steps at 81 frames a second natively and 56 in the browser.

| Sand's cost | filed |
|---|---|
| the load's edges, 341 ms of 491 | none |
| the frame's marking and its cells evaluated without changing, most of 12.6 ms | none; reach by branch, named by this slice's decision 25, not asked |
| a cell's evaluation, 78 ns | `ENGINE.6`'s `opt-level = 3`, about 5.5% in wasm (`CART.1`'s measurement) |
| frame 1's soup computed twice | `KERNEL.29`'s `LET`, frame 1 alone |
| the page frozen through the load | none; a host that loads in a worker, as `SPEC.md` §5 names a worker for pipelining |

- `KERNEL.31` is a range of this frame's sheet, and Sand reads single cells of it.
- `KERNEL.30` is an instrument, which would print Sand's shapes and reads before a frame runs.
- `KERNEL.32` is Frazaro's doors, `KERNEL.8` its lookups, and `ENGINE.6`'s block memoization pays Life alone.
- The first second's overruns most likely come from a frame's start and end lying outside the step's budget, which counts the cells a call passes. Sand's start is 3.4 ms natively, where Life's is 0.3 (*inference*, not measured).

*Recommended in the session, unadjudicated:* `CART.1`'s route again. Each candidate is prototyped in a scratch copy of the language and measured on Sand, then asked of Frazaro with the measurement. The plan's edges found once a shape, from its references' patterns as `calc/reach.rs` already keeps them, rather than a cell at a time, for the load; and reach by branch, for the frame. The rate is the cartridge's, and so the owner's.

*Committed 2026-10-12 at the owner's word, "Commit, then walk CART.1's optimization route again over CART.2 to look for hacks to improve CART.2". The pin at 0.9.1 is in the same commit (`ENGINE.1`'s record says why), and `CART.1`'s frame timer and decision 5 are in a commit of their own before it. Not pushed.*

*The playtest pass, 2026-10-12, at the owner's word, right after those commits: "walk CART.1's optimization route again over CART.2 to look for hacks to improve CART.2 (should we call it a "playtest pass" from now on for shorthand, as a stand-in for "once the game works, we play it to test for performance bugs to file as optimization passes and game mechanic improvements"?)". Everything below was measured in scratch: copies of `vla-lang` 0.9.1 and of this engine, in the session's `scratchpad/pt/`, each prototype kept there as a patch. Nothing in either repository changed.*

**The route.** `CART.1`'s, with a session played in front of it.
- *The session.* A scratch example, committed with this record as `engine/examples/play.rs`, plays Sand as the host plays it: 1,098 frames in eight phases (below), the Input sheet's rows written before every step.
  - Every frame's plane is held to `src/sand.rs`, through each stroke too.
  - Each step is timed alone, the write and the hold outside it, opted out of the throttling and on the performance cores.
- *Beside it:*
  - the live loop in Chrome from the speed question;
  - the floors' runner and the page's `?frames=1`;
  - a copy of the language with timers in its load and its step;
  - a copy that counts, by shape, the cells evaluated and changed and the marks each change tries.
- *Each candidate:*
  - built in a copy of its own and held to the references in every frame;
  - put through the language's 182 tests and the engine's 30;
  - then timed in alternated launches against the copy before it.

**What a person meets.** Today's Sand over 0.9.1, natively, six sessions (*measurement*, ms):

| phase | median | p95 | the worst frame |
|---|---|---|---|
| the opening's rain, frames 3 to 200 | 3.1 to 3.2 | 13.2 to 13.5 | 14.3 to 15.3 |
| settled, 201 to 400 | 0.14 | 0.17 to 0.19 | under 0.6 |
| a stroke of sand, 120 frames | 1.4 | 1.6 to 1.8 | 24 to 25 |
| the sand settling, 80 | 0.2 | 0.4 to 0.5 | 17.5 to 18.4 |
| a stroke of water, 120 | 1.3 | 1.6 to 2.0 | 24 to 25 |
| a lake shimmering, 180 | 0.33 | 0.5 to 0.6 | 17.7 to 25 |
| a stroke erased, 120 | 2.1 to 2.3 | 2.6 to 2.9 | 24 to 26 |
| after it, 80 | 0.27 | 1.1 | 17.9 to 18.6 |

- Settled, Sand is cheap: a lake's shimmer, which never ends, costs a third of a millisecond a frame.
- The heavy frames are the opening's first seconds, and one frame at every click.

**Found: a stall at every click.**
- *The cause.* Two parts of the rule make every cell of `Stay`, `Side` and the `Screen` compute, 189,017 cells, 17 to 26 ms natively (*measurement*):
  - rule 4's part `Input!$B$13+Input!$B$14=0`, which flips at a button's press and again at its release;
  - `Brush!$B$4`, the material, held at every cell of those shapes, which changes at a material's key and at the right button.
- In the browser that is about 25 to 38 ms by the floors' ratio of 1.45, against 25 for a frame at the rate of 30 (*inference*).
- *The fix, the cartridge's: the row gate.* The brush is read from `Gate`'s rows alone:
  - each cell tests its row's `Gate!$B2<0` before the disc;
  - a third column, `Gate!C2:C199`, holds the material in the disc's rows and −1 elsewhere;
  - `Gate!A` and `B` already read −999 and −1 when no button is held.

  A press, a release or a key then changes only the rows under the brush. The patch is 18 lines.
- *Held:* every frame of the session is equal to the sand by hand.
  - The engine's painting and water tests pass over the row gate, `Stay` and `Side` cell by cell.
  - Its opening test fails only on the count of shapes, 15 where it pins 14.
- *Its cost alone:* each marked cell reads its row and splits its lanes, 20% of the rain (the median 3.2 to 3.8 ms, the p95 13.4 to 16.5).
  - Dropping the part without the third column was worse: 30% of the rain, with the key's and the right button's stalls kept.
  - With the held-column read below, the row gate costs nothing.

**The language: four candidates**, each prototyped and measured (*measurement*).

1. *The plan's edges, built once a shape.*
   - Before, each cell resolved every reference of its parse, repeats included, walked each area in the sheet's B-tree and found each cell in a SipHash map.
   - Now each shape's references are found once:
     - one on a sheet holding no formula is dropped;
     - one every `$` holds is resolved once;
     - each cell's vertex comes from the array reach already keeps (`Positions`);
     - the adjacency is one flat array, and Tarjan and the order run over it, their components flat.
   - The plan is unchanged, every cell having the same edges as before.

   | load | 0.9.1 | the plan's edges |
   |---|---|---|
   | Sand, native | 490 to 506 ms | 156 to 167 |
   | Sand, Chrome, the real host | 548 to 555 | 153 to 163 |
   | Life, native | 67 to 74 | 37 to 40 |
   | Life, Chrome | 91 to 94 | 59 to 60 |
   | the gun, native | 60 to 63 | 36 to 41 |

   - The frames are unchanged.
   - What remains of Sand's 151 ms natively: the edges 52, the rows 29, placing the shapes 18, the refusal check 11, the first walk 10, the order 9, Tarjan 4.
2. *Reach by branch* (decision 25's candidate, asked of no one).
   - How it works:
     - each `IF` of a shape whose branches hold references gets two bits;
     - a run records the branch each cell takes;
     - a reference inside a branch marks a reader only when the reader's last evaluation took that branch;
     - a cell evaluated alone, or through `Ctx`, records every bit, and an `IF` inside a repeated part guards nothing.
   - The counts, Sand's rain, frames 3 to 31, a frame's mean:

     | | cells evaluated | of them `Stay` | of them the `Screen` | cells changed |
     |---|---|---|---|---|
     | 0.9.1 | 110,347 | 54,410 | 55,026 | 30,531 |
     | reach by branch | 80,494 | 30,387 | 49,195 | 30,531 |

   - The time: the floors' Sand 12.8 to 13.4 ms → 12.4 to 12.8, and the session −5%. The gun is +4%, from the recording.
   - Why so little: `Stay` changes 275 cells a frame in the rain, yet is evaluated tens of thousands of times, nearly all through `Screen.last!C2`, a read every cell needs. A grain arriving must ask whether it falls on, and while everything falls the answer stays 0. The cells reach by branch skips were the cheap ones.
   - Not recommended as an ask: the machine records each cell's branches and reach keeps a guard per pattern, for 5% on the cartridge it was named for.
3. *A held column read once.*
   - A reference that holds its column (`Gate!$B2`, `Parity.last!$A2`), read by a run whose cells share a row, reads one cell, as a fully held one already does. Its `IF` then takes one branch for the run, with no split. Sand's runs are each one row of one shape.
   - The floors' fixtures are unchanged.
   - Today's Sand: strokes −21 to −25%, the session −9 to −10%, and a click's whole frame 16 to 21 ms where it was 17 to 26.
   - With the row gate, the gate is free: the rain as today (median 3.0, p95 13.0), and the session 16% under today's.
4. *Merged patterns.*
   - A shape's single cells side by side in a row (`Stay`'s `Screen.last!A2` to `E2`) become one rectangle of that row, which reaches the cells they reached. The frame's start tries one pattern where it tried five.
   - The floors' Sand natively 12.5 to 12.9 ms → 10.7 to 10.9 (−15%). With the row gate, the rain's p95 13.2 to 13.8 → 11.2. Life and the gun unchanged.

**The three that pay, together** (1, 3 and 4), with the row gate (*measurement*):
- The load: Sand 490 to 506 ms → 155 to 167 natively, and 548 to 555 → 153 to 163 in Chrome.
- The floors' Sand: 12.5 to 13.0 ms → 10.7 to 10.9 natively, and 18.1 to 19.0 → 15.8 to 16.5 in Chrome (`?frames=1`, three alternated pairs). Life and the gun unchanged.
- The session: 1,781 to 1,824 ms stepping → 1,354 to 1,423 (−20 to −26%). No frame of a stroke, a settle or a key is over 3 ms, where those frames reached 18 to 26.

**Mechanics.** No rule bug: every one of 1,098 frames is equal to the sand by hand, through sand, water and erasing.
- The motion is a cell a frame, so the rain takes about six and a half seconds to land at the rate of 30.
- The opening, the whole board falling at once, is the heaviest moment the toy has. At a rate of 60, the rain's p95 of 11.2 ms natively is about 16 in the browser, against the slice's 12.5, so its first seconds still overrun (*inference*).

**Recommended, unadjudicated:**
- *Frazaro*, asked at the owner's word, as `KERNEL.28` was, each with its prototype's patch and these numbers:
  - (1), the plan's edges: the load 3.5 times faster in Chrome;
  - (3), the held-column read;
  - (4), merged patterns.

  Reach by branch is not asked.
- *Sand:* the row gate, before slice 2, since a replay names its cartridge by digest and plays only on that file (`SPEC.md` §7.6). `SPEC.md` §2 rule 4 is corrected with it: a test rarely true reads its own row, which a run reads once, and not a part every `$` holds, whose flip computes every cell.
- *The owner's:* the rate; and the opening, whether the whole board rains at once.
- *The pass itself:* the session could be committed as the engine's third example, its phases data, so that every game's playtest pass starts from the same runner.

*The owner's question in the middle of the pass's adjudication, 2026-10-12:* "How difficult would it be to implement sand displacing water due to being heavier? I can already imagine that would cause an explosion of localized checks (if a water particle is directly beneath a sand particle, do they swap or does the sand particle take a non-sand/non-wall diagonal space?). Perhaps this is best left for a much later feature pass than a core CART.2 functionality." Answered in the session, unadjudicated:
- Fewer checks than it looks. A grain over water that stayed, and did not move sideways, swaps with it:
  - `Stay` gains a code for a grain that sinks;
  - `Side` counts the swapped cell as occupied;
  - the `Screen` takes the grain from the row above's `Stay` and gives the water the grain's cell.
- The `Screen` reading the row above this frame makes no cycle, since nothing reads the `Screen` before the frame's end.
- The cost is one reference more for each `Screen` cell, more marking, perhaps 5 to 10% of a frame (*inference*, not measured).
- The work is the two hand-written sands, Rust's and the page's, kept equal, and a test of a grain sinking through a lake: about a day (*prediction*).
- Agreed, a later pass and not core: a mechanic changes the cartridge's bytes, and the owner's session, slice 2's replay, plays only on the file it was recorded from, so after slice 2 such a pass records again.

**In the browser** (*measurement*, headless Chrome 154). The real host over the engine's module, ticked on a 60 Hz schedule of real time, from second 8 a click a second, the left button held half a second at (160, 60) through the host's own `pointerAt` and `pointerButtons`. Each figure is the longest gap between two frames drawn in the 300 ms after a press or a release; a frame at the rate of 30 is due every 33.3 ms.
- The stall is visible:

  | at the rate of 30 | after a press | after a release |
  |---|---|---|
  | Sand as committed | 83 to 85 ms | 75 to 77 |
  | the row gate | 51 to 52 | 51 to 52, the loop's ordinary gap |

- *A trap of the harness, found and set aside:* a tick of 66 to 105 ms every 132 frames, at either rate and in Life too, as in the speed question's live runs. It does not come from the module's memory, which held 77.9 MiB without a growth, or from the plane's copy, which a reused buffer left unchanged. It went when the host was given no canvas: a page that never returns to the event loop never presents its canvas, and Chrome flushes the drawing it holds in one go. A page that returns to the loop every frame presents every frame.
- *Found: the host's loop aliases.*
  - At a rate of 60 Sand computed 60 frames a second but presented 38 to 40: some ticks finished two frames and some none. The timestamps jitter by a tenth of a millisecond around 16.667 ms, and the accumulator's remainder sat near its threshold.
  - At the rate of 30 the same jitter puts a gap of 50 ms among the 33s, a p95 of 51 to 60 ms.
  - Snapping a tick's time to the frame's grid when within 1 ms of it (a scratch patch of `tick`, the grid the frame's interval over the whole number of display intervals in it) gave even gaps:

    | | presented a second | gaps, median and p95 | after a click |
    |---|---|---|---|
    | rate 30, the row gate | 30, from 30 | 33.3 and 33.7 ms, from 51.0 | 35 ms |
    | rate 60, as committed | 59 to 60, from 38 to 40 | 16.7 and 17.0, from 34 | 50 at a press, 42 at a release |
    | rate 60, the row gate | 60 | 16.7 and 16.9 | 18 |

*Adjudicated 2026-10-12, the owner's word: "Your adjudications for implementing the four decisions are more informed than mine, so I trust your judgment. Proceed."*
1. *Frazaro:* the pass's three asks, the plan's edges, the held-column read and merged patterns, each with its patch and its numbers, drafted for the owner to relay as `KERNEL.28`'s ask was, since this session leaves Frazaro's tree alone. Reach by branch is not asked.
2. *The row gate before slice 2*, `SPEC.md` §2 rule 4 corrected with it. Over 0.9.1 it costs a fifth of the opening's rain, whose heaviest frames still fit a frame at the rate of 30 in the browser, and it removes the stall at every click; the held-column read makes it free when Frazaro ships it.
3. *A rate of 60, the opening as it stands.* The motion was what read as slow, and a settled frame costs under a millisecond. With the row gate and the host's tick snapped to the frame's grid, the browser presents Sand at an even 60 a second and a click shows no stall. The host's snap is `ENGINE.1`'s, the loop's, and goes in with the row gate, so that one hand test sees both. The opening stays the whole board raining at once: it is the floors' worst case by design, and at 60 it lands in about three and a half seconds.
4. *This record and the session committed now*, the session as `engine/examples/play.rs`, the engine's third example; the playtest pass named in `ROADMAP.md`'s order. The row gate, the rate and the snap wait for the owner's hand test and the floors' sixth baseline, since the cartridge's digest moves.

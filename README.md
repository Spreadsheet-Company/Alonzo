# Alonzo, the browser's Lisp machine

*Abstract: A self-aware game engine in WebAssembly (whose extension language is
VLA (Visual Lisp [for] Applications), whose scene is a grid of cells, 
whose devices are sheets, and whose telos is Frazaro, a spreadsheet generator).*

---

## What is Alonzo?

A Lisp machine was a computer whose language went all the way down: the
machine understood the language's data, and the microcode was written to
it. Alonzo is that idea in the one machine everyone already has, the
browser, with the honesty the browser imposes. A WebAssembly module sees
only its own memory and the functions its host hands it, so it cannot draw
a pixel or hear a key except through one of those, and the stack stops at
the draw call, which is rented. "All the way down" means down to the draw
call.

Three things, with three names. **VLA** is the machine: a Lisp whose heap
is a grid, in its own crate, `vla-lang`, cut out of Frazaro's core.
**Frazaro** is the set of bridges into and out of it: from English and the
other phrasebooks to VLA, with a proof per sentence, and from VLA to the
spreadsheet hosts and back. **Alonzo** is the devices and the clock: a
Screen, an Audio, an Input, a Clock, a File, a Camera, and a Write sheet
mapped into VLA's grid, as uxn's Varvara maps its devices into memory, and
a loop that writes
the input and clock cells, asks the language to step, reads the Screen
sheet and the effect cells, and draws. Every input is a cell the engine
writes. Every effect is a cell it reads. The engine's whole contract is
four calls into the language: load a cartridge, write cells, step, view.

A spreadsheet is a member of class game: a sheet of colored cells is a
framebuffer, a cell that is a formula of its neighbors is a fragment
shader, and a recalculation is a frame. The thesis in one line: a
spreadsheet is a game whose frame rate is one, and an engine that can draw
sixty can draw one.

To a game programmer: Alonzo is a data-oriented entity-component
system [ECS] where the systems are formulas, the scheduler is the
dependency graph, every component is inspectable live, and rollback is
free. A sheet is an archetype table, a row is an entity, a column is a
component, and one formula filled down a column is a system, run every
frame over every row. The order of the systems is read off their
references and never declared; a cell has one formula, so no two systems
race for it; and since the state is nothing but cells and every step is
deterministic, rolling back is restoring cells and stepping again. The
reading in full, with where it does not fit, is `docs/ALGEBRA.md` §10.6.

## What exists today

The first commits: the constitution, the work and the record, an empty
crate that builds for the browser with an import section of zero entries,
and the checks that hold it there; then the first brick, the viewport, the
Screen device in grid mode over the view record (`KERNEL.5`, a Frazaro item
laid here), with its page and the checks that hold it; then the host half
of the loop (`ENGINE.1`'s first slice), run against a fake module of the
engine's exports, with the Life cartridge as its fixture; then the engine's
own module (`ENGINE.1`'s second slice), the `alonzo` crate over the language
crate's machine, so that the same host runs Life as the language computes it,
every cell of every frame, and the fake module stays the double its oracle
drives; then the frame path's oracle (`ENGINE.2`), the plane the host draws
held to the view record of the same window, byte for value, through the
Camera's window and into the canvas's pixels, over a test card that holds
every kind of value a Screen cell can; and the frame path itself over the
engine's module, the language keeping the Screen's plane at each frame's
end, so that a view is a copy, held to the blit's floors; then the Input and
Clock devices (`ENGINE.3`), the Clock's three cells held at a person's
write, the host choosing a seed at the load and stepping at the rate the
Clock holds, the pointer written in the Screen's own cells, and an input
card that draws every cell the host writes before a step; and the replay,
every write a run makes kept by the host and played back to the same
frames, the card's own replay committed beside it with the sheet it ends
in. And the Audio device (`ENGINE.4`), the Audio sheet's
four voices sounded by the Web Audio graph's own oscillators and gains,
scheduled on the audio clock and never the animation clock, heard after a
person presses Sound on, with a sound card that plays every feature of a
voice, the schedule held to the cells by the loop's oracle and the sound
itself measured by an offline render, pitch, loudness, rests and onsets,
and the card's own replay committed beside it with the Log it ends in.
And the first game, Sand (`CART.2`, closed 2026-10-12): a falling-sand toy
on the 320 by 200 Screen, sand, water and walls painted with the mouse,
whose rule is a chain two hundred rows deep, each row reading the row
beneath it in this frame. Water falls as sand does and then moves sideways,
so it spreads and never settles. Every frame is held to a sand written by
hand, and its opening, sand and water raining together, is measured into
the floors beside Life's. A person's painting session is its replay, every
frame held, its end the golden. And the second game, Kairos (`CART.4`,
closed 2026-10-12): the stacking game in the shape of the arcade cabinet of
2004, the first with a win and a loss. Stop each row of lights over the row
beneath; the lights not over a light fall, and a row with none ends the
game; take the minor prize at level 11 or go on for the major at 15. Its
Levels sheet is the cabinet's operator menu in the open, every level's speed
and the window in which a press stops a row where it stands, so a rigged
cabinet is an edit anyone can read. It is the first game written in the
kit's words, and every frame is held to the game written twice more by
hand, in Rust and in the page. The owner's two games are its replay, every
frame held, its end the golden.

| File | What it is |
|---|---|
| `docs/CHARTER.md` | the thesis, the honest bottom, the seven rules and the frame, the lineage, the social hypothesis stated so that it can fail, the first numbers, what is not built, the license |
| `docs/ROADMAP.md` | the open items, in the order each makes the next cheap, with the standing decisions `AD-1` to `AD-7` |
| `docs/REARVIEW.md` | the closed ledger, the sittings, and each item's full scoping before it is built |
| `docs/RELEASES.md` | the release notes, newest first, each written before its tag: what a release holds and measures, its items by ID, and what it does not hold |
| `docs/SPEC.md` | the specification, version 6: the keyboard's sheets since 2026-10-20, `(game ...)`, `(work ...)` and `(read ...)` a `(spec 6)` cartridge's, the sheets whose keys are the game's, the sheets a person types into and the read-only sheets; an act settled at rate 0 since 2026-10-18, `(settle K)` a `(spec 6)` cartridge's, and an act's place and a press over a cell at rate 0; a cartridge's own commands since 2026-10-17, its Commands sheet and the Input sheet's twentieth row a `(spec 5)` cartridge's alone, and a grid cartridge's views on its own sheets since 2026-10-15, version 4's two rows a `(spec 4)` cartridge's; the cell as the unit with two renderers of one model, the device sheets cell by cell with the Camera and the Write sheet among them, the four calls and their records, the frame's order and rate zero, the determinism rules, the cartridge's one file and its source, VLA with template macros, which the pass expands into the rows the engine loads, an act of its own at the command line or in the page, the host's duties, reflection and the rule that the step computes values and never formulas |
| `docs/ALGEBRA.md` | the horizon: design theory marked per idea and never a source of items; four readers of the engine, the course corrections a later specification might take, the crowds, and linear algebra as a first-class paradigm of the formula language, with its ladder; then a later sitting, the literature of computer science read for the engine's speed, monotonicity, extensibility and elegance, the engine read as an entity-component system among it |
| `engine/` | the `alonzo` crate: the engine's twelve exports over `vla-lang`'s machine and the pass (`src/abi.rs`), what the engine adds to it, the manifest, the device sheets' checks, its own sheets and the Clock's frame (`src/cartridge.rs`), and its own refusals (`data/messages.vla`); the pass, a cartridge's source expanded by the language's expander into the rows a load takes (`src/pass.rs`); the language crate its one dependency; a sand written by hand, `src/sand.rs`, which the tests and the runner hold Sand to, and a lattice written by hand, `src/superposition.rs`, which the tests, the runner and the session hold Superposition to, with the floors' scripted player and the deepest deal of a world; and a board written by hand, `src/seiyaku.rs`, which the tests hold Seiyaku to, with two solvers, backtracking over bits and exact cover, the grader of three techniques and the generator of its book; and a netlist written by hand, `src/naught.rs`, which the tests and the runner hold Naught to, with the bench's two circuits, its two placements, by fill and shuffled with every gate its own shape, and the census each plans; each cartridge's `describe`, its census of the plan among its rows, held to a golden in `testdata/describe/`; and five examples, `examples/frames.rs`, the native runner of the frame floors, `cargo run --release --example frames`, `examples/expand.rs`, the pass at the command line, `cargo run --release --example expand`, `examples/seiyaku.rs`, Seiyaku's book written into its source, `cargo run --release --example seiyaku`, `examples/naught.rs`, Naught's bench written into its source, `cargo run --release --example naught`, and `examples/play.rs`, a playtest's session of Sand played as the host plays it, every frame held to the sand by hand, `cargo run --release --example play`, and of Superposition played by the floors' scripted player through four worlds, `cargo run --release --example play -- cartridges/superposition/superposition.vla` |
| `web/` | the host shim, `host.js`, the loop of the specification's section 5; the fake module, `fake.js`, a double of the eleven exports the loop calls; the viewport, `viewport.js`, one plain script the first game takes as a file, which since `ENGINE.8` draws a grid cartridge's Screen for the host, a formula's value, the look map and the rows' heights read from the record, every frame's record replacing the last with the person's scroll and selection kept; and the page, built from `index.template.html` with the eleven cartridges, their sources and the library they include, and seven records the door printed, each text a block its builder writes, so that a game vendors the template unchanged (`ENGINE.15`). Opened plainly it is a full-screen player (`ENGINE.14`), opening on an empty sheet with the cartridges after it in the picker: the window the game's under a slim bar, a grid at its cells' own sizes with its sheet tabs answered by the host, and a drawer holding the log, any sheet live, the source built into the cartridge by the pass and loaded as two presses, and the replay played or copied; the Audio sheet sounds after Sound on. Its other modes are the bench: the loop's oracle, the render oracle, the viewport over the fixtures, and the blit's, the frame floors' and the render floors' instruments; `web/README.md` is the page and the APIs |
| `cartridges/` | the cartridges this repository ships, 0BSD so that one may be copied: `life/life.vla`, Conway's Life on a 320 by 200 plane, its first frame a seeded soup, and `gun/gun.vla`, Gosper's glider gun on the same plane, its pattern a Seed sheet: the two fixtures of the engine's frame floors; and `testcard/testcard.vla`, the plane's test card, every kind of value a Screen cell can hold under a Camera that pans a column a frame, the fixture of the frame path's oracle; and `inputcard/inputcard.vla`, the input card, every cell the host writes before a step drawn on a plane, the buttons of four players, the mouse, the wheel, the keys, the Clock and the dice, the fixture of the Input and Clock devices' oracle, with its replay beside it, `inputcard.replay.vla`, and the replay's golden, `inputcard.golden.vla`, the Tally sheet it ends in; and `soundcard/soundcard.vla`, the sound card, the Audio sheet's four voices playing the four waves, a scale, two chords and a slide under a swell, an eight-second loop, with a tick on every press, a Knobs sheet a person turns, a Log of the voices and a waterfall of the notes on the Screen, the fixture of the Audio device's oracle, with its replay beside it, `soundcard.replay.vla`, and the replay's golden, `soundcard.golden.vla`, the Log of the last 32 frames' voices it ends in; and `sand/sand.vla`, Sand, the first game, a falling-sand toy that opens raining Life's soup from its top third as grains of sand and water, painted with the mouse, sand, water, wall or empty picked with the keys, its rule a Stay sheet, a Side sheet and the Screen, each one fill, and a Tally of every row, the third fixture of the frame floors, with its replay beside it, `sand.replay.vla`, a person's painting session of 2,085 frames, and the replay's golden, `sand.golden.vla`, the Tally it ends in; and `gridcard/gridcard.vla`, the grid card, the first grid cartridge, every kind of value, format and look a grid cell can hold, drawn by the viewport through a Camera an edit moves, the fixture of the grid's oracle (`ENGINE.8`); and `kairos/kairos.vla`, Kairos, the stacking game in the shape of the arcade cabinet of 2004, the first game with a win and a loss: stop each row of lights over the row beneath, the minor prize at level 11 taken or refused, the major at 15, its board lying on its side on a plane in Lovelace Lavender, its Levels sheet the cabinet's operator menu in the open, every level's speed and window, with its replay beside it, `kairos.replay.vla`, the owner's two games of 3,469 frames, and the replay's golden, `kairos.golden.vla`, the Tally it ends in (`CART.4`); and `superposition/superposition.vla`, Superposition, the large board, a mine-clearing game on a lattice of 512 by 512 sites at rate zero, every site safe and decayed at once until it is observed: Space observes the site the selection stands on, B boxes it, C collapses a reading its boxes equal, N branches to another world, a decay observed counted and the experiment going on, a box beside a reading of nothing opened by the cascade that reaches it, each act's cascade settled inside it, `(settle 4096)`, its Field the grid itself, its sites from A1 and nothing past them, `(bound "Field")`, both the page's version 6, its lattice three layers of 262,144 formula cells, the Decays, the Readings and the Field, in Lovelace Lavender (`CART.12`), the fourth fixture of the frame floors, its idle frame, an act's latency over a scripted session and its deepest cascade, with its hand beside it, `superposition.hand.js`, its replay, `superposition.replay.vla`, the owner's session at its hand test, 18 acts over 118 frames in one world, carried onto the lattice at A1, and the replay's golden, `superposition.golden.vla`, the Tally's row sums it ends in; and `seiyaku/seiyaku.vla`, Seiyaku (制約, "constraints"), the owner's number-placement puzzle at rate zero, eighty-one variables in nine rows, nine columns and nine boxes, each a constraint holding each value from 1 to 9 once: 1 to 9 assign a value to the variable the selection stands on, Backspace retracts it, Q W E, A S D and Z X C mark a value in its domain, each key where its mark stands in the cell, F fills every unassigned domain with the values its constraints allow, R retracts every assignment, N deals a new instance and G moves the next one's grade; a violated variable drawn red, a given in bold digits, the satisfied board in Lovelace Lavender, and its keys listed beside the Board, which stands on the canvas's gray; its constraints counted as sums over nine planes of ones and zeros, overlapping ranges no other cartridge holds; its book 128 puzzles, 32 a grade, each with one solution, written into its source by `engine/examples/seiyaku.rs`, and every instance a symmetry of one of them (`CART.14`), with its hand beside it, `seiyaku.hand.js`, its replay, `seiyaku.replay.vla`, the owner's session at its hand test, and the replay's golden, `seiyaku.golden.vla`, the Constraints sheet it ends in; and `naught/naught.vla`, Naught: *Vel et Aut*, a bench of logic gates named in Latin at rate zero, NON, ET, VEL, AUT, NON-ET (Sheffer's stroke) and NEC (Peirce's arrow), each a macro of its source writing one formula of arithmetic over 0 and 1, VEL the greater of two and AUT the parity of their sum: a 16-bit ripple adder from A1 and an 8 by 8 array multiplier from I1, 400 gates laid by fill, every 1 in Lovelace Lavender, its switches values a person types on their cells, the palette writing each, and every gate they reach computed in the edit's frame, row 1 naming each column, the switches' letters and the gates' Latin names, the cartridge opening on its Lesson, a sheet of its own that teaches the bench, read-only, `(read "Lesson")`, the Bench a sheet a person types into, `(work "Bench")` (`SPEC.5`), the bench settling, `(settle 65536)`, so that the page opens it on its values, its bench a block of its source written by `engine/examples/naught.rs` (`CART.9`'s first slice, the instrument): the fifth fixture of the frame floors, the same bench at a 4,096-bit adder and a 64 by 64 multiplier, laid by fill and shuffled with every gate its own shape, whose difference is the regularity premium; with its hand beside it, `naught.hand.js`, the netlist and its writer in the page, its replay, `naught.replay.vla`, a stand-in of 38 switches written, and the replay's golden, `naught.golden.vla`, the Bench it ends in. Each is written as a source beside it, `<name>.source.vla`, the file to read and copy, which the pass expands into the cartridge; `common.vla` is the library of template macros the sources include, a sheet named once over a run of its rows, a palette, a palette with a name, the Keys sheet's labels and keys and the Audio sheet's header, to copy, change and outgrow; and, since `KIT.1`, the kit's first verbs, each one formula row named for what it means: the first frame, a press on its rising edge, a count, a hold and the dice, with a cartridge's sheets, its labels and headers, and the Keys sheet as the specification tabulates it; and, since `KIT.2`, the picture, a string a row of cells and a character a cell through a legend, PICO-8's hex digits or a cartridge's own, in which the gun's Seed is drawn; and, since `CART.4`, the verbs `every` and `since`, the look map, a still Camera and the Write sheet's row, which Kairos is written in |
| `tools/` | the checks: the import allowlist and the twelve exports read off the wasm, the one dependency held on the manifests and the lock, the license map verified against the tree, the page's offline doctrine and the host held to the Web Audio graph's own nodes, the fixtures' pins, the render oracle and the host loop's oracle under a headless browser, the cartridges held to the specification's section 7, the render and blit floors, the frame floors with their allocation ceilings, and the crate's package, the License and the NOTICE in it and no build-time include outside it; the builder of the page; the frame floors' instrument, `bench_frames.ps1`, which measures Life, Sand, Superposition and Naught natively and in the browser with Windows' power throttling opted out; and the runner that reports one total |
| `.github/workflows/` | `checks.yml`, the checks, the crate's build, lint and tests, its package built and its own tests run from it, and the page's build and oracle on every push and pull request, in three jobs side by side; `controls.yml`, the controls that prove each check on its mutants, nightly and by hand; `publish.yml`, the crate published to crates.io by hand from a release tag, a rehearsal unless asked to upload, with no stored token; and `pages.yml`, the page built from the engine's module and deployed to GitHub Pages at each release |

What the first release, 0.1.0, shows (`REPO.4`, `docs/RELEASES.md`): Conway's
Life on a 320 by 200 sheet, every cell the same formula of its eight
neighbors, stepping in 2.9 ms natively and 4.2 ms in the browser, 342 and
235 frames a second, where the bar the first release was to clear was
thirty. Counted as the floors count, that is 21.5 and 14.8 million cells a
second, against the charter's line of two million (`CART.1`; the floors'
tenth baseline, over `vla-lang` 0.9.3). A board of a million formula cells
steps at about 17 frames a second natively and 14 in the browser
(`ENGINE.9`). The first game after Life is a falling-sand toy (`CART.2`),
and the next a stacking game (`CART.4`), both built here. Where the games
after them live, one repository for them all or one each, is `REPO.5`'s to
decide; the first of them, Buffet, has its own. The engine is the crate
`alonzo` on crates.io, and its page is deployed at each release to
https://spreadsheet-company.github.io/Alonzo/.

## Building

A Rust toolchain with the `wasm32-unknown-unknown` target; the repository's
`rust-toolchain.toml` picks it for you. Then:

```text
cargo build --workspace
cargo build --release -p alonzo --target wasm32-unknown-unknown
```

The first fetches the language crate, `vla-lang`, from crates.io at the one
version `Cargo.toml` pins, or from Frazaro's repository at a commit while the
engine waits on a change the language has not yet released. The second writes
`target/wasm32-unknown-unknown/release/alonzo.wasm`, the module a page
loads. Its import section is read on every push and held to a list of the
host's functions and nothing else (`REPO.2`), the count zero today; its
export section to the specification's twelve names; and the engine's
dependencies, in the manifests and the lock, to the language crate alone.
`tools/build_web.ps1` then builds the page with the module in it.

## The rules

1. **VLA's seams are the interface, and Frazaro is a door.** The engine
   consumes `vla-lang` and never `frazaro-core`; a game's dependency tree
   holds the language crate and the engine crate and nothing of Frazaro's.
2. **Every early brick is also a Frazaro item, laid where it is first
   needed.** The item's ID stays Frazaro's; the code lands here when it is
   the clock's.
3. **Nothing the browser rents is rebuilt until a measurement says the rent
   is the bottleneck.** The rasterizer, the shaping engine and the fonts
   stay the browser's.
4. **Frazaro has no clock; Alonzo is the clock.** What can be a golden is
   the language's or Frazaro's; what can only be measured is the engine's.
5. **The engine's imports are the host's functions, named by hand and held
   to a list; the engine crate depends on the language crate and nothing
   else.** No generated glue, and no outbound network call, ever. The first
   specification needs no import at all: every device is a sheet read or
   written through the module's exports.
6. **Everything the engine holds is a cell of a named sheet, viewable and
   writable through the two calls.** The key map, the palette, the clock
   and the previous frame are sheets a person can open and change;
   `docs/SPEC.md` is the page that lays them out.
7. **The step computes values and never formulas.** A formula enters the
   grid by `load` or by a `write` made on a person's act; the engine's own
   effects write values. The grid writes the grid in data, through the
   Write sheet, and never in code, and a test holds it: the formula cells
   are equal before and after a step.

## Contributing, security, the name

A contribution enters by a device or a cartridge, and an accelerator enters
behind the reference's frames; `CONTRIBUTING.md` says what each needs.
Vulnerabilities go to the address in `SECURITY.md`, never to a public
issue. "Alonzo" is a name held by Spreadsheet Company; a fork is welcome
under the licenses and needs its own name (`TRADEMARK.md`).

## License

Apache-2.0 for the engine; 0BSD for the cartridges, so that one may be
copied to start your own; CC-BY-4.0 for the documents. `REUSE.toml` maps
every file. A game written on Alonzo is its author's.

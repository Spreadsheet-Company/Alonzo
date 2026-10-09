# Alonzo

*The browser's Lisp machine. A game engine in WebAssembly whose language is
VLA, whose scene is a grid of cells, whose devices are sheets, and whose
first game is Frazaro, the spreadsheet.*

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
Screen, an Audio, an Input, a Clock, a File, a Camera and a Write sheet
mapped into VLA's grid, as uxn's Varvara maps its devices into memory, and
a loop that writes
the input and clock cells, asks the language to step, reads the Screen
sheet and the effect cells, and draws. Every input is a cell the engine
writes. Every effect is a cell it reads. The engine's whole contract is
four calls into the language: load a cartridge, write cells, step, view.

A spreadsheet is a member of class game: a sheet of coloured cells is a
framebuffer, a cell that is a formula of its neighbours is a fragment
shader, and a recalculation is a frame. The thesis in one line: a
spreadsheet is a game whose frame rate is one, and an engine that can draw
sixty can draw one.

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
drives.

| File | What it is |
|---|---|
| `CHARTER.md` | the thesis, the honest bottom, the seven rules and the frame, the lineage, the social hypothesis stated so that it can fail, the first numbers, what is not built, the licence |
| `ROADMAP.md` | the open items, in the order each makes the next cheap, with the standing decisions `AD-1` to `AD-7` |
| `REARVIEW.md` | the closed ledger, the sittings, and each item's full scoping before it is built |
| `SPEC.md` | the specification, version 2: the cell as the unit with two renderers of one model, the device sheets cell by cell with the Camera and the Write sheet among them, the four calls and their records, the frame's order and rate zero, the determinism rules, the cartridge's one file, the host's duties, reflection and the rule that the step computes values and never formulas |
| `docs/ALGEBRA.md` | the horizon: design theory marked per idea and never a source of items; four readers of the engine, the course corrections a later specification might take, the crowds, and linear algebra as a first-class paradigm of the formula language, with its ladder |
| `engine/` | the `alonzo` crate: the engine's eleven exports over `vla-lang`'s machine (`src/abi.rs`), what the engine adds to it, the manifest, the device sheets' checks, its own sheets and the Clock's frame (`src/cartridge.rs`), and its own refusals (`data/messages.vla`); the language crate its one dependency |
| `web/` | the host shim, `host.js`, the loop of the specification's section 5; the fake module, `fake.js`, a double of the engine's eleven exports; the viewport, `viewport.js`, one plain script the first game takes as a file; and the page, built from `index.template.html` with the Life cartridge and seven records the door printed, with the loop's oracle, the blit's instrument, the render oracle and the render floors' instrument as its modes; `web/README.md` is the page and the APIs |
| `cartridges/` | the cartridges this repository ships, 0BSD so that one may be copied: `life/life.vla`, Conway's Life on a 320 by 200 plane, the fixture of the engine's floors |
| `tools/` | the checks: the import allowlist and the eleven exports read off the wasm, the one dependency held on the manifests and the lock, the licence map verified against the tree, the page's offline doctrine, the fixtures' pins, the render oracle and the host loop's oracle under a headless browser, the cartridges held to the specification's section 7, and the render and blit floors; the builder of the page; and the runner that reports one total |
| `.github/workflows/checks.yml` | the checks, the crate's build, lint and tests, and the page's build and oracle on every push and pull request |

What the first release shows: Conway's Life on a 320 by 200 sheet at thirty
frames a second, every cell the same formula of its eight neighbours; the
cells evaluated per second are the engine's first number, against a floor
of two million a second (`CART.1`). The first game after it is a
falling-sand toy, in a repository of its own (`CART.2`).

## Building

A Rust toolchain with the `wasm32-unknown-unknown` target; the repository's
`rust-toolchain.toml` picks it for you. Then:

```text
cargo build --workspace
cargo build --release -p alonzo --target wasm32-unknown-unknown
```

The first fetches the language crate, `vla-lang`, from Frazaro's repository
at the commit `Cargo.toml` pins, until it is on crates.io. The second writes
`target/wasm32-unknown-unknown/release/alonzo.wasm`, the module a page
loads. Its import section is read on every push and held to a list of the
host's functions and nothing else (`REPO.2`), the count zero today; its
export section to the specification's eleven names; and the engine's
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
   `SPEC.md` is the page that lays them out.
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
under the licences and needs its own name (`TRADEMARK.md`).

## Licence

Apache-2.0 for the engine; 0BSD for the cartridges, so that one may be
copied to start your own; CC-BY-4.0 for the documents. `REUSE.toml` maps
every file. A game written on Alonzo is its author's.

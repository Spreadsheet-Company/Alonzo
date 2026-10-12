# alonzo

**The browser's Lisp machine: a game engine in WebAssembly whose language
is VLA, whose scene is a grid of cells, and whose devices are sheets.**

A Lisp machine was a computer whose language went all the way down. Alonzo
is that idea in the one machine everyone already has, the browser, with the
honesty the browser imposes: it stops at the draw call, which is rented.
The language is VLA, the Lisp that Frazaro is written in, held to one
meaning by two implementations and a treaty, and cut into a crate of its
own, `vla-lang`. The scene is VLA's grid, a sheet of cells. The devices are
sheets too: a Screen, an Audio, an Input, a Clock and a File sheet, which
the engine writes before each step and reads after it, so that every input
is a cell the engine writes and every effect is a cell it reads. The first
game on it is Frazaro, the spreadsheet, because a spreadsheet is a game
whose frame rate is one, and an engine that can draw sixty can draw one.

## What this crate holds today

The engine's module. Built for `wasm32-unknown-unknown` it exports twelve
names and imports none: `alonzo_load` takes a cartridge's bytes and answers
a handle; `alonzo_write` takes rows in the one notation; `alonzo_step` takes
a budget in cells and may yield, so the page never freezes; `alonzo_view`
answers one window of a sheet as the view record or as the plane, a byte a
cell; with `alonzo_describe`, `alonzo_unload`, the memory pair, the ABI
number and the version beside them; and `alonzo_expand`, the pass below,
which takes no handle. The grid, its rows, the previous
frame's twin sheets, the step in dependency order and the views are the
language crate's, `vla-lang`'s machine; what this crate adds is what an
engine is:

- the cartridge's manifest, read by the language's own reader and refused
  by name when a directive is missing, doubled, unknown or out of range;
- the device sheets, Screen, Palette, Input, Keys, Clock, Audio, File,
  Camera and Write, each held to its layout at load and at every write, a
  formula refused where the host writes and a derived write refused where
  the host writes, the volatile functions refused with the Clock named;
- the engine's own sheets, made at load: the Clock's frame, rate and seed,
  the File's name and size, and the Input sheet when a cartridge holds none;
- the frame number written into the Clock as the first act of every step,
  the only clock there is;
- `describe`, the manifest, the devices and the budget, and the engine's
  own refusals, a catalogue of ten in `data/messages.vla`: the ninth a
  cartridge's source handed to the load, which never expands, and the tenth
  a person's write into the Clock, its frame, or a rate or a seed outside
  its range (`ENGINE.3`).

Beside the engine, the pass (`src/pass.rs`, `SPEC.md` section 7.8): a
cartridge's source, VLA with template macros and `include`s, expanded by the
language's own expander into the rows a load takes, as an act of its own
that no load calls. It reads no file, so the command line and the page run
the same function to the same bytes: at the command line it is the example
`examples/expand.rs`, which writes each `<name>.vla` beside its
`<name>.source.vla` and loads it after,

```text
cargo run --release --example expand                 # every cartridges/<name>/<name>.source.vla
cargo run --release --example expand -- --check      # the same, compared and written nowhere
```

and in the page it is the module's twelfth export, `alonzo_expand`, which
the engine panel's Build calls and the page's loop oracle holds to the
command line's bytes. A test holds every cartridge of the repository to its
source's expansion, byte for byte. The pass knows no macro by name: the repository's
library, `cartridges/common.vla`, is a file a cartridge includes, copies or
outgrows like any other.

Its tests hold the two projections of a window to one another: the plane of
a window is the view record of the same window, byte for value, the record
read with the language's own reader, every frame of the repository's test
card, a cartridge holding every kind of value a Screen cell can under a
Camera that pans a column a frame, and Life at its corners (`ENGINE.2`).
And one plays every committed replay, the input card's and the sound
card's, as `SPEC.md` section 7.6 plays one, the derived writes the Write
sheet leaves before each frame's rows, to the golden beside it, byte for
byte, so the host's player and the engine alone end in the same sheet
(`ENGINE.3`, made general over every folder holding a replay by `ENGINE.4`).

The host that drives it is the repository's `web/host.js`, whose frame path
over this module, the plane viewed and blitted, is held to the same floors
as over its double; the language keeps the Screen's plane at each frame's
end, so a view is a copy. The host sounds the Audio sheet too (`ENGINE.4`):
this module holds the sheet's layout and checks it at
load and at a write, and the host reads the four voices after each step and
schedules the Web Audio graph's own oscillators and gains from them; the
module computes no sound. What comes next, in the order `ROADMAP.md` lays
it: File (`ENGINE.5`); and the
accelerators, each behind the naive evaluation's frames as its reference
(`ENGINE.6`), after the naive evaluator's own costs, which the benchmark
measured first and which are the language's to remove; the first of them
are gone, and the twin's values kept as an array is the next.

## The rules that bind every line

- The engine consumes `vla-lang` and never Frazaro's core: a game's
  dependency tree holds the language crate and the engine crate and nothing
  of Frazaro's. A game written in English is translated by Frazaro at build
  time and ships as VLA.
- The engine has a clock, and the language has none. What can be a golden
  is the language's; what can only be measured is the engine's.
- The engine's imports are the host's functions, named by hand as
  `extern "C"` and held to an allowlist read off the artifact on every
  push, its exports to the specification's twelve names; the crate depends
  on the language crate and nothing else, which a check reads off the
  manifests and the lock. It makes no outbound network call, ever.
- Nothing the browser rents is rebuilt until a measurement says the rent is
  the bottleneck: the rasterizer, the shaping engine and the fonts stay the
  browser's.

## What the first release shows

Conway's Life on a 320 by 200 sheet at thirty frames a second, every cell
the same formula of its eight neighbours, drawn through the canvas; its
cells evaluated per second are the engine's first number, against a line
of two million a second, and the cartridge ships with the engine as its
demo (`CART.1`). The first game after it is a falling-sand toy, Sand
(`CART.2`), built here first and then in a repository of its own.

The benchmark runs from a clone:

```text
cargo run --release --example frames            # Life's soup, Gosper's glider gun and Sand's opening, 31 frames each
cargo run --release --example frames -- --check # 4 frames each, the frames and the allocations held
```

Each frame is one step, timed alone, and held to a Life written by hand, or
for Sand to a sand written by hand (`src/sand.rs`, which the engine's tests
hold Sand to as well), before any number is printed; the steady frames' median gives the cells
evaluated a second and the frames a second. A frame under 2 ms, the glider
gun's, is timed again in runs of consecutive frames, as the browser's page
times one, since a frame of microseconds timed alone measured the clock
beside it as much as the step. Before a fixture's first frame and after its
steady frames, and never between two frames, where it slowed the frame after
it, the same hand-written Life runs a fixed workload, and a run whose clock
moved more than 10%, as Windows' power throttling moves it in a background
process, is named and prints no baseline. The check mode counts the allocations of a
frame, an exact number the repository's checks hold to a ceiling. On the
day the benchmark was first measured, Life stepped at about 218,000 cells a
second natively and 229,000 in the browser, about a ninth of the line, and
the engine's own profile of that step named where the rest went
(`REARVIEW.md`, `CART.1`). The first of it, the evaluator's hot path, was
made cheaper bit for bit in the language (Frazaro's `KERNEL.25`): a step
makes 4.0 allocations a cell where it made 71, and Life steps at about
623,000 cells a second natively and 461,000 in the browser, about a third
and nearly a quarter of the line. The rest came with the language's 0.9.0
(Frazaro's `KERNEL.20`, `KERNEL.26` and `KERNEL.27`): a frame computes only
the cells a change reaches, a formula filled over many cells is computed at
all of them at once, and a frame makes 80 allocations. Life now steps in
2.8 ms natively and 4.3 ms in the browser, about 357 and 235 frames a
second, eleven and nearly eight times its rate of thirty; counted as the
floors count, the frame's 62,964 formula cells over its time, that is 22.5
million and 14.8 million cells a second, past the line, though a frame no
longer computes every cell (the owner's run of 2026-10-11). Sand's opening,
the worst stretch of the toy, three eighths of the board falling at once
through a chain two hundred rows deep, steps in about 12 ms natively and
17 ms in the browser, about 60 frames a second against its rate of thirty
(`CART.2`'s first slice, the owner's run of 2026-10-11, the floors' fourth
baseline). Since the third slice the opening rains water with the sand,
half the soup's grains, through a rule of three sheets where it was two:
about 12.5 ms natively and 18.7 ms in the browser, over half again the
formula cells (the build's run of 2026-10-12 over `vla-lang` 0.9.1; the
floors' fifth baseline is the owner's).

## Where it comes from

The repository is `Spreadsheet-Company/Alonzo`, beside Frazaro, whose
`core/` is the crate the language is cut out of. `CHARTER.md` there holds
the thesis, the rules, the lineage and the social hypothesis stated so that
it can fail; `ROADMAP.md` the open items; `REARVIEW.md` the record.

## Licence

Apache-2.0. The cartridges in the repository are under 0BSD, so that one
may be copied to start your own; a game written on Alonzo is its author's.
The repository's `REUSE.toml` maps every file to its licence.

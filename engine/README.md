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

The engine's module. Built for `wasm32-unknown-unknown` it exports eleven
names and imports none: `alonzo_load` takes a cartridge's bytes and answers
a handle; `alonzo_write` takes rows in the one notation; `alonzo_step` takes
a budget in cells and may yield, so the page never freezes; `alonzo_view`
answers one window of a sheet as the view record or as the plane, a byte a
cell; with `alonzo_describe`, `alonzo_unload`, the memory pair, the ABI
number and the version beside them. The grid, its rows, the previous
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
  own refusals, a catalogue of eight in `data/messages.vla`.

Its tests hold the two projections of a window to one another: the plane of
a window is the view record of the same window, byte for value, the record
read with the language's own reader, every frame of the repository's test
card, a cartridge holding every kind of value a Screen cell can under a
Camera that pans a column a frame, and Life at its corners (`ENGINE.2`).

The host that drives it is the repository's `web/host.js`. What comes next,
in the order `ROADMAP.md` lays it: the frame path's floor over this module
(`ENGINE.2`); the Input and Clock devices finished
(`ENGINE.3`), Audio (`ENGINE.4`) and File (`ENGINE.5`); and the
accelerators, each behind the naive evaluation's frames as its reference
(`ENGINE.6`).

## The rules that bind every line

- The engine consumes `vla-lang` and never Frazaro's core: a game's
  dependency tree holds the language crate and the engine crate and nothing
  of Frazaro's. A game written in English is translated by Frazaro at build
  time and ships as VLA.
- The engine has a clock, and the language has none. What can be a golden
  is the language's; what can only be measured is the engine's.
- The engine's imports are the host's functions, named by hand as
  `extern "C"` and held to an allowlist read off the artifact on every
  push, its exports to the specification's eleven names; the crate depends
  on the language crate and nothing else, which a check reads off the
  manifests and the lock. It makes no outbound network call, ever.
- Nothing the browser rents is rebuilt until a measurement says the rent is
  the bottleneck: the rasterizer, the shaping engine and the fonts stay the
  browser's.

## What the first release shows

Conway's Life on a 320 by 200 sheet at thirty frames a second, every cell
the same formula of its eight neighbours, drawn through the canvas; its
cells evaluated per second are the engine's first number, against a floor
of two million a second, and the cartridge ships with the engine as its
demo (`CART.1`). The first game after it is a falling-sand toy, in a
repository of its own (`CART.2`).

## Where it comes from

The repository is `Spreadsheet-Company/Alonzo`, beside Frazaro, whose
`core/` is the crate the language is cut out of. `CHARTER.md` there holds
the thesis, the rules, the lineage and the social hypothesis stated so that
it can fail; `ROADMAP.md` the open items; `REARVIEW.md` the record.

## Licence

Apache-2.0. The cartridges in the repository are under 0BSD, so that one
may be copied to start your own; a game written on Alonzo is its author's.
The repository's `REUSE.toml` maps every file to its licence.

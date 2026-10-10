# Contributing to Alonzo

*Short on purpose, in Frazaro's shape: what has to exist before the first
outside patch, not after.*

## Sign your commits (DCO)

Contributions are accepted under the [Developer Certificate of
Origin](https://developercertificate.org/) 1.1. Sign each commit:

```text
git commit -s
```

That adds a `Signed-off-by:` line certifying you wrote the change or have
the right to submit it. There is no Contributor License Agreement, and there
will not be one: every file's licence is permissive enough that none is
needed.

## Inbound = outbound

By contributing, you agree your contribution is licensed under the licence
of the file it touches, as declared in `REUSE.toml`:

| Path | Licence |
|---|---|
| `engine/**`, `web/**`, `tools/**`, the workspace's own files | Apache-2.0 |
| `cartridges/**` | 0BSD |
| `*.md` at the root, `docs/**` | CC-BY-4.0 |

## What a change needs

- **A device** is a sheet's layout written into `SPEC.md` first, with its
  direction, input or effect, and its row among the host's duties; then
  its code in the shim, and in the engine where a layout is checked
  (`AD-6`). The first specification has no import at all: every device is
  a read or a write through the module's exports (`SPEC.md`, section 8).
  A device that needs one is an `extern "C"` function the host shim
  provides under the one module name `alonzo`, its name added, as
  `alonzo.<function>`, to the allowlist `tools/check_host_imports.ps1`
  holds, with the count beside it. An import that is not on the list fails
  the check on every push, a forbidden name (`fetch` first) fails even when
  listed, a listed name the engine no longer imports fails too, and the
  list grows by a reviewed line, never by a generated one (`AD-5`).
- **A refusal** the engine raises is an entry of its own catalogue,
  `engine/data/messages.vla`, the `cart` family, an id, a number, a source
  and a template whose slots the code fills, read by the language crate's
  mechanism; its text names the cell it stands on as `sheet!addr` and
  leaves the row's line to the record's field. A refusal of the grid, the
  view or recalculation is the language crate's and changes in Frazaro,
  never here. An export added to the engine is a line in `SPEC.md`'s table
  first, then in `tools/check_host_exports.ps1`'s list with its count.
- **A cartridge** is a VLA program and its sheets, with a Palette sheet.
  One that ships in this repository is a fixture of a floor or a demo, and
  carries 0BSD. A game is a repository of its own, under its author's name
  and terms. Its formulas are fixed at load: the step computes values and
  never formulas, and a cartridge that keeps a state writes it through the
  Write sheet as a value (`AD-7`; `SPEC.md`, section 3.9). A change to the
  engine or to the language that lets a step install a formula fails
  `AD-7`'s test and is not merged.
- **An accelerator** needs its oracle before it is merged: the naive
  every-cell evaluation is the reference, and the accelerator's frames must
  equal its frames on the fixtures, as a second implementation follows the
  goldens in Frazaro (`SD-18`'s shape). A faster engine with no oracle is
  not merged (`ENGINE.6`).
- **A floor** never goes down. The frame floors and the render floors are
  hand-maintained baselines in `tools/`; raising one is a commit, and
  lowering one is a reviewed act with its reason in the message. A change
  meant to make the engine faster is measured on its own benchmark, Life's
  soup and the glider gun (`CART.1`): `cargo run --release --example frames`
  steps both, holds every frame to a Life written by hand, and prints their
  cells a second, and `tools/bench_frames.ps1` measures the browser's half
  beside it; the frame floors rise with the change, and the allocation
  ceilings `tools/check_frame_floors.ps1` holds on every push fall with it.
- **The viewport** (`web/viewport.js`, the Screen device in grid mode) is
  held by the render oracle, every draw where the record puts it under
  `tools/check_render_oracle.ps1`, whose expectations live in the page and
  are never the viewport's own; by the fixtures' pins, the door's records
  byte for byte; by the offline doctrine over its source; and by the render
  floors, the owner's measurement in a real browser. A draw that moves on
  purpose is first reworded in the page's oracle; a draw that slows is
  measured before it is merged. Frazaro's page takes the file as a copy, so
  a change here is a copy there.
- **A roadmap ID** is minted in `ROADMAP.md`, in its family, and never
  reused; an item that is Frazaro's by ID keeps Frazaro's ID.
- **A commit** is titled `<ID>: <the claim, in plain English>`; its body
  gives the defect and the fix, then `Pins:`, `Floors:` and `Docs:`.

Run the checks before you open a pull request: `tools/run_checks.ps1`, one
line a check and one total, and `-WithExtras` for the controls that prove
each check on mutants; beside it the Cargo oracle, `cargo build --workspace`,
`cargo fmt --all -- --check`,
`cargo clippy --workspace --all-targets -- -D warnings`,
`cargo test --workspace`, and the wasm build, whose import section the first
check reads. CI runs all of it on every push and pull request
(`.github/workflows/checks.yml`): the checks under Windows PowerShell 5.1,
and again under pwsh beside the wasm it builds.

## The devices and the cartridges are the seams

The engine is a kernel of the clock's kind: the loop, the devices, the
renderer, the frame path and the floors, and nothing of the language's,
which lives in `vla-lang` and enters by its own seams in Frazaro's
repository. A contribution enters here by a device or by a cartridge, each
with the oracle above. A feature that is neither is a device to design
first, on the roadmap, not a feature to merge.

## Security

Do not open a public issue for a vulnerability. See `SECURITY.md`.

## The name

"Alonzo" is a name held by Spreadsheet Company; see `TRADEMARK.md`. A fork
is welcome under the licences above and needs its own name.

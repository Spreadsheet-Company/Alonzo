# Releases

*Newest first, as Frazaro keeps its `docs/RELEASES.md`. A release's section is written before its tag, never after: `REPO.4` began this file with the first, `0.1.0`. Each section says what the release holds and what it measures, names the items in it by their IDs (`ROADMAP.md` for the open, `REARVIEW.md` for the closed), says what it does not hold, and ends with a short* Known open security items *block that points to `SECURITY.md` rather than copying it.*

## 0.1.1

The player: the engine's page, opened plainly, is a full-screen player, and a grid cartridge's sheet tabs, wheel and wide numbers behave as a spreadsheet's do (`ENGINE.14`). The engine crate's code is unchanged, its refusals aside, and it is still pinned to `vla-lang` 0.9.3 exactly; what changed is the page, served at https://spreadsheet-company.github.io/Alonzo/. In a crate's manifest, `alonzo = "=0.1.1"` and, for the types its calls answer, `vla-lang = "=0.9.3"`.

### What it holds

- **The player.** The page opened plainly is the game's window: the Screen fills it under a slim bar holding the cartridge, Run, Pause, Sound, Load, the frame, the latest sentence (red when it is a refusal), Full screen and the drawer. A plane is drawn at the largest whole number of device pixels a cell that fits, and refitted when its box changes; a grid is drawn at its cells' own sizes. The drawer opens on the right and pushes the Screen aside, never covering it. It holds the frame line, the edit row, the log, the sheets, the source with Build, the cartridge and the library, the replay with Play and Copy, and the module's line. Full screen is the browser's, with the bar kept.
- **The sheet tabs answered.** A grid cartridge's own tabs show their sheet when clicked, and so do the tabs of the drawer's sheets, for any cartridge. The sheet shown is viewed, and only it, through the region in view, never whole. The Screen's tab gives back the Camera's window. A cartridge with many sheets wraps its tabs onto further rows.
- **The wheel and the pointer.** Over the Screen, the wheel is the game's over the window's cells alone; over the tabs, the headers and the scrollbars, it scrolls. While another sheet shows, the pointer and the wheel are the viewport's and the keys the Keys sheet binds stay the game's, so a person may play while watching a sheet. The viewport no longer counts its scrollbars or its tab strip as cells, so a click on a tab is never the game's.
- **A number too wide for its column draws #s,** as Excel does under a fixed number format, and its value is unchanged. In 0.1.0 such a number lost its leading digits: 1,073,741,912 in a narrow column read ")73741912".
- **The bench** is the same page's other modes, unchanged: `?loop=1`, `?oracle=1`, `?blit=1`, `?bench=1` and `?frames=1`. The fixtures' viewport and its paste box, which the plain page held, have a mode of their own, `?viewport=1`.
- **The documents moved into `docs/`:** the charter, the specification, the roadmap, the ledger and these notes, beside `docs/ALGEBRA.md`. The engine's refusals cite `docs/SPEC.md` by its new path, which makes the module 56 bytes larger.

### What it measures

Measured 2026-10-14 on the machine that measured 0.1.0 (`ENGINE.14`'s record in `REARVIEW.md`):

- **A sheet viewed through the region in view.** Natively, a full screen of Sand's Stay sheet, 1,500 cells, is viewed in 33 ms wherever it stands in the sheet, the median of nine runs. The whole sheet, 62,964 cells, took over a second and 34 MB, which is why the host never views a sheet whole. In the browser, the drawer refreshes Stay through `A1:G12` in 1.7 ms.
- **The frame floors** are 0.1.0's tenth baseline: neither the engine nor the language changed.

### The items in it

- **Closed:** `ENGINE.14`, the player, with its line in `REARVIEW.md`'s ledger.
- `KERNEL.5`'s viewport, laid here and still open, gains the #s, a hit test bounded by its cells and a tab strip that wraps. Frazaro's copy takes them when it takes the file.
- `SPEC.md` stays at version 3, with dated corrections to §3.1 (the #s), §3.3 (the wheel and the pointer) and §8.3 (the tabs answered).

### For a page that carries the host

The host has four new methods, described in `web/README.md`. `answer(viewport, event)` answers a viewport's `sheet` event. `showSheet(viewport, name)` and `refreshSheet(viewport, moved)` let a page's own viewer show a sheet and keep it current through the region in view. `refit()` draws the last plane again at the scale its box now fits.

### Not in this release

- What 0.1.0 left out: the File device (`ENGINE.5`), the accelerators (`ENGINE.6`), edit and continue (`ENGINE.7`), proof of play (`ENGINE.10`) and the network (`REPO.6`).
- The grid drawn from the `values` projection (`ENGINE.8`'s second slice). Until it lands, a full screen of long formulas costs about a frame at 30 frames a second to view, its formulas' texts nearly all of it.
- A scroll or a dropdown for the tabs of a cartridge with dozens of sheets. The tabs wrap.
- Excel's General format, which rounds a number or writes it with an exponent before it falls back to #s. A number here is never respelled.

### Known open security items

**None.** The engine imports nothing and makes no outbound call, ever; the page, the player included, fetches nothing. Both are checked on every push, by `tools/check_host_imports.ps1` and `tools/check_web_offline.ps1`. `SECURITY.md` is the policy and the place to report.

## 0.1.0

The first release: the engine crate, `alonzo`, on crates.io, pinned to `vla-lang` 0.9.3 exactly, and the engine's page, built by CI from the same module and served at https://spreadsheet-company.github.io/Alonzo/. In a crate's manifest, `alonzo = "=0.1.0"` and, for the types its calls answer, `vla-lang = "=0.9.3"`.

### What it holds

- **The engine's module.** Built for `wasm32-unknown-unknown`, it imports nothing and exports twelve names: the four calls of `SPEC.md` §4, `alonzo_load`, `alonzo_write`, `alonzo_step` and `alonzo_view`, each with an explicit handle; `alonzo_describe` and `alonzo_unload`; the memory pair, the ABI number and the version text, `alonzo 0.1.0 (vla-lang 0.9.3)`; `alonzo_expand`, the pass; and the memory. It is 749,162 bytes.
- **The devices**, each a sheet held to its layout at load and at every write: Screen, as a plane of bytes or a grid, Palette, Input, Keys, Clock, Audio, File, Camera and Write. The Clock's frame is written first at every step, the only clock there is. The engine has its own catalog of ten refusals, the `cart` family.
- **The pass.** A cartridge's source, VLA with template macros and includes, is expanded into the rows a load takes by the same function at the command line and in the page (`SPEC.3`).
- **The page**, `web/index.html`, one file that fetches nothing. It holds the viewport (`KERNEL.5`, laid here) and the host's loop at a fixed timestep (`ENGINE.1`, `ENGINE.2`). It has the Input and Clock devices and a recorder and player of replays (`ENGINE.3`), and sounds the Audio device's four voices on Web Audio's own nodes (`ENGINE.4`). Grid-mode cartridges are drawn through the viewport (`ENGINE.8`'s first slice).
- **The cartridges**, under 0BSD so that one may be copied to start your own. Life and Gosper's glider gun are the benchmark (`CART.1`), beside Sand (`CART.2`), Kairos (`CART.4`), and the test, input, sound and grid cards. Each is written as a source over the kit, `cartridges/common.vla` (`KIT.1`, `KIT.2`).

### What it measures

The frame floors' tenth baseline (`tools/check_frame_floors.ps1`), measured 2026-10-14 over `vla-lang` 0.9.3 on one machine (an Intel Core Ultra 7 265KF under Windows 11, Chrome 155 headless), both halves opted out of Windows' power throttling and on the performance cores:

- **Life on its 320 by 200 board.** A frame takes 2.9 ms natively and 4.2 ms in the browser, 342 and 235 frames a second. The bar this release was to clear was thirty (`CHARTER.md` §7), so the browser clears it nearly eight times over. Counted as the floors count, that is 21.5 and 14.8 million cells a second, against the charter's line of two million.
- **Sand's opening**, the toy's worst stretch: 3.9 ms a frame natively and 5.9 ms in the browser.
- **The size ladder** (`ENGINE.9`). A board of a million formula cells, 1280 by 800, steps in 58.3 ms natively and 70.0 ms in the browser, about 17 and 14 frames a second, holding about 472 and 385 MB. Frame, load and memory grow in proportion to the cells, and a grid is capped at 1,048,576 cells.
- **The glider gun's idle frame**: 0.028 ms natively and 0.039 ms in the browser.

### The items in it

- **Closed**, each with its line in `REARVIEW.md`'s ledger:
  - `REPO.1`, the skeleton, and `REPO.2`, the import allowlist.
  - `SPEC.1`, `SPEC.2` and `SPEC.3`, the specification's three versions.
  - `ENGINE.1`, the host and the loop; `ENGINE.2`, the frame path; `ENGINE.3`, the Input and Clock devices and the replay; `ENGINE.4`, the Audio device; `ENGINE.9`, the size ladder.
  - `KIT.1` and `KIT.2`, the kit's first verbs and the picture.
  - `CART.1`, Life the benchmark; `CART.2`, Sand; `CART.4`, Kairos; `CART.11`, Buffet, founded as a repository of its own.
- **Laid here**, its ID Frazaro's: `KERNEL.30`, the census `describe` prints, closed there. `KERNEL.5`, the viewport, is built here and stays open until Frazaro's ledger closes it.
- **Carried with its first slice**: `ENGINE.8`, grid-mode cartridges drawn.
- **This release itself**: `REPO.4`.

### For packagers

- **License files.** The package carries the License's text and the NOTICE, `LICENSE` and `NOTICE`, as the Apache License asks of whoever passes a crate on.
- **Tests.** The package's own tests build and run. The tests that read the repository's `cartridges/` read it at run time and stand down by name without it; the rest run. A clone runs them all, and CI fails a stand-down there.
- **Examples.** The three examples, the floors' runner, the pass's command line and the playtest session, read the repository's cartridges, so they are left out of the package. They run from a clone.
- **The pin.** `vla-lang` is pinned exactly, `=0.9.3`, and `alonzo`'s calls answer the language's own types (`Cartridge::machine`, the `Step` a step answers). So a release of the language is a release of the engine.

### Not in this release

- The File device (`ENGINE.5`).
- The accelerators (`ENGINE.6`).
- Edit and continue (`ENGINE.7`).
- The grid drawn from the `values` projection (`ENGINE.8`'s second slice). The module already answers `values` (`SPEC.md` §4.5).
- Proof of play (`ENGINE.10`).
- The network: `REPO.6`, its gate, and the items behind it.

### Known open security items

**None.** The engine imports nothing and makes no outbound call, ever; the page fetches nothing. Both are checked on every push, by `tools/check_host_imports.ps1` and `tools/check_web_offline.ps1`. `SECURITY.md` is the policy and the place to report.

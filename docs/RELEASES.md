# Releases

*Newest first, as Frazaro keeps its `docs/RELEASES.md`. A release's section is written before its tag, never after: `REPO.4` began this file with the first, `0.1.0`. Each section says what the release holds and what it measures, names the items in it by their IDs (`ROADMAP.md` for the open, `REARVIEW.md` for the closed), says what it does not hold, and ends with a short* Known open security items *block that points to `SECURITY.md` rather than copying it.*

## 0.1.5

Edit and continue. A rebuilt source is applied to the running game, its frame number and its state kept (`ENGINE.7`): the drawer's Apply the source builds the source and writes the rows it changed into the game at the next frame, as a person's edit the replay records. The engine crate's code is 0.1.4's and still pinned to `vla-lang` 0.9.4 exactly; what changed is the page, served at https://spreadsheet-company.github.io/Alonzo/. In a crate's manifest, `alonzo = "=0.1.5"` and, for the types its calls answer, `vla-lang = "=0.9.4"`.

### What it holds

- **Edit and continue.** Apply the source, beside Build the cartridge in the drawer, builds the source as Build does and applies the cartridge it writes to the game that runs. The cartridge is compared with the one the grid was last given, row by row, a cell or formula row by its sheet and its address. The rows it changed or added, values and formulas alike, are written as one person's edit at the next frame's start, all or none, and the frame number and every other cell are kept. The replay records them as a person's edits under the cartridge loaded, so a session of rule changes replays from it.
- **What a continue cannot carry is said, and Load offered.** A line of the manifest, a sheet added or removed, a row that is no cell or formula row (a column's width, a format, a name), or a removed row's cell that no rebuilt row writes, since no write empties a cell. A load of the rebuilt cartridge in a second handle, given back at once, first refuses whatever Load would, so a continue applies no cartridge Load refuses. Paused, a continue waits for Run; at rate 0 it is one edit and one step; while a replay plays it is refused, as an edit is.
- **The host's call** is `apply(text)`, its comparison alone `AlonzoHost.compareCartridges(base, rebuilt)`, and its counters `applied` and `appliedRefused`.
- **The host loop's control runs each mutant page's own cases alone** (`?loop=1&cases=`), in about 4 minutes where it took 12.

### What it measures

In headless Chrome 155 on the owner's machine, from the press to the frame that computes the rows:

- **Buffet's rule**, a formula over 4 cells, applied at frame 1,806 in 12.7 ms. The route it replaces, Build, Load and a replay back to the frame, took a minute at Buffet's rate.
- **Sand's Stay rule**, 62,568 cells, applied at frame 2,096 in 0.32 s, where the route took 35 s. The load in a second handle is 0.16 s of it, and the whole of a color's continue.

The floors and the module, 766,043 bytes, are unchanged.

### The items in it

- **Closed**, with its line in `REARVIEW.md`'s ledger: `ENGINE.7`, edit and continue.
- **Minted**: `ENGINE.21`, a column's width and a row's height fitted to what they hold by a double-click on a divider.

### For a game that carries the page

Take the template and the three scripts again; the module built over `vla-lang` 0.9.4 serves as it did, its exports unchanged. The drawer gains Apply the source, and a game's page runs the loop oracle's `continue` case, nine cases in all.

### Not in this release

- A key in the source's box that applies it.
- A write that empties a cell, which would let a continue apply a row the source no longer has: the language's, asked of Frazaro.
- Key chords, a cartridge loaded from a file (`ENGINE.5`) or an address (`REPO.6`), the accelerators (`ENGINE.6`), proof of play (`ENGINE.10`) and auto-fit (`ENGINE.21`).

### Known open security items

**None.** The engine imports nothing and makes no outbound call, ever; the page fetches nothing, and a built page's blocks are held to the repository's files both ways. Both are checked on every push, by `tools/check_host_imports.ps1` and `tools/check_web_offline.ps1`. `SECURITY.md` is the policy and the place to report.

## 0.1.4

The views on sheets and the frame read by its changes. A grid cartridge written to the page's version 4 is played on its own sheets (`ENGINE.18`). A frame is read by what changed since the last one: a still frame is neither viewed nor painted, and a changed one is patched and repainted cell by cell (`ENGINE.17`, `ENGINE.19`, `ENGINE.20`). The bench runs over a game's own cartridges (`ENGINE.16`). The engine crate reads a `(spec 4)` cartridge and is pinned to `vla-lang` 0.9.4 exactly, for its `changes` projection. The page is served at https://spreadsheet-company.github.io/Alonzo/. In a crate's manifest, `alonzo = "=0.1.4"` and, for the types its calls answer, `vla-lang = "=0.9.4"`.

### What it holds

- **The views on sheets.** A cartridge that says `(spec 4)` opens on the sheet its Camera's third row names, else on its first visible sheet, so a Screen it hides is never opened on. A change of that row shows the sheet it names, and the person's tabs win between its changes. The Input sheet's nineteenth row names the sheet shown, and the pointer over any cell of it is the game's. A replay's header names its cartridge's version. A cartridge written to versions 1 to 3 loads, describes, opens, points and replays exactly as before (`SPEC.md`, version 4).
- **Every sheet drawn from the values view.** A sheet shown in the Screen's place is drawn from `values` after frame 0, as the Screen is.
- **A still frame not drawn again.** A frame whose record of the Screen, or of a sheet in its place, is the one the viewport holds is neither loaded nor painted, and is counted in `stills`. A load, a tab and `redraw()` always draw.
- **A frame read by its changes.** The host asks the language for a window's changes since the frame it holds, and lays them on the held record and the viewport's model in place, so a patched frame views nothing. Every device sheet is read the same way, and only the Input rows that changed are written. Every replay keeps its bytes. The host counts `patches` and `inputsKept`.
- **A patch repainted cell by cell.** The viewport paints again only the cells a patch names, each with the span its text spills over and the span of a text on its left that spills into it, by the full paint's own steps under a clip. It paints whole when the canvas is not the model's current full paint, or the patch names more than a quarter of the cells in view. Its opaque lines are filled a device pixel wide, the same pixels on the GPU, so that every rasterizer paints a repaint's lines as the full paint's.
- **The bench over a game's own cartridges.** On a game's page `?loop=1` runs the eight cases that need nothing of Alonzo's own files, over the page's own blocks. A game's replays are held to its own hand, a block `hand-<cartridge>`.

### What it measures

In headless Chrome 155 at the owner's full screen, 2,560 by 1,440 at a pixel ratio of 1.5:

- **A still frame**, the main thread's work, from 2.8 to 3.3 ms down to 0.8 to 1.0 over a card that changes once in 30 frames (`ENGINE.17`), and since `ENGINE.19` down to 0.49 to 0.56 there and to 0.42 to 0.46 over Buffet's Stocks. Its module calls in V8 fell from 226 µs to 13.
- **A market day on Buffet's Stocks**, a patch of about three cells, from 1.3 to 1.7 ms of main thread to 0.6 to 0.8 (`ENGINE.20`). A window that changes about eight cells at every frame fell from 1.3 ms to 0.6 to 0.7.

The floors:

- **The blit floors' fifth baseline**, the owner's `?blit=1` in Chrome 155 in fullscreen: the still row's p50 fell from 0.8 ms to 0.2.
- **The frame floors' eleventh baseline**, the owner's run over `vla-lang` 0.9.4: the Memory ceilings of Life and the gun rose by exactly 1,536 bytes at every rung, the room a frame's end keeps for its changes.
- **The render floors** keep their baseline of 2026-10-08. The owner's `?bench=1` of 2026-10-15 is worse than it on most rows, and the same on the page before and after `ENGINE.20`. The slip came between the baseline's day and `ENGINE.19`, with Chrome 155 among the changes; it is recorded as a finding in `REARVIEW.md`, not pasted.
- **The module** is 766,043 bytes, from 749,218.

### The items in it

- **Closed**, each with its line in `REARVIEW.md`'s ledger: `ENGINE.16`, the bench over a game's own cartridges; `ENGINE.17`, a still frame not drawn again; `ENGINE.18`, the views on sheets; `ENGINE.19`, a frame read by its changes; and `ENGINE.20`, a patch repainted cell by cell.

### For a game that carries the page

Take the template and the three scripts again, and the module built over `vla-lang` 0.9.4.
- The host asks for `changes`. A module over 0.9.3 refuses the projection, and the host then views every frame whole, as 0.1.3 did.
- The viewport adds `patch`, `patches()` and `repaints()`, and the option `willReadFrequently` for a page that reads its pixels back. The host passes it through its option `viewport`.
- A game's replays are held to its hand, if it adds one as a block `hand-<cartridge>`, where one registers its constructor under the cartridge's name.
- A game whose views are sheets writes `(spec 4)` in its manifest. Its Camera's third row then names the sheet it opens on and the sheet it shows.

### Not in this release

- Key chords, Alt and a sequence of keys: the views' sitting recorded them, their item to be filed after this release.
- Edit and continue (`ENGINE.7`), a cartridge loaded from a file (`ENGINE.5`) or an address (`REPO.6`), the accelerators (`ENGINE.6`) and proof of play (`ENGINE.10`).
- The drawer's viewer patched at a rate above zero, which needs more than one frame's changes, the language's to keep.
- A scroll or a dropdown for dozens of tabs, and Excel's General format.

### Known open security items

**None.** The engine imports nothing and makes no outbound call, ever; the page fetches nothing, and a built page's blocks are held to the repository's files both ways. Both are checked on every push, by `tools/check_host_imports.ps1` and `tools/check_web_offline.ps1`. `SECURITY.md` is the policy and the place to report.

## 0.1.3

The grid drawn from the values view: a grid cartridge's Screen is drawn at every frame from the language's `values` projection, the record without its formulas' texts, so that a full window of formulas is drawn well inside a 60 Hz frame (`ENGINE.8`'s second slice). The engine crate's code is 0.1.2's and still pinned to `vla-lang` 0.9.3 exactly; what changed is the page, served at https://spreadsheet-company.github.io/Alonzo/. In a crate's manifest, `alonzo = "=0.1.3"` and, for the types its calls answer, `vla-lang = "=0.9.3"`.

### What it holds

- **The grid drawn from the values view.** Every frame after the first draws a grid cartridge's Screen from `values`, the grid record less its `formula` rows (Frazaro's `KERNEL.37`), so no formula's text is moved at a frame. Frame 0, before anything is computed, is drawn from the full record, its formulas shown as their texts until their first values. `redraw()` draws a grid cartridge too.
- **The viewport reads a values record.** A `value` row with no `formula` row before it is a formula known by its value, its text not in the record; a `style` row alone is a formula with no value yet, drawn empty in its style.
- **The double answers `values`**, as the module does.

### What it measures

The blit floors' third baseline, the owner's `?blit=1` in Chrome 155 in fullscreen on a 2560 by 1440 screen at a pixel ratio of 1.5 (`tools/check_blit_floors.ps1`):

- **The grid card's 80 by 50 window, drawn again from the values view** on 3,840 by 2,117 device pixels: a frame at 5.2 ms at the median, 6.1 at the 95th percentile and 6.7 at most, the module's view 1.1 ms of it and the viewport's reading and drawing 3.1, against bars of 8.3 and 16.7, half and one interval of a 60 Hz display.
- **The three plane cases** stay under their bars and are slower than the second baseline of 2026-10-09: the double's frame 1.6 ms at the 95th percentile where it was 1.1, the engine's 0.8 where it was 0.5. Not measured apart: a newer Chrome, and a host frame that has grown since; recorded as a finding in `REARVIEW.md`.
- The frame floors are 0.1.0's tenth baseline: neither the engine nor the language changed.

### The items in it

- **Closed**, each with its line in `REARVIEW.md`'s ledger: `ENGINE.8`, the host drawing a grid-mode cartridge, by its second slice; and `REPO.4`, the first release, on the owner's run of the deployed page.

### For a game that carries the page

Take the template and the three scripts again: `host.js` asks the module for `values`, `viewport.js` reads it, and `fake.js` answers it. A game's builder and blocks are 0.1.2's. In the host's own viewport a cell of the Screen no longer carries its formula's text, since the values record holds none (`cell()` answers `formula: ''`); a page that wants the text views that cell's `grid` record.

### Not in this release

- The bench over a game's own cartridges: the bench's modes run over Alonzo's eight cartridges by name, and on a game's page they say what they lack.
- A frame not drawn again when its record is unchanged.
- What 0.1.2 left out: a cartridge loaded from a file (`ENGINE.5`) or an address (`REPO.6`), the accelerators (`ENGINE.6`), edit and continue (`ENGINE.7`), proof of play (`ENGINE.10`), a scroll or a dropdown for dozens of tabs, and Excel's General format.

### Known open security items

**None.** The engine imports nothing and makes no outbound call, ever; the page fetches nothing, and a built page's blocks are held to the repository's files both ways. Both are checked on every push, by `tools/check_host_imports.ps1` and `tools/check_web_offline.ps1`. `SECURITY.md` is the policy and the place to report.

## 0.1.2

The page any game's: the engine's page opens on an empty sheet, and its code names no game's file, so that a game carries the same page unchanged (`ENGINE.15`). The engine crate's code is 0.1.1's and still pinned to `vla-lang` 0.9.3 exactly; what changed is the page, served at https://spreadsheet-company.github.io/Alonzo/. In a crate's manifest, `alonzo = "=0.1.2"` and, for the types its calls answer, `vla-lang = "=0.9.3"`.

### What it holds

- **An empty sheet first.** Opened plainly, the player starts on an empty sheet, a grid of 80 columns by 50 rows at rate zero, the same whatever cartridges a page holds. Nothing runs on it, and an edit is a step: the drawer's edit row holds `(formula "Screen" "A1" "=6*7")`, and A1 reads 42 once it is written.
- **The picker.** The bar's picker offers the empty sheet and then the page's cartridges, each by its manifest's title, and loads a cartridge when it is picked. Alonzo's page offers its eight, the test cards among them for now.
- **The cartridge's own words.** The drawer shows the picked cartridge's notes from its manifest, its own account of what it is and how it is played. A picker in the drawer chooses which library the box shows, and Build hands the pass every library, as edited.
- **A page for any game.** The template names no game's file: its builder writes every text the page holds as a block that names its kind, its name and its path. A game copies the template and the three scripts unchanged and fills them with a builder of its own: its cartridges, its libraries, and its name in the bar and the title. Buffet, the first game native to Alonzo, is built to take the page this way.

### What it measures

Nothing new. Neither the engine nor the language changed, so the frame floors are 0.1.0's tenth baseline, and the module is 0.1.1's but for its version text. The page's loop oracle holds twenty cases, the twentieth the empty sheet and the picker.

### The items in it

- **Closed:** `ENGINE.15`, with its line in `REARVIEW.md`'s ledger.

### For a game that carries the page

A game's builder fills the template's five places: the three scripts, the module and the blocks. Each block is `<script type="text/plain" id="KIND-NAME" data-path="PATH">`, the path the file's from the repository's root, and `web/README.md`, "A game's page", is the full account:

- `page-name`: the name in the bar and the title.
- `cartridge-<name>`, with `data-file`, the file name a load passes on; the picker offers the cartridges in the order their blocks stand.
- `source-<name>`, its source; `replay-<name>` and `golden-<name>`, together, when it has them.
- `library-<name>`, at the path the source's includes resolve to, so that Build in the drawer runs the pass as the command line does.

The bench, `?loop=1`, `?oracle=1` and the other modes, runs over Alonzo's own cartridges and records, and on a game's page says what it lacks.

### Not in this release

- A cartridge loaded from a file (`ENGINE.5`) or from an address (`REPO.6`, the network's question under `SD-13`). The picker's list is open to them.
- The test cartridges hidden from the picker.
- What 0.1.1 left out: the accelerators (`ENGINE.6`), edit and continue (`ENGINE.7`), the grid drawn from the `values` projection (`ENGINE.8`'s second slice), proof of play (`ENGINE.10`), a scroll or a dropdown for dozens of tabs, and Excel's General format.

### Known open security items

**None.** The engine imports nothing and makes no outbound call, ever; the page fetches nothing, and a built page's blocks are held to the repository's files both ways. Both are checked on every push, by `tools/check_host_imports.ps1` and `tools/check_web_offline.ps1`. `SECURITY.md` is the policy and the place to report.

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

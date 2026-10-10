# The engine's page: the host's loop, and the viewport

**The host shim, `host.js`, runs a cartridge on the loop of `SPEC.md`
section 5 over the engine's module, every input a cell it writes and every
effect a cell it reads, and blits the Screen as a plane of colour indices.
It runs over the engine's own module, `alonzo.wasm`, built into the page,
the language computing every cell; `fake.js`, a double of the module's
eleven exports, is what its oracle drives and what the page falls back to
when no engine is built in. The viewport, `viewport.js`, draws
one window of a sheet on a canvas from the view record alone: the Screen
device in grid mode, which the first game on Alonzo, Frazaro, the
spreadsheet, draws its grid through.**

## The host shim and the fake module (`ENGINE.1`)

`host.js` is one plain script in the viewport's shape: no module syntax, no
import, no library, nothing fetched; `AlonzoHost` the one global. It reads
every record with the viewport's reader, `AlonzoViewport.readForms`, so
`viewport.js` loads first. It is handed a module's exports, the engine's own
or the fake's, and asks the ABI number before anything else:

```js
var host = new AlonzoHost({ canvas: document.getElementById('plane') });
var a = host.attach(AlonzoFake.create({}).exports);   // or an instance's exports
if (a.ok && host.load(cartridgeText, 'life.vla').ok) host.start();
host.on('status', function (s) { /* s.text, a sentence; s.kind 'event' or 'progress' */ });
```

What it does each frame, in section 5's order: the derived writes of the
Write sheet, each its own write of one `derived` row; the Input sheet's
eighteen rows from the keys it holds through the Keys sheet, the pointer
over the canvas, the wheel and the last key; a person's edits, each its own
write; the step with a budget in cells, which may yield and continue on the
next tick, the progress a sentence; then the effects, the Camera first and
the Palette, so the frame is drawn through its own Camera and colours, the
Screen as the plane through the Camera's window, the Keys, the Audio rows,
the File's save cell and the Write sheet. The loop is a fixed timestep with
an accumulator capped at 250 ms, no interpolation and no skipped frame,
paused while the page is hidden. At rate 0 there is no tick: one step for
each edit, and no Input. The blit puts the bytes through the palette into
one `ImageData` and draws it at a whole number of device pixels a cell with
smoothing off; a byte past the palette is magenta.

| Method | What it does |
|---|---|
| `new AlonzoHost(options)` | `canvas` the plane's canvas (it takes the keys while focused); `box` the element the blit fits, the canvas's parent by default; `scale` a fixed number of device pixels a cell; `budget` a fixed budget in cells a step call, 0 for none; `callsPerTick` a fixed count of step calls a tick in place of the time slice; `now` the clock the budget is measured by; `drive: 'manual'` when the caller calls `tick` itself (the oracles) |
| `attach(exports)` | asks `alonzo_abi_version` and refuses another number, then every export the loop calls: `{ ok, abi, version }` or `{ ok: false, sentence }` |
| `load(text, name)` / `loadBytes(bytes, name)` | unloads the grid it held, loads a cartridge, then `describe`, reads the Camera, the Palette and the Keys, and draws the new grid's frame 0 at once, nothing computed, so the canvas never shows a grid the module no longer holds: `{ ok, handle, title, mode, w, h, rate }` or the refusal's sentence |
| `start()` / `stop()` | the animation-frame loop |
| `tick(ts)` | one animation frame's work at its timestamp, what the loop calls |
| `edit(row)` | a person's edit, one `cell` or `formula` row, issued after the next frame's inputs; at rate 0 it steps once |
| `keyDown(code, key)` / `keyUp(code)` / `releaseKeys()` | the keys held, by `KeyboardEvent.code` |
| `pointerAt(col, row)` / `pointerButtons(left, right, middle)` / `wheel(notches)` | the pointer in Screen cells, 0 when off the Screen |
| `runFrameSync()` | one whole frame now, whatever the clock (the blit's instrument) |
| `redraw()` | the last complete frame drawn again, nothing stepped: the Camera and the Palette read as they stand, the plane viewed through the window and blitted, no other effect read (the blit's instrument over the engine's module, where a step is the evaluator's); `false` without a plane cartridge |
| `viewRecord(sheet, window)` | a sheet's record as the module prints it, for a page to show |
| `counters()` / `sentences()` | what the host has done; every sentence said, in order |
| `log()` / `logEntries()` | the last twenty events, one line each: a repeat of an event, the same sentence at another frame, is counted in the line it first made (`3 times, frames 7 to 21: ...`) and pushes nothing out; the entries as `{ id, text, key, count, first, last, refusal }` for a page that draws the log in place, `refusal` true for a refusal or a failure, the module's or the host's, which the page paints red |
| `unload()` / `destroy()` | frees the handle and empties the canvas; removes the listeners |
| `on(name, fn)` / `off(name, fn)` | `status` (`{ text, kind, repeat, refusal }`: a sentence, `kind` `event` or `progress`, `repeat` true when it only counted an earlier line, `refusal` true for a refusal or a failure; a notice of a value the host coerced, a Camera cell read as 1 or a colour painted magenta, is not one), `frame` (`{ frame, window, scale }`, after a frame completes), `load` (`{ handle, title, mode, w, h, rate, window, scale }`, after frame 0 is drawn) |

`AlonzoHost.instantiate(bytes)` and `instantiateSync(bytes)` instantiate a
module with the empty import object of section 8.1; `AlonzoHost.RULES` holds
the loop's constants. The first step call of a cartridge asks for 2,000
cells, about 9 ms of the engine's module, before the host has measured how
many cells a millisecond the machine does; after it the budget is half the
display's interval turned into cells. A refusal is the module's words once,
then its id; the host adds the row's line only for a write of more than one
row, and only when the module's words do not already name it.

The engine's module answers as the double does, with the language's refusals
and its own: Life loads with the Clock, the File and an Input sheet the
engine makes, and steps about 230,000 cells a second in Chrome, so about 1.8
generations a second at the slice the host spends, the progress sentence
showing between them (`SPEC.md` section 5's slowness in plain sight; the
speed is `CART.1`'s and `ENGINE.6`'s to raise).

`fake.js` is the permanent test double: `AlonzoFake.create(options)` answers
`{ exports, stats, digest, peek, frame }`, the exports the eleven names of
section 4.6 over a real `WebAssembly.Memory`. It reads a cartridge's
manifest, the engine's own duty, and never a row after it, and it evaluates
nothing (`AD-1`); its grid is hard-coded and declared in `AlonzoFake.RULES`:
the Screen's bytes as eight-by-eight tiles cycling through the sixteen
colours with one row swept by a byte past the palette, the CGA palette,
TIC-80's keys, a Write sheet whose rows land or are refused on a rule of the
frame, and a history cell that makes the end state's digest witness the
order of every write. Its memory grows by zero pages at every load and every
seventeenth allocation, detaching the buffer, and its allocator counts what
is live and what is freed wrongly. `options.abi`, `options.omit` and
`options.growEvery` make the doubles the loop's oracle refuses or strains.
Since `ENGINE.1`'s second slice its refusals carry the engine's module's ids
and its write checks rows in the engine's order, the engine's own checks
over every row before the language's, which the loop oracle's `parity` case
holds scenario by scenario. Since `ENGINE.2` its plane reads a formula
without a value as 0 wherever it stands, as its record says by printing no
value row, where it had read one outside its declared size as 255; the
`plane` case holds its plane to its record.

The viewport is `viewport.js`, one plain script: no framework, no module
syntax, no import, nothing fetched. It reads a view record, the lines
`frazaro view` prints (Frazaro's `conformance/README.md`, oracle 11), and
paints the window it is given: the sheets as tabs, the columns at the widths
the record declares, the fills and number formats of its formats, each
cell's text where the record puts it, the gridlines when the record says so.
It computes nothing: a value is shown as the reader spells it, a formula
shows its text until the value row lands (`KERNEL.7`), and an unknown row is
counted, never refused. What the viewport owns is the state no program sees:
the scroll, the selection, the widths a person dragged, the frozen panes and
the marks a host asked for. The record is never written.

The page, `index.template.html` built into `index.html`, is the engine's
panel, a cartridge running on the host's loop, Life or the test card, and
below it the viewport over seven
records the door printed: the six view goldens of Frazaro's `scripts/view/`
and the record of the 10,000-line program the renderer benchmark measured.
It runs from disk and reads nothing from the network.

## Try it

From a clone:

```powershell
powershell -File tools\build_web.ps1
```

writes `web/index.html`; open it from disk. Build the engine first,
`cargo build --release -p alonzo --target wasm32-unknown-unknown`, and the
builder puts it in the page: the engine's panel then runs Life as the
language computes it, about two generations a second; without it the panel
runs against the fake module and says so. Type a row in the edit box and
press Write (`(cell "Palette" "B1" "#FF8800")` turns the dead cells orange,
`(cell "Screen" "B2:K11" 1)` holds a block alive while Life flows around
it), watch the log, each repeat counted in its first line, and press Copy
the log to take it as text; pick a sheet of the grid, the Clock's frame
counting or the previous frame's twin, to see its record live; edit the
cartridge's `(rate 30)` to `(rate 0)` and press Load the cartridge to see a
step on every edit. Pick the test card above the buttons to see the plane's
whole rule: the sixteen colours as bars, magenta wherever a value is no
colour (a byte past the palette, a fraction, a text, a truth value, an
error), black for an empty cell, the window panning a column a frame across
a Screen wider than it and wrapping after 21 frames. Below it, pick a
record, scroll on both
axes, click a cell or drag a range, click a column or row header or the
corner, drag a column's right edge in the header, set rows and columns and
press Freeze, switch sheets on the tabs, double-click a cell or press Enter,
paste a record of your own under *Paste a record*. The line under the grid
spells the selection as the grammar spells it (`B2`, `B2:C3`, `C:C`, `2:2`,
the sheet's name) and names the sentence that wrote the cell.

## What it promises

Nothing on the page leaves it: no script, stylesheet, font, image, frame,
form, link or fetch, which `tools/check_web_offline.ps1` holds on the
template and on the viewport's source on every push, and the records inside
are the door's own output, pinned byte for byte by
`tools/check_view_fixtures.ps1`. Every cell is drawn where the record puts it:
`tools/check_render_oracle.ps1` runs the page's own oracle under a headless
browser at two pixel ratios and holds the viewport's draw list equal to what
each record says, cell for cell, every coordinate on a device pixel. And the
frame holds: `tools/check_render_floors.ps1` holds the owner's measured
baseline to the roadmap's bars.

## The five modes

- Opened plainly, the page is the engine's panel and the viewport over the
  fixtures, above.
- `index.html?loop=1` runs the host loop's oracle: the host driven over a
  fixed input log against the fake module, its frames, writes, windows,
  sentences and end state held to what the page computes from the log, and
  from a second fake module it drives with no host between; and, when the
  page holds the engine's module, the same host over it, Life's plane at
  frames 1 and 11 equal byte for byte to a reference Life the page computes
  (`engine`) and eleven refusals answered with the same id by the double and
  the module (`parity`); and the frame path's equality (`plane`, `ENGINE.2`):
  at frame 0 and after every frame, the window the host drew through is the
  Camera's, the bytes it holds are the record of that window read by the
  page's own rule from `SPEC.md` section 3.1 (a whole number from 0 to 254
  itself, any other value 255, an absent cell and a formula with no value
  row 0), and the canvas's pixels at a cell of each kind are the Palette's
  colour or magenta, over the double, its Camera moved by edits, and over the
  engine's module, the test card's twenty-four frames under a Camera that
  pans a column a frame; one line a case into `<pre id="loop">`, which
  `tools/check_host_loop.ps1` reads.
- `index.html?blit=1` is the blit's instrument, the engine's second number:
  a 320 by 200 plane drawn through the host's whole frame over the double
  120 times at the scale that fits the screen and 120 at a scale of 1, and,
  when the page holds the engine's module, the same path over it (`engine`,
  `ENGINE.2`): Life stepped once to its soup, then that frame redrawn 120
  times at the scale that fits, the step left out as the evaluator's; each
  frame's main-thread cost, printed as the table and the baseline lines for
  `tools/check_blit_floors.ps1`, which holds the three cases from one run.
  Run it in Chrome in fullscreen.
- `index.html?oracle=1` runs the render oracle and prints one line a case
  into `<pre id="oracle">`, which the check reads under a headless browser.
- `index.html?bench=1` is the floors' instrument, the renderer benchmark of
  `KERNEL.3` over the viewport: the 10,000-line record at the normal window
  (40 rows by 15 columns) and at full screen, 120 steps of three rows and 20
  page steps, each draw's main-thread cost from before the call to a task
  queued after the frame's rendering, printed as a Markdown table and as the
  baseline lines for `tools/check_render_floors.ps1`. Run it in a real
  browser in fullscreen; a headless run's clock is virtual and its numbers
  are not a measurement.

## For the first game: the API

The host hands the viewport a box and gets a grid inside it, with its own
canvas, its scroller and its tab strip:

```js
var vp = new AlonzoViewport(document.getElementById('grid'), { record: text });
vp.on('select', function (s) { /* s.text is 'B2:C3'; s.focus.sentence the row that wrote B2 */ });
```

`AlonzoViewport` is a global set by the script; `AlonzoViewport.version` is
1. The options: `record`, a record's text to load at once; `colors`, any of
the defaults below; `showHidden`, whether hidden sheets' tabs show at first.
Beside the constructor, `AlonzoViewport.readRecord(text)` reads a record
into the model the viewport draws, and `AlonzoViewport.readForms(text)`
reads any text of forms into data, the host shim's one reader.

| Method | What it does |
|---|---|
| `load(text)` | reads a record; its sheet becomes a tab, replacing an earlier record of that sheet; the record's `sheet` rows become the tab strip; returns the counts (`sheet`, `lines`, `cells`, `formulas`, `styles`, `sentences`, `unknown`, `malformed`, `window`, `extent`, `readMs`) |
| `show(name)` | shows a sheet whose record is loaded (the name compared without case); false when none is |
| `sheets()` | every sheet row as `{ name, state, loaded, active }` |
| `sheet()` | the sheet shown |
| `scrollTo(row, col)` | scrolls so that the cell is at the top left of the scrolled quadrant |
| `scrollToPixels(x, y)` | scrolls to a position in CSS pixels and draws at once (the harness's step) |
| `select(text)` | selects `B2`, `B2:C3`, `C:C`, `2:2`, or the sheet by its name; false for a text that is not a range |
| `selection()` | the selection: `{ sheet, text, kind, range, focus }`, `kind` one of `cells`, `columns`, `rows`, `sheet`, `focus` the cell as `cell()` gives it |
| `freeze(rows, cols)` / `frozen()` | freezes the top rows and the left columns; what is frozen |
| `columnWidth(letters, px)` / `columnWidths()` | a column's width in CSS pixels, the host's over the record's; `null` puts the record's back; the overrides |
| `mark(name, ranges, style)` / `unmark(name)` | a named highlight over ranges the host computed, `style` `{ fill, border }`; `unmark()` with no name clears all |
| `cellAt(clientX, clientY)` | the cell under a point of the page, or null |
| `cell(row, col)` | a cell: `{ row, col, address, kind, vkind, text, style, sentence }`, `kind` one of `cell`, `formula`, `empty` |
| `geometry()` | the last draw's geometry in device pixels: the ratio, the sizes, the row height, the column edges, the frozen bands, the scroll |
| `draws()` | the last draw's list: every text, fill, line, header, selection and mark with its position (the oracle's) |
| `model()` | the record shown, as read |
| `redraw()` | sizes the canvas to the box again and draws |
| `destroy()` | removes the viewport and its listeners |
| `on(name, fn)` / `off(name, fn)` | the events |

| Event | When, and what it carries |
|---|---|
| `select` | the selection changed by a click, a drag, a key, `select()`, or a sheet shown, which puts it at that sheet's A1: `{ sheet, text, kind, range, focus }` |
| `scroll` | the window moved: `{ sheet, top, left, bottom, right, window }`, the rows and columns in view and their range text |
| `columnresize` | a column's edge was dragged: `{ sheet, column, width }` in CSS pixels |
| `sheet` | a tab was chosen or a record shown: `{ name, loaded, state }`; `loaded` false asks the host for that sheet's record |
| `cellopen` | a cell was double-clicked or Enter pressed on it: `{ sheet, address, row, col, cell }`; the first game's chrome opens the pane at the sentence here |

The keyboard, with the grid focused: the arrows move the selection and bring
it into view, Shift with them extends it, Page Up and Page Down move by a
screen, Home and End go to the first and the last column of the sheet, Ctrl
with them to the first and the last cell, Enter raises `cellopen`.

**The rules of the record, as the viewport reads it.** A column's width is
the record's number, the file's stored width in characters, turned into CSS
pixels by ECMA-376's rule with a maximum digit width of 7 (Calibri 11 at 96
DPI): 72 is 504 px and 60 is 420 px; a column with no row is 64 px, Excel's
default; a hidden column is skipped; a column's format fills its empty cells.
A row is 20 px, the headers one row high, the text 13 px `system-ui`. A
`cell` row shows its value aligned as Excel aligns it under General: a
number right, a text left, `TRUE`, `FALSE` and an error centred, a date as
the text inside, right; under a `text` format everything left. A `formula`
row shows the formula's text, left, in green. A nowrap text spills into the
empty cells to its right and stops at the first that holds anything; a
number never spills; a wrapped text is broken at the column's width and the
lines that fit the row are drawn. The layout is in device pixels, every size
an integer of them, every gridline at an integer plus a half, so the image
is crisp at the machine's ratio, and the backing store is remade when the
ratio changes.

**The colours** are options with defaults: `background` `#ffffff`,
`gridline` `#d9d9d2`, `header` `#f3f3ee`, `headerText` `#6b6b66`,
`headerSelected` `#e2d8f6`, `text` `#1d1d1b`, `formula` `#0a6b4f`,
`selectionFill` `rgba(226, 216, 246, 0.45)`, `selectionBorder` `#6b4fc8`,
`frozenLine` `#b9b9b0`, `tabBackground` `#f3f3ee`, `tabActive` `#ffffff`.
The viewport paints the record and these, and nothing of its own.

**Taking a copy.** Frazaro's page takes `viewport.js` as a file, held byte
for byte to this one by a check on its side; a change here is a copy there,
in one reviewed commit.

## Not in this version

The formula bar, the link from a cell to its sentence and back, the refusal
in the row, the modes and the pane are the first game's chrome, built on the
events and the marks above. Touch, a context menu, printing, row resizing
(the record has no row-height row) and column reordering are not here. The
fill handle, drag-move and in-cell editing never will be: the grid is a
viewport, not an Excel clone.

## For contributors

- **The template and the scripts are the source**, `index.template.html`,
  `viewport.js`, `fake.js` and `host.js`; `index.html` is a build artifact
  (gitignored). `tools/build_web.ps1` fills `{{VIEWPORT_JS}}`,
  `{{FAKE_JS}}` and `{{HOST_JS}}` once each, `{{ALONZO_WASM}}` with the
  engine's module as base64 when it is built and with nothing when it is
  not, each `{{CARTRIDGE:name}}` with `cartridges/<name>/<name>.vla` and
  each `{{FIXTURE:name}}` with `fixtures/<name>.vla`, each family held to
  its folder both ways; `-Template`, `-ViewportJs`, `-FakeJs`, `-HostJs`,
  `-FixturesDir`, `-CartridgesDir`, `-Wasm`, `-NoWasm` and `-Out` exist for a
  check that builds a page from mutated sources, never for the real page.
- **A change to the host** is held by the loop's oracle, whose expectations
  are the page's own and never the host's, under
  `tools/check_host_loop.ps1`, and the blit by the owner's measurement under
  `tools/check_blit_floors.ps1`. A loop that changes on purpose is first
  reworded in `SPEC.md` section 5, then in the page's oracle.
- **The fixtures are the door's records**, never typed or edited: a change
  in Frazaro's goldens is a copy here and a new pin in
  `tools/check_view_fixtures.ps1`.
- **A change to the viewport** is held by the render oracle: every draw
  where the record puts it, under `tools/check_render_oracle.ps1`, and by
  the floors, the owner's measurement, under `tools/check_render_floors.ps1`.
  A draw that moves on purpose is first reworded in the page's oracle, whose
  expectations are its own and never the viewport's.
- **Where it is going:** `ENGINE.2` holds the plane equal to the record of
  the same window, and makes the language's plane view cheaper than its
  3 to 5 ms a frame today; the viewport stays the grid projection's, and a
  grid cartridge is drawn through it; the fake module stays the double the
  shim is tested against, its ids the module's.

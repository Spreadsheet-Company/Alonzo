# The viewport, and its page

**One window of a sheet, drawn on a canvas from the view record alone: the
Screen device in grid mode, which the first game on Alonzo, Frazaro, the
spreadsheet, draws its grid through.**

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

The page, `index.template.html` built into `index.html`, is the viewport
over seven records the door printed: the six view goldens of Frazaro's
`scripts/view/` and the record of the 10,000-line program the renderer
benchmark measured. It runs from disk and reads nothing from the network.

## Try it

From a clone:

```powershell
powershell -File tools\build_web.ps1
```

writes `web/index.html`; open it from disk. Pick a record, scroll on both
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

## The three modes

- Opened plainly, the page is the viewport over the fixtures, above.
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

- **The template and the script are the source**, `index.template.html`
  and `viewport.js`; `index.html` is a build artifact (gitignored).
  `tools/build_web.ps1` fills `{{VIEWPORT_JS}}` once and each
  `{{FIXTURE:name}}` with `fixtures/<name>.vla`, the two sets held equal
  both ways; `-Template`, `-ViewportJs`, `-FixturesDir` and `-Out` exist for
  a check that builds a page from mutated sources, never for the real page.
- **The fixtures are the door's records**, never typed or edited: a change
  in Frazaro's goldens is a copy here and a new pin in
  `tools/check_view_fixtures.ps1`.
- **A change to the viewport** is held by the render oracle: every draw
  where the record puts it, under `tools/check_render_oracle.ps1`, and by
  the floors, the owner's measurement, under `tools/check_render_floors.ps1`.
  A draw that moves on purpose is first reworded in the page's oracle, whose
  expectations are its own and never the viewport's.
- **Where it is going:** `ENGINE.1` puts the engine's wasm into this page and
  writes the loop beside this file; `ENGINE.2` adds the plane, a game's
  Screen blitted as bytes; the viewport stays the grid projection's.

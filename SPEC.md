# ALONZO SPEC - the device sheets and the four calls

*The specification of the engine, version 3: the page `CHARTER.md` §4 promises, written before the first cartridge, in uxn's lesson that a small, finished specification is the product (§5 there). It states the unit, the grid and its two buffers, the device sheets cell by cell, the four calls into the language and the records they answer, the frame's order of operations, the determinism rules, the cartridge's shape and its source, the host's duties and the engine's reflection. It is written for three readers at once: the session that cuts `vla-lang` out of `frazaro-core` and must know what the language's step and view have to provide; the session that writes the host shim and the devices (`ENGINE.1` to `ENGINE.5`); and a stranger who wants to write a cartridge or port the engine, who should need this page and nothing else. Written 2026-10-08 (`SPEC.1`) and rewritten in place as version 2 the same evening (`SPEC.2`), after the sittings `docs/ALGEBRA.md` records, with seven decisions the sections assume and §11 lists as 18 to 24: a Write sheet of values, so that the grid writes the grid in data and never in code; one model with two renderers, not two modes; rate zero, a step on every edit; a Camera sheet the host views the window by; the rule `AD-7`, the step computes values and never formulas; a cell written twice refused at load; and the limits restated, the Screen's as the draw's and the compute line as a budget. Rewritten in place again as version 3 on 2026-10-10 (`SPEC.3`), with eleven decisions §11 lists as 25 to 35: a cartridge's source, VLA with template macros and includes, and the pass that expands it into the rows the load takes, an act of its own between the source and the load, at the command line or in the page, whose output, the cartridge, is the artifact a person reads, saves and diffs (§7.8); the engine never expands. A living document while the repository forms, rewritten in place at the owner's call; the house rules of every ledger take over when the owner freezes it.*

*Marks are the charter's. Every idea is* **math exists**, **engineering** *or* **fiction**; *an argument about the present is* **exhibit** *(a dated, public, checkable fact, its source in §14),* **shelf** *(a claim a file in the Frazaro repository or this one already makes, cited) or* **recommendation** *(the draft's choice, the owner's to take or leave; §11 collects them as numbered decisions); every figure is a* **measurement**, *a* **prediction** *or* **derived**. *Where this page and the code disagree, the code is right, and the page is corrected. Frazaro's standing decisions that bind here are named where they bind: `SD-13` (no outbound call, ever), `SD-18` (VBA the reference for the language), `SD-23` (one model, many projections), `SD-30` (nothing fails silently, nothing succeeds invisibly), `SD-32` (appearance declared, not painted), `SD-34` (every engine interruptible, its progress a sentence), `SD-35` (the program is the accessible workbook), and this repository's own `AD-1` to `AD-6` (`ROADMAP.md`), the sixth adopted from this page (§9). All seventeen of version 1's recommendations were approved by the owner on 2026-10-08 (§11); version 2's seven, decisions 18 to 24, were approved the same evening and `AD-7` adopted (§9); version 3's eleven, decisions 25 to 35, were approved on 2026-10-10, with the owner's guiding principle for the pass (§7.8); the sections assume them all, and the alternatives stay recorded.*

---

## 1. The unit: the cell

The cell is the basic unit of the engine, and there is nothing beneath it (*recommendation*, the owner's own statement of 2026-10-08, made the first rule of this page). A game fills a cell with a colour and the host draws it as one pixel; the spreadsheet fills a cell with text and the host draws it as a box of glyphs. Both are the same cell seen through a different projection (`SD-23`): the **plane** projection reads a window of cells as one byte each, a colour index, and the host blits the bytes; the **grid** projection reads the same window as lines of text, the view record of `KERNEL.4` (*shelf*: `conformance/README.md`, oracle 11), and the viewport draws them (`KERNEL.5`). Version 1 called the two the video modes of 1981, graphics and text, with the cell where the pixel and the character cell were (*exhibit*: the EGA drew 320 by 200 in sixteen colours and 80 by 25 characters from the same adapter; §14); version 2 reads them as two renderers of one model and not two modes (*recommendation*; decision 19): a sheet holds values, and its look is a declared map from a value to a style, the Palette sheet for the plane and the `look` rows for the grid (§3.1, §7.3), so that in either projection the value is the frame and the look is declared and never painted (`SD-32`), and a stacking game's lit blocks and its score in text share one sheet. The split of 1981 is what the consoles after it escaped with tile and sprite layers (*exhibit*: the Famicom of 1983, §14), and a page that copied it would have had to escape it too. A sprite is a range of cells. A level is a sheet. Physics is a formula: a position this frame is a formula of the position and the velocity in the last frame, and a collision is a comparison. A camera is two cells the host reads and places its window by (§3.8), so that a scrolling world costs a frame nothing. None of these is a device, and none needs one, which is why `CHARTER.md` §8 builds no asset pipeline, no sprite engine and no physics engine; every one of them is cells and formulas, in the language, where a stranger can read it, change it and optimize it (`CHARTER.md` §6, the hypothesis). The host's pixel is rented, as rule 3 rents the rasterizer: the engine never addresses a pixel, only a cell, and the host decides how many device pixels a cell gets (an integer, so that the image is crisp at the machine's pixel ratio, `KERNEL.3`'s check by eye).

## 2. The grid, the two buffers and the frame

**The grid.** A cartridge is loaded into one grid: `vla-lang`'s sheet model, sheets of cells, each cell a value (a number, a text, a truth value, an error value) or a formula, with defined names and a style table, as `frazaro build` builds one and `frazaro reflect` reads one (*shelf*: `core/src/sheet/mod.rs`, the model `vla-lang` takes with it, the Alonzo memory's move list). Coordinates are A1's: a column by letters, a row by number, both from 1. The Screen of a 320 by 200 cartridge is the range `A1:LH200` (*derived*: 320 = 12 × 26 + 8, the twelfth letter then the eighth).

**The two buffers, named.** A frame is a dependency graph over two buffers (`CHARTER.md` §4, the frame): a cell of this frame reads the previous frame anywhere, and this frame's cells wherever the reads are acyclic. This page gives the previous frame a name a formula can write, and it chooses the spreadsheet's own spelling over a new function (*recommendation*; decision 2 in §11). **Every sheet `X` of a loaded grid has a twin named `X.last`, holding every cell of `X` as it was when the previous step finished.** A twin holds values only, never a formula; it is read-only to the program and to the host; the engine makes it at load and fills it at the end of every step. A formula reads the previous frame by an ordinary cross-sheet reference, `Screen.last!B2`, and reads this frame by an ordinary reference, `Screen!B2` or `B2`. Nothing new is added to the language: a `.last` sheet is a sheet, the reference is a reference, the dependency graph is the graph recalculation already builds, and a reference into a `.last` sheet adds no edge to it, since the twin's values are fixed before the step begins. The suffix needs no quotes in a formula, since Excel quotes a sheet name only for a character outside letters, digits, `_` and `.`, a leading digit, or a name shaped like a reference (*shelf*: `core/src/refers.rs`, `sheet_needs_quotes`, the owner's pass of 2026-10-04). A cartridge may not name a sheet ending in `.last`, and a sheet's name is at most 26 characters so that its twin fits Excel's 31 (*exhibit*, §14).

Why a sheet and not a function. Excel's own way to read a previous value is iterative calculation over a circular reference, which the Life-in-Excel tradition uses (*exhibit*: Microsoft's "Change formula recalculation, iteration, or precision", §14); it reads the previous iteration's value in the order of Excel's calculation chain, so what a cycle computes depends on that order, and a cell that wants this iteration's neighbour and that one's previous value cannot say which it means. A function such as `LAST(B2)` would say it, but it is a new mechanism in the evaluator, a word no spreadsheet knows, and a thing nobody can look at. A twin sheet is a thing anyone can look at: `view` shows it, the viewport can show the previous frame beside this one, `reflect` of a saved cartridge lists it, and the owner's rule that an ambiguous reading gets explicit words is kept by the suffix itself (*shelf*: the Frazaro memory, "name the choice"). The cost is a copy of the sheet's values at the end of each step: 64,000 cells of eight bytes is 512 KB, under a tenth of a millisecond at memory speed, against the two million evaluations a second the frame already pays (*derived*; the implementation may swap buffers instead of copying, which this page does not see).

**The acyclic rule.** Within a frame, the references that read this frame form a directed graph over the grid's formula cells, and that graph must be acyclic; a cycle is refused by name, naming the cells that close it, at load for the cartridge's formulas and at a `write` that adds one, never during a step (*recommendation*; the refusal is recalculation's own, `KERNEL.7`'s, and the treaty's recalculation will refuse it the same way). A cell that reads itself through its twin, `=Screen.last!B2+1`, is not a cycle; a cell that reads itself directly is. The synchronous automaton (every read of the last frame) and the scan-order rule (every read of this frame in one order) are both special cases, as the charter says, and both are written in the one notation: Life reads `Screen.last` alone; sand reads the row beneath in `Board` and the rows above in `Board.last`.

**The theorem.** Each frame is a total function: the graph is finite and acyclic, and every function of the subset returns a value or an error value and never diverges (§4.4), so every step terminates by construction, and the cartridge is a productive stream transformer, inputs in and frames out, never stuck. That is why a replay is a proof (§6, §7.6). The frame is Lustre's synchronous instant, the twin its `pre`, the acyclic rule its causality check and the first-frame `IF` over `Clock!B1` its initialization arrow (*math exists*: Caspi, Pilaud, Halbwachs and Plaice 1987, §14; the reading is `docs/ALGEBRA.md` §2.2).

**The step.** One step computes one frame: the engine writes the Clock's frame cell (§3.5); every formula cell of every sheet that is not a twin is recomputed, in a topological order of the graph above, reading twins for the previous frame and the grid for this one (*math exists*: Sestoft 2014, as the charter cites it); a value cell keeps the value it holds, whether the cartridge put it there or a `write` did; a step computes values and never formulas, so the formula cells after a step are the formula cells before it, cell for cell, the rule `AD-7` (§9; decision 22), held by a test (§13); and when every formula has a value, every sheet's values are copied into its twin, and the step is done. A step takes a budget in cells and may stop before it is done, reporting how far it got, and be called again until it is; the host draws the last complete frame from the twins meanwhile, so the grid never freezes (`SD-34`). Between two steps the grid holds the last complete frame, and the twins hold the same values until the next step changes them; a `write` between steps changes the grid and not the twins, which is what gives a button its rising edge: during the next step `Input!B5` is the new press and `Input.last!B5` is the last frame's. A cartridge's own writes between steps are the Write sheet's (§3.9), values the host carries from one frame's effects into the next frame's grid, so that a state can be a value that costs nothing to keep.

The graph's depth is the frame's critical path and its width is the parallelism on offer; a shared formula over a range is one shape evaluated once per cell, which `KERNEL.20` vectorizes; both are the charter's claims and this page changes nothing in them (*shelf*). Nothing on this page asks the evaluator for a mechanism it would not have for a spreadsheet; the frame is recalculation with a budget, a snapshot and a clock cell (*recommendation*, the page's central claim, marked *engineering*).

## 3. The device sheets, cell by cell

Alonzo is Varvara to VLA's uxn: where Varvara maps its devices into uxn's memory at fixed ports, sixteen bytes each, with a vector per device that the machine evaluates on an event (*exhibit*: the Varvara page, §14), Alonzo maps its devices into the grid as sheets with fixed layouts, and has no vectors, since the frame is the only event and every input is a cell written before the step. The nearer precedent is TIC-80, whose devices are memory-mapped registers a program peeks and pokes, the screen at address zero, the palette at `0x3FC0`, the gamepads, mouse and keyboard at `0xFF80` (*exhibit*, §14): a device sheet is a register file with names instead of addresses and a formula bar instead of `peek`. The layout follows the spreadsheet's own convention for a block of settings, a label in column A and its value in column B, so that a person reading the sheet in the viewport sees `up | 1` and not a bare `1`, and follows ICAEW's tenth principle, inputs, workings and outputs separate and clearly identified (*exhibit*, §14): the Input sheet is inputs, a cartridge's own sheets are workings, and Screen, Audio and File are outputs.

Two directions, told apart by the sheet. An **input** cell is written by the host before a step and read by the cartridge's formulas: the Input sheet, and the Clock. An **effect** cell is written by the cartridge's formulas and read by the host after a step: the Screen, the Audio voices, the File's save, the Keys, the Camera and the Write sheet. A device sheet's host-written cells hold values and never formulas (a formula there is refused at load, since the host would overwrite it every frame and nobody would see why); the cartridge is free to put formulas into effect cells, and that is how a game sounds and draws. Cells of a device sheet outside its layout are refused at load, so that a later version of this page can add a row without colliding with a cartridge that used it (*recommendation*). Every name below is compared as the model compares sheet names, without case (*shelf*: `Workbook::find_sheet`).

### 3.1 Screen

The framebuffer (`CHARTER.md` §3). Its size and mode are declared by the cartridge's manifest (§7.2), `(screen plane 320 200)` or `(screen grid 80 50)`, the width then the height: the size of the window the host draws, `A1` its top-left when the cartridge has no Camera sheet, the row number the y and the column index the x, both from 1. Without a Camera sheet a cell outside the declared size is refused at load, as version 1 refused it; with one (§3.8) the Screen may be any extent within §10's limits and the Camera places the window, so that a tower taller than the window or a world wider than it is a sheet and not a trick (*recommendation*; decision 21).

- **Plane mode** (`ENGINE.2`, the games). Each cell holds a colour index, a whole number from 0 to one less than the Palette's row count. The plane projection (§4.5) reads the Screen's window as one byte per cell in row-major order: the cell's value when it is a whole number from 0 to 254, and 255 for anything else, an empty cell excepted, which reads as 0, and a formula before its first value, which reads as 0 too (*corrected 2026-10-09*, `ENGINE.1`'s second slice: the language's plane reads it so, `vla-lang/src/machine/plane.rs`, and the fake module already did). The host paints a byte below the Palette's count with that row's colour and any other byte in the error colour, magenta `#FF00FF`, so that a formula that produced text, an error value or an index past the palette is seen and never silently black (*recommendation*; the convention is the one game engines use for a missing texture). The record of the same window (the grid projection) shows the same cells as values, which is `ENGINE.2`'s equality test.
- **Grid mode** (`KERNEL.5`, the spreadsheet and the text games). Each cell holds what a spreadsheet cell holds, and the viewport draws the window as it draws any sheet: the text, the number formats and the fills the record declares, and the `look` rows of §7.3, a declared map from a value to a style index, so that a cell whose value changes changes its fill through a style the cartridge declared and never through a formula that paints (`SD-32` kept whole: the map is declared, the value is the frame; version 1's sentence that a fill cannot change per frame is withdrawn, decision 19). A roguelike, a text adventure and Frazaro itself are this mode. The first game needs no cartridge at all: the spreadsheet is a grid of this kind at a frame rate of one, and `frazaro view` already prints it.

The Screen has no layers and no sprite port in this version, and its scroll is the Camera sheet (§3.8): a scrolling world is a sheet larger than the window and two cells the host reads, which costs a frame nothing, where an offset every Screen formula read through `INDEX` would cost the window's every cell a lookup a frame, the whole of §10's budget on scrolling alone (*derived*; `docs/ALGEBRA.md` §3). A layer is a second sheet composited by a formula; a sprite is a range (§1); the composite as a projection, a Sprites sheet of ranges at positions drawn in order with blank transparent, is named for version 3 (§12).

### 3.2 Palette

Required in plane mode; ignored in grid mode, where the `look` rows of §7.3 are the same map, a value to a look, in the record's own terms (decision 19). Sixteen rows, row `r` holding index `r - 1`: column A the index as a number (0 to 15, in order, which the engine checks at load), column B the colour as `#RRGGBB`, the spelling the distro manifest uses for its shades (*shelf*: `core/src/distro.rs`), column C a name for a reader, free text, optional. Sixteen is the stated limit of this version, as PICO-8 and TIC-80 state theirs (*exhibit*); the plane's byte has room for 255, so a later version can raise the count without changing the frame path, and the manifest's `(spec ...)` is what says which (*recommendation*; decision 4). A formula may rewrite a Palette cell, since the sheet is a sheet: palette cycling and a fade are formulas, as PICO-8's `pal()` remaps colours at run time (*exhibit*). The host reads the Palette after each step with the other effects. A cartridge supplies its palette; the engine supplies none, since a default nobody wrote is a decision nobody can read. The sixteen a cartridge may copy, the CGA's, a hardware standard of 1981 and the natural palette of a 320 by 200 screen (*exhibit*, §14):

| index | colour | name | index | colour | name |
|---|---|---|---|---|---|
| 0 | `#000000` | black | 8 | `#555555` | dark grey |
| 1 | `#0000AA` | blue | 9 | `#5555FF` | light blue |
| 2 | `#00AA00` | green | 10 | `#55FF55` | light green |
| 3 | `#00AAAA` | cyan | 11 | `#55FFFF` | light cyan |
| 4 | `#AA0000` | red | 12 | `#FF5555` | light red |
| 5 | `#AA00AA` | magenta | 13 | `#FF55FF` | light magenta |
| 6 | `#AA5500` | brown | 14 | `#FFFF55` | yellow |
| 7 | `#AAAAAA` | light grey | 15 | `#FFFFFF` | white |

### 3.3 Input

The host writes it before every step; a cartridge's formulas read it. Column A holds the label; columns B to E hold players 1 to 4 for the button rows; the pointer and keyboard rows use column B alone, there being one of each. A button cell is 1 while the button is held during the frame and 0 otherwise; the host sets it from the keys the Keys sheet maps (§3.4) and, when a later version adds the Gamepad API as a device, from a pad, with no change to this layout. A press and a release are not cells: a rising edge is `=AND(Input!B5=1, Input.last!B5=0)`, a formula of the two buffers, which is how `CART.4`'s one button is read, and a held repeat is a counter the cartridge keeps, as PICO-8's `btnp` keeps one (*exhibit*: `btnp` repeats every 4 frames after 15).

| row | A (label) | B..E (players 1 to 4) | what the host writes |
|---|---|---|---|
| 1 | `up` | 0 or 1 | held this frame |
| 2 | `down` | 0 or 1 | |
| 3 | `left` | 0 or 1 | |
| 4 | `right` | 0 or 1 | |
| 5 | `a` | 0 or 1 | the first face button |
| 6 | `b` | 0 or 1 | the second |
| 7 | `x` | 0 or 1 | the third |
| 8 | `y` | 0 or 1 | the fourth |
| 9 | `start` | 0 or 1 | |
| 10 | `select` | 0 or 1 | |
| 11 | `mouse-x` | B only | the pointer's Screen column, the Screen sheet's own through the Camera (§3.8), 1 to the width without one; 0 when the pointer is off the Screen |
| 12 | `mouse-y` | B only | the pointer's Screen row, the Screen sheet's own through the Camera, 1 to the height without one; 0 when off |
| 13 | `mouse-left` | B only | 0 or 1, held |
| 14 | `mouse-right` | B only | 0 or 1, held |
| 15 | `mouse-middle` | B only | 0 or 1, held |
| 16 | `mouse-wheel` | B only | the notches turned this frame, negative away from the user, 0 when none |
| 17 | `key` | B only | the last key pressed during the frame as `KeyboardEvent.key` spells it (`a`, `Enter`, `ArrowUp`), or empty |
| 18 | `code` | B only | the same key's physical code, `KeyboardEvent.code` (`KeyA`, `Enter`, `ArrowUp`), or empty |

Ten buttons: the NES's eight as Varvara's controller carries them, a byte with a bit each (*exhibit*), plus the two face buttons TIC-80 adds (*exhibit*: its gamepad has up, down, left, right, A, B, X, Y). The mouse's place is in cells, since the Screen is cells, and it is the same in both modes. The two keyboard rows are what a typing game or an editor needs beyond buttons: `key` is the character under the person's layout and `code` the physical key, which is the distinction MDN draws and the reason a game binds buttons by `code` (*exhibit*, §14). A full key matrix is not in this version (§12). At rate 0 (§5) the host does not write this sheet: a cartridge at rate 0 is stepped by edits and reads them, not buttons, and the eighteen rows hold whatever the cartridge loaded. (*Corrected 2026-10-10*, `ENGINE.3`'s first slice, as the host now writes it. The pointer's column and row are the Screen sheet's own: the window's cell under the pointer plus the Camera's offset, the Camera of the frame the person sees, which is the frame last drawn. So `ROW()=Input!B12` and `COLUMN()=Input!B11` find the cell pointed at wherever the Camera stands, and a cartridge with no Camera reads 1 to the width as before. The host had written the window's cell: measured on the test card, whose Camera panned the window from `A1` to `F1` while `Input!B11` held 1. And a browser repeats a held key's `keydown`, so `key` and `code` name a held key again at each repeat, as typing does, while its button stays held.)

### 3.4 Keys

The map from physical keys to the Input sheet's buttons, as a sheet, so that a cartridge declares its controls as data and a player rebinds them by editing a cell, which is Emacs's keymap as a cell edit (§9). Column A the button's label, in the Input sheet's order; columns B to E the `KeyboardEvent.code` of the key that holds it for players 1 to 4, as text, or empty for none. The host reads it after each step with the other effects, so a cartridge may even rebind keys by formula, by phase of play. The defaults a cartridge may copy, player 1 only, TIC-80's for the face buttons (*exhibit*):

| row | A | B (player 1) | C..E (players 2 to 4) |
|---|---|---|---|
| 1 | `up` | `ArrowUp` | empty |
| 2 | `down` | `ArrowDown` | empty |
| 3 | `left` | `ArrowLeft` | empty |
| 4 | `right` | `ArrowRight` | empty |
| 5 | `a` | `KeyZ` | empty |
| 6 | `b` | `KeyX` | empty |
| 7 | `x` | `KeyA` | empty |
| 8 | `y` | `KeyS` | empty |
| 9 | `start` | `Enter` | empty |
| 10 | `select` | `Space` | empty |

A cartridge without a Keys sheet has no buttons, only the pointer and the two keyboard rows, and the manifest's reader says so in `describe` (§4.6); nothing is bound that nobody wrote.

### 3.5 Clock

Three cells, and no wall clock anywhere (`AD-4`: Frazaro has no clock, Alonzo is the clock; `CHARTER.md` §4, rule 4: `NOW` is the Clock device and `RAND` is a seeded cell). Column A the label, column B the value.

| row | A | B | written by |
|---|---|---|---|
| 1 | `frame` | the frame number: 0 after load, then `n` during and after the `n`th step | the engine, as the first act of every step, and nothing else: a person's write is refused |
| 2 | `rate` | the cartridge's frames per second, the manifest's `(rate ...)`; 0 for a cartridge stepped by edits (§5) | the engine, at load; a person, 0 or a whole number from 1 to 120, which the host reads after each step and steps at |
| 3 | `seed` | the dice: the manifest's `(seed ...)`, or the number the host chose when the manifest says `(seed host)`, a whole number from 1 to 2147483646, so that a Park and Miller cell seeded from it never sticks at 0 | the engine, at load; the host's one write, at load, of a number from the browser's random source, recorded by the replay; a person, a whole number in the same range |

The frame number is the only clock (`ROADMAP.md`, `SPEC.1`). Elapsed time is `=Clock!B1/Clock!B2`, a formula the cartridge writes if it wants seconds; at rate 0 it is `#DIV/0!`, honestly, since no seconds pass, and the frame number counts edits (decision 20). Random numbers are a formula over the seed and the last frame's state, in the open: Park and Miller's minimal standard, `=IF(Clock!B1=1, Clock!B3, MOD(State.last!B1*16807, 2147483647))` in a cell of the cartridge's own sheet, `State!B1` here, the seed its first value, is exact in doubles, since 16807 times 2^31 is under 2^53, and is published ground (*math exists*: Park and Miller 1988, §14; *derived* for the exactness; *corrected 2026-10-10*, `ENGINE.3`: the example had the cell in the Clock's fourth row, `Clock!B4`, which the Clock's layout, `A1:B3`, refuses at load, measured; in a cartridge's own sheet it was exact at all of 40 frames). The engine supplies no random function, and a cartridge naming Excel's volatile functions, `NOW`, `TODAY`, `RAND` or `RANDBETWEEN`, is refused at load by name with the Clock sheet named in the refusal, since a cell that reads the wall clock is a cell no replay can reproduce (*recommendation*; decision 7).

(*Corrected 2026-10-10*, `ENGINE.3`'s first slice, as the engine and the host now answer; measured before, every value landed in all three cells. A person's `cell` row into the Clock is held cell by cell, `cart-write-clock`: the frame refused, since the step writes it first and would undo the write unseen; the rate held to 0 or a whole number from 1 to 120; the seed to a whole number from 1 to 2147483646. A formula and a derived row are refused there already, as cells the host writes. The rate is §9's teacher: the host reads it after each step with the other effects and steps at it, a rate of 0 stepping on edits from there and a rate from 0 ticking again with nothing owed, so the grid and the loop never disagree. The seed the host chooses under `(seed host)` comes from the browser's random source, `crypto.getRandomValues`, and is written once, after the load and before frame 0 is drawn: no time, so §6's second rule holds without its exception.)

### 3.6 Audio

Four voices, each the Web Audio graph's own oscillator and gain and nothing else (`ENGINE.4`; `CHARTER.md` §8: no synthesizer of its own). A table, not a label column, since a voice is a row: row 1 the headers, rows 2 to 5 the voices.

| row | A `voice` | B `wave` | C `note` | D `volume` |
|---|---|---|---|---|
| 2 | 1 | `square`, `triangle`, `sawtooth` or `sine`, the OscillatorNode's own words | a MIDI note number, 69 being A4 at 440 Hz, a fraction allowed for a slide | 0 to 1, the gain; 0 is silence |
| 3 | 2 | | | |
| 4 | 3 | | | |
| 5 | 4 | | | |

The cells hold for one frame: after each step the host reads the four rows and renders each voice's state for the frame's duration, `1/rate` seconds, scheduled against the audio clock with a lookahead and never against the animation clock, which is the lesson of "A Tale of Two Clocks" (*exhibit*, §14). A tick is `volume` 1 for one frame and 0 after, 33 ms at 30 frames a second; a tone is a `note` held over frames; a fanfare is a formula over `Clock!B1`. The frequency is `440 * 2^((note - 69) / 12)`, computed by the host, so that a cartridge thinks in notes as a tracker does and the sheet reads as music. Noise, envelopes and samples are not in this version (§12); Varvara's audio device carries an ADSR and samples (*exhibit*), and a later version may add columns, since a table grows to the right.

(*Corrected 2026-10-10*, `ENGINE.4`'s first slice, as the host now sounds the sheet; every figure a *measurement* of that day under headless Chrome 154, in `REARVIEW.md`.)
- **The timeline.** A frame sounds where the last frame's sound ends: the last frame's time and `1/rate`, the rate the host read after that frame. While the loop keeps up, the frames lie end to end on the audio clock, so a rhythm in the cells is a rhythm in the sound, whatever the display's interval. A frame's time stays between the audio clock's now and 100 ms ahead of it, twice a lookahead of 50 ms:
  - a frame whose time has passed starts the timeline again 50 ms ahead, so a cartridge too heavy for its rate sounds its frames as they come, each voice holding until the next;
  - a frame further ahead than 100 ms is not sounded, and the timeline stays where it was, so a burst after a stall sounds its first frames and skips the rest, as its screen shows only its last;
  - at rate 0 every step sounds 50 ms ahead and holds until the next (§5).
- **The voices.** Each voice is one `OscillatorNode` and one `GainNode`, the voices' gains into one shared gain into the destination, and nothing else: the host computes no sample (`CHARTER.md` §8, held on the shim by `tools/check_web_offline.ps1`).
  - A voice's gain is its volume over four, so four voices at full volume never clip: four squares at gain 1 peak at 3.81, at a quarter at 0.953.
  - The frequency is set at the frame's time, the oscillator keeping its phase, so a slide is a staircase at the frame rate, as a chip's registers are written once a frame.
  - Every change of a voice's gain approaches its value through the graph's own `setTargetAtTime`, with a time constant of 3 ms: a gain set at once steps 17 to 24 times a smooth wave's own largest step, and the approach at most 1.33 times, down to 55 Hz.
  - A wave cannot be scheduled: an oscillator's type takes effect when the JavaScript runs. So a wave changed is a new oscillator started as the old one stops, at one time on the audio clock; while the voice sounds, through a dip, the gain approaching 0 from the frame's time and the switch five time constants, 15 ms, later.
  - Only what changed is scheduled, so a voice that holds costs no event.
- **A voice that is no voice.** The volume is read first, an empty cell being 0, and a volume of 0 is a rest, whatever the rest of the row holds. Above it the wave is one of the four words, compared without case, and the note a number from 0 to 127, MIDI's range, a fraction allowed, every one below the Nyquist frequency of every sample rate from 25 kHz. Anything else in any of the three, a text, a truth value, an error value or a number out of range, silences the voice for the frame, and the host says so once for each cell and each value shown, as it says a Camera cell (§3.8): a notice, the sheet never refused.
- **When it sounds.** Only after a person's act, the page's Sound on, which makes the audio context, since a context a page makes before a gesture stays suspended (the browser's autoplay policy, §14); and only while the loop runs. A pause, a hidden page, the end of a replay, a refused step and an unload each cancel every voice's later events and approach 0 from the audio clock's now; a start sounds the frame the grid holds at once.

### 3.7 File

The picker and the download (`ENGINE.5`), and nothing that reads a path: the browser's File System Access API where it exists and a file input elsewhere, as CALLOSUM §7 decision 8 already settles for Frazaro's project folder (*shelf*), and never `fetch` (`SD-13`). Column A the label, column B the value.

| row | A | B | direction |
|---|---|---|---|
| 1 | `name` | the loaded cartridge's file name as the host gave it, or `the cartridge` when it gave none | written at load |
| 2 | `size` | the cartridge's length in bytes | written at load |
| 3 | `save` | 0 or 1; on a rising edge the host hands the person the grid as a cartridge (§7.5) | an effect, read after each step |

A save is a cartridge: the whole state of a running game is its cells, so the file the host writes is the manifest and every sheet's current values and formulas, which `load` takes back and resumes at the frame it was saved at. The engine does not name files, open folders or list anything; a game's "load" menu is the host's picker.

### 3.8 Camera

The window's place, as two cells (*recommendation*; decision 21): column A the label, column B the value. An effect: the cartridge's formulas write it and the host reads it after each step, and the window it draws for the next frame is the Screen's declared width and height placed at that row and column, passed as the view call's window argument (§4.5), so that the engine knows no camera, the view call takes no new argument, and a scrolling world costs a frame nothing. It is PICO-8's `camera()`, the offset applied at the draw and not per pixel (*exhibit*, §14), where an offset read by every Screen formula would cost the window's every cell a lookup a frame (§3.1). Optional: a cartridge without a Camera sheet draws `A1` to its declared size, as version 1 did. A window past the Screen's extent reads blank, which the plane paints as colour 0 and the grid as empty cells; a value that is not a whole number from 1 reads as 1 and the host says so in its status line (`SD-30`), since the Camera is read after a step and never refused. In grid mode the Camera is the viewport's scroll when the sheet exists; the first game, the spreadsheet, has none, and its scroll stays the host's own state (`SD-23`).

| row | A | B |
|---|---|---|
| 1 | `row` | the window's top row, a whole number from 1 |
| 2 | `column` | the window's left column, a whole number from 1 |

### 3.9 Write

The grid writes the grid, in values (*recommendation*; decision 18; the argument is `docs/ALGEBRA.md` §2.3). A table: row 1 the headers, and a row a write, column A the sheet, column B the address or range, column C the value; a row whose column B is empty is no write. An effect: after each step the host reads the rows and, before the next step's inputs (§5), issues each as its own `write` of one `(derived "<sheet>" "<addr or range>" <value>)` row, so that a value a formula computed lands in another cell as a value, and a refused row is refused by the record's own status 1, with its id and words, while the rest still apply (*corrected 2026-10-08*, `ENGINE.1`, decision 3 of its scoping, found by writing the fake module: version 2 had the host issue these as `cell` rows, which the module cannot tell from a person's edit, and a person's `cell` row may replace a formula where a derived write may not; the `derived` row is the write call's input alone, never a cartridge's row, and the ABI number stays 1, no signature having changed its meaning). Version 1 had one way to keep a state, a formula of the shape `=IF(event, new, Me.last!B5)`, a frame axiom written by hand for every such cell and re-evaluated every frame to conclude that nothing happened, which is the frame problem by its own name (*exhibit*: McCarthy and Hayes 1969, §14); the law of inertia, a value persists unless something writes it, is what the `write` call already gives the host, and this sheet gives it to the cartridge. State is then values that cost nothing to keep, and events are writes: the stacking game's tower is seven values written on a freeze and holds no formula however tall (Appendix B).

| row | A `sheet` | B `address` | C `value` |
|---|---|---|---|
| 2 | a sheet's name | an address or a range; empty for no write | a number, a text, `true` or `false` |
| 3 and on | | | |

The rules. A derived write may target a value cell of any sheet that is not a twin, a host-written cell excepted, and nothing else: a formula cell (the step computes values and never formulas, §2), a twin, a host-written device cell (the Input sheet, the Clock, the File's first two rows) or a cell outside the model's limits is refused by name, `cart-write-derived`, printed by the host as a sentence (`SD-30`), and the remaining rows still apply; the refusal is a function of the frame, so a replay reproduces it. A range fills every cell of the range with the value. Derived writes are applied before the frame's own writes, so a person's edit or the host's Input row wins over a derived write to the same cell. A replay does not log them, since they are re-derived (§7.6). They cost what any effect costs, a formula a row evaluated every frame, so a cartridge keeps its Write sheet short. What is not proposed, and why: a `(formula ...)` row written from a cell would be the program writing code at run time, which the owner's veto of `GENSYM` carries by its own words, "runtime-arbitrary-code-execution is the same wall's other, more obvious breach" (*shelf*: `Frazaro/docs/BETA_ROADMAP.md`, the `GENSYM` entry), and which would make every static property of this page a per-frame property (§9); the first draft of this sheet carried formula rows and was narrowed the same hour (`docs/ALGEBRA.md` §2.3).

### 3.10 The reserved names, and what a new device is

Reserved: `Screen`, `Palette`, `Input`, `Keys`, `Clock`, `Audio`, `File`, `Camera`, `Write`, and every name ending in `.last`, all compared without case. A cartridge's other sheets are its own, including the `Frazaro` sheet a program compiled from English carries (§7.4), which no rule reads. A new device, in a later version of this page, is a sheet with a layout in this section, a direction (input or effect), a row in the host's duties (§8.3) and, only if it cannot be served by a read or a write through the module's exports, an import named in §8.2 and added to the allowlist; the layout comes first and the code after, the order the charter sets for every brick. The candidates this page can already name are the gamepad (an input, filling columns B to E of Input from the Gamepad API, no new sheet), a key matrix (an input, a sheet of codes held), a MIDI port (an input and an effect through the Web MIDI API where the browser has it, a local device and not the network; §12), the patch as a sheet (§12), the composite as a projection (§12, version 3's), and threads (a device of the host's that changes no cell, `CHARTER.md` §4: a device after a measurement).

## 4. The four calls

The engine's whole contract is four calls into `vla-lang`: load a cartridge, write cells, step, view (`CHARTER.md` §4). This section gives each its inputs, its answer and its refusals, in the shape of `frazaro-core`'s C surface, since that shape exists, is tested and is what a page already reads (*shelf*: `core/src/abi.rs`, `web/index.template.html`). The calls are Rust functions of the `vla-lang` crate, which the `alonzo` crate calls directly, and C exports of the engine's module, which the host shim calls; the memory pair and the record are the same on both.

### 4.1 The handle

A loaded grid is kept in the module's memory between calls and named by a **handle**, a whole number from 1 the `load` call returns and every other call takes first; 0 is never a handle, a handle is never reused within one instance of the module, and a call with a handle that is not live is refused by name. This amends CALLOSUM §7 decision 1 for the engine's door, "no model handle in the module's memory", on the measurement that decision asked for (*shelf*): the view record of a 10,000-line program prints in 812 to 893 ms natively (*measurement*, `CHARTER.md` §7), and a frame of 64,000 cells thirty times a second cannot rebuild its grid from text, so the escape hatch the decision named is taken here and nowhere else; Frazaro's own doors keep the pure function. The handle is explicit rather than an implicit single grid (decision 3): it costs one argument, it lets a page hold a game and its replay, or an editor's grid and the running copy, in one instance, and it is how every C surface names an open thing (*exhibit*: a file descriptor; the Component Model's resources are `i32` handles into a per-instance table, §14).

### 4.2 `load`

In: the cartridge's bytes (§7), and a name for the file, used only in refusals, as `frazaro_reflect` takes one (*shelf*). Out: a status-0 record whose text is one row, `(cartridge <handle> "<title>" plane|grid <width> <height> <rate>)`, which is what the host needs to size its canvas and set its timestep. What it does, in order: refuses a file holding a `defmacro` or an `include` as a cartridge's source, before its manifest, at the line of the first (`cart-source-unexpanded`), since the pass expands a source and the load never does (§7.8; decision 31); reads the manifest form and refuses a defect by name (`cart-manifest-invalid`, the distro reader's twin, naming what is wrong); checks the spec version it names against this page's; loads the rows that follow into a fresh grid, as the inverse of what `reflect` prints (§7.3), refusing a row it cannot hold with the row's line in the record's `line` field, and refusing a cell the rows write twice, `cart-cell-written-twice`, naming both lines (decision 23), a `value` row after a `formula` row being the formula's last value and never a second write; makes every sheet's `.last` twin; checks each device sheet against §3 (a Screen cell outside the declared size when there is no Camera sheet, a Palette out of order, a formula in a host-written cell, a cell outside a layout, a volatile function anywhere, a reserved name misused), refusing by name; builds the dependency graph and refuses a cycle by name; writes the Clock's three cells and the File's two; fills the twins with the grid's values; and answers. (*Corrected 2026-10-09*, `ENGINE.1`'s second slice, the order as the engine keeps it over the language's two calls: the Clock's and the File's cells, and the Input sheet with its eighteen labels and zeros when the cartridge holds none, are made in the grid after the device checks and before the graph reads them, so that the host's eighteen rows always land, a write making no sheet; a later `(spec ...)` is refused before any other defect of the manifest, its directives being a later page's; and a load whose rows hold a whole number above 0 in `Clock!B1` is a save's, which resumes at that frame.) Nothing is computed: the frame number is 0 and every formula waits for the first step. Every version 1 cartridge is a version 2 cartridge: `(spec 1)` loads under this page, the one new refusal, a cell written twice, naming a defect version 1 left undefined. And every version 1 and 2 cartridge is a version 3 cartridge, since version 3 adds no row and no directive: its changes are above the rows, in the source and the pass (§7.8), and the one new refusal names a source handed to the load (decision 32).

### 4.3 `write`

In: the handle, and rows in the one notation, `(cell "<sheet>" "<addr or range>" <value>)` or `(formula "<sheet>" "<addr or range>" "<text>")`, one a line, as the cartridge spells them (§7.3) and as the record prints them, or, from the host's derived writes alone, `(derived "<sheet>" "<addr or range>" <value>)`, held to §3.9's rules. Out: `(written <n>)`, the cells changed. A write that refuses a row changes nothing, so the host issues each person's edit and each derived row as its own `write` (*corrected 2026-10-08*, `ENGINE.1`): a refused row then refuses itself and not the frame's inputs, and a replay's rows give the same frames however its writes are grouped. Every input is a cell the host writes and every edit is a cell too (`CHARTER.md` §4): the host's eighteen Input rows before a step and a person's edit of a Board in a cartridge's editor arrive by this one call, told apart by the sheet they touch and nothing else. A write takes effect at once in the grid and not in the twins (§2). Refused by name: a sheet the grid does not hold, naming the ones it does (the `view-sheet-unknown` shape); a `.last` sheet, which is read-only; a Screen cell outside the declared size when there is no Camera sheet; a formula into a host-written device cell; a row that is not a `cell`, `formula` or `derived` row; a formula that would close a cycle, naming it. A range fills every cell of the range with the value, or with the formula moved as Excel moves a filled formula (*shelf*: `Sheet::set_formula`, the shared formula), which is how an editor clears a board in one row. (*Corrected 2026-10-09*, `ENGINE.1`'s second slice, as the language and the engine answer: rows apply in order, and a refused row undoes the rows before it; a value may be an error, `(error "#N/A")`; a write makes no sheet; a cell outside a device sheet's layout is refused at a write as at a load; and the engine's checks run over every row before the language's, so that a write refused by both names the engine's refusal, the only order that keeps a write atomic. *Corrected 2026-10-10*, `ENGINE.3`'s first slice: a `cell` row into the Clock is held to the Clock's cells, the frame refused and the rate and the seed to their ranges, `cart-write-clock` (§3.5).)

### 4.4 `step`

In: the handle, and a budget, the most cells to evaluate in this call, 0 meaning no limit. Out: `(step <frame> <evaluated> <of> done)` or `(step <frame> <evaluated> <of> yielded)`: the frame number being computed, the cells evaluated so far in this frame, the frame's total, and whether the frame is complete. A step that yields holds the frame in progress; the next `step` call continues it, and a `write` between a yield and the completion is refused by name, so that a frame is a function of the inputs it began with (*recommendation*). The budget is in cells and never in milliseconds, so that the frame's values are the same whatever the host's chunking and the step reports work rather than time, the house's rule for every engine (*shelf*: the Frazaro memory, budgets in work, not seconds); the host turns its time slice into cells by measuring how many the last call did per millisecond, which is its business (§5). Refusals: a handle not live; an evaluator refusal `KERNEL.7` defines, such as a function this version does not compute, named, which is raised at load and not here. An error value in a cell, `#DIV/0!`, `#VALUE!`, `#REF!`, `#NAME?`, `#N/A`, `#NUM!`, is a value and propagates as Excel propagates it; it never refuses a step, and on the Screen it is a magenta cell (§3.1). A step never changes a formula (§2, `AD-7`): the formula cells after it are the formula cells before it, cell for cell, which `vla-lang`'s test holds on every fixture (§13).

### 4.5 `view`

In: the handle, a projection's name, a sheet's name and a window (`A1:F20`; empty for the sheet's whole extent), the last two as `frazaro view` takes them (*shelf*: oracle 11); the window is where the Camera is honoured, the host passing the Camera's row and column as the window's top-left and the declared size as its extent (§3.8), so that the engine knows no camera and the call takes no new argument. Out, for the projection `grid`: the view record, the lines the door prints, byte for byte the same spelling, with one row this page asks `KERNEL.7` to add to oracle 11 the day values exist: after each `(formula ...)` row, a `(value "<sheet>" "<addr>" <value>)` row holding the formula's computed value, spelled as a `cell` row's value is, absent before the first step; and two rows this page asks `KERNEL.4` to add to oracle 11 whether or not values exist, `(look "<sheet>" <value> <index>)`, the look map of §7.3, printed after the `format` rows, and `(row "<sheet>" <n> <height|none> shown|hidden)`, the twin of the `column` row, so that a grid cartridge can declare a tall cell (decision 19). Out, for the projection `plane`: the bytes of §3.1, one per cell of the window in row-major order, in the record's text, the one record beside a build's whose text is not UTF-8 (*shelf*: `frazaro_build_xlsx`). The `.last` sheets are viewable by name, and the record's `(sheet ...)` rows list them after the cartridge's own sheets as `hidden`, the reader's own word for a sheet without a tab (*shelf*: `reflect::Visibility`), so that a viewport shows the cartridge's tabs and can show the previous frame on request. Refusals: the view's own two, a sheet unknown and a window that is not a range (*shelf*), and a projection this version does not have, naming the two it has. The plane is a projection of `vla-lang`'s, a pure function of the model and a window whose output can be a golden, and so the language's by `AD-4`; it is the second implementation of the projections seam, which `KERNEL.12` wanted a contributor to write to prove the seam takes additions (*shelf*: `BETA_ROADMAP.md`, `KERNEL.12`; `core/src/kernel.rs`, `Projection`). (*Corrected 2026-10-09*, `ENGINE.1`'s second slice: the plane is selected by name in the view call beside the `Projection` trait, whose output is lines, and is not its second implementation; whether rasters get a seam of their own waits for a second one, `KERNEL.12` still open, in the language's own words, `vla-lang/src/machine/plane.rs`.)

### 4.6 The record, the memory pair, and the calls beside the four

Every answer is one record in `abi.rs`'s shape: four little-endian `u32`, the status, a line, the id's length and the text's length, then the id's bytes and the text's bytes; status 0 is an answer and the text is the output; status 1 is a refusal, the id the catalogue's, the text its words, the line the cartridge row it stands on or 0; status 2 an input that is not UTF-8, named (*shelf*). The host allocates every input with the module's allocator, passes a pointer and a length, and frees inputs and records alike with the length each was allocated with. Beside the four calls the module exports what a page needs and nothing more: the allocator pair; the ABI version, a number that is this page's version and stays while an export is added and no signature changes its meaning, the discipline `frazaro_abi_version` keeps (*shelf*); the crate's version as text (*corrected 2026-10-09*, `ENGINE.1`'s second slice: the engine's and the language's, `alonzo 0.1.0 (vla-lang 0.8.0)`, so that a page names both); `describe`, the manifest as read, one directive a row, then one `(device "<sheet>" ...)` row per device sheet with its layout's extent and direction, then one `(budget <rate> <formula-cells> <a-second> <line>)` row, the cartridge's formula cells after the fills, their product with the rate, and the charter's line of two million a second, so that a page prints what it loaded, a stranger sees the devices without this page, and a cartridge over the console's line says so before it runs slowly (§10, decision 24); `unload`, which frees a handle; and, since version 3, `expand`, the pass of §7.8, a source and the texts it includes in and the cartridge's text out, so that the page builds what it loads by the same function as the command line, as an act of its own that no load calls (decision 26; built 2026-10-10, `SPEC.3`'s second slice: the texts it includes come in one buffer, each path then its text, a NUL between each and the next, as Frazaro's translate takes its phrasebooks (*shelf*); it takes no handle and touches no grid; and a host asks for it when a person builds and not when it attaches the module, so that a module without it, the page's double, still drives the loop and declines a build in words; `tools/check_host_exports.ps1` holds the twelve names). The names, as the engine exports them and the shim calls them:

| export | takes | answers |
|---|---|---|
| `alonzo_abi_version` | nothing | `1`, as a bare `u32` |
| `alonzo_version_text` | nothing | the crate's version |
| `alonzo_alloc`, `alonzo_free` | a length; a pointer and its length | the memory pair |
| `alonzo_load` | the cartridge's bytes, a name | `(cartridge <handle> "<title>" <mode> <w> <h> <rate>)` |
| `alonzo_describe` | a handle | the manifest and the device rows |
| `alonzo_write` | a handle, rows | `(written <n>)` |
| `alonzo_step` | a handle, a budget | `(step <frame> <evaluated> <of> done\|yielded)` |
| `alonzo_view` | a handle, a projection, a sheet, a window | the record, or the plane's bytes |
| `alonzo_unload` | a handle | `(unloaded <handle>)` |
| `alonzo_expand` | a source, its path, and the texts it may include, each path and its text NUL-separated in one buffer | the cartridge's text, the pass's (§7.8), the command line's bytes |
| `memory` | | the module's one linear memory |

`vla-lang` provides the four under its own names, `vla_load`, `vla_write`, `vla_step` and `vla_view`, with the same records, so that a door may embed the bare machine without the devices (*recommendation*; the crate's own C surface is the cut's to shape, and this page asks only that the four exist with these answers). What `alonzo_load` adds to `vla_load` is the manifest and the device checks; what `alonzo_step` adds to `vla_step` is the Clock's frame cell; `write` and `view` add nothing.

### 4.7 The refusals, by family

Every refusal is a catalogue entry with an id, a template and slots, as every Frazaro refusal is (`SD-2`); the ids below are proposed, and the item that lands each mints it in the catalogue. `cart-*`, the engine's own: `cart-manifest-invalid` (the distro reader's shape, what is wrong in a slot), `cart-spec-unsupported` (a `(spec n)` this engine does not read, naming the version it reads), `cart-sheet-reserved` (a name ending in `.last`, or a device name used for something else), `cart-screen-outside` (a Screen cell beyond the declared size), `cart-palette-invalid` (the sixteen rows out of order or a colour not `#RRGGBB`), `cart-device-cell-formula` (a formula where the host writes), `cart-device-cell-outside` (a cell outside a layout), `cart-formula-volatile` (`NOW`, `TODAY`, `RAND`, `RANDBETWEEN`, with the Clock named), `cart-handle-unknown`, `cart-write-last` (a write into a twin), `cart-write-during-step` (a write between a yield and the completion), `cart-projection-unknown`, `cart-cell-written-twice` (a cell the cartridge's rows write twice, both lines named), `cart-write-derived` (a `derived` row into a formula cell, a twin, a host-written cell or past the limits, named and printed by the host, the frame continuing). `grid-*`, the language's, for the rows: `grid-row-unknown` (a row that is not one the loader takes), `grid-row-malformed` (the wrong shape, the line named), `grid-cycle` (the cells that close it), and recalculation's own for a function outside the subset, which `KERNEL.7` names. The view's two stand as they are. (*Corrected 2026-10-09*, `ENGINE.1`'s second slice, the ids as `KERNEL.22` and the engine minted them; the names above stand as the page's history. The machine's refusals are the language's: `grid-handle-unknown`, `grid-handle-limit`, `grid-write-during-step`, `grid-write-last` (a write into a twin, derived or not), `grid-sheet-unknown` (a write's sheet the grid does not hold), `grid-sheet-name-invalid`, `grid-cell-written-twice`, `grid-write-derived` (a derived row over a formula), `grid-too-many-cells`, `grid-row-unknown`, `grid-row-malformed`, `view-sheet-unknown`, `view-window-not-a-range`, `view-projection-unknown`, `view-window-too-large`, and recalculation's `calc-cycle`, `calc-function-not-computed` and `calc-construct-not-read`. The engine's own are eight, in `engine/data/messages.vla`: `cart-manifest-invalid`, `cart-spec-unsupported`, `cart-screen-outside`, `cart-palette-invalid`, `cart-device-cell-formula`, `cart-device-cell-outside`, `cart-formula-volatile`, and `cart-write-derived`, narrowed to a derived row into a cell the host writes; since version 3 a ninth, `cart-source-unexpanded`, a file holding a `defmacro` or an `include` handed to the load, which is a source and the pass's to expand (§7.8); and since `ENGINE.3` a tenth, `cart-write-clock`, a person's write into the Clock's frame, or a rate or a seed outside its range (§3.5). `cart-sheet-reserved` is withdrawn: a name ending in `.last` is the language's `grid-sheet-name-invalid`, and a device sheet used for something else is a cell outside its layout.)

## 5. The frame's order of operations

The loop is the host's and only the host's (`AD-4`), in JavaScript, in `web/`, hand-written and read in review (`AD-5`). Its shape is the fixed timestep with an accumulator, the standard the industry settled in Fiedler's "Fix Your Timestep!" (*exhibit*, §14), with two changes a sheet allows: there is no interpolation, since a frame has no sub-frame state to interpolate, and the loop never skips a step to catch up, since the frame number is the clock and a skipped frame would be a frame that never existed.

1. **The tick.** The browser calls the host's animation-frame callback with a timestamp (*exhibit*: `requestAnimationFrame`'s `DOMHighResTimeStamp`). The host adds the elapsed wall time to an accumulator, after capping it at a quarter of a second so that a stalled tab does not ask for a hundred frames at once, Fiedler's cap against the spiral of death (*exhibit*). (*Corrected 2026-10-10*, `ENGINE.3`, found by the owner's hand test: the host held the accumulator itself to the same quarter second, against a backlog of slow steps, so a rate under four frames a second, whose interval is longer, was never owed a frame, and the teacher's rate of 1 froze the loop, the edit that would have raised it again waiting for a frame that never began. The backlog is held to the larger of a quarter of a second and one frame's interval, and a rate that moves starts it again with nothing owed.) While the accumulator holds at least one frame's interval, `1/rate`, the host runs one frame (steps 2 to 6) and subtracts the interval; a host that cannot keep up runs late, never ahead, and never skips (*recommendation*). When the page is hidden the host stops ticking and resets the accumulator on return (*exhibit*: the Page Visibility API; background tabs are throttled), so a game in a background tab is paused, not fast-forwarded.
2. **The derived writes.** The host issues the Write sheet's rows it read after the last step (§3.9), each as its own `write` of one `derived` row (*corrected 2026-10-08*, `ENGINE.1`), before the inputs, so that a person's edit or an Input row wins over a derived write to the same cell; a refused row is printed as a sentence and the rest apply; a replay re-derives them and logs none.
3. **The inputs.** The host writes the Input sheet's eighteen rows for the frame, from the state of the keys it holds (set by `keydown` and `keyup` on `code`, mapped through the Keys sheet it last read), the pointer's place in Screen cells, the buttons, the wheel's notches and the last key, as one `write` of rows; a person's edit, from a cartridge's editor, follows as its own `write`, so that a refused edit refuses itself and not the frame's inputs, and a replay issues its rows the same way, all before the step (*corrected 2026-10-08*, `ENGINE.1`; version 2 had the edits in the inputs' call). (*Corrected 2026-10-10*, `ENGINE.3`'s second slice: a replay issues each frame's rows as one `write` after the derived writes, its Input rows and a person's edits together in their order; a write applies its rows in order and every row a replay logs had landed, so the one write lands as the live writes did, §7.6.)
4. **The step.** The host calls `step` with a budget of cells. It sets the budget from the last call's cells per millisecond and the time it means to spend, a fraction of the display's interval that leaves room for the draw; if the step yields, the host draws the last complete frame from the twins and continues the step on the next tick, reporting the progress as a sentence in its status line (`SD-34`: `frame 42, 31,000 of 64,000 cells`), so that a cartridge too heavy for the machine runs slowly in plain sight rather than freezing the page.
5. **The effects.** When the step is done the host reads, through `view`: the Screen as the plane (plane mode) or as the record (grid mode); the Palette's sixteen rows; the Audio's four rows; the File's `save` cell; the Keys sheet, whose changes rebind the keys for the next frame; the Camera's two cells, which place the next frame's window; and the Write sheet's rows, which become the next frame's derived writes; and the Clock's rate, which a person's write may have moved and the loop then steps at (*corrected 2026-10-10*, `ENGINE.3`; §3.5). A view the host holds over the module's memory is made fresh for each read and never kept, since the memory's buffer is detached by any growth of the module's memory (*exhibit*: MDN, `Memory.grow`, §14).
6. **The draw and the sound.** Plane mode: the host writes the bytes through the Palette into an `ImageData` of the window's size and draws it onto the visible canvas scaled by a whole number of device pixels per cell with image smoothing off, the one way a 2D context stays crisp (*exhibit*: `imageSmoothingEnabled`, §14); `KERNEL.3` decided the canvas (`CHARTER.md` §7, *measurement*), and a WebGL texture of indices with the palette in a fragment shader is the escape hatch, taken only when a measurement on `CART.1` names the blit as the bottleneck (rule 3's spirit). Grid mode: the viewport draws the record (`KERNEL.5`). Sound: each voice's oscillator and gain are set for the frame's audio time, a lookahead ahead of the audio clock (*exhibit*, §14). (*Corrected 2026-10-10*, `ENGINE.4`: the sound is scheduled after the Clock's rate is read, so that a rate a frame writes times that frame's sound; the frame's time is §3.6's timeline, and only the voices that changed are scheduled.) A `save` edge hands the person the file (§7.5).

Pipelining, the draw of one frame beside the step of the next, is the host's (`CHARTER.md` §4) and needs a worker and an `OffscreenCanvas`, which changes nothing on this page; it is taken when a measurement wants it (`ENGINE.1`). Every call into the module is synchronous and one at a time; the engine is never re-entered.

**Rate zero** (*recommendation*; decision 20). A cartridge whose manifest says `(rate 0)` has no tick and no accumulator: the host steps once after each `write` made on a person's act, an edit, so that the frame number is the count of edits, the replay is the undo history, and `SD-22`'s source apart from the changes is the cartridge apart from its replay. The Input sheet is not written (§3.3), there being no frame to hold a button in; the derived writes of step 2 still apply before the next edit's step and never trigger a step of their own, so a Write row that is never empty cannot step the grid forever; the effects are read and drawn after each step as at any rate, and a voice's state holds until the next step, since `1/rate` is undefined (*noted 2026-10-10*, `ENGINE.4`: each step sounds 50 ms ahead of the audio clock, §3.6). Version 1's slogan, a spreadsheet as a game whose frame rate is one, was a figure; the first game is a cartridge at rate zero with no special case in the host, and `frazaro view` already prints its frames.

## 6. Determinism

The rules, each a sentence, so that a replay is a proof and a floor is a number (*recommendation* throughout; the owner's standing brief for every engine, determinism first, *shelf*: the Frazaro memory):

1. **A fixed timestep.** The cartridge declares its rate; a frame is one step; the host never runs a partial frame and never skips one. Wall time decides only when steps happen, never what they compute. At rate 0 there is no timestep: a frame is one edit, and the host steps once for each write made on a person's act (§5).
2. **The frame number is the only clock.** `Clock!B1`, written by the engine; `NOW` and `TODAY` are refused; the host writes no time into any cell, ever. (*Corrected 2026-10-10*, `ENGINE.3`: the sentence ended "except the seed at load when the manifest asks for it"; the seed the host writes then is the browser's random number and no time, §3.5, so the exception is gone.)
3. **A seeded cell is the only dice.** `Clock!B3`, from the manifest or from the host once at load, recorded by the replay; `RAND` and `RANDBETWEEN` are refused; a random number is a formula of the seed and the last frame (§3.5).
4. **The input log is the only nondeterminism.** The grid after step `n` is a function of the cartridge's bytes, the seed and the rows a person or the host's Input wrote before each of the `n` steps, and of nothing else; the host's derived writes (§3.9) are a function of those and add nothing. This is Doom's demo contract, a record of every tic's inputs from which the game replays bit for bit, with the generator's state synchronized (*exhibit*, §14), and it is the oracle every cartridge with input takes (`CART.4`; §7.6).
5. **Arithmetic is IEEE 754 doubles,** the language's `f64`, VBA's `Double` and Excel's own (*shelf*: `HORIZON.md` §12.2). WebAssembly's floating-point operations are deterministic except for the payload bits of a NaN (*exhibit*: the specification's nondeterminism note, §14), and a module with an empty import section computes every function inside itself, its transcendental functions included, so the same module gives the same bits on every browser; the native runner may differ from the module in the last bit of a transcendental function, since its library is the platform's, which is why a replay golden is held on the module and a floor is held on the runner (*recommendation*; `CART.1`, `CART.4`). (*Corrected 2026-10-09*, `CART.1`'s scoping, decision 4: a floor is held on the runner and on the module both, since one build of the language moved the native step by 55% and the module's by 35%, the two measured apart by a factor of 1.4 (*measurement*); `tools/check_frame_floors.ps1` holds four rows, native and wasm, Life's soup and the glider gun, and the runner's check mode holds a frame's allocations, the one number of the step that is the code's and not the machine's.)
6. **A budget never changes a value.** A step chunked by any budget computes the same frame as a step with none.
7. **Threads, SIMD and every accelerator are invisible.** An accelerator's frames equal the naive evaluation's frames, cell for cell, or it is not merged (`ENGINE.6`; `SD-18`'s shape); threads are a device after a measurement and change no rule above.
8. **The step computes values and never formulas.** A formula enters the grid by `load` or by a `write` made on a person's act, and the host's derived writes carry values alone; the formula cells after a step are the formula cells before it, cell for cell (`AD-7`, §9; decision 22).

What a replay cannot prove: the host's draw and sound, which are measured (frame times, floors) and never golden, by `AD-4`'s line.

## 7. The cartridge

### 7.1 One file

A cartridge is one text file, UTF-8, `.vla`, a form and then rows: the manifest form first, `(cartridge "<name>" ...)`, then the grid's rows, one a line, in the notation the treaty's oracles print (*shelf*: oracles 8 and 11). One file is what every console shares: a `.p8` is one text file with sections, a `.tic` one file of chunks, a uxn `.rom` one file (*exhibits*); one file is what a file input can pick and a person can share, diff and read. A folder of files, the manifest naming them by path as the distro manifest does (*shelf*: `core/src/distro.rs`), is the source layout a tool flattens into the one file, and is not what the engine loads; the tool is a later item's. (*Corrected 2026-10-10*, version 3: the tool is the pass of §7.8. A cartridge's source is the file a person writes, VLA with template macros, naming the other files it reads by path through `include`; the pass expands it into the one file, the artifact a person reads, saves and diffs; and the engine loads the one file alone.) The file carries its licence as its first comment line, `; SPDX-License-Identifier: 0BSD` for a cartridge in this repository, the rule `REPO.2`'s licence check holds over `cartridges/` (*shelf*: `REARVIEW.md`, `REPO.2`, decision 5), and a cartridge of one's own carries its author's.

### 7.2 The manifest

One `(cartridge "name" ...)` form, one directive a line, every directive given (nothing defaulted, so that the file says what it is; *recommendation*, the owner's rule against hidden defaults), read by the engine as the distro manifest is read and refused by name with what is wrong:

```text
; SPDX-License-Identifier: 0BSD
(cartridge "life"
  (spec 3)                     ; the version of this page the cartridge is written to; a (spec 1) or (spec 2) cartridge loads too
  (title "Life")               ; what the host shows
  (rate 30)                    ; frames per second, 0 to 120; 0 is a step on every edit (section 5)
  (screen plane 320 200)       ; plane|grid, width, height, within the limits of section 10
  (seed 1)                     ; a whole number, or host
  (author "Spreadsheet Company")   ; optional
  (licence "0BSD")             ; optional, an SPDX identifier, the header's twin
  (notes "..."))               ; optional, a paragraph for the person who loads it
```

The name is lowercase letters, digits and hyphens, as a distro's is (*shelf*). `(seed host)` asks the host for a seed at load, the one place the wall clock may enter a cell, and the replay records what it chose. (*Corrected 2026-10-10*, `ENGINE.3`: no clock enters a cell; the host's seed is the browser's random number, §3.5, and a replay's header names it, §7.6.) A directive this version does not know is refused by name, so that a cartridge written to a later page fails loudly on an older engine, which is also what `(spec ...)` is for; every version 1 cartridge loads under version 2, and every version 1 and 2 cartridge under version 3, which adds no directive (§4.2). A cartridge says the version of the rows it uses: the three in this repository say `(spec 2)`, written before version 3 and using nothing it adds, and their measured rows stand as they are (decision 32).

### 7.3 The rows

The rows are the relation rows `reflect` and `view` print, so that **what a door prints, the engine loads**: `load` is the inverse of `view`, and a sheet viewed whole and loaded again is the same sheet (*recommendation*; the oracle in §13). They are also what the pass writes (§7.8): a source's macros expand into nothing but these rows, and the load takes no other form, so that every convenience of authoring stays in the source, and a port of the engine implements none (decision 29). The kinds this version takes, in the printers' spelling (*shelf*: `core/src/reflect/print.rs`, oracle 11):

| row | meaning |
|---|---|
| `(sheet "<name>" visible\|hidden)` | a sheet, in tab order; optional, since a cell row makes its sheet |
| `(cell "<sheet>" "<addr>" <value>)` | a value: a number as written, a text in quotes, `true` or `false`, `(error "#NUM!")` |
| `(cell "<sheet>" "<range>" <value>)` | every cell of the range holds the value; the one addition to the printers' rows, so that a border is one row |
| `(formula "<sheet>" "<addr>" "=<text>")` | a formula, A1 references, the bar's spelling |
| `(formula "<sheet>" "<range>" "=<text>")` | the formula filled over the range, its relative references moved as Excel moves a filled formula, which is how a rule covers a Screen in one row and how `KERNEL.20` sees one shape |
| `(name "<name>" "<refers-to>")` | a defined name |
| `(column ...)`, `(format ...)`, `(style ...)`, `(gridlines ...)` | the looks, as the record prints them; grid mode draws them, plane mode keeps them |
| `(sentence "<sheet>" "<addr>" <row>)` | the program row that wrote the cell, kept for the sentence pane (`SD-35`), read by no rule |
| `(table ...)`, `(refers ...)` | carried as data in this version; a Table's lookups wait on `KERNEL.8` |
| `(look "<sheet>" <value> <index>)` | the look map: every cell of the sheet whose value is `<value>` draws with style `<index>` in place of its own, which is the Palette in the record's own terms; asked of oracle 11 after the `format` rows (decision 19) |
| `(row "<sheet>" <n> <height\|none> shown\|hidden)` | a row's height and visibility, the twin of the `column` row, asked of oracle 11; a viewport without it draws the default height |
| `(value "<sheet>" "<addr>" <value>)` after a `formula` row | the formula's last value, as a save prints it (§4.5, §7.5); taken as the cell's value until the first step, never a second write of the cell |

R1C1 is not an input notation in this version: a filled formula gives the same one shape, and the view record prints A1 (§12).

**One write per cell.** A cell the rows write twice, by two rows or by a range and a row over one of its cells, is refused at load by name with both lines (§4.2; decision 23), so that the file says one thing about each cell and a collision is loud rather than last-wins. That is the prelude's own doctrine for a template macro's bindings, two uses of a name colliding loudly at VBA's compile step rather than hidden by a hygiene mechanism (*shelf*: `scripts/prelude.vla`), carried into cells, where nothing but the loader can be loud (`docs/ALGEBRA.md` §2.4).

### 7.4 Frazaro is the compiler

A game written in English is translated by Frazaro at build time and ships as VLA (`CHARTER.md` §4, rule 1): `frazaro build` builds the program into the sheet model and `frazaro view` prints any sheet of it as rows (*shelf*), so a cartridge compiled from English is the manifest followed by the view of each sheet, the `Frazaro` sheet with the sentences included, and the `(sentence ...)` rows link every cell to the sentence that wrote it. The same road takes any workbook: `frazaro reflect book.xlsx` prints its sheets as rows, and a manifest in front of them is a cartridge, which is the thesis as a command line, a spreadsheet being a game whose frame rate is one. The engine reads no English and no `.xlsx`; the rows are the whole interface between Frazaro's module and this one, two modules on one page, one text between them, and `alonzo` never depends on `frazaro-core` (`AD-1`). A cartridge written in VLA takes the other road, through no door of Frazaro's: its macros are the language's, expanded by the pass (§7.8) with the language's own expander, so that a game's build needs the language and never the core (`CHARTER.md` §4, rule 1; decision 26).

### 7.5 A save is a cartridge

On a `save` edge (§3.7) the host asks `view` for every sheet that is not a twin, whole, and writes the manifest it loaded followed by those rows, with the Clock's frame as it stands, under the name `<name>-<frame>.vla`; `load` of that file resumes the game at that frame with the same seed, since the state is the cells and nothing else. The Input sheet's rows are saved too, as values, which is harmless and honest. The twins are not saved, being derivable: a loaded save's twins are filled with its values, so the first step after a load reads a previous frame equal to this one, which a rising edge sees as no edge, the right answer.

### 7.6 The replay

A replay is the log of writes between steps, with the cartridge and the seed named, so that playing it back is issuing the same writes before the same steps:

```text
(replay "life" (spec 2) (cartridge "<sha-256 of the cartridge file, upper-case hex>") (seed 12345))
(frame 1)
(cell "Input" "B5" 1)
(frame 2)
(cell "Input" "B5" 0)
(frame 3)
...
```

`(frame n)` heads the rows written before the `n`th step; a frame with no row is a frame with no change, and a host may log only the cells that changed, since a write of the value a cell already holds changes nothing. The host's derived writes (§3.9) are not logged, being a function of the frame: a replay re-derives them, and the one way they could differ is a changed cartridge, which the digest refuses. The golden of a replay is a sheet at its end, as `view` prints it, compared whole: `CART.4`'s Board, `CART.1`'s Screen at generation `n` against Golly's (*shelf*: `ROADMAP.md`). (*Corrected 2026-10-09*, `CART.1`'s scoping, decision 2: Life's Screen is held at every frame to a Life written by hand, by the native runner and by the page's instrument, the plane compared whole; and the glider gun to its published facts, period 30, 36 cells and 5 more a period, through generation 720, before its first glider meets the dead border at 740, where the cartridge's bounded plane and Golly's unbounded one stop agreeing (*measurement*, the runner's Life). A cartridge with no input has an empty replay, so its golden is the reference's frame.) A replay names the spec version and the cartridge's digest, since a replay against another cartridge or another page is nonsense, which is Doom's caveat too (*exhibit*). (*Noted 2026-10-10*, version 3: the digest is the cartridge's, the pass's output, and never its source's, so that the file a replay names is the file the engine loaded. The pass carries no comment and its banner no digest, so a cartridge's bytes move only with its rows, and a source's comments never orphan a replay.)

(*Corrected 2026-10-10*, at the owner's word after `ENGINE.3` closed: a frame is one form holding its rows, `(frame 1 (cell "Input" "B5" 1))`, where the example above writes a `(frame n)` head and the rows after it. One form is then the one write a player issues for its frame, its structure saying what the head's position said; a form after the header that is no frame is refused, and a row can no longer stand before the first frame. The recorder writes a frame's rows one a line inside its form, and a frame with no row as `(frame n)`.)

(*Noted 2026-10-10*, `ENGINE.3`'s second slice, decision 8, as the host records and plays a replay and `tools/check_cartridge.ps1` reads one.) The header is `(replay "<name>" (spec <n>) (cartridge "<SHA-256>") (seed <n>))`: the cartridge's name; the version of this page the host implements, 3, a player reading 1 to 3; the SHA-256 of the cartridge's text with its line ends LF, in upper-case hex, so that a CRLF checkout and the page's text box name one file; and `Clock!B3` as the load left it. A row is logged only when its write landed, and a derived row never. The Input rows are logged as the cells that changed against the replay's own record of the sheet, which knows nothing at the first frame and nothing after a person's edit of the Input sheet, so those frames log the sheet's forty-eight cells whole; each person's edit that landed is its row, in order, in its frame. A frame with no row is not written, except the last, so that a replay names its length. The player loads the cartridge again with the replay's seed and issues each frame's rows as one write after the derived writes, then steps to done (§5, step 3, as corrected); a person's edit is refused while a replay plays, and at its last frame the loop pauses. A replay of another cartridge's digest, of a later page, with a derived row, with a form outside its frames or with its frames out of order is refused in words before anything loads, and so is one whose seed is not its cartridge's `(seed n)`. The recorder records what is played, so that a replay played and copied is the replay played. A replay sits in its cartridge's folder as `<name>.replay.vla`, one a cartridge in this version, after its licence line; its golden beside it, `<name>.golden.vla`, is the record `view` prints of one window of the sheet at the replay's end, its `window` row naming the sheet, after its licence line, compared whole. The input card's replay is the loop oracle's own run of it: the oracle plays it to every frame of that run and to its golden on the module, and `cargo test` plays it with the engine alone. (*Noted 2026-10-10*, `ENGINE.4`'s second slice: the sound card's replay is the second, the loop oracle's `audio` run over the module as the host recorded it, its golden the Log's record at its end, the last 32 frames of the four voices, the control log note for note; the oracle plays it to the card computed by hand at every frame and to its golden, and `cargo test` plays every committed replay with the engine alone, each frame's derived writes read off the Write sheet as the host reads them.) `CART.4`'s "a sheet of its own" for a replay is superseded by these rows, since a sheet of forty-eight cells a frame would carry no person's edit, and its loader would be a second reader of the same facts.

### 7.7 The terms

A cartridge in this repository is 0BSD, made to be copied (*shelf*: `REUSE.toml`); a game of one's own is its author's, under the terms its header names; the engine takes no interest in either, and the analogue of Frazaro's `OUTPUT-EXCEPTION.md` is written the day the first game ships (`CHARTER.md` §9).

### 7.8 The source and the pass

*Version 3's, 2026-10-10 (`SPEC.3`, decisions 25 to 35).* A person writes a cartridge as a source, VLA with template macros, and the pass expands it into the rows of §7.3, the one file the engine loads. The pass is how the house's macros do the rote work of writing rows, and it is written for the owner's principle, given at the approval: "hand-typing boilerplate is not conducive to rapid iteration, and rapid iteration is the psychological barrier between creative flow and task abandonment". So the pass knows no macro by name. Every macro is an author's, in the source or in a library the source includes, and the repository's library, `cartridges/common.vla`, is a file like any other, written to be read, copied, changed and outgrown. A palette is one call there, a pattern one call a row of it, a run of rows on one sheet one call that names the sheet once, and a patch one call a module (Appendix C).

**The act** (*recommendation*; decision 25, the owner's refinement of 2026-10-10). The pass is an act of its own between the source and the load. The load takes rows and never expands; the pass takes a source and the texts it includes, writes rows, and never loads; a door may run the load after the pass, as an act of its own, to say whether the cartridge loads. The pass's output, the cartridge, is the artifact a person reads, saves and diffs, and where the pass runs is not what it is. It is one pure function of its texts in the engine's crate (`engine/src/pass.rs`), over the language's own expander, with two doors, the command line (`cargo run --release --example expand`, which writes each cartridge beside its source and then loads it) and the page (`alonzo_expand`, §4.6, the engine panel's Build, a press of its own before Load, which puts the cartridge where it is read before anything loads it), giving the same bytes (decision 26).

**The source**, in this order:
- its licence, the first line (§7.1), which the cartridge carries as its own first line;
- any `(include "path")` line;
- template macros, `(defmacro ...)`, anywhere, each defined before any form expands, as the language's first pass defines them;
- the manifest, the first form that is no macro, copied as written and never expanded, so that the source states what the cartridge is;
- then the rows of §7.3 and calls of macros, in any mix.

A source is named `<name>.source.vla` and stands beside the cartridge it writes, `<name>.vla`, in the cartridge's folder (decision 28).

**The include** (decision 27). It is the reference's, `VLA.bas`'s P.L7:
- a line holding the form alone, spliced where it stands;
- its path resolved against the source's own folder, as the reference resolves against the workbook's, the includes of an included text too;
- nested at most 16 deep;
- refused with the language's own ids: `vla-include-cannot-read`, `vla-include-too-deep`, and `vla-include-must-stand-alone` for an include inside a form or beside one.

The pass reads no file. Each door hands it the texts the source may include, under the paths they resolve to: the command line reads them from disk, and the page passes the ones it embeds.

**The pass, in order:**
1. the includes spliced, each included form standing on its include's line for a refusal;
2. every `defmacro` defined by the language's expander;
3. the manifest found, the first other form, and copied;
4. every form after it expanded to its fixpoint by the language's expander: template substitution, the rest parameter, the quasiquote bundle and the seventeen expand-time primitives (twenty-seven since `vla-lang` 0.9.0, *corrected 2026-10-11* below), with no gensym and no eval;
5. each `begin` flattened, a `begin` being no row;
6. the cartridge written: the source's licence line; a banner, `; Expanded by the pass from <name>.source.vla: edit that file, then expand it again.`; the manifest one directive a line; and the rows one a line; CRLF, as every `.vla` stands in the working tree.

The pass judges no row. A form the load would refuse is written, and the load refuses it at its line in the cartridge, one form a line. A refusal of the pass itself stands on the source line of the form that raised it. The banner holds no digest, so a comment edited in a source never moves its cartridge's bytes.

**The golden.** Every cartridge with a source is the pass's expansion of it, byte for byte over LF.
- `cargo test` holds it, reading the folder, so that a cartridge added with its source is held without a line of code.
- `tools/check_cartridge.ps1` holds, statically, the folder rule, each source beside its cartridge and each banner naming its source.
- The loop oracle holds the page's pass to the command line's bytes: its eleventh case, `pass`, expands every source the page holds over the module and compares each with its cartridge as the command line wrote it, CRLF; a build over the double is declined in words.

A cartridge with no source is written by hand and stays a cartridge, as every version 2 cartridge was.

**What a template macro reaches today** (*measurement*, 2026-10-10, `vla-lang` 0.8.1; `REARVIEW.md`, `SPEC.3`):
- *A row, by arithmetic.* `(+expand row 1)`, and an address fused from it: `(symbol "\"A" (+expand row 1))` is the text `"A1"`, since `symbol` makes a string of a fused text that opens on a quote mark.
- *A column and a sheet, only by the names its caller writes.* No primitive turns a column's number into its letters.
- *A formula's text, fused from atoms.* `(symbol "\"=IF(MOD(Clock!B1,C" row ")=0,1,0)")` is a formula a module writes. A flat expression becomes a formula too, but not a nested one, since a macro cannot call itself inside `symbol` (`vla-symbol-arg-is-list`).
- *A list, by recursion in tail position.* The trampoline keeps the rows flat: the three cartridges' expansions nest 3 deep. A chain stops at 5,000 applications, and each step copies the rest of the list, so a walk over dozens of items costs nothing and one over a Screen's 64,000 about four seconds.
- *Never a text split into its characters.* A picture written as a string is no macro's (§12).
- *The template doctrine's one trap.* A parameter replaces its name everywhere in the template, a row's head included, so a parameter is never named like a row it writes: a parameter `name` turns `(name name ...)` into a row the load refuses.

The generality the owner's principle asks for, at the row, the column and the sheet, is the language's to give, and §12 names it as the pass's next step.

(*Corrected 2026-10-11*, the pin at `vla-lang` 0.9.0, Frazaro's `VLA.3`: that step is given.)
- Ten primitives join the seventeen, twenty-seven in all, each refusing by name what it cannot compute: a fraction to divide, a zero divisor, a row or a column past Excel's limits, a text that is no address. The ten:
  - `-expand` and `*expand`;
  - `quotient-expand` and `mod-expand`, Excel's `QUOTIENT` and `MOD` over whole numbers;
  - `&expand`, its atoms joined into one text, so that an address or a formula's text needs no leading quote mark: `(&expand "A" (+expand row 1))` is the text `"A1"`;
  - `characters-expand`, a text split into its characters, so that a picture written as a string can become cells;
  - `address-expand`, `"B3"` for row 3 and column 2;
  - `row-expand`, `column-expand` and `column-letters-expand`, an address or a column read back.
- So a template macro reaches a column by arithmetic as it reaches a row, and the list above, measured at 0.8.1, stands corrected in its second, third and fifth points.
- The library's `keys-from` joins its addresses by `&expand` since the same day, every cartridge expanding to the same bytes. Appendix C's patch, written before, fuses its addresses by `symbol` still, which still works.

## 8. The host

### 8.1 The exports

The twelve names of §4.6, eleven functions and the memory, and nothing else (*noted 2026-10-10*, version 3: the twelfth, `alonzo_expand`, the pass, which a host asks for when a person builds and not when it attaches the module, since the page's double holds no pass). A page instantiates the module with an empty import object, reads `alonzo_abi_version` and refuses a number other than this page's, as the Frazaro page does with the core (*shelf*: `web/index.template.html`).

### 8.2 The imports: none

**The engine's import section is empty in this version** (*recommendation*; decision 1, the one this page most wants the owner to read). Every device above is a sheet the host writes before a step or reads after one, through the exports: the Screen and the Audio are read, the Input is written, the Clock is the engine's own, the File is a picker whose bytes come in through `load` and a download whose bytes go out through `view`. Nothing in the frame needs the module to call the host, because the loop lives in the host, and the one thing an import buys, a call out of the module in the middle of a step, nothing here wants. So the allowlist `REPO.2` holds stays at its count of zero, which is the same fact `frazaro-core` proves on its artifact, and it means more here: a module with no imports is a pure function of its inputs, bit for bit, which is what makes rule 5 of §6 true across browsers and makes `SD-13` a property of the file rather than of the shim. The charter's §2 expected imports, "because a game must draw, sound and listen, and every one of those is the host's function"; the sentence is true of the host and this page keeps it there. Both were amended on 2026-10-08 at the owner's approval: §2's "will have imports" reads "may have", and `AD-5`'s second sentence begins "Each import, when one is needed,", the rest unchanged, since the rule's substance, no generated glue and no second dependency, holds exactly as adopted. The alternative, declined: `alonzo.blit` and `alonzo.note` as imports the engine calls, which would put the draw inside the step, cost native tests a stub for every import, and buy no frame this version can draw sooner. The day a device needs an import, threads being the one candidate this page can name, it is declared under the one module name `REPO.2` chose, `alonzo`, listed in §3.10 and in the allowlist with the count beside it, and read in review.

### 8.3 The shim's duties

The host shim is the JavaScript of `web/`, a template `tools/build_web.ps1` fills with the module, in Frazaro's split (*shelf*: `.gitignore`), and it is the whole of what rule 3 rents: it instantiates the module; reads a picked file into the module's memory (`ENGINE.5`); runs the loop of §5 (`ENGINE.1`); holds the key state and writes the Input rows, mapping keys through the Keys sheet and the pointer through the Camera (`ENGINE.3`); chooses the seed at load when the manifest says `(seed host)`, and reads the Clock's rate after each step and steps at it (`ENGINE.3`, *corrected 2026-10-10*); records every load's run as its replay and plays a replay back (§7.6; `ENGINE.3`'s second slice, *noted 2026-10-10*); issues the Write sheet's rows before the inputs and prints a refused one (§3.9); reads the Camera and views the window where it points (§3.8); at rate 0 steps once for each edit (§5); blits the plane through the Palette, crisp (`ENGINE.2`), or draws the record through the viewport (`KERNEL.5`); drives the four voices (`ENGINE.4`; *noted 2026-10-10*: on the audio clock, an oscillator and a gain a voice, after a person's Sound on, §3.6); writes the save (`ENGINE.5`); prints the step's progress as a sentence and every refusal's words; and never calls `fetch`, which `check_web_offline.ps1`'s twin forbids in the template as Frazaro's does (`SD-13`). It owns the state no program sees, the pointer's last place, the accumulator, the audio context, `SD-23`'s list; everything else is a cell.

### 8.4 Adding a device, or an optimization

A contributor adds a device by writing its sheet into §3, its direction, and its row in §8.3; then its code in the shim and, where the engine checks a layout, in the engine; then a cartridge that uses it under `cartridges/` with a replay golden. A contributor makes the engine faster by making a step cheaper in `vla-lang` (vectorization, memoization, dirty regions: `ENGINE.6`, `KERNEL.20`) or the blit cheaper in the shim, and proves it by the frames being equal to the reference's and the floor rising (`CONTRIBUTING.md`); nothing on this page changes for either, which is the point of writing the page first.

## 9. Reflection, sanctified

The owner's rule of 2026-10-08, adopted the same day as the charter's sixth rule (`CHARTER.md` §4) and the register's `AD-6` (`ROADMAP.md`): **`AD-6`. Everything the engine holds is a cell of a named sheet, viewable through the one view call and, except the twins and the plane, writable through the one write call; a device is a sheet's layout on this page, and no device holds state that is not a cell.** What it buys: a player opens the Keys sheet and rebinds a button; a modder opens the Palette and recolours a game; an auditor opens `Screen.last` and sees the previous frame; a teacher opens the Clock and slows the rate to one frame a second to watch a rule think; a tester opens the Input sheet and writes a press by hand; a game's difficulty is a cell anyone can read, which is `CART.4`'s claim against the cabinet; and every one of those acts is a row in the one notation, logged by the replay, printed by the door. The engine keeps nothing a program cannot see except the progress of a yielded step, which it reports, and the host keeps nothing but `SD-23`'s interface state. This is the Lisp machine's property kept where it was cheap, in the data, and Emacs's property that the running system is inspectable and changeable from inside, in its own language (`CHARTER.md` §5): the owner's phrase for the target, 2026-10-08, is Emacs and Excel at once, and the table reads it literally (*recommendation*):

| Emacs | Alonzo |
|---|---|
| the buffer | the grid, its sheets |
| a variable, `describe-variable` | a cell, `view` |
| `setq`, `M-:` | `write`, a value or a formula, live, on a person's act; the program itself writes values alone (`AD-7`) |
| a hook that sets a variable | the Write sheet (§3.9) |
| the keymap, `global-set-key` | the Keys sheet |
| a keyboard macro, `kmacro` | the replay, the Input log |
| the init file; the dumped image | the cartridge; a save, which is a cartridge |
| `defmacro`, `macroexpand` | a template macro in a cartridge's source, and the pass that writes its rows (§7.8) |
| `describe-mode`, `apropos` | `describe`, and `view` of any sheet, the twins included |
| the redisplay, with rented glyphs | the plane and the viewport, with the rented draw call |

**`AD-7`**, proposed by version 2 (decision 22) and adopted by the owner 2026-10-08 at its approval, the charter amended first as `ROADMAP.md`'s register requires (`CHARTER.md` §4, rule 7): **the step computes values and never formulas; a formula enters the grid by `load` or by a `write` made on a person's act, and the engine's own effects write values.** What it keeps is eval by a person, the REPL, which the table's `M-:` row celebrates; what it refuses is eval by the program, a formula computed at run time and installed, which the owner's veto of `GENSYM` already carries by its own words (§3.9) and which would make every static property of this page, the cycle check at load, the vectorized shape, the clock calculus and the linear-region pass of `docs/ALGEBRA.md` §6, a per-frame property. Held by a test and not a sentence: the formula cells before and after a step are equal (§13). The sacrifice is smaller than it looks: what the Lisp machine had was a REPL, macros and `eval` from running code; the first two stay, at the viewport and at build time, and the third goes, the one least used even there (`docs/ALGEBRA.md`, the sitting of the veto's reach in `REARVIEW.md`).

What reflection does not reach, by name: the host's own state (§8.3) and the module's heap, which are not cells and are not meant to be.

## 10. The limits, stated

A finished console states its limits rather than letting them be discovered (`CHARTER.md` §5, PICO-8's lesson). This version's, each a stated number and not a measured one, raised only by a new version of this page:

| limit | value | why this number |
|---|---|---|
| Screen window, plane mode | at most 320 by 200 cells drawn a frame; any smaller size allowed; the sheet any extent within the model's when a Camera sheet places the window | `CHARTER.md` §3's budget, two million evaluations a second at 30 frames, read as the draw's limit (decision 24) |
| Screen window, grid mode | at most 80 by 50 cells drawn a frame; the sheet any extent, as above | under the 4,641 cells with text that held 60 Hz on canvas in `KERNEL.3`'s run (*measurement*, `BETA_ROADMAP.md`, `KERNEL.5`) |
| formula cells a frame | unlimited; `describe` prints the cartridge's formula cells times its rate beside the charter's two million a second (§4.6) | the compute line is a budget and never a refusal: a cartridge over it runs slowly in plain sight (`SD-34`), and a solver cartridge at a rate of 600 is honest rather than refused (decision 24) |
| Palette | 16 rows | the consoles' number; the byte allows 255 |
| rate | 0, or 1 to 120 frames a second | a display's range; 0 is the spreadsheet's, a step an edit (§5) |
| voices | 4 | the NES's and PICO-8's count |
| players | 4 | TIC-80's pads |
| handles live at once | 16 | a page's need, with room |
| a sheet's name | 26 characters, so its twin fits 31 | Excel's rule |
| a cartridge file | 16 MiB | a 32-bit memory's comfort; a 64,000-cell Screen as rows is about 3 MB |
| cells per sheet | Excel's, 1,048,576 rows by 16,384 columns | the model's own constants (*shelf*) |
| cells a grid holds | 1,048,576 beside its twins, refused `grid-too-many-cells` | sixteen Screens of 320 by 200, so that one range row cannot ask for the seventeen billion of Excel's sheet (*added 2026-10-09*, `ENGINE.1`'s second slice, the language's `CELLS`, `KERNEL.22`) |
| cells a plane window holds | 1,048,576, refused `view-window-too-large` | the same number, a view of a window larger than a grid can hold (*added 2026-10-09*, as above) |
| includes nested in a source | 16 | the reference's own cap, refused `vla-include-too-deep` (§7.8; *added 2026-10-10*, version 3) |
| a macro's applications in one chain | 5,000 | the language's expander, refused `vla-macro-self-expansion-limit`, so that a macro walks dozens of items in one call and never thousands (§7.8) |

## 11. The decisions, the owner's

Each with the draft's recommendation, which the sections above assume, and the alternative it declined. The first five are the roadmap's; the rest the drafting found. *All seventeen approved by the owner on 2026-10-08, and `AD-6` adopted; the alternatives stay recorded so that a later reader knows what was weighed.*

1. **Zero imports; the host pulls.** The engine exports and never imports; every device is a read or a write through the exports; the allowlist's count stays zero; the charter's §2 and `AD-5` get the two amendments §8.2 words. *Alternative:* `alonzo.blit` and `alonzo.note` as imports, the charter's first picture. Recommended: zero imports.
2. **The previous frame is a sheet, `X.last`.** Read-only, filled at the end of every step, listed hidden, viewable. *Alternative:* a function, `LAST(ref)`, in the evaluator. Recommended: the sheet, for the reasons of §2.
3. **An explicit handle.** From `load`, taken by every call, never reused. *Alternative:* one implicit grid per module instance, a second cartridge needing a second instance. Recommended: the handle.
4. **The palette: sixteen entries in a Palette sheet.** The index a byte, so the count can grow by a version of this page. *Alternative:* a free RGB value per Screen cell, three bytes a cell, no palette, arithmetic on colours awkward and the record noisy. Recommended: the Palette sheet.
5. **The Input sheet's cells:** ten buttons for four players, the pointer in Screen cells with three buttons and the wheel, the last key as `key` and `code`. *Alternative:* PICO-8's six buttons, or a full key matrix now. Recommended: the eighteen rows of §3.3.
6. **The Clock holds three cells,** frame, rate and seed, and nothing from the wall clock. *Alternative:* the frame number alone, the seed elsewhere; or an elapsed-seconds cell the engine computes. Recommended: the three.
7. **Volatile functions are refused at load,** `NOW`, `TODAY`, `RAND`, `RANDBETWEEN`, naming the Clock. *Alternative:* `RAND` served from the seed by the engine, which hides the dice. Recommended: refuse.
8. **The resolution: at most 320 by 200,** any smaller size declared by the manifest. *Alternative:* exactly 320 by 200. Recommended: the maximum, so a 128 by 128 cartridge is honest about its size.
9. **The Keys sheet,** the key map as data the host reads. *Alternative:* the map in the shim, fixed. Recommended: the sheet, for §9's reasons.
10. **Grid mode is a cartridge mode,** `(screen grid w h)`, drawn by the viewport. *Alternative:* plane only, text games deferred. Recommended: both modes, since the viewport exists for the first game anyway and the cell is the unit in both.
11. **One file, manifest then rows, with `(cell|formula "<sheet>" "<range>" ...)` fills.** *Alternative:* a folder with a manifest naming files, as a distro is. Recommended: one file for the engine, the folder as a source layout a later tool flattens.
12. **Every manifest directive required,** no defaults. *Alternative:* `rate` 30 and `seed` 1 when absent. Recommended: required.
13. **The error colour is magenta and fixed,** byte 255 and any byte past the palette. *Alternative:* draw them as colour 0. Recommended: magenta, so an error is seen.
14. **A `value` row joins the view record** after each formula row once values exist, `KERNEL.7`'s amendment to oracle 11, named here. *Alternative:* the record shows formulas as text only and values are read through the plane alone. Recommended: the row, so the record remains the oracle of the plane.
15. **`AD-6`, reflection,** as §9 words it. *Alternative:* leave it as a habit. Recommended: bless it, since every later device will be designed against it.
16. **The audio voice is wave, note and volume,** the graph's own words and a MIDI number. *Alternative:* frequency in hertz. Recommended: the note.
17. **The page's licence stays CC-BY-4.0** under the map's `*.md` rule, so a port may quote it with attribution. *Alternative:* a code licence for the specification. Recommended: as the map has it.

*Version 2's decisions, 2026-10-08 (`SPEC.2`), argued in `docs/ALGEBRA.md` §2 and §3; all seven approved by the owner the same evening, and `AD-7` adopted, which amended the charter the same hour; the sections assume them, and the alternatives stay recorded.*

18. **The grid writes the grid, in values: the Write sheet** (§3.9). A table of `sheet`, `address` and `value` the host carries into the next frame as `cell` writes, refused by name into a formula cell, a twin or a host-written cell, applied before the frame's own writes, never logged by the replay. *Alternatives:* keep-last formulas alone, version 1's only state, a frame axiom per cell re-evaluated every frame; or formula rows beside the value rows, the program writing code, declined under the `GENSYM` veto's `eval` clause the same hour it was drafted. Recommended: values only.
19. **One model, two renderers** (§1, §3.1, §7.3). A sheet holds values; its look is a declared map from a value to a style, the Palette for the plane and a `look` row for the grid, with a `row` row as the `column` row's twin, both asked of oracle 11; version 1's "fills that change per frame" is withdrawn from §12, `SD-32` kept whole since the map is declared and only the value changes. *Alternative:* two modes, the fills of grid mode fixed, and a stacking game's score unable to share a sheet with its blocks. Recommended: one model.
20. **Rate zero** (§5, §3.5, §3.3). `(rate 0)` steps on every edit, the frame number counts edits, the Input sheet is not written, derived writes trigger no step. *Alternative:* the spreadsheet as a special case the host handles outside the manifest, which would make the first game the one cartridge the loop does not describe. Recommended: rate zero.
21. **The Camera sheet** (§3.8). Two cells the host reads after a step and passes as the view call's window; the Screen's declared size becomes the window's, the sheet any extent. *Alternative:* an offset every Screen formula reads through `INDEX`, the window's every cell a lookup a frame, the whole budget on scrolling (*derived*, `docs/ALGEBRA.md` §3). Recommended: the sheet.
22. **`AD-7`, held by a test** (§2, §6 rule 8, §9). The step computes values and never formulas; the formula cells before and after a step are equal, a `vla-lang` test on every fixture. *Alternative:* the veto cited in prose, with nothing on the artifact to hold it. Recommended: the test, and the owner's amendment of the charter first.
23. **One write per cell** (§7.3, §4.2). A cell the cartridge's rows write twice is refused at load with both lines named. *Alternative:* last wins, silently, as a sheet would otherwise do, and the prelude's loud-collision doctrine silent in cells. Recommended: refuse.
24. **The limits restated** (§10, §4.6). The Screen's limits are the draw's, over the window; the compute line is a budget `describe` prints as rate times formula cells beside the charter's two million a second, never a refusal. *Alternative:* a refusal at load above the line, which would refuse an honest solver cartridge at a rate of 600 that runs slowly in plain sight under `SD-34`. Recommended: the budget printed.

*Version 3's decisions, 2026-10-10 (`SPEC.3`), measured in its scoping and argued there in full (`REARVIEW.md`); all eleven approved by the owner the same day, with the owner's guiding principle for the pass (§7.8); the sections assume them, and the alternatives stay recorded.*

25. **The pass is an act of its own between the source and the load** (§7.8). Its output, the cartridge, is the artifact a person reads, saves and diffs, and where it runs is not what it is. *Alternatives:* expansion inside the load, the artifact lost and load no longer the inverse of view; or a build tool alone, so that the page could not build what it loads. Recommended: the act.
26. **One pass, two doors** (§7.8, §4.6). A pure function of the engine's crate over the language's expander, run at the command line by an example and in the page by a twelfth export, the same bytes in both (measured: +51,084 bytes of module, no import). *Alternatives:* Frazaro's door, against the owner's condition that Frazaro own nothing a game needs; the general half in `vla-lang` now; the command line alone; a second module. Recommended: the two doors, the command line first.
27. **The source, the include and the library** (§7.8). The reference's include, resolved against the source's folder and handed in by each door; template macros the author's; the repository's library `cartridges/console.vla` (*renamed 2026-10-10*, at the owner's word, `cartridges/common.vla`, when it took `on`, `cells` and `formulas`, macros of no one device). *Alternatives:* libraries named to the door, the source silent about what it reads; the include in `vla-lang`, which reads no file anyway. Recommended: the include in the source.
28. **The layout and the golden** (§7.8). `<name>.source.vla` beside `<name>.vla`, both committed; the cartridge the pass's output byte for byte, with a banner and no digest; held by `cargo test` and statically by `tools/check_cartridge.ps1`. *Alternatives:* the source alone, the cartridge a build artifact; a digest of the source in the banner. Recommended: both files, the golden in the tests.
29. **No data form the loader takes; every convenience a macro** (§7.3, §12). The named palette and the table are macros; the picture waits, its three routes named. *Alternatives:* the palette as a manifest directive the engine expands; the picture now. Recommended: macros, the loader the inverse of view.
30. **The fixtures rebuilt with their rows unchanged** (§7.8). Their digests carried by `tools/check_frame_floors.ps1`'s `$sameRows`, as `$sameSource` carries the registry pin, since the measured rows load the measured grid. *Alternatives:* the owner's run again; the fixtures left hand-written; a digest over the forms. Recommended: rebuilt, carried.
31. **A source handed to the load is refused by name**, `cart-source-unexpanded` (§4.2, §4.7). *Alternative:* the language's `grid-row-unknown`, naming a form and not the act missed. Recommended: the refusal.
32. **`(spec 3)` read, with nothing new to read** (§7.2). Version 3 adds no row and no directive; the fixtures keep `(spec 2)`. *Alternatives:* the engine unchanged, refusing the page's own number; the fixtures moved, a row changed. Recommended: read 1 to 3.
33. **What the horizon needs, and no more** (§12). The pass named as an act with an artifact; the source neutral to its target; a cartridge carrying data and never code; the module and its reaches named; the emitter unminted. *Alternatives:* the emitter minted now; a `(module ...)` directive reserved. Recommended: named, not built.
34. **The charter amended first**: rule 7's expander the language's, rule 1's VLA road, §8's clause on the pass, the frame paragraph's third version. *Alternative:* the page alone changed. Recommended: amended first.
35. **Two slices**: the page, the pass and the command line; then the pass in the page, with the loop oracle's case. *Alternatives:* one slice; the page's door left to `ENGINE.5`. Recommended: two slices.

## 12. Not in this version, by name

A noise voice, envelopes and samples (Varvara has them; the Web Audio graph has no noise node, so noise would be a buffer the host makes, a small synthesizer, and rule 3 waits for a game to want it). A full key matrix. The gamepad. Threads and SIMD, devices after a measurement. R1C1 as an input notation. A second Screen, layers, a hardware scroll and a sprite port, each being cells. A save slot beyond one file. Networking, ever (`SD-13`). An interpreter for a cartridge's procedures: a cartridge's logic is its formulas, since the evaluator over the grid (`KERNEL.7`) is what `vla-lang` has first and the interpreter (`PORT.10`) comes later; a `(sub ...)` in a cartridge is carried and not run. The composite as a projection, a Sprites sheet of ranges at positions drawn in order with blank transparent, which `docs/ALGEBRA.md` §3 names as the answer to the gather cost, and with it a transparent blank; until it lands the plane reads a blank cell as 0 (§3.1), so that half a change is not made. A formula written by the program, ever (§3.9, §9, `AD-7`).

**The pass's next steps, named 2026-10-10** (version 3; decisions 29 and 33). Version 3 builds the pass over the language's expander as it stands, and the owner's principle (§7.8) asks for more than the expander gives. Each step below is named here so that the item that takes it starts from a measurement and not a wish (*engineering* throughout, the last *recommendation*).
- *The expand-time object model.* An address from a row and a column number and back; a column's letters from its number; a text split into its characters; and arithmetic past addition. With it, a macro reaches the column and the sheet as it reaches the row, and the generality the principle asks for is the language's. It is a change to `vla-lang`, so a Frazaro item, the VBA reference first (`SD-18`).
- *The picture.* A string a sheet row and a character a cell, the plane's inverse for input. Three routes, each a later version's, decided by the first cartridge that wants one:
  - a row the loader takes, which would make the loader more than the inverse of view;
  - a built-in of the pass, which would make the pass a dialect;
  - or a macro over the object model above, which version 3 recommends.
  Until then a pattern is `live`, one call a row of it.
- *The formula dialect.* An expression such as `(- note 12)` written as the formula `=note-12`. It is `frazaro-core`'s emitter today and the language's in time; a template macro writes a flat one and not a nested one (§7.8).
- *Modules, the owner's end goal.* VLA macros expanding into WebAssembly's text, which is s-expressions too, so that VLA becomes a gateway to ever more abstract modules the browser compiles. It is one more target of the same act:
  - the same source, includes and template macros;
  - an encoder, the charter's third backend and the language's, unminted;
  - an assembler from the text to the bytes, a pure function that compiles to wasm as the pass does, its bytes returned through the module's memory for the host to compile, since a browser compiles the binary format and never the text;
  - the text beside the bytes as the artifact a person reads, as the cartridge stands beside its source.

  A cartridge carries data and never code in version 3. One that carries a module reaches six things by name, which the version that takes it decides:
  - `AD-5`, a second module's imports, and how a step reaches a function its own module does not hold with an empty import section;
  - `AD-6`, a module's memory being state that is no cell;
  - `AD-7`, code entering by the load as a formula does, and never by a step;
  - §6 and the replay, a module importing nothing being deterministic but for a NaN's payload bits, and the replay naming its digest;
  - `SD-13`, the module instantiated with an empty import object;
  - and where the assembler runs.

**The score, the patch and the port, named 2026-10-08.** The owner's note at the approval, for a cartridge to be called *Fragments*, a generative ambient piece in the shape of State Azure's modular performance (`CART.5`; *exhibit*, §14), with the question whether a modular synthesizer's generative nature can be had as wave functions in VLA forms. It can, with one line drawn, and nothing in the answer is fiction (*engineering* throughout). A score is a sheet, instruments as rows and time as columns, and the Audio sheet's cells are formulas that read the column under the playhead, `INDEX(Score!B2:ZZ5, voice, beat)`, which waits on `KERNEL.8`'s lookups as sprites do; until then a sequence is `CHOOSE` over `MOD(Clock!B1, period)`. A piano roll is the same sheet drawn on the Screen by formulas, the playhead a lit column, the visualizer being the game. The generative part of a modular synthesizer is its control signals, and at the frame rate every one of them is a formula of the last frame: a low-frequency oscillator is `SIN` of the frame over its period; a sample-and-hold is `IF(MOD(Clock!B1, n)=0, dice, State.last!B5)`, the dice being §3.5's Park and Miller cell; a clock divider is `MOD(Clock!B1, n)=0`; an envelope is a piecewise formula of the frames since its trigger; a quantizer is arithmetic over a row that holds a scale; a sequencer is `INDEX`; and a patch is which cell reads which, the dependency graph itself. In VLA they are template macros, `(lfo ...)`, `(sample-hold ...)`, `(envelope ...)`, `(quantize ...)`, that the pass expands into formula rows (§7.8; *corrected 2026-10-10*, version 3, where version 2 had Frazaro expand them), as the prelude's macros expand with no gensym and every binding named (*shelf*: `scripts/prelude.vla`), so that a module is a macro, a patch is a sheet, a control voltage is a cell, a knob is a cell a person turns in the viewport, and the replay of §7.6 makes the control log golden, note for note and frame for frame, as a MIDI file is a log of the same kind. The line is the frame rate: a control signal that moves over seconds, which is what State Azure's patches move, is sampled thirty times a second and lives in cells; the waveform itself, forty-four thousand samples a second, and any modulation at that rate live in the Web Audio graph, which is a modular synthesizer by construction, nodes patched by connections, every parameter an input that automation or another node's signal can drive (*exhibit*: the AudioNode graph and `AudioParam`, §14), rented under rule 3 as the glyphs are. Two later versions of this page follow: **the patch as a sheet**, rows of modules, an oscillator, a filter, a delay, a gain, with their parameters, and a relation of connections in the treaty's row shape that the host builds the graph from at load, the Audio sheet's columns then being the control voltages into it, which is why §3.6's table is shaped to grow to the right; and **a MIDI port** as a device, in and out, through the Web MIDI API where the browser has it (*exhibit*, §14), a local device and not the network under `SD-13`, so that a keyboard plays into the Input sheet and a score plays out of the engine to a MIDI-to-CV module and a rack of real modules. The sound stays measured and never golden (`AD-4`); the score, the patch and the control log are cells, which is why they can be golden, and why a Lisp-oriented modular synthesizer is a cartridge and not a device.

## 13. The oracle, and what this page hands to each item

**The oracle of this page** (`ROADMAP.md`, `SPEC.1`): `vla-lang`'s tests for the four calls are written from §4 and nothing else, and `ENGINE.2`'s equality test is written from §3.1 and §4.5: the plane of a window equals the record of the same window, byte for value, 0 for an absent cell and 255 for a value that is not a colour. Two more oracles this page makes free: **load is the inverse of view**, a sheet viewed whole and loaded again views the same, row for row; and **a save resumes**, a save loaded and stepped once equals the original stepped once more, cell for cell. Both are `vla-lang`'s tests to write when the cut lands, and both are the shape of Frazaro's free oracle, one model seen three ways (*shelf*: oracle 11). Version 2 adds five, each a `vla-lang` test or the shim's: **a step writes no formula**, the formula cells of every fixture equal before and after a step (`AD-7`); **one write per cell**, a fixture with a cell written twice refused at load naming both lines; **a derived write lands or is refused**, the Write sheet's rows applied between steps and a row into a formula cell refused by name with the frame continuing, the same way on every replay; **the window follows the Camera**, the plane of the window at the Camera's cells equal to the record's window there; and **rate zero steps on an edit**, the frame number after `n` edits being `n` and the Input sheet untouched. Version 3 adds four.
- **A cartridge is its source expanded**: every cartridge with a source is byte for byte the pass's expansion of it, LF over LF, held by `cargo test` over the folder (`engine/src/pass.rs`).
- **The pass is one function wherever it runs**: the page's `alonzo_expand` answers every embedded source with the command line's bytes, held by the loop oracle's `pass` case.
- **A source is refused by the load**, `cart-source-unexpanded`, before its manifest, held by the engine's tests and `tools/check_cartridge.ps1`.
- **Every version 2 cartridge loads under version 3 unchanged**, the fixtures' rows the measured rows, held by `tools/check_frame_floors.ps1`'s runner half, every frame and every allocation as measured.

**To the `vla-lang` cut** (Frazaro's work, before `KERNEL.7`; *shelf*: the Frazaro memory, `vla-crate-before-kernel7`): the row loader, the inverse of `print.rs`, with the range fills; the four calls with the records of §4; the twins and the step of §2, a snapshot at the end of each step; the budget in cells and the yield; the plane as the second projection; the `value` row; the cycle refused at load and at a write, naming the cells; the volatile functions refused; the twice-written refusal; the `look` and `row` rows in the record, oracle 11's amendment; the Write sheet's rows as ordinary `cell` writes with the derived refusal; `describe`'s budget row. **To `KERNEL.7`**: smart recalculation designed in and switched on by a measurement, a cell dirty only when an input changed and a twin edge changed only when its cell changed at the last step (`docs/ALGEBRA.md` §3, correction 1; `ENGINE.6`), so that the keep-last idiom and the Write sheet both cost what they change; and the functions a cartridge rule needs on day one, beyond whatever the measured fifteen hold: `IF`, `AND`, `OR`, `NOT`, `SUM`, `MIN`, `MAX`, `ABS`, `INT`, `MOD`, `ROW`, `COLUMN`, the comparisons and the arithmetic; `ROW` and `COLUMN` because a cell painting at the mouse must know where it is, and `MOD` because every counter wraps; for a score, `CHOOSE` until `INDEX` comes, and `SIN` for a slow oscillator; `INDEX` for sprites and for a score's playhead waits on `KERNEL.8`. **To `REPO.2`**: nothing; the list stays empty and the count zero, and the module name `alonzo` stands for the day a device needs an import. **To `ENGINE.1`**: §5 and §8, the derived writes and rate zero. **To `ENGINE.2`**: §3.1, §4.5, the Camera's window and the equality test. **To `ENGINE.3`**: §3.3, §3.4, §3.5, and no Input at rate 0. **To `ENGINE.4`**: §3.6 (*noted 2026-10-10*, `ENGINE.4`'s first slice: the oracle of the schedule is the loop oracle's fourteenth case, `audio`, a double of the Web Audio graph handed to the host as its audio context, every call recorded with its time on a clock the oracle drives and held frame by frame to the page's own arithmetic of §3.6, over the double and over the sound card, `cartridges/soundcard/`; the sound itself is measured and never golden, §6. *Noted 2026-10-10*, `ENGINE.4`'s second slice: the measure is the loop oracle's fifteenth case, `sound`, the host's own voices handed an `OfflineAudioContext` and rendered over a sequence of voice states, each frame read between its own times against the graph's own waves rendered beside it: a settled frame's pitch within 0.1% of its note's and its rms within 4% of the volume over four times its wave's own, a rest below 0.0001, no onset step over 1.5 times the wave's own; it takes no time from the sound's constants, so that a misreading of the graph that the host and the page's arithmetic share is heard, and it is the one case that waits, its render paced by 0 ms tasks under a headless browser's virtual clock). **To `ENGINE.5`**: §3.7, §7.1, §7.5. **To `CART.1`**: §7, Appendix A's shape, a soup worth the name and a glider gun. **To `CART.4`**: the rising edge of §3.3, the replay of §7.6, the Tower as values through the Write sheet and the Camera over a tower taller than the window (Appendix B). **To the charter**: the two amendments of §8.2 and `AD-6`, made 2026-10-08 at the approval; and, at version 2's approval on 2026-10-08, `AD-7` as the seventh rule of §4 and the pointer to `docs/ALGEBRA.md` from §8, both made the same evening. **To `CART.5`**, Fragments: §12's paragraph, and the Audio table's shape, which grows to the right. **To `CART.4`** and every cartridge after it, since version 3: a source over the library, `cartridges/common.vla`, or a library of its own (§7.8). **To Frazaro**, at the owner's call: the expand-time object model and the formula dialect of §12, each a change to `vla-lang`, the VBA reference first; the pass takes each as it lands, and the encoder to WebAssembly after them. **A candidate repository item**, not minted here: a check that reads the module's export section and holds it to §8.1's eleven names exactly, the twin of the import check over section 7 of the module, so that an export added by accident fails on every push.

## 14. Sources for the outside facts

- uxn and Varvara, Hundred Rabbits: the Varvara page, the devices at fixed ports of sixteen bytes, the vectors, the Screen's two layers and `auto` byte, the Controller's NES-style button byte, the Mouse's state byte, the Audio's ADSR and samples, the File and Datetime devices. https://wiki.xxiivv.com/site/varvara.html
- TIC-80: the RAM page of its wiki, the memory map (VRAM at `0x0000`, 240 by 136 at four bits; the palette at `0x3FC0`, sixteen colours of three bytes; gamepads at `0xFF80`, mouse at `0xFF84`, keyboard at `0xFF88`; four sound channels), 60 frames a second, the `TIC` callback; its default keys for A, B, X, Y. https://github.com/nesbox/TIC-80/wiki/RAM
- PICO-8, Lexaloffle: the manual, `_update` at 30 and `_update60` at 60, `btn` and `btnp` (repeats every 4 frames after 15), `pal` and the draw and screen palettes, `camera()` as the draw offset applied once and not per pixel, `rnd` and `srand`, the `.p8` and `.p8.png` cartridge formats, 128 by 128 and sixteen colours. https://www.lexaloffle.com/dl/docs/pico-8_manual.html
- Fiedler, G., "Fix Your Timestep!", 2004-06-10: the accumulator, the fixed `dt`, the cap of 0.25 s on the frame time against the spiral of death, interpolation by `alpha`. https://gafferongames.com/post/fix_your_timestep/
- MDN, `WebAssembly.Memory.prototype.grow()`: every call detaches the previous `buffer`, even `grow(0)`; views must be made fresh. https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/JavaScript_interface/Memory/grow
- Wilson, C., "A Tale of Two Clocks: Scheduling Web Audio with Precision", web.dev: `AudioContext.currentTime`, the lookahead scheduler. https://web.dev/articles/audio-scheduling
- MDN, `AudioParam.setTargetAtTime()` (an exponential approach to a value from the parameter's value at the start time, by a time constant), `AudioParam.cancelScheduledValues()`, and `OscillatorNode.type`, an enumerated attribute where the frequency is an `AudioParam`; and Chrome's autoplay policy, under which an `AudioContext` made before a person's gesture starts suspended and is resumed by one (`ENGINE.4`, 2026-10-10). https://developer.mozilla.org/en-US/docs/Web/API/AudioParam/setTargetAtTime https://developer.mozilla.org/en-US/docs/Web/API/OscillatorNode/type https://developer.chrome.com/blog/autoplay
- MDN, `KeyboardEvent.code` (the physical key, unchanged by layout; the WASD example) and `KeyboardEvent.key` (the character under the layout). https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/code
- MDN, the Page Visibility API (`document.hidden`, `visibilitychange`; animation frames stop in a hidden tab) and `window.requestAnimationFrame` (the `DOMHighResTimeStamp` argument). https://developer.mozilla.org/en-US/docs/Web/API/Page_Visibility_API https://developer.mozilla.org/en-US/docs/Web/API/Window/requestAnimationFrame
- MDN, `CanvasRenderingContext2D.imageSmoothingEnabled` and `putImageData`. https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/imageSmoothingEnabled
- The Doom Wiki, "Demo": a demo is the sequence of each tic's input commands, four bytes a tic, replayed by the same version of the game; a different version makes the player's actions nonsensical. https://doomwiki.org/wiki/Demo
- Park, S. K. and Miller, K. W., "Random number generators: good ones are hard to find", *Communications of the ACM* 31(10), October 1988, 1192-1201: the minimal standard, `a = 16807`, `m = 2^31 - 1`.
- WebAssembly: the design's nondeterminism note (floating-point operations deterministic but for NaN payload bits) and the core specification's "Embedding" and "Modules" sections (a module reaches the host only through its imports). https://webassembly.org/docs/nondeterminism/ https://webassembly.github.io/spec/core/
- Wikipedia, "Color Graphics Adapter" (the sixteen-colour RGBI palette and its values) and "Enhanced Graphics Adapter" (320 by 200 in sixteen colours, mode 0Dh; 80 by 25 text). https://en.wikipedia.org/wiki/Color_Graphics_Adapter https://en.wikipedia.org/wiki/Enhanced_Graphics_Adapter
- Microsoft, "Change formula recalculation, iteration, or precision in Excel": iterative calculation over circular references, 100 iterations or a change under 0.001 by default; a circular reference may converge, diverge or alternate. https://support.microsoft.com/en-us/office/change-formula-recalculation-iteration-or-precision-in-excel-73fc7dac-91cf-4d36-86e8-67124f6bcce4
- Microsoft, Excel's sheet-name rules: 31 characters; `\ / ? * [ ] :` forbidden; a name quoted in a formula when it holds a space or a character outside letters, digits, `_` and `.`, confirmed by the owner's pass of 2026-10-04 (`core/src/refers.rs`).
- ICAEW, *Twenty principles for good spreadsheet practice* (2014; later editions): principle 10, "Separate and clearly identify inputs, workings and outputs." https://www.icaew.com/technical/technology/excel-community/20-principles-for-good-spreadsheet-practice-2024-edition
- The WebAssembly Component Model, the canonical ABI: a resource handle is an `i32` index into a per-instance table. https://github.com/WebAssembly/component-model/blob/main/design/mvp/CanonicalABI.md
- Sestoft, P., *Spreadsheet Implementation Technology*, MIT Press, 2014 (topological recalculation), as `CHARTER.md` §10 cites it.
- MDN, the Web Audio API: the `AudioNode` graph, `AudioParam` automation and audio-rate connections; and the Web MIDI API, in Chromium, and in Firefox since 108 behind a site permission, not in Safari. https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API https://developer.mozilla.org/en-US/docs/Web/API/Web_MIDI_API
- State Azure, a generative ambient performance on a modular synthesizer, the owner's reference for *Fragments*, named 2026-10-08; the artist's patch notes for the track, as the owner pasted them on 2026-10-08, are what Appendix C.5 quotes and codifies. https://www.youtube.com/watch?v=8V71sATDTqs
- Lorenz, E. N., "Deterministic Nonperiodic Flow", *Journal of the Atmospheric Sciences* 20(2), 1963, 130-141: a weather model of three variables, deterministic and never repeating.
- Csound (Vercoe, B., MIT Media Lab, 1986): the orchestra file, which defines the instruments, apart from the score file, which plays them. https://csound.com/
- VCV Rack, whose patches are `.vcv` files, and Pure Data, whose patches are `.pd` text files, both traded between people; VCV Rack's library, where makers publish their own modules' ports (Mutable Instruments' open-source firmware as Audible Instruments, Vult, Instruō, Nonlinearcircuits); the Standard MIDI File (MIDI Manufacturers Association, 1988), the log a generative patch leaves. https://vcvrack.com/ https://library.vcvrack.com/ https://puredata.info/
- The reference's include, `VLA.bas`, P.L7, `SpliceIncludes`, `IsIncludeLine` and `ReadIncludeFile`: a line standing alone, raw text before the tokenizer, a relative name resolved against the workbook's folder, nesting capped at 16. And `frazaro-core`'s `core/src/emit/mod.rs`: "the core cannot read the file, so it refuses by name where the VBA would splice; a door that reads files splices first". `vla-lang` 0.8.1's `src/expand.rs`: the expander the pass runs, its seventeen primitives, its trampoline and its limit of 5,000 applications in a chain.
- In the Frazaro repository: `core/src/abi.rs`, `core/src/view.rs`, `core/src/kernel.rs`, `core/src/sheet/mod.rs`, `core/src/distro.rs`, `core/src/refers.rs`, `core/src/reflect/print.rs`, `web/index.template.html`, `web/CALLOSUM.md` §7, `conformance/README.md` (oracle 11), `docs/BETA_ROADMAP.md` (`KERNEL.5`, `KERNEL.7`, `KERNEL.8`, `KERNEL.12`, `KERNEL.20`, the `SD` register), `docs/HORIZON.md` §12.2, `docs/BETA_ROADMAP.md`'s `GENSYM` entry (the veto's words, `eval` carried), `scripts/prelude.vla` (the anti-gensym doctrine), `vla-lang/src/expand.rs` (the seventeen expand-time primitives). In this repository: `CHARTER.md` §2 to §8, `ROADMAP.md`, `REARVIEW.md` (`REPO.2`'s decisions 1 and 5, `CART.4`, the evening sittings of 2026-10-08), `docs/ALGEBRA.md` §2 to §4.
- McCarthy, J. and Hayes, P. J., "Some Philosophical Problems from the Standpoint of Artificial Intelligence", *Machine Intelligence* 4, 1969: the frame problem named, the axioms that say what an action leaves unchanged.
- Caspi, P., Pilaud, D., Halbwachs, N. and Plaice, J., "LUSTRE: A declarative language for programming synchronous systems", POPL 1987: `pre`, `->`, the causality check, the synchronous hypothesis.
- The Elm Architecture: Czaplicki, E., the Elm guide, a pure update returning a model and a command the runtime performs. https://guide.elm-lang.org/architecture/
- Nintendo's Famicom of 1983 and its picture processor: background tiles and sprites as separate layers (Wikipedia, "Picture Processing Unit").

---

## Appendix A. Life, the shape of a cartridge

The shape and not the fixture: `CART.1` picks its soup and its gun, and this is what a cartridge looks like in the notation above, twenty lines for a 64,000-cell game. The rule lives in the interior, `B2:LG199`, and the border stays empty, which the plane reads as 0, dead; a cell is 1 when alive, and the cartridge's palette makes 1 white. The first frame seeds a soup from the seed by a formula, so the dice is in the open; every later frame is Conway's rule over the previous frame, `Screen.last`, with every reference relative, so the one row is one shape over 62,964 cells.

```text
; SPDX-License-Identifier: 0BSD
(cartridge "life"
  (spec 2)
  (title "Life")
  (rate 30)
  (screen plane 320 200)
  (seed 1)
  (licence "0BSD"))
(cell "Palette" "A1" 0)
(cell "Palette" "A2" 1)
(cell "Palette" "B1" "#000000")
(cell "Palette" "B2" "#FFFFFF")
(cell "Palette" "C1" "dead")
(cell "Palette" "C2" "alive")
(formula "Screen" "B2:LG199" "=IF(Clock!$B$1=1,IF(MOD(Clock!$B$3+ROW()*7919+COLUMN()*104729,7)<3,1,0),IF(OR(SUM(Screen.last!A1:C3)-Screen.last!B2=3,AND(Screen.last!B2=1,SUM(Screen.last!A1:C3)-Screen.last!B2=2)),1,0))")
```

(The Palette's column A must hold 0 to 15 in order, so a real cartridge holds the sixteen rows one each, since a range fill and a row over one of its cells would write that cell twice, which §7.3 refuses; the two shown are the shape. Since version 3 its source writes them as one call, `(palette ...)`, sixteen entries one a line, which the pass expands into the forty-eight rows (§7.8): `cartridges/life/life.source.vla` is Life's, and `cartridges/life/life.vla` the cartridge it writes. The soup's hash is a toy, chosen to be exact in doubles, and a soup worth the name is `CART.1`'s.)

## Appendix B. Four formulas a cartridge writes

- **A button's rising edge** (`CART.4`): `=AND(Input!B5=1, Input.last!B5=0)`.
- **A counter that wraps with the clock**: `=MOD(Clock!B1, 8)`, the phase of an eight-frame cycle.
- **A position under velocity** (the falling-block game, the sand): `=State.last!B2 + State.last!B3 / Clock!B2`, the last frame's position plus the last frame's velocity over the rate, with the collision as the comparison that clamps it.
- **A tower cell frozen by a write** (the stacking game; `docs/ALGEBRA.md` §4): `Write!A2` holds `Tower`, `Write!C2` holds `1`, and `Write!B2` holds `=IF(AND(freeze, lit1), "A" & State!B2, "")`, one such row a column of the slider, so that on the frame the button freezes a lit block the host writes a 1 into the Tower as a value, and the Tower holds no formula however tall (§3.9); the Camera's row cell, `=MAX(1, State!B2 - 12)`, keeps the window on the top of it (§3.8).

## Appendix C. A Fragments patch, in VLA

*Added 2026-10-08 at the owner's word, after the approval: what `CART.5`'s patch looks like as a file a person writes, shares and modifies, in the shape §12 names. The shape, not the fixture; `CART.5`'s scoping picks the music.*

A patch is two files. The first is the one a person writes: a list of module calls, each a template macro from a module library, with every row and every name chosen by the caller, which is the prelude's own rule against hidden bindings (*shelf*: `scripts/prelude.vla`, the anti-gensym doctrine). A module call is written one argument a line, each followed by a comment that says what the argument is, so that the patch reads without the library open, as a rack's patch sheet lists each cable; a list of like things, the ten notes of a scale, stays on one line (the owner's rule, 2026-10-08). A module is a row of the `Patch` sheet, its label in column A, its output in column B and its knobs from column C, so that turning a knob is editing a cell in the viewport, live, under `AD-6`, and `save` writes the turned patch back out as a cartridge. A cable is a defined name, so a formula reads `bar` and `dice` and not `B3` and `B5`. The clock is the Clock sheet, the dice is §3.5's cell, and the previous frame is the twin.

**C.1 The patch, `fragments.source.vla`.** (*Corrected 2026-10-10*, version 3: the patch is a cartridge's source, which the pass expands into `fragments.vla` beside it (§7.8); its sheets are rows, where version 1 had the build walker's forms; and its library is a file of `cartridges/`, included by its path.)

```text
; SPDX-License-Identifier: 0BSD
; fragments.source.vla - a patch for the Audio device (SPEC.md, section 12 and Appendix C).
; A module is a macro from modular.vla; a cable is a name; a knob is a cell.
; One argument a line, each with what it is, so the patch reads without the library.
(include "../modular.vla")

(cartridge "fragments"
  (spec 3)                        ; the version of this page the patch is written to
  (title "Fragments")
  (rate 30)                       ; frames a second; every period below is in frames
  (screen plane 320 200)          ; the roll draws on the top ten rows
  (seed host)                     ; the dice: the host rolls one at load, the replay records it
  (licence "0BSD"))

(sheet "Patch" visible)           ; the Patch sheet: every module below is a row of it

(divide                           ; a pulse: 1 on the frame a cycle begins, else 0
  2                               ; the row of the Patch sheet
  "beat"                          ; the name, the cable the others read
  15)                             ; the period in frames: 120 pulses a minute

(divide                           ; the bar
  3                               ; the row
  "bar"                           ; the name
  60)                             ; the period: four beats, two seconds

(lfo                              ; a slow oscillator, 0 to 1
  4                               ; the row
  "drift"                         ; the name
  sine                            ; the shape: sine, triangle, sawtooth or square
  1800)                           ; the period in frames: a minute

(dice                             ; the random voltage: Park and Miller over Clock!B3, a roll a frame
  5                               ; the row
  "dice")                         ; the name

(hold                             ; sample and hold
  6                               ; the row
  "held"                          ; the name
  dice                            ; the source
  bar)                            ; the trigger: take the source when it is 1, else keep the last frame's

(quantize                         ; a voltage onto a scale
  7                               ; the row
  "note"                          ; the name
  held                            ; the voltage, 0 to 2147483646
  Scale!$A$1:$A$10)               ; the scale, lowest note first

(envelope                         ; attack then decay, retriggered
  8                               ; the row of the age, the frames since the trigger
  "age"                           ; its name
  9                               ; the row of the envelope, 0 to 1
  "env"                           ; its name
  beat                            ; the trigger
  2                               ; the attack, in frames
  20)                             ; the decay, in frames

(sheet "Scale" visible)           ; the Scale sheet

(scale                            ; ten notes down a column, MIDI numbers, lowest first
  "A"                             ; the column
  48 50 52 55 57 60 62 64 67 69)  ; C3 pentatonic over two octaves

(audio)                           ; the Audio sheet's header row and voice numbers

(voice                            ; the melody
  1                               ; the voice, 1 to 4
  triangle                        ; the wave, the oscillator's own word
  note                            ; the note, a MIDI number, or an expression of names
  env)                            ; the volume, 0 to 1, or an expression

(voice                            ; a drone an octave below, swelling with the drift
  2                               ; the voice
  sine                            ; the wave
  (- note 12)                     ; the note
  (* 0.3 drift))                  ; the volume

(voice                            ; a fifth above, fading as the drift rises
  3                               ; the voice
  sawtooth                        ; the wave
  (+ note 7)                      ; the note
  (* 0.2 env (- 1 drift)))        ; the volume

(roll                             ; the visualizer: the note's row lit at a playhead that sweeps and leaves a trail
  10)                             ; the rows of the Screen it uses, from the top
```

**C.2 What it expands to.** The pass expands the macros into rows (§7.8; *corrected 2026-10-10*, version 3, where version 1 had Frazaro expand them and print the sheets), and the rows are the second file, the cartridge the engine loads. Three modules, one voice and the roll, so that the shape is visible; the rest follows the same pattern:

```text
(cell "Patch" "A2" "beat")  (cell "Patch" "C2" 15)
(formula "Patch" "B2" "=IF(MOD(Clock!B1,C2)=0,1,0)")
(name "beat" "Patch!$B$2")
(cell "Patch" "A5" "dice")
(formula "Patch" "B5" "=MOD(IF(Clock!B1=1,Clock!B3,Patch.last!B5)*16807,2147483647)")
(name "dice" "Patch!$B$5")
(cell "Patch" "A6" "held")
(formula "Patch" "B6" "=IF(bar=1,dice,Patch.last!B6)")
(name "held" "Patch!$B$6")
(cell "Patch" "A7" "note")
(formula "Patch" "B7" "=INDEX(Scale!$A$1:$A$10,1+INT(held/2147483647*10))")
(name "note" "Patch!$B$7")
(cell "Patch" "A8" "age")
(formula "Patch" "B8" "=IF(beat=1,0,Patch.last!B8+1)")
(name "age" "Patch!$B$8")
(cell "Patch" "A9" "env")  (cell "Patch" "C9" 2)  (cell "Patch" "D9" 20)
(formula "Patch" "B9" "=IF(age<C9,age/C9,MAX(0,1-(age-C9)/D9))")
(name "env" "Patch!$B$9")
(cell "Audio" "B3" "sine")  (formula "Audio" "C3" "=note-12")  (formula "Audio" "D3" "=0.3*drift")
(formula "Screen" "A1:LH10" "=IF(COLUMN()=MOD(Clock!B1-1,320)+1,IF(ROW()=11-MATCH(note,Scale!$A$1:$A$10,0),15,0),Screen.last!A1)")
```

Every row above is a formula of this frame's cells and the twin, so the whole patch is one dependency graph with no cycle: `held` reads `bar` and `dice` this frame and its own last value; `env` reads `age` this frame; the roll's cells each keep their own last value except the one column under the playhead, which is how a trail is drawn with no state but cells. The dice is exact in doubles, since the seed and every later value are below 2^31 and 16807 times 2^31 is below 2^53 (*derived*; §3.5).

**C.3 The module library, `modular.vla`.** Template macros in the prelude's style, each writing its rows itself: a value into a cell, a formula's text fused from atoms by `symbol`, and the cable as a `(name ...)` row (*corrected 2026-10-10*, version 3; version 1's macros wrote the build walker's forms, `set!` and `set-formula` of a `cells` reference, for Frazaro to fold). Measured the same day, `SPEC.3`'s scoping: over the language's expander as published, these three write C.2's rows exactly, and a template macro loops by recursing over a list in tail position, so a scale takes as many notes as its caller gives. A parameter is called `label` and never `name`, since a parameter replaces its name in the `(name ...)` row's head too (§7.8):

```text
(defmacro (divide row label n)
  "a pulse: 1 on the frame a cycle of n frames begins, else 0"
  (cell "Patch" (symbol "\"A" row) label)
  (cell "Patch" (symbol "\"C" row) n)
  (formula "Patch" (symbol "\"B" row) (symbol "\"=IF(MOD(Clock!B1,C" row ")=0,1,0)"))
  (name label (symbol "\"Patch!$B$" row)))

(defmacro (hold row label source when)
  "sample and hold: take the source when the trigger is 1, else keep the last frame's value"
  (cell "Patch" (symbol "\"A" row) label)
  (formula "Patch" (symbol "\"B" row) (symbol "\"=IF(" when "=1," source ",Patch.last!B" row ")"))
  (name label (symbol "\"Patch!$B$" row)))

(defmacro (scale col & notes)
  "notes down a column, MIDI numbers, lowest first, as many as the caller gives"
  (quasiquote (scale-from (unquote col) 1 (unquote notes))))

(defmacro (scale-from col row notes)
  "the notes from a row on, a note at a time, in tail position"
  (quote-if (null? notes)
    (begin)
    (begin
      (cell "Scale" (symbol "\"" col row) (car notes))
      (scale-from col (+expand row 1) (cdr notes)))))
```

**C.4 What exists, and what waits.** The macros above expand under the language's expander as published, and the pass writes their rows (§7.8): the modules, the scale and the cables exist today (*measurement*, 2026-10-10). A `voice` form's expression arguments want the formula dialect, `(- note 12)` becoming `=note-12`. A template macro writes a flat expression so (`(symbol "\"=" (car (cdr e)) (car e) (car (cdr (cdr e))))`), and not a nested one such as `(* 0.2 env (- 1 drift))`, since a macro cannot call itself inside `symbol` (measured: `vla-symbol-arg-is-list`). The dialect is `frazaro-core`'s emitter today and the language's in time (§12), and until it is the language's an argument is the formula's own text, `"=note-12"`. The `(name ...)` row is in the cartridge format (§7.3), and a module writes its own cable. `Patch.last` and `Screen.last` are the language's (§2). `SIN` for the oscillator is `KERNEL.7`'s registry; `INDEX` and `MATCH` for the quantizer and the roll are `KERNEL.8`'s, with `CHOOSE` as the stand-in (§13). The `age` and `env` rows show why the caller names every cell: an envelope is two cells, and a macro that invented a hidden one would break the rule the whole language keeps. What a modder shares is either file: the patch as written, which the pass expands, or the saved cartridge with the knobs as turned, which loads; both are text in the one notation, so they diff in git, and the cartridge loads, views and reflects.

**C.5 Fragments in Fragments.** *Added 2026-10-08 at the owner's word, from the sitting's answer to two questions: how `fragments.vla` and `modular.vla` map onto a modular synthesizer, since the example seems to add no sine wave and no effect; and whether the artist's patch notes for the track, which the owner read as "an unstructured version of what I hope VLA could codify so that modular synth artists can pass around VLA patch files in the same way pianists pass around sheet music", can be so codified. The notes are quoted as the owner pasted them (§14).*

*Where the sine waves are, and why there is no effect.* A rack carries two kinds of signal. Control voltages move at the speed of a hand or a cloud: clocks, random voltages, envelopes, slow oscillators, probability. Audio moves at the speed of a string. This page puts the first kind in cells and rents the second from the Web Audio graph (§12). So `(lfo 4 "drift" sine 1800)` is a sine computed by a formula, one value a frame, a minute a cycle, a control signal; and `(voice 2 sine ...)` is a sine at audio rate, the host's oscillator, named by a word in the `wave` cell rather than computed. There is no effect because version 1's Audio sheet is a chip-tune voice, one oscillator and one gain per voice, the scope `ENGINE.4` was given; a filter, a delay, a reverb and a crossfader are rows of the patch sheet §12 names, the later version in which the graph itself becomes data. What the example shows in full is the control side of a modular system, which is where the artist says the week went: "most of that to fine tune many aspects, especially probability and setting attenuation and offsets to get just the right range of CV".

*The eurorack reading.* Each module of the notes, by its role, against the construct that is it in cells, and whether version 1 holds it:

| In the rack | In VLA | Today, or later |
|---|---|---|
| a clock and its dividers | `divide`: `MOD` over `Clock!B1` | today |
| a probability skipper, its probability under CV | `skip`: `=IF(AND(trig=1, dice/2147483647<p),1,0)`, with `p` a cell, so a cable can drive it | today |
| random voltages and random triggers | `dice` (§3.5) with `hold` on a trigger | today |
| a random sequence that loops and slowly mutates | a row of sixteen held values, each re-rolled with a small probability and otherwise its last value | today |
| a quantizer with a harmonic context, chords that progress | `quantize` into a Scale sheet; a progression is a row of scales picked by a bar counter | `INDEX`, `KERNEL.8` |
| an envelope with CV on attack and decay | `envelope`: an age cell and a shape cell; a knob is a cell, so the decay can be a cable | today |
| eight slow oscillators | `lfo`, eight rows with eight periods | `SIN`, `KERNEL.7` |
| three slow chaotic oscillators, the notes' weather, with X, Y and Z outputs | three formulas of the last frame integrating a chaotic system, Lorenz's for one | today (*math exists*, §14) |
| a slew limiter, for pitch bends | `=last+MIN(rate,MAX(-rate,target-last))` | today |
| an attenuator, an offset, a VCA, a mixer | arithmetic in the formula dialect; `(+ 0.15 (* 0.85 env))` is a VCA with a floor | today |
| a mult | a name read by several cells, free where a rack pays a module for it | today |
| oscillators with shaping and folding, a resonator, a granular voice | version 1's four voice shapes alone | shaping, FM and resonance: rows of the patch sheet |
| a filter opened by the envelope | none in version 1 | a filter row of the patch sheet |
| a delay, a reverb, tape wow and flutter, a dry/wet balance | none in version 1 | rows of the patch sheet; a reverb's impulse response is data |
| samplers and a looper, rain and harbour and a music box | none in version 1 | a version that carries audio data in a cartridge, named in §12 and not yet designed |

The chaotic line is exact rather than cute. Lorenz's system of 1963 was a weather model, three variables integrated step by step, deterministic and never repeating (*exhibit*, §14). Three cells, each reading the other two's previous values at a slowed timestep, are that system, and give the notes' slow peaks and valleys under §6's rules intact: the same seed, the same weather, on every machine.

*The patch notes, codified.* The control structure of the notes in the shape of C.1, by their paragraphs. Everything below runs on version 1's calls, except the lines marked:

```text
; the bass: a sequencer into a quantizer into an oscillator; its gate through a skipper into an
; envelope; the envelope's decay from a random voltage; no VCA, so a floor keeps the bass audible
(sequence                         ; a step sequencer: INDEX over a row, KERNEL.8
  2                               ; the row
  "bass-step"                     ; the name
  beat                            ; the clock that steps it
  Seq!$A$1:$A$8)                  ; the steps, eight voltages in a row of the Seq sheet

(quantize                         ; the step onto the scale
  3                               ; the row
  "bass-note"                     ; the name
  bass-step                       ; the voltage
  Scale!$A$1:$A$10)               ; the scale

(skip                             ; a probability skipper: the trigger passes with probability p
  4                               ; the row
  "bass-gate"                     ; the name
  beat                            ; the trigger in
  0.2)                            ; p, a low probability

(hold                             ; a random voltage into the decay knob
  5                               ; the row
  "decay"                         ; the name
  dice                            ; the source
  bass-gate)                      ; the trigger: a new decay on every gate

(envelope                         ; the bass envelope
  6                               ; the row of the age
  "bass-age"                      ; its name
  7                               ; the row of the envelope
  "bass-env"                      ; its name
  bass-gate                       ; the trigger
  3                               ; the attack, in frames
  decay)                          ; the decay, in frames: the knob is a cable

(voice                            ; the bass
  1                               ; the voice
  sawtooth                        ; the wave
  bass-note                       ; the note
  (+ 0.15 (* 0.85 bass-env)))     ; the volume: a floor of 0.15, so the bass is always audible
; the filter the envelope opens: a row of the patch sheet, later

; random triggers and voltages, through the quantizer, into two voices; the triggers' probability
; modulated by a slow chaotic voltage, so that "sometimes stuff isn't triggering very much"
(skip                             ; the first random trigger
  8                               ; the row
  "t1"                            ; the name
  beat                            ; the trigger in
  (+ 0.05 (* 0.1 apathy-x)))      ; p: 0.05 to 0.15, following a chaotic voltage

(skip                             ; the second
  9                               ; the row
  "t2"                            ; the name
  beat                            ; the trigger in
  (+ 0.05 (* 0.1 apathy-x)))      ; p, the same cable

(hold                             ; the first random voltage, sampled on its trigger
  10                              ; the row
  "x1"                            ; the name
  dice                            ; the source
  t1)                             ; the trigger

(quantize                         ; onto the scale
  11                              ; the row
  "note1"                         ; the name
  x1                              ; the voltage
  Scale!$A$1:$A$10)               ; the scale

(hold                             ; the second random voltage
  12                              ; the row
  "x2"                            ; the name
  dice                            ; the source
  t2)                             ; the trigger

(quantize                         ; onto the scale
  13                              ; the row
  "note2"                         ; the name
  x2                              ; the voltage
  Scale!$A$1:$A$10)               ; the scale

(voice                            ; the first music-box voice
  2                               ; the voice
  triangle                        ; the wave
  note1                           ; the note
  (* env1 (- 1 torpor-y)))        ; the volume: its envelope, held down by a chaotic voltage

(voice                            ; the second
  3                               ; the voice
  sine                            ; the wave
  note2                           ; the note
  (* env2 (- 1 torpor-y)))        ; the volume

; three chaotic systems, three cells each; slow oscillators; a slew for the bends
(sloth                            ; a chaotic oscillator, Lorenz's system integrated a frame at a time
  20                              ; the row of x
  "apathy-x"                      ; its name
  21                              ; the row of y
  "apathy-y"                      ; its name
  22                              ; the row of z
  "apathy-z"                      ; its name
  0.002)                          ; the timestep: smaller is slower

(sloth                            ; a slower one
  23                              ; the row of x
  "inertia-x"                     ; its name
  24                              ; the row of y
  "inertia-y"                     ; its name
  25                              ; the row of z
  "inertia-z"                     ; its name
  0.0005)                         ; the timestep

(lfo                              ; a slow oscillator
  30                              ; the row
  "ochd-2"                        ; the name
  triangle                        ; the shape
  2400)                           ; the period in frames: 80 seconds

(slew                             ; a slew limiter, for the pitch bends
  31                              ; the row
  "bend"                          ; the name
  ochd-2                          ; the target it follows
  0.01)                           ; the most it moves a frame
; the weather samples, their crossfaders, the reverb's dry/wet on a chaotic voltage: the patch sheet, and samples
```

*On sheet music.* The analogy holds exactly, and it says where the line is. A score fixes pitches, durations and dynamics and leaves the timbre to the instrument and the room; a VLA patch fixes every control voltage, every probability and every knob, and leaves the sound to the host's graph. What the notes cannot do, the file does: the same patch with the same seed produces the same control log on any machine, frame for frame (§6), which no rack and no page of notes can promise, and a week of attenuation and offsets becomes numbers in labelled cells another artist can diff, fork and turn. The practice exists in neighbouring forms (*exhibits*, §14): Csound has split the instrument from the score since 1986; VCV Rack and Pure Data patches are text files people trade; a Standard MIDI File is the output of a generative patch, where the VLA file is the patch. What VLA adds is the spreadsheet as the substrate, every value visible, every knob a cell, the previous frame a sheet, determinism by construction, and English through Frazaro; what it lacks today is the audio half, which is why the first Fragments sounds like a music box over a drone rather than like the track, and why the patch sheet is the version that matters to the artists the owner means.

*The golden patch.* Fragments is the golden patch of `modular.vla`, the owner's reading of 2026-10-08, so the dictionary a scoping will build on is written here before it starts. A module is a row of the Patch sheet: its knobs are the cells to the right of its output, its inputs are the references inside its formula, its output is the named cell. A cable is a reference. A mult is several formulas reading one name, free where a rack pays a module. A feedback cable, an output looped into its own input, is a `.last` reference, one frame late, which is the only way a loop is stable without a slew. A VCA, an attenuator, an offset and a CV mixer are arithmetic inside the formula and never rows. The cable list of a whole patch is a relation the house already prints, `reflect`'s `refers` rows, every cell against every cell it reads (*shelf*: oracle 8), so the patch sheet printed that way is the patch bay drawn as text:

```text
(refers "Patch!B6" "Patch!B3")        ; the cable from bar
(refers "Patch!B6" "Patch!B5")        ; the cable from dice
(refers "Patch!B6" "Patch.last!B6")   ; the feedback cable, a frame late
```

The distance between C.1 and the rack in the owner's screenshot of the performance is quantitative, not categorical. The notes name about forty-five control functions and about twenty-five audio ones, and the plumbing between them, the mults and attenuators and offsets, costs nothing in cells; so a faithful Fragments is on the order of seventy module rows and a hundred connections, five or six hundred lines in the layout above, of which the audio rows and their connections are the patch sheet's and not version 1's (*prediction*, 2026-10-08, for `CART.5`'s scoping to count). Software duplicates every module of that rack in kind, and several already exist in VCV Rack's library as their makers' own ports, Mutable Instruments' Marbles and Rings, Vult's filters, Instruō's modules and the chaotic Sloths (*exhibit*, §14); MIDI alone does not, since MIDI carries control and not audio, which is why the replay is MIDI-shaped and the sound is the graph's. The one categorical gap is the recordings, the rain, the harbour, the music box and the looped improvisation, which no patch synthesizes and a cartridge must carry as data (§12). And the render itself is beyond every substrate including the rack: three analog chaotic oscillators and probability on every trigger mean it never plays the piece the same way twice, where the cell version reproduces one performance exactly and forever; the file duplicates the patch, never the night. The oracle follows (*recommendation*): `modular.vla` is held by two goldens of Fragments in the house's shape, the expansion golden, the rows `fragments.vla` expands into, and the replay golden, the Audio sheet's log over a fixed number of frames under a fixed seed, so that a change to a macro that changes a row or a note is caught on every push; a new module enters the library with its row in C.5's table and its line in the goldens.

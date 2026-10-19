# The engine's page: the host's loop, and the viewport

**Opened plainly, the page is the player: the window the game's, the Screen
filling it under a slim bar, the source, the replay, the log and the sheets
in a drawer (`ENGINE.14`). It opens on an empty sheet, its cartridges in the
picker after it, and it names no game's file, so a game vendors it unchanged
and builds a page of its own (`ENGINE.15`). Its other modes are the bench, the oracles the
checks drive and the instruments the floors read. The host shim, `host.js`, runs a cartridge on the loop of `docs/SPEC.md`
section 5 over the engine's module, every input a cell it writes and every
effect a cell it reads, and blits the Screen as a plane of color indices.
It runs over the engine's own module, `alonzo.wasm`, built into the page,
the language computing every cell; `fake.js`, a double of the eleven
exports the loop calls, is what its oracle drives and what the page falls
back to when no engine is built in. Beside the loop the host runs the pass,
the module's twelfth export, which builds a cartridge from its source in the
page as an act of its own before the load (`SPEC.3`), and it keeps the
replay, every write a run makes, and plays one back to the same frames
(`ENGINE.3`). The viewport, `viewport.js`, draws
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
over the canvas, written as the Screen's own cell through the Camera of the
frame the person sees, the wheel and the last key; a person's edits, each
its own write; the step with a budget in cells, which may yield and continue
on the next tick, the progress a sentence; then the effects, the Camera
first and the Palette, so the frame is drawn through its own Camera and
colors, the Screen as the plane through the Camera's window, the Keys, the
Audio rows, the File's save cell, the Write sheet and the Clock's rate,
which a person may write into `Clock!B2` and the loop then steps at. At a
load whose manifest says `(seed host)` the host writes the seed into
`Clock!B3`, a number from the browser's random source, before frame 0 is
drawn (`ENGINE.3`). The loop is a fixed timestep with
an accumulator, a tick's time capped at 250 ms and the backlog at the larger
of 250 ms and one frame's interval, so a rate under four frames a second
still steps; a rate that moves starts the backlog again. No interpolation
and no skipped frame, and the loop is paused while the page is hidden. At rate 0 there is no tick: one step for
each edit, and no Input. A cartridge written to version 6 (`docs/SPEC.md`,
`CART.12`) has a place at rate 0: before an act's step the host writes the sheet
shown and the cell the act stands on, the selection's for an edit and a command,
`Input!B19`, `B11` and `B12`, with the press and the command, `B13` to `B15` and
`B20`; a press of a button over a cell of the sheet shown is an act of its own,
the viewport selecting the cell. One that says `(settle K)` settles each act: while
the step's answer ends `settling` the host steps again, no act and the derived
writes before each, drawing each frame, a person's acts waiting in order; the
load's act settles too, so the cartridge opens on computed values; an answer
ending `unsettled`, K settle steps taken, is said. The engine numbers its Clock by
acts and releases an act's press and command before the first settle step, and the
host and the recorder hold the release in their records of the Input sheet. The blit puts the bytes through the palette into
one `ImageData` and draws it at a whole number of device pixels a cell with
smoothing off; a byte past the palette is magenta.

The host keeps the replay of every load's run (`docs/SPEC.md` section 7.6,
`ENGINE.3`'s second slice). Its header names the cartridge by the SHA-256 of
its text with LF line ends, a digest the host computes itself, at once, and
the seed `Clock!B3` held after the load. Each frame is one form, `(frame n
row ...)`, holding the rows written before the `n`th step that landed, one
a line: the Input sheet's cells that changed, all forty-eight at the first
frame and after a person's edit of the Input sheet, and each person's edit
in its order. The derived writes are never logged, since a replay
re-derives them. A frame with no row is left out, except the last, written
`(frame n)`, so a replay names its length; the recorder stops at 8 MiB of
text and says so.
`play(text)` reads a replay whole and refuses in words a replay of another
cartridge, of a later page, with a derived row, with a form outside its
frames, with frames out of order, or with a seed that is not the manifest's.
It then loads the cartridge again with the replay's seed and plays the
frames through the loop at the cartridge's rate, each frame's rows one
write after the derived writes. A person's edit is refused while it plays,
and the loop pauses at the last frame. The recorder records what is played,
so a replay played and copied is the replay played.

The host continues the running game with a rebuilt cartridge, edit and
continue (`docs/SPEC.md` section 7.8, `ENGINE.7`). `apply(text)` compares it
with the cartridge the grid was last given, the one loaded or the one last
applied, row by row: each `cell` or `formula` row by its sheet, without case,
and its address or range, as the reader spells it back. The rows it changed
or added, values and formulas alike, are written as one person's edit at the
next frame's start, one write after the Input rows and the edits made before,
and recorded as a person's edits in that frame, under the header of the
cartridge loaded, so a session of rule changes replays from it. A row it left
alone is never written, so every cell the run moved keeps what the run gave
it, and the frame number goes on. What a write cannot carry is named in
words, with Load offered, and nothing is written: a directive of the
manifest; a sheet added or removed, or the tabs' order or a sheet's
visibility; any row that is not a cell or formula row; and a cell a removed
row wrote that no rebuilt row writes, since no write empties a cell. The
rebuilt cartridge is first loaded in a second handle and given back, so
nothing a load would refuse is applied, and a write refused writes nothing,
the game running on under the rules it had. At rate 0 a continue is one edit
and one step; paused at a rate above 0, it waits for Run and says so; while
a replay plays it is refused, as an edit is; and a second press before the
first lands replaces it.

A cartridge written to version 5 has commands of its own (`docs/SPEC.md`
section 3.10, `ENGINE.25`): its Commands sheet, row 1 the headers and a
command a row from 2 to 101, each a name in lowercase letters, digits and
hyphens, its words, whether it holds now, and its key, a `KeyboardEvent.code`.
The host reads the sheet at the load and after every step, a row it cannot
take said once until it changes. `command(name)` runs one, as a page's palette
or a person's binding asks: it waits for the next frame, one a frame and
sixteen at most, and is written into `Input!B20` for that frame alone, so a
formula reads it with no edge, `=IF(Input!$B$20="buy-1",...)`; at rate 0 it
steps the grid once, the twentieth row written alone before every step. A
command that holds not, or one asked for while a replay plays, is refused in
words. A command's key is taken on the Screen while the command holds and no
Ctrl, Cmd or Alt is held, a held key's repeat taken and running nothing; it is
the command's alone, holding no button and naming no last key. Since `CART.12`
it is taken on the grid's viewport at rate 0 too, before the viewport sees it,
every other key staying the viewport's. The replay logs
`B20` as every Input cell, and a version 5 cartridge's replay says
`(spec 5)`. A cartridge written to 1 to 4 has no commands, and a sheet of its
named Commands is its own.

The host sounds the Audio sheet (`docs/SPEC.md` section 3.6, `ENGINE.4`), each of
its four voices one `OscillatorNode` and one `GainNode` of the Web Audio
graph into one shared gain, and nothing of the host's own: no sample is
computed here, which `tools/check_web_offline.ps1` holds on this file. After
each frame, once the Clock's rate is read, a frame sounds where the last
frame's sound ends on the audio clock, while that lies within 100 ms ahead of
it; a frame whose time has passed starts the timeline again 50 ms ahead, and
a frame further ahead than 100 ms is not sounded. A voice's gain is its
volume over four, approached by the graph's `setTargetAtTime` with a time
constant of 3 ms, so a change is not a click; its frequency is
`440 * 2^((note - 69) / 12)`, set at the frame's time; a wave changed is a
new oscillator, through a dip of 15 ms while the voice sounds, since a wave
takes effect when the JavaScript runs and cannot be scheduled. Only what
changed is scheduled. A volume of 0, or an empty one, is a rest; a wave that
is not one of the four words (without case), a note that is not a number
from 0 to 127 or a volume that is not one from 0 to 1 silences the voice for
the frame, said once, a notice and not a refusal. Nothing sounds until a
person presses Sound on, which makes the audio context, since one made
before a person's act stays suspended; and the voices stop with the loop, at
a pause, a hidden page, a replay's end, a refused step and an unload, and
sound the frame the grid holds again when it starts.

| Method | What it does |
|---|---|
| `new AlonzoHost(options)` | `canvas` the plane's canvas (it takes the keys while focused); `box` the element the blit fits, the canvas's parent by default; `scale` a fixed number of device pixels a cell; `budget` a fixed budget in cells a step call, 0 for none; `callsPerTick` a fixed count of step calls a tick in place of the time slice; `now` the clock the budget is measured by; `drive: 'manual'` when the caller calls `tick` itself (the oracles); `seed` the number a `(seed host)` cartridge gets in place of the browser's random one, a whole number from 1 to 2147483646 (the oracle); `audio` an audio context the host sounds through from the start, in place of the one `soundOn` makes, and `audioNow` its clock in place of the context's `currentTime` (the oracle's double of the graph); `grid` the element a grid cartridge's viewport fills (`ENGINE.8`), without which a grid cartridge runs and nothing draws it; `viewport` the options that viewport is made with (`ENGINE.20`), the loop oracle's `{ willReadFrequently: true }` |
| `attach(exports)` | asks `alonzo_abi_version` and refuses another number, then every export the loop calls: `{ ok, abi, version }` or `{ ok: false, sentence }` |
| `load(text, name)` / `loadBytes(bytes, name)` | unloads the grid it held, loads a cartridge, then `describe`, reads the Camera, the Palette and the Keys, and draws the new grid's frame 0 at once, nothing computed, on the plane's canvas or, for a grid cartridge, through the viewport, so that neither shows a grid the module no longer holds: `{ ok, handle, title, mode, w, h, rate }` or the refusal's sentence |
| `expand(source, path, files)` | the pass (`docs/SPEC.md` section 7.8): a cartridge's source, the path its includes resolve against (`cartridges/<name>/<name>.source.vla`, the command line's), and the texts it may include as `[path, text]` pairs, handed to the module's `alonzo_expand`, an act of its own that takes no handle, touches no grid and stops nothing: `{ ok, text, rows, ms }`, the cartridge's text CRLF as the command line writes it and its rows after the manifest, or the refusal's sentence with the source line it stands on; the export is asked for here and not at `attach`, so over a module without it, the double, the build is declined in words |
| `apply(text, name)` | a rebuilt cartridge applied to the running game, its state kept (`ENGINE.7`): compared with the cartridge the grid was last given, then loaded in a second handle and given back, then its changed and added cell and formula rows queued as one person's edit for the next frame's start, a press waiting replaced: `{ ok, rows, cells, formulas, values }`, `rows` 0 when it changes none, or the refusal's sentence, which names what a write cannot carry and offers Load. `name` is the file's name in the sentences, the loaded one's by default |
| `start()` / `stop()` | the animation-frame loop; the voices sound the frame the grid holds when it starts, and stop with it |
| `soundOn()` / `soundOff()` / `soundIs()` | the sound, on only after a person's act: `soundOn` makes the audio context at its first call, which a page makes in a press's handler, and sounds the frame the grid holds; `soundOff` silences the voices, stops the oscillators and suspends the context; `soundIs` whether it is on |
| `tick(ts)` | one animation frame's work at its timestamp, what the loop calls |
| `edit(row)` | a person's edit, one `cell` or `formula` row, issued after the next frame's inputs; at rate 0 it steps once, and for a version 6 cartridge stands on the cell the selection stands on when it is made, and waits for a settle going on, then settles (`CART.12`); while the loop is paused at a rate above 0 it waits for the frame Run brings, and the host says so |
| `keyDown(code, key, ev)` / `keyUp(code)` / `releaseKeys()` | the keys held, by `KeyboardEvent.code`; since `ENGINE.25` a command's key runs its command and holds nothing, `ev` the key's event when a listener has one, its Ctrl, Cmd, Alt and repeat |
| `command(name)` / `commands()` | a version 5 cartridge's own commands (`ENGINE.25`): `command` runs one by its name, waiting for the next frame, one a frame and sixteen at most, written into `Input!B20` for that frame, at rate 0 a step of its own: `{ ok, name }`, or the refusal's sentence, for a cartridge written to 1 to 4, a name its Commands sheet holds no command of, a command that holds not, a replay playing or sixteen waiting; `commands` lists them as the sheet last said them, `{ name, words, holds, key }` in its order, `key` the code or empty |
| `pointerAt(col, row)` / `pointerButtons(left, right, middle)` / `wheel(notches)` | the pointer's place as the window's cell under it, 0 when off the canvas, which the Input rows write as the Screen's own cell through the Camera; in grid mode, at a rate above zero, the viewport's cell under the pointer, 0 off the window's cells, and the wheel's notches with its scroll prevented, while a key the Keys sheet binds is taken before the viewport sees it (`ENGINE.8`). Since `ENGINE.14` the wheel is the game's over a cell of the Camera's window alone, where the pointer is, and scrolls over the tabs, the headers, the corner and the scrollbars; the buttons follow the pointer; while another sheet is shown the pointer is 0 and the wheel scrolls, and a bound key stays the game's. Since `ENGINE.18`, for a cartridge written to version 4, the pointer and its buttons over any cell of another sheet shown are the game's too, that sheet's own cell with no Camera added, and the Input sheet's nineteenth row names the sheet shown; the wheel still scrolls there; a cartridge written to 1 to 3 is as before |
| `runFrameSync()` | one whole frame now, whatever the clock (the blit's instrument) |
| `redraw()` | the last complete frame drawn again, nothing stepped: the Camera and the Palette read as they stand, the plane viewed through the window and blitted, or a grid's Screen drawn through the viewport (`ENGINE.8`'s second slice), always, never found still (`ENGINE.17`), no other effect read (the blit's instrument over the engine's module, where a step is the evaluator's); `false` without a cartridge |
| `viewRecord(sheet, window)` | a sheet's record as the module prints it, for a page to show; `null` while a frame is in progress, or refused, the refusal said once |
| `answer(viewport, event)` | a viewport's `sheet` event answered (`ENGINE.14`; `KERNEL.5`'s decision 6): a sheet the viewport holds no record of is viewed and shown, one it holds is viewed again at once, and in the host's own viewport the Screen's tab gives the Camera's window back. The host answers its own viewport's tabs itself; a page wires a viewer of its own with `viewer.on('sheet', function (e) { host.answer(viewer, e); })`. A tab clicked while a frame is in progress is answered at the frame's end, and the events the host's own calls raise go unanswered |
| `showSheet(viewport, name)` | a sheet viewed through the region the viewport shows from `A1`, loaded and shown, then viewed again at once when its own widths put more in view: `true`, or `false` when refused. Since `CART.12`'s hand test the sheet's columns are read whole first, its last row viewed across every column, a record of no cell that names every column with a setting and the extent, which the viewport learns (`learn`), so that it lays every column as the sheet sets it, at the load, at a jump of the scroll and when its box grows; and a sheet the cartridge bounds, version 6's `(bound ...)`, is drawn to its extent and no further (`bound`). The record is the values record after frame 0 and the grid record at frame 0, as the Screen's is (`ENGINE.18`) |
| `refreshSheet(viewport, moved, still)` | the sheet a viewport shows viewed again through the region it shows, its view kept: what the host does at every frame for its own viewport, and a page at its viewer's refresh; `moved` only when the region has left the window the record was viewed through, at a scroll (`viewer.on('scroll', ...)`); `still` (`ENGINE.17`) not loaded again when the record is the one the host last loaded into the viewport and the viewport holds the model it made of it, as a frame does and the player's drawer does. The region and never the sheet whole: a full screen of Sand's Stay is 33 ms natively, its whole record 1.4 s and 34 MB. The record is the values record after frame 0 (`ENGINE.18`), so a still sheet's frame keeps only that view: a sheet of 1,000 formulas views in about 0.35 ms where its grid record took 2. Since `ENGINE.19` a `still` refresh asks the window's changes first: patched in place when they name cells since the record the host holds for that viewport, kept when they name none, viewed whole otherwise, as at a refresh frames apart, the drawer's at a rate above zero |
| `replayText()` | the replay of the run since the last load, as text, a replay played included; `null` with no cartridge loaded. Its header names the page its rows are written to, the cartridge's version, and 3 for a cartridge written to 1 to 3 (`ENGINE.18`) |
| `play(text, all)` | a replay checked whole, then the cartridge loaded again with its seed and its frames played through the loop at the cartridge's rate, edits refused until it ends, the loop paused at its last frame: `{ ok, frames }`, or the refusal's sentence with nothing loaded; `all` plays every frame at once, synchronously (the oracle) |
| `counters()` / `sentences()` | what the host has done, the sound's among it (`sounded`, `restarts`, `skipped`, `silences`), and a grid's frames drawn and still (`draws`, `stills`: a frame whose record of the Screen, or of a sheet shown in its place, is byte for byte the one the host last loaded into the viewport, and whose model it still holds, is neither read nor painted, `ENGINE.17`; a still Screen's `timing` is `{ view, draw: 0, skipped: true }`), and the sheets a version 4 cartridge's Camera showed (`shows`, `ENGINE.18`). Since `ENGINE.19` a frame asks the window's changes before its view, so a still frame views nothing at all, and a frame whose changes name cells since the record the host holds is patched, the held record and the viewport's model laid with them in place: `patches`, each also a draw, its `timing` `{ view, draw, patched }`, `view` the changes' time and `patched` the cells named; and `inputsKept`, the frames whose Input rows all stood as last written, so that none was written; since `ENGINE.7` `applied` and `appliedRefused`, the continues written and those whose write was refused; since `ENGINE.25` `commands` and `commandsRefused`, the commands written into `Input!B20` and those refused; since `CART.12` `presses`, a version 6 cartridge's presses over a cell taken as acts at rate 0, `settles` and `unsettled`, the acts whose settle ended still and those K stopped, `settleSteps`, the settle steps stepped, and `settling`, whether the last step's answer left the grid settling; every sentence said, in order |
| `log()` / `logEntries()` | the last twenty events, one line each: a repeat of an event, the same sentence at another frame, is counted in the line it first made (`3 times, frames 7 to 21: ...`) and pushes nothing out; the entries as `{ id, text, key, count, first, last, refusal }` for a page that draws the log in place, `refusal` true for a refusal or a failure, the module's or the host's, which the page paints red |
| `unload()` / `destroy()` | frees the handle and empties the canvas and the viewport; removes the listeners, and the viewport with them |
| `vp` | grid mode's viewport (`ENGINE.8`), made at the first grid load over `options.grid` and kept across loads: a grid cartridge's Screen, its record through the Camera's window drawn at frame 0 and after every frame, the grid record at frame 0, its formulas as their texts, and the values record after it, the grid record less its formula rows, so that no formula's text is moved at a frame (`ENGINE.8`'s second slice, Frazaro's `KERNEL.37`), each frame's record replacing the last with the person's scroll and selection kept, scrolled to the window's corner at a load and by the Camera's move after it; a page focuses its `scroller` to give it the keys. Its tabs are answered (`ENGINE.14`): while another sheet is shown, each frame views that sheet alone, through the region in view, and the Screen's tab gives the Camera's window back, scrolled to its corner as at a load. Since `ENGINE.18` a cartridge written to version 4 opens on the sheet its Camera's third row names, else on its first visible sheet, so a Screen it hides is never opened on, and a change of that row shows the sheet it names at the frame's end, the person's tabs winning between its changes; a page that shows the viewport's box only after the load calls `refreshSheet(host.vp)` once it is laid out, as the player does |
| `on(name, fn)` / `off(name, fn)` | `status` (`{ text, kind, repeat, refusal }`: a sentence, `kind` `event` or `progress`, `repeat` true when it only counted an earlier line, `refusal` true for a refusal or a failure; a notice of a value the host coerced, a Camera cell read as 1 or a color painted magenta, is not one), `frame` (`{ frame, window, scale, rate, replay }`, after a frame completes, `rate` the one the Clock now holds, `replay` the last frame of a replay playing or 0), `load` (`{ handle, title, mode, w, h, rate, window, scale }`, after frame 0 is drawn), `stop` (`{ frame }`, when a running loop stops, at Pause, a replay's end, a refused step, a load or an unload, so that a page draws what it shows of the grid at that frame) |

`AlonzoHost.instantiate(bytes)` and `instantiateSync(bytes)` instantiate a
module with the empty import object of section 8.1; `AlonzoHost.RULES` holds
the loop's constants; `AlonzoHost.sha256(bytes or text)` is the host's
digest in upper-case hex, and `AlonzoHost.SPEC` the page's version a
replay's header names. `AlonzoHost.patchRecord(record, changes)` is the
host's patch alone (`ENGINE.19`): a values record's text after a window's
changes, each named cell's rows replaced, put in or taken out and the header
untouched, or `null` for a whole answer. `AlonzoHost.compareCartridges(base,
rebuilt)` is the continue's comparison alone (`ENGINE.7`): `{ why, rows,
formulas, values, cells }`, each reason a write cannot carry the change in
words, and the rows a continue writes. The first step call of a cartridge asks for 2,000
cells, about 9 ms of the engine's module, before the host has measured how
many cells a millisecond the machine does; after it the budget is three
quarters of the display's interval turned into cells, where it was half
until Sand's water (`CART.2`, 2026-10-12), whose heaviest seconds step in
about 23 to 25 ms and are presented at thirty frames a second only so; the
loop oracle's `slice` case holds the share. A tick's time is put on the grid
of the frame's interval when within a quarter of a millisecond of it (the
rules' `snapMs`, `CART.2`'s playtest pass, 2026-10-12): the display's
timestamps jitter by a tenth of a millisecond, and at a rate of 60 the
accumulator's remainder at its threshold presented 38 to 40 of 60 frames a
second, some ticks two and some none; the loop oracle's `pace` case holds
one frame a tick at 60 and one each second tick at 30. A refusal is the module's words once,
then its id; the host adds the row's line only for a write of more than one
row, and only when the module's words do not already name it.

The engine's module answers as the double does, with the language's refusals
and its own: Life loads with the Clock, the File and an Input sheet the
engine makes, and steps a frame in about 4.3 ms in Chrome over `vla-lang`
0.9.0 (the owner's run of 2026-10-11), so it keeps its rate of thirty frames
a second with most of each frame's interval to spare. The first engine,
2026-10-09, stepped about 1.8 generations a second at the slice the host
spends, the progress sentence showing between them (`docs/SPEC.md` section 5's
slowness in plain sight); `CART.1` measured the cost, and the language's
releases removed it.

`fake.js` is the permanent test double: `AlonzoFake.create(options)` answers
`{ exports, stats, digest, peek, frame }`, the exports the eleven names of
section 4.6 the loop calls over a real `WebAssembly.Memory`, and not the
twelfth, the pass, since it holds no expander: the host declines a build
over it in words. It reads a cartridge's
manifest, the engine's own duty, and never a row after it, and it evaluates
nothing (`AD-1`); its grid is hard-coded and declared in `AlonzoFake.RULES`:
the Screen's bytes as eight-by-eight tiles cycling through the sixteen
colors with one row swept by a byte past the palette, the CGA palette,
TIC-80's keys, a Write sheet whose rows land or are refused on a rule of the
frame, and a history cell that makes the end state's digest witness the
order of every write; in grid mode its Screen's record draws the tiles through
a look of the CGA's sixteen (`ENGINE.8`), and it answers the values
projection as its grid record less the formula rows. Since `ENGINE.19` it
answers a window's changes too, from the twins of its last two frames' ends
with room for every change, whole before the first frame, after a write that
changed a formula or added a cell until and at the next frame's end, while a
value written since the last frame lies in the window, and when the sheet's
extent moved, as its Write sheet's does on its rule of the frame; its tiles
all change at every frame, so its Screen is patched whole. Its memory grows by zero pages at every load and every
seventeenth allocation, detaching the buffer, and its allocator counts what
is live and what is freed wrongly. `options.abi`, `options.omit` and
`options.growEvery` make the doubles the loop's oracle refuses or strains.
Since `ENGINE.1`'s second slice its refusals carry the engine's module's ids
and its write checks rows in the engine's order, the engine's own checks
over every row before the language's, which the loop oracle's `parity` case
holds scenario by scenario. Since `ENGINE.2` its plane reads a formula
without a value as 0 wherever it stands, as its record says by printing no
value row, where it had read one outside its declared size as 255; the
`plane` case holds its plane to its record. Since `ENGINE.3` it refuses a
person's value into the Clock as the engine does, `cart-write-clock`: the
frame, and a rate or a seed outside its range.

The viewport is `viewport.js`, one plain script: no framework, no module
syntax, no import, nothing fetched. It reads a view record, the lines
`frazaro view` prints (Frazaro's `conformance/README.md`, oracle 11), and
paints the window it is given: the sheets as tabs, the columns at the widths
the record declares, the fills and number formats of its formats, each
cell's text where the record puts it, the gridlines when the record says so.
It computes nothing: a value is shown as the reader spells it, a formula
shows its text until the value row lands (`KERNEL.7`) and its value after it,
its text kept for the bar; in a values record, which prints no formula row, a
value row is a formula known by its value, its text not in the record, and a
style or sentence row alone a formula with no value yet, drawn empty in its
style (`KERNEL.37`, read since `ENGINE.8`'s second slice); a `look` row maps a value to the format every cell
holding it draws with, and a `row` row gives a row its height in points or
hides it (`docs/SPEC.md` decision 19, read since `ENGINE.8`); a `format` row's
number format may be a code of Excel's, `"0.00"`, and a `text` row after a
cell's value is the text the value draws under the code of the format the
cell draws with, which the cell shows in the value's place, aligned and
matched to a look by the value, the value kept for the bar (Frazaro's
`KERNEL.47`, read since `CART.12`): the viewport keeps a code and never
applies one; an unknown row is counted, never refused. What the viewport owns is the state no program sees:
the scroll, the selection, the widths a person dragged, the frozen panes and
the marks a host asked for. The record is never written.

The page, `index.template.html` built into `index.html`, is the engine's
panel, a cartridge running on the host's loop, Life, the glider gun, the
test card, the input card, the sound card, Sand, the grid card, the first grid cartridge, drawn by the viewport in the plane's place (`ENGINE.8`), Kairos, the stacking game (`CART.4`), or Superposition, the large board (`CART.12`), each with its source, which the drawer's Build expands into the
cartridge in the page, the input card, the sound card, Sand and Kairos each with its replay, which Play the replay plays, the
Audio sheet heard after Sound on, and
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
builder puts it in the page. Opened plainly, the page is the player
(`ENGINE.14`), and it opens on an empty sheet (`ENGINE.15`): a grid of
eighty columns by fifty rows at rate zero, nothing running, the same in
every page whatever cartridges it holds. Open the Drawer and press Write:
its edit row holds `(formula "Screen" "A1" "=6*7")`, and A1 reads 42 at
once, since at rate zero an edit is a step. Pick Life in the bar, the
picker holding the page's cartridges after the empty sheet, each by its
manifest's title: the window is the game's, Life filling it as the language
computes it, at its rate of thirty frames a second, under a slim bar with
the cartridge, Run, Pause, Sound, Load, the frame and the latest sentence;
without the engine the player runs against the fake module and says so.
Press Full screen for the browser's fullscreen over the whole player, the bar
kept; Esc leaves it, pressed twice where the page holds Escape (below). Press Drawer, and the drawer opens at the right and
pushes the Screen aside, which refits. Type a row in its edit box and press
Write (`(cell "Palette" "B1" "#FF8800")` turns the dead cells orange,
`(cell "Screen" "B2:K11" 1)` holds a block alive while Life flows around
it), watch the log, each repeat counted in its first line, and press Copy
the log to take it as text; click a tab of the drawer's sheets, the Clock's
frame counting or, under the hidden sheets, the previous frame's twin, to
see its record live through the cells in view, viewed again about five
times a second while the loop runs, at every scroll and whenever it stops,
so that at a pause the sheet and the frame line say the same frame; edit the
cartridge's `(rate 30)` to `(rate 0)` and press Load to see a step on every
edit. Open The source and the cartridge to see both texts: the
source a person writes, its palette one macro call, and the cartridge the
pass writes from it. Press Build the cartridge to run the pass in the page,
the function `cargo run --release --example expand` runs, to the same bytes:
it puts the cartridge it built in the second box and loads nothing, so the
cartridge running goes on running until Load loads what was built. Press
Apply the source instead to build it and apply it to the game that runs:
change a rule of Sand's source while the sand falls, and the next frame
falls by the new rule, every grain where it was (`ENGINE.7`). Every act of
the drawer is a key too, its button a convenience (`ENGINE.22`), Cmd for
Ctrl on a Mac: in the source's box Ctrl+Enter builds and Ctrl+Shift+Enter
applies, the caret staying where it was, so a rule is tuned without leaving
the box, and a library's box does the same; in the cartridge's box
Ctrl+Enter loads it from frame 0 and Ctrl+Shift+Enter applies it as it
stands; in the replay's box Ctrl+Enter plays it. Every act of the player is
a command too (`ENGINE.23`), run from the palette: press Ctrl+K, Cmd+K on a
Mac, or Ctrl+Shift+`, Frazaro's CLI key, anywhere on the page or the Commands
button, and type a command's name, `run`, `pause`, `drawer`, `source`,
`full-screen`, the lines narrowing as you type, a command of your own and the
game's before the page's, each with its words and the keys that also press it. Enter runs the line chosen, the arrows choose, a
click runs one, Escape closes, Ctrl+Up and Ctrl+Down bring back what was run,
and the focus goes back where it was. A sheet's name shows that sheet as its
tab does, in the Screen's place for a grid and in the drawer's sheets for a
plane; a text that begins with `(` or `;` is a row of VLA, written as a
person's edit as the edit row writes it. A cartridge picked from the list
`pick` opens gives the game the keys once it loads. Ctrl+Alt+PageDown and
Ctrl+Alt+PageUp, Excel for the web's keys, move between the sheets in a
window and in full screen, and Ctrl+PageDown and Ctrl+PageUp, Excel's own, in
full screen, a window's browser keeping them for its tabs. Where the browser
has Keyboard Lock, Chrome, Edge and Opera, the page holds Escape in a full
screen it asked for: Escape closes the palette, a first Escape otherwise
drops a hint from the top, and a second within three seconds leaves full
screen, as Escape held does, the browser's own way out. Firefox and Safari
keep Escape, which leaves full screen at once, and the hint says so as full
screen begins, naming the browser's own full screen, F11, which leaves
Escape to the page. Open The keys in the drawer, or type `keys` in the
palette (`ENGINE.23`'s second slice): the page's keymap is a text, a
binding a line, `(bind "Ctrl+K" palette)`, and yours to change. Bind a key,
`(bind "Ctrl+J" pause)`, or a key in one place alone, `(bind "Ctrl+Shift+Enter"
run screen)`, and press Apply the keys, or Ctrl+Enter in the box. A keymap
is read whole and refused whole, every problem said by its line and nothing
changed: a line that names no command, a key Windows keeps (Alt+Tab, Alt+F4,
Ctrl+Alt+Delete), Ctrl with Alt and a letter, which is AltGr on Windows,
two lines binding one key in one place, or no key left for the palette.
Write commands of your own, a name, its words and the steps it runs in
order, each a command of the page's, one of yours, or a row of VLA written
as a person's edit: `(command "again" "the cartridge loaded again and run"
(load) (run))`, then type `again` in the palette, or bind it, `(bind
"Alt+Shift+A" again)`. Record a key writes the next key pressed into the box
at the caret, as the keymap spells it. Under the box every command is
listed with its words and its keys, yours and the game's first, and each button's
tip says the same;
the list says, too, what keeps a key from the page, Ctrl+W a window's
browser's and Cmd+Q a Mac's, and which binding shadows a button of the game
loaded on the Screen, a plain Z beside Kairos's, or a key the game reads as
the last one pressed, a plain 3 beside Sand's (`ENGINE.24`). A binding may
hold on one sheet, `(bind "P" drawer (on "Portfolio"))`, on the Screen or in
the drawer's sheets while that sheet shows, before a binding of the same key
on none, so that each tab has keys of its own: on Buffet's page P opens the
drawer on the Portfolio and stays the game's on Gigs. The note under the edit
row names the game's own keys, player by player as its Keys sheet binds them
now, the four arrows as one, and says when the game reads any key; Buffet's
changes from view to view. A cartridge of version 5 brings commands of its
own (`ENGINE.25`), its Commands sheet a row a command, a name, its words,
whether it holds now and its key: the palette lists each while it holds as
`<cartridge>.<command>`, `commandcard.count-up` in the loop's card, before
the page's own, and runs it as the game reads it, its name in the Input
sheet's twentieth row for one frame. Bind one as any other, `(bind "Ctrl+J"
commandcard.count-up)`, on one sheet too, or make it a step of a command of
your own; while its cartridge is not loaded, or the command holds not, its
keys press nothing and pass on to the game, and the list says so, marking
the game's commands (game). Its own key, the sheet's column D, runs it on
the Screen with no Ctrl, Cmd or Alt, the drawer's note naming it, and the
list says which binding of yours shadows it.
The keymap applied is kept in this browser, the one thing the page writes
(below), and holds again at the next load; Back to the defaults, `default-keys` in the
palette, puts the page's own in the box and gives the box the keys, the caret at
its end, and applying it forgets the one kept. In a box the
typing is the box's: a binding written for anywhere holds there only for a
key held with Ctrl or Cmd, or a function key, and never for the box's
editing keys, Ctrl with A, C, V, X, Y or Z, an arrow, Home, End, Backspace
or Delete. On the Screen of a cartridge with a rate, a game in time, Tab is
the game's, never walking the focus out of the page; the palette's key
leads out. Change a macro of the library at the bottom, `cartridges/common.vla`,
and build again to see every row it writes change; over the fake module the
build is declined, in words. Pick the glider gun in the bar to see Gosper's
gun fire a glider every thirty frames, south-east until the stream meets the
border; its pattern is the Seed sheet, which the first frame reads, drawn in
its source as one picture, a string a row and a hex digit a cell, `1` alive
and a dot nothing (`KIT.2`). Pick the test card to see the plane's
whole rule: the sixteen colors as bars, magenta wherever a value is no
color (a byte past the palette, a fraction, a text, a truth value, an
error), black for an empty cell, the window panning a column a frame across
a Screen wider than it and wrapping after 21 frames. Pick the input card,
click the plane to give it the keys, and see every cell the host writes
before a step: a lamp for each button of four players, white while held and
a new color after each press (the arrows, Z, X, A, S, Enter and Space for
player 1; I, K, J, L, U, O, Y, P, 9 and 0 for player 2), the mouse's three
buttons and a cursor under the pointer in their colors, the wheel panning
the card with the cursor still under the pointer, the frame's bits, and the
seed's and the dice's from the seed the host chose; write `(cell "Clock"
"B2" 1)` to watch it step once a second. Open The replay: the input card's
own replay waits in its box, the loop oracle's run of the card; press Play
the replay and watch it, the frame line saying which frame of the 26 it
plays, until it pauses at its end. Play the card yourself, press Copy the
replay, reload the page, paste it into the box, and press Play the replay
to watch the same run again. Pick the sound card, press Sound on, and hear
its eight-second loop: A4 through the four waves, a scale, two chords and a
slide under a swell, the notes falling down the Screen in each voice's
color; press Z or an arrow for a tick; write `(cell "Knobs" "B1" "saw")`
and the log says voice 4's wave is no wave and the tick is silent, then
`(cell "Knobs" "B1" "square")` for a square one; Pause and the sound stops,
Run and it sounds again. Open The replay with the sound card picked: its
own replay waits in the box, the loop oracle's run of it, 240 frames; press
Play the replay with the sound on and hear that run again, six presses of
Z, five of them ticks and the one while the knob says "saw" silent, and ten
frames at a third of the speed. Pick Sand and watch it open raining sand
and water from its top third at sixty frames a second, Life's soup as
grains, half of each,
the sand settling into piles and the water spreading over them in a few
seconds, the motion even and no click, release or key a stall; click the plane
to give it the keys, paint sand with the left button, press 3 and paint
water, which spreads along whatever it lands on and never settles, a lake's
edge shimmering; press 2 and paint walls, press 0 and the left button paints
empty, as the right button always does; turn the wheel to size the brush
from 1 to 8, and see the material the left button paints in the floor's
color. Its Stay sheet, the cells that keep their occupant this frame, 2
where it is water, its Side sheet, the cells occupied once the water has
moved sideways, its Parity column and its Tally, each row's codes and
occupied cells, are among the drawer's sheets, each viewed through the cells
in view, where the whole of Stay is 34 MB of record. Open The replay with Sand picked:
its own replay waits in the box, a person's painting session, 2,085 frames;
press Play the replay and watch sand painted into the rain, water after the
key 3, sand after the key 1, a wall after the key 2, water again with the
brush widened to 7, the right button erasing near the bottom, and the toy
left alone to frame 2,085, where the replay pauses, its Tally the golden's.
Pick Kairos and a row of three lights slides up and down the board's first
column, the tower lying on its side with level 1 at the left: press Z or
Space, or click the plane, to stop it over the row beneath. The lights that
miss blink and fall, and the next row is no wider than what stayed. At level
11 the minor prize's column blinks: X takes it and ends the game, Z goes on;
level 15 wins the major, and WIN flashes. Its Levels sheet, each level's
speed and window, and its State sheet, the game's thirty-one cells, are among
the drawer's sheets; write `(cell "Levels" "D3" 1)` and level 2's row stops
where it stands only in the first frame of each place, a column on after it,
the cabinet rigged in the open. Open The replay with Kairos picked: its own
replay waits in the box, the owner's two games, 3,469 frames; press Play the
replay and watch the major prize won, every row stopped over the one beneath
and the minor refused at level 11, then a second game that loses a light at
levels 2 and 4, refuses the minor again and misses at level 15, the replay
pausing after the fall's hold, its Tally the golden's.
Pick the grid card, or paste a grid cartridge of your own into the
drawer's cartridge box and press Load, and its Screen fills the window at
the cells' own sizes, never fitted or zoomed: click a tab and the sheet
shows live in the Screen's place, the pointer and the wheel the viewport's
while it shows and the keys the Keys sheet binds still the game's; the
Screen's tab gives the Camera's window back. Over the Screen the wheel is the
game's over the cells of the Camera's window and scrolls over the tabs, the
headers and the scrollbars; a number too wide for its column reads as #s.
Open the page with `?viewport=1` for the viewport over the fixtures: pick a
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
template and on the viewport's source on every push. It writes one thing, a
person's keymap, when they apply it, under the one name `alonzo-keys` in the
browser's storage for pages, kept until the page's own
keymap is applied (`ENGINE.23`, the owner's word); in Chrome, Edge, Opera
and Firefox every page opened from disk shares that store (measured), so a
keymap follows a person from Alonzo's page to a game's. The same check holds
the template to naming that store once and every source to naming no
other: no session store, database, cookie or cache. And the records inside
are the door's own output, pinned byte for byte by
`tools/check_view_fixtures.ps1`. Every cell is drawn where the record puts it:
`tools/check_render_oracle.ps1` runs the page's own oracle under a headless
browser at two pixel ratios and holds the viewport's draw list equal to what
each record says, cell for cell, every coordinate on a device pixel. And the
frame holds: `tools/check_render_floors.ps1` holds the owner's measured
baseline to the roadmap's bars.

## The seven modes: the player, and the bench

One template and one built page (`ENGINE.14`): every check opens
`web/index.html` with its mode and reads one element, so the bench kept as
the page's modes keeps each check's contract, and the player is what the
page shows opened plainly and what Pages deploys.

- Opened plainly, the page is the player, above.
- `index.html?viewport=1` is the viewport over the fixtures, `KERNEL.5`'s own
  page, above, with the HiDPI panel, the same text in a DOM cell and in the
  canvas, by which the crispness verdict was taken.
- `index.html?loop=1` runs the host loop's oracle: the host driven over a
  fixed input log against the fake module, its frames, writes, windows,
  sentences and end state held to what the page computes from the log, and
  from a second fake module it drives with no host between; and, when the
  page holds the engine's module, the same host over it, Life's plane at
  frames 1 and 11 equal byte for byte to a reference Life the page computes
  (`engine`) and fourteen refusals answered with the same id by the double and
  the module (`parity`); and the frame path's equality (`plane`, `ENGINE.2`):
  at frame 0 and after every frame, the window the host drew through is the
  Camera's, the bytes it holds are the record of that window read by the
  page's own rule from `docs/SPEC.md` section 3.1 (a whole number from 0 to 254
  itself, any other value 255, an absent cell and a formula with no value
  row 0), and the canvas's pixels at a cell of each kind are the Palette's
  color or magenta, over the double, its Camera moved by edits, and over the
  engine's module, the test card's twenty-four frames under a Camera that
  pans a column a frame; and the pass in the page (`pass`, `SPEC.3`): every
  source the page holds, expanded over the module, is its cartridge as the
  command line wrote it, byte for byte, an include the page does not hand in
  is refused at its line, the pass takes no handle and stops no loop, and a
  build over the double is declined in words; and the Input and Clock
  devices (`input`, `ENGINE.3`): over the engine's module, the input card
  loaded with its seed named and driven by events dispatched to the canvas,
  keys, a second player's press, the pointer with its clicks, the wheel
  panning the Camera, an edit of the Clock's frame refused, the rate
  written to 1, the teacher's, and back, and a person's edit of the Input
  sheet, the window the host draws equal at every frame to the card
  computed by hand from the log, and the Tally's counts, the seed and the
  dice to the log's; `rate30` pins the pointer written through the double's
  Camera too; and the replay (`replay`, `ENGINE.3`'s second slice): the
  host's SHA-256 held to FIPS 180-2's five vectors, a live run over the
  double copied and played on a fresh host to the same digest, all at once
  and through the loop, an edit refused while it played, the loop's stop
  said once at the replay's last frame, and six replays refused in words; and, over the engine's module, the input card's
  committed replay equal to the `input` case's run as the host recorded
  it, played on a fresh host to every frame of that run and to its golden,
  the Tally's record, byte for byte; and the Audio device (`audio`,
  `ENGINE.4`): a double of the Web Audio graph handed to the host as its
  audio context, every node and call recorded with its time on a clock the
  oracle drives, held frame by frame to the page's own arithmetic of the
  timeline, the voices, the approach, the dip, a voice that is no voice and
  the silence at a stop, over the double's Audio sheet written by edits
  (frames on time, a long task, a stall's burst, Pause and Run, the page
  hidden and shown, rate 0, the unload) and, over the engine's module, the
  sound card's 240 frames, every frame's Audio sheet equal to the card
  computed by hand and its waterfall drawn by hand, the run as the host
  recorded it the card's committed replay, which `replay` plays to every
  frame of the card and to its golden, the Log's record; `replay` plays
  Sand's committed replay too, a person's painting session (`CART.2`'s
  second slice), every frame's Screen equal to Sand's hand (its block
  `hand-sand` since `ENGINE.16`) under the brush the replay's Input rows
  make, and its end its golden, the Tally's record; and Kairos's, the
  owner's two games (`CART.4`'s second slice), every frame's board and,
  since `ENGINE.16`, its Tally equal to Kairos's hand under the buttons the
  replay's Input rows press, and its end its golden, the Tally's record;
  and Superposition's, the owner's session at `CART.12`'s hand test,
  every frame's Tally, the sum of each row of its lattice,
  equal to Superposition's hand, a frame with no row a settle step after
  the engine's release, and its end its golden, the Tally's row sums;
  and the sound
  itself (`sound`, `ENGINE.4`'s second slice): the host's own voices over
  the double handed an `OfflineAudioContext`, a sequence of voice states
  rendered into samples and each frame measured between its own times
  against the graph's own waves rendered beside it, a settled frame's pitch
  within 0.1% of its note's and its rms within 4% of the volume over four
  times its wave's own, a rest below 0.0001 and no onset step over 1.5 times
  the wave's own; measured, never golden, and the one case that waits, its
  render paced by a chain of 0 ms tasks under a headless browser's virtual
  clock; and grid mode (`grid`, `ENGINE.8`): a grid cartridge's Screen drawn
  by the host's own viewport, held at frame 0 and after every frame to the
  record of the same window by the page's own reading of it and its own
  layout, never the viewport's: the window the Camera's, the viewport's
  top-left cell the window's corner and a person's scroll since, every
  visible cell's text, fill, alignment and place both ways, a formula's value
  once it has one and its text before, a look's fill, a style's and a
  column's each read back as a pixel, the selection kept, and the viewport
  emptied at the unload; the record the host drew the grid record at frame 0
  and the values record after it, held byte for byte to the grid record less
  its formula rows, and a values record written in the page read whole by a
  viewport of its own; over the double, a grid of 20 by 12 drawn through
  its looks, the pointer and a bound key read back from the Input sheet, and
  an edit made while the loop is paused said to wait for the frame Run
  brings; over the engine's module the grid card, twenty-four frames under a
  Camera an edit moves a column right at frames 10 and 20, its numbers too
  wide for their columns drawn as #s; and the tabs (`tabs`, `ENGINE.14`): a
  tab with no record clicked as a person clicks it, its sheet shown and held
  at the click and after every frame to the record of a window that holds
  every cell in view, a scroll with the loop paused viewing the new region at
  once, the pointer and the wheel over another sheet the viewport's and a
  bound key still the game's, the Screen's tab giving back the Camera's
  window an edit moved meanwhile, and on the Screen the wheel counted over a
  cell of the window and never over the column header, the tab strip or a
  scrollbar; over the double its State sheet, over the module the grid
  card's Clock, the frame's number drawn at every frame.
  One line a case into `<pre id="loop">` once the last has answered,
  which `tools/check_host_loop.ps1` reads. `?loop=1&cases=abi,grid` runs
  those cases alone, in the list's order, and names them in the header; the
  check's control runs each mutant page so, with `abi` and the cases its
  reason is judged by, the `replay` case after `input`, whose live run it
  copies.
- `index.html?blit=1` is the blit's instrument, the engine's second number:
  a 320 by 200 plane drawn through the host's whole frame over the double
  120 times at the scale that fits the screen and 120 at a scale of 1, and,
  when the page holds the engine's module, the same path over it (`engine`,
  `ENGINE.2`): Life stepped once to its soup, then that frame redrawn 120
  times at the scale that fits, the step left out as the evaluator's; and
  the grid card the same way (`grid`, `ENGINE.8`'s second slice), its frame
  drawn again 120 times through the viewport from the values view in a box of
  the screen's size; and the still card's frame path (`still`, `ENGINE.17`),
  stepped and drawn 120 times as the loop draws it, a day's boundary drawn
  every 30 frames and the frames between still, which its row counts; each
  frame's main-thread cost, printed as the table and the baseline lines for
  `tools/check_blit_floors.ps1`, which holds the six cases from one run; and
  since `CART.12` Superposition's acts (`act`), the large board loaded
  through the host with the seed 1, then the floors' scripted player's acts,
  20 to warm and 120 timed, each made by its command on the cell the
  viewport's selection stands on and timed from before the command to a
  task queued after the rendering of the frame that drew its settle's end,
  its bar one display interval at its p95, the page's hand following every
  act and holding the Tally at the end. Run it in Chrome in fullscreen.
- `index.html?oracle=1` runs the render oracle and prints one line a case
  into `<pre id="oracle">`, which the check reads under a headless browser;
  since `ENGINE.14` each line counts its #s, and `sparse_hashes` narrows the
  sparse record's column A until its three-digit numbers draw them.
- `index.html?bench=1` is the floors' instrument, the renderer benchmark of
  `KERNEL.3` over the viewport: the 10,000-line record at the normal window
  (40 rows by 15 columns) and at full screen, 120 steps of three rows and 20
  page steps, each draw's main-thread cost from before the call to a task
  queued after the frame's rendering, printed as a Markdown table and as the
  baseline lines for `tools/check_render_floors.ps1`. Run it in a real
  browser in fullscreen; a headless run's clock is virtual and its numbers
  are not a measurement.
- `index.html?frames=1` is the frame floors' instrument (`CART.1`), the
  engine's first number: the engine's module stepped over the benchmark's two
  fixtures, Life's soup and the glider gun, and since `CART.2` Sand's
  opening, 31 frames each (`&n=` sets it, at most 80),
  each step timed alone with no budget and every frame's plane held to the
  page's own Life, or its own Sand (`sandStep`), so a fast wrong answer is never a number; before
  each fixture's frames and after them the page's Life runs a fixed workload
  three times, the clock, and a run whose clock moved more than 10% prints
  no rows; never between two frames, where it slowed the frame after it
  (`CART.1`, 2026-10-12). A frame under twenty steps of the page's clock,
  the gun's, is timed in five runs of 128 frames, back to back, over frames
  32 to 671, the last frame held after them and every frame on a second
  instance. Since `ENGINE.9` it climbs the size ladder too: Life and the
  gun built here by the module's own pass at four and sixteen times the
  window's area, 640 by 400 and 1280 by 800, from their sources with the
  ladder's definition of their board, `board-size`, after the source's own,
  each held over its whole board and named by its cartridge's SHA-256 over
  LF, which the instrument holds to the native runner's; every row carries
  the module's memory after frame 4, a fresh module a fixture, and the slope
  is printed after the rows. Since `CART.12` Superposition's three rows
  follow, each over the committed lattice on a fresh module and held to the
  page's hand, `hand-superposition`: the idle frame in five runs of 1,000
  steps, an act's latency over the scripted player's 200 acts at 15%, its
  rows' cells a second taken at the 95th percentile, and the deepest cascade
  at 8%, the site the hand finds at the end of the largest opening's widest
  path observed and its settle timed whole. It runs at the page's load and
  synchronously, since `--dump-dom` writes a page at its load:
  `tools/bench_frames.ps1` runs it under headless Chrome, with Chrome's flags
  against backgrounding and its processes opted out of Windows' power
  throttling, which slows a background process by about 40% three seconds
  in, and reads `<pre id="frames">`. A step costs computation and no display,
  so a headless run is a measurement here. Opened by hand, the page freezes
  for about twenty-five seconds while it steps, then prints the same.

## For the first game: the API

The host hands the viewport a box and gets a grid inside it, with its own
canvas, its scroller and its tab strip, which wraps onto a further row when
its tabs outrun the box (`ENGINE.14`):

```js
var vp = new AlonzoViewport(document.getElementById('grid'), { record: text });
vp.on('select', function (s) { /* s.text is 'B2:C3'; s.focus.sentence the row that wrote B2 */ });
```

`AlonzoViewport` is a global set by the script; `AlonzoViewport.version` is
2, since `ENGINE.20`'s repaint. The options: `record`, a record's text to
load at once; `colors`, any of the defaults below; `showHidden`, whether
hidden sheets' tabs show at first; `willReadFrequently`, a canvas the CPU
rasterizes from the first paint, for a page that reads its pixels back
(`ENGINE.20`): Chrome moves a canvas read back often from the GPU to the
CPU midway, and the two rasterize text apart.
Beside the constructor, `AlonzoViewport.readRecord(text)` reads a record
into the model the viewport draws, and `AlonzoViewport.readForms(text)`
reads any text of forms into data, the host shim's one reader.

| Method | What it does |
|---|---|
| `load(text, options)` | reads a record; its sheet becomes a tab, replacing an earlier record of that sheet; the record's `sheet` rows become the tab strip; returns the counts (`sheet`, `lines`, `cells`, `formulas`, `values`, `texts`, `styles`, `sentences`, `looks`, `rows`, `unknown`, `malformed`, `window`, `extent`, `readMs`). With `{ keep: true }` (`ENGINE.8`), a later frame of the sheet shown: the record replaces the last with the scroll, the selection, the widths, the frozen panes and the marks kept and no event raised, the tabs remade only when the sheet rows changed; the host draws every frame of a grid cartridge so, a still one excepted (`ENGINE.17`), and the player's sheets viewer its sheet |
| `patch(text)` | a window's changes laid on the model of their sheet (`ENGINE.19`), the text a view of the projection `changes` answers: each named cell's entry read again from its rows as `load` reads them, a cell put in or an empty one taken out, the model's counts and lines kept as a load of the patched record makes them, the model object, the scroll and the selection kept, and the sheet shown painted again: the named cells alone (`ENGINE.20`), each cell's band of its row with the span its text spills over and the span of a text on its left that spills into it, before the patch and after, painted again by the full paint's own steps under each band's clip, the rest of the canvas kept, wherever the canvas holds the model's full paint, unscrolled and unresized since, and the cells named are no more than a quarter of the cells in view; whole otherwise. Returns the counts as `load` does, with `patched` the cells named and `patchMs`; `false`, and nothing changed, for a whole answer, another window, a sheet it holds no record of, rows that are no cell's of the window, or a model holding a row its reader counted unknown or malformed |
| `patches()` | the patches laid on its models since it was made: a host notes the count with each record it loads, so that a model a page patched is never taken for the host's (`ENGINE.19`) |
| `repaints()` | the patches it painted by their cells alone since it was made, the others painted whole (`ENGINE.20`) |
| `clear()` | forgets every record, every layout learned and every bound, and draws the grid empty: the host's grid unloaded (`ENGINE.8`) |
| `learn(text)` | reads a record of a sheet for its layout alone (`CART.12`'s hand test): its columns and rows with settings and its extent, inside its window, the cells and the model shown untouched; a column past the window a later record is viewed through is then laid as the sheet sets it and not at the default width. Returns `{ sheet, window, extent, columns }`, or null for a text that is no record of a sheet |
| `fresh(name)` | the range a sheet shows from `A1` in the box, its columns as its layout lays them and its rows at the default height, inside a bound sheet's extent: the window a host views a sheet through before it shows it |
| `bound(name, on)` | whether a sheet is drawn to its extent and no further, its last row and column the grid's, no slack after them (version 6's `(bound "<sheet>")`): the host says so for each sheet its cartridge bounds |
| `scrolled()` | the window the scrolled quadrant shows, `{ top, left, bottom, right, window }`: the host follows a Camera's move by it (`ENGINE.8`) |
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
| `cellAt(clientX, clientY)` | the cell under a point of the page, or null: over a header, the corner, a scrollbar or the tab strip (the last two since `ENGINE.14`, which the hit test had counted as cells) |
| `cell(row, col)` | a cell: `{ row, col, address, kind, vkind, text, value, formula, valued, style, sentence }`, `kind` one of `cell`, `formula`, `empty`; `text` what the cell shows, a formula's value once its value row lands and its text before, the text a code draws where the record holds a `text` row (`CART.12`); `value` the value as the record spells it, empty for a formula with none yet; `formula` a formula's own text, the bar's, and `valued` whether a formula has its value |
| `geometry()` | the last draw's geometry in device pixels: the ratio, the sizes, the row height, the column edges, the frozen bands, the scroll |
| `draws()` | the draw list: every text, fill, line, header, selection and mark with its position, as the last full paint drew it, each cell a repaint drew since in its place, in the full paint's order (`ENGINE.20`), so that it describes the canvas op for op (the oracle's) |
| `model()` | the record shown, as read |
| `redraw()` | sizes the canvas to the box again and draws |
| `destroy()` | removes the viewport and its listeners |
| `on(name, fn)` / `off(name, fn)` | the events |

| Event | When, and what it carries |
|---|---|
| `select` | the selection changed by a click, a drag, a key, `select()`, or a sheet shown, which puts it at that sheet's A1: `{ sheet, text, kind, range, focus }` |
| `scroll` | the window moved, by a scroll or, since `CART.12`'s hand test, a resize of the box, full screen's among them: `{ sheet, top, left, bottom, right, window }`, the rows and columns in view and their range text |
| `columnresize` | a column's edge was dragged: `{ sheet, column, width }` in CSS pixels |
| `sheet` | a tab was chosen or a record shown: `{ name, loaded, state }`; `loaded` false asks the host for that sheet's record, which the engine's host answers with `answer(viewport, event)` (`ENGINE.14`) |
| `cellopen` | a cell was double-clicked or Enter pressed on it: `{ sheet, address, row, col, cell }`; the first game's chrome opens the pane at the sentence here |

The keyboard, with the grid focused: the arrows move the selection and bring
it into view, Shift with them extends it, Page Up and Page Down move by a
screen, Home and End go to the first and the last column of the sheet, Ctrl
with them to the first and the last cell, Enter raises `cellopen`. A tab
chosen, by its click or a key that clicks it, gives the grid the keys, so the
arrows move the selection on the sheet shown; a box being typed in keeps them
(`CART.12`'s hand test). A bound sheet's last row and column end the
selection, the scroll and the hit test: past them there is no cell.

**The rules of the record, as the viewport reads it.** A column's width is
the record's number, the file's stored width in characters, turned into CSS
pixels by ECMA-376's rule with a maximum digit width of 7 (Calibri 11 at 96
DPI): 72 is 504 px and 60 is 420 px; a column with no row is 64 px, Excel's
default; a hidden column is skipped; a column's format fills its empty cells.
A row is 20 px, the headers one row high, the text 13 px `system-ui`. A
`cell` row shows its value aligned as Excel aligns it under General: a
number right, a text left, `TRUE`, `FALSE` and an error centered, a date as
the text inside, right; under a `text` format everything left; under a code,
the text of its `text` row where the record holds one, aligned by its value
as under General (`CART.12`). A `formula`
row shows the formula's text, left, in green. A nowrap text spills into the
empty cells to its right and stops at the first that holds anything; a
number never spills, and a number or a date under General or a code whose text is
wider than its column draws as many `#` as fit, as Excel fills a cell under
a fixed number format, never a cut text (`ENGINE.14`); a wrapped text is
broken at the column's width and the lines that fit the row are drawn, and
a number is never wrapped. The layout is in device pixels, every size
an integer of them, every gridline at an integer plus a half, so the image
is crisp at the machine's ratio, and the backing store is remade when the
ratio changes. A line in an opaque color is filled as a rectangle one
device pixel wide, which every rasterizer covers exactly, so that a
repaint's few lines paint the full paint's pixels (`ENGINE.20`).

**The colors** are options with defaults: `background` `#ffffff`,
`gridline` `#d9d9d2`, `header` `#f3f3ee`, `headerText` `#6b6b66`,
`headerSelected` `#e2d8f6`, `text` `#1d1d1b`, `formula` `#0a6b4f`,
`selectionFill` `rgba(226, 216, 246, 0.45)`, `selectionBorder` `#6b4fc8`,
`frozenLine` `#b9b9b0`, `tabBackground` `#f3f3ee`, `tabActive` `#ffffff`.
The viewport paints the record and these, and nothing of its own.

**Taking a copy.** Frazaro's page takes `viewport.js` as a file, held byte
for byte to this one by a check on its side; a change here is a copy there,
in one reviewed commit. It holds no copy yet (2026-10-14): the copy is a
Frazaro item the owner mints, and `ENGINE.14`'s #s and its hit test travel
with the file at that take.

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
  not, and `{{BLOCKS}}` with every text the page holds, a block each
  (`ENGINE.15`, below): the page's name, each cartridge in the order the
  builder names, `cartridges/<name>/<name>.vla`, with its source, replay and
  golden beside it, each library, `cartridges/<name>.vla`, and each fixture,
  `fixtures/<name>.vla`, the order held to the folder both ways; `-Template`, `-ViewportJs`, `-FakeJs`, `-HostJs`,
  `-FixturesDir`, `-CartridgesDir`, `-Wasm`, `-NoWasm` and `-Out` exist for a
  check that builds a page from mutated sources, never for the real page, and
  `-PageOrder` for a check's page of a scratch folder (`ENGINE.16`).
- **A game's page** (`ENGINE.15`): the template names no game's file, so a
  game vendors the template and the three scripts unchanged and fills them
  with a builder of its own. Its builder fills the same five places, the
  three scripts, the module and `{{BLOCKS}}`, writing each text as
  `<script type="text/plain" id="KIND-NAME" data-path="PATH">TEXT</script>`,
  the path the file's from its repository's root, and refusing a text that
  holds `</script`:
  - `page-name`, the name the bar and the title show (Alonzo here);
  - `cartridge-<name>`, with `data-file`, the file name a load passes on,
    the picker offering the cartridges in the order their blocks stand;
  - `source-<name>`, its source, and `replay-<name>` with `golden-<name>`
    when it has them;
  - `library-<name>`, each library a source includes, at the path the
    source's includes resolve to, so that Build in the drawer runs the pass
    over them as the command line does;
  - `hand-<name>` (`ENGINE.16`), the game written a third time in
    JavaScript, the one block that is a script:
    `<script id="hand-NAME" data-path="PATH">TEXT</script>`, which the page
    runs where it stands and never through `eval`. It registers one
    constructor under its cartridge's name,
    `(window.AlonzoHands = window.AlonzoHands || {}).NAME = Hand`. The page
    makes it with the replay's seed, `new Hand(seed)`, and asks it
    `hand.frame(n, rows)` for each frame of the cartridge's committed replay,
    n from 1 and the frame's rows as the page's reader reads them. It answers
    `{ plane }`, the Screen's window row by row, held byte for byte to the
    host's plane, and or `{ cells }`, `{ "Sheet!A1": value }`, each value a
    number, a text, `true` or `false`, or `null` for an empty cell, held to
    that sheet's record at that frame; a grid game answers cells. An optional
    `hand.counts()` names counts of its own. Alonzo's three,
    `cartridges/sand/sand.hand.js`, `cartridges/kairos/kairos.hand.js` and
    since `CART.12` `cartridges/superposition/superposition.hand.js`, are the
    examples, Kairos's answering both and Superposition's the Tally's sum of
    each row of its lattice, a frame with no row a settle step after the
    engine's release; it also lends the frames and blit instruments its
    lattice, its scripted player and its deepest deal.

  The page opens on the empty sheet whatever it holds and offers its
  cartridges in the picker, each by its manifest's title, its notes in the
  drawer. A page that does not hold Alonzo's own cartridges and records is
  a game's (`ENGINE.16`). Its `?loop=1` runs the twelve cases that need
  nothing of Alonzo's own files, over its own blocks: `abi`; `pass`, every
  source to its cartridge; `replay`, every replay to its golden and its
  recording, every frame to its hand; `grid`, every grid cartridge's drawn
  window held to its record for frame 0 and twelve frames with no edits, a
  version 4 cartridge's sheet shown held as the record of its region
  (`ENGINE.18`); `empty`; `still`, the page's own still card (`ENGINE.17`);
  `views`, the page's own views card (`ENGINE.18`); and `changes`, the
  page's own changes card, a frame read by its changes (`ENGINE.19`), each
  patch repainted by its cells and held pixel for pixel to a full paint
  (`ENGINE.20`); `continue`, the page's own continue card, its source
  rebuilt and applied as it runs (`ENGINE.7`); `palette`, the palette's
  keys, lines and second Escape over the page's own registry (`ENGINE.23`);
  and `keys`, the page's own keymap read, crafted ones refused by line, a
  key's command in each place, a person's own command's steps and the
  keymap kept through a double of the browser's storage (its second slice);
  and `commands`, the page's own command card, a game's commands named,
  listed and bound, and run by name and by key into the Input sheet's
  twentieth row (`ENGINE.25`); and `settle`, an act settled at rate 0 over the
  double and over the page's own settle card, a press over a cell an act, the
  settle stepped and drawn, an act waiting for it and its replay rowless at
  the settle's frames (`CART.12`). Each of
  the fifteen others prints
  `case <name>: not on this page`, being proven in Alonzo's CI, and the
  last line reads `loop ok cases=13 dpr=1; 15 of Alonzo's own not on this
  page` at a ratio of 1. A replay with no hand is held to its golden alone, counted `alone`
  and said in a note under the case. Every other mode of the bench is
  Alonzo's own and says so on a game's page; `?frames=1` and `?blit=1` over
  a game's own fixtures are a later slice.
- **A change to the host** is held by the loop's oracle, whose expectations
  are the page's own and never the host's, under
  `tools/check_host_loop.ps1`, and the blit by the owner's measurement under
  `tools/check_blit_floors.ps1`. A loop that changes on purpose is first
  reworded in `docs/SPEC.md` section 5, then in the page's oracle.
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

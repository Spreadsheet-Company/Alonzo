/*
  SPDX-FileCopyrightText: 2026 Spreadsheet Company
  SPDX-License-Identifier: Apache-2.0

  web/host.js - the host shim: the loop of docs/SPEC.md section 5 over the
  engine's module (ENGINE.1). It instantiates nothing it was not handed and
  imports nothing: a page gives it a module's exports, the engine's own or
  the fake module's (web/fake.js), and it asks the ABI number before
  anything else and refuses another (section 8.1). Then it runs the frame's
  order of operations: the tick of the animation frame with a fixed
  timestep and an accumulator, a tick's time capped at a quarter of a
  second and the backlog at the larger of that and one frame's interval,
  with no interpolation and no skipped frame, paused while the page is
  hidden; the
  derived writes of the Write sheet before the inputs, each its own write
  of one derived row; the Input sheet's eighteen rows from the keys it
  holds, mapped through the Keys sheet, and the pointer, written as the
  Screen's own cell through the Camera of the frame the person sees; a
  person's edits, each its own write; the step with a budget in cells,
  which may yield and continue on the next tick, its progress a sentence
  (SD-34); the effects read after the step, the Camera first and the
  Palette, so that a frame is drawn through its own Camera and colors,
  then the Screen as the plane through the Camera's window, the Keys, the
  Audio rows, the File's save cell, the Write sheet and the Clock's rate,
  which a person may write and the loop then steps at; and the blit, the
  plane's bytes through the palette into an ImageData drawn at a whole
  number of device pixels a cell, magenta past the palette. At rate zero
  there is no tick: one step for each edit, and no Input. At a load whose
  manifest says (seed host) the host chooses the seed, its one write of its
  own (ENGINE.3).

  A grid cartridge (docs/SPEC.md section 3.1; ENGINE.8) is drawn by a viewport
  of the host's own (web/viewport.js) over an element the page hands it:
  frame 0 at the load and each frame after, the record of the Screen
  through the Camera's window, every frame's record replacing the last with
  the person's scroll and selection kept, and the viewport scrolled by the
  Camera's move. Its tabs are answered (ENGINE.14): a sheet clicked is
  viewed and shown, and while it shows, each frame and each scroll view it
  alone, through the region the viewport shows and never the sheet whole;
  the Screen's tab gives the Camera's window back. A page's own viewer of
  the sheets is answered the same way (showSheet, refreshSheet, answer). At
  a rate above zero the keys the Keys sheet binds are the Input sheet's,
  and so, while the Screen shows, are the pointer over the cells of the
  Camera's window, its buttons and the wheel there; over the tabs, the
  headers and the scrollbars, and over another sheet, they are the
  viewport's, to scroll and select by, and at rate zero all of them are.

  A grid cartridge written to version 4 (ENGINE.18) has its views on its
  own sheets. It opens on the sheet its Camera's third row names, else on
  its first visible sheet, so a Screen it hides is never opened on; a
  change of that row shows the sheet it names at the frame's end, the
  person's tabs winning between its changes, as the person's scroll wins
  between the Camera's moves. The Input sheet's nineteenth row names the
  sheet shown, and the pointer and its buttons over any cell of it are the
  game's, that sheet's own cell. Every sheet the host draws, for any
  cartridge, is the values record after frame 0, as the Screen's frames
  have been since ENGINE.8's second slice. A cartridge written to 1 to 3
  opens, points and replays as before.

  A cartridge written to version 5 (ENGINE.25) has commands of its own, its
  Commands sheet's rows, read at the load and after each step: each a name,
  its words, whether it holds now and its key. command(name) runs one, as a
  page's palette or a person's binding asks, and commands() lists them; the
  host takes a command's key on the Screen while the command holds and no
  Ctrl, Cmd or Alt is held, a repeat taken and running nothing. A command
  waits for the next frame, one a frame and sixteen at most, and is written
  into the Input sheet's twentieth row for that frame alone; at rate 0 each
  steps the grid once, the twentieth row written alone before every step;
  and while a replay plays, a command is refused, as an edit is. A cartridge
  written to 1 to 4 has no commands, a sheet of its named Commands its own.

  A frame is read by its changes (ENGINE.19), the language's report of the
  cells of a window the last frame changed (docs/SPEC.md section 4.5). The
  frame's own draw of the Screen, or of a sheet in its place, and a page's
  refresh that passes still, ask a window's changes before its view, while
  the viewport still holds the values record the host noted for it: cells
  named since that record's frame are laid on the held text, by cell, and on
  the viewport's model in place, a patch; none named is a still frame; and
  an answer of whole, another window or another frame views as before. A
  load, a tab, a scroll and redraw() always view. Every device sheet is read
  the same way, its cells kept and patched, and only the Input rows that
  differ from the rows last written are written, all of them after a
  person's edit of the Input sheet, a replay's rows or a refused write. The
  language prints a text's line feed raw, so a row holding one runs over the
  record's lines, and a record is read by its rows and not its lines (ENGINE.36).
  A cell's lit row, the rules whose answer is true at it, is one of its rows, so
  that a frame whose answers alone moved patches its cells (ENGINE.37).

  And it sounds the Audio sheet (docs/SPEC.md section 3.6; ENGINE.4): after each
  frame, once the Clock's rate is read, its four voices, each the Web Audio
  graph's own oscillator and gain and nothing else, scheduled on the audio
  clock and never on the animation clock. A frame sounds where the last
  frame's sound ends, while that lies within twice a lookahead of 50 ms
  ahead of the audio clock; a frame whose time has passed starts the
  timeline again a lookahead ahead, and a frame past the window is not
  sounded, the timeline staying where it was. A voice's gain is its volume
  over four, approached by the graph's setTargetAtTime with a time constant
  of 3 ms; a wave changed is a new oscillator, through a dip while the voice
  sounds; a cell that is no voice silences its voice for the frame, said
  once. The sound is on only after a person's act, the panel's Sound on, as
  Chrome's autoplay policy asks, and it stops with the loop.

  Beside the loop it runs the pass (docs/SPEC.md section 7.8, SPEC.3's second
  slice): a cartridge's source, its path and the texts it includes handed to
  the module's twelfth export, alonzo_expand, an act of its own that takes no
  handle and touches no grid, its answer the cartridge's text for a page to
  show before anything loads it. The export is asked for at the act and not
  at the attach, since the fake module holds no pass and still drives the
  loop; over a module without one, a build is declined in words.

  And it continues the running game with a rebuilt cartridge (docs/SPEC.md
  section 7.8; ENGINE.7), edit and continue: apply(text) compares it with the
  cartridge the grid was last given, the one loaded or the one last applied,
  each cell or formula row by its sheet and its address, and writes the rows
  it changed or added as one person's edit at the next frame's start, the
  frame number and every other cell kept; the replay records them as a
  person's edits in their frame, under the header of the cartridge loaded.
  What a write cannot carry, a line of the manifest, a sheet added or removed,
  a row that is no cell or formula row, or a cell a removed row wrote that no
  rebuilt row writes, is named in words with Load offered, and nothing is
  written; and the rebuilt cartridge is first loaded in a second handle and
  given back, so that nothing Load would refuse is applied.

  And it keeps the replay (docs/SPEC.md section 7.6; ENGINE.3's second slice):
  every write a load's run makes, from frame 0, recorded as the replay's
  rows, the Input rows as the cells that changed and each person's edit
  that landed in its frame, the derived writes never, under a header that
  names the cartridge by the SHA-256 of its text with LF line ends, a
  synchronous digest of the host's own, and the seed; replayText() answers
  it. play(text) loads the cartridge again with the replay's seed and plays
  its frames through the loop at the cartridge's rate, each frame's rows
  one write after the derived writes, in place of the live inputs, a
  person's edits refused while it plays and the loop paused at its last
  frame; play(text, true) plays every frame at once, for an oracle. The
  recorder records what is played, so a replay played and copied is the
  replay played.

  And it keeps the run's work for a page to keep in the browser (docs/SPEC.md
  section 7.9; ENGINE.38): a keyframe, a cartridge, at first the one the load
  took and then a save at rest, and every frame since as a replay's frames,
  numbered from the frame the keyframe opens at, beside the recorder's and
  free of its cap. A keyframe is taken at a frame's end at rest once the
  steps since the last have cost a second or twenty times the last
  keyframe's own cost, whichever is more, or the frames kept pass 1 MiB of
  text; keyframeNow() takes one for a page whose tab hides. keptWork(since)
  answers the keyframe and the frames to the last frame at rest, and whether
  a person has acted, a run no person acted in keeping nothing a page keeps;
  keepSaved() takes the page's word that a save was written to a file;
  restore(work) opens the keyframe as a load and plays the frames at once,
  the replay law, and pauses there.

  A paste (ENGINE.39's second slice) is a person's act as an applied
  cartridge is: paste(p) takes the rows a page wrote from the clipboard's
  text, or from its own copy, and writes them at the act's frame as one
  write, all or none, one step at rate 0, each row recorded as a person's
  edit in its frame; it refuses, saying why, a replay playing, a read-only
  sheet, a value into a game sheet a person writes and a cell past an edge.
  cellsOf(sheet, range) answers a range's cells as the sheet is drawn, a
  copy's, and since the third slice its formulas as fills; moved(text,
  dRow, dCol) a formula's text moved by the language's mover, the module's
  thirteenth export; extentOf(sheet) a sheet's extent; and sayAct(text)
  says a page's own act's answer, its copy's and its cut's. An edit, an
  applied cartridge and a paste that land tell their rows ('wrote').

  Undo and redo (ENGINE.30's first slice) are Excel's, on work sheets at
  rate 0: undo() takes back a person's last edit, paste or cut's move, its
  cells written back as one act as the record of the cells as written held
  them just before it, and redo() writes the act again; each answers the
  sheet and range a page shows and selects, or refuses, saying why: a rate,
  a replay playing, an act still computing, a cell the cartridge has written
  since. The watches (its second slice) are a debugger's watchpoints:
  setWatches(list) the keymap's, each a cell and maybe a value, standing;
  watch(sheet, address) the command's, the cell's next change, once; and
  unwatch() forgets the command's. At every frame's end each watched cell is
  read, and a watch that holds is said, the run paused at that frame at a
  rate or while a replay plays, never a frame late, and a replay played at
  once stopping there.

  What the host holds is SD-23's interface state and nothing else (AD-6):
  the keys held, the pointer's place, the accumulator, the budget's
  measurement, the palette's table, the key map, the Camera's two cells,
  the derived rows waiting for the next frame, the replay's record and the
  frames a replay has left to play, the audio context with the voices'
  nodes and the timeline's end, and since ENGINE.19 the records it holds
  with their frames, the device sheets' cells as last read and the Input
  rows last written, and since ENGINE.7 the text of the cartridge the grid
  was last given, and since ENGINE.25 the commands waiting for their frames,
  and since ENGINE.38 the run's work kept, its keyframe's text and the frames
  since, and since ENGINE.39 the moment the last act came to rest, which a
  held key's repeat is judged by, and since ENGINE.30 the run's line of a
  person's acts at rate 0, each with the cells it replaced, and the watches
  with each one's last value. Every value is the module's.
  Every refusal and every event is a sentence, the latest new one in the
  status and the last twenty events in a log, a repeat of an event counted in
  the line it first made rather than pushing the others out (SD-30), and a
  refusal or a failure is marked as one, so that a page paints every refusal
  one color. Every view over the module's memory is made fresh for each
  read, since any growth of the memory detaches the buffer the earlier views
  were made over. A page hears four events: status, a sentence; load, frame 0
  drawn; frame, a frame completed; and stop, a running loop stopped at its
  frame, so that what a page shows of the grid can be drawn at the frame the
  frame line says.

  It reads every record with the viewport's reader (web/viewport.js,
  AlonzoViewport.readForms), which must load first: the shim holds no
  reader of its own.

  Plain script, no module syntax, no library, nothing fetched: one global,
  AlonzoHost, set by this closure. The API is documented in web/README.md.
*/
(function (global) {
  'use strict';

  // ---- the rules of the loop, as ENGINE.1's scoping states them (decisions 4 to 8) ----
  var ACCUMULATOR_CAP_MS = 250;      // Fiedler's cap, on a tick's time; and on the backlog, unless one frame's interval is longer:
                                     // a stall runs seven frames at 30, never thirty, and a rate under four a second still steps
  var FIRST_BUDGET = 2000;           // the cells of a step call before a rate is measured: about 9 ms of the
                                     // engine's own module (226,000 to 236,000 cells a second in Chrome,
                                     // measured 2026-10-09), where 16,000 held the page for about 70 ms
  var MIN_BUDGET = 1000;             // the least a measured budget asks for
  var SLICE_FRACTION = 0.75;         // the share of the display's interval the steps of one tick may spend: three
                                     // quarters since CART.2's water (decision 20), whose heaviest seconds step in
                                     // 22.6 to 24.9 ms, presented at 20 to 22 frames a second at a half and at 30 here
  var INTERVAL_SAMPLES = 30;         // the display's interval is the median of the first thirty deltas
  var DEFAULT_INTERVAL_MS = 1000 / 60;
  var SNAP_MS = 0.25;                // a tick's time this near the grid of the frame's interval is put on it: the
                                     // display's timestamps jitter by a tenth of a millisecond, and a remainder at
                                     // the accumulator's threshold made some ticks present two frames and some none
                                     // (CART.2's playtest pass, 2026-10-12: Sand at 60 presented 38 to 40 a second)
  var TIMER_FLOOR_MS = 0.1;          // a step faster than the timer's grain is measured at the grain
  var LOG_LINES = 20;
  var HISTORY_LINES = 2000;
  var MAX_SEED = 2147483646;         // the highest seed, so a Park and Miller cell never sticks at 0 (section 3.5)
  var MAX_RATE = 120;                // the highest rate, in frames a second (section 10)
  var SPEC = 9;                      // the page's version this host implements; a replay's header names its
                                     // cartridge's, 3 for a cartridge written to 1 to 3 (ENGINE.18, decision 7)
  var MAX_COMMANDS = 100;            // a Commands sheet's rows 2 to 101 (ENGINE.25; docs/SPEC.md section 3.10)
  var COMMANDS_WAITING = 16;         // the commands that may wait for their frames, one a frame: a seventeenth is said
                                     // and dropped (ENGINE.25, decision 3)
  var MAX_CARTRIDGE_BYTES = 16 * 1048576;   // section 10's file, which the engine refuses to load past (ENGINE.5)
  var REPLAY_CAP = 8 * 1048576;      // the replay's text, past which the recorder stops and says so: about an
                                     // hour of a pointer that never rests (ENGINE.3, decision 10)
  var KEEP_STEPS_MS = 1000;          // the work kept (ENGINE.38, decision 2): a keyframe at rest once the steps since the
  var KEEP_COST_TIMES = 20;          // last have cost a second, or twenty times that keyframe's own cost if more, so that a
                                     // keyframe costs at most a twentieth of the stepping and a restore plays about a
                                     // second of steps; Superposition's save of 176 ms, its steps 3.5 s (measured)
  var KEEP_FRAMES_CAP = 1048576;     // or once the frames kept since it pass 1 MiB of text
  var KEPT_NOT_ACTS = { B11: true, B12: true, B19: true };   // the Input rows no person's act: the pointer's place, and the
                                     // sheet shown, which a cartridge's Camera moves too (ENGINE.38, decision 4)
  // ---- the sound's rules, as ENGINE.4's scoping states them (decisions 1 to 4) ----
  var LOOKAHEAD = 0.05;              // s: a frame that starts the timeline sounds this far ahead of the audio clock,
                                     // and no frame sounds further ahead than twice it
  var GAIN_TAU = 0.003;              // s: every change of a voice's gain approaches its value by the graph's setTargetAtTime
                                     // with this time constant (measured: no onset step over 1.33 times a wave's own down to
                                     // 55 Hz, where a gain set at once steps 17 to 24 times it)
  var DIP_TAUS = 5;                  // a wave changed while the voice sounds: the new oscillator this many time constants on
  var VOICE_SHARE = 0.25;            // a voice's gain is its volume times this, so four voices at full volume never clip
  var RELEASE_TAUS = 10;             // an unload stops the oscillators this many time constants after their silence
  var MAX_NOTE = 127;                // MIDI's highest note, below every Nyquist frequency from 25 kHz
  var WAVES = ['square', 'triangle', 'sawtooth', 'sine'];   // the OscillatorNode's own words
  var ABI = 1;
  var RULES = {
    abi: ABI, capMs: ACCUMULATOR_CAP_MS, firstBudget: FIRST_BUDGET, minBudget: MIN_BUDGET,
    sliceFraction: SLICE_FRACTION, snapMs: SNAP_MS, intervalSamples: INTERVAL_SAMPLES, logLines: LOG_LINES,
    lookahead: LOOKAHEAD, gainTau: GAIN_TAU, voiceShare: VOICE_SHARE
  };
  var EXPORTS = ['alonzo_abi_version', 'alonzo_version_text', 'alonzo_alloc', 'alonzo_free', 'alonzo_load',
                 'alonzo_describe', 'alonzo_write', 'alonzo_step', 'alonzo_view', 'alonzo_unload'];
  var PLAYERS = ['B', 'C', 'D', 'E'];
  var enc = new TextEncoder(), dec = new TextDecoder('utf-8');
  var LITTLE = new Uint8Array(new Uint32Array([1]).buffer)[0] === 1;

  function VP() {
    var v = global.AlonzoViewport;
    if (!v || !v.readForms) throw new Error('web/host.js reads records with web/viewport.js, which must load first');
    return v;
  }
  function sym(d) { return d && d.sym !== undefined ? d.sym : null; }
  function str(d) { return typeof d === 'string' ? d : null; }
  function num(d) { return d && d.num !== undefined ? d.num : null; }
  function valueOf(d) {
    if (typeof d === 'string') return d;
    if (d && d.num !== undefined) return d.num;
    if (d && d.sym === 'true') return true;
    if (d && d.sym === 'false') return false;
    if (Array.isArray(d) && sym(d[0]) === 'error') return { error: str(d[1]) };
    return null;
  }
  function quote(s) { return '"' + String(s).replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"'; }
  function spell(v) { return typeof v === 'string' ? quote(v) : (typeof v === 'boolean' ? (v ? 'true' : 'false') : String(v)); }
  function thousands(n) { return String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }
  // The article a number takes as it is spoken: an 8, an 11, an 18, an 80 to 89, an 800 to 899, and their
  // thousands; a for the rest (ENGINE.14: the load said "a 80 by 50 grid").
  function article(n) { var s = String(n); return /^8/.test(s) || /^1[18](\d{3})*$/.test(s) ? 'an' : 'a'; }
  // The Screen's name, as a viewport names the sheet it shows; nothing shown yet is the Screen.
  function isScreen(name) { return !name || String(name).toLowerCase() === 'screen'; }
  // A cell's value as one text, to tell whether it changed between two reads: empty for an empty cell, a formula
  // before its first value and the empty text alike (ENGINE.18, the Camera's third row).
  function valueKey(v) { return v === null || v === undefined || v === '' ? '' : (typeof v === 'object' ? 'error ' + v.error : typeof v + ' ' + v); }
  // A cell's value as a notice shows it: a text in quotes, an error by its name, a number or a truth value as itself.
  function shownValue(v) { return typeof v === 'string' ? '"' + v + '"' : (v && typeof v === 'object' ? 'an error, ' + v.error : String(v)); }
  // A cartridge's command's name (ENGINE.25; docs/SPEC.md section 3.10), as a cartridge's own name is spelled: lowercase
  // letters, digits and hyphens; and a key's code, as a Keys sheet spells one (section 3.4): KeyB, Digit1, Space, F2.
  var COMMAND_NAME = /^[a-z0-9-]+$/;
  var KEY_CODE = /^[A-Z][A-Za-z0-9]+$/;
  // ---- the key language: the page's keymap's, and since version 7 a Commands sheet's (CART.3's second slice, decision
  // 14; docs/SPEC.md section 3.10), one parser and one match, so that a page and a cartridge spell a key alike ----
  // A key's spelling read: modifiers joined by +, then the key. mod: 'either' for Ctrl, Ctrl or Cmd as ENGINE.22 takes
  // them; 'control' for the Control key alone; 'meta' for Cmd alone. kind: a letter, which matches the key that types it,
  // so that a mnemonic follows the person's layout, or on a layout whose keys type no Latin letter the key in its place;
  // a digit, by its key on the top row or the pad; a named key, as KeyboardEvent.key names it; a code in brackets, the
  // key's place; or a character. text: the spelling printed back.
  var KEY_NAMES = { enter: 'Enter', escape: 'Escape', esc: 'Escape', tab: 'Tab', backspace: 'Backspace', delete: 'Delete', insert: 'Insert', home: 'Home', end: 'End',
                    pageup: 'PageUp', pagedown: 'PageDown', up: 'ArrowUp', down: 'ArrowDown', left: 'ArrowLeft', right: 'ArrowRight', arrowup: 'ArrowUp', arrowdown: 'ArrowDown',
                    arrowleft: 'ArrowLeft', arrowright: 'ArrowRight', space: 'Space' };
  // The modifiers of a spelling, its parts before the key: { mod, alt, shift } or { error }.
  function modifiersOf(parts) {
    var k = { mod: '', alt: false, shift: false, kind: '', value: '' };
    for (var i = 0; i < parts.length; i++) {
      var p = parts[i].toLowerCase(), m = p === 'ctrl' ? 'either' : p === 'control' ? 'control' : (p === 'cmd' || p === 'meta' || p === 'command') ? 'meta' : '';
      if (m) { if (k.mod) return { error: 'two of Ctrl, Control and Cmd' }; k.mod = m; }
      else if (p === 'alt' || p === 'option') k.alt = true;
      else if (p === 'shift') k.shift = true;
      else return { error: 'no modifier named ' + parts[i] + ': the modifiers are Ctrl, Control, Cmd, Alt and Shift' };
    }
    return k;
  }
  // The modifiers of a key as a spelling prints them, in the keymap's order, each followed by +.
  function modifiersText(k) {
    var mods = [];
    if (k.mod) mods.push(k.mod === 'either' ? 'Ctrl' : k.mod === 'control' ? 'Control' : 'Cmd');
    if (k.alt) mods.push('Alt');
    if (k.shift) mods.push('Shift');
    return mods.length ? mods.join('+') + '+' : '';
  }
  function parseKeys(spelling) {
    var parts = String(spelling).split('+'), key = parts.pop();
    if (key === '' && parts.length && parts[parts.length - 1] === '') { parts.pop(); key = '+'; }
    var k = modifiersOf(parts);
    if (k.error) return k;
    var fn = /^f([1-9]|1[0-9]|2[0-4])$/i.exec(key), code = /^\[([A-Za-z0-9]+)\]$/.exec(key);
    if (code) { k.kind = 'code'; k.value = code[1]; }
    else if (/^[A-Za-z]$/.test(key)) { k.kind = 'letter'; k.value = key.toLowerCase(); }
    else if (/^[0-9]$/.test(key)) { k.kind = 'digit'; k.value = key; }
    else if (fn) { k.kind = 'named'; k.value = 'F' + fn[1]; }
    else if (KEY_NAMES[key.toLowerCase()]) { k.kind = 'named'; k.value = KEY_NAMES[key.toLowerCase()]; }
    else if (key.length === 1 && key !== ' ') { k.kind = 'char'; k.value = key; }
    else return { error: 'no key named ' + (key || 'nothing') };
    k.text = modifiersText(k) + (k.kind === 'code' ? '[' + k.value + ']' : k.kind === 'letter' ? k.value.toUpperCase() : k.value);
    return k;
  }
  // Whether a key event holds exactly a key's modifiers: Ctrl or Cmd for Ctrl and never both, and Shift and Alt as written,
  // so that Ctrl+K is not Edge's Ctrl+Shift+K.
  function modifiersMatch(k, ev) {
    var ctrl = !!ev.ctrlKey, meta = !!ev.metaKey;
    if (k.mod === 'either') { if (ctrl === meta) return false; }
    else if (k.mod === 'control') { if (!ctrl || meta) return false; }
    else if (k.mod === 'meta') { if (!meta || ctrl) return false; }
    else if (ctrl || meta) return false;
    if (!!ev.shiftKey !== k.shift || !!ev.altKey !== k.alt) return false;
    return true;
  }
  // Whether a key event presses a key read by parseKeys: its modifiers exactly, then the key.
  function keyMatches(k, ev) {
    if (!modifiersMatch(k, ev)) return false;
    var key = String(ev.key || ''), low = key.toLowerCase();
    if (k.kind === 'code') return ev.code === k.value;
    if (k.kind === 'letter') return low === k.value || (ev.code === 'Key' + k.value.toUpperCase() && !/^[a-z0-9]$/.test(low));
    if (k.kind === 'digit') return ev.code === 'Digit' + k.value || ev.code === 'Numpad' + k.value || low === k.value;
    if (k.kind === 'named') return k.value === 'Space' ? key === ' ' : low === k.value.toLowerCase();
    return key === k.value;
  }
  // A command's key as a Commands sheet's column D writes it (docs/SPEC.md section 3.10): a KeyboardEvent.code, as the
  // Keys sheet spells one, and for a cartridge written to version 7 the keymap's modifiers before it, joined by +,
  // Ctrl+ArrowRight (CART.3's second slice, decision 14). { mod, alt, shift, kind: 'code', value, text, bare }, text the
  // spelling printed back in the keymap's order and bare whether it holds no modifier; { error } for any other text,
  // 'version 7' for modifiers a cartridge written to 1 to 6 writes.
  function commandKeyOf(text, seven) {
    var parts = String(text).split('+'), code = parts.pop();
    if (!KEY_CODE.test(code)) return { error: 'no key\'s code' };
    if (parts.length && !seven) return { error: 'version 7' };
    var k = modifiersOf(parts);
    if (k.error) return k;
    k.kind = 'code'; k.value = code; k.bare = !k.mod && !k.alt && !k.shift;
    k.text = modifiersText(k) + code;
    return k;
  }
  // Whether a Commands sheet's holds cell holds (section 3.10): empty, the empty text or a formula before its first value,
  // true, or a number other than 0, hold; false and 0 hold not; null for a text or an error, which is no truth value.
  function holdsOf(v) {
    if (v === undefined || v === null || v === '') return true;
    if (typeof v === 'boolean') return v;
    if (typeof v === 'number') return v !== 0;
    return null;
  }
  // Whether a command repeats, a Commands sheet's column E at version 8 (ENGINE.39; docs/SPEC.md section 3.10), read as
  // holds is but for the empty cell: empty, none; TRUE or a number other than 0, a repeat; FALSE or 0, none; a text or an
  // error, null, said by its cell, and none.
  function repeatsOf(v) {
    if (v === undefined || v === null || v === '') return false;
    if (typeof v === 'boolean') return v;
    if (typeof v === 'number') return v !== 0;
    return null;
  }
  // The region a viewport shows, as the window a sheet is viewed through (ENGINE.14, decision 3): the cells
  // its last draw put in view at its scroll, the frozen rows and columns from 1; never the sheet whole, so a
  // view costs a screen wherever it stands. fresh: a sheet the viewport has not drawn, estimated from A1 at
  // the default cell's size over the viewport's box, its own widths read once it is drawn.
  function regionOf(vp, fresh) {
    var V = VP(), g = vp.geometry();
    if (!g) return 'A1';
    // a sheet not yet drawn: the scroller's client area less its headers, at the default cell's size (ENGINE.43: the
    // headers no row or column of cells, as the region drawn will measure it, so that the first frame drawn keeps the view)
    if (fresh) return rangeOf(1, 1, Math.max(1, Math.ceil((g.clientH - g.headH / g.dpr) / V.RULES.row)), Math.max(1, Math.ceil((g.clientW - g.rhW / g.dpr) / V.RULES.column)));
    var s = vp.scrolled(), top = g.frozenRows > 0 ? 1 : s.top, left = g.frozenCols > 0 ? 1 : s.left;
    var r = { top: top, left: left, bottom: Math.max(top, s.bottom), right: Math.max(left, s.right) };
    var m = vp.model(), w = m && m.windowText ? V.parseRange(m.windowText) : null;
    if (w) carried(r, w, g, m, V);
    // A region that reaches the last column or row laid takes one more (ENGINE.43): an unbound sheet's layout grows with
    // the record it is viewed through, and at a ratio that is no whole number the scroller's end stands up to a device
    // pixel past the content it laid (its range in whole CSS pixels, its offset in fractions), so the column or row laid
    // next shows a sliver once the record lands; the record names it beforehand. A bound sheet's layout ends at its
    // extent and never grows.
    if (!g.bounded) {
      if (s.right >= g.cols) r.right = Math.max(r.right, Math.min(16384, s.right + 1));
      if (s.bottom >= g.rows) r.bottom = Math.max(r.bottom, Math.min(1048576, s.bottom + 1));
    }
    if (g.bounded) { r.bottom = Math.min(r.bottom, g.sheetRows); r.right = Math.min(r.right, g.sheetCols); }   // a bound sheet's extent (version 6)
    return V.rangeText(r);
  }
  // Past its record's window a viewport lays a row the record does not name as the sheet's earlier records set it,
  // else at the default height, so a sheet of rows lower than the default shows more of them than its region held,
  // each drawn empty until a view names it; the region is carried on past the window at the height of its last row,
  // so that the next view names what the viewport shows. A column needs no such carrying since CART.12's hand test,
  // 2026-10-19 (the large board's columns of 21 pixels drawn to CX of a screen of about 120 of them, and a page's jump
  // drawing columns no record named): the host reads a sheet's columns whole before it shows it (_learn), and the
  // viewport lays every column as the sheet sets it.
  function carried(r, w, g, m, V) {
    if (r.bottom > w.bottom && w.bottom >= r.top) {
      var st = m.rowSettings ? m.rowSettings[w.bottom] : null;
      var h = !st ? g.rowH : (st.hidden ? 0 : (st.height === null ? g.rowH : Math.round(Math.round(st.height * V.RULES.point) * g.dpr)));
      if (h > 0 && h < g.rowH) r.bottom = w.bottom + Math.ceil((r.bottom - w.bottom) * g.rowH / h);
    }
  }
  // Whether one window lies inside another.
  function within(inner, outer) {
    var a = VP().parseRange(inner), b = VP().parseRange(outer);
    return !!a && !!b && a.top >= b.top && a.left >= b.left && a.bottom <= b.bottom && a.right <= b.right;
  }
  // A refusal as the host prints it: the module's words once, then its id; the line only when a
  // write held more than one row, since a one-row write's line is always 1, and only when the
  // module's words do not already name it. The language's grid texts named it until KERNEL.23
  // ("Line 47 writes ..."); since then they name what they refuse and leave the line to the
  // answer's own field, so a refused load's line is said here.
  function namesLine(text, line) { return new RegExp('\\b[Ll]ine ' + line + '\\b').test(text); }
  function words(r, oneRow) { return r.status === 2 ? r.text : r.text + (r.line && !oneRow && !namesLine(r.text, r.line) ? ' (line ' + r.line + ')' : '') + ' [' + r.id + ']'; }
  function first(text, head) { var f = VP().readForms(text)[0]; return Array.isArray(f) && sym(f[0]) === head ? f : null; }
  // A text's lines, as a file counts them: one a line end, and one more for a last line with none.
  function lineCount(text) { return text === '' ? 0 : text.split('\n').length - (/\n$/.test(text) ? 1 : 0); }
  // A file's lines, each without its line feed and with a carriage return it ends on, and whether its last line ends:
  // a text that ends on a line feed holds no line after it, and the empty text no line at all.
  function fileLines(text) {
    var t = String(text);
    if (t === '') return { lines: [], ends: true };
    var ends = /\n$/.test(t), a = t.split('\n');
    if (ends) a.pop();
    return { lines: a, ends: ends };
  }
  // Where two files part (CART.16's second slice): a file as it was opened beside the file a grid says, and the first
  // line at which they differ, { line, was, now }, a line a file does not have undefined; or, where every line is the
  // same and only the last line's end is not, that line with end, whether the written file ends it; null where they are
  // one file, line ends and all. Pure.
  function firstChange(opened, written) {
    var a = fileLines(opened), b = fileLines(written), n = Math.max(a.lines.length, b.lines.length);
    for (var i = 0; i < n; i++) if (a.lines[i] !== b.lines[i]) return { line: i + 1, was: a.lines[i], now: b.lines[i] };
    return a.ends === b.ends ? null : { line: n, was: a.lines[n - 1], now: b.lines[n - 1], end: b.ends };
  }
  // That difference in words, each line cut to what a bar holds.
  function changeWords(ch) {
    var cut = function (t) { t = String(t).replace(/\r$/, ''); return '"' + (t.length > 72 ? t.slice(0, 69) + '...' : t) + '"'; };
    if (ch.end !== undefined) return ch.end ? 'its last line has no line end, and would be given one' : 'its last line would be written with no line end';
    if (ch.was === undefined) return 'a line would be added, ' + cut(ch.now);
    if (ch.now === undefined) return /^[ \t\r]*$/.test(ch.was) ? 'it ends with an empty line, or more, which would not be written' : 'the line ' + cut(ch.was) + ' and what follows it would not be written';
    if (ch.was.replace(/\r$/, '') === ch.now.replace(/\r$/, '')) return 'its line end would be ' + (/\r$/.test(ch.now) ? 'CR LF' : 'LF') + ' where the file has ' + (/\r$/.test(ch.was) ? 'CR LF' : 'LF');
    return cut(ch.now) + ' would be written where the file has ' + cut(ch.was);
  }
  // Whether a file's name ends with a cartridge's type (docs/SPEC.md section 3.11), compared without case, a name that
  // is the type alone being no such file. Pure.
  function ofType(name, type) {
    name = String(name || '');
    return !!type && name.length > type.length && name.toLowerCase().slice(-type.length) === type.toLowerCase();
  }
  function rangeOf(row, col, h, w) { return VP().rangeText({ top: row, left: col, bottom: row + h - 1, right: col + w - 1 }); }
  // A sentence's frame, and the rest of it: the log's key, so that a repeat is the same event at another frame.
  var FRAME_PREFIX = /^frame (\d+): /;
  function entryText(e) {
    if (e.count === 1) return e.first === null ? e.key : 'frame ' + e.first + ': ' + e.key;
    return e.count + ' times' + (e.first === null ? '' : ', frames ' + e.first + ' to ' + e.last) + ': ' + e.key;
  }
  function pack(r, g, b) { return (LITTLE ? ((255 << 24) | (b << 16) | (g << 8) | r) : ((r << 24) | (g << 16) | (b << 8) | 255)) >>> 0; }
  var MAGENTA = pack(255, 0, 255);
  // The cells of a sheet's record by address: a cell row's value, and a formula's
  // value from the value row after it (null until the first step gives one).
  function sheetCells(text) {
    var forms = VP().readForms(text), cells = {};
    for (var i = 0; i < forms.length; i++) {
      var f = forms[i];
      if (!Array.isArray(f)) continue;
      var head = sym(f[0]), a = str(f[2]);
      if (!a) continue;
      if (head === 'cell' || head === 'value') cells[a.toUpperCase()] = valueOf(f[3]);
      else if (head === 'formula') cells[a.toUpperCase()] = null;
    }
    return cells;
  }
  // A form spelled back as the reader read it, a list in parentheses, a string quoted, a number by
  // its own text and a symbol by its name: a replay's rows one a line, whatever their spacing.
  function spellForm(d) {
    if (Array.isArray(d)) return '(' + d.map(spellForm).join(' ') + ')';
    if (typeof d === 'string') return quote(d);
    if (d && d.num !== undefined) return d.text;
    return d && d.sym !== undefined ? d.sym : '';
  }
  function whole(d) { var n = num(d); return n !== null && n >= 0 && Math.floor(n) === n ? n : null; }
  // The bytes with each CR before an LF dropped: a cartridge's text as the page's box and a CRLF
  // checkout both hold it, named by one digest.
  function lfOnly(bytes) {
    var out = new Uint8Array(bytes.length), j = 0;
    for (var i = 0; i < bytes.length; i++) { if (bytes[i] === 13 && bytes[i + 1] === 10) continue; out[j++] = bytes[i]; }
    return out.subarray(0, j);
  }
  // A text's first form as written (ENGINE.5): to the parenthesis that closes it, a literal's and a comment's passed
  // over; the manifest a save begins with is the one its load took.
  function firstForm(text) {
    var depth = 0, inText = false, escaped = false, comment = false;
    for (var i = 0; i < text.length; i++) {
      var ch = text.charAt(i);
      if (comment) comment = ch !== '\n';
      else if (inText) { if (escaped) escaped = false; else if (ch === '\\') escaped = true; else if (ch === '"') inText = false; }
      else if (ch === ';') comment = true;
      else if (ch === '"') inText = true;
      else if (ch === '(') depth++;
      else if (ch === ')') { depth--; if (depth === 0) return text.slice(0, i + 1); }
    }
    return text;
  }
  // The cartridge's name, its manifest's first field, after the comment lines before it.
  function manifestName(text) {
    var m = /^\s*(?:;[^\n]*\n\s*)*\(\s*cartridge\s+"((?:[^"\\]|\\.)*)"/.exec(text);
    return m ? m[1] : '';
  }

  // ---- a window's changes (ENGINE.19; docs/SPEC.md section 4.5, the language's KERNEL.42) ----
  // The answer's header, (changes "<sheet>" "<range>" <since> <at> <n>), ending whole where the language cannot say
  // which cells changed; then each changed cell's rows as the values record prints them, (empty "<sheet>" "<addr>")
  // for a cell with none, in row-major order.
  var CHANGES_HEAD = /^\(changes "((?:[^"\\]|\\.)*)" "([^"]*)" (\d+) (\d+) (whole|\d+)\)$/;
  // A cell's row of a values record or of a changes answer, its address the first group and its row the second; a
  // text row (KERNEL.47) is a cell's, after its value's, and since ENGINE.37 a lit row (KERNEL.58), after the rest, alone
  // at a lit cell holding nothing.
  var CELL_LINE = /^\((?:cell|value|text|style|sentence|formula|lit|empty) "(?:[^"\\]|\\.)*" "([A-Z]+)([0-9]+)"/;
  // A record's window row, its sheet and its range.
  var WINDOW_LINE = /^\(window "((?:[^"\\]|\\.)*)" "([^"]*)"\)$/m;
  function unquote(s) { return s.replace(/\\(.)/g, '$1'); }
  // Whether a person's edit, one cell or formula row, writes the Input sheet, its name compared without case as the
  // recorder compares it (ENGINE.19, decision 5).
  function editsInput(row) { var f = VP().readForms(row)[0]; return Array.isArray(f) && String(str(f[1])).toLowerCase() === 'input'; }
  // Whether rows' formulas read the Input sheet's column B, or its twin's, at any row from top to bottom: a reference
  // in a formula's text, a cell or a range, whose rows meet them, a whole column's among them. The page asks it of
  // rows 17 and 18, the last key (ENGINE.24), and the host of rows 11 to 15, an act's place and press (CART.9's hand
  // test).
  var INPUT_REF = /(^|[^A-Za-z0-9_.'!])'?input(?:\.last)?'?!(\$?[A-Za-z]{1,3})(\$?\d+)?(?::(\$?[A-Za-z]{1,3})(\$?\d+)?)?/gi;
  function readsInputRows(text, top, bottom) {
    var forms = VP().readForms(String(text)), f, j, m;
    function col(s) { s = s.replace(/\$/g, '').toUpperCase(); var n = 0; for (var i = 0; i < s.length; i++) n = n * 26 + s.charCodeAt(i) - 64; return n; }
    function row(s) { return s ? +s.replace(/\$/g, '') : null; }
    for (f = 0; f < forms.length; f++) {
      if (!Array.isArray(forms[f])) continue;
      for (j = 1; j < forms[f].length; j++) {
        var t = forms[f][j];
        if (typeof t !== 'string' || t.charAt(0) !== '=') continue;
        INPUT_REF.lastIndex = 0;
        while ((m = INPUT_REF.exec(t))) {
          var c1 = col(m[2]), r1 = row(m[3]), c2 = m[4] ? col(m[4]) : c1, r2 = m[4] ? row(m[5]) : r1, whole = r1 === null || r2 === null;
          if (Math.min(c1, c2) <= 2 && Math.max(c1, c2) >= 2 && (whole || (Math.min(r1, r2) <= bottom && Math.max(r1, r2) >= top))) return true;
        }
      }
    }
    return false;
  }
  function readChanges(text) {
    var nl = text.indexOf('\n'), m = CHANGES_HEAD.exec(nl < 0 ? text : text.slice(0, nl));
    if (!m) return null;
    return { sheet: unquote(m[1]), range: m[2], since: +m[3], at: +m[4], whole: m[5] === 'whole', n: m[5] === 'whole' ? -1 : +m[5], rows: nl < 0 ? '' : text.slice(nl + 1) };
  }
  // What a window's changes make of a record held at a frame, its sheet and range as the record's window row names
  // them (decisions 2 and 4): whole, the view to run; still, the held record the frame's own, being the held frame's
  // or naming no cell since it; patch, the cells named since the held frame laid on it.
  function decide(held, ch) {
    if (!ch || ch.whole) return 'whole';
    if (ch.sheet !== held.sheet || ch.range !== held.range) return 'whole';
    if (ch.at === held.frame) return 'still';
    if (ch.since !== held.frame) return 'whole';
    return ch.n === 0 ? 'still' : 'patch';
  }
  // A cell's place in row-major order, one number: a row's 16,384 columns fit under 32,768.
  function placeOf(letters, row) { return +row * 32768 + VP().colIndex(letters); }
  // Whether a row's text so far ends inside a string (ENGINE.36): the language prints a text's line feed raw and escapes
  // a quote, so a row holding one runs on over the lines to where its string closes, and no line of it after the first
  // can pass CELL_LINE, which asks a bare quote straight after the row's head. So a line that passes costs nothing here.
  function stringOpen(row) {
    var open = false;
    for (var i = 0; i < row.length; i++) {
      var c = row.charCodeAt(i);
      if (c === 92) i++;
      else if (c === 34) open = !open;
    }
    return open;
  }
  // A values record by cell (decision 3): the rows before the first cell's as one text, and each cell's rows as one
  // text in the record's row-major order; null for a record whose rows after the first cell's are not all a cell's
  // in that order, which no patch is laid on.
  function byCell(text) {
    var lines = text.split('\n'), n = lines.length, i = 0, head = '', keys = [], pieces = new Map(), last = -1, row = '';
    if (n && lines[n - 1] === '') n--;
    for (; i < n && !CELL_LINE.test(lines[i]); i++) head += lines[i] + '\n';
    for (; i < n; i++) {
      var m = CELL_LINE.exec(lines[i]);
      if (!m) {
        if (!stringOpen(row)) return null;
        row += lines[i] + '\n';
        pieces.set(last, pieces.get(last) + lines[i] + '\n');
        continue;
      }
      row = lines[i] + '\n';
      var k = placeOf(m[1], m[2]);
      if (k === last) { pieces.set(k, pieces.get(k) + lines[i] + '\n'); continue; }
      if (k < last) return null;
      keys.push(k); pieces.set(k, lines[i] + '\n'); last = k;
    }
    return { head: head, keys: keys, pieces: pieces };
  }
  // The first place in keys at or after k.
  function keyAt(keys, k) {
    var lo = 0, hi = keys.length;
    while (lo < hi) { var mid = (lo + hi) >> 1; if (keys[mid] < k) lo = mid + 1; else hi = mid; }
    return lo;
  }
  // A changes answer's rows laid on a record by cell (the host's rule, docs/SPEC.md section 4.5): each named cell's
  // rows replaced with the given ones, a cell the record lacks put in at its place in row-major order, an empty one's
  // taken out, and the header untouched; the record's text, joined at once. Null, the record untouched, for rows that
  // are not cells' in row-major order, each cell's together.
  function patchRecord(rec, rows) {
    var lines = rows.split('\n'), n = lines.length, groups = [], last = -1, row = '';
    if (n && lines[n - 1] === '') n--;
    for (var i = 0; i < n; i++) {
      var m = CELL_LINE.exec(lines[i]);
      if (!m) {
        if (!stringOpen(row)) return null;
        row += lines[i] + '\n';
        groups[groups.length - 1].text += lines[i] + '\n';
        continue;
      }
      row = lines[i] + '\n';
      var k = placeOf(m[1], m[2]), empty = lines[i].lastIndexOf('(empty ', 0) === 0;
      if (k === last) { if (empty || groups[groups.length - 1].empty) return null; groups[groups.length - 1].text += lines[i] + '\n'; continue; }
      if (k < last) return null;
      groups.push({ k: k, empty: empty, text: empty ? '' : lines[i] + '\n' }); last = k;
    }
    for (var g = 0; g < groups.length; g++) {
      var c = groups[g], had = rec.pieces.has(c.k);
      if (c.empty) {
        if (had) { rec.pieces.delete(c.k); rec.keys.splice(keyAt(rec.keys, c.k), 1); }
        continue;
      }
      if (!had) rec.keys.splice(keyAt(rec.keys, c.k), 0, c.k);
      rec.pieces.set(c.k, c.text);
    }
    var out = rec.head;
    for (var j = 0; j < rec.keys.length; j++) out += rec.pieces.get(rec.keys[j]);
    return out;
  }
  // A changes answer's rows laid on a device sheet's cells as sheetCells reads them (decision 4): each named cell's
  // rows replace its value, a cell or value row its value and a formula row null, and an empty cell's address is
  // removed. False, the cells untouched, for rows that are not cells'.
  function patchCells(cells, rows) {
    var forms = VP().readForms(rows), i, f;
    for (i = 0; i < forms.length; i++) { f = forms[i]; if (!Array.isArray(f) || !sym(f[0]) || !str(f[2])) return false; }
    var seen = {};
    for (i = 0; i < forms.length; i++) {
      f = forms[i];
      var a = str(f[2]).toUpperCase(), head = sym(f[0]);
      if (!seen[a]) { seen[a] = true; delete cells[a]; }
      if (head === 'cell' || head === 'value') cells[a] = valueOf(f[3]);
      else if (head === 'formula') cells[a] = null;
    }
    return true;
  }

  // ---- edit and continue (ENGINE.7; docs/SPEC.md section 7.8): a rebuilt cartridge against the grid's ----
  // A cartridge's rows after its manifest (decision 2): the rows a write carries, cell and formula rows, by their sheet
  // without case and their address or range in capitals, each spelled back as the reader reads it, so that spacing is
  // never a change; the sheet rows in their order; every other row by its spelling, counted; and the sheets every row
  // names. A value row is a formula's value before its first step, which a running grid is past: neither written nor
  // compared (decision 3).
  var NAMES_A_SHEET = { sheet: 1, cell: 1, formula: 1, value: 1, column: 1, row: 1, look: 1, style: 1, sentence: 1, gridlines: 1 };
  function rowsOf(text) {
    var forms = VP().readForms(text), out = { manifest: forms[0], carried: new Map(), sheetRows: [], other: new Map(), sheets: new Map() };
    for (var i = 1; i < forms.length; i++) {
      var f = forms[i], head = Array.isArray(f) ? sym(f[0]) : null, sheet = Array.isArray(f) ? str(f[1]) : null, s = spellForm(f);
      if (head && NAMES_A_SHEET[head] && sheet !== null) out.sheets.set(sheet.toLowerCase(), sheet);
      if ((head === 'cell' || head === 'formula') && sheet !== null && str(f[2]) !== null) out.carried.set(sheet.toLowerCase() + '!' + str(f[2]).toUpperCase(), { text: s, head: head, sheet: sheet, range: str(f[2]), at: i });
      else if (head === 'sheet') out.sheetRows.push(s);
      else if (head !== 'value') out.other.set(s, (out.other.get(s) || 0) + 1);
    }
    return out;
  }
  function shortly(s) { return s.length > 90 ? s.slice(0, 87) + '...' : s; }
  // The manifest's change in words, or null for the same manifest: its name, then a directive changed, added or dropped.
  function manifestChange(was, now) {
    var a = Array.isArray(was) ? was : [], b = Array.isArray(now) ? now : [], heads = {}, i;
    if (spellForm(a) === spellForm(b)) return null;
    if (spellForm(a.slice(0, 2)) !== spellForm(b.slice(0, 2))) return 'its manifest names the cartridge ' + shortly(spellForm(b[1])) + ', where the running game\'s names ' + shortly(spellForm(a[1]));
    for (i = 2; i < a.length; i++) heads[Array.isArray(a[i]) ? sym(a[i][0]) : spellForm(a[i])] = spellForm(a[i]);
    for (i = 2; i < b.length; i++) {
      var h = Array.isArray(b[i]) ? sym(b[i][0]) : spellForm(b[i]), s = spellForm(b[i]);
      if (heads[h] === s) { delete heads[h]; continue; }
      return heads[h] !== undefined ? 'its manifest says ' + shortly(s) + ', where the running game\'s says ' + shortly(heads[h]) : 'its manifest adds ' + shortly(s);
    }
    for (var k in heads) if (Object.prototype.hasOwnProperty.call(heads, k)) return 'its manifest drops ' + shortly(heads[k]);
    return 'its manifest\'s directives stand in another order';
  }
  // Whether a range as parseRange reads it holds a cell; and how many cells of a rectangle no range of a list holds.
  function covers(r, row, col) {
    if (!r) return false;
    if (r.columns) return col >= r.left && col <= r.right;
    if (r.rows) return row >= r.top && row <= r.bottom;
    return row >= r.top && row <= r.bottom && col >= r.left && col <= r.right;
  }
  function uncovered(q, rs) {
    for (var k = 0; k < rs.length; k++) if (covers(rs[k], q.top, q.left) && covers(rs[k], q.bottom, q.right)) return 0;   // one range holds it whole
    var n = 0;
    for (var row = q.top; row <= q.bottom; row++) {
      for (var col = q.left; col <= q.right; col++) {
        var hit = false;
        for (var j = 0; j < rs.length && !hit; j++) hit = covers(rs[j], row, col);
        if (!hit) n++;
      }
    }
    return n;
  }
  function cellsOf(range) { var q = VP().parseRange(range); return q && !q.rows && !q.columns ? (q.bottom - q.top + 1) * (q.right - q.left + 1) : 0; }
  // A rebuilt cartridge against the one the grid was last given (decisions 2 to 5): why a write cannot carry the change,
  // each difference in words, the manifest's first, then the sheets, the sheet rows, the rows no write takes, and a
  // removed row's cells that no rebuilt row writes; and the rows to write, the rebuilt cartridge's changed and added
  // cell and formula rows in its own order, with their count by kind and their cells.
  function compareCartridges(baseText, nextText) {
    var A = rowsOf(baseText), B = rowsOf(nextText), why = [], m = manifestChange(A.manifest, B.manifest), i;
    if (m) why.push(m);
    B.sheets.forEach(function (name, key) { if (!A.sheets.has(key)) why.push('it adds the sheet ' + name + ', which a write cannot make'); });
    A.sheets.forEach(function (name, key) { if (!B.sheets.has(key)) why.push('it drops the sheet ' + name + ', which a write cannot remove'); });
    for (i = 0; i < Math.max(A.sheetRows.length, B.sheetRows.length); i++) {
      if (A.sheetRows[i] === B.sheetRows[i]) continue;
      why.push('its sheet rows change the tabs\' order or a sheet\'s visibility, ' + (B.sheetRows[i] || 'one row fewer') + ' where the running game has ' + (A.sheetRows[i] || 'none') + ', which a write cannot carry');
      break;
    }
    [[B.other, A.other, 'it writes '], [A.other, B.other, 'it no longer writes ']].forEach(function (d) { d[0].forEach(function (n, s) { if ((d[1].get(s) || 0) < n) why.push(d[2] + shortly(s) + ', a row that is no cell or formula row, which a write cannot carry'); }); });
    var ranges = {};
    B.carried.forEach(function (v) { var key = v.sheet.toLowerCase(); (ranges[key] = ranges[key] || []).push(VP().parseRange(v.range)); });
    A.carried.forEach(function (v, key) {
      if (B.carried.has(key)) return;
      var q = VP().parseRange(v.range), left = q && !q.rows && !q.columns ? uncovered(q, ranges[v.sheet.toLowerCase()] || []) : -1;
      if (left !== 0) why.push('it no longer writes ' + v.sheet + '!' + v.range + (left > 0 ? ', ' + thousands(left) + ' cell' + (left === 1 ? '' : 's') + ' no row of it writes,' : ',') + ' and no write empties a cell');
    });
    var write = [], formulas = 0, values = 0, cells = 0;
    B.carried.forEach(function (v, key) { var o = A.carried.get(key); if (!o || o.text !== v.text) write.push(v); });
    write.sort(function (p, q) { return p.at - q.at; });
    for (i = 0; i < write.length; i++) { if (write[i].head === 'formula') formulas++; else values++; cells += cellsOf(write[i].range); }
    return { why: why, rows: write.map(function (v) { return v.text; }), formulas: formulas, values: values, cells: cells };
  }
  // A command's name in a sentence, in single quotes (the owner's word at CART.9's fourth slice's hand test).
  function commandWords(name) { return 'command \'' + name + '\''; }
  // An act at rate 0, in words, for the frame's sentence: an edit's row, a command, a press of a button on its cell
  // (version 6, CART.12), the load's first step of a cartridge that settles, a paste or a cut's move (ENGINE.39), or a
  // rebuilt cartridge applied.
  var PRESS_WORDS = ['', 'left', 'right', 'middle'];
  function actWords(a) {
    if (typeof a === 'string') return 'the edit ' + a;
    if (a.paste) return a.what;
    if (a.row !== undefined) return 'the edit ' + a.row;
    if (a.command !== undefined) return 'the ' + commandWords(a.command);
    if (a.press !== undefined) return 'the ' + PRESS_WORDS[a.press] + ' press on ' + a.place.sheet + '!' + VP().colName(a.place.col) + a.place.row;
    if (a.load) return 'the load';
    return 'the source applied, ' + a.file;
  }
  // A count in a sentence: a word below ten, and a number from there.
  var COUNT_WORDS = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
  function countWords(n) { return n < COUNT_WORDS.length ? COUNT_WORDS[n] : thousands(n); }
  // What an act's own frame did, in a person's words.
  function ownFrameWords(a) {
    if (a.command !== undefined) return 'it ran';
    if (a.press !== undefined) return 'it landed';
    if (a.load) return 'it took its first step';
    return 'it was written';
  }
  // A settled act's frames and what each was for (the owner's word at CART.9's fourth slice's hand test, decision 51),
  // docs/SPEC.md section 5's settle in a person's words: the act's own; the one after a press's or a command's release, or
  // the one reading what an edit wrote; those while the grid still moved; and the last, which moved nothing and so proves
  // that nothing will. a, the act; steps, the settle steps after its own, at least one.
  function settledWords(a, steps) {
    var released = a.command !== undefined || a.press !== undefined, parts = [ownFrameWords(a)];
    if (steps >= 2) parts.push(released ? 'it was released' : 'the grid read it');
    if (steps >= 3) parts.push('the grid moved for ' + countWords(steps - 2) + ' more');
    parts.push('and a last frame proved nothing moved');
    return countWords(steps + 1) + ' frames: ' + parts.join(', ');
  }
  // What a continue writes, in words: its rows by kind, and their cells.
  function appliedWords(b) {
    var parts = [];
    if (b.formulas) parts.push(b.formulas + ' formula row' + (b.formulas === 1 ? '' : 's'));
    if (b.values) parts.push(b.values + ' value row' + (b.values === 1 ? '' : 's'));
    return parts.join(' and ') + ', ' + thousands(b.cells) + ' cell' + (b.cells === 1 ? '' : 's');
  }
  // Each row's line in a cartridge's text, where a line holds it as the reader spells it back, a row a line as the
  // pass writes them; 0 where none does.
  function linesOf(text, rows) {
    var at = new Map(), lines = String(text).split('\n');
    for (var i = 0; i < lines.length; i++) { var t = lines[i].trim(); if (!at.has(t)) at.set(t, i + 1); }
    return rows.map(function (r) { return at.get(r) || 0; });
  }

  // ---- SHA-256 (FIPS 180-4), synchronous: a replay names its cartridge by the digest of its text
  // with LF line ends, the bytes tools/check_frame_floors.ps1 digests (ENGINE.3, decision 9), in a
  // call that answers at once, where crypto.subtle answers with a promise and only in a secure context ----
  var K256 = [0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
              0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
              0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
              0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
              0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
              0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
              0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
              0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2];
  function sha256(bytes) {
    var n = bytes.length, total = (((n + 8) >> 6) + 1) << 6, m = new Uint8Array(total), dv = new DataView(m.buffer);
    m.set(bytes); m[n] = 0x80;
    dv.setUint32(total - 8, Math.floor(n / 0x20000000)); dv.setUint32(total - 4, (n * 8) >>> 0);   // the length in bits
    var h = [0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19];
    var w = new Int32Array(64), i;
    for (var off = 0; off < total; off += 64) {
      for (i = 0; i < 16; i++) w[i] = dv.getInt32(off + 4 * i);
      for (i = 16; i < 64; i++) {
        var x = w[i - 15], y = w[i - 2];
        w[i] = (w[i - 16] + ((x >>> 7 | x << 25) ^ (x >>> 18 | x << 14) ^ (x >>> 3)) + w[i - 7] + ((y >>> 17 | y << 15) ^ (y >>> 19 | y << 13) ^ (y >>> 10))) | 0;
      }
      var a = h[0], b = h[1], c = h[2], d = h[3], e = h[4], f = h[5], g = h[6], k = h[7];
      for (i = 0; i < 64; i++) {
        var t1 = (k + ((e >>> 6 | e << 26) ^ (e >>> 11 | e << 21) ^ (e >>> 25 | e << 7)) + ((e & f) ^ (~e & g)) + K256[i] + w[i]) | 0;
        var t2 = (((a >>> 2 | a << 30) ^ (a >>> 13 | a << 19) ^ (a >>> 22 | a << 10)) + ((a & b) ^ (a & c) ^ (b & c))) | 0;
        k = g; g = f; f = e; e = (d + t1) | 0; d = c; c = b; b = a; a = (t1 + t2) | 0;
      }
      h[0] = (h[0] + a) | 0; h[1] = (h[1] + b) | 0; h[2] = (h[2] + c) | 0; h[3] = (h[3] + d) | 0;
      h[4] = (h[4] + e) | 0; h[5] = (h[5] + f) | 0; h[6] = (h[6] + g) | 0; h[7] = (h[7] + k) | 0;
    }
    var hex = '';
    for (i = 0; i < 8; i++) hex += ('0000000' + (h[i] >>> 0).toString(16)).slice(-8);
    return hex.toUpperCase();
  }

  // ---- (1) the module: the memory pair and the record (docs/SPEC.md section 4.6) ----
  function Module(x) { this.x = x; }
  Module.prototype.put = function (bytes) {
    var p = this.x.alonzo_alloc(bytes.length);
    new Uint8Array(this.x.memory.buffer, p, bytes.length).set(bytes);   // a view made after the allocation, which may have grown the memory
    return { ptr: p, len: bytes.length };
  };
  Module.prototype.text = function (s) { return this.put(enc.encode(String(s))); };
  Module.prototype.release = function (b) { this.x.alonzo_free(b.ptr, b.len); };
  // One call: a cell for the record's length, the export, the record read through fresh views, copied out and freed.
  Module.prototype.call = function (name, args, raw) {
    var x = this.x;
    var outp = x.alonzo_alloc(4);
    var ptr = x[name].apply(null, args.concat([outp]));
    var len = new DataView(x.memory.buffer).getUint32(outp, true);
    x.alonzo_free(outp, 4);
    var dv = new DataView(x.memory.buffer, ptr, len);
    var status = dv.getUint32(0, true), line = dv.getUint32(4, true), idLen = dv.getUint32(8, true), textLen = dv.getUint32(12, true);
    var mem = new Uint8Array(x.memory.buffer, ptr, len);
    var id = dec.decode(mem.subarray(16, 16 + idLen));
    var body = mem.slice(16 + idLen, 16 + idLen + textLen);   // a copy: the record is freed next
    x.alonzo_free(ptr, len);
    if (raw && status === 0) return { status: status, line: line, id: id, bytes: body };
    return { status: status, line: line, id: id, text: dec.decode(body) };
  };
  Module.prototype.texts = function (name, head, texts, raw) {   // a call whose arguments are a number then texts
    var bufs = [], args = head.slice();
    try {
      for (var i = 0; i < texts.length; i++) { var b = this.text(texts[i]); bufs.push(b); args.push(b.ptr, b.len); }
      return this.call(name, args, raw);
    } finally {
      for (var j = 0; j < bufs.length; j++) this.release(bufs[j]);
    }
  };

  // ---- (2) the host ----
  // options: canvas (the plane's), box (the element the blit fits, the canvas's parent by default),
  // scale (a fixed number of device pixels a cell), budget (a fixed budget in cells, 0 for none),
  // callsPerTick (the step calls a tick may make, in place of the time slice), now (the clock the
  // budget is measured by), drive ('manual' when the caller calls tick itself), seed (the number a
  // (seed host) cartridge gets in place of the browser's random one, a whole number from 1 to
  // 2147483646), audio (an audio context the host sounds through from the start, in place of the
  // one Sound on makes: an oracle's double of the graph, or an offline context to render),
  // audioNow (the audio clock, in place of that context's currentTime), grid (the element a grid
  // cartridge's viewport fills, ENGINE.8; without one a grid cartridge runs and nothing draws it), and
  // viewport (the options that viewport is made with, ENGINE.20: an oracle's willReadFrequently).
  function Host(options) {
    options = options || {};
    VP();
    this.options = options;
    this.now = options.now || function () { return global.performance.now(); };
    // The time a key was pressed, on the host's clock (ENGINE.39): an event's own timeStamp, which is the page's clock and so
    // the host's own where it keeps the page's; a host on a clock of its own is given its own reading (options.keyTime), or
    // judges no key by its time.
    this.keyTime = options.keyTime || (options.now ? function () { return null; } : function (ev) { return ev && typeof ev.timeStamp === 'number' ? ev.timeStamp : null; });
    this.canvas = options.canvas || null;
    this.gridEl = options.grid || null;
    this.vp = null;   // grid mode's viewport, made at the first grid load and kept across loads
    this.quieting = false;   // while the host itself loads or shows a viewport's sheet: the events that raises go unanswered
    this.box = options.box || (this.canvas ? this.canvas.parentNode : null);
    this.fixedScale = options.scale || 0;
    this.fixedBudget = options.budget;
    this.callsPerTick = options.callsPerTick || 0;
    this.listeners = {};
    this.handlers = [];
    this.entries = new Map(); this.order = []; this.entryId = 0;   // the log: one entry an event of a run, its repeats counted
    this.history = []; this.said = 0; this.status = '';
    this.m = null; this.version = ''; this.handle = 0; this.cart = null;
    this.cartBytes = null; this.cartFile = '';   // the cartridge loaded, as its load was given it: a replay reloads it
    this.running = false; this.hidden = false; this.raf = 0;
    // The sound (ENGINE.4): the audio context and the voices' nodes, the host's own state (SD-23), kept
    // across loads; made at Sound on, or handed in (options.audio) with its clock (options.audioNow).
    this.snd = { ctx: null, injected: false, on: false, now: null, master: null, voices: null, end: null, silent: true, bad: {}, wanted: false };
    if (options.audio) {
      var actx = options.audio;
      this.snd.ctx = actx; this.snd.injected = true; this.snd.on = true;
      this.snd.now = options.audioNow || function () { return actx.currentTime; };
    }
    this.watched = [];   // the watches (ENGINE.30's second slice), the keymap's standing and the command's once, kept across loads
    this._reset();
    if (this.canvas) this._listenCanvas();
    this._listenPage();
  }
  Host.prototype._reset = function () {
    // a load's run, counted from 1: the log's lines are a run's, so that a load begins lines of its own and the log reads
    // as a timeline across loads, each line's frames one run's, and a load's sentences are the status line's again
    // (the rider of CART.9's third slice and the owner's word after it)
    this.run = (this.run || 0) + 1;
    this.frame = 0; this.inFrame = false; this.progress = null; this.stepEdit = null; this.stepAct = null;
    // the run's line of a person's edits of work sheets at rate 0 (ENGINE.30's first slice; decision 5, the history a line):
    // done, the edits a person can take back, the last last; undone, those taken back that redo puts back, the last taken
    // back last; and the entry whose rest is waited for, the cells its act left read then. A load empties it, and nothing
    // else does.
    this.undoLine = { done: [], undone: [] }; this.undoWaiting = null; this.stepLetGo = 0;
    // the watches across a load (ENGINE.30's second slice): the keymap's kept, each to be read again as the load leaves its
    // cell, and the command's, the run's, let go; and the frame a watch paused the run at, which Run clears
    this.watched = this.watched.filter(function (w) { return !w.once; });
    for (var wi = 0; wi < this.watched.length; wi++) this.watched[wi].last = undefined;
    this.watchStop = null;
    this.saveWaiting = null; this.saveAsked = null;   // a save asked for inside a frame or a settle, and the cartridge's, taken at a frame's end (ENGINE.5)
    this.saveWhat = null; this.checkWaiting = null;   // what a waiting save writes, the file or the cartridge, and a file opened whose check waits for the grid to rest (CART.16)
    this.saveAs = false;   // whether a waiting save was asked for under another name (ENGINE.49)
    this.acc = 0; this.lastTs = null; this.deltas = []; this.interval = DEFAULT_INTERVAL_MS;
    this.cellsPerMs = 0; this.frameCells = 0;
    this.pending = []; this.edits = [];
    this.held = Object.create(null); this.lastKey = null; this.notches = 0;
    this.pointer = { col: 0, row: 0, left: 0, right: 0, middle: 0, sheetCell: false };   // sheetCell: a sheet's own cell, no Camera added (ENGINE.18)
    this.keymap = null; this.window = ''; this.camera = { row: 1, col: 1 }; this.badCamera = {};
    this.table = null; this.paletteText = ''; this.paletteCount = 0;
    this.audio = []; this.saveValue = 0; this.plane = null; this.record = null; this.followed = null; this.timing = null; this.said1 = {};
    this.windowsSeen = {};
    // { vp, text, model, patches, frame, sheet, range, values, rec } a viewport, or null for a host without one: the record
    // the host last loaded into it and the model it made (ENGINE.17); the viewport's patches then, the frame the record
    // is of, its sheet and range as its window row names them, whether it is a values record, and its rows by cell,
    // made at its first patch (ENGINE.19)
    this.loads = [];
    this.kept = {};   // a device sheet's name: { frame, sheet, range, cells } as last read (ENGINE.19, decision 4)
    this.inputsLast = null;   // the Input rows last written, one a line; null where the next frame writes them whole (decision 5)
    this.tabsWaiting = [];   // tabs clicked while a frame was in progress, answered at its end (ENGINE.14)
    // Version 4's views (ENGINE.18): the sheet the host last showed itself, kept without a viewport too; the
    // Camera's third row as the load and the last step left it; the grid's sheets, read once a load; and a
    // sheet the Camera asked for, shown at the frame's end.
    this.shownName = null; this.cameraSheet = null; this.sheetsList = null; this.showWanted = null;
    this.rec = null; this.player = null;   // the replay recorded since the load, and one playing
    this.keep = null;   // the run's work kept since the load (ENGINE.38): its keyframe and the frames since
    this.given = null;   // the text of the cartridge the grid was last given by a continue, null for the bytes loaded (ENGINE.7)
    // Version 5's commands (ENGINE.25): the Commands sheet as last read, each { name, words, holds, code, row }, and the
    // codes of the commands that hold now; the commands waiting for their frames, one a frame; the one that runs at the
    // step in progress; the twentieth row as the host last wrote it at rate 0, null where it does not know; and the
    // rows of the sheet said once, until they change.
    this.commandList = []; this.commandKeys = {}; this.waiting = []; this.commandNow = ''; this.commandRow = null; this.badRows = {};
    // Version 8's repeat (ENGINE.39): the moment, on the host's clock, the last act came to rest, a repeat pressed before it
    // being one the browser kept behind a step, null before the first.
    this.restAt = null;
    // Version 6's settle (CART.12): whether the last step's answer left the grid settling, its word, and the act a settle
    // follows, { what, from }, said when it ends; and an act's rows at rate 0 as the host last knew the Input sheet to hold
    // them, by address, the engine's release mirrored, null where it does not know.
    this.settling = false; this.settleWord = ''; this.settleAct = null; this.actKnown = null;
    // whether the cartridge reads an act's place or press, Input!B11 to B15, so that a press over a cell is an act;
    // null until asked, after a load or a continue (CART.9's hand test)
    this.actRead = null;
    this.snd.end = null; this.snd.bad = {}; this.snd.wanted = false;   // the sound's timeline and its notices, a load's own
    this.c = { frames: 0, calls: 0, yields: 0, inputs: 0, inputsKept: 0, derivedApplied: 0, derivedRefused: 0, edits: 0, editsRefused: 0, windows: 0, draws: 0, stills: 0, patches: 0, shows: 0, saves: 0, saved: 0,
               sounded: 0, restarts: 0, skipped: 0, silences: 0, applied: 0, appliedRefused: 0, commands: 0, commandsRefused: 0,
               settles: 0, settleSteps: 0, unsettled: 0, presses: 0, playedShown: 0, editsRead: 0, keysRead: 0, keysStray: 0,
               keyframes: 0, restores: 0, pastes: 0, pastesRefused: 0, undos: 0, redos: 0, undosRefused: 0, letGo: 0,
               watchesHeld: 0, watchPauses: 0 };
  };

  // The module: its ABI number asked first, then every export the loop calls.
  Host.prototype.attach = function (exports) {
    this.stop();
    this.m = null; this.handle = 0; this.cart = null;
    if (!exports || typeof exports.alonzo_abi_version !== 'function') return this._fail('The module exports no alonzo_abi_version, so it is not an engine this page can drive.');
    var abi = exports.alonzo_abi_version();
    if (abi !== ABI) return this._fail('This page expects the engine ABI ' + ABI + ' and the module says ' + abi + '.');
    var missing = [];
    for (var i = 0; i < EXPORTS.length; i++) if (typeof exports[EXPORTS[i]] !== 'function') missing.push(EXPORTS[i]);
    if (!(exports.memory instanceof WebAssembly.Memory)) missing.push('memory');
    if (missing.length) return this._fail('The module lacks the export' + (missing.length === 1 ? ' ' : 's ') + missing.join(', ') + '.');
    this.m = new Module(exports);
    var v = this.m.call('alonzo_version_text', []);
    this.version = v.status === 0 ? v.text : 'a module that gave no version';
    return { ok: true, abi: abi, version: this.version };
  };

  Host.prototype.load = function (text, name) { return this.loadBytes(enc.encode(String(text)), name); };
  Host.prototype.loadBytes = function (bytes, name) {
    if (!this.m) return this._answerFailed('There is no engine module to load a cartridge into.');
    this.stop();
    if (this.handle) this.unload();
    this._reset();
    this.cartBytes = null; this.cartFile = '';
    var b = this.m.put(bytes), n = this.m.text(name || ''), r;
    try { r = this.m.call('alonzo_load', [b.ptr, b.len, n.ptr, n.len]); } finally { this.m.release(b); this.m.release(n); }
    if (r.status !== 0) return this._answerFailed('The cartridge was refused: ' + words(r) + '.');
    var f = first(r.text, 'cartridge');
    if (!f) return this._answerFailed('The module answered the load with ' + r.text.trim() + ', not a cartridge row.');
    this.handle = num(f[1]);
    this.cartBytes = bytes; this.cartFile = name || '';
    var c = this.cart = { title: str(f[2]), mode: sym(f[3]), w: num(f[4]), h: num(f[5]), rate: num(f[6]), seed: '', spec: 0, settle: 0, bound: [], game: [], work: [], read: [], devices: {}, budget: null, name: null, digest: null };
    this._describe();
    // A save resumes at its frame (docs/SPEC.md section 7.5; ENGINE.5): the host counts from the Clock's frame as loaded,
    // so that the frame said, the recorder's frames and a replay of the resumed run are the Clock's, and a replay of a
    // run resumed from a save plays on that save
    this.frame = this._clockAt('B1') || 0;
    this.window = rangeOf(1, 1, c.h, c.w);
    this._answer('Loaded ' + c.title + ': ' + article(c.w) + ' ' + c.w + ' by ' + c.h + ' ' + c.mode + ' at ' + (c.rate ? c.rate + ' frames a second' : 'rate 0, a step on every edit') + ', seed ' + c.seed + ', on ' + this.version + '.');
    if (c.budget) {
      // "may", since CART.2 (2026-10-11, decision 16): the budget counts every formula cell every frame,
      // and the engine computes only the cells a change reaches, so a cartridge over the line may run
      // at its rate, as Sand's 126,449 cells at 30 frames a second do.
      var bd = c.budget, over = bd.perSecond > bd.line;
      this._answer(c.rate ? 'The budget: ' + thousands(bd.cells) + ' formula cells a frame at ' + c.rate + ' frames a second, ' + thousands(bd.perSecond) + ' a second, ' + (over ? 'over' : 'under') + ' the console\'s line of ' + thousands(bd.line) + (over ? ': it may run slowly, in plain sight.' : '.')
                       : 'The budget: ' + thousands(bd.cells) + ' formula cells a step, one step an edit.');
    }
    if (c.mode === 'grid' && !this.gridEl) this._answer('This page gave the host no element for grid mode: the cartridge runs, and nothing draws it.');
    // a save of a cartridge whose host chose its seed holds the seed it ran on, which the host keeps (ENGINE.5)
    var held = c.seed === 'host' && this.playSeed === undefined ? this._clockAt('B3') : null;
    if (held) { c.seed = held; c.seedChosen = true; this._answer('The cartridge asks the host for its seed: the save holds ' + held + ', in Clock!B3, and keeps it.'); }
    else if (c.seed === 'host') this._seed();
    this._startReplay();   // the replay of this load's run, from frame 0 (section 7.6)
    this._startKeep();     // and the work kept, the cartridge loaded its first keyframe (ENGINE.38)
    if (c.devices.camera) this._readCamera('load');
    if (c.devices.palette) this._readPalette();
    if (c.devices.keys) this._readKeys();
    if (c.devices.commands) this._readCommands();   // version 5's commands, as loaded (ENGINE.25)
    // A save loaded past frame 0 owes the derived writes its run made at its next frame (ENGINE.30's decision 13; docs/SPEC.md
    // section 7.5): its Write sheet read as after a step, so that the page's Open, a restore's keyframe and a replay played on
    // a save go on as the run went; a cartridge loaded at frame 0 owes none, its formulas having no value yet.
    if (c.devices.write && this.frame > 0) this._readWrite();
    // The new grid drawn at once, frame 0 with nothing computed (a formula with no value yet reads
    // 0, a value cell its value): a load completes no frame, and without this draw the canvas kept
    // the last run's picture, a grid that no longer exists (the owner's hand test, 2026-10-09).
    if (c.mode === 'plane') this._drawPlane();   // frame 0, drawn at the load
    if (c.mode === 'grid') this._open();   // and a grid's, its record as loaded (ENGINE.8), on the sheet it opens on (ENGINE.18)
    this._emit('load', { handle: this.handle, title: c.title, mode: c.mode, w: c.w, h: c.h, rate: c.rate, window: this.window, scale: this.scale || 0, frame: this.frame });
    // A cartridge that settles opens on computed values (CART.12; docs/SPEC.md section 5): the load's act, frame 1, stepped
    // with its settle as an act at rate 0 is, at once and on the ticks after; a replay's player steps it itself.
    var loadSettles = this._settles() && c.rate === 0 && this.playSeed === undefined && this.frame === 0;
    this._watchBaselines(!loadSettles);   // each watch read as the load leaves its cell, or at the load's act's rest (ENGINE.30)
    // a watch whose sheet this cartridge lacks said, since it never holds; a replay's play says it in its own sentence
    var unread = this.playSeed === undefined ? this.unreadWatches() : '';
    if (unread) this._answer(unread.charAt(0).toUpperCase() + unread.slice(1) + '.');
    if (loadSettles) { this.edits.push({ load: true }); this._editFrames(this._window()); }   // a save rests as it was saved (ENGINE.5)
    return { ok: true, handle: this.handle, title: c.title, mode: c.mode, w: c.w, h: c.h, rate: c.rate };
  };
  // The host's seed (ENGINE.3, decision 1): a cartridge whose manifest says (seed host) loads with
  // Clock!B3 empty, and the host writes it once, before frame 0 is drawn, a whole number from 1 to
  // 2147483646 from the browser's random source, or options.seed when a caller names one (the
  // oracle), or the seed of the replay being played. The one write of the host's own that no person
  // made and no step computes: no time, and at rate zero no step.
  Host.prototype._seed = function () {
    var played = this.playSeed !== undefined, named = played ? this.playSeed : this.options.seed, n;
    if (typeof named === 'number' && named >= 1 && named <= MAX_SEED && Math.floor(named) === named) n = named;
    else {
      var cr = global.crypto, u = new Uint32Array(1);
      if (cr && cr.getRandomValues) cr.getRandomValues(u); else u[0] = Math.floor(Math.random() * 4294967296);
      n = 1 + (u[0] % MAX_SEED);
    }
    var r = this._write('(cell "Clock" "B3" ' + n + ')');
    if (r.status !== 0) { this._answerRefused('The cartridge asks the host for its seed, and the write of ' + n + ' into Clock!B3 was refused: ' + words(r, true) + '.'); return; }
    this.cart.seed = n; this.cart.seedChosen = true;
    this._answer(played ? 'The cartridge asks the host for its seed: the replay names ' + n + ', written in Clock!B3.'
                     : 'The cartridge asks the host for its seed: the host chose ' + n + ', in Clock!B3.');
  };
  // A Clock cell's whole number above 0 as the grid holds it, read from its values view, or null (ENGINE.5): a save's
  // frame and seed at its load.
  Host.prototype._clockAt = function (addr) {
    var r = this.m.texts('alonzo_view', [this.handle], ['values', 'Clock', addr]);
    var m = r.status === 0 ? new RegExp('^\\((?:cell|value) "Clock" "' + addr + '" (\\d+)\\)$', 'm').exec(r.text) : null;
    return m && +m[1] > 0 ? +m[1] : null;
  };
  Host.prototype._describe = function () {
    var r = this.m.call('alonzo_describe', [this.handle]);
    if (r.status !== 0) { this._answerRefused('The describe was refused: ' + words(r) + '.'); return; }
    var forms = VP().readForms(r.text), c = this.cart;
    for (var i = 0; i < forms.length; i++) {
      var f = forms[i], head = Array.isArray(f) ? sym(f[0]) : null;
      if (head === 'seed') c.seed = num(f[1]) !== null ? num(f[1]) : sym(f[1]);
      else if (head === 'spec') c.spec = num(f[1]) || 0;   // the page the cartridge is written to: version 4's views its alone (ENGINE.18)
      else if (head === 'settle') c.settle = num(f[1]) || 0;   // version 6's settle, the most steps an act settles in (CART.12)
      else if (head === 'bound') { for (var b = 1; b < f.length; b++) if (str(f[b]) !== null) c.bound.push(str(f[b])); }   // version 6's bound sheets (CART.12's hand test)
      else if (head === 'game' || head === 'work' || head === 'read') { for (var g = 1; g < f.length; g++) if (str(f[g]) !== null) c[head].push(str(f[g])); }   // version 6's keyboard sheets (SPEC.5)
      else if (head === 'device' && str(f[1])) c.devices[str(f[1]).toLowerCase()] = { range: str(f[2]), direction: sym(f[3]) };
      else if (head === 'budget') c.budget = { rate: num(f[1]), cells: num(f[2]), perSecond: num(f[3]), line: num(f[4]) };
    }
  };
  Host.prototype.unload = function () {
    if (!this.m || !this.handle) return;
    this.stop();
    this._release();   // the oscillators stopped after the silence, the next load making its own (ENGINE.4, decision 6)
    var r = this.m.call('alonzo_unload', [this.handle]);
    if (r.status !== 0) this._answerRefused('The unload was refused: ' + words(r) + '.');
    this.handle = 0; this.cart = null; this.inFrame = false; this.progress = null; this.plane = null;
    this._clear();
  };
  // The canvas emptied when its grid is unloaded: what it showed is gone, and a load refused after
  // it leaves no picture of a grid the module no longer holds; the viewport too (ENGINE.8).
  Host.prototype._clear = function () {
    if (this.vp) this.vp.clear();
    if (!this.canvas) return;
    var ctx = this.ctx || this.canvas.getContext('2d');
    ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
  };

  // ---- the pass (docs/SPEC.md section 7.8; SPEC.3's second slice): an act of its own, before any load ----
  // A source, its path and the texts it may include, [path, text] pairs, handed to the module's
  // alonzo_expand, the texts joined path, NUL, text, NUL, as the export reads them; the answer is the
  // cartridge's text, the command line's bytes, for a page to show before anything loads it. The
  // pass takes no handle and touches no grid, so nothing here stops, unloads or resets the loop. The
  // export is asked for at the act and not at the attach, since the fake module holds no pass and
  // still drives the loop: over a module without one, the build is declined in words.
  Host.prototype.expand = function (source, path, files) {
    if (!this.m) return this._answerFailed('There is no engine module to run the pass.');
    var name = String(path || '').replace(/^.*[\/\\]/, '');
    if (typeof this.m.x.alonzo_expand !== 'function') return this._answerFailed('The module exports no alonzo_expand, so it holds no pass to build a cartridge from ' + (name || 'its source') + ': the engine\'s module holds one (docs/SPEC.md section 7.8).');
    var parts = [];
    for (var i = 0; i < (files || []).length; i++) parts.push(String(files[i][0]), String(files[i][1]));
    var t0 = this.now(), r = this.m.texts('alonzo_expand', [], [source, path, parts.join('\u0000')]), ms = this.now() - t0;
    if (r.status !== 0) return this._answerFailed('The pass refused ' + name + ': ' + words(r) + '.');
    var rows = Math.max(0, VP().readForms(r.text).length - 1);
    this._answer('Built ' + name.replace(/\.source\.vla$/i, '.vla') + ' from ' + name + ' by the pass: its manifest and ' + thousands(rows) + ' row' + (rows === 1 ? '' : 's') + ', and nothing loaded.');
    return { ok: true, text: r.text, rows: rows, ms: ms };
  };

  // ---- edit and continue (ENGINE.7; docs/SPEC.md section 7.8): a rebuilt cartridge applied to the running game ----
  // The cartridge the grid was last given (decision 10): the one loaded, or the one a continue last applied.
  Host.prototype._given = function () { return this.given !== null ? this.given : dec.decode(this.cartBytes); };
  // A rebuilt cartridge applied to the running game, its state kept (decisions 1 to 8). Compared with the cartridge the
  // grid was last given, row by row; what a write cannot carry named in words with Load offered, and nothing written;
  // the rebuilt cartridge loaded in a second handle and given back at once, so that nothing Load would refuse is
  // applied; then the rows it changed or added, one act in the place of a person's edits at the next frame's start, a
  // press waiting replaced by the next; at rate zero, one edit and one step. name: the file's name in the sentences, the
  // name the cartridge loaded was given by default.
  Host.prototype.apply = function (text, name) {
    if (!this.m) return this._answerFailed('There is no engine module to apply a cartridge to.');
    if (!this.handle || !this.cart || !this.cartBytes) return this._answerFailed('No cartridge is loaded to apply a rebuilt one to: Load starts one from frame 0.');
    var file = name || this.cartFile || 'the cartridge', next = String(text || '');
    if (this.player) return this._answerFailed('The rebuilt ' + file + ' was not applied: a replay is playing, frame ' + this.frame + ' of ' + this.player.last + ', and a person\'s edits wait until it ends, so that what plays is the replay alone.');
    var cmp = compareCartridges(this._given(), next), at = 'frame ' + this.frame + ': ';
    if (cmp.why.length) return this._answerFailed(at + file + ' cannot be applied to the running game: ' + cmp.why[0] + (cmp.why.length > 1 ? ', and ' + (cmp.why.length - 1) + ' more' : '') + '. Load starts it from frame 0.');
    if (!cmp.rows.length) { this._answer(at + file + ' changes no cell or formula row of the cartridge the running game holds: nothing to apply.'); return { ok: true, rows: 0, cells: 0, formulas: 0, values: 0 }; }
    var r = this._checkLoad(next, file);
    if (r) return this._answerFailed(at + file + ' cannot be applied to the running game, since a load refuses it: ' + words(r) + '; nothing was written.');
    for (var i = this.edits.length - 1; i >= 0; i--) if (typeof this.edits[i] !== 'string') this.edits.splice(i, 1);   // a press waiting, replaced
    var b = { text: next, file: file, rows: cmp.rows, lines: linesOf(next, cmp.rows), formulas: cmp.formulas, values: cmp.values, cells: cmp.cells };
    this.edits.push(b);
    if (!this.inFrame && this.cart.rate === 0) this._editFrames(this._window());
    else if (!this.running && this.cart.rate > 0) this._answer(at + file + ' waits for the next frame, which Run brings: ' + appliedWords(b) + ' to write; the loop is paused at ' + this.cart.rate + ' frame' + (this.cart.rate === 1 ? '' : 's') + ' a second.');
    return { ok: true, rows: cmp.rows.length, cells: cmp.cells, formulas: cmp.formulas, values: cmp.values };
  };
  // The rebuilt cartridge loaded in a second handle of the same module and given back at once (decision 6): false when
  // it loads, else the load's refusal, its line the rebuilt cartridge's. The grid that runs is the first handle's alone.
  Host.prototype._checkLoad = function (text, name) {
    var b = this.m.text(text), n = this.m.text(name || ''), r;
    try { r = this.m.call('alonzo_load', [b.ptr, b.len, n.ptr, n.len]); } finally { this.m.release(b); this.m.release(n); }
    var f = r.status === 0 ? first(r.text, 'cartridge') : null;
    if (f) this.m.call('alonzo_unload', [num(f[1])]);
    return f ? false : r;
  };

  // ---- the loop (section 5) ----
  Host.prototype.start = function () {
    if (this.running || !this.handle) return;
    this.running = true; this.lastTs = null; this.watchStop = null;   // Run goes on past a watch that paused it (ENGINE.30)
    this._resound();   // the frame the grid holds sounds again with the loop (ENGINE.4, decision 6)
    if (this.options.drive === 'manual' || !global.requestAnimationFrame) return;
    var self = this;
    var loop = function (ts) {
      if (!self.running) return;
      try { self.tick(ts); } catch (e) { self.stop(); self._refuse('The loop stopped: ' + (e && e.message ? e.message : e) + '.'); return; }
      self.raf = global.requestAnimationFrame(loop);
    };
    this.raf = global.requestAnimationFrame(loop);
  };
  Host.prototype.stop = function () {
    var was = this.running;
    this.running = false;
    if (this.raf && global.cancelAnimationFrame) global.cancelAnimationFrame(this.raf);
    this.raf = 0;
    this._silence();   // the voices stop with the loop (ENGINE.4, decision 6)
    // A running loop that stops says so, with the frame it stopped at (Pause, a replay's end, a refused
    // step, a load or an unload), so that a page draws what it shows of the grid at that frame: the
    // panel's live sheet, drawn about five times a second while the loop runs, was left a few frames
    // behind the frame line at every stop (the owner's hand test of ENGINE.4, 2026-10-10).
    if (was) this._emit('stop', { frame: this.frame });
  };
  // One animation frame's work, at its timestamp: the step 1 of section 5.
  Host.prototype.tick = function (ts) {
    if (!this.running || !this.handle || this.hidden || !this.cart) return;
    var c = this.cart, win;
    if (c.rate === 0) {   // no tick at rate zero: a frame an edit began continues here, and the edits waiting follow it
      win = this._window();
      if (this.inFrame) { if (this._continue(win)) this._editFrames(win); }
      else if (!this.player && (this.settling || this.edits.length)) this._editFrames(win);   // a settle going on (CART.12), or edits made in the frame that set the rate to 0
      else if (this.player) { this._begin(); if (this.inFrame) this._continue(win); }   // a replay's frame a tick, its edits being its frames
      return;
    }
    if (this.lastTs === null) { this.lastTs = ts; return; }
    var raw = ts - this.lastTs;
    this.lastTs = ts;
    this._sample(raw);
    var dt = this._snapped(raw, c.rate);
    // A tick's time held to a quarter second, and the backlog to the larger of a quarter second and one
    // frame's interval: held to the quarter second alone, a rate under four frames a second, whose
    // interval is longer, never stepped, and the teacher's rate of 1 froze the loop (ENGINE.3's hand test).
    this.acc = Math.min(this.acc + Math.min(dt, ACCUMULATOR_CAP_MS), Math.max(ACCUMULATOR_CAP_MS, 1000 / c.rate));
    win = this._window();
    for (;;) {
      if (this.inFrame) { if (!this._continue(win)) return; continue; }
      if (c.rate === 0) return;   // a frame of this tick set the Clock's rate to 0: edits step from here
      if (!this.running) return;  // a frame of this tick ended a replay, or a replay's refused rows stopped it
      if (this._spent(win)) return;
      if (this.acc < 1000 / c.rate) return;   // the interval at the rate the last frame left in the Clock
      this.acc -= 1000 / c.rate;
      this._begin();
    }
  };
  // A tick's time put on the grid of the frame's interval when within SNAP_MS of it (docs/SPEC.md section 5, step 1,
  // corrected 2026-10-12): the grid's step is the frame's interval over the whole number of the display's
  // intervals it spans, or the frame's own interval where it is shorter than the display's. So at a rate of
  // 60 on a display of 60 every tick owes one frame, and at 30 every second tick, whatever the timestamps'
  // jitter; a display whose interval is off the grid by more than SNAP_MS is timed as it comes.
  Host.prototype._snapped = function (dt, rate) {
    var f = 1000 / rate, d = this.interval, unit = f >= d ? f / Math.max(1, Math.round(f / d)) : f, m = Math.round(dt / unit);
    return m >= 1 && Math.abs(dt - m * unit) < SNAP_MS ? m * unit : dt;
  };
  Host.prototype._sample = function (dt) {
    if (dt <= 0 || this.deltas.length >= INTERVAL_SAMPLES) return;
    this.deltas.push(dt);
    var s = this.deltas.slice().sort(function (a, b) { return a - b; });
    this.interval = s[Math.floor((s.length - 1) / 2)];
  };
  Host.prototype._window = function () { return { used: 0, limit: this.callsPerTick, deadline: this.now() + this.interval * SLICE_FRACTION }; };
  Host.prototype._spent = function (win) { return win.limit ? win.used >= win.limit : (win.used > 0 && this.now() >= win.deadline); };
  // A frame begins: the writes of steps 2 and 3, then the step.
  Host.prototype._begin = function () {
    this.inFrame = true;
    this.progress = { evaluated: 0, of: this.frameCells };
    this._issueDerived();   // section 5, step 2: the derived writes, before the inputs
    this._issueInputs();    // step 3: the Input rows, then a person's edits, each its own write
  };
  // Rate zero: one step for each edit, in the order they were made. A settling cartridge's act is its step and then its
  // settle's (version 6, CART.12; docs/SPEC.md section 5): while the last step's answer says settling, a settle step,
  // the derived writes before it and no act, and the acts made meanwhile wait for the settle to end.
  Host.prototype._editFrames = function (win) {
    while (!this.inFrame && this.handle && !this.player && (this.settling || this.edits.length)) {
      this.inFrame = true;
      this.progress = { evaluated: 0, of: this.frameCells };
      this._issueDerived();
      if (this.settling) { if (!this._continue(win)) return; continue; }
      var row = this.edits.shift();
      if (!this._issueAct(row, true)) { this.inFrame = false; this.progress = null; continue; }
      this.stepEdit = actWords(row); this.stepAct = row;
      this.stepLetGo = row && typeof row === 'object' && row.letGo ? row.letGo : 0;   // the edits undone it let go (ENGINE.30)
      if (!this._continue(win)) return;
    }
  };
  // Steps the frame in progress until it is done (true) or the tick's window is spent (false).
  Host.prototype._continue = function (win) {
    for (;;) {
      if (this._spent(win)) { this._sayProgress(); return false; }
      var s = this._stepOnce(win);
      if (s === 'done') return true;
      if (s === 'refused') return false;
    }
  };
  Host.prototype._budget = function (win) {
    if (this.fixedBudget !== undefined && this.fixedBudget !== null) return this.fixedBudget >>> 0;
    if (!this.cellsPerMs) return FIRST_BUDGET;
    var left = win.limit ? this.interval * SLICE_FRACTION : Math.max(0, win.deadline - this.now());
    return Math.max(MIN_BUDGET, Math.min(0x7fffffff, Math.floor(this.cellsPerMs * left)));
  };
  // Step 4: one call, its budget in cells; the cells it did per millisecond set the next budget.
  Host.prototype._stepOnce = function (win) {
    var budget = this._budget(win), t0 = this.now();
    var r = this.m.call('alonzo_step', [this.handle, budget]);
    var ms = Math.max(this.now() - t0, TIMER_FLOOR_MS);
    win.used++; this.c.calls++;
    if (this.keep) this.keep.steps += ms;   // the steps since the keyframe, which time the next (ENGINE.38)
    var f = r.status === 0 ? first(r.text, 'step') : null;
    if (!f) {
      this.inFrame = false; this.progress = null; this.stop();
      this._refuse('frame ' + (this.frame + 1) + ': the step was refused: ' + (r.status === 0 ? 'the module answered ' + r.text.trim() : words(r)) + '; the loop stops.');
      return 'refused';
    }
    var evaluated = num(f[2]), of = num(f[3]), before = this.progress ? this.progress.evaluated : 0;
    if (evaluated > before) this.cellsPerMs = (evaluated - before) / ms;
    this.frameCells = of;
    if (sym(f[4]) === 'yielded') { this.c.yields++; this.progress = { evaluated: evaluated, of: of }; return 'yielded'; }
    this.inFrame = false; this.progress = null;
    // a settling cartridge's word (version 6, CART.12; docs/SPEC.md section 4.4): settling, the next step a settle step
    // with no act; unsettled, K settle steps taken and the grid waiting for the next act; none, settled
    this.settleWord = sym(f[5]) || '';
    var was = this.settling;
    this.settling = this.settleWord === 'settling';
    if (was) this.c.settleSteps++;
    // the engine releases the act's press and command before the first settle step: the host's own record of the act's
    // rows, and the recorder's, hold the release, so that the next act writes and logs a press against it
    if (this.settling && !was) this._released();
    this._complete(num(f[1]));
    return 'done';
  };
  // The engine's release mirrored (CART.12): the press's cells 0 and the command's empty, as the host and the recorder
  // last know the Input sheet to hold them, and the twentieth row so too.
  Host.prototype._released = function () {
    var rel = { B13: '0', B14: '0', B15: '0', B20: '""' }, known = this.actKnown, rec = this.rec, a;
    for (a in rel) {
      if (known) known[a] = rel[a];
      if (rec && rec.input && rec.input[a] !== undefined) rec.input[a] = rel[a];
    }
    if (this.commandRow !== null) this.commandRow = '';
  };
  Host.prototype._sayProgress = function () {
    var p = this.progress || { evaluated: 0, of: this.frameCells };
    this._say('frame ' + (this.frame + 1) + ', ' + thousands(p.evaluated) + ' of ' + thousands(p.of) + ' cells', 'progress');
  };

  // ---- the writes (steps 2 and 3) ----
  Host.prototype._write = function (rows) {
    var b = this.m.text(rows);
    try { return this.m.call('alonzo_write', [this.handle, b.ptr, b.len]); } finally { this.m.release(b); }
  };
  Host.prototype._issueDerived = function () {
    var rows = this.pending;
    this.pending = [];
    for (var i = 0; i < rows.length; i++) {
      var r = this._write(rows[i].text);
      if (r.status === 0) { this.c.derivedApplied++; continue; }
      this.c.derivedRefused++;
      // the module's words name the cell when they can; the host names it only when they do not
      var said = r.text.indexOf(rows[i].where) >= 0 ? words(r, true) : 'a derived write into ' + rows[i].where + ' was refused: ' + words(r, true);
      this._refuse('frame ' + (this.frame + 1) + ': ' + said + '.');
    }
  };
  // Step 3's Input rows by their changes (ENGINE.19, decision 5): the rows that differ from the rows last written, in
  // their order, and none when none does, the frame counted kept; all of them at the first frame since the load and
  // after a person's edit of the Input sheet, a replay's rows or a refused write, each of which forgets the rows last
  // written, as the recorder forgets its record of the sheet at the same acts. The recorder is given the frame's rows
  // whenever they differ from the last written and logs the cells that changed against its own record, as before.
  Host.prototype._issueInputs = function () {
    if (this.player) { this._issuePlayed(); return; }   // a replay's rows in place of the live inputs and edits (section 7.6)
    if (this.cart.rate > 0) {
      this.commandNow = this._five() && this.waiting.length ? this.waiting.shift() : '';   // the command that runs at this step, one a frame (ENGINE.25)
      var rows = this._inputRows(), lines = rows.split('\n'), last = this.inputsLast, changed = [];
      if (last && last.length !== lines.length) last = null;
      for (var i = 0; i < lines.length; i++) if (!last || last[i] !== lines[i]) changed.push(lines[i]);
      this.c.inputs++;
      if (!changed.length) this.c.inputsKept++;
      else {
        var r = this._write(changed.join('\n'));
        if (r.status !== 0) { this.inputsLast = null; this._refuse('frame ' + (this.frame + 1) + ': the Input rows were refused: ' + words(r) + '.'); }
        else { this.inputsLast = lines; this._recordInputs(rows); }
      }
      this.notches = 0; this.lastKey = null;
      if (this._five()) { this.commandRow = this.inputsLast ? this.commandNow : null; if (this.commandNow && this.inputsLast) this.c.commands++; }
    }
    while (this.edits.length) this._issueAct(this.edits.shift(), false);
  };
  // A person's act at a frame's start, in the order acts were made: an edit, one row; a rebuilt cartridge's rows; or a
  // cartridge's command at rate 0 (ENGINE.25), before whose step, as before every step at rate 0, the twentieth row is
  // written alone, the command that runs or empty.
  Host.prototype._issueAct = function (act, atRateZero) {
    if (atRateZero && this._sixAtZero()) { if (!this._writeActRows(act)) return false; }
    else if (atRateZero && this._five()) this._writeCommandRow(act.command !== undefined ? act.command : '');
    if (act.command !== undefined) return this._issueCommand(act, atRateZero);
    if (act.press !== undefined || act.load) return true;   // a press, or the load's first step: its rows are the act (CART.12)
    if (act.paste) return this._issuePaste(act, atRateZero);   // a paste's rows, one write (ENGINE.39)
    if (act.row !== undefined) return this._issueEdit(act.row, atRateZero, act);
    return typeof act === 'string' ? this._issueEdit(act, atRateZero, null) : this._issueApplied(act, atRateZero);
  };
  // An act's rows at rate 0 (version 6, CART.12; docs/SPEC.md section 3.3), before its step: the sheet shown and the cell
  // the act stands on, the press, and the command, as one write of the rows that differ from the Input sheet as the host
  // last knew it, the engine's release held there; all seven where it knows nothing. Recorded as the Input cells they
  // are, against the recorder's own record. Refused: said, and no step.
  Host.prototype._writeActRows = function (act) {
    var p = act.place || this._place(), press = act.press || 0, cmd = act.command !== undefined ? act.command : '';
    var want = { B11: String(p.col), B12: String(p.row), B13: press === 1 ? '1' : '0', B14: press === 2 ? '1' : '0', B15: press === 3 ? '1' : '0',
                 B19: quote(p.sheet), B20: quote(cmd) };
    var known = this.actKnown, rows = [], all = [], a;
    for (a in want) {
      var row = '(cell "Input" "' + a + '" ' + want[a] + ')';
      all.push(row);
      if (!known || known[a] !== want[a]) rows.push(row);
    }
    if (rows.length) {
      var r = this._write(rows.join('\n'));
      if (r.status !== 0) {
        this.actKnown = null; this.commandRow = null;
        this._answerRefused('frame ' + (this.frame + 1) + ': the act\'s rows were refused: ' + words(r, true) + '; no step for ' + actWords(act) + '.');
        return false;
      }
    }
    this.actKnown = want; this.commandRow = cmd; this.inputsLast = null;
    this._recordInputs(all.join('\n'));
    return true;
  };
  // A command's step at rate 0 (ENGINE.25): its name written into the twentieth row before it, the step following; the
  // row refused, no step. At a rate a command left among the acts, a rate risen from 0, waits for the next frame.
  Host.prototype._issueCommand = function (act, atRateZero) {
    if (!atRateZero) { this.waiting.push(act.command); return true; }
    if (this.commandRow !== act.command) return false;
    this.c.commands++;
    return true;
  };
  // The twentieth row at rate 0 (ENGINE.25; docs/SPEC.md section 3.10), written alone before every step when it is not
  // what the host last wrote there: the command that runs at the step, or empty, so that the step after a command's
  // sees none. Recorded as the Input cell it is; the Input rows last written forgotten, the sheet no longer theirs.
  Host.prototype._writeCommandRow = function (name) {
    if (this.commandRow === name) return true;
    var row = '(cell "Input" "B20" ' + quote(name) + ')', r = this._write(row);
    if (r.status !== 0) { this.commandRow = null; this._answerRefused('frame ' + (this.frame + 1) + ': the command row ' + row + ' was refused: ' + words(r, true) + '; no step for it.'); return false; }
    this.commandRow = name; this.inputsLast = null;
    this._recordCommandRow(row, name);
    return true;
  };
  // A rebuilt cartridge's rows as one write, all or none (ENGINE.7, decisions 7 and 8), in the place of a person's edits.
  // Landed: each row recorded as a person's edit in its frame (decision 9), an Input sheet's row making the next frame's
  // Input rows whole, and the cartridge the base of the next continue (decision 10). Refused: nothing written, the game
  // running on under the rules it had, the row the write refused named with its line in the rebuilt cartridge.
  Host.prototype._issueApplied = function (b, atRateZero) {
    var r = this._write(b.rows.join('\n'));
    if (r.status === 0) {
      this.c.applied++;
      for (var i = 0; i < b.rows.length; i++) {
        this._recordEdit(b.rows[i]);
        if (editsInput(b.rows[i])) this.inputsLast = null;
        if (editsInput(b.rows[i])) { this.commandRow = null; this.actKnown = null; }   // the twentieth row and the act's rows no longer known (ENGINE.25, CART.12)
      }
      this.given = b.text; this.actRead = null;   // the rebuilt rows read again for an act's place and press
      this._emit('wrote', { rows: b.rows, move: false });   // the rows that landed, which a page's cut is let go by (ENGINE.39)
      this._answer('frame ' + (this.frame + 1) + ': applied ' + b.file + ' to the running game: ' + appliedWords(b) + ' written, the frame number and every other cell kept.');
      return true;
    }
    this.c.appliedRefused++;
    var k = r.line >= 1 && r.line <= b.rows.length ? r.line - 1 : -1;
    var where = k >= 0 ? ', its row ' + shortly(b.rows[k]) + (b.lines[k] ? ' at line ' + b.lines[k] : '') : '';
    this._answerRefused('frame ' + (this.frame + 1) + ': ' + b.file + ' was not applied: the write of its rows was refused' + where + ': ' + r.text + ' [' + r.id + ']; nothing was written, and the game runs on under the rules it had. Load starts the rebuilt cartridge from frame 0' + (atRateZero ? '; no step.' : '.'));
    return false;
  };
  Host.prototype._issueEdit = function (row, atRateZero, act) {
    var before = this._undoBefore(act), r = this._write(row);
    if (r.status === 0) {
      this.c.edits++;
      if (before !== undefined) this._undoLanded(act, before);   // the edit joins the run's line (ENGINE.30's first slice)
      this._recordEdit(row);   // the replay logs a person's edit that landed, in its frame (section 7.6)
      if (readsInputRows(row, 11, 15)) this.actRead = true;   // a person's formula reading an act's place or press: a press is an act from here (CART.9)
      if (editsInput(row)) this.inputsLast = null;   // the Input sheet a person wrote: the next frame's rows written whole (ENGINE.19)
      if (editsInput(row)) { this.commandRow = null; this.actKnown = null; }   // and its twentieth row and the act's rows no longer known (ENGINE.25, CART.12)
      this._emit('wrote', { rows: [row], move: false });   // the row that landed, which a page's cut is let go by (ENGINE.39)
      if (!atRateZero) this._answer('frame ' + (this.frame + 1) + ': the edit ' + row + ' was written.');
      return true;
    }
    this.c.editsRefused++;
    this._answerRefused('frame ' + (this.frame + 1) + ': the edit ' + row + ' was refused: ' + words(r, true) + (atRateZero ? '; no step.' : '.'));
    return false;
  };
  // A paste's rows as one write, all or none (ENGINE.39's second slice, decision 10), in the place of a person's edits, as
  // a rebuilt cartridge's are. Landed: each row recorded as a person's edit in its frame, so that a replay holds the paste
  // as the rows of one frame and plays it so; an Input sheet's row making the next frame's Input rows whole; a formula
  // reading an act's place making a press an act; and its rows told. At a rate its answer said; at rate 0 the step's
  // sentence says it. Refused: nothing written, the row the write refused named, and at rate 0 no step.
  Host.prototype._issuePaste = function (act, atRateZero) {
    var before = this._undoBefore(act), r = this._write(act.rows.join('\n'));
    if (r.status === 0) {
      if (act.undoOp === 'undo') this.c.undos++; else if (act.undoOp === 'redo') this.c.redos++; else this.c.pastes++;
      if (before !== undefined) this._undoLanded(act, before);   // a paste joins the run's line, and an undo or a redo moves in it (ENGINE.30)
      for (var i = 0; i < act.rows.length; i++) {
        var row = act.rows[i];
        this._recordEdit(row);
        if (readsInputRows(row, 11, 15)) this.actRead = true;
        if (editsInput(row)) { this.inputsLast = null; this.commandRow = null; this.actKnown = null; }
      }
      this._emit('wrote', { rows: act.rows, move: !!act.move });
      if (!atRateZero) this._answer('frame ' + (this.frame + 1) + ': ' + act.done + '.');
      return true;
    }
    this.c.pastesRefused++;
    var k = r.line >= 1 && r.line <= act.rows.length ? r.line - 1 : -1;
    this._answerRefused('frame ' + (this.frame + 1) + ': ' + act.what + ' was not written: the write of its rows was refused' + (k >= 0 ? ' at its row ' + shortly(act.rows[k]) : '') + ': ' + words(r, true) + '; nothing was written' + (atRateZero ? ', and no step.' : '.'));
    return false;
  };
  // The Input sheet's eighteen rows (section 3.3): ten buttons for four players through the key map,
  // the pointer in Screen cells, its three buttons, the wheel's notches, the last key twice. The
  // pointer is held as the window's cell under it, and written as the Screen's own cell (ENGINE.3,
  // decision 4): the window's cell plus the offset of the Camera the person sees, the one the last
  // frame was drawn through, so that ROW() and COLUMN() find the cell pointed at wherever the Camera
  // stands; 0 off the canvas. A cartridge written to version 4 (ENGINE.18, decision 4) has a nineteenth
  // row, the sheet the host shows, a plane's being the Screen, and its pointer over any other sheet is that
  // sheet's own cell, the Camera added on the Screen alone.
  Host.prototype._inputRows = function () {
    var out = [], km = this.keymap, held = this.held, pt = this.pointer, k = this.lastKey, cam = pt.sheetCell ? { col: 1, row: 1 } : this.camera;
    for (var b = 0; b < 10; b++) {
      for (var p = 0; p < 4; p++) {
        var code = km ? km[b][p] : '';
        out.push('(cell "Input" "' + PLAYERS[p] + (b + 1) + '" ' + (code && held[code] ? 1 : 0) + ')');
      }
    }
    var on = pt.col > 0 && pt.row > 0;
    out.push('(cell "Input" "B11" ' + (on ? cam.col + pt.col - 1 : 0) + ')', '(cell "Input" "B12" ' + (on ? cam.row + pt.row - 1 : 0) + ')');
    out.push('(cell "Input" "B13" ' + pt.left + ')', '(cell "Input" "B14" ' + pt.right + ')', '(cell "Input" "B15" ' + pt.middle + ')');
    out.push('(cell "Input" "B16" ' + this.notches + ')');
    out.push('(cell "Input" "B17" ' + quote(k ? k.key : '') + ')', '(cell "Input" "B18" ' + quote(k ? k.code : '') + ')');
    if (this._four()) out.push('(cell "Input" "B19" ' + quote(this.cart.mode === 'grid' ? this._shown() : 'Screen') + ')');
    if (this._five()) out.push('(cell "Input" "B20" ' + quote(this.commandNow || '') + ')');   // the command that runs at the step (ENGINE.25)
    return out.join('\n');
  };

  // ---- the effects (step 5) and the draw (step 6) ----
  Host.prototype._complete = function (n) {
    this.frame = n; this.c.frames++;
    if (this.cart.rate === 0 || this.commandNow) this.rested();   // an act come to rest, which a repeat is judged by (ENGINE.39)
    this._recordFrame(n);
    var d = this.cart.devices;
    if (d.camera) this._readCamera();
    if (d.palette) this._readPalette();
    if (this.cart.mode === 'plane') this._drawPlane();
    if (this.cart.mode === 'grid') this._drawGrid(false, true);   // the record through the frame's own Camera (ENGINE.8), a still one not drawn again (ENGINE.17)
    if (this.tabsWaiting.length) this._answerWaiting();   // a tab clicked while the frame was in progress (ENGINE.14)
    if (d.keys) this._readKeys();
    if (d.commands) this._readCommands();   // after the Keys sheet, whose codes a command's key goes before (ENGINE.25)
    if (d.audio) this._readAudio();
    if (d.file) this._readFile();
    if (d.write) this._readWrite();
    if (d.clock) this._readClock();
    if (d.audio && !this._restoring()) this._sound();   // step 6, the sound, after the Clock's rate that times it (ENGINE.4)
    // an act's sentence: stepped once for it; for a cartridge that settles (CART.12), said when its settle ends, with its
    // frames and what each was for, or that K stopped it with the grid still moving (SD-30)
    if (this.stepEdit) {
      if (this.settling) this.settleAct = { what: this.stepEdit, act: this.stepAct, from: n, letGo: this.stepLetGo };
      else this._answer('frame ' + n + ': stepped once for ' + this.stepEdit + letGoWords(this.stepLetGo) + '.');
      this.stepEdit = null; this.stepLetGo = 0;
    } else if (this.settleAct && !this.settling) {
      var sa = this.settleAct, steps = n - sa.from;
      this.settleAct = null;
      if (this.settleWord === 'unsettled') {
        this.c.unsettled++;
        this._answer('frame ' + n + ': ' + sa.what + ' did not settle in ' + countWords(steps + 1) + ' frames, the most its (settle ' + this.cart.settle + ') allows: the grid still moves, and waits for the next act (docs/SPEC.md section 5)' + letGoWords(sa.letGo) + '.');
      } else {
        this.c.settles++;
        this._answer('frame ' + n + ': ' + sa.what + ' settled in ' + settledWords(sa.act, steps) + letGoWords(sa.letGo) + '.');
      }
    }
    // the cells an act of the line left, read once it rests: what an undo or a redo holds the grid to (ENGINE.30)
    if (this.undoWaiting && !this.settling) { var uw = this.undoWaiting; this.undoWaiting = null; uw.entry[uw.slot] = this._heldAll(uw.entry.targets); }
    // the cartridge's save, taken after the frame's reads, the Clock's among them, at rest or held for the act's settle;
    // and a save asked for inside a frame or a settle, taken now that the grid rests (ENGINE.5)
    if (this.saveAsked) { var by = this.saveAsked; this.saveAsked = null; this.save(by); }
    else if (this.saveWaiting && !this.settling) { var asked = this.saveWaiting, what = this.saveWhat, under = this.saveAs; this.saveWaiting = null; this.saveWhat = null; this.saveAs = false; this._saveNow(asked, true, null, what, under); }
    // a file opened, written back and held to the file once the load's act has settled (CART.16's second slice)
    if (this.checkWaiting && !this.settling) { var cw = this.checkWaiting; this.checkWaiting = null; this._fileChecked(cw.opened, cw.name); }
    // a keyframe of the work kept, at rest and never while a restore plays its frames (ENGINE.38)
    if (this.keep && !this.settling && !(this.player && this.player.restore) && this._keyframeDue()) this._keyframe();
    var p = this.player;
    this._emit('frame', { frame: n, window: this.window, scale: this.scale || 0, rate: this.cart.rate, replay: p ? p.last : 0 });
    if (p && p === this.player && n >= p.last) this._endReplay(n);
    if (this.watched.length) this._watchFrame(n);   // each watch read at the frame's end, never a frame late (ENGINE.30's second slice)
  };
  Host.prototype._record = function (sheet) {
    var r = this.m.texts('alonzo_view', [this.handle], ['grid', sheet, '']);
    if (r.status !== 0) { this._sayOnce('view-' + sheet, 'frame ' + this.frame + ': the view of ' + sheet + ' was refused: ' + words(r) + '.', true); return null; }
    return r.text;
  };
  Host.prototype._cells = function (sheet) { var d = this._device(sheet); return d ? d.cells : null; };
  // A device sheet read by its changes (ENGINE.19, decision 4): its cells kept as last read with the frame they hold,
  // and the sheet's changes over its extent asked first. Whole, no cells kept (the first read since the load) or any
  // other frame: the sheet read whole, as before. The held frame's own, or no cell named since it: the cells kept.
  // Cells named since it: each named cell's rows replace its value, and an empty cell's address is removed. Each
  // device's own reading runs over the cells as before, so the Write sheet's rows become the next frame's derived
  // writes at every frame. { cells, text, changed }: text the record when the sheet was read whole, and changed false
  // when the cells were kept; null, the refusal said once, when the view is refused.
  Host.prototype._device = function (sheet) {
    var d = this.kept[sheet];
    if (d) {
      var r = this.m.texts('alonzo_view', [this.handle], ['changes', sheet, '']), ch = r.status === 0 ? readChanges(r.text) : null, how = decide(d, ch);
      if (how === 'still') { d.frame = ch.at; return { cells: d.cells, text: null, changed: false }; }
      if (how === 'patch' && patchCells(d.cells, ch.rows)) { d.frame = ch.at; return { cells: d.cells, text: null, changed: true }; }
    }
    var t = this._record(sheet);
    if (t === null) { delete this.kept[sheet]; return null; }
    var w = WINDOW_LINE.exec(t);
    d = this.kept[sheet] = { frame: this.frame, sheet: w ? unquote(w[1]) : '', range: w ? w[2] : '', cells: sheetCells(t) };
    return { cells: d.cells, text: t, changed: true };
  };
  // The Camera's two cells place the window this frame is drawn through (section 3.8). A cartridge written to
  // version 4 has its third row read too (ENGINE.18): stage 'load' at the load, none after a step, and
  // 'redraw' from redraw(), which steps nothing and so reads no sheet.
  Host.prototype._readCamera = function (stage) {
    var cells = this._cells('Camera');
    if (!cells) return;
    var c = this.cart;
    var row = Math.min(this._cameraCell(cells.B1, 'row'), 1048576 - c.h + 1), col = Math.min(this._cameraCell(cells.B2, 'column'), 16384 - c.w + 1);
    var text = rangeOf(row, col, c.h, c.w);
    if (text !== this.window) this._say('frame ' + this.frame + ': the Camera placed the window at ' + text + '.');
    this.window = text; this.camera = { row: row, col: col };
    if (stage !== 'redraw' && this._four()) this._readCameraSheet(cells.B3, stage);
  };
  // The Camera's third row (ENGINE.18, decision 5), a cartridge's written to version 4: the sheet the game
  // shows. At the load it names the sheet the cartridge opens on (decision 2); after a step, a change of its
  // value that names a sheet the grid holds is shown at the frame's end, as a tab clicked is shown, and between
  // its changes the person's tabs win, as the person's scroll does between the Camera's moves.
  Host.prototype._readCameraSheet = function (v, stage) {
    var key = valueKey(v), was = this.cameraKey;
    this.cameraSheet = v; this.cameraKey = key;
    if (stage === 'load' || key === was) return;
    var name = this._cameraSheetName(v);
    if (name !== null) this.showWanted = name;
  };
  // A value of the Camera's third row read as a sheet: the grid's own spelling of the sheet it names, compared
  // without case as the model compares names, or null. Empty, or a formula before its first value, names none;
  // a value the grid holds no sheet for is said once, as a Camera cell is (SD-30), and so is a sheet a plane's
  // Camera names, a plane drawing its Screen alone.
  Host.prototype._cameraSheetName = function (v) {
    if (valueKey(v) === '') { this.badCamera.sheet = undefined; return null; }
    var name = this._sheetNamed(v), plane = this.cart.mode === 'plane';
    var why = name === null ? (typeof v === 'string' ? ', a sheet the grid does not hold' : ', not a sheet\'s name') : (plane && !isScreen(name) ? ': a plane cartridge draws its Screen alone' : '');
    if (!why) { this.badCamera.sheet = undefined; return plane ? null : name; }
    var shown = typeof v === 'string' ? '"' + v + '"' : (typeof v === 'object' ? 'an error, ' + v.error : String(v));
    if (this.badCamera.sheet !== shown) { this.badCamera.sheet = shown; this._say('frame ' + this.frame + ': the Camera\'s sheet is ' + shown + why + '; nothing is shown.'); }
    return null;
  };
  Host.prototype._cameraCell = function (v, what) {
    if (typeof v === 'number' && v >= 1 && Math.floor(v) === v) { this.badCamera[what] = undefined; return v; }
    var shown = v === null || v === undefined ? 'empty' : (typeof v === 'string' ? '"' + v + '"' : (typeof v === 'object' ? 'an error, ' + v.error : String(v)));
    if (this.badCamera[what] !== shown) { this.badCamera[what] = shown; this._say('frame ' + this.frame + ': the Camera\'s ' + what + ' is ' + shown + ', not a whole number from 1; the window takes 1.'); }
    return 1;
  };
  // The Palette's table, made again only when its cells changed: kept by their changes, or a record read whole that is
  // the last one byte for byte; a patch leaves no record to compare the next with (ENGINE.19).
  Host.prototype._readPalette = function () {
    var d = this._device('Palette');
    if (!d || !d.changed || (d.text !== null && d.text === this.paletteText)) return;
    this.paletteText = d.text;
    var cells = d.cells, table = new Uint32Array(256), bad = [], count = 0;
    table.fill(MAGENTA);
    for (var i = 1; i <= 255; i++) {
      var v = cells['B' + i];
      if (v === undefined) break;
      var m = typeof v === 'string' ? /^#([0-9A-Fa-f]{6})$/.exec(v) : null;
      if (m) { var x = parseInt(m[1], 16); table[i - 1] = pack((x >> 16) & 255, (x >> 8) & 255, x & 255); count = i; }
      else bad.push('B' + i);
    }
    this.table = table; this.paletteCount = count;
    if (bad.length) this._say('frame ' + this.frame + ': the Palette\'s ' + bad.join(', ') + ' hold no #RRGGBB color; those indices paint magenta.');
  };
  // A restore's frames, played at once (ENGINE.38): drawn and sounded once, at its end, and never frame by frame.
  Host.prototype._restoring = function () { return !!(this.player && this.player.restore); };
  Host.prototype._drawPlane = function () {
    if (this._restoring()) return;
    var c = this.cart, t0 = this.now();
    var r = this.m.texts('alonzo_view', [this.handle], ['plane', 'Screen', this.window], true);
    var t1 = this.now();
    if (r.status !== 0) { this._sayOnce('plane', 'frame ' + this.frame + ': the plane was refused: ' + words(r) + '.', true); return; }
    if (r.bytes.length !== c.w * c.h) { this._sayOnce('plane-size', 'frame ' + this.frame + ': the plane holds ' + r.bytes.length + ' bytes, not the window\'s ' + (c.w * c.h) + '.', true); return; }
    if (!this.windowsSeen[this.window]) { this.windowsSeen[this.window] = true; this.c.windows++; }
    this.plane = r.bytes;
    if (this.canvas) this._blit(r.bytes);
    this.timing = { view: t1 - t0, blit: this.now() - t1 };
  };
  // The bytes through the palette into one ImageData of the window's size, put into a plane-sized
  // canvas, and drawn onto the visible one at a whole number of device pixels a cell, smoothing off.
  Host.prototype._blit = function (bytes) {
    var c = this.cart, w = c.w, h = c.h;
    if (!this.planeCanvas || this.planeCanvas.width !== w || this.planeCanvas.height !== h) {
      this.planeCanvas = global.document.createElement('canvas');
      this.planeCanvas.width = w; this.planeCanvas.height = h;
      this.planeCtx = this.planeCanvas.getContext('2d');
      this.image = this.planeCtx.createImageData(w, h);
      this.pixels = new Uint32Array(this.image.data.buffer);
    }
    if (!this.table) { this.table = new Uint32Array(256); this.table.fill(MAGENTA); }
    var pal = this.table, px = this.pixels, n = w * h;
    for (var i = 0; i < n; i++) px[i] = pal[bytes[i]];
    this.planeCtx.putImageData(this.image, 0, 0);
    this._fit();
    this.ctx.imageSmoothingEnabled = false;
    this.ctx.drawImage(this.planeCanvas, 0, 0, w * this.scale, h * this.scale);
    this.c.draws++;
  };
  // Grid mode (ENGINE.8; docs/SPEC.md section 5, steps 5 and 6): the Screen's record through the window the
  // Camera places, drawn by the viewport. Frame 0's record is loaded whole, the view reset; every later
  // frame's replaces it with the person's scroll and selection kept (decision 5). The record is viewed
  // whether or not a viewport draws it, so a host with no element still counts its windows. Once a frame
  // has computed values the record is the values projection, the grid record less its formula rows, so no
  // formula's text is moved at a frame (the second slice, KERNEL.37); frame 0, nothing computed since the
  // load, is the grid record, its formulas shown as their texts until their first values. A still frame
  // (ENGINE.17): at a frame's own draw, of the Screen or of a sheet shown in its place, a record byte for byte
  // the one the host last loaded into the viewport, the viewport still holding the model it made of it, is
  // neither loaded nor painted, and counted; the view still runs, its text being what tells, and the viewport
  // paints a person's scroll and selection itself. A load, a tab clicked and redraw() always draw.
  Host.prototype._drawGrid = function (atLoad, frame) {
    if (frame && this._restoring()) return;   // a restore's frame (ENGINE.38)
    // A frame's draw when the Camera asked for a sheet: that sheet shown (ENGINE.18, decision 5).
    if (frame && this.showWanted) { this._drawShown(); return; }
    // A host with no viewport views no sheet it shows other than the Screen, nothing drawing it (ENGINE.18).
    if (!atLoad && !this.vp && !isScreen(this._shown())) return;
    // Another sheet shown in the Screen's place (ENGINE.14, decision 2): the frame views that sheet alone,
    // through the region the viewport shows, and the Screen again when its tab gives the window back.
    if (!atLoad && this.vp && !isScreen(this.vp.sheet())) { if (this.refreshSheet(this.vp, false, frame)) this.c.draws++; return; }
    // A frame's own draw asks the window's changes first (ENGINE.19, decisions 2 and 3), when the viewport, or a host
    // without one, still holds the values record the host noted for this window. Cells named since its frame patch the
    // held text and the viewport's model in place, a draw; none named, or the held frame's own, hand the held record to
    // the still frame's test below in the place of a view; whole, or any other frame, view as before.
    var d = frame ? this._byChanges(this._viewport(), 'Screen', this.window) : null;
    if (d && d.how === 'patch') {
      this.record = d.text;
      if (this.vp) { this.c.patches++; this.c.draws++; }
      this.timing = { view: d.view, draw: d.draw, patched: d.cells };
      return;
    }
    var t0 = this.now(), projection = this.frame > 0 ? 'values' : 'grid';
    var r = d ? { status: 0, text: d.text } : this.m.texts('alonzo_view', [this.handle], [projection, 'Screen', this.window]);
    var t1 = this.now(), asked = d ? d.view : 0;
    if (r.status !== 0) { this._sayOnce('grid', 'frame ' + this.frame + ': the record of the Screen was refused: ' + words(r) + '.', true); return; }
    if (!this.windowsSeen[this.window]) { this.windowsSeen[this.window] = true; this.c.windows++; }
    var vp = this._viewport(), was = this.quieting;
    if (frame && vp && this._still(vp, r.text)) {
      this.c.stills++;
      this.timing = { view: asked + t1 - t0, draw: 0, skipped: true };
      return;
    }
    this.record = r.text;
    if (vp) {
      this.quieting = true;   // the events this load and the follow raise are the host's own, never a person's tab
      try {
        vp.load(r.text, { keep: !atLoad });
        if (atLoad && !isScreen(vp.sheet())) vp.show('Screen');   // the Screen a version 4 cartridge's Camera shows from another sheet (ENGINE.18)
        this._follow(atLoad);
      } finally { this.quieting = was; }
      this._noteLoad(vp, r.text);
      this.c.draws++;
    } else this._noteLoad(null, r.text);   // a host without a viewport holds its text alone (ENGINE.19)
    this.timing = { view: asked + t1 - t0, draw: this.now() - t1 };
  };
  // The viewport, made over the page's element at the first grid load and kept across loads; its tabs
  // answered, and the sheet it shows viewed again at a scroll that leaves its region (ENGINE.14).
  Host.prototype._viewport = function () {
    if (this.vp || !this.gridEl) return this.vp;
    var V = VP(), self = this;
    this.vp = new V(this.gridEl, this.options.viewport);
    this._listenGrid();
    this.vp.on('sheet', function (e) { self.answer(self.vp, e); });
    this.vp.on('scroll', function () { self.refreshSheet(self.vp, true); });
    return this.vp;
  };
  // The viewport follows the Camera (decision 6): at a load to the window's top-left; at a move, by the
  // move, so that where the person looks inside the window is kept and the window moves under it. A
  // cartridge with no Camera keeps the person's scroll.
  Host.prototype._follow = function (atLoad) {
    var cam = this.camera, was = this.followed;
    this.followed = { row: cam.row, col: cam.col };
    if (!this.cart.devices.camera) return;
    if (atLoad || !was) { this.vp.scrollTo(cam.row, cam.col); return; }
    if (cam.row === was.row && cam.col === was.col) return;
    var at = this.vp.scrolled();
    this.vp.scrollTo(Math.max(1, at.top + cam.row - was.row), Math.max(1, at.left + cam.col - was.col));
  };

  // ---- the tabs (ENGINE.14; KERNEL.5's decision 6): a viewport's sheet event answered ----
  // A person's click on a tab. A sheet the viewport holds no record of is viewed and shown; one it holds, which
  // the viewport has shown already from its last record, is viewed again at once; and the Screen's tab, in the
  // host's own viewport, gives the game's window back. A frame in progress is never viewed (viewRecord), so a
  // tab clicked mid-frame waits for the frame's end. The events the host's own calls raise go unanswered.
  Host.prototype.answer = function (vp, e) {
    if (this.quieting || !vp || !e || !this.handle) return;
    if (this.inFrame) { this.tabsWaiting.push({ vp: vp, e: e }); return; }
    if (vp === this.vp && isScreen(e.name)) { this._screenTab(); return; }
    if (e.loaded) this.refreshSheet(vp); else this.showSheet(vp, e.name);
  };
  Host.prototype._answerWaiting = function () {
    var list = this.tabsWaiting;
    this.tabsWaiting = [];
    for (var i = 0; i < list.length; i++) this.answer(list[i].vp, list[i].e);
  };
  // The Screen's tab (decision 2): the Screen viewed through the Camera's window as at a load, the view reset
  // and scrolled to the Camera's corner, the Camera followed from there; so a person who scrolled away, or who
  // watched another sheet while the Camera moved, has the game's window back. A click on it while it shows
  // does the same. The selection stays where the person left it, as every sheet keeps it (CART.14.1's hand test).
  Host.prototype._screenTab = function () {
    var self = this, kept = this.vp ? this.vp.selection().text : null;
    this._quiet(function () { self._drawGrid(true); });
    if (kept !== null && this.vp.selection().text !== kept) this.vp.select(kept);
  };

  // ---- version 4's views (ENGINE.18): the sheet a grid cartridge opens on, and the sheet the game shows ----
  // Whether the cartridge is written to version 4, whose rows and behaviors are its alone (decision 1).
  Host.prototype._four = function () { return !!this.cart && this.cart.spec >= 4; };
  // Whether the cartridge is written to version 5, whose Commands sheet and twentieth row are its alone (ENGINE.25).
  Host.prototype._five = function () { return !!this.cart && this.cart.spec >= 5; };
  // Whether the cartridge is written to version 7, whose commands' keys may hold modifiers (CART.3's second slice).
  Host.prototype._seven = function () { return !!this.cart && this.cart.spec >= 7; };
  // Whether the cartridge is written to version 8, whose Commands sheet says which commands repeat (ENGINE.39).
  Host.prototype._eight = function () { return !!this.cart && this.cart.spec >= 8; };
  // Version 9's Format sheet (CART.16's second slice): a cartridge written to 9 says a file's lines on it.
  Host.prototype._nine = function () { return !!this.cart && this.cart.spec >= 9; };
  // Whether the cartridge is written to version 6 and stands at rate 0, where an act has a place and a press over a cell
  // is an act (CART.12); and whether it settles, (settle K), each act then stepped again while the grid moves.
  Host.prototype._sixAtZero = function () { return !!this.cart && this.cart.spec >= 6 && this.cart.rate === 0; };
  Host.prototype._settles = function () { return !!this.cart && this.cart.settle > 0; };
  // The place an act stands on at rate 0 (CART.12; docs/SPEC.md section 3.3, version 6): in grid mode the sheet shown and
  // the cell the viewport's selection stands on there, the sheet's own; in plane mode the pointer's Screen cell, the
  // Camera added, as the Input rows write it at a rate, 0 off the canvas.
  Host.prototype._place = function () {
    if (this.cart && this.cart.mode === 'grid' && this.vp) {
      var f = this.vp.selection().focus;
      return { sheet: this._shown(), col: f ? f.col : 1, row: f ? f.row : 1 };
    }
    var pt = this.pointer, cam = this.camera, on = pt.col > 0 && pt.row > 0;
    return { sheet: 'Screen', col: on ? cam.col + pt.col - 1 : 0, row: on ? cam.row + pt.row - 1 : 0 };
  };
  // The sheet the host's viewport shows, the Screen while none is shown; without a viewport, the one the host
  // last showed itself, so that a host with no element never views a hidden Screen nobody draws.
  Host.prototype._shown = function () { return (this.vp && this.vp.sheet()) || this.shownName || 'Screen'; };
  // The grid's sheets in tab order with their states, read once a load off the record of the Clock's first
  // cell, which every grid holds: a write makes no sheet, so the list holds for the load.
  Host.prototype._sheets = function () {
    if (this.sheetsList) return this.sheetsList;
    var t = this.viewRecord('Clock', 'A1'), forms = t === null ? [] : VP().readForms(t), list = [];
    for (var i = 0; i < forms.length; i++) {
      var f = forms[i];
      if (Array.isArray(f) && sym(f[0]) === 'sheet' && str(f[1]) !== null) list.push({ name: str(f[1]), state: sym(f[2]) });
    }
    this.sheetsList = list;
    return list;
  };
  // The grid's own spelling of the sheet a text names, compared without case as the model compares names; null
  // for anything else.
  Host.prototype._sheetNamed = function (v) {
    if (typeof v !== 'string' || v === '') return null;
    var want = v.toLowerCase(), list = this._sheets();
    for (var i = 0; i < list.length; i++) if (list[i].name.toLowerCase() === want) return list[i].name;
    return null;
  };
  // The sheet a grid cartridge opens on (decision 2). Written to version 4: the one its Camera's third row names
  // at the load, a value or a formula's value row, else the first visible sheet of the record's sheet rows, the
  // cartridge's own order, so that a hidden Screen is never opened on. Written to 1 to 3: its Screen, through
  // the Camera's window, as before.
  Host.prototype._open = function () {
    if (!this._four()) { this._drawGrid(true); return; }
    var name = this._cameraSheetName(this.cameraSheet), list = this._sheets();
    for (var i = 0; name === null && i < list.length; i++) if (list[i].state === 'visible') name = list[i].name;
    this._showAt(name || 'Screen');
  };
  // A sheet the host shows itself, at the opening or for the Camera (decisions 2 and 5), as a tab clicked is
  // shown: the Screen through the Camera's window, as its tab gives it back, any other sheet through showSheet,
  // its load noted (ENGINE.17's rule), either counted a draw. Without a viewport the host keeps the name alone.
  Host.prototype._showAt = function (name) {
    this.shownName = name;
    if (isScreen(name)) { var self = this; this._quiet(function () { self._drawGrid(true); }); return; }
    var vp = this._viewport();
    if (vp && this.showSheet(vp, name)) this.c.draws++;
  };
  // The frame's draw when the Camera asked for a sheet (decision 5): that sheet shown, the frame's own draw and
  // never a still frame.
  Host.prototype._drawShown = function () {
    var name = this.showWanted;
    this.showWanted = null;
    this.c.shows++;
    this._showAt(name);
  };
  // The record a sheet is drawn from (decision 3): the values projection once a frame has computed values, the
  // grid record less its formula rows, as the Screen's frame is drawn (ENGINE.8's second slice), and the grid
  // record at frame 0, its formulas shown as their texts until their first values. viewRecord, a page's read of
  // a sheet's record, stays the grid record.
  Host.prototype._viewDrawn = function (sheet, win) {
    if (!this.m || !this.handle || this.inFrame) return null;
    var r = this.m.texts('alonzo_view', [this.handle], [this.frame > 0 ? 'values' : 'grid', sheet, win || '']);
    if (r.status !== 0) { this._sayOnce('record-' + sheet, 'The view of ' + sheet + ' was refused: ' + words(r) + '.', true); return null; }
    return r.text;
  };

  // A sheet shown in a viewport (decisions 2, 3 and 10): viewed through the region the viewport shows, from A1
  // at the default cell's size for a sheet it has not drawn, loaded and shown, then viewed again at once when
  // the sheet's own widths put more in view than the estimate did. A page's viewer of the sheets calls it to
  // show one by name. False, and a refusal said once, when the view is refused or a frame is in progress. The
  // record is the values projection after frame 0 (ENGINE.18, decision 3).
  Host.prototype.showSheet = function (vp, name) {
    if (!vp || !this.m || !this.handle) return false;
    this._learn(vp, name);
    var win = vp.fresh ? vp.fresh(name) : regionOf(vp, true), t = this._viewDrawn(name, win);
    if (t === null) return false;
    this._quiet(function () { vp.load(t, { keep: true }); vp.show(name); });
    this._noteLoad(vp, t);
    if (!within(regionOf(vp, false), win)) this.refreshSheet(vp);
    return true;
  };
  // A sheet's layout read before it is shown (CART.12's hand test, 2026-10-19): its last row, which no cell holds,
  // viewed across every column, a record of its columns with settings and its extent and of no cell, which the
  // viewport learns, so that it lays every column as the sheet sets it and a jump of the scroll draws the columns it
  // views; and whether the cartridge's manifest bounds the sheet to its extent (version 6). Refused, said once by the
  // view, the sheet is shown as before, its columns learned window by window.
  var LAYOUT_STRIP = 'A1048576:XFD1048576';
  Host.prototype._learn = function (vp, name) {
    if (vp.bound) vp.bound(name, this._bounded(name));
    if (!vp.learn) return;
    var t = this._viewDrawn(name, LAYOUT_STRIP);
    if (t !== null) vp.learn(t);
  };
  Host.prototype._bounded = function (name) {
    var b = this.cart && this.cart.bound ? this.cart.bound : [], want = String(name || '').toLowerCase();
    for (var i = 0; i < b.length; i++) if (b[i].toLowerCase() === want) return true;
    return false;
  };
  // The sheet a viewport shows, viewed again through the region it shows, its view kept (decision 3): at every
  // frame in the host's own viewport, at a page's refresh in its viewer. moved: only when the region has left
  // the window the sheet's record was viewed through, at a scroll. still: a record still the one the host last
  // loaded into the viewport is not loaded again, and in the host's own viewport the frame is counted still
  // (ENGINE.17); a frame passes it, and a page's refresh of its viewer may. The Screen in the host's own viewport
  // is the frame's own draw, through the Camera's window, and is left to it. True when a record was loaded. The
  // record is the values projection after frame 0 (ENGINE.18, decision 3).
  Host.prototype.refreshSheet = function (vp, moved, still) {
    if (!vp || this.quieting || !this.m || !this.handle || this.inFrame) return false;
    var name = vp.sheet(), model = vp.model();
    if (!name || !model || (vp === this.vp && isScreen(name))) return false;
    var win = regionOf(vp, false);
    if (moved && model.windowText && within(win, model.windowText)) return false;
    // A still refresh asks the window's changes first (ENGINE.19, decision 2): cells named since the held frame patch
    // the held record and the model in place, a load; none named hand the held record to the still sheet's test below,
    // in the place of a view; whole, or any other frame, views as before.
    var d = still ? this._byChanges(vp, name, win) : null;
    if (d && d.how === 'patch') { if (vp === this.vp) this.c.patches++; return true; }
    var t = d ? d.text : this._viewDrawn(name, win);
    if (t === null) return false;
    if (still && this._still(vp, t)) { if (vp === this.vp) this.c.stills++; return false; }   // a still sheet (ENGINE.17)
    this._quiet(function () { vp.load(t, { keep: true }); });
    this._noteLoad(vp, t);
    return true;
  };
  Host.prototype._quiet = function (fn) {
    var was = this.quieting;
    this.quieting = true;
    try { fn(); } finally { this.quieting = was; }
  };
  // The record the host last loaded into a viewport, and the model the viewport made of it (ENGINE.17). A text
  // is still when it is that record byte for byte and the viewport holds that very model, so that a record
  // anyone else loaded into it, or a viewport cleared, is never taken for the host's: the text names its sheet
  // and its window, and the model is the sheet the viewport shows.
  // Since ENGINE.19 the viewport's patches are noted with the load too, so that a model a page patched is never taken
  // for the host's; and the record's frame, sheet, range and projection, which its changes are asked against. A host
  // without a viewport holds its record under null, its text alone.
  Host.prototype._lastLoad = function (vp) {
    for (var i = 0; i < this.loads.length; i++) if (this.loads[i].vp === vp) return this.loads[i];
    var l = { vp: vp, text: null, model: null, patches: 0, frame: -1, sheet: '', range: '', values: false, rec: null };
    this.loads.push(l);
    return l;
  };
  Host.prototype._noteLoad = function (vp, text) {
    var l = this._lastLoad(vp), w = WINDOW_LINE.exec(text);
    l.text = text; l.model = vp ? vp.model() : null; l.patches = vp ? vp.patches() : 0;
    l.frame = this.frame; l.values = this.frame > 0; l.sheet = w ? unquote(w[1]) : ''; l.range = w ? w[2] : ''; l.rec = null;
  };
  Host.prototype._still = function (vp, text) {
    var l = this._lastLoad(vp);
    if (l.patches !== vp.patches()) return false;   // a model a page patched is never the host's (ENGINE.19)
    if (l.text === text && vp.model() === l.model) { l.frame = this.frame; l.values = this.frame > 0; }   // the held record this frame's too
    return l.text === text && vp.model() === l.model;
  };
  // A window's changes asked against the record a viewport, or a host without one, holds (ENGINE.19, decisions 2 and
  // 3): only while the viewport still holds the model the host noted, unpatched by anyone else, and the record is a
  // values record of the same sheet; and decided by the held frame, sheet and range. Cells named since the held frame
  // are laid on the held text by cell, joined at once, and on the viewport's model in place: { how: 'patch', text, view,
  // draw, cells }. None named, or the held frame's own: { how: 'still', text, view }, the held text, which the still
  // frame's test then finds as it finds a record viewed whole. Null for whole, another window or sheet, any other frame,
  // or a patch either side refuses, which forgets the held text so that the view that follows loads afresh.
  Host.prototype._byChanges = function (vp, sheet, win) {
    var l = this._lastLoad(vp);
    if (l.text === null || l.rec === false || !l.values || l.sheet.toLowerCase() !== String(sheet).toLowerCase()) return null;
    if (vp && (vp.model() !== l.model || vp.patches() !== l.patches)) return null;
    var t0 = this.now(), r = this.m.texts('alonzo_view', [this.handle], ['changes', sheet, win]), t1 = this.now();
    var ch = r.status === 0 ? readChanges(r.text) : null, how = decide(l, ch);
    if (how === 'whole') return null;
    if (how === 'still') return { how: how, text: l.text, view: t1 - t0 };
    if (l.rec === null) l.rec = byCell(l.text) || false;
    var text = l.rec ? patchRecord(l.rec, ch.rows) : null;
    if (text === null || (vp && !vp.patch(r.text))) { l.text = null; l.rec = null; return null; }
    l.text = text; l.frame = ch.at; l.patches = vp ? vp.patches() : 0;
    return { how: how, text: text, view: t1 - t0, draw: this.now() - t1, cells: ch.n };
  };
  Host.prototype._fit = function () {
    var c = this.cart, dpr = global.devicePixelRatio || 1;
    var bw = this.box ? this.box.clientWidth : c.w, bh = this.box ? this.box.clientHeight : c.h;
    var s = this.fixedScale || Math.max(1, Math.floor(Math.min(bw * dpr / c.w, bh * dpr / c.h)));
    if (s === this.scale && dpr === this.dpr && this.ctx && this.canvas.width === c.w * s) return;
    this.scale = s; this.dpr = dpr;
    this.canvas.width = c.w * s; this.canvas.height = c.h * s;
    this.canvas.style.width = (c.w * s / dpr) + 'px'; this.canvas.style.height = (c.h * s / dpr) + 'px';
    this.ctx = this.canvas.getContext('2d');
  };
  Host.prototype._readKeys = function () {
    var cells = this._cells('Keys');
    if (!cells) return;
    var km = [];
    for (var b = 0; b < 10; b++) {
      km.push([]);
      for (var p = 0; p < 4; p++) { var v = cells[PLAYERS[p] + (b + 1)]; km[b].push(typeof v === 'string' ? v : ''); }
    }
    this.keymap = km;
  };
  // The Commands sheet (ENGINE.25; docs/SPEC.md section 3.10), a cartridge's written to version 5, read at the load and
  // after each step by its changes: each row from 2 a command, in the sheet's order, its name, its words, whether it
  // holds now and its key's code, and since version 8 whether a held key's repeat runs it, column E (ENGINE.39), which the
  // engine holds a cartridge written to 5 to 7 out of. A row the host cannot take is said once, until it changes, and is
  // no command or has no key: a name that is no name or that a row above holds, a holds that is a text or an error, a key
  // that is no code; and a repeats that is no truth value is said so and runs once. A key goes to the first row holding
  // it now, and before a Keys button of the same code; each said once.
  Host.prototype._readCommands = function () {
    var cells = this._cells('Commands') || {}, self = this, before = this.badRows, now = {}, list = [], byName = {}, keys = {}, rows = {}, a, m, i;
    function note(key, text) { now[key] = text; if (before[key] !== text) self._say('frame ' + self.frame + ': ' + text); }
    for (a in cells) { m = /^([A-E])(\d+)$/.exec(a); if (m && +m[2] >= 2 && +m[2] <= MAX_COMMANDS + 1) rows[m[2]] = true; }
    var order = Object.keys(rows).map(Number).sort(function (x, y) { return x - y; });
    for (i = 0; i < order.length; i++) {
      var r = order[i], name = cells['A' + r], words = cells['B' + r], h = cells['C' + r], key = cells['D' + r];
      if (name === undefined || name === null || name === '') continue;   // no command, or a formula with no value yet
      if (typeof name !== 'string' || !COMMAND_NAME.test(name)) { note('A' + r, 'Commands!A' + r + ' holds ' + shownValue(name) + ', which is no command\'s name: a command is named in lowercase letters, digits and hyphens, so the row is no command (docs/SPEC.md section 3.10).'); continue; }
      if (byName[name]) { note('A' + r, 'Commands!A' + r + ' names ' + name + ', as A' + byName[name].row + ' does, so the row is no command (docs/SPEC.md section 3.10).'); continue; }
      var holds = holdsOf(h);
      if (holds === null) { note('C' + r, 'Commands!C' + r + ' holds ' + shownValue(h) + ', which is no truth value, so the ' + commandWords(name) + ' holds not (docs/SPEC.md section 3.10).'); holds = false; }
      // the key: a code, and at version 7 the keymap's modifiers before it (CART.3's second slice, decision 14), its code
      // the spelling printed back, so that one key spelled two ways is one key
      var code = '', chord = null;
      if (typeof key === 'string' && key !== '') {
        var ck = commandKeyOf(key, this._seven());
        if (!ck.error) { chord = ck; code = ck.text; }
        else if (ck.error === 'version 7') note('D' + r, 'Commands!D' + r + ' holds ' + shownValue(key) + ', a key with modifiers, which is version 7\'s, and the cartridge is written to version ' + (this.cart.spec || 1) + ', so the ' + commandWords(name) + ' has no key (docs/SPEC.md section 3.10).');
        else if (ck.error === 'no key\'s code') {
          var hint = /^[A-Za-z]$/.test(key) ? ': the key ' + key.toUpperCase() + ' is Key' + key.toUpperCase() : (/^[0-9]$/.test(key) ? ': the key ' + key + ' is Digit' + key : '');
          note('D' + r, 'Commands!D' + r + ' holds ' + shownValue(key) + ', which is no key\'s code' + hint + ', so the ' + commandWords(name) + ' has no key (docs/SPEC.md section 3.10).');
        }
        else note('D' + r, 'Commands!D' + r + ' holds ' + shownValue(key) + ', whose modifiers this page does not read, ' + ck.error + ', so the ' + commandWords(name) + ' has no key (docs/SPEC.md section 3.10).');
      }
      else if (key !== undefined && key !== null && key !== '') note('D' + r, 'Commands!D' + r + ' holds ' + shownValue(key) + ', which is no key\'s code, so the ' + commandWords(name) + ' has no key (docs/SPEC.md section 3.10).');
      // whether a held key's repeat runs it, version 8's column E (ENGINE.39), none below 8
      var repeats = this._eight() ? repeatsOf(cells['E' + r]) : false;
      if (repeats === null) { note('E' + r, 'Commands!E' + r + ' holds ' + shownValue(cells['E' + r]) + ', which is no truth value, so a held key runs the ' + commandWords(name) + ' once (docs/SPEC.md section 3.10).'); repeats = false; }
      var cmd = { name: name, words: typeof words === 'string' ? words : (typeof words === 'number' || typeof words === 'boolean' ? String(words) : ''), holds: holds, code: code, chord: chord, repeats: repeats, row: r };
      byName[name] = cmd; list.push(cmd);
      if (!code || !holds) continue;
      if (keys[code]) { note('key-' + code, 'Commands!D' + r + ' gives ' + code + ', as D' + keys[code].row + ' does while both hold, so the ' + commandWords(keys[code].name) + ' takes it.'); continue; }
      keys[code] = cmd;
      // a Keys button's key is bare, so a key with modifiers shares none (docs/SPEC.md section 3.4)
      for (var b = 0; chord.bare && this.keymap && b < this.keymap.length; b++) for (var p = 0; p < this.keymap[b].length; p++) {
        if (this.keymap[b][p] === code && now['button-' + code] === undefined) note('button-' + code, 'Commands!D' + r + '\'s ' + code + ' is the Keys sheet\'s ' + PLAYERS[p] + (b + 1) + ' too, so the ' + commandWords(name) + ' takes it while it holds.');
      }
    }
    this.badRows = now; this.commandList = list; this.commandKeys = keys;
  };
  // The cartridge's commands as the Commands sheet last said them (ENGINE.25), in the sheet's order: { name, words,
  // holds, key, repeats }, its key the code or empty, and since version 8 whether a held key's repeat runs it (ENGINE.39);
  // none for a cartridge written to 1 to 4 or without a Commands sheet.
  Host.prototype.commands = function () {
    return this.commandList.map(function (x) { return { name: x.name, words: x.words, holds: x.holds, key: x.code, repeats: x.repeats }; });
  };
  // Whether a key's repeat is fresh (ENGINE.39; docs/SPEC.md section 3.10): nothing of the cartridge's waiting, at a rate
  // no command waiting for its frame and at rate 0 no act waiting or stepping, and the key pressed at or after the moment
  // the last act came to rest, so that a repeat the browser kept behind a step runs nothing and a key let go stops its
  // command at once. ev, the key's event; own, a command of the page's own, judged by its time alone. One rule, the
  // host's, for a command's own key and for every binding a page presses at a repeat.
  Host.prototype.freshRepeat = function (ev, own) {
    if (!own && this.cart) {
      var waits = this.cart.rate > 0
        ? this.waiting.length + this.edits.filter(function (x) { return x && x.command !== undefined; }).length > 0
        : this.inFrame || this.edits.length > 0 || this.settling;
      if (waits) return false;
    }
    var t = this.keyTime(ev);
    return t === null || t === undefined || this.restAt === null || t >= this.restAt;
  };
  // An act come to rest (ENGINE.39): the moment a repeat after it is judged by. The host notes its own steps; a page notes a
  // press of its own commands, whose act is the page's.
  Host.prototype.rested = function () { this.restAt = this.now(); };
  // A cartridge's command run (ENGINE.25; docs/SPEC.md section 3.10), as a page's palette or a person's binding asks, or
  // its key on the Screen (how 'key'): by its name as the Commands sheet spells it, as the last step left the sheet. It
  // waits for the next frame, one a frame and sixteen at most, and is written into Input!B20 for that frame alone; at
  // rate 0 it steps the grid once, as an edit does. Refused, said and counted: no cartridge, one written to 1 to 4, a
  // name the sheet holds no command of, a command that holds not, a replay playing, or sixteen waiting already.
  Host.prototype.command = function (name, how) {
    var n = String(name === undefined || name === null ? '' : name), c = this.cart, cmd = null, i, self = this;
    function no(why) { self.c.commandsRefused++; return self._fail('The ' + commandWords(n || '(no name)') + ' was not run: ' + why); }
    if (!this.handle || !c) return no('no cartridge is loaded.');
    if (!this._five()) return no('the cartridge is written to the page\'s version ' + (c.spec || 1) + ', and a cartridge\'s own commands are version 5\'s (docs/SPEC.md section 3.10).');
    for (i = 0; i < this.commandList.length; i++) if (this.commandList[i].name === n) { cmd = this.commandList[i]; break; }
    if (!cmd) return no('the Commands sheet names no such command' + (this.commandList.length ? '; its commands are ' + this.commandList.map(function (x) { return x.name; }).join(', ') : '') + '.');
    if (!cmd.holds) return no('it holds not now, as Commands!C' + cmd.row + ' says.');
    if (this.player) return no('a replay is playing, frame ' + this.frame + ' of ' + this.player.last + ', and a person\'s acts wait until it ends, so that what plays is the replay alone.');
    var queued = this.waiting.length + this.edits.filter(function (x) { return x && x.command !== undefined; }).length;
    if (queued >= COMMANDS_WAITING) return no(COMMANDS_WAITING + ' commands wait for their frames already, one a frame.');
    if (c.rate === 0) {
      this.edits.push(this._sixAtZero() ? { command: cmd.name, place: this._place() } : { command: cmd.name });   // its place, version 6's (CART.12)
      if (!this.inFrame) this._editFrames(this._window());
    } else {
      this.waiting.push(cmd.name);
      if (!this.running) this._answer('frame ' + this.frame + ': the ' + commandWords(cmd.name) + ' waits for the next frame, which Run brings: the loop is paused at ' + c.rate + ' frame' + (c.rate === 1 ? '' : 's') + ' a second.');
    }
    return { ok: true, name: cmd.name, how: how || 'page' };
  };
  Host.prototype._readAudio = function () {
    var cells = this._cells('Audio');
    if (!cells) return;
    var voices = [];
    for (var r = 2; r <= 5; r++) voices.push({ voice: cells['A' + r], wave: cells['B' + r], note: cells['C' + r], volume: cells['D' + r] });
    this.audio = voices;
  };
  Host.prototype._readFile = function () {
    var cells = this._cells('File');
    if (!cells) return;
    var v = cells.B3 === 1 ? 1 : 0;
    // on its rising edge the cartridge's save, taken as a person's is (ENGINE.5; docs/SPEC.md section 3.7)
    var rose = v === 1 && this.saveValue !== 1;
    this.saveValue = v;
    if (rose) { this.c.saves++; this._say('frame ' + this.frame + ': the cartridge asked to be saved (File!B3 rose to 1).'); this.saveAsked = 'cartridge'; }
  };
  // The Clock's rate (ENGINE.3, decision 3): a person may write Clock!B2, 0 or a whole number from 1
  // to 120, which the engine holds to that range, and the loop steps at what the grid says, the
  // teacher of section 9 who slows a rule to watch it think. A rate that moves starts the backlog
  // again with nothing owed, so a rise from 1 to 30 runs no burst of the slow rate's backlog; from a
  // rate to 0 the ticks stop and an edit steps; from 0 to a rate they start again.
  Host.prototype._readClock = function () {
    var cells = this._cells('Clock');
    if (!cells) return;
    var v = cells.B2, c = this.cart;
    if (typeof v !== 'number' || Math.floor(v) !== v || v < 0 || v > MAX_RATE || v === c.rate) return;
    var was = c.rate;
    c.rate = v;
    this.acc = 0;
    if (was === 0) this.lastTs = null;
    // commands waiting for frames that a rate of 0 brings no more: each its own step among the edits (ENGINE.25)
    if (v === 0) while (this.waiting.length) this.edits.push({ command: this.waiting.shift() });
    this._say('frame ' + this.frame + ': the Clock\'s rate is now ' + (v === 0 ? '0 (Clock!B2): the loop steps once for each edit, and the Input sheet keeps what it last held.' : v + ' frame' + (v === 1 ? '' : 's') + ' a second (Clock!B2); the loop steps at it.'));
  };
  // The Write sheet's rows become the next frame's derived writes (section 3.9).
  Host.prototype._readWrite = function () {
    var cells = this._cells('Write');
    if (!cells) return;
    var seen = {}, list = [];
    for (var a in cells) { var m = /^([ABC])(\d+)$/.exec(a); if (m && +m[2] >= 2) seen[m[2]] = true; }
    var rows = Object.keys(seen).map(Number).sort(function (x, y) { return x - y; });
    for (var i = 0; i < rows.length; i++) {
      var r = rows[i], sheet = cells['A' + r], addr = cells['B' + r], val = cells['C' + r];
      if (typeof addr !== 'string' || addr === '') continue;
      if (typeof sheet !== 'string' || sheet === '' || val === undefined || val === null || typeof val === 'object') {
        this._sayOnce('write-' + r, 'frame ' + this.frame + ': Write!A' + r + ':C' + r + ' is not a sheet, an address and a value; no write.', true);
        continue;
      }
      list.push({ text: '(derived ' + quote(sheet) + ' ' + quote(addr) + ' ' + spell(val) + ')', where: sheet + '!' + addr });
    }
    this.pending = list;
  };

  // ---- the sound (step 6; docs/SPEC.md section 3.6; ENGINE.4) ----
  // A frame's four voices on the audio clock (decision 1). A frame sounds where the last frame's sound
  // ends, the last frame's time and 1/rate, the rate the host read after it; while the loop keeps up the
  // frames lie end to end, so a rhythm in the cells is a rhythm in the sound whatever the display's
  // interval. A frame whose time has passed starts the timeline again a lookahead ahead of the clock; a
  // frame further ahead than twice the lookahead is not sounded and the timeline stays where it was, so a
  // burst after a stall sounds its first frames and skips the rest, as its screen shows only its last. At
  // rate zero every step sounds a lookahead ahead and holds until the next. Nothing sounds while the loop
  // is stopped or the page hidden, or before a person turns the sound on.
  Host.prototype._sound = function () {
    var s = this.snd, c = this.cart;
    if (!c || !c.devices.audio || !this.running || this.hidden) return;
    if (!this._soundOn()) { this._wantSound(); return; }
    var now = s.now(), at;
    if (c.rate > 0 && s.end !== null) {
      at = s.end;   // the end of the last frame's sound (decision 1)
      if (at < now) { at = now + LOOKAHEAD; this.c.restarts++; }
      else if (at > now + 2 * LOOKAHEAD) { this.c.skipped++; return; }
    } else {
      at = now + LOOKAHEAD;
      if (c.rate > 0) this.c.restarts++;
    }
    s.end = c.rate > 0 ? at + 1 / c.rate : null;
    s.silent = false;
    this._graph();
    for (var i = 0; i < 4; i++) this._voiceAt(s.voices[i], this._voiceOf(i), at);
    this.c.sounded++;
  };
  // The sound on: a context the host was handed, or one made at Sound on that the browser runs.
  Host.prototype._soundOn = function () { var s = this.snd; return s.on && !!s.ctx && (s.injected || s.ctx.state === 'running'); };
  // The graph, made once for its context (decision 2): one gain into the destination and a gain a voice into
  // it, each voice silent until a frame sounds it; an oscillator is made when its voice first sounds.
  Host.prototype._graph = function () {
    var s = this.snd;
    if (s.voices) return;
    s.master = s.ctx.createGain();
    s.master.gain.value = 1;
    s.master.connect(s.ctx.destination);
    s.voices = [];
    for (var i = 0; i < 4; i++) {
      var g = s.ctx.createGain();
      g.gain.value = 0;
      g.connect(s.master);
      s.voices.push({ gain: g, osc: null, wave: null, freq: null, target: 0 });
    }
  };
  // A voice's row judged (decision 4): the volume first, empty 0 and a number from 0 to 1 itself, 0 a rest
  // whatever the rest of the row holds; above it, the wave one of the four words, compared without case as
  // the model compares names, and the note a number from 0 to 127, a fraction allowed, its frequency the
  // host's 440 * 2^((note - 69) / 12). Anything else silences the voice for the frame.
  Host.prototype._voiceOf = function (i) {
    var row = this.audio[i] || {}, r = i + 2, bad = this.snd.bad, vol = row.volume;
    if (vol === null || vol === undefined) vol = 0;
    if (typeof vol !== 'number' || !(vol >= 0 && vol <= 1)) return this._voiceBad(i, 'volume', 'D' + r, row.volume, 'a number from 0 to 1');
    bad[i + ' volume'] = undefined;
    if (vol === 0) return { gain: 0 };
    var wave = typeof row.wave === 'string' ? row.wave.toLowerCase() : null;
    if (WAVES.indexOf(wave) < 0) return this._voiceBad(i, 'wave', 'B' + r, row.wave, WAVES.slice(0, 3).join(', ') + ' or ' + WAVES[3]);
    bad[i + ' wave'] = undefined;
    var note = row.note;
    if (typeof note !== 'number' || !(note >= 0 && note <= MAX_NOTE)) return this._voiceBad(i, 'note', 'C' + r, note, 'a number from 0 to ' + MAX_NOTE);
    bad[i + ' note'] = undefined;
    return { gain: vol * VOICE_SHARE, wave: wave, freq: 440 * Math.pow(2, (note - 69) / 12) };
  };
  // Said once for each cell and each value shown, as a Camera cell is (section 3.8): a notice and not a
  // refusal, since the Audio sheet is read after a step and never refused.
  Host.prototype._voiceBad = function (i, what, addr, v, want) {
    var shown = v === null || v === undefined ? 'empty' : (typeof v === 'string' ? '"' + v + '"' : (typeof v === 'object' ? 'an error, ' + v.error : String(v)));
    if (this.snd.bad[i + ' ' + what] !== shown) {
      this.snd.bad[i + ' ' + what] = shown;
      this._say('frame ' + this.frame + ': voice ' + (i + 1) + '\'s ' + what + ', Audio!' + addr + ', is ' + shown + ', not ' + want + '; the voice is silent.');
    }
    return { gain: 0 };
  };
  // One voice at a frame's time (decisions 2 and 3): only what changed. A silent voice changes its gain
  // alone; a wave cannot be scheduled, its type taking effect when the JavaScript runs (measured), so a
  // wave changed is a new oscillator started at a time on the audio clock as the old one stops, through a
  // dip while the voice sounds; a pitch is set at the frame's time, the oscillator keeping its phase.
  Host.prototype._voiceAt = function (v, want, at) {
    if (want.gain === 0) { if (v.target !== 0) this._target(v, 0, at); return; }
    if (!v.osc) { this._oscillator(v, want, at); this._target(v, want.gain, at); return; }
    if (want.wave !== v.wave) {
      var sw = v.target > 0 ? at + DIP_TAUS * GAIN_TAU : at;   // through a dip while the voice sounds
      if (sw !== at) this._target(v, 0, at);
      v.osc.stop(sw);
      this._oscillator(v, want, sw);
      this._target(v, want.gain, sw);
      return;
    }
    if (want.freq !== v.freq) { v.osc.frequency.setValueAtTime(want.freq, at); v.freq = want.freq; }
    if (want.gain !== v.target) this._target(v, want.gain, at);
  };
  Host.prototype._oscillator = function (v, want, at) {
    var o = this.snd.ctx.createOscillator();
    o.type = want.wave;
    o.frequency.setValueAtTime(want.freq, at);
    o.connect(v.gain);
    o.start(at);
    v.osc = o; v.wave = want.wave; v.freq = want.freq;
  };
  Host.prototype._target = function (v, value, at) {
    v.gain.gain.setTargetAtTime(value, at, GAIN_TAU);   // the graph's own approach, never a sample of the host's (decision 3)
    v.target = value;
  };
  // The voices stopped with the loop (decision 6): every voice's later events canceled and its gain
  // approaching 0 from the audio clock's now; the timeline and each voice's pitch forgotten, so that the
  // next frame sets every voice whole. A voice already silent since its last silence is left alone.
  Host.prototype._silence = function () {
    var s = this.snd;
    s.end = null;
    if (s.silent || !s.voices) return;
    var now = s.now();
    for (var i = 0; i < 4; i++) {
      var v = s.voices[i];
      v.gain.gain.cancelScheduledValues(now);
      this._target(v, 0, now);
      if (v.osc) { v.osc.frequency.cancelScheduledValues(now); v.freq = null; }
    }
    s.silent = true;
    this.c.silences++;
  };
  // At an unload and at Sound off, after the silence: the oscillators stopped once the release is over.
  Host.prototype._release = function () {
    var s = this.snd;
    if (!s.voices) return;
    var now = s.now();
    for (var i = 0; i < 4; i++) {
      var v = s.voices[i];
      if (!v.osc) continue;
      v.osc.stop(now + RELEASE_TAUS * GAIN_TAU);
      v.osc = null; v.wave = null; v.freq = null;
    }
  };
  // The loop started, or the page shown again (decision 6): the frame the grid holds sounds at once, a
  // lookahead ahead, its Audio sheet read as it stands.
  Host.prototype._resound = function () {
    var c = this.cart;
    if (!this.handle || !c || !c.devices.audio || !this.running || this.hidden || this.inFrame || !this._soundOn()) return;
    this._readAudio();
    this.snd.end = null;
    this._sound();
  };
  // The sound off while a voice would sound (decision 5; SD-30): said once a load.
  Host.prototype._wantSound = function () {
    var s = this.snd;
    if (s.wanted || s.on) return;
    for (var i = 0; i < 4; i++) {
      var r = this.audio[i], vol = r ? r.volume : null;
      if (typeof vol === 'number' && vol > 0) {
        s.wanted = true;
        this._say('frame ' + this.frame + ': the Audio sheet\'s voices would sound now: press Sound on to hear them (the browser lets a page sound only after a person\'s act).');
        return;
      }
    }
  };
  // Sound on (decision 5): the audio context made at a person's act, the press of the panel's button, which
  // is what Chrome's autoplay policy asks for (a context made before one stays suspended, measured); the
  // frame the grid holds sounds at once. Sound off: the voices silenced and stopped, the context suspended
  // once the release is over.
  Host.prototype.soundOn = function () {
    var s = this.snd, self = this;
    if (!s.ctx) {
      var AC = global.AudioContext || global.webkitAudioContext;
      if (!AC) return this._answerFailed('This browser has no Web Audio: the Audio sheet is read and never heard.');
      try { s.ctx = new AC(); } catch (e) { return this._answerFailed('The browser made no audio context: ' + (e && e.message ? e.message : e) + '.'); }
      s.now = function () { return s.ctx.currentTime; };
      s.ctx.onstatechange = function () { if (s.on && s.ctx.state === 'running') self._resound(); };
    }
    s.on = true;
    if (s.ctx.state !== 'running' && s.ctx.resume) s.ctx.resume();
    this._answer('Sound on: ' + (this.cart && this.cart.devices.audio ? 'the Audio sheet\'s four voices sound on the audio clock, ' + (LOOKAHEAD * 1000) + ' ms ahead of it.' : 'this cartridge has no Audio sheet, so nothing sounds.'));
    this._resound();
    return { ok: true };
  };
  Host.prototype.soundOff = function () {
    var s = this.snd;
    if (!s.on) return { ok: true };
    this._silence();
    this._release();
    s.on = false;
    if (s.ctx && !s.injected && s.ctx.suspend) global.setTimeout(function () { if (!s.on) s.ctx.suspend(); }, 1000 * RELEASE_TAUS * GAIN_TAU + 20);
    this._answer('Sound off.');
    return { ok: true };
  };
  Host.prototype.soundIs = function () { return this.snd.on; };

  // ---- a person's acts: edits, keys, the pointer ----
  // An edit is one cell or formula row, issued as its own write after the frame's inputs; at
  // rate zero it steps the grid once, and the frame number counts the edits that landed.
  Host.prototype.edit = function (row) {
    var t = String(row || '').trim(), forms = VP().readForms(t);
    var head = forms.length === 1 && Array.isArray(forms[0]) ? sym(forms[0][0]) : null;
    if (head !== 'cell' && head !== 'formula' && head !== 'empty') { this._answerRefused('An edit is one cell, formula or empty row, as (cell "Palette" "B1" "#FF8800") or (empty "Work" "A1:B2"); ' + (t || 'an empty line') + ' is not one.'); return false; }
    if (!this.handle) { this._answerRefused('No cartridge is loaded to edit.'); return false; }
    var into = str(forms[0][1]);
    if (into !== null && this.sheetMode(into).read) {   // a read-only sheet (SPEC.5), its cartridge's rows and the Write sheet's still writing it
      this.c.editsRead++;
      this._answerRefused('The edit ' + t + ' was not written: ' + into + ' is a read-only sheet, named by the manifest\'s (read ...); the cartridge\'s own rows still write it (version 6, docs/SPEC.md section 7.2).');
      return false;
    }
    if (this.player) { this._answerRefused('The edit ' + t + ' was not written: a replay is playing, frame ' + this.frame + ' of ' + this.player.last + ', and a person\'s edit waits until it ends, so that what plays is the replay alone.'); return false; }
    // at rate 0 a version 6 cartridge's edit stands on the cell the selection stands on when it is made (CART.12); and an edit
    // of a work sheet at rate 0 joins the run's line (ENGINE.30's first slice)
    var entry = this._undoEntry([t], null, 'the edit ' + t), act = this._sixAtZero() ? { row: t, place: this._place() } : entry ? { row: t } : t;
    if (entry) act.undoEntry = entry;
    this.edits.push(act);
    if (this.cart.rate === 0 && !this.inFrame) this._editFrames(this._window());
    // At a rate above zero the edit is written at the next frame, which a paused loop does not bring until Run:
    // said, so that an edit is never silent (the owner's hand test of ENGINE.8, 2026-10-12: the grid card,
    // paused, took an edit and showed nothing).
    else if (this.cart.rate > 0 && !this.running) this._answer('frame ' + this.frame + ': the edit ' + t + ' waits for the next frame, which Run brings: the loop is paused at ' + this.cart.rate + ' frame' + (this.cart.rate === 1 ? '' : 's') + ' a second.');
    return true;
  };
  // ---- copy, cut and paste in the grid (ENGINE.39's second slice; docs/SPEC.md section 7.2) ----
  // The page keeps the clipboard's text, its own copy and a cut's mark, and writes a paste's rows; the host reads the cells a
  // copy takes, refuses or takes the paste as one act, and says each act's answer.
  // The cells of a range of a sheet as the sheet is drawn (decision 7), and since the third slice its formulas (decision 13).
  // The cells through the record the sheet is drawn from, the values projection after frame 0 and the grid record at frame
  // 0, a formula shown as its text until its first value; the formulas after frame 0 through the fills record, each fill's
  // formula row printed once over each of its rectangles in the range, so that a board of one fill copies one formula and
  // not one a cell (its values are runs, which the viewport's reader takes no row of, so the values projection gives them),
  // and at frame 0 the grid record's own, a cell's each. range, { top, left, bottom, right }. { ok, sheet, range, rows,
  // fills }: each row an array of { shown, value, formula, empty }, the text the cell shows, its value as a cell row spells
  // it, exact where its shown text rounds, the empty text for an empty cell, whether a formula computed it, and since
  // ENGINE.30's first slice whether the cell holds nothing, which a paste empties, told from one holding the empty text,
  // which a paste writes (an empty cell's empty true, a cell's absent); and fills, each
  // formula's rectangle in the range and the text of its first cell, { top, left, bottom, right, text }. A date, which no
  // cell row holds, and a formula with no value yet keep the text they show. Else { ok: false, sentence }, said as the act's
  // refusal.
  Host.prototype.cellsOf = function (sheet, range) {
    if (!this.handle || !this.cart) return this._answerFailed('Nothing was copied: no cartridge is loaded.');
    if (this.inFrame) return this._answerFailed('Nothing was copied: frame ' + (this.frame + 1) + ' is being computed, and a copy takes the cells as a frame left them; copy again once it lands.');
    var win = VP().rangeText(range), t = this._viewDrawn(sheet, win);
    if (t === null) return { ok: false, sentence: 'The view of ' + sheet + ' was refused.' };
    var f = this.frame > 0 ? this.m.texts('alonzo_view', [this.handle], ['fills', sheet, win]) : { status: 0, text: t };
    if (f.status !== 0) return this._answerFailed('Nothing was copied: the view of ' + sheet + '\'s formulas was refused: ' + words(f) + '.');
    var m = VP().readRecord(t), rows = [], fills = [];
    for (var r = range.top; r <= range.bottom; r++) {
      var line = [];
      for (var c = range.left; c <= range.right; c++) line.push(copiedCell(m.cells.get(r + ',' + c)));
      rows.push(line);
    }
    VP().readForms(f.text).forEach(function (f) {
      var q = Array.isArray(f) && sym(f[0]) === 'formula' && str(f[2]) !== null && str(f[3]) !== null ? VP().parseRange(str(f[2])) : null;
      if (q && !q.rows && !q.columns) fills.push({ top: q.top, left: q.left, bottom: q.bottom, right: q.right, text: str(f[3]) });
    });
    return { ok: true, sheet: sheet, range: { top: range.top, left: range.left, bottom: range.bottom, right: range.right }, rows: rows, fills: fills };
  };
  // A formula's text moved as Excel moves a formula copied dRow rows down and dCol columns right (ENGINE.39's third slice,
  // decision 13): the language's own mover, through the module's thirteenth export, a part moved off the sheet #REF!. The
  // text, or null over a module without the export, the double's, whose paste then writes a formula's value, said.
  Host.prototype.moved = function (text, dRow, dCol) {
    if (!this.m || typeof this.m.x.alonzo_moved !== 'function') return null;
    if (!dRow && !dCol) return String(text);
    var r = this.m.texts('alonzo_moved', [dRow | 0, dCol | 0], [String(text)]);
    return r.status === 0 ? r.text : null;
  };
  function copiedCell(e) {
    if (!e || e.kind === 'empty') return { shown: '', value: '""', formula: false, empty: true };
    if (e.kind === 'formula' && !e.valued) return { shown: e.text, value: quote(e.text), formula: true };
    var v = e.value !== undefined ? e.value : e.text, k = e.vkind, spelled;
    if (k === 'number') spelled = v;
    else if (k === 'bool') spelled = v === 'TRUE' ? 'true' : 'false';
    else if (k === 'error') spelled = '(error ' + quote(v) + ')';
    else spelled = quote(k === 'date' ? e.text : v);
    return { shown: e.text, value: spelled, formula: e.kind === 'formula' };
  }
  // A sheet's extent as its record says it, { top, left, bottom, right }: the cells it holds, which a selection of whole rows
  // or columns or of the sheet copies within; null for a sheet holding none, or a view refused.
  Host.prototype.extentOf = function (sheet) {
    var t = this._viewDrawn(sheet, LAYOUT_STRIP);
    return t === null ? null : (VP().readRecord(t).extent || null);
  };
  // A page's own act answered (ENGINE.42), its copy's, its cut's and a cut let go (ENGINE.39): said as the host says an act's
  // answer, so that the bar and the log both hold it. refused, a refusal.
  Host.prototype.sayAct = function (text, refused) { this._say(String(text), 'event', !!refused, true); };
  // A paste (decisions 9 to 12): rows a page wrote from the clipboard's text, or from its own copy, written at the act's frame
  // as one write, all or none, in the place of a person's edits, one step at rate 0, and recorded as its rows in its frame.
  // p: { sheet, range, rows, what, done, place, move }: rows each { row, sheet, address, kind } with kind 'value', 'formula'
  // or 'empty', a cell emptied as Delete empties one; range the cells it writes on the sheet; what and done its words before
  // it lands and after; place the cell an act stands on at rate 0 (version 6), the range's corner; and move whether it moves
  // a cut's cells, the cut's emptied in the same write. Refused whole and said, nothing written: no cartridge; a replay
  // playing, as every edit is; a read-only sheet it writes, a cut's among them (SPEC.5); a value into a game sheet a person
  // writes, where a formula and an emptied cell alone are taken (CART.9's decisions 49 and 50); and a cell past the sheet's
  // edge, a bound sheet's extent, which a write would grow, or the Screen's window where no Camera places it, the first
  // named. True where the act waits for its frame or has landed.
  Host.prototype.paste = function (p) {
    if (!this.handle || !this.cart) { this._answerRefused('Nothing was pasted: no cartridge is loaded.'); return false; }
    var what = p.what.charAt(0).toUpperCase() + p.what.slice(1);
    if (this.player) { this._answerRefused(what + ' was not written: a replay is playing, frame ' + this.frame + ' of ' + this.player.last + ', and a person\'s edit waits until it ends, so that what plays is the replay alone.'); return false; }
    var modes = {}, i, x, m;
    for (i = 0; i < p.rows.length; i++) {
      x = p.rows[i];
      m = modes[x.sheet] || (modes[x.sheet] = this.sheetMode(x.sheet));
      if (m.read) { this.c.editsRead++; this._answerRefused(what + ' was not written: ' + x.sheet + ' is a read-only sheet, named by the manifest\'s (read ...); the cartridge\'s own rows still write it (version 6, docs/SPEC.md section 7.2).'); return false; }
      if (m.game && x.kind === 'value') { this._answerRefused(what + ' was not written: ' + x.sheet + ' is the game\'s, where a person writes a formula and no value, and ' + x.sheet + '!' + x.address + ' would hold a value (version 6, docs/SPEC.md section 7.2).'); return false; }
    }
    var past = this._pastEdge(p.sheet, p.range);
    if (past) { this._answerRefused(what + ' was not written: ' + past + '.'); return false; }
    var act = { paste: true, what: p.what, done: p.done, move: !!p.move, rows: p.rows.map(function (y) { return y.row; }) };
    if (this._sixAtZero()) act.place = p.place;   // the cell the act stands on (CART.12)
    var entry = this._undoEntry(act.rows, { sheet: p.sheet, range: p.range }, p.what);   // ENGINE.30's first slice: one act, one step back
    if (entry) act.undoEntry = entry;
    this.edits.push(act);   // one act, all or none (decision 10)
    if (this.cart.rate === 0 && !this.inFrame) this._editFrames(this._window());
    else if (!this.running && this.cart.rate > 0) this._answer('frame ' + this.frame + ': ' + p.what + ' waits for the next frame, which Run brings: the loop is paused at ' + this.cart.rate + ' frame' + (this.cart.rate === 1 ? '' : 's') + ' a second.');
    return true;
  };
  // The first cell of a paste past an edge (decision 9), in words, or the empty text: the Screen's window where no Camera
  // sheet places it, which the engine refuses too; a bound sheet's extent (version 6), which a write would grow, so that a
  // board's edge holds; and the sheet's own, 1,048,576 rows by 16,384 columns. r, { top, left, bottom, right }.
  var SHEET_ROWS = 1048576, SHEET_COLS = 16384;
  Host.prototype._pastEdge = function (sheet, r) {
    var c = this.cart, edges = [], ext;
    if (isScreen(sheet) && !c.devices.camera) edges.push({ rows: c.h, cols: c.w, words: 'the Screen\'s window, ' + rangeOf(1, 1, c.h, c.w) });
    if (this._bounded(sheet) && (ext = this.extentOf(sheet))) edges.push({ rows: ext.bottom, cols: ext.right, words: 'the extent ' + sheet + ' is bound to, ' + VP().rangeText(ext) });
    edges.push({ rows: SHEET_ROWS, cols: SHEET_COLS, words: 'the sheet\'s last cell, XFD1048576' });
    for (var i = 0; i < edges.length; i++) {
      var e = edges[i], cell = r.right > e.cols ? VP().colName(Math.max(r.left, e.cols + 1)) + r.top : r.bottom > e.rows ? VP().colName(r.left) + Math.max(r.top, e.rows + 1) : '';
      if (cell) return 'it reaches ' + sheet + '!' + cell + ', past ' + e.words;
    }
    return '';
  };

  // ---- undo and redo, Excel's kind (ENGINE.30's first slice; docs/SPEC.md section 7.2) ----
  // The owner's rule: a game is never undone. A person's edit of a work sheet at rate 0, a sheet the manifest names work or
  // names neither game nor read, a paste and a cut's move each one, keeps the cells it replaced, read as the grid holds them
  // just before its write; undo writes them back as one new act, the cells that held nothing emptied by an (empty ...) row,
  // recorded in the replay as the writes it made, and redo writes the act again. A game's move at rate 0 leaves the line
  // standing; an undo or a redo over a cell the cartridge has written since is refused and said; an edit after an undo lets
  // the edits undone go, said; and at a rate undo takes nothing back, said. No keyframe and no snapshot of the grid: the
  // line is the acts' rows and the cells they replaced.
  // The line's length, Excel's 100 levels, the oldest let go silently past it; and the cells an act may reach and be kept, a
  // lattice of 512 by 512, a larger act landing with its undo refused and said.
  var UNDO_DEPTH = 100, UNDO_CELLS = 262144;
  function areaOf(r) { return (r.bottom - r.top + 1) * (r.right - r.left + 1); }
  function joinOf(a, b) { return { top: Math.min(a.top, b.top), left: Math.min(a.left, b.left), bottom: Math.max(a.bottom, b.bottom), right: Math.max(a.right, b.right) }; }
  // A row's rectangle joined to a target of its sheet where their join is at most twice the two, else a target of its own:
  // a paste's cells one rectangle, and a cut's source another where it stands far from them.
  function undoTarget(targets, sheet, q) {
    for (var i = 0; i < targets.length; i++) {
      var t = targets[i];
      if (t.sheet.toLowerCase() !== sheet.toLowerCase()) continue;
      var j = joinOf(t.range, q);
      if (areaOf(j) <= 2 * (areaOf(t.range) + areaOf(q))) { t.range = j; return; }
    }
    targets.push({ sheet: sheet, range: { top: q.top, left: q.left, bottom: q.bottom, right: q.right } });
  }
  // The line's entry for an act's rows, or null where the act is none of a person's edits of a work sheet at rate 0: targets,
  // the rectangles its rows reach; select, the sheet and range a step back shows and selects, the act's own range by
  // default; words, the act in a sentence; rows, what a redo writes again; and unkept, why its undo is refused where the line
  // cannot keep it, more than UNDO_CELLS, so that an undo never passes over it to the one before. Whole rows or columns are
  // none, the engine refusing them in a row (vla-lang's parse_a1_range).
  Host.prototype._undoEntry = function (rows, select, words) {
    if (!this.cart || this.cart.rate !== 0 || this.player) return null;
    var targets = [], cells = 0, i;
    for (i = 0; i < rows.length; i++) {
      var f = VP().readForms(String(rows[i]))[0], head = Array.isArray(f) ? sym(f[0]) : null;
      var sheet = head ? str(f[1]) : null, q = sheet !== null && str(f[2]) !== null ? VP().parseRange(str(f[2])) : null;
      if ((head !== 'cell' && head !== 'formula' && head !== 'empty') || !q || q.rows || q.columns) return null;
      var mode = this.sheetMode(sheet);
      if (mode.game || mode.read) return null;   // a game's sheet or a read-only one: never the page's to undo
      undoTarget(targets, sheet, q);
    }
    if (!targets.length) return null;
    for (i = 0; i < targets.length; i++) cells += areaOf(targets[i].range);
    var unkept = cells > UNDO_CELLS ? 'it reaches ' + thousands(cells) + ' cells, more than the ' + thousands(UNDO_CELLS) + ' a step back keeps' : '';
    return { words: words, rows: rows.slice(), targets: unkept ? [] : targets, unkept: unkept,
             select: select || { sheet: targets[0].sheet, range: targets[0].range }, before: null, after: null, restored: null };
  };
  // The cells of a range as the grid holds them, read through the record of the cells as written, the grid projection,
  // whatever frame it is: each cell's own row, a value as written or a formula's text, keyed by its row and column, and
  // no row for a cell that holds nothing. A row the record prints over a range makes the snapshot none, as a refused view
  // does. Read between a frame's writes and its step too, the module stepping nothing then.
  Host.prototype._heldNow = function (sheet, range) {
    if (!this.m || !this.handle) return null;
    var r = this.m.texts('alonzo_view', [this.handle], ['grid', sheet, VP().rangeText(range)]);
    if (r.status !== 0) return null;
    var held = {}, lines = r.text.split('\n');
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim();
      if (line.charAt(0) !== '(') continue;
      var f = VP().readForms(line)[0], head = Array.isArray(f) ? sym(f[0]) : null;
      if (head !== 'cell' && head !== 'formula') continue;
      var q = str(f[2]) !== null ? VP().parseRange(str(f[2])) : null;
      if (!q || q.rows || q.columns || q.top !== q.bottom || q.left !== q.right) return null;
      if (q.top < range.top || q.top > range.bottom || q.left < range.left || q.left > range.right) continue;
      held[q.top + ',' + q.left] = line;
    }
    return { sheet: sheet, range: range, held: held };
  };
  Host.prototype._heldAll = function (targets) {
    var out = [];
    for (var i = 0; i < targets.length; i++) {
      var s = this._heldNow(targets[i].sheet, targets[i].range);
      if (!s) return null;
      out.push(s);
    }
    return out;
  };
  // The rows that write snapshots back: an (empty ...) row over a snapshot's range where any of its cells held nothing, then
  // each held cell's own row as the record printed it, so that one write of them leaves the range as the snapshot found it.
  function heldRows(snaps) {
    var rows = [];
    snaps.forEach(function (s) {
      var lines = [], k;
      for (k in s.held) if (Object.prototype.hasOwnProperty.call(s.held, k)) lines.push(s.held[k]);
      if (lines.length < areaOf(s.range)) rows.push('(empty ' + quote(s.sheet) + ' ' + quote(VP().rangeText(s.range)) + ')');
      for (var i = 0; i < lines.length; i++) rows.push(lines[i]);
    });
    return rows;
  }
  // What a row holds, in a sentence: a value as written, or a formula's text; nothing for no row.
  function heldWords(line) {
    if (!line) return 'nothing';
    var f = VP().readForms(line)[0];
    return sym(f[0]) === 'formula' ? 'the formula ' + str(f[3]) : line.replace(/^\(cell\s+"(?:[^"\\]|\\.)*"\s+"[^"]*"\s+/, '').replace(/\)\s*$/, '');
  }
  // The first cell whose row differs between two snapshots of the same targets, in words, or the empty text.
  function heldDiff(now, was) {
    for (var i = 0; i < was.length; i++) {
      var s = was[i], R = s.range, n = now[i];
      for (var r = R.top; r <= R.bottom; r++) for (var c = R.left; c <= R.right; c++) {
        var k = r + ',' + c, a = n.held[k], b = s.held[k];
        if (a !== b) return s.sheet + '!' + VP().colName(c) + r + ' holds ' + heldWords(a) + ', where ' + heldWords(b) + ' stood';
      }
    }
    return '';
  }
  function letGoWords(n) { return n ? '; ' + (n === 1 ? 'the edit undone was let go' : 'the ' + countWords(n) + ' edits undone were let go') : ''; }
  // The cells as an act found them, read just before its write, the frame's derived writes already made: an entry's
  // snapshot, or null where its view was refused or the line cannot keep it, its undo then refused; true for an undo's or a
  // redo's, whose rows the line wrote; undefined for an act the line keeps nothing of.
  Host.prototype._undoBefore = function (act) {
    if (!act || typeof act !== 'object' || !act.undoEntry) return undefined;
    if (act.undoOp) return true;
    return act.undoEntry.unkept ? null : this._heldAll(act.undoEntry.targets);
  };
  // An act of the line landed: an edit or a paste joins it, letting the edits undone go, said in its frame's sentence, and
  // the oldest past UNDO_DEPTH; an undo moves its entry to the undone and a redo back; and the cells it left are read at its
  // rest (_complete).
  Host.prototype._undoLanded = function (act, before) {
    var u = this.undoLine, e = act.undoEntry;
    if (act.undoOp === 'undo') { u.done.pop(); u.undone.push(e); this.undoWaiting = { entry: e, slot: 'restored' }; return; }
    if (act.undoOp === 'redo') { u.undone.pop(); u.done.push(e); this.undoWaiting = { entry: e, slot: 'after' }; return; }
    e.before = before;
    if (!before && !e.unkept) e.unkept = 'its cells could not be read before it wrote them';
    if (u.undone.length) { act.letGo = u.undone.length; this.c.letGo += u.undone.length; u.undone = []; }
    u.done.push(e);
    if (u.done.length > UNDO_DEPTH) u.done.shift();
    if (!e.unkept) this.undoWaiting = { entry: e, slot: 'after' };
  };
  // Why a step back cannot be taken now, or the empty text.
  Host.prototype._undoBusy = function (what) {
    if (!this.handle || !this.cart) return 'Nothing was ' + what + ': no cartridge is loaded.';
    if (this.cart.rate !== 0) return 'Nothing was ' + what + ': ' + (what === 'undone' ? 'undo takes back' : 'redo puts back') + ' a person\'s edits of work sheets at rate 0, and ' + (this.cart.title || 'the cartridge') + ' runs at ' + this.cart.rate + ' frame' + (this.cart.rate === 1 ? '' : 's') + ' a second, where a game is never undone.';
    if (this.player) return 'Nothing was ' + what + ': a replay is playing, frame ' + this.frame + ' of ' + this.player.last + '.';
    if (this.inFrame || this.settling || this.edits.length || this.undoWaiting) return 'Nothing was ' + what + ' yet: frame ' + (this.frame + 1) + ' is still being computed for the last act; press again once it rests.';
    return '';
  };
  // Why an entry cannot be stepped over now, or the empty text: the line cannot keep it, its cells cannot be read, or one of
  // them holds what the act that last wrote it did not leave there, the cartridge having written it since.
  Host.prototype._undoRefusal = function (e, left, verb, when, writing) {
    if (e.unkept) return verb + ' of ' + e.words + ' was refused: ' + e.unkept + '.';
    var now = this._heldAll(e.targets);
    if (!now || !left) return verb + ' of ' + e.words + ' was refused: its cells could not be read.';
    var moved = heldDiff(now, left);
    return moved ? verb + ' of ' + e.words + ' was refused: ' + moved + ' when ' + when + ', so the cartridge has written it since, and ' + writing + ' would lose that.' : '';
  };
  // Undo (decision 6 as answered): the last edit of a work sheet taken back, its cells written back as one act. Answers
  // { ok, sheet, range }, the sheet and range a page shows and selects, or { ok: false }, said.
  Host.prototype.undo = function () {
    var busy = this._undoBusy('undone');
    if (busy) { this.c.undosRefused++; this._answerRefused(busy); return { ok: false }; }
    var u = this.undoLine, n = u.undone.length;
    if (!u.done.length) {
      this._answer('Nothing to undo: ' + (!n ? 'no edit of a work sheet since ' + (this.cart.title || 'the cartridge') + ' was loaded' : n === 1 ? 'the edit kept is taken back, and redo puts it back' : 'the ' + countWords(n) + ' edits kept are taken back, and redo puts them back') + '.');
      return { ok: false };
    }
    var e = u.done[u.done.length - 1], refused = this._undoRefusal(e, e.after, 'Undo', 'the edit left it', 'writing back what the edit replaced');
    if (refused) { this.c.undosRefused++; this._answerRefused(refused); return { ok: false }; }
    return this._stepBack(e, 'undo', heldRows(e.before));
  };
  // Redo: the edit last taken back written again, as it was written.
  Host.prototype.redo = function () {
    var busy = this._undoBusy('redone');
    if (busy) { this.c.undosRefused++; this._answerRefused(busy); return { ok: false }; }
    var u = this.undoLine;
    if (!u.undone.length) { this._answer('Nothing to redo: no edit taken back waits' + (u.done.length ? ', and an edit after an undo lets the edits undone go' : '') + '.'); return { ok: false }; }
    var e = u.undone[u.undone.length - 1], refused = this._undoRefusal(e, e.restored, 'Redo', 'the undo left it', 'writing the edit again');
    if (refused) { this.c.undosRefused++; this._answerRefused(refused); return { ok: false }; }
    return this._stepBack(e, 'redo', e.rows.slice());
  };
  // An undo or a redo as one act, a paste's: its rows one write at its frame, all or none, each recorded as a person's edit,
  // and the line moved as it lands. Answers { ok, sheet, range }.
  Host.prototype._stepBack = function (e, op, rows) {
    var act = { paste: true, what: 'the ' + op + ' of ' + e.words, done: (op === 'undo' ? 'undid ' : 'redid ') + e.words, move: false, rows: rows, undoEntry: e, undoOp: op };
    if (this._sixAtZero()) act.place = this._actPlace(e);
    this.edits.push(act);
    this._editFrames(this._window());
    return { ok: true, sheet: e.select.sheet, range: e.select.range };
  };
  // The cell a step back stands on at rate 0 (version 6, CART.12): the act's range's corner on its sheet.
  Host.prototype._actPlace = function (e) {
    return { sheet: e.select.sheet, row: e.select.range.top, col: e.select.range.left };
  };

  // ---- the watches, a debugger's watchpoint (ENGINE.30's second slice, decision 12; docs/SPEC.md section 7.2) ----
  // A watch is a cell and maybe a value: the keymap's, (watch "State" "B1" 4), standing, or the command's, watch, the
  // selection's cell at its next change, once. At every frame's end the host reads each watched cell, one cell of a values
  // view, and a watch holds at the frame whose cell comes to hold its value, where the frame before's held another, or,
  // with no value, at the frame whose cell's value differs from the frame before's. Its first read, as a load leaves the
  // cell or as it is set, is its baseline and holds nothing, a formula with no value yet read again at the first rest. A
  // watch held is said with its frame; at a rate, or while a replay plays, the run pauses at that frame, never a frame
  // late: the tick steps no frame after it, and a replay played at once stops there. At rate 0 an act steps on, the watch
  // said. Host state and never a cell, so that no replay moves; a watch on a sheet the cartridge lacks reads nothing.
  // A value as a watch compares it: { k, v }, k 'none', 'unvalued' (a formula with no value yet), 'number', 'bool',
  // 'error' or 'text'; a record's cell, or a keymap's value, a number, a text or true or false.
  function watchValueOf(e) {
    if (!e || e.kind === 'empty') return { k: 'none', v: null };
    if (e.kind === 'formula' && !e.valued) return { k: 'unvalued', v: null };
    var v = e.value !== undefined ? e.value : e.text, kind = e.vkind;
    if (kind === 'number') return { k: 'number', v: Number(v) };
    if (kind === 'bool') return { k: 'bool', v: String(v).toUpperCase() === 'TRUE' };
    if (kind === 'error') return { k: 'error', v: String(v) };
    return { k: 'text', v: String(kind === 'date' ? e.text : v) };
  }
  function watchGiven(v) { return typeof v === 'number' ? { k: 'number', v: v } : typeof v === 'boolean' ? { k: 'bool', v: v } : { k: 'text', v: String(v) }; }
  function sameWatched(a, b) { return !!a && !!b && a.k === b.k && a.v === b.v; }
  function watchedWords(a) { return !a ? 'unread' : a.k === 'none' || a.k === 'unvalued' ? 'nothing' : a.k === 'text' ? quote(a.v) : a.k === 'bool' ? (a.v ? 'TRUE' : 'FALSE') : String(a.v); }
  function watchName(w) { return w.sheet + '!' + w.address + (w.has ? ' = ' + watchedWords(w.value) : ''); }
  // A watch's cell read now, or null where its view is refused, a sheet the cartridge lacks among them.
  Host.prototype._watchedValue = function (w) {
    if (!this.m || !this.handle) return null;
    var r = this.m.texts('alonzo_view', [this.handle], [this.frame > 0 ? 'values' : 'grid', w.sheet, w.address]);
    if (r.status !== 0) return null;
    var q = VP().parseRange(w.address);
    return watchValueOf(VP().readRecord(r.text).cells.get(q.top + ',' + q.left));
  };
  // Each watch's baseline taken again: read now where read, else at the first rest.
  Host.prototype._watchBaselines = function (read) {
    for (var i = 0; i < this.watched.length; i++) this.watched[i].last = read ? this._watchBase(this.watched[i]) : undefined;
  };
  Host.prototype._watchBase = function (w) {
    if (!this.handle || this.inFrame || this.settling) return undefined;
    var v = this._watchedValue(w);
    return v && v.k !== 'unvalued' ? v : undefined;
  };
  // The keymap's watches (decision 12's (a)), each { sheet, address, value } with value undefined for any change: they
  // replace the keymap's before them, the command's standing beside them. Answers how many watches stand.
  Host.prototype.setWatches = function (list) {
    var self = this, own = this.watched.filter(function (w) { return w.once; });
    this.watched = (list || []).map(function (x) {
      var has = x.value !== undefined && x.value !== null, w = { sheet: String(x.sheet), address: String(x.address).toUpperCase(), once: false, has: has, value: has ? watchGiven(x.value) : null, last: undefined };
      w.last = self._watchBase(w);
      return w;
    }).concat(own);
    return this.watched.length;
  };
  // The command's watch (decision 12's (c)): the selection's cell, sheet and address, watched for its next change, once,
  // said. True where it was set.
  Host.prototype.watch = function (sheet, address) {
    if (!this.handle || !this.cart) { this._answerRefused('Nothing is watched: no cartridge is loaded.'); return false; }
    var q = VP().parseRange(String(address || ''));
    if (!sheet || !q || q.rows || q.columns || q.top !== q.bottom || q.left !== q.right) { this._answerRefused('Nothing is watched: a watch is one cell, and the selection is ' + (address || 'none') + '; select one cell, then watch.'); return false; }
    var a = VP().colName(q.left) + q.top, key = String(sheet).toLowerCase() + '!' + a;
    if (this.watched.some(function (w) { return w.once && (w.sheet.toLowerCase() + '!' + w.address) === key; })) { this._answer(sheet + '!' + a + ' is watched already: the run pauses at its next change.'); return true; }
    var w = { sheet: String(sheet), address: a, once: true, has: false, value: null, last: undefined };
    w.last = this._watchBase(w);
    this.watched.push(w);
    this._answer('Watching ' + sheet + '!' + a + (w.last ? ', which holds ' + watchedWords(w.last) : '') + ': ' + (this.cart.rate > 0 ? 'the run pauses at the frame it next changes' : 'the frame it next changes is said') + '; unwatch forgets it.');
    return true;
  };
  // The command's watches forgotten, said; the keymap's stand, its lines being the keys'. Answers how many were forgotten.
  Host.prototype.unwatch = function () {
    var gone = this.watched.filter(function (w) { return w.once; }), left = this.watched.length - gone.length;
    this.watched = this.watched.filter(function (w) { return !w.once; });
    var standing = left ? '; the keymap\'s ' + (left === 1 ? 'watch stands' : countWords(left) + ' watches stand') + ', its lines the keys\'' : '';
    this._answer(gone.length ? 'Forgot the watch' + (gone.length === 1 ? '' : 'es') + ' on ' + gone.map(watchName).join(', ') + standing + '.' : 'No watch of the watch command waits' + standing + '.');
    return gone.length;
  };
  // The watches standing, each { sheet, address, value, once, last }: for a page and an oracle.
  Host.prototype.watches = function () {
    return this.watched.map(function (w) { return { sheet: w.sheet, address: w.address, value: w.has ? w.value.v : undefined, once: w.once, last: w.last ? w.last.v : undefined }; });
  };
  // The words for the watches that read nothing, '' where none: a watch whose sheet the cartridge loaded lacks never holds,
  // so it is said where a person waits on it, at a load, at a replay's play and at the keys' apply (the owner's hand test
  // of the second slice, where a replay played through a watch and nothing said why). A sheet's name compared without case.
  Host.prototype.unreadWatches = function () {
    if (!this.handle || !this.watched.length) return '';
    var self = this, unread = this.watched.filter(function (w) { return self._sheetNamed(w.sheet) === null; }), sheets = [];
    if (!unread.length) return '';
    unread.forEach(function (w) { if (sheets.indexOf(w.sheet) < 0) sheets.push(w.sheet); });
    var cells = unread.map(function (w) { return w.sheet + '!' + w.address; });
    return (unread.length === 1 ? 'the watch on ' + cells[0] + ' reads' : 'the watches on ' + seriesWords(cells, 'and') + ' read') + ' nothing, as the cartridge loaded has no sheet named ' + seriesWords(sheets, 'or');
  };
  function seriesWords(list, word) { return list.length < 2 ? list.join('') : list.slice(0, -1).join(', ') + ' ' + word + ' ' + list[list.length - 1]; }
  // A frame's end: each watch read, those that hold said, the command's let go, and the run paused at a rate or a replay.
  Host.prototype._watchFrame = function (n) {
    var held = [], i;
    for (i = 0; i < this.watched.length; i++) {
      var w = this.watched[i], now = this._watchedValue(w);
      if (now === null) continue;
      if (w.last === undefined) { if (!this.settling && now.k !== 'unvalued') w.last = now; continue; }   // its baseline, at the first rest
      var holds = w.has ? sameWatched(now, w.value) && !sameWatched(w.last, w.value) : !sameWatched(now, w.last);
      if (holds) held.push({ w: w, was: w.last, now: now });
      w.last = now;
    }
    if (!held.length) return;
    this.c.watchesHeld += held.length;
    this.watched = this.watched.filter(function (w) { return !(w.once && held.some(function (h) { return h.w === w; })); });
    var pause = this.cart.rate > 0 || !!this.player;
    if (pause) { this.watchStop = n; this.c.watchPauses++; }
    this._answer('frame ' + n + ': ' + held.map(function (h) {
      return h.w.has ? h.w.sheet + '!' + h.w.address + ' holds ' + watchedWords(h.now) + ', as its watch asks' : h.w.sheet + '!' + h.w.address + ' changed from ' + watchedWords(h.was) + ' to ' + watchedWords(h.now);
    }).join('; ') + (pause ? '; paused at the watch, and Run goes on.' : '.'));
    if (pause && this.running) this.stop();
  };
  // A key down on the Screen: a command's key (ENGINE.25) runs its command and is no button's and no last key, a repeat
  // taken and running nothing but where the command repeats and the repeat is fresh (version 8, ENGINE.39); any other
  // holds the Keys sheet's buttons it binds and is the frame's last key. ev, the event, when a listener has one: its
  // Ctrl, Cmd, Alt and repeat.
  Host.prototype.keyDown = function (code, key, ev) {
    if (!code || !this.gameKeysHere()) return false;   // a work or a read sheet's keys are not the game's (SPEC.5)
    var cmd = this._commandKey(code, ev, key);
    if (cmd) { this._keyCommand(cmd, ev); return true; }
    this.held[code] = true;
    this.lastKey = { key: key === undefined ? '' : String(key), code: String(code) };
    return this._bound(code);
  };
  // A command's own key pressed (ENGINE.25), its repeat running it only where the Commands sheet says it repeats and the
  // repeat is fresh (version 8, ENGINE.39), the act noted at rest.
  Host.prototype._keyCommand = function (cmd, ev) {
    if (ev && ev.repeat && !(cmd.repeats && this.freshRepeat(ev))) return;
    this.command(cmd.name, 'key');
    this.rested();
  };
  // The command a key runs on the Screen (ENGINE.25; docs/SPEC.md section 3.10): the first row holding now whose key is
  // the code, while no Ctrl, Cmd or Alt is held; null for every other key, the game's buttons' or the viewport's. A digit
  // of the keypad, Num Lock on so that its key is the digit, runs the command of the digit row's key when no row holding
  // names the keypad's own, as a spreadsheet takes the keypad's digits for the row's and the page's keymap does (CART.14's
  // hand test, 2026-10-19); Num Lock off, its arrows, Home and End stay the viewport's. key, the event's KeyboardEvent.key
  // where a caller has no event.
  // Since version 7 a key with modifiers is taken with exactly its modifiers held, as the keymap takes a binding, before a
  // bare key of the same code, and a bare key is taken as before, Shift either way (CART.3's second slice, decision 14).
  Host.prototype._commandKey = function (code, ev, key) {
    if (!this._five()) return null;
    if (!this.gameKeysHere()) return null;   // no command's key holds on a work or a read sheet (SPEC.5)
    var row = keypadDigit(code, key !== undefined ? key : (ev ? ev.key : undefined)), name, c;
    if (ev && this._seven()) {
      for (name in this.commandKeys) {
        c = this.commandKeys[name];
        if (c.chord && !c.chord.bare && (c.chord.value === code || c.chord.value === row) && modifiersMatch(c.chord, ev)) return c;
      }
    }
    if (ev && (ev.ctrlKey || ev.metaKey || ev.altKey)) return null;   // a bare key, with no Ctrl, Cmd or Alt held (decision 52)
    if (Object.prototype.hasOwnProperty.call(this.commandKeys, code)) return this.commandKeys[code];
    return row && Object.prototype.hasOwnProperty.call(this.commandKeys, row) ? this.commandKeys[row] : null;
  };
  // The digit row's key a keypad's digit stands for, Digit7 for Numpad7, while Num Lock is on so that its key is the
  // digit; null for any other key.
  function keypadDigit(code, key) {
    var m = /^Numpad([0-9])$/.exec(String(code || ''));
    return m && String(key) === m[1] ? 'Digit' + m[1] : null;
  }
  // Whether a key on the grid is the game's (CART.9's second slice): a holding command's key at any rate, and at a rate
  // above zero a key the Keys sheet binds. A page asks before it takes a key typed on a cell for an edit of its own.
  Host.prototype.takesKey = function (code, key, ev) {
    if (!this.cart || !code || !this.gameKeysHere()) return false;
    if (this._commandKey(code, ev, key)) return true;
    return this.cart.rate > 0 && this._bound(code);
  };
  // The keyboard's sheets (SPEC.5; docs/SPEC.md section 7.2, version 6), what a sheet's mode in the manifest makes of a key
  // and of a person's row there. sheetMode(name): { game, work, read }, whether the manifest names the sheet so, compared
  // without case as the model compares names.
  Host.prototype.sheetMode = function (name) {
    var c = this.cart, want = String(name || '').toLowerCase();
    function has(list) { for (var i = 0; list && i < list.length; i++) if (String(list[i]).toLowerCase() === want) return true; return false; }
    return { game: !!c && has(c.game), work: !!c && has(c.work), read: !!c && has(c.read) };
  };
  // Whether the game's keys hold on the sheet shown, its commands, its Keys at a rate and the last key it reads: on a game
  // sheet; never on a work or a read sheet that is not also the game's; on a sheet named by none, never where the
  // cartridge names a game sheet, and as today where it names none. A plane's canvas is the game's.
  Host.prototype.gameKeysHere = function () {
    var c = this.cart;
    if (!c || c.mode !== 'grid') return true;
    var m = this.sheetMode(this._shown());
    if (m.game) return true;
    if (m.work || m.read) return false;
    return !(c.game && c.game.length);
  };
  // Whether the manifest names the sheet shown the game's, where a character typed on a cell is the game's key, or =, or
  // nothing (CART.9's fourth slice, decision 49). A sheet named by none keeps its typing, whoever's keys hold there.
  Host.prototype.gameSheetHere = function () { return this.sheetMode(this._shown()).game; };
  // Whether a person writes the sheet shown by hand, a key typed on a cell, Delete, Backspace, or Enter's and F2's edit:
  // anywhere but a read-only sheet.
  Host.prototype.editsHere = function () { return !this.sheetMode(this._shown()).read; };
  // A person's key that would write a read-only sheet, refused by the sheet's name: a character typed on a cell, Delete,
  // Backspace, F2 or a double click there, the cells untouched and the log counting the repeats. It returns the sentence,
  // the page's bar showing it at every press.
  Host.prototype.readKey = function () {
    var name = this._shown(), text = name + ' is a read-only sheet, named by the manifest\'s (read ...): a key there writes nothing, and the cartridge\'s own rows still write it (version 6, docs/SPEC.md section 7.2).';
    this.c.keysRead++;
    this._answerRefused(text);
    return text;
  };
  // A character on a game sheet a person writes that is neither the game's key nor = (CART.9's fourth slice, decisions 49
  // and 50), refused by the sheet's name, one sentence for every such key. It returns the sentence, as readKey does.
  Host.prototype.strayKey = function () {
    var text = 'That key does nothing on ' + this._shown() + ': it is not one of the game\'s keys. Commands lists them, and = opens a cell\'s formula.';
    this.c.keysStray++;
    this._answerRefused(text);   // the log counts the repeats
    return text;
  };
  Host.prototype.keyUp = function (code) { delete this.held[code]; };
  Host.prototype.releaseKeys = function () { this.held = Object.create(null); };
  Host.prototype._bound = function (code) {
    var km = this.keymap;
    if (!km) return false;
    for (var b = 0; b < km.length; b++) for (var p = 0; p < km[b].length; p++) if (km[b][p] === code) return true;
    return false;
  };
  Host.prototype.pointerAt = function (col, row) { this.pointer.col = col | 0; this.pointer.row = row | 0; this.pointer.sheetCell = false; };
  Host.prototype.pointerButtons = function (left, right, middle) { this.pointer.left = left ? 1 : 0; this.pointer.right = right ? 1 : 0; this.pointer.middle = middle ? 1 : 0; };
  Host.prototype.wheel = function (notches) { this.notches += notches | 0; };
  Host.prototype._pointerFrom = function (ev) {
    var c = this.cart, rect = this.canvas.getBoundingClientRect();
    if (!c || rect.width <= 0 || rect.height <= 0) return;
    var col = Math.floor((ev.clientX - rect.left) / rect.width * c.w) + 1, row = Math.floor((ev.clientY - rect.top) / rect.height * c.h) + 1;
    if (col < 1 || col > c.w || row < 1 || row > c.h) { col = 0; row = 0; }
    this.pointerAt(col, row);
    this.pointerButtons(ev.buttons & 1, ev.buttons & 2, ev.buttons & 4);
  };
  Host.prototype._on = function (target, type, fn, opts) { target.addEventListener(type, fn, opts); this.handlers.push([target, type, fn, opts]); };
  Host.prototype._listenCanvas = function () {
    var self = this, cv = this.canvas;
    if (!cv.hasAttribute('tabindex')) cv.setAttribute('tabindex', '0');
    this._on(cv, 'keydown', function (ev) { if (self.keyDown(ev.code, ev.key, ev)) ev.preventDefault(); });
    this._on(cv, 'keyup', function (ev) { self.keyUp(ev.code); });
    this._on(cv, 'blur', function () { self.releaseKeys(); });
    this._on(cv, 'mousemove', function (ev) { self._pointerFrom(ev); });
    this._on(cv, 'mousedown', function (ev) { cv.focus(); self._pointerFrom(ev); ev.preventDefault(); });
    this._on(cv, 'mouseup', function (ev) { self._pointerFrom(ev); });
    this._on(cv, 'mouseleave', function () { self.pointerAt(0, 0); self.pointerButtons(0, 0, 0); });
    this._on(cv, 'contextmenu', function (ev) { ev.preventDefault(); });
    this._on(cv, 'wheel', function (ev) { self.wheel(ev.deltaY > 0 ? 1 : (ev.deltaY < 0 ? -1 : 0)); ev.preventDefault(); }, { passive: false });
  };
  // The Input device over the viewport (ENGINE.8, decision 7, as ENGINE.14 bounds it). At a rate above zero
  // a key the Keys sheet binds is the game's whatever sheet shows, taken before the viewport sees it; every
  // other key moves the viewport. While the Screen shows, the pointer over a cell of the Camera's window, its
  // buttons and the wheel there are the game's too; over the tabs, the headers, the corner and the scrollbars,
  // and over another sheet, the pointer is 0 and the wheel scrolls. A cartridge written to version 4 has the
  // pointer and its buttons over any cell of another sheet shown too, that sheet's own cell, the wheel still
  // scrolling there (ENGINE.18, decision 4). At rate zero, where the Input sheet is not written, all of them are
  // the viewport's, to select, scroll and move by, but for a holding command's key, taken as at a rate (CART.12,
  // decision 64), and, for a cartridge written to version 6, a press of a button over a cell, an act (decision 63),
  // its context menu taken.
  Host.prototype._listenGrid = function () {
    var self = this, root = this.vp.root;
    function playing() { return !!self.cart && self.cart.mode === 'grid' && self.cart.rate > 0; }
    function still() { return !!self.cart && self.cart.mode === 'grid' && self.cart.rate === 0; }
    this._on(root, 'keydown', function (ev) {
      if (playing()) { if (self.keyDown(ev.code, ev.key, ev)) { ev.preventDefault(); ev.stopPropagation(); } return; }
      var cmd = still() ? self._commandKey(ev.code, ev) : null;
      if (cmd) { self._keyCommand(cmd, ev); ev.preventDefault(); ev.stopPropagation(); }
    }, true);
    this._on(root, 'keyup', function (ev) { if (playing()) self.keyUp(ev.code); }, true);
    this._on(root, 'focusout', function () { self.releaseKeys(); });
    this._on(root, 'mousemove', function (ev) { if (playing()) self._pointerFromGrid(ev); });
    this._on(root, 'mousedown', function (ev) { if (playing()) self._pointerFromGrid(ev); });
    // a press at rate 0 read before the viewport's own, whose focus may scroll the page under the point (CART.12), an act
    // for a cartridge that reads an act's place or press, and the viewport's alone, a selection, for one that does not
    this._on(root, 'mousedown', function (ev) { if (still() && self._pressActs()) self._pressAct(ev); }, true);
    this._on(root, 'mouseup', function (ev) { if (playing()) self._pointerFromGrid(ev); });
    this._on(root, 'mouseleave', function () { if (playing()) { self.pointerAt(0, 0); self.pointerButtons(0, 0, 0); } });
    this._on(root, 'contextmenu', function (ev) { if ((playing() || (still() && self._pressActs())) && self._pointerCellAt(ev)) ev.preventDefault(); });
    this._on(root, 'wheel', function (ev) { if (!playing() || !self._windowCellAt(ev)) return; self.wheel(ev.deltaY > 0 ? 1 : (ev.deltaY < 0 ? -1 : 0)); ev.preventDefault(); }, { passive: false, capture: true });
  };
  // A press of a button over a cell of the sheet shown, an act at rate 0 for a cartridge written to version 6 (CART.12,
  // decision 63; docs/SPEC.md section 3.3): over the Screen a cell of the Camera's window, the Camera added, and over
  // another sheet any cell in view, the sheet's own; never over the headers, the corner, the tabs or the scrollbars. The
  // viewport selects the cell, its own press doing so for the left button, and the press holds for the act's frame,
  // Input!B13 the left, B14 the right, B15 the middle. While a replay plays it is no act, said once.
  // A press is an act only for a cartridge whose formulas read an act's place or press, Input!B11 to B15, its rows as
  // given or a person's formula since (CART.9's hand test, 2026-10-20, docs/SPEC.md section 3.3): for one that reads
  // neither, a press would be three frames that move nothing, its own, its release's and the proof's, and it is the
  // viewport's selection alone, as at version 5.
  // And since CART.9's third slice a press is an act only on a sheet whose keys are the game's (SPEC.5's sheets): on any
  // other it is the viewport's selection alone, as a key typed there is a person's, so that a click on Naught's Bench or
  // Lesson steps no frame where its levels read the act's place.
  Host.prototype._pressActs = function () {
    if (!this._sixAtZero()) return false;
    if (this.actRead === null) { try { this.actRead = readsInputRows(this._given(), 11, 15); } catch (e) { this.actRead = true; } }
    return this.actRead && this.gameKeysHere();
  };
  Host.prototype._pressAct = function (ev) {
    if (!this.vp || !this.handle || ev.button > 2) return false;
    var at = this._pointerCellAt(ev);
    if (!at) return false;
    if (this.player) { this._sayOnce('press-replay', 'A press over a cell is no act while a replay plays: what plays is the replay alone.', false); return false; }
    var col = at.sheet ? at.col : this.camera.col + at.col - 1, row = at.sheet ? at.row : this.camera.row + at.row - 1;
    if (ev.button !== 0) this.vp.select(VP().colName(col) + row);
    this.c.presses++;
    this.edits.push({ press: ev.button === 0 ? 1 : ev.button === 2 ? 2 : 3, place: { sheet: this._shown(), col: col, row: row } });
    if (!this.inFrame) this._editFrames(this._window());
    return true;
  };
  // The cell of the Camera's window under a point, { col, row } counted from the window's corner, or null: off
  // the window's cells, over a header, a scrollbar or the tabs, or while another sheet shows (ENGINE.14).
  Host.prototype._windowCellAt = function (ev) {
    var c = this.cart, cam = this.camera;
    if (!c || !this.vp || !isScreen(this.vp.sheet())) return null;
    var at = this.vp.cellAt(ev.clientX, ev.clientY);
    var col = at ? at.col - cam.col + 1 : 0, row = at ? at.row - cam.row + 1 : 0;
    return col >= 1 && col <= c.w && row >= 1 && row <= c.h ? { col: col, row: row } : null;
  };
  // The pointer's cell (ENGINE.18, decision 4): over the Screen, the Camera's window's cell, as before; over
  // another sheet shown, for a cartridge written to version 4, that sheet's own cell under the pointer, any cell
  // in view, marked so that the Input rows add no Camera; null over the headers, the corner, the tabs and the
  // scrollbars, and over another sheet for a cartridge written to 1 to 3 (ENGINE.14).
  Host.prototype._pointerCellAt = function (ev) {
    if (!this.vp) return null;
    if (isScreen(this.vp.sheet())) return this._windowCellAt(ev);
    if (!this._four()) return null;
    var at = this.vp.cellAt(ev.clientX, ev.clientY);
    return at ? { col: at.col, row: at.row, sheet: true } : null;
  };
  // The cell under the pointer, the sheet's own, held on the Screen as the window's cell so that the Input rows
  // add the Camera back as they do a plane's: the viewport draws the sheet's own rows and columns, so a cell is
  // the pointer's when the window holds it, and the pointer is 0 off the window, as a plane's is off its canvas.
  // The buttons follow the pointer, so a click on a tab or a header is never the game's.
  Host.prototype._pointerFromGrid = function (ev) {
    var at = this._pointerCellAt(ev);
    this.pointerAt(at ? at.col : 0, at ? at.row : 0);
    this.pointer.sheetCell = !!(at && at.sheet);
    this.pointerButtons(at && (ev.buttons & 1), at && (ev.buttons & 2), at && (ev.buttons & 4));
  };
  // A hidden page stops the ticks and the voices, and its return starts the clock again with nothing owed
  // and sounds the frame the grid holds (ENGINE.4, decision 6).
  Host.prototype._listenPage = function () {
    var self = this, d = global.document;
    if (!d) return;
    this._on(d, 'visibilitychange', function () { self._visibility(d.hidden); });
  };
  Host.prototype._visibility = function (hidden) {
    if (hidden) { this.hidden = true; this._silence(); return; }
    this.hidden = false; this.lastTs = null; this.acc = 0;
    this._resound();
  };

  // ---- the replay (docs/SPEC.md section 7.6; ENGINE.3's second slice, decisions 8 to 10) ----
  // The recorder: from a load, every write that landed before each step, a frame logged at its end
  // as one form holding its rows, (frame n row ...), one row a line, the form the player issues as
  // one write (the owner's word after the close). The Input rows as the cells that changed against
  // the replay's own record of the sheet, whole at the first frame and after a person's edit of the
  // sheet; each person's edit as its row, in order; the derived writes never, a replay re-deriving them.
  var INPUT_ROW = /^\(cell "Input" "([A-Z]+[0-9]+)" (.*)\)$/;
  Host.prototype._startReplay = function () {
    var s = this.cart.seed;
    this.rec = { seed: typeof s === 'number' ? s : null, blocks: [], size: 0, rows: [], input: null, last: 0, written: 0, full: false };
  };
  // The recorder's rows go on past its cap while the work is kept (ENGINE.38), whose frames are free of it.
  Host.prototype._recordInputs = function (text) {
    var rec = this.rec;
    if (!rec || (rec.full && !this.keep)) return;
    var lines = text.split('\n'), was = rec.input, now = {};
    for (var i = 0; i < lines.length; i++) {
      var m = INPUT_ROW.exec(lines[i]);
      if (!m) continue;
      now[m[1]] = m[2];
      if (!was || was[m[1]] !== m[2]) {
        rec.rows.push(lines[i]);
        if (was && !KEPT_NOT_ACTS[m[1]]) this._acted();   // a key, a press, the wheel or a command: a person's act
      }
    }
    rec.input = now;
  };
  Host.prototype._recordEdit = function (row) {
    var rec = this.rec;
    if (!rec || (rec.full && !this.keep)) return;
    var f = VP().readForms(row)[0];
    rec.rows.push(spellForm(f));
    this._acted();
    if (String(str(f[1])).toLowerCase() === 'input') rec.input = null;   // the Input sheet unknown to the replay: its next rows are logged whole
  };
  // The twentieth row written alone at rate 0 (ENGINE.25): logged when it differs from the recorder's record of the
  // cell, which it then holds, the rest of the record kept.
  Host.prototype._recordCommandRow = function (row, name) {
    var rec = this.rec;
    if (!rec || (rec.full && !this.keep)) return;
    var v = quote(name), was = rec.input;
    if (!was || was.B20 !== v) { rec.rows.push(row); this._acted(); }
    if (was) was.B20 = v;
  };
  Host.prototype._recordPlayed = function (rows) {
    var rec = this.rec;
    if (!rec || (rec.full && !this.keep)) return;
    for (var i = 0; i < rows.length; i++) rec.rows.push(rows[i]);
    if (rows.length) this._acted();   // a replay a person played, a restore's frames among them
    rec.input = null;   // a replay's rows are its own record: live rows after it are logged whole
  };
  Host.prototype._recordFrame = function (n) {
    var rec = this.rec;
    if (!rec || (rec.full && !this.keep)) return;
    if (this.keep) this._keepFrame(n, rec.rows);
    if (rec.full) { rec.rows = []; return; }
    if (rec.rows.length) {
      var block = '(frame ' + n + '\n  ' + rec.rows.join('\n  ') + ')\n';
      rec.rows = [];
      if (rec.size + block.length > REPLAY_CAP) {
        rec.full = true;
        this._say('frame ' + n + ': the replay reached its cap of 8 MiB of text and records no more; Copy the replay keeps frames 1 to ' + rec.last + '.');
        return;
      }
      rec.blocks.push(block); rec.size += block.length; rec.written = n;
    }
    rec.last = n;
  };
  // ---- the work kept (ENGINE.38; docs/SPEC.md section 7.9) ----
  // A run's work as two texts a page keeps for it in the browser: a keyframe, a cartridge, at first the one this load took
  // and then a save at rest (ENGINE.5's), and every frame since as a replay's frames, numbered from the frame the keyframe
  // opens at, off being the host's frame less the Clock's at the keyframe (a settling cartridge's Clock counts its acts).
  // A restore opens the keyframe as a load and plays the frames at once: ENGINE.5's replay law. A restore's load carries
  // its keyframe's number on, kf, so that a page's records of the run go on as they were; acted, whether a person acted.
  Host.prototype._startKeep = function () {
    var r = this.restoring;
    this.keep = { kf: r ? r.kf : 0, text: null, opens: this.frame, off: 0, blocks: [], size: 0, last: this.frame, rested: this.frame,
                  steps: 0, cost: 0, frames: 0, acted: !!r, acts: r ? 1 : 0, version: 0, kfVersion: 0, saved: null, unsaved: false };
  };
  Host.prototype._acted = function () {
    var k = this.keep;
    if (!k || this.restoring) return;
    k.acts++;
    if (!k.acted) { k.acted = true; k.version++; }
  };
  // A frame's rows, as the recorder logged them, kept as the frame since the keyframe it is; the last frame at rest, the
  // one a restore lands on, since a restore plays to rest.
  Host.prototype._keepFrame = function (n, rows) {
    var k = this.keep, f = n - k.off;
    if (rows.length) {
      var b = '(frame ' + f + '\n  ' + rows.join('\n  ') + ')\n';
      k.blocks.push({ f: f, text: b }); k.size += b.length;
    }
    k.last = f; k.frames++;
    if (!this.settling) k.rested = f;
    k.version++;
  };
  // A keyframe due (decision 2): at the first rest past every keepEvery frames where a caller names it, the oracle; else
  // once the steps since have cost the larger of a second and twenty times the last keyframe, or the frames kept pass
  // 1 MiB of text. A save the host cannot write (section 10's file) is no keyframe, said once, and the frames kept on.
  Host.prototype._keyframeDue = function () {
    var k = this.keep, every = this.options.keepEvery;
    if (k.unsaved) return false;
    if (every) return k.frames >= every;
    return k.size >= KEEP_FRAMES_CAP || k.steps >= Math.max(KEEP_STEPS_MS, KEEP_COST_TIMES * k.cost);
  };
  Host.prototype._keyframe = function () {
    var k = this.keep, t0 = this.now(), s = this.saveText();
    if (!s.ok) {
      if (!s.wait) { k.unsaved = true; this._say('frame ' + this.frame + ': no keyframe of the work kept was taken: ' + s.words.replace(/^The save was not written: /, '') + ' The frames since the last are kept on.'); }
      return false;
    }
    k.kf++; k.text = s.text; k.opens = s.frame; k.off = this.frame - s.frame;
    k.blocks = []; k.size = 0; k.steps = 0; k.frames = 0; k.last = s.frame; k.rested = s.frame;
    k.cost = Math.max(this.now() - t0, TIMER_FLOOR_MS);
    k.version++; k.kfVersion = k.version;
    this.c.keyframes++;
    return true;
  };
  // A keyframe now, for a page whose tab hides (decision 3): taken at rest when a person acted and a frame stepped since the
  // last, else none.
  Host.prototype.keyframeNow = function () {
    var k = this.keep;
    if (!k || !k.acted || !this.handle || this.inFrame || this.settling || (this.player && this.player.restore) || !k.frames) return false;
    return this._keyframe();
  };
  // Whether a person acted in the run since its load, or since a save written with no act after it (decision 4); and the
  // cartridge's name, its manifest's, as a page matches a run's kept work to a cartridge it loads.
  Host.prototype.keptActed = function () { return !!(this.keep && this.keep.acted); };
  Host.prototype.cartName = function () { return this.cart && this.cartBytes ? this._cartName() || '' : ''; };
  // The work kept, for a page to keep (decision 3): null with no cartridge, or when nothing moved since the version a page
  // last took, since; else { version, kf, acted, name, title, file, spec, seed, opens, frame, frames, keyframe }: the
  // frames' text to the last frame at rest, a replay's frames without its header, which restore() writes for the keyframe
  // it loads, and the keyframe's text when it is newer than since, else null. A page keeps nothing of a run no person
  // acted in (decision 4).
  Host.prototype.keptWork = function (since) {
    var k = this.keep;
    if (!k || !this.handle || !this.cart) return null;
    var fresh = since === undefined || since === null;
    if (!fresh && k.version === since) return null;
    var out = [], i, lastBlock = 0;
    for (i = 0; i < k.blocks.length && k.blocks[i].f <= k.rested; i++) { out.push(k.blocks[i].text); lastBlock = k.blocks[i].f; }
    if (k.rested > k.opens && lastBlock !== k.rested) out.push('(frame ' + k.rested + ')\n');   // the last frame however empty, so the frames name their length
    var keyframe = fresh || k.kfVersion > since ? (k.text !== null ? k.text : dec.decode(this.cartBytes).replace(/\r\n/g, '\n')) : null;
    return { version: k.version, kf: k.kf, acted: k.acted, name: this._cartName() || '', title: this.cart.title || '', file: this.cartFile,
             spec: this.cart.spec, seed: typeof this.cart.seed === 'number' ? this.cart.seed : null, opens: k.opens, frame: k.rested,
             frames: out.join(''), keyframe: keyframe };
  };
  // The page's word that the save the host last handed it is written to a file of the person's (decision 6): no frame
  // since, the save is the keyframe and nothing is unsaved; frames since with no act, nothing is unsaved and the frames
  // are kept on; an act since, the work since it is unsaved and kept. Answers whether there was a save to take.
  Host.prototype.keepSaved = function () {
    var k = this.keep, s = k && k.saved;
    if (!s) return false;
    k.saved = null;
    if (k.version === s.version) {
      k.kf++; k.text = s.text; k.opens = s.frame; k.off = s.at - s.frame;
      k.blocks = []; k.size = 0; k.steps = 0; k.frames = 0; k.last = s.frame; k.rested = s.frame;
      k.kfVersion = k.version + 1;
    }
    if (k.acts === s.acts) k.acted = false;
    k.version++;
    return true;
  };
  // A run's work restored (decision 6): its keyframe opened as a load, with the run's seed, as a replay's player loads its
  // cartridge, so that a settling cartridge takes no load's act; then its frames played at once, through the player, and
  // the loop paused there. work: { keyframe, frames, seed, file, kf }. Answers { ok, frame, played, opened } or a failure.
  Host.prototype.restore = function (w) {
    if (!this.m) return this._answerFailed('There is no engine module to restore work on.');
    if (this.player) return this._answerFailed('The work kept was not restored: a replay is playing, frame ' + this.frame + ' of ' + this.player.last + '.');
    w = w || {};
    var t0 = this.now(), seed = typeof w.seed === 'number' && w.seed >= 1 && w.seed <= MAX_SEED ? w.seed : null, ld;
    this.restoring = { kf: w.kf || 0 };
    this.playSeed = seed;
    try { ld = this.loadBytes(enc.encode(String(w.keyframe || '')), w.file || 'kept.vla'); } finally { this.playSeed = undefined; this.restoring = null; }
    if (!ld.ok) return ld;
    var opened = this.frame, frames = String(w.frames || '');
    this.c.restores++;
    if (!frames.trim()) {
      this._answer('frame ' + opened + ': restored the work kept at frame ' + opened + ', no frame to play again; ' + (this.cart.rate > 0 ? 'the loop is paused, and Run carries on.' : 'the grid rests, and the next act steps it.'));
      return { ok: true, frame: opened, played: 0, opened: opened };
    }
    var rp = this._readReplay('(replay ' + quote(this._cartName() || '') + ' (spec ' + SPEC + ') (cartridge "' + this._cartDigest() + '") (seed ' + (seed || 1) + '))\n' + frames);
    if (rp.error) return this._answerFailed('The work kept was not restored past its keyframe at frame ' + opened + ': its frames are no replay\'s: ' + rp.error);
    var firstFrame = Infinity;
    for (var n in rp.frames) if (Object.prototype.hasOwnProperty.call(rp.frames, n)) firstFrame = Math.min(firstFrame, +n);
    if (Math.min(firstFrame, rp.last) <= opened) return this._answerFailed('The work kept was not restored past its keyframe: its frames begin at ' + Math.min(firstFrame, rp.last) + ', and its keyframe opens at frame ' + opened + '.');
    this.player = { frames: rp.frames, last: rp.last, restore: { from: opened, t0: t0 } };
    var win = { used: 0, limit: 0x7fffffff, deadline: Infinity };
    while (this.player && this.handle) {
      this._begin();
      if (!this.inFrame || !this._continue(win)) break;
    }
    return { ok: this.frame === rp.last, frame: this.frame, played: this.frame - opened, opened: opened };
  };
  Host.prototype._cartName = function () {
    var c = this.cart;
    if (c.name === null) c.name = manifestName(dec.decode(this.cartBytes));
    return c.name;
  };
  Host.prototype._cartDigest = function () {
    var c = this.cart;
    if (c.digest === null) c.digest = sha256(lfOnly(this.cartBytes));
    return c.digest;
  };
  // ---- the save (ENGINE.5; docs/SPEC.md sections 3.7 and 7.5) ----
  // A save is a cartridge: the manifest this load took, its first form as written; every sheet that is no twin, its
  // fills view whole, in the record's order, the language's save (vla-lang 0.13.0, Frazaro's KERNEL.72); then the
  // loaded text's name rows, which no view prints and no write makes, so that a formula reading a name reads it in the
  // save. Taken at rest alone, between frames, and for a cartridge that settles between acts: a load assumes a grid at
  // rest, and a save inside a settle resumes otherwise (the replay law, engine/src/cartridge.rs). Named for the Clock's
  // frame, <name>-<frame>.vla, and never over section 10's file, which the engine refuses to load (cart-too-large).
  // Answers { ok, text, file, frame, bytes }, or { ok: false, wait: true } inside a frame or a settle, or a refusal.
  Host.prototype.saveText = function () {
    if (!this.m || !this.handle || !this.cart) return { ok: false, words: 'There is nothing to save: no cartridge is loaded.' };
    if (this.inFrame || this.settling) return { ok: false, wait: true };
    var loaded = dec.decode(this.cartBytes).replace(/\r\n/g, '\n'), out = [firstForm(loaded) + '\n'];
    var list = this._sheets(), named = {}, i;
    for (i = 0; i < list.length; i++) named[list[i].name] = true;
    for (i = 0; i < list.length; i++) {
      var s = list[i].name;
      if (/\.last$/.test(s) && named[s.slice(0, -5)]) continue;   // a twin, filled at the load with its sheet's values
      var r = this.m.texts('alonzo_view', [this.handle], ['fills', s, '']);
      if (r.status !== 0) return { ok: false, words: 'The save was not written: the view of ' + s + ' was refused: ' + words(r) + '.' };
      out.push(r.text);
    }
    var lines = loaded.split('\n');
    for (i = 0; i < lines.length; i++) if (lines[i].indexOf('(name ') === 0) out.push(lines[i] + '\n');
    // the Clock's frame as this frame read it, the host's kept cells and no view, else as the grid holds it
    var text = out.join(''), bytes = enc.encode(text).length, kept = this.kept && this.kept.Clock, frame = kept && typeof kept.cells.B1 === 'number' ? kept.cells.B1 : (this._clockAt('B1') || 0);
    if (bytes > MAX_CARTRIDGE_BYTES) return { ok: false, words: 'The save was not written: it is ' + thousands(bytes) + ' bytes, over the ' + thousands(MAX_CARTRIDGE_BYTES) + ' (16 MiB) a cartridge may be (docs/SPEC.md section 10), which the engine would not load again.' };
    return { ok: true, text: text, file: this._cartName() + '-' + frame + '.vla', frame: frame, bytes: bytes };
  };
  // A save asked for (ENGINE.5): by a person's command, 'person', or by the cartridge's File!B3 rising, 'cartridge'.
  // Taken now at rest, else held and taken at the end of the frame that rests, the act's settle ended, and said so;
  // then handed to the page by the event save, { text, file, frame, bytes, by, waited, kind }, which writes it to a file
  // of the person's. Answers what it did. Since CART.16's second slice a person's save of a cartridge that says a file's
  // lines (docs/SPEC.md section 3.11) writes the file, kind 'file', its text the module's and its name the file's; the
  // cartridge's own save and a person's save of the cartridge itself, what 'cartridge', write the grid as a cartridge,
  // kind 'cartridge', as before. under (ENGINE.49): a person's save under another name, Save as, which the event
  // carries as `as` for the page, whose file it is; the host writes nothing itself and knows no file of a person's.
  Host.prototype.save = function (by, what, under) {
    by = by === 'cartridge' ? 'cartridge' : 'person';
    var file = what === 'file' || (what !== 'cartridge' && by === 'person' && !!this.fileType());
    var as = !!under && by === 'person';
    var s = file ? this.fileText() : this.saveText();
    if (s.wait) {
      this.saveWaiting = by; this.saveWhat = file ? 'file' : 'cartridge'; this.saveAs = as;
      this._say('The save waits for ' + (this.settling ? 'the act to settle' : 'the frame to end') + ', and is written then.', 'event', false, by === 'person');
      return { ok: true, waiting: true };
    }
    return this._saveNow(by, false, s, file ? 'file' : 'cartridge', as);
  };
  Host.prototype._saveNow = function (by, waited, s, what, as) {
    var file = what === 'file';
    s = s || (file ? this.fileText() : this.saveText());
    if (!s.ok) { if (s.wait) { this.saveWaiting = by; this.saveWhat = file ? 'file' : 'cartridge'; this.saveAs = !!as; return { ok: true, waiting: true }; } this._say(s.words, 'event', true, by === 'person'); return s; }
    s.by = by; s.waited = waited; s.kind = file ? 'file' : 'cartridge'; s.as = !!as;
    this.c.saved++;
    if (file) {
      // the work kept takes the grid's own save as its keyframe, as after any save (ENGINE.38): the file is the work
      var g = this.saveText();
      s.frame = g.ok ? g.frame : this.frame;
      if (this.keep) this.keep.saved = g.ok ? { text: g.text, frame: g.frame, at: this.frame, version: this.keep.version, acts: this.keep.acts } : null;
      this._say('Wrote ' + s.file + ': ' + thousands(s.lines) + ' line' + (s.lines === 1 ? '' : 's') + ', ' + thousands(s.bytes) + ' bytes.', 'event', false, by === 'person');
    } else {
      if (this.keep) this.keep.saved = { text: s.text, frame: s.frame, at: this.frame, version: this.keep.version, acts: this.keep.acts };   // for keepSaved (ENGINE.38)
      this._say('Saved frame ' + s.frame + ' as ' + s.file + ', ' + thousands(s.bytes) + ' bytes' + (by === 'cartridge' ? ', as the cartridge asked' : '') + '.', 'event', false, by === 'person');
    }
    this._emit('save', s);
    return s;
  };
  // ---- a file's lines (CART.16's second slice; docs/SPEC.md section 3.11) ----
  // A cartridge written to version 9 may say a file's lines on its Format sheet, a kind of line a row, the line written
  // out with a hole a column, and the module reads a file into the cartridge's sheets and writes them back by it: two
  // exports, alonzo_file_read and alonzo_file_write, asked for at the act and not at the attach, as the pass is, since
  // the fake module holds neither and still drives the loop.
  // The file's type the cartridge says now, Format!B1, a dot and then letters and digits, or '' where it says none:
  // read from the grid at each ask, a person's edit of the cell among its values.
  Host.prototype.fileType = function () {
    if (!this.m || !this.handle || !this._nine() || !this.cart.devices.format) return '';
    var r = this.m.texts('alonzo_view', [this.handle], ['values', 'Format', 'B1']);
    var m = r.status === 0 ? /^\((?:cell|value) "Format" "B1" "(\.[A-Za-z0-9]{1,15})"\)$/m.exec(r.text) : null;
    return m ? m[1] : '';
  };
  // The name the file is written under: the name this load was given where it is such a file's, the file a person
  // opened; else the cartridge's own name with the type.
  Host.prototype.fileName = function () {
    var type = this.fileType();
    if (!type) return '';
    var given = this.cartFile || '';
    return ofType(given, type) ? given : (this._cartName() || 'file') + type;
  };
  // The file's name from here on, after a save under another (ENGINE.49): a name of the cartridge's type, which the
  // next save is written under and the work kept is kept under. Nothing of the grid is touched; answers whether the
  // name was taken.
  Host.prototype.fileNamed = function (name) {
    name = String(name || '');
    if (!this.handle || !this.cart || !ofType(name, this.fileType())) return false;
    this.cartFile = name;
    return true;
  };
  // A file opened under the cartridge loaded: its text handed to the module with the cartridge the grid was last given,
  // and the answer the cartridge's text with the file's lines in the place of the cells its sheets held, which a page
  // loads as it loads any cartridge, under the file's name. Nothing is loaded here and the grid that runs is left as it
  // is, so a file a line of which no template reads changes nothing. Answers { ok, text }, or the failure, said.
  Host.prototype.fileRead = function (file, name) {
    var what = name ? String(name) : 'The file';
    if (!this.m) return this._answerFailed(what + ' was not opened: there is no engine module to read it.');
    if (!this.handle || !this.cart || !this.cartBytes) return this._answerFailed(what + ' was not opened: no cartridge is loaded to read it by.');
    if (typeof this.m.x.alonzo_file_read !== 'function') return this._answerFailed(what + ' was not opened: the module exports no alonzo_file_read, so it reads no file\'s lines: the engine\'s module does (docs/SPEC.md section 3.11).');
    var r = this.m.texts('alonzo_file_read', [], [this._given(), String(file)]);
    if (r.status !== 0) return this._answerFailed(what + ' was not opened: ' + words(r, true).replace(/^The file was not read: /, '') + '.');
    return { ok: true, text: r.text };
  };
  // The file the grid's sheets say now, by the module's templates: { ok, text, file, lines, bytes }; { ok: false, wait }
  // inside a frame or a settle, a file being written at rest as a save is; or a refusal's words, a row no line says
  // named by its cell. It changes nothing.
  Host.prototype.fileText = function () {
    if (!this.m || !this.handle || !this.cart) return { ok: false, words: 'There is no file to write: no cartridge is loaded.' };
    if (this.settling || this.inFrame) return { ok: false, wait: true };   // written at rest, as a save is taken
    if (typeof this.m.x.alonzo_file_write !== 'function') return { ok: false, words: 'The file was not written: the module exports no alonzo_file_write, so it writes no file\'s lines: the engine\'s module does (docs/SPEC.md section 3.11).' };
    var r = this.m.call('alonzo_file_write', [this.handle]);
    if (r.status !== 0) return { ok: false, words: words(r, true) + '.' };
    return { ok: true, text: r.text, file: this.fileName(), lines: lineCount(r.text), bytes: enc.encode(r.text).length };
  };
  // The open's check (the slice's decision 5): a file opened is written back at once, from the cartridge it was read
  // into, and held to the file as it was opened, line ends and all, so that the first line a save would change is said
  // before a person edits anything. Asked by a page once that cartridge is loaded; where the load's act still settles,
  // it waits for the grid to rest and is said then. Answers { ok, same, lines } or { ok, same: false, line, was, now,
  // lines }, or { ok, waiting }, or the write's refusal, each said.
  Host.prototype.fileCheck = function (opened, name) {
    var w = this.fileText();
    if (w.wait) { this.checkWaiting = { opened: String(opened), name: name }; return { ok: true, waiting: true }; }
    return this._fileChecked(String(opened), name, w);
  };
  Host.prototype._fileChecked = function (opened, name, w) {
    w = w || this.fileText();
    var what = name ? String(name) : 'the file';
    if (!w.ok) { this._answerRefused('Opened ' + what + ', and it cannot be written back as it stands: ' + (w.words || 'the grid is not at rest.')); return w; }
    var ch = firstChange(opened, w.text), n = thousands(w.lines) + ' line' + (w.lines === 1 ? '' : 's');
    if (!ch) { this._answer('Opened ' + what + ', ' + n + ': Save writes it back as it is.'); return { ok: true, same: true, lines: w.lines }; }
    this._answer('Opened ' + what + ', ' + n + '. Save would change it, first at line ' + thousands(ch.line) + ': ' + changeWords(ch) + '.');
    return { ok: true, same: false, line: ch.line, was: ch.was, now: ch.now, lines: w.lines };
  };
  // The replay of the run since the last load: its header, then each frame that wrote a row, and
  // the last frame however empty, so that a replay names its length; null with no cartridge.
  Host.prototype.replayText = function () {
    var rec = this.rec;
    if (!rec || !this.handle || !this.cart) return null;
    if (rec.seed === null) { this._sayOnce('replay-seed', 'There is no replay of this run: Clock!B3 holds no seed the load wrote, and a replay names its seed.', true); return null; }
    // the page its rows are written to (ENGINE.18, decision 7): its cartridge's version, and 3 for a cartridge
    // written to 1 to 3, whose rows are version 3's, so that every replay version 3's host recorded is recorded
    // again byte for byte
    var spec = Math.max(3, Math.min(this.cart.spec || 3, SPEC));
    var out = '(replay ' + quote(this._cartName()) + ' (spec ' + spec + ') (cartridge "' + this._cartDigest() + '") (seed ' + rec.seed + '))\n' + rec.blocks.join('');
    if (rec.last > rec.written) out += '(frame ' + rec.last + ')\n';
    return out;
  };
  // A replay's text read whole before anything plays: the header, then frames ascending from 1, each
  // one form holding its cell, formula and empty rows; a refusal in words, and nothing loaded.
  Host.prototype._readReplay = function (text) {
    var forms = VP().readForms(text), h = forms[0];
    var shape = 'A replay begins with its header, (replay "<name>" (spec <n>) (cartridge "<SHA-256>") (seed <n>))';
    if (!Array.isArray(h) || sym(h[0]) !== 'replay' || str(h[1]) === null) return { error: shape + ', and this text begins with ' + (h === undefined ? 'nothing' : spellForm(h).slice(0, 60)) + '.' };
    var rp = { name: str(h[1]), spec: null, digest: null, seed: null, frames: {}, last: 0 }, i;
    for (i = 2; i < h.length; i++) {
      var d = h[i], k = Array.isArray(d) && d.length === 2 ? sym(d[0]) : null;
      if (k === 'spec') rp.spec = whole(d[1]);
      else if (k === 'cartridge') rp.digest = str(d[1]);
      else if (k === 'seed') rp.seed = whole(d[1]);
      else return { error: shape + ', and ' + spellForm(d) + ' is none of its three.' };
    }
    if (rp.spec === null || rp.spec < 1) return { error: shape + ', and its (spec ...) is not a version of the page.' };
    if (rp.spec > SPEC) return { error: 'The replay is written to the page\'s version ' + rp.spec + ', and this host implements versions 1 to ' + SPEC + ' (docs/SPEC.md): a later version\'s replay may hold what this host cannot play.' };
    if (rp.digest === null || !/^[0-9A-F]{64}$/.test(rp.digest)) return { error: shape + ', and its (cartridge ...) is not a SHA-256 in sixty-four upper-case hex digits.' };
    if (rp.seed === null || rp.seed < 1 || rp.seed > MAX_SEED) return { error: shape + ', and its (seed ...) is not a whole number from 1 to ' + MAX_SEED + '.' };
    var frame = 0;
    for (i = 1; i < forms.length; i++) {
      var f = forms[i];
      if (!Array.isArray(f) || sym(f[0]) !== 'frame') return { error: 'The replay holds ' + spellForm(f).slice(0, 60) + ' outside a frame, and every form after a replay\'s header is a frame, (frame <n> <row> ...), holding the rows written before that step.' };
      var n = whole(f[1]);
      if (n === null || n <= frame) return { error: 'The replay\'s frames are out of order: (frame ' + (f.length > 1 ? spellForm(f[1]) : '') + ' ...) follows ' + (frame ? '(frame ' + frame + ' ...)' : 'the header') + ', and a replay\'s frames ascend from 1.' };
      frame = n; rp.last = n;
      for (var j = 2; j < f.length; j++) {
        var row = f[j], head = Array.isArray(row) ? sym(row[0]) : null;
        if (head === 'derived') return { error: 'The replay holds a derived row, ' + spellForm(row) + ', in frame ' + n + ': the host\'s derived writes are re-derived as a replay plays and never logged (docs/SPEC.md section 7.6).' };
        // since ENGINE.30's first slice an empty row too, KERNEL.46's: Delete, a paste's empty field, a cut's source and an undo
        // giving a cell back to no value
        if (head !== 'cell' && head !== 'formula' && head !== 'empty') return { error: 'The replay holds ' + spellForm(row).slice(0, 60) + ' in frame ' + n + ', and a frame holds cell, formula and empty rows.' };
        (rp.frames[n] = rp.frames[n] || []).push(spellForm(row));
      }
    }
    return rp;
  };
  // The player: a replay read and checked whole, then the cartridge the host holds loaded again with
  // the replay's seed, and its frames played through the loop at the cartridge's rate, each frame's
  // rows one write after the derived writes, in place of the live inputs; a person's edits are
  // refused while it plays, and at its last frame the loop pauses. all: every frame at once, for an
  // oracle. The recorder records what is played, so a replay played and copied is the replay played.
  Host.prototype.play = function (text, all) {
    if (!this.m) return this._answerFailed('There is no engine module to play a replay on.');
    if (!this.handle || !this.cart || !this.cartBytes) return this._answerFailed('No cartridge is loaded to play a replay on: load the cartridge it was recorded from, then play it.');
    var rp = this._readReplay(String(text || ''));
    if (rp.error) return this._answerFailed(rp.error);
    var name = this._cartName(), digest = this._cartDigest(), c = this.cart;
    if (rp.digest !== digest) return this._answerFailed('The replay was recorded from ' + (rp.name || 'a cartridge') + ', its digest ' + rp.digest.slice(0, 16) + '..., and the cartridge loaded is ' + (name || 'another') + ', ' + digest.slice(0, 16) + '...: a replay plays only on the file it was recorded from (docs/SPEC.md section 7.6).');
    if (typeof c.seed === 'number' && !c.seedChosen && rp.seed !== c.seed) return this._answerFailed('The replay\'s seed is ' + rp.seed + ', and the cartridge\'s manifest says (seed ' + c.seed + '): a replay of this cartridge holds its manifest\'s seed.');
    var ld;
    this.playSeed = rp.seed;
    try { ld = this.loadBytes(this.cartBytes, this.cartFile); } finally { this.playSeed = undefined; }
    if (!ld.ok) return ld;
    if (this.cart.seed !== rp.seed) return this._answerFailed('The cartridge loaded again holds the seed ' + this.cart.seed + ', and the replay names ' + rp.seed + ': the replay is not played.');
    if (rp.last === 0) { this._answer('The replay of ' + name + ' holds no frame: the cartridge stands at frame 0, loaded again from the seed ' + rp.seed + '.'); return { ok: true, frames: 0 }; }
    this.player = { frames: rp.frames, last: rp.last };
    var unread = this.unreadWatches();   // a watch that reads nothing, which never pauses it (ENGINE.30)
    this._answer('Playing the replay of ' + name + ': ' + rp.last + ' frame' + (rp.last === 1 ? '' : 's') + ' from the seed ' + rp.seed + (all ? ', all at once' : ', at the cartridge\'s rate') + '; a person\'s edits wait until it ends' + (unread ? '; ' + unread : '') + '.');
    if (!all) { this.start(); return { ok: true, frames: rp.last }; }
    var win = { used: 0, limit: 0x7fffffff, deadline: Infinity };
    while (this.player && this.handle && this.watchStop === null) {   // a run to the watch stops where a watch holds (ENGINE.30)
      this._begin();
      if (!this.inFrame || !this._continue(win)) break;
    }
    return { ok: this.frame === rp.last, frames: this.frame, watched: this.watchStop };
  };
  // A replay's frame (section 7.6, decision 8): its rows as one write, after the derived writes and in
  // place of the live Input rows and edits, landing as the live writes did, since a write applies its
  // rows in order and every row logged had landed; a refused write stops the replay where it stands.
  Host.prototype._issuePlayed = function () {
    var n = this.frame + 1, rows = this.player.frames[n];
    if (!rows) return;
    var r = this._write(rows.join('\n'));
    if (r.status === 0) {
      this._recordPlayed(rows); this.inputsLast = null; this.commandRow = null; this.actKnown = null;   // the rows last written forgotten with the recorder's record (ENGINE.19), the twentieth row too (ENGINE.25), and an act's (CART.12)
      this._playedShown(rows);
      return;
    }
    this.inFrame = false; this.progress = null; this.player = null; this.stop();
    this._answerRefused('frame ' + n + ': the replay\'s rows were refused: ' + words(r) + '; the replay stops, and the cartridge stands at frame ' + this.frame + '.');
  };
  // A replay's nineteenth row (version 4), the sheet its person's viewport showed when they acted: shown at the frame's
  // end, as a tab clicked is shown, when it is not the sheet shown, so that a replay shows what its person saw (CART.9's
  // hand test, 2026-10-20: Naught's replay played on the Lesson while its acts wrote the Bench). The Camera's change in
  // the same frame, read after the step, has the last word, as it had when the person played.
  Host.prototype._playedShown = function (rows) {
    if (!this._four() || this.cart.mode !== 'grid') return;
    for (var i = rows.length - 1; i >= 0; i--) {
      var f = VP().readForms(String(rows[i]))[0];
      if (!Array.isArray(f) || sym(f[0]) !== 'cell' || String(str(f[1])).toLowerCase() !== 'input' || str(f[2]) !== 'B19') continue;
      var name = this._sheetNamed(str(f[3]));
      if (name !== null && name !== this._shown()) { this.showWanted = name; this.c.playedShown++; }
      return;
    }
  };
  Host.prototype._endReplay = function (n) {
    var r = this.player && this.player.restore;
    this.player = null; this.stop();
    this.notches = 0; this.lastKey = null;   // what the wheel and the keys did while it played is no person's frame
    // a restore's one draw, its frames having drawn nothing: a sheet its Camera asked for shown, else the grid whole
    if (r) { if (this.cart.mode === 'plane') this._drawPlane(); else if (this.showWanted) this._drawShown(); else this._drawGrid(false, false); }
    if (r) this._answer('frame ' + n + ': restored the work kept: its keyframe at frame ' + r.from + ' opened and ' + countWords(n - r.from) + ' frame' + (n - r.from === 1 ? '' : 's') + ' played again in ' + Math.round(this.now() - r.t0) + ' ms; ' + (this.cart.rate > 0 ? 'the loop is paused, and Run carries on.' : 'the grid rests, and the next act steps it.'));
    else this._answer('frame ' + n + ': the replay ended at its last frame; the loop is paused, and Run carries on from here with the live inputs.');
  };

  // ---- what a page asks of the host ----
  // One complete frame now, whatever the clock: the blit's instrument times it (?blit=1).
  Host.prototype.runFrameSync = function () {
    if (!this.handle || this.inFrame || !this.cart || this.cart.rate === 0) return false;
    this._begin();
    return this._continue({ used: 0, limit: 0x7fffffff, deadline: Infinity });
  };
  // The last complete frame drawn again, nothing stepped: the Camera and the Palette read as they
  // stand, the plane viewed through the window and blitted, or a grid's Screen viewed through it and
  // drawn by the viewport (ENGINE.8's second slice), and no other effect read, so no derived write,
  // save edge or key map moves. The blit's instrument times it over the engine's module, where a step
  // is the evaluator's and not the frame path's (ENGINE.2). A grid is always drawn, never found still
  // (ENGINE.17): this is the explicit "draw again", and the blit's baseline times a whole draw.
  Host.prototype.redraw = function () {
    if (!this.handle || !this.cart) return false;
    var d = this.cart.devices;
    if (d.camera) this._readCamera('redraw');
    if (d.palette) this._readPalette();
    if (this.cart.mode === 'grid') this._drawGrid(false, false); else this._drawPlane();   // never still (ENGINE.17)
    return true;
  };
  // The last plane blitted again at the scale its box now fits, nothing viewed and nothing stepped: a page
  // calls it when the box changes size, the window resized, a drawer opened or full screen entered, so that a
  // paused loop or rate zero refits too, where no frame would bring the next blit (ENGINE.14). False with no
  // plane drawn.
  Host.prototype.refit = function () {
    if (!this.canvas || !this.plane || !this.cart || this.cart.mode !== 'plane') return false;
    this._blit(this.plane);
    return true;
  };
  // A sheet's record as the module prints it, for a page to show; null and a sentence when refused.
  Host.prototype.viewRecord = function (sheet, win) {
    if (!this.m || !this.handle || this.inFrame) return null;
    var r = this.m.texts('alonzo_view', [this.handle], ['grid', sheet, win || '']);
    if (r.status !== 0) { this._sayOnce('record-' + sheet, 'The view of ' + sheet + ' was refused: ' + words(r) + '.', true); return null; }
    return r.text;
  };
  Host.prototype.counters = function () {
    var o = {};
    for (var k in this.c) if (Object.prototype.hasOwnProperty.call(this.c, k)) o[k] = this.c[k];
    o.frame = this.frame; o.handle = this.handle; o.window = this.window; o.scale = this.scale || 0; o.said = this.said;
    o.settling = this.settling;   // the last step's answer left the grid settling (CART.12)
    return o;
  };
  Host.prototype.sentences = function () { return this.history.slice(); };
  // The log, one line an event: a repeat of an event, the same sentence at another frame, is
  // counted in the line it first made and pushes nothing out (the owner's hand test, 2026-10-09).
  Host.prototype.log = function () { return this.order.map(entryText); };
  Host.prototype.logEntries = function () {
    return this.order.map(function (e) { return { id: e.id, text: entryText(e), key: e.key, count: e.count, first: e.first, last: e.last, refusal: e.refusal }; });
  };
  Host.prototype.destroy = function () {
    this.stop();
    if (this.handle) this.unload();
    for (var i = 0; i < this.handlers.length; i++) { var h = this.handlers[i]; h[0].removeEventListener(h[1], h[2], h[3]); }
    this.handlers = []; this.listeners = {};
    if (this.vp) { this.vp.destroy(); this.vp = null; }   // its element left as the page gave it
  };

  // ---- sentences and events ----
  // Every sentence goes into the history; an event goes into the log as well, a new line for a new
  // event and a count for a repeat; a repeat leaves the status line to the last new event. A repeat
  // is an event said before in the same load's run: a load begins new lines, so that the log reads
  // as a timeline across loads, each line's frames one run's, and the first of its kind after a load
  // is the status line's (the owner's hand test of CART.9's third slice, the bar at frame 74 after a
  // Load, and the owner's word after it, the log's "2 times, frames 2 to 2"). A refusal
  // or a failure is marked as one, the module's or the host's, so that a page paints it so (the
  // owner's word, 2026-10-09: every refusal one color); a notice of a value coerced is not one.
  // An act's answer is marked too (ENGINE.42), act: a sentence answering a person's act, said where the page called the
  // host for it or where the act lands at a frame. Its repeat is the status line's again and its line moves to the log's
  // end, so that the bar and the log's last line both say what the person just did (the owner's hand test of KIT.6's
  // held step: a build after a refused one left the refusal in the bar, red, over a success); the loop's own repeat
  // counts in place and leaves both as they were, a refusal said at every frame never taking them from a person's act.
  Host.prototype._say = function (text, kind, refusal, act) {
    kind = kind || 'event'; refusal = !!refusal; act = !!act;
    this.history.push({ text: text, kind: kind, refusal: refusal });
    if (this.history.length > HISTORY_LINES) this.history.shift();
    if (kind !== 'event') { this.status = text; this._emit('status', { text: text, kind: kind, repeat: false, refusal: refusal, act: act }); return; }
    this.said++;
    var m = FRAME_PREFIX.exec(text), key = m ? text.slice(m[0].length) : text, frame = m ? +m[1] : null;
    var slot = this.run + ':' + key, e = this.entries.get(slot);
    if (e) {
      e.count++; e.last = frame;
      if (act) { this.order.splice(this.order.indexOf(e), 1); this.order.push(e); this.status = text; }
      this._emit('status', { text: text, kind: kind, repeat: true, entry: e.id, refusal: refusal, act: act });
      return;
    }
    e = { id: ++this.entryId, key: key, slot: slot, count: 1, first: frame, last: frame, refusal: refusal };
    this.entries.set(slot, e); this.order.push(e);
    if (this.order.length > LOG_LINES) this.entries.delete(this.order.shift().slot);
    this.status = text;
    this._emit('status', { text: text, kind: kind, repeat: false, entry: e.id, refusal: refusal, act: act });
  };
  Host.prototype._refuse = function (text) { this._say(text, 'event', true); };
  Host.prototype._sayOnce = function (key, text, refusal) { if (this.said1[key] === text) return; this.said1[key] = text; this._say(text, 'event', refusal); };
  Host.prototype._fail = function (text) { this._refuse(text); return { ok: false, sentence: text }; };
  // A person's act answered (ENGINE.42): said, refused, or refused with the failure handed back, each marked the act's.
  Host.prototype._answer = function (text) { this._say(text, 'event', false, true); };
  Host.prototype._answerRefused = function (text) { this._say(text, 'event', true, true); };
  Host.prototype._answerFailed = function (text) { this._answerRefused(text); return { ok: false, sentence: text }; };
  Host.prototype.on = function (name, fn) { (this.listeners[name] = this.listeners[name] || []).push(fn); return this; };
  Host.prototype.off = function (name, fn) {
    var l = this.listeners[name];
    if (l) for (var i = l.length - 1; i >= 0; i--) if (l[i] === fn) l.splice(i, 1);
    return this;
  };
  Host.prototype._emit = function (name, payload) {
    var l = this.listeners[name];
    if (!l) return;
    for (var i = 0; i < l.length; i++) { try { l[i](payload); } catch (e) { if (global.console) global.console.error(e); } }
  };

  // ---- instantiation: the empty import object of section 8.1 ----
  Host.instantiate = function (bytes) { return WebAssembly.instantiate(bytes, {}).then(function (res) { return res.instance.exports; }); };
  Host.instantiateSync = function (bytes) { return new WebAssembly.Instance(new WebAssembly.Module(bytes), {}).exports; };
  Host.RULES = RULES;
  Host.commandWords = commandWords;
  Host.KEY_NAMES = KEY_NAMES;
  Host.parseKeys = parseKeys;
  Host.keyMatches = keyMatches;
  Host.commandKeyOf = commandKeyOf;
  Host.settledWords = settledWords;
  Host.firstChange = firstChange;
  Host.changeWords = changeWords;
  Host.EXPORTS = EXPORTS;
  Host.ABI = ABI;
  Host.SPEC = SPEC;
  Host.MAX_CARTRIDGE_BYTES = MAX_CARTRIDGE_BYTES;   // section 10's file, which a page's save with its drafts is held to (ENGINE.40)
  // The host's SHA-256 of bytes, or of a text's UTF-8, in upper-case hex: an oracle holds it to FIPS 180-2's vectors.
  Host.sha256 = function (x) { return sha256(typeof x === 'string' ? enc.encode(x) : x); };
  // The host's patch of a values record by a window's changes (ENGINE.19, decision 3), pure: the record's text after
  // the answer's rows, or null for a whole answer, or a record or rows it lays no patch on. An oracle holds it to
  // records of its own.
  Host.patchRecord = function (record, changes) {
    var rec = byCell(String(record)), ch = readChanges(String(changes));
    return rec && ch && !ch.whole ? patchRecord(rec, ch.rows) : null;
  };
  // The host's comparison of a rebuilt cartridge with the one a grid was given (ENGINE.7, decisions 2 to 5), pure: why a
  // write cannot carry the change, each difference in words, and the rows a continue writes. An oracle holds it.
  Host.compareCartridges = function (base, rebuilt) {
    var c = compareCartridges(String(base), String(rebuilt));
    return { why: c.why.slice(), rows: c.rows.slice(), formulas: c.formulas, values: c.values, cells: c.cells };
  };
  Host.version = 1;

  global.AlonzoHost = Host;
})(typeof window !== 'undefined' ? window : this);

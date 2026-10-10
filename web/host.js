/*
  SPDX-FileCopyrightText: 2026 Spreadsheet Company
  SPDX-License-Identifier: Apache-2.0

  web/host.js - the host shim: the loop of SPEC.md section 5 over the
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
  Palette, so that a frame is drawn through its own Camera and colours,
  then the Screen as the plane through the Camera's window, the Keys, the
  Audio rows, the File's save cell, the Write sheet and the Clock's rate,
  which a person may write and the loop then steps at; and the blit, the
  plane's bytes through the palette into an ImageData drawn at a whole
  number of device pixels a cell, magenta past the palette. At rate zero
  there is no tick: one step for each edit, and no Input. At a load whose
  manifest says (seed host) the host chooses the seed, its one write of its
  own (ENGINE.3).

  Beside the loop it runs the pass (SPEC.md section 7.8, SPEC.3's second
  slice): a cartridge's source, its path and the texts it includes handed to
  the module's twelfth export, alonzo_expand, an act of its own that takes no
  handle and touches no grid, its answer the cartridge's text for a page to
  show before anything loads it. The export is asked for at the act and not
  at the attach, since the fake module holds no pass and still drives the
  loop; over a module without one, a build is declined in words.

  And it keeps the replay (SPEC.md section 7.6; ENGINE.3's second slice):
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

  What the host holds is SD-23's interface state and nothing else (AD-6):
  the keys held, the pointer's place, the accumulator, the budget's
  measurement, the palette's table, the key map, the Camera's two cells,
  the derived rows waiting for the next frame, and the replay's record and
  the frames a replay has left to play. Every value is the module's.
  Every refusal and every event is a sentence, the latest new one in the
  status and the last twenty events in a log, a repeat of an event counted in
  the line it first made rather than pushing the others out (SD-30), and a
  refusal or a failure is marked as one, so that a page paints every refusal
  one colour. Every view over the module's memory is made fresh for each
  read, since any growth of the memory detaches the buffer the earlier views
  were made over.

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
  var SLICE_FRACTION = 0.5;          // the share of the display's interval the steps of one tick may spend
  var INTERVAL_SAMPLES = 30;         // the display's interval is the median of the first thirty deltas
  var DEFAULT_INTERVAL_MS = 1000 / 60;
  var TIMER_FLOOR_MS = 0.1;          // a step faster than the timer's grain is measured at the grain
  var LOG_LINES = 20;
  var HISTORY_LINES = 2000;
  var MAX_SEED = 2147483646;         // the highest seed, so a Park and Miller cell never sticks at 0 (section 3.5)
  var MAX_RATE = 120;                // the highest rate, in frames a second (section 10)
  var SPEC = 3;                      // the page's version this host implements, which a replay's header names
  var REPLAY_CAP = 8 * 1048576;      // the replay's text, past which the recorder stops and says so: about an
                                     // hour of a pointer that never rests (ENGINE.3, decision 10)
  var ABI = 1;
  var RULES = {
    abi: ABI, capMs: ACCUMULATOR_CAP_MS, firstBudget: FIRST_BUDGET, minBudget: MIN_BUDGET,
    sliceFraction: SLICE_FRACTION, intervalSamples: INTERVAL_SAMPLES, logLines: LOG_LINES
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
  // A refusal as the host prints it: the module's words once, then its id; the line only when a
  // write held more than one row, since a one-row write's line is always 1, and only when the
  // module's words do not already name it. The language's grid texts named it until KERNEL.23
  // ("Line 47 writes ..."); since then they name what they refuse and leave the line to the
  // answer's own field, so a refused load's line is said here.
  function namesLine(text, line) { return new RegExp('\\b[Ll]ine ' + line + '\\b').test(text); }
  function words(r, oneRow) { return r.status === 2 ? r.text : r.text + (r.line && !oneRow && !namesLine(r.text, r.line) ? ' (line ' + r.line + ')' : '') + ' [' + r.id + ']'; }
  function first(text, head) { var f = VP().readForms(text)[0]; return Array.isArray(f) && sym(f[0]) === head ? f : null; }
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
  // The cartridge's name, its manifest's first field, after the comment lines before it.
  function manifestName(text) {
    var m = /^\s*(?:;[^\n]*\n\s*)*\(\s*cartridge\s+"((?:[^"\\]|\\.)*)"/.exec(text);
    return m ? m[1] : '';
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

  // ---- (1) the module: the memory pair and the record (SPEC.md section 4.6) ----
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
  // 2147483646).
  function Host(options) {
    options = options || {};
    VP();
    this.options = options;
    this.now = options.now || function () { return global.performance.now(); };
    this.canvas = options.canvas || null;
    this.box = options.box || (this.canvas ? this.canvas.parentNode : null);
    this.fixedScale = options.scale || 0;
    this.fixedBudget = options.budget;
    this.callsPerTick = options.callsPerTick || 0;
    this.listeners = {};
    this.handlers = [];
    this.entries = new Map(); this.order = []; this.entryId = 0;   // the log: one entry an event, its repeats counted
    this.history = []; this.said = 0; this.status = '';
    this.m = null; this.version = ''; this.handle = 0; this.cart = null;
    this.cartBytes = null; this.cartFile = '';   // the cartridge loaded, as its load was given it: a replay reloads it
    this.running = false; this.hidden = false; this.raf = 0;
    this._reset();
    if (this.canvas) this._listenCanvas();
    this._listenPage();
  }
  Host.prototype._reset = function () {
    this.frame = 0; this.inFrame = false; this.progress = null; this.stepEdit = null;
    this.acc = 0; this.lastTs = null; this.deltas = []; this.interval = DEFAULT_INTERVAL_MS;
    this.cellsPerMs = 0; this.frameCells = 0;
    this.pending = []; this.edits = [];
    this.held = Object.create(null); this.lastKey = null; this.notches = 0;
    this.pointer = { col: 0, row: 0, left: 0, right: 0, middle: 0 };
    this.keymap = null; this.window = ''; this.camera = { row: 1, col: 1 }; this.badCamera = {};
    this.table = null; this.paletteText = ''; this.paletteCount = 0;
    this.audio = []; this.saveValue = 0; this.plane = null; this.timing = null; this.said1 = {};
    this.windowsSeen = {};
    this.rec = null; this.player = null;   // the replay recorded since the load, and one playing
    this.c = { frames: 0, calls: 0, yields: 0, inputs: 0, derivedApplied: 0, derivedRefused: 0, edits: 0, editsRefused: 0, windows: 0, draws: 0, saves: 0 };
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
    if (!this.m) return this._fail('There is no engine module to load a cartridge into.');
    this.stop();
    if (this.handle) this.unload();
    this._reset();
    this.cartBytes = null; this.cartFile = '';
    var b = this.m.put(bytes), n = this.m.text(name || ''), r;
    try { r = this.m.call('alonzo_load', [b.ptr, b.len, n.ptr, n.len]); } finally { this.m.release(b); this.m.release(n); }
    if (r.status !== 0) return this._fail('The cartridge was refused: ' + words(r) + '.');
    var f = first(r.text, 'cartridge');
    if (!f) return this._fail('The module answered the load with ' + r.text.trim() + ', not a cartridge row.');
    this.handle = num(f[1]);
    this.cartBytes = bytes; this.cartFile = name || '';
    var c = this.cart = { title: str(f[2]), mode: sym(f[3]), w: num(f[4]), h: num(f[5]), rate: num(f[6]), seed: '', devices: {}, budget: null, name: null, digest: null };
    this._describe();
    this.window = rangeOf(1, 1, c.h, c.w);
    this._say('Loaded ' + c.title + ': a ' + c.w + ' by ' + c.h + ' ' + c.mode + ' at ' + (c.rate ? c.rate + ' frames a second' : 'rate 0, a step on every edit') + ', seed ' + c.seed + ', on ' + this.version + '.');
    if (c.budget) {
      var bd = c.budget, over = bd.perSecond > bd.line;
      this._say(c.rate ? 'The budget: ' + thousands(bd.cells) + ' formula cells a frame at ' + c.rate + ' frames a second, ' + thousands(bd.perSecond) + ' a second, ' + (over ? 'over' : 'under') + ' the console\'s line of ' + thousands(bd.line) + (over ? ': it will run slowly, in plain sight.' : '.')
                       : 'The budget: ' + thousands(bd.cells) + ' formula cells a step, one step an edit.');
    }
    if (c.mode !== 'plane') this._say('This slice blits the plane alone; a grid cartridge is drawn by the viewport, which the host takes up after it.');
    if (c.seed === 'host') this._seed();
    this._startReplay();   // the replay of this load's run, from frame 0 (section 7.6)
    if (c.devices.camera) this._readCamera();
    if (c.devices.palette) this._readPalette();
    if (c.devices.keys) this._readKeys();
    // The new grid drawn at once, frame 0 with nothing computed (a formula with no value yet reads
    // 0, a value cell its value): a load completes no frame, and without this draw the canvas kept
    // the last run's picture, a grid that no longer exists (the owner's hand test, 2026-10-09).
    if (c.mode === 'plane') this._drawPlane();   // frame 0, drawn at the load
    this._emit('load', { handle: this.handle, title: c.title, mode: c.mode, w: c.w, h: c.h, rate: c.rate, window: this.window, scale: this.scale || 0 });
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
    if (r.status !== 0) { this._refuse('The cartridge asks the host for its seed, and the write of ' + n + ' into Clock!B3 was refused: ' + words(r, true) + '.'); return; }
    this.cart.seed = n; this.cart.seedChosen = true;
    this._say(played ? 'The cartridge asks the host for its seed: the replay names ' + n + ', written in Clock!B3.'
                     : 'The cartridge asks the host for its seed: the host chose ' + n + ', in Clock!B3.');
  };
  Host.prototype._describe = function () {
    var r = this.m.call('alonzo_describe', [this.handle]);
    if (r.status !== 0) { this._refuse('The describe was refused: ' + words(r) + '.'); return; }
    var forms = VP().readForms(r.text), c = this.cart;
    for (var i = 0; i < forms.length; i++) {
      var f = forms[i], head = Array.isArray(f) ? sym(f[0]) : null;
      if (head === 'seed') c.seed = num(f[1]) !== null ? num(f[1]) : sym(f[1]);
      else if (head === 'device' && str(f[1])) c.devices[str(f[1]).toLowerCase()] = { range: str(f[2]), direction: sym(f[3]) };
      else if (head === 'budget') c.budget = { rate: num(f[1]), cells: num(f[2]), perSecond: num(f[3]), line: num(f[4]) };
    }
  };
  Host.prototype.unload = function () {
    if (!this.m || !this.handle) return;
    this.stop();
    var r = this.m.call('alonzo_unload', [this.handle]);
    if (r.status !== 0) this._refuse('The unload was refused: ' + words(r) + '.');
    this.handle = 0; this.cart = null; this.inFrame = false; this.progress = null; this.plane = null;
    this._clear();
  };
  // The canvas emptied when its grid is unloaded: what it showed is gone, and a load refused after
  // it leaves no picture of a grid the module no longer holds.
  Host.prototype._clear = function () {
    if (!this.canvas) return;
    var ctx = this.ctx || this.canvas.getContext('2d');
    ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
  };

  // ---- the pass (SPEC.md section 7.8; SPEC.3's second slice): an act of its own, before any load ----
  // A source, its path and the texts it may include, [path, text] pairs, handed to the module's
  // alonzo_expand, the texts joined path, NUL, text, NUL, as the export reads them; the answer is the
  // cartridge's text, the command line's bytes, for a page to show before anything loads it. The
  // pass takes no handle and touches no grid, so nothing here stops, unloads or resets the loop. The
  // export is asked for at the act and not at the attach, since the fake module holds no pass and
  // still drives the loop: over a module without one, the build is declined in words.
  Host.prototype.expand = function (source, path, files) {
    if (!this.m) return this._fail('There is no engine module to run the pass.');
    var name = String(path || '').replace(/^.*[\/\\]/, '');
    if (typeof this.m.x.alonzo_expand !== 'function') return this._fail('The module exports no alonzo_expand, so it holds no pass to build a cartridge from ' + (name || 'its source') + ': the engine\'s module holds one (SPEC.md section 7.8).');
    var parts = [];
    for (var i = 0; i < (files || []).length; i++) parts.push(String(files[i][0]), String(files[i][1]));
    var t0 = this.now(), r = this.m.texts('alonzo_expand', [], [source, path, parts.join('\u0000')]), ms = this.now() - t0;
    if (r.status !== 0) return this._fail('The pass refused ' + name + ': ' + words(r) + '.');
    var rows = Math.max(0, VP().readForms(r.text).length - 1);
    this._say('Built ' + name.replace(/\.source\.vla$/i, '.vla') + ' from ' + name + ' by the pass: its manifest and ' + thousands(rows) + ' row' + (rows === 1 ? '' : 's') + ', and nothing loaded.');
    return { ok: true, text: r.text, rows: rows, ms: ms };
  };

  // ---- the loop (section 5) ----
  Host.prototype.start = function () {
    if (this.running || !this.handle) return;
    this.running = true; this.lastTs = null;
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
    this.running = false;
    if (this.raf && global.cancelAnimationFrame) global.cancelAnimationFrame(this.raf);
    this.raf = 0;
  };
  // One animation frame's work, at its timestamp: the step 1 of section 5.
  Host.prototype.tick = function (ts) {
    if (!this.running || !this.handle || this.hidden || !this.cart) return;
    var c = this.cart, win;
    if (c.rate === 0) {   // no tick at rate zero: a frame an edit began continues here, and the edits waiting follow it
      win = this._window();
      if (this.inFrame) { if (this._continue(win)) this._editFrames(win); }
      else if (this.edits.length) this._editFrames(win);   // edits made in the frame that set the rate to 0
      else if (this.player) { this._begin(); if (this.inFrame) this._continue(win); }   // a replay's frame a tick, its edits being its frames
      return;
    }
    if (this.lastTs === null) { this.lastTs = ts; return; }
    var dt = ts - this.lastTs;
    this.lastTs = ts;
    this._sample(dt);
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
  // Rate zero: one step for each edit, in the order they were made.
  Host.prototype._editFrames = function (win) {
    while (!this.inFrame && this.edits.length && this.handle) {
      this.inFrame = true;
      this.progress = { evaluated: 0, of: this.frameCells };
      this._issueDerived();
      var row = this.edits.shift();
      if (!this._issueEdit(row, true)) { this.inFrame = false; this.progress = null; continue; }
      this.stepEdit = row;
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
    this._complete(num(f[1]));
    return 'done';
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
  Host.prototype._issueInputs = function () {
    if (this.player) { this._issuePlayed(); return; }   // a replay's rows in place of the live inputs and edits (section 7.6)
    if (this.cart.rate > 0) {
      var rows = this._inputRows(), r = this._write(rows);
      this.c.inputs++;
      if (r.status !== 0) this._refuse('frame ' + (this.frame + 1) + ': the Input rows were refused: ' + words(r) + '.');
      else this._recordInputs(rows);
      this.notches = 0; this.lastKey = null;
    }
    while (this.edits.length) this._issueEdit(this.edits.shift(), false);
  };
  Host.prototype._issueEdit = function (row, atRateZero) {
    var r = this._write(row);
    if (r.status === 0) {
      this.c.edits++;
      this._recordEdit(row);   // the replay logs a person's edit that landed, in its frame (section 7.6)
      if (!atRateZero) this._say('frame ' + (this.frame + 1) + ': the edit ' + row + ' was written.');
      return true;
    }
    this.c.editsRefused++;
    this._refuse('frame ' + (this.frame + 1) + ': the edit ' + row + ' was refused: ' + words(r, true) + (atRateZero ? '; no step.' : '.'));
    return false;
  };
  // The Input sheet's eighteen rows (section 3.3): ten buttons for four players through the key map,
  // the pointer in Screen cells, its three buttons, the wheel's notches, the last key twice. The
  // pointer is held as the window's cell under it, and written as the Screen's own cell (ENGINE.3,
  // decision 4): the window's cell plus the offset of the Camera the person sees, the one the last
  // frame was drawn through, so that ROW() and COLUMN() find the cell pointed at wherever the Camera
  // stands; 0 off the canvas.
  Host.prototype._inputRows = function () {
    var out = [], km = this.keymap, held = this.held, pt = this.pointer, k = this.lastKey, cam = this.camera;
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
    return out.join('\n');
  };

  // ---- the effects (step 5) and the draw (step 6) ----
  Host.prototype._complete = function (n) {
    this.frame = n; this.c.frames++;
    this._recordFrame(n);
    var d = this.cart.devices;
    if (d.camera) this._readCamera();
    if (d.palette) this._readPalette();
    if (this.cart.mode === 'plane') this._drawPlane();
    if (d.keys) this._readKeys();
    if (d.audio) this._readAudio();
    if (d.file) this._readFile();
    if (d.write) this._readWrite();
    if (d.clock) this._readClock();
    if (this.stepEdit) { this._say('frame ' + n + ': stepped once for the edit ' + this.stepEdit + '.'); this.stepEdit = null; }
    var p = this.player;
    this._emit('frame', { frame: n, window: this.window, scale: this.scale || 0, rate: this.cart.rate, replay: p ? p.last : 0 });
    if (p && p === this.player && n >= p.last) this._endReplay(n);
  };
  Host.prototype._record = function (sheet) {
    var r = this.m.texts('alonzo_view', [this.handle], ['grid', sheet, '']);
    if (r.status !== 0) { this._sayOnce('view-' + sheet, 'frame ' + this.frame + ': the view of ' + sheet + ' was refused: ' + words(r) + '.', true); return null; }
    return r.text;
  };
  Host.prototype._cells = function (sheet) { var t = this._record(sheet); return t === null ? null : sheetCells(t); };
  // The Camera's two cells place the window this frame is drawn through (section 3.8).
  Host.prototype._readCamera = function () {
    var cells = this._cells('Camera');
    if (!cells) return;
    var c = this.cart;
    var row = Math.min(this._cameraCell(cells.B1, 'row'), 1048576 - c.h + 1), col = Math.min(this._cameraCell(cells.B2, 'column'), 16384 - c.w + 1);
    var text = rangeOf(row, col, c.h, c.w);
    if (text !== this.window) this._say('frame ' + this.frame + ': the Camera placed the window at ' + text + '.');
    this.window = text; this.camera = { row: row, col: col };
  };
  Host.prototype._cameraCell = function (v, what) {
    if (typeof v === 'number' && v >= 1 && Math.floor(v) === v) { this.badCamera[what] = undefined; return v; }
    var shown = v === null || v === undefined ? 'empty' : (typeof v === 'string' ? '"' + v + '"' : (typeof v === 'object' ? 'an error, ' + v.error : String(v)));
    if (this.badCamera[what] !== shown) { this.badCamera[what] = shown; this._say('frame ' + this.frame + ': the Camera\'s ' + what + ' is ' + shown + ', not a whole number from 1; the window takes 1.'); }
    return 1;
  };
  Host.prototype._readPalette = function () {
    var text = this._record('Palette');
    if (text === null || text === this.paletteText) return;
    this.paletteText = text;
    var cells = sheetCells(text), table = new Uint32Array(256), bad = [], count = 0;
    table.fill(MAGENTA);
    for (var i = 1; i <= 255; i++) {
      var v = cells['B' + i];
      if (v === undefined) break;
      var m = typeof v === 'string' ? /^#([0-9A-Fa-f]{6})$/.exec(v) : null;
      if (m) { var x = parseInt(m[1], 16); table[i - 1] = pack((x >> 16) & 255, (x >> 8) & 255, x & 255); count = i; }
      else bad.push('B' + i);
    }
    this.table = table; this.paletteCount = count;
    if (bad.length) this._say('frame ' + this.frame + ': the Palette\'s ' + bad.join(', ') + ' hold no #RRGGBB colour; those indices paint magenta.');
  };
  Host.prototype._drawPlane = function () {
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
    if (v === 1 && this.saveValue !== 1) { this.c.saves++; this._say('frame ' + this.frame + ': the cartridge asked to be saved (File!B3 rose to 1); writing the save is the File device\'s, ENGINE.5.'); }
    this.saveValue = v;
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

  // ---- a person's acts: edits, keys, the pointer ----
  // An edit is one cell or formula row, issued as its own write after the frame's inputs; at
  // rate zero it steps the grid once, and the frame number counts the edits that landed.
  Host.prototype.edit = function (row) {
    var t = String(row || '').trim(), forms = VP().readForms(t);
    var head = forms.length === 1 && Array.isArray(forms[0]) ? sym(forms[0][0]) : null;
    if (head !== 'cell' && head !== 'formula') { this._refuse('An edit is one cell or formula row, as (cell "Palette" "B1" "#FF8800"); ' + (t || 'an empty line') + ' is not one.'); return false; }
    if (!this.handle) { this._refuse('No cartridge is loaded to edit.'); return false; }
    if (this.player) { this._refuse('The edit ' + t + ' was not written: a replay is playing, frame ' + this.frame + ' of ' + this.player.last + ', and a person\'s edit waits until it ends, so that what plays is the replay alone.'); return false; }
    this.edits.push(t);
    if (this.cart.rate === 0 && !this.inFrame) this._editFrames(this._window());
    return true;
  };
  Host.prototype.keyDown = function (code, key) {
    if (!code) return false;
    this.held[code] = true;
    this.lastKey = { key: key === undefined ? '' : String(key), code: String(code) };
    return this._bound(code);
  };
  Host.prototype.keyUp = function (code) { delete this.held[code]; };
  Host.prototype.releaseKeys = function () { this.held = Object.create(null); };
  Host.prototype._bound = function (code) {
    var km = this.keymap;
    if (!km) return false;
    for (var b = 0; b < km.length; b++) for (var p = 0; p < km[b].length; p++) if (km[b][p] === code) return true;
    return false;
  };
  Host.prototype.pointerAt = function (col, row) { this.pointer.col = col | 0; this.pointer.row = row | 0; };
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
    this._on(cv, 'keydown', function (ev) { if (self.keyDown(ev.code, ev.key)) ev.preventDefault(); });
    this._on(cv, 'keyup', function (ev) { self.keyUp(ev.code); });
    this._on(cv, 'blur', function () { self.releaseKeys(); });
    this._on(cv, 'mousemove', function (ev) { self._pointerFrom(ev); });
    this._on(cv, 'mousedown', function (ev) { cv.focus(); self._pointerFrom(ev); ev.preventDefault(); });
    this._on(cv, 'mouseup', function (ev) { self._pointerFrom(ev); });
    this._on(cv, 'mouseleave', function () { self.pointerAt(0, 0); self.pointerButtons(0, 0, 0); });
    this._on(cv, 'contextmenu', function (ev) { ev.preventDefault(); });
    this._on(cv, 'wheel', function (ev) { self.wheel(ev.deltaY > 0 ? 1 : (ev.deltaY < 0 ? -1 : 0)); ev.preventDefault(); }, { passive: false });
  };
  // A hidden page stops the ticks, and its return starts the clock again with nothing owed.
  Host.prototype._listenPage = function () {
    var self = this, d = global.document;
    if (!d) return;
    this._on(d, 'visibilitychange', function () {
      if (d.hidden) { self.hidden = true; return; }
      self.hidden = false; self.lastTs = null; self.acc = 0;
    });
  };

  // ---- the replay (SPEC.md section 7.6; ENGINE.3's second slice, decisions 8 to 10) ----
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
  Host.prototype._recordInputs = function (text) {
    var rec = this.rec;
    if (!rec || rec.full) return;
    var lines = text.split('\n'), was = rec.input, now = {};
    for (var i = 0; i < lines.length; i++) {
      var m = INPUT_ROW.exec(lines[i]);
      if (!m) continue;
      now[m[1]] = m[2];
      if (!was || was[m[1]] !== m[2]) rec.rows.push(lines[i]);
    }
    rec.input = now;
  };
  Host.prototype._recordEdit = function (row) {
    var rec = this.rec;
    if (!rec || rec.full) return;
    var f = VP().readForms(row)[0];
    rec.rows.push(spellForm(f));
    if (String(str(f[1])).toLowerCase() === 'input') rec.input = null;   // the Input sheet unknown to the replay: its next rows are logged whole
  };
  Host.prototype._recordPlayed = function (rows) {
    var rec = this.rec;
    if (!rec || rec.full) return;
    for (var i = 0; i < rows.length; i++) rec.rows.push(rows[i]);
    rec.input = null;   // a replay's rows are its own record: live rows after it are logged whole
  };
  Host.prototype._recordFrame = function (n) {
    var rec = this.rec;
    if (!rec || rec.full) return;
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
  // The replay of the run since the last load: its header, then each frame that wrote a row, and
  // the last frame however empty, so that a replay names its length; null with no cartridge.
  Host.prototype.replayText = function () {
    var rec = this.rec;
    if (!rec || !this.handle || !this.cart) return null;
    if (rec.seed === null) { this._sayOnce('replay-seed', 'There is no replay of this run: Clock!B3 holds no seed the load wrote, and a replay names its seed.', true); return null; }
    var out = '(replay ' + quote(this._cartName()) + ' (spec ' + SPEC + ') (cartridge "' + this._cartDigest() + '") (seed ' + rec.seed + '))\n' + rec.blocks.join('');
    if (rec.last > rec.written) out += '(frame ' + rec.last + ')\n';
    return out;
  };
  // A replay's text read whole before anything plays: the header, then frames ascending from 1, each
  // one form holding its cell and formula rows; a refusal in words, and nothing loaded.
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
    if (rp.spec > SPEC) return { error: 'The replay is written to the page\'s version ' + rp.spec + ', and this host implements versions 1 to ' + SPEC + ' (SPEC.md): a later version\'s replay may hold what this host cannot play.' };
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
        if (head === 'derived') return { error: 'The replay holds a derived row, ' + spellForm(row) + ', in frame ' + n + ': the host\'s derived writes are re-derived as a replay plays and never logged (SPEC.md section 7.6).' };
        if (head !== 'cell' && head !== 'formula') return { error: 'The replay holds ' + spellForm(row).slice(0, 60) + ' in frame ' + n + ', and a frame holds cell and formula rows.' };
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
    if (!this.m) return this._fail('There is no engine module to play a replay on.');
    if (!this.handle || !this.cart || !this.cartBytes) return this._fail('No cartridge is loaded to play a replay on: load the cartridge it was recorded from, then play it.');
    var rp = this._readReplay(String(text || ''));
    if (rp.error) return this._fail(rp.error);
    var name = this._cartName(), digest = this._cartDigest(), c = this.cart;
    if (rp.digest !== digest) return this._fail('The replay was recorded from ' + (rp.name || 'a cartridge') + ', its digest ' + rp.digest.slice(0, 16) + '..., and the cartridge loaded is ' + (name || 'another') + ', ' + digest.slice(0, 16) + '...: a replay plays only on the file it was recorded from (SPEC.md section 7.6).');
    if (typeof c.seed === 'number' && !c.seedChosen && rp.seed !== c.seed) return this._fail('The replay\'s seed is ' + rp.seed + ', and the cartridge\'s manifest says (seed ' + c.seed + '): a replay of this cartridge holds its manifest\'s seed.');
    var ld;
    this.playSeed = rp.seed;
    try { ld = this.loadBytes(this.cartBytes, this.cartFile); } finally { this.playSeed = undefined; }
    if (!ld.ok) return ld;
    if (this.cart.seed !== rp.seed) return this._fail('The cartridge loaded again holds the seed ' + this.cart.seed + ', and the replay names ' + rp.seed + ': the replay is not played.');
    if (rp.last === 0) { this._say('The replay of ' + name + ' holds no frame: the cartridge stands at frame 0, loaded again from the seed ' + rp.seed + '.'); return { ok: true, frames: 0 }; }
    this.player = { frames: rp.frames, last: rp.last };
    this._say('Playing the replay of ' + name + ': ' + rp.last + ' frame' + (rp.last === 1 ? '' : 's') + ' from the seed ' + rp.seed + (all ? ', all at once' : ', at the cartridge\'s rate') + '; a person\'s edits wait until it ends.');
    if (!all) { this.start(); return { ok: true, frames: rp.last }; }
    var win = { used: 0, limit: 0x7fffffff, deadline: Infinity };
    while (this.player && this.handle) {
      this._begin();
      if (!this.inFrame || !this._continue(win)) break;
    }
    return { ok: this.frame === rp.last, frames: this.frame };
  };
  // A replay's frame (section 7.6, decision 8): its rows as one write, after the derived writes and in
  // place of the live Input rows and edits, landing as the live writes did, since a write applies its
  // rows in order and every row logged had landed; a refused write stops the replay where it stands.
  Host.prototype._issuePlayed = function () {
    var n = this.frame + 1, rows = this.player.frames[n];
    if (!rows) return;
    var r = this._write(rows.join('\n'));
    if (r.status === 0) { this._recordPlayed(rows); return; }
    this.inFrame = false; this.progress = null; this.player = null; this.stop();
    this._refuse('frame ' + n + ': the replay\'s rows were refused: ' + words(r) + '; the replay stops, and the cartridge stands at frame ' + this.frame + '.');
  };
  Host.prototype._endReplay = function (n) {
    this.player = null; this.stop();
    this.notches = 0; this.lastKey = null;   // what the wheel and the keys did while it played is no person's frame
    this._say('frame ' + n + ': the replay ended at its last frame; the loop is paused, and Run carries on from here with the live inputs.');
  };

  // ---- what a page asks of the host ----
  // One complete frame now, whatever the clock: the blit's instrument times it (?blit=1).
  Host.prototype.runFrameSync = function () {
    if (!this.handle || this.inFrame || !this.cart || this.cart.rate === 0) return false;
    this._begin();
    return this._continue({ used: 0, limit: 0x7fffffff, deadline: Infinity });
  };
  // The last complete frame drawn again, nothing stepped: the Camera and the Palette read as they
  // stand, the plane viewed through the window and blitted, and no other effect read, so no derived
  // write, save edge or key map moves. The blit's instrument times it over the engine's module,
  // where a step is the evaluator's and not the frame path's (ENGINE.2).
  Host.prototype.redraw = function () {
    if (!this.handle || !this.cart || this.cart.mode !== 'plane') return false;
    var d = this.cart.devices;
    if (d.camera) this._readCamera();
    if (d.palette) this._readPalette();
    this._drawPlane();
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
  };

  // ---- sentences and events ----
  // Every sentence goes into the history; an event goes into the log as well, a new line for a new
  // event and a count for a repeat; a repeat leaves the status line to the last new event. A refusal
  // or a failure is marked as one, the module's or the host's, so that a page paints it so (the
  // owner's word, 2026-10-09: every refusal one colour); a notice of a value coerced is not one.
  Host.prototype._say = function (text, kind, refusal) {
    kind = kind || 'event'; refusal = !!refusal;
    this.history.push({ text: text, kind: kind, refusal: refusal });
    if (this.history.length > HISTORY_LINES) this.history.shift();
    if (kind !== 'event') { this.status = text; this._emit('status', { text: text, kind: kind, repeat: false, refusal: refusal }); return; }
    this.said++;
    var m = FRAME_PREFIX.exec(text), key = m ? text.slice(m[0].length) : text, frame = m ? +m[1] : null;
    var e = this.entries.get(key);
    if (e) {
      e.count++; e.last = frame;
      this._emit('status', { text: text, kind: kind, repeat: true, entry: e.id, refusal: refusal });
      return;
    }
    e = { id: ++this.entryId, key: key, count: 1, first: frame, last: frame, refusal: refusal };
    this.entries.set(key, e); this.order.push(e);
    if (this.order.length > LOG_LINES) this.entries.delete(this.order.shift().key);
    this.status = text;
    this._emit('status', { text: text, kind: kind, repeat: false, entry: e.id, refusal: refusal });
  };
  Host.prototype._refuse = function (text) { this._say(text, 'event', true); };
  Host.prototype._sayOnce = function (key, text, refusal) { if (this.said1[key] === text) return; this.said1[key] = text; this._say(text, 'event', refusal); };
  Host.prototype._fail = function (text) { this._refuse(text); return { ok: false, sentence: text }; };
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
  Host.EXPORTS = EXPORTS;
  Host.ABI = ABI;
  Host.SPEC = SPEC;
  // The host's SHA-256 of bytes, or of a text's UTF-8, in upper-case hex: an oracle holds it to FIPS 180-2's vectors.
  Host.sha256 = function (x) { return sha256(typeof x === 'string' ? enc.encode(x) : x); };
  Host.version = 1;

  global.AlonzoHost = Host;
})(typeof window !== 'undefined' ? window : this);

/*
  SPDX-FileCopyrightText: 2026 Spreadsheet Company
  SPDX-License-Identifier: Apache-2.0

  web/host.js - the host shim: the loop of SPEC.md section 5 over the
  engine's module (ENGINE.1). It instantiates nothing it was not handed and
  imports nothing: a page gives it a module's exports, the engine's own or
  the fake module's (web/fake.js), and it asks the ABI number before
  anything else and refuses another (section 8.1). Then it runs the frame's
  order of operations: the tick of the animation frame with a fixed
  timestep and an accumulator, capped at a quarter of a second, with no
  interpolation and no skipped frame, paused while the page is hidden; the
  derived writes of the Write sheet before the inputs, each its own write
  of one derived row; the Input sheet's eighteen rows from the keys it
  holds, mapped through the Keys sheet, and the pointer; a person's edits,
  each its own write; the step with a budget in cells, which may yield and
  continue on the next tick, its progress a sentence (SD-34); the effects
  read after the step, the Camera first and the Palette, so that a frame is
  drawn through its own Camera and colours, then the Screen as the plane
  through the Camera's window, the Keys, the Audio rows, the File's save
  cell and the Write sheet; and the blit, the plane's bytes through the
  palette into an ImageData drawn at a whole number of device pixels a
  cell, magenta past the palette. At rate zero there is no tick: one step
  for each edit, and no Input.

  What the host holds is SD-23's interface state and nothing else (AD-6):
  the keys held, the pointer's place, the accumulator, the budget's
  measurement, the palette's table, the key map, the Camera's two cells and
  the derived rows waiting for the next frame. Every value is the module's.
  Every refusal and every event is a sentence, the latest new one in the
  status and the last twenty events in a log, a repeat of an event counted in
  the line it first made rather than pushing the others out (SD-30). Every
  view over the module's memory is
  made fresh for each read, since any growth of the memory detaches the
  buffer the earlier views were made over.

  It reads every record with the viewport's reader (web/viewport.js,
  AlonzoViewport.readForms), which must load first: the shim holds no
  reader of its own.

  Plain script, no module syntax, no library, nothing fetched: one global,
  AlonzoHost, set by this closure. The API is documented in web/README.md.
*/
(function (global) {
  'use strict';

  // ---- the rules of the loop, as ENGINE.1's scoping states them (decisions 4 to 8) ----
  var ACCUMULATOR_CAP_MS = 250;      // Fiedler's cap, on a tick's time and on the backlog: a stall runs seven frames at 30, never thirty
  var FIRST_BUDGET = 16000;          // the cells of a step call before a rate is measured
  var MIN_BUDGET = 1000;             // the least a measured budget asks for
  var SLICE_FRACTION = 0.5;          // the share of the display's interval the steps of one tick may spend
  var INTERVAL_SAMPLES = 30;         // the display's interval is the median of the first thirty deltas
  var DEFAULT_INTERVAL_MS = 1000 / 60;
  var TIMER_FLOOR_MS = 0.1;          // a step faster than the timer's grain is measured at the grain
  var LOG_LINES = 20;
  var HISTORY_LINES = 2000;
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
  // write held more than one row, since a one-row write's line is always 1.
  function words(r, oneRow) { return r.status === 2 ? r.text : r.text + (r.line && !oneRow ? ' (line ' + r.line + ')' : '') + ' [' + r.id + ']'; }
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
  // budget is measured by), drive ('manual' when the caller calls tick itself).
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
    var b = this.m.put(bytes), n = this.m.text(name || ''), r;
    try { r = this.m.call('alonzo_load', [b.ptr, b.len, n.ptr, n.len]); } finally { this.m.release(b); this.m.release(n); }
    if (r.status !== 0) return this._fail('The cartridge was refused: ' + words(r) + '.');
    var f = first(r.text, 'cartridge');
    if (!f) return this._fail('The module answered the load with ' + r.text.trim() + ', not a cartridge row.');
    this.handle = num(f[1]);
    var c = this.cart = { title: str(f[2]), mode: sym(f[3]), w: num(f[4]), h: num(f[5]), rate: num(f[6]), seed: '', devices: {}, budget: null };
    this._describe();
    this.window = rangeOf(1, 1, c.h, c.w);
    this._say('Loaded ' + c.title + ': a ' + c.w + ' by ' + c.h + ' ' + c.mode + ' at ' + (c.rate ? c.rate + ' frames a second' : 'rate 0, a step on every edit') + ', seed ' + c.seed + ', on ' + this.version + '.');
    if (c.budget) {
      var bd = c.budget, over = bd.perSecond > bd.line;
      this._say(c.rate ? 'The budget: ' + thousands(bd.cells) + ' formula cells a frame at ' + c.rate + ' frames a second, ' + thousands(bd.perSecond) + ' a second, ' + (over ? 'over' : 'under') + ' the console\'s line of ' + thousands(bd.line) + (over ? ': it will run slowly, in plain sight.' : '.')
                       : 'The budget: ' + thousands(bd.cells) + ' formula cells a step, one step an edit.');
    }
    if (c.mode !== 'plane') this._say('This slice blits the plane alone; a grid cartridge is drawn by the viewport, which the host takes up after it.');
    if (c.devices.camera) this._readCamera();
    if (c.devices.palette) this._readPalette();
    if (c.devices.keys) this._readKeys();
    this._emit('load', { handle: this.handle, title: c.title, mode: c.mode, w: c.w, h: c.h, rate: c.rate });
    return { ok: true, handle: this.handle, title: c.title, mode: c.mode, w: c.w, h: c.h, rate: c.rate };
  };
  Host.prototype._describe = function () {
    var r = this.m.call('alonzo_describe', [this.handle]);
    if (r.status !== 0) { this._say('The describe was refused: ' + words(r) + '.'); return; }
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
    if (r.status !== 0) this._say('The unload was refused: ' + words(r) + '.');
    this.handle = 0; this.cart = null; this.inFrame = false; this.progress = null;
  };

  // ---- the loop (section 5) ----
  Host.prototype.start = function () {
    if (this.running || !this.handle) return;
    this.running = true; this.lastTs = null;
    if (this.options.drive === 'manual' || !global.requestAnimationFrame) return;
    var self = this;
    var loop = function (ts) {
      if (!self.running) return;
      try { self.tick(ts); } catch (e) { self.stop(); self._say('The loop stopped: ' + (e && e.message ? e.message : e) + '.'); return; }
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
      if (this.inFrame) { win = this._window(); if (this._continue(win)) this._editFrames(win); }
      return;
    }
    if (this.lastTs === null) { this.lastTs = ts; return; }
    var dt = ts - this.lastTs;
    this.lastTs = ts;
    this._sample(dt);
    this.acc = Math.min(this.acc + Math.min(dt, ACCUMULATOR_CAP_MS), ACCUMULATOR_CAP_MS);
    var interval = 1000 / c.rate;
    win = this._window();
    for (;;) {
      if (this.inFrame) { if (!this._continue(win)) return; continue; }
      if (this._spent(win)) return;
      if (this.acc < interval) return;
      this.acc -= interval;
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
      this._say('frame ' + (this.frame + 1) + ': the step was refused: ' + (r.status === 0 ? 'the module answered ' + r.text.trim() : words(r)) + '; the loop stops.');
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
      this._say('frame ' + (this.frame + 1) + ': ' + said + '.');
    }
  };
  Host.prototype._issueInputs = function () {
    if (this.cart.rate > 0) {
      var r = this._write(this._inputRows());
      this.c.inputs++;
      if (r.status !== 0) this._say('frame ' + (this.frame + 1) + ': the Input rows were refused: ' + words(r) + '.');
      this.notches = 0; this.lastKey = null;
    }
    while (this.edits.length) this._issueEdit(this.edits.shift(), false);
  };
  Host.prototype._issueEdit = function (row, atRateZero) {
    var r = this._write(row);
    if (r.status === 0) {
      this.c.edits++;
      if (!atRateZero) this._say('frame ' + (this.frame + 1) + ': the edit ' + row + ' was written.');
      return true;
    }
    this.c.editsRefused++;
    this._say('frame ' + (this.frame + 1) + ': the edit ' + row + ' was refused: ' + words(r, true) + (atRateZero ? '; no step.' : '.'));
    return false;
  };
  // The Input sheet's eighteen rows (section 3.3): ten buttons for four players through the key map,
  // the pointer in Screen cells, its three buttons, the wheel's notches, the last key twice.
  Host.prototype._inputRows = function () {
    var out = [], km = this.keymap, held = this.held, pt = this.pointer, k = this.lastKey;
    for (var b = 0; b < 10; b++) {
      for (var p = 0; p < 4; p++) {
        var code = km ? km[b][p] : '';
        out.push('(cell "Input" "' + PLAYERS[p] + (b + 1) + '" ' + (code && held[code] ? 1 : 0) + ')');
      }
    }
    out.push('(cell "Input" "B11" ' + pt.col + ')', '(cell "Input" "B12" ' + pt.row + ')');
    out.push('(cell "Input" "B13" ' + pt.left + ')', '(cell "Input" "B14" ' + pt.right + ')', '(cell "Input" "B15" ' + pt.middle + ')');
    out.push('(cell "Input" "B16" ' + this.notches + ')');
    out.push('(cell "Input" "B17" ' + quote(k ? k.key : '') + ')', '(cell "Input" "B18" ' + quote(k ? k.code : '') + ')');
    return out.join('\n');
  };

  // ---- the effects (step 5) and the draw (step 6) ----
  Host.prototype._complete = function (n) {
    this.frame = n; this.c.frames++;
    var d = this.cart.devices;
    if (d.camera) this._readCamera();
    if (d.palette) this._readPalette();
    if (this.cart.mode === 'plane') this._drawPlane();
    if (d.keys) this._readKeys();
    if (d.audio) this._readAudio();
    if (d.file) this._readFile();
    if (d.write) this._readWrite();
    if (this.stepEdit) { this._say('frame ' + n + ': stepped once for the edit ' + this.stepEdit + '.'); this.stepEdit = null; }
    this._emit('frame', { frame: n, window: this.window, scale: this.scale || 0 });
  };
  Host.prototype._record = function (sheet) {
    var r = this.m.texts('alonzo_view', [this.handle], ['grid', sheet, '']);
    if (r.status !== 0) { this._sayOnce('view-' + sheet, 'frame ' + this.frame + ': the view of ' + sheet + ' was refused: ' + words(r) + '.'); return null; }
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
    if (r.status !== 0) { this._sayOnce('plane', 'frame ' + this.frame + ': the plane was refused: ' + words(r) + '.'); return; }
    if (r.bytes.length !== c.w * c.h) { this._sayOnce('plane-size', 'frame ' + this.frame + ': the plane holds ' + r.bytes.length + ' bytes, not the window\'s ' + (c.w * c.h) + '.'); return; }
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
        this._sayOnce('write-' + r, 'frame ' + this.frame + ': Write!A' + r + ':C' + r + ' is not a sheet, an address and a value; no write.');
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
    if (head !== 'cell' && head !== 'formula') { this._say('An edit is one cell or formula row, as (cell "Camera" "B1" 7); ' + (t || 'an empty line') + ' is not one.'); return false; }
    if (!this.handle) { this._say('No cartridge is loaded to edit.'); return false; }
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

  // ---- what a page asks of the host ----
  // One complete frame now, whatever the clock: the blit's instrument times it (?blit=1).
  Host.prototype.runFrameSync = function () {
    if (!this.handle || this.inFrame || !this.cart || this.cart.rate === 0) return false;
    this._begin();
    return this._continue({ used: 0, limit: 0x7fffffff, deadline: Infinity });
  };
  // A sheet's record as the module prints it, for a page to show; null and a sentence when refused.
  Host.prototype.viewRecord = function (sheet, win) {
    if (!this.m || !this.handle || this.inFrame) return null;
    var r = this.m.texts('alonzo_view', [this.handle], ['grid', sheet, win || '']);
    if (r.status !== 0) { this._sayOnce('record-' + sheet, 'The view of ' + sheet + ' was refused: ' + words(r) + '.'); return null; }
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
    return this.order.map(function (e) { return { id: e.id, text: entryText(e), key: e.key, count: e.count, first: e.first, last: e.last }; });
  };
  Host.prototype.destroy = function () {
    this.stop();
    if (this.handle) this.unload();
    for (var i = 0; i < this.handlers.length; i++) { var h = this.handlers[i]; h[0].removeEventListener(h[1], h[2], h[3]); }
    this.handlers = []; this.listeners = {};
  };

  // ---- sentences and events ----
  // Every sentence goes into the history; an event goes into the log as well, a new line for a new
  // event and a count for a repeat; a repeat leaves the status line to the last new event.
  Host.prototype._say = function (text, kind) {
    kind = kind || 'event';
    this.history.push({ text: text, kind: kind });
    if (this.history.length > HISTORY_LINES) this.history.shift();
    if (kind !== 'event') { this.status = text; this._emit('status', { text: text, kind: kind, repeat: false }); return; }
    this.said++;
    var m = FRAME_PREFIX.exec(text), key = m ? text.slice(m[0].length) : text, frame = m ? +m[1] : null;
    var e = this.entries.get(key);
    if (e) {
      e.count++; e.last = frame;
      this._emit('status', { text: text, kind: kind, repeat: true, entry: e.id });
      return;
    }
    e = { id: ++this.entryId, key: key, count: 1, first: frame, last: frame };
    this.entries.set(key, e); this.order.push(e);
    if (this.order.length > LOG_LINES) this.entries.delete(this.order.shift().key);
    this.status = text;
    this._emit('status', { text: text, kind: kind, repeat: false, entry: e.id });
  };
  Host.prototype._sayOnce = function (key, text) { if (this.said1[key] === text) return; this.said1[key] = text; this._say(text); };
  Host.prototype._fail = function (text) { this._say(text); return { ok: false, sentence: text }; };
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
  Host.version = 1;

  global.AlonzoHost = Host;
})(typeof window !== 'undefined' ? window : this);

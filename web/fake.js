/*
  SPDX-FileCopyrightText: 2026 Spreadsheet Company
  SPDX-License-Identifier: Apache-2.0

  web/fake.js - the fake module: a double of the engine's eleven exports
  (SPEC.md section 4.6), the permanent test double of the host shim
  (ENGINE.1, decision 1 of its scoping in REARVIEW.md). The shim must behave
  the same against this file and, later, against the engine's own module, so
  the double answers the JavaScript side of the contract to the byte: the
  memory pair over a real WebAssembly.Memory, the record of four
  little-endian u32 (the status, a line, the id's length, the text's length)
  then the id and the text, status 0, 1 and 2, and the refusals by their
  catalogue ids (SPEC.md section 4.7).

  What it is not is an engine. It reads a cartridge's manifest, which is the
  engine's own duty (what alonzo_load adds to vla_load), and never a row
  after it; and it evaluates nothing, since the loader and the evaluator are
  the language's (AD-1). Its grid is hard-coded and declared in
  AlonzoFake.RULES, so that an oracle can compute what it answers without
  asking it: the Screen's cells inside the declared size are formula cells
  whose bytes follow the frame number (eight-by-eight tiles cycling through
  the sixteen colours, one row swept by a byte past the palette, one error
  byte); the device sheets sit at their section 3 layouts as value cells,
  the Palette the CGA's sixteen and the Keys TIC-80's defaults for player 1;
  the Write sheet carries rows on a rule of the frame, one that lands and
  three that are refused; and a State sheet holds a value cell the derived
  writes land in and a history cell that folds every frame's State!B1 and
  Input sheet into one number, so that the end state's digest witnesses the
  order of every write the host made.

  What it exercises in the host, on purpose: its memory grows by zero pages
  on a schedule, at every load and every seventeenth allocation, which
  detaches every earlier view of the buffer (MDN, Memory.grow), so a host
  that keeps a view fails here first; its allocator counts live allocations
  and checks every free against the pointer and the length it handed out;
  its step yields on a budget over a declared cost of width times height
  cells; its write refuses a twin, a host-written cell and, for a derived
  row, a formula cell; and a write while a frame is in progress is refused.

  Plain script, no module syntax, no library, nothing fetched: one global,
  AlonzoFake, set by this closure. AlonzoFake.create(options) answers
  { exports, stats, digest, peek, frame }; the exports are what a page
  hands the host in place of an instance's.
*/
(function (global) {
  'use strict';

  var PAGE = 65536;
  var BASE = 16;                         // the first address handed out; 0 is never a pointer
  var MAX_ROW = 1048576, MAX_COL = 16384;
  var MAX_CELLS = 1048576;               // the cells one grid holds beside its twins, the language's CELLS
  var enc = new TextEncoder();
  var strict = new TextDecoder('utf-8', { fatal: true });

  // ---- the declared grid ----
  var SHEETS = ['Screen', 'Palette', 'Input', 'Keys', 'Clock', 'Audio', 'File', 'Camera', 'Write', 'State'];
  var PALETTE = [
    ['#000000', 'black'], ['#0000AA', 'blue'], ['#00AA00', 'green'], ['#00AAAA', 'cyan'],
    ['#AA0000', 'red'], ['#AA00AA', 'magenta'], ['#AA5500', 'brown'], ['#AAAAAA', 'light grey'],
    ['#555555', 'dark grey'], ['#5555FF', 'light blue'], ['#55FF55', 'light green'], ['#55FFFF', 'light cyan'],
    ['#FF5555', 'light red'], ['#FF55FF', 'light magenta'], ['#FFFF55', 'yellow'], ['#FFFFFF', 'white']
  ];
  var BUTTONS = ['up', 'down', 'left', 'right', 'a', 'b', 'x', 'y', 'start', 'select'];
  var KEYS = ['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'KeyZ', 'KeyX', 'KeyA', 'KeyS', 'Enter', 'Space'];
  var POINTER = ['mouse-x', 'mouse-y', 'mouse-left', 'mouse-right', 'mouse-middle', 'mouse-wheel', 'key', 'code'];
  // Rectangles as [top, left, bottom, right], rows and columns from 1.
  var LAYOUT = {
    palette: [[1, 1, 16, 3]], input: [[1, 1, 10, 5], [11, 1, 18, 2]], keys: [[1, 1, 10, 5]], clock: [[1, 1, 3, 2]],
    audio: [[1, 1, 5, 4]], file: [[1, 1, 3, 2]], camera: [[1, 1, 2, 2]], write: [[1, 1, MAX_ROW, 3]]
  };
  // The cells the host writes: a formula there is refused (cart-device-cell-formula).
  var HOST_CELLS = { input: [[1, 2, 10, 5], [11, 2, 18, 2]], clock: [[1, 2, 3, 2]], file: [[1, 2, 2, 2]] };
  // Where a derived write is refused as a cell the host writes (SPEC.md section 3.9).
  var DERIVED_BLOCKED = { input: [[1, 1, 18, 5]], clock: [[1, 1, 3, 2]], file: [[1, 1, 2, 2]] };
  var DEVICES = [
    ['Screen', 'effect'], ['Palette', 'effect'], ['Input', 'input'], ['Keys', 'effect'], ['Clock', 'input'],
    ['Audio', 'effect'], ['File', 'effect'], ['Camera', 'effect'], ['Write', 'effect']
  ];
  var SCREEN_FORMULA = '=FAKE.PLANE()';
  var HISTORY_FORMULA = '=FAKE.HISTORY(B1,Input!B1:E18)';

  var RULES = {
    abi: 1,
    version: '0.1.0 (the fake module, web/fake.js)',
    growEvery: 17,       // every seventeenth allocation, and every load, grows the memory by zero pages
    tile: 8,             // the plane's tiles, eight cells a side
    sweepByte: 200,      // the byte swept down the rows, one a frame: past the palette, so painted magenta
    errorByte: 255,      // the byte of a cell that holds no colour: A1 holds one always
    saveEvery: 25,       // File!B3 is 1 on every twenty-fifth frame, 0 otherwise
    sheets: SHEETS,
    palette: PALETTE,
    buttons: BUTTONS,
    keys: KEYS,
    pointer: POINTER,
    // The Screen's byte at (row r, column c) after frame n, inside the declared size, h rows high.
    byteAt: function (n, r, c, h) {
      if (n <= 0) return 0;
      if (r === 1 && c === 1) return 255;
      if (r === ((n - 1) % h) + 1) return 200;
      return (Math.floor((r - 1) / 8) + Math.floor((c - 1) / 8) + n) % 16;
    },
    // The Write sheet's rows 2 to 5 after frame n, each [sheet, address, value] or null for no write:
    // one that lands (a value cell of State) and three refused (a formula cell, a cell the host
    // writes, a twin), on frames divisible by 7, 11 and 13.
    writeRows: function (n) {
      return [
        ['State', 'B1', n],
        n % 7 === 0 ? ['Screen', 'A1', 1] : null,
        n % 11 === 0 ? ['Input', 'B5', 1] : null,
        n % 13 === 0 ? ['Screen.last', 'B1', 1] : null
      ];
    },
    // State!B2 after frame n: the history of State!B1 and the Input sheet, Park and Miller's step.
    history: function (prev, b1, inputs, n) {
      var m = 2147483647, x = (prev * 16807 + b1 + inputs + n) % m;
      return x < 0 ? x + m : x;
    }
  };

  // ---- addresses ----
  function colIndex(s) { var c = 0; s = s.toUpperCase(); for (var i = 0; i < s.length; i++) c = c * 26 + (s.charCodeAt(i) - 64); return c; }
  function colName(c) { var s = ''; while (c > 0) { var r = (c - 1) % 26; s = String.fromCharCode(65 + r) + s; c = (c - 1 - r) / 26; } return s; }
  function parseRange(t) {
    var m = /^\$?([A-Za-z]{1,3})\$?(\d{1,7})(?::\$?([A-Za-z]{1,3})\$?(\d{1,7}))?$/.exec(t);
    if (!m) return null;
    var r1 = +m[2], c1 = colIndex(m[1]), r2 = m[3] ? +m[4] : r1, c2 = m[3] ? colIndex(m[3]) : c1;
    var R = { top: Math.min(r1, r2), left: Math.min(c1, c2), bottom: Math.max(r1, r2), right: Math.max(c1, c2) };
    if (R.top < 1 || R.left < 1 || R.bottom > MAX_ROW || R.right > MAX_COL) return null;
    return R;
  }
  function rangeText(R) {
    var a = colName(R.left) + R.top;
    return (R.top === R.bottom && R.left === R.right) ? a : a + ':' + colName(R.right) + R.bottom;
  }
  function addrOf(r, c) { return colName(c) + r; }
  function rcOf(addr) { var m = /^([A-Z]+)(\d+)$/.exec(addr); return m ? { r: +m[2], c: colIndex(m[1]) } : null; }
  function anyCell(R, fn) {   // true when fn holds for some cell of R
    for (var r = R.top; r <= R.bottom; r++) for (var c = R.left; c <= R.right; c++) if (fn(r, c)) return true;
    return false;
  }
  function area(R) { return (R.bottom - R.top + 1) * (R.right - R.left + 1); }
  // A range inside a layout of row bands sorted from the top, as engine/src/cartridge.rs's within.
  function within(R, bands) {
    var row = R.top;
    for (;;) {
      var b = null;
      for (var i = 0; i < bands.length; i++) if (bands[i][0] <= row && row <= bands[i][2]) { b = bands[i]; break; }
      if (!b || R.left < b[1] || R.right > b[3]) return false;
      if (R.bottom <= b[2]) return true;
      row = b[2] + 1;
    }
  }
  function meets(R, rects) {
    if (!rects) return false;
    for (var i = 0; i < rects.length; i++) { var q = rects[i]; if (R.top <= q[2] && q[0] <= R.bottom && R.left <= q[3] && q[1] <= R.right) return true; }
    return false;
  }

  // ---- values, as the record spells them ----
  function quote(s) { return '"' + String(s).replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"'; }
  function unquote(s) { return s.replace(/\\(.)/g, '$1'); }
  function spell(v) { return typeof v === 'string' ? quote(v) : (typeof v === 'boolean' ? (v ? 'true' : 'false') : String(v)); }
  function parseValue(t) {
    t = t.trim();
    var m = /^"((?:[^"\\]|\\.)*)"$/.exec(t);
    if (m) return { ok: true, v: unquote(m[1]) };
    if (t === 'true') return { ok: true, v: true };
    if (t === 'false') return { ok: true, v: false };
    if (/^-?(\d+\.?\d*|\.\d+)([eE][-+]?\d+)?$/.test(t)) return { ok: true, v: Number(t) };
    return { ok: false };
  }
  // A cell's byte in the plane (SPEC.md section 3.1): an absent cell, and a formula before its
  // first value, is 0, wherever it stands, as the record says by printing no value row for it.
  function byteOf(e) {
    if (!e || e.v === undefined) return 0;   // nothing here, or a formula with no value
    var v = e.v;
    return (typeof v === 'number' && v >= 0 && v <= 254 && Math.floor(v) === v) ? v : 255;
  }
  function numberOf(v) { return typeof v === 'number' && isFinite(v) ? v : 0; }
  function thousands(n) { return String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }
  function fnv(s) {
    var h = 0x811c9dc5;
    for (var i = 0; i < s.length; i++) { h ^= s.charCodeAt(i); h = Math.imul(h, 16777619) >>> 0; }
    return ('0000000' + h.toString(16)).slice(-8);
  }

  // ---- the manifest: the five directives the engine reads, each by one regular expression ----
  function readManifest(text) {
    var i = 0, n = text.length;
    for (;;) {   // the comments and the space before the form
      while (i < n && /\s/.test(text.charAt(i))) i++;
      if (text.charAt(i) !== ';') break;
      while (i < n && text.charAt(i) !== '\n') i++;
    }
    var bad = function (what) { return { refusal: { id: 'cart-manifest-invalid', text: 'the manifest ' + what + '; every directive is given (SPEC.md section 7.2)' } }; };
    if (text.substr(i, 10) !== '(cartridge') return bad('is not the first form: a cartridge begins with (cartridge "name" ...)');
    var bare = '', depth = 0, inStr = false, closed = false;
    for (; i < n; i++) {   // the form's text without its comments, to its closing parenthesis
      var ch = text.charAt(i);
      if (inStr) { bare += ch; if (ch === '\\' && i + 1 < n) bare += text.charAt(++i); else if (ch === '"') inStr = false; continue; }
      if (ch === ';') { while (i + 1 < n && text.charAt(i + 1) !== '\n') i++; continue; }
      bare += ch;
      if (ch === '"') inStr = true;
      else if (ch === '(') depth++;
      else if (ch === ')') { depth--; if (depth === 0) { closed = true; break; } }
    }
    if (!closed) return bad('is not closed');
    var m, out = {};
    m = /\(spec\s+([^\s()]+)\s*\)/.exec(bare);
    if (!m) return bad('has no (spec ...) directive');
    if (m[1] !== '1' && m[1] !== '2') return { refusal: { id: 'cart-spec-unsupported', text: 'the cartridge is written to (spec ' + m[1] + '); this engine reads 1 and 2' } };
    out.spec = +m[1];
    m = /\(title\s+"((?:[^"\\]|\\.)*)"\s*\)/.exec(bare);
    if (!m) return bad('has no (title "...") directive');
    out.title = unquote(m[1]);
    m = /\(rate\s+([^\s()]+)\s*\)/.exec(bare);
    if (!m) return bad('has no (rate ...) directive');
    if (!/^\d+$/.test(m[1]) || +m[1] > 120) return bad('has (rate ' + m[1] + '); a rate is a whole number from 0 to 120');
    out.rate = +m[1];
    m = /\(screen\s+([^\s()]+)\s+([^\s()]+)\s+([^\s()]+)\s*\)/.exec(bare);
    if (!m) return bad('has no (screen plane|grid width height) directive');
    var mode = m[1], w = m[2], h = m[3], lim = mode === 'plane' ? [320, 200] : [80, 50];
    if (mode !== 'plane' && mode !== 'grid') return bad('has (screen ' + mode + ' ...); the mode is plane or grid');
    if (!/^\d+$/.test(w) || !/^\d+$/.test(h) || +w < 1 || +h < 1 || +w > lim[0] || +h > lim[1]) return bad('has (screen ' + mode + ' ' + w + ' ' + h + '); a ' + mode + ' screen is at most ' + lim[0] + ' by ' + lim[1]);
    out.mode = mode; out.w = +w; out.h = +h;
    m = /\(seed\s+([^\s()]+)\s*\)/.exec(bare);
    if (!m) return bad('has no (seed ...) directive');
    if (m[1] === 'host') out.seed = 'host';
    else if (/^\d+$/.test(m[1]) && +m[1] >= 1 && +m[1] <= 2147483646) out.seed = +m[1];
    else return bad('has (seed ' + m[1] + '); a seed is a whole number from 1 to 2147483646, or host');
    return out;
  }

  // ---- one loaded cartridge: the grid the double answers from ----
  function Cart(handle, name, size, m) {
    this.handle = handle; this.name = name; this.size = size;
    this.spec = m.spec; this.title = m.title; this.rate = m.rate; this.mode = m.mode; this.w = m.w; this.h = m.h; this.seed = m.seed;
    this.frame = 0;          // the last complete frame
    this.progress = null;    // { evaluated, of } while a frame is in progress
    this.cells = {};         // sheet key -> Map(address -> { v } or { f, v }); the Screen's map holds what overrides its formulas
    for (var i = 0; i < SHEETS.length; i++) this.cells[SHEETS[i].toLowerCase()] = new Map();
    var self = this;
    function put(key, r, c, v) { self.cells[key].set(addrOf(r, c), { v: v }); }
    for (var p = 0; p < 16; p++) { put('palette', p + 1, 1, p); put('palette', p + 1, 2, PALETTE[p][0]); put('palette', p + 1, 3, PALETTE[p][1]); }
    for (var b = 0; b < 10; b++) {
      put('input', b + 1, 1, BUTTONS[b]);
      for (var q = 2; q <= 5; q++) put('input', b + 1, q, 0);
      put('keys', b + 1, 1, BUTTONS[b]); put('keys', b + 1, 2, KEYS[b]);
    }
    for (var k = 0; k < POINTER.length; k++) { put('input', 11 + k, 1, POINTER[k]); put('input', 11 + k, 2, k < 6 ? 0 : ''); }
    put('clock', 1, 1, 'frame'); put('clock', 1, 2, 0);
    put('clock', 2, 1, 'rate'); put('clock', 2, 2, m.rate);
    put('clock', 3, 1, 'seed'); put('clock', 3, 2, m.seed === 'host' ? 1 : m.seed);
    ['voice', 'wave', 'note', 'volume'].forEach(function (t, j) { put('audio', 1, j + 1, t); });
    for (var v = 1; v <= 4; v++) { put('audio', v + 1, 1, v); put('audio', v + 1, 2, 'square'); put('audio', v + 1, 3, 69); put('audio', v + 1, 4, 0); }
    put('file', 1, 1, 'name'); put('file', 1, 2, name);
    put('file', 2, 1, 'size'); put('file', 2, 2, size);
    put('file', 3, 1, 'save'); put('file', 3, 2, 0);
    put('camera', 1, 1, 'row'); put('camera', 1, 2, 1);
    put('camera', 2, 1, 'column'); put('camera', 2, 2, 1);
    put('write', 1, 1, 'sheet'); put('write', 1, 2, 'address'); put('write', 1, 3, 'value');
    put('state', 1, 1, 'derived'); put('state', 1, 2, 0);
    put('state', 2, 1, 'history'); this.cells.state.set('B2', { f: HISTORY_FORMULA });
    this.snapshot();
  }
  // The content of a cell: { v } a value, { f, v } a formula with its value, or null.
  Cart.prototype.content = function (key, r, c, twin) {
    var map = twin ? this.twins[key] : this.cells[key];
    var e = map.get(addrOf(r, c));
    if (key === 'screen' && r <= this.h && c <= this.w && (!e || e.f)) {
      var n = twin ? this.twinFrame : this.frame;
      return { f: e ? e.f : SCREEN_FORMULA, v: n > 0 ? RULES.byteAt(n, r, c, this.h) : undefined };
    }
    return e || null;
  };
  // The twins: every sheet's cells as they were when the last step finished (SPEC.md section 2).
  Cart.prototype.snapshot = function () {
    this.twins = {};
    for (var k in this.cells) if (Object.prototype.hasOwnProperty.call(this.cells, k)) this.twins[k] = new Map(this.cells[k]);
    this.twinFrame = this.frame;
  };
  // What a step does when a frame completes: the clock, the history, the Write sheet, the save cell, the twins.
  Cart.prototype.complete = function (n) {
    this.frame = n;
    this.cells.clock.set('B1', { v: n });
    var st = this.cells.state, h = st.get('B2');
    if (h && h.f) {
      var inputs = 0;
      this.cells.input.forEach(function (e, addr) {
        if (addr.charAt(0) === 'A') return;
        if (typeof e.v === 'number') inputs += e.v;
        else if (typeof e.v === 'string') for (var i = 0; i < e.v.length; i++) inputs += e.v.charCodeAt(i);
      });
      var b1 = st.get('B1');
      st.set('B2', { f: h.f, v: RULES.history(numberOf(h.v), numberOf(b1 && b1.v), inputs, n) });
    }
    var wr = this.cells.write, rows = RULES.writeRows(n);
    for (var r = 2; r <= 9; r++) for (var c = 1; c <= 3; c++) wr.delete(addrOf(r, c));
    for (var i = 0; i < rows.length; i++) {
      if (!rows[i]) continue;
      wr.set(addrOf(i + 2, 1), { v: rows[i][0] }); wr.set(addrOf(i + 2, 2), { v: rows[i][1] }); wr.set(addrOf(i + 2, 3), { v: rows[i][2] });
    }
    this.cells.file.set('B3', { v: n % RULES.saveEvery === 0 ? 1 : 0 });
    this.snapshot();
  };
  Cart.prototype.extent = function (key, twin) {
    var map = twin ? this.twins[key] : this.cells[key], R = null;
    var grow = function (r, c) {
      if (!R) R = { top: r, left: c, bottom: r, right: c };
      else { R.top = Math.min(R.top, r); R.left = Math.min(R.left, c); R.bottom = Math.max(R.bottom, r); R.right = Math.max(R.right, c); }
    };
    map.forEach(function (e, addr) { var p = rcOf(addr); if (p) grow(p.r, p.c); });
    if (key === 'screen') { grow(1, 1); grow(this.h, this.w); }
    return R;
  };
  Cart.prototype.digest = function () {
    var parts = ['frame ' + this.frame];
    for (var i = 0; i < SHEETS.length; i++) {
      var key = SHEETS[i].toLowerCase(), list = [];
      this.cells[key].forEach(function (e, addr) { list.push(addr + '=' + (e.f ? e.f + '|' + spell(e.v === undefined ? '' : e.v) : spell(e.v))); });
      list.sort();
      parts.push(SHEETS[i] + ':' + list.join(';'));
    }
    return fnv(parts.join('\n'));
  };

  // ---- the module ----
  function create(options) {
    options = options || {};
    var growEvery = options.growEvery === undefined ? RULES.growEvery : options.growEvery;
    var abi = options.abi === undefined ? RULES.abi : options.abi;
    var memory = new WebAssembly.Memory({ initial: 4 });
    var next = BASE, live = new Map(), carts = {}, nextHandle = 1;
    var st = {
      allocs: 0, frees: 0, misfrees: 0, grows: 0, detaches: 0,
      calls: { abi: 0, version: 0, load: 0, describe: 0, write: 0, step: 0, view: 0, unload: 0 },
      rows: { cell: 0, formula: 0, derived: 0 }, sheetRows: {}, planeViews: 0, windows: [], refusals: {}
    };

    function grow(pages) {
      var before = memory.buffer;
      memory.grow(pages);
      st.grows++;
      if (before.byteLength === 0) st.detaches++;
    }
    function alloc(len) {
      len = len >>> 0;
      st.allocs++;
      var size = Math.max(1, len), need = next + size, have = memory.buffer.byteLength;
      if (need > have) grow(Math.ceil((need - have) / PAGE));
      else if (growEvery > 0 && st.allocs % growEvery === 0) grow(0);
      var p = next;
      next = need + ((8 - (need % 8)) % 8);
      live.set(p, len);
      return p;
    }
    function free(ptr, len) {
      st.frees++;
      if (!live.has(ptr) || live.get(ptr) !== (len >>> 0)) { st.misfrees++; return; }
      live.delete(ptr);
      if (live.size === 0) next = BASE;   // nothing is live: the arena starts again
    }
    function record(status, line, id, body, outLen) {
      var idb = enc.encode(id || ''), textb = typeof body === 'string' ? enc.encode(body) : body;
      var total = 16 + idb.length + textb.length;
      var p = alloc(total);
      var dv = new DataView(memory.buffer, p, total);   // made after the allocation, which may have grown the memory
      dv.setUint32(0, status, true); dv.setUint32(4, line, true); dv.setUint32(8, idb.length, true); dv.setUint32(12, textb.length, true);
      var u8 = new Uint8Array(memory.buffer, p, total);
      u8.set(idb, 16); u8.set(textb, 16 + idb.length);
      if (outLen) new DataView(memory.buffer).setUint32(outLen >>> 0, total, true);
      return p;
    }
    function refuse(id, text, line, outLen) {
      st.refusals[id] = (st.refusals[id] || 0) + 1;
      return record(1, line || 0, id, text, outLen);
    }
    function input(ptr, len, what, outLen) {
      var bytes = new Uint8Array(memory.buffer, ptr >>> 0, len >>> 0).slice();
      try { return { text: strict.decode(bytes) }; } catch (e) { return { rec: record(2, 0, '', what + ' is not UTF-8', outLen) }; }
    }
    function cartOf(handle, outLen) {
      var c = carts[handle >>> 0];
      return c ? { c: c } : { rec: refuse('grid-handle-unknown', 'no cartridge is loaded under the handle ' + (handle >>> 0), 0, outLen) };
    }
    function sheetKey(name) {
      var lower = String(name).toLowerCase(), twin = /\.last$/.test(lower), base = twin ? lower.slice(0, -5) : lower;
      for (var i = 0; i < SHEETS.length; i++) if (SHEETS[i].toLowerCase() === base) return { key: base, twin: twin, name: SHEETS[i] + (twin ? '.last' : '') };
      return null;
    }
    function sheetList() { return SHEETS.join(', '); }

    function alonzo_load(ptr, len, namePtr, nameLen, outLen) {
      st.calls.load++;
      grow(0);   // every load detaches the buffer: the host's views of it must be made fresh
      var inp = input(ptr, len, 'the cartridge', outLen);
      if (inp.rec) return inp.rec;
      var nm = input(namePtr, nameLen, 'the name', outLen);
      if (nm.rec) return nm.rec;
      var m = readManifest(inp.text);
      if (m.refusal) return refuse(m.refusal.id, m.refusal.text, 0, outLen);
      var h = nextHandle++;
      carts[h] = new Cart(h, nm.text || 'the cartridge', len >>> 0, m);
      return record(0, 0, '', '(cartridge ' + h + ' ' + quote(m.title) + ' ' + m.mode + ' ' + m.w + ' ' + m.h + ' ' + m.rate + ')', outLen);
    }
    function alonzo_describe(handle, outLen) {
      st.calls.describe++;
      var x = cartOf(handle, outLen);
      if (x.rec) return x.rec;
      var c = x.c, lines = ['(spec ' + c.spec + ')', '(title ' + quote(c.title) + ')', '(rate ' + c.rate + ')', '(screen ' + c.mode + ' ' + c.w + ' ' + c.h + ')', '(seed ' + c.seed + ')'];
      for (var i = 0; i < DEVICES.length; i++) {
        var key = DEVICES[i][0].toLowerCase(), R = c.extent(key, false);
        if (key !== 'write' && LAYOUT[key]) { var q = LAYOUT[key][LAYOUT[key].length - 1]; R = { top: 1, left: 1, bottom: q[2], right: LAYOUT[key][0][3] }; }
        lines.push('(device ' + quote(DEVICES[i][0]) + ' ' + quote(rangeText(R)) + ' ' + DEVICES[i][1] + ')');
      }
      var cost = c.w * c.h;
      lines.push('(budget ' + c.rate + ' ' + cost + ' ' + (c.rate * cost) + ' 2000000)');
      return record(0, 0, '', lines.join('\n') + '\n', outLen);
    }
    var ROW = /^\((cell|formula|derived) "((?:[^"\\]|\\.)*)" "((?:[^"\\]|\\.)*)" (.+)\)$/;
    function alonzo_write(handle, ptr, len, outLen) {
      st.calls.write++;
      var x = cartOf(handle, outLen);
      if (x.rec) return x.rec;
      var c = x.c;
      var inp = input(ptr, len, 'the rows', outLen);
      if (inp.rec) return inp.rec;
      if (c.progress) return refuse('grid-write-during-step', 'frame ' + (c.frame + 1) + ' is in progress, ' + thousands(c.progress.evaluated) + ' of ' + thousands(c.progress.of) + ' cells; a write waits until the step is done', 0, outLen);
      // In the engine's order (engine/src/cartridge.rs): the engine's own checks over every row
      // first, the device layouts and the cells the host writes, then the language's, the row's
      // shape, the sheet, the twins, the cap and a derived row over a formula; so a write refused
      // by both names the engine's, and a write that refuses a row changes nothing.
      var lines = inp.text.split('\n'), ops = [], language = null;
      function later(id, text, ln) { if (!language) language = { id: id, text: text, ln: ln }; }
      for (var i = 0; i < lines.length; i++) {
        var t = lines[i].trim();
        if (t === '' || t.charAt(0) === ';') continue;
        var m = ROW.exec(t), ln = i + 1;
        if (!m) {
          if (/^\((cell|formula|derived)\b/.test(t)) later('grid-row-malformed', 'the row ' + t + ' is not (kind "sheet" "address" value)', ln);
          else later('grid-row-unknown', 'the row ' + t + ' is not a cell, formula or derived row', ln);
          continue;
        }
        var kind = m[1], name = unquote(m[2]), where = unquote(m[3]), R = parseRange(where), val = parseValue(m[4]);
        if (!R) { later('grid-row-malformed', 'the address "' + where + '" is not a cell or a range', ln); continue; }
        if (!val.ok) { later('grid-row-malformed', 'the value ' + m[4] + ' is not a number, a text, true or false', ln); continue; }
        if (kind === 'formula' && (typeof val.v !== 'string' || val.v.charAt(0) !== '=')) { later('grid-row-malformed', 'a formula row holds a text that begins with =', ln); continue; }
        var sk = sheetKey(name), target = name + '!' + where;
        if (!sk) { later('grid-sheet-unknown', 'the grid holds no sheet ' + name + '; it holds ' + sheetList() + ', and a write makes no sheet', ln); continue; }
        if (sk.twin) {
          later('grid-write-last', kind === 'derived' ? 'a derived write into ' + target + ' was refused: it is a twin: the previous frame is read-only'
                                                       : target + ' is a cell of ' + sk.name + ', the previous frame, which is read-only', ln);
          continue;
        }
        if (LAYOUT[sk.key] && !within(R, LAYOUT[sk.key])) return refuse('cart-device-cell-outside', target + ' is outside the layout of the ' + sk.name + ' sheet (SPEC.md section 3)', ln, outLen);
        if (kind === 'formula' && meets(R, HOST_CELLS[sk.key])) return refuse('cart-device-cell-formula', target + ' is a cell the host writes, which holds values and never formulas', ln, outLen);
        if (kind === 'derived' && meets(R, DERIVED_BLOCKED[sk.key])) return refuse('cart-write-derived', 'a derived write into ' + target + ' was refused: it is a cell the host writes', ln, outLen);
        if (area(R) > MAX_CELLS) { later('grid-too-many-cells', target + ' would bring the grid past the ' + thousands(MAX_CELLS) + ' cells one grid holds', ln); continue; }
        if (kind === 'derived' && anyCell(R, function (r, cc) { var e = c.content(sk.key, r, cc, false); return !!(e && e.f); })) {
          later('grid-write-derived', 'a derived write into ' + target + ' was refused: it is a formula cell: the step computes values and never formulas, and a derived write replaces none', ln);
          continue;
        }
        ops.push({ kind: kind, key: sk.key, R: R, v: val.v });
      }
      if (language) return refuse(language.id, language.text, language.ln, outLen);
      var written = 0;
      for (var j = 0; j < ops.length; j++) {
        var op = ops[j], map = c.cells[op.key];
        st.rows[op.kind]++;
        st.sheetRows[op.key] = (st.sheetRows[op.key] || 0) + 1;
        for (var r = op.R.top; r <= op.R.bottom; r++) {
          for (var cc = op.R.left; cc <= op.R.right; cc++) {
            var before = c.content(op.key, r, cc, false), after = op.kind === 'formula' ? { f: op.v } : { v: op.v };
            var same = before && (op.kind === 'formula' ? before.f === op.v : (!before.f && before.v === op.v));
            if (!same) written++;
            map.set(addrOf(r, cc), after);
          }
        }
      }
      return record(0, 0, '', '(written ' + written + ')', outLen);
    }
    function alonzo_step(handle, budget, outLen) {
      st.calls.step++;
      var x = cartOf(handle, outLen);
      if (x.rec) return x.rec;
      var c = x.c, n = c.frame + 1;
      if (!c.progress) { c.progress = { evaluated: 0, of: c.w * c.h }; c.cells.clock.set('B1', { v: n }); }
      var rest = c.progress.of - c.progress.evaluated;
      budget = budget >>> 0;
      c.progress.evaluated += budget === 0 ? rest : Math.min(budget, rest);
      var p = c.progress;
      if (p.evaluated < p.of) return record(0, 0, '', '(step ' + n + ' ' + p.evaluated + ' ' + p.of + ' yielded)', outLen);
      c.progress = null;
      c.complete(n);
      return record(0, 0, '', '(step ' + n + ' ' + p.evaluated + ' ' + p.of + ' done)', outLen);
    }
    function alonzo_view(handle, projPtr, projLen, sheetPtr, sheetLen, winPtr, winLen, outLen) {
      st.calls.view++;
      var x = cartOf(handle, outLen);
      if (x.rec) return x.rec;
      var c = x.c;
      var pj = input(projPtr, projLen, 'the projection', outLen); if (pj.rec) return pj.rec;
      var sh = input(sheetPtr, sheetLen, 'the sheet', outLen); if (sh.rec) return sh.rec;
      var wn = input(winPtr, winLen, 'the window', outLen); if (wn.rec) return wn.rec;
      if (pj.text !== 'plane' && pj.text !== 'grid') return refuse('view-projection-unknown', 'the projection ' + pj.text + '; this version has plane and grid', 0, outLen);
      var sk = sheetKey(sh.text);
      if (!sk) return refuse('view-sheet-unknown', 'the grid holds no sheet ' + sh.text + '; it holds ' + sheetList(), 0, outLen);
      var R = wn.text === '' ? (c.extent(sk.key, sk.twin) || parseRange('A1')) : parseRange(wn.text);
      if (!R) return refuse('view-window-not-a-range', 'the window "' + wn.text + '" is not a range such as A1:F20', 0, outLen);
      return pj.text === 'plane' ? plane(c, sk, R, outLen) : grid(c, sk, R, outLen);
    }
    function plane(c, sk, R, outLen) {
      st.planeViews++;
      if (st.windows.length < 4000) st.windows.push(rangeText(R));
      var w = R.right - R.left + 1, out = new Uint8Array(w * (R.bottom - R.top + 1)), i = 0;
      var map = sk.twin ? c.twins[sk.key] : c.cells[sk.key];
      if (sk.key === 'screen') {
        var n = sk.twin ? c.twinFrame : c.frame, H = c.h, W = c.w, colTile = new Int32Array(w);
        for (var k = 0; k < w; k++) colTile[k] = Math.floor((R.left + k - 1) / 8);
        for (var r = R.top; r <= R.bottom; r++) {
          var rowTile = Math.floor((r - 1) / 8), sweep = n > 0 && r === ((n - 1) % H) + 1;
          for (var k2 = 0; k2 < w; k2++, i++) {
            var col = R.left + k2;
            if (r > H || col > W || n <= 0) out[i] = 0;
            else out[i] = (r === 1 && col === 1) ? 255 : (sweep ? 200 : ((rowTile + colTile[k2] + n) % 16));
          }
        }
        map.forEach(function (e, addr) {
          var p = rcOf(addr);
          if (!p || p.r < R.top || p.r > R.bottom || p.c < R.left || p.c > R.right) return;
          var inside = p.r <= H && p.c <= W;
          if (e.f && inside) return;   // a formula cell of the Screen follows the pattern, whatever its text
          out[(p.r - R.top) * w + (p.c - R.left)] = byteOf(e);
        });
      } else {
        map.forEach(function (e, addr) {
          var p = rcOf(addr);
          if (!p || p.r < R.top || p.r > R.bottom || p.c < R.left || p.c > R.right) return;
          out[(p.r - R.top) * w + (p.c - R.left)] = byteOf(e);
        });
      }
      return record(0, 0, '', out, outLen);
    }
    function grid(c, sk, R, outLen) {
      var lines = [];
      for (var i = 0; i < SHEETS.length; i++) lines.push('(sheet ' + quote(SHEETS[i]) + ' visible)');
      for (var j = 0; j < SHEETS.length; j++) lines.push('(sheet ' + quote(SHEETS[j] + '.last') + ' hidden)');
      var E = c.extent(sk.key, sk.twin), name = quote(sk.name);
      lines.push('(window ' + name + ' ' + quote(rangeText(R)) + ')');
      lines.push('(extent ' + name + ' ' + (E ? quote(rangeText(E)) : 'none') + ')');
      lines.push('(gridlines ' + name + ' on)');
      lines.push('(format 0 none general nowrap)');
      var map = sk.twin ? c.twins[sk.key] : c.cells[sk.key], addrs = [];
      map.forEach(function (e, addr) { var p = rcOf(addr); if (p && p.r >= R.top && p.r <= R.bottom && p.c >= R.left && p.c <= R.right) addrs.push(p); });
      if (sk.key === 'screen') {   // the formula cells inside the declared size, each with its value
        for (var r = R.top; r <= Math.min(R.bottom, c.h); r++) for (var cc = R.left; cc <= Math.min(R.right, c.w); cc++) if (!map.has(addrOf(r, cc))) addrs.push({ r: r, c: cc });
      }
      addrs.sort(function (a, b) { return a.r - b.r || a.c - b.c; });
      for (var k = 0; k < addrs.length; k++) {
        var at = addrOf(addrs[k].r, addrs[k].c), e = c.content(sk.key, addrs[k].r, addrs[k].c, sk.twin);
        if (!e) continue;
        if (e.f) {
          lines.push('(formula ' + name + ' ' + quote(at) + ' ' + quote(e.f) + ')');
          if (e.v !== undefined) lines.push('(value ' + name + ' ' + quote(at) + ' ' + spell(e.v) + ')');
        } else {
          lines.push('(cell ' + name + ' ' + quote(at) + ' ' + spell(e.v) + ')');
        }
      }
      return record(0, 0, '', lines.join('\n') + '\n', outLen);
    }
    function alonzo_unload(handle, outLen) {
      st.calls.unload++;
      var x = cartOf(handle, outLen);
      if (x.rec) return x.rec;
      delete carts[handle >>> 0];
      return record(0, 0, '', '(unloaded ' + (handle >>> 0) + ')', outLen);
    }

    var exports = {
      memory: memory,
      alonzo_abi_version: function () { st.calls.abi++; return abi; },
      alonzo_version_text: function (outLen) { st.calls.version++; return record(0, 0, '', RULES.version, outLen); },
      alonzo_alloc: alloc,
      alonzo_free: free,
      alonzo_load: alonzo_load,
      alonzo_describe: alonzo_describe,
      alonzo_write: alonzo_write,
      alonzo_step: alonzo_step,
      alonzo_view: alonzo_view,
      alonzo_unload: alonzo_unload
    };
    (options.omit || []).forEach(function (k) { delete exports[k]; });

    return {
      exports: exports,
      // What the double has seen: the allocations, the growths and detachments, the calls, the rows by kind
      // and by sheet, the plane views and their windows, the refusals by id. A copy.
      stats: function () {
        var out = JSON.parse(JSON.stringify(st));
        out.live = live.size;
        return out;
      },
      // The grid's state as one hash: the frame and every cell of every sheet, the twins excluded.
      digest: function (handle) { var c = carts[handle >>> 0]; return c ? c.digest() : '00000000'; },
      // One cell as the double holds it: { v } or { f, v }, or null; for the oracle, never the host.
      peek: function (handle, sheet, addr) {
        var c = carts[handle >>> 0], sk = sheetKey(sheet), p = rcOf(String(addr).toUpperCase());
        return (c && sk && p) ? c.content(sk.key, p.r, p.c, sk.twin) : null;
      },
      frame: function (handle) { var c = carts[handle >>> 0]; return c ? c.frame : -1; }
    };
  }

  global.AlonzoFake = { create: create, RULES: RULES, version: 1 };
})(typeof window !== 'undefined' ? window : this);

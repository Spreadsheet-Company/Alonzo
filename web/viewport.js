/*
  SPDX-FileCopyrightText: 2026 Spreadsheet Company
  SPDX-License-Identifier: Apache-2.0

  web/viewport.js - the viewport: the Screen device in grid mode (SPEC.md,
  section 3.1), KERNEL.5 laid here. One window of a sheet drawn on a canvas
  from the view record alone, the lines `frazaro view` prints (the treaty's
  oracle 11): every sheet as a tab, the window's columns at the widths the
  record declares, the fills and number formats of its formats, each cell's
  text where the record puts it, and the gridlines when the record says so.
  The viewport computes nothing: a cell row shows its value as the reader
  spells it, a formula row shows its text until the value row lands
  (KERNEL.7), and an unknown row is counted, never refused.

  What the viewport owns is the state no program sees (SD-23): the scroll, the
  selection, the widths a person dragged, the frozen panes, the marks a host
  asked for; the record is never written. What it does not do: no fill
  handle, no drag-move, no in-cell editing (web/CALLOSUM.md section 7,
  decision 5); the formula bar, the link to a sentence, the refusal in the
  row, the modes and the pane are the first game's chrome, which consumes
  this file and gets the events and the marks it needs.

  Plain script, no module syntax, no library, nothing fetched: one global,
  AlonzoViewport, set by this closure, so that the file inlines into a page
  (tools/build_web.ps1) or loads as a file in a page of one's own. The API
  and its events are documented in web/README.md.

  The layout is in device pixels: every size an integer of them, every
  gridline at an integer plus a half, every text at an integer position, so
  the image is crisp at the machine's pixel ratio (SPEC.md section 1); the
  backing store is the CSS size times the ratio and is remade when the ratio
  changes. The painter keeps a draw list of what it drew and where, which the
  page's oracle (web/index.template.html, ?oracle=1) holds equal to what the
  record says, cell for cell.

  The structure, top to bottom: the rules of the record (the constants), the
  reader of the record, the geometry (the layout), the painter, the
  interactions, the API. A rasterizer that one day replaces the painter takes
  the geometry's rectangles and nothing else.
*/
(function (global) {
  'use strict';

  // ---- the rules of the record, as decision 8 of the scoping states them ----
  // Pixels are CSS pixels here; the geometry scales them to device pixels.
  var DEFAULT_COLUMN_PX = 64;    // Excel's default column, 8.43 characters of Calibri 11 at 96 DPI
  var DEFAULT_ROW_PX = 20;       // Excel's default row, 15 points
  var FONT_PX = 13;              // the benchmark's text size
  var FONT_FAMILY = 'system-ui, "Segoe UI", sans-serif';
  var TEXT_PAD_PX = 4;           // the padding inside a cell, left and right
  var MAX_DIGIT_WIDTH = 7;       // Calibri 11 at 96 DPI: ECMA-376 Part 1, section 18.3.1.13
  var ROW_HEADER_MIN_PX = 32;    // the row header's least width
  var ROW_HEADER_PAD_PX = 12;    // the row header's width is this plus a digit's width per digit
  var ROW_HEADER_DIGIT_PX = 7;
  var RESIZE_GRIP_PX = 4;        // how near a column boundary a press must be to resize it
  var LINE_HEIGHT = 1.2;         // a wrapped line's height, in font sizes
  var OVERFLOW_LOOKBACK = 8;     // columns to look back for a text that overflows into view
  var DEFAULT_COLORS = {
    background: '#ffffff',
    gridline: '#d9d9d2',
    header: '#f3f3ee',
    headerText: '#6b6b66',
    headerSelected: '#e2d8f6',
    text: '#1d1d1b',
    formula: '#0a6b4f',
    selectionFill: 'rgba(226, 216, 246, 0.45)',
    selectionBorder: '#6b4fc8',
    frozenLine: '#b9b9b0',
    tabBackground: '#f3f3ee',
    tabActive: '#ffffff'
  };
  var RULES = {
    column: DEFAULT_COLUMN_PX, row: DEFAULT_ROW_PX, font: FONT_PX, pad: TEXT_PAD_PX, digit: MAX_DIGIT_WIDTH,
    headerMin: ROW_HEADER_MIN_PX, headerPad: ROW_HEADER_PAD_PX, headerDigit: ROW_HEADER_DIGIT_PX, lineHeight: LINE_HEIGHT
  };

  // A column's width in CSS pixels from the record's width, the file's stored
  // width in characters with the padding folded in (ECMA-376, 18.3.1.13).
  function columnPixels(width) {
    return Math.floor(((256 * width + Math.floor(128 / MAX_DIGIT_WIDTH)) / 256) * MAX_DIGIT_WIDTH);
  }

  function now() { return (global.performance && global.performance.now) ? global.performance.now() : Date.now(); }

  // ---- (1) the reader: the record's forms, one a line, into a model ----
  // A datum is a list (an array), a string (\" and \\ read), a number
  // ({ num, text }, the text as printed) or a symbol ({ sym }).
  function Reader(text) { this.s = text; this.i = 0; this.n = text.length; }
  Reader.prototype.skipSpace = function () {
    var s = this.s;
    while (this.i < this.n) {
      var c = s.charCodeAt(this.i);
      if (c === 32 || c === 9 || c === 10 || c === 13) { this.i++; }
      else if (c === 59) { while (this.i < this.n && s.charCodeAt(this.i) !== 10) this.i++; }
      else break;
    }
  };
  Reader.prototype.readForm = function () {
    this.skipSpace();
    if (this.i >= this.n) return null;
    var s = this.s, c = s.charAt(this.i);
    if (c === '(') {
      this.i++;
      var list = [];
      for (;;) {
        this.skipSpace();
        if (this.i >= this.n) return list;
        if (s.charAt(this.i) === ')') { this.i++; return list; }
        list.push(this.readForm());
      }
    }
    if (c === ')') { this.i++; return this.readForm(); }
    if (c === '"') {
      this.i++;
      var out = '', start = this.i;
      while (this.i < this.n) {
        var ch = s.charAt(this.i);
        if (ch === '\\') {
          out += s.slice(start, this.i);
          this.i++;
          if (this.i < this.n) { out += s.charAt(this.i); this.i++; }
          start = this.i;
          continue;
        }
        if (ch === '"') { out += s.slice(start, this.i); this.i++; return out; }
        this.i++;
      }
      return out + s.slice(start);
    }
    var j = this.i;
    while (j < this.n) {
      var cc = s.charCodeAt(j);
      if (cc === 32 || cc === 9 || cc === 10 || cc === 13 || cc === 40 || cc === 41 || cc === 34) break;
      j++;
    }
    var tok = s.slice(this.i, j);
    this.i = j;
    if (/^-?(\d+\.?\d*|\.\d+)([eE][-+]?\d+)?$/.test(tok)) return { num: Number(tok), text: tok };
    return { sym: tok };
  };
  // What a cell shows and what kind of value it is: a string itself (text), a
  // number as printed, true and false as TRUE and FALSE (bool), an
  // (error "#NUM!") or a (date "2026-10-03") as the text inside.
  function valueOf(d) {
    if (typeof d === 'string') return { kind: 'text', text: d };
    if (d === null || d === undefined) return { kind: 'text', text: '' };
    if (Array.isArray(d)) {
      if (d.length === 2 && d[0] && d[0].sym !== undefined && typeof d[1] === 'string') {
        if (d[0].sym === 'error') return { kind: 'error', text: d[1] };
        if (d[0].sym === 'date') return { kind: 'date', text: d[1] };
        return { kind: 'text', text: d[1] };
      }
      return { kind: 'text', text: d.map(function (x) { return valueOf(x).text; }).join(' ') };
    }
    if (d.text !== undefined) return { kind: 'number', text: d.text };
    if (d.sym !== undefined) {
      if (d.sym === 'true') return { kind: 'bool', text: 'TRUE' };
      if (d.sym === 'false') return { kind: 'bool', text: 'FALSE' };
      return { kind: 'text', text: d.sym };
    }
    return { kind: 'text', text: String(d) };
  }
  function strOf(d) { return typeof d === 'string' ? d : null; }
  function symOf(d) { return (d && d.sym !== undefined) ? d.sym : null; }
  function numOf(d) { return (d && d.num !== undefined) ? d.num : null; }
  function colIndex(letters) {
    var col = 0, s = letters.toUpperCase();
    for (var k = 0; k < s.length; k++) col = col * 26 + (s.charCodeAt(k) - 64);
    return col;
  }
  function colName(c) {
    var s = '';
    while (c > 0) { var r = (c - 1) % 26; s = String.fromCharCode(65 + r) + s; c = (c - 1 - r) / 26; }
    return s;
  }
  function parseA1(addr) {
    var m = /^\$?([A-Za-z]+)\$?(\d+)$/.exec(addr);
    if (!m) return null;
    return { row: parseInt(m[2], 10), col: colIndex(m[1]) };
  }
  // A range as a reference spells one: A1, A1:F20, C:C, 2:2 (corners in any order).
  function parseRange(text) {
    if (typeof text !== 'string') return null;
    var parts = text.split(':');
    if (parts.length > 2) return null;
    var cols = /^([A-Za-z]+):([A-Za-z]+)$/.exec(text);
    if (cols) return { top: 1, left: Math.min(colIndex(cols[1]), colIndex(cols[2])), bottom: 0, right: Math.max(colIndex(cols[1]), colIndex(cols[2])), columns: true };
    var rows = /^(\d+):(\d+)$/.exec(text);
    if (rows) return { top: Math.min(+rows[1], +rows[2]), left: 1, bottom: Math.max(+rows[1], +rows[2]), right: 0, rows: true };
    var a = parseA1(parts[0]), b = parseA1(parts.length > 1 ? parts[1] : parts[0]);
    if (!a || !b) return null;
    return { top: Math.min(a.row, b.row), left: Math.min(a.col, b.col), bottom: Math.max(a.row, b.row), right: Math.max(a.col, b.col) };
  }
  function rangeText(r) {
    if (r.columns) return colName(r.left) + ':' + colName(r.right);
    if (r.rows) return r.top + ':' + r.bottom;
    var a = colName(r.left) + r.top;
    if (r.top === r.bottom && r.left === r.right) return a;
    return a + ':' + colName(r.right) + r.bottom;
  }
  function countLines(text) {
    if (!text) return 0;
    var n = 0;
    for (var i = text.indexOf('\n'); i >= 0; i = text.indexOf('\n', i + 1)) n++;
    return n + (text.charAt(text.length - 1) === '\n' ? 0 : 1);
  }
  function cellKey(row, col) { return row + ',' + col; }

  // The record as a model: the sheets, the window's sheet and range, the
  // extent, the gridlines, the columns with settings, the formats, and the
  // cells by row and column. An unknown row is counted; a known row of the
  // wrong shape is counted as malformed; nothing is refused.
  function readRecord(text) {
    var t0 = now();
    var rd = new Reader(text);
    var m = {
      sheets: [], sheet: '', windowText: '', window: null, extentText: '', extent: null, gridlines: true,
      columns: {}, columnList: [], formats: {}, cells: new Map(), rows: 1, cols: 1,
      counts: { forms: 0, cells: 0, formulas: 0, styles: 0, sentences: 0, unknown: 0, malformed: 0 },
      lines: 0, readMs: 0
    };
    m.formats[0] = { fill: null, num: 'general', wrap: false };
    var f, maxRow = 0, maxCol = 0;
    while ((f = rd.readForm()) !== null) {
      m.counts.forms++;
      if (!Array.isArray(f) || f.length === 0 || !f[0] || f[0].sym === undefined) { m.counts.unknown++; continue; }
      var head = f[0].sym, name, r, a, e;
      if (head === 'sheet') {
        name = strOf(f[1]);
        if (name === null) { m.counts.malformed++; continue; }
        m.sheets.push({ name: name, state: symOf(f[2]) || 'visible' });
      } else if (head === 'window') {
        name = strOf(f[1]); r = parseRange(strOf(f[2]));
        if (name === null || !r || r.columns || r.rows) { m.counts.malformed++; continue; }
        m.sheet = name; m.windowText = strOf(f[2]); m.window = r;
      } else if (head === 'extent') {
        name = strOf(f[1]);
        if (name === null) { m.counts.malformed++; continue; }
        if (symOf(f[2]) === 'none') { m.extentText = 'none'; m.extent = null; continue; }
        r = parseRange(strOf(f[2]));
        if (!r || r.columns || r.rows) { m.counts.malformed++; continue; }
        m.extentText = strOf(f[2]); m.extent = r;
      } else if (head === 'gridlines') {
        var g = symOf(f[2]);
        if (g !== 'on' && g !== 'off') { m.counts.malformed++; continue; }
        m.gridlines = (g === 'on');
      } else if (head === 'column') {
        var letters = strOf(f[2]);
        if (letters === null || !/^[A-Za-z]+$/.test(letters)) { m.counts.malformed++; continue; }
        var width = numOf(f[3]);
        if (width === null && symOf(f[3]) !== 'none') { m.counts.malformed++; continue; }
        var shown = symOf(f[4]);
        if (shown !== 'shown' && shown !== 'hidden') { m.counts.malformed++; continue; }
        var cstyle = numOf(f[5]);
        if (cstyle === null && symOf(f[5]) !== 'none') { m.counts.malformed++; continue; }
        var col = { letters: letters.toUpperCase(), index: colIndex(letters), width: width, hidden: shown === 'hidden', style: cstyle };
        m.columns[col.index] = col;
        m.columnList.push(col);
      } else if (head === 'format') {
        var idx = numOf(f[1]), fill = strOf(f[2]), num = symOf(f[3]), wrap = symOf(f[4]);
        if (idx === null || (fill === null && symOf(f[2]) !== 'none') || (num !== 'general' && num !== 'text') || (wrap !== 'wrap' && wrap !== 'nowrap')) { m.counts.malformed++; continue; }
        m.formats[idx] = { fill: fill === null ? null : '#' + fill, num: num, wrap: wrap === 'wrap' };
      } else if (head === 'cell' || head === 'formula') {
        a = parseA1(strOf(f[2]) || '');
        if (!a) { m.counts.malformed++; continue; }
        var v = head === 'cell' ? valueOf(f[3]) : { kind: 'formula', text: strOf(f[3]) === null ? valueOf(f[3]).text : strOf(f[3]) };
        m.cells.set(cellKey(a.row, a.col), { row: a.row, col: a.col, address: colName(a.col) + a.row, kind: head, vkind: v.kind, text: v.text, style: 0, sentence: 0 });
        if (a.row > maxRow) maxRow = a.row;
        if (a.col > maxCol) maxCol = a.col;
        if (head === 'cell') m.counts.cells++; else m.counts.formulas++;
      } else if (head === 'style' || head === 'sentence') {
        a = parseA1(strOf(f[2]) || '');
        var n = numOf(f[3]);
        e = a ? m.cells.get(cellKey(a.row, a.col)) : null;
        if (!a || n === null || !e) { m.counts.malformed++; continue; }
        e[head] = n;
        if (head === 'style') m.counts.styles++; else m.counts.sentences++;
      } else {
        m.counts.unknown++;
      }
    }
    // The sheet's scope: the window's range, or the cells' reach when the record holds no window row.
    if (m.window) { m.rows = m.window.bottom; m.cols = m.window.right; }
    else { m.rows = Math.max(1, maxRow); m.cols = Math.max(1, maxCol); }
    m.lines = countLines(text);
    m.readMs = now() - t0;
    return m;
  }

  // ---- (2) the geometry: the layout in device pixels ----
  // env: { dpr, canvasW, canvasH } in device pixels and { clientW, clientH }
  // in CSS pixels, the scroller's client area. state: the host's state.
  function Geometry(model, state, env) {
    var dpr = env.dpr;
    this.dpr = dpr;
    this.canvasW = env.canvasW; this.canvasH = env.canvasH;
    this.rowH = Math.round(DEFAULT_ROW_PX * dpr);
    this.headH = this.rowH;
    this.fontPx = Math.round(FONT_PX * dpr);
    this.font = this.fontPx + 'px ' + FONT_FAMILY;
    this.pad = Math.round(TEXT_PAD_PX * dpr);
    this.lineH = Math.round(FONT_PX * LINE_HEIGHT * dpr);
    var rows = model ? model.rows : 1, cols = model ? model.cols : 1;
    // The sheet space is never less than a screen: a screen of slack rows and
    // columns follows the window, so the scroll reaches past the last cell.
    this.sheetRows = rows; this.sheetCols = cols;
    this.rows = rows + Math.ceil(env.clientH / DEFAULT_ROW_PX) + 1;
    this.cols = cols + Math.ceil(env.clientW / DEFAULT_COLUMN_PX) + 1;
    this.digits = String(this.rows).length;
    this.rhW = Math.round(Math.max(ROW_HEADER_MIN_PX, ROW_HEADER_PAD_PX + ROW_HEADER_DIGIT_PX * this.digits) * dpr);
    this.colW = [0]; this.colX = [0, 0];
    var x = 0;
    for (var c = 1; c <= this.cols; c++) {
      var w = Math.round(columnWidthCss(model, state, c) * dpr);
      this.colW.push(w); x += w; this.colX.push(x);
    }
    this.contentW = x;
    this.contentH = this.rows * this.rowH;
    this.fr = Math.max(0, Math.min(state.frozenRows, this.rows - 1));
    this.fc = Math.max(0, Math.min(state.frozenCols, this.cols - 1));
    this.frozenH = this.fr * this.rowH;
    this.frozenW = this.colX[this.fc + 1];
    this.ox = this.rhW; this.oy = this.headH;
  }
  // A column's width in CSS pixels: the host's override, else hidden is 0,
  // else the record's width through the rule, else the default.
  function columnWidthCss(model, state, c) {
    var letters = colName(c);
    if (Object.prototype.hasOwnProperty.call(state.widths, letters)) return state.widths[letters];
    var col = model ? model.columns[c] : null;
    if (col) {
      if (col.hidden) return 0;
      if (col.width !== null) return columnPixels(col.width);
    }
    return DEFAULT_COLUMN_PX;
  }
  Geometry.prototype.rowTop = function (r) { return (r - 1) * this.rowH; };
  // The first column whose right edge is past x (content coordinates), from c0.
  Geometry.prototype.columnAt = function (x, c0) {
    var c = Math.max(1, c0 || 1);
    while (c <= this.cols && this.colX[c + 1] <= x) c++;
    return c;
  };
  Geometry.prototype.rowAt = function (y, r0) {
    var r = Math.floor(y / this.rowH) + 1;
    return Math.max(r0 || 1, r);
  };
  // The formats of a cell: the cell's own, else its column's, else format 0.
  function formatOf(model, cell, c) {
    if (cell && cell.style !== 0 && model.formats[cell.style]) return model.formats[cell.style];
    if (!cell) {
      var col = model.columns[c];
      if (col && col.style !== null && model.formats[col.style]) return model.formats[col.style];
    }
    return model.formats[0];
  }
  // Where a value sits in its cell, as Excel aligns it under General, and
  // everything left under a text format.
  function alignOf(cell, fmt) {
    if (fmt.num === 'text') return 'left';
    if (cell.vkind === 'number' || cell.vkind === 'date') return 'right';
    if (cell.vkind === 'bool' || cell.vkind === 'error') return 'center';
    return 'left';
  }

  // ---- (3) the painter ----
  function Painter(ctx, colors) { this.ctx = ctx; this.colors = colors; this.ops = []; }
  Painter.prototype.fillRect = function (x, y, w, h, color, op) {
    this.ctx.fillStyle = color;
    this.ctx.fillRect(x, y, w, h);
    if (op) { op.x = x; op.y = y; op.w = w; op.h = h; op.color = color; this.ops.push(op); }
  };
  Painter.prototype.lines = function (segments, color, kind) {
    var ctx = this.ctx;
    ctx.strokeStyle = color;
    ctx.lineWidth = 1;
    ctx.beginPath();
    for (var i = 0; i < segments.length; i++) {
      var s = segments[i];
      ctx.moveTo(s[0], s[1]); ctx.lineTo(s[2], s[3]);
      this.ops.push({ op: 'line', kind: kind, x1: s[0], y1: s[1], x2: s[2], y2: s[3], color: color });
    }
    ctx.stroke();
  };
  Painter.prototype.clipped = function (rect, fn) {
    var ctx = this.ctx;
    ctx.save();
    ctx.beginPath();
    ctx.rect(rect.x, rect.y, rect.w, rect.h);
    ctx.clip();
    try { fn(); } finally { ctx.restore(); }
  };
  // One line of text at an anchor, clipped to a rectangle.
  Painter.prototype.text = function (text, x, y, align, color, clip, op) {
    var ctx = this.ctx;
    ctx.save();
    ctx.beginPath();
    ctx.rect(clip.x, clip.y, clip.w, clip.h);
    ctx.clip();
    ctx.fillStyle = color;
    ctx.textAlign = align;
    ctx.fillText(text, x, y);
    ctx.restore();
    if (op) { op.text = text; op.x = x; op.y = y; op.align = align; op.color = color; op.clip = { x: clip.x, y: clip.y, w: clip.w, h: clip.h }; this.ops.push(op); }
  };
  // A text broken at word boundaries to a width, in the context's font; a
  // word wider than the width is cut.
  function wrapText(ctx, text, width) {
    var words = text.split(' '), lines = [], line = '';
    for (var i = 0; i < words.length; i++) {
      var w = words[i];
      var trial = line === '' ? w : line + ' ' + w;
      if (ctx.measureText(trial).width <= width || line === '') {
        if (line === '' && ctx.measureText(w).width > width) {
          // cut a word wider than the cell
          var cut = '';
          for (var k = 0; k < w.length; k++) {
            if (ctx.measureText(cut + w.charAt(k)).width > width && cut !== '') { lines.push(cut); cut = ''; }
            cut += w.charAt(k);
          }
          line = cut;
        } else {
          line = trial;
        }
      } else {
        lines.push(line);
        line = w;
      }
    }
    lines.push(line);
    return lines;
  }

  // ---- (4) the viewport ----
  function Viewport(element, options) {
    if (!element || !element.appendChild) throw new Error('AlonzoViewport: the first argument must be an element the viewport fills');
    options = options || {};
    this.colors = {};
    for (var k in DEFAULT_COLORS) if (Object.prototype.hasOwnProperty.call(DEFAULT_COLORS, k)) this.colors[k] = DEFAULT_COLORS[k];
    if (options.colors) for (var k2 in options.colors) if (Object.prototype.hasOwnProperty.call(options.colors, k2)) this.colors[k2] = options.colors[k2];
    this.records = {};         // sheet name -> model
    this.sheetList = [];       // every sheet row of the latest record, in tab order
    this.active = '';          // the sheet shown
    this.state = { widths: {}, frozenRows: 0, frozenCols: 0, marks: {}, showHidden: !!options.showHidden,
                   selection: { kind: 'cells', anchor: { row: 1, col: 1 }, focus: { row: 1, col: 1 } } };
    this.listeners = {};
    this.ops = [];
    this.g = null;
    this.lastScroll = { x: -1, y: -1 };
    this.drag = null;
    this._build(element);
    this._listen();
    if (options.record) this.load(options.record);
    else this._draw();
  }

  Viewport.prototype._build = function (element) {
    var d = global.document;
    this.element = element;
    var root = this.root = d.createElement('div');
    root.className = 'alonzo-viewport';
    root.style.cssText = 'position:relative;display:flex;flex-direction:column;width:100%;height:100%;min-height:0;box-sizing:border-box;';
    var box = this.box = d.createElement('div');
    box.className = 'alonzo-grid';
    box.style.cssText = 'position:relative;flex:1 1 auto;min-height:0;overflow:hidden;background:' + this.colors.background + ';';
    var canvas = this.canvas = d.createElement('canvas');
    canvas.style.cssText = 'position:absolute;left:0;top:0;display:block;';
    var scroller = this.scroller = d.createElement('div');
    scroller.className = 'alonzo-scroller';
    scroller.setAttribute('tabindex', '0');
    scroller.setAttribute('role', 'grid');
    scroller.setAttribute('aria-label', 'the grid');
    scroller.style.cssText = 'position:absolute;left:0;top:0;right:0;bottom:0;overflow:auto;outline:none;cursor:cell;';
    var spacer = this.spacer = d.createElement('div');
    spacer.style.cssText = 'width:1px;height:1px;';
    scroller.appendChild(spacer);
    box.appendChild(canvas);
    box.appendChild(scroller);
    var tabs = this.tabs = d.createElement('div');
    tabs.className = 'alonzo-tabs';
    tabs.style.cssText = 'flex:none;display:flex;align-items:center;gap:2px;padding:3px 4px;background:' + this.colors.tabBackground + ';border-top:1px solid ' + this.colors.gridline + ';font:12px system-ui, "Segoe UI", sans-serif;color:' + this.colors.headerText + ';min-height:22px;';
    root.appendChild(box);
    root.appendChild(tabs);
    element.appendChild(root);
    this.ctx = canvas.getContext('2d');
    this._renderTabs();
    this._resize();
  };

  // The canvas takes the box's CSS size, its backing store that size times the
  // ratio; the spacer gives the scroller its range.
  Viewport.prototype._resize = function () {
    var dpr = global.devicePixelRatio || 1;
    var w = this.box.clientWidth, h = this.box.clientHeight;
    this.dpr = dpr;
    this.cssW = w; this.cssH = h;
    this.canvas.width = Math.max(1, Math.round(w * dpr));
    this.canvas.height = Math.max(1, Math.round(h * dpr));
    this.canvas.style.width = w + 'px';
    this.canvas.style.height = h + 'px';
  };
  Viewport.prototype._env = function () {
    return { dpr: this.dpr, canvasW: this.canvas.width, canvasH: this.canvas.height, clientW: this.scroller.clientWidth, clientH: this.scroller.clientHeight };
  };
  Viewport.prototype._model = function () { return this.active ? (this.records[this.active] || null) : null; };

  Viewport.prototype._listen = function () {
    var self = this, d = global.document;
    this._onScroll = function () {
      if (self.scroller.scrollLeft === self.lastScroll.x && self.scroller.scrollTop === self.lastScroll.y) return;
      self._draw();
      self._emit('scroll', self._scrollPayload());
    };
    this._onMouseDown = function (ev) { self._mouseDown(ev); };
    this._onMouseMove = function (ev) { self._mouseMove(ev); };
    this._onMouseUp = function (ev) { self._mouseUp(ev); };
    this._onDblClick = function (ev) { self._dblClick(ev); };
    this._onKeyDown = function (ev) { self._keyDown(ev); };
    this._onResize = function () { self._resize(); self._draw(); };
    this.scroller.addEventListener('scroll', this._onScroll);
    this.scroller.addEventListener('mousedown', this._onMouseDown);
    this.scroller.addEventListener('dblclick', this._onDblClick);
    this.scroller.addEventListener('keydown', this._onKeyDown);
    d.addEventListener('mousemove', this._onMouseMove);
    d.addEventListener('mouseup', this._onMouseUp);
    if (global.ResizeObserver) {
      this.observer = new global.ResizeObserver(function () { self._onResize(); });
      this.observer.observe(this.box);
    } else {
      global.addEventListener('resize', this._onResize);
    }
    this._watchRatio();
  };
  // When the ratio changes (a window moved between screens, a zoom), the
  // backing store is remade and the window drawn again.
  Viewport.prototype._watchRatio = function () {
    var self = this;
    if (!global.matchMedia) return;
    var dpr = global.devicePixelRatio || 1;
    var mq = global.matchMedia('(resolution: ' + dpr + 'dppx)');
    var onChange = function () {
      if (self.ratioQuery) { try { self.ratioQuery.removeEventListener('change', self.ratioChange); } catch (e) { } }
      self._resize(); self._draw();
      self._watchRatio();
    };
    this.ratioQuery = mq; this.ratioChange = onChange;
    try { mq.addEventListener('change', onChange); } catch (e) { }
  };

  // ---- the draw ----
  Viewport.prototype._draw = function () {
    var model = this._model();
    var env = this._env();
    var state = this.state;
    var g = this.g = new Geometry(model, state, env);
    var W = env.canvasW, H = env.canvasH;
    var p = new Painter(this.ctx, this.colors);
    var ctx = this.ctx;
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.clearRect(0, 0, W, H);
    ctx.fillStyle = this.colors.background;
    ctx.fillRect(0, 0, W, H);
    ctx.font = g.font;
    ctx.textBaseline = 'middle';
    // The spacer: the scroller's range is the content less what the frozen bands and headers hold on screen.
    var spacerW = Math.ceil((g.contentW + g.rhW) / g.dpr), spacerH = Math.ceil((g.contentH + g.headH) / g.dpr);
    if (this.spacer.style.width !== spacerW + 'px') this.spacer.style.width = spacerW + 'px';
    if (this.spacer.style.height !== spacerH + 'px') this.spacer.style.height = spacerH + 'px';
    var sx = Math.round(this.scroller.scrollLeft * g.dpr), sy = Math.round(this.scroller.scrollTop * g.dpr);
    this.lastScroll = { x: this.scroller.scrollLeft, y: this.scroller.scrollTop };
    this.scroll = { x: sx, y: sy };
    var ox = g.ox, oy = g.oy, fx = ox + g.frozenW, fy = oy + g.frozenH;
    if (model) {
      this._paintQuadrant(p, model, g, { x: fx, y: fy, w: W - fx, h: H - fy }, g.fr + 1, g.rows, g.fc + 1, g.cols, sx, sy, 'body');
      if (g.fr > 0) this._paintQuadrant(p, model, g, { x: fx, y: oy, w: W - fx, h: g.frozenH }, 1, g.fr, g.fc + 1, g.cols, sx, 0, 'frozen-rows');
      if (g.fc > 0) this._paintQuadrant(p, model, g, { x: ox, y: fy, w: g.frozenW, h: H - fy }, g.fr + 1, g.rows, 1, g.fc, 0, sy, 'frozen-cols');
      if (g.fr > 0 && g.fc > 0) this._paintQuadrant(p, model, g, { x: ox, y: oy, w: g.frozenW, h: g.frozenH }, 1, g.fr, 1, g.fc, 0, 0, 'frozen-corner');
    } else {
      this._paintQuadrant(p, null, g, { x: fx, y: fy, w: W - fx, h: H - fy }, 1, g.rows, 1, g.cols, sx, sy, 'body');
    }
    // the frozen separators
    var seps = [];
    if (g.fr > 0) seps.push([ox, fy - 0.5, W, fy - 0.5]);
    if (g.fc > 0) seps.push([fx - 0.5, oy, fx - 0.5, H]);
    if (seps.length) p.lines(seps, this.colors.frozenLine, 'frozen');
    this._paintHeaders(p, g, sx, sy, W, H);
    this.ops = p.ops;
  };

  // One quadrant: the cells of rows r1..r2 and columns c1..c2 drawn at the
  // content position less the quadrant's scroll, clipped to its rectangle.
  Viewport.prototype._paintQuadrant = function (p, model, g, clip, r1, r2, c1, c2, sx, sy, name) {
    var self = this, colors = this.colors;
    var ox = g.ox, oy = g.oy, rowH = g.rowH;
    if (clip.w <= 0 || clip.h <= 0) return;
    // the visible rows and columns of the quadrant
    var rowStart = Math.max(r1, g.rowAt(clip.y - oy + sy, r1));
    var rowEnd = Math.min(r2, g.rowAt(clip.y + clip.h - 1 - oy + sy, r1));
    var colStart = Math.max(c1, g.columnAt(clip.x - ox + sx, c1));
    var colEnd = Math.min(c2, g.columnAt(clip.x + clip.w - 1 - ox + sx, c1));
    if (rowStart > rowEnd || colStart > colEnd) return;
    var r, c, cell, x, y, w;
    p.clipped(clip, function () {
      // the fills: a styled cell's, or a styled column's for its empty cells
      if (model) {
        for (r = rowStart; r <= rowEnd; r++) {
          y = oy + g.rowTop(r) - sy;
          for (c = colStart; c <= colEnd; c++) {
            w = g.colW[c];
            if (w === 0) continue;
            cell = model.cells.get(cellKey(r, c)) || null;
            var fmt = formatOf(model, cell, c);
            if (fmt.fill) p.fillRect(ox + g.colX[c] - sx, y, w, rowH, fmt.fill, { op: 'fill', row: r, col: c, quadrant: name });
          }
        }
      }
      // the gridlines, at an integer plus a half so that each is one device pixel
      if (!model || model.gridlines) {
        var segs = [];
        for (c = colStart; c <= colEnd; c++) {
          if (g.colW[c] === 0) continue;
          x = ox + g.colX[c + 1] - sx - 0.5;
          segs.push([x, clip.y, x, clip.y + clip.h]);
        }
        for (r = rowStart; r <= rowEnd; r++) {
          y = oy + g.rowTop(r) + rowH - sy - 0.5;
          segs.push([clip.x, y, clip.x + clip.w, y]);
        }
        p.lines(segs, colors.gridline, 'grid-' + name);
      }
      // the texts
      if (model) {
        for (r = rowStart; r <= rowEnd; r++) {
          y = oy + g.rowTop(r) - sy;
          // a text left of the quadrant's first visible column may overflow into view
          var from = Math.max(c1, colStart - OVERFLOW_LOOKBACK);
          for (c = from; c <= colEnd; c++) {
            if (g.colW[c] === 0) continue;
            cell = model.cells.get(cellKey(r, c)) || null;
            if (!cell || cell.text === '') continue;
            if (c < colStart) {
              // only a left-aligned nowrap text can reach the visible columns
              var f0 = formatOf(model, cell, c);
              if (f0.wrap || alignOf(cell, f0) !== 'left') continue;
            }
            self._paintCell(p, model, g, cell, r, c, ox + g.colX[c] - sx, y, c2, name, clip);
          }
        }
      }
      // the selection and the marks
      self._paintRanges(p, model, g, clip, r1, r2, c1, c2, sx, sy, name);
    });
  };

  // One cell's text: aligned by its kind, a nowrap text spilling into empty
  // neighbours to the right, a wrapped text broken at the column's width.
  Viewport.prototype._paintCell = function (p, model, g, cell, r, c, left, top, cLast, quadrant, qclip) {
    var ctx = p.ctx, colors = this.colors;
    var w = g.colW[c], h = g.rowH, pad = g.pad;
    var fmt = formatOf(model, cell, c);
    var align = alignOf(cell, fmt);
    var color = cell.kind === 'formula' ? colors.formula : colors.text;
    var op = { op: 'text', row: r, col: c, kind: cell.kind, quadrant: quadrant };
    if (fmt.wrap) {
      if (left + w <= qclip.x || left >= qclip.x + qclip.w) return;
      var lines = wrapText(ctx, cell.text, Math.max(1, w - 2 * pad));
      var clip = { x: left, y: top, w: w, h: h };
      var ty = top + Math.round(g.lineH / 2);
      for (var i = 0; i < lines.length && ty - Math.round(g.lineH / 2) < top + h; i++) {
        var ax = align === 'left' ? left + pad : (align === 'right' ? left + w - pad : left + Math.round(w / 2));
        var lop = { op: 'text', row: r, col: c, kind: cell.kind, quadrant: quadrant, line: i, lines: lines.length, wrap: true };
        p.text(lines[i], ax, ty, align, color, clip, lop);
        ty += g.lineH;
      }
      return;
    }
    var cy = top + Math.round(h / 2);
    var textW = ctx.measureText(cell.text).width;
    var clipW = w;
    if (align === 'left' && textW + 2 * pad > w) {
      // spill into the empty cells to the right, and stop at the first that holds anything
      var cc = c + 1;
      while (cc <= cLast && clipW < textW + 2 * pad) {
        var e = model.cells.get(cellKey(r, cc));
        if (e && e.text !== '') break;
        clipW += g.colW[cc];
        cc++;
      }
    }
    // a text whose clip never reaches the quadrant is not drawn at all
    if (left + clipW <= qclip.x || left >= qclip.x + qclip.w) return;
    var ax2 = align === 'left' ? left + pad : (align === 'right' ? left + w - pad : left + Math.round(w / 2));
    op.wrap = false;
    p.text(cell.text, ax2, cy, align, color, { x: left, y: top, w: clipW, h: h }, op);
  };

  // The selection and the marks inside a quadrant.
  Viewport.prototype._paintRanges = function (p, model, g, clip, r1, r2, c1, c2, sx, sy, name) {
    var ctx = p.ctx, colors = this.colors;
    function rectOf(range) {
      var top = range.top, bottom = range.bottom, left = range.left, right = range.right;
      if (range.columns) { top = 1; bottom = g.rows; }
      if (range.rows) { left = 1; right = g.cols; }
      if (range.sheet) { top = 1; bottom = g.rows; left = 1; right = g.cols; }
      // clip to the quadrant's rows and columns
      var t = Math.max(top, r1), b = Math.min(bottom, r2), l = Math.max(left, c1), rr = Math.min(right, c2);
      if (t > b || l > rr) return null;
      var x = g.ox + g.colX[l] - sx, y = g.oy + g.rowTop(t) - sy;
      var w = g.colX[rr + 1] - g.colX[l], h = (b - t + 1) * g.rowH;
      return { x: x, y: y, w: w, h: h, top: t, bottom: b, left: l, right: rr };
    }
    var sel = this._selectionRange();
    var sr = rectOf(sel);
    if (sr && sr.w > 0 && sr.h > 0) {
      p.fillRect(sr.x, sr.y, sr.w, sr.h, colors.selectionFill, { op: 'selection', quadrant: name, top: sr.top, bottom: sr.bottom, left: sr.left, right: sr.right });
      ctx.strokeStyle = colors.selectionBorder;
      ctx.lineWidth = 2;
      ctx.strokeRect(sr.x + 1, sr.y + 1, sr.w - 2, sr.h - 2);
    }
    var marks = this.state.marks;
    for (var nm in marks) {
      if (!Object.prototype.hasOwnProperty.call(marks, nm)) continue;
      var mk = marks[nm];
      for (var i = 0; i < mk.ranges.length; i++) {
        var mr = rectOf(mk.ranges[i]);
        if (!mr || mr.w <= 0 || mr.h <= 0) continue;
        if (mk.style.fill) p.fillRect(mr.x, mr.y, mr.w, mr.h, mk.style.fill, { op: 'mark', name: nm, quadrant: name, top: mr.top, bottom: mr.bottom, left: mr.left, right: mr.right });
        if (mk.style.border) {
          ctx.strokeStyle = mk.style.border;
          ctx.lineWidth = 2;
          ctx.strokeRect(mr.x + 1, mr.y + 1, mr.w - 2, mr.h - 2);
          if (!mk.style.fill) p.ops.push({ op: 'mark', name: nm, quadrant: name, top: mr.top, bottom: mr.bottom, left: mr.left, right: mr.right, x: mr.x, y: mr.y, w: mr.w, h: mr.h, color: mk.style.border });
        }
      }
    }
  };

  // The column headers, the row headers and the corner, never scrolled past.
  Viewport.prototype._paintHeaders = function (p, g, sx, sy, W, H) {
    var colors = this.colors;
    var ox = g.ox, oy = g.oy, rowH = g.rowH, headH = g.headH;
    var sel = this._selectionRange();
    var selCols = (sel.sheet || sel.rows) ? { left: 1, right: g.cols } : { left: sel.left, right: sel.right };
    var selRows = (sel.sheet || sel.columns) ? { top: 1, bottom: g.rows } : { top: sel.top, bottom: sel.bottom };
    // the column headers: the frozen columns unscrolled, the rest scrolled, each band clipped
    function columnBand(clip, c1, c2, scroll) {
      if (clip.w <= 0) return;
      p.clipped(clip, function () {
        var cStart = Math.max(c1, g.columnAt(clip.x - ox + scroll, c1));
        var cEnd = Math.min(c2, g.columnAt(clip.x + clip.w - 1 - ox + scroll, c1));
        var segs = [];
        for (var c = cStart; c <= cEnd; c++) {
          var w = g.colW[c];
          if (w === 0) continue;
          var x = ox + g.colX[c] - scroll;
          var selected = c >= selCols.left && c <= selCols.right;
          p.fillRect(x, 0, w, headH, selected ? colors.headerSelected : colors.header, { op: 'header', kind: 'column', index: c, text: colName(c), selected: selected });
          p.text(colName(c), x + Math.round(w / 2), Math.round(headH / 2), 'center', colors.headerText, { x: x, y: 0, w: w, h: headH }, { op: 'header-text', kind: 'column', index: c });
          segs.push([x + w - 0.5, 0, x + w - 0.5, headH]);
        }
        segs.push([clip.x, headH - 0.5, clip.x + clip.w, headH - 0.5]);
        p.lines(segs, colors.gridline, 'header-column');
      });
    }
    function rowBand(clip, r1, r2, scroll) {
      if (clip.h <= 0) return;
      p.clipped(clip, function () {
        var rStart = Math.max(r1, g.rowAt(clip.y - oy + scroll, r1));
        var rEnd = Math.min(r2, g.rowAt(clip.y + clip.h - 1 - oy + scroll, r1));
        var segs = [];
        for (var r = rStart; r <= rEnd; r++) {
          var y = oy + g.rowTop(r) - scroll;
          var selected = r >= selRows.top && r <= selRows.bottom;
          p.fillRect(0, y, g.rhW, rowH, selected ? colors.headerSelected : colors.header, { op: 'header', kind: 'row', index: r, text: String(r), selected: selected });
          p.text(String(r), g.rhW - g.pad, y + Math.round(rowH / 2), 'right', colors.headerText, { x: 0, y: y, w: g.rhW, h: rowH }, { op: 'header-text', kind: 'row', index: r });
          segs.push([0, y + rowH - 0.5, g.rhW, y + rowH - 0.5]);
        }
        segs.push([g.rhW - 0.5, clip.y, g.rhW - 0.5, clip.y + clip.h]);
        p.lines(segs, colors.gridline, 'header-row');
      });
    }
    var fx = ox + g.frozenW, fy = oy + g.frozenH;
    columnBand({ x: fx, y: 0, w: W - fx, h: headH }, g.fc + 1, g.cols, sx);
    if (g.fc > 0) columnBand({ x: ox, y: 0, w: g.frozenW, h: headH }, 1, g.fc, 0);
    rowBand({ x: 0, y: fy, w: g.rhW, h: H - fy }, g.fr + 1, g.rows, sy);
    if (g.fr > 0) rowBand({ x: 0, y: oy, w: g.rhW, h: g.frozenH }, 1, g.fr, 0);
    p.fillRect(0, 0, g.rhW, headH, colors.header, { op: 'header', kind: 'corner', index: 0, text: '', selected: !!sel.sheet });
    p.lines([[g.rhW - 0.5, 0, g.rhW - 0.5, headH], [0, headH - 0.5, g.rhW, headH - 0.5]], colors.gridline, 'header-corner');
  };

  // ---- the selection ----
  Viewport.prototype._selectionRange = function () {
    var s = this.state.selection, a = s.anchor, f = s.focus;
    var rows = this.g ? this.g.sheetRows : 1, cols = this.g ? this.g.sheetCols : 1;
    if (s.kind === 'sheet') return { sheet: true, top: 1, left: 1, bottom: rows, right: cols };
    if (s.kind === 'columns') return { columns: true, top: 1, bottom: rows, left: Math.min(a.col, f.col), right: Math.max(a.col, f.col) };
    if (s.kind === 'rows') return { rows: true, left: 1, right: cols, top: Math.min(a.row, f.row), bottom: Math.max(a.row, f.row) };
    return { top: Math.min(a.row, f.row), bottom: Math.max(a.row, f.row), left: Math.min(a.col, f.col), right: Math.max(a.col, f.col) };
  };
  // The selection as the grammar spells it: B2, B2:C3, C:C, 2:2, or the sheet's name.
  Viewport.prototype._selectionText = function () {
    var r = this._selectionRange();
    if (r.sheet) return this.active;
    return rangeText(r);
  };
  Viewport.prototype._cellInfo = function (row, col) {
    var model = this._model();
    var cell = model ? model.cells.get(cellKey(row, col)) : null;
    if (!cell) return { row: row, col: col, address: colName(col) + row, kind: 'empty', text: '', style: 0, sentence: 0 };
    return { row: cell.row, col: cell.col, address: cell.address, kind: cell.kind, vkind: cell.vkind, text: cell.text, style: cell.style, sentence: cell.sentence };
  };
  Viewport.prototype._selectPayload = function () {
    var r = this._selectionRange(), s = this.state.selection;
    return { sheet: this.active, text: this._selectionText(), kind: s.kind, range: { top: r.top, left: r.left, bottom: r.bottom, right: r.right },
             focus: this._cellInfo(s.focus.row, s.focus.col) };
  };
  Viewport.prototype._scrollPayload = function () {
    var g = this.g;
    if (!g) return { sheet: this.active, top: 1, left: 1, window: 'A1' };
    var sx = this.scroll.x, sy = this.scroll.y;
    var top = g.fr + 1 + Math.floor(sy / g.rowH), left = g.columnAt(g.colX[g.fc + 1] + sx, g.fc + 1);
    var bottom = Math.min(g.rows, g.rowAt(g.canvasH - 1 - g.oy + sy, top)), right = Math.min(g.cols, g.columnAt(g.canvasW - 1 - g.ox + sx, left));
    return { sheet: this.active, top: top, left: left, bottom: bottom, right: right, window: rangeText({ top: top, left: left, bottom: bottom, right: right }) };
  };
  Viewport.prototype._setSelection = function (kind, anchor, focus, emit) {
    this.state.selection = { kind: kind, anchor: anchor, focus: focus };
    this._draw();
    if (emit !== false) this._emit('select', this._selectPayload());
  };
  // Scroll so that a cell is inside the scrolled quadrant, unless a frozen band holds it.
  Viewport.prototype._scrollIntoView = function (row, col) {
    var g = this.g;
    if (!g) return;
    var sc = this.scroller, dpr = g.dpr;
    var changed = false;
    if (row > g.fr) {
      var top = g.rowTop(row) - g.frozenH, bottom = top + g.rowH;
      var viewH = sc.clientHeight * dpr - g.oy - g.frozenH;
      var sy = Math.round(sc.scrollTop * dpr);
      if (top < sy) { sc.scrollTop = top / dpr; changed = true; }
      else if (bottom > sy + viewH) { sc.scrollTop = (bottom - viewH) / dpr; changed = true; }
    }
    if (col > g.fc) {
      var left = g.colX[col] - g.frozenW, right = left + g.colW[col];
      var viewW = sc.clientWidth * dpr - g.ox - g.frozenW;
      var sx = Math.round(sc.scrollLeft * dpr);
      if (left < sx) { sc.scrollLeft = left / dpr; changed = true; }
      else if (right > sx + viewW) { sc.scrollLeft = (right - viewW) / dpr; changed = true; }
    }
    if (changed) { this._draw(); this._emit('scroll', this._scrollPayload()); }
  };

  // ---- the mouse ----
  // Where a press lands, in device pixels of the canvas: the corner, a column
  // header (and whether on a boundary), a row header, or a cell.
  Viewport.prototype._hit = function (ev) {
    var g = this.g;
    if (!g) return null;
    var rect = this.box.getBoundingClientRect();
    var x = (ev.clientX - rect.left) * g.dpr, y = (ev.clientY - rect.top) * g.dpr;
    var sx = this.scroll.x, sy = this.scroll.y;
    var ox = g.ox, oy = g.oy;
    var grip = RESIZE_GRIP_PX * g.dpr;
    var col, row, cx, cy;
    // the column under x: frozen columns unscrolled, the rest scrolled
    if (x < ox + g.frozenW) { cx = x - ox; col = g.columnAt(cx, 1); if (col > g.fc) col = g.fc; }
    else { cx = x - ox + sx; col = g.columnAt(cx, g.fc + 1); }
    if (y < oy + g.frozenH) { cy = y - oy; row = g.rowAt(cy, 1); if (row > g.fr) row = g.fr; }
    else { cy = y - oy + sy; row = g.rowAt(cy, g.fr + 1); }
    if (col < 1) col = 1;
    if (row < 1) row = 1;
    if (x < ox && y < oy) return { kind: 'corner' };
    if (y < oy) {
      // a boundary: within the grip of a column's right edge
      for (var c = Math.max(1, col - 1); c <= col; c++) {
        if (g.colW[c] === 0) continue;
        var edge = g.colX[c + 1];
        if (Math.abs(cx - edge) <= grip) return { kind: 'boundary', col: c };
      }
      return { kind: 'column', col: col };
    }
    if (x < ox) return { kind: 'row', row: row };
    return { kind: 'cell', row: row, col: col };
  };
  Viewport.prototype._mouseDown = function (ev) {
    if (ev.button !== 0) return;
    var hit = this._hit(ev);
    if (!hit) return;
    this.scroller.focus();
    var s = this.state.selection;
    if (hit.kind === 'boundary') {
      ev.preventDefault();
      this.drag = { kind: 'resize', col: hit.col, startX: ev.clientX, startW: this.g.colW[hit.col] / this.g.dpr };
      return;
    }
    ev.preventDefault();
    if (hit.kind === 'corner') { this._setSelection('sheet', { row: 1, col: 1 }, { row: 1, col: 1 }); return; }
    if (hit.kind === 'column') {
      var anchorC = (ev.shiftKey && s.kind === 'columns') ? s.anchor : { row: 1, col: hit.col };
      this._setSelection('columns', anchorC, { row: 1, col: hit.col });
      this.drag = { kind: 'columns' };
      return;
    }
    if (hit.kind === 'row') {
      var anchorR = (ev.shiftKey && s.kind === 'rows') ? s.anchor : { row: hit.row, col: 1 };
      this._setSelection('rows', anchorR, { row: hit.row, col: 1 });
      this.drag = { kind: 'rows' };
      return;
    }
    var anchor = (ev.shiftKey && s.kind === 'cells') ? s.anchor : { row: hit.row, col: hit.col };
    this._setSelection('cells', anchor, { row: hit.row, col: hit.col });
    this.drag = { kind: 'cells' };
  };
  Viewport.prototype._mouseMove = function (ev) {
    var drag = this.drag;
    if (!drag) {
      // the cursor on a boundary
      if (!this.g) return;
      var rect = this.box.getBoundingClientRect();
      if (ev.clientX < rect.left || ev.clientX > rect.right || ev.clientY < rect.top || ev.clientY > rect.bottom) return;
      var h = this._hit(ev);
      this.scroller.style.cursor = (h && h.kind === 'boundary') ? 'col-resize' : (h && h.kind === 'cell' ? 'cell' : 'default');
      return;
    }
    if (drag.kind === 'resize') {
      var w = Math.max(0, Math.round(drag.startW + (ev.clientX - drag.startX)));
      this.state.widths[colName(drag.col)] = w;
      this._draw();
      return;
    }
    var hit = this._hit(ev);
    if (!hit) return;
    var s = this.state.selection;
    if (drag.kind === 'cells' && (hit.kind === 'cell' || hit.kind === 'column' || hit.kind === 'row')) {
      var row = hit.kind === 'column' ? s.focus.row : hit.row, col = hit.kind === 'row' ? s.focus.col : hit.col;
      if (row !== s.focus.row || col !== s.focus.col) this._setSelection('cells', s.anchor, { row: row, col: col });
    } else if (drag.kind === 'columns' && (hit.kind === 'column' || hit.kind === 'cell' || hit.kind === 'boundary')) {
      if (hit.col !== s.focus.col) this._setSelection('columns', s.anchor, { row: 1, col: hit.col });
    } else if (drag.kind === 'rows' && (hit.kind === 'row' || hit.kind === 'cell')) {
      if (hit.row !== s.focus.row) this._setSelection('rows', s.anchor, { row: hit.row, col: 1 });
    }
  };
  Viewport.prototype._mouseUp = function () {
    var drag = this.drag;
    if (!drag) return;
    this.drag = null;
    if (drag.kind === 'resize') {
      this._emit('columnresize', { sheet: this.active, column: colName(drag.col), width: this.state.widths[colName(drag.col)] });
    }
  };
  Viewport.prototype._dblClick = function (ev) {
    var hit = this._hit(ev);
    if (!hit || hit.kind !== 'cell') return;
    ev.preventDefault();
    this._emit('cellopen', { sheet: this.active, address: colName(hit.col) + hit.row, row: hit.row, col: hit.col, cell: this._cellInfo(hit.row, hit.col) });
  };

  // ---- the keyboard ----
  Viewport.prototype._keyDown = function (ev) {
    var g = this.g;
    if (!g) return;
    var s = this.state.selection, f = s.focus;
    var row = f.row, col = f.col;
    var pageRows = Math.max(1, Math.floor((this.scroller.clientHeight * g.dpr - g.oy - g.frozenH) / g.rowH));
    var handled = true, open = false;
    switch (ev.key) {
      case 'ArrowUp': row = Math.max(1, row - 1); break;
      case 'ArrowDown': row = row + 1; break;
      case 'ArrowLeft': col = Math.max(1, col - 1); break;
      case 'ArrowRight': col = col + 1; break;
      case 'PageUp': row = Math.max(1, row - pageRows); break;
      case 'PageDown': row = row + pageRows; break;
      case 'Home': if (ev.ctrlKey) { row = 1; col = 1; } else { col = 1; } break;
      case 'End': if (ev.ctrlKey) { row = g.sheetRows; col = g.sheetCols; } else { col = g.sheetCols; } break;
      case 'Enter': open = true; break;
      default: handled = false;
    }
    if (!handled) return;
    ev.preventDefault();
    if (open) {
      this._emit('cellopen', { sheet: this.active, address: colName(f.col) + f.row, row: f.row, col: f.col, cell: this._cellInfo(f.row, f.col) });
      return;
    }
    row = Math.min(row, g.rows); col = Math.min(col, g.cols);
    var focus = { row: row, col: col };
    if (ev.shiftKey) this._setSelection('cells', s.kind === 'cells' ? s.anchor : focus, focus);
    else this._setSelection('cells', focus, focus);
    this._scrollIntoView(row, col);
  };

  // ---- the tabs ----
  Viewport.prototype._renderTabs = function () {
    var d = global.document, self = this, tabs = this.tabs;
    while (tabs.firstChild) tabs.removeChild(tabs.firstChild);
    var hiddenCount = 0;
    for (var i = 0; i < this.sheetList.length; i++) if (this.sheetList[i].state !== 'visible') hiddenCount++;
    for (var k = 0; k < this.sheetList.length; k++) {
      var sh = this.sheetList[k];
      if (sh.state !== 'visible' && !this.state.showHidden) continue;
      var b = d.createElement('button');
      b.type = 'button';
      b.className = 'alonzo-tab' + (sh.name === this.active ? ' active' : '') + (this.records[sh.name] ? '' : ' unloaded') + (sh.state !== 'visible' ? ' hidden-sheet' : '');
      b.textContent = sh.name + (sh.state !== 'visible' ? ' (' + sh.state + ')' : '');
      b.title = this.records[sh.name] ? 'the sheet ' + sh.name : 'no record loaded for ' + sh.name + ': the host is asked for one';
      b.setAttribute('data-sheet', sh.name);
      b.style.cssText = 'font:inherit;padding:2px 10px;border:1px solid ' + this.colors.gridline + ';border-radius:3px;cursor:pointer;background:' + (sh.name === this.active ? this.colors.tabActive : this.colors.tabBackground) + ';color:' + (this.records[sh.name] ? this.colors.text : this.colors.headerText) + ';' + (sh.name === this.active ? 'font-weight:600;' : '') + (this.records[sh.name] ? '' : 'font-style:italic;');
      b.addEventListener('click', function (ev) { self._tabClick(ev.currentTarget.getAttribute('data-sheet')); });
      tabs.appendChild(b);
    }
    if (hiddenCount > 0) {
      var label = d.createElement('label');
      label.style.cssText = 'margin-left:auto;display:inline-flex;align-items:center;gap:4px;cursor:pointer;';
      var cb = d.createElement('input');
      cb.type = 'checkbox';
      cb.checked = this.state.showHidden;
      cb.addEventListener('change', function () { self.state.showHidden = cb.checked; self._renderTabs(); });
      label.appendChild(cb);
      label.appendChild(d.createTextNode('hidden sheets (' + hiddenCount + ')'));
      tabs.appendChild(label);
    }
  };
  Viewport.prototype._tabClick = function (name) {
    var sh = null;
    for (var i = 0; i < this.sheetList.length; i++) if (this.sheetList[i].name === name) sh = this.sheetList[i];
    if (this.records[name]) { this.show(name); return; }
    this._emit('sheet', { name: name, loaded: false, state: sh ? sh.state : 'visible' });
  };

  // ---- the events ----
  Viewport.prototype.on = function (name, fn) { (this.listeners[name] = this.listeners[name] || []).push(fn); return this; };
  Viewport.prototype.off = function (name, fn) {
    var l = this.listeners[name];
    if (!l) return this;
    for (var i = l.length - 1; i >= 0; i--) if (l[i] === fn) l.splice(i, 1);
    return this;
  };
  Viewport.prototype._emit = function (name, payload) {
    var l = this.listeners[name];
    if (!l) return;
    for (var i = 0; i < l.length; i++) { try { l[i](payload); } catch (e) { if (global.console) global.console.error(e); } }
  };

  // ---- (5) the API ----
  // A record's text: its sheet becomes a tab, replacing an earlier record of
  // the same sheet; the record's sheet rows are the tab strip. Returns the
  // model's counts.
  Viewport.prototype.load = function (text) {
    var model = readRecord(String(text || ''));
    var name = model.sheet || (model.sheets.length ? model.sheets[0].name : 'Sheet');
    this.records[name] = model;
    if (model.sheets.length) this.sheetList = model.sheets.slice();
    else if (!this._sheetListed(name)) this.sheetList.push({ name: name, state: 'visible' });
    if (!this.active || this.active === name) { this.active = name; this._resetView(); }
    this._renderTabs();
    this._draw();
    if (this.active === name) {
      this._emit('sheet', { name: name, loaded: true, state: this._sheetState(name) });
      // the selection went back to A1 of the record shown: say so
      this._emit('select', this._selectPayload());
    }
    return { sheet: name, lines: model.lines, cells: model.counts.cells, formulas: model.counts.formulas, styles: model.counts.styles, sentences: model.counts.sentences,
             unknown: model.counts.unknown, malformed: model.counts.malformed, window: model.windowText, extent: model.extentText, readMs: model.readMs };
  };
  Viewport.prototype._sheetListed = function (name) {
    for (var i = 0; i < this.sheetList.length; i++) if (this.sheetList[i].name === name) return true;
    return false;
  };
  Viewport.prototype._sheetState = function (name) {
    for (var i = 0; i < this.sheetList.length; i++) if (this.sheetList[i].name === name) return this.sheetList[i].state;
    return 'visible';
  };
  Viewport.prototype._resetView = function () {
    this.scroller.scrollTop = 0; this.scroller.scrollLeft = 0;
    this.lastScroll = { x: -1, y: -1 };
    this.state.selection = { kind: 'cells', anchor: { row: 1, col: 1 }, focus: { row: 1, col: 1 } };
  };
  // Show a sheet whose record is loaded; a name without a record is false.
  Viewport.prototype.show = function (name) {
    var key = this._findSheet(name);
    if (!key) return false;
    var changed = this.active !== key;
    if (changed) { this.active = key; this._resetView(); }
    this._renderTabs();
    this._draw();
    this._emit('sheet', { name: key, loaded: true, state: this._sheetState(key) });
    // a sheet shown puts the selection at its A1 (found by the owner's hand test, 2026-10-08:
    // the line under the grid kept the last sheet's selection), so the change is announced
    if (changed) this._emit('select', this._selectPayload());
    return true;
  };
  Viewport.prototype._findSheet = function (name) {
    var want = String(name || '').toLowerCase();
    for (var k in this.records) if (Object.prototype.hasOwnProperty.call(this.records, k) && k.toLowerCase() === want) return k;
    return null;
  };
  Viewport.prototype.sheets = function () {
    var out = [];
    for (var i = 0; i < this.sheetList.length; i++) {
      var sh = this.sheetList[i];
      out.push({ name: sh.name, state: sh.state, loaded: !!this.records[sh.name], active: sh.name === this.active });
    }
    return out;
  };
  Viewport.prototype.sheet = function () { return this.active; };
  // Scroll so that the cell is at the top left of the scrolled quadrant.
  Viewport.prototype.scrollTo = function (row, col) {
    var g = this.g;
    if (!g) return;
    var r = Math.max(g.fr + 1, row || 1), c = Math.max(g.fc + 1, col || 1);
    this.scrollToPixels((g.colX[c] - g.frozenW) / g.dpr, (g.rowTop(r) - g.frozenH) / g.dpr);
  };
  // Scroll to a position in CSS pixels and draw at once: the harness's step.
  Viewport.prototype.scrollToPixels = function (x, y) {
    this.scroller.scrollLeft = x;
    this.scroller.scrollTop = y;
    this._draw();
    this._emit('scroll', this._scrollPayload());
  };
  Viewport.prototype.select = function (text) {
    var t = String(text || '');
    if (this.active && t.toLowerCase() === this.active.toLowerCase()) { this._setSelection('sheet', { row: 1, col: 1 }, { row: 1, col: 1 }); return true; }
    var r = parseRange(t);
    if (!r) return false;
    if (r.columns) this._setSelection('columns', { row: 1, col: r.left }, { row: 1, col: r.right });
    else if (r.rows) this._setSelection('rows', { row: r.top, col: 1 }, { row: r.bottom, col: 1 });
    else this._setSelection('cells', { row: r.top, col: r.left }, { row: r.bottom, col: r.right });
    return true;
  };
  Viewport.prototype.selection = function () { return this._selectPayload(); };
  Viewport.prototype.freeze = function (rows, cols) {
    this.state.frozenRows = Math.max(0, rows | 0);
    this.state.frozenCols = Math.max(0, cols | 0);
    this._draw();
  };
  Viewport.prototype.frozen = function () { return { rows: this.state.frozenRows, cols: this.state.frozenCols }; };
  // A column's width in CSS pixels, the host's over the record's; null puts the record's back.
  Viewport.prototype.columnWidth = function (letters, px) {
    var key = String(letters).toUpperCase();
    if (px === null || px === undefined) delete this.state.widths[key];
    else this.state.widths[key] = Math.max(0, Math.round(px));
    this._draw();
  };
  Viewport.prototype.columnWidths = function () {
    var out = {};
    for (var k in this.state.widths) if (Object.prototype.hasOwnProperty.call(this.state.widths, k)) out[k] = this.state.widths[k];
    return out;
  };
  // A named highlight over ranges the host computed: style { fill, border }.
  Viewport.prototype.mark = function (name, ranges, style) {
    var list = [];
    var arr = Array.isArray(ranges) ? ranges : [ranges];
    for (var i = 0; i < arr.length; i++) {
      var r = typeof arr[i] === 'string' ? parseRange(arr[i]) : arr[i];
      if (r) list.push(r);
    }
    this.state.marks[String(name)] = { ranges: list, style: style || { border: this.colors.selectionBorder } };
    this._draw();
  };
  Viewport.prototype.unmark = function (name) {
    if (name === undefined) this.state.marks = {};
    else delete this.state.marks[String(name)];
    this._draw();
  };
  // The cell under a point of the page, or null outside the cells.
  Viewport.prototype.cellAt = function (clientX, clientY) {
    var hit = this._hit({ clientX: clientX, clientY: clientY });
    if (!hit || hit.kind !== 'cell') return null;
    return this._cellInfo(hit.row, hit.col);
  };
  Viewport.prototype.cell = function (row, col) { return this._cellInfo(row, col); };
  // The geometry of the last draw: the ratio, the sizes, the scroll, the
  // column edges in device pixels; the environment the oracle needs.
  Viewport.prototype.geometry = function () {
    var g = this.g;
    if (!g) return null;
    return { dpr: g.dpr, canvasW: g.canvasW, canvasH: g.canvasH, clientW: this.scroller.clientWidth, clientH: this.scroller.clientHeight,
             rowH: g.rowH, headH: g.headH, rhW: g.rhW, fontPx: g.fontPx, pad: g.pad, lineH: g.lineH, rows: g.rows, cols: g.cols, sheetRows: g.sheetRows, sheetCols: g.sheetCols,
             colW: g.colW.slice(), colX: g.colX.slice(), frozenRows: g.fr, frozenCols: g.fc, frozenW: g.frozenW, frozenH: g.frozenH,
             scrollX: this.scroll.x, scrollY: this.scroll.y, scrollLeft: this.scroller.scrollLeft, scrollTop: this.scroller.scrollTop };
  };
  Viewport.prototype.draws = function () { return this.ops.slice(); };
  Viewport.prototype.model = function () { return this._model(); };
  Viewport.prototype.redraw = function () { this._resize(); this._draw(); };
  Viewport.prototype.destroy = function () {
    var d = global.document;
    this.scroller.removeEventListener('scroll', this._onScroll);
    this.scroller.removeEventListener('mousedown', this._onMouseDown);
    this.scroller.removeEventListener('dblclick', this._onDblClick);
    this.scroller.removeEventListener('keydown', this._onKeyDown);
    d.removeEventListener('mousemove', this._onMouseMove);
    d.removeEventListener('mouseup', this._onMouseUp);
    if (this.observer) this.observer.disconnect(); else global.removeEventListener('resize', this._onResize);
    if (this.ratioQuery) { try { this.ratioQuery.removeEventListener('change', this.ratioChange); } catch (e) { } }
    if (this.root.parentNode) this.root.parentNode.removeChild(this.root);
    this.listeners = {};
  };

  // The helpers a host or an oracle may want, beside the constructor.
  Viewport.readRecord = readRecord;
  Viewport.columnPixels = columnPixels;
  Viewport.parseRange = parseRange;
  Viewport.rangeText = rangeText;
  Viewport.colName = colName;
  Viewport.colIndex = colIndex;
  Viewport.RULES = RULES;
  Viewport.DEFAULT_COLORS = DEFAULT_COLORS;
  Viewport.version = 1;

  global.AlonzoViewport = Viewport;
})(typeof window !== 'undefined' ? window : this);

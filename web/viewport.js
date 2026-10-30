/*
  SPDX-FileCopyrightText: 2026 Spreadsheet Company
  SPDX-License-Identifier: Apache-2.0

  web/viewport.js - the viewport: the Screen device in grid mode (docs/SPEC.md,
  section 3.1), KERNEL.5 laid here. One window of a sheet drawn on a canvas
  from the view record alone, the lines `frazaro view` prints (the treaty's
  oracle 11): every sheet as a tab, the window's columns at the widths the
  record declares, the fills and number formats of its formats, each cell's
  text where the record puts it, and the gridlines when the record says so.
  The viewport computes nothing: a cell row shows its value as the reader
  spells it, a formula row shows its text until its value row lands
  (KERNEL.7) and its value after it, keeping the text for the bar; a look
  row maps a value to the format every cell holding it draws with, and a
  row row gives a row its height or hides it (docs/SPEC.md decision 19; both read
  since ENGINE.8, when the host began drawing a grid cartridge's Screen
  every frame); a format may hold a code of Excel's, which the viewport keeps
  and never applies, a text row after a cell's value giving the text the cell
  shows under it (KERNEL.47, read since CART.12); a number or a date too wide
  for its column shows #s across it and never a cut text (ENGINE.14); and an
  unknown row is counted, never refused. Since ENGINE.19 a host may lay a window's changes on the model it
  holds (patch), each named cell's entry read again as a load reads it, the
  model and the view kept; since ENGINE.20 the named cells alone are painted
  again, each with the span its text spills over and a neighbor's text that
  spills into it, by the full paint's own steps under a clip, the rest of the
  canvas kept. Since ENGINE.28 a format row's groups after its wrap are read
  as the loader reads them, a font, an alignment and a border (Frazaro's
  KERNEL.50, vla-lang 0.11.0), a look drawing a cell with what its format
  says over the cell's own property by property (Style::over); a text is
  drawn in its format's weight, slant, size and color, placed by its
  alignment and spilling by it, and a row with no set height is fitted to
  the tallest own size in it; a format's border draws its four edges as
  Excel draws its fourteen lines on a screen, a shared edge once, the
  heavier line winning, and a fill covers the gridlines around its cell, as
  Excel lays one.

  What the viewport owns is the state no program sees (SD-23): the scroll, the
  selection, the widths a person dragged, each sheet's its own as a
  spreadsheet keeps them (ENGINE.26), the frozen panes, the marks a host
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
  the image is crisp at the machine's pixel ratio (docs/SPEC.md section 1); the
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
  var MAX_COLUMNS = 16384;       // a sheet's columns, A to XFD, as Excel's
  var DEFAULT_COLUMN_PX = 64;    // Excel's default column, 8.43 characters of Calibri 11 at 96 DPI
  var DEFAULT_ROW_PX = 20;       // Excel's default row, 15 points
  var POINT_PX = 96 / 72;        // a row row's height is in points: at 96 dots an inch, 15 points are the default row
  var FONT_PX = 13;              // the benchmark's text size
  var FONT_FAMILY = 'system-ui, "Segoe UI", sans-serif';
  var TEXT_PAD_PX = 4;           // the padding inside a cell, left and right
  var MAX_DIGIT_WIDTH = 7;       // Calibri 11 at 96 DPI: ECMA-376 Part 1, section 18.3.1.13
  var ROW_HEADER_MIN_PX = 32;    // the row header's least width
  var ROW_HEADER_PAD_PX = 12;    // the row header's width is this plus a digit's width per digit
  var ROW_HEADER_DIGIT_PX = 7;
  var RESIZE_GRIP_PX = 4;        // how near a column boundary a press must be to resize it
  var LINE_HEIGHT = 1.2;         // a wrapped line's height, in font sizes
  var POINT_FONT_PX = FONT_PX / 11;   // a said size in points draws at this many pixels a point: the default text taken as 11 points (ENGINE.28)
  var FIT_PX = DEFAULT_ROW_PX / 11;   // a row with no set height fits its tallest own size by the default row's ratio, 20 px to 11 points (ENGINE.28)
  var OVERFLOW_LOOKBACK = 8;     // columns to look back, and since ENGINE.28 ahead, for a text that overflows into view
  var REPAINT_SHARE = 0.25;      // a patch naming more of the cells in view than this is painted whole (ENGINE.20)
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
    column: DEFAULT_COLUMN_PX, row: DEFAULT_ROW_PX, point: POINT_PX, font: FONT_PX, pad: TEXT_PAD_PX, digit: MAX_DIGIT_WIDTH,
    headerMin: ROW_HEADER_MIN_PX, headerPad: ROW_HEADER_PAD_PX, headerDigit: ROW_HEADER_DIGIT_PX, lineHeight: LINE_HEIGHT,
    pointFont: POINT_FONT_PX, fit: FIT_PX
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
    if (d.text !== undefined) return { kind: 'number', text: d.text, num: d.num };
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
  // A value as a look matches it (docs/SPEC.md decision 19, as ENGINE.8 reads it): a number by its value, so 7
  // and 7.0 are one value and so are 0 and -0, which the language spells apart in a cell row and a value
  // row; a text by its characters exactly; a truth value; an error by its name. Anything else, a date or a
  // value not computed, is matched by no look, and nor is an empty cell or a formula with no value.
  function lookKeyOf(d) {
    if (typeof d === 'string') return 't:' + d;
    if (d && d.num !== undefined) return 'n:' + String(d.num);
    if (d && d.sym === 'true') return 'b:true';
    if (d && d.sym === 'false') return 'b:false';
    if (Array.isArray(d) && d.length === 2 && d[0] && d[0].sym === 'error' && typeof d[1] === 'string') return 'e:' + d[1];
    return null;
  }
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
      looks: {}, rowSettings: {},
      // ENGINE.28: whether any format says a font or an alignment (styled) or a border (bordered), by which a record
      // that says neither keeps the paths it had; the formats drawn under a look, built once a pair; the rows a cell's
      // own size fits
      styled: false, bordered: false, drawn: new Map(), rowFits: {},
      filled: false,   // whether any format says a fill, by which a repaint grows its band over a fill's gridlines (decision 11)
      counts: { forms: 0, cells: 0, formulas: 0, values: 0, texts: 0, styles: 0, sentences: 0, looks: 0, rows: 0, unknown: 0, malformed: 0 },
      lines: 0, readMs: 0
    };
    m.formats[0] = { fill: null, num: 'general', code: null, wrap: false, font: null, align: null, border: null };
    var f, reach = { row: 0, col: 0 };
    while ((f = rd.readForm()) !== null) readRow(m, f, reach);
    // The sheet's scope: the window's range, or the cells' reach when the record holds no window row.
    if (m.window) { m.rows = m.window.bottom; m.cols = m.window.right; }
    else { m.rows = Math.max(1, reach.row); m.cols = Math.max(1, reach.col); }
    computeFits(m);
    m.lines = countLines(text);
    m.readMs = now() - t0;
    return m;
  }
  // The heads of a cell's rows, a bit each: an entry notes the rows read into it (rows), so that a patch takes back
  // exactly what they counted (ENGINE.19).
  var CELL_ROWS = { cell: 1, formula: 2, value: 4, style: 8, sentence: 16, text: 32 };
  // A formula cell the values projection prints by its value or its style alone, never by its text
  // (KERNEL.37): no value yet, no text for the bar; its value row, when one comes, gives it both.
  function formulaCell(m, a, reach) {
    var e = { row: a.row, col: a.col, address: colName(a.col) + a.row, kind: 'formula', vkind: 'formula', text: '', style: 0, sentence: 0, formula: '', valued: false, lookKey: null, rows: 0 };
    m.cells.set(cellKey(a.row, a.col), e);
    if (a.row > reach.row) reach.row = a.row;
    if (a.col > reach.col) reach.col = a.col;
    return e;
  }
  // One form of a record read into a model and counted (ENGINE.19: one reading of a row, readRecord's and a patch's
  // alike): a sheet's row into the model's tables, a cell's into its entry; reach, the farthest row and column a cell
  // stands at, the scope of a record with no window row.
  function readRow(m, f, reach) {
    m.counts.forms++;
    if (!Array.isArray(f) || f.length === 0 || !f[0] || f[0].sym === undefined) { m.counts.unknown++; return; }
    var head = f[0].sym, name, r, a, e;
    if (head === 'sheet') {
      name = strOf(f[1]);
      if (name === null) { m.counts.malformed++; return; }
      m.sheets.push({ name: name, state: symOf(f[2]) || 'visible' });
    } else if (head === 'window') {
      name = strOf(f[1]); r = parseRange(strOf(f[2]));
      if (name === null || !r || r.columns || r.rows) { m.counts.malformed++; return; }
      m.sheet = name; m.windowText = strOf(f[2]); m.window = r;
    } else if (head === 'extent') {
      name = strOf(f[1]);
      if (name === null) { m.counts.malformed++; return; }
      if (symOf(f[2]) === 'none') { m.extentText = 'none'; m.extent = null; return; }
      r = parseRange(strOf(f[2]));
      if (!r || r.columns || r.rows) { m.counts.malformed++; return; }
      m.extentText = strOf(f[2]); m.extent = r;
    } else if (head === 'gridlines') {
      var g = symOf(f[2]);
      if (g !== 'on' && g !== 'off') { m.counts.malformed++; return; }
      m.gridlines = (g === 'on');
    } else if (head === 'column') {
      var letters = strOf(f[2]);
      if (letters === null || !/^[A-Za-z]+$/.test(letters)) { m.counts.malformed++; return; }
      var width = numOf(f[3]);
      if (width === null && symOf(f[3]) !== 'none') { m.counts.malformed++; return; }
      var shown = symOf(f[4]);
      if (shown !== 'shown' && shown !== 'hidden') { m.counts.malformed++; return; }
      var cstyle = numOf(f[5]);
      if (cstyle === null && symOf(f[5]) !== 'none') { m.counts.malformed++; return; }
      var col = { letters: letters.toUpperCase(), index: colIndex(letters), width: width, hidden: shown === 'hidden', style: cstyle };
      m.columns[col.index] = col;
      m.columnList.push(col);
    } else if (head === 'format') {
      // the number format general, text, or a code of Excel's in quotes (KERNEL.47, read since CART.12), which the
      // viewport keeps and never applies: the record prints each cell's text under it in a text row
      var idx = numOf(f[1]), fill = strOf(f[2]), num = symOf(f[3]), code = strOf(f[3]), wrap = symOf(f[4]);
      if (idx === null || (fill === null && symOf(f[2]) !== 'none') || (num !== 'general' && num !== 'text' && code === null) || (wrap !== 'wrap' && wrap !== 'nowrap')) { m.counts.malformed++; return; }
      // the groups after the wrap, a font, an alignment and a border (ENGINE.28), each read as the loader reads it; a
      // row whose groups say what a format does not take is malformed, counted and dropped, never passed over
      var fmt = { fill: fill === null ? null : '#' + fill, num: code === null ? num : 'code', code: code, wrap: wrap === 'wrap', font: null, align: null, border: null };
      if (!readGroups(f, fmt)) { m.counts.malformed++; return; }
      if (fmt.font || fmt.align) m.styled = true;
      if (fmt.border) m.bordered = true;
      if (fmt.fill) m.filled = true;
      m.formats[idx] = fmt;
    } else if (head === 'cell' || head === 'formula') {
      a = parseA1(strOf(f[2]) || '');
      if (!a) { m.counts.malformed++; return; }
      var v = head === 'cell' ? valueOf(f[3]) : { kind: 'formula', text: strOf(f[3]) === null ? valueOf(f[3]).text : strOf(f[3]) };
      // text is what the cell shows; a formula keeps its own text for the bar, and has a value once its value row lands
      m.cells.set(cellKey(a.row, a.col), { row: a.row, col: a.col, address: colName(a.col) + a.row, kind: head, vkind: v.kind, text: v.text, style: 0, sentence: 0,
                                           formula: head === 'formula' ? v.text : '', valued: head === 'cell', lookKey: head === 'cell' ? lookKeyOf(f[3]) : null, rows: CELL_ROWS[head] });
      if (a.row > reach.row) reach.row = a.row;
      if (a.col > reach.col) reach.col = a.col;
      if (head === 'cell') m.counts.cells++; else m.counts.formulas++;
    } else if (head === 'value') {
      // a formula's computed value (KERNEL.7's row, drawn since ENGINE.8): the cell shows it, aligned by its
      // kind, and matches a look by it. In the values projection (KERNEL.37, ENGINE.8's second slice) no formula
      // row comes before it, and the cell is a formula known by its value alone, its text not in the record;
      // a value row for a value cell is malformed
      a = parseA1(strOf(f[2]) || '');
      e = a ? m.cells.get(cellKey(a.row, a.col)) : null;
      if (a && !e && f.length >= 4) e = formulaCell(m, a, reach);
      if (!e || e.kind !== 'formula' || f.length < 4) { m.counts.malformed++; return; }
      var vv = valueOf(f[3]);
      e.text = vv.text; e.vkind = vv.kind; e.valued = true; e.lookKey = lookKeyOf(f[3]); e.rows |= CELL_ROWS.value;
      m.counts.values++;
    } else if (head === 'text') {
      // the text a value draws under its format's code (KERNEL.47, drawn since CART.12), after the cell's value row
      // or its formula's: the cell shows it, aligned and matched to a look by its value, which it keeps as the record
      // spells it for the bar; a text row for a cell with no value, or a second one, is malformed
      a = parseA1(strOf(f[2]) || '');
      e = a ? m.cells.get(cellKey(a.row, a.col)) : null;
      var drawn = strOf(f[3]);
      if (!e || !e.valued || drawn === null || (e.rows & CELL_ROWS.text)) { m.counts.malformed++; return; }
      e.value = e.text; e.text = drawn; e.rows |= CELL_ROWS.text;
      m.counts.texts++;
    } else if (head === 'look') {
      // the look map (docs/SPEC.md decision 19): every cell whose value is the look's draws with its format in
      // place of its own; of two looks a value matches, the first the record holds
      var lk = lookKeyOf(f[2]), li = numOf(f[3]);
      if (strOf(f[1]) === null || lk === null || li === null || li < 0 || Math.floor(li) !== li) { m.counts.malformed++; return; }
      if (!Object.prototype.hasOwnProperty.call(m.looks, lk)) m.looks[lk] = li;
      m.counts.looks++;
    } else if (head === 'row') {
      // a row's settings (docs/SPEC.md decision 19), the column row's twin: its height in points or none, shown or hidden
      var rn = numOf(f[2]), rh = numOf(f[3]), rs = symOf(f[4]);
      if (strOf(f[1]) === null || rn === null || rn < 1 || Math.floor(rn) !== rn || (rh === null && symOf(f[3]) !== 'none') || (rh !== null && rh < 0) || (rs !== 'shown' && rs !== 'hidden')) { m.counts.malformed++; return; }
      m.rowSettings[rn] = { height: rh, hidden: rs === 'hidden' };
      m.counts.rows++;
    } else if (head === 'style' || head === 'sentence') {
      // with no row before it, in the values projection, a formula with no value yet: drawn empty, styled
      a = parseA1(strOf(f[2]) || '');
      var n = numOf(f[3]);
      e = a ? m.cells.get(cellKey(a.row, a.col)) : null;
      if (a && !e && n !== null) e = formulaCell(m, a, reach);
      if (!a || n === null || !e) { m.counts.malformed++; return; }
      e[head] = n; e.rows |= CELL_ROWS[head];
      if (head === 'style') m.counts.styles++; else m.counts.sentences++;
    } else {
      m.counts.unknown++;
    }
  }
  // An entry's rows taken back from its model's counts and lines, the entry removed (ENGINE.19, a patch): one form
  // and one line a row, as the language prints a record, each counted by its head.
  function unread(m, e) {
    var n = 0;
    for (var head in CELL_ROWS) {
      if (!(e.rows & CELL_ROWS[head])) continue;
      n++;
      m.counts[head === 'cell' ? 'cells' : head === 'formula' ? 'formulas' : head === 'value' ? 'values' : head === 'text' ? 'texts' : head === 'style' ? 'styles' : 'sentences']--;
    }
    m.counts.forms -= n; m.lines -= n;
    m.cells.delete(cellKey(e.row, e.col));
  }

  // The forms of a text, each a datum as the reader reads it: a list (an
  // array), a string, a number ({ num, text }) or a symbol ({ sym }); a
  // comment is skipped. The host's one reader (web/host.js, ENGINE.1): the
  // rows the engine's four calls answer, and the cells of a device sheet's
  // record with its value rows, which readRecord counts and does not keep.
  function readForms(text) {
    var rd = new Reader(String(text || '')), out = [], f;
    while ((f = rd.readForm()) !== null) out.push(f);
    return out;
  }

  // ---- (2) the geometry: the layout in device pixels ----
  // env: { dpr, canvasW, canvasH } in device pixels and { clientW, clientH }
  // in CSS pixels, the scroller's client area, and the widths of the sheet
  // drawn, its own (ENGINE.26). state: the host's state.
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
    this.fonts = {};   // a font string a format's weight, slant and pixels (ENGINE.28), built once each
    // The rows with settings of their own (ENGINE.8): a height in points turned into whole CSS pixels and then
    // device pixels, as a column's width is, or 0 for a hidden row; kept sorted with the running difference
    // from the default above each, so that a row's top is the default arithmetic corrected by the rows with
    // settings above it, and a window a million rows down costs a search of the few rows that have any.
    var rs = [], heights = {}, layout = env.layout || null, self = this;
    function settle(key, st) {
      var h = st.hidden ? 0 : (st.height === null ? self.rowH : Math.round(Math.round(st.height * POINT_PX) * dpr));
      rs.push({ n: +key, h: h });
      heights[+key] = h;
    }
    if (model && model.rowSettings) {
      for (var key in model.rowSettings) {
        if (Object.prototype.hasOwnProperty.call(model.rowSettings, key)) settle(key, model.rowSettings[key]);
      }
    }
    // A row past the record's window the record does not answer for: as the sheet's records have set it, learned
    // (CART.12's hand test), else the default.
    if (layout) {
      for (var lk in layout.rows) {
        if (!Object.prototype.hasOwnProperty.call(layout.rows, lk) || heights[+lk] !== undefined || inWindowRow(model, +lk)) continue;
        settle(lk, layout.rows[lk]);
      }
    }
    // A row with no set height fits the tallest size its cells' own formats say (ENGINE.28, decision 7), a CSS height
    // the model found, turned into device pixels as a set height is.
    if (model && model.rowFits) {
      for (var fk in model.rowFits) {
        if (!Object.prototype.hasOwnProperty.call(model.rowFits, fk) || heights[+fk] !== undefined) continue;
        var fh = Math.round(model.rowFits[fk] * dpr);
        rs.push({ n: +fk, h: fh });
        heights[+fk] = fh;
      }
    }
    rs.sort(function (p, q) { return p.n - q.n; });
    this.rs = rs; this.heights = heights; this.rsDelta = [0];
    for (var i = 0; i < rs.length; i++) this.rsDelta.push(this.rsDelta[i] + rs[i].h - this.rowH);
    var rows = model ? model.rows : 1, cols = model ? model.cols : 1;
    // A bound sheet (version 6's (bound "<sheet>"), CART.12's hand test) is its extent and no more: its last row and
    // column the grid's, no slack after them, so a board's edge is the grid's.
    var extent = env.bound ? ((model && model.extent) || (layout && layout.extent) || null) : null;
    if (extent) {
      this.sheetRows = extent.bottom; this.sheetCols = extent.right;
      this.rows = extent.bottom; this.cols = extent.right;
    } else {
      // The sheet space is never less than a screen: a screen of slack rows and
      // columns follows the window, so the scroll reaches past the last cell. The
      // columns' slack is a screen's width of them as the sheet lays them, so that a
      // sheet of narrow columns has a screen of them too (CART.12's hand test).
      this.sheetRows = rows; this.sheetCols = cols;
      this.rows = rows + Math.ceil(env.clientH / DEFAULT_ROW_PX) + 1;
      var slackW = 0, slack = 0, screenW = env.clientW * dpr;
      while (slackW < screenW && cols + slack < MAX_COLUMNS) { slack++; slackW += Math.round(columnWidthCss(model, env.widths, cols + slack, layout) * dpr); }
      this.cols = Math.min(MAX_COLUMNS, cols + slack + 1);
    }
    this.bounded = !!extent;
    this.digits = String(this.rows).length;
    this.rhW = Math.round(Math.max(ROW_HEADER_MIN_PX, ROW_HEADER_PAD_PX + ROW_HEADER_DIGIT_PX * this.digits) * dpr);
    this.colW = [0]; this.colX = [0, 0];
    var x = 0;
    for (var c = 1; c <= this.cols; c++) {
      var w = Math.round(columnWidthCss(model, env.widths, c, layout) * dpr);
      this.colW.push(w); x += w; this.colX.push(x);
    }
    this.contentW = x;
    this.contentH = this.rowTop(this.rows + 1);
    this.fr = Math.max(0, Math.min(state.frozenRows, this.rows - 1));
    this.fc = Math.max(0, Math.min(state.frozenCols, this.cols - 1));
    this.frozenH = this.rowTop(this.fr + 1);
    this.frozenW = this.colX[this.fc + 1];
    this.ox = this.rhW; this.oy = this.headH;
  }
  // A column's width in CSS pixels: the width a person dragged or a host set
  // on the sheet, from that sheet's own widths (ENGINE.26), else hidden is 0,
  // else the record's width through the rule, else, for a column past the
  // record's window, which the record does not answer for, the width the
  // sheet's records have set, learned (CART.12's hand test), else the default.
  function columnWidthCss(model, widths, c, layout) {
    var letters = colName(c);
    if (widths && Object.prototype.hasOwnProperty.call(widths, letters)) return widths[letters];
    var col = model ? model.columns[c] : null;
    if (!col && layout && !inWindowColumn(model, c)) col = layout.columns[c] || null;
    if (col) {
      if (col.hidden) return 0;
      if (col.width !== null) return columnPixels(col.width);
    }
    return DEFAULT_COLUMN_PX;
  }
  // Whether a record answers for a column or a row: inside its window, or anywhere for a record with no window,
  // the whole sheet.
  function inWindowColumn(model, c) { return !!model && (!model.window || (c >= model.window.left && c <= model.window.right)); }
  function inWindowRow(model, r) { return !!model && (!model.window || (r >= model.window.top && r <= model.window.bottom)); }
  // A sheet's layout (CART.12's hand test): the columns and the rows with settings, and the extent, learned from a
  // record a host reads before it shows the sheet, its columns whole (learn). The record answers for its window, a
  // column or a row there that it names set and one it does not name set back to the default. So that a column past
  // the window the sheet shown was viewed through is laid as the sheet sets it and not at the default, and the cells
  // under the scroll stay where they are when a record of another window is loaded.
  function learnLayout(layout, model) {
    var w = model.window, key, c, r;
    if (w) {
      for (c = w.left; c <= w.right; c++) { if (model.columns[c]) layout.columns[c] = model.columns[c]; else delete layout.columns[c]; }
      for (key in layout.rows) if (Object.prototype.hasOwnProperty.call(layout.rows, key) && +key >= w.top && +key <= w.bottom && !model.rowSettings[key]) delete layout.rows[key];
    } else {
      for (key in model.columns) if (Object.prototype.hasOwnProperty.call(model.columns, key)) layout.columns[key] = model.columns[key];
    }
    for (key in model.rowSettings) if (Object.prototype.hasOwnProperty.call(model.rowSettings, key)) layout.rows[key] = model.rowSettings[key];
    if (model.extentText === 'none') layout.extent = null;
    else if (model.extent) layout.extent = model.extent;
  }
  // A row's top in content coordinates, and its height, 0 when hidden.
  Geometry.prototype.rowTop = function (r) {
    var rs = this.rs;
    if (!rs.length) return (r - 1) * this.rowH;
    var lo = 0, hi = rs.length;   // the count of rows with settings above r
    while (lo < hi) { var mid = (lo + hi) >> 1; if (rs[mid].n < r) lo = mid + 1; else hi = mid; }
    return (r - 1) * this.rowH + this.rsDelta[lo];
  };
  Geometry.prototype.rowHeight = function (r) { var h = this.heights[r]; return h === undefined ? this.rowH : h; };
  // A format's text in device pixels (ENGINE.28, decision 3): a said size of s points at round(s × 13/11 × dpr), the
  // default text taken as 11 points, so that a said 11 draws as an unsized text and 22 at twice it; unsized, the default.
  Geometry.prototype.sizeOf = function (fmt) { return fmt.font && fmt.font.size !== null ? Math.round(fmt.font.size / 20 * POINT_FONT_PX * this.dpr) : this.fontPx; };
  // A wrapped line's height under a format: its size's.
  Geometry.prototype.lineHOf = function (fmt) { return fmt.font && fmt.font.size !== null ? Math.round(fmt.font.size / 20 * POINT_FONT_PX * LINE_HEIGHT * this.dpr) : this.lineH; };
  // The canvas font a format's text is drawn in: its slant and its weight before its pixels and the family, one string
  // a kind, built once; a format saying no font draws in the default.
  Geometry.prototype.fontOf = function (fmt) {
    var f = fmt.font;
    if (!f) return this.font;
    var px = this.sizeOf(fmt), key = (f.italic ? 'i' : '') + (f.bold ? 'b' : '') + px, s = this.fonts[key];
    if (!s) s = this.fonts[key] = (f.italic ? 'italic ' : '') + (f.bold ? 'bold ' : '') + px + 'px ' + FONT_FAMILY;
    return s;
  };
  // The first column whose right edge is past x (content coordinates), from c0.
  Geometry.prototype.columnAt = function (x, c0) {
    var c = Math.max(1, c0 || 1);
    while (c <= this.cols && this.colX[c + 1] <= x) c++;
    return c;
  };
  // The row a content y falls in, from r0: the last row whose top is at or above y, so that a hidden row,
  // whose top is the next row's, is never the answer.
  Geometry.prototype.rowAt = function (y, r0) {
    var lo = Math.max(1, r0 || 1);
    if (!this.rs.length) return Math.max(lo, Math.floor(y / this.rowH) + 1);
    var hi = Math.max(lo, this.rows);
    if (this.rowTop(lo) > y) return lo;
    while (lo < hi) { var mid = Math.floor((lo + hi + 1) / 2); if (this.rowTop(mid) <= y) lo = mid; else hi = mid - 1; }
    return lo;
  };
  // ---- a format's appearance (ENGINE.28): the groups after a format row's wrap, read as the loader reads them ----
  // (font bold|not-bold italic|not-italic <points> "<RRGGBB>"), (align general|left|center|right top|middle|bottom) and
  // (border (left <line> ["<RRGGBB>"]) (right ...) (top ...) (bottom ...)), each group and each property at most once,
  // in any order; a size a whole number of twentieths of a point from 1 to 409.55, as vla-lang's FontSize reads one; a
  // line one of Excel's fourteen, none taking no color. A property unsaid is null. A row whose groups say anything
  // else is malformed (decision 1).
  var LINE_NAMES = ['none', 'thin', 'medium', 'thick', 'double', 'hair', 'dotted', 'dashed', 'dash-dot', 'dash-dot-dot', 'medium-dashed', 'medium-dash-dot', 'medium-dash-dot-dot', 'slant-dash-dot'];
  // The lines as Excel draws them on a screen (ENGINE.28, decision 8, measured at the approval from the owner's
  // screenshots of Excel 365 at 100% on a display at 150%), in device pixels at every ratio, as a gridline is one at
  // every ratio: each line its strands across the edge, a strand's offset from the gridline's own pixel toward the right
  // or lower cell and, for a pattern, its mask over a period of device pixels, 1 drawn and 0 a gap, phased on the
  // sheet's coordinate and never on the edge's start; slant-dash-dot's gaps lean, the outer strand keeping a gap's
  // first two pixels and the inner its third. And its rank for a shared edge (decision 9, held by the probe workbook's
  // pairs): the wider line wins, a double over a thick, at one width a solid line over a patterned one.
  var LINES = {
    'thin': { rank: 11, strands: [[0, null]] },
    'medium': { rank: 21, strands: [[-1, null], [0, null]] },
    'thick': { rank: 31, strands: [[-1, null], [0, null], [1, null]] },
    'double': { rank: 41, strands: [[-1, null], [1, null]] },
    'hair': { rank: 10, strands: [[0, '10']] },
    'dotted': { rank: 10, strands: [[0, '1100']] },
    'dashed': { rank: 10, strands: [[0, '1110']] },
    'dash-dot': { rank: 10, strands: [[0, '111111111000111000']] },
    'dash-dot-dot': { rank: 10, strands: [[0, '111111111000111000111000']] },
    'medium-dashed': { rank: 20, strands: [[-1, '111111111000'], [0, '111111111000']] },
    'medium-dash-dot': { rank: 20, strands: [[-1, '111111111000111000'], [0, '111111111000111000']] },
    'medium-dash-dot-dot': { rank: 20, strands: [[-1, '111111111000111000111000'], [0, '111111111000111000111000']] },
    'slant-dash-dot': { rank: 20, strands: [[-1, '111111111110111110'], [0, '111111111001111001']] }
  };
  var EDGE_INK = '#000000';   // an edge said with no color: Excel's automatic, black
  // the lines that leave the gridline's own pixel bare in places, a double's middle and a pattern's gaps, where the edge
  // pass shows the fill there or the background
  var BARE = {};
  // and each line's strands as the passes that draw them, adjacent strands of one mask a band as thick as they are, so
  // that a medium or a thick edge is one rectangle and a medium pattern's two strands one pass
  var PASSES = {};
  Object.keys(LINES).forEach(function (n) {
    var s = LINES[n].strands, zero = null, passes = [], k, last;
    for (k = 0; k < s.length; k++) if (s[k][0] === 0) zero = s[k];
    BARE[n] = zero === null || zero[1] !== null;
    for (k = 0; k < s.length; k++) {
      last = passes[passes.length - 1];
      if (last && last.mask === s[k][1] && last.off + last.thick === s[k][0]) last.thick++;
      else passes.push({ off: s[k][0], thick: 1, mask: s[k][1] });
    }
    PASSES[n] = passes;
  });
  // The nearest column or row shown after i, and before it (ENGINE.28's hand test): a hidden column or row, of no width
  // or height, takes no part in an edge and its cells' own edges are never drawn, so the edge between two cells drawn
  // side by side is the one their facing sides make, whatever hidden ones lie between them. size(k) is a column's width
  // or a row's height and last the grid's last; 0 is the sheet's edge before the first.
  function shownAfter(size, i, last) { var k = i + 1; while (k <= last && size(k) === 0) k++; return k; }
  function shownBefore(size, i) { var k = i - 1; while (k >= 1 && size(k) === 0) k--; return Math.max(k, 0); }
  function hexColor(d) {
    var s = strOf(d);
    return s !== null && /^[0-9A-Fa-f]{6}$/.test(s) ? '#' + s.toUpperCase() : null;
  }
  // A size as the record spells it, in twentieths of a point: digits, then a point and one or two more at most, read
  // exactly in hundredths, taken only where it is a whole number of twentieths within 1 to 409.55; null otherwise.
  function twentiethsOf(d) {
    var t = d && d.text !== undefined ? d.text : null;
    if (t === null || !/^\d{1,3}(\.\d{1,2})?$/.test(t)) return null;
    var parts = t.split('.'), hundredths = parseInt(parts[0], 10) * 100 + (parts.length > 1 ? parseInt((parts[1] + '0').slice(0, 2), 10) : 0);
    if (hundredths % 5 !== 0) return null;
    var n = hundredths / 5;
    return n >= 20 && n <= 8191 ? n : null;
  }
  function readFont(items) {
    if (!items.length) return null;
    var font = { bold: null, italic: null, size: null, color: null };
    for (var i = 0; i < items.length; i++) {
      var d = items[i], w = symOf(d);
      if (w === 'bold' || w === 'not-bold') { if (font.bold !== null) return null; font.bold = w === 'bold'; }
      else if (w === 'italic' || w === 'not-italic') { if (font.italic !== null) return null; font.italic = w === 'italic'; }
      else if (d && d.num !== undefined) { var n = twentiethsOf(d); if (n === null || font.size !== null) return null; font.size = n; }
      else if (typeof d === 'string') { var col = hexColor(d); if (col === null || font.color !== null) return null; font.color = col; }
      else return null;
    }
    return font;
  }
  function readAlign(items) {
    if (!items.length) return null;
    var align = { h: null, v: null };
    for (var i = 0; i < items.length; i++) {
      var w = symOf(items[i]);
      if (w === 'general' || w === 'left' || w === 'center' || w === 'right') { if (align.h !== null) return null; align.h = w; }
      else if (w === 'top' || w === 'middle' || w === 'bottom') { if (align.v !== null) return null; align.v = w; }
      else return null;
    }
    return align;
  }
  function readBorder(items) {
    if (!items.length) return null;
    var border = { left: null, right: null, top: null, bottom: null };
    for (var i = 0; i < items.length; i++) {
      var e = items[i];
      if (!Array.isArray(e) || e.length < 2 || e.length > 3) return null;
      var side = symOf(e[0]), line = symOf(e[1]), color = null;
      if (side === null || !Object.prototype.hasOwnProperty.call(border, side) || border[side] !== null || line === null || LINE_NAMES.indexOf(line) < 0) return null;
      if (e.length === 3) { if (line === 'none') return null; color = hexColor(e[2]); if (color === null) return null; }
      border[side] = { line: line, color: color };
    }
    return border;
  }
  // The groups from a format row's fifth item on, read into the format; false where the row is malformed.
  function readGroups(f, fmt) {
    for (var i = 5; i < f.length; i++) {
      var gp = f[i];
      if (!Array.isArray(gp) || gp.length === 0) return false;
      var head = symOf(gp[0]), items = gp.slice(1);
      if (head === 'font') { if (fmt.font !== null) return false; fmt.font = readFont(items); if (fmt.font === null) return false; }
      else if (head === 'align') { if (fmt.align !== null) return false; fmt.align = readAlign(items); if (fmt.align === null) return false; }
      else if (head === 'border') { if (fmt.border !== null) return false; fmt.border = readBorder(items); if (fmt.border === null) return false; }
      else return false;
    }
    return true;
  }
  function pick(a, b) { return a !== null && a !== undefined ? a : (b !== null && b !== undefined ? b : null); }
  // The format a cell draws with under a look (decision 2; vla-lang's Style::over): the look's fill, number format and
  // wrap in place of the cell's own, as before ENGINE.28, and, property by property, the look's weight, slant, size,
  // color, horizontal and vertical alignment and each edge where the look says one, else the cell's own format's. A
  // said default, not-bold, not-italic, general, bottom or an edge's none, is said, and takes the cell's own back.
  function over(look, own) {
    var f = { fill: look.fill, num: look.num, code: look.code, wrap: look.wrap, font: null, align: null, border: null };
    if (look.font || own.font) {
      var lf = look.font || {}, of = own.font || {};
      f.font = { bold: pick(lf.bold, of.bold), italic: pick(lf.italic, of.italic), size: pick(lf.size, of.size), color: pick(lf.color, of.color) };
    }
    if (look.align || own.align) { var la = look.align || {}, oa = own.align || {}; f.align = { h: pick(la.h, oa.h), v: pick(la.v, oa.v) }; }
    if (look.border || own.border) { var lb = look.border || {}, ob = own.border || {}; f.border = { left: pick(lb.left, ob.left), right: pick(lb.right, ob.right), top: pick(lb.top, ob.top), bottom: pick(lb.bottom, ob.bottom) }; }
    return f;
  }
  // The rows a cell's own format fits (decision 7): for each row, the tallest size a style row's format says among its
  // cells, as the height in CSS pixels the default row's ratio gives it, 20 to 11 points, kept where it is more than
  // the default row's; a look's size never moves a row, nor does a column's format. Nothing where no format says a font.
  function fitPx(twentieths) { return Math.round(twentieths / 20 * FIT_PX); }
  function computeFits(m) {
    var fits = {};
    if (m.styled) {
      m.cells.forEach(function (e) {
        if (e.style === 0) return;
        var f = m.formats[e.style];
        if (!f || !f.font || f.font.size === null) return;
        var px = fitPx(f.font.size);
        if (px > DEFAULT_ROW_PX && (fits[e.row] === undefined || px > fits[e.row])) fits[e.row] = px;
      });
    }
    m.rowFits = fits;
  }

  // The formats of a cell: its look's, when its value is a look's (docs/SPEC.md decision 19), in place of its
  // own, since ENGINE.28 what the look says over the cell's own (over); else the cell's own; else, for an empty cell,
  // its column's; else format 0.
  function formatOf(model, cell, c) {
    if (cell && cell.lookKey !== null && Object.prototype.hasOwnProperty.call(model.looks, cell.lookKey)) {
      var li = model.looks[cell.lookKey], lf = model.formats[li];
      if (lf) {
        // the look's format whole where no format of the record says a group, as before ENGINE.28; else the format drawn
        // under it, built once a pair of look and own and kept on the model
        if (!model.styled && !model.bordered) return lf;
        var oi = cell.style !== 0 && model.formats[cell.style] ? cell.style : 0, key = li + ',' + oi, d = model.drawn.get(key);
        if (!d) { d = over(lf, model.formats[oi]); model.drawn.set(key, d); }
        return d;
      }
    }
    if (cell && cell.style !== 0 && model.formats[cell.style]) return model.formats[cell.style];
    if (!cell) {
      var col = model.columns[c];
      if (col && col.style !== null && model.formats[col.style]) return model.formats[col.style];
    }
    return model.formats[0];
  }
  // Where a value sits in its cell: as its format says, where it says left, center or right (ENGINE.28); else, under
  // general and unsaid, as Excel aligns it under General, and everything left under a text format.
  function alignOf(cell, fmt) {
    if (fmt.align && fmt.align.h !== null && fmt.align.h !== 'general') return fmt.align.h;
    if (fmt.num === 'text') return 'left';
    if (cell.vkind === 'number' || cell.vkind === 'date') return 'right';
    if (cell.vkind === 'bool' || cell.vkind === 'error') return 'center';
    return 'left';
  }
  // What a number or a date shows when its text, with the padding on both sides, is wider than its
  // column: as many # as fit between the paddings, at least one, as Excel fills a cell under a fixed
  // number format (ENGINE.14; KERNEL.5's decision 7 had clipped it, so a number lost its leading
  // digits). Never wrapped, never cut, and never respelled: the text is the record's, a code's
  // text row's where it holds one (CART.12), and the viewport applies no number format of its
  // own. Null when the text fits, or is no number.
  function hashesOf(ctx, cell, fmt, w, pad) {
    if (fmt.num === 'text' || (cell.vkind !== 'number' && cell.vkind !== 'date')) return null;
    if (ctx.measureText(cell.text).width + 2 * pad <= w) return null;
    var n = Math.max(1, Math.floor((w - 2 * pad) / ctx.measureText('#').width));
    return new Array(n + 1).join('#');
  }

  // ---- (3) the painter ----
  function Painter(ctx, colors) { this.ctx = ctx; this.colors = colors; this.ops = []; }
  Painter.prototype.fillRect = function (x, y, w, h, color, op) {
    this.ctx.fillStyle = color;
    this.ctx.fillRect(x, y, w, h);
    if (op) { op.x = x; op.y = y; op.w = w; op.h = h; op.color = color; this.ops.push(op); }
  };
  // Lines a device pixel wide, each across or down at an integer plus a half. In an opaque color each is filled as a
  // rectangle a pixel wide, which every rasterizer covers exactly (ENGINE.20): Chrome's CPU rasterizer strokes a long
  // line a few pixels short of covered, and otherwise under another clip, so a repaint's few lines would not paint the
  // full paint's pixels. In a color with alpha they are stroked as one path, as before, so that a crossing blends once.
  Painter.prototype.lines = function (segments, color, kind) {
    var ctx = this.ctx;
    ctx.fillStyle = color;
    var opaque = String(ctx.fillStyle).charAt(0) === '#';
    if (!opaque) { ctx.strokeStyle = color; ctx.lineWidth = 1; ctx.beginPath(); }
    for (var i = 0; i < segments.length; i++) {
      var s = segments[i];
      if (!opaque) { ctx.moveTo(s[0], s[1]); ctx.lineTo(s[2], s[3]); }
      else if (s[0] === s[2]) ctx.fillRect(s[0] - 0.5, s[1], 1, s[3] - s[1]);
      else ctx.fillRect(s[0], s[1] - 0.5, s[2] - s[0], 1);
      this.ops.push({ op: 'line', kind: kind, x1: s[0], y1: s[1], x2: s[2], y2: s[3], color: color });
    }
    if (!opaque) ctx.stroke();
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
  // A painter that paints nothing (ENGINE.20): a cell's paint run through it keeps the ops the full paint would draw,
  // so that a repaint finds where a text lies, its spill with it, by the full paint's own code.
  function Tracer(ctx) { this.ctx = ctx; this.ops = []; }
  Tracer.prototype.text = function (text, x, y, align, color, clip, op) {
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
    this.layouts = {};         // a sheet's name, lowercased -> its layout, learned from its records (CART.12's hand test)
    this.bounds = {};          // a sheet's name, lowercased -> true: drawn to its extent and no further (version 6's bound)
    this.widths = {};          // a sheet's name, lowercased -> its column's letters -> CSS pixels: the widths a person dragged on it or a host set (ENGINE.26)
    this.patchCount = 0;       // the patches laid on its models (ENGINE.19)
    this.repaintCount = 0;     // the patches painted by their cells alone (ENGINE.20)
    // The last full paint (ENGINE.20): the model and the environment it painted, its quadrants as it left them, the cells
    // in view, and the cells a repaint drew since, by quadrant, which stand in its draw list in place of its own.
    this.painted = null; this.quads = []; this.inView = 0; this.over = null;
    // A context the CPU rasterizes from the first paint (ENGINE.20): for a page that reads the pixels back, an oracle,
    // since Chrome moves a GPU canvas read back often to the CPU midway, whose text it rasterizes otherwise.
    this.readback = !!options.willReadFrequently;
    this.sheetList = [];       // every sheet row of the latest record, in tab order
    this.active = '';          // the sheet shown
    this.state = { frozenRows: 0, frozenCols: 0, marks: {}, showHidden: !!options.showHidden,
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
    // the strip wraps onto a further row when its tabs outrun the box, so that no tab lies past the edge
    // and a narrow viewport never scrolls its page sideways (ENGINE.14's hand test: Sand's twelve tabs in a drawer)
    tabs.style.cssText = 'flex:none;display:flex;flex-wrap:wrap;align-items:center;gap:2px;padding:3px 4px;background:' + this.colors.tabBackground + ';border-top:1px solid ' + this.colors.gridline + ';font:12px system-ui, "Segoe UI", sans-serif;color:' + this.colors.headerText + ';min-height:22px;';
    root.appendChild(box);
    root.appendChild(tabs);
    element.appendChild(root);
    this.ctx = canvas.getContext('2d', { willReadFrequently: this.readback });
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
    var key = String(this.active || '').toLowerCase();
    return { dpr: this.dpr, canvasW: this.canvas.width, canvasH: this.canvas.height, clientW: this.scroller.clientWidth, clientH: this.scroller.clientHeight,
             layout: this.layouts[key] || null, bound: !!this.bounds[key], widths: this._widthsOf(this.active) };
  };
  Viewport.prototype._layoutOf = function (name) {
    var key = String(name || '').toLowerCase();
    return this.layouts[key] || (this.layouts[key] = { columns: {}, rows: {}, extent: null });
  };
  // A sheet's widths (ENGINE.26): the widths a person dragged on it and those a host set, a column's letters to CSS pixels,
  // the sheet's alone, found by its name compared without case as its layout is, so that one sheet's column D is never
  // another's (Buffet's PLATE.1 and POT.11 hand tests, where a drag of D on one view widened D on every view).
  Viewport.prototype._widthsOf = function (name) {
    var key = String(name || '').toLowerCase();
    return this.widths[key] || (this.widths[key] = {});
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
    // a resize changes the region shown as a scroll does (CART.12's hand test: full screen showed columns no record
    // named until a scroll), so the host is told as it is told of a scroll
    this._onResize = function () { self._resize(); self._draw(); self._emit('scroll', self._scrollPayload()); };
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
      self._resize(); self._draw(); self._emit('scroll', self._scrollPayload());
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
    this.quads = []; this.over = null;   // the quadrants this paint leaves, and no repaint over it yet (ENGINE.20)
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.clearRect(0, 0, W, H);
    // A bound sheet stands on a canvas in the headers' gray, past its last column and its last row, where there is no
    // row and no column (CART.14's hand test, 2026-10-19); its cells lay the background over it (_paintQuadrant).
    ctx.fillStyle = g.bounded ? this.colors.header : this.colors.background;
    ctx.fillRect(0, 0, W, H);
    ctx.font = g.font; p.font = g.font;   // the painter notes the font set, so that a cell's is set only when it differs (ENGINE.28)
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
    var seps = separators(g, W, H);
    if (seps.length) p.lines(seps, this.colors.frozenLine, 'frozen');
    if (p.font !== g.font) { ctx.font = g.font; p.font = g.font; }   // the headers in the default font, whatever the last cell's
    this._paintHeaders(p, g, sx, sy, W, H);
    this.ops = p.ops;
    this.inView = 0;
    for (var i = 0; i < this.quads.length; i++) { var q = this.quads[i]; this.inView += (q.rowEnd - q.rowStart + 1) * (q.colEnd - q.colStart + 1); }
    this.painted = { model: model, env: env };
  };
  // The frozen separators: a line under the frozen rows and one right of the frozen columns, across the canvas.
  function separators(g, W, H) {
    var seps = [], fx = g.ox + g.frozenW, fy = g.oy + g.frozenH;
    if (g.fr > 0) seps.push([g.ox, fy - 0.5, W, fy - 0.5]);
    if (g.fc > 0) seps.push([fx - 0.5, g.oy, fx - 0.5, H]);
    return seps;
  }

  // One quadrant: the cells of rows r1..r2 and columns c1..c2 drawn at the
  // content position less the quadrant's scroll, clipped to its rectangle.
  // A full paint notes each quadrant as it leaves it (ENGINE.20): its rows and columns in view, and where its fills,
  // its gridlines, its texts and its ranges begin in the draw list. A repaint passes part, { row, left, right }: the
  // same steps over that row's columns left to right alone, under the clip the repaint has set.
  Viewport.prototype._paintQuadrant = function (p, model, g, clip, r1, r2, c1, c2, sx, sy, name, part) {
    var self = this, colors = this.colors;
    var ox = g.ox, oy = g.oy, rh;
    if (clip.w <= 0 || clip.h <= 0) return;
    // the visible rows and columns of the quadrant
    var rowStart = Math.max(r1, g.rowAt(clip.y - oy + sy, r1));
    var rowEnd = Math.min(r2, g.rowAt(clip.y + clip.h - 1 - oy + sy, r1));
    var colStart = Math.max(c1, g.columnAt(clip.x - ox + sx, c1));
    var colEnd = Math.min(c2, g.columnAt(clip.x + clip.w - 1 - ox + sx, c1));
    if (rowStart > rowEnd || colStart > colEnd) return;
    var q = null;
    if (part) { rowStart = part.top; rowEnd = part.bottom; colStart = part.left; colEnd = part.right; }
    else this.quads.push(q = { index: this.quads.length, name: name, clip: clip, r1: r1, r2: r2, c1: c1, c2: c2, sx: sx, sy: sy, rowStart: rowStart, rowEnd: rowEnd, colStart: colStart, colEnd: colEnd });
    var r, c, cell, x, y, w;
    // the rectangle of the cells in view: a bound sheet's lines end at its edges (CART.14's hand test), any other's
    // cross the quadrant
    var cellsX = ox + g.colX[colStart] - sx, cellsY = oy + g.rowTop(rowStart) - sy;
    var cellsR = ox + g.colX[colEnd + 1] - sx, cellsB = oy + g.rowTop(rowEnd + 1) - sy;
    p.clipped(clip, function () {
      // a bound sheet's cells in view, the background laid over its canvas; a repaint has cleared its own rectangle
      if (g.bounded && !part) {
        p.ctx.fillStyle = colors.background;
        p.ctx.fillRect(cellsX, cellsY, cellsR - cellsX, cellsB - cellsY);
      }
      if (q) q.lines = p.ops.length;
      // the gridlines, at an integer plus a half so that each is one device pixel; a hidden row draws none; first since
      // ENGINE.28, so that a fill covers them (decision 11)
      if (!model || model.gridlines) {
        var segs = [], top = clip.y, bottom = clip.y + clip.h, left = clip.x, right = clip.x + clip.w;
        if (g.bounded) { top = Math.max(top, cellsY); bottom = Math.min(bottom, cellsB); left = Math.max(left, cellsX); right = Math.min(right, cellsR); }
        for (c = colStart; c <= colEnd; c++) {
          if (g.colW[c] === 0) continue;
          x = ox + g.colX[c + 1] - sx - 0.5;
          segs.push([x, top, x, bottom]);
        }
        for (r = rowStart; r <= rowEnd; r++) {
          rh = g.rowHeight(r);
          if (rh === 0) continue;
          y = oy + g.rowTop(r) + rh - sy - 0.5;
          segs.push([left, y, right, y]);
        }
        p.lines(segs, colors.gridline, 'grid-' + name);
      }
      if (q) q.fills = p.ops.length;
      // the fills: a look's, a styled cell's, or a styled column's for its empty cells; each from the gridline on its left
      // to the one on its right and from the one above to the one below, all four covered, as Excel lays a fill
      // (ENGINE.28, decision 11): the cell's rectangle grown a device pixel up and left
      if (model) {
        for (r = rowStart; r <= rowEnd; r++) {
          rh = g.rowHeight(r);
          if (rh === 0) continue;
          y = oy + g.rowTop(r) - sy;
          for (c = colStart; c <= colEnd; c++) {
            w = g.colW[c];
            if (w === 0) continue;
            cell = model.cells.get(cellKey(r, c)) || null;
            var fmt = formatOf(model, cell, c);
            if (fmt.fill) p.fillRect(ox + g.colX[c] - sx - 1, y - 1, w + 1, rh + 1, fmt.fill, { op: 'fill', row: r, col: c, quadrant: name });
          }
        }
      }
      if (q) q.edges = p.ops.length;
      // the edges, where a format says a border (ENGINE.28, decisions 8 to 10)
      if (model && model.bordered) self._paintEdges(p, model, g, rowStart, rowEnd, colStart, colEnd, sx, sy, name);
      if (q) q.texts = p.ops.length;
      // the texts
      if (model) {
        for (r = rowStart; r <= rowEnd; r++) {
          if (g.rowHeight(r) === 0) continue;
          y = oy + g.rowTop(r) - sy;
          // a text left of the quadrant's first visible column may overflow into view, and, where a format says an
          // alignment, one right of its last (ENGINE.28, decision 6)
          var from = Math.max(c1, colStart - OVERFLOW_LOOKBACK), to = model.styled ? Math.min(c2, colEnd + OVERFLOW_LOOKBACK) : colEnd;
          for (c = from; c <= to; c++) {
            if (g.colW[c] === 0) continue;
            cell = model.cells.get(cellKey(r, c)) || null;
            if (!cell || cell.text === '') continue;
            if (c < colStart || c > colEnd) {
              // only a nowrap text that spills can reach the visible columns: from the left one aligned left, or a
              // centered text; from the right a text aligned right, or centered
              var f0 = formatOf(model, cell, c), a0 = alignOf(cell, f0), centered = a0 === 'center' && cell.vkind === 'text';
              if (f0.wrap || !(c < colStart ? a0 === 'left' || centered : (a0 === 'right' && cell.vkind === 'text') || centered)) continue;
            }
            self._paintCell(p, model, g, cell, r, c, ox + g.colX[c] - sx, y, c2, name, clip, c1);
          }
        }
      }
      if (q) q.ranges = p.ops.length;
      // the selection and the marks
      self._paintRanges(p, model, g, clip, r1, r2, c1, c2, sx, sy, name);
    });
  };

  // The edges of the cells of rows r1..r2 and columns c1..c2 (ENGINE.28, decisions 8 to 10): each cell's right and bottom
  // edge, and the first column's left and the first row's top, each resolved with the cell beside it into one line or
  // none (decision 9), drawn once, an op on the cell whose side won; the verticals first, then the horizontals, each in
  // reading order, so that a repaint over a part draws its edges in the full paint's order. An edge lies on its
  // gridline's pixel g, its strands across it by its line, and runs from one corner's gridline pixel to the other's and
  // past a corner by the reach of the edges across it there, the measured corners; a pattern is phased on the sheet's
  // coordinate; the gridline's pixel in a pattern's gap or between a double's lines shows the fill there or the
  // background, the gridline hidden (decision 10); a bound sheet's edges end at the sheet. Every rectangle is filled,
  // never stroked, so that each edge is the same device pixels on every rasterizer. A hidden column or row takes no part:
  // a boundary is owned by the shown column or row before it and resolved against the next one shown, as the cells are
  // drawn side by side (the hand test's). Each cell's format and each boundary's line is found once a paint, in the
  // pass's own arrays over the rows and columns from the shown ones before the first to the shown ones after the last,
  // and the ink is set only when it changes.
  Viewport.prototype._paintEdges = function (p, model, g, r1, r2, c1, c2, sx, sy, name) {
    var ox = g.ox, oy = g.oy, ctx = p.ctx, background = this.colors.background, ink = null, r, c, b, l, k;
    var limR = g.bounded ? ox + g.colX[g.cols + 1] - sx : Infinity, limB = g.bounded ? oy + g.rowTop(g.rows + 1) - sy : Infinity;
    function colSize(i) { return g.colW[i]; }
    function rowSize(i) { return g.rowHeight(i); }
    function nextC(cc) { return shownAfter(colSize, cc, g.cols); }
    function prevC(cc) { return shownBefore(colSize, cc); }
    function nextR(rr) { return shownAfter(rowSize, rr, g.rows); }
    function prevR(rr) { return shownBefore(rowSize, rr); }
    var rLo = prevR(r1), rHi = nextR(r2), cLo = prevC(c1), cHi = nextC(c2);
    var span = cHi - cLo + 1, size = (rHi - rLo + 1) * span, fmts = new Array(size), vs = new Array(size), hs = new Array(size);
    function at(rr, cc) { return (rr - rLo) * span + (cc - cLo); }
    function fmtAt(rr, cc) {
      if (rr < 1 || cc < 1) return null;
      var i = at(rr, cc), f = fmts[i];
      if (f === undefined) f = fmts[i] = formatOf(model, model.cells.get(cellKey(rr, cc)) || null, cc);
      return f;
    }
    function sideOf(rr, cc, side) { var f = fmtAt(rr, cc); return f && f.border ? f.border[side] : null; }
    function fillAt(rr, cc) { var f = fmtAt(rr, cc); return f ? f.fill : null; }
    // the line between two cells, the left or upper one's side a and the right or lower one's b: the higher rank, at a
    // tie the right or lower cell's; a said none, a line of no width, yields as an unsaid side does
    function resolve(a, bb) {
      var la = a && a.line !== 'none' ? LINES[a.line] : null, lb = bb && bb.line !== 'none' ? LINES[bb.line] : null;
      if (!la && !lb) return null;
      if (lb && (!la || lb.rank >= la.rank)) return { line: bb.line, color: bb.color || EDGE_INK, def: lb, near: false };
      return { line: a.line, color: a.color || EDGE_INK, def: la, near: true };
    }
    // the vertical line right of column cc in row rr, against the next column shown, and the horizontal line below row
    // rr in column cc, against the next row shown
    function lineV(rr, cc) {
      var i = at(rr, cc), v = vs[i];
      if (v === undefined) v = vs[i] = resolve(sideOf(rr, cc, 'right'), sideOf(rr, nextC(cc), 'left'));
      return v;
    }
    function lineH(rr, cc) {
      var i = at(rr, cc), v = hs[i];
      if (v === undefined) v = hs[i] = resolve(sideOf(rr, cc, 'bottom'), sideOf(nextR(rr), cc, 'top'));
      return v;
    }
    // how far a line reaches across from its gridline's pixel, toward the left or up, and toward the right or down
    function low(x) { return x ? x.def.strands[0][0] : 0; }
    function high(x) { return x ? x.def.strands[x.def.strands.length - 1][0] : 0; }
    // a run along the edge: u0..u1 along it, from across and thick device pixels across it, cut at a bound sheet's edges
    function run(vert, across, u0, u1, thick) {
      var x = vert ? across : u0, y = vert ? u0 : across, w = vert ? thick : u1 - u0 + 1, h = vert ? u1 - u0 + 1 : thick;
      if (x + w > limR) w = limR - x;
      if (y + h > limB) h = limB - y;
      if (w > 0 && h > 0) ctx.fillRect(x, y, w, h);
    }
    // the runs of a mask's drawn pixels, or of its gaps, along u0..u1, phased on the sheet's coordinate from origin
    function runs(mask, want, vert, across, u0, u1, origin, thick) {
      var n = mask.length, start = -1, u;
      for (u = u0; u <= u1 + 1; u++) {
        var on = u <= u1 && mask.charAt((((u - origin) % n) + n) % n) === want;
        if (on && start < 0) start = u;
        else if (!on && start >= 0) { run(vert, across, start, u - 1, thick); start = -1; }
      }
    }
    function inked(color) { if (color !== ink) { ctx.fillStyle = color; ink = color; } }
    // one edge: where its line leaves the gridline's pixel bare, the pixel between the corners in the color of the fill
    // on the right or below, else the one on the left or above (the cells ar, ac and br, bc), else the background, one
    // run the strand on it then covers but at its gaps; then its strands from end to end, a pass a band of them
    function draw(x, vert, gp, base0, base1, u0, u1, origin, ar, ac, br, bc) {
      var passes = PASSES[x.line], k, s;
      if (BARE[x.line] && base1 - 1 >= base0 + 1) { inked(fillAt(ar, ac) || fillAt(br, bc) || background); run(vert, gp, base0 + 1, base1 - 1, 1); }
      inked(x.color);
      for (k = 0; k < passes.length; k++) {
        s = passes[k];
        if (s.mask === null) run(vert, gp + s.off, u0, u1, s.thick);
        else runs(s.mask, '1', vert, gp + s.off, u0, u1, origin, s.thick);
      }
    }
    // the columns whose right edges the pass draws: the one shown before the first shown in view, whose right is that
    // one's left, then each shown in view; and the rows whose bottom edges it draws, the same way
    var cols = [], rows = [], cFirst = c1, rFirst = r1;
    while (cFirst <= c2 && g.colW[cFirst] === 0) cFirst++;
    if (cFirst <= c2) { cols.push(prevC(cFirst)); for (c = cFirst; c <= c2; c++) if (g.colW[c] !== 0) cols.push(c); }
    while (rFirst <= r2 && g.rowHeight(rFirst) === 0) rFirst++;
    if (rFirst <= r2) { rows.push(prevR(rFirst)); for (r = rFirst; r <= r2; r++) if (g.rowHeight(r) !== 0) rows.push(r); }
    // the verticals: in each row, the first column's left, then every column's right, each against the next shown
    for (r = r1; r <= r2; r++) {
      if (g.rowHeight(r) === 0) continue;
      var above = prevR(r);
      for (k = 0; k < cols.length; k++) {
        b = cols[k];
        l = lineV(r, b);
        if (!l) continue;
        var nb = nextC(b), gx = ox + g.colX[b + 1] - sx - 1, t0 = oy + g.rowTop(r) - sy - 1, t1 = oy + g.rowTop(r + 1) - sy - 1;
        var y0 = t0 + Math.min(0, low(lineH(above, b)), low(lineH(above, nb))), y1 = t1 + Math.max(0, high(lineH(r, b)), high(lineH(r, nb)));
        draw(l, true, gx, t0, t1, y0, y1, oy - sy, r, nb, r, b);
        p.ops.push({ op: 'edge', at: 'v' + r + ',' + b, row: r, col: l.near ? b : nb, side: l.near ? 'right' : 'left', line: l.line, color: l.color,
                     x: gx + low(l), y: y0, w: high(l) - low(l) + 1, h: y1 - y0 + 1, quadrant: name });
      }
    }
    // the horizontals: the first row's top, then every row's bottom, each along the row's columns, against the next shown
    for (k = 0; k < rows.length; k++) {
      b = rows[k];
      var nr = nextR(b);
      for (c = c1; c <= c2; c++) {
        if (g.colW[c] === 0) continue;
        l = lineH(b, c);
        if (!l) continue;
        var left = prevC(c), gy = oy + g.rowTop(b + 1) - sy - 1, s0 = ox + g.colX[c] - sx - 1, s1 = ox + g.colX[c + 1] - sx - 1;
        var x0 = s0 + Math.min(0, low(lineV(b, left)), low(lineV(nr, left))), x1 = s1 + Math.max(0, high(lineV(b, c)), high(lineV(nr, c)));
        draw(l, false, gy, s0, s1, x0, x1, ox - sx, nr, c, b, c);
        p.ops.push({ op: 'edge', at: 'h' + b + ',' + c, row: l.near ? b : nr, col: c, side: l.near ? 'bottom' : 'top', line: l.line, color: l.color,
                     x: x0, y: gy + low(l), w: x1 - x0 + 1, h: high(l) - low(l) + 1, quadrant: name });
      }
    }
  };
  // One cell's text, in its format's font and color (ENGINE.28): aligned as its format says or by its kind, a
  // nowrap text spilling into empty neighbors by its alignment, a wrapped text broken at the column's width and
  // placed by its vertical alignment, a number too wide for its column drawn as #s. cFirst and cLast are the
  // quadrant's columns, which a spill never leaves.
  Viewport.prototype._paintCell = function (p, model, g, cell, r, c, left, top, cLast, quadrant, qclip, cFirst) {
    var ctx = p.ctx, colors = this.colors;
    var w = g.colW[c], h = g.rowHeight(r), pad = g.pad;
    var fmt = formatOf(model, cell, c);
    var align = alignOf(cell, fmt), valign = fmt.align && fmt.align.v !== null ? fmt.align.v : null;
    var font = g.fontOf(fmt), lineH = g.lineHOf(fmt), half = Math.round(lineH / 2);
    // the font set only where it differs from the last set: an assignment costs what a change costs (the scoping's probe)
    if (p.font !== font) { ctx.font = font; p.font = font; }
    // a formula before its value shows its text in the formula's color; its value, the color its format says, else the
    // text's (KERNEL.5, decision 7)
    var color = cell.kind === 'formula' && !cell.valued ? colors.formula : (fmt.font && fmt.font.color !== null ? fmt.font.color : colors.text);
    var op = { op: 'text', row: r, col: c, kind: cell.kind, valued: cell.valued, quadrant: quadrant, font: font };
    // one line's vertical place: the cell's middle, as before ENGINE.28, unless its format says top or bottom
    var cy = valign === 'top' ? top + half : (valign === 'bottom' ? top + h - half : top + Math.round(h / 2));
    var hashes = hashesOf(ctx, cell, fmt, w, pad);
    if (hashes !== null) {
      if (left + w <= qclip.x || left >= qclip.x + qclip.w) return;
      op.wrap = false; op.hashes = true;
      p.text(hashes, left + w - pad, cy, 'right', color, { x: left, y: top, w: w, h: h }, op);
      return;
    }
    if (fmt.wrap) {
      if (left + w <= qclip.x || left >= qclip.x + qclip.w) return;
      var lines = wrapText(ctx, cell.text, Math.max(1, w - 2 * pad));
      var clip = { x: left, y: top, w: w, h: h };
      // the block's first line from the cell's top, as before ENGINE.28, unless its format says middle or bottom
      var ty = valign === 'middle' ? top + Math.round(h / 2) - Math.round((lines.length - 1) * lineH / 2) : (valign === 'bottom' ? top + h - half - (lines.length - 1) * lineH : top + half);
      for (var i = 0; i < lines.length && ty - half < top + h; i++, ty += lineH) {
        if (ty + half <= top) continue;   // a line above the cell under a middle or bottom alignment
        var ax = align === 'left' ? left + pad : (align === 'right' ? left + w - pad : left + Math.round(w / 2));
        var lop = { op: 'text', row: r, col: c, kind: cell.kind, quadrant: quadrant, line: i, lines: lines.length, wrap: true, font: font };
        p.text(lines[i], ax, ty, align, color, clip, lop);
      }
      return;
    }
    var textW = ctx.measureText(cell.text).width;
    var need = textW + 2 * pad - w, clipX = left, clipW = w;
    // a nowrap text wider than its cell spills into empty neighbors by its alignment (decision 6): a left-aligned one
    // into the cells to its right, as before ENGINE.28; a text aligned right into those to its left; a centered text
    // into both, half the overhang each way; each stops at the first cell that holds anything and at the quadrant
    if (need > 0 && (align === 'left' || (cell.vkind === 'text' && (align === 'right' || align === 'center')))) {
      var wantR = align === 'left' ? need : (align === 'center' ? Math.ceil(need / 2) : 0), wantL = align === 'right' ? need : (align === 'center' ? Math.ceil(need / 2) : 0);
      var cc = c + 1, grown = 0;
      while (cc <= cLast && grown < wantR) {
        var e = model.cells.get(cellKey(r, cc));
        if (e && e.text !== '') break;
        grown += g.colW[cc];
        cc++;
      }
      clipW += grown; grown = 0; cc = c - 1;
      while (cc >= (cFirst || 1) && grown < wantL) {
        var e2 = model.cells.get(cellKey(r, cc));
        if (e2 && e2.text !== '') break;
        grown += g.colW[cc];
        cc--;
      }
      clipX -= grown; clipW += grown;
    }
    // a text whose clip never reaches the quadrant is not drawn at all
    if (clipX + clipW <= qclip.x || clipX >= qclip.x + qclip.w) return;
    var ax2 = align === 'left' ? left + pad : (align === 'right' ? left + w - pad : left + Math.round(w / 2));
    op.wrap = false;
    p.text(cell.text, ax2, cy, align, color, { x: clipX, y: top, w: clipW, h: h }, op);
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
      var w = g.colX[rr + 1] - g.colX[l], h = g.rowTop(b + 1) - g.rowTop(t);
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
        // the headers' edge, a bound sheet's ending at its last column (CART.14's hand test)
        var end = clip.x + clip.w;
        if (g.bounded) end = Math.min(end, ox + g.colX[cEnd + 1] - scroll);
        segs.push([clip.x, headH - 0.5, end, headH - 0.5]);
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
          var rh = g.rowHeight(r);
          if (rh === 0) continue;   // a hidden row has no header, as a hidden column has none
          var y = oy + g.rowTop(r) - scroll;
          var selected = r >= selRows.top && r <= selRows.bottom;
          p.fillRect(0, y, g.rhW, rh, selected ? colors.headerSelected : colors.header, { op: 'header', kind: 'row', index: r, text: String(r), selected: selected });
          p.text(String(r), g.rhW - g.pad, y + Math.round(rh / 2), 'right', colors.headerText, { x: 0, y: y, w: g.rhW, h: rh }, { op: 'header-text', kind: 'row', index: r });
          segs.push([0, y + rh - 0.5, g.rhW, y + rh - 0.5]);
        }
        // the headers' edge, a bound sheet's ending at its last row (CART.14's hand test)
        var end = clip.y + clip.h;
        if (g.bounded) end = Math.min(end, oy + g.rowTop(rEnd + 1) - scroll);
        segs.push([g.rhW - 0.5, clip.y, g.rhW - 0.5, end]);
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

  // ---- the repaint (ENGINE.20): a patch's cells painted again alone, the rest of the canvas kept ----
  // Whether a patch of n cells to a model may be painted by its cells (decision 2): the canvas holds that model's full
  // paint, the scroller is where the paint left it (no scroll's event pending), the canvas's size and ratio and the
  // scroller's area are the paint's, and the cells named are no more than a share of the cells in view. Every other
  // change to what the canvas shows paints whole at once, so the full paint is otherwise current.
  Viewport.prototype._repaintable = function (model, n) {
    var at = this.painted;
    if (!at || at.model !== model || !this.g) return false;
    var env = this._env(), was = at.env;
    if (env.dpr !== was.dpr || env.canvasW !== was.canvasW || env.canvasH !== was.canvasH || env.clientW !== was.clientW || env.clientH !== was.clientH) return false;
    if (this.scroller.scrollLeft !== this.lastScroll.x || this.scroller.scrollTop !== this.lastScroll.y) return false;
    return n <= REPAINT_SHARE * this.inView;
  };
  // The quadrant that paints a cell, as the last full paint left it; null where that paint drew no such quadrant.
  Viewport.prototype._quadOf = function (r, c) {
    var g = this.g, name = r <= g.fr ? (c <= g.fc ? 'frozen-corner' : 'frozen-rows') : (c <= g.fc ? 'frozen-cols' : 'body');
    for (var i = 0; i < this.quads.length; i++) if (this.quads[i].name === name) return this.quads[i];
    return null;
  };
  // Where a cell's paint lies on the canvas, in the model as it stands (decision 1), added to spans as { q, row, y, h,
  // x0, x1 }, each cut to its quadrant's rectangle: its row's band over its own column, its fill and its text; the span
  // its text spills over; and the span of the nearest text on its left, every cell between them empty, the one text that
  // can spill into it or through it. Each is where the full paint's own code draws it, run through a tracer, and the left
  // is looked for as far as the full paint looks, the columns in view and eight before them. Nothing for a cell in a
  // hidden row or out of view.
  Viewport.prototype._footprint = function (model, r, c, spans) {
    var g = this.g, q = this._quadOf(r, c), h = g.rowHeight(r);
    if (!q || h === 0 || r < q.rowStart || r > q.rowEnd) return;
    // the band grown where a fill or an edge reaches past the cell's rectangle (ENGINE.28, decisions 11 and 12): a fill a
    // device pixel up and left, over its gridlines; an edge two up and left and one down and right, a thick's reach
    var up = model.bordered ? 2 : (model.filled ? 1 : 0), down = model.bordered ? 1 : 0;
    var clip = q.clip, top = g.oy + g.rowTop(r) - q.sy, x = g.ox - q.sx, xs = [];
    var y0 = Math.max(top - up, clip.y), y1 = Math.min(top + h + down, clip.y + clip.h);
    if (y0 >= y1) return;
    if (g.colW[c] > 0) xs.push(x + g.colX[c] - up, x + g.colX[c + 1] + down);
    var own = this._traced(model, g, q, r, c, top);
    if (own) xs.push(own.x, own.x + own.w);
    // the nearest text on its right, where a format says an alignment (ENGINE.28, decision 12): one aligned right or
    // centered may spill into it, looked for as far as the full paint looks ahead
    if (model.styled) {
      for (var cr = c + 1, until = Math.min(q.c2, q.colEnd + OVERFLOW_LOOKBACK); cr <= until; cr++) {
        var er = model.cells.get(cellKey(r, cr));
        if (!er || er.text === '') continue;
        var right = this._traced(model, g, q, r, cr, top);
        if (right && right.x < x + g.colX[c + 1]) xs.push(right.x, right.x + right.w);
        break;
      }
    }
    for (var cc = c - 1, from = Math.max(q.c1, q.colStart - OVERFLOW_LOOKBACK); cc >= from; cc--) {
      var e = model.cells.get(cellKey(r, cc));
      if (!e || e.text === '') continue;
      var left = this._traced(model, g, q, r, cc, top);
      if (left && left.x + left.w > x + g.colX[c]) xs.push(left.x, left.x + left.w);
      break;
    }
    for (var i = 0; i < xs.length; i += 2) {
      var x0 = Math.max(xs[i], clip.x), x1 = Math.min(xs[i + 1], clip.x + clip.w);
      if (x0 < x1) spans.push({ q: q, row: r, y: y0, h: y1 - y0, x0: x0, x1: x1 });
    }
  };
  // Where the full paint clips a cell's text: the cell's paint run through a tracer. Null for a cell it draws no text for.
  Viewport.prototype._traced = function (model, g, q, r, c, top) {
    var cell = model.cells.get(cellKey(r, c));
    if (!cell || cell.text === '' || g.colW[c] === 0) return null;
    var t = new Tracer(this.ctx);
    this._paintCell(t, model, g, cell, r, c, g.ox + g.colX[c] - q.sx, top, q.c2, q.name, q.clip, q.c1);
    return t.ops.length ? t.ops[0].clip : null;
  };
  // A patch's cells painted again (decision 1): their spans merged into rectangles, one a run of a row in its quadrant,
  // each painted by the full paint's steps (_repaintRect); the cells whose fills and texts it drew stand in the draw list
  // in place of the last full paint's (decision 3), and the repaint is counted.
  Viewport.prototype._repaint = function (model, spans) {
    var g = this.g, ctx = this.ctx, p = new Painter(ctx, this.colors), seps = separators(g, g.canvasW, g.canvasH), rects = [], cur = null, i;
    spans.sort(function (a, b) { return a.q.index - b.q.index || a.row - b.row || a.x0 - b.x0; });
    for (i = 0; i < spans.length; i++) {
      var s = spans[i];
      if (cur && cur.q === s.q && cur.row === s.row && s.x0 <= cur.x1) { if (s.x1 > cur.x1) cur.x1 = s.x1; continue; }
      rects.push(cur = { q: s.q, row: s.row, y: s.y, h: s.h, x0: s.x0, x1: s.x1 });
    }
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.font = g.font; p.font = g.font;
    ctx.textBaseline = 'middle';
    // where a fill or an edge reaches past a cell (ENGINE.28, decision 12), a rectangle's part is the rows and columns
    // around it too, whose fills, gridlines, edges and texts reach into it
    var grown = model.filled || model.bordered;
    for (i = 0; i < rects.length; i++) {
      var R = rects[i], q = R.q, at = p.ops.length;
      var part = { top: R.row, bottom: R.row, left: Math.max(q.colStart, g.columnAt(R.x0 - g.ox + q.sx, q.colStart)), right: Math.min(q.colEnd, g.columnAt(R.x1 - 1 - g.ox + q.sx, q.colStart)) };
      if (grown) {
        part.top = Math.max(q.rowStart, g.rowAt(R.y - g.oy + q.sy, q.rowStart) - 1);
        part.bottom = Math.min(q.rowEnd, g.rowAt(R.y + R.h - 1 - g.oy + q.sy, q.rowStart) + 1);
        part.left = Math.max(q.colStart, part.left - 1);
        part.right = Math.min(q.colEnd, part.right + 1);
      }
      this._repaintRect(p, model, g, q, { x: R.x0, y: R.y, w: R.x1 - R.x0, h: R.h }, part, seps);
      this._override(model, q, part, p.ops, at);
    }
    this.repaintCount++;
  };
  // One rectangle of a repaint: under its clip, the canvas cleared to the background, a bound sheet's canvas past its
  // cells to the headers' gray, then the quadrant's steps over the part's rows part.top to part.bottom and columns
  // part.left to part.right, its gridlines, fills, edges and texts, the selection and the marks, then the frozen
  // separators; never the headers, which no value changes. Every step of the full paint that touches a pixel of the
  // rectangle runs again, in the full paint's order, so the rectangle's pixels are the full paint's.
  Viewport.prototype._repaintRect = function (p, model, g, q, rect, part, seps) {
    var self = this, ctx = p.ctx, colors = this.colors;
    p.clipped(rect, function () {
      ctx.clearRect(rect.x, rect.y, rect.w, rect.h);
      ctx.fillStyle = g.bounded ? colors.header : colors.background;
      ctx.fillRect(rect.x, rect.y, rect.w, rect.h);
      if (g.bounded) {
        var sr = Math.min(rect.x + rect.w, g.ox + g.colX[g.cols + 1] - q.sx), sb = Math.min(rect.y + rect.h, g.oy + g.rowTop(g.rows + 1) - q.sy);
        ctx.fillStyle = colors.background;
        if (sr > rect.x && sb > rect.y) ctx.fillRect(rect.x, rect.y, sr - rect.x, sb - rect.y);
      }
      self._paintQuadrant(p, model, g, q.clip, q.r1, q.r2, q.c1, q.c2, q.sx, q.sy, q.name, part);
      if (seps.length) p.lines(seps, colors.frozenLine, 'frozen');
    });
  };
  // A rectangle's ops laid over the last full paint's in the draw list (decision 3), for each cell whose paint the repaint
  // decided as the full paint decides it: every cell of the part's rows and columns, its fill and its texts, drawn or
  // not; the cells left of them it looked back to, a text it drew; and, left of the columns in view, where the full
  // paint looks back by the same rule, a text it did not draw too; and since ENGINE.28 every boundary the part's edge
  // pass resolved, its edge or none.
  Viewport.prototype._override = function (model, q, part, ops, at) {
    var over = this.over || (this.over = {}), o = over[q.name] || (over[q.name] = { fills: new Map(), texts: new Map(), edges: new Map() });
    var drawn = new Map(), r, c, key;
    for (r = part.top; r <= part.bottom; r++) {
      for (c = part.left; c <= part.right; c++) { key = cellKey(r, c); o.fills.set(key, null); o.texts.set(key, []); }
      for (c = Math.max(q.c1, part.left - OVERFLOW_LOOKBACK); c < part.left && c < q.colStart; c++) o.texts.set(cellKey(r, c), []);
      // and right of them, where the full paint looks ahead for a text aligned right or centered (ENGINE.28)
      if (model.styled) for (c = Math.min(q.c2, part.right + OVERFLOW_LOOKBACK); c > part.right && c > q.colEnd; c--) o.texts.set(cellKey(r, c), []);
    }
    if (model.bordered) {
      // keyed as the edge pass keys them: a column's right by the column, the first column's left by the one shown
      // before it, and a row's the same way
      var g = this.g, cb = shownBefore(function (i) { return g.colW[i]; }, part.left), rb = shownBefore(function (i) { return g.rowHeight(i); }, part.top);
      for (r = part.top; r <= part.bottom; r++) { o.edges.set('v' + r + ',' + cb, null); for (c = part.left; c <= part.right; c++) o.edges.set('v' + r + ',' + c, null); }
      for (c = part.left; c <= part.right; c++) { o.edges.set('h' + rb + ',' + c, null); for (r = part.top; r <= part.bottom; r++) o.edges.set('h' + r + ',' + c, null); }
    }
    for (var i = at; i < ops.length; i++) {
      var op = ops[i];
      if (op.op === 'edge') { o.edges.set(op.at, op); continue; }
      if (!op.row) continue;
      key = cellKey(op.row, op.col);
      if (op.op === 'fill') o.fills.set(key, op);
      else if (op.op === 'text') { if (!drawn.has(key)) drawn.set(key, []); drawn.get(key).push(op); }
    }
    drawn.forEach(function (list, k) { o.texts.set(k, list); });
  };
  // A section of the draw list, ops from to to, with the cells a repaint drew taken out and the repaint's put in, by row,
  // then column, then line: the order the full paint draws them in.
  function spliced(ops, from, to, cells, out) {
    var list = [], i;
    for (i = from; i < to; i++) if (!cells.has(cellKey(ops[i].row, ops[i].col))) list.push(ops[i]);
    cells.forEach(function (v) { if (v === null) return; if (Array.isArray(v)) { for (var k = 0; k < v.length; k++) list.push(v[k]); } else list.push(v); });
    list.sort(function (a, b) { return a.row - b.row || a.col - b.col || (a.line || 0) - (b.line || 0); });
    for (i = 0; i < list.length; i++) out.push(list[i]);
  }
  // The edges' section the same way, by their boundaries (ENGINE.28): the verticals by row, then column, and the
  // horizontals after them by row, then column, the order the full paint draws them in.
  function splicedEdges(ops, from, to, edges, out) {
    var list = [], i;
    for (i = from; i < to; i++) if (!edges || !edges.has(ops[i].at)) list.push(ops[i]);
    if (edges) edges.forEach(function (v) { if (v) list.push(v); });
    list.sort(edgeOrder);
    for (i = 0; i < list.length; i++) out.push(list[i]);
  }
  function edgeOrder(a, b) {
    var da = a.at.charAt(0) === 'v' ? 0 : 1, db = b.at.charAt(0) === 'v' ? 0 : 1;
    if (da !== db) return da - db;
    var pa = a.at.slice(1).split(','), pb = b.at.slice(1).split(',');
    return (+pa[0] - +pb[0]) || (+pa[1] - +pb[1]);
  }

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
    if (!cell) return { row: row, col: col, address: colName(col) + row, kind: 'empty', text: '', value: '', formula: '', valued: false, style: 0, sentence: 0 };
    // text is what the cell shows; value its value as the record spells it, the text a code draws aside (KERNEL.47),
    // empty for a formula with none yet; formula is a formula cell's own text, the bar's, beside its value
    var value = cell.value !== undefined ? cell.value : cell.valued ? cell.text : '';
    return { row: cell.row, col: cell.col, address: cell.address, kind: cell.kind, vkind: cell.vkind, text: cell.text, value: value, formula: cell.formula, valued: cell.valued, style: cell.style, sentence: cell.sentence };
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
    var top = g.rowAt(g.frozenH + sy, g.fr + 1), left = g.columnAt(g.colX[g.fc + 1] + sx, g.fc + 1);
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
      var top = g.rowTop(row) - g.frozenH, bottom = top + g.rowHeight(row);
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
    // past the last column or the last row of the sheet's space, a bound sheet's edge (version 6), there is no cell
    if ((x >= ox && cx >= g.colX[g.cols + 1]) || (y >= oy && cy >= g.rowTop(g.rows + 1))) return null;
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
  // Whether a point of the page lies in the scroller's client area, the cells, the headers and the corner:
  // not over a scrollbar, and not below the box over the tab strip, both of which the hit test, which
  // extends a drag past the edge, would answer as cells (ENGINE.14).
  Viewport.prototype._inside = function (ev) {
    var rect = this.box.getBoundingClientRect(), x = ev.clientX - rect.left, y = ev.clientY - rect.top;
    return x >= 0 && y >= 0 && x < this.scroller.clientWidth && y < this.scroller.clientHeight;
  };
  Viewport.prototype._mouseDown = function (ev) {
    if (ev.button !== 0 || !this._inside(ev)) return;   // a press on a scrollbar is the browser's
    var hit = this._hit(ev);
    if (!hit) return;
    this.scroller.focus();
    var s = this.state.selection;
    if (hit.kind === 'boundary') {
      ev.preventDefault();
      this.drag = { kind: 'resize', col: hit.col, startX: ev.clientX, startW: this.g.colW[hit.col] / this.g.dpr, sheet: this.active, moved: false };
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
      // the width of the sheet the drag was pressed on, its own (ENGINE.26); when another sheet has come to show since
      // the press, as a Camera shows one at a rate, the drag stays that sheet's and nothing shown moves
      var w = Math.max(0, Math.round(drag.startW + (ev.clientX - drag.startX)));
      this._widthsOf(drag.sheet)[colName(drag.col)] = w;
      drag.moved = true;
      if (this.active !== drag.sheet) return;
      var was = this._scrollPayload().window;
      this._draw();
      // a narrower column brings columns into view, as a box grown does, and a wider one takes them out: the host is told
      // as it is told of a scroll, so that it views the columns no record named (ENGINE.26; at rate 0 no frame would)
      var now = this._scrollPayload();
      if (now.window !== was) this._emit('scroll', now);
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
    // the sheet the drag was pressed on and the width it left there; a press on a divider that moved nothing raises
    // nothing, where it raised a width of undefined (ENGINE.26)
    if (drag.kind === 'resize' && drag.moved) {
      this._emit('columnresize', { sheet: drag.sheet, column: colName(drag.col), width: this._widthsOf(drag.sheet)[colName(drag.col)] });
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
      case 'F2': open = true; break;   // a spreadsheet's key to edit a cell, opened as Enter opens it (CART.9's second slice)
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
      b.style.cssText = 'font:inherit;white-space:nowrap;padding:2px 10px;border:1px solid ' + this.colors.gridline + ';border-radius:3px;cursor:pointer;background:' + (sh.name === this.active ? this.colors.tabActive : this.colors.tabBackground) + ';color:' + (this.records[sh.name] ? this.colors.text : this.colors.headerText) + ';' + (sh.name === this.active ? 'font-weight:600;' : '') + (this.records[sh.name] ? '' : 'font-style:italic;');
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
    if (this.records[name]) this.show(name);
    else this._emit('sheet', { name: name, loaded: false, state: sh ? sh.state : 'visible' });
    this._focusGrid();
  };
  // A sheet chosen by its tab, clicked or stepped to by a key, gives the grid the keys, so that the arrows move the
  // selection on the sheet shown (CART.12's hand test); a box being typed in keeps them.
  Viewport.prototype._focusGrid = function () {
    var d = global.document, a = d ? d.activeElement : null;
    if (a && a !== this.scroller && (a.tagName === 'TEXTAREA' || a.tagName === 'SELECT' || a.isContentEditable ||
        (a.tagName === 'INPUT' && !/^(button|checkbox|radio|submit|reset|range|color|file|image)$/i.test(a.type || '')))) return;
    try { this.scroller.focus({ preventScroll: true }); } catch (e) { this.scroller.focus(); }
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
  // model's counts. With options.keep (ENGINE.8), a later frame of the sheet
  // shown: its record replaces the last with the scroll and the selection
  // kept and no event raised, and the tabs are remade only when the sheet rows
  // changed. The host draws every frame of a grid cartridge so, and a page its
  // live sheet. Every load, kept or not, keeps every sheet's widths, which
  // clear() alone forgets (ENGINE.26), and the frozen panes and the marks.
  Viewport.prototype.load = function (text, options) {
    var keep = !!(options && options.keep);
    var model = readRecord(String(text || ''));
    var name = model.sheet || (model.sheets.length ? model.sheets[0].name : 'Sheet');
    var tabs = !keep || !this.records[name];
    this.records[name] = model;
    if (model.sheets.length) { if (!sameSheets(this.sheetList, model.sheets)) tabs = true; this.sheetList = model.sheets.slice(); }
    else if (!this._sheetListed(name)) { this.sheetList.push({ name: name, state: 'visible' }); tabs = true; }
    var kept = keep && this.active === name;
    if (!kept && (!this.active || this.active === name)) { this.active = name; this._resetView(); }
    if (tabs) this._renderTabs();
    this._draw();
    if (this.active === name && !kept) {
      this._emit('sheet', { name: name, loaded: true, state: this._sheetState(name) });
      // the selection went back to A1 of the record shown: say so
      this._emit('select', this._selectPayload());
    }
    return { sheet: name, lines: model.lines, cells: model.counts.cells, formulas: model.counts.formulas, values: model.counts.values, texts: model.counts.texts, styles: model.counts.styles, sentences: model.counts.sentences,
             looks: model.counts.looks, rows: model.counts.rows, unknown: model.counts.unknown, malformed: model.counts.malformed, window: model.windowText, extent: model.extentText, readMs: model.readMs };
  };
  // A window's changes laid on the model of their sheet (ENGINE.19, decision 3): the text a host's view of changes
  // answered (docs/SPEC.md section 4.5), its header (changes "<sheet>" "<range>" <since> <at> <n>), then the rows of
  // each cell it names as the values record prints them, (empty "<sheet>" "<addr>") for a cell with none. Each named
  // cell's entry is replaced as readRecord reads its rows, one reading of a row serving both, a cell the model lacks
  // put in and an empty one's taken out, the model's counts and lines with them, so that the model is the one a load
  // of the patched record makes. The model object and the view are kept, the patch counted (patches), and the sheet
  // shown painted again: the named cells alone (ENGINE.20, repaints), where the canvas holds the model's full paint,
  // still current, and they are no more than a share of the cells in view; whole otherwise. False, and nothing
  // changed, for a text that is
  // no such answer: a header ending whole or counting other cells than its rows name, a sheet the viewport holds no
  // record of, another window, a row that is no cell's of that window or a cell's rows not together, and a model
  // holding a row its reader counted unknown or malformed, whose counts no patch can keep. Else the model's counts
  // as a load returns them, with patched, the cells named, and patchMs.
  Viewport.prototype.patch = function (text) {
    var t0 = now(), rd = new Reader(String(text || '')), h = rd.readForm();
    if (!Array.isArray(h) || h.length !== 6 || symOf(h[0]) !== 'changes' || numOf(h[5]) === null) return false;
    var name = strOf(h[1]), model = name !== null && Object.prototype.hasOwnProperty.call(this.records, name) ? this.records[name] : null;
    if (!model || !model.window || model.windowText !== strOf(h[2]) || model.counts.unknown || model.counts.malformed) return false;
    // the rows by cell, in the order printed, every one checked before the model is touched
    var W = model.window, groups = [], seen = {}, last = null, f;
    while ((f = rd.readForm()) !== null) {
      var head = Array.isArray(f) ? symOf(f[0]) : null, a = head ? parseA1(strOf(f[2]) || '') : null;
      if (!a || (head !== 'empty' && !Object.prototype.hasOwnProperty.call(CELL_ROWS, head)) || strOf(f[1]) !== name) return false;
      if (a.row < W.top || a.row > W.bottom || a.col < W.left || a.col > W.right) return false;
      var key = cellKey(a.row, a.col);
      if (!last || last.key !== key) {
        if (seen[key]) return false;
        seen[key] = true;
        groups.push(last = { key: key, row: a.row, col: a.col, rows: [] });
      }
      if (head !== 'empty') last.rows.push(f);
    }
    if (groups.length !== numOf(h[5])) return false;
    // the named cells repainted alone (ENGINE.20) where decision 2 allows: what their paint covered before the patch,
    // found now, and what it covers after; else the sheet shown painted whole
    var shown = this.active === name, spans = shown && this._repaintable(model, groups.length) ? [] : null, i;
    if (spans) { this.ctx.font = this.g.font; for (i = 0; i < groups.length; i++) this._footprint(model, groups[i].row, groups[i].col, spans); }
    var reach = { row: 0, col: 0 }, restyled = false;
    for (i = 0; i < groups.length; i++) {
      var g = groups[i], e = model.cells.get(g.key), was = e ? e.style : 0;
      if (e) unread(model, e);
      for (var j = 0; j < g.rows.length; j++) { readRow(model, g.rows[j], reach); model.lines++; }
      var after = model.cells.get(g.key);
      if ((after ? after.style : 0) !== was) restyled = true;
    }
    // a cell whose own format changed may move its row's fit (ENGINE.28, decision 7): the fits found again, and a
    // row that moved paints the sheet whole, the geometry being new
    if (restyled && model.styled) {
      var fitsWere = JSON.stringify(model.rowFits);
      computeFits(model);
      if (JSON.stringify(model.rowFits) !== fitsWere) spans = null;
    }
    this.patchCount++;
    if (spans) {
      for (i = 0; i < groups.length; i++) this._footprint(model, groups[i].row, groups[i].col, spans);
      this._repaint(model, spans);
    } else if (shown) this._draw();
    return { sheet: name, patched: groups.length, lines: model.lines, cells: model.counts.cells, formulas: model.counts.formulas, values: model.counts.values, texts: model.counts.texts, styles: model.counts.styles, sentences: model.counts.sentences,
             looks: model.counts.looks, rows: model.counts.rows, unknown: model.counts.unknown, malformed: model.counts.malformed, window: model.windowText, extent: model.extentText, patchMs: now() - t0 };
  };
  // The patches this viewport has taken since it was made (ENGINE.19): a host notes the count with each record it
  // loads, so that a model a page patched is never taken for the one the host made.
  Viewport.prototype.patches = function () { return this.patchCount; };
  // The patches it has painted by their cells alone since it was made (ENGINE.20), the others painted whole.
  Viewport.prototype.repaints = function () { return this.repaintCount; };
  function sameSheets(a, b) {
    if (a.length !== b.length) return false;
    for (var i = 0; i < a.length; i++) if (a[i].name !== b[i].name || a[i].state !== b[i].state) return false;
    return true;
  }
  // Every record forgotten and the grid drawn empty: a host's grid unloaded (ENGINE.8), so that the viewport
  // shows no picture of a grid the module no longer holds. Every sheet's widths go with it, and a drag in progress
  // (ENGINE.26): a person's widths are the grid's they were dragged on, and a Load starts from the cartridge's text,
  // the one act that carries a column row's change, which a width kept across it would hide.
  Viewport.prototype.clear = function () {
    this.records = {}; this.sheetList = []; this.active = '';
    this.layouts = {}; this.bounds = {};
    this.widths = {}; this.drag = null;
    this._resetView();
    this._renderTabs();
    this._draw();
  };
  // The window the scrolled quadrant shows, { top, left, bottom, right, window }: a host follows a Camera's
  // move by it (ENGINE.8).
  Viewport.prototype.scrolled = function () { return this._scrollPayload(); };
  // A record of a sheet read for its layout alone (CART.12's hand test): its columns and rows with settings and its
  // extent learned as a load learns them, its cells and the model shown untouched. A host reads a sheet's columns
  // whole so, through a window of every column on a row no cell holds, before it shows the sheet, and the viewport
  // then lays every column as the sheet sets it. The sheet's name, the window and the columns learned; null for a
  // text that is no record of a sheet.
  Viewport.prototype.learn = function (text) {
    var model = readRecord(String(text || '')), name = model.sheet;
    if (!name) return null;
    var layout = this._layoutOf(name);
    learnLayout(layout, model);
    if (this.active && this.active.toLowerCase() === name.toLowerCase()) this._draw();
    var n = 0;
    for (var k in layout.columns) if (Object.prototype.hasOwnProperty.call(layout.columns, k)) n++;
    return { sheet: name, window: model.windowText, extent: model.extentText, columns: n };
  };
  // The range a sheet shows from A1 in this box, its columns laid as its layout and its own widths set them (ENGINE.26),
  // never the sheet shown's, and its rows at the default height, within a bound sheet's extent: the window a host views
  // a sheet through before it shows it.
  Viewport.prototype.fresh = function (name) {
    var key = String(name || '').toLowerCase(), layout = this.layouts[key] || null, model = this._findSheet(name) ? this.records[this._findSheet(name)] : null;
    var w = Math.max(1, this.scroller.clientWidth), x = 0, c = 0;
    while (x < w && c < MAX_COLUMNS) { c++; x += columnWidthCss(model, this._widthsOf(name), c, layout); }
    var r = Math.max(1, Math.ceil(this.scroller.clientHeight / DEFAULT_ROW_PX)), ext = this.bounds[key] ? ((model && model.extent) || (layout && layout.extent)) : null;
    if (ext) { c = Math.min(c, ext.right); r = Math.min(r, ext.bottom); }
    return rangeText({ top: 1, left: 1, bottom: r, right: Math.max(1, c) });
  };
  // Whether a sheet is drawn to its extent and no further (version 6's (bound "<sheet>"), CART.12's hand test): the
  // host says so for each sheet its cartridge's manifest bounds.
  Viewport.prototype.bound = function (name, on) {
    var key = String(name || '').toLowerCase();
    if (on) this.bounds[key] = true; else delete this.bounds[key];
    if (this.active && this.active.toLowerCase() === key) this._draw();
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
  // A column's width in CSS pixels on a sheet, the host's over the record's, kept for that sheet alone (ENGINE.26): the
  // sheet shown, or the one named, compared without case, a sheet with no record yet among them; null puts the
  // record's back. With no sheet shown and none named there is no sheet to keep it for, and nothing is set.
  Viewport.prototype.columnWidth = function (letters, px, sheet) {
    var key = String(letters).toUpperCase(), name = sheet === undefined || sheet === null ? this.active : String(sheet);
    if (!name) return;
    var widths = this._widthsOf(name);
    if (px === null || px === undefined) delete widths[key];
    else widths[key] = Math.max(0, Math.round(px));
    if (this.active && this.active.toLowerCase() === name.toLowerCase()) this._draw();
  };
  // A sheet's widths, the sheet shown's or the one named: a column's letters to CSS pixels, a copy.
  Viewport.prototype.columnWidths = function (sheet) {
    var widths = this._widthsOf(sheet === undefined || sheet === null ? this.active : String(sheet)), out = {};
    for (var k in widths) if (Object.prototype.hasOwnProperty.call(widths, k)) out[k] = widths[k];
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
  // The cell under a point of the page, or null outside the cells: over a header, a scrollbar or the tabs.
  Viewport.prototype.cellAt = function (clientX, clientY) {
    if (!this._inside({ clientX: clientX, clientY: clientY })) return null;
    var hit = this._hit({ clientX: clientX, clientY: clientY });
    if (!hit || hit.kind !== 'cell') return null;
    return this._cellInfo(hit.row, hit.col);
  };
  Viewport.prototype.cell = function (row, col) { return this._cellInfo(row, col); };
  // A cell's box on the page, the hit test's inverse (CART.9's short slice, the owner's word at its hand test): its left,
  // top, right and bottom in the page's pixels where the last draw put it, a frozen band's unscrolled; null before a draw.
  Viewport.prototype.cellBox = function (row, col) {
    var g = this.g;
    if (!g) return null;
    var rect = this.box.getBoundingClientRect(), dpr = g.dpr;
    var x = g.ox + g.colX[col] - (col > g.fc ? this.scroll.x : 0), y = g.oy + g.rowTop(row) - (row > g.fr ? this.scroll.y : 0);
    return { left: rect.left + x / dpr, top: rect.top + y / dpr, right: rect.left + (x + g.colW[col]) / dpr, bottom: rect.top + (y + g.rowHeight(row)) / dpr };
  };
  // The geometry of the last draw: the ratio, the sizes, the scroll, the
  // column edges in device pixels; the environment the oracle needs.
  Viewport.prototype.geometry = function () {
    var g = this.g;
    if (!g) return null;
    return { dpr: g.dpr, canvasW: g.canvasW, canvasH: g.canvasH, clientW: this.scroller.clientWidth, clientH: this.scroller.clientHeight,
             rowH: g.rowH, headH: g.headH, rhW: g.rhW, fontPx: g.fontPx, pad: g.pad, lineH: g.lineH, rows: g.rows, cols: g.cols, sheetRows: g.sheetRows, sheetCols: g.sheetCols, bounded: g.bounded,
             colW: g.colW.slice(), colX: g.colX.slice(), contentW: g.contentW, contentH: g.contentH, frozenRows: g.fr, frozenCols: g.fc, frozenW: g.frozenW, frozenH: g.frozenH,
             scrollX: this.scroll.x, scrollY: this.scroll.y, scrollLeft: this.scroller.scrollLeft, scrollTop: this.scroller.scrollTop };
  };
  // The draw list (ENGINE.20, decision 3): the last full paint's, each cell a repaint drew since in its place, in the
  // full paint's order, so that it describes the canvas op for op as a full paint of the model would.
  Viewport.prototype.draws = function () {
    if (!this.over) return this.ops.slice();
    var ops = this.ops, out = [], at = 0, i, j;
    for (i = 0; i < this.quads.length; i++) {
      var q = this.quads[i], o = this.over[q.name];
      if (!o) continue;
      for (j = at; j < q.fills; j++) out.push(ops[j]);   // the gridlines, first since ENGINE.28
      spliced(ops, q.fills, q.edges, o.fills, out);
      splicedEdges(ops, q.edges, q.texts, o.edges, out);
      spliced(ops, q.texts, q.ranges, o.texts, out);
      at = q.ranges;
    }
    for (j = at; j < ops.length; j++) out.push(ops[j]);
    return out;
  };
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
  Viewport.readForms = readForms;
  Viewport.columnPixels = columnPixels;
  Viewport.parseRange = parseRange;
  Viewport.rangeText = rangeText;
  Viewport.colName = colName;
  Viewport.colIndex = colIndex;
  Viewport.RULES = RULES;
  Viewport.LINES = LINES;   // the lines' table, which the page's oracles hold to their own (ENGINE.28)
  Viewport.DEFAULT_COLORS = DEFAULT_COLORS;
  Viewport.version = 4;

  global.AlonzoViewport = Viewport;
})(typeof window !== 'undefined' ? window : this);

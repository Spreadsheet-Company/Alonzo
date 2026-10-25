// SPDX-License-Identifier: 0BSD
// SPDX-FileCopyrightText: 2026 Spreadsheet Company
//
// cartridges/naught/naught.hand.js - Naught: Vel et Aut by hand (CART.9, decisions 4 and 14), the page's own, a
// second beside the Rust one, engine/src/naught.rs, whose netlists, placements and block it mirrors line for line,
// so that the page writes the same bytes the native runner writes. A hand (ENGINE.16): the builder writes this file
// into the page as the block hand-naught, a script the page runs where it stands, and it registers one constructor
// under its cartridge's name in window.AlonzoHands. The frames instrument (?frames=1) builds the floors' two
// fixtures through NaughtHand.Net, NaughtHand.Laid and NaughtHand.floorsSource, the bench of a 4,096-bit adder and a
// 64 by 64 multiplier laid by fill and shuffled, every switch a hash of the frame, and holds every gate to
// Net.evaluate at every frame. The loop oracle's replay case makes one for the committed replay, which lays the
// bench and holds its block to the page's own text of the source, the block source-naught, line for line, then
// answers each frame of the replay with every gate's value after the frame's switches; and, since the game's levels
// (CART.9's third slice), with the game by hand, a person's gates evaluated in the gates' arithmetic, each level's
// board and words, the Lab and the Camera's sheet, the Rust hand's Game line for line.
(function (hands) {
  'use strict';
  var BLOCK_BEGIN = '; ---- the bench, written by cargo run --release --example naught: edit the generator, never these lines ----';
  var BLOCK_END = '; ---- the bench\'s end ----';
  var SHEET = 'Bench', WIDTH = '3', RUN = 4, SHUFFLE_SEED = 20261020;
  // the named adder's columns four wide, its names of three capitals whole (NAMED_WIDTH in Rust)
  var NAMED_WIDTH = '4';
  var BENCH = [16, 8], FLOORS = [4096, 64];
  // the bench a person loads stands from row 2, row 1 naming its columns; the floors' from row 1 (BENCH_TOP in Rust)
  var BENCH_TOP = 2;
  var STIMULUS = '=MOD(INT(MOD(MOD(ROW()*40503+COLUMN()*9973+Clock!$B$1*65519,65521)*MOD(ROW()*40503+COLUMN()*9973+Clock!$B$1*65519,65521),65521)/256),2)';

  // ---- the gates: a kind's macro, its inputs, its value and its formula ----
  var KINDS = {
    non: { arity: 1, apply: function (a) { return 1 - a; }, formula: function (x) { return '=1-' + x; } },
    et: { arity: 2, apply: function (a, b) { return a & b; }, formula: function (x, y) { return '=' + x + '*' + y; } },
    vel: { arity: 2, apply: function (a, b) { return a | b; }, formula: function (x, y) { return '=MAX(' + x + ',' + y + ')'; } },
    aut: { arity: 2, apply: function (a, b) { return a ^ b; }, formula: function (x, y) { return '=MOD(' + x + '+' + y + ',2)'; } },
    'non-et': { arity: 2, apply: function (a, b) { return 1 - (a & b); }, formula: function (x, y) { return '=1-' + x + '*' + y; } },
    nec: { arity: 2, apply: function (a, b) { return 1 - (a | b); }, formula: function (x, y) { return '=1-MAX(' + x + ',' + y + ')'; } }
  };
  // A node: a constant, a switch or a gate, each by its number.
  var ZERO = { t: 'zero' }, ONE = { t: 'one' };
  function sw(k) { return { t: 'switch', k: k }; }
  function gt(k) { return { t: 'gate', k: k }; }

  // ---- the netlist ----
  function Net(top) { this.switches = []; this.buses = []; this.gates = []; this.home = []; this.circuits = []; this.top = top || 1; this.labels = []; this.wide = []; }
  Net.prototype.switch_ = function (at, bus) { this.switches.push(at); this.buses.push(bus); return sw(this.switches.length - 1); };
  Net.prototype.put = function (kind, a, b, at) { this.gates.push({ kind: kind, a: a, b: b }); this.home.push(at); return gt(this.gates.length - 1); };
  Net.prototype.non = function (a, at) { return a.t === 'zero' ? ONE : a.t === 'one' ? ZERO : this.put('non', a, ZERO, at); };
  Net.prototype.et = function (a, b, at) {
    if (a.t === 'zero' || b.t === 'zero') return ZERO;
    if (a.t === 'one') return b;
    if (b.t === 'one') return a;
    return this.put('et', a, b, at);
  };
  Net.prototype.vel = function (a, b, at) {
    if (a.t === 'one' || b.t === 'one') return ONE;
    if (a.t === 'zero') return b;
    if (b.t === 'zero') return a;
    return this.put('vel', a, b, at);
  };
  Net.prototype.aut = function (a, b, at) {
    if (a.t === 'zero') return b;
    if (b.t === 'zero') return a;
    if (a.t === 'one') return this.non(b, at);
    if (b.t === 'one') return this.non(a, at);
    return this.put('aut', a, b, at);
  };
  // The bench: an adder of `adder` bits from A1 and a multiplier of `multiplier` bits from I1, either left out at 0; from
  // row `top`, 1 where none is given, and from row 2 on the row above naming its columns (Net::bench_from in Rust).
  Net.bench = function (adder, multiplier, top) {
    var net = new Net(top);
    if (adder > 0) net.adder(adder, 1);
    if (multiplier > 0) net.multiplier(multiplier, 9);
    return net;
  };
  // The bench a person loads (Net::shown).
  Net.shown = function () { return Net.bench(BENCH[0], BENCH[1], BENCH_TOP); };
  // A text naming a column, written where the bench starts below row 1.
  Net.prototype.label = function (at, word) { if (this.top > 1) this.labels.push({ at: at, word: word }); };
  Net.prototype.adder = function (n, c0) {
    var a = [], b = [], i, top = this.top, self = this;
    for (i = 0; i < n; i++) a.push(this.switch_([top + 1 + i, c0], [false, false]));
    for (i = 0; i < n; i++) b.push(this.switch_([top + 1 + i, c0 + 1], [false, false]));
    var carry = this.switch_([top, c0 + 5], [false, false]), c = carry, sum = [];
    ['a', 'b', 'AUT', 'ET', 'ET', 'VEL', 'AUT'].forEach(function (word, k) { self.label([Math.max(top - 1, 0), c0 + k], word); if (top > 1) self.wide.push(c0 + k); });
    for (i = 0; i < n; i++) {
      var r = top + 1 + i;
      var x = this.aut(a[i], b[i], [r, c0 + 2]);
      var g = this.et(a[i], b[i], [r, c0 + 3]);
      var p = this.et(x, c, [r, c0 + 4]);
      var next = this.vel(g, p, [r, c0 + 5]);
      sum.push(this.aut(x, c, [r, c0 + 6]));
      c = next;
    }
    sum.push(c);
    this.circuits.push({ kind: 'adder', bits: n, a: a.map(function (s) { return s.k; }), b: b.map(function (s) { return s.k; }), carry: carry.k, out: sum });
  };
  Net.prototype.multiplier = function (n, m0) {
    var top = this.top, r0 = top + 2, cpp = m0 + 1, w = n + 1, above = Math.max(top - 1, 0), self = this;
    var cx = cpp + w, cg = cpp + 2 * w, cp = cpp + 3 * w, cc = cpp + 4 * w, cs = cpp + 5 * w;
    var a = [], b = [], i, j;
    for (j = 0; j < n; j++) a.push(this.switch_([top, cpp + j], [true, false]));
    [[[above, cpp], 'a'], [[top + 1, m0], 'b'], [[top + 1, cpp], 'ET'], [[above, cx], 'AUT'], [[above, cg], 'ET'], [[above, cp], 'ET'],
     [[above, cc], 'VEL'], [[above, cs], 'AUT']].forEach(function (x) { self.label(x[0], x[1]); });
    for (i = 0; i < n; i++) b.push(this.switch_([r0 + i, m0], [false, true]));
    var pp = [];
    for (i = 0; i < n; i++) { pp.push([]); for (j = 0; j < n; j++) pp[i].push(this.et(a[j], b[i], [r0 + i, cpp + j])); }
    var product = [], sums = pp[0].slice(), carries = [];
    for (j = 0; j < 2 * n; j++) product.push(ZERO);
    for (j = 0; j < n; j++) carries.push(ZERO);
    product[0] = pp[0][0];
    for (i = 1; i < n; i++) {
      var r = r0 + i, nextSums = [], nextCarries = [];
      for (j = 0; j < n; j++) {
        var y = j + 1 < n ? sums[j + 1] : ZERO, z = carries[j];
        var x = this.aut(pp[i][j], y, [r, cx + j]);
        var g = this.et(pp[i][j], y, [r, cg + j]);
        var p = this.et(x, z, [r, cp + j]);
        nextCarries.push(this.vel(g, p, [r, cc + j]));
        nextSums.push(this.aut(x, z, [r, cs + j]));
      }
      product[i] = nextSums[0];
      sums = nextSums; carries = nextCarries;
    }
    var rf = r0 + n, k = ZERO;
    for (j = 0; j < n; j++) {
      var u = j + 1 < n ? sums[j + 1] : ZERO, v = carries[j];
      var x2 = this.aut(u, v, [rf, cx + j]);
      var g2 = this.et(u, v, [rf, cg + j]);
      var p2 = this.et(x2, k, [rf, cp + j]);
      var next = this.vel(g2, p2, [rf, cc + j]);
      product[n + j] = this.aut(x2, k, [rf, cs + j]);
      k = next;
    }
    this.circuits.push({ kind: 'multiplier', bits: n, a: a.map(function (s) { return s.k; }), b: b.map(function (s) { return s.k; }), out: product });
  };
  Net.prototype.value = function (node, switches, gates) { return node.t === 'zero' ? 0 : node.t === 'one' ? 1 : node.t === 'switch' ? switches[node.k] : gates[node.k]; };
  // Every gate's value at full rate: the netlist computed inside one frame, in the order its gates were made.
  Net.prototype.evaluate = function (switches) {
    var gates = new Uint8Array(this.gates.length);
    for (var k = 0; k < this.gates.length; k++) {
      var g = this.gates[k];
      gates[k] = KINDS[g.kind].apply(this.value(g.a, switches, gates), this.value(g.b, switches, gates));
    }
    return gates;
  };
  // Each circuit's outputs read as a whole number, held to integer + and x of its switches; null, or the words.
  Net.prototype.check = function (switches, gates) {
    var self = this;
    function whole(bits) { var v = 0n; for (var i = bits.length - 1; i >= 0; i--) v = v * 2n + BigInt(bits[i]); return v; }
    for (var c = 0; c < this.circuits.length; c++) {
      var ci = this.circuits[c];
      var a = whole(ci.a.map(function (k) { return switches[k]; })), b = whole(ci.b.map(function (k) { return switches[k]; }));
      var got = whole(ci.out.map(function (n) { return self.value(n, switches, gates); }));
      var want = ci.kind === 'adder' ? a + b + BigInt(switches[ci.carry]) : a * b;
      if (got !== want) return 'the ' + ci.bits + (ci.kind === 'adder' ? '-bit adder' : ' by ' + ci.bits + ' multiplier') + '\'s outputs are not the integer answer';
    }
    return null;
  };

  // ---- the dice: Mulberry32, the Rust hand's, below n by multiplying and shifting (exact for n under 2^21) ----
  function Dice(seed) { this.a = seed | 0; }
  Dice.prototype.next = function () {
    this.a = (this.a + 0x6D2B79F5) | 0;
    var t = Math.imul(this.a ^ (this.a >>> 15), 1 | this.a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return (t ^ (t >>> 14)) >>> 0;
  };
  Dice.prototype.below = function (n) { return Math.floor(this.next() * n / 4294967296); };

  // ---- the cells and the block ----
  function letters(c) { var s = ''; while (c > 0) { s = String.fromCharCode(65 + (c - 1) % 26) + s; c = Math.floor((c - 1) / 26); } return s; }
  function a1(row, col, rowHeld, colHeld) { return (colHeld ? '$' : '') + letters(col) + (rowHeld ? '$' : '') + row; }
  function rangeText(r) { return r[0] === r[2] && r[1] === r[3] ? a1(r[0], r[1], false, false) : a1(r[0], r[1], false, false) + ':' + a1(r[2], r[3], false, false); }
  function byRect(x, y) { for (var i = 0; i < 4; i++) if (x[i] !== y[i]) return x[i] - y[i]; return 0; }
  // Cells covered by rectangles: each row's runs of adjacent cells, then runs of the same columns on consecutive rows
  // merged; in the order of their first cells.
  function rectangles(cells) {
    var sorted = cells.slice().sort(function (x, y) { return x[0] - y[0] || x[1] - y[1]; }), segments = [], rects = [], open = {};
    for (var i = 0; i < sorted.length; i++) {
      var r = sorted[i][0], c = sorted[i][1], last = segments[segments.length - 1];
      if (last && last[0] === r && last[2] + 1 === c) { last[2] = c; continue; }
      segments.push([r, c, c]);
    }
    for (var j = 0; j < segments.length; j++) {
      var s = segments[j], key = s[1] + ',' + s[2], at = open[key];
      if (at !== undefined && rects[at][2] + 1 === s[0]) { rects[at][2] = s[0]; continue; }
      rects.push([s[0], s[1], s[0], s[2]]);
      open[key] = rects.length - 1;
    }
    return rects.sort(byRect);
  }
  function article(n) { var s = String(n); return s.charAt(0) === '8' || n === 11 || n === 18 ? 'an' : 'a'; }

  // A netlist laid in cells: lay 'fill' or 'shuffled', switches 'values' or 'stimulus', wiring 'now' or 'last'.
  function Laid(net, lay, switches, wiring) {
    this.net = net; this.cells = net.home.map(function (c) { return [c[0], c[1]]; });
    this.lay = lay; this.switches = switches; this.wiring = wiring;
    if (lay !== 'shuffled') return;
    var d = new Dice(SHUFFLE_SEED), n = this.cells.length, i, t;
    for (i = n - 1; i >= 1; i--) { var j = d.below(i + 1); t = this.cells[i]; this.cells[i] = this.cells[j]; this.cells[j] = t; }
    // Every gate its own shape: a gate whose R1C1 text an earlier gate holds trades cells with a gate drawn at
    // random, until no two hold one text.
    for (;;) {
      var seen = {}, clashes = [];
      for (i = 0; i < n; i++) { var key = this.key(i); if (Object.prototype.hasOwnProperty.call(seen, key)) clashes.push(i); else seen[key] = i; }
      if (!clashes.length) break;
      for (i = 0; i < clashes.length; i++) { var k = clashes[i], m = d.below(n); t = this.cells[k]; this.cells[k] = this.cells[m]; this.cells[m] = t; }
    }
  }
  Laid.prototype.inputs = function (k) { var g = this.net.gates[k]; return KINDS[g.kind].arity === 1 ? [g.a] : [g.a, g.b]; };
  Laid.prototype.place = function (node) {
    if (node.t === 'switch') return { at: this.net.switches[node.k], held: this.lay === 'fill' ? this.net.buses[node.k] : [false, false] };
    if (node.t === 'gate') return { at: this.cells[node.k], held: [false, false] };
    throw new Error('a constant folded away reached a wire');
  };
  Laid.prototype.key = function (k) {
    var at = this.cells[k], s = this.net.gates[k].kind + (this.wiring === 'last' ? ' last' : ''), ins = this.inputs(k);
    for (var i = 0; i < ins.length; i++) {
      var p = this.place(ins[i]);
      s += ' ' + (p.held[0] ? 'R' + p.at[0] : 'R[' + (p.at[0] - at[0]) + ']') + (p.held[1] ? 'C' + p.at[1] : 'C[' + (p.at[1] - at[1]) + ']');
    }
    return s;
  };
  Laid.prototype.reference = function (node) { var p = this.place(node), text = a1(p.at[0], p.at[1], p.held[0], p.held[1]); return this.wiring === 'last' ? SHEET + '.last!' + text : text; };
  // The block's formula rows: the switches' stimulus, a rectangle a row, then the gates, each rectangle of one R1C1
  // text by fill, a cell a gate shuffled; in the order of their first cells.
  Laid.prototype.rows = function () {
    var rows = [], i, at = {};
    if (this.switches === 'stimulus') { var sr = rectangles(this.net.switches); for (i = 0; i < sr.length; i++) rows.push({ rect: sr[i], gate: -1 }); }
    for (i = 0; i < this.cells.length; i++) at[this.cells[i][0] + ',' + this.cells[i][1]] = i;
    var gates = [];
    if (this.lay === 'fill') {
      var groups = {}, order = [];
      for (i = 0; i < this.cells.length; i++) { var key = this.key(i); if (!groups[key]) { groups[key] = []; order.push(key); } groups[key].push(this.cells[i]); }
      for (var g = 0; g < order.length; g++) { var rs = rectangles(groups[order[g]]); for (var q = 0; q < rs.length; q++) gates.push({ rect: rs[q], gate: at[rs[q][0] + ',' + rs[q][1]] }); }
    } else {
      for (i = 0; i < this.cells.length; i++) gates.push({ rect: [this.cells[i][0], this.cells[i][1], this.cells[i][0], this.cells[i][1]], gate: i });
    }
    gates.sort(function (x, y) { return byRect(x.rect, y.rect); });
    return rows.concat(gates);
  };
  // The block's lines: what it holds, the bench's columns, its switches, then a gate form a row.
  Laid.prototype.block = function () {
    var lines = [], i;
    var circuits = this.net.circuits.map(function (c) { return c.kind === 'adder' ? article(c.bits) + ' ' + c.bits + '-bit ripple adder from A1' : article(c.bits) + ' ' + c.bits + ' by ' + c.bits + ' multiplier from I1'; });
    lines.push('; ' + circuits.join(' and ') + ': ' + this.net.gates.length + ' gates ' + (this.lay === 'fill' ? 'laid by fill' : 'shuffled, every gate its own shape') + ', their switches ' + (this.switches === 'values' ? 'values' : 'a hash of the frame'));
    var cols = {}, list = [];
    this.net.switches.concat(this.cells).forEach(function (c) { if (!cols[c[1]]) { cols[c[1]] = true; list.push(c[1]); } });
    list.sort(function (x, y) { return x - y; });
    for (i = 0; i < list.length; i++) lines.push('(column "' + SHEET + '" "' + letters(list[i]) + '" ' + (this.net.wide.indexOf(list[i]) >= 0 ? NAMED_WIDTH : WIDTH) + ' shown none)');
    var labels = this.net.labels.slice().sort(function (x, y) { return x.at[0] - y.at[0] || x.at[1] - y.at[1]; });
    for (i = 0; i < labels.length; i++) lines.push('(cell "' + SHEET + '" "' + a1(labels[i].at[0], labels[i].at[1], false, false) + '" "' + labels[i].word + '")');
    if (this.switches === 'values') { var vr = rectangles(this.net.switches); for (i = 0; i < vr.length; i++) lines.push('(cell "' + SHEET + '" "' + rangeText(vr[i]) + '" 0)'); }
    var rows = this.rows();
    for (i = 0; i < rows.length; i++) {
      var row = rows[i];
      if (row.gate < 0) { lines.push('(formula "' + SHEET + '" "' + rangeText(row.rect) + '" "' + STIMULUS + '")'); continue; }
      var s = '(' + this.net.gates[row.gate].kind + ' "' + rangeText(row.rect) + '"', ins = this.inputs(row.gate);
      for (var k = 0; k < ins.length; k++) s += ' "' + this.reference(ins[k]) + '"';
      lines.push(s + ')');
    }
    return lines;
  };

  // The source with its block's lines replaced, the lines around it as they stand; null where it holds no block.
  function withBlock(source, lines) {
    var eol = source.indexOf('\r\n') >= 0 ? '\r\n' : '\n', all = source.split(eol);
    var begin = all.indexOf(BLOCK_BEGIN), end = all.indexOf(BLOCK_END);
    if (begin < 0 || end <= begin) return null;
    return all.slice(0, begin + 1).concat(lines, all.slice(end)).join(eol);
  }
  // MOD as the language computes it, and a switch's bit under the stimulus at its cell and frame.
  function modulo(n, d) { return n - d * Math.floor(n / d); }
  function stimulus(row, col, frame) {
    var n = row * 40503 + col * 9973 + frame * 65519, u = modulo(n, 65521), v = modulo(u * u, 65521);
    return modulo(Math.floor(v / 256), 2);
  }

  // The floors' source (decision 6): the source with its block's lines replaced, the manifest's (settle K) line taken
  // out, and the lesson's lines with it, each sheet the lesson makes named no more in the manifest's (bound ...), since
  // a cartridge that settles numbers the Clock by acts and the floors' switches read it as the frame, and the lesson is
  // the bench's words to a person; and the keyboard's sheets, (game ...), (work ...) and (read ...) (SPEC.5), a person's
  // keys being nothing the floors press, so that their benches stay the bytes measured; null where it holds no block.
  var LESSON_BEGIN = '; ---- the lesson beside the bench: the floors build their benches without it ----';
  var LESSON_END = '; ---- the lesson\'s end ----';
  // the game's levels (CART.9's third slice), which the floors leave out as they leave the lesson
  var LEVELS_BEGIN = '; ---- the levels: the game, between the lesson and the bench; the floors build their benches without them ----';
  var LEVELS_END = '; ---- the levels\' end ----';
  function floorsSource(source, lines) {
    var built = withBlock(source, lines);
    if (built === null) return null;
    var eol = built.indexOf('\r\n') >= 0 ? '\r\n' : '\n', all = built.split(eol), i;
    for (i = 0; i < all.length; i++) if (/^\s*\(settle /.test(all[i])) { all.splice(i, 1); break; }
    all = all.filter(function (l) { return !/^\s*\((game|work|read) "/.test(l); });
    [[LESSON_BEGIN, LESSON_END], [LEVELS_BEGIN, LEVELS_END]].forEach(function (pair) {
      var b = all.indexOf(pair[0]), e = all.indexOf(pair[1]);
      if (b < 0 || e <= b) return;
      var sheets = [];
      for (i = b; i <= e; i++) { var m = /^\(sheet "([^"]*)"/.exec(all[i]); if (m) sheets.push(' "' + m[1] + '"'); }
      all.splice(b, e - b + 1);
      for (i = 0; i < all.length; i++) {
        if (!/^\s*\(bound /.test(all[i])) continue;
        for (var s = 0; s < sheets.length; s++) all[i] = all[i].replace(sheets[s], '');
        break;
      }
    });
    return all.join(eol);
  }
  // The block's lines as a source holds them, between its two lines; null where it holds none.
  function blockOf(source) {
    var lines = source.split('\n').map(function (l) { return l.replace(/\r$/, ''); });
    var begin = lines.indexOf(BLOCK_BEGIN), end = lines.indexOf(BLOCK_END);
    return end > begin && begin >= 0 ? lines.slice(begin + 1, end) : null;
  }

  // ---- the game by hand (CART.9's third slice, decision 26): engine/src/naught.rs's own, line for line ----
  // A value as the language computes one, spelled as the replay case's handSame compares a record's: a number, a text,
  // true or false, an error { error: '#VALUE!' }, and nothing, null.
  var VALUE = '#VALUE!';
  function isErr(v) { return v !== null && typeof v === 'object' && typeof v.error === 'string'; }
  function fault(k) { return { error: k }; }
  function asciiLower(t) { return t.replace(/[A-Z]/g, function (c) { return c.toLowerCase(); }); }
  // The number an operand coerces to, or its error: a text that spells one, a truth value 1 or 0, nothing 0, and any
  // other text #VALUE!.
  function numberOf(v) {
    if (typeof v === 'number') return v;
    if (typeof v === 'boolean') return v ? 1 : 0;
    if (v === null) return 0;
    if (typeof v === 'string') { var n = textNumber(v); return n === null ? fault(VALUE) : n; }
    return v;
  }
  // The truth a condition reads, or its error: a number not 0, a truth value, nothing FALSE, and a text TRUE or FALSE
  // alone.
  function truthOf(v) {
    if (typeof v === 'boolean') return v;
    if (typeof v === 'number') return v !== 0;
    if (v === null) return false;
    if (typeof v === 'string') { var l = asciiLower(v); return l === 'true' ? true : l === 'false' ? false : fault(VALUE); }
    return v;
  }
  // The text & reads, or its error: a number in its General spelling, a truth value TRUE or FALSE, nothing empty.
  function textOf(v) {
    if (typeof v === 'string') return v;
    if (typeof v === 'number') return general(v);
    if (typeof v === 'boolean') return v ? 'TRUE' : 'FALSE';
    if (v === null) return '';
    return v;
  }
  // A formula's answer as its cell holds it: nothing settles to 0.
  function settled(v) { return v === null ? 0 : v; }
  // A number's General spelling, for the counts the words hold: JavaScript spells every number from 10^-6 to 10^21
  // as Rust does, and the counts are whole and small.
  function general(n) { return String(n); }
  // A text's number as an operand reads it (the language's text_to_number): a sign, digits with one point, an
  // exponent, a percent; null for any other text.
  function textNumber(text) {
    var t = text.trim(), percent = false;
    if (t.charAt(t.length - 1) === '%') { t = t.slice(0, -1).replace(/\s+$/, ''); percent = true; }
    if (!/^[+-]?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?$/.test(t)) return null;
    var v = Number(t);
    return percent ? v / 100 : v;
  }
  // A result no cell can hold is #NUM!; no cell holds -0.
  function finite(v) { return v === 0 ? 0 : isFinite(v) ? v : fault('#NUM!'); }
  // An arithmetic operator over two values, the left's error first.
  function arith(op, a, b) {
    var x = numberOf(a);
    if (isErr(x)) return x;
    var y = numberOf(b);
    if (isErr(y)) return y;
    if (op === '+') return finite(x + y);
    if (op === '-') return finite(x - y);
    if (op === '*') return finite(x * y);
    return y === 0 ? fault('#DIV/0!') : finite(x / y);
  }
  // How two values compare in Excel's order of kinds: nothing is 0, "" or FALSE, whichever the other side is; every
  // number below every text, every text below every truth value; texts without case, by code point. -1, 0 or 1.
  function sign(x, y) { return x < y ? -1 : x > y ? 1 : 0; }
  function rank(v) { return typeof v === 'number' || v === null ? 0 : typeof v === 'string' ? 1 : typeof v === 'boolean' ? 2 : 3; }
  function byCodePoint(x, y) {
    var i = 0, j = 0;
    while (i < x.length && j < y.length) {
      var p = x.codePointAt(i), q = y.codePointAt(j);
      if (p !== q) return p < q ? -1 : 1;
      i += p > 0xffff ? 2 : 1;
      j += q > 0xffff ? 2 : 1;
    }
    return i < x.length ? 1 : j < y.length ? -1 : 0;
  }
  function order(a, b) {
    var ta = typeof a, tb = typeof b;
    if (a === null && b === null) return 0;
    if (a === null && tb === 'number') return sign(0, b);
    if (ta === 'number' && b === null) return sign(a, 0);
    if (a === null && tb === 'string') return b === '' ? 0 : -1;
    if (ta === 'string' && b === null) return a === '' ? 0 : 1;
    if (a === null && tb === 'boolean') return sign(0, b ? 1 : 0);
    if (ta === 'boolean' && b === null) return sign(a ? 1 : 0, 0);
    if (ta === 'number' && tb === 'number') return sign(a, b);
    if (ta === 'string' && tb === 'string') return byCodePoint(a.toLowerCase(), b.toLowerCase());
    if (ta === 'boolean' && tb === 'boolean') return sign(a ? 1 : 0, b ? 1 : 0);
    return sign(rank(a), rank(b));
  }
  // a = b, a < b and a <= b: a truth value or the first error.
  function equal(a, b) { return isErr(a) ? a : isErr(b) ? b : order(a, b) === 0; }
  function less(a, b) { return isErr(a) ? a : isErr(b) ? b : order(a, b) < 0; }
  function lessEqual(a, b) { return isErr(a) ? a : isErr(b) ? b : order(a, b) <= 0; }
  // IF(c, then, else) over a condition's value, the branch taken alone.
  function when(c, then, otherwise) { var t = truthOf(c); return isErr(t) ? t : t ? then() : otherwise(); }
  // AND and OR over values given as conditions, the first error answering.
  function and(items) {
    var all = true;
    for (var i = 0; i < items.length; i++) { var t = truthOf(items[i]); if (isErr(t)) return t; all = all && t; }
    return all;
  }
  function or(items) {
    var any = false;
    for (var i = 0; i < items.length; i++) { var t = truthOf(items[i]); if (isErr(t)) return t; any = any || t; }
    return any;
  }

  // A person's gate as the hand evaluates it (decision 26): numbers; cells of its own level, relative or held;
  // + - * / and a sign; parentheses; and MAX, MIN, MOD and INT, enough for the six gates and any formula of them.
  // Anything else refuses the hand by name. A node: { t: 'num' | 'cell' | 'range' | 'neg' | 'op' | 'call', ... }.
  function gex(formula) {
    var p = { s: Array.from(formula.trim()), i: 1, f: formula };
    if (p.s[0] !== '=') throw new Error(formula + ' is no formula');
    var e = gSum(p);
    gSpace(p);
    if (p.i < p.s.length) throw new Error(gOutside(p));
    return e;
  }
  function gOutside(p) { return 'the hand evaluates the gates\' arithmetic alone, and ' + p.f + ' holds ' + p.s.slice(p.i).join('') + ' at ' + (p.i + 1); }
  function isDigit(c) { return typeof c === 'string' && c >= '0' && c <= '9'; }
  function isAlpha(c) { return typeof c === 'string' && /^[A-Za-z]$/.test(c); }
  function gSpace(p) { while (p.i < p.s.length && p.s[p.i] === ' ') p.i++; }
  function gPeek(p) { gSpace(p); return p.i < p.s.length ? p.s[p.i] : null; }
  function gSum(p) {
    var e = gProduct(p), c;
    while ((c = gPeek(p)) === '+' || c === '-') { p.i++; e = { t: 'op', op: c, x: e, y: gProduct(p) }; }
    return e;
  }
  function gProduct(p) {
    var e = gUnary(p), c;
    while ((c = gPeek(p)) === '*' || c === '/') { p.i++; e = { t: 'op', op: c, x: e, y: gUnary(p) }; }
    return e;
  }
  function gUnary(p) {
    var c = gPeek(p);
    if (c === '-') { p.i++; return { t: 'neg', x: gUnary(p) }; }
    if (c === '+') { p.i++; return gUnary(p); }
    return gPrimary(p);
  }
  function gPrimary(p) {
    var c = gPeek(p), from, e;
    if (c === '(') {
      p.i++;
      e = gSum(p);
      if (gPeek(p) !== ')') throw new Error(gOutside(p));
      p.i++;
      return e;
    }
    if (isDigit(c) || c === '.') {
      from = p.i;
      while (p.i < p.s.length && (isDigit(p.s[p.i]) || p.s[p.i] === '.')) p.i++;
      var digits = p.s.slice(from, p.i).join('');
      if (!/^(\d+\.?\d*|\.\d+)$/.test(digits)) throw new Error(gOutside(p));
      return { t: 'num', n: Number(digits) };
    }
    if (isAlpha(c) || c === '$') {
      from = p.i;
      var word = '';
      for (var j = p.i; j < p.s.length && isAlpha(p.s[j]); j++) word += p.s[j];
      if (p.s[p.i + word.length] === '(') {
        var name = word.toUpperCase();
        if (name !== 'MAX' && name !== 'MIN' && name !== 'MOD' && name !== 'INT') throw new Error(gOutside(p));
        p.i += word.length + 1;
        var args = [];
        for (;;) {
          args.push(name === 'MAX' || name === 'MIN' ? gArgument(p) : gSum(p));
          var d = gPeek(p);
          if (d === ',') p.i++;
          else if (d === ')') { p.i++; break; }
          else throw new Error(gOutside(p));
        }
        var arity = name === 'MOD' ? args.length === 2 : name === 'INT' ? args.length === 1 : args.length > 0;
        if (!arity) throw new Error(gOutside(p));
        return { t: 'call', name: name, args: args };
      }
      p.i = from;
      var rc = gCell(p);
      if (!rc) throw new Error(gOutside(p));
      return { t: 'cell', r: rc[0], c: rc[1] };
    }
    throw new Error(gOutside(p));
  }
  // An argument of MAX or MIN: a cell, a range, or a value.
  function gArgument(p) {
    var from = p.i;
    gSpace(p);
    var rc = gCell(p);
    if (rc) {
      if (p.s[p.i] === ':') {
        p.i++;
        var rc2 = gCell(p);
        if (!rc2) throw new Error(gOutside(p));
        return { t: 'range', r1: Math.min(rc[0], rc2[0]), c1: Math.min(rc[1], rc2[1]), r2: Math.max(rc[0], rc2[0]), c2: Math.max(rc[1], rc2[1]) };
      }
      var d = gPeek(p);
      if (d === ',' || d === ')') return { t: 'cell', r: rc[0], c: rc[1] };
    }
    p.i = from;
    return gSum(p);
  }
  // A cell's address, $ held or not: [row, column], or null.
  function gCell(p) {
    gSpace(p);
    var s = p.s, i = p.i, col = 0, row = 0;
    if (s[i] === '$') i++;
    var from = i;
    while (i < s.length && isAlpha(s[i])) { col = col * 26 + (s[i].toUpperCase().charCodeAt(0) - 64); i++; }
    if (i === from || i - from > 3) return null;
    if (s[i] === '$') i++;
    var digits = i;
    while (i < s.length && isDigit(s[i])) { row = row * 10 + (s[i].charCodeAt(0) - 48); i++; }
    if (i === digits || row === 0 || (i < s.length && (/^[A-Za-z0-9]$/.test(s[i]) || s[i] === '!' || s[i] === '('))) return null;
    p.i = i;
    return [row, col];
  }
  // The cells a gate reads.
  function gReads(g, out) {
    if (g.t === 'cell') out.push([g.r, g.c]);
    else if (g.t === 'range') { for (var r = g.r1; r <= g.r2; r++) for (var c = g.c1; c <= g.c2; c++) out.push([r, c]); }
    else if (g.t === 'neg') gReads(g.x, out);
    else if (g.t === 'op') { gReads(g.x, out); gReads(g.y, out); }
    else if (g.t === 'call') for (var i = 0; i < g.args.length; i++) gReads(g.args[i], out);
  }
  // A gate's value, the cells it reads answered by cell(row, column).
  function gEval(g, cell) {
    var x, y, i;
    if (g.t === 'num') return g.n;
    if (g.t === 'cell') return cell(g.r, g.c);
    if (g.t === 'range') return fault(VALUE);
    if (g.t === 'neg') { x = numberOf(gEval(g.x, cell)); return isErr(x) ? x : finite(-x); }
    if (g.t === 'op') {
      x = gEval(g.x, cell);
      if (isErr(x)) return x;
      y = gEval(g.y, cell);
      if (isErr(y)) return y;
      return arith(g.op, x, y);
    }
    if (g.name === 'MAX' || g.name === 'MIN') {
      var items = [];
      for (i = 0; i < g.args.length; i++) {
        var a = g.args[i];
        if (a.t === 'cell' || a.t === 'range') {
          var cells = [], first = null;
          gReads(a, cells);
          for (var j = 0; j < cells.length; j++) {
            var v = cell(cells[j][0], cells[j][1]);
            if (typeof v === 'number') items.push(v);
            else if (isErr(v) && first === null) first = v;
          }
          if (first !== null) return first;
        } else {
          x = numberOf(gEval(a, cell));
          if (isErr(x)) return x;
          items.push(x);
        }
      }
      if (!items.length) return 0;
      var m = items[0];
      for (i = 1; i < items.length; i++) m = g.name === 'MAX' ? Math.max(m, items[i]) : Math.min(m, items[i]);
      return m;
    }
    if (g.name === 'MOD') {
      x = numberOf(gEval(g.args[0], cell));
      if (isErr(x)) return x;
      y = numberOf(gEval(g.args[1], cell));
      if (isErr(y)) return y;
      return y === 0 ? fault('#DIV/0!') : finite(x - y * Math.floor(x / y));
    }
    x = numberOf(gEval(g.args[0], cell));
    return isErr(x) ? x : Math.floor(x);
  }

  // The nine levels in tab order (decisions 16 to 21), I NON the first: each its sheet, its switches and outputs, its
  // room's rows from row 3 to the board's last, its budget, its least known and the last kind of gate it gives (kind);
  // their switches' and outputs' names, the B and K columns; and the inputs a test runs through, the Lab's B7.
  var LEVELS = [
    { sheet: 'I NON', inputs: 1, outputs: 1, rows: 8, budget: 2, least: 1, gives: 2 },
    { sheet: 'II ET', inputs: 2, outputs: 1, rows: 8, budget: 3, least: 2, gives: 3 },
    { sheet: 'III VEL', inputs: 2, outputs: 1, rows: 8, budget: 4, least: 3, gives: 4 },
    { sheet: 'IV AUT', inputs: 2, outputs: 1, rows: 8, budget: 5, least: 3, gives: 5 },
    { sheet: 'V ELIGE', inputs: 3, outputs: 1, rows: 8, budget: 5, least: 3, gives: 6 },
    { sheet: 'VI DISTRIBUE', inputs: 2, outputs: 2, rows: 8, budget: 4, least: 2, gives: 6 },
    { sheet: 'VII SEMIS', inputs: 2, outputs: 2, rows: 8, budget: 3, least: 2, gives: 6 },
    { sheet: 'VIII SUMMA', inputs: 3, outputs: 2, rows: 8, budget: 6, least: 5, gives: 6 },
    { sheet: 'IX QUATTUOR', inputs: 9, outputs: 5, rows: 9, budget: 21, least: 20, gives: 6 }
  ];
  var NAMES = [
    [['a'], ['y']],
    [['a', 'b'], ['y']],
    [['a', 'b'], ['y']],
    [['a', 'b'], ['y']],
    [['a', 'b', 's'], ['y']],
    [['x', 's'], ['to 0', 'to 1']],
    [['a', 'b'], ['sum', 'carry']],
    [['a', 'b', 'c'], ['sum', 'carry']],
    [['a0', 'a1', 'a2', 'a3', 'b0', 'b1', 'b2', 'b3', 'c'], ['s0', 's1', 's2', 's3', 'carry']]
  ];
  var VECTORS = [2, 4, 4, 4, 8, 4, 4, 8, 512];
  // The bit of the input's number that input s takes while a test runs, MOD(INT(B6/2^s),2).
  function bit(b6, s) { var v = numberOf(b6); return isErr(v) ? v : finite(modulo(Math.floor(v / Math.pow(2, s)), 2)); }
  // A level's inputs as its test reads them, the Lab's column of them from row 21: while its test runs (here, the
  // Lab's N, is 1), the bits of the input's number; and otherwise its switches as they stand, an empty one 0.
  function tested(here, b6, standing) {
    return standing.map(function (v, s) { return settled(when(equal(here, 1), function () { return bit(b6, s); }, function () { return v; })); });
  }
  // Level k's outputs due, as the Lab's formulas compute them from its inputs as its test reads them (decision 17's
  // specification).
  function due(k, s) {
    function maxOf(xs) {
      var items = [];
      for (var i = 0; i < xs.length; i++) { if (typeof xs[i] === 'number') items.push(xs[i]); else if (isErr(xs[i])) return xs[i]; }
      return items.length ? Math.max.apply(null, items) : 0;
    }
    function mod2(v) { var x = numberOf(v); return isErr(x) ? x : finite(x - 2 * Math.floor(x / 2)); }
    function int(v) { var x = numberOf(v); return isErr(x) ? x : Math.floor(x); }
    var t;
    if (k === 0) return [arith('-', 1, s[0])];
    if (k === 1) return [arith('*', s[0], s[1])];
    if (k === 2) return [maxOf([s[0], s[1]])];
    if (k === 3) return [mod2(arith('+', s[0], s[1]))];
    if (k === 4) return [settled(when(equal(s[2], 1), function () { return s[1]; }, function () { return s[0]; }))];
    if (k === 5) return [arith('*', s[0], arith('-', 1, s[1])), arith('*', s[0], s[1])];
    if (k === 6) { t = arith('+', s[0], s[1]); return [mod2(t), int(arith('/', t, 2))]; }
    if (k === 7) { t = arith('+', arith('+', s[0], s[1]), s[2]); return [mod2(t), int(arith('/', t, 2))]; }
    t = s[0];
    [[1, 2], [2, 4], [3, 8]].forEach(function (p) { t = arith('+', t, arith('*', p[1], s[p[0]])); });
    [[4, 1], [5, 2], [6, 4], [7, 8]].forEach(function (p) { t = arith('+', t, p[1] === 1 ? s[p[0]] : arith('*', p[1], s[p[0]])); });
    t = arith('+', t, s[8]);
    return [mod2(t), mod2(int(arith('/', t, 2))), mod2(int(arith('/', t, 4))), mod2(int(arith('/', t, 8))), int(arith('/', t, 16))];
  }

  // A formula's text as the Gates sheet reads it, FORMULATEXT with its spaces and its $ gone and upper-cased (the short
  // slice of 2026-10-24).
  function gateText(formula) { return formula.replace(/[ $]/g, '').replace(/[a-z]/g, function (c) { return c.toUpperCase(); }); }
  // The inputs a gate of level k may read, the Lab's P, between bars: its switches, the cells of its room row by row, 0
  // and 1.
  function inputsOf(k) {
    var level = LEVELS[k], out = '|', s, row, c;
    for (s = 0; s < level.inputs; s++) out += 'A' + (3 + s) + '|';
    for (row = 3; row < 3 + level.rows; row++) for (c = 0; c < 8; c++) out += 'CDEFGHIJ'.charAt(c) + row + '|';
    return out + '0|1|';
  }
  // MID(f, start, n) over a text's characters: null for an error, a start before the first or a length below 0.
  function mid(f, start, n) { return start < 1 || n < 0 ? null : f.slice(start - 1, start - 1 + n); }
  // FIND(c, f): the place of a text's first c, from 1, or null.
  function find(f, c) { var i = f.indexOf(c); return i < 0 ? null : i + 1; }
  // A room cell's kind by its formula's text as gateText reads it, as the Gates sheet computes it: 0 no formula; a gate
  // of the set, 1 a wire =x, 2 NON-ET =1-x*y, 3 NON =1-x, 4 ET =x*y, 5 VEL =MAX(x,y), 6 AUT =MOD(x+y,2), each input
  // among inputs, inputsOf the level's; and 9 any other formula.
  function kind(f, inputs) {
    if (f === '') return 0;
    var len = f.length, star = find(f, '*'), comma = find(f, ','), plus = find(f, '+');
    var among = function (x) { return x !== null && inputs.indexOf('|' + x + '|') >= 0; };
    var pair = function (x, y) { return among(x) && among(y); };
    var starts = function (p) { return f.slice(0, p.length) === p; };
    if (among(mid(f, 2, 99))) return 1;
    if (starts('=1-') && star !== null && pair(mid(f, 4, star - 4), mid(f, star + 1, 99))) return 2;
    if (starts('=1-') && among(mid(f, 4, 99))) return 3;
    if (star !== null && pair(mid(f, 2, star - 2), mid(f, star + 1, 99))) return 4;
    if (starts('=MAX(') && f.slice(-1) === ')' && comma !== null && pair(mid(f, 6, comma - 6), mid(f, comma + 1, len - comma - 1))) return 5;
    if (starts('=MOD(') && f.slice(-3) === ',2)' && plus !== null && pair(mid(f, 6, plus - 6), mid(f, plus + 1, len - plus - 3))) return 6;
    return 9;
  }
  // The address of a room's cell by its place in the room read row by row from C3, eight cells a row, 1 the first: the
  // Lab's R and S.
  function roomAddress(i) { return 'CDEFGHIJ'.charAt((i - 1) % 8) + (3 + Math.floor((i - 1) / 8)); }

  // The game by hand, the levels and the Lab frame by frame, as the cartridge's formulas compute them, its own
  // arithmetic and no formula of the cartridge's: what the replay's frames are held to.
  function Game() {
    var zeros = function (n, v) { var z = []; for (var i = 0; i < n; i++) z.push(v); return z; };
    // each level's cells a person wrote, by 'row,column': { value }, or { formula, text }, the hand's reading of a
    // formula and its text as written
    this.written = LEVELS.map(function () { return {}; });
    // each level's switches, this frame and the last
    this.switches = LEVELS.map(function (l) { return zeros(l.inputs, 0); });
    this.switchesLast = LEVELS.map(function (l) { return zeros(l.inputs, null); });
    // each level's cells as this frame computes them, by 'row,column'
    this.board = LEVELS.map(function () { return {}; });
    // each level's room as the Gates sheet reads it this frame, row by row from C3: each cell's formula's text
    // (gateText, empty for none) and its kind (kind)
    this.texts = LEVELS.map(function () { return []; });
    this.kinds = LEVELS.map(function () { return []; });
    // the Lab, its cells by address, this frame and the last
    this.lab = {};
    this.labLast = {};
    // the Input rows standing
    this.input = { sheet: '', col: 0, row: 0, press: false, command: '' };
  }
  // A level by its sheet's name, its case aside; -1 for none.
  Game.level = function (sheet) {
    for (var k = 0; k < LEVELS.length; k++) if (asciiLower(LEVELS[k].sheet) === asciiLower(sheet)) return k;
    return -1;
  };
  function own(o, at) { return Object.prototype.hasOwnProperty.call(o, at); }
  // A person's row into a level, { value } or { formula }, over a cell or a range, [top, left, bottom, right]. A row
  // into any other sheet of the game's is refused by the hand, which models none.
  Game.prototype.write = function (sheet, rect, what) {
    var k = Game.level(sheet);
    if (k < 0) throw new Error('the hand models no person\'s row into ' + sheet);
    if (what.formula) {
      var reads = [];
      gReads(what.formula, reads);
      if (rect[0] !== rect[2] || rect[1] !== rect[3]) throw new Error('the hand writes a formula into one cell, not ' + rect.join(','));
      for (var i = 0; i < reads.length; i++) {
        if (reads[i][0] < 3 || reads[i][1] > 13) throw new Error('the hand evaluates a gate\'s reads of its board alone, not row ' + reads[i][0] + ' column ' + reads[i][1]);
      }
    }
    for (var r = rect[0]; r <= rect[2]; r++) for (var c = rect[1]; c <= rect[3]; c++) this.written[k][r + ',' + c] = what;
  };
  Game.prototype.labOf = function (at) { return own(this.lab, at) ? this.lab[at] : null; };
  Game.prototype.last = function (at) { return own(this.labLast, at) ? this.labLast[at] : null; };
  // One frame: the act's Input rows, or a settle step's, the press and the command released; every level and the Lab
  // computed.
  Game.prototype.frame = function (act) {
    if (act) this.input = { sheet: act.sheet, col: act.col, row: act.row, press: act.press, command: act.command };
    else { this.input.press = false; this.input.command = ''; }
    this.labLast = this.lab;
    this.lab = {};
    this.switchesLast = this.switches.map(function (s) { return s.slice(); });
    var i = this.input, lab = this.lab;
    var is = function (w) { return equal(i.command, w) === true; };
    // B1 the level the act stands on
    var shown = Game.level(i.sheet) + 1;
    lab.B1 = shown;
    // B2 the level N and P move to, B3 the Camera's sheet
    var lb2 = this.last('B2'), lastB2 = typeof lb2 === 'number' ? Math.max(lb2, 1) : 1;
    var b2 = is('next') && shown > 0 ? Math.min(shown + 1, 9) : is('previous') && shown > 0 ? Math.max(shown - 1, 1) : lastB2;
    lab.B2 = b2;
    lab.B3 = is('next') || is('previous') ? LEVELS[b2 - 1].sheet : '';
    // B4 the level under test, B5 whether it runs, B6 its input, B7 its inputs
    var b4 = is('test') ? shown : settled(this.last('B4'));
    lab.B4 = b4;
    var b5;
    if (is('test')) b5 = shown > 0 ? 1 : 0;
    else if (is('reset')) b5 = 0;
    else {
      var l5 = this.last('B5'), l8 = this.last('B8'), l6 = this.last('B6'), l7 = this.last('B7');
      b5 = when(equal(l5, 1), function () {
        return when(and([equal(l8, 1), less(l6, arith('-', l7, 1))]), function () { return 1; }, function () { return 0; });
      }, function () { return 0; });
    }
    lab.B5 = b5;
    var b6;
    if (is('test')) b6 = 0;
    else {
      var m5 = this.last('B5'), m6 = this.last('B6');
      b6 = settled(when(and([equal(m5, 1), equal(b5, 1)]), function () { return arith('+', m6, 1); }, function () { return m6; }));
    }
    lab.B6 = b6;
    var under = typeof b4 === 'number' && b4 >= 1 ? Math.floor(b4) : 1;
    lab.B7 = VECTORS[under - 1];
    // each level: whether its test runs, its switches, its board, its due and whether every output is due
    var k, r;
    for (k = 0; k < 9; k++) {
      r = 11 + k;
      var level = LEVELS[k], kk = k + 1;
      var here = settled(when(equal(b4, kk), function () { return b5; }, function () { return 0; }));
      lab['N' + r] = here;
      var onLevel = Game.level(i.sheet) === k;
      for (var s = 0; s < level.inputs; s++) {
        var row = 3 + s;
        if (own(this.written[k], row + ',1')) continue;
        var lastS = this.switchesLast[k][s];
        this.switches[k][s] = is('reset') && onLevel ? 0 : when(equal(here, 1), function () { return bit(b6, s); }, function () {
          if (onLevel && i.col === 1 && i.row === row) {
            if (is('one')) return 1;
            if (is('zero')) return 0;
            if (is('toggle') || i.press) return arith('-', 1, lastS);
          }
          return settled(lastS);
        });
      }
      this.computeBoard(k, here, b6);
      var sw = [];
      for (s = 0; s < level.inputs; s++) sw.push(this.cell(k, 3 + s, 1));
      var inputs = tested(here, b6, sw);
      for (s = 0; s < inputs.length; s++) lab[String.fromCharCode(66 + k) + (21 + s)] = inputs[s];
      var owed = due(k, inputs), equals = [];
      for (var o = 0; o < owed.length; o++) {
        lab['IJKLM'.charAt(o) + r] = owed[o];
        equals.push(equal(this.cell(k, 3 + o, 10), owed[o]));
      }
      if (k === 8) {
        var t = inputs[0];
        [[1, 2], [2, 4], [3, 8], [4, 1], [5, 2], [6, 4], [7, 8], [8, 1]].forEach(function (p) { t = arith('+', t, p[1] === 1 ? inputs[p[0]] : arith('*', p[1], inputs[p[0]])); });
        lab.O19 = t;
      }
      // an output holding an error is never due
      var ok = when(and(equals), function () { return 1; }, function () { return 0; });
      lab['D' + r] = isErr(ok) ? 0 : ok;
      // the gates: every formula of its room, each read by its text as one of the set or outside it; and the room's
      // first cell holding an error
      var ops = inputsOf(k), texts = [], kinds = [], error = 0;
      for (var gr = 3; gr < 3 + level.rows; gr++) {
        for (var gc = 3; gc <= 10; gc++) {
          var w = own(this.written[k], gr + ',' + gc) ? this.written[k][gr + ',' + gc] : null;
          var gt = w && w.formula ? gateText(w.text) : '';
          kinds.push(kind(gt, ops));
          texts.push(gt);
          if (!error && isErr(this.cell(k, gr, gc))) error = texts.length;
        }
      }
      var outside = 0, first = 0, gates = 0;
      for (var q = 0; q < kinds.length; q++) {
        if (kinds[q] > level.gives) { outside++; if (!first) first = q + 1; }
        if (kinds[q] > 0) gates++;
      }
      lab['E' + r] = gates;
      lab['F' + r] = level.budget;
      lab['G' + r] = level.least;
      lab['P' + r] = ops;
      lab['Q' + r] = outside;
      lab['R' + r] = first ? roomAddress(first) : '';
      lab['S' + r] = error ? roomAddress(error) : '';
      this.texts[k] = texts;
      this.kinds[k] = kinds;
    }
    lab.B8 = lab['D' + (10 + under)];
    // each level's result and the input its test stopped at, then its stars
    var L4 = this.last('B4'), L5 = this.last('B5'), L8 = this.last('B8'), L6 = this.last('B6');
    for (k = 0; k < 9; k++) {
      r = 11 + k;
      var n = k + 1, lastB = settled(this.last('B' + r)), lastC = settled(this.last('C' + r));
      var away = function (v) { var e = equal(v, n); return typeof e === 'boolean' ? !e : e; };
      var gone = or([away(L4), away(b4)]);
      var result = is('reset') && shown === n ? 0 : when(gone, function () { return lastB; }, function () {
        return when(and([equal(L5, 1), equal(b5, 0)]), function () { return when(equal(L8, 1), function () { return 1; }, function () { return 2; }); }, function () { return lastB; });
      });
      var stopped = when(gone, function () { return lastC; }, function () {
        return when(and([equal(L5, 1), equal(b5, 0)]), function () { return settled(L6); }, function () { return lastC; });
      });
      lab['B' + r] = result;
      lab['C' + r] = stopped;
      // its gates and those outside the set when its test last ended, which its stars read
      var atTestEnd = function (col, now) {
        var last = settled(this.last(col + r));
        return when(gone, function () { return last; }, function () {
          return when(and([equal(L5, 1), equal(b5, 0)]), function () { return lab[now + r]; }, function () { return last; });
        });
      }.bind(this);
      var t = lab['T' + r] = atTestEnd('T', 'E'), u = lab['U' + r] = atTestEnd('U', 'Q'), f = lab['F' + r], g = lab['G' + r];
      lab['H' + r] = when(equal(result, 1), function () {
        return when(less(0, u), function () { return '\u2605\u2606\u2606'; }, function () {
          return when(lessEqual(t, g), function () { return '\u2605\u2605\u2605'; }, function () {
            return when(lessEqual(t, f), function () { return '\u2605\u2605\u2606'; }, function () { return '\u2605\u2606\u2606'; });
          });
        });
      }, function () { return '\u2606\u2606\u2606'; });
    }
  };
  // A level's cell as this frame computes it.
  Game.prototype.cell = function (k, row, col) { var v = this.board[k][row + ',' + col]; return v === undefined ? null : v; };
  // A level's board this frame: its switches, a person's cells, its lamps and its due, each a cell's value; a person's
  // formula evaluated over the cells it reads, in their order. here and b6, the Lab's N and B6, which the due's inputs
  // read.
  Game.prototype.computeBoard = function (k, here, b6) {
    var level = LEVELS[k], last = 2 + Math.max(level.rows, level.inputs), board = {}, doing = {};
    var switches = this.switches[k], written = this.written[k];
    function value(row, col) {
      var at = row + ',' + col, v;
      if (own(board, at)) return board[at];
      if (doing[at]) return fault('#CYCLE');
      doing[at] = true;
      var w = own(written, at) ? written[at] : null;
      if (w && w.formula) v = settled(gEval(w.formula, value));
      else if (w) v = w.value;
      else if (col === 1 && row >= 3 && row < 3 + level.inputs) v = switches[row - 3];
      else if (col === 12 && row >= 3 && row < 3 + level.outputs) {
        v = when(equal(value(row, 10), 1), function () { return '\u25cf'; }, function () { return '\u25cb'; });
        if (isErr(v)) v = '?';
      }
      else if (col === 13 && row >= 3 && row < 3 + level.outputs) {
        var sw = [];
        for (var s = 0; s < level.inputs; s++) sw.push(value(3 + s, 1));
        v = due(k, tested(here, b6, sw))[row - 3];
      } else if (col === 2 && row >= 3 && row < 3 + level.inputs) v = NAMES[k][0][row - 3];
      else if (col === 11 && row >= 3 && row < 3 + level.outputs) v = NAMES[k][1][row - 3];
      else v = null;
      delete doing[at];
      board[at] = v;
      return v;
    }
    for (var row = 3; row <= last; row++) for (var col = 1; col <= 13; col++) value(row, col);
    for (var at in written) if (own(written, at)) { var rc = at.split(','); value(+rc[0], +rc[1]); }
    // a switch a person wrote over is that cell's value from now on
    for (var s = 0; s < level.inputs; s++) {
      if (own(written, (3 + s) + ',1')) this.switches[k][s] = own(board, (3 + s) + ',1') ? board[(3 + s) + ',1'] : null;
    }
    this.board[k] = board;
  };
  // A level's reckoning and verdict, its N8 and N9, as the words say them: its gates, those outside the set and the
  // first of them, and its last test's stars; its test, and the room's first cell holding an error.
  Game.prototype.words = function (k) {
    var r = 11 + k, level = LEVELS[k], inputs = VECTORS[k], self = this;
    var lab = function (col) { return self.labOf(col + r); };
    var outside = when(less(0, lab('Q')), function () {
      var q = textOf(lab('Q')), at = textOf(lab('R'));
      return isErr(q) ? q : isErr(at) ? at : ', ' + q + ' outside the set given, the first at ' + at;
    }, function () { return ''; });
    var e = textOf(lab('E')), o = textOf(outside), h = textOf(lab('H'));
    var reckoning = isErr(e) ? e : isErr(o) ? o : isErr(h) ? h : 'Gates ' + e + o + '; the budget ' + level.budget + ', the least known ' + level.least + ': ' + h;
    var error = function (tail) {
      var at = textOf(lab('S'));
      return isErr(at) ? at : at + ' holds an error: it reads a text, an emptied cell or an error.' + tail;
    };
    var verdict = when(equal(lab('N'), 1), function () {
      var t = textOf(arith('+', self.labOf('B6'), 1));
      return isErr(t) ? t : 'Calculemus: input ' + t + ' of ' + inputs;
    }, function () {
      return when(equal(lab('B'), 2), function () {
        var at = when(equal(lab('S'), ''), function () { return 'a lamp differs from its due.'; }, function () { return error(''); });
        var t = textOf(arith('+', lab('C'), 1)), a = textOf(at);
        return isErr(t) ? t : isErr(a) ? a : 'The test stops at input ' + t + ' of ' + inputs + ', standing on the board: ' + a;
      }, function () {
        return when(equal(lab('S'), ''), function () {
          return when(equal(lab('B'), 1), function () { return 'Quod erat demonstrandum: every one of its ' + inputs + ' inputs passes.'; },
            function () { return 'T tests every input, an input a frame. Calculemus!'; });
        }, function () { return error(' Ex nihilo nihil fit.'); });
      });
    });
    return [reckoning, verdict];
  };
  // The cells a frame holds, by Sheet!A1, as the engine's tests hold them (naught_game_holds): each level's board, A3
  // to M at its last row, and its words; the Lab's state, its levels' rows and their inputs as tested; the Camera's
  // sheet; and the Gates sheet, each room cell's text and kind, a level's block 20 rows apart from row 3.
  Game.prototype.cells = function (out) {
    var k, s, at = [];
    for (k = 0; k < LEVELS.length; k++) {
      var level = LEVELS[k], last = 2 + Math.max(level.rows, level.inputs);
      for (var row = 3; row <= last; row++) for (var col = 1; col <= 13; col++) out[level.sheet + '!' + a1(row, col, false, false)] = this.cell(k, row, col);
      var w = this.words(k);
      out[level.sheet + '!N8'] = w[0];
      out[level.sheet + '!N9'] = w[1];
    }
    for (var r = 1; r <= 8; r++) at.push('B' + r);
    for (r = 11; r <= 19; r++) for (s = 0; s < 14; s++) at.push('BCDEFGHNPQRSTU'.charAt(s) + r);
    for (k = 0; k < LEVELS.length; k++) for (s = 0; s < LEVELS[k].outputs; s++) at.push('IJKLM'.charAt(s) + (11 + k));
    at.push('O19');
    for (k = 0; k < LEVELS.length; k++) for (s = 0; s < LEVELS[k].inputs; s++) at.push(String.fromCharCode(66 + k) + (21 + s));
    for (var j = 0; j < at.length; j++) out['Lab!' + at[j]] = this.labOf(at[j]);
    out['Camera!B3'] = this.labOf('B3');
    for (k = 0; k < LEVELS.length; k++) {
      for (var g = 0; g < this.kinds[k].length; g++) {
        var gr = 3 + 20 * k + Math.floor(g / 8), gc = 3 + g % 8;
        out['Gates!' + a1(gr, gc, false, false)] = this.texts[k][g];
        out['Gates!' + a1(gr, gc + 10, false, false)] = this.kinds[k][g];
      }
    }
  };
  // A row's cell or range, 'C4:C5', as [top, left, bottom, right].
  function rect(text) {
    var m = /^\$?([A-Za-z]{1,3})\$?(\d+)(?::\$?([A-Za-z]{1,3})\$?(\d+))?$/.exec(text), col = function (l) {
      var c = 0;
      for (var i = 0; i < l.length; i++) c = c * 26 + (l.toUpperCase().charCodeAt(i) - 64);
      return c;
    };
    if (!m) throw new Error(JSON.stringify(text) + ' is no cell or range');
    var a = [+m[2], col(m[1])], b = m[3] ? [+m[4], col(m[3])] : a;
    return [Math.min(a[0], b[0]), Math.min(a[1], b[1]), Math.max(a[0], b[0]), Math.max(a[1], b[1])];
  }
  // A row's value as the reader gives it: a number or a text.
  function datum(d) {
    if (typeof d === 'string') return d;
    if (d && d.num !== undefined) return d.num;
    throw new Error('the hand models no value ' + JSON.stringify(d));
  }

  // A replay of the committed session (ENGINE.16): the bench, then the levels. The Bench's switches as the replay's
  // rows leave them, each 0 or 1, and each frame answers every gate's value at full rate, the circuits held to integer
  // + and x; and the game by hand, its acts the replay's Input rows as the recorder logged them, the engine's release
  // of an act's press and command mirrored after its frame, and a person's rows into the levels. Made, it lays the
  // bench and holds its block to the one the page's own block source-naught holds, line for line, so that this writer
  // and the Rust one are held to each other at every push, as the floors hold them at the floors' size.
  function NaughtHand() {
    var el = typeof document !== 'undefined' ? document.getElementById('source-naught') : null;
    if (!el) throw new Error('the page holds no source-naught block, whose bench the hand lays');
    this.net = Net.shown();
    this.laid = new Laid(this.net, 'fill', 'values', 'now');
    var held = blockOf(el.textContent), mine = this.laid.block();
    if (!held) throw new Error('the source-naught block holds no bench between its two lines');
    for (var i = 0; i < Math.max(held.length, mine.length); i++) {
      if (held[i] !== mine[i]) throw new Error('the bench the source-naught block holds is not the one the hand lays, at the block\'s line ' + (i + 1) + ': ' + JSON.stringify(held[i] === undefined ? 'no line' : held[i]) + ' against ' + JSON.stringify(mine[i] === undefined ? 'no line' : mine[i]));
    }
    this.switches = new Uint8Array(this.net.switches.length);
    this.at = {};
    for (var k = 0; k < this.net.switches.length; k++) this.at[a1(this.net.switches[k][0], this.net.switches[k][1], false, false)] = k;
    this.edits = 0; this.lit = 0; this.written = 0;
    this.game = new Game();
    // the Input rows as the recorder last logged them
    this.input = { B11: 0, B12: 0, B13: 0, B14: 0, B15: 0, B19: '', B20: '' };
  }
  NaughtHand.prototype.frame = function (n, rows) {
    var I = this.input;
    for (var r = 0; r < rows.length; r++) {
      var row = rows[r], head = Array.isArray(row) && row[0] ? row[0].sym : '';
      if ((head !== 'cell' && head !== 'formula') || typeof row[1] !== 'string' || typeof row[2] !== 'string') throw new Error('the hand models no row ' + JSON.stringify(row));
      if (head === 'cell' && row[1] === 'Input') {
        if (!own(I, row[2])) throw new Error('the hand models no Input row ' + row[2]);
        I[row[2]] = datum(row[3]);
        continue;
      }
      if (head === 'cell' && row[1] === SHEET) {
        var k = this.at[row[2]], v = row[3] && row[3].num !== undefined ? row[3].num : null;
        if (k === undefined) throw new Error(row[2] + ' is no switch of the bench');
        if (v !== 0 && v !== 1) throw new Error('the switch ' + row[2] + ' is written ' + JSON.stringify(row[3]) + ', where the hand holds 0 or 1');
        this.switches[k] = v;
        this.edits++;
        continue;
      }
      this.game.write(row[1], rect(row[2]), head === 'formula' ? { formula: gex(row[3]), text: row[3] } : { value: datum(row[3]) });
      this.written++;
    }
    // a frame with rows is an act's, and one with none a settle step's, before which the engine released the act's
    // press and command
    var act = rows.length > 0;
    this.game.frame(act ? { sheet: I.B19, col: I.B11, row: I.B12, press: I.B13 === 1, command: I.B20 } : null);
    if (act) { I.B13 = 0; I.B14 = 0; I.B15 = 0; I.B20 = ''; }
    var gates = this.net.evaluate(this.switches), cells = {}, lit = 0;
    var wrong = this.net.check(this.switches, gates);
    if (wrong) throw new Error('frame ' + n + ': ' + wrong);
    for (var g = 0; g < gates.length; g++) { cells[SHEET + '!' + a1(this.laid.cells[g][0], this.laid.cells[g][1], false, false)] = gates[g]; lit += gates[g]; }
    this.lit = lit;
    this.game.cells(cells);
    return { cells: cells };
  };
  // The switches written and the gates lit at the replay's end, the rows a person wrote into the levels, and the levels
  // whose last test passed: the case's naughtEdits, naughtLit, naughtWritten and naughtPassed.
  NaughtHand.prototype.counts = function () {
    var passed = 0;
    for (var r = 11; r <= 19; r++) if (this.game.labOf('B' + r) === 1) passed++;
    return { edits: this.edits, lit: this.lit, written: this.written, passed: passed };
  };
  NaughtHand.Net = Net;
  NaughtHand.Laid = Laid;
  NaughtHand.Dice = Dice;
  NaughtHand.rectangles = rectangles;
  NaughtHand.a1 = a1;
  NaughtHand.letters = letters;
  NaughtHand.withBlock = withBlock;
  NaughtHand.floorsSource = floorsSource;
  NaughtHand.blockOf = blockOf;
  NaughtHand.stimulus = stimulus;
  NaughtHand.SHEET = SHEET;
  NaughtHand.kind = kind;
  NaughtHand.gateText = gateText;
  NaughtHand.inputsOf = inputsOf;
  NaughtHand.BENCH = BENCH;
  NaughtHand.FLOORS = FLOORS;
  NaughtHand.RUN = RUN;
  hands.naught = NaughtHand;
})(window.AlonzoHands = window.AlonzoHands || {});

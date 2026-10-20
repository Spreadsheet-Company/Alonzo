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
// answers each frame of the replay with every gate's value after the frame's switches.
(function (hands) {
  'use strict';
  var BLOCK_BEGIN = '; ---- the bench, written by cargo run --release --example naught: edit the generator, never these lines ----';
  var BLOCK_END = '; ---- the bench\'s end ----';
  var SHEET = 'Bench', WIDTH = '3', RUN = 4, SHUFFLE_SEED = 20261020;
  var BENCH = [16, 8], FLOORS = [4096, 64];
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
  function Net() { this.switches = []; this.buses = []; this.gates = []; this.home = []; this.circuits = []; }
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
  // The bench: an adder of `adder` bits from A1 and a multiplier of `multiplier` bits from I1, either left out at 0.
  Net.bench = function (adder, multiplier) {
    var net = new Net();
    if (adder > 0) net.adder(adder, 1);
    if (multiplier > 0) net.multiplier(multiplier, 9);
    return net;
  };
  Net.prototype.adder = function (n, c0) {
    var a = [], b = [], i;
    for (i = 0; i < n; i++) a.push(this.switch_([i + 2, c0], [false, false]));
    for (i = 0; i < n; i++) b.push(this.switch_([i + 2, c0 + 1], [false, false]));
    var carry = this.switch_([1, c0 + 5], [false, false]), c = carry, sum = [];
    for (i = 0; i < n; i++) {
      var r = i + 2;
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
    var r0 = 3, cpp = m0 + 1, w = n + 1;
    var cx = cpp + w, cg = cpp + 2 * w, cp = cpp + 3 * w, cc = cpp + 4 * w, cs = cpp + 5 * w;
    var a = [], b = [], i, j;
    for (j = 0; j < n; j++) a.push(this.switch_([1, cpp + j], [true, false]));
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
    for (i = 0; i < list.length; i++) lines.push('(column "' + SHEET + '" "' + letters(list[i]) + '" ' + WIDTH + ' shown none)');
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

  // The floors' source (decision 6): the source with its block's lines replaced and the manifest's (settle K) line taken
  // out, since a cartridge that settles numbers the Clock by acts and the floors' switches read it as the frame; null
  // where it holds no block.
  function floorsSource(source, lines) {
    var built = withBlock(source, lines);
    if (built === null) return null;
    var eol = built.indexOf('\r\n') >= 0 ? '\r\n' : '\n', all = built.split(eol);
    for (var i = 0; i < all.length; i++) if (/^\s*\(settle /.test(all[i])) { all.splice(i, 1); break; }
    return all.join(eol);
  }
  // The block's lines as a source holds them, between its two lines; null where it holds none.
  function blockOf(source) {
    var lines = source.split('\n').map(function (l) { return l.replace(/\r$/, ''); });
    var begin = lines.indexOf(BLOCK_BEGIN), end = lines.indexOf(BLOCK_END);
    return end > begin && begin >= 0 ? lines.slice(begin + 1, end) : null;
  }

  // A replay of the committed bench (ENGINE.16): the Bench's switches as the replay's rows leave them, each 0 or 1, and
  // each frame answers every gate's value at full rate, the circuits held to integer + and x. Made, it lays the bench
  // and holds its block to the one the page's own block source-naught holds, line for line, so that this writer and
  // the Rust one are held to each other at every push, as the floors hold them at the floors' size.
  function NaughtHand() {
    var el = typeof document !== 'undefined' ? document.getElementById('source-naught') : null;
    if (!el) throw new Error('the page holds no source-naught block, whose bench the hand lays');
    this.net = Net.bench(BENCH[0], BENCH[1]);
    this.laid = new Laid(this.net, 'fill', 'values', 'now');
    var held = blockOf(el.textContent), mine = this.laid.block();
    if (!held) throw new Error('the source-naught block holds no bench between its two lines');
    for (var i = 0; i < Math.max(held.length, mine.length); i++) {
      if (held[i] !== mine[i]) throw new Error('the bench the source-naught block holds is not the one the hand lays, at the block\'s line ' + (i + 1) + ': ' + JSON.stringify(held[i] === undefined ? 'no line' : held[i]) + ' against ' + JSON.stringify(mine[i] === undefined ? 'no line' : mine[i]));
    }
    this.switches = new Uint8Array(this.net.switches.length);
    this.at = {};
    for (var k = 0; k < this.net.switches.length; k++) this.at[a1(this.net.switches[k][0], this.net.switches[k][1], false, false)] = k;
    this.edits = 0; this.lit = 0;
  }
  NaughtHand.prototype.frame = function (n, rows) {
    for (var r = 0; r < rows.length; r++) {
      var row = rows[r];
      if (!Array.isArray(row) || !row[0] || row[0].sym !== 'cell' || row[1] !== SHEET || typeof row[2] !== 'string') continue;
      var k = this.at[row[2]], v = row[3] && row[3].num !== undefined ? row[3].num : null;
      if (k === undefined) throw new Error(row[2] + ' is no switch of the bench');
      if (v !== 0 && v !== 1) throw new Error('the switch ' + row[2] + ' is written ' + JSON.stringify(row[3]) + ', where the hand holds 0 or 1');
      this.switches[k] = v;
      this.edits++;
    }
    var gates = this.net.evaluate(this.switches), cells = {}, lit = 0;
    var wrong = this.net.check(this.switches, gates);
    if (wrong) throw new Error('frame ' + n + ': ' + wrong);
    for (var g = 0; g < gates.length; g++) { cells[SHEET + '!' + a1(this.laid.cells[g][0], this.laid.cells[g][1], false, false)] = gates[g]; lit += gates[g]; }
    this.lit = lit;
    return { cells: cells };
  };
  // The switches written and the gates lit at the replay's end: the case's naughtEdits and naughtLit.
  NaughtHand.prototype.counts = function () { return { edits: this.edits, lit: this.lit }; };
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
  NaughtHand.BENCH = BENCH;
  NaughtHand.FLOORS = FLOORS;
  NaughtHand.RUN = RUN;
  hands.naught = NaughtHand;
})(window.AlonzoHands = window.AlonzoHands || {});

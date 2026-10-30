// SPDX-License-Identifier: 0BSD
// SPDX-FileCopyrightText: 2026 Spreadsheet Company
//
// cartridges/seiyaku/seiyaku.hand.js - Seiyaku by hand (CART.14, decision 14), the page's own, a third beside the
// engine's module and the Rust one, engine/src/seiyaku.rs, whose transforms and board it mirrors line for line. A
// hand (ENGINE.16): the builder writes this file into the page as the block hand-seiyaku, a script the page runs
// where it stands, and it registers one constructor under its cartridge's name in window.AlonzoHands. The loop
// oracle's replay case answers it each frame of Seiyaku's committed replay and holds the frame to what it answers,
// the Board's 81 variables, each a code or its marks' text. The book is the page's own text of the source, the
// block source-seiyaku, read between the two lines the book's writer keeps (engine/examples/seiyaku.rs).
(function (hands) {
  'use strict';
  var P = 67108859, PER_GRADE = 32, FS = String.fromCharCode(0x2007);
  var BOOK_BEGIN = '; ---- the book, written by cargo run --release --example seiyaku: edit the generator, never these lines ----';
  var BOOK_END = '; ---- the book\'s end ----';

  // The book's puzzles, as the source's block holds them: a puzzle a line, 81 values, 0 an empty variable.
  function readBook(text) {
    var lines = String(text).split('\n'), inside = false, book = [];
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].replace(/\r$/, '');
      if (line === BOOK_BEGIN) { inside = true; continue; }
      if (line === BOOK_END) break;
      var m = inside ? /^\s*"([.1-9]{81})"/.exec(line) : null;
      if (!m) continue;
      var p = [];
      for (var k = 0; k < 81; k++) p.push(m[1].charAt(k) === '.' ? 0 : +m[1].charAt(k));
      book.push(p);
    }
    return book;
  }

  // The Deal sheet's hash of a row: Life's soup hash over the seed, the instance and the row, two linear forms modulo
  // the prime multiplied; every product under 2^53, which a double holds exactly.
  function hash(seed, instance, row) {
    var a = (seed * 1103515 + instance * 7919 + row * 1597334 + 3440100) % P;
    var b = (seed * 2012345 + instance * 104729 + row * 1209487 + 3213021) % P;
    return (a * b) % P;
  }
  // An instance dealt: its puzzle the one its grade's block of the book the hash names, and each permutation the
  // ranks of keys, a key the hash times 64 and its row, so that no two are equal.
  function deal(seed, instance, grade) {
    function key(row) { return hash(seed, instance, row) * 64 + row; }
    function rank(row, first, last) { var n = 1, k = key(row); for (var j = first; j <= last; j++) if (key(j) < k) n++; return n; }
    var sigma = [], tau = [], pi = [0];
    for (var r = 1; r <= 9; r++) {
      var band = Math.floor((r - 1) / 3), rows = 23 + 3 * band, cols = 35 + 3 * band;
      sigma.push(3 * (rank(20 + band, 20, 22) - 1) + rank(22 + r, rows, rows + 2));
      tau.push(3 * (rank(32 + band, 32, 34) - 1) + rank(34 + r, cols, cols + 2));
    }
    for (var v = 1; v <= 9; v++) pi.push(rank(10 + v, 11, 19));
    return { puzzle: PER_GRADE * (grade - 1) + 1 + hash(seed, instance, 10) % PER_GRADE, transposed: hash(seed, instance, 44) % 2 === 1,
             sigma: sigma, tau: tau, pi: pi };
  }
  // The instance's givens: each variable's source in the puzzle, its row's and its column's, swapped when
  // transposed, and its value relabeled.
  function givensOf(d, book) {
    var p = book[d.puzzle - 1], g = [];
    for (var r = 0; r < 9; r++) for (var c = 0; c < 9; c++) {
      var k = d.transposed ? (d.sigma[c] - 1) * 9 + d.tau[r] : (d.sigma[r] - 1) * 9 + d.tau[c], v = p[k - 1];
      g.push(v === 0 ? 0 : d.pi[v]);
    }
    return g;
  }
  function unitsOf(k) { var r = Math.floor(k / 9), c = k % 9; return [r, c, Math.floor(r / 3) * 3 + Math.floor(c / 3)]; }
  function zeros(n) { var a = []; for (var i = 0; i < n; i++) a.push(0); return a; }
  function counts() { var u = []; for (var i = 0; i < 9; i++) u.push(zeros(10)); return u; }
  function valueOf(command, prefix) { var m = new RegExp('^' + prefix + '([1-9])$').exec(command || ''); return m ? +m[1] : 0; }

  // The board by hand: a frame takes the Input rows as the engine's frame sees them, the act's at its frame and the
  // released ones at a settle step, and computes, in the cartridge's order, the Lab's counts, the instance dealt and
  // its givens, the assignments, the counts of each unit, the violations and the candidates, then the marks.
  function Board(book, seed) {
    this.book = book; this.seed = seed; this.clock = 0; this.acts = 0; this.instances = 0; this.restarts = 0;
    this.nextGrade = 0; this.grade = 0; this.satisfied = false; this.satisfiedActs = 0;
    this.givens = zeros(81); this.entries = zeros(81); this.marks = zeros(81); this.grid = zeros(81); this.violated = zeros(81);
  }
  Board.prototype.frame = function (i, beginsAct) {
    if (beginsAct) this.clock++;
    var first = this.clock === 1, cmd = i.command || '', k;
    var act = !!(i.left || i.right || i.middle || cmd !== '');
    var instances = this.instances + (cmd === 'instance' ? 1 : 0), restarts = this.restarts + (cmd === 'retract-all' ? 1 : 0);
    var dealt = instances !== this.instances, reset = dealt || restarts !== this.restarts;
    var nextGrade = first ? 2 : (cmd === 'grade' ? this.nextGrade % 4 + 1 : this.nextGrade);
    var grade = first || dealt ? nextGrade : this.grade;
    var acts = reset ? 0 : this.acts + (act ? 1 : 0);
    var assigned = valueOf(cmd, 'assign-'), marked = valueOf(cmd, 'domain-'), retract = cmd === 'retract', domains = cmd === 'domains';
    // the Board stands from B2, a margin row and column before it: a place is a variable on B2:J10
    var place = i.sheet === 'Board' && i.column >= 2 && i.column <= 10 && i.row >= 2 && i.row <= 10 ? (i.row - 2) * 9 + (i.column - 1) : 0;
    var givens = givensOf(deal(this.seed, instances, grade), this.book), entries = [], grid = [];
    for (k = 0; k < 81; k++) {
      var last = this.entries[k];
      entries.push(reset || givens[k] > 0 ? 0 : (place === k + 1 ? (assigned > 0 ? assigned : (retract ? 0 : last)) : last));
      grid.push(givens[k] + entries[k]);
    }
    var rows = counts(), cols = counts(), boxes = counts(), u;
    for (k = 0; k < 81; k++) if (grid[k] > 0) { u = unitsOf(k); rows[u[0]][grid[k]]++; cols[u[1]][grid[k]]++; boxes[u[2]][grid[k]]++; }
    var violated = [], candidates = [];
    for (k = 0; k < 81; k++) {
      u = unitsOf(k);
      var v = grid[k], cand = 0;
      violated.push(v > 0 && (rows[u[0]][v] > 1 || cols[u[1]][v] > 1 || boxes[u[2]][v] > 1));
      if (v === 0) for (var w = 1; w <= 9; w++) if (rows[u[0]][w] === 0 && cols[u[1]][w] === 0 && boxes[u[2]][w] === 0) cand += 1 << (w - 1);
      candidates.push(cand);
    }
    var marks = [];
    for (k = 0; k < 81; k++) {
      var m = this.marks[k];
      if (reset || givens[k] > 0) marks.push(0);
      else if (domains) marks.push(entries[k] > 0 ? m : candidates[k]);
      else if (place === k + 1) marks.push(marked > 0 && entries[k] === 0 ? m ^ (1 << (marked - 1)) : (retract && this.entries[k] === 0 ? 0 : m));
      else marks.push(m);
    }
    var filled = 0, any = false;
    for (k = 0; k < 81; k++) { if (grid[k] > 0) filled++; if (violated[k]) any = true; }
    var satisfied = filled === 81 && !any;
    this.satisfiedActs = satisfied ? (this.satisfied ? this.satisfiedActs : acts) : 0;
    this.acts = acts; this.instances = instances; this.restarts = restarts; this.nextGrade = nextGrade; this.grade = grade;
    this.satisfied = satisfied; this.givens = givens; this.entries = entries; this.marks = marks; this.grid = grid; this.violated = violated;
  };
  // What the Board shows at row and column from 1: a value's code, 100 times its kind, 10 times its box's parity and
  // the value; else the marks kept, a digit or a figure space in each of nine places, a line of three with three
  // figure spaces between them, and a line of four figure spaces between two lines, too wide to share a line with
  // marks, each line a word the viewport's wrap breaks after and centers, so that each mark stands in its third of the
  // cell (the owner's hand tests, 2026-10-19 and ENGINE.28's of 2026-10-29); or nothing.
  Board.prototype.shown = function (row, column) {
    var k = (row - 1) * 9 + (column - 1), v = this.grid[k];
    if (v > 0) {
      var given = this.givens[k] > 0, kind = this.satisfied ? (given ? 5 : 6) : (given ? (this.violated[k] ? 3 : 1) : (this.violated[k] ? 4 : 2));
      return 100 * kind + 10 * ((Math.floor((row - 1) / 3) + Math.floor((column - 1) / 3)) % 2) + v;
    }
    var m = this.marks[k];
    if (m === 0) return '';
    var lines = [], within = FS + FS + FS, between = within + FS;
    function place(d) { return m & (1 << (d - 1)) ? String(d) : FS; }
    for (var d = 1; d <= 7; d += 3) lines.push(place(d) + within + place(d + 1) + within + place(d + 2));
    return lines.join(' ' + between + ' ');
  };

  // A replay of Seiyaku: the Input sheet's cells as the replay's rows leave them, a frame with rows an act's and a
  // frame with none a settle step, before which the engine has released the press and the command; an edit of the
  // seed read as the board reads it. Each frame answers the Board's 81 variables.
  function num(v) { return v && v.num !== undefined ? +v.num : (typeof v === 'number' ? v : 0); }
  function SeiyakuHand(seed) {
    var el = document.getElementById('source-seiyaku');
    if (!el) throw new Error('the page holds no source-seiyaku block, whose book the hand reads');
    var book = readBook(el.textContent);
    if (book.length !== 4 * PER_GRADE) throw new Error('the source-seiyaku block holds ' + book.length + ' puzzles, and the book is ' + 4 * PER_GRADE);
    this.board = new Board(book, seed); this.input = {}; this.settles = 0; this.satisfiedOnce = false;
  }
  SeiyakuHand.prototype.frame = function (n, rows) {
    var b = this.board, input = this.input;
    for (var k = 0; k < rows.length; k++) {
      var row = rows[k];
      if (!Array.isArray(row) || !row[0] || row[0].sym !== 'cell' || typeof row[2] !== 'string') continue;
      if (row[1] === 'Input') input[row[2]] = row[3];
      else if (row[1] === 'Clock' && row[2] === 'B3') b.seed = num(row[3]);
    }
    if (!rows.length) { input.B13 = { num: 0 }; input.B14 = { num: 0 }; input.B15 = { num: 0 }; input.B20 = ''; this.settles++; }
    b.frame({ column: num(input.B11), row: num(input.B12), left: num(input.B13) === 1, right: num(input.B14) === 1, middle: num(input.B15) === 1,
              sheet: typeof input.B19 === 'string' ? input.B19 : '', command: typeof input.B20 === 'string' ? input.B20 : '' }, rows.length > 0);
    if (b.satisfied) this.satisfiedOnce = true;
    var cells = {};
    for (var r = 1; r <= 9; r++) for (var c = 1; c <= 9; c++) cells['Board!' + String.fromCharCode(65 + c) + (r + 1)] = b.shown(r, c);   // from B2
    return { cells: cells };
  };
  // The acts begun, the load's among them, the instances, the settle steps, and whether an instance was satisfied:
  // the case's seiyakuActs and the rest.
  SeiyakuHand.prototype.counts = function () {
    return { acts: this.board.clock, instances: this.board.instances + 1, settles: this.settles, satisfied: this.satisfiedOnce ? 1 : 0 };
  };
  SeiyakuHand.Board = Board;
  SeiyakuHand.deal = deal;
  hands.seiyaku = SeiyakuHand;
})(window.AlonzoHands = window.AlonzoHands || {});

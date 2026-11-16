// SPDX-License-Identifier: 0BSD
// SPDX-FileCopyrightText: 2026 Spreadsheet Company
//
// cartridges/seiyaku/seiyaku.hand.js - Seiyaku by hand (CART.14, decision 14), the page's own, a third beside the
// engine's module and the Rust one, engine/src/seiyaku.rs, whose transforms and board it mirrors line for line. A
// hand (ENGINE.16): the builder writes this file into the page as the block hand-seiyaku, a script the page runs
// where it stands, and it registers one constructor under its cartridge's name in window.AlonzoHands. The loop
// oracle's replay case answers it each frame of Seiyaku's committed replay and holds the frame to what it answers,
// the Board's 81 variables, each a value or its marks' text. The book is the page's own text of the source, the
// block source-seiyaku, read between the two lines the book's writer keeps (engine/examples/seiyaku.rs). Since CART.14.1's
// second slice it keeps the ladder too, the Rust hand's Seiyaku::infer line for line: its strikes, the variables inference
// assigned, the words lit, a propagation running and the marks filtered, and it answers the words under the Board; and
// since its third the light, the Rust hand's Seiyaku::light and lit_rules, answering the rules each variable is lit by.
(function (hands) {
  'use strict';
  var P = 67108859, PER_GRADE = 32, FS = String.fromCharCode(0x2007), EMPTY_DOMAIN = String.fromCharCode(0x2205);
  // The rules over the Board, by priority (CART.14.1's third slice): the satisfied board's two, by box, each stopping the
  // rest; the inference's place; a violation or an emptied domain; a reason; an assignment.
  var RULE_SATISFIED_ODD = 1, RULE_SATISFIED_EVEN = 2, RULE_PLACE = 3, RULE_RED = 4, RULE_REASON = 5, RULE_ASSIGNED = 6;
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

  // The ladder (CART.14.1's second slice): a variable's address as the Board's headers show it, from B2; n and its
  // words; and the 27 units, rows, columns and boxes, each its nine variables, in the grader's order.
  function addressOf(place) { var r = Math.floor((place - 1) / 9), c = (place - 1) % 9; return String.fromCharCode(66 + c) + (r + 2); }
  function counted(n, one, many) { return n + ' ' + (n === 1 ? one : many); }
  function ones(m) { var n = 0; while (m) { n += m & 1; m >>>= 1; } return n; }
  var UNITS = (function () {
    var u = [], r, c, x, k, line;
    for (r = 0; r < 9; r++) { line = []; for (c = 0; c < 9; c++) line.push(9 * r + c); u.push(line); }
    for (c = 0; c < 9; c++) { line = []; for (r = 0; r < 9; r++) line.push(9 * r + c); u.push(line); }
    for (x = 0; x < 9; x++) { line = []; for (k = 0; k < 9; k++) line.push(9 * (3 * Math.floor(x / 3) + Math.floor(k / 3)) + 3 * (x % 3) + k % 3); u.push(line); }
    return u;
  })();
  // Each unit's places left for each value, and a line's inside a box: a row's in each stack, a column's in each band.
  function openOf(grid, candidates) {
    var o = { rows: counts(), cols: counts(), boxes: counts(), across: [], down: [] }, v, j;
    for (v = 0; v <= 9; v++) { o.across.push([]); o.down.push([]); for (j = 0; j < 9; j++) { o.across[v].push([0, 0, 0]); o.down[v].push([0, 0, 0]); } }
    for (var k = 0; k < 81; k++) {
      if (grid[k] > 0) continue;
      var u = unitsOf(k), r = u[0], c = u[1];
      for (v = 1; v <= 9; v++) if (candidates[k] & (1 << (v - 1))) {
        o.rows[r][v]++; o.cols[c][v]++; o.boxes[u[2]][v]++; o.across[v][r][Math.floor(c / 3)]++; o.down[v][c][Math.floor(r / 3)]++;
      }
    }
    return o;
  }
  // The next inference in the grader's order: a contradiction or the board satisfied first, which stops the ladder; then
  // the first naked single by variable, the first hidden single by unit and value, and the first pointing by box and
  // value, a row before a column; or none. Its kind 0 to 3, value, place, a pointing's box, line and whether a column, why
  // there is none, its words, and a hidden single's constraint, which the light reads.
  function infer(grid, candidates, tables, violated, satisfied) {
    var open = openOf(grid, candidates), k, v, u, j, naked = -1, hidden = null, pointing = null;
    for (k = 0; k < 81 && naked < 0; k++) if (ones(candidates[k]) === 1) naked = k;
    for (u = 0; u < 27 && !hidden; u++) {
      var places = u < 9 ? open.rows[u] : (u < 18 ? open.cols[u - 9] : open.boxes[u - 18]);
      for (v = 1; v <= 9 && !hidden; v++) if (places[v] === 1) {
        for (j = 0; j < 9 && !hidden; j++) if (candidates[UNITS[u][j]] & (1 << (v - 1))) hidden = { unit: u + 1, value: v, k: UNITS[u][j] };
      }
    }
    for (var b = 0; b < 9 && !pointing; b++) {
      var band = Math.floor(b / 3), stack = b % 3;
      for (v = 1; v <= 9 && !pointing; v++) {
        var n = open.boxes[b][v];
        if (n < 2) continue;
        for (var r = 3 * band; r < 3 * band + 3 && !pointing; r++) if (open.across[v][r][stack] === n && open.rows[r][v] > n) pointing = { box: b + 1, value: v, down: false, line: r + 1 };
        for (var c = 3 * stack; c < 3 * stack + 3 && !pointing; c++) if (open.down[v][c][band] === n && open.cols[c][v] > n) pointing = { box: b + 1, value: v, down: true, line: c + 1 };
      }
    }
    var violations = 0, emptied = 0, noPlace = 0, left = 0, mine = [open.rows, open.cols, open.boxes];
    for (k = 0; k < 81; k++) { if (violated[k]) violations++; if (grid[k] === 0) { left++; if (candidates[k] === 0) emptied++; } }
    for (var t = 0; t < 3; t++) for (j = 0; j < 9; j++) for (v = 1; v <= 9; v++) if (mine[t][j][v] === 0 && tables[t][j][v] === 0) noPlace++;
    var any = naked >= 0 || !!hidden || !!pointing;
    var stop = satisfied ? 1 : violations > 0 ? 2 : emptied > 0 ? 3 : noPlace > 0 ? 4 : any ? 0 : 5;
    var i = { kind: 0, value: 0, place: 0, box: 0, down: false, line: 0, unit: 0, stop: stop, words: '' };
    if (stop === 1) i.words = 'Satisfied: nothing is left to infer.';
    else if (stop === 2) i.words = 'Nothing to infer: ' + counted(violations, 'variable violates', 'variables violate') + ' a constraint.';
    else if (stop === 3) i.words = 'Nothing to infer: ' + counted(emptied, 'variable has no value left in its domain.', 'variables have no value left in their domains.');
    else if (stop === 4) i.words = 'Nothing to infer: ' + counted(noPlace, 'value has', 'values have') + ' no place left in a constraint.';
    else if (stop === 5) i.words = 'Nothing the three techniques can infer: ' + left + ' variables left.';
    else if (naked >= 0) {
      for (v = 1; v <= 9; v++) if (candidates[naked] & (1 << (v - 1))) i.value = v;
      i.kind = 1; i.place = naked + 1;
      i.words = addressOf(i.place) + ' is ' + i.value + ': the only value left in its domain.';
    } else if (hidden) {
      i.kind = 2; i.value = hidden.value; i.place = hidden.k + 1; i.unit = hidden.unit;
      i.words = addressOf(i.place) + ' is ' + i.value + ': the only place left for it in its ' + (hidden.unit <= 9 ? 'row' : hidden.unit <= 18 ? 'column' : 'box') + '.';
    } else {
      i.kind = 3; i.value = pointing.value; i.box = pointing.box; i.down = pointing.down; i.line = pointing.line;
      var first = 27 * Math.floor((i.box - 1) / 3) + 3 * ((i.box - 1) % 3) + 1;
      i.words = i.value + ' is struck from the rest of ' + (i.down ? 'column ' + String.fromCharCode(65 + i.line) : 'row ' + (i.line + 1)) +
        ': in the box from ' + addressOf(first) + ', every place left for it is on that line.';
    }
    return i;
  }

  // The board by hand: a frame takes the Input rows as the engine's frame sees them, the act's at its frame and the
  // released ones at a settle step, and computes, in the cartridge's order, the Lab's counts, the instance dealt and
  // its givens, the assignments, the counts of each unit, the violations and the candidates, then the marks.
  function Board(book, seed) {
    this.book = book; this.seed = seed; this.clock = 0; this.acts = 0; this.instances = 0; this.restarts = 0;
    this.nextGrade = 0; this.grade = 0; this.satisfied = false; this.satisfiedActs = 0;
    this.givens = zeros(81); this.entries = zeros(81); this.marks = zeros(81); this.grid = zeros(81); this.violated = zeros(81);
    this.candidates = zeros(81); this.struck = zeros(81); this.inferred = zeros(81); this.lit = false; this.propagating = false; this.filtered = false;
    this.ladder = { kind: 0, value: 0, place: 0, box: 0, down: false, line: 0, unit: 0, stop: 0, words: '' };
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
    // the ladder's switches, the Lab's B13 to B18: the words lit by infer or propagate and put out by any other command;
    // a propagation running while the last frame named an inference; that inference applied, an assignment or a strike
    var L = this.ladder, lit = cmd === 'infer' || cmd === 'propagate' ? true : (cmd !== '' ? false : this.lit), named = L.kind > 0;
    var propagating = cmd === 'propagate' || (this.propagating && named), applied = named && (propagating || (cmd === 'infer' && this.lit));
    var assigns = applied && L.kind < 3, strikes = applied && L.kind === 3, filtered = first ? false : (cmd === 'filter' ? !this.filtered : this.filtered);
    var marked = valueOf(cmd, 'domain-'), retract = cmd === 'retract', domains = cmd === 'domains', undo = cmd === 'retract-inferred';
    // the Board stands from B2, a margin row and column before it: a place is a variable on B2:J10; an inference that
    // assigns takes the place of the person's value and place
    var assigned = assigns ? L.value : valueOf(cmd, 'assign-');
    var place = assigns ? L.place : (i.sheet === 'Board' && i.column >= 2 && i.column <= 10 && i.row >= 2 && i.row <= 10 ? (i.row - 2) * 9 + (i.column - 1) : 0);
    var givens = givensOf(deal(this.seed, instances, grade), this.book), entries = [], grid = [], inferred = [];
    for (k = 0; k < 81; k++) {
      var last = this.entries[k];
      entries.push(reset || givens[k] > 0 || (undo && this.inferred[k]) ? 0 : (place === k + 1 ? (assigned > 0 ? assigned : (retract ? 0 : last)) : last));
      grid.push(givens[k] + entries[k]);
      inferred.push(reset || entries[k] === 0 ? false : (assigns && place === k + 1 ? true : (entries[k] !== last ? false : this.inferred[k])));
    }
    var rows = counts(), cols = counts(), boxes = counts(), u;
    for (k = 0; k < 81; k++) if (grid[k] > 0) { u = unitsOf(k); rows[u[0]][grid[k]]++; cols[u[1]][grid[k]]++; boxes[u[2]][grid[k]]++; }
    // the strikes: cleared by a restart, a new instance, or any variable assigned at the last frame holding another value or
    // none; else a pointing applied strikes its value from every unassigned variable on its line outside its box
    var cleared = reset, struck = [];
    for (k = 0; k < 81 && !cleared; k++) if (this.entries[k] > 0 && entries[k] !== this.entries[k]) cleared = true;
    for (k = 0; k < 81; k++) {
      u = unitsOf(k);
      var onLine = L.down ? u[1] + 1 === L.line : u[0] + 1 === L.line;
      struck.push(cleared ? 0 : (strikes && grid[k] === 0 && onLine && u[2] + 1 !== L.box ? this.struck[k] | (1 << (L.value - 1)) : this.struck[k]));
    }
    var violated = [], candidates = [];
    for (k = 0; k < 81; k++) {
      u = unitsOf(k);
      var v = grid[k], cand = 0;
      violated.push(v > 0 && (rows[u[0]][v] > 1 || cols[u[1]][v] > 1 || boxes[u[2]][v] > 1));
      if (v === 0) for (var w = 1; w <= 9; w++) if (rows[u[0]][w] === 0 && cols[u[1]][w] === 0 && boxes[u[2]][w] === 0) cand += 1 << (w - 1);
      candidates.push(cand & ~struck[k]);
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
    this.candidates = candidates; this.struck = struck; this.inferred = inferred; this.lit = lit; this.propagating = propagating; this.filtered = filtered;
    this.ladder = infer(grid, candidates, [rows, cols, boxes], violated, satisfied);
  };
  // A variable's light, the Light sheet's (CART.14.1's third slice, decisions 10 and 11): 0 none; 1 a reason, a variable
  // the inference is read by; 2 the inference's place, the variable a single assigns or a place a pointing strikes its
  // value from; 3 an emptied domain. A naked single is read by its assigned neighbors, a hidden single by its constraint
  // whole and every variable holding its value, a pointing by its box whole and every variable holding its value; all of
  // it only while the ladder is asked.
  Board.prototype.light = function (k) {
    if (!this.lit) return 0;
    if (this.grid[k] === 0 && this.candidates[k] === 0) return 3;
    var L = this.ladder, u = unitsOf(k), place = false, reason = false, holding = this.grid[k] > 0 && this.grid[k] === L.value;
    if (L.kind === 1 || L.kind === 2) place = k + 1 === L.place;
    else if (L.kind === 3) place = this.grid[k] === 0 && (L.down ? u[1] + 1 === L.line : u[0] + 1 === L.line) && u[2] + 1 !== L.box && (this.candidates[k] & (1 << (L.value - 1))) !== 0;
    if (place) return 2;
    if (L.kind === 1) { var p = unitsOf(L.place - 1); reason = this.grid[k] > 0 && (u[0] === p[0] || u[1] === p[1] || u[2] === p[2]); }
    else if (L.kind === 2) reason = (L.unit <= 9 ? u[0] + 1 === L.unit : (L.unit <= 18 ? u[1] + 10 === L.unit : u[2] + 19 === L.unit)) || holding;
    else if (L.kind === 3) reason = u[2] + 1 === L.box || holding;
    return reason ? 1 : 0;
  };
  // The rules a variable at row and column from 1 is lit by, in priority order up to the first that stops, as the
  // record's lit row names them: the satisfied board's, by box, alone; else the inference's place, a violation or an
  // emptied domain, a reason and an assignment, each where it holds.
  Board.prototype.litRules = function (row, column) {
    var k = (row - 1) * 9 + (column - 1);
    if (this.satisfied) return [(Math.floor((row - 1) / 3) + Math.floor((column - 1) / 3)) % 2 === 0 ? RULE_SATISFIED_ODD : RULE_SATISFIED_EVEN];
    var light = this.light(k), lit = [];
    if (light === 2) lit.push(RULE_PLACE);
    if (this.violated[k] || light === 3) lit.push(RULE_RED);
    if (light === 1) lit.push(RULE_REASON);
    if (this.grid[k] > 0 && this.givens[k] === 0) lit.push(RULE_ASSIGNED);
    return lit;
  };
  // What the Board shows at row and column from 1: a variable's value, and since CART.14.1's third slice, while the light
  // names it, a single's value at the variable it assigns before it is applied and an emptied domain's empty set; else the
  // marks kept, a digit or a figure space in each of nine places, a line of three with three figure spaces between them,
  // and two line feeds between two lines, so that each mark stands in its third of the cell (the owner's hand tests,
  // 2026-10-19 and ENGINE.28's of 2026-10-29; the line feeds since CART.14.1's second slice, by ENGINE.36); the marks
  // drawn, all or, filtered, those still candidates; or nothing. A code stood for a value until the third slice.
  Board.prototype.shown = function (row, column) {
    var k = (row - 1) * 9 + (column - 1), v = this.grid[k];
    if (v > 0) return v;
    var light = this.light(k);
    if (light === 2 && this.ladder.kind < 3) return this.ladder.value;
    if (light === 3) return EMPTY_DOMAIN;
    var m = this.filtered ? this.marks[k] & this.candidates[k] : this.marks[k];
    if (m === 0) return '';
    var lines = [], within = FS + FS + FS;
    function place(d) { return m & (1 << (d - 1)) ? String(d) : FS; }
    for (var d = 1; d <= 7; d += 3) lines.push(place(d) + within + place(d + 1) + within + place(d + 2));
    return lines.join('\n\n');
  };
  // The words under the Board, B11: the ladder's while lit.
  Board.prototype.words = function () { return this.lit ? this.ladder.words : ''; };

  // A replay of Seiyaku: the Input sheet's cells as the replay's rows leave them, a frame with rows an act's and a
  // frame with none a settle step, before which the engine has released the press and the command; an edit of the
  // seed read as the board reads it. Each frame answers the Board's 81 variables, the words under them, and the rules
  // each variable is lit by.
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
    var cells = {}, lit = {};
    for (var r = 1; r <= 9; r++) for (var c = 1; c <= 9; c++) {
      var at = 'Board!' + String.fromCharCode(65 + c) + (r + 1);   // from B2
      cells[at] = b.shown(r, c);
      lit[at] = b.litRules(r, c);
    }
    cells['Board!B11'] = b.words();
    return { cells: cells, lit: lit };
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

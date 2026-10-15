// SPDX-License-Identifier: 0BSD
// SPDX-FileCopyrightText: 2026 Spreadsheet Company
//
// cartridges/kairos/kairos.hand.js - Kairos by hand (CART.4's second slice), the page's own, a third beside
// the engine's module and the Rust one, engine/src/kairos.rs. A hand (ENGINE.16): the builder writes this
// file into the page as the block hand-kairos, a script the page runs where it stands, and it registers one
// constructor under its cartridge's name in window.AlonzoHands. The loop oracle's replay case answers it each
// frame of Kairos's committed replay and holds the frame to what it answers: the board, the plane, byte for
// byte, and the Tally's cells, each to the Tally's record at that frame.
(function (hands) {
  'use strict';
  // The stacking game as a person writes it, a row a bitmask of its seven columns, a stop a bitwise AND with
  // the row beneath, and the game a switch on its phase, the cartridge's codes: 1 sliding, 2 stopped, 3 the
  // minor prize offered, 4 over; a game's end 1 fell, 2 the minor prize taken, 3 the major. The Levels
  // sheet's own values, each window its period. The board lies on its side as the plane reads the Screen's
  // A1:O7, the cabinet's column a row and its level a column, with the checker.
  var KAIROS = {
    levels: 15, columns: 7, minor: 11, major: 15, beat: 20, hold: 90,
    period: [10, 10, 9, 9, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3],
    width: [3, 3, 3, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1],
    window: [10, 10, 9, 9, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3],
    win: ['#...#.###.#...#', '#...#..#..##..#', '#...#..#..##..#', '#.#.#..#..#.#.#', '#.#.#..#..#..##', '##.##..#..#..##', '#...#.###.#...#']
  };
  // The run of columns from to to, both from 1, as a mask; a mask's lights.
  function kairosRun(from, to) { var m = 0; for (var c = Math.max(1, from); c <= Math.min(KAIROS.columns, to); c++) m |= 1 << (c - 1); return m; }
  function kairosLights(m) { var n = 0; for (; m; m &= m - 1) n++; return n; }
  // A replay of Kairos: the Input sheet's cells as the replay's rows leave them, the stop's button held
  // while a, select or the left button is down (the State's B8, their MAX) and the minor prize's while b
  // is, each a press on its rising edge; the Tower the Write sheet's, a stop's lights landing before the
  // next frame and the clear once a result has been held. Each frame's board is held, and since ENGINE.16
  // the Tally beside it, each level's row: the times it was reached, a start or an advance landing on it;
  // the stops on it whose lights stayed, counted when the beat resolves them; and the lights that fell from
  // it, counted at the stop.
  function KairosHand() {
    this.input = {}; this.n = 0; this.phase = 4; this.since = 0; this.level = 1; this.width = 3; this.left = 1; this.direction = 1;
    this.stopped = 0; this.beneath = kairosRun(1, KAIROS.columns); this.end = 0; this.tower = []; this.pending = [];
    this.heldLast = false; this.takeLast = false; this.stops = 0;
    this.reached = []; this.stacked = []; this.fell = [];
    for (var c = 0; c < KAIROS.levels; c++) { this.tower.push(0); this.reached.push(0); this.stacked.push(0); this.fell.push(0); }
  }
  // The row's next place and direction: a column on, turning at an end.
  KairosHand.prototype.onward = function () {
    var right = this.left + this.width - 1;
    var turn = (this.direction === 1 && right >= KAIROS.columns) || (this.direction === -1 && this.left <= 1);
    var d = turn ? -this.direction : this.direction;
    return [this.left + d, d];
  };
  // A level begun, by a start or an advance: the row at its left, sliding right, and the level reached.
  KairosHand.prototype.begin = function () { this.left = 1; this.direction = 1; this.phase = 1; this.reached[this.level - 1]++; };
  KairosHand.prototype.start = function () {
    this.level = 1; this.beneath = kairosRun(1, KAIROS.columns);
    this.width = Math.min(KAIROS.width[0], kairosLights(this.beneath)); this.end = 0; this.begin();
  };
  KairosHand.prototype.over = function (end) { this.end = end; this.phase = 4; };
  KairosHand.prototype.advance = function () {
    this.level++; this.width = Math.min(KAIROS.width[this.level - 1], kairosLights(this.beneath)); this.begin();
  };
  KairosHand.prototype.step = function (held, takeHeld) {
    for (var i = 0; i < this.pending.length; i++) {
      var w = this.pending[i];
      if (w === 'clear') for (var c = 0; c < KAIROS.levels; c++) this.tower[c] = 0;
      else this.tower[w[0] - 1] |= w[1];
    }
    this.pending = [];
    this.n++;
    var press = held && !this.heldLast, take = takeHeld && !this.takeLast, was = this.phase, period = KAIROS.period[this.level - 1];
    this.heldLast = held; this.takeLast = takeHeld;
    if (this.n === 1) this.start();
    else if (was === 1 && press) {
      // stopped where the person saw it, or a column on after the window
      this.stopped = this.since % period < KAIROS.window[this.level - 1] ? this.left : this.onward()[0];
      var stayed = kairosRun(this.stopped, this.stopped + this.width - 1) & this.beneath;
      this.fell[this.level - 1] += this.width - kairosLights(stayed);
      this.beneath = stayed;
      if (stayed) this.pending.push([this.level, stayed]);
      this.phase = 2; this.stops++;
    } else if (was === 1) {
      if ((this.since + 1) % period === 0) { var o = this.onward(); this.left = o[0]; this.direction = o[1]; }
    } else if (was === 2) {
      if (this.since + 1 >= KAIROS.beat) {
        if (this.beneath) this.stacked[this.level - 1]++;
        if (!this.beneath) this.over(1);
        else if (this.level === KAIROS.major) this.over(3);
        else if (this.level === KAIROS.minor) this.phase = 3;
        else this.advance();
      }
    } else if (was === 3) {
      if (take) this.over(2); else if (press) this.advance();
    } else if (press && this.since >= KAIROS.hold) this.start();
    this.since = this.phase !== was ? 0 : this.since + 1;
    if (this.phase === 4 && this.since === KAIROS.hold) this.pending.push('clear');
  };
  // The light at the cabinet's column r and level c, both from 1, before the checker: 0 none, 1 a light
  // that stayed, 2 the row sliding, 3 a light falling (blinking), 6 and 7 the minor and the major prize's
  // level unlit, 5 the minor's while it is offered (blinking).
  KairosHand.prototype.light = function (r, c) {
    var blink = this.since % 8 < 4, bit = 1 << (r - 1), span = 0, look = 0;
    var falling = this.phase === 2 || (this.phase === 4 && this.end === 1 && this.since < KAIROS.hold);
    if (this.phase === 1) { span = kairosRun(this.left, this.left + this.width - 1); look = 2; }
    else if (falling) { span = kairosRun(this.stopped, this.stopped + this.width - 1); look = blink ? 3 : 0; }
    var stayed = this.phase === 2 ? this.beneath : 0;
    if (c === this.level && (stayed & bit)) return 1;
    if (c === this.level && (span & bit)) return look;
    if (this.tower[c - 1] & bit) return 1;
    if (c === KAIROS.minor) return this.phase === 3 && blink ? 5 : 6;
    if (c === KAIROS.major) return 7;
    return 0;
  };
  // The board row by row, WIN by half seconds while the major prize is won, the checker's twin, 8 more, on
  // a light whose row and column sum odd.
  KairosHand.prototype.board = function () {
    var out = new Uint8Array(KAIROS.columns * KAIROS.levels), win = this.phase === 4 && this.end === 3 ? this.since % 30 < 15 : null;
    for (var r = 1; r <= KAIROS.columns; r++) for (var c = 1; c <= KAIROS.levels; c++) {
      var v = win === null ? this.light(r, c) : win && KAIROS.win[r - 1].charAt(c - 1) === '#' ? 4 : 0;
      out[(r - 1) * KAIROS.levels + (c - 1)] = v + ((r + c) % 2 === 1 ? 8 : 0);
    }
    return out;
  };
  // The Tally's cells, a level a row from row 2: reached in B, stacked in C, fallen from in D.
  KairosHand.prototype.tally = function () {
    var out = {};
    for (var lv = 1; lv <= KAIROS.levels; lv++) {
      out['Tally!B' + (lv + 1)] = this.reached[lv - 1];
      out['Tally!C' + (lv + 1)] = this.stacked[lv - 1];
      out['Tally!D' + (lv + 1)] = this.fell[lv - 1];
    }
    return out;
  };
  KairosHand.prototype.frame = function (n, rows) {
    for (var i = 0; i < rows.length; i++) {
      var row = rows[i];
      if (Array.isArray(row) && row[0] && row[0].sym === 'cell' && row[1] === 'Input' && typeof row[2] === 'string') this.input[row[2]] = row[3];
    }
    var input = this.input, down = function (a) { var v = input[a]; return !!v && v.num !== undefined && +v.num === 1; };
    this.step(down('B5') || down('B10') || down('B13'), down('B6'));
    return { plane: this.board(), cells: this.tally() };
  };
  // The rows stopped, the case's kairosStops.
  KairosHand.prototype.counts = function () { return { stops: this.stops }; };
  hands.kairos = KairosHand;
})(window.AlonzoHands = window.AlonzoHands || {});

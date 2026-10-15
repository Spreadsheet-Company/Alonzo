// SPDX-License-Identifier: 0BSD
// SPDX-FileCopyrightText: 2026 Spreadsheet Company
//
// cartridges/sand/sand.hand.js - Sand by hand, the page's own (CART.2, decisions 13 and 21), a third
// beside the engine's module and the Rust one, engine/src/sand.rs. A hand (ENGINE.16): the builder writes
// this file into the page as the block hand-sand, a script the page runs where it stands, and it registers
// one constructor under its cartridge's name in window.AlonzoHands. The loop oracle's replay case answers
// it each frame of Sand's committed replay and holds the frame to the plane it answers; the frames
// instrument (?frames=1) holds Sand's fixture to its rule, SandHand.opening and SandHand.step.
(function (hands) {
  'use strict';
  // The rule of cartridges/sand/sand.vla as a person writes a falling-sand toy, each row's grains, sand and
  // water alike, proposing a move and the cells beneath them claiming it, from the bottom row up, in three
  // passes: straight down, then each grain's first diagonal, then its second, the first to the right on an
  // even row; a cell is claimed once, by the first grain to ask. Then the row's water that stayed claims a
  // cell of its row left free, in two passes, the side its row's direction names first. The codes are the
  // cartridge's, 0 empty, 1 wall, 2 sand and 3 water; the interior is C2:LF199, the walls two cells wide
  // down each side, row 1 empty and row 200 the floor, which shows the swatch. A plane of 320 by 200 bytes,
  // row by row.
  var SAND_W = 320, SAND_H = 200;
  var SAND_TOP = 2, SAND_BOTTOM = SAND_H - 1, SAND_LEFT = 3, SAND_RIGHT = SAND_W - 2;
  function sandEmpty(swatch) {
    var b = new Uint8Array(SAND_W * SAND_H), r, c;
    for (r = 1; r <= SAND_H; r++) { var at = (r - 1) * SAND_W; b[at] = b[at + 1] = b[at + SAND_W - 2] = b[at + SAND_W - 1] = 1; }
    for (c = SAND_LEFT; c <= SAND_RIGHT; c++) b[(SAND_H - 1) * SAND_W + (c - 1)] = swatch;
    return b;
  }
  // The opening: Life's soup as grains, Life's own arithmetic over the interior's top third, rows 2 to
  // 67 (CART.2's playtest pass), sand where the soup's square is under three sixteenths of the prime and
  // water where it is under three eighths.
  var SAND_RAIN = 67;
  function sandOpening(seed) {
    var P = 67108859, T = 25165822, TS = 12582911, b = sandEmpty(2);
    for (var r = SAND_TOP; r <= SAND_RAIN; r++) for (var c = SAND_LEFT; c <= SAND_RIGHT; c++) {
      var a = (seed * 1103515 + r * 1597334 + c * 1830421 + 12345) % P;
      var d = (seed * 2012345 + r * 1209487 + c * 1949213 + 54321) % P;
      var h = (a * d) % P, sq = (h * h) % P;
      if (sq < TS) b[(r - 1) * SAND_W + (c - 1)] = 2;
      else if (sq < T) b[(r - 1) * SAND_W + (c - 1)] = 3;
    }
    return b;
  }
  // One frame of the rule over the last frame's board, the floor showing the swatch: the row beneath
  // known after its departures and its water's sideways moves, occupied or not and what it holds, the
  // floor first. A brush, { row, col, radius, material }, paints the cells of the interior its disc
  // covers (CART.2's second slice, as engine/src/sand.rs paints them): a painted cell holds its paint at
  // the frame's end and is occupied when the paint is not empty, while the grain it held still moves as
  // the rule says, falling or moving sideways.
  function sandStep(old, swatch, brush) {
    var W = SAND_W, next = old.slice(), occ = new Uint8Array(W + 1), holds = new Uint8Array(W + 1);
    var claimed = new Uint8Array(W + 1), moved = new Uint8Array(W + 1), arrives = new Uint8Array(W + 1), r, c, pass, p;
    var taken = new Uint8Array(W + 1), went = new Uint8Array(W + 1);
    // the paint at a cell, or -1 where the disc does not reach or there is no brush
    function paint(pr, pc) {
      if (!brush || pr < SAND_TOP || pr > SAND_BOTTOM || pc < SAND_LEFT || pc > SAND_RIGHT) return -1;
      var dr = pr - brush.row, dc = pc - brush.col;
      return dr * dr + dc * dc <= brush.radius * brush.radius ? brush.material : -1;
    }
    for (c = SAND_LEFT; c <= SAND_RIGHT; c++) next[(SAND_H - 1) * W + (c - 1)] = swatch;
    for (c = 1; c <= W; c++) { occ[c] = 1; holds[c] = 1; }
    for (r = SAND_BOTTOM; r >= SAND_TOP; r--) {
      var row = (r - 1) * W, rightFirst = r % 2 === 0;
      claimed.fill(0); moved.fill(0); arrives.fill(0);
      for (pass = 0; pass < 3; pass++) for (c = SAND_LEFT; c <= SAND_RIGHT; c++) {
        var g = old[row + c - 1];
        if (g < 2 || moved[c]) continue;
        var t = pass === 0 ? c : ((pass === 1) === rightFirst ? c + 1 : c - 1);
        if (!occ[t] && !claimed[t]) { claimed[t] = 1; moved[c] = 1; arrives[t] = g; }
      }
      if (r < SAND_BOTTOM) for (c = SAND_LEFT; c <= SAND_RIGHT; c++) { p = paint(r + 1, c); next[row + W + c - 1] = p >= 0 ? p : occ[c] ? holds[c] : arrives[c]; }
      // this row after its departures
      for (c = 1; c <= W; c++) {
        var m = old[row + c - 1];
        p = paint(r, c);
        if (p >= 0) { occ[c] = p !== 0 ? 1 : 0; holds[c] = p; continue; }
        if (c < SAND_LEFT || c > SAND_RIGHT) { occ[c] = 1; holds[c] = m; continue; }
        var stays = m === 1 || (m >= 2 && !moved[c]);
        occ[c] = stays ? 1 : 0; holds[c] = stays ? m : 0;
      }
      // its water that stayed, into a cell of the row left free, its direction's side first; a grain
      // moving out frees no cell for another this frame
      taken.fill(0); went.fill(0);
      for (pass = 0; pass < 2; pass++) for (c = SAND_LEFT; c <= SAND_RIGHT; c++) {
        if (!occ[c] || old[row + c - 1] !== 3 || went[c]) continue;
        var s = (pass === 0) === rightFirst ? c + 1 : c - 1;
        if (!occ[s] && !taken[s]) { taken[s] = 1; went[c] = 1; }
      }
      // this row after its sideways moves, a painted cell holding its paint whatever moved
      for (c = SAND_LEFT; c <= SAND_RIGHT; c++) {
        if (went[c]) { occ[c] = 0; holds[c] = 0; }
        if (taken[c]) { occ[c] = 1; holds[c] = 3; }
        p = paint(r, c);
        if (p >= 0) { occ[c] = p !== 0 ? 1 : 0; holds[c] = p; }
      }
    }
    for (c = SAND_LEFT; c <= SAND_RIGHT; c++) { p = paint(SAND_TOP, c); next[(SAND_TOP - 1) * W + c - 1] = p >= 0 ? p : occ[c] ? holds[c] : 0; }
    return next;
  }
  // A replay of Sand (CART.2's second slice), the brush as the cartridge reads it: the Input sheet's cells
  // as the replay's rows leave them, since a replay logs a cell only in the frame it changes; the material
  // and the radius as the State and the Brush keep them, sand and 3 at the first frame, then a key's pick
  // and the wheel's notches; the disc the left or the right button paints while the pointer is over the
  // Screen, empty under the right; and the board, the opening from the seed at the first frame.
  // engine/src/cartridge.rs holds the same replay natively to engine/src/sand.rs.
  var SAND_PICKS = { '1': 2, '2': 1, '3': 3, '0': 0 };
  function SandHand(seed) { this.seed = seed; this.input = {}; this.material = 2; this.radius = 3; this.board = null; this.painted = 0; }
  SandHand.prototype.frame = function (n, rows) {
    for (var i = 0; i < rows.length; i++) {
      var row = rows[i];
      if (Array.isArray(row) && row[0] && row[0].sym === 'cell' && row[1] === 'Input' && typeof row[2] === 'string') this.input[row[2]] = row[3];
    }
    var input = this.input, num = function (a) { var v = input[a]; return v && v.num !== undefined ? +v.num : 0; };
    if (n === 1) { this.material = 2; this.radius = 3; this.board = sandOpening(this.seed); return { plane: this.board }; }
    var key = typeof input.B17 === 'string' ? input.B17 : '';
    if (Object.prototype.hasOwnProperty.call(SAND_PICKS, key)) this.material = SAND_PICKS[key];
    this.radius = Math.max(1, Math.min(8, this.radius - num('B16')));
    var col = num('B11'), row1 = num('B12'), left = num('B13'), right = num('B14');
    var brush = left + right > 0 && col > 0 && row1 > 0 ? { row: row1, col: col, radius: this.radius, material: right === 1 ? 0 : this.material } : null;
    if (brush) this.painted++;
    this.board = sandStep(this.board, this.material, brush);
    return { plane: this.board };
  };
  // The frames a brush painted, the case's sandPainted.
  SandHand.prototype.counts = function () { return { painted: this.painted }; };
  // The rule itself, for the frames instrument's Sand fixture.
  SandHand.opening = sandOpening;
  SandHand.step = sandStep;
  hands.sand = SandHand;
})(window.AlonzoHands = window.AlonzoHands || {});

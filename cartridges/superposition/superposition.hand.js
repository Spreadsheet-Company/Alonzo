// SPDX-License-Identifier: 0BSD
// SPDX-FileCopyrightText: 2026 Spreadsheet Company
//
// cartridges/superposition/superposition.hand.js - Superposition by hand (CART.12, decision 7), the page's own, a
// third beside the engine's module and the Rust one, engine/src/superposition.rs, whose rule, player and deepest
// deal it mirrors line for line. A hand (ENGINE.16): the builder writes this file into the page as the block
// hand-superposition, a script the page runs where it stands, and it registers one constructor under its
// cartridge's name in window.AlonzoHands. The loop oracle's replay case answers it each frame of Superposition's
// committed replay and holds the frame to what it answers, the Tally's sum of each row of the lattice, whose codes
// decode into the row's observations, boxes and decays exactly. The frames instrument (?frames=1) and the blit's
// act case (?blit=1) play the floors' scripted session through SuperpositionHand.Lattice and
// SuperpositionHand.Player, and find the cascade's deal by Lattice.deepest.
(function (hands) {
  'use strict';
  // The codes are the cartridge's: 0 a site in superposition, 10,000 plus its reading an observed site, 10,000,000 a
  // box and 10,000,000,000 an observed decay. The lattice is n by n sites from A1 to the sheet's nth row and column,
  // every cell of the Field a site and the Field bound there (version 6's (bound "Field"), CART.12's hand test); a
  // site's index is (row - 1) n + (column - 1).
  var P = 67108859, UNOBSERVED = 0, NOTHING = 10000, BOX = 10000000, DECAY = 10000000000;
  var AROUND = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]];
  var OBSERVE = 1, BOXED = 2, COLLAPSE = 3;
  function reading(code) { return code >= NOTHING + 1 && code <= NOTHING + 8; }

  // The lattice by hand: a frame takes the Input rows as the engine's frame sees them, the act's at its frame and
  // the released ones at a settle step, and computes in the cartridge's order the act's serial and the world, the
  // row the act stands on, the first observation of the world, the decays dealt from the seed, the world and the
  // probability with the first observation's 3 by 3 clear, the readings, and the lattice from its last frame.
  function Lattice(n, seed, probability) {
    var sites = n * n;
    this.n = n; this.seed = seed; this.probability = probability;
    this.acts = 0; this.world = 0; this.first = [0, 0];
    this.decays = new Uint8Array(sites); this.readings = new Float64Array(sites).fill(NOTHING);
    this.field = new Float64Array(sites); this.spare = new Float64Array(sites); this.dealt = '';
  }
  Lattice.prototype.index = function (row, column) { return (row - 1) * this.n + (column - 1); };
  Lattice.prototype.inside = function (row, column) { return row >= 1 && column >= 1 && row <= this.n && column <= this.n; };
  Lattice.prototype.site = function (row, column) { return this.field[this.index(row, column)]; };
  Lattice.prototype.decayed = function (row, column) { return this.decays[this.index(row, column)] === 1; };
  // A row's sum of its sites' codes, the Tally's: under 2^53 for any row.
  Lattice.prototype.rowSum = function (row) { var s = 0, at = (row - 1) * this.n; for (var c = 0; c < this.n; c++) s += this.field[at + c]; return s; };
  // Whether a site decays in a world: Life's soup hash of the seed, the site and the world, squared modulo the
  // prime, under the probability's share of it; every product under 2^53, which a double holds exactly. The forms'
  // constants, 3,440,100 and 3,213,021, are 12,345 and 54,321 with a row's and a column's multipliers added, so that
  // each site keeps the world it was dealt when the lattice stood a row and a column further in, at B2.
  Lattice.prototype.decaysAt = function (row, column, world) {
    var a = (this.seed * 1103515 + row * 1597334 + column * 1830421 + world * 7919 + 3440100) % P;
    var b = (this.seed * 2012345 + row * 1209487 + column * 1949213 + world * 104729 + 3213021) % P;
    var h = (a * b) % P;
    return (h * h) % P < this.probability * P;
  };
  // The world dealt, done again only when the seed, the world, the first observation or the probability moved.
  Lattice.prototype.deal = function () {
    var key = this.seed + ' ' + this.world + ' ' + this.first[0] + ' ' + this.first[1] + ' ' + this.probability;
    if (this.dealt === key) return;
    var n = this.n, d = this.decays, rd = this.readings, r, c, i;
    for (r = 1; r <= n; r++) for (c = 1; c <= n; c++) {
      var cleared = this.first[0] > 0 && Math.abs(r - this.first[0]) <= 1 && Math.abs(c - this.first[1]) <= 1;
      d[this.index(r, c)] = !cleared && this.decaysAt(r, c, this.world) ? 1 : 0;
    }
    for (r = 1; r <= n; r++) for (c = 1; c <= n; c++) {
      i = this.index(r, c);
      if (d[i]) { rd[i] = DECAY; continue; }
      var around = 0;
      for (var k = 0; k < 8; k++) { var rr = r + AROUND[k][0], cc = c + AROUND[k][1]; if (this.inside(rr, cc) && d[this.index(rr, cc)]) around++; }
      rd[i] = NOTHING + around;
    }
    this.dealt = key;
  };
  // One frame. An act is a press of a button or a command of the three, on the Field: a box toggles a site in
  // superposition and its box; an observation takes the site's reading; a collapse, or an observation of a reading,
  // turns a reading whose boxes equal it to a reading of nothing for one frame. Else a site in superposition takes
  // its reading beside a reading of nothing, a ring a frame; a box takes its reading beside a reading of nothing
  // indeed, 10,000 on the lattice and in the readings both, since nothing has decayed beside nothing, and never beside
  // a collapse, whose reading trusts its boxes (CART.12's hand test); and a reading of nothing takes its reading again.
  Lattice.prototype.frame = function (i) {
    var n = this.n, onField = i.sheet === 'Field', cmd = i.command || '';
    var act = onField && !!(i.left || i.right || i.middle || cmd === 'observe' || cmd === 'box' || cmd === 'collapse');
    var kind = i.right || cmd === 'box' ? BOXED : (i.middle || cmd === 'collapse' ? COLLAPSE : OBSERVE);
    var branched = cmd === 'branch';
    if (act) this.acts++;
    if (branched) this.world++;
    var actedRow = act && i.row >= 1 && i.row <= n ? i.row : 0;
    var observed = !!i.left || cmd === 'observe';
    if (branched) this.first = [0, 0];
    else if (this.first[0] > 0) { /* kept */ }
    else if (onField && observed && this.inside(i.row, i.column)) this.first = [i.row, i.column];
    else this.first = [0, 0];
    this.deal();
    var last = this.field, next = this.spare, rd = this.readings, self = this;
    function was(r, c) { return self.inside(r, c) ? last[self.index(r, c)] : 0; }
    for (var r = 1; r <= n; r++) for (var c = 1; c <= n; c++) {
      var k = (r - 1) * n + (c - 1), site = last[k], v, j, rr, cc;
      if (branched) v = UNOBSERVED;
      else if (actedRow === r && c === i.column) {
        if (kind === BOXED) v = site === UNOBSERVED ? BOX : (site === BOX ? UNOBSERVED : site);
        else if (kind === OBSERVE && site === UNOBSERVED) v = rd[k];
        else if (kind === COLLAPSE && site === UNOBSERVED) v = UNOBSERVED;
        else if (reading(site)) {
          var boxes = 0;
          for (j = 0; j < 8; j++) if (was(r + AROUND[j][0], c + AROUND[j][1]) === BOX) boxes++;
          v = boxes === site - NOTHING ? NOTHING : site;
        } else v = site;
      } else if (site === UNOBSERVED) {
        var opened = false;
        for (j = 0; j < 8 && !opened; j++) if (was(r + AROUND[j][0], c + AROUND[j][1]) === NOTHING) opened = true;
        v = opened ? rd[k] : UNOBSERVED;
      } else if (site === BOX) {
        var unsealed = false;
        for (j = 0; j < 8 && !unsealed; j++) {
          rr = r + AROUND[j][0]; cc = c + AROUND[j][1];
          if (was(rr, cc) === NOTHING && rd[self.index(rr, cc)] === NOTHING) unsealed = true;
        }
        v = unsealed ? rd[k] : BOX;
      } else if (site === NOTHING) v = rd[k];
      else v = site;
      next[k] = v;
    }
    this.spare = last; this.field = next;
  };
  // The neighbors of a site that stand on the lattice, by index, in AROUND's order.
  Lattice.prototype.around = function (i, out) {
    var n = this.n, r = Math.floor(i / n), c = i % n, m = 0;
    for (var k = 0; k < 8; k++) { var rr = r + AROUND[k][0], cc = c + AROUND[k][1]; if (rr >= 0 && cc >= 0 && rr < n && cc < n) out[m++] = rr * n + cc; }
    return m;
  };
  Lattice.prototype.besideReading = function (i) {
    var nb = [], m = this.around(i, nb);
    for (var k = 0; k < m; k++) if (reading(this.field[nb[k]])) return true;
    return false;
  };
  // The sites a move may be made on, row by row, by index (Player).
  Lattice.prototype.candidates = function (move) {
    var out = [], f = this.field, d = this.decays, nb = [], sites = f.length;
    for (var i = 0; i < sites; i++) {
      var site = f[i], takes = false;
      if (move === 'frontier') takes = site === UNOBSERVED && !d[i] && this.besideReading(i);
      else if (move === 'box' || move === 'trip') takes = site === UNOBSERVED && d[i] === 1 && this.besideReading(i);
      else if (move === 'collapse') {
        if (reading(site)) {
          var m = this.around(i, nb), boxes = 0, unobserved = false;
          for (var k = 0; k < m; k++) { if (f[nb[k]] === BOX) boxes++; if (f[nb[k]] === UNOBSERVED) unobserved = true; }
          takes = boxes === site - NOTHING && unobserved;
        }
      } else if (move === 'jump') takes = site === UNOBSERVED && !d[i];
      else if (move === 'open') takes = site === BOX;
      if (takes) out.push(i);
    }
    return out;
  };
  // A breadth-first sweep through readings of nothing from one site: the site it reaches deepest, the first row by
  // row among those, and its depth.
  Lattice.prototype.sweep = function (from) {
    var sites = this.field.length, depth = new Int32Array(sites).fill(-1), queue = new Int32Array(sites), nb = [];
    var head = 0, tail = 0, far = from, deepest = 0;
    depth[from] = 0; queue[tail++] = from;
    while (head < tail) {
      var i = queue[head++], dd = depth[i];
      if (dd > deepest || (dd === deepest && i < far)) { far = i; deepest = dd; }
      var m = this.around(i, nb);
      for (var k = 0; k < m; k++) { var j = nb[k]; if (this.readings[j] === NOTHING && depth[j] < 0) { depth[j] = dd + 1; queue[tail++] = j; } }
    }
    return [far, deepest];
  };
  // The site where a world's first observation opens the deepest cascade, in the world as last dealt: the largest
  // cluster of readings of nothing, joined through their eight neighbors, the first found row by row among
  // clusters of a size, and the site at an end of its widest path, which two breadth-first sweeps find.
  Lattice.prototype.deepest = function () {
    var sites = this.field.length, seen = new Uint8Array(sites), queue = new Int32Array(sites), nb = [], zeros = 0, first = 0;
    for (var start = 0; start < sites; start++) {
      if (this.readings[start] !== NOTHING || seen[start]) continue;
      var head = 0, tail = 0;
      seen[start] = 1; queue[tail++] = start;
      while (head < tail) {
        var i = queue[head++], m = this.around(i, nb);
        for (var k = 0; k < m; k++) { var j = nb[k]; if (this.readings[j] === NOTHING && !seen[j]) { seen[j] = 1; queue[tail++] = j; } }
      }
      if (tail > zeros) { zeros = tail; first = start; }
    }
    if (!zeros) return null;
    var end = this.sweep(first)[0], rings = this.sweep(end)[1];
    return { row: Math.floor(end / this.n) + 1, column: end % this.n + 1, zeros: zeros, rings: rings };
  };
  // The sites no longer in superposition.
  Lattice.prototype.opened = function () { var o = 0; for (var i = 0; i < this.field.length; i++) if (this.field[i] !== UNOBSERVED) o++; return o; };
  // The rows released, as the engine releases them before a settle step: the place kept, the press and the
  // command emptied.
  function released(i) { return { column: i.column, row: i.row, left: false, right: false, middle: false, sheet: i.sheet, command: '' }; }

  // The floors' scripted player (CART.12, decision 8), engine/src/superposition.rs's Player: the first act of a
  // world observes a site anywhere, the deal; every later act is drawn, six in ten a safe site on the frontier,
  // three in twenty a decay there boxed, one in ten a reading its boxes satisfy collapsed beside a site still in
  // superposition, and one in twenty each a trip, a jump and a box opened; a move with no site falls to the
  // frontier, then to a jump; its site drawn from the move's sites row by row, and made by its button or its
  // command, each half the time. MINSTD's draws, x = 48,271 x modulo 2^31 - 1, each product under 2^47.
  var MODULUS = 2147483647;
  function Player(seed) { var s = seed % MODULUS; this.state = s === 0 ? 1 : s; }
  Player.prototype.draw = function (n) { this.state = (this.state * 48271) % MODULUS; return this.state % n; };
  function made(row, column, kind, byCommand) {
    var i = { column: column, row: row, left: false, right: false, middle: false, sheet: 'Field', command: '' };
    if (byCommand) i.command = kind === BOXED ? 'box' : (kind === COLLAPSE ? 'collapse' : 'observe');
    else if (kind === BOXED) i.right = true;
    else if (kind === COLLAPSE) i.middle = true;
    else i.left = true;
    return i;
  }
  var KIND = { deal: OBSERVE, frontier: OBSERVE, box: BOXED, collapse: COLLAPSE, trip: OBSERVE, jump: OBSERVE, open: BOXED };
  // The next act on the lattice as the last frame left it: { move, inputs }.
  Player.prototype.act = function (l) {
    var n = l.n, byCommand, row, column;
    if (l.first[0] === 0) {
      row = 1 + this.draw(n); column = 1 + this.draw(n); byCommand = this.draw(2) === 1;
      return { move: 'deal', inputs: made(row, column, OBSERVE, byCommand) };
    }
    var roll = this.draw(100);
    var wanted = roll < 60 ? 'frontier' : roll < 75 ? 'box' : roll < 85 ? 'collapse' : roll < 90 ? 'trip' : roll < 95 ? 'jump' : 'open';
    var order = [wanted, 'frontier', 'jump'];
    for (var o = 0; o < order.length; o++) {
      var sites = l.candidates(order[o]);
      if (!sites.length) continue;
      var i = sites[this.draw(sites.length)];
      byCommand = this.draw(2) === 1;
      return { move: order[o], inputs: made(Math.floor(i / n) + 1, i % n + 1, KIND[order[o]], byCommand) };
    }
    return { move: 'jump', inputs: made(1, 1, OBSERVE, false) };
  };

  // A replay of Superposition: the Input sheet's cells as the replay's rows leave them, a frame with rows an act's
  // and a frame with none a settle step, before which the engine has released the press and the command; an edit
  // of the probability or the seed read as the lattice reads it. Each frame answers the Tally's sum of each row.
  function num(v) { return v && v.num !== undefined ? +v.num : (typeof v === 'number' ? v : 0); }
  function SuperpositionHand(seed) { this.lattice = new Lattice(512, seed, 0.15); this.input = {}; this.settles = 0; }
  SuperpositionHand.prototype.frame = function (n, rows) {
    var l = this.lattice, input = this.input;
    for (var k = 0; k < rows.length; k++) {
      var row = rows[k];
      if (!Array.isArray(row) || !row[0] || row[0].sym !== 'cell' || typeof row[2] !== 'string') continue;
      if (row[1] === 'Input') input[row[2]] = row[3];
      else if (row[1] === 'Constants' && row[2] === 'B1') l.probability = num(row[3]);
      else if (row[1] === 'Clock' && row[2] === 'B3') l.seed = num(row[3]);
    }
    if (!rows.length) { input.B13 = { num: 0 }; input.B14 = { num: 0 }; input.B15 = { num: 0 }; input.B20 = ''; this.settles++; }
    l.frame({ column: num(input.B11), row: num(input.B12), left: num(input.B13) === 1, right: num(input.B14) === 1, middle: num(input.B15) === 1,
              sheet: typeof input.B19 === 'string' ? input.B19 : '', command: typeof input.B20 === 'string' ? input.B20 : '' });
    var cells = {}, sums = String.fromCharCode(64 + l.n / 32 + 2);
    for (var r = 1; r <= l.n; r++) cells['Tally!' + sums + r] = l.rowSum(r);
    return { cells: cells };
  };
  // The acts the lattice counted, the worlds, and the settle steps: the case's superpositionActs and the rest.
  SuperpositionHand.prototype.counts = function () { return { acts: this.lattice.acts, worlds: this.lattice.world + 1, settles: this.settles, opened: this.lattice.opened() }; };
  SuperpositionHand.Lattice = Lattice;
  SuperpositionHand.Player = Player;
  SuperpositionHand.released = released;
  SuperpositionHand.codes = { UNOBSERVED: UNOBSERVED, NOTHING: NOTHING, BOX: BOX, DECAY: DECAY };
  hands.superposition = SuperpositionHand;
})(window.AlonzoHands = window.AlonzoHands || {});

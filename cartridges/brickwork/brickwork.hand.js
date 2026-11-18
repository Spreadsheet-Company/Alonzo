// SPDX-License-Identifier: 0BSD
// SPDX-FileCopyrightText: 2026 Spreadsheet Company
//
// cartridges/brickwork/brickwork.hand.js - Brickwork by hand (CART.3's third slice), the page's own, a third beside the
// engine's module and the Rust one, engine/src/brickwork.rs, whose rule it follows line for line: the wall a grid of
// cells, a brick turned in its box and tested cell by cell, its deal by Park and Miller's dice. A hand (ENGINE.16): the
// builder writes this file into the page as the block hand-brickwork, a script the page runs where it stands, and it
// registers one constructor under its cartridge's name in window.AlonzoHands. The loop oracle's replay case answers it
// each frame of Brickwork's committed replay and holds the frame to what it answers (decision 27, its design (b)): the
// State's cells and the Tally's at every frame; and the whole, the wall's words and the joints its rules light, each
// course's count, the next three, the Clipboard, the words beside the wall, the serials, the laid wall, the bag in use
// and the four voices, at every frame that moves the wall, a lay, a clear, a start or a top-out, at the first and at
// every 64th. The wall's words are formulas of the State and the laid wall, which only those frames move.
(function (hands) {
  'use strict';
  var WIDTH = 14, HEIGHT = 24, KINDS = 9, SLOTS = 36, MOST_OF_EACH = 4, A_MINUTE = 3600, MODULUS = 2147483647;
  var FIRST_COUNT_ROW = 12, WHOLE_EVERY = 64, SPAWN_COLUMN = Math.floor((WIDTH - 3) / 2) + 1;
  // Each setting's row on the Pace sheet, from 1: its lowest value, its highest, its default, and whether it counts
  // frames, a whole number: the frames a course as a game begins, the share each course cleared takes off them, the
  // fewest frames a course, the lay's delay, a held arrow's delay and its period, the soft fall, the beat and the hold.
  var SETTINGS = [[1, A_MINUTE, 60, false], [0, 1, 0.03, false], [1, A_MINUTE, 1, true], [0, A_MINUTE, 30, true],
                  [0, A_MINUTE, 10, true], [1, A_MINUTE, 2, true], [1, A_MINUTE, 2, true], [2, A_MINUTE, 12, true],
                  [0, A_MINUTE, 60, true]];
  // The bricks, each its name, its box's side and its first picture, # a cell of the brick.
  var BRICKS = [['header', 1, ['#']], ['brick', 2, ['##']], ['corner', 2, ['##', '#.']], ['lintel', 3, ['...', '###']],
                ['square', 2, ['##', '##']], ['arch', 3, ['###', '#.#']], ['block', 3, ['###', '###']],
                ['horseshoe', 3, ['###', '#.#', '#.#']], ['flue', 3, ['###', '#.#', '###']]];
  // The phases as the State's B60 codes them.
  var WAITING = 0, FALLING = 1, BEAT = 2, OVER = 3;
  // The commands a frame may run, by the names the Input's B20 holds.
  var COMMANDS = { '': true, pause: true, 'slide-left': true, 'slide-right': true, 'to-the-bottom': true, cut: true };

  // A setting as the game reads it: the number typed, a whole number where it counts frames, held inside its bounds;
  // or its default where the cell holds no number (null).
  function heldSetting(typed, row) {
    var s = SETTINGS[row - 1];
    if (typed === null) return s[2];
    return Math.max(s[0], Math.min(s[1], s[3] ? Math.floor(typed) : typed));
  }
  // A brick's count as the game reads it: a whole number from none to four, none where the cell holds no number.
  function heldCount(typed) { return typed === null ? 0 : Math.max(0, Math.min(MOST_OF_EACH, Math.floor(typed))); }
  // The counts a bag is dealt by: each brick once if none is counted, and a bag of fewer than three twice or three
  // times over, so that the next three are always this bag's or the next's.
  function inUse(held) {
    var sum = 0, out = [], i;
    for (i = 0; i < KINDS; i++) sum += held[i];
    for (i = 0; i < KINDS; i++) out.push(sum === 0 ? 1 : held[i] * Math.floor((sum + 2) / sum));
    return out;
  }
  function sizeOf(counts) { var s = 0; for (var i = 0; i < KINDS; i++) s += counts[i]; return s; }
  function sameCounts(a, b) { for (var i = 0; i < KINDS; i++) if (a[i] !== b[i]) return false; return true; }
  function zeros(n) { var a = []; for (var i = 0; i < n; i++) a.push(0); return a; }
  function emptyWall() { var w = []; for (var r = 0; r < HEIGHT; r++) w.push(zeros(WIDTH)); return w; }
  function place(course, column, turn) { return { course: course, column: column, turn: turn }; }

  // A brick's cells in a turn, each [box row, box column] from 0: the first picture turned clockwise in its box turn
  // times, a cell at (r, c) going to (c, size - 1 - r), kept once made.
  var CELLS = [];
  function cellsOf(kind, turn) {
    var t = turn % 4, byKind = CELLS[kind] || (CELLS[kind] = []);
    if (byKind[t]) return byKind[t];
    var brick = BRICKS[kind - 1], size = brick[1], rows = brick[2], out = [], r, c, n;
    for (r = 0; r < rows.length; r++) for (c = 0; c < rows[r].length; c++) if (rows[r].charAt(c) === '#') out.push([r, c]);
    for (n = 0; n < t; n++) out = out.map(function (p) { return [p[1], size - 1 - p[0]]; });
    out.sort(function (a, b) { return a[0] - b[0] || a[1] - b[1]; });
    return (byKind[t] = out);
  }
  // The kind and turn a place names: where no brick is, the header's first turn, as the cartridge's key of 1.
  function cellsAt(kind, turn) { return kind < 1 ? cellsOf(1, 0) : cellsOf(kind, turn); }
  // Whether a brick fits at a place in a wall: every cell inside the wall and on an empty cell.
  function fitsIn(wall, kind, at) {
    var cs = cellsAt(kind, at.turn);
    for (var i = 0; i < cs.length; i++) {
      var row = at.course + cs[i][0], col = at.column + cs[i][1];
      if (row < 1 || row > HEIGHT || col < 1 || col > WIDTH || wall[row - 1][col - 1] !== 0) return false;
    }
    return true;
  }
  // The course a brick lands at falling straight from its place: the course before the first one below it where it
  // no longer fits.
  function landingOf(wall, kind, at) {
    var first = HEIGHT + 1;
    for (var r = 1; r <= HEIGHT; r++) if (r > at.course && !fitsIn(wall, kind, place(r, at.column, at.turn))) { first = r; break; }
    return first - 1;
  }
  // Whether a brick at a place covers a cell, by course and column from 1.
  function covers(kind, at, course, column) {
    var cs = cellsAt(kind, at.turn);
    for (var i = 0; i < cs.length; i++) if (at.course + cs[i][0] === course && at.column + cs[i][1] === column) return true;
    return false;
  }

  // Seventy-two of Park and Miller's dice after a base, each the next after the one before: thirty-six for this bag,
  // thirty-six for the next. A die under 2^31 times 16807 stays under 2^46, a double's whole number.
  function dice(base) {
    var out = [], x = base;
    for (var i = 0; i < 2 * SLOTS; i++) { x = (x * 16807) % MODULUS; out.push(x); }
    return out;
  }
  // A bag from thirty-six dice from d[from], and the counts in use: each slot a brick, the header's first and each as
  // many as its count; a slot past the bag's size takes a die larger than any; and the kind at each place the brick of
  // the slot whose die ranks there, from the smallest; 0 at a place past the bag's size.
  function order(d, from, counts, firstRow) {
    var n = sizeOf(counts), slots = [], out = [], i;
    function slotKind(slot) { var sum = 0, below = 0; for (var j = 0; j < KINDS; j++) { sum += counts[j]; if (sum < slot) below++; } return below + 1; }
    function key(slot) { return slot <= n ? d[from + slot - 1] : 3000000000 + firstRow + slot - 1; }
    for (i = 1; i <= SLOTS; i++) slots.push(i);
    slots.sort(function (a, b) { return key(a) - key(b); });
    for (i = 0; i < SLOTS; i++) out.push(i < n ? slotKind(slots[i]) : 0);
    return out;
  }
  // The kind at a place of a game's deal: counted from the deal's start, this bag holds its number's size of the
  // places and the next bag those after.
  function kindAt(at, start, size, thisBag, nextBag, number) {
    var q = at - start - 1, i = q % size;
    return Math.floor(q / size) === number ? thisBag[i] : nextBag[i];
  }

  // The pace and the settings as the game reads them from the Pace sheet, and each brick's count in a bag.
  function Settings() {
    this.startPace = 0; this.quickening = 0; this.fastest = 0; this.layDelay = 0; this.repeatDelay = 0;
    this.repeatPeriod = 0; this.softFall = 0; this.beat = 0; this.hold = 0; this.bag = [2, 2, 2, 2, 1, 1, 1, 1, 1];
    for (var row = 1; row <= SETTINGS.length; row++) this.typeInto(row, null);
  }
  // What a person types into a row of the Pace sheet, a number or none: a setting in rows 1 to 9, a brick's count in
  // rows 12 to 20.
  Settings.prototype.typeInto = function (row, typed) {
    if (row >= FIRST_COUNT_ROW && row < FIRST_COUNT_ROW + KINDS) { this.bag[row - FIRST_COUNT_ROW] = heldCount(typed); return; }
    if (row < 1 || row > SETTINGS.length) throw new Error('no setting at the Pace\'s row ' + row);
    var v = heldSetting(typed, row), frames = Math.floor(v);
    if (row === 1) this.startPace = v;
    else if (row === 2) this.quickening = v;
    else if (row === 3) this.fastest = frames;
    else if (row === 4) this.layDelay = frames;
    else if (row === 5) this.repeatDelay = frames;
    else if (row === 6) this.repeatPeriod = frames;
    else if (row === 7) this.softFall = frames;
    else if (row === 8) this.beat = frames;
    else this.hold = frames;
  };

  // Frame 0: the grid as the load computes it, every count 0, the pace 0, the phase waiting, the bags empty until the
  // first frame deals them, and the counts in use read from the Pace, against none before them.
  function Game(settings, seed) {
    this.settings = settings; this.seed = seed; this.frame = 0; this.phase = WAITING; this.since = 0; this.paused = false;
    this.wall = emptyWall(); this.kind = 0; this.brick = place(0, 0, 0); this.dealt = 0; this.counts = inUse(settings.bag);
    this.recount = true; this.redeal = true; this.dealStart = 0; this.bagNumber = 0; this.thisBag = zeros(SLOTS);
    this.nextBag = zeros(SLOTS); this.generator = 0; this.sinceFall = 0; this.restingFor = 0; this.level = 0; this.pace = 0;
    this.clearing = false; this.laidCourses = 0; this.beatNow = 0; this.sinceLay = 1; this.heldTurn = false; this.heldA = false;
    this.heldLay = false; this.heldLeft = 0; this.heldRight = 0; this.placed = place(0, 0, 0); this.landing = 0;
    this.resting = false; this.lay = false; this.turned = false; this.kicked = false; this.moved = false; this.fell = false;
    this.starts = false; this.topout = false; this.entered = false; this.fullCount = 0; this.period = 0;
    this.tallyKinds = zeros(KINDS); this.tallyAtOnce = zeros(4); this.games = 0; this.topouts = 0; this.cut = false;
    this.cutRefused = false; this.clipKind = 0; this.cutUsed = false; this.refusedSince = 1; this.slid = false;
    this.dropped = false; this.serial = 0; this.tallySlides = 0; this.tallyDropped = 0; this.tallyCuts = 0; this.shifted = false;
  }
  // One frame: the keys held and the command run, the stages in the cartridge's order, the lay, the wall's event and
  // the counts, each from the frame before as the cartridge's twins read it.
  Game.prototype.step = function (keys) {
    var s = this.settings, last = {}, f;
    for (f in this) if (Object.prototype.hasOwnProperty.call(this, f)) last[f] = this[f];
    this.frame += 1;
    var first = this.frame === 1;

    // the keys
    var turnHeld = keys.up || keys.b, cw = turnHeld && !last.heldTurn, ccw = keys.a && !last.heldA;
    var layHeld = keys.start || keys.select, layKey = layHeld && !last.heldLay;
    this.heldTurn = turnHeld; this.heldA = keys.a; this.heldLay = layHeld;
    this.paused = first ? false : keys.command === 'pause' && (last.phase === FALLING || last.phase === BEAT) ? !last.paused : last.paused;
    var go = !this.paused;
    this.heldLeft = keys.left ? last.heldLeft + 1 : 0;
    this.heldRight = keys.right ? last.heldRight + 1 : 0;
    var steps = function (held) { return held === 1 || (held > s.repeatDelay && (held - s.repeatDelay - 1) % s.repeatPeriod === 0); };
    var stepLeft = go && keys.left && steps(this.heldLeft), stepRight = go && keys.right && steps(this.heldRight);
    var dx = (stepRight ? 1 : 0) - (stepLeft ? 1 : 0), dt = go ? (cw ? 1 : 0) - (ccw ? 1 : 0) : 0;
    var slide = keys.command === 'slide-left' ? -1 : keys.command === 'slide-right' ? 1 : 0;
    var toBottom = keys.command === 'to-the-bottom';
    var cutWanted = go && last.phase === FALLING && keys.command === 'cut' && !last.cutUsed;

    // a game starts, never at the first frame, and a brick enters, its kind from the bags the last frame left, by the
    // size they were dealt at
    this.starts = !first && layKey && (last.phase === WAITING || (last.phase === OVER && last.since >= s.hold));
    var ending = go && last.phase === BEAT && last.since === (last.clearing ? last.beatNow - 1 : 0);
    var enteringAt = this.starts ? 1 : last.dealt + 1, counts = inUse(s.bag);
    var sizeBefore = first ? sizeOf(counts) : sizeOf(last.counts), fromClip = cutWanted && last.clipKind > 0;
    var enterKind = fromClip ? last.clipKind : kindAt(enteringAt, last.dealStart, sizeBefore, last.thisBag, last.nextBag, last.bagNumber);
    var spawn = place(1, SPAWN_COLUMN, 0), spawnOk = this.starts || fitsIn(last.wall, enterKind, spawn);
    this.cut = cutWanted && spawnOk;
    this.cutRefused = cutWanted && !spawnOk;
    var enter = this.starts || ending || this.cut;
    this.topout = (this.starts || ending) && !spawnOk;
    this.entered = enter && spawnOk;
    var bagEntry = this.entered && !fromClip;

    // the deal: dealt afresh at a top-out or at a count changed, the places from a count changed counted from the
    // deal's start
    this.recount = !first && !sameCounts(counts, last.counts);
    this.redeal = this.topout || this.recount;
    var newBag = bagEntry && Math.floor((enteringAt - last.dealStart - 1) / sizeBefore) > last.bagNumber;
    this.dealt = first || this.topout ? 0 : bagEntry ? enteringAt : last.dealt;
    this.serial = first || this.topout ? 0 : this.entered ? last.serial + 1 : last.serial;
    this.clipKind = first || this.starts ? 0 : this.cut ? last.kind : last.clipKind;
    this.dealStart = first || this.topout ? 0 : this.recount ? this.dealt : last.dealStart;
    this.bagNumber = first || this.redeal ? 0 : newBag ? last.bagNumber + 1 : last.bagNumber;
    var d = dice(first ? this.seed : last.generator);
    if (first || this.redeal) { this.thisBag = order(d, 0, counts, 1); this.nextBag = order(d, SLOTS, counts, SLOTS + 1); this.generator = d[2 * SLOTS - 1]; }
    else if (newBag) { this.thisBag = last.nextBag; this.nextBag = order(d, 0, counts, 1); this.generator = d[SLOTS - 1]; }
    this.counts = counts;
    this.kind = first ? 0 : this.entered ? enterKind : last.kind;
    var kind = this.kind;

    // the stages: a turn (in place, a column right, a column left, a course up, the first that fits), a slide or a
    // move, and a fall, each from where the last left the brick
    var moving = go && last.phase === FALLING && !cutWanted, aim = (last.brick.turn + dt + 4) % 4, lb = last.brick;
    var tries = [place(lb.course, lb.column, aim), place(lb.course, lb.column + 1, aim), place(lb.course, lb.column - 1, aim), place(lb.course - 1, lb.column, aim)];
    var fit = tries.map(function (p) { return fitsIn(last.wall, kind, p); }), fitAt = fit.indexOf(true);
    this.turned = moving && dt !== 0 && fitAt >= 0;
    this.kicked = this.turned && !fit[0];
    var turnedTo = this.turned ? tries[fitAt] : lb, slidTo = turnedTo;
    while (slide !== 0 && fitsIn(last.wall, kind, place(slidTo.course, slidTo.column + slide, slidTo.turn))) slidTo = place(slidTo.course, slidTo.column + slide, slidTo.turn);
    this.slid = moving && slide !== 0 && slidTo.column !== turnedTo.column;
    var movedTo = place(turnedTo.course, turnedTo.column + dx, turnedTo.turn);
    this.moved = moving && (this.slid || (slide === 0 && dx !== 0 && fitsIn(last.wall, kind, movedTo)));
    var afterMove = this.slid ? slidTo : this.moved ? movedTo : turnedTo;
    this.period = Math.max(s.fastest, Math.floor(last.pace + 0.5));
    var gravity = keys.down ? Math.min(s.softFall, this.period) : this.period, due = last.sinceFall + 1 >= gravity;
    var below = place(afterMove.course + 1, afterMove.column, afterMove.turn);
    var bottom = place(landingOf(last.wall, kind, afterMove), afterMove.column, afterMove.turn);
    this.dropped = moving && toBottom && bottom.course > afterMove.course;
    this.fell = moving && (this.dropped || (due && fitsIn(last.wall, kind, below)));
    this.placed = this.entered ? spawn : moving ? (this.dropped ? bottom : this.fell ? below : afterMove) : lb;
    var placed = this.placed;
    this.resting = !fitsIn(last.wall, kind, place(placed.course + 1, placed.column, placed.turn));
    this.sinceFall = first || this.entered ? 0 : moving ? (this.fell ? 0 : last.sinceFall + 1) : last.sinceFall;
    this.restingFor = first || this.entered ? 0 : moving ? (this.fell ? 0 : this.resting ? last.restingFor + 1 : last.restingFor) : last.restingFor;
    this.landing = landingOf(last.wall, kind, placed);
    this.lay = moving && (layKey || (this.resting && this.restingFor >= s.layDelay));
    var layCourse = layKey ? this.landing : placed.course;
    this.brick = first ? place(1, SPAWN_COLUMN, 0) : this.lay ? place(layCourse, placed.column, placed.turn) : placed;

    // the phase
    this.phase = first ? WAITING : this.topout ? OVER : this.entered ? FALLING : this.lay ? BEAT : last.phase;
    this.since = first || this.phase !== last.phase ? 0 : go ? last.since + 1 : last.since;

    // the lay: the brick's cells and the full courses
    var laid = last.wall, r, c;
    this.fullCount = 0;
    if (this.lay) {
      laid = last.wall.map(function (row) { return row.slice(); });
      var cs = cellsAt(kind, this.brick.turn);
      for (var i = 0; i < cs.length; i++) {
        r = this.brick.course + cs[i][0]; c = this.brick.column + cs[i][1];
        if (r >= 1 && r <= HEIGHT && c >= 1 && c <= WIDTH) laid[r - 1][c - 1] = this.serial;
      }
      for (r = 0; r < HEIGHT; r++) if (laid[r].every(function (v) { return v !== 0; })) this.fullCount++;
    }

    // the level, the pace and the beat's counts: the pace a product, a multiplication a course cleared, in the
    // cartridge's order
    this.level = first || this.starts ? 0 : last.level + this.fullCount;
    var quicken = 1 - s.quickening;
    if (first || this.starts) this.pace = s.startPace;
    else { var p = last.pace; for (var nth = 1; nth <= 4; nth++) p *= this.fullCount >= nth ? quicken : 1; this.pace = p; }
    this.clearing = first ? false : this.lay ? this.fullCount > 0 : last.clearing;
    this.laidCourses = first ? 0 : this.lay ? this.fullCount : last.laidCourses;
    this.beatNow = first || this.lay ? s.beat : last.beatNow;
    var shift = go && last.phase === BEAT && last.clearing && last.since === last.beatNow - 2;

    // the wall's event
    this.shifted = false;
    if (first || this.starts) this.wall = emptyWall();
    else if (this.lay) this.wall = laid;
    else if (shift) {
      var kept = last.wall.filter(function (row) { return !row.every(function (v) { return v !== 0; }); }), out = [];
      for (r = 0; r < HEIGHT - kept.length; r++) out.push(zeros(WIDTH));
      this.wall = out.concat(kept.map(function (row) { return row.slice(); }));
      this.shifted = true;
    } else this.wall = last.wall;
    this.sinceLay = first ? 99 : this.lay ? 0 : go ? Math.min(last.sinceLay + 1, 99) : last.sinceLay;

    // the Tally
    if (this.lay) {
      this.tallyKinds[kind - 1] += 1;
      if (this.fullCount >= 1 && this.fullCount <= 4) this.tallyAtOnce[this.fullCount - 1] += 1;
    }
    this.games += this.starts ? 1 : 0;
    this.topouts += this.topout ? 1 : 0;
    this.cutUsed = first || this.starts ? false : this.cut ? true : this.lay ? false : last.cutUsed;
    this.refusedSince = first ? 99 : this.cutRefused ? 0 : Math.min(last.refusedSince + 1, 99);
    this.tallySlides += this.slid ? 1 : 0;
    this.tallyDropped += this.dropped ? 1 : 0;
    this.tallyCuts += this.cut ? 1 : 0;
  };
  // The next three kinds, from the bags as the frame leaves them.
  Game.prototype.next = function () {
    var size = sizeOf(this.counts), out = [];
    for (var i = 1; i <= 3; i++) out.push(kindAt(this.dealt + i, this.dealStart, size, this.thisBag, this.nextBag, this.bagNumber));
    return out;
  };
  // A course's count of laid cells.
  Game.prototype.count = function (course) { var n = 0, row = this.wall[course - 1]; for (var c = 0; c < WIDTH; c++) if (row[c] !== 0) n++; return n; };
  // The word a cell of the wall shows, by course and column from 1.
  Game.prototype.word = function (course, column) {
    if (this.phase === FALLING && covers(this.kind, this.brick, course, column)) return 'falling';
    if (this.phase === FALLING && covers(this.kind, place(this.landing, this.brick.column, this.brick.turn), course, column)) return 'landing';
    if (this.wall[course - 1][column - 1] === 0) return '';
    return this.phase === BEAT && this.count(course) === WIDTH ? 'full' : 'brick';
  };
  // The serial a cell shows the joints, the falling brick's its own, and 0 outside the wall.
  Game.prototype.serialAt = function (course, column) {
    if (course < 1 || course > HEIGHT || column < 1 || column > WIDTH) return 0;
    if (this.phase === FALLING && covers(this.kind, this.brick, course, column)) return this.serial;
    return this.wall[course - 1][column - 1];
  };
  // The words beside the wall, when there is something to say, and the line below them.
  Game.prototype.words = function () {
    if (this.phase === WAITING) return 'Enter or Space begins a wall.';
    if (this.paused) return 'Paused: P resumes.';
    if (this.phase === FALLING && this.refusedSince < 60) return 'Ctrl+X: no room at the top for the brick it brings.';
    if (this.phase === OVER) return '#SPILL! The next brick has no room.';
    return '';
  };
  Game.prototype.hint = function () { return this.phase === OVER && this.since >= this.settings.hold ? 'Enter or Space builds again.' : ''; };
  // The four voices, each [wave, note, volume].
  Game.prototype.voices = function () {
    var go = !this.paused, chord = [72, 76, 79, 84][Math.min(Math.floor(this.sinceLay / 3) + 1, 4) - 1];
    return [
      ['square', 76, go && (this.turned || this.moved || this.cut) ? 0.25 : 0],
      ['triangle', 45, go && this.sinceLay < 6 ? 0.6 : 0],
      ['square', chord, go && this.laidCourses > 0 && this.sinceLay < 3 * this.laidCourses ? 0.35 : 0],
      ['sawtooth', this.phase === OVER ? Math.max(60 - this.since / 2, 24) : 60, this.phase === OVER && this.since < 40 ? 0.4 : 0]
    ];
  };

  function colName(n) { return String.fromCharCode(64 + n); }
  function bit(x) { return x ? 1 : 0; }
  // A number of the page's reader, {num}, as a number, else null: what a typed text holds.
  function numberOf(v) { return v && typeof v === 'object' && v.num !== undefined ? +v.num : null; }

  // A replay of Brickwork: the Input sheet's cells as the replay's rows leave them, the buttons held player 1's, B1 to
  // B10, and the command B20; a number typed into the Pace sheet's column B the game's at once.
  function BrickworkHand(seed) { this.g = new Game(new Settings(), seed); this.input = {}; this.wholes = 0; }
  BrickworkHand.prototype.frame = function (n, rows) {
    var g = this.g, input = this.input, i, row, m;
    for (i = 0; i < rows.length; i++) {
      row = rows[i];
      if (!Array.isArray(row) || !row[0] || row[0].sym !== 'cell' || typeof row[1] !== 'string' || typeof row[2] !== 'string') throw new Error('frame ' + n + ': a row the hand does not read');
      if (row[1] === 'Input') input[row[2]] = row[3];
      else if (row[1] === 'Pace' && (m = /^B(\d+)$/.exec(row[2]))) g.settings.typeInto(+m[1], numberOf(row[3]));
      else throw new Error('frame ' + n + ': a row of ' + row[1] + '!' + row[2] + ' the hand does not read');
    }
    var on = function (a) { var v = input[a]; return !!v && typeof v === 'object' && v.num !== undefined && +v.num === 1; };
    var command = input.B20 === undefined ? '' : input.B20;
    if (typeof command !== 'string' || !COMMANDS[command]) throw new Error('frame ' + n + ': a command the hand does not know: ' + JSON.stringify(command));
    g.step({ up: on('B1'), down: on('B2'), left: on('B3'), right: on('B4'), a: on('B5'), b: on('B6'), start: on('B9'), select: on('B10'), command: command });
    if (g.frame !== n) throw new Error('the hand stepped to frame ' + g.frame + ' at the replay\'s frame ' + n);
    var cells = this.held(), answer = { cells: cells };
    if (g.frame === 1 || g.lay || g.shifted || g.starts || g.topout || g.frame % WHOLE_EVERY === 0) { answer.lit = this.whole(cells); this.wholes++; }
    return answer;
  };
  // The State's cells and the Tally's, each at its address, as the Rust hand holds them.
  BrickworkHand.prototype.held = function () {
    var g = this.g, s = g.settings, out = {}, a, k;
    var state = {
      B5: bit(g.paused), B12: g.heldLeft, B13: g.heldRight, B18: bit(g.starts), B25: bit(g.topout), B27: g.dealt,
      B29: g.bagNumber, B30: g.generator, B31: g.kind, B35: bit(g.turned), B40: bit(g.moved), B42: g.period, B45: bit(g.fell),
      B46: g.placed.course, B47: g.placed.column, B48: g.placed.turn, B50: bit(g.resting), B51: g.sinceFall, B52: g.restingFor,
      B53: g.landing, B54: bit(g.lay), B56: g.brick.course, B57: g.brick.column, B58: g.brick.turn, B60: g.phase, B61: g.since,
      B62: g.fullCount, B63: g.level, B65: g.pace, B66: bit(g.clearing), B67: g.laidCourses, B70: g.sinceLay,
      B77: sizeOf(g.counts), B78: bit(g.recount), B79: bit(g.redeal), B81: g.dealStart, B82: g.beatNow, B83: s.startPace,
      B84: s.quickening, B85: s.fastest, B86: s.layDelay, B87: s.repeatDelay, B88: s.repeatPeriod, B89: s.softFall,
      B90: s.beat, B91: s.hold, B96: bit(g.cut), B97: bit(g.cutRefused), B99: g.serial, B100: g.clipKind, B101: bit(g.cutUsed),
      B102: g.refusedSince, B103: bit(g.slid), B106: bit(g.dropped)
    };
    for (a in state) if (Object.prototype.hasOwnProperty.call(state, a)) out['State!' + a] = state[a];
    for (k = 1; k <= KINDS; k++) out['Tally!B' + (k + 1)] = g.tallyKinds[k - 1];
    for (k = 1; k <= 4; k++) out['Tally!B' + (k + 11)] = g.tallyAtOnce[k - 1];
    out['Tally!B17'] = g.games; out['Tally!B18'] = g.topouts;
    out['Tally!B19'] = g.tallySlides; out['Tally!B20'] = g.tallyDropped; out['Tally!B21'] = g.tallyCuts;
    return out;
  };
  // The whole, added to cells: the wall's words, B2:O25, and each course's count beside it in Q; the next three, S2:U12
  // a box of three every four rows; the Clipboard, S15:U17; the words beside the wall, W2 and W3, and the level, X4; the
  // serials and the laid wall, B2:O25 of their sheets; the bag in use, Bag!I1:I9; and the four voices, Audio!B2:D5. Its
  // answer the rules each cell of the wall lights, a side of it whose neighbor's serial is another's: 1 above, 2 on the
  // right, 3 below and 4 on the left; none on any other cell the hand names.
  BrickworkHand.prototype.whole = function (cells) {
    var g = this.g, lit = {}, SIDES = [[-1, 0], [0, 1], [1, 0], [0, -1]], course, column, addr, me, rules, i, rr, cc, box;
    for (course = 1; course <= HEIGHT; course++) {
      for (column = 1; column <= WIDTH; column++) {
        addr = colName(column + 1) + (course + 1);
        cells['Wall!' + addr] = g.word(course, column);
        me = g.serialAt(course, column);
        cells['Serials!' + addr] = me;
        cells['Laid!' + addr] = g.wall[course - 1][column - 1];
        rules = [];
        for (i = 0; i < 4; i++) if (me > 0 && me !== g.serialAt(course + SIDES[i][0], column + SIDES[i][1])) rules.push(i + 1);
        if (rules.length) lit['Wall!' + addr] = rules;
      }
      var n = g.count(course);
      cells['Wall!' + colName(WIDTH + 3) + (course + 1)] = n === 0 ? '' : n + ' / ' + WIDTH;
    }
    var next = g.next();
    for (i = 0; i < 3; i++) {
      box = cellsOf(next[i], 0);
      for (rr = 0; rr < 3; rr++) for (cc = 0; cc < 3; cc++) {
        cells['Wall!' + colName(WIDTH + 5 + cc) + (2 + 4 * i + rr)] = box.some(function (p) { return p[0] === rr && p[1] === cc; }) ? 'queued' : '';
      }
    }
    box = g.clipKind > 0 ? cellsOf(g.clipKind, 0) : [];
    for (rr = 0; rr < 3; rr++) for (cc = 0; cc < 3; cc++) {
      cells['Wall!' + colName(WIDTH + 5 + cc) + (15 + rr)] = box.some(function (p) { return p[0] === rr && p[1] === cc; }) ? 'queued' : '';
    }
    cells['Wall!' + colName(WIDTH + 9) + 2] = g.words();
    cells['Wall!' + colName(WIDTH + 9) + 3] = g.hint();
    cells['Wall!' + colName(WIDTH + 10) + 4] = g.level;
    for (i = 0; i < KINDS; i++) cells['Bag!I' + (i + 1)] = g.counts[i];
    var voices = g.voices();
    for (i = 0; i < 4; i++) { cells['Audio!B' + (i + 2)] = voices[i][0]; cells['Audio!C' + (i + 2)] = voices[i][1]; cells['Audio!D' + (i + 2)] = voices[i][2]; }
    return lit;
  };
  // The hand's own counts, the case's brickworkWholes and the rest: the frames held whole, the level, the bricks laid,
  // the games and the top-outs.
  BrickworkHand.prototype.counts = function () {
    var g = this.g, laid = 0;
    for (var k = 0; k < KINDS; k++) laid += g.tallyKinds[k];
    return { wholes: this.wholes, level: g.level, laid: laid, games: g.games, topouts: g.topouts };
  };
  hands.brickwork = BrickworkHand;
})(window.AlonzoHands = window.AlonzoHands || {});

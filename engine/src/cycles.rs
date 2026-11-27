//! Cycles by hand (`CART.17`; `docs/REARVIEW.md`, the item's scoping): the
//! game and its opponent written a second time, in Rust, the way a person
//! would write them, so that the cartridge's frames are held to a rule
//! written twice. The cartridge counts the room through a door by a wave, a
//! stamp less its steps spread a cell a layer through nine sheets, and one
//! formula over the last of them; this hand searches by a queue from the
//! door's cell and counts the cells within the wave's reach. The cartridge
//! keeps a turn in two cells of formulas; this hand keeps two numbers. The
//! two share no predicate. The engine's tests compile it as a module of the
//! crate for the tests alone, as they compile `brickwork.rs`.
//!
//! The game. Two cursors cross a sheet of 40 columns by 40 rows inside a
//! frame a cell wide, the player's from the left and the house's from the
//! right, a cell a step, a step every fifth frame. A cursor writes every
//! cell it enters with the round's step, the player's above 0 and the
//! house's below; a cursor that enters a written cell, the frame or data,
//! has closed a circle and loses the round, and both lose where both enter
//! one cell. An arrow's press is kept as the turn to come and a second
//! behind it; a press that names the way already kept, or the way back,
//! does nothing.
//!
//! The house. Its cursor has three doors, ahead, left and right, and each
//! is weighed by the sentences of the genre's guide: a written cell is the
//! end; keep a way ahead; keep a wall beside you; do not cut your own room
//! in two; leave the other's cell alone; take the door with the most room.
//! A door's points are its counts times the weights, a point more for
//! straight on, and its order its points and a whim of the dice. The house
//! takes the door of the greatest order, and its heading at a step is the
//! choice of the frame before, so that it reads nothing of the step it
//! chooses in.
//!
//! Its sight. The cartridge's wave spreads nine cells a frame, a cell a
//! layer, from the frame its stamp changes, a step's or a round's start, so
//! at any frame a wave has reached the cells within nine times the frames
//! since, and eight;
//! [`Game::reach`] is that number, and a door's room the cells within it and
//! within the sight that the door's search finds sooner than the player's.
//!
//! Two stand-ins, [`Reader`] and [`Wanderer`], watch the game by hand and
//! press as a person would; the engine's tests share them.
//!
//! The frames follow the cartridge's cells exactly, its first frame
//! included: [`Game::load`] is the grid as the load computes it, frame 0, and
//! the first step sets what the cartridge's first-frame cells set, every
//! other value computed from frame 0's as at any frame.

/// The sheet's columns and rows, its cells.
pub const WIDTH: usize = 40;
pub const HEIGHT: usize = 40;

/// The sheet with its frame: rows 1 to 42 and columns 1 to 42, as the Arena
/// numbers them.
pub const ROWS: usize = HEIGHT + 2;
pub const COLUMNS: usize = WIDTH + 2;

/// The frames a step, the frames of the countdown, and a wave's layers.
pub const FRAMES_A_STEP: u32 = 5;
pub const COUNTDOWN: u32 = 90;
pub const LAYERS: u32 = 9;

/// The level's row, the seventh of the scoping's ladder: the sight in steps,
/// what a cell of room weighs, a cell of the way ahead and the most of them
/// counted, a wall beside, a room cut in two, and straight on.
pub const SIGHT: u32 = 42;
pub const WEIGHT_ROOM: i64 = 10;
pub const WEIGHT_WAY: i64 = 3;
pub const WAY_COUNTED: i64 = 8;
pub const WEIGHT_WALL: i64 = 2;
pub const WEIGHT_SPLIT: i64 = 60;
pub const WEIGHT_AHEAD: i64 = 1;

/// A door that is not open, in the order the house chooses by.
pub const CLOSED: i64 = -1_000_000_000_000;

/// A cell of the frame, or a wall the Layout gives: the Arena's `#` on the
/// frame and its `wall` inside, two words for their two looks and one thing
/// to the rule.
pub const DATA: i32 = i32::MAX;

/// The headings: 0 up, 1 right, 2 down, 3 left.
pub const UP: i32 = 0;
pub const RIGHT: i32 = 1;
pub const DOWN: i32 = 2;
pub const LEFT: i32 = 3;

/// Park and Miller's modulus and multiplier.
const MODULUS: u64 = 2_147_483_647;
const MULTIPLIER: u64 = 16_807;

/// The rows a step moves, by its heading.
pub fn row_step(heading: i32) -> i32 {
    [-1, 0, 1, 0][heading.rem_euclid(4) as usize]
}

/// The columns a step moves, by its heading.
pub fn column_step(heading: i32) -> i32 {
    [0, 1, 0, -1][heading.rem_euclid(4) as usize]
}

/// A row held inside the sheet and its frame.
fn inside_rows(row: i32) -> usize {
    row.clamp(1, ROWS as i32) as usize
}

/// A column held inside the sheet and its frame.
fn inside_columns(column: i32) -> usize {
    column.clamp(1, COLUMNS as i32) as usize
}

/// The sheet with its frame, a cell at its row and column from 1: 0 empty,
/// [`DATA`] the frame or a wall, or the step that wrote it.
pub type Sheet = [[i32; COLUMNS + 1]; ROWS + 1];

/// The steps from a cell to every cell a search reaches, by row and column
/// from 1; a cell it does not reach holds [`FAR`].
pub type Steps = [[u16; COLUMNS + 1]; ROWS + 1];

/// A cell no search reached.
pub const FAR: u16 = u16::MAX;

/// A sheet empty inside its frame.
fn framed() -> Sheet {
    let mut sheet = [[0; COLUMNS + 1]; ROWS + 1];
    for (row, cells) in sheet.iter_mut().enumerate().skip(1) {
        for (column, cell) in cells.iter_mut().enumerate().skip(1) {
            if row == 1 || row == ROWS || column == 1 || column == COLUMNS {
                *cell = DATA;
            }
        }
    }
    sheet
}

/// The steps from a cell to every cell reached through the empty ones, the
/// cell itself 0 whatever it holds: a search by a queue, breadth first.
pub fn steps_from(sheet: &Sheet, from: (i32, i32)) -> Steps {
    let mut steps = [[FAR; COLUMNS + 1]; ROWS + 1];
    let start = (inside_rows(from.0), inside_columns(from.1));
    steps[start.0][start.1] = 0;
    let mut queue = std::collections::VecDeque::from([start]);
    while let Some((row, column)) = queue.pop_front() {
        let next = steps[row][column] + 1;
        for heading in 0..4 {
            let r = row as i32 + row_step(heading);
            let c = column as i32 + column_step(heading);
            if r < 2 || r > HEIGHT as i32 + 1 || c < 2 || c > WIDTH as i32 + 1 {
                continue;
            }
            let (r, c) = (r as usize, c as usize);
            if sheet[r][c] == 0 && steps[r][c] == FAR {
                steps[r][c] = next;
                queue.push_back((r, c));
            }
        }
    }
    steps
}

/// What the host writes before a frame: the arrows, Enter and Space held, and
/// the command run.
#[derive(Clone, Copy, Debug, Default)]
pub struct Keys {
    pub up: bool,
    pub right: bool,
    pub down: bool,
    pub left: bool,
    pub start: bool,
    pub select: bool,
    pub command: &'static str,
}

impl Keys {
    /// The arrow of a heading, pressed.
    pub fn arrow(heading: i32) -> Keys {
        Keys {
            up: heading == UP,
            right: heading == RIGHT,
            down: heading == DOWN,
            left: heading == LEFT,
            ..Keys::default()
        }
    }
}

/// The phases: before a round, the frames before its first step, the cursors
/// moving, and a circle closed.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum Phase {
    #[default]
    Waiting,
    Countdown,
    Running,
    Over,
}

impl Phase {
    /// The number the State holds.
    pub fn code(self) -> u32 {
        match self {
            Phase::Waiting => 0,
            Phase::Countdown => 1,
            Phase::Running => 2,
            Phase::Over => 3,
        }
    }
}

/// A door of the house's cursor, a row of the Mind: its heading and its
/// cell; whether it is open; the cells past it, beside it and at its
/// corners, each whether empty; each sentence's count; its points, its whim
/// and its order; and whether the house chose it.
#[derive(Clone, Copy, Debug, Default)]
pub struct Door {
    pub heading: i32,
    pub row: i32,
    pub column: i32,
    pub open: bool,
    pub past: [bool; 7],
    pub left: bool,
    pub right: bool,
    pub left_corner: bool,
    pub right_corner: bool,
    pub way: i64,
    pub wall: i64,
    pub split: bool,
    pub others: bool,
    pub room: i64,
    pub points: i64,
    pub whim: i64,
    pub order: i64,
    pub chosen: bool,
}

/// The game by hand: every cell of the State the cartridge computes, the
/// sheet, the Layout's data, the Mind's three rows and the Tally.
#[derive(Clone, Debug)]
pub struct Game {
    pub frame: u32,
    seed: u64,
    /// Whether the Mind's room is searched at every frame, as the cartridge
    /// computes it, or only where the house reads it, the frame before a
    /// step, which plays the same game in a fifth of the searches.
    pub every_frame: bool,
    // the keys as this frame held them
    pub begin_held: bool,
    held: [bool; 4],
    pub begin_key: bool,
    pub paused: bool,
    pub playing: bool,
    pub pressed_way: i32,
    pub aimed: i32,
    pub press_counts: bool,
    pub kept_now: i32,
    pub behind_now: i32,
    pub starts: bool,
    pub fresh: bool,
    pub step: bool,
    pub turn_kept: i32,
    pub turn_behind: i32,
    pub since_step: u32,
    pub phase: Phase,
    pub since_phase: u32,
    pub round: u32,
    pub round_step: i32,
    pub serial: i64,
    pub heading: i32,
    pub house_heading: i32,
    pub next: (i32, i32),
    pub house_next: (i32, i32),
    pub blocked: bool,
    pub house_blocked: bool,
    pub same_cell: bool,
    pub closes: bool,
    pub house_closes: bool,
    pub moves: bool,
    pub house_moves: bool,
    pub cursor: (i32, i32),
    pub house: (i32, i32),
    pub result: u32,
    pub circle: (i32, i32),
    pub dice: [u64; 3],
    pub sheet: Sheet,
    /// The Layout's cells a person filled, by the Arena's rows and columns.
    pub layout: [[bool; COLUMNS + 1]; ROWS + 1],
    pub doors: [Door; 3],
    pub choice_row: usize,
    pub choice: i32,
    /// The frame the waves' serial last moved at.
    stamp_frame: u32,
    /// The rounds begun, the player's, the house's, nobody's, and the steps.
    pub tally: [u32; 5],
    /// The steps at which a second turn stood behind the first.
    pub two_kept: u32,
}

impl Game {
    /// Where the player starts: a quarter of the way in from the left on the
    /// middle row.
    pub fn start() -> (i32, i32) {
        (2 + (HEIGHT / 2) as i32, 2 + (WIDTH / 4) as i32)
    }

    /// Where the house starts: the player's start under a half turn.
    pub fn house_start() -> (i32, i32) {
        (
            1 + (HEIGHT - HEIGHT / 2) as i32,
            1 + (WIDTH - WIDTH / 4) as i32,
        )
    }

    /// The grid as the load computes it, frame 0: every formula's cell empty,
    /// the frame's cells alone holding their data.
    pub fn load(seed: u64) -> Game {
        Game {
            frame: 0,
            seed,
            every_frame: true,
            begin_held: false,
            held: [false; 4],
            begin_key: false,
            paused: false,
            playing: false,
            pressed_way: 0,
            aimed: 0,
            press_counts: false,
            kept_now: 0,
            behind_now: 0,
            starts: false,
            fresh: false,
            step: false,
            turn_kept: 0,
            turn_behind: 0,
            since_step: 0,
            phase: Phase::Waiting,
            since_phase: 0,
            round: 0,
            round_step: 0,
            serial: 0,
            heading: 0,
            house_heading: 0,
            next: (0, 0),
            house_next: (0, 0),
            blocked: false,
            house_blocked: false,
            same_cell: false,
            closes: false,
            house_closes: false,
            moves: false,
            house_moves: false,
            cursor: (0, 0),
            house: (0, 0),
            result: 0,
            circle: (0, 0),
            dice: [0; 3],
            sheet: framed(),
            layout: [[false; COLUMNS + 1]; ROWS + 1],
            doors: [Door::default(); 3],
            choice_row: 0,
            choice: 0,
            stamp_frame: 0,
            tally: [0; 5],
            two_kept: 0,
        }
    }

    /// The stamp the waves hold: 64 times their serial.
    pub fn stamp(&self) -> i64 {
        self.serial * 64
    }

    /// Whether the round runs unpaused.
    pub fn go(&self) -> bool {
        !self.paused
    }

    /// How far a wave has spread at this frame, in steps from its source:
    /// a cell a layer, nine a frame from the frame its stamp changed, and
    /// eight, the last of its nine layers.
    pub fn reach(&self) -> u32 {
        LAYERS * (self.frame - self.stamp_frame) + LAYERS - 1
    }

    /// One frame: the keys read, the turn kept, a step where one is due, the
    /// sheet, and the Mind.
    pub fn step(&mut self, k: Keys) {
        let last = self.clone();
        self.frame += 1;
        let first = self.frame == 1;

        // the keys: Enter or Space, a rising edge; P, a command; each arrow, a rising edge
        self.begin_held = k.start || k.select;
        self.begin_key = self.begin_held && !last.begin_held;
        let counting = matches!(last.phase, Phase::Countdown | Phase::Running);
        self.paused = if first {
            false
        } else if k.command == "pause" && counting {
            !last.paused
        } else {
            last.paused
        };
        self.playing = self.go() && counting;
        self.held = [k.up, k.right, k.down, k.left];
        self.pressed_way = (0..4)
            .find(|&way| self.held[way] && !last.held[way])
            .map_or(-1, |way| way as i32);

        // the turns kept
        self.aimed = if last.turn_kept >= 0 {
            last.turn_kept
        } else {
            last.heading
        };
        self.press_counts = self.playing
            && self.pressed_way >= 0
            && self.pressed_way != self.aimed
            && self.pressed_way != (self.aimed + 2).rem_euclid(4);
        self.kept_now = if self.press_counts && last.turn_kept < 0 {
            self.pressed_way
        } else {
            last.turn_kept
        };
        self.behind_now = if self.press_counts && last.turn_kept >= 0 {
            self.pressed_way
        } else {
            last.turn_behind
        };

        // a round's start, the sheet laid afresh, and a step
        self.starts =
            !first && self.begin_key && matches!(last.phase, Phase::Waiting | Phase::Over);
        self.fresh = first || self.starts;
        self.step =
            self.go() && last.phase == Phase::Running && last.since_step + 1 >= FRAMES_A_STEP;
        self.two_kept += u32::from(self.step && self.kept_now >= 0 && self.behind_now >= 0);
        self.turn_kept = if self.fresh {
            -1
        } else if self.step {
            self.behind_now
        } else {
            self.kept_now
        };
        self.turn_behind = if self.fresh || self.step {
            -1
        } else {
            self.behind_now
        };
        self.since_step = if self.fresh || self.step {
            0
        } else if self.go() && last.phase == Phase::Running {
            last.since_step + 1
        } else {
            last.since_step
        };

        // the headings: the player's the turn kept, the house's the Mind's choice of the frame before
        self.heading = if self.fresh {
            RIGHT
        } else if self.step && self.kept_now >= 0 {
            self.kept_now
        } else {
            last.heading
        };
        self.house_heading = if self.fresh {
            LEFT
        } else if self.step {
            last.choice
        } else {
            last.house_heading
        };

        // the cell ahead of each cursor, read as the frame began
        self.next = (
            inside_rows(last.cursor.0 + row_step(self.heading)) as i32,
            inside_columns(last.cursor.1 + column_step(self.heading)) as i32,
        );
        self.house_next = (
            inside_rows(last.house.0 + row_step(self.house_heading)) as i32,
            inside_columns(last.house.1 + column_step(self.house_heading)) as i32,
        );
        self.blocked = last.sheet[self.next.0 as usize][self.next.1 as usize] != 0;
        self.house_blocked =
            last.sheet[self.house_next.0 as usize][self.house_next.1 as usize] != 0;
        self.same_cell = self.next == self.house_next;
        self.closes = self.step && (self.blocked || self.same_cell);
        self.house_closes = self.step && (self.house_blocked || self.same_cell);
        self.moves = self.step && !self.closes;
        self.house_moves = self.step && !self.house_closes;

        // the phase, the round and its step, and the waves' serial
        let circle = self.closes || self.house_closes;
        self.phase = if first {
            Phase::Waiting
        } else if self.starts {
            Phase::Countdown
        } else if circle {
            Phase::Over
        } else if self.go() && last.phase == Phase::Countdown && last.since_phase + 1 >= COUNTDOWN {
            Phase::Running
        } else {
            last.phase
        };
        self.since_phase = if first || self.phase != last.phase {
            0
        } else if self.go() {
            last.since_phase + 1
        } else {
            last.since_phase
        };
        self.round = last.round + u32::from(self.starts);
        self.round_step = if self.fresh {
            1
        } else if self.step {
            last.round_step + 1
        } else {
            last.round_step
        };
        self.serial = if first {
            1
        } else if self.starts || self.step {
            last.serial + 1
        } else {
            last.serial
        };
        if self.serial != last.serial {
            self.stamp_frame = self.frame;
        }

        // where each cursor stands, and a round's result
        self.cursor = if self.fresh {
            Game::start()
        } else if self.moves {
            self.next
        } else {
            last.cursor
        };
        self.house = if self.fresh {
            Game::house_start()
        } else if self.house_moves {
            self.house_next
        } else {
            last.house
        };
        if self.fresh {
            self.result = 0;
            self.circle = (0, 0);
        } else if circle {
            self.result = u32::from(self.closes) + 2 * u32::from(self.house_closes);
            self.circle = if self.closes {
                self.next
            } else {
                self.house_next
            };
        }

        // the dice: three at the first frame and at every step
        if first {
            self.dice[0] = self.seed * MULTIPLIER % MODULUS;
        } else if self.step {
            self.dice[0] = last.dice[2] * MULTIPLIER % MODULUS;
        }
        if first || self.step {
            self.dice[1] = self.dice[0] * MULTIPLIER % MODULUS;
            self.dice[2] = self.dice[1] * MULTIPLIER % MODULUS;
        }

        // the sheet: laid afresh, or a cursor's step written into an empty cell
        for row in 2..=HEIGHT + 1 {
            for column in 2..=WIDTH + 1 {
                let here = (row as i32, column as i32);
                self.sheet[row][column] = if self.fresh {
                    if here == Game::start() {
                        1
                    } else if here == Game::house_start() {
                        -1
                    } else if self.layout[row][column] {
                        DATA
                    } else {
                        0
                    }
                } else if last.sheet[row][column] != 0 {
                    last.sheet[row][column]
                } else if self.moves && here == self.next {
                    self.round_step
                } else if self.house_moves && here == self.house_next {
                    -self.round_step
                } else {
                    0
                };
            }
        }

        // the Tally
        self.tally[0] += u32::from(self.starts);
        self.tally[1] += u32::from(self.house_closes && !self.closes);
        self.tally[2] += u32::from(self.closes && !self.house_closes);
        self.tally[3] += u32::from(self.closes && self.house_closes);
        self.tally[4] += u32::from(self.step);

        self.mind();
    }

    /// Whether a cell of the sheet is empty, its row and column held inside
    /// the frame.
    fn empty_at(&self, row: i32, column: i32) -> bool {
        self.sheet[inside_rows(row)][inside_columns(column)] == 0
    }

    /// Whether the house reads this frame's room: the frame before a step.
    fn decisive(&self) -> bool {
        self.phase == Phase::Running && self.since_step + 1 >= FRAMES_A_STEP
    }

    /// The Mind: each door's row, and the choice.
    fn mind(&mut self) {
        let search = self.every_frame || self.decisive();
        let reach = self.reach();
        let yours = if search {
            Some(steps_from(&self.sheet, self.cursor))
        } else {
            None
        };
        let headings = [
            self.house_heading,
            (self.house_heading + 3).rem_euclid(4),
            (self.house_heading + 1).rem_euclid(4),
        ];
        for (place, heading) in headings.into_iter().enumerate() {
            let (dr, dc) = (row_step(heading), column_step(heading));
            let (left, right) = ((heading + 3).rem_euclid(4), (heading + 1).rem_euclid(4));
            let (row, column) = (self.house.0 + dr, self.house.1 + dc);
            let open = self.empty_at(row, column);
            let mut past = [false; 7];
            let mut clear = open;
            for (index, cell) in past.iter_mut().enumerate() {
                let steps = index as i32 + 1;
                clear = clear && self.empty_at(row + steps * dr, column + steps * dc);
                *cell = clear;
            }
            let beside = |side: i32, forward: i32| {
                self.empty_at(
                    row + row_step(side) + forward * dr,
                    column + column_step(side) + forward * dc,
                )
            };
            let (to_left, to_right) = (beside(left, 0), beside(right, 0));
            let (left_corner, right_corner) = (beside(left, 1), beside(right, 1));
            let ways = i64::from(past[0]) + i64::from(to_left) + i64::from(to_right);
            let joined = i64::from(past[0] && to_left && left_corner)
                + i64::from(past[0] && to_right && right_corner);
            let way = if open {
                1 + past.iter().filter(|&&cell| cell).count() as i64
            } else {
                0
            };
            let wall = if open { 3 - ways } else { 0 };
            let split = open && ways - joined >= 2;
            let others = open && (row - self.cursor.0).abs() + (column - self.cursor.1).abs() == 1;
            let room = match (&yours, open) {
                (Some(yours), true) => self.room(row, column, yours, reach),
                (Some(_), false) => 0,
                (None, _) => self.doors[place].room,
            };
            let points =
                room * WEIGHT_ROOM + way.min(WAY_COUNTED) * WEIGHT_WAY + wall * WEIGHT_WALL
                    - i64::from(split) * WEIGHT_SPLIT
                    + if place == 0 { WEIGHT_AHEAD } else { 0 };
            let whim = (self.dice[place] % 500) as i64;
            let order = if open {
                (points - 1_000_000 * i64::from(others)) * 1000 + whim
            } else {
                CLOSED
            };
            self.doors[place] = Door {
                heading,
                row,
                column,
                open,
                past,
                left: to_left,
                right: to_right,
                left_corner,
                right_corner,
                way,
                wall,
                split,
                others,
                room,
                points,
                whim,
                order,
                chosen: false,
            };
        }
        let best = self
            .doors
            .iter()
            .map(|door| door.order)
            .max()
            .unwrap_or(CLOSED);
        let place = self
            .doors
            .iter()
            .position(|door| door.order == best)
            .unwrap_or(0);
        self.choice_row = place + 1;
        self.choice = self.doors[place].heading;
        self.doors[place].chosen = true;
    }

    /// The room through a door: the cells its search reaches within the
    /// sight and within the wave's reach, sooner than the player's search
    /// does, the door's own cell among them.
    fn room(&self, row: i32, column: i32, yours: &Steps, reach: u32) -> i64 {
        let door = steps_from(&self.sheet, (row, column));
        let within = reach.min(SIGHT);
        let mut room = 0;
        for r in 2..=HEIGHT + 1 {
            for c in 2..=WIDTH + 1 {
                let mine = u32::from(door[r][c]);
                let theirs = u32::from(yours[r][c]);
                if mine <= within && !(theirs <= reach && theirs <= mine) {
                    room += 1;
                }
            }
        }
        room
    }

    /// The words the Arena shows beside the sheet.
    pub fn words(&self) -> String {
        let at = format!("{}{}", letters(self.circle.1), self.circle.0);
        match (self.phase, self.paused, self.result) {
            (Phase::Waiting, _, _) => "Enter or Space begins a round.".to_string(),
            (_, true, _) => "Paused: P resumes.".to_string(),
            (Phase::Countdown, _, _) => "Ready.".to_string(),
            (_, _, 1) => format!("You closed a circle at {at}."),
            (_, _, 2) => format!("The house closed a circle at {at}."),
            (_, _, 3) => format!("Both closed a circle at {at}."),
            _ => String::new(),
        }
    }

    /// Whose round it was, under the words.
    pub fn verdict(&self) -> &'static str {
        match self.result {
            1 => "The round is the house's.",
            2 => "The round is yours.",
            3 => "The round is nobody's.",
            _ => "",
        }
    }

    /// The hint under the words.
    pub fn hint(&self) -> &'static str {
        if self.phase == Phase::Over {
            "Enter or Space begins the next round."
        } else {
            ""
        }
    }

    /// The rules lit at a cell of the sheet, as the Arena's five are
    /// numbered: the player's series, the house's, the player's cursor, the
    /// house's, and a series' number shown at a round's end.
    pub fn lit(&self, row: usize, column: usize) -> Vec<u32> {
        let value = self.sheet[row][column];
        let number = value != DATA;
        let here = (row as i32, column as i32);
        let mut lit = Vec::new();
        if number && value > 0 {
            lit.push(1);
        }
        if number && value < 0 {
            lit.push(2);
        }
        if here == self.cursor {
            lit.push(3);
        }
        if here == self.house {
            lit.push(4);
        }
        if self.phase == Phase::Over && number && value != 0 {
            lit.push(5);
        }
        lit
    }
}

/// A column's letters, as a spreadsheet writes them: 1 is A, 27 AA.
pub fn letters(column: i32) -> String {
    let mut text = String::new();
    let mut n = column;
    while n > 0 {
        let digit = ((n - 1) % 26) as u8;
        text.insert(0, char::from(b'A' + digit));
        n = (n - 1) / 26;
    }
    text
}

/// A small generator of the stand-ins' own, apart from the game's dice.
#[derive(Clone, Debug)]
struct Lot(u64);

impl Lot {
    fn next(&mut self) -> u64 {
        self.0 = self.0 * MULTIPLIER % MODULUS;
        self.0
    }

    /// One time in a number.
    fn one_in(&mut self, n: u64) -> bool {
        self.next() % n == 0
    }
}

/// A stand-in that reads room, the scoping's sharp player at once: at the
/// frame after a step it counts, for each way it may head, the cells it
/// reaches before the house less the cells the house reaches first, and
/// presses the arrow of the best. It keeps off a cell the house may enter
/// at the same step, wanders now and then, and begins the next round a
/// while after a round ends. With its quirks on it also presses as a person
/// fumbles: the way back, the way it already heads, a second turn behind
/// the first, and P.
#[derive(Clone, Debug)]
pub struct Reader {
    lot: Lot,
    /// Whether it fumbles and pauses, for the session, or plays plainly.
    pub quirks: bool,
    /// One step in this many is a way drawn by lot.
    pub wanders: u64,
    /// The frames it lets a round's end stand before it begins the next.
    pub rests: u32,
    second: Option<(u32, i32)>,
    resume_at: Option<u32>,
}

impl Reader {
    pub fn new(seed: u64) -> Reader {
        Reader {
            lot: Lot(seed.max(1)),
            quirks: false,
            wanders: 50,
            rests: 12,
            second: None,
            resume_at: None,
        }
    }

    /// The cells a cursor would reach before the house, less the cells the
    /// house reaches first, after a step into a cell.
    fn worth(g: &Game, into: (i32, i32)) -> i64 {
        let mut sheet = g.sheet;
        sheet[into.0 as usize][into.1 as usize] = 1;
        let mine = steps_from(&sheet, into);
        let theirs = steps_from(&sheet, g.house);
        let mut worth = 0;
        for r in 2..=HEIGHT + 1 {
            for c in 2..=WIDTH + 1 {
                if sheet[r][c] != 0 {
                    continue;
                }
                if mine[r][c] < theirs[r][c] {
                    worth += 1;
                } else if theirs[r][c] < mine[r][c] {
                    worth -= 1;
                }
            }
        }
        worth
    }

    /// The way it would head at the next step: the best of straight on and
    /// the two turns, a written cell never taken while another is open.
    fn wants(&mut self, g: &Game) -> i32 {
        let ways = [g.heading, (g.heading + 1) % 4, (g.heading + 3) % 4];
        let open: Vec<i32> = ways
            .into_iter()
            .filter(|&way| g.empty_at(g.cursor.0 + row_step(way), g.cursor.1 + column_step(way)))
            .collect();
        if open.is_empty() {
            return g.heading;
        }
        if self.lot.one_in(self.wanders) {
            return open[(self.lot.next() % open.len() as u64) as usize];
        }
        let mut best = (i64::MIN, g.heading);
        for way in open {
            let into = (g.cursor.0 + row_step(way), g.cursor.1 + column_step(way));
            let beside = (into.0 - g.house.0).abs() + (into.1 - g.house.1).abs() == 1;
            let worth = Reader::worth(g, into) * 4 + i64::from(way == g.heading)
                - if beside { 100_000 } else { 0 };
            if worth > best.0 {
                best = (worth, way);
            }
        }
        best.1
    }

    /// The keys for the frame after the one the game by hand last computed.
    pub fn decide(&mut self, g: &Game) -> Keys {
        if let Some(at) = self.resume_at {
            if g.frame + 1 >= at {
                self.resume_at = None;
                return Keys {
                    command: "pause",
                    ..Keys::default()
                };
            }
            return Keys::default();
        }
        match g.phase {
            Phase::Waiting | Phase::Over => {
                self.second = None;
                if g.since_phase >= self.rests && !g.begin_held {
                    return Keys {
                        start: g.round % 2 == 0,
                        select: g.round % 2 == 1,
                        ..Keys::default()
                    };
                }
                Keys::default()
            }
            Phase::Countdown => Keys::default(),
            Phase::Running => {
                if self.quirks && g.since_step == 1 && self.lot.one_in(90) {
                    self.resume_at = Some(g.frame + 1 + 14);
                    return Keys {
                        command: "pause",
                        ..Keys::default()
                    };
                }
                if let Some((at, way)) = self.second {
                    if g.since_step == at {
                        self.second = None;
                        return Keys::arrow(way);
                    }
                }
                if g.since_step != 0 {
                    return Keys::default();
                }
                let want = self.wants(g);
                if self.quirks && self.lot.one_in(12) {
                    // a fumble: the way back, or the way already headed
                    let way = if self.lot.one_in(2) {
                        (g.heading + 2) % 4
                    } else {
                        g.heading
                    };
                    return Keys::arrow(way);
                }
                if want == g.heading {
                    return Keys::default();
                }
                if self.quirks && self.lot.one_in(6) {
                    // a tight turn: the way wanted, and the way back of the heading behind it
                    self.second = Some((2, (g.heading + 2) % 4));
                }
                Keys::arrow(want)
            }
        }
    }
}

/// A stand-in that reads nothing: it heads on until the cell ahead is
/// written, then takes the turn with the longer way, and now and then turns
/// for no reason. The scoping's casual player was no better.
#[derive(Clone, Debug)]
pub struct Wanderer {
    lot: Lot,
}

impl Wanderer {
    pub fn new(seed: u64) -> Wanderer {
        Wanderer {
            lot: Lot(seed.max(1)),
        }
    }

    /// The empty cells straight on from a cell, one way.
    fn way(g: &Game, from: (i32, i32), heading: i32) -> i32 {
        let mut n = 0;
        while g.empty_at(
            from.0 + (n + 1) * row_step(heading),
            from.1 + (n + 1) * column_step(heading),
        ) {
            n += 1;
        }
        n
    }

    /// The keys for the frame after the one the game by hand last computed.
    pub fn decide(&mut self, g: &Game) -> Keys {
        match g.phase {
            Phase::Waiting | Phase::Over => Keys {
                start: g.since_phase >= 12 && !g.begin_held,
                ..Keys::default()
            },
            Phase::Countdown => Keys::default(),
            Phase::Running => {
                if g.since_step != 0 {
                    return Keys::default();
                }
                let ahead = Wanderer::way(g, g.cursor, g.heading);
                if ahead > 0 && !self.lot.one_in(25) {
                    return Keys::default();
                }
                let (left, right) = ((g.heading + 3) % 4, (g.heading + 1) % 4);
                let turn = if Wanderer::way(g, g.cursor, left) > Wanderer::way(g, g.cursor, right) {
                    left
                } else {
                    right
                };
                Keys::arrow(turn)
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// A game begun: Enter at the second frame, and the countdown run out.
    fn running() -> Game {
        let mut g = Game::load(7);
        g.step(Keys::default());
        g.step(Keys {
            start: true,
            ..Keys::default()
        });
        while g.phase != Phase::Running {
            g.step(Keys::default());
        }
        g
    }

    /// One step's frames, an arrow pressed at the first of them.
    fn a_step(g: &mut Game, way: Option<i32>) {
        g.step(way.map_or_else(Keys::default, Keys::arrow));
        while !g.step {
            g.step(Keys::default());
        }
    }

    #[test]
    fn a_round_begins_after_its_countdown_and_steps_every_fifth_frame() {
        let mut g = Game::load(7);
        g.step(Keys::default());
        assert_eq!(
            (g.phase, g.cursor, g.house),
            (Phase::Waiting, (22, 12), (21, 31))
        );
        g.step(Keys {
            start: true,
            ..Keys::default()
        });
        assert!(g.starts && g.phase == Phase::Countdown);
        for _ in 0..COUNTDOWN {
            assert_eq!(g.phase, Phase::Countdown);
            g.step(Keys::default());
        }
        assert_eq!(g.phase, Phase::Running);
        let begun = g.frame;
        while !g.step {
            g.step(Keys::default());
        }
        assert_eq!(g.frame - begun, FRAMES_A_STEP);
        assert_eq!(g.cursor, (22, 13), "a cell to the right");
        assert_eq!(
            g.sheet[22][13], 2,
            "the round's second step, the start its first"
        );
        assert_eq!(g.sheet[g.house.0 as usize][g.house.1 as usize], -2);
    }

    #[test]
    fn a_press_against_the_heading_and_one_along_it_do_nothing() {
        let mut g = running();
        g.step(Keys::arrow(LEFT));
        assert!(!g.press_counts && g.turn_kept == -1, "the way back");
        g.step(Keys::arrow(RIGHT));
        assert!(
            !g.press_counts && g.turn_kept == -1,
            "the way already headed"
        );
        g.step(Keys::arrow(UP));
        assert!(g.press_counts && g.turn_kept == UP);
        g.step(Keys::arrow(DOWN));
        assert!(!g.press_counts, "the way back of the turn kept");
        assert_eq!((g.turn_kept, g.turn_behind), (UP, -1));
    }

    #[test]
    fn two_presses_are_kept_and_a_third_takes_the_place_behind() {
        let mut g = running();
        g.step(Keys::arrow(UP));
        g.step(Keys::arrow(LEFT));
        assert_eq!(
            (g.turn_kept, g.turn_behind),
            (UP, LEFT),
            "a tight turn kept whole"
        );
        g.step(Keys::arrow(RIGHT));
        assert_eq!(
            (g.turn_kept, g.turn_behind),
            (UP, RIGHT),
            "the last press behind"
        );
        while !g.step {
            g.step(Keys::default());
        }
        assert_eq!(g.heading, UP);
        assert_eq!((g.turn_kept, g.turn_behind), (RIGHT, -1));
        a_step(&mut g, None);
        assert_eq!(g.heading, RIGHT);
    }

    #[test]
    fn a_cursor_into_its_own_series_closes_a_circle() {
        let mut g = running();
        a_step(&mut g, None);
        a_step(&mut g, Some(UP));
        a_step(&mut g, Some(LEFT));
        assert_eq!(g.phase, Phase::Running);
        a_step(&mut g, Some(DOWN));
        assert!(g.closes && !g.house_closes && g.result == 1);
        assert_eq!(g.phase, Phase::Over);
        assert_eq!(g.words(), "You closed a circle at L22.");
        assert_eq!(g.tally, [1, 0, 1, 0, g.tally[4]]);
    }

    #[test]
    fn a_wave_reaches_a_cell_a_layer_from_the_frame_its_stamp_changes() {
        let mut g = running();
        while !g.step {
            g.step(Keys::default());
        }
        assert_eq!(
            g.reach(),
            8,
            "the last of nine layers, at the stamp's own frame"
        );
        g.step(Keys::default());
        assert_eq!(g.reach(), 17);
        while g.since_step + 1 < FRAMES_A_STEP {
            g.step(Keys::default());
        }
        assert_eq!(g.reach(), 44, "the frame before the next step");
        assert!(
            g.reach() >= SIGHT,
            "the sight is inside what a step's frames reach"
        );
    }

    #[test]
    fn the_room_searched_at_the_decisive_frame_alone_plays_the_same_game() {
        let play = |every_frame: bool| {
            let mut g = Game::load(99);
            g.every_frame = every_frame;
            let mut reader = Reader::new(5);
            for _ in 0..1500 {
                let keys = reader.decide(&g);
                g.step(keys);
            }
            (g.sheet, g.tally, g.cursor, g.house)
        };
        assert_eq!(play(true), play(false));
    }

    /// The house as an opponent: sixty rounds against each stand-in, the
    /// rounds each took printed, with floors far under what the scoping's
    /// probe measured, so that the house stays one.
    #[test]
    fn the_house_is_an_opponent() {
        let mut g = Game::load(2026);
        g.every_frame = false;
        let mut reader = Reader::new(11);
        reader.rests = 0;
        while g.tally[0] <= 60 {
            let keys = reader.decide(&g);
            g.step(keys);
        }
        let against_reader = g.tally;
        let mut g = Game::load(2026);
        g.every_frame = false;
        let mut wanderer = Wanderer::new(11);
        while g.tally[0] <= 60 {
            let keys = wanderer.decide(&g);
            g.step(keys);
        }
        eprintln!(
            "the house, sixty rounds: against the reader of room {} to {} and {} nobody's; against the wanderer {} to {} and {} nobody's",
            against_reader[2], against_reader[1], against_reader[3], g.tally[2], g.tally[1], g.tally[3]
        );
        assert!(
            against_reader[2] >= 15,
            "the house takes rounds from a reader of room: {against_reader:?}"
        );
        assert!(g.tally[2] >= 45, "and most from a wanderer: {:?}", g.tally);
    }
}

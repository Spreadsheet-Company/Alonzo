//! Brickwork by hand (`CART.3`; `docs/REARVIEW.md`, the item's scoping): the
//! game's rule written a second time, in Rust, the way a person would write
//! it, so that the cartridge's frames are held to a rule written twice. The
//! cartridge keeps a course as one number and tests a brick against the wall
//! with `BITAND`; this hand keeps the wall as a grid of cells and tests a
//! brick cell by cell. The cartridge reads each brick's turns from the
//! pictures on its Bricks sheet; this hand turns each brick's first picture
//! in its box. The two share no predicate. The engine's tests compile it as a
//! module of the crate for the tests alone, as they compile `kairos.rs`.
//!
//! The game. Nine bricks of one to eight cells fall into a wall of 14
//! columns by 24 courses, dealt from a bag that holds each as many times as
//! the Pace sheet counts it, none to four, its order the ranks of thirty-six
//! of Park and Miller's dice, a slot past the bag's size ranking last; a
//! count typed at any frame deals the bag again, and a setting typed is held
//! inside its bounds, so that nothing typed on the Pace stops the wall. A brick is
//! its kind, its turn and its box's place, the box's top course and left
//! column, from 1. Each frame it turns (in place, then a column right, a
//! column left, a course up, the first that fits), moves a column, and falls
//! a course when the pace's frames have passed, in that order, each from
//! where the last left it. It is laid at a lay key where it would land, or
//! after resting the lay's delay where it rests, the rest's count restarted
//! only by a fall. The full courses are cleared after the beat, each a level,
//! the score, and each quickens the pace by a share. A game ends when the
//! next brick has no room at the top center. And since the second slice, the
//! page's version 7, the commands on Ctrl: a slide to the edge of the brick's
//! region, the brick moved to its landing course not laid, and the cut, the
//! falling brick to the Clipboard and the Clipboard's, or the deal's next, in
//! its place, once a brick, refused where the brick it brings has no room.
//!
//! The frames follow the cartridge's cells exactly, its first frame
//! included: [`Game::load`] is the grid as the load computes it, frame 0, and
//! the first step sets what the cartridge's first-frame cells set, every
//! other value computed from frame 0's as at any frame.

pub const WIDTH: usize = 14;
pub const HEIGHT: usize = 24;
pub const KINDS: usize = 9;

/// A bag's slots at most, and each draw's dice: four of each brick.
pub const SLOTS: usize = 36;

/// The most of one brick a bag holds.
pub const MOST_OF_EACH: u32 = 4;

/// The most frames any setting counts, a minute's.
const A_MINUTE: f64 = 3600.0;

/// Each setting's row on the Pace sheet, from 1, with its lowest and highest
/// value, its default, and whether it counts frames, a whole number: the
/// frames a course as a game begins, the share each course cleared takes off
/// them, the fewest frames a course, the lay's delay, a held arrow's delay
/// and its period, the soft fall, the beat and the hold.
pub const SETTINGS: [(f64, f64, f64, bool); 9] = [
    (1.0, A_MINUTE, 60.0, false),
    (0.0, 1.0, 0.03, false),
    (1.0, A_MINUTE, 1.0, true),
    (0.0, A_MINUTE, 30.0, true),
    (0.0, A_MINUTE, 10.0, true),
    (1.0, A_MINUTE, 2.0, true),
    (1.0, A_MINUTE, 2.0, true),
    (2.0, A_MINUTE, 12.0, true),
    (0.0, A_MINUTE, 60.0, true),
];

/// The first row of the bag's counts on the Pace sheet, the header's.
pub const FIRST_COUNT_ROW: u32 = 12;

/// A setting as the game reads it: the number typed, a whole number where it
/// counts frames, held inside its bounds; or its default where the cell
/// holds no number.
pub fn held_setting(typed: Option<f64>, row: u32) -> f64 {
    let (lowest, highest, default, whole) = SETTINGS[(row - 1) as usize];
    match typed {
        Some(x) => {
            let x = if whole { x.floor() } else { x };
            x.min(highest).max(lowest)
        }
        None => default,
    }
}

/// A brick's count as the game reads it: the number typed, a whole number
/// from none to four; none where the cell holds no number.
pub fn held_count(typed: Option<f64>) -> u32 {
    match typed {
        Some(x) => x.floor().min(f64::from(MOST_OF_EACH)).max(0.0) as u32,
        None => 0,
    }
}

/// The counts a bag is dealt by: each brick once if none is counted, and a
/// bag of fewer than three twice or three times over, so that the next
/// three are always this bag's or the next's.
pub fn in_use(held: &[u32; KINDS]) -> [u32; KINDS] {
    let sum: u32 = held.iter().sum();
    if sum == 0 {
        [1; KINDS]
    } else {
        held.map(|n| n * ((sum + 2) / sum))
    }
}

/// The bricks, each its name and its first picture, a box of `size` cells a
/// side: `#` a cell of the brick. The cartridge's Bricks sheet draws the same
/// first turn and the three after it by hand.
pub const BRICKS: [(&str, usize, [&str; 3]); KINDS] = [
    ("header", 1, ["#", "", ""]),
    ("brick", 2, ["##", "", ""]),
    ("corner", 2, ["##", "#.", ""]),
    ("lintel", 3, ["...", "###", ""]),
    ("square", 2, ["##", "##", ""]),
    ("arch", 3, ["###", "#.#", ""]),
    ("block", 3, ["###", "###", ""]),
    ("horseshoe", 3, ["###", "#.#", "#.#"]),
    ("flue", 3, ["###", "#.#", "###"]),
];

/// A brick's cells in a turn, each (box row, box column) from 0: the first
/// picture turned clockwise in its box `turn` times, a cell at (r, c) going
/// to (c, size - 1 - r).
pub fn cells(kind: usize, turn: usize) -> Vec<(i32, i32)> {
    let (_, size, rows) = BRICKS[kind - 1];
    let mut out: Vec<(i32, i32)> = Vec::new();
    for (r, row) in rows.iter().enumerate() {
        for (c, ch) in row.chars().enumerate() {
            if ch == '#' {
                out.push((r as i32, c as i32));
            }
        }
    }
    for _ in 0..turn % 4 {
        out = out
            .into_iter()
            .map(|(r, c)| (c, size as i32 - 1 - r))
            .collect();
    }
    out.sort_unstable();
    out
}

/// The pace and the settings as the game reads them from the Pace sheet: the
/// frames a course as a game begins, the share each course cleared takes off
/// them, the fewest frames a course, the counts of the lay, the held arrows,
/// the soft fall, the beat and the hold after a top-out, and each brick's
/// count in a bag, each held inside its bounds.
#[derive(Clone, Copy, Debug)]
pub struct Settings {
    pub start_pace: f64,
    pub quickening: f64,
    pub fastest: u32,
    pub lay_delay: u32,
    pub repeat_delay: u32,
    pub repeat_period: u32,
    pub soft_fall: u32,
    pub beat: u32,
    pub hold: u32,
    pub bag: [u32; KINDS],
}

impl Default for Settings {
    fn default() -> Settings {
        let mut s = Settings {
            start_pace: 0.0,
            quickening: 0.0,
            fastest: 0,
            lay_delay: 0,
            repeat_delay: 0,
            repeat_period: 0,
            soft_fall: 0,
            beat: 0,
            hold: 0,
            bag: [2, 2, 2, 2, 1, 1, 1, 1, 1],
        };
        for row in 1..=SETTINGS.len() as u32 {
            s.type_into(row, None);
        }
        s
    }
}

impl Settings {
    /// What a person types into a row of the Pace sheet, a number or none,
    /// as the game reads it: a setting in rows 1 to 9, a brick's count in
    /// rows 12 to 20.
    pub fn type_into(&mut self, row: u32, typed: Option<f64>) {
        if (FIRST_COUNT_ROW..FIRST_COUNT_ROW + KINDS as u32).contains(&row) {
            self.bag[(row - FIRST_COUNT_ROW) as usize] = held_count(typed);
            return;
        }
        let v = held_setting(typed, row);
        let frames = v as u32;
        match row {
            1 => self.start_pace = v,
            2 => self.quickening = v,
            3 => self.fastest = frames,
            4 => self.lay_delay = frames,
            5 => self.repeat_delay = frames,
            6 => self.repeat_period = frames,
            7 => self.soft_fall = frames,
            8 => self.beat = frames,
            9 => self.hold = frames,
            _ => panic!("no setting at the Pace's row {row}"),
        }
    }
}

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum Phase {
    Waiting,
    Falling,
    Beat,
    Over,
}

impl Phase {
    pub fn code(self) -> u32 {
        match self {
            Phase::Waiting => 0,
            Phase::Falling => 1,
            Phase::Beat => 2,
            Phase::Over => 3,
        }
    }
}

/// What a person holds this frame, and the command run, by its name, or the
/// empty name: `pause`, `slide-left`, `slide-right`, `to-the-bottom` or `cut`.
#[derive(Clone, Copy, Default, Debug)]
pub struct Keys {
    pub up: bool,
    pub down: bool,
    pub left: bool,
    pub right: bool,
    pub a: bool,
    pub b: bool,
    pub start: bool,
    pub select: bool,
    pub command: &'static str,
}

/// A brick's place: its kind, its turn, and its box's top course and left
/// column, from 1.
#[derive(Clone, Copy, PartialEq, Eq, Debug, Default)]
pub struct Place {
    pub course: i32,
    pub column: i32,
    pub turn: usize,
}

/// A voice as the Audio sheet holds it: its wave, note and volume.
#[derive(Clone, Copy, PartialEq, Debug)]
pub struct Voice {
    pub wave: &'static str,
    pub note: f64,
    pub volume: f64,
}

const MODULUS: u64 = 2_147_483_647;

/// Seventy-two of Park and Miller's dice after a base, each the next after
/// the one before: thirty-six for this bag, thirty-six for the next.
fn dice(base: u64) -> [u64; 2 * SLOTS] {
    let mut out = [0u64; 2 * SLOTS];
    let mut x = base;
    for d in out.iter_mut() {
        x = x * 16807 % MODULUS;
        *d = x;
    }
    out
}

/// A bag's size: the counts in use summed, three to thirty-six.
fn size_of(counts: &[u32; KINDS]) -> u32 {
    counts.iter().sum()
}

/// A bag from thirty-six dice and the counts in use: each slot a brick, the
/// header's first and each as many as its count; a slot past the bag's size
/// takes a die larger than any; and the kind at each place the brick of the
/// slot whose die ranks there, from the smallest; 0 at a place past the
/// bag's size.
fn order(dice: &[u64], counts: &[u32; KINDS], first_row: u64) -> [usize; SLOTS] {
    let n = size_of(counts) as usize;
    let slot_kind = |slot: usize| -> usize {
        let mut sum = 0u32;
        let mut below = 0usize;
        for &c in counts.iter() {
            sum += c;
            if (sum as usize) < slot {
                below += 1;
            }
        }
        below + 1
    };
    let key = |slot: usize| -> u64 {
        if slot <= n {
            dice[slot - 1]
        } else {
            3_000_000_000 + first_row + slot as u64 - 1
        }
    };
    let mut slots: Vec<usize> = (1..=SLOTS).collect();
    slots.sort_by_key(|&s| key(s));
    let mut out = [0usize; SLOTS];
    for (place, &slot) in slots.iter().enumerate() {
        if place < n {
            out[place] = slot_kind(slot);
        }
    }
    out
}

/// The kind at a place of a game's deal: counted from the deal's start, this
/// bag holds its number's size of the places and the next bag those after.
fn kind_at(
    place: u32,
    start: u32,
    size: u32,
    this: &[usize; SLOTS],
    next: &[usize; SLOTS],
    number: u32,
) -> usize {
    let q = place - start - 1;
    let i = (q % size) as usize;
    if q / size == number {
        this[i]
    } else {
        next[i]
    }
}

#[derive(Clone, Debug)]
pub struct Game {
    pub settings: Settings,
    pub seed: u64,
    pub frame: u32,
    pub phase: Phase,
    pub since: u32,
    pub paused: bool,
    /// The laid wall, a cell its brick's serial, empty 0.
    pub wall: [[i32; WIDTH]; HEIGHT],
    pub kind: usize,
    pub brick: Place,
    pub dealt: u32,
    /// The counts in use as the frame leaves them.
    pub counts: [u32; KINDS],
    /// Whether the counts changed this frame, and whether the bags were
    /// dealt afresh, at a count changed or a top-out.
    pub recount: bool,
    pub redeal: bool,
    /// The bricks of the game dealt before its bags were last dealt afresh.
    pub deal_start: u32,
    pub bag_number: u32,
    pub this_bag: [usize; SLOTS],
    pub next_bag: [usize; SLOTS],
    pub generator: u64,
    pub since_fall: u32,
    pub resting_for: u32,
    /// The courses this game has cleared: the level, and the score.
    pub level: u32,
    /// The frames a course, kept as a product, a share taken off it for
    /// each course cleared.
    pub pace: f64,
    pub clearing: bool,
    pub laid_courses: u32,
    /// The beat's length as its lay began it.
    pub beat_now: u32,
    pub since_lay: u32,
    held_turn: bool,
    held_a: bool,
    held_lay: bool,
    pub held_left: u32,
    pub held_right: u32,
    // what this frame did, as the State's cells say it
    pub placed: Place,
    pub landing: i32,
    pub resting: bool,
    pub lay: bool,
    pub turned: bool,
    pub kicked: bool,
    pub moved: bool,
    pub fell: bool,
    pub starts: bool,
    pub topout: bool,
    pub entered: bool,
    pub full_count: u32,
    pub period: u32,
    pub tally_kinds: [u32; KINDS],
    pub tally_at_once: [u32; 4],
    pub games: u32,
    pub topouts: u32,
    /// The second slice's: a cut this frame, a cut refused, the Clipboard's
    /// kind (0 none), whether this brick was cut, the frames since a cut was
    /// refused, a slide that moved the brick, the brick moved to the bottom,
    /// and every brick that entered this game, each brick's serial.
    pub cut: bool,
    pub cut_refused: bool,
    pub clip_kind: usize,
    pub cut_used: bool,
    pub refused_since: u32,
    pub slid: bool,
    pub dropped: bool,
    pub serial: u32,
    pub tally_slides: u32,
    pub tally_dropped: u32,
    pub tally_cuts: u32,
}

impl Game {
    /// Frame 0: the grid as the load computes it, every count 0, the pace
    /// 0, the phase waiting, the bags empty until the first frame deals
    /// them, and the counts in use read from the Pace, against none before
    /// them.
    pub fn load(settings: Settings, seed: u64) -> Game {
        Game {
            settings,
            seed,
            frame: 0,
            phase: Phase::Waiting,
            since: 0,
            paused: false,
            wall: [[0; WIDTH]; HEIGHT],
            kind: 0,
            brick: Place::default(),
            dealt: 0,
            counts: in_use(&settings.bag),
            recount: true,
            redeal: true,
            deal_start: 0,
            bag_number: 0,
            this_bag: [0; SLOTS],
            next_bag: [0; SLOTS],
            generator: 0,
            since_fall: 0,
            resting_for: 0,
            level: 0,
            pace: 0.0,
            clearing: false,
            laid_courses: 0,
            beat_now: 0,
            since_lay: 1,
            held_turn: false,
            held_a: false,
            held_lay: false,
            held_left: 0,
            held_right: 0,
            placed: Place::default(),
            landing: 0,
            resting: false,
            lay: false,
            turned: false,
            kicked: false,
            moved: false,
            fell: false,
            starts: false,
            topout: false,
            entered: false,
            full_count: 0,
            period: 0,
            tally_kinds: [0; KINDS],
            tally_at_once: [0; 4],
            games: 0,
            topouts: 0,
            cut: false,
            cut_refused: false,
            clip_kind: 0,
            cut_used: false,
            refused_since: 1,
            slid: false,
            dropped: false,
            serial: 0,
            tally_slides: 0,
            tally_dropped: 0,
            tally_cuts: 0,
        }
    }

    pub fn spawn_column() -> i32 {
        (WIDTH as i32 - 3) / 2 + 1
    }

    /// The kind and turn a key names: where no brick is, the header's first
    /// turn, as the cartridge's key of 1.
    fn shape(kind: usize, turn: usize) -> (usize, usize) {
        if kind < 1 {
            (1, 0)
        } else {
            (kind, turn)
        }
    }

    /// Whether a brick fits at a place in a wall: every cell inside the wall
    /// and on an empty cell.
    pub fn fits_in(wall: &[[i32; WIDTH]; HEIGHT], kind: usize, at: Place) -> bool {
        let (k, t) = Game::shape(kind, at.turn);
        cells(k, t).iter().all(|&(r, c)| {
            let (row, col) = (at.course + r, at.column + c);
            row >= 1
                && row <= HEIGHT as i32
                && col >= 1
                && col <= WIDTH as i32
                && wall[(row - 1) as usize][(col - 1) as usize] == 0
        })
    }

    /// The course a brick would land at falling straight from its place: the
    /// course before the first one below it where it no longer fits.
    fn landing_of(wall: &[[i32; WIDTH]; HEIGHT], kind: usize, at: Place) -> i32 {
        let mut first = HEIGHT as i32 + 1;
        for r in 1..=HEIGHT as i32 {
            if r > at.course && !Game::fits_in(wall, kind, Place { course: r, ..at }) {
                first = r;
                break;
            }
        }
        first - 1
    }

    /// Whether a brick at a place covers a cell, by course and column from 1.
    pub fn covers(kind: usize, at: Place, course: i32, column: i32) -> bool {
        let (k, t) = Game::shape(kind, at.turn);
        cells(k, t)
            .iter()
            .any(|&(r, c)| at.course + r == course && at.column + c == column)
    }

    /// One frame: the keys held and the command run, the stages in the
    /// cartridge's order, the lay, the wall's event and the counts.
    pub fn step(&mut self, keys: Keys) {
        let s = self.settings;
        let last = self.clone();
        self.frame += 1;
        let first = self.frame == 1;

        // the keys
        let turn_held = keys.up || keys.b;
        let cw = turn_held && !last.held_turn;
        let ccw = keys.a && !last.held_a;
        let lay_held = keys.start || keys.select;
        let lay_key = lay_held && !last.held_lay;
        self.held_turn = turn_held;
        self.held_a = keys.a;
        self.held_lay = lay_held;
        self.paused = if first {
            false
        } else if keys.command == "pause"
            && (last.phase == Phase::Falling || last.phase == Phase::Beat)
        {
            !last.paused
        } else {
            last.paused
        };
        let go = !self.paused;
        self.held_left = if keys.left { last.held_left + 1 } else { 0 };
        self.held_right = if keys.right { last.held_right + 1 } else { 0 };
        let steps = |held: u32| {
            held == 1
                || (held > s.repeat_delay && (held - s.repeat_delay - 1) % s.repeat_period == 0)
        };
        let step_left = go && keys.left && steps(self.held_left);
        let step_right = go && keys.right && steps(self.held_right);
        let dx = i32::from(step_right) - i32::from(step_left);
        let dt = if go {
            i32::from(cw) - i32::from(ccw)
        } else {
            0
        };
        let slide = match keys.command {
            "slide-left" => -1,
            "slide-right" => 1,
            _ => 0,
        };
        let to_bottom = keys.command == "to-the-bottom";
        let cut_wanted =
            go && last.phase == Phase::Falling && keys.command == "cut" && !last.cut_used;

        // a game starts, never at the first frame, and a brick enters, its
        // kind from the bags the last frame left, by the size they were
        // dealt at
        self.starts = !first
            && lay_key
            && (last.phase == Phase::Waiting
                || (last.phase == Phase::Over && last.since >= s.hold));
        let ending = go
            && last.phase == Phase::Beat
            && last.since == if last.clearing { last.beat_now - 1 } else { 0 };
        let entering_at = if self.starts { 1 } else { last.dealt + 1 };
        let counts = in_use(&s.bag);
        let size_before = if first {
            size_of(&counts)
        } else {
            size_of(&last.counts)
        };
        let from_clip = cut_wanted && last.clip_kind > 0;
        let enter_kind = if from_clip {
            last.clip_kind
        } else {
            kind_at(
                entering_at,
                last.deal_start,
                size_before,
                &last.this_bag,
                &last.next_bag,
                last.bag_number,
            )
        };
        let spawn = Place {
            course: 1,
            column: Game::spawn_column(),
            turn: 0,
        };
        let spawn_ok = self.starts || Game::fits_in(&last.wall, enter_kind, spawn);
        self.cut = cut_wanted && spawn_ok;
        self.cut_refused = cut_wanted && !spawn_ok;
        let enter = self.starts || ending || self.cut;
        self.topout = (self.starts || ending) && !spawn_ok;
        self.entered = enter && spawn_ok;
        let bag_entry = self.entered && !from_clip;

        // the deal: dealt afresh at a top-out or at a count changed, the
        // places from a count changed counted from the deal's start
        self.recount = !first && counts != last.counts;
        self.redeal = self.topout || self.recount;
        let new_bag =
            bag_entry && (entering_at - last.deal_start - 1) / size_before > last.bag_number;
        self.dealt = if first || self.topout {
            0
        } else if bag_entry {
            entering_at
        } else {
            last.dealt
        };
        self.serial = if first || self.topout {
            0
        } else if self.entered {
            last.serial + 1
        } else {
            last.serial
        };
        self.clip_kind = if first || self.starts {
            0
        } else if self.cut {
            last.kind
        } else {
            last.clip_kind
        };
        self.deal_start = if first || self.topout {
            0
        } else if self.recount {
            self.dealt
        } else {
            last.deal_start
        };
        self.bag_number = if first || self.redeal {
            0
        } else if new_bag {
            last.bag_number + 1
        } else {
            last.bag_number
        };
        let base = if first { self.seed } else { last.generator };
        let d = dice(base);
        if first || self.redeal {
            self.this_bag = order(&d[0..SLOTS], &counts, 1);
            self.next_bag = order(&d[SLOTS..2 * SLOTS], &counts, SLOTS as u64 + 1);
            self.generator = d[2 * SLOTS - 1];
        } else if new_bag {
            self.this_bag = last.next_bag;
            self.next_bag = order(&d[0..SLOTS], &counts, 1);
            self.generator = d[SLOTS - 1];
        }
        self.counts = counts;
        self.kind = if first {
            0
        } else if self.entered {
            enter_kind
        } else {
            last.kind
        };
        let kind = self.kind;

        // the stages
        let moving = go && last.phase == Phase::Falling && !cut_wanted;
        let aim = ((last.brick.turn as i32 + dt + 4) % 4) as usize;
        let lb = last.brick;
        let tries = [
            Place { turn: aim, ..lb },
            Place {
                column: lb.column + 1,
                turn: aim,
                ..lb
            },
            Place {
                column: lb.column - 1,
                turn: aim,
                ..lb
            },
            Place {
                course: lb.course - 1,
                turn: aim,
                ..lb
            },
        ];
        let fit: Vec<bool> = tries
            .iter()
            .map(|&p| Game::fits_in(&last.wall, kind, p))
            .collect();
        self.turned = moving && dt != 0 && fit.iter().any(|&f| f);
        self.kicked = self.turned && !fit[0];
        let turned_to = if self.turned {
            tries[fit.iter().position(|&f| f).unwrap_or(3)]
        } else {
            lb
        };
        let mut slid_to = turned_to;
        while slide != 0
            && Game::fits_in(
                &last.wall,
                kind,
                Place {
                    column: slid_to.column + slide,
                    ..slid_to
                },
            )
        {
            slid_to.column += slide;
        }
        self.slid = moving && slide != 0 && slid_to.column != turned_to.column;
        let moved_to = Place {
            column: turned_to.column + dx,
            ..turned_to
        };
        self.moved = moving
            && (self.slid || (slide == 0 && dx != 0 && Game::fits_in(&last.wall, kind, moved_to)));
        let after_move = if self.slid {
            slid_to
        } else if self.moved {
            moved_to
        } else {
            turned_to
        };
        self.period = s.fastest.max((last.pace + 0.5).floor() as u32);
        let period = self.period;
        let gravity = if keys.down {
            s.soft_fall.min(period)
        } else {
            period
        };
        let due = last.since_fall + 1 >= gravity;
        let below = Place {
            course: after_move.course + 1,
            ..after_move
        };
        let bottom = Place {
            course: Game::landing_of(&last.wall, kind, after_move),
            ..after_move
        };
        self.dropped = moving && to_bottom && bottom.course > after_move.course;
        self.fell = moving && (self.dropped || (due && Game::fits_in(&last.wall, kind, below)));
        self.placed = if self.entered {
            spawn
        } else if moving {
            if self.dropped {
                bottom
            } else if self.fell {
                below
            } else {
                after_move
            }
        } else {
            lb
        };
        let placed = self.placed;
        self.resting = !Game::fits_in(
            &last.wall,
            kind,
            Place {
                course: placed.course + 1,
                ..placed
            },
        );
        self.since_fall = if first || self.entered {
            0
        } else if moving {
            if self.fell {
                0
            } else {
                last.since_fall + 1
            }
        } else {
            last.since_fall
        };
        self.resting_for = if first || self.entered {
            0
        } else if moving {
            if self.fell {
                0
            } else if self.resting {
                last.resting_for + 1
            } else {
                last.resting_for
            }
        } else {
            last.resting_for
        };
        self.landing = Game::landing_of(&last.wall, kind, placed);
        self.lay = moving && (lay_key || (self.resting && self.resting_for >= s.lay_delay));
        let lay_course = if lay_key { self.landing } else { placed.course };
        self.brick = if first {
            Place {
                course: 1,
                column: Game::spawn_column(),
                turn: 0,
            }
        } else if self.lay {
            Place {
                course: lay_course,
                ..placed
            }
        } else {
            placed
        };

        // the phase
        self.phase = if first {
            Phase::Waiting
        } else if self.topout {
            Phase::Over
        } else if self.entered {
            Phase::Falling
        } else if self.lay {
            Phase::Beat
        } else {
            last.phase
        };
        self.since = if first || self.phase != last.phase {
            0
        } else if go {
            last.since + 1
        } else {
            last.since
        };

        // the lay: the brick's cells and the full courses
        let mut laid = last.wall;
        self.full_count = 0;
        if self.lay {
            let at = self.brick;
            for r in 1..=HEIGHT as i32 {
                for c in 1..=WIDTH as i32 {
                    if Game::covers(kind, at, r, c) {
                        laid[(r - 1) as usize][(c - 1) as usize] = self.serial as i32;
                    }
                }
            }
            self.full_count = laid
                .iter()
                .filter(|row| row.iter().all(|&v| v != 0))
                .count() as u32;
        }

        // the level, the pace and the beat's counts: the pace a product, a
        // multiplication a course cleared, in the cartridge's order
        self.level = if first || self.starts {
            0
        } else {
            last.level + self.full_count
        };
        let quicken = 1.0 - s.quickening;
        self.pace = if first || self.starts {
            s.start_pace
        } else {
            let mut p = last.pace;
            for nth in 1..=4 {
                p *= if self.full_count >= nth { quicken } else { 1.0 };
            }
            p
        };
        self.clearing = if first {
            false
        } else if self.lay {
            self.full_count > 0
        } else {
            last.clearing
        };
        self.laid_courses = if first {
            0
        } else if self.lay {
            self.full_count
        } else {
            last.laid_courses
        };
        self.beat_now = if first || self.lay {
            s.beat
        } else {
            last.beat_now
        };
        let shift =
            go && last.phase == Phase::Beat && last.clearing && last.since == last.beat_now - 2;

        // the wall's event
        self.wall = if first || self.starts {
            [[0; WIDTH]; HEIGHT]
        } else if self.lay {
            laid
        } else if shift {
            let kept: Vec<[i32; WIDTH]> = last
                .wall
                .iter()
                .copied()
                .filter(|row| !row.iter().all(|&v| v != 0))
                .collect();
            let mut out = [[0; WIDTH]; HEIGHT];
            let start = HEIGHT - kept.len();
            for (i, row) in kept.into_iter().enumerate() {
                out[start + i] = row;
            }
            out
        } else {
            last.wall
        };
        self.since_lay = if first {
            99
        } else if self.lay {
            0
        } else if go {
            (last.since_lay + 1).min(99)
        } else {
            last.since_lay
        };

        // the Tally
        if self.lay {
            self.tally_kinds[kind - 1] += 1;
            if (1..=4).contains(&self.full_count) {
                self.tally_at_once[(self.full_count - 1) as usize] += 1;
            }
        }
        self.games += u32::from(self.starts);
        self.topouts += u32::from(self.topout);
        self.cut_used = if first || self.starts {
            false
        } else if self.cut {
            true
        } else if self.lay {
            false
        } else {
            last.cut_used
        };
        self.refused_since = if first {
            99
        } else if self.cut_refused {
            0
        } else {
            (last.refused_since + 1).min(99)
        };
        self.tally_slides += u32::from(self.slid);
        self.tally_dropped += u32::from(self.dropped);
        self.tally_cuts += u32::from(self.cut);
    }

    pub fn go(&self) -> bool {
        !self.paused
    }

    /// The next three kinds, from the bags as the frame leaves them.
    pub fn next(&self) -> [usize; 3] {
        let size = size_of(&self.counts);
        [1, 2, 3].map(|i| {
            kind_at(
                self.dealt + i,
                self.deal_start,
                size,
                &self.this_bag,
                &self.next_bag,
                self.bag_number,
            )
        })
    }

    /// A course's count of laid cells.
    pub fn count(&self, course: usize) -> usize {
        self.wall[course - 1].iter().filter(|&&v| v != 0).count()
    }

    /// The word a cell of the wall shows, by course and column from 1.
    pub fn word(&self, course: i32, column: i32) -> &'static str {
        if self.phase == Phase::Falling && Game::covers(self.kind, self.brick, course, column) {
            return "falling";
        }
        let landing = Place {
            course: self.landing,
            ..self.brick
        };
        if self.phase == Phase::Falling && Game::covers(self.kind, landing, course, column) {
            return "landing";
        }
        let v = self.wall[(course - 1) as usize][(column - 1) as usize];
        if v == 0 {
            ""
        } else if self.phase == Phase::Beat && self.count(course as usize) == WIDTH {
            "full"
        } else {
            "brick"
        }
    }

    /// The serial a cell shows the joints, the falling brick's its own.
    pub fn serial(&self, course: i32, column: i32) -> i32 {
        if self.phase == Phase::Falling && Game::covers(self.kind, self.brick, course, column) {
            self.serial as i32
        } else {
            self.wall[(course - 1) as usize][(column - 1) as usize]
        }
    }

    /// The words beside the wall, when there is something to say.
    pub fn words(&self) -> &'static str {
        match self.phase {
            Phase::Waiting => "Enter or Space begins a wall.",
            _ if self.paused => "Paused: P resumes.",
            Phase::Falling if self.refused_since < 60 => {
                "Ctrl+X: no room at the top for the brick it brings."
            }
            Phase::Over => "#SPILL! The next brick has no room.",
            _ => "",
        }
    }

    /// The line below them: once a topped-out wall has stood, how to build
    /// again.
    pub fn hint(&self) -> &'static str {
        if self.phase == Phase::Over && self.since >= self.settings.hold {
            "Enter or Space builds again."
        } else {
            ""
        }
    }

    /// The four voices.
    pub fn voices(&self) -> [Voice; 4] {
        let go = self.go();
        let chord = [72.0, 76.0, 79.0, 84.0][((self.since_lay / 3 + 1).min(4) - 1) as usize];
        [
            Voice {
                wave: "square",
                note: 76.0,
                volume: if go && (self.turned || self.moved || self.cut) {
                    0.25
                } else {
                    0.0
                },
            },
            Voice {
                wave: "triangle",
                note: 45.0,
                volume: if go && self.since_lay < 6 { 0.6 } else { 0.0 },
            },
            Voice {
                wave: "square",
                note: chord,
                volume: if go && self.laid_courses > 0 && self.since_lay < 3 * self.laid_courses {
                    0.35
                } else {
                    0.0
                },
            },
            Voice {
                wave: "sawtooth",
                note: if self.phase == Phase::Over {
                    (60.0 - f64::from(self.since) / 2.0).max(24.0)
                } else {
                    60.0
                },
                volume: if self.phase == Phase::Over && self.since < 40 {
                    0.4
                } else {
                    0.0
                },
            },
        ]
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// No brick has a left and a right hand: each brick's first turn,
    /// mirrored, is one of its own turns, moved.
    #[test]
    fn no_brick_has_a_left_and_a_right_hand() {
        let at_origin = |cells: &[(i32, i32)]| -> Vec<(i32, i32)> {
            let (r0, c0) = (
                cells.iter().map(|p| p.0).min().unwrap(),
                cells.iter().map(|p| p.1).min().unwrap(),
            );
            let mut v: Vec<(i32, i32)> = cells.iter().map(|&(r, c)| (r - r0, c - c0)).collect();
            v.sort_unstable();
            v
        };
        for kind in 1..=KINDS {
            let first = cells(kind, 0);
            let mirrored: Vec<(i32, i32)> = first.iter().map(|&(r, c)| (r, -c)).collect();
            let mirrored = at_origin(&mirrored);
            assert!(
                (0..4).any(|t| at_origin(&cells(kind, t)) == mirrored),
                "the {} has a hand",
                BRICKS[kind - 1].0
            );
        }
    }

    /// The bricks' cells, one to eight, the same in every turn.
    #[test]
    fn each_brick_keeps_its_cells_in_every_turn() {
        let sizes: Vec<usize> = (1..=KINDS).map(|k| cells(k, 0).len()).collect();
        assert_eq!(sizes, [1, 2, 3, 3, 4, 5, 6, 7, 8]);
        for kind in 1..=KINDS {
            for turn in 1..4 {
                assert_eq!(cells(kind, turn).len(), sizes[kind - 1]);
            }
        }
    }

    /// A bag holds each brick as many times as its count in use, and two
    /// seeds deal two orders.
    #[test]
    fn a_bag_holds_each_brick_its_count() {
        let counts = in_use(&Settings::default().bag);
        let d = dice(12345);
        let bag = order(&d[0..SLOTS], &counts, 1);
        let n = size_of(&counts) as usize;
        assert_eq!(n, 13);
        for kind in 1..=KINDS {
            assert_eq!(
                bag.iter().filter(|&&k| k == kind).count() as u32,
                counts[kind - 1],
                "the {}",
                BRICKS[kind - 1].0
            );
        }
        assert!(bag[n..].iter().all(|&k| k == 0));
        assert_ne!(
            order(&dice(1)[0..SLOTS], &counts, 1),
            order(&dice(2)[0..SLOTS], &counts, 1)
        );
    }

    /// What a person types into a count is read as a whole number from none
    /// to four, a text as none; the counts in use are each once when none is
    /// counted, and a bag of fewer than three is dealt over until it holds
    /// three; a full bag holds thirty-six.
    #[test]
    fn the_counts_in_use_hold_what_is_typed() {
        let typed = [
            (Some(2.0), 2),
            (Some(2.9), 2),
            (Some(-3.0), 0),
            (Some(-0.5), 0),
            (Some(9.0), 4),
            (Some(1e300), 4),
            (None, 0),
        ];
        for (t, want) in typed {
            assert_eq!(held_count(t), want, "{t:?}");
        }
        assert_eq!(in_use(&[0; KINDS]), [1; KINDS]);
        assert_eq!(
            in_use(&[1, 0, 0, 0, 0, 0, 0, 0, 0]),
            [3, 0, 0, 0, 0, 0, 0, 0, 0]
        );
        assert_eq!(
            in_use(&[1, 0, 0, 0, 1, 0, 0, 0, 0]),
            [2, 0, 0, 0, 2, 0, 0, 0, 0]
        );
        assert_eq!(
            in_use(&[0, 0, 0, 0, 0, 0, 0, 0, 2]),
            [0, 0, 0, 0, 0, 0, 0, 0, 4]
        );
        assert_eq!(
            in_use(&[1, 1, 1, 0, 0, 0, 0, 0, 0]),
            [1, 1, 1, 0, 0, 0, 0, 0, 0]
        );
        assert_eq!(size_of(&in_use(&[MOST_OF_EACH; KINDS])), SLOTS as u32);
        for held in [
            [0; KINDS],
            [1, 0, 0, 0, 0, 0, 0, 0, 0],
            [MOST_OF_EACH; KINDS],
        ] {
            let counts = in_use(&held);
            let bag = order(&dice(7)[0..SLOTS], &counts, 1);
            let n = size_of(&counts) as usize;
            assert!((3..=SLOTS).contains(&n));
            assert!(bag[..n]
                .iter()
                .all(|&k| (1..=KINDS).contains(&k) && counts[k - 1] > 0));
        }
    }

    /// A game begun, its first brick falling at the top center.
    fn falling() -> Game {
        let mut g = Game::load(Settings::default(), 1);
        g.step(Keys::default());
        g.step(Keys::default());
        g.step(Keys {
            start: true,
            ..Keys::default()
        });
        assert_eq!(g.phase, Phase::Falling);
        g
    }

    fn command(name: &'static str) -> Keys {
        Keys {
            command: name,
            ..Keys::default()
        }
    }

    /// A slide stops at the last column the brick fits at, before a brick or
    /// the wall, in one frame, and a slide that moves nothing is none.
    #[test]
    fn a_slide_stops_at_a_brick_and_at_the_wall() {
        let mut g = falling();
        g.kind = 1;
        g.brick = Place {
            course: 2,
            column: 6,
            turn: 0,
        };
        g.wall[1][1] = 99;
        g.step(command("slide-left"));
        assert_eq!(g.brick.column, 3, "stopped beside the brick in column 2");
        assert!(g.slid && g.moved);
        g.step(command("slide-right"));
        assert_eq!(g.brick.column, WIDTH as i32, "stopped at the wall");
        g.step(command("slide-right"));
        assert!(!g.slid && !g.moved, "no slide where none moves");
    }

    /// To the bottom moves the brick to where its shadow stands and lays it
    /// not, its rest's count begun again, the brick still free to slide.
    #[test]
    fn to_the_bottom_moves_the_brick_to_its_shadow_unlaid() {
        let mut g = falling();
        g.kind = 1;
        g.brick = Place {
            course: 2,
            column: 6,
            turn: 0,
        };
        g.step(command("to-the-bottom"));
        assert!(g.dropped && g.fell && !g.lay);
        assert_eq!(g.brick.course, HEIGHT as i32);
        assert_eq!((g.phase, g.resting_for), (Phase::Falling, 0));
        g.step(command("slide-left"));
        assert_eq!(
            (g.brick.course, g.brick.column),
            (HEIGHT as i32, 1),
            "slid along the bottom"
        );
        assert_eq!(g.phase, Phase::Falling, "and not laid");
    }

    /// A cut sends the falling brick to the Clipboard and takes the deal's
    /// next, once a brick: a second cut of the brick it took does nothing
    /// until one is laid. The next brick's cut takes the Clipboard's back, and
    /// every brick that entered has a serial of its own.
    #[test]
    fn a_cut_takes_the_clipboards_brick_once_a_brick() {
        let mut g = falling();
        let (first, serial, dealt) = (g.kind, g.serial, g.dealt);
        g.step(command("cut"));
        assert!(g.cut && g.cut_used);
        assert_eq!(
            (g.clip_kind, g.serial, g.dealt),
            (first, serial + 1, dealt + 1)
        );
        let taken = g.kind;
        g.step(command("cut"));
        assert!(!g.cut, "once a brick");
        assert_eq!(g.kind, taken);
        g.step(Keys {
            select: true,
            ..Keys::default()
        });
        assert!(g.lay && !g.cut_used, "the lay frees the cut");
        while g.phase != Phase::Falling {
            g.step(Keys::default());
        }
        let next = g.kind;
        assert_eq!(g.serial, serial + 2);
        g.step(command("cut"));
        assert!(g.cut, "the Clipboard's brick back");
        assert_eq!((g.kind, g.clip_kind, g.serial), (first, next, serial + 3));
        assert_eq!(
            g.dealt,
            dealt + 2,
            "a brick back from the Clipboard takes no place in the deal"
        );
    }

    /// A setting typed is held inside its bounds, a whole number where it
    /// counts frames, and its default where the cell holds no number.
    #[test]
    fn a_setting_typed_is_held_inside_its_bounds() {
        assert_eq!(held_setting(Some(45.5), 1), 45.5);
        assert_eq!(held_setting(Some(0.0), 1), 1.0);
        assert_eq!(held_setting(Some(1e9), 1), A_MINUTE);
        assert_eq!(held_setting(None, 1), 60.0);
        assert_eq!(held_setting(Some(-0.2), 2), 0.0);
        assert_eq!(held_setting(Some(5.0), 2), 1.0);
        assert_eq!(held_setting(Some(0.5), 3), 1.0);
        assert_eq!(held_setting(Some(2.7), 4), 2.0);
        assert_eq!(held_setting(Some(0.0), 6), 1.0);
        assert_eq!(held_setting(Some(1.0), 8), 2.0);
        assert_eq!(held_setting(None, 9), 60.0);
        let s = Settings::default();
        assert_eq!(
            (
                s.start_pace,
                s.quickening,
                s.fastest,
                s.lay_delay,
                s.repeat_delay
            ),
            (60.0, 0.03, 1, 30, 10)
        );
        assert_eq!(
            (s.repeat_period, s.soft_fall, s.beat, s.hold),
            (2, 2, 12, 60)
        );
    }
}

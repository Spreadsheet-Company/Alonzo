//! Kairos by hand (`CART.4`; `docs/REARVIEW.md`, the item's second scoping,
//! decisions 3 and 11): the cabinet's rule written a second time, in Rust,
//! the way a person would write the game, so that the cartridge's frames are
//! held to a rule written twice. A row is a bitmask of its seven columns, a
//! stop is a bitwise AND with the row beneath, what stayed is its population
//! count, and the game is a `match` on its phase. The cartridge keeps a row
//! as the two ends of a run and its phase as a chain of `IF`s, so the two
//! share no predicate. The engine's tests compile it as a module of the crate
//! for the tests alone, as they compile `sand.rs`; the page holds a second
//! Kairos, in JavaScript, for its replay case.
//!
//! The game. Fifteen levels of seven columns. A row of lights slides along its
//! level, a column every `period` frames of its level, turning at either end.
//! A press stops it where the person saw it, the last frame's place, or a
//! column on when the press comes after the level's window in that place. The
//! lights not over a light of the row beneath fall; none over one ends the
//! game. After a beat the next row begins at the left end, as wide as what
//! stayed and at most its level's width. At the minor prize's level the game
//! offers the minor prize, which a second button takes and a press refuses;
//! at the major prize's level the game is won and WIN flashes. A game over
//! holds its picture, then the tower clears, and a press plays again.
//!
//! The Tower is the cartridge's Write sheet's: a stop's run is written into it
//! as a derived write that lands before the next frame's step, and so is the
//! clear once a result has been held. The rule reads none of it.

/// The board: fifteen levels of seven columns.
pub const LEVELS: usize = 15;
pub const COLUMNS: usize = 7;

/// The phase, by the cartridge's codes 1 to 4.
#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum Phase {
    Sliding,
    Stopped,
    Offer,
    Over,
}

impl Phase {
    pub fn code(self) -> u32 {
        match self {
            Phase::Sliding => 1,
            Phase::Stopped => 2,
            Phase::Offer => 3,
            Phase::Over => 4,
        }
    }
}

/// How a game ended, by the cartridge's codes 0 to 3.
#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum End {
    Playing,
    Fell,
    Minor,
    Major,
}

impl End {
    pub fn code(self) -> u32 {
        match self {
            End::Playing => 0,
            End::Fell => 1,
            End::Minor => 2,
            End::Major => 3,
        }
    }
}

/// The Levels sheet's values: each level's period, width and window, the two
/// prizes' levels, the beat after a stop and the result's hold.
#[derive(Clone, Debug)]
pub struct Settings {
    pub period: [u32; LEVELS],
    pub width: [u32; LEVELS],
    pub window: [u32; LEVELS],
    pub minor: usize,
    pub major: usize,
    pub beat: u32,
    pub hold: u32,
}

impl Default for Settings {
    /// The cartridge's own: honest, every window its period.
    fn default() -> Settings {
        let period = [10, 10, 9, 9, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3];
        Settings {
            period,
            width: [3, 3, 3, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1],
            window: period,
            minor: 11,
            major: 15,
            beat: 20,
            hold: 90,
        }
    }
}

/// The run of columns `from` to `to`, both from 1, as a mask.
pub fn run(from: i32, to: i32) -> u8 {
    (from..=to)
        .filter(|c| (1..=COLUMNS as i32).contains(c))
        .fold(0u8, |m, c| m | (1 << (c - 1)))
}

/// A mask's lowest and highest column, from 1.
pub fn ends(mask: u8) -> Option<(i32, i32)> {
    (mask != 0).then(|| {
        (
            mask.trailing_zeros() as i32 + 1,
            8 - mask.leading_zeros() as i32,
        )
    })
}

/// A write the Write sheet asks for, landing before the next frame's step.
#[derive(Clone, Copy, Debug)]
enum Write {
    Lights(usize, u8),
    Clear,
}

/// One voice of the Audio sheet: its wave, note and volume.
#[derive(Clone, Copy, PartialEq, Debug)]
pub struct Voice {
    pub wave: &'static str,
    pub note: f64,
    pub volume: f64,
}

/// The game, frame by frame.
#[derive(Clone, Debug)]
pub struct Game {
    pub settings: Settings,
    pub frame: u32,
    pub phase: Phase,
    /// The frames since the phase began.
    pub since: u32,
    pub level: usize,
    pub width: u32,
    pub left: i32,
    pub direction: i32,
    /// Where the row stopped, its left end.
    pub stopped: i32,
    /// The row beneath, or at a stop what stayed of the row.
    pub beneath: u8,
    pub end: End,
    pub games: u32,
    /// The Tower: each level's lights, as the Write sheet has written them.
    pub tower: [u8; LEVELS],
    /// The row moved in this frame.
    pub moved: bool,
    /// The Tally: each level reached and stacked, the lights that fell there;
    /// the presses, the moves, the minor prizes, the major prizes and the falls.
    pub reached: [u32; LEVELS],
    pub stacked: [u32; LEVELS],
    pub fell: [u32; LEVELS],
    pub presses: u32,
    pub moves: u32,
    pub minors: u32,
    pub majors: u32,
    pub falls: u32,
    pending: Vec<Write>,
    held_last: bool,
    take_last: bool,
}

impl Game {
    /// The game as a load leaves it: nothing computed, frame 0.
    pub fn new(settings: Settings) -> Game {
        Game {
            settings,
            frame: 0,
            phase: Phase::Over,
            since: 0,
            level: 1,
            width: 3,
            left: 1,
            direction: 1,
            stopped: 0,
            beneath: run(1, COLUMNS as i32),
            end: End::Playing,
            games: 0,
            tower: [0; LEVELS],
            moved: false,
            reached: [0; LEVELS],
            stacked: [0; LEVELS],
            fell: [0; LEVELS],
            presses: 0,
            moves: 0,
            minors: 0,
            majors: 0,
            falls: 0,
            pending: Vec::new(),
            held_last: false,
            take_last: false,
        }
    }

    fn period(&self) -> u32 {
        self.settings.period[self.level - 1]
    }

    /// The row's next place and direction: a column on, turning at an end.
    pub fn onward(&self) -> (i32, i32) {
        let right = self.left + self.width as i32 - 1;
        let turn = (self.direction == 1 && right >= COLUMNS as i32)
            || (self.direction == -1 && self.left <= 1);
        let d = if turn {
            -self.direction
        } else {
            self.direction
        };
        (self.left + d, d)
    }

    /// The sliding row's lights, as the last frame drew them.
    pub fn row(&self) -> u8 {
        run(self.left, self.left + self.width as i32 - 1)
    }

    /// A row begins at the left end, going right.
    fn begin_row(&mut self) {
        self.left = 1;
        self.direction = 1;
        self.reached[self.level - 1] += 1;
        self.phase = Phase::Sliding;
    }

    fn start(&mut self) {
        self.level = 1;
        self.beneath = run(1, COLUMNS as i32);
        self.width = self.settings.width[0].min(self.beneath.count_ones());
        self.end = End::Playing;
        self.games += 1;
        self.begin_row();
    }

    fn over(&mut self, end: End) {
        self.end = end;
        match end {
            End::Fell => self.falls += 1,
            End::Minor => self.minors += 1,
            End::Major => self.majors += 1,
            End::Playing => {}
        }
        self.phase = Phase::Over;
    }

    fn advance(&mut self) {
        self.level += 1;
        self.width = self.settings.width[self.level - 1].min(self.beneath.count_ones());
        self.begin_row();
    }

    /// One frame: the writes the last frame asked for land, then the frame's
    /// buttons, `held` the stop's (a, select or the left button) and
    /// `take_held` the minor prize's (b), each a press on its rising edge.
    pub fn step(&mut self, held: bool, take_held: bool) {
        for w in std::mem::take(&mut self.pending) {
            match w {
                Write::Lights(level, mask) => self.tower[level - 1] |= mask,
                Write::Clear => self.tower = [0; LEVELS],
            }
        }
        self.frame += 1;
        let press = held && !self.held_last;
        let take = take_held && !self.take_last;
        self.held_last = held;
        self.take_last = take_held;
        self.presses += u32::from(press);
        self.moved = false;
        let was = self.phase;
        if self.frame == 1 {
            self.start();
        } else {
            match was {
                Phase::Sliding if press => {
                    // stopped where the person saw it, or a column on after the window
                    let within = self.since % self.period() < self.settings.window[self.level - 1];
                    self.stopped = if within { self.left } else { self.onward().0 };
                    let row = run(self.stopped, self.stopped + self.width as i32 - 1);
                    let stayed = row & self.beneath;
                    self.fell[self.level - 1] += self.width - stayed.count_ones();
                    self.beneath = stayed;
                    if stayed != 0 {
                        self.pending.push(Write::Lights(self.level, stayed));
                    }
                    self.phase = Phase::Stopped;
                }
                Phase::Sliding => {
                    if (self.since + 1) % self.period() == 0 {
                        (self.left, self.direction) = self.onward();
                        self.moved = true;
                        self.moves += 1;
                    }
                }
                Phase::Stopped if self.since + 1 >= self.settings.beat => {
                    if self.beneath == 0 {
                        self.over(End::Fell);
                    } else {
                        self.stacked[self.level - 1] += 1;
                        if self.level == self.settings.major {
                            self.over(End::Major);
                        } else if self.level == self.settings.minor {
                            self.phase = Phase::Offer;
                        } else {
                            self.advance();
                        }
                    }
                }
                Phase::Offer if take => self.over(End::Minor),
                Phase::Offer if press => self.advance(),
                Phase::Over if press && self.since >= self.settings.hold => self.start(),
                _ => {}
            }
        }
        self.since = if self.phase != was { 0 } else { self.since + 1 };
        if self.phase == Phase::Over && self.since == self.settings.hold {
            self.pending.push(Write::Clear);
        }
    }

    /// A game's end has been held, and a press plays again.
    pub fn ready(&self) -> bool {
        self.phase == Phase::Over && self.since >= self.settings.hold
    }

    /// The light of the board's cabinet column `r` and level `c`, both from 1,
    /// before the checker: 0 no light, 1 a light that stayed, 2 the row
    /// sliding, 3 a light falling (blinking), 6 and 7 the minor and the major
    /// prize's level unlit, 5 the minor's while it is offered (blinking). WIN
    /// is drawn by the caller, each orientation spelling its own.
    fn light(&self, r: usize, c: usize) -> u8 {
        let s = &self.settings;
        let blink = self.since % 8 < 4;
        let bit = 1u8 << (r - 1);
        let falling = self.phase == Phase::Stopped
            || (self.phase == Phase::Over && self.end == End::Fell && !self.ready());
        let (span, look) = match self.phase {
            Phase::Sliding => (self.row(), 2),
            _ if falling => (
                run(self.stopped, self.stopped + self.width as i32 - 1),
                if blink { 3 } else { 0 },
            ),
            _ => (0, 0),
        };
        let stayed = if self.phase == Phase::Stopped {
            self.beneath
        } else {
            0
        };
        if c == self.level && stayed & bit != 0 {
            1
        } else if c == self.level && span & bit != 0 {
            look
        } else if self.tower[c - 1] & bit != 0 {
            1
        } else if c == s.minor {
            if self.phase == Phase::Offer && blink {
                5
            } else {
                6
            }
        } else if c == s.major {
            7
        } else {
            0
        }
    }

    /// WIN's state: shown while the major prize is won, by half seconds, dark
    /// between; `None` otherwise.
    fn win(&self) -> Option<bool> {
        (self.phase == Phase::Over && self.end == End::Major).then_some(self.since % 30 < 15)
    }

    /// The board lying on its side, as the plane reads the Screen's `A1:O7`:
    /// the cabinet's column `r` the Screen's row `r`, its level `c` the
    /// Screen's column `c`, row by row, and the checker's twin, 8 more, on a
    /// light whose row and column sum odd.
    pub fn board(&self) -> Vec<u8> {
        let mut out = vec![0u8; COLUMNS * LEVELS];
        for r in 1..=COLUMNS {
            for c in 1..=LEVELS {
                let v = match self.win() {
                    Some(true) => u8::from(WIN[r - 1].as_bytes()[c - 1] == b'#') * 4,
                    Some(false) => 0,
                    None => self.light(r, c),
                };
                out[(r - 1) * LEVELS + (c - 1)] = v + if (r + c) % 2 == 1 { 8 } else { 0 };
            }
        }
        out
    }

    /// The board standing up, as the plane reads an upright build's `A1:G15`:
    /// the level `16 - y` at the Screen's row `y`, the cabinet's column `x` at
    /// its column `x`, row by row, with the same checker.
    pub fn board_upright(&self) -> Vec<u8> {
        let mut out = vec![0u8; COLUMNS * LEVELS];
        for y in 1..=LEVELS {
            for x in 1..=COLUMNS {
                let v = match self.win() {
                    Some(true) => u8::from(WIN_UPRIGHT[y - 1].as_bytes()[x - 1] == b'#') * 4,
                    Some(false) => 0,
                    None => self.light(x, LEVELS + 1 - y),
                };
                out[(y - 1) * COLUMNS + (x - 1)] = v + if (x + y) % 2 == 1 { 8 } else { 0 };
            }
        }
        out
    }

    /// The Audio sheet's four voices after the frame.
    pub fn voices(&self) -> [Voice; 4] {
        let stayed = self.beneath.count_ones();
        let stopped = self.phase == Phase::Stopped;
        let over = self.phase == Phase::Over;
        let since = f64::from(self.since);
        [
            Voice {
                wave: "square",
                note: 72.0 + self.level as f64,
                volume: if self.moved { 0.3 } else { 0.0 },
            },
            Voice {
                wave: "triangle",
                note: 60.0 + 2.0 * self.level as f64,
                volume: if stopped && self.since < 8 && stayed > 0 {
                    0.6
                } else {
                    0.0
                },
            },
            Voice {
                wave: "sawtooth",
                note: if over { 55.0 - since / 2.0 } else { 55.0 },
                volume: if (stopped && stayed == 0 && self.since < 8)
                    || (over && self.end == End::Fell && self.since < 40)
                {
                    0.5
                } else {
                    0.0
                },
            },
            Voice {
                wave: "square",
                note: [72.0, 76.0, 79.0, 84.0][(self.since / 8 % 4) as usize],
                volume: if (over && self.end == End::Major && self.since < 64)
                    || (self.phase == Phase::Offer && self.since < 16)
                {
                    0.5
                } else {
                    0.0
                },
            },
        ]
    }
}

/// WIN lying on its side: the board's seven rows of fifteen.
pub const WIN: [&str; COLUMNS] = [
    "#...#.###.#...#",
    "#...#..#..##..#",
    "#...#..#..##..#",
    "#.#.#..#..#.#.#",
    "#.#.#..#..#..##",
    "##.##..#..#..##",
    "#...#.###.#...#",
];

/// WIN standing up: fifteen rows of seven, a letter above the next.
pub const WIN_UPRIGHT: [&str; LEVELS] = [
    ".......", "#.....#", "#..#..#", "#.#.#.#", ".#...#.", ".......", ".#####.", "...#...",
    "...#...", ".#####.", ".......", "##...#.", "#.#..#.", "#..#.#.", "#...##.",
];

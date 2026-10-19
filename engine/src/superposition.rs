//! Superposition by hand (`CART.12`; `docs/REARVIEW.md`, the item's scoping,
//! decision 7): the rule of `cartridges/superposition/superposition.vla`
//! written a second time, in Rust, the way a person writes a mine-clearing
//! game: a lattice of sites, each unobserved, observed with its reading, boxed
//! or an observed decay, and an act's effect and an opening's spread computed
//! site by site from the last frame. It shares no predicate with the
//! cartridge's formulas, where each site reads its row's Probe and its
//! neighbors' twins, so the engine's frames are held to a rule written twice.
//! The engine's tests compile it as a module of the crate for the tests
//! alone; the native runner of the floors, `examples/frames.rs`, and the
//! playtest session, `examples/play.rs`, include the same file by its path.
//!
//! The lattice is n by n sites from `A1` to the sheet's nth row and column,
//! every cell of the Field a site and the Field bound there (version 6's
//! `(bound "Field")`, `CART.12`'s hand test). The codes are the cartridge's:
//! 0 a site in superposition, 10,000 plus its reading an observed site,
//! 10,000,000 a box and 10,000,000,000 an observed decay.
//!
//! A frame takes the Input rows as the engine's frame sees them, the act's at
//! its frame and the released ones at a settle step, and computes, in the
//! cartridge's order: the act's serial and the world; the row the act stands
//! on, its column, its kind and its serial; the first observation of the
//! world; the decays, dealt from the seed, the world and the probability, the
//! first observation's 3 by 3 clear; the readings; and the lattice from its
//! last frame.
//!
//! Beside the rule, two things the floors need (`CART.12`, decisions 3 and
//! 8), each mirrored in the page's hand,
//! `cartridges/superposition/superposition.hand.js`, so that the module in
//! the browser plays what the runner plays: the scripted player, `Player`,
//! who knows the lattice and plays as a person who knows it would, and the
//! deepest deal of a world, `Lattice::deepest`, the site whose observation
//! opens the longest cascade.

/// The hash's prime, `2^26 - 5`, Life's (`cartridges/life`).
pub const P: u64 = 67_108_859;

/// The codes.
pub const UNOBSERVED: u64 = 0;
pub const NOTHING: u64 = 10_000;
pub const BOX: u64 = 10_000_000;
pub const DECAY: u64 = 10_000_000_000;

/// The eight neighbors.
pub const AROUND: [(i64, i64); 8] = [
    (-1, -1),
    (-1, 0),
    (-1, 1),
    (0, -1),
    (0, 1),
    (1, -1),
    (1, 0),
    (1, 1),
];

/// The Input rows a frame sees: the place, the press and the command.
#[derive(Clone, Debug, Default, PartialEq)]
pub struct Inputs {
    /// `B11` and `B12`, the column and the row the act stands on.
    pub column: u32,
    pub row: u32,
    /// `B13` to `B15`, the left, the right and the middle button held.
    pub left: bool,
    pub right: bool,
    pub middle: bool,
    /// `B19`, the sheet shown.
    pub sheet: String,
    /// `B20`, the command run, or empty.
    pub command: String,
}

impl Inputs {
    /// The rows released, as the engine releases them before a settle step:
    /// the place kept, the press and the command emptied.
    pub fn released(&self) -> Inputs {
        Inputs {
            column: self.column,
            row: self.row,
            sheet: self.sheet.clone(),
            ..Inputs::default()
        }
    }
}

/// What an act does to the site it stands on.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Kind {
    Observe,
    Box,
    Collapse,
}

/// The lattice, by hand.
pub struct Lattice {
    pub n: u32,
    pub seed: u64,
    pub probability: f64,
    /// The acts made on the Field, and the branches taken.
    pub acts: u64,
    pub world: u64,
    /// The first observation of the world, row and column, (0, 0) before it.
    pub first: (u32, u32),
    /// Each row's last act: its column, its kind and its serial.
    last_act: Vec<Option<(u32, Kind, u64)>>,
    decays: Vec<bool>,
    readings: Vec<u64>,
    field: Vec<u64>,
    dealt: Option<(u64, (u32, u32), u64)>,
}

impl Lattice {
    /// The lattice as loaded: every site in superposition, world 0, no act.
    pub fn new(n: u32, seed: u64, probability: f64) -> Lattice {
        let sites = (n * n) as usize;
        Lattice {
            n,
            seed,
            probability,
            acts: 0,
            world: 0,
            first: (0, 0),
            last_act: vec![None; n as usize + 1],
            decays: vec![false; sites],
            readings: vec![NOTHING; sites],
            field: vec![UNOBSERVED; sites],
            dealt: None,
        }
    }

    fn index(&self, row: u32, column: u32) -> usize {
        ((row - 1) * self.n + (column - 1)) as usize
    }

    fn inside(&self, row: i64, column: i64) -> bool {
        let last = i64::from(self.n);
        (1..=last).contains(&row) && (1..=last).contains(&column)
    }

    /// A site's code, its row and its column the sheet's own.
    pub fn site(&self, row: u32, column: u32) -> u64 {
        self.field[self.index(row, column)]
    }

    /// Whether a site has decayed, in the world as last dealt.
    pub fn decayed(&self, row: u32, column: u32) -> bool {
        self.decays[self.index(row, column)]
    }

    /// A site's reading, as last dealt: the decay's code, or 10,000 and its
    /// neighbors' decays.
    pub fn reading(&self, row: u32, column: u32) -> u64 {
        self.readings[self.index(row, column)]
    }

    /// A row's sum of its sites' codes, the Tally's.
    pub fn row_sum(&self, row: u32) -> u64 {
        (1..=self.n).map(|c| self.site(row, c)).sum()
    }

    /// Whether a site decays in a world: the hash of the seed, the site and the
    /// world, squared modulo the prime, under the probability's share of it.
    /// The forms' constants, 3,440,100 and 3,213,021, are 12,345 and 54,321
    /// with a row's and a column's multipliers added, so that each site keeps
    /// the world it was dealt when the lattice stood a row and a column
    /// further in, at `B2` (`CART.12`'s hand test).
    fn decays_at(&self, row: u32, column: u32, world: u64) -> bool {
        let (r, c) = (u64::from(row), u64::from(column));
        let a =
            (self.seed * 1_103_515 + r * 1_597_334 + c * 1_830_421 + world * 7_919 + 3_440_100) % P;
        let b =
            (self.seed * 2_012_345 + r * 1_209_487 + c * 1_949_213 + world * 104_729 + 3_213_021)
                % P;
        let h = (a * b) % P;
        let v = (h * h) % P;
        (v as f64) < self.probability * P as f64
    }

    /// The world dealt: the decays, the first observation's 3 by 3 clear, and
    /// every site's reading; done again only when the world, the first
    /// observation or the probability moved. A frame deals first; the floors'
    /// runner deals a world before its first frame to find its deepest deal.
    pub fn deal(&mut self) {
        let key = (self.world, self.first, self.probability.to_bits());
        if self.dealt == Some(key) {
            return;
        }
        let n = self.n;
        let mut decays = vec![false; self.decays.len()];
        for r in 1..=n {
            for c in 1..=n {
                let cleared = self.first.0 > 0
                    && r.abs_diff(self.first.0) <= 1
                    && c.abs_diff(self.first.1) <= 1;
                decays[self.index(r, c)] = !cleared && self.decays_at(r, c, self.world);
            }
        }
        let mut readings = vec![NOTHING; self.readings.len()];
        for r in 1..=n {
            for c in 1..=n {
                let i = self.index(r, c);
                readings[i] = if decays[i] {
                    DECAY
                } else {
                    let around = AROUND
                        .iter()
                        .filter(|(dr, dc)| {
                            let (rr, cc) = (i64::from(r) + dr, i64::from(c) + dc);
                            self.inside(rr, cc) && decays[self.index(rr as u32, cc as u32)]
                        })
                        .count();
                    NOTHING + around as u64
                };
            }
        }
        self.decays = decays;
        self.readings = readings;
        self.dealt = Some(key);
    }

    /// One frame, its Input rows as the engine's frame sees them.
    pub fn frame(&mut self, i: &Inputs) {
        let n = self.n;
        let on_field = i.sheet == "Field";
        let commanded = |name: &str| i.command == name;
        let act = on_field
            && (i.left
                || i.right
                || i.middle
                || commanded("observe")
                || commanded("box")
                || commanded("collapse"));
        let kind = if i.right || commanded("box") {
            Kind::Box
        } else if i.middle || commanded("collapse") {
            Kind::Collapse
        } else {
            Kind::Observe
        };
        let branched = commanded("branch");
        if act {
            self.acts += 1;
        }
        if branched {
            self.world += 1;
        }
        // the row the act stands on: its last act this frame's
        let mut acted_row = None;
        if act && (1..=n).contains(&i.row) {
            self.last_act[i.row as usize] = Some((i.column, kind, self.acts));
            acted_row = Some(i.row);
        }
        // the first observation of the world, on a site of the lattice
        let observed = i.left || commanded("observe");
        self.first = if branched {
            (0, 0)
        } else if self.first.0 > 0 {
            self.first
        } else if on_field && observed && (1..=n).contains(&i.row) && (1..=n).contains(&i.column) {
            (i.row, i.column)
        } else {
            (0, 0)
        };
        self.deal();
        let last = &self.field;
        let was = |r: i64, c: i64| -> u64 {
            if self.inside(r, c) {
                last[self.index(r as u32, c as u32)]
            } else {
                0
            }
        };
        // a reading of nothing indeed: 10,000 on the lattice and in the readings,
        // which a reading collapsing, 10,000 on the lattice for a frame, is not
        let nothing = |r: i64, c: i64| -> bool {
            self.inside(r, c) && {
                let j = self.index(r as u32, c as u32);
                last[j] == NOTHING && self.readings[j] == NOTHING
            }
        };
        let mut next = vec![UNOBSERVED; last.len()];
        for r in 1..=n {
            for c in 1..=n {
                let k = self.index(r, c);
                let site = last[k];
                let reading = self.readings[k];
                let here = acted_row == Some(r)
                    && self.last_act[r as usize].is_some_and(|(column, _, _)| column == c);
                next[k] = if branched {
                    UNOBSERVED
                } else if here {
                    let (_, kind, _) = self.last_act[r as usize].expect("the act on its row");
                    match (kind, site) {
                        (Kind::Box, UNOBSERVED) => BOX,
                        (Kind::Box, BOX) => UNOBSERVED,
                        (Kind::Box, other) => other,
                        (Kind::Observe, UNOBSERVED) => reading,
                        (Kind::Collapse, UNOBSERVED) => UNOBSERVED,
                        (_, number) if (NOTHING + 1..=NOTHING + 8).contains(&number) => {
                            let boxes = AROUND
                                .iter()
                                .filter(|(dr, dc)| was(i64::from(r) + dr, i64::from(c) + dc) == BOX)
                                .count() as u64;
                            if boxes == number - NOTHING {
                                NOTHING
                            } else {
                                number
                            }
                        }
                        (_, other) => other,
                    }
                } else if site == UNOBSERVED {
                    let opened = AROUND
                        .iter()
                        .any(|(dr, dc)| was(i64::from(r) + dr, i64::from(c) + dc) == NOTHING);
                    if opened {
                        reading
                    } else {
                        UNOBSERVED
                    }
                } else if site == BOX {
                    // a box beside a reading of nothing opens: nothing has decayed
                    // beside nothing (CART.12's hand test); beside a collapse, whose
                    // reading trusts its boxes, it stays
                    let opened = AROUND
                        .iter()
                        .any(|(dr, dc)| nothing(i64::from(r) + dr, i64::from(c) + dc));
                    if opened {
                        reading
                    } else {
                        BOX
                    }
                } else if site == NOTHING {
                    reading
                } else {
                    site
                };
            }
        }
        self.field = next;
    }

    /// The neighbors of a site that stand on the lattice, as indices.
    fn around(&self, i: usize) -> impl Iterator<Item = usize> + '_ {
        let n = i64::from(self.n);
        let (r, c) = ((i as i64) / n, (i as i64) % n);
        AROUND.iter().filter_map(move |(dr, dc)| {
            let (rr, cc) = (r + dr, c + dc);
            ((0..n).contains(&rr) && (0..n).contains(&cc)).then_some((rr * n + cc) as usize)
        })
    }

    /// Whether a site stands beside an observed reading of one to eight.
    fn beside_reading(&self, i: usize) -> bool {
        self.around(i)
            .any(|j| (NOTHING + 1..=NOTHING + 8).contains(&self.field[j]))
    }

    /// The sites a move may be made on, row by row (`Player`), each by its
    /// index: its row the index over n, plus 1, and its column the rest,
    /// plus 1.
    pub fn candidates(&self, kind: Move) -> Vec<usize> {
        let mut out = Vec::new();
        for (i, &site) in self.field.iter().enumerate() {
            let takes = match kind {
                Move::Deal => false,
                Move::Frontier => site == UNOBSERVED && !self.decays[i] && self.beside_reading(i),
                Move::Box | Move::Trip => {
                    site == UNOBSERVED && self.decays[i] && self.beside_reading(i)
                }
                Move::Collapse => {
                    (NOTHING + 1..=NOTHING + 8).contains(&site)
                        && self.around(i).filter(|&j| self.field[j] == BOX).count() as u64
                            == site - NOTHING
                        && self.around(i).any(|j| self.field[j] == UNOBSERVED)
                }
                Move::Jump => site == UNOBSERVED && !self.decays[i],
                Move::Open => site == BOX,
            };
            if takes {
                out.push(i);
            }
        }
        out
    }

    /// The site where a world's first observation opens the deepest cascade
    /// (`CART.12`, decision 3), in the world as last dealt: the largest
    /// cluster of readings of nothing, its sites joined through their eight
    /// neighbors, the first found row by row among clusters of a size; and
    /// the site at an end of its widest path, which two breadth-first sweeps
    /// find, the site the first sweep, from the cluster's first site, reaches
    /// deepest. Its row and column, the cluster's sites, and the depth of the
    /// second sweep, from the site to the far end, the rings its cascade
    /// opens. A reading of nothing has no decay in its 3 by 3, so the deal
    /// clears nothing and the world stays as dealt.
    pub fn deepest(&self) -> Option<Deal> {
        let sites = self.field.len();
        let mut seen = vec![false; sites];
        let mut queue = Vec::with_capacity(sites);
        let (mut zeros, mut first) = (0, 0);
        for start in 0..sites {
            if self.readings[start] != NOTHING || seen[start] {
                continue;
            }
            seen[start] = true;
            queue.clear();
            queue.push(start);
            let mut head = 0;
            while head < queue.len() {
                let i = queue[head];
                head += 1;
                for j in self.around(i) {
                    if self.readings[j] == NOTHING && !seen[j] {
                        seen[j] = true;
                        queue.push(j);
                    }
                }
            }
            if queue.len() > zeros {
                zeros = queue.len();
                first = start;
            }
        }
        if zeros == 0 {
            return None;
        }
        let (end, _) = self.sweep(first);
        let (_, rings) = self.sweep(end);
        let n = self.n as usize;
        Some(Deal {
            row: (end / n) as u32 + 1,
            column: (end % n) as u32 + 1,
            zeros,
            rings,
        })
    }

    /// A breadth-first sweep through readings of nothing from one site: the
    /// site it reaches deepest, the first row by row among those, and its
    /// depth.
    fn sweep(&self, from: usize) -> (usize, usize) {
        let mut depth = vec![usize::MAX; self.field.len()];
        let mut queue = vec![from];
        depth[from] = 0;
        let (mut far, mut deepest) = (from, 0);
        let mut head = 0;
        while head < queue.len() {
            let i = queue[head];
            head += 1;
            let d = depth[i];
            if d > deepest || (d == deepest && i < far) {
                (far, deepest) = (i, d);
            }
            for j in self.around(i) {
                if self.readings[j] == NOTHING && depth[j] == usize::MAX {
                    depth[j] = d + 1;
                    queue.push(j);
                }
            }
        }
        (far, deepest)
    }
}

/// Where a world's deepest cascade is dealt (`Lattice::deepest`).
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Deal {
    pub row: u32,
    pub column: u32,
    /// The sites of the largest cluster of readings of nothing.
    pub zeros: usize,
    /// The depth from the deal to the cluster's far end.
    pub rings: usize,
}

/// What a scripted act does (`Player`).
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub enum Move {
    /// The first observation of a world, anywhere on the lattice.
    Deal,
    /// A safe site beside an observed reading, observed.
    Frontier,
    /// A decayed site beside an observed reading, boxed.
    Box,
    /// A reading whose boxes equal it, beside a site in superposition,
    /// collapsed.
    Collapse,
    /// A decayed site beside an observed reading, observed: a trip.
    Trip,
    /// A safe site anywhere in superposition, observed.
    Jump,
    /// A box opened.
    Open,
}

impl Move {
    /// Every move, in the order a session's lines name them.
    pub const ALL: [Move; 7] = [
        Move::Deal,
        Move::Frontier,
        Move::Box,
        Move::Collapse,
        Move::Trip,
        Move::Jump,
        Move::Open,
    ];

    /// The move in words, for a session's lines.
    pub fn words(self) -> &'static str {
        match self {
            Move::Deal => "the deal, a world's first observation",
            Move::Frontier => "a safe site on the frontier observed",
            Move::Box => "a decay on the frontier boxed",
            Move::Collapse => "a reading its boxes satisfy collapsed",
            Move::Trip => "a decay on the frontier observed, a trip",
            Move::Jump => "a safe site anywhere observed, a jump",
            Move::Open => "a box opened",
        }
    }

    /// The act it is made by: an observation, a box or a collapse.
    fn kind(self) -> Kind {
        match self {
            Move::Box | Move::Open => Kind::Box,
            Move::Collapse => Kind::Collapse,
            _ => Kind::Observe,
        }
    }
}

/// The floors' scripted player (`CART.12`, decision 8): a player who knows
/// the lattice, as the scoping's session played one. The first act of a
/// world observes a site anywhere, the deal. Every later act is drawn: six
/// in ten a safe site on the frontier, beside an observed reading; three in
/// twenty a decay there boxed; one in ten a reading its boxes satisfy
/// collapsed, beside a site still in superposition; and one in twenty each a
/// trip, a decay on the frontier observed, a jump, a safe site anywhere
/// observed, and a box opened. A move with no site falls to the frontier,
/// then to a jump. Its site is drawn from the move's sites row by row, and
/// it is made by its button or by its command, each half the time. The
/// draws are a Lehmer generator's, MINSTD's, x = 48,271 x modulo 2^31 - 1,
/// each product under 2^47, which a double holds exactly, so that the
/// page's hand plays the same acts.
pub struct Player {
    state: u64,
}

/// MINSTD's modulus, `2^31 - 1`.
const MODULUS: u64 = 2_147_483_647;

impl Player {
    /// A player whose draws begin from a seed, 1 for a seed of 0.
    pub fn new(seed: u64) -> Player {
        let s = seed % MODULUS;
        Player {
            state: if s == 0 { 1 } else { s },
        }
    }

    /// A draw under n.
    fn draw(&mut self, n: u64) -> u64 {
        self.state = self.state * 48_271 % MODULUS;
        self.state % n
    }

    /// The next act on the lattice as the last frame left it: its move and its
    /// Input rows, on the Field.
    pub fn act(&mut self, l: &Lattice) -> (Move, Inputs) {
        let n = u64::from(l.n);
        if l.first == (0, 0) {
            let row = 1 + self.draw(n) as u32;
            let column = 1 + self.draw(n) as u32;
            let by_command = self.draw(2) == 1;
            return (Move::Deal, made(row, column, Kind::Observe, by_command));
        }
        let wanted = match self.draw(100) {
            0..=59 => Move::Frontier,
            60..=74 => Move::Box,
            75..=84 => Move::Collapse,
            85..=89 => Move::Trip,
            90..=94 => Move::Jump,
            _ => Move::Open,
        };
        for kind in [wanted, Move::Frontier, Move::Jump] {
            let sites = l.candidates(kind);
            if sites.is_empty() {
                continue;
            }
            let i = sites[self.draw(sites.len() as u64) as usize] as u32;
            let by_command = self.draw(2) == 1;
            return (
                kind,
                made(i / l.n + 1, i % l.n + 1, kind.kind(), by_command),
            );
        }
        // every safe site observed: the first site observed again, which
        // changes nothing
        (Move::Jump, made(1, 1, Kind::Observe, false))
    }
}

/// An act's Input rows on the Field: its place, and its button or its
/// command.
fn made(row: u32, column: u32, kind: Kind, by_command: bool) -> Inputs {
    let mut i = Inputs {
        column,
        row,
        sheet: "Field".to_string(),
        ..Inputs::default()
    };
    match (kind, by_command) {
        (Kind::Observe, false) => i.left = true,
        (Kind::Box, false) => i.right = true,
        (Kind::Collapse, false) => i.middle = true,
        (Kind::Observe, true) => i.command = "observe".to_string(),
        (Kind::Box, true) => i.command = "box".to_string(),
        (Kind::Collapse, true) => i.command = "collapse".to_string(),
    }
    i
}

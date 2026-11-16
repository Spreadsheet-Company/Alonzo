//! Seiyaku by hand (`CART.14`; `docs/REARVIEW.md`, the item's scoping,
//! decisions 7, 9 and 14): the puzzle of `cartridges/seiyaku/seiyaku.vla`
//! written a second time, in Rust, the way a person keeps it, and the tools
//! that write its book.
//!
//! - *The solvers.* Two counters of a puzzle's solutions, written apart so
//!   that each holds the other: backtracking over bits, the variable of fewest
//!   values first, and exact cover, Knuth's Algorithm X over the puzzle's 324
//!   constraints and 729 choices.
//! - *The grader.* The three techniques of the roadmap's line, the simplest
//!   that progresses at each step: 1 a naked single, 2 a hidden single, 3 a
//!   pointing pair; a puzzle's grade is the hardest it needs, or 4 when the
//!   three stall.
//! - *The generator.* A full grid by backtracking with the values in a drawn
//!   order, then givens dug in pairs under a half turn, each pair kept out
//!   while the solution stays one; integers alone and a fixed seed, so the
//!   book's bytes are the same on every machine. `engine/examples/seiyaku.rs`
//!   writes the book into the source's block between its two markers.
//! - *The board by hand.* The instance a transform of its book puzzle by the
//!   seed and the instance's number, and every frame of a session computed
//!   from the Input rows as the engine's frame sees them, sharing no formula
//!   with the cartridge: its values, its marks' texts and its Constraints
//!   sheet's values; since `CART.14.1`'s second slice the ladder, the
//!   grader's three techniques an inference a frame, its strikes, the
//!   assignments it made, and its words; and since its third the light, what
//!   the Board lights while the ladder is asked and the rules each variable
//!   is lit by.
//!
//! The engine's tests compile it as a module of the crate for the tests
//! alone; the book's writer includes the same file by its path.

/// The hash's prime, `2^26 - 5`, Life's (`cartridges/life`) and Superposition's.
pub const P: u64 = 67_108_859;

/// The generator's seed: the book is the same on every machine.
pub const BOOK_SEED: u64 = 20_261_019;

/// The puzzles of a grade in the book.
pub const PER_GRADE: usize = 32;

/// The book's block in the source: these two lines and the lines between
/// them, which the book's writer writes.
pub const BOOK_BEGIN: &str = "; ---- the book, written by cargo run --release --example seiyaku: edit the generator, never these lines ----";
pub const BOOK_END: &str = "; ---- the book's end ----";

/// The figure space, a digit's width: a struck mark's place in a cell.
pub fn figure_space() -> char {
    char::from_u32(0x2007).expect("the figure space")
}

/// What an emptied domain shows while the light names it, the empty set
/// (`CART.14.1`'s third slice, decision 10).
pub const EMPTY_DOMAIN: &str = "\u{2205}";

/// The rules over the Board, by priority (`CART.14.1`'s third slice): the
/// satisfied board's two, by box, each stopping the rest; the inference's
/// place; a violation or an emptied domain; a reason; an assignment.
pub const RULE_SATISFIED_ODD: u32 = 1;
pub const RULE_SATISFIED_EVEN: u32 = 2;
pub const RULE_PLACE: u32 = 3;
pub const RULE_RED: u32 = 4;
pub const RULE_REASON: u32 = 5;
pub const RULE_ASSIGNED: u32 = 6;

/// A puzzle or a board: 81 values, row by row, 0 an empty variable.
pub type Board = [u8; 81];

/// A puzzle read from its line: 81 characters, a digit a given and a dot an
/// empty variable.
pub fn parse(line: &str) -> Option<Board> {
    let chars: Vec<char> = line.chars().collect();
    if chars.len() != 81 {
        return None;
    }
    let mut b = [0u8; 81];
    for (i, ch) in chars.iter().enumerate() {
        b[i] = match ch {
            '.' => 0,
            '1'..='9' => *ch as u8 - b'0',
            _ => return None,
        };
    }
    Some(b)
}

/// A puzzle's line.
pub fn spell(b: &Board) -> String {
    b.iter()
        .map(|&v| if v == 0 { '.' } else { char::from(b'0' + v) })
        .collect()
}

/// A variable's row, column and box, each from 0.
fn units_of(i: usize) -> (usize, usize, usize) {
    let (r, c) = (i / 9, i % 9);
    (r, c, (r / 3) * 3 + c / 3)
}

// ---- the first solver: backtracking over bits ----------------------------

/// The values each row, column and box holds, a bit a value.
struct Bits {
    rows: [u16; 9],
    cols: [u16; 9],
    boxes: [u16; 9],
}

impl Bits {
    /// The puzzle's values as bits, or `None` where two givens repeat a value
    /// in a unit.
    fn of(g: &Board) -> Option<Bits> {
        let mut b = Bits {
            rows: [0; 9],
            cols: [0; 9],
            boxes: [0; 9],
        };
        for (i, &v) in g.iter().enumerate() {
            if v > 0 {
                let (r, c, x) = units_of(i);
                let m = 1u16 << v;
                if (b.rows[r] | b.cols[c] | b.boxes[x]) & m != 0 {
                    return None;
                }
                b.flip(r, c, x, m);
            }
        }
        Some(b)
    }

    fn flip(&mut self, r: usize, c: usize, x: usize, m: u16) {
        self.rows[r] ^= m;
        self.cols[c] ^= m;
        self.boxes[x] ^= m;
    }

    /// The values a variable may still take, a bit a value.
    fn free(&self, r: usize, c: usize, x: usize) -> u16 {
        !(self.rows[r] | self.cols[c] | self.boxes[x]) & 0x3FE
    }
}

/// The solutions counted to a limit, and the first found.
fn backtrack(g: &mut Board, b: &mut Bits, limit: u32, found: &mut u32, first: &mut Option<Board>) {
    let mut best = (10u32, 81usize, 0u16);
    for (i, &v) in g.iter().enumerate() {
        if v == 0 {
            let (r, c, x) = units_of(i);
            let m = b.free(r, c, x);
            let n = m.count_ones();
            if n < best.0 {
                best = (n, i, m);
                if n <= 1 {
                    break;
                }
            }
        }
    }
    if best.1 == 81 {
        *found += 1;
        if first.is_none() {
            *first = Some(*g);
        }
        return;
    }
    let (r, c, x) = units_of(best.1);
    let mut m = best.2;
    while m != 0 {
        let v = m.trailing_zeros() as u8;
        m &= m - 1;
        let bit = 1u16 << v;
        g[best.1] = v;
        b.flip(r, c, x, bit);
        backtrack(g, b, limit, found, first);
        b.flip(r, c, x, bit);
        g[best.1] = 0;
        if *found >= limit {
            return;
        }
    }
}

/// A puzzle's solutions counted to a limit, by backtracking over bits.
pub fn count_by_bits(puzzle: &Board, limit: u32) -> u32 {
    let mut g = *puzzle;
    let Some(mut b) = Bits::of(&g) else {
        return 0;
    };
    let (mut found, mut first) = (0, None);
    backtrack(&mut g, &mut b, limit, &mut found, &mut first);
    found
}

/// A puzzle's first solution by backtracking, the values tried in order.
pub fn solve(puzzle: &Board) -> Option<Board> {
    let mut g = *puzzle;
    let mut b = Bits::of(&g)?;
    let (mut found, mut first) = (0, None);
    backtrack(&mut g, &mut b, 1, &mut found, &mut first);
    first
}

// ---- the second solver: exact cover --------------------------------------

/// A choice, a variable and a value, `81 r + 9 c + v` with `v` from 0, and
/// the four constraints it meets: its cell, its row's value, its column's
/// value and its box's value.
fn constraints_of(k: usize) -> [usize; 4] {
    let (r, c, v) = (k / 81, (k / 9) % 9, k % 9);
    let x = (r / 3) * 3 + c / 3;
    [9 * r + c, 81 + 9 * r + v, 162 + 9 * c + v, 243 + 9 * x + v]
}

/// Algorithm X over the 324 constraints: a constraint open or met, a choice
/// alive or struck, and two stacks to put them back.
struct Cover {
    choices: Vec<Vec<usize>>,
    alive: Vec<bool>,
    open: Vec<bool>,
    struck: Vec<usize>,
    met: Vec<usize>,
}

impl Cover {
    fn new() -> Cover {
        let mut choices = vec![Vec::new(); 324];
        for k in 0..729 {
            for col in constraints_of(k) {
                choices[col].push(k);
            }
        }
        Cover {
            choices,
            alive: vec![true; 729],
            open: vec![true; 324],
            struck: Vec::new(),
            met: Vec::new(),
        }
    }

    /// A choice made: its four constraints met, and every choice that meets
    /// one of them struck. Answers the stacks' heights to put back to.
    fn choose(&mut self, k: usize) -> (usize, usize) {
        let marks = (self.struck.len(), self.met.len());
        for col in constraints_of(k) {
            self.open[col] = false;
            self.met.push(col);
            for j in 0..self.choices[col].len() {
                let other = self.choices[col][j];
                if self.alive[other] {
                    self.alive[other] = false;
                    self.struck.push(other);
                }
            }
        }
        marks
    }

    fn put_back(&mut self, marks: (usize, usize)) {
        while self.struck.len() > marks.0 {
            let k = self.struck.pop().expect("a struck choice");
            self.alive[k] = true;
        }
        while self.met.len() > marks.1 {
            let col = self.met.pop().expect("a met constraint");
            self.open[col] = true;
        }
    }

    fn count(&mut self, limit: u32, found: &mut u32) {
        let mut best: Option<(usize, usize)> = None;
        for col in 0..324 {
            if !self.open[col] {
                continue;
            }
            let n = self.choices[col].iter().filter(|&&k| self.alive[k]).count();
            if best.map_or(true, |(m, _)| n < m) {
                best = Some((n, col));
                if n == 0 {
                    break;
                }
            }
        }
        let Some((n, col)) = best else {
            *found += 1;
            return;
        };
        if n == 0 {
            return;
        }
        let options: Vec<usize> = self.choices[col]
            .iter()
            .copied()
            .filter(|&k| self.alive[k])
            .collect();
        for k in options {
            let marks = self.choose(k);
            self.count(limit, found);
            self.put_back(marks);
            if *found >= limit {
                return;
            }
        }
    }
}

/// A puzzle's solutions counted to a limit, by exact cover.
pub fn count_by_cover(puzzle: &Board, limit: u32) -> u32 {
    let mut cover = Cover::new();
    for (i, &v) in puzzle.iter().enumerate() {
        if v > 0 {
            let k = 9 * i + usize::from(v - 1);
            if !cover.alive[k] {
                return 0;
            }
            cover.choose(k);
        }
    }
    let mut found = 0;
    cover.count(limit, &mut found);
    found
}

// ---- the grader -----------------------------------------------------------

/// The 27 units, rows, columns and boxes, each its nine variables.
fn units() -> Vec<[usize; 9]> {
    let mut u = Vec::with_capacity(27);
    for r in 0..9 {
        u.push(std::array::from_fn(|c| 9 * r + c));
    }
    for c in 0..9 {
        u.push(std::array::from_fn(|r| 9 * r + c));
    }
    for x in 0..9 {
        let (r0, c0) = ((x / 3) * 3, (x % 3) * 3);
        u.push(std::array::from_fn(|k| 9 * (r0 + k / 3) + c0 + k % 3));
    }
    u
}

/// A puzzle's grade: the hardest of the three techniques it needs, the
/// simplest that progresses taken at each step, or 4 when the three stall.
/// Each technique only ever strikes a value or places one, and every
/// technique that applies still applies after another has, so the grade is
/// the least set of techniques that solves the puzzle, whatever their order.
pub fn grade(puzzle: &Board) -> u8 {
    let units = units();
    let peers: Vec<Vec<usize>> = (0..81)
        .map(|i| {
            let (r, c, x) = units_of(i);
            (0..81)
                .filter(|&k| {
                    let (r2, c2, x2) = units_of(k);
                    k != i && (r2 == r || c2 == c || x2 == x)
                })
                .collect()
        })
        .collect();
    let mut g = *puzzle;
    let mut free = [0u16; 81];
    for i in 0..81 {
        free[i] = if g[i] == 0 { 0x3FE } else { 0 };
    }
    for i in 0..81 {
        if g[i] > 0 {
            for &p in &peers[i] {
                free[p] &= !(1 << g[i]);
            }
        }
    }
    let place = |g: &mut Board, free: &mut [u16; 81], i: usize, v: u8| {
        g[i] = v;
        free[i] = 0;
        for &p in &peers[i] {
            free[p] &= !(1 << v);
        }
    };
    let mut hardest = 0u8;
    'step: loop {
        if g.iter().all(|&v| v > 0) {
            return hardest.max(1);
        }
        // 1: a naked single, a variable with one value left
        if let Some(i) = (0..81).find(|&i| g[i] == 0 && free[i].count_ones() == 1) {
            let v = free[i].trailing_zeros() as u8;
            place(&mut g, &mut free, i, v);
            hardest = hardest.max(1);
            continue;
        }
        // 2: a hidden single, a value with one place left in a unit
        for u in &units {
            for v in 1..=9u8 {
                let places: Vec<usize> = u
                    .iter()
                    .copied()
                    .filter(|&i| free[i] & (1 << v) != 0)
                    .collect();
                if places.len() == 1 {
                    place(&mut g, &mut free, places[0], v);
                    hardest = hardest.max(2);
                    continue 'step;
                }
            }
        }
        // 3: a pointing pair or triple, a box's places for a value on one
        // line, the value struck from the rest of that line
        for u in &units[18..] {
            for v in 1..=9u8 {
                let places: Vec<usize> = u
                    .iter()
                    .copied()
                    .filter(|&i| free[i] & (1 << v) != 0)
                    .collect();
                if places.len() < 2 {
                    continue;
                }
                let (r0, c0) = (places[0] / 9, places[0] % 9);
                let line: Option<Vec<usize>> = if places.iter().all(|&i| i / 9 == r0) {
                    Some((0..9).map(|c| 9 * r0 + c).collect())
                } else if places.iter().all(|&i| i % 9 == c0) {
                    Some((0..9).map(|r| 9 * r + c0).collect())
                } else {
                    None
                };
                let Some(line) = line else {
                    continue;
                };
                let mut struck = false;
                for i in line {
                    if !places.contains(&i) && free[i] & (1 << v) != 0 {
                        free[i] &= !(1 << v);
                        struck = true;
                    }
                }
                if struck {
                    hardest = hardest.max(3);
                    continue 'step;
                }
            }
        }
        return 4;
    }
}

// ---- the generator ----------------------------------------------------------

/// The generator's draws: xorshift64*, its state never 0.
pub struct Generator(u64);

impl Generator {
    pub fn new(seed: u64) -> Generator {
        Generator(seed.max(1))
    }

    fn next(&mut self) -> u64 {
        self.0 ^= self.0 >> 12;
        self.0 ^= self.0 << 25;
        self.0 ^= self.0 >> 27;
        self.0.wrapping_mul(0x2545_F491_4F6C_DD1D)
    }

    fn below(&mut self, n: usize) -> usize {
        (self.next() % n as u64) as usize
    }

    /// A full grid: backtracking from the first variable, the values tried in
    /// a drawn order at each.
    pub fn full(&mut self) -> Board {
        fn fill(g: &mut Board, b: &mut Bits, i: usize, draw: &mut Generator) -> bool {
            if i == 81 {
                return true;
            }
            let mut order = [1u8, 2, 3, 4, 5, 6, 7, 8, 9];
            for k in (1..9).rev() {
                let j = draw.below(k + 1);
                order.swap(k, j);
            }
            let (r, c, x) = units_of(i);
            let free = b.free(r, c, x);
            for v in order {
                let bit = 1u16 << v;
                if free & bit != 0 {
                    g[i] = v;
                    b.flip(r, c, x, bit);
                    if fill(g, b, i + 1, draw) {
                        return true;
                    }
                    b.flip(r, c, x, bit);
                    g[i] = 0;
                }
            }
            false
        }
        let mut g = [0u8; 81];
        let mut b = Bits::of(&g).expect("an empty grid");
        assert!(fill(&mut g, &mut b, 0, self), "a full grid exists");
        g
    }

    /// The givens dug from a solution: variables taken out in pairs under a
    /// half turn, in a drawn order, each pair kept out while the solution
    /// stays one.
    pub fn dig(&mut self, solution: &Board) -> Board {
        let mut g = *solution;
        let mut order: Vec<usize> = (0..81).collect();
        for k in (1..81).rev() {
            let j = self.below(k + 1);
            order.swap(k, j);
        }
        for i in order {
            if g[i] == 0 {
                continue;
            }
            let j = 80 - i;
            let (a, b) = (g[i], g[j]);
            g[i] = 0;
            g[j] = 0;
            if count_by_bits(&g, 2) != 1 {
                g[i] = a;
                g[j] = b;
            }
        }
        g
    }
}

/// The book: puzzles generated in order and each kept in its grade's block
/// until every block holds `per_grade`, the blocks in the order of their
/// grades. Each with its grade.
pub fn write_book(seed: u64, per_grade: usize) -> Vec<(Board, u8)> {
    let mut blocks: [Vec<Board>; 4] = Default::default();
    let mut draw = Generator::new(seed);
    while blocks.iter().any(|b| b.len() < per_grade) {
        let solution = draw.full();
        let puzzle = draw.dig(&solution);
        let block = &mut blocks[usize::from(grade(&puzzle) - 1)];
        if block.len() < per_grade {
            block.push(puzzle);
        }
    }
    let mut book = Vec::with_capacity(4 * per_grade);
    for (k, block) in blocks.iter().enumerate() {
        for p in block {
            book.push((*p, k as u8 + 1));
        }
    }
    book
}

/// The book's lines between its two markers: one call of the kit's picture,
/// a puzzle a row of the hidden Book sheet, each line its puzzle's 81
/// characters and a comment of its number, its grade and its givens.
pub fn book_lines(book: &[(Board, u8)]) -> Vec<String> {
    let mut lines = vec!["(picture \"Book\" \"A1\" hex".to_string()];
    for (n, (p, g)) in book.iter().enumerate() {
        let givens = p.iter().filter(|&&v| v > 0).count();
        lines.push(format!(
            "  \"{}\" ; {}, grade {g}, {givens} givens",
            spell(p),
            n + 1
        ));
    }
    lines.push("  )".to_string());
    lines
}

/// The source with its book's block written again: the lines between the two
/// markers replaced, each line ending as the source's do. `None` for a source
/// without both markers, in order.
pub fn with_book(source: &str, book: &[(Board, u8)]) -> Option<String> {
    let eol = if source.contains("\r\n") {
        "\r\n"
    } else {
        "\n"
    };
    let lines: Vec<&str> = source.split(eol).collect();
    let begin = lines.iter().position(|l| *l == BOOK_BEGIN)?;
    let end = lines.iter().position(|l| *l == BOOK_END)?;
    if end <= begin {
        return None;
    }
    let mut out: Vec<String> = lines[..=begin].iter().map(|l| l.to_string()).collect();
    out.extend(book_lines(book));
    out.extend(lines[end..].iter().map(|l| l.to_string()));
    Some(out.join(eol))
}

/// The book's puzzles as the source's block holds them, in order.
pub fn book_of(source: &str) -> Vec<Board> {
    let mut inside = false;
    let mut book = Vec::new();
    for line in source.lines() {
        let line = line.trim_end_matches('\r');
        if line == BOOK_BEGIN {
            inside = true;
        } else if line == BOOK_END {
            break;
        } else if inside {
            if let Some(rest) = line.trim_start().strip_prefix('"') {
                let text = rest.split('"').next().unwrap_or("");
                book.push(parse(text).unwrap_or_else(|| panic!("a puzzle of the book: {line}")));
            }
        }
    }
    book
}

// ---- the transforms -----------------------------------------------------------

/// The Deal sheet's hash of a row: Life's soup hash over the seed, the
/// instance and the row, two linear forms modulo the prime multiplied.
pub fn hash(seed: u64, instance: u64, row: u64) -> u64 {
    let a = (seed * 1_103_515 + instance * 7_919 + row * 1_597_334 + 3_440_100) % P;
    let b = (seed * 2_012_345 + instance * 104_729 + row * 1_209_487 + 3_213_021) % P;
    (a * b) % P
}

/// An instance's puzzle and its transform: the book's row it reads, whether
/// it is transposed, each row's and each column's source, a row's band and
/// its place in it permuted, a column's stack and its place too, and each
/// value relabeled.
#[derive(Clone, Debug, PartialEq)]
pub struct Deal {
    pub puzzle: usize,
    pub transposed: bool,
    pub sigma: [usize; 9],
    pub tau: [usize; 9],
    pub pi: [u8; 10],
}

/// An instance dealt: its puzzle the one its grade's block of the book the
/// hash names, and each permutation the ranks of keys hashed from the seed and
/// the instance, a key the hash times 64 and its row, so that no two are
/// equal (the Deal sheet's rows 10 to 44).
pub fn deal(seed: u64, instance: u64, grade: u8) -> Deal {
    let key = |row: u64| hash(seed, instance, row) * 64 + row;
    let rank =
        |row: u64, first: u64, last: u64| 1 + (first..=last).filter(|&j| key(j) < key(row)).count();
    let puzzle = PER_GRADE * usize::from(grade - 1)
        + 1
        + (hash(seed, instance, 10) % PER_GRADE as u64) as usize;
    let transposed = hash(seed, instance, 44) % 2 == 1;
    let mut sigma = [0usize; 9];
    let mut tau = [0usize; 9];
    for r in 1..=9u64 {
        let band = (r - 1) / 3;
        let rows = 23 + 3 * band;
        sigma[r as usize - 1] = 3 * (rank(20 + band, 20, 22) - 1) + rank(22 + r, rows, rows + 2);
        let cols = 35 + 3 * band;
        tau[r as usize - 1] = 3 * (rank(32 + band, 32, 34) - 1) + rank(34 + r, cols, cols + 2);
    }
    let mut pi = [0u8; 10];
    for v in 1..=9u64 {
        pi[v as usize] = rank(10 + v, 11, 19) as u8;
    }
    Deal {
        puzzle,
        transposed,
        sigma,
        tau,
        pi,
    }
}

impl Deal {
    /// The instance's givens: each variable's source in the puzzle, its row's
    /// and its column's, swapped when transposed, and its value relabeled.
    pub fn givens(&self, book: &[Board]) -> Board {
        let p = &book[self.puzzle - 1];
        let mut g = [0u8; 81];
        for r in 0..9 {
            for c in 0..9 {
                let k = if self.transposed {
                    (self.sigma[c] - 1) * 9 + self.tau[r]
                } else {
                    (self.sigma[r] - 1) * 9 + self.tau[c]
                };
                let v = p[k - 1];
                g[9 * r + c] = if v == 0 { 0 } else { self.pi[usize::from(v)] };
            }
        }
        g
    }
}

// ---- the board by hand -------------------------------------------------------

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

/// What a variable of the Board shows: a code, or its marks' text.
#[derive(Clone, Debug, PartialEq)]
pub enum Shown {
    Number(f64),
    Text(String),
}

/// The grades' words, as the Constraints sheet says them.
pub const GRADES: [&str; 4] = [
    "naked singles",
    "hidden singles",
    "pointing pairs",
    "beyond the three",
];

/// The ladder's next inference, or why there is none (`CART.14.1`'s second
/// slice): the Ladder sheet's `B1` to `B9` and its words, `B21`.
#[derive(Clone, Debug, Default, PartialEq)]
pub struct Inference {
    /// 0 none, 1 a naked single, 2 a hidden single, 3 a pointing.
    pub kind: u8,
    /// The value assigned or struck, 1 to 9, or 0.
    pub value: u8,
    /// The variable an assignment takes, 1 to 81, or 0.
    pub place: usize,
    /// A pointing's box, 1 to 9, whether its line is a column, and the line,
    /// 1 to 9.
    pub boxed: u8,
    pub down: bool,
    pub line: u8,
    /// A hidden single's constraint, the rows 1 to 9, the columns 10 to 18
    /// and the boxes 19 to 27, which the light reads; else 0.
    pub unit: usize,
    /// Why there is none: 0 there is one, 1 satisfied, 2 a violated
    /// constraint, 3 an emptied domain, 4 a value with no place in a
    /// constraint, 5 nothing the three techniques infer.
    pub stop: u8,
    /// The words the Board shows under it while they are lit.
    pub words: String,
}

/// The board, by hand.
pub struct Seiyaku {
    pub book: Vec<Board>,
    pub seed: u64,
    /// The acts begun, the load's among them: the Clock's frame.
    pub clock: u64,
    /// The Lab's counts: the acts of this instance, the instances dealt, the
    /// restarts, the next instance's grade and this one's.
    pub acts: u64,
    pub instances: u64,
    pub restarts: u64,
    pub next_grade: u8,
    pub grade: u8,
    pub satisfied: bool,
    pub satisfied_acts: u64,
    pub deal: Option<Deal>,
    pub givens: Board,
    pub entries: Board,
    pub marks: [u16; 81],
    pub grid: Board,
    /// Each row's, column's and box's count of each value.
    pub row_counts: [[u8; 10]; 9],
    pub col_counts: [[u8; 10]; 9],
    pub box_counts: [[u8; 10]; 9],
    pub violated: [bool; 81],
    /// The values the constraints still allow, less those struck, a bit a
    /// value as the marks are.
    pub candidates: [u16; 81],
    /// The ladder's (`CART.14.1`'s second slice): each variable's strikes, a
    /// bit a value; the variables inference assigned; the words lit, a
    /// propagation running, the marks filtered; and the inference this
    /// frame names, which the next applies.
    pub struck: [u16; 81],
    pub inferred: [bool; 81],
    pub lit: bool,
    pub propagating: bool,
    pub filtered: bool,
    pub ladder: Inference,
}

/// The value a command names after its prefix, 1 to 9, or 0.
fn value_of(command: &str, prefix: &str) -> u8 {
    match command.strip_prefix(prefix) {
        Some(d) if d.len() == 1 => match d.as_bytes()[0] {
            b @ b'1'..=b'9' => b - b'0',
            _ => 0,
        },
        _ => 0,
    }
}

/// A variable's address as the Board's headers show it, the Board standing
/// from `B2`: the variable 1 is `B2`, the variable 81 `J10`.
pub fn address_of(place: usize) -> String {
    let (r, c) = ((place - 1) / 9, (place - 1) % 9);
    format!("{}{}", char::from(b'B' + c as u8), r + 2)
}

/// n and the words for one or for many.
fn counted(n: usize, one: &str, many: &str) -> String {
    format!("{n} {}", if n == 1 { one } else { many })
}

/// Each unit's places left for each value, from the candidates: the rows',
/// the columns' and the boxes', and a line's inside a box, a row's in each
/// stack and a column's in each band.
struct Open {
    rows: [[u8; 10]; 9],
    cols: [[u8; 10]; 9],
    boxes: [[u8; 10]; 9],
    across: [[[u8; 3]; 9]; 10],
    down: [[[u8; 3]; 9]; 10],
}

impl Open {
    fn of(grid: &Board, candidates: &[u16; 81]) -> Open {
        let mut o = Open {
            rows: [[0; 10]; 9],
            cols: [[0; 10]; 9],
            boxes: [[0; 10]; 9],
            across: [[[0; 3]; 9]; 10],
            down: [[[0; 3]; 9]; 10],
        };
        for k in 0..81 {
            if grid[k] > 0 {
                continue;
            }
            let (r, c, x) = units_of(k);
            for v in 1..=9usize {
                if candidates[k] & (1 << (v - 1)) != 0 {
                    o.rows[r][v] += 1;
                    o.cols[c][v] += 1;
                    o.boxes[x][v] += 1;
                    o.across[v][r][c / 3] += 1;
                    o.down[v][c][r / 3] += 1;
                }
            }
        }
        o
    }
}

impl Seiyaku {
    /// The board as loaded: no act yet.
    pub fn new(book: Vec<Board>, seed: u64) -> Seiyaku {
        Seiyaku {
            book,
            seed,
            clock: 0,
            acts: 0,
            instances: 0,
            restarts: 0,
            next_grade: 0,
            grade: 0,
            satisfied: false,
            satisfied_acts: 0,
            deal: None,
            givens: [0; 81],
            entries: [0; 81],
            marks: [0; 81],
            grid: [0; 81],
            row_counts: [[0; 10]; 9],
            col_counts: [[0; 10]; 9],
            box_counts: [[0; 10]; 9],
            violated: [false; 81],
            candidates: [0; 81],
            struck: [0; 81],
            inferred: [false; 81],
            lit: false,
            propagating: false,
            filtered: false,
            ladder: Inference::default(),
        }
    }

    /// One frame: an act's when `begins_act`, its inputs the act's rows, and
    /// a settle step's else, its inputs the released ones.
    pub fn frame(&mut self, i: &Inputs, begins_act: bool) {
        if begins_act {
            self.clock += 1;
        }
        let first = self.clock == 1;
        let cmd = i.command.as_str();
        let act = i.left || i.right || i.middle || !cmd.is_empty();
        let instances = self.instances + u64::from(cmd == "instance");
        let restarts = self.restarts + u64::from(cmd == "retract-all");
        let dealt = instances != self.instances;
        let reset = dealt || restarts != self.restarts;
        let next_grade = if first {
            2
        } else if cmd == "grade" {
            self.next_grade % 4 + 1
        } else {
            self.next_grade
        };
        let grade = if first || dealt {
            next_grade
        } else {
            self.grade
        };
        let acts = if reset { 0 } else { self.acts + u64::from(act) };
        // the ladder's switches, the Lab's B13 to B18: the words lit by infer or propagate and put
        // out by any other command; a propagation running while the last frame named an inference;
        // that inference applied, an assignment or a strike; the marks filtered
        let asked = cmd == "infer" || cmd == "propagate";
        let lit = if asked {
            true
        } else if !cmd.is_empty() {
            false
        } else {
            self.lit
        };
        let named = self.ladder.kind > 0;
        let propagating = cmd == "propagate" || (self.propagating && named);
        let applied = named && (propagating || (cmd == "infer" && self.lit));
        let assigns = applied && self.ladder.kind < 3;
        let strikes = applied && self.ladder.kind == 3;
        let filtered = if first {
            false
        } else if cmd == "filter" {
            !self.filtered
        } else {
            self.filtered
        };
        // the person's value and place, which an inference that assigns takes the place of
        let marked = value_of(cmd, "domain-");
        let retract = cmd == "retract";
        let domains = cmd == "domains";
        let undo = cmd == "retract-inferred";
        // the Board stands from B2, a margin row and column before it (the owner's second look at
        // `ENGINE.28`'s third slice): a place is a variable on B2:J10
        let on_board = |n: u32| (2..=10).contains(&n);
        let (assigned, place) = if assigns {
            (self.ladder.value, self.ladder.place)
        } else {
            let place = if i.sheet == "Board" && on_board(i.column) && on_board(i.row) {
                ((i.row - 2) * 9 + i.column - 1) as usize
            } else {
                0
            };
            (value_of(cmd, "assign-"), place)
        };
        let deal = deal(self.seed, instances, grade);
        let givens = deal.givens(&self.book);
        let mut entries = [0u8; 81];
        for k in 0..81 {
            let last = self.entries[k];
            entries[k] = if reset || givens[k] > 0 || (undo && self.inferred[k]) {
                0
            } else if place == k + 1 {
                if assigned > 0 {
                    assigned
                } else if retract {
                    0
                } else {
                    last
                }
            } else {
                last
            };
        }
        let mut inferred = [false; 81];
        for k in 0..81 {
            inferred[k] = if reset || entries[k] == 0 {
                false
            } else if assigns && place == k + 1 {
                true
            } else if entries[k] != self.entries[k] {
                false
            } else {
                self.inferred[k]
            };
        }
        let mut grid = [0u8; 81];
        for k in 0..81 {
            grid[k] = givens[k] + entries[k];
        }
        let (mut rows, mut cols, mut boxes) = ([[0u8; 10]; 9], [[0u8; 10]; 9], [[0u8; 10]; 9]);
        for (k, &v) in grid.iter().enumerate() {
            if v > 0 {
                let (r, c, x) = units_of(k);
                rows[r][usize::from(v)] += 1;
                cols[c][usize::from(v)] += 1;
                boxes[x][usize::from(v)] += 1;
            }
        }
        // the strikes (decision 7): cleared by a restart, a new instance, or any variable assigned
        // at the last frame holding another value or none; else a pointing applied strikes its
        // value from every unassigned variable on its line outside its box
        let cleared =
            reset || (0..81).any(|k| self.entries[k] > 0 && entries[k] != self.entries[k]);
        let mut struck = [0u16; 81];
        for k in 0..81 {
            let (r, c, x) = units_of(k);
            let on_line = if self.ladder.down {
                c + 1 == usize::from(self.ladder.line)
            } else {
                r + 1 == usize::from(self.ladder.line)
            };
            let last = self.struck[k];
            struck[k] = if cleared {
                0
            } else if strikes && grid[k] == 0 && on_line && x + 1 != usize::from(self.ladder.boxed)
            {
                last | (1 << (self.ladder.value - 1))
            } else {
                last
            };
        }
        let mut violated = [false; 81];
        let mut candidates = [0u16; 81];
        for k in 0..81 {
            let (r, c, x) = units_of(k);
            let v = usize::from(grid[k]);
            violated[k] = v > 0 && (rows[r][v] > 1 || cols[c][v] > 1 || boxes[x][v] > 1);
            if grid[k] == 0 {
                for w in 1..=9 {
                    if rows[r][w] == 0 && cols[c][w] == 0 && boxes[x][w] == 0 {
                        candidates[k] |= 1 << (w - 1);
                    }
                }
                candidates[k] &= !struck[k];
            }
        }
        let mut marks = [0u16; 81];
        for k in 0..81 {
            let last = self.marks[k];
            marks[k] = if reset || givens[k] > 0 {
                0
            } else if domains {
                if entries[k] > 0 {
                    last
                } else {
                    candidates[k]
                }
            } else if place == k + 1 {
                if marked > 0 && entries[k] == 0 {
                    last ^ (1 << (marked - 1))
                } else if retract && self.entries[k] == 0 {
                    0
                } else {
                    last
                }
            } else {
                last
            };
        }
        let filled = grid.iter().filter(|&&v| v > 0).count();
        let satisfied = filled == 81 && !violated.iter().any(|&b| b);
        self.satisfied_acts = if satisfied {
            if self.satisfied {
                self.satisfied_acts
            } else {
                acts
            }
        } else {
            0
        };
        let ladder = Self::infer(
            &grid,
            &candidates,
            [&rows, &cols, &boxes],
            &violated,
            satisfied,
        );
        self.acts = acts;
        self.instances = instances;
        self.restarts = restarts;
        self.next_grade = next_grade;
        self.grade = grade;
        self.satisfied = satisfied;
        self.deal = Some(deal);
        self.givens = givens;
        self.entries = entries;
        self.marks = marks;
        self.grid = grid;
        self.row_counts = rows;
        self.col_counts = cols;
        self.box_counts = boxes;
        self.violated = violated;
        self.candidates = candidates;
        self.struck = struck;
        self.inferred = inferred;
        self.lit = lit;
        self.propagating = propagating;
        self.filtered = filtered;
        self.ladder = ladder;
    }

    /// The next inference on a board, in the grader's order (`grade`): a
    /// contradiction or the board satisfied first, which stops the ladder;
    /// then the first naked single by variable, the first hidden single by
    /// unit, rows, columns and boxes, and value, and the first pointing by
    /// box and value, a row before a column; or none.
    pub fn infer(
        grid: &Board,
        candidates: &[u16; 81],
        counts: [&[[u8; 10]; 9]; 3],
        violated: &[bool; 81],
        satisfied: bool,
    ) -> Inference {
        let open = Open::of(grid, candidates);
        let naked = (0..81).find(|&k| candidates[k].count_ones() == 1);
        let units = units();
        let mut hidden = None;
        'units: for (u, unit) in units.iter().enumerate() {
            let places = match u / 9 {
                0 => &open.rows[u],
                1 => &open.cols[u - 9],
                _ => &open.boxes[u - 18],
            };
            for v in 1..=9u8 {
                if places[usize::from(v)] == 1 {
                    let k = unit
                        .iter()
                        .copied()
                        .find(|&k| candidates[k] & (1 << (v - 1)) != 0)
                        .expect("a place counted");
                    hidden = Some((u + 1, v, k));
                    break 'units;
                }
            }
        }
        let mut pointing = None;
        'boxes: for b in 0..9 {
            let (band, stack) = (b / 3, b % 3);
            for v in 1..=9usize {
                let n = open.boxes[b][v];
                if n < 2 {
                    continue;
                }
                for r in 3 * band..3 * band + 3 {
                    if open.across[v][r][stack] == n && open.rows[r][v] > n {
                        pointing = Some((b + 1, v as u8, false, r + 1));
                        break 'boxes;
                    }
                }
                for c in 3 * stack..3 * stack + 3 {
                    if open.down[v][c][band] == n && open.cols[c][v] > n {
                        pointing = Some((b + 1, v as u8, true, c + 1));
                        break 'boxes;
                    }
                }
            }
        }
        let violations = violated.iter().filter(|&&b| b).count();
        let emptied = (0..81)
            .filter(|&k| grid[k] == 0 && candidates[k] == 0)
            .count();
        let tables = [&open.rows, &open.cols, &open.boxes];
        let no_place: usize = (0..3)
            .map(|t| {
                (0..9)
                    .map(|j| {
                        (1..=9)
                            .filter(|&v| tables[t][j][v] == 0 && counts[t][j][v] == 0)
                            .count()
                    })
                    .sum::<usize>()
            })
            .sum();
        let any = naked.is_some() || hidden.is_some() || pointing.is_some();
        let stop = if satisfied {
            1
        } else if violations > 0 {
            2
        } else if emptied > 0 {
            3
        } else if no_place > 0 {
            4
        } else if any {
            0
        } else {
            5
        };
        let mut i = Inference {
            stop,
            ..Inference::default()
        };
        let left = grid.iter().filter(|&&v| v == 0).count();
        if stop > 0 {
            i.words = match stop {
                1 => "Satisfied: nothing is left to infer.".to_string(),
                2 => format!(
                    "Nothing to infer: {} a constraint.",
                    counted(violations, "variable violates", "variables violate")
                ),
                3 => format!(
                    "Nothing to infer: {}",
                    counted(
                        emptied,
                        "variable has no value left in its domain.",
                        "variables have no value left in their domains."
                    )
                ),
                4 => format!(
                    "Nothing to infer: {} no place left in a constraint.",
                    counted(no_place, "value has", "values have")
                ),
                _ => format!("Nothing the three techniques can infer: {left} variables left."),
            };
        } else if let Some(k) = naked {
            i.kind = 1;
            i.value = candidates[k].trailing_zeros() as u8 + 1;
            i.place = k + 1;
            i.words = format!(
                "{} is {}: the only value left in its domain.",
                address_of(i.place),
                i.value
            );
        } else if let Some((u, v, k)) = hidden {
            i.kind = 2;
            i.value = v;
            i.place = k + 1;
            i.unit = u;
            let named = match (u - 1) / 9 {
                0 => "row",
                1 => "column",
                _ => "box",
            };
            i.words = format!(
                "{} is {v}: the only place left for it in its {named}.",
                address_of(i.place)
            );
        } else if let Some((b, v, down, line)) = pointing {
            i.kind = 3;
            i.value = v;
            i.boxed = b as u8;
            i.down = down;
            i.line = line as u8;
            let named = if down {
                format!("column {}", char::from(b'A' + line as u8))
            } else {
                format!("row {}", line + 1)
            };
            let first = 9 * (3 * ((b - 1) / 3)) + 3 * ((b - 1) % 3) + 1;
            i.words = format!(
                "{v} is struck from the rest of {named}: in the box from {}, every place left for it is on that line.",
                address_of(first)
            );
        }
        i
    }

    /// The marks a variable draws: all of them, or, filtered, those still
    /// candidates (decision 13).
    pub fn drawn(&self, k: usize) -> u16 {
        if self.filtered {
            self.marks[k] & self.candidates[k]
        } else {
            self.marks[k]
        }
    }

    /// A variable's light, the Light sheet's (`CART.14.1`'s third slice,
    /// decisions 10 and 11): 0 none; 1 a reason, a variable the inference is
    /// read by; 2 the inference's place, the variable a single assigns or a
    /// place a pointing strikes its value from; 3 an emptied domain. A naked
    /// single is read by its assigned neighbors, a hidden single by its
    /// constraint whole and every variable holding its value, a pointing by
    /// its box whole and every variable holding its value; all of it only
    /// while the ladder is asked.
    pub fn light(&self, k: usize) -> u8 {
        if !self.lit {
            return 0;
        }
        if self.grid[k] == 0 && self.candidates[k] == 0 {
            return 3;
        }
        let i = &self.ladder;
        let (r, c, x) = units_of(k);
        let place = match i.kind {
            1 | 2 => k + 1 == i.place,
            3 => {
                let on_line = if i.down {
                    c + 1 == usize::from(i.line)
                } else {
                    r + 1 == usize::from(i.line)
                };
                self.grid[k] == 0
                    && on_line
                    && x + 1 != usize::from(i.boxed)
                    && self.candidates[k] & (1 << (i.value - 1)) != 0
            }
            _ => false,
        };
        if place {
            return 2;
        }
        let holding = self.grid[k] > 0 && self.grid[k] == i.value;
        let reason = match i.kind {
            1 => {
                let (pr, pc, px) = units_of(i.place - 1);
                self.grid[k] > 0 && (r == pr || c == pc || x == px)
            }
            2 => {
                let within = match (i.unit - 1) / 9 {
                    0 => r + 1 == i.unit,
                    1 => c + 10 == i.unit,
                    _ => x + 19 == i.unit,
                };
                within || holding
            }
            3 => x + 1 == usize::from(i.boxed) || holding,
            _ => false,
        };
        u8::from(reason)
    }

    /// The rules a variable at row and column from 1 is lit by, in priority
    /// order up to the first that stops, as the record's `lit` row names them:
    /// the satisfied board's, by box, alone; else the inference's place, a
    /// violation or an emptied domain, a reason and an assignment, each where
    /// it holds.
    pub fn lit_rules(&self, row: u32, column: u32) -> Vec<u32> {
        let k = ((row - 1) * 9 + (column - 1)) as usize;
        if self.satisfied {
            let parity = ((row - 1) / 3 + (column - 1) / 3) % 2;
            return vec![if parity == 0 {
                RULE_SATISFIED_ODD
            } else {
                RULE_SATISFIED_EVEN
            }];
        }
        let light = self.light(k);
        let mut lit = Vec::new();
        if light == 2 {
            lit.push(RULE_PLACE);
        }
        if self.violated[k] || light == 3 {
            lit.push(RULE_RED);
        }
        if light == 1 {
            lit.push(RULE_REASON);
        }
        if self.grid[k] > 0 && self.givens[k] == 0 {
            lit.push(RULE_ASSIGNED);
        }
        lit
    }

    /// What the Board shows at row and column from 1: a variable's value, and
    /// since `CART.14.1`'s third slice, while the light names it, a single's
    /// value at the variable it assigns before it is applied and an emptied
    /// domain's ∅; else the marks drawn, a digit or a figure space in each of
    /// nine places, a line of three with three figure spaces between them,
    /// and two line feeds between two lines, so that each mark stands in its
    /// third of the cell (the owner's hand tests, 2026-10-19 and `ENGINE.28`'s
    /// of 2026-10-29; the line feeds since `CART.14.1`'s second slice, by
    /// `ENGINE.36`). A code stood for a value until the third slice: 100 times
    /// its kind, 10 times its box's parity and the value.
    pub fn shown(&self, row: u32, column: u32) -> Shown {
        let k = ((row - 1) * 9 + (column - 1)) as usize;
        let v = self.grid[k];
        if v > 0 {
            return Shown::Number(f64::from(v));
        }
        match self.light(k) {
            2 if self.ladder.kind < 3 => return Shown::Number(f64::from(self.ladder.value)),
            3 => return Shown::Text(EMPTY_DOMAIN.to_string()),
            _ => {}
        }
        let m = self.drawn(k);
        if m == 0 {
            return Shown::Text(String::new());
        }
        let fs = figure_space();
        let place = |d: u8| {
            if m & (1 << (d - 1)) != 0 {
                char::from(b'0' + d)
            } else {
                fs
            }
        };
        let within: String = [fs; 3].iter().collect();
        let lines: Vec<String> = [1u8, 4, 7]
            .iter()
            .map(|&d| {
                format!(
                    "{}{within}{}{within}{}",
                    place(d),
                    place(d + 1),
                    place(d + 2)
                )
            })
            .collect();
        Shown::Text(lines.join("\n\n"))
    }

    /// The words under the Board, `B11`: the ladder's while lit.
    pub fn words(&self) -> String {
        if self.lit {
            self.ladder.words.clone()
        } else {
            String::new()
        }
    }

    /// The givens of the instance.
    pub fn given_count(&self) -> usize {
        self.givens.iter().filter(|&&v| v > 0).count()
    }

    /// The variables assigned, the givens among them.
    pub fn filled(&self) -> usize {
        self.grid.iter().filter(|&&v| v > 0).count()
    }

    /// The variables inference assigned.
    pub fn inferred_count(&self) -> usize {
        self.inferred.iter().filter(|&&b| b).count()
    }

    /// The constraints violated: each row, column and box with a value twice.
    pub fn violated_constraints(&self) -> usize {
        let twice =
            |counts: &[[u8; 10]; 9]| counts.iter().filter(|u| u.iter().any(|&n| n > 1)).count();
        twice(&self.row_counts) + twice(&self.col_counts) + twice(&self.box_counts)
    }

    /// The marks kept, every variable's.
    pub fn marks_kept(&self) -> u32 {
        self.marks.iter().map(|m| m.count_ones()).sum()
    }

    /// A constraint's state: violated, satisfied or open, as the sheet says it.
    pub fn state(counts: &[u8; 10]) -> &'static str {
        if counts.iter().any(|&n| n > 1) {
            "violated"
        } else if counts.iter().map(|&n| u32::from(n)).sum::<u32>() == 9 {
            "satisfied"
        } else {
            "open"
        }
    }

    /// The Constraints sheet's line of the instance satisfied, or not yet.
    pub fn satisfied_words(&self) -> String {
        if self.satisfied {
            format!("satisfied, in {} acts", self.satisfied_acts)
        } else {
            "not yet".to_string()
        }
    }
}

//! Naught: Vel et Aut by hand (`CART.9`; `docs/REARVIEW.md`, the item's
//! scoping, decisions 3 to 6 and 14): the netlists the cartridge's bench and
//! the floors' two fixtures are written from, their placements, the block of
//! the source that states them, and the netlist evaluated by hand. It shares
//! no formula with the cartridge: a gate here is a kind and two inputs, and
//! the hand computes it with Rust's own bits, so the engine's frames are held
//! to a netlist written twice.
//!
//! The engine's tests compile it as a module of the crate for the tests
//! alone; the block's writer, `examples/naught.rs`, and the native runner of
//! the floors, `examples/frames.rs`, include the same file by its path. The
//! page's hand, `cartridges/naught/naught.hand.js`, writes the same blocks
//! byte for byte, so that the module in the browser measures the rows the
//! runner measures.
//!
//! **The gates** are arithmetic over 0 and 1, named in Latin (decision 2):
//! NON `=1-a`, ET `=a*b`, VEL `=MAX(a,b)`, AUT `=MOD(a+b,2)`, NON-ET (NAND,
//! Sheffer's stroke) `=1-a*b` and NEC (NOR, Peirce's arrow) `=1-MAX(a,b)`.
//! The source writes each by a macro of its own, `(aut "C3:C18" "A3" "B3")`,
//! a cell or a fill and its inputs as the first cell reads them.
//!
//! **The circuits** (decision 1): an n-bit ripple-carry adder of five gates a
//! bit, `x = AUT(a,b)`, `g = ET(a,b)`, `p = ET(x,c)`, `c' = VEL(g,p)` and
//! `s = AUT(x,c)`, its carry-in a switch; and an n by n array multiplier, its
//! partial products, n - 1 rows of carry-save adders and a ripple of n bits.
//! A gate with a constant input folds into a wire or a NON, so the
//! multiplier's first row and last column are half adders. The bench lays
//! the adder from `A1`, a bit a row, its switches in columns A and B and its
//! carry-in at `F1`; and the multiplier from `I1`, its b-bus down column I
//! and its a-bus along row 1, read through mixed references, each of its
//! roles a block of n + 1 columns and a carry-save row a row. The bench a
//! person loads stands a row lower, from row [`BENCH_TOP`], its carry-in at
//! `F2` and its a-bus along row 2, so that row 1 names its columns: `a`, `b`
//! and each gate's Latin name over the adder's, the multiplier's a-bus and
//! each block's role, its b-bus and partial products in row 3 (the owner's
//! word at the second slice's hand test).
//!
//! **The placements** (decision 5): by fill, each role a rectangle of one
//! R1C1 text, written as one gate form; and shuffled, the same gates
//! permuted among the same cells by a fixed seed, then every gate whose R1C1
//! text another holds trading cells with one drawn at random until no two
//! hold one text, so that every gate is its own shape. The census the
//! language prints of either is the one [`Laid::census`] counts here.
//!
//! **The settle and the lesson.** The committed bench settles, `(settle
//! 65536)`, so that the page opens it on its values, and teaches itself on a
//! sheet of its own, the Lesson; the floors' fixtures leave both out
//! ([`floors_source`]), their switches reading the Clock as the frame.

use std::collections::HashMap;

/// The block of the source the example writes, between these two lines.
pub const BLOCK_BEGIN: &str =
    "; ---- the bench, written by cargo run --release --example naught: edit the generator, never these lines ----";
pub const BLOCK_END: &str = "; ---- the bench's end ----";

/// The sheet the bench stands on.
pub const SHEET: &str = "Bench";

/// The committed bench: a 16-bit adder and an 8 by 8 multiplier.
pub const BENCH: (usize, usize) = (16, 8);

/// The committed bench's top row (CART.9's hand test of the second slice, the
/// owner's word): row 1 above it names its columns, the gates in Latin. The
/// floors' benches stand from row 1, unnamed, so that their fixtures stay the
/// bytes both runs measured.
pub const BENCH_TOP: u32 = 2;

/// The floors' two fixtures (decision 6): a 4,096-bit adder and a 64 by 64
/// multiplier, laid by fill and shuffled.
pub const FLOORS: (usize, usize) = (4096, 64);

/// The shuffle's seed.
pub const SHUFFLE_SEED: u32 = 20_261_020;

/// A column's width in characters: a digit and its paddings.
pub const WIDTH: &str = "3";

/// A switch as a hash of the frame, so that about half the switches flip at
/// every frame (the floors' steady frame); [`stimulus`] computes it by hand.
pub const STIMULUS: &str = "=MOD(INT(MOD(MOD(ROW()*40503+COLUMN()*9973+Clock!$B$1*65519,65521)*MOD(ROW()*40503+COLUMN()*9973+Clock!$B$1*65519,65521),65521)/256),2)";

/// The least cells of one shape at one level the language evaluates at once
/// as a run (`vla-lang`'s `shape::RUN`).
pub const RUN: usize = 4;

// ---- the gates ----------------------------------------------------------------

/// A gate's kind, its Latin name the source's macro.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum Kind {
    Non,
    Et,
    Vel,
    Aut,
    NonEt,
    Nec,
}

impl Kind {
    pub const ALL: [Kind; 6] = [
        Kind::Non,
        Kind::Et,
        Kind::Vel,
        Kind::Aut,
        Kind::NonEt,
        Kind::Nec,
    ];

    /// The source's macro.
    pub fn word(self) -> &'static str {
        match self {
            Kind::Non => "non",
            Kind::Et => "et",
            Kind::Vel => "vel",
            Kind::Aut => "aut",
            Kind::NonEt => "non-et",
            Kind::Nec => "nec",
        }
    }

    /// Its inputs: one for NON, two for the others.
    pub fn arity(self) -> usize {
        if self == Kind::Non {
            1
        } else {
            2
        }
    }

    /// The gate computed by hand, over 0 and 1.
    pub fn apply(self, a: u8, b: u8) -> u8 {
        match self {
            Kind::Non => 1 - a,
            Kind::Et => a & b,
            Kind::Vel => a | b,
            Kind::Aut => a ^ b,
            Kind::NonEt => 1 - (a & b),
            Kind::Nec => 1 - (a | b),
        }
    }

    /// The formula's text, as the source's macro writes it.
    pub fn formula(self, x: &str, y: &str) -> String {
        match self {
            Kind::Non => format!("=1-{x}"),
            Kind::Et => format!("={x}*{y}"),
            Kind::Vel => format!("=MAX({x},{y})"),
            Kind::Aut => format!("=MOD({x}+{y},2)"),
            Kind::NonEt => format!("=1-{x}*{y}"),
            Kind::Nec => format!("=1-MAX({x},{y})"),
        }
    }
}

/// What a gate reads: a constant, a switch or a gate, each by its number.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Node {
    Zero,
    One,
    Switch(u32),
    Gate(u32),
}

/// A gate: its kind and its inputs, the second `Zero` for NON.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Gate {
    pub kind: Kind,
    pub a: Node,
    pub b: Node,
}

/// A circuit of the bench, its switches by number and its outputs, low bit
/// first.
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum Circuit {
    /// `a + b + carry`, n + 1 bits.
    Adder {
        bits: usize,
        a: Vec<u32>,
        b: Vec<u32>,
        carry: u32,
        sum: Vec<Node>,
    },
    /// `a × b`, 2n bits.
    Multiplier {
        bits: usize,
        a: Vec<u32>,
        b: Vec<u32>,
        product: Vec<Node>,
    },
}

// ---- the netlist --------------------------------------------------------------

/// The bench's netlist: its switches, each a cell and the mixed reference a
/// gate laid by fill reads it through, `(row held, column held)`; its gates,
/// in an order that puts every gate after what it reads, each with its cell
/// when laid by fill; its circuits; the row its circuits start from; and the
/// texts that name its columns, each a cell, where a row above them is free.
#[derive(Clone, Debug, Default)]
pub struct Net {
    pub switches: Vec<(u32, u32)>,
    pub buses: Vec<(bool, bool)>,
    pub gates: Vec<Gate>,
    pub home: Vec<(u32, u32)>,
    pub circuits: Vec<Circuit>,
    pub top: u32,
    pub labels: Vec<((u32, u32), &'static str)>,
}

impl Net {
    /// The bench: an adder of `adder` bits from `A1` and a multiplier of
    /// `multiplier` bits from `I1`, either left out at 0.
    pub fn bench(adder: usize, multiplier: usize) -> Net {
        Net::bench_from(adder, multiplier, 1)
    }

    /// The bench a person loads (CART.9's hand test of the second slice): the
    /// committed bench from row [`BENCH_TOP`], the row above it naming its
    /// columns.
    pub fn shown() -> Net {
        Net::bench_from(BENCH.0, BENCH.1, BENCH_TOP)
    }

    /// The bench from row `top`: its carry-in and its a-bus in that row, its
    /// bits below it; from row 2 on, the gates' Latin names and the switches'
    /// letters in the row above, and the multiplier's b-bus and partial
    /// products named in the row between its a-bus and them.
    pub fn bench_from(adder: usize, multiplier: usize, top: u32) -> Net {
        let mut net = Net {
            top,
            ..Net::default()
        };
        if adder > 0 {
            net.adder(adder, 1);
        }
        if multiplier > 0 {
            net.multiplier(multiplier, 9);
        }
        net
    }

    /// A text naming a column, written where the bench starts below row 1.
    fn label(&mut self, at: (u32, u32), word: &'static str) {
        if self.top > 1 {
            self.labels.push((at, word));
        }
    }

    fn switch(&mut self, at: (u32, u32), bus: (bool, bool)) -> Node {
        self.switches.push(at);
        self.buses.push(bus);
        Node::Switch(self.switches.len() as u32 - 1)
    }

    fn put(&mut self, kind: Kind, a: Node, b: Node, at: (u32, u32)) -> Node {
        self.gates.push(Gate { kind, a, b });
        self.home.push(at);
        Node::Gate(self.gates.len() as u32 - 1)
    }

    fn non(&mut self, a: Node, at: (u32, u32)) -> Node {
        match a {
            Node::Zero => Node::One,
            Node::One => Node::Zero,
            _ => self.put(Kind::Non, a, Node::Zero, at),
        }
    }

    fn et(&mut self, a: Node, b: Node, at: (u32, u32)) -> Node {
        match (a, b) {
            (Node::Zero, _) | (_, Node::Zero) => Node::Zero,
            (Node::One, x) | (x, Node::One) => x,
            _ => self.put(Kind::Et, a, b, at),
        }
    }

    fn vel(&mut self, a: Node, b: Node, at: (u32, u32)) -> Node {
        match (a, b) {
            (Node::One, _) | (_, Node::One) => Node::One,
            (Node::Zero, x) | (x, Node::Zero) => x,
            _ => self.put(Kind::Vel, a, b, at),
        }
    }

    fn aut(&mut self, a: Node, b: Node, at: (u32, u32)) -> Node {
        match (a, b) {
            (Node::Zero, x) | (x, Node::Zero) => x,
            (Node::One, x) | (x, Node::One) => self.non(x, at),
            _ => self.put(Kind::Aut, a, b, at),
        }
    }

    /// An n-bit ripple-carry adder whose switches stand in column `c0` and the
    /// next, a bit a row from the row below the top, its carry-in at the top
    /// row of its carry's column, and its five roles in the five columns after
    /// the switches, each named above.
    fn adder(&mut self, n: usize, c0: u32) {
        let top = self.top;
        let a: Vec<Node> = (0..n)
            .map(|i| self.switch((top + 1 + i as u32, c0), (false, false)))
            .collect();
        let b: Vec<Node> = (0..n)
            .map(|i| self.switch((top + 1 + i as u32, c0 + 1), (false, false)))
            .collect();
        let carry = self.switch((top, c0 + 5), (false, false));
        for (k, word) in ["a", "b", "AUT", "ET", "ET", "VEL", "AUT"]
            .into_iter()
            .enumerate()
        {
            self.label((top.saturating_sub(1), c0 + k as u32), word);
        }
        let index = |s: &[Node]| -> Vec<u32> {
            s.iter()
                .map(|n| match n {
                    Node::Switch(k) => *k,
                    _ => unreachable!("a switch"),
                })
                .collect()
        };
        let (ai, bi) = (index(&a), index(&b));
        let Node::Switch(ci) = carry else {
            unreachable!("a switch")
        };
        let mut c = carry;
        let mut sum = Vec::with_capacity(n + 1);
        for i in 0..n {
            let r = top + 1 + i as u32;
            let x = self.aut(a[i], b[i], (r, c0 + 2));
            let g = self.et(a[i], b[i], (r, c0 + 3));
            let p = self.et(x, c, (r, c0 + 4));
            let next = self.vel(g, p, (r, c0 + 5));
            let s = self.aut(x, c, (r, c0 + 6));
            sum.push(s);
            c = next;
        }
        sum.push(c);
        self.circuits.push(Circuit::Adder {
            bits: n,
            a: ai,
            b: bi,
            carry: ci,
            sum,
        });
    }

    /// An n by n array multiplier from column `m0`: its b-bus down that
    /// column from two rows below the top, its a-bus along the top row over
    /// its partial products, each of its roles a block of n + 1 columns, a
    /// carry-save row a row, and the ripple the blocks' last row; each bus
    /// and block named above it.
    fn multiplier(&mut self, n: usize, m0: u32) {
        let top = self.top;
        let r0 = top + 2;
        let cpp = m0 + 1;
        let w = n as u32 + 1;
        let (cx, cg, cp, cc, cs) = (cpp + w, cpp + 2 * w, cpp + 3 * w, cpp + 4 * w, cpp + 5 * w);
        let a: Vec<Node> = (0..n)
            .map(|j| self.switch((top, cpp + j as u32), (true, false)))
            .collect();
        let above = top.saturating_sub(1);
        for (at, word) in [
            ((above, cpp), "a"),
            ((top + 1, m0), "b"),
            ((top + 1, cpp), "ET"),
            ((above, cx), "AUT"),
            ((above, cg), "ET"),
            ((above, cp), "ET"),
            ((above, cc), "VEL"),
            ((above, cs), "AUT"),
        ] {
            self.label(at, word);
        }
        let b: Vec<Node> = (0..n)
            .map(|i| self.switch((r0 + i as u32, m0), (false, true)))
            .collect();
        let numbers = |s: &[Node]| -> Vec<u32> {
            s.iter()
                .map(|n| match n {
                    Node::Switch(k) => *k,
                    _ => unreachable!("a switch"),
                })
                .collect()
        };
        let (ai, bi) = (numbers(&a), numbers(&b));
        let mut pp = vec![vec![Node::Zero; n]; n];
        for (i, row) in pp.iter_mut().enumerate() {
            for (j, cell) in row.iter_mut().enumerate() {
                *cell = self.et(a[j], b[i], (r0 + i as u32, cpp + j as u32));
            }
        }
        let mut product = vec![Node::Zero; 2 * n];
        product[0] = pp[0][0];
        let mut sums: Vec<Node> = pp[0].clone();
        let mut carries: Vec<Node> = vec![Node::Zero; n];
        for (i, row) in pp.iter().enumerate().skip(1) {
            let r = r0 + i as u32;
            let mut next_sums = vec![Node::Zero; n];
            let mut next_carries = vec![Node::Zero; n];
            for j in 0..n {
                let c = j as u32;
                let y = if j + 1 < n { sums[j + 1] } else { Node::Zero };
                let z = carries[j];
                let x = self.aut(row[j], y, (r, cx + c));
                let g = self.et(row[j], y, (r, cg + c));
                let p = self.et(x, z, (r, cp + c));
                next_carries[j] = self.vel(g, p, (r, cc + c));
                next_sums[j] = self.aut(x, z, (r, cs + c));
            }
            product[i] = next_sums[0];
            sums = next_sums;
            carries = next_carries;
        }
        let rf = r0 + n as u32;
        let mut k = Node::Zero;
        for j in 0..n {
            let c = j as u32;
            let u = if j + 1 < n { sums[j + 1] } else { Node::Zero };
            let v = carries[j];
            let x = self.aut(u, v, (rf, cx + c));
            let g = self.et(u, v, (rf, cg + c));
            let p = self.et(x, k, (rf, cp + c));
            let next = self.vel(g, p, (rf, cc + c));
            product[n + j] = self.aut(x, k, (rf, cs + c));
            k = next;
        }
        self.circuits.push(Circuit::Multiplier {
            bits: n,
            a: ai,
            b: bi,
            product,
        });
    }

    /// A node's value, the switches' and the gates' given.
    pub fn value(&self, node: Node, switches: &[u8], gates: &[u8]) -> u8 {
        match node {
            Node::Zero => 0,
            Node::One => 1,
            Node::Switch(k) => switches[k as usize],
            Node::Gate(k) => gates[k as usize],
        }
    }

    /// Every gate's value at full rate: the netlist computed inside one
    /// frame, in the order its gates were made.
    pub fn evaluate(&self, switches: &[u8]) -> Vec<u8> {
        let mut gates = vec![0u8; self.gates.len()];
        for (k, g) in self.gates.iter().enumerate() {
            let a = self.value(g.a, switches, &gates);
            let b = self.value(g.b, switches, &gates);
            gates[k] = g.kind.apply(a, b);
        }
        gates
    }

    /// One gate delay, the teacher's rate: every gate computed from the
    /// values the last frame left, the switches' and the gates' alike.
    pub fn delay(&self, last_switches: &[u8], last: &[u8]) -> Vec<u8> {
        self.gates
            .iter()
            .map(|g| {
                g.kind.apply(
                    self.value(g.a, last_switches, last),
                    self.value(g.b, last_switches, last),
                )
            })
            .collect()
    }

    /// Each circuit's outputs read as a whole number, held to integer + and
    /// × of its switches.
    pub fn check(&self, switches: &[u8], gates: &[u8]) -> Result<(), String> {
        let bits = |ks: &[u32]| -> Vec<u8> { ks.iter().map(|&k| switches[k as usize]).collect() };
        let out = |ns: &[Node]| -> Vec<u8> {
            ns.iter().map(|&n| self.value(n, switches, gates)).collect()
        };
        for c in &self.circuits {
            let (got, want, what) = match c {
                Circuit::Adder {
                    bits: n,
                    a,
                    b,
                    carry,
                    sum,
                } => (
                    limbs(&out(sum)),
                    add(
                        &limbs(&bits(a)),
                        &limbs(&bits(b)),
                        u64::from(switches[*carry as usize]),
                    ),
                    format!("the {n}-bit adder"),
                ),
                Circuit::Multiplier {
                    bits: n,
                    a,
                    b,
                    product,
                } => (
                    limbs(&out(product)),
                    multiply(&limbs(&bits(a)), &limbs(&bits(b))),
                    format!("the {n} by {n} multiplier"),
                ),
            };
            if trim(got) != trim(want) {
                return Err(format!("{what}'s outputs are not the integer answer"));
            }
        }
        Ok(())
    }

    /// The netlist's depth: the levels of gates reading gates, plus one.
    pub fn depth(&self) -> usize {
        let mut level = vec![0usize; self.gates.len()];
        let mut deepest = 0;
        for (k, g) in self.gates.iter().enumerate() {
            let of = |n: Node| match n {
                Node::Gate(j) => level[j as usize] + 1,
                _ => 0,
            };
            level[k] = of(g.a).max(of(g.b));
            deepest = deepest.max(level[k]);
        }
        deepest + usize::from(!self.gates.is_empty())
    }
}

// ---- the integers ----------------------------------------------------------------

/// Bits, low first, as 64-bit limbs, low first.
pub fn limbs(bits: &[u8]) -> Vec<u64> {
    let mut out = vec![0u64; bits.len().div_ceil(64) + 1];
    for (i, &b) in bits.iter().enumerate() {
        out[i / 64] |= u64::from(b) << (i % 64);
    }
    out
}

fn add(a: &[u64], b: &[u64], carry: u64) -> Vec<u64> {
    let n = a.len().max(b.len()) + 1;
    let mut out = vec![0u64; n];
    let mut c = u128::from(carry);
    for (i, slot) in out.iter_mut().enumerate() {
        let s = u128::from(*a.get(i).unwrap_or(&0)) + u128::from(*b.get(i).unwrap_or(&0)) + c;
        *slot = s as u64;
        c = s >> 64;
    }
    out
}

fn multiply(a: &[u64], b: &[u64]) -> Vec<u64> {
    let mut out = vec![0u64; a.len() + b.len() + 1];
    for (i, &x) in a.iter().enumerate() {
        let mut carry = 0u128;
        for (j, &y) in b.iter().enumerate() {
            let t = u128::from(out[i + j]) + u128::from(x) * u128::from(y) + carry;
            out[i + j] = t as u64;
            carry = t >> 64;
        }
        let mut k = i + b.len();
        while carry > 0 {
            let t = u128::from(out[k]) + carry;
            out[k] = t as u64;
            carry = t >> 64;
            k += 1;
        }
    }
    out
}

fn trim(mut v: Vec<u64>) -> Vec<u64> {
    while v.last() == Some(&0) {
        v.pop();
    }
    v
}

// ---- the dice -----------------------------------------------------------------

/// Mulberry32, a 32-bit generator the page's hand computes alike with
/// `Math.imul`.
#[derive(Clone, Debug)]
pub struct Dice(pub u32);

impl Dice {
    pub fn next(&mut self) -> u32 {
        self.0 = self.0.wrapping_add(0x6D2B_79F5);
        let a = self.0;
        let mut t = (a ^ (a >> 15)).wrapping_mul(a | 1);
        t = t.wrapping_add((t ^ (t >> 7)).wrapping_mul(t | 61)) ^ t;
        t ^ (t >> 14)
    }

    /// A whole number below `n`, by multiplying and shifting, which the page
    /// computes exactly for `n` under 2^21.
    pub fn below(&mut self, n: usize) -> usize {
        ((u64::from(self.next()) * n as u64) >> 32) as usize
    }
}

// ---- the cells and the block ----------------------------------------------------

/// How the gates are laid (decision 5).
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Lay {
    /// Each role a rectangle of one R1C1 text, written as one gate form.
    Fill,
    /// The same gates in the same cells, permuted, every gate its own shape.
    Shuffled,
}

/// What a switch holds: a value a person writes, or a hash of the frame.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Switches {
    Values,
    Stimulus,
}

/// Where a gate reads its inputs: in the frame (full rate), or in the last
/// frame's twin, a gate delay a frame (the teacher's rate, decision 8).
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Wiring {
    Now,
    Last,
}

/// A column's letters.
pub fn letters(mut c: u32) -> String {
    let mut s = Vec::new();
    while c > 0 {
        s.push(b'A' + ((c - 1) % 26) as u8);
        c = (c - 1) / 26;
    }
    s.reverse();
    String::from_utf8(s).expect("ASCII")
}

/// A cell's address, each `$` where it is held.
pub fn a1(row: u32, col: u32, row_held: bool, col_held: bool) -> String {
    format!(
        "{}{}{}{row}",
        if col_held { "$" } else { "" },
        letters(col),
        if row_held { "$" } else { "" }
    )
}

/// The article before a number said aloud: "an" before eight, eleven,
/// eighteen and eighty-odd, "a" before the rest.
fn article(n: usize) -> &'static str {
    let s = n.to_string();
    if s.starts_with('8') || n == 11 || n == 18 {
        "an"
    } else {
        "a"
    }
}

/// A rectangle's address, a cell where it is one.
fn range_text((top, left, bottom, right): (u32, u32, u32, u32)) -> String {
    if top == bottom && left == right {
        a1(top, left, false, false)
    } else {
        format!(
            "{}:{}",
            a1(top, left, false, false),
            a1(bottom, right, false, false)
        )
    }
}

/// Cells covered by rectangles: each row's runs of adjacent cells, then runs
/// of the same columns on consecutive rows merged; in the order of their
/// first cells.
pub fn rectangles(mut cells: Vec<(u32, u32)>) -> Vec<(u32, u32, u32, u32)> {
    cells.sort_unstable();
    let mut segments: Vec<(u32, u32, u32)> = Vec::new();
    for (r, c) in cells {
        if let Some(last) = segments.last_mut() {
            if last.0 == r && last.2 + 1 == c {
                last.2 = c;
                continue;
            }
        }
        segments.push((r, c, c));
    }
    let mut rects: Vec<(u32, u32, u32, u32)> = Vec::new();
    let mut open: HashMap<(u32, u32), usize> = HashMap::new();
    for (r, l, right) in segments {
        if let Some(&i) = open.get(&(l, right)) {
            if rects[i].2 + 1 == r {
                rects[i].2 = r;
                continue;
            }
        }
        rects.push((r, l, r, right));
        open.insert((l, right), rects.len() - 1);
    }
    rects.sort_unstable();
    rects
}

/// One formula row of the block: its rectangle, its R1C1 key, whether it is
/// a fill, and the gate whose form it writes, none for a switch's stimulus.
#[derive(Clone, Debug)]
pub struct Row {
    pub rect: (u32, u32, u32, u32),
    pub key: String,
    pub gate: Option<usize>,
}

impl Row {
    fn cells(&self) -> usize {
        let (t, l, b, r) = self.rect;
        ((b - t + 1) * (r - l + 1)) as usize
    }
}

/// The census the language prints of a laid netlist, counted here
/// (`KERNEL.30`): its plan row's numbers.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Census {
    pub shapes: usize,
    pub texts: usize,
    pub formulas: usize,
    pub levels: usize,
    pub runs: usize,
    pub lanes: usize,
    pub alone: usize,
}

impl Census {
    /// The plan row, as `describe` prints it.
    pub fn row(&self) -> String {
        format!(
            "(plan (shapes {}) (texts {}) (formulas {}) (levels {}) (runs {}) (lanes {}) (alone {}) (every-frame 0) (cycles 0))",
            self.shapes, self.texts, self.formulas, self.levels, self.runs, self.lanes, self.alone
        )
    }
}

/// A netlist laid in cells: each gate's cell, and how its switches and its
/// wires are written.
#[derive(Clone, Debug)]
pub struct Laid<'n> {
    pub net: &'n Net,
    pub cells: Vec<(u32, u32)>,
    pub lay: Lay,
    pub switches: Switches,
    pub wiring: Wiring,
}

impl<'n> Laid<'n> {
    /// The netlist laid: by fill at its gates' own cells; shuffled, those
    /// cells permuted by the seed, then every coincidence traded away.
    pub fn new(net: &'n Net, lay: Lay, switches: Switches, wiring: Wiring) -> Laid<'n> {
        let mut laid = Laid {
            net,
            cells: net.home.clone(),
            lay,
            switches,
            wiring,
        };
        if lay == Lay::Shuffled {
            let mut d = Dice(SHUFFLE_SEED);
            for i in (1..laid.cells.len()).rev() {
                let j = d.below(i + 1);
                laid.cells.swap(i, j);
            }
            // Every gate its own shape: a gate whose R1C1 text an earlier gate
            // holds trades cells with a gate drawn at random, until no two
            // hold one text (decision 5; Found 1 is what they would cost).
            loop {
                let mut seen: HashMap<String, usize> = HashMap::new();
                let mut clashes = Vec::new();
                for k in 0..laid.cells.len() {
                    if seen.insert(laid.key(k), k).is_some() {
                        clashes.push(k);
                    }
                }
                if clashes.is_empty() {
                    break;
                }
                for k in clashes {
                    let j = d.below(laid.cells.len());
                    laid.cells.swap(k, j);
                }
            }
        }
        laid
    }

    /// A gate's inputs, one for NON.
    fn inputs(&self, k: usize) -> Vec<Node> {
        let g = &self.net.gates[k];
        if g.kind.arity() == 1 {
            vec![g.a]
        } else {
            vec![g.a, g.b]
        }
    }

    /// Where a node stands, and the `$` a gate laid by fill reads it through.
    fn place(&self, node: Node) -> ((u32, u32), (bool, bool)) {
        match node {
            Node::Switch(k) => (
                self.net.switches[k as usize],
                if self.lay == Lay::Fill {
                    self.net.buses[k as usize]
                } else {
                    (false, false)
                },
            ),
            Node::Gate(k) => (self.cells[k as usize], (false, false)),
            other => unreachable!("a constant folded away reached a wire: {other:?}"),
        }
    }

    /// A gate's R1C1 key: its kind and each input's reference relative to its
    /// cell, or held where a `$` holds it, and the twin's name where it reads
    /// the last frame.
    pub fn key(&self, k: usize) -> String {
        let at = self.cells[k];
        let mut s = String::from(self.net.gates[k].kind.word());
        if self.wiring == Wiring::Last {
            s.push_str(" last");
        }
        for node in self.inputs(k) {
            let ((r, c), (rh, ch)) = self.place(node);
            let row = if rh {
                format!("R{r}")
            } else {
                format!("R[{}]", i64::from(r) - i64::from(at.0))
            };
            let col = if ch {
                format!("C{c}")
            } else {
                format!("C[{}]", i64::from(c) - i64::from(at.1))
            };
            s.push(' ');
            s.push_str(&row);
            s.push_str(&col);
        }
        s
    }

    /// A reference to a node as written, the twin's name before it where the
    /// gate reads the last frame.
    pub fn reference(&self, node: Node) -> String {
        let ((r, c), (rh, ch)) = self.place(node);
        let text = a1(r, c, rh, ch);
        match self.wiring {
            Wiring::Now => text,
            Wiring::Last => format!("{SHEET}.last!{text}"),
        }
    }

    /// The gate's formula, as its cell holds it.
    pub fn formula(&self, k: usize) -> String {
        let refs: Vec<String> = self
            .inputs(k)
            .into_iter()
            .map(|n| self.reference(n))
            .collect();
        let y = refs.get(1).cloned().unwrap_or_default();
        self.net.gates[k].kind.formula(&refs[0], &y)
    }

    /// The block's formula rows: the switches' stimulus, a rectangle a row,
    /// then the gates, each rectangle of one R1C1 text by fill, a cell a gate
    /// shuffled; in the order of their first cells.
    pub fn rows(&self) -> Vec<Row> {
        let mut rows = Vec::new();
        if self.switches == Switches::Stimulus {
            for rect in rectangles(self.net.switches.clone()) {
                rows.push(Row {
                    rect,
                    key: STIMULUS.to_string(),
                    gate: None,
                });
            }
        }
        let at: HashMap<(u32, u32), usize> = self
            .cells
            .iter()
            .enumerate()
            .map(|(k, &c)| (c, k))
            .collect();
        let mut gates = Vec::new();
        match self.lay {
            Lay::Fill => {
                let mut groups: HashMap<String, Vec<(u32, u32)>> = HashMap::new();
                for k in 0..self.cells.len() {
                    groups.entry(self.key(k)).or_default().push(self.cells[k]);
                }
                for (key, cells) in groups {
                    for rect in rectangles(cells) {
                        let k = at[&(rect.0, rect.1)];
                        gates.push(Row {
                            rect,
                            key: key.clone(),
                            gate: Some(k),
                        });
                    }
                }
            }
            Lay::Shuffled => {
                for (k, &(r, c)) in self.cells.iter().enumerate() {
                    gates.push(Row {
                        rect: (r, c, r, c),
                        key: self.key(k),
                        gate: Some(k),
                    });
                }
            }
        }
        gates.sort_unstable_by_key(|row| row.rect);
        rows.extend(gates);
        rows
    }

    /// The block's lines: what it holds, the bench's columns, its switches,
    /// then a gate form a row.
    pub fn block(&self) -> Vec<String> {
        let mut lines = Vec::new();
        let circuits: Vec<String> = self
            .net
            .circuits
            .iter()
            .map(|c| match c {
                Circuit::Adder { bits, .. } => {
                    format!("{} {bits}-bit ripple adder from A1", article(*bits))
                }
                Circuit::Multiplier { bits, .. } => {
                    format!("{} {bits} by {bits} multiplier from I1", article(*bits))
                }
            })
            .collect();
        lines.push(format!(
            "; {}: {} gates {}, their switches {}",
            circuits.join(" and "),
            self.net.gates.len(),
            match self.lay {
                Lay::Fill => "laid by fill",
                Lay::Shuffled => "shuffled, every gate its own shape",
            },
            match self.switches {
                Switches::Values => "values",
                Switches::Stimulus => "a hash of the frame",
            }
        ));
        let mut columns: Vec<u32> = self
            .net
            .switches
            .iter()
            .chain(&self.cells)
            .map(|&(_, c)| c)
            .collect();
        columns.sort_unstable();
        columns.dedup();
        for c in columns {
            lines.push(format!(
                "(column \"{SHEET}\" \"{}\" {WIDTH} shown none)",
                letters(c)
            ));
        }
        let mut labels = self.net.labels.clone();
        labels.sort_unstable();
        for ((r, c), word) in labels {
            lines.push(format!(
                "(cell \"{SHEET}\" \"{}\" \"{word}\")",
                a1(r, c, false, false)
            ));
        }
        if self.switches == Switches::Values {
            for rect in rectangles(self.net.switches.clone()) {
                lines.push(format!("(cell \"{SHEET}\" \"{}\" 0)", range_text(rect)));
            }
        }
        for row in self.rows() {
            match row.gate {
                None => lines.push(format!(
                    "(formula \"{SHEET}\" \"{}\" \"{STIMULUS}\")",
                    range_text(row.rect)
                )),
                Some(k) => {
                    let mut s = format!(
                        "({} \"{}\"",
                        self.net.gates[k].kind.word(),
                        range_text(row.rect)
                    );
                    for node in self.inputs(k) {
                        s.push_str(&format!(" \"{}\"", self.reference(node)));
                    }
                    s.push(')');
                    lines.push(s);
                }
            }
        }
        lines
    }

    /// Every shape the language plans for the laid netlist, counted here, in
    /// the order of their first cells, as the census prints its shape rows: a
    /// shape a fill, and one for each R1C1 text of the formulas alone; a cell
    /// at level 0 when it reads no formula of the frame, else one past the
    /// deepest it reads; a run a shape's cells at one level, at least `RUN`
    /// of them, and every other cell alone.
    pub fn shapes(&self) -> Vec<ShapeFacts> {
        let rows = self.rows();
        // Each gate's level: the stimulus's switches are formulas of level 0,
        // a value is no formula, and a wire through the twin no edge.
        let stimulus = self.switches == Switches::Stimulus;
        let mut level = vec![0usize; self.net.gates.len()];
        if self.wiring == Wiring::Now {
            for (k, g) in self.net.gates.iter().enumerate() {
                let of = |n: Node| match n {
                    Node::Gate(j) => Some(level[j as usize] + 1),
                    Node::Switch(_) if stimulus => Some(1),
                    _ => None,
                };
                level[k] = of(g.a).into_iter().chain(of(g.b)).max().unwrap_or(0);
            }
        }
        let gate_at: HashMap<(u32, u32), usize> = self
            .cells
            .iter()
            .enumerate()
            .map(|(k, &c)| (c, k))
            .collect();
        // Each shape's cells, by level, and its key.
        let mut by_key: HashMap<&str, usize> = HashMap::new();
        let mut shapes: Vec<(String, Vec<Placed>)> = Vec::new();
        for row in &rows {
            let s = if row.cells() > 1 {
                shapes.push((row.key.clone(), Vec::new()));
                shapes.len() - 1
            } else {
                *by_key.entry(&row.key).or_insert_with(|| {
                    shapes.push((row.key.clone(), Vec::new()));
                    shapes.len() - 1
                })
            };
            let (t, l, b, r) = row.rect;
            for rr in t..=b {
                for cc in l..=r {
                    let lv = match row.gate {
                        None => 0,
                        Some(_) => level[gate_at[&(rr, cc)]],
                    };
                    shapes[s].1.push(((rr, cc), lv));
                }
            }
        }
        let mut out: Vec<ShapeFacts> = shapes
            .into_iter()
            .map(|(key, cells)| {
                let mut at_level: HashMap<usize, usize> = HashMap::new();
                for &(_, lv) in &cells {
                    *at_level.entry(lv).or_default() += 1;
                }
                let runs: Vec<usize> = at_level.values().copied().filter(|&n| n >= RUN).collect();
                let lanes: usize = runs.iter().sum();
                ShapeFacts {
                    first: cells
                        .iter()
                        .map(|&(c, _)| c)
                        .min()
                        .expect("a shape holds a cell"),
                    key,
                    cells: cells.len(),
                    levels: (
                        *at_level.keys().min().expect("a level"),
                        *at_level.keys().max().expect("a level"),
                        at_level.len(),
                        *at_level.values().max().expect("a level"),
                    ),
                    runs: (
                        runs.len(),
                        lanes,
                        runs.iter().copied().min().unwrap_or(0),
                        runs.iter().copied().max().unwrap_or(0),
                    ),
                    alone: cells.len() - lanes,
                    at: at_level,
                }
            })
            .collect();
        out.sort_by_key(|s| s.first);
        out
    }

    /// The census the language prints of the laid netlist, its plan row's
    /// numbers, counted here from [`Laid::shapes`].
    pub fn census(&self) -> Census {
        let shapes = self.shapes();
        let mut texts: Vec<&str> = shapes.iter().map(|s| s.key.as_str()).collect();
        texts.sort_unstable();
        texts.dedup();
        let mut levels: Vec<usize> = shapes.iter().flat_map(|s| s.at.keys().copied()).collect();
        levels.sort_unstable();
        levels.dedup();
        let formulas: usize = shapes.iter().map(|s| s.cells).sum();
        let lanes: usize = shapes.iter().map(|s| s.runs.1).sum();
        Census {
            shapes: shapes.len(),
            texts: texts.len(),
            formulas,
            levels: levels.len(),
            runs: shapes.iter().map(|s| s.runs.0).sum(),
            lanes,
            alone: formulas - lanes,
        }
    }
}

/// A formula cell of a shape and its level.
type Placed = ((u32, u32), usize);

/// One shape the language plans, as the census's shape row prints it: its
/// first cell, its cells, its levels (the first, the last, how many and the
/// widest), its runs (how many, their cells, the narrowest and the widest)
/// and its cells alone; with its key and its cells at each level.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ShapeFacts {
    pub first: (u32, u32),
    pub key: String,
    pub cells: usize,
    pub levels: (usize, usize, usize, usize),
    pub runs: (usize, usize, usize, usize),
    pub alone: usize,
    pub at: HashMap<usize, usize>,
}

impl ShapeFacts {
    /// The facts the census's shape row prints after its formula.
    pub fn row(&self) -> String {
        format!(
            "(cells {}) (levels {} {} {} {}) (runs {} {} {} {}) (alone {})",
            self.cells,
            self.levels.0,
            self.levels.1,
            self.levels.2,
            self.levels.3,
            self.runs.0,
            self.runs.1,
            self.runs.2,
            self.runs.3,
            self.alone
        )
    }
}

// ---- the source ---------------------------------------------------------------

/// The source with its block's lines replaced by `lines`, the lines around it
/// as they stand, each line ending as the source's do; `None` where the
/// source holds no block.
pub fn with_block(source: &str, lines: &[String]) -> Option<String> {
    let eol = if source.contains("\r\n") {
        "\r\n"
    } else {
        "\n"
    };
    let all: Vec<&str> = source.split(eol).collect();
    let begin = all.iter().position(|l| *l == BLOCK_BEGIN)?;
    let end = all.iter().position(|l| *l == BLOCK_END)?;
    if end <= begin {
        return None;
    }
    let mut out: Vec<String> = all[..=begin].iter().map(|l| l.to_string()).collect();
    out.extend(lines.iter().cloned());
    out.extend(all[end..].iter().map(|l| l.to_string()));
    Some(out.join(eol))
}

/// The lesson the bench teaches beside it (`CART.9`'s second slice), the
/// lines between these two, which the floors leave out.
pub const LESSON_BEGIN: &str =
    "; ---- the lesson beside the bench: the floors build their benches without it ----";
pub const LESSON_END: &str = "; ---- the lesson's end ----";

/// The floors' source (decision 6): the source with its block's lines
/// replaced by `lines`, the manifest's `(settle K)` line taken out, and the
/// lesson's lines with it, each sheet the lesson makes named no more in the
/// manifest's `(bound ...)`. A cartridge that settles numbers the Clock by
/// acts, and the floors step frames, their switches reading the Clock as
/// the frame; and the lesson is the bench's words to a person, of which the
/// floors measure nothing. `None` where the source holds no block.
pub fn floors_source(source: &str, lines: &[String]) -> Option<String> {
    let built = with_block(source, lines)?;
    let eol = if built.contains("\r\n") { "\r\n" } else { "\n" };
    let mut all: Vec<String> = built.split(eol).map(str::to_string).collect();
    if let Some(i) = all
        .iter()
        .position(|l| l.trim_start().starts_with("(settle "))
    {
        all.remove(i);
    }
    let begin = all.iter().position(|l| l == LESSON_BEGIN);
    let end = all.iter().position(|l| l == LESSON_END);
    if let (Some(b), Some(e)) = (begin, end) {
        if e > b {
            let sheets: Vec<String> = all[b..=e]
                .iter()
                .filter_map(|l| l.strip_prefix("(sheet \""))
                .filter_map(|l| l.split_once('"'))
                .map(|(name, _)| format!(" \"{name}\""))
                .collect();
            all.drain(b..=e);
            if let Some(bound) = all
                .iter_mut()
                .find(|l| l.trim_start().starts_with("(bound "))
            {
                for name in &sheets {
                    *bound = bound.replacen(name.as_str(), "", 1);
                }
            }
        }
    }
    Some(all.join(eol))
}

/// The block's lines as the source holds them; `None` where it holds none.
pub fn block_of(source: &str) -> Option<Vec<String>> {
    let lines: Vec<&str> = source.lines().map(|l| l.trim_end_matches('\r')).collect();
    let begin = lines.iter().position(|l| *l == BLOCK_BEGIN)?;
    let end = lines.iter().position(|l| *l == BLOCK_END)?;
    (end > begin).then(|| {
        lines[begin + 1..end]
            .iter()
            .map(|l| l.to_string())
            .collect()
    })
}

/// `MOD` as the language computes it, `n - d·⌊n/d⌋`.
fn modulo(n: f64, d: f64) -> f64 {
    n - d * (n / d).floor()
}

/// A switch's bit under [`STIMULUS`] at its cell and frame, computed in the
/// language's own arithmetic.
pub fn stimulus(row: u32, col: u32, frame: u64) -> u8 {
    let n = f64::from(row) * 40503.0 + f64::from(col) * 9973.0 + frame as f64 * 65519.0;
    let u = modulo(n, 65521.0);
    let v = modulo(u * u, 65521.0);
    modulo((v / 256.0).floor(), 2.0) as u8
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn the_gates_are_their_truth_tables() {
        let table = |k: Kind| -> Vec<u8> {
            [(0, 0), (0, 1), (1, 0), (1, 1)]
                .iter()
                .map(|&(a, b)| k.apply(a, b))
                .collect()
        };
        assert_eq!(table(Kind::Et), [0, 0, 0, 1]);
        assert_eq!(table(Kind::Vel), [0, 1, 1, 1]);
        assert_eq!(table(Kind::Aut), [0, 1, 1, 0]);
        assert_eq!(table(Kind::NonEt), [1, 1, 1, 0]);
        assert_eq!(table(Kind::Nec), [1, 0, 0, 0]);
        assert_eq!([Kind::Non.apply(0, 0), Kind::Non.apply(1, 0)], [1, 0]);
    }

    #[test]
    fn the_circuits_are_plus_and_times_over_every_input_of_four_bits() {
        let net = Net::bench(4, 4);
        let n = net.switches.len();
        assert_eq!(n, 4 + 4 + 1 + 4 + 4);
        for v in 0u32..(1 << n) {
            let switches: Vec<u8> = (0..n).map(|i| ((v >> i) & 1) as u8).collect();
            let gates = net.evaluate(&switches);
            net.check(&switches, &gates)
                .unwrap_or_else(|e| panic!("{e} at {v:b}"));
        }
    }

    #[test]
    fn the_floors_are_decision_6_s_bench() {
        let net = Net::bench(FLOORS.0, FLOORS.1);
        assert_eq!(net.gates.len(), 44_544);
        assert_eq!(net.switches.len(), 2 * 4096 + 1 + 2 * 64);
        assert_eq!(
            net.depth(),
            8_193,
            "the carry through every bit of the adder, two gates a bit"
        );
        let bench = Net::bench(BENCH.0, BENCH.1);
        assert_eq!((bench.gates.len(), bench.depth()), (400, 33));
    }

    /// The bench a person loads stands a row lower than the floors' (the
    /// second slice's hand test), the same gates and depth, and row 1 above it
    /// names its columns; a bench from row 1, the floors' among them, names
    /// none, so that its block is the bytes it was.
    #[test]
    fn the_shown_bench_names_its_columns_a_row_above_it() {
        let shown = Net::shown();
        assert_eq!((shown.gates.len(), shown.depth()), (400, 33));
        let named: Vec<String> = shown
            .labels
            .iter()
            .map(|&((r, c), w)| format!("{}={w}", a1(r, c, false, false)))
            .collect();
        assert_eq!(
            named.join(" "),
            "A1=a B1=b C1=AUT D1=ET E1=ET F1=VEL G1=AUT J1=a I3=b J3=ET S1=AUT AB1=ET AK1=ET AT1=VEL BC1=AUT"
        );
        let at = |k: usize| a1(shown.switches[k].0, shown.switches[k].1, false, false);
        let Circuit::Adder { a, carry, .. } = &shown.circuits[0] else {
            panic!("the adder first")
        };
        let Circuit::Multiplier { a: ma, b: mb, .. } = &shown.circuits[1] else {
            panic!("the multiplier second")
        };
        assert_eq!(
            [
                at(a[0] as usize),
                at(*carry as usize),
                at(ma[0] as usize),
                at(mb[0] as usize)
            ],
            ["A3", "F2", "J2", "I4"].map(String::from)
        );
        assert!(Net::bench(BENCH.0, BENCH.1).labels.is_empty());
        assert!(Net::bench(FLOORS.0, FLOORS.1).labels.is_empty());
    }

    #[test]
    fn the_floors_source_replaces_the_block_and_leaves_out_the_settle() {
        let source = format!(
            "(cartridge \"t\"\r\n  (rate 0)\r\n  (settle 9)   ; a note\r\n  (bound \"Lesson\" \"S\")\r\n  (seed 1))\r\n{LESSON_BEGIN}\r\n(sheet \"Lesson\" visible)\r\n(cell \"Lesson\" \"A9\" \"a word\")\r\n{LESSON_END}\r\n{BLOCK_BEGIN}\r\nold\r\n{BLOCK_END}\r\n"
        );
        let lines = vec!["new".to_string()];
        let want = format!(
            "(cartridge \"t\"\r\n  (rate 0)\r\n  (bound \"S\")\r\n  (seed 1))\r\n{BLOCK_BEGIN}\r\nnew\r\n{BLOCK_END}\r\n"
        );
        assert_eq!(floors_source(&source, &lines), Some(want));
        assert_eq!(
            with_block(&source, &lines).map(|s| s.contains("(settle 9)") && s.contains("a word")),
            Some(true),
            "the cartridge's own source keeps both"
        );
        assert_eq!(floors_source("no block", &lines), None);
    }

    #[test]
    fn the_shuffle_leaves_every_gate_its_own_shape() {
        let net = Net::bench(64, 8);
        let laid = Laid::new(&net, Lay::Shuffled, Switches::Values, Wiring::Now);
        let mut keys: Vec<String> = (0..laid.cells.len()).map(|k| laid.key(k)).collect();
        keys.sort();
        keys.dedup();
        assert_eq!(keys.len(), net.gates.len());
        let mut cells = laid.cells.clone();
        cells.sort();
        let mut home = net.home.clone();
        home.sort();
        assert_eq!(cells, home, "the same cells");
    }

    #[test]
    fn the_dice_are_mulberry32() {
        // Mulberry32's first draws from 0, as the page's hand draws them.
        let mut d = Dice(0);
        assert_eq!(
            [d.next(), d.next(), d.next()],
            [1_144_304_738, 1_416_247, 958_946_056]
        );
    }
}

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

/// A named adder's column's width (the second slice's hand test): a gate's
/// Latin name of three capitals beside another name cut at three, `AU` and
/// `VEI` on the owner's screen, so the adder's seven columns are four wide
/// where row 1 names them; the multiplier's names run on into empty cells.
pub const NAMED_WIDTH: &str = "4";

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
    pub wide: Vec<u32>,
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
            if top > 1 {
                self.wide.push(c0 + k as u32);
            }
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
            let width = if self.net.wide.contains(&c) {
                NAMED_WIDTH
            } else {
                WIDTH
            };
            lines.push(format!(
                "(column \"{SHEET}\" \"{}\" {width} shown none)",
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

/// The game's levels (`CART.9`'s third slice), the lines between these two,
/// which the floors leave out as they leave the lesson.
pub const LEVELS_BEGIN: &str = "; ---- the levels: the game, between the lesson and the bench; the floors build their benches without them ----";
pub const LEVELS_END: &str = "; ---- the levels' end ----";

/// The floors' source (decision 6): the source with its block's lines
/// replaced by `lines`, the manifest's `(settle K)` line taken out, and the
/// lesson's lines and the levels' with it, each sheet they make named no
/// more in the manifest's `(bound ...)`. A cartridge that settles numbers the
/// Clock by acts, and the floors step frames, their switches reading the
/// Clock as the frame; and the lesson and the levels are the game's, of which
/// the floors measure nothing. The keyboard's sheets, `(game ...)`, `(work
/// ...)` and `(read ...)` (`SPEC.5`), go too, a person's keys being nothing
/// the floors press, so that their benches stay the bytes measured. `None`
/// where the source holds no block.
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
    all.retain(|l| {
        let t = l.trim_start();
        !["(game \"", "(work \"", "(read \""]
            .iter()
            .any(|h| t.starts_with(h))
    });
    for (first, last) in [(LESSON_BEGIN, LESSON_END), (LEVELS_BEGIN, LEVELS_END)] {
        let begin = all.iter().position(|l| l == first);
        let end = all.iter().position(|l| l == last);
        let (Some(b), Some(e)) = (begin, end) else {
            continue;
        };
        if e <= b {
            continue;
        }
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
    Some(all.join(eol))
}

/// The source without its game (`CART.9`'s third slice): the levels' lines
/// left out, each sheet they make named no more in the manifest's
/// `(bound ...)` and `(work ...)`, and the manifest's `(game ...)`, which names
/// them. The bench's own tests read the bench alone, its census and its
/// frames' changes the netlist's, as they did before the levels.
pub fn without_levels(source: &str) -> String {
    let eol = if source.contains("\r\n") {
        "\r\n"
    } else {
        "\n"
    };
    let mut all: Vec<String> = source.split(eol).map(str::to_string).collect();
    all.retain(|l| !l.trim_start().starts_with("(game \""));
    let begin = all.iter().position(|l| l == LEVELS_BEGIN);
    let end = all.iter().position(|l| l == LEVELS_END);
    if let (Some(b), Some(e)) = (begin, end) {
        if e > b {
            let sheets: Vec<String> = all[b..=e]
                .iter()
                .filter_map(|l| l.strip_prefix("(sheet \""))
                .filter_map(|l| l.split_once('"'))
                .map(|(name, _)| format!(" \"{name}\""))
                .collect();
            all.drain(b..=e);
            for l in all.iter_mut().filter(|l| {
                let t = l.trim_start();
                t.starts_with("(bound ") || t.starts_with("(work ")
            }) {
                for name in &sheets {
                    *l = l.replacen(name.as_str(), "", 1);
                }
            }
        }
    }
    all.join(eol)
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

// ---- the game by hand (`CART.9`'s third slice, decision 26) -------------------------------

/// A cell's value as the language computes one: a number, a text, a truth
/// value, an error by its spelling, or nothing.
#[derive(Clone, Debug, PartialEq)]
pub enum Val {
    Num(f64),
    Text(String),
    Bool(bool),
    Err(&'static str),
    Empty,
}

/// `#VALUE!`, an operand of the wrong kind.
pub const VALUE: &str = "#VALUE!";

impl Val {
    /// The number an operand coerces to: a text that spells one, a truth
    /// value 1 or 0, nothing 0, and any other text `#VALUE!`.
    pub fn number(&self) -> Result<f64, &'static str> {
        match self {
            Val::Num(n) => Ok(*n),
            Val::Bool(b) => Ok(if *b { 1.0 } else { 0.0 }),
            Val::Empty => Ok(0.0),
            Val::Text(t) => text_number(t).ok_or(VALUE),
            Val::Err(k) => Err(k),
        }
    }

    /// The truth a condition reads: a number not 0, a truth value, nothing
    /// FALSE, and a text TRUE or FALSE alone.
    pub fn truth(&self) -> Result<bool, &'static str> {
        match self {
            Val::Bool(b) => Ok(*b),
            Val::Num(n) => Ok(*n != 0.0),
            Val::Empty => Ok(false),
            Val::Text(t) => match t.to_ascii_lowercase().as_str() {
                "true" => Ok(true),
                "false" => Ok(false),
                _ => Err(VALUE),
            },
            Val::Err(k) => Err(k),
        }
    }

    /// The text `&` reads: a number in its General spelling, a whole one
    /// as its digits.
    pub fn text(&self) -> Result<String, &'static str> {
        match self {
            Val::Text(t) => Ok(t.clone()),
            Val::Num(n) => Ok(general(*n)),
            Val::Bool(true) => Ok("TRUE".to_string()),
            Val::Bool(false) => Ok("FALSE".to_string()),
            Val::Empty => Ok(String::new()),
            Val::Err(k) => Err(k),
        }
    }

    /// A formula's answer as its cell holds it: nothing settles to 0.
    pub fn settled(self) -> Val {
        if self == Val::Empty {
            Val::Num(0.0)
        } else {
            self
        }
    }
}

/// A number's General spelling, for the counts the words hold: its digits
/// while it is whole and under 10^15.
pub fn general(n: f64) -> String {
    if n.fract() == 0.0 && n.abs() < 1e15 {
        format!("{}", n as i64)
    } else {
        format!("{n}")
    }
}

/// A text's number as an operand reads it (the language's
/// `text_to_number`): a sign, digits with one point, an exponent, a
/// percent; `None` for any other text.
pub fn text_number(text: &str) -> Option<f64> {
    let t = text.trim();
    let (t, percent) = match t.strip_suffix('%') {
        Some(rest) => (rest.trim_end(), true),
        None => (t, false),
    };
    let b = t.as_bytes();
    let (mut i, mut digits, mut dot) = (0, 0, false);
    if i < b.len() && (b[i] == b'+' || b[i] == b'-') {
        i += 1;
    }
    while i < b.len() {
        match b[i] {
            b'0'..=b'9' => digits += 1,
            b'.' if !dot => dot = true,
            _ => break,
        }
        i += 1;
    }
    if digits == 0 {
        return None;
    }
    if i < b.len() && (b[i] == b'e' || b[i] == b'E') {
        let mut j = i + 1;
        if j < b.len() && (b[j] == b'+' || b[j] == b'-') {
            j += 1;
        }
        let from = j;
        while j < b.len() && b[j].is_ascii_digit() {
            j += 1;
        }
        if j == from {
            return None;
        }
        i = j;
    }
    if i != b.len() {
        return None;
    }
    let v: f64 = t.parse().ok()?;
    Some(if percent { v / 100.0 } else { v })
}

/// A result no cell can hold is `#NUM!`; no cell holds -0.
fn finite(v: f64) -> Val {
    if v == 0.0 {
        Val::Num(0.0)
    } else if v.is_finite() {
        Val::Num(v)
    } else {
        Val::Err("#NUM!")
    }
}

/// An arithmetic operator over two values, the left's error first.
pub fn arith(op: u8, a: &Val, b: &Val) -> Val {
    let x = match a.number() {
        Ok(n) => n,
        Err(k) => return Val::Err(k),
    };
    let y = match b.number() {
        Ok(n) => n,
        Err(k) => return Val::Err(k),
    };
    match op {
        b'+' => finite(x + y),
        b'-' => finite(x - y),
        b'*' => finite(x * y),
        _ => {
            if y == 0.0 {
                Val::Err("#DIV/0!")
            } else {
                finite(x / y)
            }
        }
    }
}

/// How two values compare in Excel's order of kinds: nothing is 0, `""` or
/// FALSE, whichever the other side is; every number below every text, every
/// text below every truth value; texts without case.
pub fn order(a: &Val, b: &Val) -> std::cmp::Ordering {
    use std::cmp::Ordering;
    use Val::*;
    let rank = |v: &Val| match v {
        Num(_) | Empty => 0,
        Text(_) => 1,
        Bool(_) => 2,
        Err(_) => 3,
    };
    match (a, b) {
        (Empty, Empty) => Ordering::Equal,
        (Empty, Num(y)) => 0.0f64.partial_cmp(y).unwrap_or(Ordering::Equal),
        (Num(x), Empty) => x.partial_cmp(&0.0).unwrap_or(Ordering::Equal),
        (Empty, Text(t)) => {
            if t.is_empty() {
                Ordering::Equal
            } else {
                Ordering::Less
            }
        }
        (Text(t), Empty) => {
            if t.is_empty() {
                Ordering::Equal
            } else {
                Ordering::Greater
            }
        }
        (Empty, Bool(y)) => false.cmp(y),
        (Bool(x), Empty) => x.cmp(&false),
        (Num(x), Num(y)) => x.partial_cmp(y).unwrap_or(Ordering::Equal),
        (Text(x), Text(y)) => x.to_lowercase().cmp(&y.to_lowercase()),
        (Bool(x), Bool(y)) => x.cmp(y),
        _ => rank(a).cmp(&rank(b)),
    }
}

/// `a = b`, a truth value or the first error.
pub fn equal(a: &Val, b: &Val) -> Val {
    match (a, b) {
        (Val::Err(k), _) | (_, Val::Err(k)) => Val::Err(k),
        _ => Val::Bool(order(a, b) == std::cmp::Ordering::Equal),
    }
}

/// `IF(c, then, else)` over a condition's value, the branch taken alone.
pub fn if_(c: &Val, then: impl FnOnce() -> Val, otherwise: impl FnOnce() -> Val) -> Val {
    match c.truth() {
        Ok(true) => then(),
        Ok(false) => otherwise(),
        Err(k) => Val::Err(k),
    }
}

/// `AND` over values given as conditions, the first error answering.
pub fn and(items: &[Val]) -> Val {
    let mut all = true;
    for v in items {
        match v.truth() {
            Ok(b) => all &= b,
            Err(k) => return Val::Err(k),
        }
    }
    Val::Bool(all)
}

/// `a < b`, a truth value or the first error.
pub fn less(a: &Val, b: &Val) -> Val {
    match (a, b) {
        (Val::Err(k), _) | (_, Val::Err(k)) => Val::Err(k),
        _ => Val::Bool(order(a, b) == std::cmp::Ordering::Less),
    }
}

/// `a <= b`, a truth value or the first error.
pub fn less_equal(a: &Val, b: &Val) -> Val {
    match (a, b) {
        (Val::Err(k), _) | (_, Val::Err(k)) => Val::Err(k),
        _ => Val::Bool(order(a, b) != std::cmp::Ordering::Greater),
    }
}

/// `OR` over values given as conditions, the first error answering.
pub fn or(items: &[Val]) -> Val {
    let mut any = false;
    for v in items {
        match v.truth() {
            Ok(b) => any |= b,
            Err(k) => return Val::Err(k),
        }
    }
    Val::Bool(any)
}

/// A person's gate as the hand evaluates it (decision 26): numbers; cells
/// of its own level, relative or held; `+ - * /` and a sign; parentheses;
/// and `MAX`, `MIN`, `MOD` and `INT`, enough for the six gates and any
/// formula of them. Anything else refuses the hand by name.
#[derive(Clone, Debug, PartialEq)]
pub enum Gex {
    Num(f64),
    Cell(u32, u32),
    Range(u32, u32, u32, u32),
    Neg(Box<Gex>),
    Op(u8, Box<Gex>, Box<Gex>),
    Call(&'static str, Vec<Gex>),
}

/// A gate's formula read, `=` first.
pub fn gex(formula: &str) -> Result<Gex, String> {
    let text: Vec<char> = formula.trim().chars().collect();
    if text.first() != Some(&'=') {
        return Err(format!("{formula} is no formula"));
    }
    let mut p = Gp {
        s: text,
        i: 1,
        f: formula,
    };
    let e = p.sum()?;
    p.space();
    if p.i < p.s.len() {
        return Err(p.outside());
    }
    Ok(e)
}

struct Gp<'f> {
    s: Vec<char>,
    i: usize,
    f: &'f str,
}

impl Gp<'_> {
    fn outside(&self) -> String {
        format!(
            "the hand evaluates the gates' arithmetic alone, and {} holds {} at {}",
            self.f,
            self.s[self.i..].iter().collect::<String>(),
            self.i + 1
        )
    }
    fn space(&mut self) {
        while self.i < self.s.len() && self.s[self.i] == ' ' {
            self.i += 1;
        }
    }
    fn peek(&mut self) -> Option<char> {
        self.space();
        self.s.get(self.i).copied()
    }
    fn sum(&mut self) -> Result<Gex, String> {
        let mut e = self.product()?;
        while let Some(c @ ('+' | '-')) = self.peek() {
            self.i += 1;
            e = Gex::Op(c as u8, Box::new(e), Box::new(self.product()?));
        }
        Ok(e)
    }
    fn product(&mut self) -> Result<Gex, String> {
        let mut e = self.unary()?;
        while let Some(c @ ('*' | '/')) = self.peek() {
            self.i += 1;
            e = Gex::Op(c as u8, Box::new(e), Box::new(self.unary()?));
        }
        Ok(e)
    }
    fn unary(&mut self) -> Result<Gex, String> {
        match self.peek() {
            Some('-') => {
                self.i += 1;
                Ok(Gex::Neg(Box::new(self.unary()?)))
            }
            Some('+') => {
                self.i += 1;
                self.unary()
            }
            _ => self.primary(),
        }
    }
    fn primary(&mut self) -> Result<Gex, String> {
        match self.peek() {
            Some('(') => {
                self.i += 1;
                let e = self.sum()?;
                if self.peek() != Some(')') {
                    return Err(self.outside());
                }
                self.i += 1;
                Ok(e)
            }
            Some(c) if c.is_ascii_digit() || c == '.' => {
                let from = self.i;
                while self.i < self.s.len()
                    && (self.s[self.i].is_ascii_digit() || self.s[self.i] == '.')
                {
                    self.i += 1;
                }
                let t: String = self.s[from..self.i].iter().collect();
                t.parse().map(Gex::Num).map_err(|_| self.outside())
            }
            Some(c) if c.is_ascii_alphabetic() || c == '$' => {
                let from = self.i;
                let word: String = self.s[self.i..]
                    .iter()
                    .take_while(|c| c.is_ascii_alphabetic())
                    .collect();
                if self.s.get(self.i + word.len()) == Some(&'(') {
                    let name = match word.to_ascii_uppercase().as_str() {
                        "MAX" => "MAX",
                        "MIN" => "MIN",
                        "MOD" => "MOD",
                        "INT" => "INT",
                        "IF" => "IF",
                        _ => return Err(self.outside()),
                    };
                    self.i += word.len() + 1;
                    let mut args = Vec::new();
                    loop {
                        args.push(if name == "MAX" || name == "MIN" {
                            self.argument()?
                        } else {
                            self.sum()?
                        });
                        match self.peek() {
                            Some(',') => self.i += 1,
                            Some(')') => {
                                self.i += 1;
                                break;
                            }
                            _ => return Err(self.outside()),
                        }
                    }
                    let arity = match name {
                        "MOD" => args.len() == 2,
                        "INT" => args.len() == 1,
                        "IF" => args.len() == 3,
                        _ => !args.is_empty(),
                    };
                    if !arity {
                        return Err(self.outside());
                    }
                    return Ok(Gex::Call(name, args));
                }
                self.i = from;
                let (r, c) = self.cell().ok_or_else(|| self.outside())?;
                Ok(Gex::Cell(r, c))
            }
            _ => Err(self.outside()),
        }
    }
    /// An argument of MAX or MIN: a cell, a range, or a value.
    fn argument(&mut self) -> Result<Gex, String> {
        let from = self.i;
        self.space();
        if let Some((r, c)) = self.cell() {
            if self.s.get(self.i) == Some(&':') {
                self.i += 1;
                let (r2, c2) = self.cell().ok_or_else(|| self.outside())?;
                return Ok(Gex::Range(r.min(r2), c.min(c2), r.max(r2), c.max(c2)));
            }
            if matches!(self.peek(), Some(',') | Some(')')) {
                return Ok(Gex::Cell(r, c));
            }
        }
        self.i = from;
        self.sum()
    }
    /// A cell's address, `$` held or not: its row and column.
    fn cell(&mut self) -> Option<(u32, u32)> {
        self.space();
        let s = &self.s;
        let mut i = self.i;
        if s.get(i) == Some(&'$') {
            i += 1;
        }
        let mut col = 0u32;
        let from = i;
        while i < s.len() && s[i].is_ascii_alphabetic() {
            col = col * 26 + (s[i].to_ascii_uppercase() as u32 - 64);
            i += 1;
        }
        if i == from || i - from > 3 {
            return None;
        }
        if s.get(i) == Some(&'$') {
            i += 1;
        }
        let mut row = 0u32;
        let digits = i;
        while i < s.len() && s[i].is_ascii_digit() {
            row = row * 10 + s[i].to_digit(10)?;
            i += 1;
        }
        if i == digits
            || row == 0
            || s.get(i)
                .is_some_and(|c| c.is_ascii_alphanumeric() || *c == '!' || *c == '(')
        {
            return None;
        }
        self.i = i;
        Some((row, col))
    }
}

impl Gex {
    /// The cells it reads.
    pub fn reads(&self, out: &mut Vec<(u32, u32)>) {
        match self {
            Gex::Num(_) => {}
            Gex::Cell(r, c) => out.push((*r, *c)),
            Gex::Range(r1, c1, r2, c2) => {
                for r in *r1..=*r2 {
                    for c in *c1..=*c2 {
                        out.push((r, c));
                    }
                }
            }
            Gex::Neg(x) => x.reads(out),
            Gex::Op(_, x, y) => {
                x.reads(out);
                y.reads(out);
            }
            Gex::Call(_, args) => args.iter().for_each(|a| a.reads(out)),
        }
    }

    /// Its value, the cells it reads answered by `cell`.
    pub fn eval(&self, cell: &mut dyn FnMut(u32, u32) -> Val) -> Val {
        match self {
            Gex::Num(n) => Val::Num(*n),
            Gex::Cell(r, c) => cell(*r, *c),
            Gex::Range(..) => Val::Err(VALUE),
            Gex::Neg(x) => match x.eval(cell).number() {
                Ok(n) => finite(-n),
                Err(k) => Val::Err(k),
            },
            Gex::Op(op, x, y) => {
                let a = x.eval(cell);
                if let Val::Err(k) = a {
                    return Val::Err(k);
                }
                let b = y.eval(cell);
                if let Val::Err(k) = b {
                    return Val::Err(k);
                }
                arith(*op, &a, &b)
            }
            Gex::Call(name, args) => match *name {
                "MAX" | "MIN" => {
                    let mut items = Vec::new();
                    for a in args {
                        match a {
                            Gex::Cell(..) | Gex::Range(..) => {
                                let mut cells = Vec::new();
                                a.reads(&mut cells);
                                let mut err = None;
                                for (r, c) in cells {
                                    match cell(r, c) {
                                        Val::Num(n) => items.push(n),
                                        Val::Err(k) => {
                                            err.get_or_insert(k);
                                        }
                                        _ => {}
                                    }
                                }
                                if let Some(k) = err {
                                    return Val::Err(k);
                                }
                            }
                            _ => match a.eval(cell).number() {
                                Ok(n) => items.push(n),
                                Err(k) => return Val::Err(k),
                            },
                        }
                    }
                    let folded = if *name == "MAX" {
                        items
                            .iter()
                            .copied()
                            .fold(None, |m: Option<f64>, x| Some(m.map_or(x, |m| m.max(x))))
                    } else {
                        items
                            .iter()
                            .copied()
                            .fold(None, |m: Option<f64>, x| Some(m.map_or(x, |m| m.min(x))))
                    };
                    Val::Num(folded.unwrap_or(0.0))
                }
                "MOD" => {
                    let n = match args[0].eval(cell).number() {
                        Ok(n) => n,
                        Err(k) => return Val::Err(k),
                    };
                    let d = match args[1].eval(cell).number() {
                        Ok(d) => d,
                        Err(k) => return Val::Err(k),
                    };
                    if d == 0.0 {
                        Val::Err("#DIV/0!")
                    } else {
                        finite(n - d * (n / d).floor())
                    }
                }
                "IF" => match args[0].eval(cell).truth() {
                    Ok(true) => args[1].eval(cell),
                    Ok(false) => args[2].eval(cell),
                    Err(k) => Val::Err(k),
                },
                _ => match args[0].eval(cell).number() {
                    Ok(n) => Val::Num(n.floor()),
                    Err(k) => Val::Err(k),
                },
            },
        }
    }
}

/// A level of the game (decisions 16 to 21 and 34 to 46): its sheet, its
/// switches and the flip-flops below them, its outputs, its room's rows from
/// row 3 to the board's last, its budget, its least known, the last kind of
/// gate it gives ([`kind`]), and the inputs its test runs through.
pub struct Level {
    pub sheet: &'static str,
    pub inputs: u32,
    pub state: u32,
    pub outputs: u32,
    pub rows: u32,
    pub budget: u32,
    pub least: u32,
    pub gives: u32,
    pub vectors: u32,
}

impl Level {
    /// Its cells of column A: its switches and its flip-flops.
    pub fn switches(&self) -> u32 {
        self.inputs + self.state
    }

    /// The states its flip-flops can hold, the most ticks a run moves them
    /// before one comes twice (decision 37); 0 for a level with none.
    pub fn limit(&self) -> u32 {
        if self.state == 0 {
            0
        } else {
            1 << self.state
        }
    }
}

const fn level(
    sheet: &'static str,
    (inputs, state, outputs): (u32, u32, u32),
    rows: u32,
    (budget, least): (u32, u32),
    gives: u32,
    vectors: u32,
) -> Level {
    Level {
        sheet,
        inputs,
        state,
        outputs,
        rows,
        budget,
        least,
        gives,
        vectors,
    }
}

/// The fifteen levels in tab order, `I NON` the first.
pub const LEVELS: [Level; 15] = [
    level("I NON", (1, 0, 1), 8, (2, 1), 2, 2),
    level("II ET", (2, 0, 1), 8, (3, 2), 3, 4),
    level("III VEL", (2, 0, 1), 8, (4, 3), 4, 4),
    level("IV AUT", (2, 0, 1), 8, (5, 3), 5, 4),
    level("V ELIGE", (3, 0, 1), 8, (5, 3), 6, 8),
    level("VI DISTRIBUE", (2, 0, 2), 8, (4, 2), 6, 4),
    level("VII SEMIS", (2, 0, 2), 8, (3, 2), 6, 4),
    level("VIII SUMMA", (3, 0, 2), 8, (6, 5), 6, 8),
    level("IX QUATTUOR", (9, 0, 5), 9, (21, 20), 6, 512),
    level("X MORA", (1, 1, 1), 8, (2, 1), 7, 4),
    level("XI TENE", (2, 1, 1), 8, (3, 1), 7, 8),
    level("XII MEMORIA", (5, 4, 4), 9, (6, 4), 7, 512),
    level("XIII NUMERA", (2, 4, 4), 8, (13, 11), 7, 64),
    level("XIV RATIO", (10, 0, 5), 10, (38, 31), 7, 1024),
    level("XV MACHINA", (7, 12, 12), 19, (60, 46), 7, 2048),
];

/// Level XV's place among them: its inputs its word, read from the ROM.
pub const MACHINA: usize = 14;

/// XV's switches a test counts through, its word and its A; the rest, its p
/// and its B, it draws by lot (decision 40).
pub const COUNTED: usize = 11;

/// Each level's switches' and outputs' names, its B and K columns.
pub const NAMES: [(&[&str], &[&str]); 15] = [
    (&["a"], &["y"]),
    (&["a", "b"], &["y"]),
    (&["a", "b"], &["y"]),
    (&["a", "b"], &["y"]),
    (&["a", "b", "s"], &["y"]),
    (&["x", "s"], &["to 0", "to 1"]),
    (&["a", "b"], &["sum", "carry"]),
    (&["a", "b", "c"], &["sum", "carry"]),
    (
        &["a0", "a1", "a2", "a3", "b0", "b1", "b2", "b3", "c"],
        &["s0", "s1", "s2", "s3", "carry"],
    ),
    (&["d", "q"], &["q'"]),
    (&["load", "d", "q"], &["q'"]),
    (
        &["load", "d0", "d1", "d2", "d3", "q0", "q1", "q2", "q3"],
        &["q0'", "q1'", "q2'", "q3'"],
    ),
    (
        &["reset", "inc", "q0", "q1", "q2", "q3"],
        &["q0'", "q1'", "q2'", "q3'"],
    ),
    (
        &["a0", "a1", "a2", "a3", "b0", "b1", "b2", "b3", "op0", "op1"],
        &["y0", "y1", "y2", "y3", "carry"],
    ),
    (
        &[
            "op0", "op1", "op2", "n0", "n1", "n2", "n3", "a0", "a1", "a2", "a3", "p0", "p1", "p2",
            "p3", "b0", "b1", "b2", "b3",
        ],
        &[
            "a0'", "a1'", "a2'", "a3'", "p0'", "p1'", "p2'", "p3'", "b0'", "b1'", "b2'", "b3'",
        ],
    ),
];

/// The words of XV's program, each its op by its place, the ROM's F2:F6.
pub const ROM_WORDS: [&str; 5] = ["LDI", "ADD", "SWP", "JNZ", "HLT"];

/// The program the ROM opens on: 3 x 5 by repeated addition, B2 down.
pub const ROM_PROGRAM: [&str; 8] = [
    "LDI 3", "SWP", "ADD 5", "SWP", "ADD 15", "JNZ 1", "SWP", "HLT",
];

/// A line of the ROM read as its word's number, its op plus 8 times its n, as
/// its C column computes it: a word none of the five, or an empty line, is
/// HLT; what follows the word, from its fifth character, is its n, in four
/// bits, 0 for none.
pub fn rom_word(line: &Val) -> f64 {
    let text = line.text().unwrap_or_default();
    let chars: Vec<char> = text.chars().collect();
    let word: String = chars.iter().take(3).collect::<String>().to_uppercase();
    let op = ROM_WORDS
        .iter()
        .position(|w| *w == word)
        .map_or(4.0, |p| p as f64);
    let rest: String = chars.iter().skip(4).take(9).collect();
    let n = text_number(&rest).map_or(0.0, |x| modulo(x.floor(), 16.0));
    op + 8.0 * n
}

/// The bit of the input's number that input s takes while a test runs,
/// `MOD(INT(B6/2^s),2)`.
pub fn bit(b6: &Val, s: usize) -> Val {
    match b6.number() {
        Ok(v) => finite(modulo((v / f64::from(1u32 << s)).floor(), 2.0)),
        Err(e) => Val::Err(e),
    }
}

/// What level k's switch s takes at the input's number while its test runs:
/// a bit of the number, or, for XV's p and B, a bit drawn by lot, the bench's
/// stimulus at the switch's row and column A.
pub fn test_input(k: usize, s: usize, b6: &Val) -> Val {
    if k == MACHINA && s >= COUNTED {
        match b6.number() {
            Ok(v) => Val::Num(f64::from(stimulus(3 + s as u32, 1, v as u64))),
            Err(e) => Val::Err(e),
        }
    } else {
        bit(b6, s)
    }
}

/// A level's inputs as its test reads them, the Lab's column of them from
/// row 31: while its test runs (`here`, the Lab's N, is 1), what
/// [`test_input`] gives; and otherwise its switches as they stand, an empty
/// one 0.
pub fn tested(k: usize, here: &Val, b6: &Val, standing: &[Val]) -> Vec<Val> {
    standing
        .iter()
        .enumerate()
        .map(|(s, v)| {
            if_(
                &equal(here, &Val::Num(1.0)),
                || test_input(k, s, b6),
                || v.clone(),
            )
            .settled()
        })
        .collect()
}

/// A sum of inputs, each with its weight, as the Lab's formulas spell one:
/// the first alone, and a weight of 1 unwritten.
fn weighted(s: &[Val], terms: &[(usize, f64)]) -> Val {
    let term = |&(i, w): &(usize, f64)| {
        if w == 1.0 {
            s[i].clone()
        } else {
            arith(b'*', &Val::Num(w), &s[i])
        }
    };
    let mut t = term(&terms[0]);
    for x in &terms[1..] {
        t = arith(b'+', &t, &term(x));
    }
    t
}

/// `MOD(v, d)` over a value.
fn modulo_of(v: Val, d: f64) -> Val {
    match v.number() {
        Ok(x) => finite(x - d * (x / d).floor()),
        Err(e) => Val::Err(e),
    }
}

/// `INT(v)` over a value.
fn int_of(v: Val) -> Val {
    match v.number() {
        Ok(x) => Val::Num(x.floor()),
        Err(e) => Val::Err(e),
    }
}

/// Bit i of a number, `MOD(INT(v/2^i),2)`, the Lab's `a-bit-of`.
fn a_bit_of(v: &Val, i: usize) -> Val {
    modulo_of(int_of(arith(b'/', v, &Val::Num(f64::from(1u32 << i)))), 2.0)
}

/// `MAX` over cells' values: its numbers, an error first.
fn max_of(xs: &[&Val]) -> Val {
    let mut items = Vec::new();
    for v in xs {
        match v {
            Val::Num(x) => items.push(*x),
            Val::Err(e) => return Val::Err(e),
            _ => {}
        }
    }
    Val::Num(
        items
            .iter()
            .copied()
            .fold(None, |m: Option<f64>, x| Some(m.map_or(x, |m| m.max(x))))
            .unwrap_or(0.0),
    )
}

/// `CHOOSE(index, items...)`: the item the index names, from 1.
fn choose(index: Val, items: &[Val]) -> Val {
    match index.number() {
        Ok(x) if x >= 1.0 && (x as usize) <= items.len() => items[x as usize - 1].clone(),
        Ok(_) => Val::Err(VALUE),
        Err(e) => Val::Err(e),
    }
}

/// XV's workings from its inputs as its test reads them, the Lab's P64 to
/// P72: its op, n, A, p and B; its A next, its p + 1, its p next and its B
/// next.
pub fn machina(s: &[Val]) -> [Val; 9] {
    let n = |x: f64| Val::Num(x);
    let op = weighted(s, &[(0, 1.0), (1, 2.0), (2, 4.0)]);
    let word = weighted(s, &[(3, 1.0), (4, 2.0), (5, 4.0), (6, 8.0)]);
    let a = weighted(s, &[(7, 1.0), (8, 2.0), (9, 4.0), (10, 8.0)]);
    let p = weighted(s, &[(11, 1.0), (12, 2.0), (13, 4.0), (14, 8.0)]);
    let b = weighted(s, &[(15, 1.0), (16, 2.0), (17, 4.0), (18, 8.0)]);
    let index = arith(b'+', &op, &n(1.0));
    let sum = modulo_of(arith(b'+', &a, &word), 16.0);
    let a_next = choose(
        index.clone(),
        &[
            word.clone(),
            sum,
            b.clone(),
            a.clone(),
            a.clone(),
            a.clone(),
            a.clone(),
            a.clone(),
        ],
    );
    let inc = modulo_of(arith(b'+', &p, &n(1.0)), 16.0);
    let not_zero = match equal(&a, &n(0.0)) {
        Val::Bool(z) => Val::Bool(!z),
        other => other,
    };
    let jump = if_(&not_zero, || word.clone(), || inc.clone()).settled();
    let p_next = choose(
        index,
        &[
            inc.clone(),
            inc.clone(),
            inc.clone(),
            jump,
            p.clone(),
            p.clone(),
            p.clone(),
            p.clone(),
        ],
    );
    let b_next = if_(&equal(&op, &n(2.0)), || a.clone(), || b.clone()).settled();
    [op, word, a, p, b, a_next, inc, p_next, b_next]
}

/// Level k's outputs due, as the Lab's formulas compute them from its
/// inputs as its test reads them (decision 17's specification); a clocked
/// level's its flip-flops' next state.
pub fn due(k: usize, s: &[Val]) -> Vec<Val> {
    let n = |x: f64| Val::Num(x);
    let is_one = |v: &Val| equal(v, &n(1.0));
    match k {
        0 => vec![arith(b'-', &n(1.0), &s[0])],
        1 => vec![arith(b'*', &s[0], &s[1])],
        2 => vec![max_of(&[&s[0], &s[1]])],
        3 => vec![modulo_of(arith(b'+', &s[0], &s[1]), 2.0)],
        4 => vec![if_(&is_one(&s[2]), || s[1].clone(), || s[0].clone()).settled()],
        5 => vec![
            arith(b'*', &s[0], &arith(b'-', &n(1.0), &s[1])),
            arith(b'*', &s[0], &s[1]),
        ],
        6 => {
            let t = arith(b'+', &s[0], &s[1]);
            vec![modulo_of(t.clone(), 2.0), int_of(arith(b'/', &t, &n(2.0)))]
        }
        7 => {
            let t = arith(b'+', &arith(b'+', &s[0], &s[1]), &s[2]);
            vec![modulo_of(t.clone(), 2.0), int_of(arith(b'/', &t, &n(2.0)))]
        }
        8 => {
            let t = quattuor(s);
            vec![
                a_bit_of(&t, 0),
                a_bit_of(&t, 1),
                a_bit_of(&t, 2),
                a_bit_of(&t, 3),
                int_of(arith(b'/', &t, &n(16.0))),
            ]
        }
        9 => vec![s[0].clone()],
        10 => vec![if_(&is_one(&s[0]), || s[1].clone(), || s[2].clone()).settled()],
        11 => (0..4)
            .map(|i| if_(&is_one(&s[0]), || s[1 + i].clone(), || s[5 + i].clone()).settled())
            .collect(),
        12 => {
            let t = numera(s);
            (0..4)
                .map(|i| if_(&is_one(&s[0]), || n(0.0), || a_bit_of(&t, i)))
                .collect()
        }
        13 => {
            let t = ratio(s);
            let index = arith(
                b'+',
                &arith(b'+', &s[8], &arith(b'*', &n(2.0), &s[9])),
                &n(1.0),
            );
            let mut owed: Vec<Val> = (0..4)
                .map(|i| {
                    choose(
                        index.clone(),
                        &[
                            arith(b'*', &s[i], &s[4 + i]),
                            max_of(&[&s[i], &s[4 + i]]),
                            modulo_of(arith(b'+', &s[i], &s[4 + i]), 2.0),
                            a_bit_of(&t, i),
                        ],
                    )
                })
                .collect();
            owed.push(if_(
                &and(&[is_one(&s[8]), is_one(&s[9])]),
                || int_of(arith(b'/', &t, &n(16.0))),
                || n(0.0),
            ));
            owed
        }
        _ => {
            let w = machina(s);
            let bits = |v: &Val| (0..4).map(|i| a_bit_of(v, i)).collect::<Vec<Val>>();
            let mut owed = bits(&w[5]);
            owed.extend(bits(&w[7]));
            owed.extend(bits(&w[8]));
            owed
        }
    }
}

/// IX's sum of its inputs, the Lab's O19.
fn quattuor(s: &[Val]) -> Val {
    weighted(
        s,
        &[
            (0, 1.0),
            (1, 2.0),
            (2, 4.0),
            (3, 8.0),
            (4, 1.0),
            (5, 2.0),
            (6, 4.0),
            (7, 8.0),
            (8, 1.0),
        ],
    )
}

/// XIII's count at the next tick, the Lab's O23: its inc and its q.
fn numera(s: &[Val]) -> Val {
    weighted(s, &[(1, 1.0), (2, 1.0), (3, 2.0), (4, 4.0), (5, 8.0)])
}

/// XIV's sum of its a and its b, the Lab's O24.
fn ratio(s: &[Val]) -> Val {
    weighted(
        s,
        &[
            (0, 1.0),
            (1, 2.0),
            (2, 4.0),
            (3, 8.0),
            (4, 1.0),
            (5, 2.0),
            (6, 4.0),
            (7, 8.0),
        ],
    )
}

/// A formula's text as the Gates sheet reads it, `FORMULATEXT` with its
/// spaces and its `$` gone and upper-cased (the short slice of 2026-10-24).
pub fn gate_text(formula: &str) -> String {
    formula
        .chars()
        .filter(|&c| c != ' ' && c != '$')
        .map(|c| c.to_ascii_uppercase())
        .collect()
}

/// The inputs a gate of level k may read, the Lab's P, between bars: its
/// switches and flip-flops, the cells of its room row by row, 0 and 1.
pub fn inputs_of(k: usize) -> String {
    let level = &LEVELS[k];
    let mut out = String::from("|");
    for s in 0..level.switches() {
        out.push_str(&format!("A{}|", 3 + s));
    }
    for row in 3..3 + level.rows {
        for col in "CDEFGHIJ".chars() {
            out.push_str(&format!("{col}{row}|"));
        }
    }
    out.push_str("0|1|");
    out
}

/// `MID(f, start, n)` over a text's characters: `None` for an error, a
/// start before the first or a length below 0.
fn mid(f: &[char], start: i64, n: i64) -> Option<String> {
    if start < 1 || n < 0 {
        return None;
    }
    Some(f.iter().skip(start as usize - 1).take(n as usize).collect())
}

/// `FIND(c, f, from)`: the place of a text's first `c` at or after `from`,
/// from 1.
fn find_from(f: &[char], c: char, from: i64) -> Option<i64> {
    f.iter()
        .skip(from as usize - 1)
        .position(|&x| x == c)
        .map(|i| i as i64 + from)
}

/// `FIND(c, f)`: the place of a text's first `c`, from 1.
fn find(f: &[char], c: char) -> Option<i64> {
    find_from(f, c, 1)
}

/// A room cell's kind by its formula's text as [`gate_text`] reads it, as
/// the Gates sheet computes it: 0 no formula; a gate of the set, 1 a wire
/// `=x`, 2 NON-ET `=1-x*y`, 3 NON `=1-x`, 4 ET `=x*y`, 5 VEL `=MAX(x,y)`, 6
/// AUT `=MOD(x+y,2)`, 7 ELIGE `=IF(s,b,a)`, each input among `inputs`,
/// [`inputs_of`] the level's; and 9 any other formula.
pub fn kind(f: &str, inputs: &str) -> u32 {
    if f.is_empty() {
        return 0;
    }
    let c: Vec<char> = f.chars().collect();
    let len = c.len() as i64;
    let among = |x: Option<String>| x.is_some_and(|x| inputs.contains(&format!("|{x}|")));
    let pair = |x: Option<String>, y: Option<String>| among(x) && among(y);
    let (star, comma, plus) = (find(&c, '*'), find(&c, ','), find(&c, '+'));
    let second = comma.and_then(|p| find_from(&c, ',', p + 1));
    if among(mid(&c, 2, 99)) {
        1
    } else if f.starts_with("=1-")
        && star.is_some_and(|p| pair(mid(&c, 4, p - 4), mid(&c, p + 1, 99)))
    {
        2
    } else if f.starts_with("=1-") && among(mid(&c, 4, 99)) {
        3
    } else if star.is_some_and(|p| pair(mid(&c, 2, p - 2), mid(&c, p + 1, 99))) {
        4
    } else if f.starts_with("=MAX(")
        && f.ends_with(')')
        && comma.is_some_and(|p| pair(mid(&c, 6, p - 6), mid(&c, p + 1, len - p - 1)))
    {
        5
    } else if f.starts_with("=MOD(")
        && f.ends_with(",2)")
        && plus.is_some_and(|p| pair(mid(&c, 6, p - 6), mid(&c, p + 1, len - p - 3)))
    {
        6
    } else if f.starts_with("=IF(")
        && f.ends_with(')')
        && comma.is_some_and(|p| {
            second.is_some_and(|q| {
                among(mid(&c, 5, p - 5))
                    && among(mid(&c, p + 1, q - p - 1))
                    && among(mid(&c, q + 1, len - q - 1))
            })
        })
    {
        7
    } else {
        9
    }
}

/// Formulas a person may write and their kinds, at I and at IX (I's inputs
/// its one switch and its room to row 10, IX's nine and its room to row 11):
/// the seven shapes, written in any case with spaces and `$`, a constant among
/// the inputs; and the formulas outside the set, a gate of none of its
/// shapes, a shape holding two gates, and an input that is no switch or room
/// cell of the level, the due, a name or the Lab among them.
pub const SHAPES: [(&str, u32, u32); 35] = [
    ("=1-A3*A3", 2, 2),
    ("=1-A3", 3, 3),
    ("=A3*C3", 4, 4),
    ("=MAX(A3,C3)", 5, 5),
    ("=MOD(A3+C3,2)", 6, 6),
    ("=C3", 1, 1),
    ("=1", 1, 1),
    ("=mod(a3 + c3, 2)", 6, 6),
    ("=1-$A$3*C$3", 2, 2),
    ("=1-A3*0", 2, 2),
    ("=MAX(A3,J10)", 5, 5),
    ("=A4", 9, 1),
    ("=C11", 9, 1),
    ("=1-MAX(A3,C3)", 9, 9),
    ("=M3", 9, 9),
    ("=1-A3*A3*A3", 9, 9),
    ("=MAX(A3,C3)*1", 9, 9),
    ("=MOD(A3,2)", 9, 9),
    ("=K3", 9, 9),
    ("=1-Lab!B21*A3", 9, 9),
    ("=--A3", 9, 9),
    ("=(A3)", 9, 9),
    ("=-A3+INT(A3/2)", 9, 9),
    ("=MIN(A3:A3)", 9, 9),
    ("=MAX(A3,C3,D3)", 9, 9),
    ("=MOD(A3+C3,3)", 9, 9),
    ("=A3*TRUE", 9, 9),
    ("=AC3", 9, 9),
    ("=1-B3", 9, 9),
    ("=IF(A3,C3,0)", 7, 7),
    ("=if($a$3, c3, 1)", 7, 7),
    ("=IF(A4,C3,D3)", 9, 7),
    ("=IF(A3,C3)", 9, 9),
    ("=IF(A3,C3,D3,E3)", 9, 9),
    ("=IF(A3=1,C3,D3)", 9, 9),
];

/// The address of a room's cell by its place in the room read row by row
/// from C3, eight cells a row, 1 the first: the Lab's R and S.
pub fn room_address(i: usize) -> String {
    format!(
        "{}{}",
        &"CDEFGHIJ"[(i - 1) % 8..=(i - 1) % 8],
        3 + (i - 1) / 8
    )
}

/// What a person wrote into a level's cell, the cartridge's own row gone: a
/// value, or a formula's text as written and the hand's reading of it.
#[derive(Clone, Debug)]
pub enum Written {
    Value(Val),
    Formula(String, Gex),
}

impl Written {
    /// A person's formula, read by the hand or refused by name.
    pub fn formula(text: &str) -> Result<Written, String> {
        Ok(Written::Formula(text.to_string(), gex(text)?))
    }
}

/// An act's Input rows, as the host writes them for a version 6 cartridge
/// at rate 0: the place, the press and the command.
#[derive(Clone, Debug, Default, PartialEq)]
pub struct Acted {
    pub sheet: String,
    pub col: u32,
    pub row: u32,
    pub press: bool,
    pub command: String,
}

/// A value as `N` reads it, then `IFERROR`'s 0: a number itself, a truth value
/// 1 or 0, and anything else 0, so that a tick carries no error around the
/// loop.
fn as_a_flip_flop_takes(v: &Val) -> Val {
    match v {
        Val::Num(x) => Val::Num(*x),
        Val::Bool(b) => Val::Num(f64::from(u8::from(*b))),
        _ => Val::Num(0.0),
    }
}

/// How many of two lists' values differ, as `SUMPRODUCT(--(x<>y))` counts
/// them; `None` for an error in either.
fn differing(x: &[Val], y: &[Val]) -> Option<usize> {
    let mut count = 0;
    for (a, b) in x.iter().zip(y) {
        match equal(a, b) {
            Val::Bool(same) => count += usize::from(!same),
            _ => return None,
        }
    }
    Some(count)
}

/// The game by hand, the levels, the ROM and the Lab frame by frame, as the
/// cartridge's formulas compute them, its own arithmetic and no formula of
/// the cartridge's: what the engine's frames are held to.
#[derive(Clone, Debug)]
pub struct Game {
    /// Each level's cells a person wrote, by row and column.
    pub written: Vec<HashMap<(u32, u32), Written>>,
    /// Each level's cells of column A, this frame and the last.
    pub switches: Vec<Vec<Val>>,
    pub switches_last: Vec<Vec<Val>>,
    /// Each level's cells as this frame computes them: the board, A3 to the
    /// last row of its room, A to M.
    pub board: Vec<HashMap<(u32, u32), Val>>,
    /// Each level's room as the Gates sheet reads it this frame, row by row
    /// from C3: each cell's formula's text ([`gate_text`], empty for none)
    /// and its kind ([`kind`]).
    pub texts: Vec<Vec<String>>,
    pub kinds: Vec<Vec<u32>>,
    /// The Lab, its cells by address, this frame and the last.
    pub lab: HashMap<String, Val>,
    pub lab_last: HashMap<String, Val>,
    /// The ROM's program, its B2:B17.
    pub rom: Vec<Val>,
    /// The Input rows standing.
    pub input: Acted,
    /// The frames computed.
    pub frames: u64,
    /// Each level this frame computed, the others standing as they stood; and
    /// each whose gates a person's row changed at this frame.
    pub touched: Vec<bool>,
    pub fresh: Vec<bool>,
    /// A person's row into a level since its last frame, and each level an
    /// act, a test or a clock moved at the last frame.
    dirty: Vec<bool>,
    caused: Vec<bool>,
    /// The Write sheet's row the last frame left, its level, its cell and its
    /// value, which lands before this frame (decision 47).
    derived: Option<(usize, (u32, u32), f64)>,
}

impl Default for Game {
    fn default() -> Self {
        Game::new()
    }
}

impl Game {
    pub fn new() -> Game {
        Game {
            written: vec![HashMap::new(); LEVELS.len()],
            switches: LEVELS
                .iter()
                .map(|l| vec![Val::Num(0.0); l.switches() as usize])
                .collect(),
            switches_last: LEVELS
                .iter()
                .map(|l| vec![Val::Empty; l.switches() as usize])
                .collect(),
            board: vec![HashMap::new(); LEVELS.len()],
            texts: vec![Vec::new(); LEVELS.len()],
            kinds: vec![Vec::new(); LEVELS.len()],
            lab: HashMap::new(),
            lab_last: HashMap::new(),
            rom: (0..16)
                .map(|i| {
                    ROM_PROGRAM
                        .get(i)
                        .map_or(Val::Empty, |t| Val::Text(t.to_string()))
                })
                .collect(),
            input: Acted::default(),
            frames: 0,
            touched: vec![true; LEVELS.len()],
            fresh: vec![true; LEVELS.len()],
            dirty: vec![true; LEVELS.len()],
            caused: vec![true; LEVELS.len()],
            derived: None,
        }
    }

    /// A level by its sheet's name, compared without case.
    pub fn level(sheet: &str) -> Option<usize> {
        LEVELS
            .iter()
            .position(|l| l.sheet.eq_ignore_ascii_case(sheet))
    }

    /// A person's row into a level, a value or a formula over a cell or a
    /// range, or into the ROM's program, a value. A row into any other sheet
    /// of the game's, or a formula into the ROM, is refused by the hand, which
    /// models none.
    pub fn write(
        &mut self,
        sheet: &str,
        rows: (u32, u32, u32, u32),
        what: Written,
    ) -> Result<(), String> {
        if sheet.eq_ignore_ascii_case("ROM") {
            let Written::Value(v) = what else {
                return Err("the hand models no formula in the ROM".to_string());
            };
            if rows.1 != 2 || rows.3 != 2 || rows.0 < 2 || rows.2 > 17 {
                return Err(format!(
                    "the hand models the ROM's program alone, not {rows:?}"
                ));
            }
            for r in rows.0..=rows.2 {
                self.rom[r as usize - 2] = v.clone();
            }
            self.dirty[MACHINA] = true;
            return Ok(());
        }
        let Some(k) = Game::level(sheet) else {
            return Err(format!("the hand models no person's row into {sheet}"));
        };
        if let Written::Formula(_, g) = &what {
            let mut reads = Vec::new();
            g.reads(&mut reads);
            if rows.0 != rows.2 || rows.1 != rows.3 {
                return Err(format!(
                    "the hand writes a formula into one cell, not {rows:?}"
                ));
            }
            for (r, c) in reads {
                if r < 3 || c > 13 {
                    return Err(format!("the hand evaluates a gate's reads of its board alone, not row {r} column {c}"));
                }
            }
        }
        for r in rows.0..=rows.2 {
            for c in rows.1..=rows.3 {
                self.written[k].insert((r, c), what.clone());
            }
        }
        self.dirty[k] = true;
        Ok(())
    }

    fn lab(&self, at: &str) -> Val {
        self.lab.get(at).cloned().unwrap_or(Val::Empty)
    }
    fn last(&self, at: &str) -> Val {
        self.lab_last.get(at).cloned().unwrap_or(Val::Empty)
    }
    /// A number of the Lab's clock at the last frame, nothing 0.
    fn last_number(&self, at: &str) -> f64 {
        match self.last(at) {
            Val::Num(x) => x,
            _ => 0.0,
        }
    }

    /// Whether this frame holds every cell, and not only what its acts could
    /// move (decision 44): one frame in 64, the first among them. The others
    /// hold each level this frame computed, so that a long test is held at
    /// its own board at every input and the rest at this rhythm.
    pub fn whole(&self) -> bool {
        self.frames % 64 == 1
    }

    /// The Lab's cells this frame holds: its state and its clock; and each
    /// level's row where the level was computed; and at a whole frame its
    /// inputs as tested, its dues and its workings too.
    pub fn lab_held(&self) -> Vec<String> {
        let whole = self.whole();
        let mut at: Vec<String> = (1..=8).map(|r| format!("B{r}")).collect();
        at.extend((1..=9).map(|r| format!("E{r}")));
        at.push("H1".to_string());
        for (k, level) in LEVELS.iter().enumerate() {
            if !(whole || self.touched[k]) {
                continue;
            }
            let r = 11 + k;
            for col in "BCDEHKLNPQRSTU".chars() {
                at.push(format!("{col}{r}"));
            }
            if level.state > 0 {
                at.push(format!("I{r}"));
                at.push(format!("J{r}"));
            }
        }
        if whole {
            for (k, level) in LEVELS.iter().enumerate() {
                let r = 11 + k;
                at.extend(["F", "G", "M", "W"].map(|col| format!("{col}{r}")));
                if level.state > 0 {
                    at.push(format!("V{r}"));
                }
            }
            at.extend(["O19", "O23", "O24"].map(str::to_string));
            at.extend((64..=72).map(|r| format!("P{r}")));
            for (k, level) in LEVELS.iter().enumerate() {
                let col = char::from(b'B' + k as u8);
                at.extend((0..level.switches()).map(|s| format!("{col}{}", 31 + s)));
                at.extend((0..level.outputs).map(|o| format!("{col}{}", 51 + o)));
            }
        }
        at
    }

    /// The Write sheet's row as this frame computes it: its sheet, its address
    /// and its value (decision 47).
    pub fn write_row(&self) -> [Val; 3] {
        let typed = matches!(self.lab("H1"), Val::Num(x) if x == 1.0);
        let i = &self.input;
        let text = |t: String| Val::Text(if typed { t } else { String::new() });
        [
            text(i.sheet.clone()),
            text(format!(
                "{}{}",
                "CDEFGHIJ"
                    .chars()
                    .nth(i.col.saturating_sub(3) as usize)
                    .unwrap_or('C'),
                i.row
            )),
            Val::Num(if i.command == "one" { 1.0 } else { 0.0 }),
        ]
    }

    /// A cell of the ROM's, A to E of its rows 2 to 17, as this frame computes
    /// it: its line, its text, its word's number, the mark of the line p
    /// names, and what it says of a word none of the five.
    pub fn rom_cell(&self, row: u32, col: u32) -> Val {
        let line = &self.rom[row as usize - 2];
        match col {
            1 => Val::Num(f64::from(row - 2)),
            2 => line.clone(),
            3 => Val::Num(rom_word(line)),
            4 => {
                let here = equal(&Val::Num(f64::from(row - 2)), &self.lab("E7"));
                if matches!(here, Val::Bool(true)) {
                    Val::Text("\u{25c4}".into())
                } else {
                    Val::Text(String::new())
                }
            }
            _ => {
                let text = line.text().unwrap_or_default();
                let word = text.chars().take(3).collect::<String>().to_uppercase();
                if text.is_empty() || ROM_WORDS.contains(&word.as_str()) {
                    Val::Text(String::new())
                } else {
                    Val::Text("no such word: HLT".into())
                }
            }
        }
    }

    /// One frame: the act's Input rows, or a settle step's, the press and the
    /// command released; every level an act, a test, a clock or a person's row
    /// could move computed, and the Lab.
    pub fn frame(&mut self, act: Option<&Acted>) {
        match act {
            Some(a) => self.input = a.clone(),
            None => {
                self.input.press = false;
                self.input.command.clear();
            }
        }
        if let Some((k, at, value)) = self.derived.take() {
            self.written[k].insert(at, Written::Value(Val::Num(value)));
            self.dirty[k] = true;
        }
        self.lab_last = self.lab.clone();
        let first = self.frames == 0;
        self.frames += 1;
        let i = self.input.clone();
        let cmd = Val::Text(i.command.clone());
        let is = |w: &str| {
            equal(&cmd, &Val::Text(w.to_string()))
                .truth()
                .unwrap_or(false)
        };
        let n = |x: f64| Val::Num(x);
        let at_one = |v: &Val| matches!(v, Val::Num(x) if *x == 1.0);
        // B1 the level the act stands on
        let shown = LEVELS
            .iter()
            .position(|l| l.sheet.eq_ignore_ascii_case(&i.sheet))
            .map_or(0.0, |k| (k + 1) as f64);
        self.lab.insert("B1".into(), n(shown));
        // B2 the level N and P move to, B3 the Camera's sheet
        let last_b2 = match self.last("B2") {
            Val::Num(x) => x.max(1.0),
            _ => 1.0,
        };
        let b2 = if is("next") && shown > 0.0 {
            (shown + 1.0).min(LEVELS.len() as f64)
        } else if is("previous") && shown > 0.0 {
            (shown - 1.0).max(1.0)
        } else {
            last_b2
        };
        self.lab.insert("B2".into(), n(b2));
        let b3 = if is("next") || is("previous") {
            Val::Text(LEVELS[b2 as usize - 1].sheet.to_string())
        } else {
            Val::Text(String::new())
        };
        self.lab.insert("B3".into(), b3);
        // B4 the level under test, B5 whether it runs, B6 its input, B7 its inputs
        let b4 = if is("test") {
            n(shown)
        } else {
            self.last("B4").settled()
        };
        self.lab.insert("B4".into(), b4.clone());
        let b5 = if is("test") {
            n(if shown > 0.0 { 1.0 } else { 0.0 })
        } else if is("reset") {
            n(0.0)
        } else {
            let (l5, l8, l6, l7) = (
                self.last("B5"),
                self.last("B8"),
                self.last("B6"),
                self.last("B7"),
            );
            if_(
                &equal(&l5, &n(1.0)),
                || {
                    if_(
                        &and(&[equal(&l8, &n(1.0)), less(&l6, &arith(b'-', &l7, &n(1.0)))]),
                        || n(1.0),
                        || n(0.0),
                    )
                },
                || n(0.0),
            )
        };
        self.lab.insert("B5".into(), b5.clone());
        let b6 = if is("test") {
            n(0.0)
        } else {
            let (l5, l6) = (self.last("B5"), self.last("B6"));
            if_(
                &and(&[equal(&l5, &n(1.0)), equal(&b5, &n(1.0))]),
                || arith(b'+', &l6, &n(1.0)),
                || l6.clone(),
            )
            .settled()
        };
        self.lab.insert("B6".into(), b6.clone());
        let under = match &b4 {
            Val::Num(x) if *x >= 1.0 => *x as usize,
            _ => 1,
        };
        self.lab
            .insert("B7".into(), n(f64::from(LEVELS[under - 1].vectors)));
        // the clock: E2 the level last run, E3 whether it runs, E1 the level that ticks, E4 its ticks, E6 its states, E9 how it ended
        let (l3, l4, l5, l9) = (
            self.last_number("E3"),
            self.last_number("E4"),
            self.last_number("E5"),
            self.last_number("E9"),
        );
        let states = |no: f64| f64::from(LEVELS[no.max(1.0) as usize - 1].limit());
        let e2 = if is("run") {
            shown
        } else {
            self.last_number("E2")
        };
        let e3 = if is("run") {
            if states(shown) > 0.0 {
                1.0
            } else {
                0.0
            }
        } else if l3 != 1.0 || l4 >= self.last_number("E6") || (l4 > 0.0 && l5 == 0.0) {
            0.0
        } else {
            1.0
        };
        let e1 = if is("tick") {
            shown
        } else if e3 == 1.0 {
            e2
        } else {
            0.0
        };
        let e4 = if is("run") {
            0.0
        } else if e3 == 1.0 {
            l4 + 1.0
        } else {
            l4
        };
        let e9 = if is("run") || is("reset") {
            0.0
        } else if l3 == 1.0 && e3 == 0.0 {
            if l5 > 0.0 {
                2.0
            } else {
                1.0
            }
        } else {
            l9
        };
        for (at, v) in [
            ("E1", e1),
            ("E2", e2),
            ("E3", e3),
            ("E4", e4),
            ("E6", states(e2)),
            ("E9", e9),
        ] {
            self.lab.insert(at.into(), n(v));
        }
        let (l4v, l5v, l8v, l6v) = (
            self.last("B4"),
            self.last("B5"),
            self.last("B8"),
            self.last("B6"),
        );
        // each level: whether its test runs and its clock ticks, and what they, an act or a person's row move
        for (k, level) in LEVELS.iter().enumerate() {
            let r = 11 + k;
            let kk = n((k + 1) as f64);
            let here = if_(&equal(&b4, &kk), || b5.clone(), || n(0.0)).settled();
            self.lab.insert(format!("N{r}"), here.clone());
            let ticks = e1 == (k + 1) as f64;
            let sheet = level.sheet;
            let on_level = i.sheet.eq_ignore_ascii_case(sheet);
            let was_ticking = at_one(&self.last(&format!("I{r}")));
            let tests = at_one(&here) || at_one(&self.last(&format!("N{r}")));
            let caused = first
                || self.dirty[k]
                || tests
                || ticks
                || was_ticking
                || (on_level && (!i.command.is_empty() || i.press));
            // and the frame after, whose twins read what that one moved
            let touched = caused || self.caused[k];
            self.caused[k] = caused;
            let fresh = first || self.dirty[k];
            if level.state > 0 {
                self.lab
                    .insert(format!("I{r}"), n(if ticks { 1.0 } else { 0.0 }));
            }
            self.touched[k] = touched;
            self.fresh[k] = fresh;
            if !touched {
                continue;
            }
            self.switches_last[k] = self.switches[k].clone();
            // its result and the input its test stopped at
            let (last_b, last_c) = (
                self.last(&format!("B{r}")).settled(),
                self.last(&format!("C{r}")).settled(),
            );
            let away = |v: &Val| match equal(v, &kk) {
                Val::Bool(b) => Val::Bool(!b),
                other => other,
            };
            let gone = or(&[away(&l4v), away(&b4)]);
            let ended = and(&[equal(&l5v, &n(1.0)), equal(&b5, &n(0.0))]);
            let result = if is("reset") && shown == (k + 1) as f64 {
                n(0.0)
            } else {
                if_(
                    &gone,
                    || last_b.clone(),
                    || {
                        if_(
                            &ended,
                            || if_(&equal(&l8v, &n(1.0)), || n(1.0), || n(2.0)),
                            || last_b.clone(),
                        )
                    },
                )
            };
            let stopped = if_(
                &gone,
                || last_c.clone(),
                || if_(&ended, || l6v.clone().settled(), || last_c.clone()),
            );
            self.lab.insert(format!("B{r}"), result.clone());
            self.lab.insert(format!("C{r}"), stopped);
            // its switches and its flip-flops, each its own last value
            let total = level.switches() as usize;
            let inputs_n = level.inputs as usize;
            for s in (0..total).rev() {
                let row = 3 + s as u32;
                if k == MACHINA && s < inputs_n {
                    continue;
                }
                if self.written[k].contains_key(&(row, 1)) {
                    continue;
                }
                let last = self.switches_last[k][s].clone();
                let flip_flop = s >= inputs_n;
                let v = if (is("reset") || (flip_flop && is("run"))) && on_level {
                    n(0.0)
                } else {
                    if_(
                        &equal(&here, &n(1.0)),
                        || test_input(k, s, &b6),
                        || {
                            if flip_flop && ticks {
                                let next = self.board[k]
                                    .get(&(3 + (s - inputs_n) as u32, 10))
                                    .cloned()
                                    .unwrap_or(Val::Empty);
                                as_a_flip_flop_takes(&next)
                            } else if on_level && i.col == 1 && i.row == row {
                                if is("one") {
                                    n(1.0)
                                } else if is("zero") {
                                    n(0.0)
                                } else if is("toggle") || i.press {
                                    arith(b'-', &n(1.0), &last)
                                } else {
                                    last.clone().settled()
                                }
                            } else {
                                last.clone().settled()
                            }
                        },
                    )
                };
                self.switches[k][s] = v;
            }
            // XV's word: the ROM's line at p, E7, and its number, E8
            if k == MACHINA {
                let sw = &self.switches[k];
                let p = weighted(sw, &[(11, 1.0), (12, 2.0), (13, 4.0), (14, 8.0)]);
                let word = match &p {
                    Val::Num(x) if *x >= 0.0 && *x < 16.0 => rom_word(&self.rom[*x as usize]),
                    _ => 4.0,
                };
                self.lab.insert("E7".into(), p);
                self.lab.insert("E8".into(), n(word));
                for s in 0..inputs_n {
                    let row = 3 + s as u32;
                    if self.written[k].contains_key(&(row, 1)) {
                        continue;
                    }
                    let last = self.switches_last[k][s].clone().settled();
                    self.switches[k][s] = if_(
                        &equal(&here, &n(1.0)),
                        || test_input(k, s, &b6),
                        || {
                            if matches!(result, Val::Num(x) if x == 2.0) && !ticks {
                                last.clone()
                            } else {
                                a_bit_of(&n(word), s)
                            }
                        },
                    );
                }
            }
            self.compute_board(k, &(here.clone(), b6.clone()));
            let sw: Vec<Val> = (0..level.switches())
                .map(|s| self.cell(k, 3 + s, 1))
                .collect();
            let inputs = tested(k, &here, &b6, &sw);
            let col = char::from(b'B' + k as u8);
            for (s, v) in inputs.iter().enumerate() {
                self.lab.insert(format!("{col}{}", 31 + s), v.clone());
            }
            let owed = due(k, &inputs);
            for (o, d) in owed.iter().enumerate() {
                self.lab.insert(format!("{col}{}", 51 + o), d.clone());
            }
            match k {
                8 => {
                    self.lab.insert("O19".into(), quattuor(&inputs));
                }
                12 => {
                    self.lab.insert("O23".into(), numera(&inputs));
                }
                13 => {
                    self.lab.insert("O24".into(), ratio(&inputs));
                }
                MACHINA => {
                    for (j, v) in machina(&inputs).into_iter().enumerate() {
                        self.lab.insert(format!("P{}", 64 + j), v);
                    }
                }
                _ => {}
            }
            // whether every switch stands where its test wants it, and every output is its due, an error never
            let held = differing(&sw, &inputs) == Some(0);
            self.lab
                .insert(format!("K{r}"), n(if held { 1.0 } else { 0.0 }));
            let outs: Vec<Val> = (0..level.outputs)
                .map(|o| self.cell(k, 3 + o, 10))
                .collect();
            let ok = held && differing(&outs, &owed) == Some(0);
            self.lab
                .insert(format!("D{r}"), n(if ok { 1.0 } else { 0.0 }));
            // its flip-flops moved at this frame, each against its twin
            if level.state > 0 {
                let moved = differing(&sw[inputs_n..], &self.switches_last[k][inputs_n..])
                    .map_or(0.0, |m| m as f64);
                self.lab.insert(format!("J{r}"), n(moved));
                self.lab
                    .insert(format!("V{r}"), n(f64::from(level.limit())));
            }
            // the gates: every formula of its room, each read by its text as one of the set or outside it; and the
            // room's first cell holding an error
            if fresh {
                let inputs = inputs_of(k);
                let (mut texts, mut kinds) = (Vec::new(), Vec::new());
                for row in 3..3 + level.rows {
                    for col in 3..=10 {
                        let text = match self.written[k].get(&(row, col)) {
                            Some(Written::Formula(f, _)) => gate_text(f),
                            _ => String::new(),
                        };
                        kinds.push(kind(&text, &inputs));
                        texts.push(text);
                    }
                }
                let outside = kinds.iter().filter(|&&q| q > level.gives).count();
                let first = kinds.iter().position(|&q| q > level.gives);
                let gates = kinds.iter().filter(|&&q| q > 0).count();
                self.lab.insert(format!("E{r}"), n(gates as f64));
                self.lab.insert(format!("F{r}"), n(f64::from(level.budget)));
                self.lab.insert(format!("G{r}"), n(f64::from(level.least)));
                self.lab
                    .insert(format!("M{r}"), n(f64::from(level.vectors)));
                self.lab
                    .insert(format!("W{r}"), n(f64::from(2 + level.rows)));
                self.lab.insert(format!("P{r}"), Val::Text(inputs));
                self.lab.insert(format!("Q{r}"), n(outside as f64));
                self.lab.insert(
                    format!("R{r}"),
                    Val::Text(first.map_or(String::new(), |i| room_address(i + 1))),
                );
                self.texts[k] = texts;
                self.kinds[k] = kinds;
            }
            let mut error = None;
            'room: for (place, (row, col)) in (3..3 + level.rows)
                .flat_map(|row| (3..=10).map(move |col| (row, col)))
                .enumerate()
            {
                if matches!(self.cell(k, row, col), Val::Err(_)) {
                    error = Some(place + 1);
                    break 'room;
                }
            }
            self.lab.insert(
                format!("S{r}"),
                Val::Text(error.map_or(String::new(), room_address)),
            );
            // its gates and those outside the set, and whether its switches held, when its test last ended, which its
            // stars and its verdict read
            let last_held = self.last(&format!("K{r}"));
            let (e, q) = (self.lab(&format!("E{r}")), self.lab(&format!("Q{r}")));
            let mut at_test_end = |col: &str, now: Val| {
                let last = self.last(&format!("{col}{r}")).settled();
                let v = if_(
                    &gone,
                    || last.clone(),
                    || if_(&ended, || now.clone(), || last.clone()),
                );
                self.lab.insert(format!("{col}{r}"), v.clone());
                v
            };
            let t = at_test_end("T", e);
            let u = at_test_end("U", q);
            at_test_end("L", last_held.settled());
            let (f, g) = (self.lab(&format!("F{r}")), self.lab(&format!("G{r}")));
            let stars = if_(
                &equal(&result, &n(1.0)),
                || {
                    if_(
                        &less(&n(0.0), &u),
                        || Val::Text("★☆☆".into()),
                        || {
                            if_(
                                &less_equal(&t, &g),
                                || Val::Text("★★★".into()),
                                || {
                                    if_(
                                        &less_equal(&t, &f),
                                        || Val::Text("★★☆".into()),
                                        || Val::Text("★☆☆".into()),
                                    )
                                },
                            )
                        },
                    )
                },
                || Val::Text("☆☆☆".into()),
            );
            self.lab.insert(format!("H{r}"), stars);
            self.dirty[k] = false;
        }
        let b8 = self.lab(&format!("D{}", 10 + under));
        self.lab.insert("B8".into(), b8);
        // 1 or 0 on a cell of the level's room that holds no gate: the Write sheet's row, a frame on (decision 47)
        let typed = (is("one") || is("zero")) && shown > 0.0 && {
            let k = shown as usize - 1;
            (3..=10).contains(&i.col)
                && (3..3 + LEVELS[k].rows).contains(&i.row)
                && self.kinds[k][8 * (i.row - 3) as usize + (i.col - 3) as usize] == 0
        };
        self.lab
            .insert("H1".into(), n(if typed { 1.0 } else { 0.0 }));
        if typed {
            self.derived = Some((
                shown as usize - 1,
                (i.row, i.col),
                if is("one") { 1.0 } else { 0.0 },
            ));
        }
        let e5 = match self.lab(&format!("J{}", 10 + (e2.max(1.0) as usize))) {
            Val::Num(x) => x,
            _ => 0.0,
        };
        self.lab.insert("E5".into(), n(e5));
    }

    /// A level's cell as this frame computes it.
    pub fn cell(&self, k: usize, row: u32, col: u32) -> Val {
        self.board[k]
            .get(&(row, col))
            .cloned()
            .unwrap_or(Val::Empty)
    }

    /// A level's board this frame: its switches, a person's cells, its lamps
    /// and its due, each a cell's value; a person's formula evaluated over
    /// the cells it reads, in their order. `test`, the Lab's N and B6, which
    /// the due's inputs read.
    fn compute_board(&mut self, k: usize, test: &(Val, Val)) {
        let level = &LEVELS[k];
        let total = level.switches();
        let last = 2 + level.rows.max(total);
        let mut board: HashMap<(u32, u32), Val> = HashMap::new();
        let mut doing: Vec<(u32, u32)> = Vec::new();
        let switches = self.switches[k].clone();
        let written = self.written[k].clone();
        // the due, the Lab's, read by M
        fn value(
            at: (u32, u32),
            k: usize,
            test: &(Val, Val),
            switches: &[Val],
            written: &HashMap<(u32, u32), Written>,
            board: &mut HashMap<(u32, u32), Val>,
            doing: &mut Vec<(u32, u32)>,
        ) -> Val {
            if let Some(v) = board.get(&at) {
                return v.clone();
            }
            if doing.contains(&at) {
                return Val::Err("#CYCLE");
            }
            doing.push(at);
            let level = &LEVELS[k];
            let total = level.switches();
            let (row, col) = at;
            let v = match written.get(&at) {
                Some(Written::Value(v)) => v.clone(),
                Some(Written::Formula(_, g)) => {
                    let mut read =
                        |r: u32, c: u32| value((r, c), k, test, switches, written, board, doing);
                    g.eval(&mut read).settled()
                }
                None => {
                    if col == 1 && row >= 3 && row < 3 + total {
                        switches[(row - 3) as usize].clone()
                    } else if col == 12 && row >= 3 && row < 3 + level.outputs {
                        let j = value((row, 10), k, test, switches, written, board, doing);
                        match if_(
                            &equal(&j, &Val::Num(1.0)),
                            || Val::Text("●".into()),
                            || Val::Text("○".into()),
                        ) {
                            Val::Err(_) => Val::Text("?".into()),
                            lamp => lamp,
                        }
                    } else if col == 13 && row >= 3 && row < 3 + level.outputs {
                        let sw: Vec<Val> = (0..total)
                            .map(|s| value((3 + s, 1), k, test, switches, written, board, doing))
                            .collect();
                        due(k, &tested(k, &test.0, &test.1, &sw))[(row - 3) as usize].clone()
                    } else if col == 2 && row >= 3 && row < 3 + total {
                        Val::Text(NAMES[k].0[(row - 3) as usize].to_string())
                    } else if col == 11 && row >= 3 && row < 3 + level.outputs {
                        Val::Text(NAMES[k].1[(row - 3) as usize].to_string())
                    } else {
                        Val::Empty
                    }
                }
            };
            doing.pop();
            board.insert(at, v.clone());
            v
        }
        for row in 3..=last {
            for col in 1..=13 {
                value(
                    (row, col),
                    k,
                    test,
                    &switches,
                    &written,
                    &mut board,
                    &mut doing,
                );
            }
        }
        for &(r, c) in written.keys() {
            value((r, c), k, test, &switches, &written, &mut board, &mut doing);
        }
        // a switch a person wrote over is that cell's value from now on
        for s in 0..total as usize {
            if written.contains_key(&(3 + s as u32, 1)) {
                self.switches[k][s] = board.get(&(3 + s as u32, 1)).cloned().unwrap_or(Val::Empty);
            }
        }
        self.board[k] = board;
    }

    /// A level's reckoning and verdict, its N8 and N9, as the words say them:
    /// its gates, those outside the set and the first of them, and its last
    /// test's stars; its test, and the room's first cell holding an error.
    pub fn words(&self, k: usize) -> (Val, Val) {
        let r = 11 + k;
        let level = &LEVELS[k];
        let inputs = level.vectors;
        let n = |x: f64| Val::Num(x);
        let lab = |col: &str| self.lab(&format!("{col}{r}"));
        let outside = if_(
            &less(&n(0.0), &lab("Q")),
            || match (lab("Q").text(), lab("R").text()) {
                (Ok(q), Ok(at)) => {
                    Val::Text(format!(", {q} outside the set given, the first at {at}"))
                }
                (Err(k), _) | (_, Err(k)) => Val::Err(k),
            },
            || Val::Text(String::new()),
        );
        let reckoning = match (lab("E").text(), outside.text(), lab("H").text()) {
            (Ok(e), Ok(o), Ok(h)) => Val::Text(format!(
                "Gates {e}{o}; the budget {}, the least known {}: {h}",
                level.budget, level.least
            )),
            (Err(k), _, _) | (_, Err(k), _) | (_, _, Err(k)) => Val::Err(k),
        };
        let error = |tail: &str| match lab("S").text() {
            Ok(at) => Val::Text(format!(
                "{at} holds an error: it reads a text, an emptied cell or an error.{tail}"
            )),
            Err(k) => Val::Err(k),
        };
        let no_error = equal(&lab("S"), &Val::Text(String::new()));
        let verdict = if_(
            &equal(&lab("N"), &n(1.0)),
            || match arith(b'+', &self.lab("B6"), &n(1.0)).text() {
                Ok(t) => Val::Text(format!("Calculemus: input {t} of {inputs}")),
                Err(k) => Val::Err(k),
            },
            || {
                if_(
                    &equal(&lab("B"), &n(2.0)),
                    || {
                        let at = if_(
                            &no_error,
                            || {
                                if_(
                                    &equal(&lab("L"), &n(0.0)),
                                    || {
                                        Val::Text("a switch written over does not follow the test. Load restores it, and empties every level.".into())
                                    },
                                    || Val::Text("a lamp differs from its due.".into()),
                                )
                            },
                            || error(""),
                        );
                        match (arith(b'+', &lab("C"), &n(1.0)).text(), at.text()) {
                            (Ok(t), Ok(at)) => Val::Text(format!(
                                "The test stops at input {t} of {inputs}, standing on the board: {at}"
                            )),
                            (Err(k), _) | (_, Err(k)) => Val::Err(k),
                        }
                    },
                    || {
                        if_(
                            &no_error,
                            || {
                                if_(
                                    &equal(&lab("B"), &n(1.0)),
                                    || {
                                        Val::Text(if k == MACHINA {
                                            "Probatum: all 2,048 pass, every word at every A. Testing, said Dijkstra, shows the presence of bugs, never their absence.".to_string()
                                        } else {
                                            format!("Quod erat demonstrandum: every one of its {inputs} inputs passes.")
                                        })
                                    },
                                    || {
                                        Val::Text(
                                            "T tests every input, an input a frame. Calculemus!"
                                                .into(),
                                        )
                                    },
                                )
                            },
                            || error(" Ex nihilo nihil fit."),
                        )
                    },
                )
            },
        );
        (reckoning, verdict)
    }

    /// A clocked level's clock in words, its N11: its keys; the tick a run
    /// stands at; where a run came to rest; or that it never rests.
    pub fn clock_words(&self, k: usize) -> Val {
        let level = &LEVELS[k];
        let keys = "C ticks the clock once. G clears the flip-flops and runs the clock until they stand still.";
        let number = |at: &str| match self.lab(at) {
            Val::Num(x) => x,
            _ => 0.0,
        };
        if number("E2") != (k + 1) as f64 {
            return Val::Text(keys.into());
        }
        let holding = if level.state == 1 {
            "1 flip-flop holds".to_string()
        } else {
            format!("{} flip-flops hold", level.state)
        };
        Val::Text(if number("E3") == 1.0 {
            format!("Currit, it runs: tick {}", general(number("E4")))
        } else if number("E9") == 1.0 {
            format!(
                "Stat, it stands: its last move at tick {}.",
                general(number("E4") - 1.0)
            )
        } else if number("E9") == 2.0 {
            let limit = level.limit();
            format!("In aeternum: {limit} ticks, no rest. {holding} {limit} states, so one came twice: it never halts. A short tape answers Turing.")
        } else {
            keys.to_string()
        })
    }
}

/// A text as a row spells it, between double quotes, a quote and a
/// backslash escaped.
fn quote(text: &str) -> String {
    format!("\"{}\"", text.replace('\\', "\\\\").replace('"', "\\\""))
}

/// A cell's place by its address, `C4` row 4 and column 3, a range's by its
/// first cell.
pub fn place(address: &str) -> (u32, u32) {
    let (mut row, mut col) = (0u32, 0u32);
    for ch in address.split(':').next().unwrap_or("").chars() {
        if ch.is_ascii_alphabetic() {
            col = col * 26 + (ch.to_ascii_uppercase() as u32 - 64);
        } else if let Some(d) = ch.to_digit(10) {
            row = row * 10 + d;
        }
    }
    (row, col)
}

/// A cell or a range, `C4:C5`, as its top, left, bottom and right.
pub fn rect(range: &str) -> (u32, u32, u32, u32) {
    let (a, b) = range.split_once(':').unwrap_or((range, range));
    let ((r1, c1), (r2, c2)) = (place(a), place(b));
    (r1.min(r2), c1.min(c2), r1.max(r2), c1.max(c2))
}

/// A person's edit in the session: the row it writes, and the hand's
/// reading of it, its sheet, its cells and what it writes.
#[derive(Clone, Debug)]
pub struct Edit {
    pub text: String,
    pub sheet: String,
    pub cells: (u32, u32, u32, u32),
    pub what: Written,
}

/// The levels played through (decision 26): the session the stand-in replay
/// plays after the bench, and the engine's tests hold frame by frame to the
/// hand. Each act's place and command, and the row it writes, if any.
pub fn session() -> Vec<(Acted, Option<Edit>)> {
    let act = |sheet: &str, col: u32, row: u32, press: bool, command: &str| Acted {
        sheet: sheet.to_string(),
        col,
        row,
        press,
        command: command.to_string(),
    };
    let gate = |sheet: &str, addr: &str, formula: &str| {
        let (row, col) = place(addr);
        let text = format!(
            "(formula {} {} {})",
            quote(sheet),
            quote(addr),
            quote(formula)
        );
        let what = Written::formula(formula).unwrap_or_else(|e| panic!("{e}"));
        let cells = rect(addr);
        (
            act(sheet, col, row, false, ""),
            Some(Edit {
                text,
                sheet: sheet.to_string(),
                cells,
                what,
            }),
        )
    };
    let value = |sheet: &str, addr: &str, v: Val| {
        let (row, col) = place(addr);
        let spelled = match &v {
            Val::Num(x) => general(*x),
            Val::Text(t) => quote(t),
            other => panic!("the session writes a number or a text, not {other:?}"),
        };
        let text = format!("(cell {} {} {spelled})", quote(sheet), quote(addr));
        let cells = rect(addr);
        (
            act(sheet, col, row, false, ""),
            Some(Edit {
                text,
                sheet: sheet.to_string(),
                cells,
                what: Written::Value(v),
            }),
        )
    };
    let key = |sheet: &str, col: u32, row: u32, command: &str| {
        (act(sheet, col, row, false, command), None)
    };
    let mut s = vec![
        // I: a switch toggled by Space, by a click and set by 1 and 0; NON from NON-ET, tested
        key("I NON", 1, 3, "toggle"),
        (act("I NON", 1, 3, true, ""), None),
        key("I NON", 1, 3, "one"),
        key("I NON", 1, 3, "zero"),
        gate("I NON", "J3", "=1-A3*A3"),
        key("I NON", 10, 3, "test"),
        key("I NON", 1, 3, "previous"),
        key("I NON", 1, 3, "next"),
        // II: VEL for ET, failing at its second input; then ET by NON of NON-ET with a wire, two stars; R
        gate("II ET", "J3", "=MAX(A3,A4)"),
        key("II ET", 1, 3, "test"),
        gate("II ET", "C3", "=1-A3*A4"),
        gate("II ET", "C4", "=1-C3"),
        gate("II ET", "J3", "=C4"),
        key("II ET", 1, 3, "test"),
        key("II ET", 1, 3, "reset"),
        // III: VEL, an input emptied by Delete, the error named before T and where T stops, R, the gate again, a pass
        gate("III VEL", "C3", "=1-A3"),
        gate("III VEL", "C4", "=1-A4"),
        gate("III VEL", "J3", "=1-C3*C4"),
        value("III VEL", "C4:C5", Val::Text(String::new())),
        key("III VEL", 1, 3, "test"),
        key("III VEL", 1, 3, "reset"),
        gate("III VEL", "C4", "=1-A4"),
        key("III VEL", 1, 3, "test"),
        // IV: AUT from VEL and NON-ET, its first gate VEL times a number written as a text, outside the set and the
        // text no gate: a pass, one star
        value("IV AUT", "D5", Val::Text("1".into())),
        gate("IV AUT", "C3", "=MAX(A3,A4)*D5"),
        gate("IV AUT", "C4", "=1-A3*A4"),
        gate("IV AUT", "J3", "=C3*C4"),
        key("IV AUT", 1, 3, "test"),
        // and 1 and 0 typed on its room: a value written and written over, and nothing on a gate, on a lamp or past the room
        key("IV AUT", 6, 6, "one"),
        key("IV AUT", 6, 6, "zero"),
        key("IV AUT", 3, 3, "one"),
        key("IV AUT", 12, 3, "one"),
        key("IV AUT", 3, 11, "one"),
        // V at its least known; VI at the textbook's three gates, NON and two ETs, within the budget: two stars
        gate("V ELIGE", "C3", "=MOD(A3+A4,2)"),
        gate("V ELIGE", "C4", "=A5*C3"),
        gate("V ELIGE", "J3", "=MOD(A3+C4,2)"),
        key("V ELIGE", 1, 5, "test"),
        gate("VI DISTRIBUE", "C3", "=1-A4"),
        gate("VI DISTRIBUE", "J3", "=A3*C3"),
        gate("VI DISTRIBUE", "J4", "=A3*A4"),
        key("VI DISTRIBUE", 1, 3, "test"),
        // VII with two gates idle, outside the set, one of them low in the room: one star, which their Delete moves
        // not until T, three; VIII at its least known
        gate("VII SEMIS", "J3", "=MOD(A3+A4,2)"),
        gate("VII SEMIS", "J4", "=A3*A4"),
        gate("VII SEMIS", "E6", "=-A3+INT(A4/2)"),
        gate("VII SEMIS", "F9", "=MIN(A3:A4)"),
        key("VII SEMIS", 1, 3, "test"),
        value("VII SEMIS", "E6", Val::Text(String::new())),
        value("VII SEMIS", "F9", Val::Text(String::new())),
        key("VII SEMIS", 1, 3, "test"),
        gate("VIII SUMMA", "C3", "=MOD(A3+A4,2)"),
        gate("VIII SUMMA", "J3", "=MOD(C3+A5,2)"),
        gate("VIII SUMMA", "C4", "=A3*A4"),
        gate("VIII SUMMA", "C5", "=C3*A5"),
        gate("VIII SUMMA", "J4", "=MAX(C4,C5)"),
        key("VIII SUMMA", 1, 3, "test"),
    ];
    // IX: four whole sums, a carry rippling, all 512 inputs
    for (i, carry) in ["A11", "F3", "F4", "F5"].iter().enumerate() {
        let r = 3 + i;
        s.push(gate(
            "IX QUATTUOR",
            &format!("C{r}"),
            &format!("=MOD(A{r}+A{},2)", r + 4),
        ));
        s.push(gate(
            "IX QUATTUOR",
            &format!("D{r}"),
            &format!("=A{r}*A{}", r + 4),
        ));
        s.push(gate(
            "IX QUATTUOR",
            &format!("E{r}"),
            &format!("=C{r}*{carry}"),
        ));
        s.push(gate(
            "IX QUATTUOR",
            &format!("J{r}"),
            &format!("=MOD(C{r}+{carry},2)"),
        ));
        s.push(gate(
            "IX QUATTUOR",
            if i == 3 {
                "J7".to_string()
            } else {
                format!("F{r}")
            }
            .as_str(),
            &format!("=MAX(D{r},E{r})"),
        ));
    }
    s.push(key("IX QUATTUOR", 1, 3, "test"));
    s.push(key("IX QUATTUOR", 1, 3, "next"));
    // X: the flip-flop: a wire to J3 and T, d set and C ticked, q a tick behind; G, at rest; and a gate that toggles q,
    // which G runs until every state is spent, then the wire again
    s.push(gate("X MORA", "J3", "=A3"));
    s.push(key("X MORA", 1, 3, "test"));
    s.push(key("X MORA", 1, 3, "zero"));
    s.push(key("X MORA", 1, 3, "tick"));
    s.push(key("X MORA", 1, 3, "one"));
    s.push(key("X MORA", 1, 3, "tick"));
    s.push(key("X MORA", 1, 3, "run"));
    s.push(gate("X MORA", "J3", "=1-A4"));
    s.push(key("X MORA", 1, 3, "run"));
    s.push(gate("X MORA", "J3", "=A3"));
    s.push(key("X MORA", 1, 3, "test"));
    // XI: a bit held, ELIGE in one gate; its flip-flop set by hand and its test forgotten by R
    s.push(gate("XI TENE", "J3", "=IF(A3,A4,A5)"));
    s.push(key("XI TENE", 1, 3, "test"));
    s.push(key("XI TENE", 1, 5, "toggle"));
    s.push(key("XI TENE", 1, 3, "reset"));
    s.push(key("XI TENE", 1, 3, "test"));
    // XII: four of them
    for (r, a, b) in [
        ("J3", "A4", "A8"),
        ("J4", "A5", "A9"),
        ("J5", "A6", "A10"),
        ("J6", "A7", "A11"),
    ] {
        s.push(gate("XII MEMORIA", r, &format!("=IF($A$3,{a},{b})")));
    }
    s.push(key("XII MEMORIA", 1, 3, "test"));
    // XIII: a half adder a bit, a 0 chosen at reset; inc on and G, which never rests
    for (at, f) in NUMERA_GATES {
        s.push(gate("XIII NUMERA", at, f));
    }
    s.push(key("XIII NUMERA", 1, 3, "test"));
    s.push(key("XIII NUMERA", 1, 3, "zero"));
    s.push(key("XIII NUMERA", 1, 4, "one"));
    s.push(key("XIII NUMERA", 1, 4, "run"));
    // XIV: the reckoning, all 1,024 inputs
    for (at, f) in RATIO_GATES {
        s.push(gate("XIV RATIO", at, f));
    }
    s.push(key("XIV RATIO", 1, 3, "test"));
    // XV: half its gates, T standing on the input that fails, its word as it stood; C and R; then the rest, its 2,048
    // inputs; G, which runs the ROM's 3 x 5 to its HLT; a line rewritten and a word none of the five, and G again
    let half = MACHINA_GATES.len() / 2;
    for (at, f) in &MACHINA_GATES[..half] {
        s.push(gate("XV MACHINA", at, f));
    }
    s.push(key("XV MACHINA", 1, 3, "test"));
    s.push(key("XV MACHINA", 1, 3, "tick"));
    s.push(key("XV MACHINA", 1, 3, "reset"));
    for (at, f) in &MACHINA_GATES[half..] {
        s.push(gate("XV MACHINA", at, f));
    }
    s.push(key("XV MACHINA", 1, 3, "test"));
    s.push(key("XV MACHINA", 1, 3, "run"));
    s.push(key("XV MACHINA", 1, 3, "next"));
    s.push(value("ROM", "B4", Val::Text("add 7".into())));
    s.push(value("ROM", "B9", Val::Text("FOO".into())));
    s.push(key("XV MACHINA", 1, 3, "run"));
    s.push(key("XV MACHINA", 1, 3, "tick"));
    // a switch a person writes over is a value until Load
    s.push(value("I NON", "A3", Val::Num(1.0)));
    s.push(key("I NON", 1, 3, "toggle"));
    s.push(key("I NON", 1, 3, "test"));
    s
}

/// XIII at its least known: a half adder a bit from inc, and a 0 chosen at
/// reset.
pub const NUMERA_GATES: [(&str, &str); 11] = [
    ("C3", "=MOD(A5+A4,2)"),
    ("D3", "=A5*A4"),
    ("C4", "=MOD(A6+D3,2)"),
    ("D4", "=A6*D3"),
    ("C5", "=MOD(A7+D4,2)"),
    ("D5", "=A7*D4"),
    ("C6", "=MOD(A8+D5,2)"),
    ("J3", "=IF(A3,0,C3)"),
    ("J4", "=IF(A3,0,C4)"),
    ("J5", "=IF(A3,0,C5)"),
    ("J6", "=IF(A3,0,C6)"),
];

/// XIV at its least known: bit 0's six gates, each later bit's eight, whose
/// carry is `=IF(x,c,a*op0)`, a carry chain alive under op0 alone, and J7 the
/// last carry under op1.
pub const RATIO_GATES: [(&str, &str); 31] = [
    ("C3", "=MOD(A3+A7,2)"),
    ("D3", "=A3*A7"),
    ("E3", "=MAX(A3,A7)"),
    ("F3", "=IF(A11,E3,D3)"),
    ("J3", "=IF(A12,C3,F3)"),
    ("G3", "=A11*D3"),
    ("C4", "=MOD(A4+A8,2)"),
    ("D4", "=A4*A8"),
    ("E4", "=MAX(A4,A8)"),
    ("F4", "=IF($A$11,E4,D4)"),
    ("H4", "=MOD(C4+G3,2)"),
    ("J4", "=IF($A$12,H4,F4)"),
    ("I4", "=A4*$A$11"),
    ("G4", "=IF(C4,G3,I4)"),
    ("C5", "=MOD(A5+A9,2)"),
    ("D5", "=A5*A9"),
    ("E5", "=MAX(A5,A9)"),
    ("F5", "=IF($A$11,E5,D5)"),
    ("H5", "=MOD(C5+G4,2)"),
    ("J5", "=IF($A$12,H5,F5)"),
    ("I5", "=A5*$A$11"),
    ("G5", "=IF(C5,G4,I5)"),
    ("C6", "=MOD(A6+A10,2)"),
    ("D6", "=A6*A10"),
    ("E6", "=MAX(A6,A10)"),
    ("F6", "=IF($A$11,E6,D6)"),
    ("H6", "=MOD(C6+G5,2)"),
    ("J6", "=IF($A$12,H6,F6)"),
    ("I6", "=A6*$A$11"),
    ("G6", "=IF(C6,G5,I6)"),
    ("J7", "=G6*A12"),
];

/// XV at its least known. The word, A3 to A9, op then n; A, A10 to A13; p, A14
/// to A17; B, A18 to A21. C3 and D3 tell JNZ's op and every op that keeps A; E3
/// SWP and F3 JNZ; I3 that A is not 0, and C4 the jump. C5 to E8 add A and n,
/// the carry by ELIGE; F and G choose A's next among the sum, n and B, and J3
/// to J6 keep A; I4 is 1 but at HLT, and C9 to D11 add it to p, so that HLT's p
/// is p; J7 to J10 choose the jump's n; and J11 to J14 trade B at SWP.
pub const MACHINA_GATES: [(&str, &str); 46] = [
    ("C3", "=A3*A4"),
    ("D3", "=MAX(A5,C3)"),
    ("E3", "=IF(D3,0,A4)"),
    ("F3", "=IF(A5,0,C3)"),
    ("G3", "=MAX(A10,A11)"),
    ("H3", "=MAX(A12,A13)"),
    ("I3", "=MAX(G3,H3)"),
    ("C4", "=F3*I3"),
    ("C5", "=MOD(A10+A6,2)"),
    ("D5", "=A10*A6"),
    ("C6", "=MOD(A11+A7,2)"),
    ("D6", "=MOD(C6+D5,2)"),
    ("E6", "=IF(C6,D5,A11)"),
    ("C7", "=MOD(A12+A8,2)"),
    ("D7", "=MOD(C7+E6,2)"),
    ("E7", "=IF(C7,E6,A12)"),
    ("C8", "=MOD(A13+A9,2)"),
    ("D8", "=MOD(C8+E7,2)"),
    ("F5", "=IF(A3,C5,A6)"),
    ("F6", "=IF(A3,D6,A7)"),
    ("F7", "=IF(A3,D7,A8)"),
    ("F8", "=IF(A3,D8,A9)"),
    ("G5", "=IF(A4,A18,F5)"),
    ("G6", "=IF(A4,A19,F6)"),
    ("G7", "=IF(A4,A20,F7)"),
    ("G8", "=IF(A4,A21,F8)"),
    ("J3", "=IF(D3,A10,G5)"),
    ("J4", "=IF(D3,A11,G6)"),
    ("J5", "=IF(D3,A12,G7)"),
    ("J6", "=IF(D3,A13,G8)"),
    ("I4", "=1-A5"),
    ("C9", "=MOD(A14+I4,2)"),
    ("D9", "=A14*I4"),
    ("C10", "=MOD(A15+D9,2)"),
    ("D10", "=A15*D9"),
    ("C11", "=MOD(A16+D10,2)"),
    ("D11", "=A16*D10"),
    ("C12", "=MOD(A17+D11,2)"),
    ("J7", "=IF(C4,A6,C9)"),
    ("J8", "=IF(C4,A7,C10)"),
    ("J9", "=IF(C4,A8,C11)"),
    ("J10", "=IF(C4,A9,C12)"),
    ("J11", "=IF(E3,A10,A18)"),
    ("J12", "=IF(E3,A11,A19)"),
    ("J13", "=IF(E3,A12,A20)"),
    ("J14", "=IF(E3,A13,A21)"),
];

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
        // the named adder's seven columns four wide, so that AUT and VEL read whole beside the next name
        assert_eq!(shown.wide, (1..=7).collect::<Vec<u32>>());
        assert!(Net::bench(FLOORS.0, FLOORS.1).wide.is_empty());
    }

    #[test]
    fn the_floors_source_replaces_the_block_and_leaves_out_the_settle_and_the_keyboard_s_sheets() {
        let source = format!(
            "(cartridge \"t\"\r\n  (rate 0)\r\n  (settle 9)   ; a note\r\n  (bound \"Lesson\" \"I NON\" \"S\")\r\n  (read \"Lesson\")   ; a note\r\n  (work \"S\")\r\n  (game \"S\")\r\n  (seed 1))\r\n{LESSON_BEGIN}\r\n(sheet \"Lesson\" visible)\r\n(cell \"Lesson\" \"A9\" \"a word\")\r\n{LESSON_END}\r\n{LEVELS_BEGIN}\r\n(sheet \"I NON\" visible)\r\n(cell \"I NON\" \"A1\" \"a level\")\r\n(sheet \"Lab\" hidden)\r\n{LEVELS_END}\r\n{BLOCK_BEGIN}\r\nold\r\n{BLOCK_END}\r\n"
        );
        let lines = vec!["new".to_string()];
        let want = format!(
            "(cartridge \"t\"\r\n  (rate 0)\r\n  (bound \"S\")\r\n  (seed 1))\r\n{BLOCK_BEGIN}\r\nnew\r\n{BLOCK_END}\r\n"
        );
        assert_eq!(floors_source(&source, &lines), Some(want));
        assert_eq!(
            with_block(&source, &lines).map(|s| s.contains("(settle 9)")
                && s.contains("a word")
                && s.contains("a level")
                && s.contains("(read \"Lesson\")")
                && s.contains("(work \"S\")")),
            Some(true),
            "the cartridge's own source keeps them all"
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
    fn the_gates_are_read_by_their_shapes() {
        for (f, at_i, at_ix) in SHAPES {
            assert_eq!(kind(&gate_text(f), &inputs_of(0)), at_i, "{f} at I");
            assert_eq!(kind(&gate_text(f), &inputs_of(8)), at_ix, "{f} at IX");
        }
        assert_eq!(kind("", &inputs_of(0)), 0, "no formula");
        assert_eq!(gate_text("=mod(a3 + $c$3, 2)"), "=MOD(A3+C3,2)");
        assert!(inputs_of(0).starts_with("|A3|C3|D3|") && inputs_of(0).ends_with("|J10|0|1|"));
        assert!(inputs_of(8).starts_with("|A3|A4|") && inputs_of(8).ends_with("|J11|0|1|"));
        assert_eq!(
            (
                room_address(1),
                room_address(8),
                room_address(9),
                room_address(72)
            ),
            (
                "C3".to_string(),
                "J3".to_string(),
                "C4".to_string(),
                "J11".to_string()
            )
        );
        // each level gives the gates proven before it: NON at II, ET at III, VEL at IV, AUT from V, ELIGE from X
        let gives: Vec<u32> = LEVELS.iter().map(|l| l.gives).collect();
        assert_eq!(gives, [2, 3, 4, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7]);
    }

    /// A room's gates in their order, over a level's switches: each output of
    /// J the hand's arithmetic gives, each gate seeing those before it.
    fn outputs_of(gates: &[(u32, u32, Gex)], switches: &[Val], outputs: u32) -> Vec<Val> {
        let mut cells: HashMap<(u32, u32), Val> = HashMap::new();
        for (s, v) in switches.iter().enumerate() {
            cells.insert((3 + s as u32, 1), v.clone());
        }
        for (row, col, g) in gates {
            let v = g
                .eval(&mut |r, c| cells.get(&(r, c)).cloned().unwrap_or(Val::Empty))
                .settled();
            cells.insert((*row, *col), v);
        }
        (0..outputs)
            .map(|o| cells.get(&(3 + o, 10)).cloned().unwrap_or(Val::Empty))
            .collect()
    }

    /// The first input of a level's test its gates get wrong; `None` if they
    /// pass it.
    fn first_wrong(k: usize, gates: &[(u32, u32, Gex)]) -> Option<u32> {
        let level = &LEVELS[k];
        (0..level.vectors).find(|&v| {
            let b6 = Val::Num(f64::from(v));
            let s: Vec<Val> = (0..level.switches() as usize)
                .map(|i| test_input(k, i, &b6))
                .collect();
            outputs_of(gates, &s, level.outputs) != due(k, &s)
        })
    }

    /// A gate's formula with its inputs and its shape moved: ET for VEL and VEL
    /// for ET, VEL for AUT, and ELIGE's two branches traded.
    fn another_gate(f: &str) -> Option<String> {
        let inside = |p: &str, q: &str| f.strip_prefix(p).and_then(|x| x.strip_suffix(q));
        if let Some(x) = inside("=IF(", ")") {
            let v: Vec<&str> = x.split(',').collect();
            return Some(format!("=IF({},{},{})", v[0], v[2], v[1]));
        }
        if let Some(x) = inside("=MAX(", ")") {
            let (a, b) = x.split_once(',')?;
            return Some(format!("={a}*{b}"));
        }
        if let Some(x) = inside("=MOD(", ",2)") {
            let (a, b) = x.split_once('+')?;
            return Some(format!("=MAX({a},{b})"));
        }
        let x = f.strip_prefix('=')?;
        let (a, b) = x.split_once('*')?;
        Some(format!("=MAX({a},{b})"))
    }

    /// The test of each level past 15 bits or with gates enough to err (decision
    /// 40): every least-known room passes, and no gate of it stuck at 0 or at 1,
    /// or another gate in its place, passes. So XV's 2,048 inputs of 524,288, its
    /// p and its B drawn by lot, see each of its gates fail, however they fail.
    #[test]
    fn the_tests_catch_every_gate_of_a_least_known_room_gone_wrong() {
        let read = |gates: &[(&str, &str)]| -> Vec<(u32, u32, Gex)> {
            gates
                .iter()
                .map(|(at, f)| {
                    let (row, col) = place(at);
                    (row, col, gex(f).expect("a gate"))
                })
                .collect()
        };
        for (k, gates) in [
            (12, &NUMERA_GATES[..]),
            (13, &RATIO_GATES[..]),
            (MACHINA, &MACHINA_GATES[..]),
        ] {
            let room = read(gates);
            assert_eq!(first_wrong(k, &room), None, "{}: its room", LEVELS[k].sheet);
            for (i, (at, f)) in gates.iter().enumerate() {
                let mut wrongs = vec![Gex::Num(0.0), Gex::Num(1.0)];
                if let Some(other) = another_gate(f) {
                    wrongs.push(gex(&other).expect("a gate"));
                }
                for wrong in wrongs {
                    let mut mutated = room.clone();
                    mutated[i].2 = wrong.clone();
                    assert!(
                        first_wrong(k, &mutated).is_some(),
                        "{}: {at} {f} as {wrong:?} passes its test",
                        LEVELS[k].sheet
                    );
                }
            }
        }
    }

    /// A line of the ROM read as its word's number, and a level's limit.
    #[test]
    fn the_rom_reads_its_lines_as_the_cartridge_does() {
        for (line, word) in [
            ("LDI 3", 24.0),
            ("ADD 15", 121.0),
            ("add 7", 57.0),
            ("SWP", 2.0),
            ("JNZ 1", 11.0),
            ("HLT", 4.0),
            ("", 4.0),
            ("FOO", 4.0),
            ("ADD -1", 121.0),
            ("ADD x", 1.0),
            ("LDI 1.5", 8.0),
        ] {
            assert_eq!(rom_word(&Val::Text(line.into())), word, "{line:?}");
        }
        assert_eq!(rom_word(&Val::Empty), 4.0, "an empty line");
        assert_eq!(
            LEVELS.iter().map(Level::limit).collect::<Vec<u32>>(),
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 16, 16, 0, 4096]
        );
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

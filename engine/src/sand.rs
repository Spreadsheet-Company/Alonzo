//! Sand by hand (`CART.2`; `docs/REARVIEW.md`, the item's scoping, decisions 13
//! and 21): the rule of `cartridges/sand/sand.vla` written a second time, in
//! Rust, the way a person would write a falling-sand toy: each row's grains
//! propose a move and the cells beneath them claim it, in three passes, and
//! then the row's water that stays claims a free cell beside it, in two.
//! It shares no predicate with the cartridge's formulas, where a receiving
//! cell computes the grain's move again, so the engine's frames are held to
//! a rule written twice. The engine's tests compile it as a module of the
//! crate for the tests alone, and the native runner of the floors,
//! `examples/frames.rs`, includes the same file by its path. The page holds
//! a third sand, in JavaScript (`web/index.template.html`, `sandStep`).
//!
//! The board is the Screen, 320 by 200, a byte a cell, row by row from `A1`,
//! as the plane reads it. The codes are the cartridge's: 0 empty, 1 wall, 2
//! sand and 3 water, so that what moves is 2 and up. The interior is rows 2
//! to 199 and columns 3 to 318, `C2:LF199`. Walls two cells wide stand down
//! each side, row 1 is empty above the interior, and row 200 is the floor,
//! whose cells show the swatch, the material the left button paints.
//!
//! A frame, from the bottom row up, as the scan order has it: the row
//! beneath is known after its own departures and its water's sideways moves.
//! The row's grains, sand and water alike, claim cells in it that are not
//! occupied, in three passes: straight down, then each grain's first
//! diagonal, then its second. The first diagonal is to the right on an even
//! row and to the left on an odd one. A cell is claimed once, by the first
//! grain to ask. The row beneath then holds what stayed in it and what
//! arrived. Then this row's water that stayed claims a cell of the row left
//! free, in two passes: the side its row's direction names, then the other;
//! a grain moving out frees no cell for another this frame. This row, after
//! its departures and its sideways moves, is the next row's row beneath. A
//! brush paints the cells of the interior it covers: a painted cell holds
//! its paint at the frame's end, and is occupied when the paint is not
//! empty, while the grain it held still moves as the rule says, falling or
//! moving sideways.

/// The plane's size, `A1:LH200`.
pub const W: usize = 320;
pub const H: usize = 200;

/// The materials, by the cartridge's codes.
pub const EMPTY: u8 = 0;
pub const WALL: u8 = 1;
pub const SAND: u8 = 2;
pub const WATER: u8 = 3;

/// The interior: rows 2 to 199, columns C to LF.
pub const TOP: usize = 2;
pub const BOTTOM: usize = H - 1;
pub const LEFT: usize = 3;
pub const RIGHT: usize = W - 2;

/// The opening's last row: the soup rains from the interior's top third,
/// rows 2 to 67, since the whole board falling at once took two of a 60 Hz
/// display's ticks a frame for its first two seconds (`CART.2`'s playtest
/// pass, 2026-10-12).
pub const RAIN: usize = 67;

/// The soup's prime and its threshold, three eighths of it, Life's own; and
/// the opening's sand, under three sixteenths, so that half its grains are
/// water.
const P: u64 = 67_108_859;
const T: u64 = 25_165_822;
const T_SAND: u64 = 12_582_911;

/// The index of the cell at a row and a column, both from 1.
pub fn at(row: usize, col: usize) -> usize {
    (row - 1) * W + (col - 1)
}

/// A disc of paint: its center's row and column, its radius, and the
/// material it paints.
#[derive(Clone, Copy, Debug)]
pub struct Brush {
    pub row: i64,
    pub col: i64,
    pub radius: i64,
    pub material: u8,
}

impl Brush {
    /// Whether the disc covers a cell of the interior.
    pub fn covers(&self, row: usize, col: usize) -> bool {
        if !(TOP..=BOTTOM).contains(&row) || !(LEFT..=RIGHT).contains(&col) {
            return false;
        }
        let (dr, dc) = (row as i64 - self.row, col as i64 - self.col);
        dr * dr + dc * dc <= self.radius * self.radius
    }
}

/// The board with no grain: the walls, an empty interior, and the floor
/// showing `swatch`.
pub fn empty(swatch: u8) -> Vec<u8> {
    let mut b = vec![EMPTY; W * H];
    for row in 1..=H {
        for col in [1, 2, W - 1, W] {
            b[at(row, col)] = WALL;
        }
    }
    for col in LEFT..=RIGHT {
        b[at(H, col)] = swatch;
    }
    b
}

/// The opening: Life's soup from the seed, its own arithmetic, a grain at
/// every cell of the interior's top third, rows 2 to 67, where Life's first
/// frame is alive: sand where the soup's square is under three sixteenths of
/// the prime, and water where it is under three eighths. Every sum and
/// product stays under 2^53, so the cartridge's doubles agree.
pub fn opening(seed: u64) -> Vec<u8> {
    let mut b = empty(SAND);
    for row in TOP..=RAIN {
        for col in LEFT..=RIGHT {
            let (r, c) = (row as u64, col as u64);
            let a = (seed * 1_103_515 + r * 1_597_334 + c * 1_830_421 + 12_345) % P;
            let d = (seed * 2_012_345 + r * 1_209_487 + c * 1_949_213 + 54_321) % P;
            let h = (a * d) % P;
            let square = (h * h) % P;
            if square < T_SAND {
                b[at(row, col)] = SAND;
            } else if square < T {
                b[at(row, col)] = WATER;
            }
        }
    }
    b
}

/// One frame of the rule over the last frame's board: the board at the
/// frame's end, the `Stay` sheet and the `Side` sheet as the cartridge
/// computes them, each with its border 1 and its row 1 empty. `Stay` is 0
/// where a cell is free after its row's departures, 1 where a wall or a
/// grain of sand stays, and 2 where water stays; `Side` is 1 where a cell is
/// occupied after its row's sideways moves. `swatch` is what the floor shows.
pub fn step(old: &[u8], brush: Option<&Brush>, swatch: u8) -> (Vec<u8>, Vec<u8>, Vec<u8>) {
    let paint = |row: usize, col: usize| brush.filter(|b| b.covers(row, col)).map(|b| b.material);
    let interior = |col: usize| (LEFT..=RIGHT).contains(&col);
    let mut new = old.to_vec();
    for col in LEFT..=RIGHT {
        new[at(H, col)] = swatch;
    }
    let bordered = || {
        let mut plane = vec![EMPTY; W * H];
        for row in 1..=H {
            for col in [1, 2, W - 1, W] {
                plane[at(row, col)] = 1;
            }
        }
        for col in LEFT..=RIGHT {
            plane[at(H, col)] = 1;
        }
        plane
    };
    let (mut stay, mut side) = (bordered(), bordered());
    // The row beneath after its departures and its sideways moves, each
    // column from 1: whether the cell is occupied, and what it holds. The
    // floor first, all occupied.
    let mut occupied = vec![true; W + 1];
    let mut holds = vec![WALL; W + 1];
    for row in (TOP..=BOTTOM).rev() {
        let right_first = row % 2 == 0;
        // The row's grains fall: straight, then the first diagonal, then the
        // second, each into a cell of the row beneath not occupied.
        let mut claimed = vec![false; W + 1];
        let mut moved = vec![false; W + 1];
        let mut arrives = vec![EMPTY; W + 1];
        for pass in 0..3 {
            for col in LEFT..=RIGHT {
                let m = old[at(row, col)];
                if m < SAND || moved[col] {
                    continue;
                }
                let target = match (pass, right_first) {
                    (0, _) => col,
                    (1, true) | (2, false) => col + 1,
                    _ => col - 1,
                };
                if !occupied[target] && !claimed[target] {
                    claimed[target] = true;
                    moved[col] = true;
                    arrives[target] = m;
                }
            }
        }
        // The row beneath is final: what stayed in it, what arrived, or the paint.
        if row < BOTTOM {
            for col in LEFT..=RIGHT {
                let kept = if occupied[col] {
                    holds[col]
                } else {
                    arrives[col]
                };
                new[at(row + 1, col)] = paint(row + 1, col).unwrap_or(kept);
            }
        }
        // This row after its departures: Stay, 2 where water stays.
        let mut occ = vec![true; W + 1];
        let mut held = vec![WALL; W + 1];
        for col in 1..=W {
            let m = old[at(row, col)];
            let (o, h) = match paint(row, col) {
                Some(p) => (p != EMPTY, p),
                None if !interior(col) => (true, m),
                None => {
                    let stays = m == WALL || (m >= SAND && !moved[col]);
                    (stays, if stays { m } else { EMPTY })
                }
            };
            occ[col] = o;
            held[col] = h;
            if interior(col) {
                stay[at(row, col)] = match (o, m) {
                    (false, _) => 0,
                    (true, WATER) => 2,
                    (true, _) => 1,
                };
            }
        }
        // Its water that stayed moves sideways into a cell of the row left
        // free: the side its row's direction names, then the other, each cell
        // claimed once.
        let mut taken = vec![false; W + 1];
        let mut went = vec![false; W + 1];
        for pass in 0..2 {
            for col in LEFT..=RIGHT {
                if !occ[col] || old[at(row, col)] != WATER || went[col] {
                    continue;
                }
                let target = if (pass == 0) == right_first {
                    col + 1
                } else {
                    col - 1
                };
                if !occ[target] && !taken[target] {
                    taken[target] = true;
                    went[col] = true;
                }
            }
        }
        // This row after its sideways moves: Side, and the next row's row
        // beneath. A painted cell holds its paint whatever moved.
        for col in 1..=W {
            let (mut o, mut h) = (occ[col], held[col]);
            if went[col] {
                (o, h) = (false, EMPTY);
            }
            if taken[col] {
                (o, h) = (true, WATER);
            }
            if let Some(p) = paint(row, col) {
                (o, h) = (p != EMPTY, p);
            }
            occupied[col] = o;
            holds[col] = h;
            if interior(col) {
                side[at(row, col)] = u8::from(o);
            }
        }
    }
    // The top row of the interior takes nothing from row 1, which is empty.
    for col in LEFT..=RIGHT {
        let kept = if occupied[col] { holds[col] } else { EMPTY };
        new[at(TOP, col)] = paint(TOP, col).unwrap_or(kept);
    }
    (new, stay, side)
}

/// The interior's cells of each material, by its code: empty, wall, sand and
/// water.
pub fn counts(board: &[u8]) -> [usize; 4] {
    let mut n = [0; 4];
    for row in TOP..=BOTTOM {
        for col in LEFT..=RIGHT {
            n[usize::from(board[at(row, col)])] += 1;
        }
    }
    n
}

/// A row's interior summed, as the `Tally` sheet sums it: the codes of the
/// board's row, and the occupied cells of the `Side` sheet's row.
pub fn tally(board: &[u8], side: &[u8], row: usize) -> (u64, u64) {
    let sum = |plane: &[u8]| -> u64 {
        (LEFT..=RIGHT)
            .map(|col| u64::from(plane[at(row, col)]))
            .sum()
    };
    (sum(board), sum(side))
}

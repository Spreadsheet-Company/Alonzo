//! The size ladder's rungs (`ENGINE.9`; `docs/REARVIEW.md`, the item's scoping,
//! decisions 1 to 3): the boards Life and the gun are built on past the
//! window's own, and the door's values that build a source on one. A source
//! whose rule covers a board states its width and height as two parameters,
//! `board-width` and `board-height`, and hands them on by a macro,
//! `(board-size then args...)` becoming `(then width height args...)`, the
//! kit's way of handing a value on; the pass, given this file's values as a
//! door's ([`crate::pass::expand_given`]; since `ENGINE.30`'s pin to `vla-lang`
//! 0.15.0, whose `parameter` is Frazaro's `VLA.11`, where a second definition
//! of `board-size` after the source's own stood before), expands the same
//! rule over a larger Screen. The window stays the manifest's, 320 by 200,
//! `docs/SPEC.md` section 10's limit for a plane, so a larger board stands under
//! a still Camera at its top-left, which the source's own `still-camera`
//! writes wherever its board is wider than the window. Compiled for the tests
//! alone; the native runner of the floors, `examples/frames.rs`, includes the
//! same file by its path, and the page writes the same values in its own
//! words and gives them by the module's `alonzo_expand_given` (its frame
//! floors' instrument), the two halves held to one cartridge a rung by its
//! digest.

/// The window: the plane the manifest declares, and every floor's board
/// before the ladder.
pub const WINDOW: (usize, usize) = (320, 200);

/// The rungs past the window: each its multiple of the window's area, then
/// its width and its height in cells.
pub const RUNGS: [(usize, usize, usize); 2] = [(4, 640, 400), (16, 1280, 800)];

/// Whether a source climbs the ladder: it states its board as the two
/// parameters a door gives.
pub fn climbs(source: &str) -> bool {
    source.contains("(parameter board-width ") && source.contains("(parameter board-height ")
}

/// The door's values for a board of `width` by `height` cells, the source's
/// two parameters given: what a door hands the pass beside the source. The
/// source's own `still-camera` puts the board under a still Camera at its
/// top-left wherever it is wider than the window.
pub fn door(width: usize, height: usize) -> String {
    format!("(parameter board-width {width})\r\n(parameter board-height {height})\r\n")
}

/// A column's letters, `A` for 1, `LH` for 320.
pub fn letters(mut column: usize) -> String {
    let mut out = Vec::new();
    while column > 0 {
        out.push(b'A' + ((column - 1) % 26) as u8);
        column = (column - 1) / 26;
    }
    out.reverse();
    String::from_utf8(out).unwrap_or_default()
}

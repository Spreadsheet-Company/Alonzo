//! The size ladder's rungs (`ENGINE.9`; `REARVIEW.md`, the item's scoping,
//! decisions 1 to 3): the boards Life and the gun are built on past the
//! window's own, and the definition that builds a source on one. A source
//! whose rule covers a board states the board's size as a macro,
//! `(board-size then args...)` becoming `(then width height args...)`, the
//! kit's way of handing a value on; the pass, handed this file's definition
//! after the source's own ([`crate::pass::expand_with`]), expands the same
//! rule over a larger Screen. The window stays the manifest's, 320 by 200,
//! `SPEC.md` section 10's limit for a plane, so a larger board stands under
//! a still Camera at its top-left, which the definition writes before it
//! hands the size on. Compiled for the tests alone; the native runner of
//! the floors, `examples/frames.rs`, includes the same file by its path, and
//! the page writes the same definition in its own words (its frame floors'
//! instrument), the two halves held to one cartridge a rung by its digest.

/// The window: the plane the manifest declares, and every floor's board
/// before the ladder.
pub const WINDOW: (usize, usize) = (320, 200);

/// The rungs past the window: each its multiple of the window's area, then
/// its width and its height in cells.
pub const RUNGS: [(usize, usize, usize); 2] = [(4, 640, 400), (16, 1280, 800)];

/// Whether a source climbs the ladder: it states its board as `board-size`.
pub fn climbs(source: &str) -> bool {
    source.contains("(defmacro (board-size ")
}

/// The definition of `board-size` for a board of `width` by `height` cells,
/// under a still Camera at its top-left: what a door hands the pass after
/// the source's own.
pub fn definition(width: usize, height: usize) -> String {
    format!(
        "(defmacro (board-size then & args)\r\n  \"the size ladder (ENGINE.9): a board of {width} by {height} cells under a still Camera at its top-left\"\r\n  (quasiquote (begin (camera 1 1) ((unquote then) {width} {height} (unquote-splicing args)))))\r\n"
    )
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

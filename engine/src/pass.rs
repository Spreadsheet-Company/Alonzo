//! The pass (`SPEC.3`, 2026-10-10; `SPEC.md` section 7.8): a cartridge's
//! source expanded into the rows a load takes. It is an act of its own
//! between the source and the load: it reads no file and loads nothing, so
//! the command line (`examples/expand.rs`) and the page run the same
//! function over the texts their doors hand it, and its output, the
//! cartridge, is the artifact a person reads, saves and diffs.
//!
//! **What it does, in order.** The source's top-level `(include "path")`
//! forms are spliced as the reference splices them (`VLA.bas`, P.L7): each
//! stands alone on its line, its path is resolved against the source's own
//! folder as the reference resolves against the workbook's, and includes
//! nest at most 16 deep, each included form standing on its include's line
//! for a refusal. Every `defmacro` is defined by the language's expander
//! before anything expands, as its first pass defines them. The manifest,
//! the first other form, is copied as written and never expanded. Every
//! form after it is expanded to its fixpoint by the language's expander,
//! template macros alone, no gensym and no eval, and each `begin` is
//! flattened. Then the cartridge is written: the source's licence line, a
//! banner naming the source, the manifest one directive a line, and the
//! rows one a line, CRLF, as every `.vla` stands in the working tree.
//!
//! **What it does not do.** It knows no macro by name: every macro is an
//! author's, in the source or in a library it includes, and the
//! repository's library, `cartridges/common.vla`, is a file like any
//! other. It judges no row: a form the load would refuse is written, and
//! the load, an act of its own, refuses it with its line in the cartridge.
//! And it splices only the texts it is handed, keyed by the paths [`resolve`]
//! makes, so a door decides what a source may read.

use vla_lang::expand::Expander;
use vla_lang::form::{Form, List};
use vla_lang::machine::LineRefusal;
use vla_lang::messages::{raise, Refusal};
use vla_lang::printer::write_datum;
use vla_lang::reader::read_forms;

use crate::cartridge;

/// How deep includes nest, the reference's own cap.
pub const INCLUDE_DEPTH: u32 = 16;

/// What the pass wrote: the cartridge's text, CRLF, and its rows after the
/// manifest.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Expansion {
    pub text: String,
    pub rows: usize,
}

/// The reference's `IsIncludeLine`: `(include "name")` alone on its line,
/// leading and trailing spaces allowed, the name between its quotes raw
/// text with no quote in it.
pub fn include_name(line: &str) -> Option<String> {
    let t = line.trim();
    let head = t.get(..9)?;
    if !head.eq_ignore_ascii_case("(include ") || !t.ends_with(')') {
        return None;
    }
    let inner = t[9..t.len() - 1].trim();
    if inner.len() < 2 || !inner.starts_with('"') || !inner.ends_with('"') {
        return None;
    }
    let name = &inner[1..inner.len() - 1];
    if name.is_empty() || name.contains('"') {
        return None;
    }
    Some(name.to_string())
}

/// A path joined to a folder with `/`, `.` and `..` folded away, `\` read
/// as `/`: the key under which a door hands the pass an included text.
pub fn resolve(folder: &str, name: &str) -> String {
    let name = name.replace('\\', "/");
    let mut parts: Vec<String> = Vec::new();
    if !name.starts_with('/') {
        for p in folder.replace('\\', "/").split('/') {
            if !p.is_empty() {
                parts.push(p.to_string());
            }
        }
    }
    for p in name.split('/') {
        match p {
            "" | "." => {}
            ".." => {
                parts.pop();
            }
            _ => parts.push(p.to_string()),
        }
    }
    let joined = parts.join("/");
    if name.starts_with('/') {
        format!("/{joined}")
    } else {
        joined
    }
}

/// The folder of a path, everything before its last `/` or `\`.
pub fn folder_of(path: &str) -> &str {
    match path.rfind(['/', '\\']) {
        Some(i) => &path[..i],
        None => "",
    }
}

/// The file name of a path, everything after its last `/` or `\`.
pub fn file_name(path: &str) -> &str {
    match path.rfind(['/', '\\']) {
        Some(i) => &path[i + 1..],
        None => path,
    }
}

/// The cartridge a source writes: `<name>.vla` beside `<name>.source.vla`.
pub fn cartridge_path(source: &str) -> Option<String> {
    source
        .strip_suffix(".source.vla")
        .filter(|stem| !file_name(stem).is_empty())
        .map(|stem| format!("{stem}.vla"))
}

/// The paths a text includes, each resolved against `folder`, in order: a
/// door reads these and hands them to [`expand`].
pub fn includes(text: &str, folder: &str) -> Vec<String> {
    text.lines()
        .filter_map(include_name)
        .map(|name| resolve(folder, &name))
        .collect()
}

/// The banner on a cartridge's second line, naming the source it was
/// expanded from. No digest: a comment edited in the source never moves the
/// cartridge's bytes.
pub fn banner(source_file: &str) -> String {
    format!("; Expanded by the pass from {source_file}: edit that file, then expand it again.")
}

fn refused(line: u32, refusal: Refusal) -> LineRefusal {
    LineRefusal { line, refusal }
}

fn raised(line: u32, id: &str, slots: &[(&str, &str)]) -> LineRefusal {
    refused(line, raise(id, slots))
}

/// A list form's line, or 0.
fn line_of(f: &Form) -> u32 {
    f.as_list().map(|l| l.line).unwrap_or(0)
}

/// The source's forms with every include spliced in, each with the source
/// line it stands on: its own, or its include's.
struct Spliced {
    forms: Vec<(Form, u32)>,
}

impl Spliced {
    /// The forms of `text`, its includes spliced, `anchor` the source line
    /// every form of an included text stands on (0 for the source itself).
    fn walk(
        &mut self,
        text: &str,
        folder: &str,
        files: &[(String, String)],
        depth: u32,
        label: &str,
        anchor: u32,
    ) -> Result<(), LineRefusal> {
        if depth > INCLUDE_DEPTH {
            return Err(raised(anchor, "vla-include-too-deep", &[("label", label)]));
        }
        let lines: Vec<&str> = text.split('\n').collect();
        let forms = read_forms(text).map_err(|r| refused(anchor, r))?;
        for f in forms {
            let own = line_of(&f);
            let at = if anchor == 0 { own } else { anchor };
            if f.head_is("include") {
                let whole_line = lines
                    .get(own.saturating_sub(1) as usize)
                    .and_then(|l| include_name(l.trim_end_matches('\r')));
                let Some(name) = whole_line else {
                    return Err(raised(at, "vla-include-must-stand-alone", &[]));
                };
                let path = resolve(folder, &name);
                let Some((_, body)) = files.iter().find(|(p, _)| *p == path) else {
                    return Err(raised(
                        at,
                        "vla-include-cannot-read",
                        &[("name", &name), ("path", &path)],
                    ));
                };
                self.walk(body, folder, files, depth + 1, &name, at)?;
            } else {
                nested_include(&f, at)?;
                self.forms.push((f, at));
            }
        }
        Ok(())
    }
}

/// An include anywhere inside a form stands nowhere alone.
fn nested_include(f: &Form, at: u32) -> Result<(), LineRefusal> {
    if let Form::List(l) = f {
        for item in &l.items {
            if item.head_is("include") {
                return Err(raised(at, "vla-include-must-stand-alone", &[]));
            }
            nested_include(item, at)?;
        }
    }
    Ok(())
}

fn flatten(f: Form, out: &mut Vec<Form>) {
    match f {
        Form::List(l) if l.head_is("begin") => {
            for item in l.items.into_iter().skip(1) {
                flatten(item, out);
            }
        }
        other => out.push(other),
    }
}

/// The manifest one directive a line: the head and the name on the first,
/// each directive indented two spaces below, the closing parenthesis on the
/// last.
fn manifest_text(m: &List) -> String {
    let mut out = String::from("(");
    let mut items = m.items.iter();
    if let Some(head) = items.next() {
        out.push_str(&write_datum(head));
    }
    if let Some(name) = items.next() {
        out.push(' ');
        out.push_str(&write_datum(name));
    }
    for d in items {
        out.push_str("\r\n  ");
        out.push_str(&write_datum(d));
    }
    out.push(')');
    out
}

/// The pass: `source`, at `path`, expanded into its cartridge, with every
/// text it may include handed in as `(path, text)` under the keys
/// [`resolve`] makes against the source's folder. Refused with the line of
/// the source form that raised the refusal, an included form standing on
/// its include's line.
pub fn expand(
    source: &str,
    path: &str,
    files: &[(String, String)],
) -> Result<Expansion, LineRefusal> {
    let mut spliced = Spliced { forms: Vec::new() };
    spliced.walk(source, folder_of(path), files, 0, path, 0)?;

    let mut ex = Expander::new();
    let mut body: Vec<(Form, u32)> = Vec::new();
    for (f, at) in spliced.forms {
        match &f {
            Form::List(l) if f.head_is("defmacro") => {
                ex.define_macro(l).map_err(|r| refused(at, r))?;
            }
            _ => body.push((f, at)),
        }
    }

    let mut body = body.into_iter();
    let manifest = match body.next() {
        Some((Form::List(l), _)) if l.head_is("cartridge") => l,
        other => {
            let at = other.map(|(_, at)| at).unwrap_or(0);
            return Err(LineRefusal {
                line: at,
                refusal: cartridge::raise(
                    "cart-manifest-invalid",
                    &[(
                        "what",
                        "is not the source's first form beside its includes and its macros",
                    )],
                ),
            });
        }
    };

    let mut out = String::new();
    let first = source
        .split('\n')
        .next()
        .unwrap_or("")
        .trim_end_matches('\r');
    if first.starts_with(';') && first.contains("SPDX-License-Identifier:") {
        out.push_str(first);
        out.push_str("\r\n");
    }
    out.push_str(&banner(file_name(path)));
    out.push_str("\r\n");
    out.push_str(&manifest_text(&manifest));
    out.push_str("\r\n");

    let mut rows = 0;
    for (f, at) in body {
        let expanded = ex.expand(&f, 0).map_err(|r| refused(at, r))?;
        let mut flat = Vec::new();
        flatten(expanded, &mut flat);
        for row in flat {
            out.push_str(&write_datum(&row));
            out.push_str("\r\n");
            rows += 1;
        }
    }
    Ok(Expansion { text: out, rows })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::cartridge::Cartridge;

    fn files(pairs: &[(&str, &str)]) -> Vec<(String, String)> {
        pairs
            .iter()
            .map(|(p, t)| (p.to_string(), t.to_string()))
            .collect()
    }

    const MANIFEST: &str = "(cartridge \"tiny\"\n  (spec 3)\n  (title \"Tiny\")\n  (rate 30)\n  (screen plane 4 4)\n  (seed 1))\n";

    fn lf(s: &str) -> String {
        s.replace("\r\n", "\n")
    }

    #[test]
    fn an_include_line_is_the_reference_s() {
        assert_eq!(
            include_name("(include \"lib.vla\")").as_deref(),
            Some("lib.vla")
        );
        assert_eq!(
            include_name("  (include \"a b.vla\")  ").as_deref(),
            Some("a b.vla")
        );
        assert_eq!(
            include_name("(INCLUDE \"../common.vla\")").as_deref(),
            Some("../common.vla")
        );
        assert_eq!(include_name("(include \"a\") x"), None);
        assert_eq!(include_name("(include-all \"a\")"), None);
        assert_eq!(include_name("(include \"\")"), None);
        assert_eq!(include_name("(include a)"), None);
        assert_eq!(include_name("(include \"a\" \"b\")"), None);
    }

    #[test]
    fn a_path_resolves_against_the_source_s_folder() {
        assert_eq!(
            resolve("cartridges/life", "../common.vla"),
            "cartridges/common.vla"
        );
        assert_eq!(
            resolve("cartridges/life", "./lib.vla"),
            "cartridges/life/lib.vla"
        );
        assert_eq!(
            resolve("cartridges/life", "lib\\x.vla"),
            "cartridges/life/lib/x.vla"
        );
        assert_eq!(resolve("", "common.vla"), "common.vla");
        assert_eq!(
            resolve("C:/r/cartridges/gun", "../common.vla"),
            "C:/r/cartridges/common.vla"
        );
        assert_eq!(resolve("cartridges/life", "/abs/x.vla"), "/abs/x.vla");
        assert_eq!(
            cartridge_path("cartridges/life/life.source.vla").as_deref(),
            Some("cartridges/life/life.vla")
        );
        assert_eq!(cartridge_path("cartridges/life/life.vla"), None);
        assert_eq!(
            includes(
                "; a\n(include \"../common.vla\")\r\n(x)\n",
                "cartridges/gun"
            ),
            vec!["cartridges/common.vla".to_string()]
        );
    }

    #[test]
    fn the_pass_writes_the_licence_the_banner_the_manifest_and_the_rows() {
        let source = format!(
            "; SPDX-License-Identifier: 0BSD\r\n; a comment the cartridge does not carry\r\n{MANIFEST}(defmacro (two sheet a b) (cell sheet a 1) (cell sheet b 2))\n(sheet \"Screen\" visible)\n(two \"Screen\" \"A1\" \"B1\")\n(formula \"Screen\" \"C1\" \"=A1+B1\")\n"
        );
        let e = expand(&source, "cartridges/tiny/tiny.source.vla", &[]).expect("expands");
        assert_eq!(
            lf(&e.text),
            "; SPDX-License-Identifier: 0BSD\n; Expanded by the pass from tiny.source.vla: edit that file, then expand it again.\n(cartridge \"tiny\"\n  (spec 3)\n  (title \"Tiny\")\n  (rate 30)\n  (screen plane 4 4)\n  (seed 1))\n(sheet \"Screen\" visible)\n(cell \"Screen\" \"A1\" 1)\n(cell \"Screen\" \"B1\" 2)\n(formula \"Screen\" \"C1\" \"=A1+B1\")\n"
        );
        assert_eq!(e.rows, 4);
        assert!(e.text.contains("\r\n") && !e.text.replace("\r\n", "").contains('\n'));
        // No licence line, no line for it; the banner is then the first.
        let bare = expand(MANIFEST, "tiny.source.vla", &[]).expect("expands");
        assert!(bare
            .text
            .starts_with("; Expanded by the pass from tiny.source.vla"));
        assert_eq!(bare.rows, 0);
    }

    #[test]
    fn the_pass_knows_no_macro_by_name() {
        // A source's own macro expands; a call to a macro nobody defined is
        // written as it stands, and the load, an act of its own, refuses it.
        let source = format!("{MANIFEST}(palette (\"#000000\" \"black\"))\n");
        let e = expand(&source, "t.source.vla", &[]).expect("the pass judges no row");
        assert!(lf(&e.text).ends_with("(palette (\"#000000\" \"black\"))\n"));
        let r = Cartridge::load(&e.text, "t.vla", e.text.len()).expect_err("the load refuses it");
        assert_eq!(r.refusal.id, "grid-row-unknown");
        // The manifest is copied as written, never expanded, whatever the
        // source defines.
        let source = format!("(defmacro (title x) (cell \"S\" \"A1\" x))\n{MANIFEST}");
        let e = expand(&source, "t.source.vla", &[]).expect("expands");
        assert!(e.text.contains("  (title \"Tiny\")\r\n"));
    }

    #[test]
    fn an_include_is_spliced_from_the_texts_the_door_hands_in() {
        let lib =
            "; SPDX-License-Identifier: 0BSD\n(defmacro (one sheet addr) (cell sheet addr 1))\n";
        let source = format!("(include \"../lib.vla\")\n{MANIFEST}(one \"Screen\" \"A1\")\n");
        let fs = files(&[("carts/lib.vla", lib)]);
        let e = expand(&source, "carts/t/t.source.vla", &fs).expect("expands");
        assert!(lf(&e.text).ends_with("(cell \"Screen\" \"A1\" 1)\n"));
        // A text the door did not hand in, named with the path it would be.
        let r = expand(&source, "carts/t/t.source.vla", &[]).expect_err("cannot read");
        assert_eq!(r.refusal.id, "vla-include-cannot-read");
        assert!(
            r.refusal.text.contains("carts/lib.vla"),
            "{}",
            r.refusal.text
        );
        assert_eq!(r.line, 1);
        // An include beside another form, or inside one, stands nowhere alone.
        let beside = format!("(include \"../lib.vla\") (x)\n{MANIFEST}");
        let r = expand(&beside, "carts/t/t.source.vla", &fs).expect_err("beside");
        assert_eq!(r.refusal.id, "vla-include-must-stand-alone");
        let inside = format!("{MANIFEST}(begin\n  (include \"../lib.vla\"))\n");
        let r = expand(&inside, "carts/t/t.source.vla", &fs).expect_err("inside");
        assert_eq!(r.refusal.id, "vla-include-must-stand-alone");
        // A library that includes itself is caught at the reference's cap.
        let me = files(&[("carts/me.vla", "(include \"../me.vla\")\n")]);
        let source = format!("(include \"../me.vla\")\n{MANIFEST}");
        let r = expand(&source, "carts/t/t.source.vla", &me).expect_err("too deep");
        assert_eq!(r.refusal.id, "vla-include-too-deep");
    }

    #[test]
    fn a_refusal_stands_on_the_source_line_of_its_form() {
        let lib = "(defmacro (two a b) (cell \"S\" a b))\n";
        let fs = files(&[("lib.vla", lib)]);
        // A macro called with the wrong arity on the source's line 9: the
        // include on line 1, the manifest on 2 to 7, a blank line on 8.
        let source = format!("(include \"lib.vla\")\n{MANIFEST}\n(two \"A1\")\n");
        let r = expand(&source, "t.source.vla", &fs).expect_err("arity");
        assert_eq!(r.refusal.id, "vla-macro-arity");
        assert_eq!(r.line, 9);
        // A row an included library writes before the manifest stands on
        // the include's line, and the manifest is then not the first form.
        let rows = files(&[("lib.vla", "(cell \"S\" \"Z9\" 1)\n")]);
        let early = format!("(include \"lib.vla\")\n{MANIFEST}");
        let r = expand(&early, "t.source.vla", &rows).expect_err("not first");
        assert_eq!(r.refusal.id, "cart-manifest-invalid");
        assert_eq!(r.line, 1);
        // No manifest at all.
        let r = expand("(sheet \"S\" visible)\n", "t.source.vla", &[]).expect_err("none");
        assert_eq!(r.refusal.id, "cart-manifest-invalid");
    }

    /// The golden (decision 28): every cartridge of the repository that has
    /// a source is the pass's expansion of it, byte for byte over LF, and
    /// loads. Read off the folder at run time, so a cartridge added with
    /// its source is held without a line here; a package without the
    /// repository's folder holds nothing to compare.
    #[test]
    fn every_cartridge_with_a_source_is_its_expansion_and_loads() {
        let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("..");
        let dir = root.join("cartridges");
        if !dir.is_dir() {
            eprintln!("no cartridges/ beside the crate: the golden is the repository's");
            return;
        }
        let mut texts: Vec<(String, String)> = Vec::new();
        let mut stack = vec![dir.clone()];
        while let Some(d) = stack.pop() {
            for entry in std::fs::read_dir(&d).expect("the folder reads") {
                let p = entry.expect("an entry").path();
                if p.is_dir() {
                    stack.push(p);
                } else if p.extension().is_some_and(|x| x == "vla") {
                    let rel = p
                        .strip_prefix(&root)
                        .expect("under the root")
                        .to_string_lossy()
                        .replace('\\', "/");
                    let text = std::fs::read_to_string(&p).expect("the file reads");
                    texts.push((rel, text));
                }
            }
        }
        texts.sort();
        let mut held = 0;
        for (path, text) in &texts {
            let Some(target) = cartridge_path(path) else {
                continue;
            };
            let built = texts
                .iter()
                .find(|(p, _)| *p == target)
                .unwrap_or_else(|| panic!("{path} has no cartridge {target} beside it"));
            let e = expand(text, path, &texts).unwrap_or_else(|r| {
                panic!(
                    "{path}: line {}: {} {}",
                    r.line, r.refusal.id, r.refusal.text
                )
            });
            assert_eq!(
                lf(&e.text),
                lf(&built.1),
                "{target} is not the pass's expansion of {path}"
            );
            Cartridge::load(&built.1, file_name(&target), built.1.len()).unwrap_or_else(|r| {
                panic!(
                    "{target}: line {}: {} {}",
                    r.line, r.refusal.id, r.refusal.text
                )
            });
            held += 1;
        }
        assert!(held >= 6, "{held} cartridges held to their sources");
    }

    /// The kit's verbs (`KIT.1`, decision 9 of its scoping in `REARVIEW.md`):
    /// a source over the repository's own library calls each macro the kit
    /// added, at its edges, and each call is held to the rows its docstring
    /// names, exactly. A cartridge holds only the paths it uses; this holds
    /// the rest, and names the call that moved. Read off the folder at run
    /// time, as the golden above is: a package without the repository's
    /// `cartridges/` holds nothing to compare.
    #[test]
    fn the_kit_s_verbs_write_the_rows_they_name() {
        let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("..");
        let Ok(library) = std::fs::read_to_string(root.join("cartridges").join("common.vla"))
        else {
            eprintln!("no cartridges/common.vla beside the crate: the kit is the repository's");
            return;
        };
        let fs = files(&[("cartridges/common.vla", library.as_str())]);
        // A call's rows: the source's lines after the include and the
        // manifest, as the pass writes them.
        let rows_of = |call: &str| -> Result<Vec<String>, LineRefusal> {
            let source = format!("(include \"../common.vla\")\n{MANIFEST}{call}\n");
            let e = expand(&source, "cartridges/kit/kit.source.vla", &fs)?;
            let text = lf(&e.text);
            let lines: Vec<&str> = text.lines().collect();
            Ok(lines[lines.len() - e.rows..]
                .iter()
                .map(|l| l.to_string())
                .collect())
        };
        let cases: &[(&str, &[&str])] = &[
            // The sheets, and their words.
            (
                r#"(sheets "Screen" "Palette")"#,
                &[
                    r#"(sheet "Screen" visible)"#,
                    r#"(sheet "Palette" visible)"#,
                ],
            ),
            (
                r#"(labels "Tally" "A11" "pointer column" "pointer row")"#,
                &[
                    r#"(cell "Tally" "A11" "pointer column")"#,
                    r#"(cell "Tally" "A12" "pointer row")"#,
                ],
            ),
            (
                r#"(headers "Write" "A1" "sheet" "address" "value")"#,
                &[
                    r#"(cell "Write" "A1" "sheet")"#,
                    r#"(cell "Write" "B1" "address")"#,
                    r#"(cell "Write" "C1" "value")"#,
                ],
            ),
            // Along row 9 from ZZ into AAA.
            (
                r#"(headers "S" "ZZ9" "a" "b")"#,
                &[r#"(cell "S" "ZZ9" "a")"#, r#"(cell "S" "AAA9" "b")"#],
            ),
            // The library's own audio over headers and labels, numbers as labels.
            (
                r#"(audio)"#,
                &[
                    r#"(cell "Audio" "A1" "voice")"#,
                    r#"(cell "Audio" "B1" "wave")"#,
                    r#"(cell "Audio" "C1" "note")"#,
                    r#"(cell "Audio" "D1" "volume")"#,
                    r#"(cell "Audio" "A2" 1)"#,
                    r#"(cell "Audio" "A3" 2)"#,
                    r#"(cell "Audio" "A4" 3)"#,
                    r#"(cell "Audio" "A5" 4)"#,
                ],
            ),
            (
                r#"(default-keys)"#,
                &[
                    r#"(cell "Keys" "A1" "up")"#,
                    r#"(cell "Keys" "A2" "down")"#,
                    r#"(cell "Keys" "A3" "left")"#,
                    r#"(cell "Keys" "A4" "right")"#,
                    r#"(cell "Keys" "A5" "a")"#,
                    r#"(cell "Keys" "A6" "b")"#,
                    r#"(cell "Keys" "A7" "x")"#,
                    r#"(cell "Keys" "A8" "y")"#,
                    r#"(cell "Keys" "A9" "start")"#,
                    r#"(cell "Keys" "A10" "select")"#,
                    r#"(cell "Keys" "B1" "ArrowUp")"#,
                    r#"(cell "Keys" "B2" "ArrowDown")"#,
                    r#"(cell "Keys" "B3" "ArrowLeft")"#,
                    r#"(cell "Keys" "B4" "ArrowRight")"#,
                    r#"(cell "Keys" "B5" "KeyZ")"#,
                    r#"(cell "Keys" "B6" "KeyX")"#,
                    r#"(cell "Keys" "B7" "KeyA")"#,
                    r#"(cell "Keys" "B8" "KeyS")"#,
                    r#"(cell "Keys" "B9" "Enter")"#,
                    r#"(cell "Keys" "B10" "Space")"#,
                ],
            ),
            // The verbs: a piece as a string, or an &expand of strings.
            (
                r#"(first-frame "Screen" "B2:LG199" "Seed!B2" "0")"#,
                &[r#"(formula "Screen" "B2:LG199" "=IF(Clock!$B$1=1,Seed!B2,0)")"#],
            ),
            (
                r#"(first-frame "Screen" "C2" (&expand "1+" "2") (&expand "Screen.last!" "C2"))"#,
                &[r#"(formula "Screen" "C2" "=IF(Clock!$B$1=1,1+2,Screen.last!C2)")"#],
            ),
            (
                r#"(pressed "Score" "C1:C10" "Input!B1")"#,
                &[r#"(formula "Score" "C1:C10" "=IF(AND(Input!B1=1,Input.last!B1=0),1,0)")"#],
            ),
            // A $ reference's twin.
            (
                r#"(pressed "Score" "C11" "Input!$B$13")"#,
                &[r#"(formula "Score" "C11" "=IF(AND(Input!$B$13=1,Input.last!$B$13=0),1,0)")"#],
            ),
            (
                r#"(count "Tally" "B1:E10" "Input!B1")"#,
                &[r#"(formula "Tally" "B1:E10" "=Tally.last!B1+Input!B1")"#],
            ),
            // A range in two-letter columns, and the grid's last cell alone.
            (
                r#"(count "Screen" "LG1:LH200" 1)"#,
                &[r#"(formula "Screen" "LG1:LH200" "=Screen.last!LG1+1")"#],
            ),
            (
                r#"(count "Screen" "XFD1048576" 1)"#,
                &[r#"(formula "Screen" "XFD1048576" "=Screen.last!XFD1048576+1")"#],
            ),
            (
                r#"(hold "Tally" "B11:B12" "Input!B11>0" "Input!B11")"#,
                &[r#"(formula "Tally" "B11:B12" "=IF(Input!B11>0,Input!B11,Tally.last!B11)")"#],
            ),
            (
                r#"(dice "Tally" "B19")"#,
                &[
                    r#"(formula "Tally" "B19" "=IF(Clock!B1=1,Clock!B3,MOD(Tally.last!B19*16807,2147483647))")"#,
                ],
            ),
            // Verbs inside on, the sheet named once.
            (
                r#"(on "Score" (pressed "C11" "Input!B13") (count "D1:D2" 1))"#,
                &[
                    r#"(formula "Score" "C11" "=IF(AND(Input!B13=1,Input.last!B13=0),1,0)")"#,
                    r#"(formula "Score" "D1:D2" "=Score.last!D1+1")"#,
                ],
            ),
        ];
        for (call, want) in cases {
            let got = rows_of(call)
                .unwrap_or_else(|r| panic!("{call}: {} {}", r.refusal.id, r.refusal.text));
            assert_eq!(got, *want, "{call}");
        }
        // A verb's call is no piece of another's: the language refuses it at
        // the caller's line, the include on 1 and the manifest on 2 to 7.
        let r = rows_of("(count \"Tally\" \"B1\"\n  (pressed \"Tally\" \"B2\" \"Input!B1\"))")
            .expect_err("a verb nested in another");
        assert_eq!(r.refusal.id, "vla-expand-arg-is-list");
        assert_eq!(r.line, 8);
    }
}

#set page(paper: "a4", margin: (x: 1.8cm, y: 1.6cm))
#set text(size: 10pt)
#set par(leading: 0.5em)

#let green     = rgb("#2d5a1b")
#let hdr-fill  = rgb("#b0cc94")
#let row-fill  = rgb("#d8e8cc")
#let alt-fill  = rgb("#f2f7ee")

// ── Change this to control how many specimen rows appear ──────────────────────
#let n-specimens = 8

// ── Row generator: returns a flat array of cells spread into the table ────────
#let specimen-rows(n, n-cols) = {
  let labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".clusters()
  let cells = ()
  for i in range(n) {
    cells.push(text(weight: "bold")[#labels.at(i)])
    for _ in range(n-cols - 1) { cells.push([]) }
  }
  cells
}

// ── Header ────────────────────────────────────────────────────────────────────
#align(center)[
  #text(size: 14pt, weight: "bold", fill: green)[Leaf Morphology — Observation Worksheet]
  #v(0.15em)
  #text(size: 9pt)[Botany Short Course 2026 · Anglia Ruskin University]
]
#v(0.6em)

// ── Name / date fields ────────────────────────────────────────────────────────
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1.2em,
  [Name: #box(width: 1fr, repeat[\_])],
  [Date: #box(width: 1fr, repeat[\_])],
  [Group: #box(width: 1fr, repeat[\_])],
)
#v(0.8em)

// ── Instructions ──────────────────────────────────────────────────────────────
#block(
  fill: row-fill,
  inset: (x: 8pt, y: 6pt),
  radius: 3pt,
  width: 100%,
)[
  #text(weight: "bold")[Instructions] — For each lettered specimen, examine the leaf carefully and fill in each column. Use the terms in the header hints where they fit; add your own if needed. Leave blank if a character is unclear.
]
#v(0.8em)

// ── Observation table ─────────────────────────────────────────────────────────
#let n-cols = 8
#let hint(t) = text(size: 7.5pt, style: "italic", fill: rgb("#555"))[#t]

#table(
  columns: (0.7cm, 2.2cm, 2.2cm, 2.4cm, 2.6cm, 2.2cm, 2.0cm, 1fr),
  fill: (col, row) => {
    if row == 0 { hdr-fill }
    else if row == 1 { rgb("#ddebd0") }
    else if col == 0 { row-fill }
    else if calc.rem(row, 2) == 0 { alt-fill }
    else { white }
  },
  stroke: (paint: rgb("#999"), thickness: 0.4pt),
  inset: (x: 4pt, y: 15pt),
  align: (col, row) => if col == 0 { center + horizon } else if row <= 1 { center } else { top + left },

  // header row 1 — column titles
  text(weight: "bold")[Sp.],
  text(weight: "bold")[Arrangement],
  text(weight: "bold")[Simple or\ compound?],
  text(weight: "bold")[Shape],
  text(weight: "bold")[Margin],
  text(weight: "bold")[Venation],
  text(weight: "bold")[Surface],
  text(weight: "bold")[Notes],

  // header row 2 — hints
  [],
  hint[alternate · opposite · whorled · basal],
  hint[simple · pinnate · palmate],
  hint[ovate · lanceolate · linear · oblong · round · lobed],
  hint[entire · toothed · lobed · wavy],
  hint[pinnate · palmate · parallel],
  hint[smooth · hairy · waxy · rough],
  hint[smell? colour? petiole? stipules?],

  ..specimen-rows(n-specimens, n-cols),
)

#v(1em)

// ── Sketch / notes area ───────────────────────────────────────────────────────
#text(weight: "bold", fill: green)[Sketches and additional notes]
#v(0.4em)
#box(
  width: 100%,
  height: 5cm,
  stroke: (paint: rgb("#bbb"), thickness: 0.5pt),
  radius: 2pt,
)[]

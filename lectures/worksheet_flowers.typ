#set page(paper: "a4", margin: (x: 1.8cm, y: 1.6cm))
#set text(size: 10pt)
#set par(leading: 0.5em)

#let green     = rgb("#2d5a1b")
#let hdr-fill  = rgb("#e8c8c8")
#let row-fill  = rgb("#f4dede")
#let alt-fill  = rgb("#fdf5f5")

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
  #text(size: 14pt, weight: "bold", fill: green)[Flower Morphology — Observation Worksheet]
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
  inset: (x: 8pt, y: 8pt),
  radius: 3pt,
  width: 100%,
)[
  #text(weight: "bold")[Instructions] — For each lettered specimen, identify the floral parts and fill in each column. Dissect carefully if needed — lay parts on white card. Count each whorl separately. Use R (radial) or B (bilateral) for symmetry.
]
#v(0.8em)

// ── Observation table ─────────────────────────────────────────────────────────
#let n-cols = 9
#let hint(t) = text(size: 7.5pt, style: "italic", fill: rgb("#555"))[#t]

#table(
  columns: (0.7cm, 1.6cm, 1.6cm, 2.4cm, 1.7cm, 1.7cm, 2.2cm, 2.2cm, 1fr),
  fill: (col, row) => {
    if row == 0 { hdr-fill }
    else if row == 1 { rgb("#f0d5d5") }
    else if col == 0 { row-fill }
    else if calc.rem(row, 2) == 0 { alt-fill }
    else { white }
  },
  stroke: (paint: rgb("#999"), thickness: 0.4pt),
  inset: (x: 4pt, y: 15pt),
  align: (col, row) => if col == 0 { center + horizon } else if row <= 1 { center } else { top + left },

  // header row 1 — column titles
  text(weight: "bold")[Sp.],
  text(weight: "bold")[Sepals\ (\#)],
  text(weight: "bold")[Petals\ (\#)],
  text(weight: "bold")[Free or\ fused?],
  text(weight: "bold")[Stamens\ (\#)],
  text(weight: "bold")[Carpels\ (\#)],
  text(weight: "bold")[Symmetry],
  text(weight: "bold")[Inflorescence],
  text(weight: "bold")[Notes],

  // header row 2 — hints
  [],
  hint[count],
  hint[count],
  hint[free / fused / absent],
  hint[count],
  hint[count if visible],
  hint[R = radial\ B = bilateral],
  hint[solitary · raceme · umbel · spike · cyme…],
  hint[colour · scent · spur · superior/inferior ovary],

  ..specimen-rows(n-specimens, n-cols),
)

#v(1em)

// ── Sketch / notes area ───────────────────────────────────────────────────────
#text(weight: "bold", fill: green)[Sketches and additional notes]
#v(0.4em)
#box(
  width: 100%,
  height: 6cm,
  stroke: (paint: rgb("#bbb"), thickness: 0.5pt),
  radius: 2pt,
)[]

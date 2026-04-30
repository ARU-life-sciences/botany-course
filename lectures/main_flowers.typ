#import "@preview/touying:0.7.1": *
#import "../lib/flowers.typ": *

#import themes.simple: *
#show: simple-theme.with(aspect-ratio: "16-9")

#title-slide[
  = Botany short course 2026
  #block(text(size: 1.5em, fill: rgb("#4f6b3c"), weight: "bold")[Flowers])
  
  Max Carter-Brown
  
  Anglia Ruskin University
]

== What is a flower?

- Reproductive organ of the Angiosperms
#pause
- Evolutionarily derived from leaves
#pause
- Contain the megaspores (ovaries) and microspores (pollen)
#pause
- Much variation but exist as 3-4 'whorls'

== Flower characters you will classify
#grid(
  columns: (1fr, 1fr),
  gutter: 1.2em,
  [
    - Sepals (or calyx)
    #pause
    - Petals (or corolla); tepals (undifferentiated perianth)
    #pause
    - Stamens (anthers + filament; androecium)
    #pause
    - Carpels (ovary + style + stigma; pistil)
  ],
  {
    // uncover() can't cross CeTZ's context boundary — use #only to swap
    // between diagram versions, each showing one more label.
    // Coordinates in canvas units: 1 unit = 1 cm at size 9cm.
    let fl = (
      (from: (0.0, -3.1), to: (0.0, -4.8), anchor: "north",
       body: text(size: 9pt, weight: "bold")[Sepal]),
      (from: (0.0,  4.55), to: (0.0,  5.5), anchor: "south",
       body: text(size: 9pt, weight: "bold")[Petal]),
      (from: (1.1,  1.4),  to: (3.8,  2.6), anchor: "west",
       body: text(size: 9pt, weight: "bold")[Stamen]),
      (from: (0.7,  0.0),  to: (3.8, -1.0), anchor: "west",
       body: text(size: 9pt, weight: "bold")[Carpel / pistil]),
    )
    align(center)[
      #only(1)[#flower_top(size: 9cm, kind: "dicot", labels: fl.slice(0, 1))]
      #only(2)[#flower_top(size: 9cm, kind: "dicot", labels: fl.slice(0, 2))]
      #only(3)[#flower_top(size: 9cm, kind: "dicot", labels: fl.slice(0, 3))]
      #only(4)[#flower_top(size: 9cm, kind: "dicot", labels: fl.slice(0, 4))]
    ]
  },
)

== Idealised flower top view

#let _lbl(b) = text(size: 8pt, weight: "bold", b)
#grid(
  columns: (1fr, 1fr), gutter: 1.4em,
  labeled_flower("Idealised dicot flower (top view)",
    flower_top(kind: "dicot", size: 7cm, labels: (
      (from: (0.0, -3.2), to: (0.0, -4.8), anchor: "north", body: _lbl[Sepal]),
      (from: (0.0,  4.55), to: (0.0,  5.6), anchor: "south", body: _lbl[Petal]),
      (from: (1.1,  1.4),  to: (3.8,  2.4), anchor: "west",  body: _lbl[Stamen]),
      (from: (0.7,  0.0),  to: (3.8, -0.6), anchor: "west",  body: _lbl[Gynoecium]),
    )), body-height: 8cm),
  labeled_flower("Idealised monocot flower (top view)",
    flower_top(kind: "monocot", size: 7cm, labels: (
      (from: (0.0,  5.0),  to: (0.0,  6.1), anchor: "south", body: _lbl[Outer tepal]),
      (from: (3.5,  2.0),  to: (5.2,  2.2), anchor: "west",  body: _lbl[Inner tepal]),
      (from: (1.85, 0.0),  to: (3.8, -0.5), anchor: "west",  body: _lbl[Stamen]),
      (from: (0.72, 0.0),  to: (3.5,  0.5), anchor: "west",  body: _lbl[Gynoecium]),
    )), body-height: 8cm),
)

== Idealised flower cross-section

#grid(
  columns: (1fr, 1fr), gutter: 1.4em,
  labeled_flower("Idealised dicot flower",
    flower_section(kind: "dicot", size: 7cm, labels: (
      (from: (0.0,  -1.2),  to: (-3.2, -1.2), anchor: "east", body: _lbl[Pedicel]),
      (from: (2.0,   0.8),  to: ( 3.8,  0.8), anchor: "west", body: _lbl[Sepal]),
      (from: (1.9,   4.2),  to: ( 3.8,  4.2), anchor: "west", body: _lbl[Petal]),
      (from: (1.0,   2.4),  to: ( 3.8,  2.4), anchor: "west", body: _lbl[Stamen]),
      (from: (-0.65, 1.0),  to: (-3.2,  1.0), anchor: "east", body: _lbl[Ovary]),
      (from: (-0.05, 3.1),  to: (-3.2,  3.1), anchor: "east", body: _lbl[Style]),
      (from: (0.0,   4.5),  to: ( 3.8,  5.0), anchor: "west", body: _lbl[Stigma]),
    )), body-height: 9cm),
  labeled_flower("Idealised monocot flower",
    flower_section(kind: "monocot", size: 7cm, labels: (
      (from: (-2.9,  1.7),  to: (-4.8,  1.7), anchor: "east", body: _lbl[Outer tepal]),
      (from: (-1.5,  2.6),  to: (-4.8,  2.3), anchor: "east", body: _lbl[Inner tepal]),
      (from: (1.1,   2.7),  to: ( 4.8,  2.7), anchor: "west", body: _lbl[Stamen]),
      (from: (-0.58, 0.9),  to: (-4.8,  0.9), anchor: "east", body: _lbl[Ovary]),
      (from: (-0.05, 3.3),  to: (-4.8,  3.3), anchor: "east", body: _lbl[Style]),
      (from: (0.4,   4.0),  to: ( 4.8,  4.2), anchor: "west", body: _lbl[Stigma]),
    )), body-height: 9cm),
)

== Floral symmetry

#grid(
  columns: (1fr, 1fr), gutter: 1.4em,
  labeled_flower(
    [Actinomorphic — radially symmetrical \ #text(size: 9pt)[e.g. _Ranunculus_, _Rosa_]],
    flower_top(kind: "dicot", size: 7cm, symmetry-lines: 5),
    body-height: 8cm,
  ),
  labeled_flower(
    [Zygomorphic — bilaterally symmetrical \ #text(size: 9pt)[e.g. _Lamium_, _Digitalis_]],
    flower_top(kind: "bilabiate", size: 7cm, labels: (
      (from: (1.2, 3.5),  to: (4.2, 4.4), anchor: "west", body: _lbl[Upper lip]),
      (from: (1.0, -3.6), to: (4.2, -4.4), anchor: "west", body: _lbl[Lower lip]),
    )),
    body-height: 8cm,
  ),
)

== Activity — Flower observation

#let green = rgb("#4f6b3c")

*You have a selection of flowers.*

+ Is the flower solitary, or part of an inflorescence?
+ Count the parts of each whorl
+ Are petals free or fused?
+ Is the flower radially or bilaterally symmetric?
+ Dissect carefully if needed — lay parts on card

#v(0.4em)
_Worksheet provided separately_

== What to record

#set text(size: 16pt)
#table(
  columns: (4cm, 1fr),
  fill: (col, _row) => if col == 0 { rgb("#f8f0f0") } else { white },
  stroke: (paint: rgb("#999"), thickness: 0.4pt),
  inset: (x: 5pt, y: 8pt),
  table.cell(colspan: 2, fill: rgb("#e8c8c8"),
    align(center)[#text(weight: "bold", fill: green)[Flower characters]]),
  [*Sepals*],    [Count — note if joined or free],
  [*Petals*],   [Count — note if free or fused into a tube],
  [*Stamens*],  [Count — note if same number as petals or different],
  [*Carpels*],  [Count if visible — superior or inferior ovary?],
  [*Symmetry*], [Radial (actinomorphic) or bilateral (zygomorphic)],
  [*Notes*],    [Colour · scent · spur · nectary · hairy?],
)

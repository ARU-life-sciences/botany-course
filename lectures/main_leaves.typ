#import "@preview/touying:0.7.1": *
#import "../lib/leafs.typ": *

#import themes.simple: *
#show: simple-theme.with(aspect-ratio: "16-9")

#title-slide[
  = Botany short course 2026
  #block(text(size: 1.5em, fill: rgb("#4f6b3c"), weight: "bold")[Leaves])
  
  Max Carter-Brown
  
  Anglia Ruskin University
]

== What is a leaf?
- Variable in size and shape, form and function
#pause
- Photosynthetic, protective (spines/sheaths), architectural (climbing), carnivorous (pitchers), storage (e.g. garlic)
#pause
- *A leaf always subtends a bud*

== Leaves always subtend a bud
#align(center)[#leaf_axil_illustration(size: 11cm)]

== Leaf characters you will classify
#grid(
  columns: (1fr, 1fr),
  gutter: 1.2em,
  [
    - Simple and compound
    - Margins
    - Bases
    - Overall shape
    - Venation
    - Any hairs?
  ],
  [#hero_leaf()],
)

== Simple vs compound
#leaf_complexity_gallery()

== Margins and bases
- Margins look at leaf edges
- Bases are where the petiole joins the leaf

= Leaf margins
#leaf_margin_gallery()

= Leaf bases
#leaf_base_gallery()

== Shape and venation
- Overall leaf shape. There are *many*, we only show a few...
- What do the leaf *veins* look like

= Overall leaf shape
#leaf_shape_gallery()

= Venation
#leaf_venation_gallery()

== Leaf hairs
#leaf_hair_gallery()

== Leaf glands
#leaf_gland_gallery()

== Activity — Leaf observation

#let green = rgb("#4f6b3c")

*You have a selection of leaves from different species.*

+ Pick up one leaf at a time — work through the characters on the next slide
+ Record each on your worksheet
+ Once all leaves described — can you group any together?

#v(0.4em)
_Worksheet provided separately_

== What to record

#set text(size: 16pt)
#table(
  columns: (4cm, 1fr),
  fill: (col, _row) => if col == 0 { rgb("#d8e8cc") } else { white },
  stroke: (paint: rgb("#999"), thickness: 0.4pt),
  inset: (x: 5pt, y: 8pt),
  table.cell(colspan: 2, fill: rgb("#b0cc94"),
    align(center)[#text(weight: "bold", fill: green)[Leaf characters]]),
  [*Arrangement*],         [Alternate · opposite · whorled · basal rosette],
  [*Simple or compound?*], [Simple / pinnately compound / palmately compound],
  [*Shape*],               [Ovate · lanceolate · linear · oblong · round · lobed],
  [*Margin*],              [Entire · toothed (serrate/dentate) · lobed · wavy],
  [*Venation*],            [Pinnate · palmate · parallel],
  [*Surface*],             [Smooth · hairy · waxy · rough],
  [*Notes*],               [Smell? Colour? Petiole? Stipules?],
)

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
- Photosynthetic, protective (spines/sheaths), architectural (climbing), carnivorous (pitchers)
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

== Exercise
- There are leaves from different species
- Take one example from each species
- Group similar leaves together
- Describe each group of leaves as best you can

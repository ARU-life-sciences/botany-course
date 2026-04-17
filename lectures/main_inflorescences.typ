#import "@preview/touying:0.7.1": *
#import "../lib/inflorescences.typ": *

#import themes.simple: *
#show: simple-theme.with(aspect-ratio: "16-9")

#title-slide[
  = Botany short course 2026
  #block(text(size: 1.5em, fill: rgb("#4f6b3c"), weight: "bold")[Inflorescences])

  Max Carter-Brown

  Anglia Ruskin University
]

== What is an inflorescence?

#grid(
  rows: 2,
  gutter: 1.5em,
  align: (left, right + horizon),
  [
    - The whole flowering shoot — including open flowers, buds, and spent flowers/fruits
    #pause
    - Knowing the *arrangement* of flowers is one of the first steps in the identification method we will use
    #pause
    - There are many types
  ],
  inf_legend(flower-size: 3cm),
)

== Simple inflorescences

#inf_simple_gallery()

== Complex inflorescences

#inf_complex_gallery()

== Tight heads

#tight_head_gallery()

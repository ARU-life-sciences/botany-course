#import "../lib/family_diagrams.typ": (
  prunus_top, prunus_section,
  poterium_carpellate_top, poterium_staminate_top, poterium_section,
)
#import "../lib/floral_formula.typ": floral

#set page(paper: "a4", margin: (x: 1.8cm, y: 1.6cm))
#set text(size: 10pt)
#set par(leading: 0.45em)

#let green    = rgb("#2d5a1b")
#let row-fill = rgb("#d8e8cc")

// ── Header ─────────────────────────────────────────────────────────────────────
#align(center)[
  #text(size: 15pt, weight: "bold", fill: green)[Rosaceae]
  #h(0.6em)
  #text(size: 9pt, style: "italic")[Rose family · \~4800 spp.]
]
#v(0.3em)

#block(fill: row-fill, inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%)[
  #grid(columns: (auto, 1fr), column-gutter: 1em,
    text(weight: "bold")[Shared characters],
    [Perigynous–epigynous hypanthium ·
     Leaves alternate, stipulate
     #h(0.5em)
     #text(style: "italic", size: 8.5pt)[

       General formula: #h(0.3em)

       #floral(
        symmetry: "*",
        calyx: "3–10",
        petals: "0–10",
        stamens: "1–∞",
        carpels: "1–∞",
        carpels-connate: "variable",
        ovary: "variable",
        fruit: [achene, drupelets, follicle, drupe, pome],
        adnation: (
          (from: "K", to: "A", variable: true),
        ),
      )
     ]
    ],
  )
]
#v(0.8em)

// ── Two-species columns ────────────────────────────────────────────────────────
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.4em,

  // ── LEFT: Prunus padus ──────────────────────────────────────────────────────
  [
    #align(center)[
      #text(size: 12pt, weight: "bold", style: "italic")[Prunus padus]
      #h(0.4em)#text(size: 9pt)[L.]
      #linebreak()
      #text(size: 9pt)[Bird Cherry · bisexual]
    ]
    #v(0.5em)

    #block(fill: rgb("#f0f8e8"), inset: (x: 8pt, y: 6pt), radius: 3pt, width: 100%)[
      #set text(size: 9pt)
      #align(center)[
        #floral(
          symmetry: "*",
          calyx: 5,
          petals: 5,
          stamens: "23–30",
          carpels: 1,
          ovary: "s",
          fruit: [drupe],
        )
      ]
      #v(0.3em)
      #set text(size: 7.5pt, style: "italic")
    ]
    #v(0.6em)

    #align(center)[
      #prunus_top(size: 5.8cm)
      #v(0.2em)
      #text(size: 8pt, style: "italic")[
        Top view — 5 petals, ~25 stamens,\ 1 carpel; perigynous hypanthium rim visible
      ]
    ]
    #v(0.6em)

    #align(center)[
      #prunus_section(size: 5.8cm)
      #v(0.2em)
      #text(size: 8pt, style: "italic")[
        Longitudinal section — cup-shaped hypanthium;\ ovary superior (#underline[G]: free inside cup)
      ]
    ]
  ],

  // ── RIGHT: Poterium sanguisorba ─────────────────────────────────────────────
  [
    #align(center)[
      #text(size: 12pt, weight: "bold", style: "italic")[Poterium sanguisorba]
      #h(0.4em)#text(size: 9pt)[L.]
      #linebreak()
      #text(size: 9pt)[Salad Burnet · wind-pollinated · monoecious]
    ]
    #v(0.5em)

    #block(fill: rgb("#f0f8e8"), inset: (x: 8pt, y: 6pt), radius: 3pt, width: 100%)[
      #set text(size: 9pt)
      #grid(columns: (0.9em, 1fr), column-gutter: 4pt, row-gutter: 3pt,
        align(horizon)[♀],
        [#floral(
            symmetry: "*",
            calyx: 4,
            petals: 0,
            stamens: 0,
            carpels: 2,
            ovary: "i",
            fruit: [achene],
        )],
        align(horizon)[♂],
        [#floral(
          symmetry: "*",
          calyx: 4,
          petals: 0,
          stamens: "20–30",
          carpels: 0,
        )],
      )
      #v(0.3em)
      #set text(size: 7.5pt, style: "italic")
      ♀: very enclosed hypanthium; carpels free (not fused to wall); tepals green \
      ♂: pendant stamens; occasionally rudimentary carpels present; tepals green
    ]
    #v(0.6em)

    #align(center)[
      #grid(columns: (1fr, 1fr), column-gutter: 0.8em,
        align(center)[
          #poterium_carpellate_top(size: 3.8cm)
          #v(0.2em)
          #text(size: 8pt)[♀ carpellate]
        ],
        align(center)[
          #poterium_staminate_top(size: 3.8cm)
          #v(0.2em)
          #text(size: 8pt)[♂ staminate]
        ],
      )
      #v(0.15em)
      #text(size: 8pt, style: "italic")[
        Top views — K4, no petals; feathery stigmas (♀)\ or pendant stamens (♂); hypanthium mouth as ring
      ]
    ]
    #v(0.6em)

    #align(center)[
      #poterium_section(size: 4.8cm)
      #v(0.2em)
      #text(size: 8pt, style: "italic")[
        Longitudinal section (♀) — urn-shaped hypanthium;\ G̅#sub[2]: carpels enclosed but free from wall
      ]
    ]
  ],
)

#v(0.8em)
#line(length: 100%, stroke: (paint: rgb("#aaa"), thickness: 0.4pt))
#v(0.3em)
#text(size: 7.5pt)[
  #text(weight: "bold", fill: green)[Formula notation] #h(0.5em)
  #underline[G] = superior (hypogynous — other parts insert below ovary) ·
  G̅ = inferior (epigynous — other parts insert above ovary) #h(1em)
  #text(weight: "bold", fill: green)[Contrast] #h(0.5em)
  In _Prunus_ the ovary sits free inside an open cup (perigynous, superior).
  In _Poterium_ the urn-shaped hypanthium deeply encloses the carpels; the carpels are free from the hypanthium wall
  but appear inferior because other parts insert at the mouth above them.
  Both share the polystemonous androecium and stipulate alternate leaves characteristic of Rosaceae.
]

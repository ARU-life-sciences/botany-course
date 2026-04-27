// Family Finder — British Vascular Plants
// Landscape A4 handout. Compile with: typst compile famfinder.typ
// Based on the original Famfinder by R. Milne; rebuilt in Typst with Stace (2019) family names.

#import "../lib/inflorescences.typ": inf_solitary, inf_pair, inf_axillary, inf_spike, inf_raceme, inf_umbel, inf_cyme, inf_tight_umbel, inf_catkin
#import "../lib/flowers.typ": flower_top

#set page(paper: "a4", flipped: true, margin: (x: 0.65cm, y: 0.65cm))
#set text(size: 7.5pt)
#set par(leading: 0.35em)

#let green      = rgb("#2d5a1b")
#let dark-red   = rgb("#7a1500")
#let hdr-fill   = rgb("#b0cc94")
#let row-fill   = rgb("#d8e8cc")
#let alt-fill   = rgb("#f2f7ee")
#let bil-hdr    = rgb("#e8c8c8")
#let bil-fill   = rgb("#f8f0f0")

// Helper: family list — single column up to 8 entries, two columns above that
#let fams(..names) = {
  let items = names.pos()
  if items.len() > 8 {
    let half = calc.ceil(items.len() / 2)
    grid(
      columns: (1fr, 1fr),
      column-gutter: 4pt,
      row-gutter: 0pt,
      items.slice(0, half).join[\ ],
      items.slice(half).join[\ ],
    )
  } else {
    items.join[\ ]
  }
}

// Helper: empty cell — neutral grey to signal no families in this combination
#let no-fams = table.cell(fill: rgb("#d4d4d4"))[]

// Helper: row label cell — diagram above, bold label below
#let row-label(diagram, label) = align(center)[
  #diagram
  #text(weight: "bold")[#label]
]

#align(center)[
  #text(size: 10pt, weight: "bold", fill: green)[Table 1: Family Finder — British Vascular Plants]
  #h(0.8em)
  #text(size: 7.5pt, style: "italic")[
    Flowers not green or brown · radially or bilaterally symmetric · herbaceous plants
  ]
]
#v(0.25em)

#table(
  columns: (2.1cm, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  fill: (col, row) => {
    if row == 0 {
      if col == 6 { bil-hdr } else { hdr-fill }
    } else if col == 0 {
      row-fill
    } else if col == 6 {
      bil-fill
    } else if calc.rem(row, 2) == 0 {
      alt-fill
    } else {
      white
    }
  },
  stroke: (paint: rgb("#999"), thickness: 0.4pt),
  inset: (x: 3.5pt, y: 3pt),

  // ── HEADER ──────────────────────────────────────────────────────────────────
  align(center, text(size: 9pt, weight: "bold")[Flower\ arrangement]),
  // 3 or 6 petals — show 3-petal and monocot side by side
  align(center)[
    #grid(columns: 2, gutter: 0.4em,
      flower_top(kind: "3-petal",  size: 1.4cm),
      flower_top(kind: "monocot",  size: 1.4cm))
    #text(size: 9pt, weight: "bold")[3 or 6 petals]\ #text(style: "italic", size: 7pt)[(or multiples)]
  ],
  align(center)[
    #flower_top(kind: "4-petal", size: 1.4cm)
    #text(size: 9pt, weight: "bold")[4 petals]
  ],
  align(center)[
    #flower_top(kind: "joined", size: 1.9cm)
    #text(size: 9pt, weight: "bold")[5 petals joined]\ #text(style: "italic", size: 7pt)[(tubular / bell)]
  ],
  align(center)[
    #flower_top(kind: "dicot", size: 1.4cm)
    #text(size: 9pt, weight: "bold")[5 petals free]
  ],
  align(center)[
    #flower_top(kind: "many-petal", size: 1.4cm)
    #text(size: 9pt, weight: "bold")[7+ petals]
  ],
  align(center, text(fill: dark-red)[
    #flower_top(kind: "bilabiate", size: 1.4cm)
    #text(size: 9pt, weight: "bold")[Bilateral\ flowers]
  ]),

  // ── ROW 1 — SINGLE OR PAIR ──────────────────────────────────────────────────
  table.cell(align: top + center,
    row-label(
      grid(columns: 2, gutter: 0.8em,
        inf_solitary(size: 1.3cm), inf_pair(size: 1.3cm)),
      [Single or pair])),

  // 3/6
  fams(
    "Amaryllidaceae",
    "Iridaceae",
    "Liliaceae",
    "Colchicaceae",
    "Aristolochiaceae",
    "Hydrocharitaceae",
    "Alismataceae",
  ),

  // 4 petals
  fams(
    "Papaveraceae",
    "Rosaceae",
    "Onagraceae", 
    "Caryophyllaceae",
    "Gentianaceae",
  ),

  // 5 joined
  fams(
    "Primulaceae",
    "Ericaceae",
    "Convolvulaceae",
    "Campanulaceae",
    text(fill: red)[Apocynaceae],
    "Gentianaceae",
    "Solanaceae",
    "Caprifoliaceae",
    "Menyanthaceae",
  ),

  // 5 free
  fams(
    "Ranunculaceae",
    "Rosaceae",
    "Geraniaceae",
    "Caryophyllaceae",
    "Hypericaceae",
    "Oxalidaceae",
    "Saxifragaceae",
    "Parnassiaceae",
    "Malvaceae",
    "Paeoniaceae",
    "Linaceae",
    "Cistaceae",
    "Portulacaceae",
    "Montiaceae",
    text(fill: red)[Limnanthaceae],
    text(fill: red)[Sarraceniaceae]
  ),

  // 7+
  fams(
    "Ranunculaceae",
    "Nymphaeaceae",
    "Primulaceae",
    "Rosaceae",
    "Gentianaceae",
    text(fill: red)[Paeoniaceae],
    "Aizoaceae",
    "(Asteraceae - check!)",
    "(Caryophyllaceae - check!)"
  ),

  // Bilateral
  fams(
    "Fabaceae",
    "Violaceae",
    "Balsaminaceae",
    "Caprifoliaceae",
    "Lentibulariaceae",
    "Ranunculaceae",
    "Orchidaceae",
  ),

  // ── ROW 2 — IN LEAF AXILS ───────────────────────────────────────────────────
  table.cell(align: top + center, row-label(inf_axillary(size: 1.7cm), [In Leaf Axils])),

  // 3/6
  fams(
    "Liliaceae",
    "Lythraceae",
    "Aristolochiaceae",
  ),

  // 4 petals
  fams(
    "Onagraceae",
    "Rosaceae",
    "Rubiaceae",
    "Caryophyllaceae",
    [(Veronicaceae - _Veronica_; bilateral)]
  ),

  // 5 joined
  fams(
    "Boraginaceae",
    "Ericaceae",
    "Primulaceae",
    "Campanulaceae",
    "Convolvulaceae",
    "Apocynaceae",
    "Solanaceae",
    "Curcubitaceae",
    text(fill: red)[Hydrophyllaceae]
  ),

  // 5 free
  fams(
    "Malvaceae",
    "Hypericaceae",
    "Caryophyllaceae",
    "Polygonaceae",
    "Crassulaceae",
    "Rosaceae",
    "Primulaceae",
    "Lythraceae",
    "Portulacaceae",
    "Linaceae",
    "Cistaceae",
    "Oxalidaceae",
    "Saxifragaceae",
    [(Solanaceae - _Solanum_?)],
    "Santalaceae",
    "Frankeniaceae"
  ),

  // 7+
  fams(
    text(fill: red)[Aizoaceae],
    "(Caryophyllaceae - check!)",
    "(Onagraceae - check!)"
  ),

  // Bilateral
  fams(
    "Lamiaceae",
    "Veronicaceae",
    "Caprifoliaceae", 
    "Fabaceae",
    "Onagraceae",
    "Violaceae",
    "Balsaminaceae", 
    text(fill: red)[Phrymaceae],
    "Scrophulariaceae",
    "Orobanchaceae",
    text(fill: red)[Tropaolaceae - _Tropaeolum_]
  ),

  // ── ROW 3 — SPIKE OR RACEME ─────────────────────────────────────────────────
  table.cell(align: top + center,
    row-label(
      grid(columns: 2, gutter: 0.8em,
        inf_spike(size: 1.3cm), inf_raceme(size: 1.3cm)),
      [Spike or Raceme])),

  // 3/6
  fams(
    "Liliaceae",
    "Lythraceae",
    "Dioscoreaceae",
    "Alismataceae",
    "Asparagaceae",
    "Amaryllidaceae",
    "Nartheciaceae",
    "Resedaceae",
    "Polygonaceae",
    "Iridaceae",
    "Scheuchzeriaceae",
    "Asphodelaceae",
    "Tofieldiaceae",
    text(fill: red)[Pontederiaceae (semi-aquatic)]
  ),

  // 4 petals
  fams(
    "Brassicaceae",
    "Onagraceae",
    "Resedaceae",
    "Polygonaceae",
  ),

  // 5 joined
  fams(
    "Campanulaceae",
    "Boraginaceae",
    "Ericaceae",
    "Menyanthaceae",
    "Crassulaceae",
    "Primulaceae",
    "Curcubitaceae",
    "Resedaceae"
  ),

  // 5 free
  fams(
    "Rosaceae",
    "Lythraceae",
    "Resedaceae",
    "Polygonaceae",
    "Saxifragaceae",
    "Droseraceae",
    "Linaceae",
    "Cistaceae",
    "Portulacaceae",
    "Ranunculaceae",
    "Santalaceae",
    text(fill: red)[Phytolaccaceae]
  ),

  // 7+
  fams(
    [(Brassicaceae - _Draba_? Check!)],
    [(Onagraceae - _Epilobium_? Check!)],
    "Resedaceae"
  ),

  // Bilateral
  fams(
    "Lamiaceae",
    "Veronicaceae",
    "Scrophulariaceae",
    "Papaveraceae (Fumarioideae)",
    "Fabaceae",
    [Onagraceae (_Chamaenerion_)],
    "Orchidaceae",
    "Polygalaceae",
    "Balsaminaceae",
    "Verbenaceae",
    [Brassicaceae (_Iberis_, _Teesdalia_)],
    "Ranunculaceae",
    "Resedaceae",
    "Campanulaceae",
    [Iridaceae (e.g. _Crocosmia_)],
    "Lentibulariaceae",
    "Boraginaceae"
  ),

  // ── ROW 4 — UMBEL ───────────────────────────────────────────────────────────
  table.cell(align: top + center, row-label(inf_umbel(size: 1.7cm), [Umbel])),

  // 3/6
  fams(
    "Liliaceae",
    "Amaryllidaceae",
    "Butomaceae",
    "(Alismataceae - not true umbels)"
  ),

  // 4 petals
  fams(
    "Papaveraceae"
  ),

  // 5 joined
  fams(
    "Primulaceae",
    "Curcubitaceae"
  ),

  // 5 free
  fams(
    "Apiaceae",
    "Hydrocotylaceae",
    "Geraniaceae",
    "Oxalidaceae",
    "Rosaceae"
  ),

  // 7+
  no-fams,

  // Bilateral
  fams(
    "Apiaceae",
    [#text(style: "italic", size: 6pt)[(outer florets only)]],
    "Fabaceae",
    text(fill: red)[Alstromeriaceae]
  ),

  // ── ROW 5 — COMPLEX GROUP ───────────────────────────────────────────────────
  table.cell(align: top + center, row-label(inf_cyme(size: 1.7cm), [Complex group])),

  // 3/6
  fams(
    "Dioscoreaceae",
    "Alismataceae",
    "Asparagaceae",
    "Polygonaceae",
    "Rosaceae",
    "Rubiaceae",
    text(fill:red)[Commelinaceae]
  ),

  // 4 petals
  fams(
    "Rubiaceae",
    [(Rosaceae - _Alchemilla_; sepals?)],
    "Brassicaceae",
    "Crassulaceae",
    "Saxifragaceae",
    "Gentianaceae",
    "Onagraceae",
    [(Veronicaceae - _Veronica_)]
  ),

  // 5 joined
  fams(
    "Boraginaceae",
    "Valerianaceae",
    "Gentianaceae",
    "Primulaceae",
    "Solanaceae",
    [Rubiaceae (_Rubia_)],
    "Polemoniaceae",
    "Plumbaginaceae",
    "Caprifoliaceae",
    "Ericaceae",
    text(fill: red)[Nyctaginaceae],
    text(fill: red)[Hydrophyllaceae]
  ),

  // 5 free
  fams(
    "Rosaceae",
    "Hypericaceae",
    "Polygonaceae",
    "Caryophyllaceae",
    "Saxifragaceae",
    "Crassulaceae",
    "Malvaceae",
    "Ranunculaceae",
    "Geraniaceae",
    "Linaceae",
    "Montiaceae",
    "(Solanaceae)"
  ),

  // 7+
  fams(
    "(Asteraceae - actually a tight head)",
    "(Caryophyllaceae - bifid petals)",
    "Ranunculaceae",
    "Rosaceae",
    [Gentianaceae (_Blackstonia_)]
  ),

  // Bilateral
  fams(
    "Scrophulariaceae",
    "Valerianaceae",
    "Balsaminaceae",
    "Lamiaceae",
    "Polemoniaceae",
    "Boraginaceae",
    text(fill: red)[Alstromeriaceae]
  ),

  // ── ROW 6 — TIGHT HEAD ──────────────────────────────────────────────────────
  table.cell(align: top + center, row-label(inf_tight_umbel(size: 1.7cm), [Tight head])),

  // 3/6
  fams(
    "Asparagaceae",
    "Amaryllidaceae",
    "Asphodelaceae",
    text(fill: red)[Bromeliaceae]
  ),

  // 4 petals
  fams(
    "Dipsacaceae",
    "Rosaceae",
    "Brassicaceae",
    "Eriocaulaceae",
    "Polygonaceae",
    "Rubiaceae",
    "(Asteraceae)"
  ),

  // 5 joined
  fams(
    "Asteraceae",
    "Dipsacaceae",
    "Campanulaceae",
    "(Boraginaceae)",
    "Valerianaceae",
    "Convolvulaceae"
  ),

  // 5 free
  fams(
    "Caryophyllaceae",
    "Rosaceae",
    "Apiaceae",
    "Plumbaginaceae",
    "Cannabaceae",
    "(Asteraceae)",
    "Polygonaceae"
  ),

  // 7+
  fams(
    "(Asteraceae - 5 fused petals)",
    "(Caryophyllaceae - bifid petals)"
  ),

  // Bilateral
  fams(
    "Fabaceae",
    "Asteraceae",
    [#text(style: "italic", size: 6pt)[(ray florets)]],
    "Lamiaceae",
    "Dipsacaceae",
    "Valerianaceae",
    "Caprifoliaceae"
  ),
)

// ═══════════════════════════════════════════════════════════════════════════
// PAGE 2 — Supplementary tables
// ═══════════════════════════════════════════════════════════════════════════
#pagebreak()

// ── additional colour palette ──────────────────────────────────────────────
#let wh-hdr   = rgb("#deded8")
#let ye-hdr   = rgb("#eae870")
#let pk-hdr   = rgb("#e6b2c6")
#let tr-hdr   = rgb("#ccb87a")
#let tr-fill  = rgb("#e6ddc0")
#let aq-hdr   = rgb("#80bed4")
#let aq-fill  = rgb("#cce8f4")
#let noc-hdr  = rgb("#b8aeca")
#let noc-fill = rgb("#e2def0")

// compact text row-label
#let rl(body) = align(center + horizon)[#text(weight: "bold", size: 6.5pt)[#body]]

// row-label with diagram above text
#let rl-d(diagram, label) = align(center + top)[
  #diagram
  #v(0.05em)
  #text(weight: "bold", size: 6.5pt)[#label]
]

#let cs = (paint: rgb("#999"), thickness: 0.4pt)  // cell stroke
#let ci = (x: 3pt, y: 2.2pt)                      // cell inset

// ── TOP ROW: Tables 2 and 3 ────────────────────────────────────────────────
#grid(
  columns: (10.5cm, 1fr),
  column-gutter: 0.5em,

  // ── Table 2: Green/Brown Flowers (herbaceous) ──────────────────────────
  [
    #text(weight: "bold", size: 10pt, fill: green)[Table 2 · Green/Brown Flowers — herbs]
    #v(0.12em)
    #table(
      columns: (1.62cm, 1fr, 1fr),
      fill: (col, row) => if row == 0 { hdr-fill } else if col == 0 { row-fill } else if calc.rem(row, 2) == 0 { alt-fill } else { white },
      stroke: cs,
      inset: ci,

      align(center)[#text(weight: "bold", size: 7pt)[Flower\ arrangement]],
      align(center)[#text(weight: "bold", size: 7pt)[Broad leaves]],
      align(center)[#text(weight: "bold", size: 7pt)[Grass-like\ leaves]],

      rl-d(grid(columns: 2, gutter: 0.25em,
             inf_solitary(size: 0.65cm), inf_pair(size: 0.65cm)),
           [Single / pair]),
          // broad leaves
      fams(
        "(Araceae - monoecious spike)",
        "Plantaginaceae",
        "Caryophyllaceae",
        "Asparagaceae",
        "Amaryllidaceae",
        [Melanthiaceae (_Paris_)],
        "Euphorbiaceae"
      ),

      // grass like leaves
      fams(
        "Caryophyllaceae"
      ),

      rl-d(inf_axillary(size: 0.85cm), [Leaf axils]),
      fams(
        "Polygonaceae",
        [Amaranthaceae (incl. _Chenopodium_)],
        "Rosaceae",
        "Euphorbiaceae",
        "Urticaceae",
        "Caryophyllaceae",
        "Callitrichaceae",
        "Santalaceae",
        "Rubiaceae"
      ),
      fams("Caryophyllaceae", "Amaranthaceae"),

      rl-d(grid(columns: 2, gutter: 0.25em,
             inf_spike(size: 0.65cm), inf_raceme(size: 0.65cm)),
           [Spike / raceme]),
      fams(
        [Plantaginaceae (_Plantago_)],
        [Polygonaceae (_Rumex_)],
        "Amaranthaceae",
        "Resedaceae",
        "Euphorbiaceae",
        "Urticaceae",
        "Cannabaceae",
        "Curcubitaceae",
        "Potamogetonaceae",
        "Araceae",
        "Scheuchzeriaceae",
      ),
      fams(
        "Poaceae",
        "Cyperaceae",
        "Resedaceae",
        "Typhaceae",
        "Juncaginaceae",
        "Araceae",
        "Orchidaceae",
        "Acoraceae",
        "Potamogetonaceae",
        "Polygonaceae"
      ),

      rl-d(inf_umbel(size: 0.85cm), [Umbel]),
      fams(
        "Araliaceae",
        "Curcubitaceae",
        "Apiaceae"
      ),
      table.cell(fill: rgb("#d4d4d4"))[],

      rl-d(inf_cyme(size: 0.85cm), [Complex group]),
      fams(
        "Polygonaceae",
        "Amaranthaceae",
        "Euphorbiaceae",
        "Rosaceae",
        "Urticaceae",
        "Cannabaceae",
        "Saxifragaceae",
        "Gunneraceae",
        "Curcubitaceae",
        "Scrophulariaceae",
      ),
      fams("Poaceae", "Cyperaceae", "Juncaceae", "Amaranthaceae", "Polygonaceae"),

      rl-d(inf_tight_umbel(size: 0.85cm), [Tight head]),
      fams(
        "Plantaginaceae",
        "Euphorbiaceae",
        "Amaranthaceae",
        "Rosaceae",
        "Typhaceae",
        "Adoxaceae",
        "Cannabaceae",
        "Asteraceae",
        "Santalaceae"
      ),
      fams("Juncaceae", "Poaceae", "Cyperaceae", "Typhaceae"),
    )
  ],

  // ── Table 3: Trees and Shrubs ───────────────────────────────────────────
  [
    #text(weight: "bold", size: 10pt, fill: green)[Table 3 · Trees, Shrubs, Woody Climbers · Petal counts in brackets]
    #v(0.08em)
    #text(size: 8pt, style: "italic", fill: green)[a. Coloured (not green/brown) flowers — broken down by colour within radial symmetry]
    #v(0.07em)
    #table(
      columns: (1.58cm, 1fr, 1fr, 1fr, 1fr),
      fill: (col, row) => {
        if row == 0 {
          if col == 0 { tr-hdr }
          else if col == 1 { wh-hdr }
          else if col == 2 { ye-hdr }
          else if col == 3 { pk-hdr }
          else { bil-hdr }
        } else if col == 0 { tr-fill }
        else if col == 4 { bil-fill }
        else if calc.rem(row, 2) == 0 { rgb("#f2ede0") }
        else { white }
      },
      stroke: cs,
      inset: ci,

      align(center)[#text(weight: "bold", size: 7pt)[Flower\ shape]],
      align(center)[
        #flower_top(kind: "dicot", size: 0.9cm, petal-clr: rgb("#f2f2ee"))
        #text(weight: "bold", size: 7pt)[White /\ cream]
      ],
      align(center)[
        #flower_top(kind: "dicot", size: 0.9cm, petal-clr: rgb("#f5de30"))
        #text(weight: "bold", size: 7pt)[Yellow]
      ],
      align(center)[
        #flower_top(kind: "dicot", size: 0.9cm, petal-clr: rgb("#c558b0"))
        #text(weight: "bold", size: 7pt)[Pink /\ purple]
      ],
      align(center)[
        #flower_top(kind: "bilabiate", size: 0.9cm)
        #text(fill: dark-red, weight: "bold", size: 7pt)[Bilateral]
      ],

      rl-d(flower_top(kind: "dicot", size: 0.8cm), [Petals free]),
      // white
      fams(
        "Rosaceae (5)",
        "Cornaceae (4)",
        "Aquifoliaceae (4)",
        text(fill: red)[Hydrangaceae (4-5)],
        text(fill: red)[Tamaricaceae (5)],
        text(fill: red)[Passifloraceae (5; corona of many infertile stamens)],
        text(fill: red)[Rutaceae (5; _Choisya_)]
      ),
      // yellow
      fams(
        "Hypericaceae (5)",
        "Cornaceae (4)",
        "Berberidaceae (many)",
        [Grossulariaceae (5; _Ribes odoratum_)],
        [Rosaceae (5; _Kerria_)],
        [Sapindaceae (4; _Koelreuteria_)],
        text(fill: red)[Rutaceae (4-5; _Ruta_)]
      ),
      // pink/purple
      fams(
        [Onagraceae (4; _Fuchsia_)],
        [Grossulariaceae (5; _Ribes sanguineum_)],
        "Rosaceae (5; Spiraea)",
        "Ericaceae (3; Empetrum)",
        text(fill: red)[Tamaricaceae (5)],
        [Thymeleaceae (4; _Daphne_, actually sepals)],
        text(fill: red)[Pittosporaceae (5)]
      ),
      // bilateral
      fams(
        "Fabaceae (5)",
        [Sapindaceae (4-5; _Aesculus_)],
      ),

      rl-d(flower_top(kind: "joined", size: 0.8cm), [Petals joined]),
      // white
      fams(
        "Caprifoliaceae (5)",
        "Rhamnaceae (5)",
        "Oleaceae (4-6)",
        "Viburnaceae (5)",
        "Sambucaceae (5)", 
        "Ericaceae (4-5)",
        "Diapensiaceae (5)",
        text(fill: red)[Myrtaceae (4-5)],
        text(fill: red)[Simaroubaceae (5; _Ailanthus_)]
      ),
      // yellow
      fams(
        [Oleaceae (4-6; _Jasminum_, _Forsythia_)]
      ),
      // pink
      fams(
        "Scrophulariaceae (4)",
        "Ericaceae (4-5)",
        "Solanaceae (5)",
        "Oleaceae (4-6)",
        text(fill: red)[Garryaceae (4)],
        text(fill: red)[Escalloniaceae (5)],
        text(fill: red)[Rutaceae (4; _Correa_)]
      ),
      // bilateral
      fams(
        "Caprifoliaceae (5)",
        "Ericaceae (5)",
        text(fill: red)[Paulowniaceae (5)],
      ),
    )

    #v(0.22em)
    #text(size: 8pt, style: "italic", fill: green)[b. Green/brown flowers]
    #v(0.07em)
    #table(
      columns: (1fr, 1fr, 1fr),
      fill: (col, row) => if row == 0 { tr-hdr } else { rgb("#f2ede0") },
      stroke: cs,
      inset: ci,

      align(center)[
        #inf_catkin(size: 1.05cm)
        #v(0.05em)
        #text(weight: "bold", size: 7pt)[Catkins]
      ],
      align(center)[
        #flower_top(kind: "dicot", size: 0.8cm, petal-clr: rgb("#8ab858"))
        #v(0.05em)
        #text(weight: "bold", size: 7pt)[Flower-shaped (greenish)]
      ],
      align(center)[
        #text(weight: "bold", size: 7pt)[Other]
      ],

      fams(
        "Salicaceae",
        "Betulaceae",
        "Fagaceae",
        "Myricaceae",
        "Juglandaceae"
      ),
      fams(
        "Sapindaceae",
        "Malvaceae",
        "Celastraceae",
        "Rhamnaceae",
        "Thymeleaceae",
        "Grossulariaceae",
        "Amaranthaceae",
        text(fill: red)[Anacardiaceae (dense (_Rhus_) or diffuse (_Cotinus_))],
        text(fill: red)[Griseliniaceae]
      ),
      fams(
        "Ulmaceae (small axillary clusters)",
        text(fill: red)[Vitaceae (woody climber, leaf opposed infls)],
        text(fill: red)[Platanaceae (globose pendant heads)],
        "Oleaceae (axillary clusters)",
        "Eleagnaceae (axillary clusters)",
        "Buxaceae (monoecious clusters)",
        text(fill: red)[Moraceae (very odd fls; _Ficus_ or _Morus_)],
        text(fill: red)[Nothofagaceae],
        text(fill: red)[Myrtaceae (_Eucalyptus_)]
      ),
    )
  ],
)

#v(0.35em)

// ── BOTTOM ROW: Tables 4 and 5 ────────────────────────────────────────────
#grid(
  columns: (1fr, 8.5cm),
  column-gutter: 0.5em,

  // ── Table 4: Fully Aquatic Plants ──────────────────────────────────────
  [
    #text(weight: "bold", size: 10pt, fill: green)[Table 4 · Fully Aquatic Plants]
    #v(0.1em)
    #table(
      columns: (1fr, 1fr, 1fr, 1.2fr),
      fill: (col, row) => if row <= 1 { aq-hdr } else { aq-fill },
      stroke: cs,
      inset: ci,

      table.cell(colspan: 3, align: center)[
        #text(weight: "bold", size: 7pt)[Tiny flowers (\<2 mm)]
      ],
      align(center)[#text(weight: "bold", size: 7pt)[Conspicuous /\ white flowers]],

      align(center)[#text(size: 6.5pt, style: "italic")[Leaves all\ at stem base]],
      align(center)[#text(size: 6.5pt, style: "italic")[Leaves all\ along stem]],
      align(center)[#text(size: 6.5pt, style: "italic")[Tiny floating\ plant]],
      table.cell(rowspan: 2, fill: aq-fill, align: left + top)[
      // TODO: arrange so these have some sort of extra floral division
        #fams(
          "Nymphaeaceae",
          "Menyanthaceae",
          "Polygonaceae",
          "Hydrocharitaceae",
          "Alismataceae",
          "Campanulaceae",
          "Lentibulariaceae",
          "Ranunculaceae",
          [Primulaceae (_Samolus_)],
          "Butomaceae",
          "Aponogetonaceae"
        )
      ],

      fams(
        "Zosteraceae",
        "Plantaginaceae",
        "Callitrichaceae",
        "Brassicaceae",
        "Eriocaulaceae"
      ),
      fams(
        "Callitrichaceae",
        "Potamogetonaceae",
        "Haloragaceae (whorled; finely pinnate)",
        "Hippuridaceae",
        "Hydrocharitaceae",
        "Typhaceae",
        "Ceratophyllaceae (whorled; bifid)",
        "Elatinaceae",
        "Cyperaceae",
        "Zannichellaceae",
        "Ruppiaceae",
      ),
      fams(
        "Araceae (Lemnoideae)",
      ),
    )
  ],

  // ── Table 5: Without Chlorophyll ───────────────────────────────────────
  [
    #text(weight: "bold", size: 10pt, fill: green)[Table 5 · Without Chlorophyll]
    #v(0.1em)
    #table(
      columns: (2cm, 1fr),
      fill: (col, row) => if row == 0 { noc-hdr } else if col == 0 { noc-fill } else if calc.rem(row, 2) == 0 { rgb("#eeeaf5") } else { white },
      stroke: cs,
      inset: ci,

      align(center)[#text(weight: "bold", size: 7pt)[Mode]],
      align(center)[#text(weight: "bold", size: 7pt)[Families / notes]],

      rl([Root parasite]),
      fams(
        [Orobanchaceae (_Orobanche_, _Lathraea_)],
      ),

      rl([Stem parasite]),
      fams(
        [Convolvulaceae (_Cuscuta_)]
      ),

      rl([Mycoheterotrophic]),
      fams(
        [Ericaceae (_Hypopitys_)],
        [Orchidaceae (_Neottia nidus-avis_)]
      ),
    )
  ],
)

#v(0.3em)
#line(length: 100%, stroke: (paint: rgb("#aaa"), thickness: 0.4pt))
#v(0.15em)
#[
#set text(size: 7pt)
#set par(leading: 0.3em)
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 0.6em,
  [
    #text(weight: "bold", fill: green)[Notes]
    - Families arranged in order of occurrence (column-wise)
    - Family names follow Stace (2019).
    - There may be taxonomic changes from the texts you use.
      - e.g. Liliaceae s.l. split & Scrophulariaceae s.l. split.
  ],
  [
    #text(weight: "bold", fill: red)[Aliens]
    - Wholly alien families are marked in red.
      - Either archaeophyte/neophyte.
  ],
  [
    #text(weight: "bold", fill: green)[Work In Progress!]
      - If you find mistakes, email me at max.carter-brown\@aru.ac.uk
  ],
)
#v(0.4em)
#text(weight: "bold", fill: green)[Key references] #h(1em)
Stace (2019) _New Flora of the British Isles_, 4th ed. · Poland & Clement (2020) _Vegetative Key to the British Flora_ · Rose & O'Reilly (2006) _The Wildflower Key_
]

#import "@preview/touying:0.7.1": *

#import themes.simple: *
#show: simple-theme.with(aspect-ratio: "16-9")
#set text(size: 20pt)

#let fam-layout(title, species-count, img, facts) = grid(
  columns: (1fr, 1fr),
  rows: (auto, 1fr),
  gutter: 0.6em,
  grid.cell(colspan: 2,
    text(size: 1.2em, weight: "bold", fill: rgb("#4f6b3c"))[#title — #species-count spp. in Britain]
  ),
  image(img, width: 90%),
  facts,
)

#title-slide[
  = Botany short course 2026
  #block(text(size: 1.5em, fill: rgb("#4f6b3c"), weight: "bold")[Introduction to British Botany])

  Max Carter-Brown

  Anglia Ruskin University
]

== Overview

- Britain has a rich but geologically young flora — largely reassembled after the last glaciation (~10,000 BP)
#pause
- Compared to continental Europe, diversity is *lower* — island geography limited post-glacial recolonisation
#pause
- Yet the flora punches above its weight: wide range of habitats, strong Atlantic influence, and centuries of botanical recording
#pause
- This lecture: how many plants, where they come from, the families they belong to, and how to find out more


== How many species?

- Britain and Ireland have approximately *1,700 native vascular plant species*
- Including all vascular plants (native + naturalised + common aliens): ~*3500+ taxa* recorded (Stace, 4th ed.)
- Non-vascular plants add substantially more (thousands...)
#pause
- Flowering plants (angiosperms): ~1,600 native spp.
- Ferns & allies (pteridophytes): ~80 native spp.
- Conifers (gymnosperms): 3 native spp. (_Pinus sylvestris_, _Juniperus communis_, _Taxus baccata_)


== Native, archaeophyte, or neophyte?

- *Native* — present before human influence; arrived naturally after the last glaciation
- *Archaeophyte* — introduced by humans *before* 1500 CE (often arable weeds arriving with agriculture)
- Examples: _Papaver rhoeas_ (common poppy), _Centaurea cyanus_ (cornflower)
- *Neophyte* — introduced *after* 1500 CE (post-Columbian exchange, horticulture, trade)
- Examples: _Fallopia japonica_ (Japanese knotweed), _Rhododendron ponticum_, _Impatiens glandulifera_
- *Casual alien* — appears but does not persist without repeated introduction


== Alien and invasive species

- Invasion biology distinguishes *naturalised* (self-sustaining) from *invasive* (spreading, causing harm)
- Key invasive species in Britain:
- _Fallopia japonica_ — Japanese knotweed; dense monoculture, structural damage
- _Impatiens glandulifera_ — Himalayan balsam; riverbanks, shades out natives
- _Rhododendron ponticum_ — woodland understorey, toxic to stock
- _Crassula helmsii_ — New Zealand pygmyweed; aquatic habitats

== How do the aliens get here?
- Pathways: horticulture, agriculture, forestry, ballast water, contaminated soil, bird seed
- GB Non-Native Species Secretariat (GBNNSS) maintains the risk register


== Diversity: major families

#table(
  columns: (1fr, auto, 1fr),
  stroke: none,
  align: (left, center, left),
  [Asteraceae (~230 spp.) \ Rosaceae (~130 spp.) \ Brassicaceae (~110 spp.) \ Cyperaceae (~120 spp.)],
  [],
  [Poaceae (~170 spp.) \ Fabaceae (~80 spp.) \ Lamiaceae (~70 spp.) \ Apiaceae (~70 spp.) \ Ranunculaceae (~65 spp.) \ Caryophyllaceae (~60 spp.) \ Orchidaceae (~52 spp.)],
)

#block(
  fill: rgb("#e8f0e0"),
  stroke: (paint: rgb("#4f6b3c"), thickness: 1.5pt),
  inset: 12pt,
  radius: 6pt,
  width: 100%,
  align(center, text(size: 1.1em)[Although >3000 species including aliens, only \~180 *families*!])
)

---

#fam-layout("Asteraceae — daisy family", "~230", "resources/sea-aster-tripolium-pannonicum-600x600-crop-48-3-36-5.webp", [
  - Composite flowerhead (capitulum) made of many tiny florets
  - Ray florets (strap-shaped) surround disc florets (tubular)
  - Example: _Tripolium pannonicum_ (sea aster) — saltmarsh specialist
  - Key genera: _Senecio_, _Cirsium_, _Centaurea_, _Taraxacum_, _Hieracium_
])

---

#fam-layout("Rosaceae — rose family", "~130", "resources/dog-rose-rosa-canina-600x600-crop.webp", [
  - 5 petals, many stamens, inferior or superior ovary depending on genus
  - Includes trees, shrubs, and herbs — enormous ecological breadth
  - Example: _Rosa canina_ (dog rose) — hedgerow classic; hips rich in vitamin C
  - Key genera: _Rosa_, _Rubus_, _Prunus_, _Sorbus_, _Potentilla_, _Agrimonia_
])

---

#fam-layout("Brassicaceae — cabbage family", "~110", "resources/sea-rocket-cakile-maritima-4-600x600-crop.webp", [
  - Diagnostic: 4 petals in a cross, 6 stamens (4 long + 2 short), silique fruit
  - Many archaeophyte arable weeds; also coastal and upland specialists
  - Example: _Cakile maritima_ (sea rocket) — strandline pioneer
  - Key genera: _Cardamine_, _Arabidopsis_, _Rorippa_, _Draba_, _Raphanus_
])

---

#fam-layout("Fabaceae — pea family", "~80", "resources/bitter-vetch-lathyrus-linifolius-var-montanus-2-600x600-crop-30-6-57-1.webp", [
  - Zygomorphic flowers; fruit a legume (pod)
  - Root nodules with nitrogen-fixing _Rhizobium_ bacteria
  - Example: _Lathyrus linifolius_ (bitter-vetch) — upland grassland and heath
  - Key genera: _Trifolium_, _Vicia_, _Lathyrus_, _Lotus_, _Ulex_, _Genista_
])

---

#fam-layout("Lamiaceae — mint family", "~70", "resources/red-deadnettle-lamium-purpureum-600x600-crop-53-4-46-7.webp", [
  - Square stems, opposite leaves, bilabiate (2-lipped) flowers
  - Many aromatic — volatile oils in glands on leaves
  - Example: _Lamium purpureum_ (red deadnettle) — common weed of disturbed ground
  - Key genera: _Lamium_, _Stachys_, _Prunella_, _Mentha_, _Thymus_, _Ajuga_
])

---

#fam-layout("Apiaceae — carrot family", "~70", "resources/rough-chervil-chaerophyllum-temulum-2-600x600-crop-40-8-19-2.webp", [
  - Compound umbels; small 5-petalled flowers; often hollow stems
  - Aromatic; many edible genera but also deadly (_Conium_, _Oenanthe_)
  - Example: _Chaerophyllum temulentum_ (rough chervil) — hedgerow annual
  - Key genera: _Anthriscus_, _Conium_, _Heracleum_, _Daucus_, _Oenanthe_
])

---

#fam-layout("Ranunculaceae — buttercup family", "~65", "resources/ranunculus-lingua-600x600-crop-57-6-47-7.webp", [
  - Mostly actinomorphic; many free stamens and carpels (primitive traits)
  - Aquatic and wetland specialists in genus _Ranunculus_
  - Example: _Ranunculus lingua_ (greater spearwort) — tall fen species
  - Key genera: _Ranunculus_, _Caltha_, _Aquilegia_, _Clematis_, _Anemone_
])

---

#fam-layout("Caryophyllaceae — pink family", "~60", "resources/sticky-catchfly-silene-viscaria-600x600-crop-50-1-28-1.webp", [
  - Opposite, entire leaves; swollen nodes; 5 petals often notched
  - Calyx often tubular and prominently veined
  - Example: _Silene viscaria_ (sticky catchfly) — dry rocky grassland, local in Britain
  - Key genera: _Silene_, _Cerastium_, _Stellaria_, _Arenaria_, _Dianthus_
])

---

#fam-layout("Orchidaceae — orchid family", "~52", "resources/early-purple-orchid-orchis-mascula-4-600x600-crop-50-6-33-8.webp", [
  - Highly zygomorphic; labellum (lip) often elaborate
  - Mycorrhizal dependency — seeds lack endosperm, require fungal germination
  - Example: _Orchis mascula_ (early-purple orchid) — ancient woodland indicator
  - Key genera: _Dactylorhiza_, _Ophrys_, _Gymnadenia_, _Epipactis_, _Neottia_
])

== Biogeographic elements

- British flora classified into *phytogeographic elements* (Preston & Hill 1997)
- Key elements relevant to our flora:
  - *Oceanic* — concentrated in W Britain; require mild, humid winters (_Hymenophyllum_, _Euphorbia hyberna_)
  - *Continental* — SE Britain; drought-tolerant, warm summers (_Medicago minima_, arable weeds)
  - *Arctic-alpine* — upland Scotland and Wales; cold-adapted relicts (_Dryas octopetala_, _Saxifraga oppositifolia_)
  - *Mediterranean* — S England coasts; near range edge (_Cistus_, _Orobanche_ spp.)
- Climate change already shifting range margins northward and upward


== Recording and mapping

- Britain has one of the world's best-documented floras — recording since the 16th century
- *Botanical Society of Britain and Ireland (BSBI)* — coordinates recording; Atlas 2020 is the current distribution atlas
- *NBN Atlas* — national biodiversity network; open data portal for occurrence records
- *iNaturalist / iRecord* — citizen science; useful but verify IDs before trusting
- Recording unit: the *hectad* (10 × 10 km OS grid square); ~2,900 hectads in Britain & Ireland
- Species distribution maps on BSBI.org by hectad


== Key resources: field guides and floras

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    *Floras (identification keys)*
    - *Stace, C.A.* — _New Flora of the British Isles_, 4th ed. (2019). The standard reference; comprehensive dichotomous keys.
    - *Poland, J. & Clement, E.* — _The Vegetative Key to the British Flora_ (2020). Identify by vegetative characters alone — invaluable when flowers are absent.
    - *Rose, F. & O'Reilly, C.* — _The Wildflower Key_, revised ed. (2006). Accessible beginner flora; illustrated dichotomous keys.
  ],
  [
    *Field guides (visual)*
    - *Blamey, M., Fitter, R. & Fitter, A.* — _Collins Wildflower Guide_ (2013). Excellent illustrations; covers ~1,400 spp.
    - *Streeter, D. et al.* — _Collins Wildflower Field Guide_ (2016). Photographic; very portable.
  ],
)


== Choosing the right book

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#aaa"), thickness: 0.5pt),
  fill: (col, row) => if row == 0 { rgb("#c8dab8") } else if calc.rem(row, 2) == 0 { rgb("#f2f7ee") } else { white },
  [*Situation*], [*Best choice*], [*Why*],
  [No flower present], [Poland & Clement], [Keys vegetative characters],
  [Beginner, flower present], [Rose], [Simple keys, clear illustrations],
  [Comprehensive determination], [Stace], [Full keys, all taxa],
  [Quick visual check], [Collins Wildflower Guide], [Fast to scan illustrations],
  [Data / distribution], [BSBI Atlas 2020 / NBN], [Maps and occurrence data],
)


== Aims of the course

- Have fun!
- Learn more about plants, get stuck in the detail, or beauty
- Learn plant *families*
- Go further if you can, but not a priority

# Botany Short Course 2026

**Anglia Ruskin University — Max Carter-Brown**

A 6-week introductory botany course combining classroom sessions, fieldwork, and herbarium work.

---

## Schedule

| Week | Format | Topic |
|------|--------|-------|
| 1 | Classroom | Introduction to botany — vegetative morphology (leaves) and reproductive morphology (flowers) |
| 2 | Classroom | Plant identification using the Richard Milnes method ([Plant ID for Beginners](https://milneorchid.weebly.com/plant-id-for-beginners.html)) |
| 3 | Field | The Flora of Mill Road Cemetery |
| 4–5 | Field | Vegetation surveys at other sites |
| 6 | Indoor | Introduction to the herbarium |

---

## Repository contents

### Slide decks (`./lectures/main_*.typ`)

| File | Description |
|------|-------------|
| `main_leaves.typ` | Week 1 — leaf morphology |
| `main_flowers.typ` | Week 1 — flower morphology and symmetry |
| `main_inflorescences.typ` | Week 1 — inflorescence types |

The PDF's are also in this same directory.

### Library (`lib/`)

A small typst library which creates various diagrams of leaves, flowers, and infloresences.

| File | Description |
|------|-------------|
| `lib/leafs.typ` | Leaf diagrams, hair types, axil illustration, Oxalis compound leaf |
| `lib/flowers.typ` | Flower diagrams: dicot, monocot, bilabiate top views; longitudinal sections |
| `lib/inflorescences.typ` | Schematic inflorescence diagrams: solitary, raceme, spike, umbel, compound umbel, capitulum, axillary, cyme |

Slides are written in [Typst](https://typst.app/) using the [Touying](https://github.com/touying-typ/touying) presentation framework and [CeTZ](https://github.com/cetz-package/cetz) for vector diagrams.

### Building

```bash
./build.sh          # compile all lectures to lectures/*.pdf
./build.sh --watch  # recompile on save (one watcher per file)
```

Requires Typst ≥ 0.13 with packages `@preview/touying:0.7.1` and `@preview/cetz:0.3.4`.

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

| File | Description |
|------|-------------|
| `main_leaves.typ` | Week 1 slide deck — leaf morphology |
| `main_flowers.typ` | Week 1 slide deck — flower morphology |
| `leafs.typ` | Typst/CeTZ library: leaf diagrams, hair types, axil illustration, Oxalis |
| `flowers.typ` | Typst/CeTZ library: flower diagrams (dicot, monocot, bilabiate top views; longitudinal sections) |

Slides are written in [Typst](https://typst.app/) using the [Touying](https://github.com/touying-typ/touying) presentation framework and [CeTZ](https://github.com/cetz-package/cetz) for vector diagrams.

### Building

```
typst compile main_leaves.typ
typst compile main_flowers.typ
```

Requires Typst ≥ 0.13 with packages `@preview/touying:0.7.1` and `@preview/cetz:0.3.4`.

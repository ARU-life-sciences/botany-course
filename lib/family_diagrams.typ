#import "@preview/cetz:0.3.4": canvas, draw
#import "flowers.typ": (
  sepal-fill, sepal-stroke, gyn-fill, gyn-stroke,
  anther-fill, anther-stroke, filament-stroke, floral-axis-stroke,
  _gstroke, _astroke,
  _transform_points, _draw_closed_catmull,
  _petal_outline, _sepal_outline,
  _draw_radial_organ, _draw_radial_stamen,
  _draw_stamen_side, _side_petal, _side_sepal,
)

#let hypan-fill   = rgb("#c8d8a8")
#let hypan-stroke = rgb("#6a8a4a")
#let p-petal-fill   = rgb("#faf5f5")
#let p-petal-stroke = rgb("#c89898")
#let stigma-fill = rgb("#7b3f98")
#let stigma-stroke = rgb("#5d2e73")

// ── Helpers ───────────────────────────────────────────────────────────────────

#let _scale_bar(x, y, width, label) = {
  draw.line((x, y), (x + width, y), stroke: (paint: black, thickness: 0.5pt))
  draw.line((x, y - 0.05), (x, y + 0.05), stroke: (paint: black, thickness: 0.5pt))
  draw.line((x + width, y - 0.05), (x + width, y + 0.05), stroke: (paint: black, thickness: 0.5pt))
  draw.content((x + width / 2, y - 0.22), text(size: 5.5pt)[#label], anchor: "north")
}

// Plumose stigma arm from (x0,y0) to (x1,y1)
#let _feathery_stigma(x0, y0, x1, y1, n: 10, branch-len: 0.25) = {
  draw.line((x0, y0), (x1, y1), stroke: (paint: stigma-stroke, thickness: 0.7pt))
  let dx = x1 - x0
  let dy = y1 - y0
  let len = calc.sqrt(dx * dx + dy * dy)
  if len > 0.001 {
    let px = (-dy / len) * branch-len
    let py = ( dx / len) * branch-len
    for i in range(n) {
      let t = (i + 0.5) / n
      let bx = x0 + t * dx
      let by = y0 + t * dy
      draw.line(
        (bx - px, by - py), (bx + px, by + py),
        stroke: (paint: stigma-stroke, thickness: 0.42pt),
      )
    }
  }
}

// ── Prunus padus — top view ───────────────────────────────────────────────────
// Real flower ≈ 15 mm diam. canvas(length: size/9).
// 1 unit ≈ size/9. Scale bar 2 u shown as "3 mm" (approx ×3 magnification).

#let prunus_top(size: 5cm) = canvas(length: size / 9, {
  import draw: *

  circle((0, 0), radius: 4.3, fill: rgb("#e8f5e0"), stroke: none)

  // 5 sepals (alternating, offset 36° from petals)
  for i in range(5) {
    _draw_radial_organ(_sepal_outline(), radius: 1.2, angle: 54deg + i * 72deg,
      fill: sepal-fill, stroke: (paint: sepal-stroke, thickness: 0.6pt), scale: 0.82)
  }

  // 5 petals
  for i in range(5) {
    _draw_radial_organ(_petal_outline(), radius: 1.6, angle: 90deg + i * 72deg,
      fill: p-petal-fill, stroke: (paint: p-petal-stroke, thickness: 0.7pt), scale: 1.05)
  }

  // Hypanthium rim (perigynous disk visible as ring)
  circle((0, 0), radius: 1.68,
    fill: hypan-fill, stroke: (paint: hypan-stroke, thickness: 0.6pt))
  circle((0, 0), radius: 0.95, fill: rgb("#dff0d0"), stroke: none)

  // 25 stamens arising from hypanthium rim
  for i in range(25) {
    _draw_radial_stamen(radius: 0.98, angle: i * (360deg / 25),
      len: 0.82, anther-scale: 0.48)
  }

  // G1 — single carpel
  circle((0, 0), radius: 0.50, fill: gyn-fill, stroke: _gstroke())
  circle((0, 0.10), radius: 0.17, fill: gyn-fill.darken(18%), stroke: none)

  _scale_bar(-3.2, -4.6, 2.0, "3 mm")
})

// ── Prunus padus — perigynous section ────────────────────────────────────────
// Cup-shaped hypanthium; ovary superior (free inside cup, not fused to walls).

#let prunus_section(size: 5cm) = canvas(length: size / 10, {
  import draw: *

  // Pedicel
  line((0, -3.8), (0, -2.2), stroke: (paint: floral-axis-stroke, thickness: 1.2pt))

  // Hypanthium cup tissue (closed section shape)
  catmull(
    (-1.45, 3.4), (-1.75, 2.2), (-1.95, 0.8), (-1.65, -0.5),
    (-1.0, -1.5), (-0.38, -2.1), (0, -2.2),
    (0.38, -2.1), (1.0, -1.5), (1.65, -0.5),
    (1.95, 0.8), (1.75, 2.2), (1.45, 3.4),
    (1.02, 3.62),
    (0.70, 2.8), (0.52, 1.6), (0.42, 0.45),
    (0, 0.28),
    (-0.42, 0.45), (-0.52, 1.6), (-0.70, 2.8),
    (-1.02, 3.62),
    close: true,
    fill: hypan-fill, stroke: (paint: hypan-stroke, thickness: 0.65pt),
  )

  // Ovary — superior: sitting free inside cup (not fused to walls)
  catmull(
    (0, 0.28),
    (0.46, 0.44), (0.62, 1.05), (0.50, 1.92),
    (0, 2.22),
    (-0.50, 1.92), (-0.62, 1.05), (-0.46, 0.44),
    close: true, fill: gyn-fill, stroke: _gstroke(),
  )
  // Ovule
  circle((0, 1.0), radius: 0.12, fill: rgb("#fff6dd"), stroke: _gstroke(w: 0.35pt))

  // Style (long, emerges through cup opening above)
  line((0, 2.22), (0, 4.5), stroke: _gstroke(w: 0.85pt))
  circle((0, 4.65), radius: 0.15, fill: gyn-fill, stroke: _gstroke(w: 0.5pt))

  // Stamens (perigynous — from inner cup rim, ascending)
  _draw_stamen_side(x: -0.52, base-y: 3.42, h: 2.1, bend: -0.10)
  _draw_stamen_side(x: -1.00, base-y: 3.22, h: 2.3, bend: -0.20)
  _draw_stamen_side(x:  0.52, base-y: 3.42, h: 2.1, bend:  0.10)
  _draw_stamen_side(x:  1.00, base-y: 3.22, h: 2.3, bend:  0.20)

  // Petals at cup rim
  group({
    translate((-0.80, 3.30)); rotate(20deg)
    _side_petal(fill: p-petal-fill, stroke: (paint: p-petal-stroke, thickness: 0.7pt))
  })
  group({
    translate((0.80, 3.30)); rotate(-20deg)
    _side_petal(fill: p-petal-fill, stroke: (paint: p-petal-stroke, thickness: 0.7pt))
  })

  // Sepals spreading from outer rim
  group({ translate((-1.45, 3.10)); rotate(52deg); _side_sepal() })
  group({ translate(( 1.45, 3.10)); rotate(-52deg); _side_sepal() })

  _scale_bar(-1.2, -4.5, 2.0, "3 mm")
})

// ── Poterium sanguisorba — carpellate flower top view ─────────────────────────
// Tiny flower ≈ 2–3 mm. canvas(length: size/8). Bar 3 u ≈ "1 mm".

#let poterium_carpellate_top(size: 3.5cm) = canvas(length: size / 8, {
  import draw: *

  circle((0, 0), radius: 3.5, fill: rgb("#e8f5e0"), stroke: none)

  // Hypanthium mouth visible as thick ring
  circle((0, 0), radius: 2.8,
    fill: hypan-fill, stroke: (paint: hypan-stroke, thickness: 0.7pt))
  circle((0, 0), radius: 1.85, fill: rgb("#dff0d0"), stroke: none)

  // 4 sepal lobes (short, K4)
  for a in (90deg, 0deg, 270deg, 180deg) {
    _draw_radial_organ(_sepal_outline(), radius: 0.35, angle: a,
      fill: sepal-fill,
      stroke: (paint: sepal-stroke, thickness: 0.85pt),
      scale: 1.55)
  }

  // 2 feathery (plumose) stigmas
  _feathery_stigma(-0.20, 0.10, -0.85, 1.90, n: 9, branch-len: 0.30)
  _feathery_stigma( 0.20, 0.10,  0.85, 1.90, n: 9, branch-len: 0.30)

  _scale_bar(-1.5, -4.3, 3.0, "1 mm")
})

// ── Poterium sanguisorba — staminate flower top view ─────────────────────────

#let poterium_staminate_top(size: 3.5cm) = canvas(length: size / 8, {
  import draw: *

  circle((0, 0), radius: 3.5, fill: rgb("#e8f5e0"), stroke: none)

  // Hypanthium mouth ring
  circle((0, 0), radius: 2.8,
    fill: hypan-fill, stroke: (paint: hypan-stroke, thickness: 0.7pt))
  circle((0, 0), radius: 1.6, fill: rgb("#dff0d0"), stroke: none)

  // 4 sepal lobes
  for a in (90deg, 0deg, 270deg, 180deg) {
    _draw_radial_organ(_sepal_outline(), radius: 0.35, angle: a,
      fill: sepal-fill,
      stroke: (paint: sepal-stroke, thickness: 0.85pt),
      scale: 1.55)
  }

  // ~20 pendant stamens (appearing spread radially in top view)
  for i in range(20) {
    _draw_radial_stamen(radius: 0.55, angle: i * (360deg / 20),
      len: 1.05, anther-scale: 0.52)
  }

  _scale_bar(-1.5, -4.3, 3.0, "1 mm")
})

// ── Poterium sanguisorba — section (carpellate) ───────────────────────────────
// Urn-shaped hypanthium; G2 inferior (carpel walls fused to hypanthium wall).

#let poterium_section(size: 4cm) = canvas(length: size / 9, {
  import draw: *

  // Pedicel
  line((0, -3.6), (0, -2.4), stroke: (paint: floral-axis-stroke, thickness: 1.0pt))

  // Urn-shaped hypanthium outer wall (closed section)
  catmull(
    (-0.52, 4.05), (-0.82, 3.2), (-1.38, 2.0),
    (-1.48, 1.0), (-1.18, 0.0), (-0.48, -1.1),
    (0, -2.4),
    (0.48, -1.1), (1.18, 0.0), (1.48, 1.0),
    (1.38, 2.0), (0.82, 3.2), (0.52, 4.05),
    (0.32, 4.18),
    (0.32, 3.2), (0.58, 2.0), (0.58, 0.75),
    (0, 0.48),
    (-0.58, 0.75), (-0.58, 2.0), (-0.32, 3.2),
    (-0.32, 4.18),
    close: true,
    fill: hypan-fill, stroke: (paint: hypan-stroke, thickness: 0.65pt),
  )

  // Ovary interior (inferior — fused; 2 locules)
  catmull(
    (0, 0.48), (0.52, 0.65), (0.52, 2.2), (0, 2.42),
    (-0.52, 2.2), (-0.52, 0.65),
    close: true, fill: gyn-fill, stroke: _gstroke(w: 0.4pt),
  )
  // Locule divider
  line((0, 0.48), (0, 2.42), stroke: _gstroke(w: 0.45pt))
  // Ovules
  circle(( 0.27, 1.3), radius: 0.11, fill: rgb("#fff6dd"), stroke: _gstroke(w: 0.3pt))
  circle((-0.27, 1.3), radius: 0.11, fill: rgb("#fff6dd"), stroke: _gstroke(w: 0.3pt))

  // Sepal lobes at mouth
  group({ translate((-0.52, 3.95)); rotate(38deg); _side_sepal() })
  group({ translate(( 0.52, 3.95)); rotate(-38deg); _side_sepal() })

  // 2 feathery stigmas protruding through mouth
  _feathery_stigma(-0.10, 2.42, -0.62, 5.10, n: 11, branch-len: 0.20)
  _feathery_stigma( 0.10, 2.42,  0.62, 5.10, n: 11, branch-len: 0.20)

  _scale_bar(-1.4, -4.1, 3.0, "1 mm")
})

#import "@preview/cetz:0.3.4": canvas, draw

// =========================
// Flower cartoons for CeTZ
// Idealised monocot / dicot
// top view + longitudinal section
// =========================

// Colours
#let petal-fill = rgb("#f4d6e8")
#let petal-stroke = rgb("#a35b86")
#let tepal-fill = rgb("#f7e6b8")
#let tepal-stroke = rgb("#a6802d")
#let sepal-fill = rgb("#cfe7b8")
#let sepal-stroke = rgb("#5d8a47")
#let gyn-fill = rgb("#d8efc1")
#let gyn-stroke = rgb("#5f8c48")
#let anther-fill = rgb("#e3b44b")
#let anther-stroke = rgb("#8a6420")
#let filament-stroke = rgb("#6a6a6a")
#let floral-axis-stroke = rgb("#6e563f")

#let _fstroke(w: 0.9pt, paint: petal-stroke) = (paint: paint, thickness: w)
#let _gstroke(w: 0.9pt, paint: gyn-stroke) = (paint: paint, thickness: w)
#let _astroke(w: 0.6pt, paint: filament-stroke) = (paint: paint, thickness: w)

// --- geometry helpers ---

#let _rotate_point(p, angle: 0deg) = {
  let ca = calc.cos(angle)
  let sa = calc.sin(angle)
  (
    p.at(0) * ca - p.at(1) * sa,
    p.at(0) * sa + p.at(1) * ca,
  )
}

#let _transform_points(points, x: 0, y: 0, sx: 1, sy: 1, angle: 0deg) = {
  let out = ()
  for p in points {
    let q = (p.at(0) * sx, p.at(1) * sy)
    let r = _rotate_point(q, angle: angle)
    out.push((x + r.at(0), y + r.at(1)))
  }
  out
}

// closed smooth organ from local coordinates
#let _draw_closed_catmull(points, fill: petal-fill, stroke: _fstroke()) = {
  draw.catmull(..points, close: true, fill: fill, stroke: stroke)
}

// simple petal / tepal outline in local coordinates, base at (0,0), apex upward
#let _petal_outline() = (
  (0, 0),
  (0.55, 0.28),
  (1.0, 1.2),
  (0.82, 2.25),
  (0.0, 3.1),
  (-0.82, 2.25),
  (-1.0, 1.2),
  (-0.55, 0.28),
)

#let _narrow_tepal_outline() = (
  (0, 0),
  (0.38, 0.2),
  (0.72, 1.0),
  (0.62, 2.25),
  (0.0, 3.25),
  (-0.62, 2.25),
  (-0.72, 1.0),
  (-0.38, 0.2),
)

#let _sepal_outline() = (
  (0, 0),
  (0.42, 0.18),
  (0.75, 0.9),
  (0.62, 1.8),
  (0.0, 2.45),
  (-0.62, 1.8),
  (-0.75, 0.9),
  (-0.42, 0.18),
)

// radial organ
#let _draw_radial_organ(
  outline,
  radius: 2.0,
  angle: 0deg,
  fill: petal-fill,
  stroke: _fstroke(),
  scale: 1.0,
) = {
  let pts = _transform_points(
    outline,
    x: radius * calc.cos(angle),
    y: radius * calc.sin(angle),
    sx: scale,
    sy: scale,
    angle: angle - 90deg,
  )
  _draw_closed_catmull(pts, fill: fill, stroke: stroke)
}

// stamen in top view: filament as short line, anther as ellipse-ish blob
#let _draw_radial_stamen(radius: 1.2, angle: 0deg, len: 0.95, anther-scale: 1.0) = {
  let bx = radius * calc.cos(angle)
  let by = radius * calc.sin(angle)
  let tx = (radius + len) * calc.cos(angle)
  let ty = (radius + len) * calc.sin(angle)

  draw.line((bx, by), (tx, ty), stroke: _astroke(w: 0.55pt))

  let outline = (
    (0, -0.22),
    (0.28, -0.12),
    (0.34, 0.20),
    (0.0, 0.34),
    (-0.34, 0.20),
    (-0.28, -0.12),
  )
  let pts = _transform_points(
    outline,
    x: tx,
    y: ty,
    sx: anther-scale,
    sy: anther-scale,
    angle: angle,
  )
  _draw_closed_catmull(pts, fill: anther-fill, stroke: (paint: anther-stroke, thickness: 0.5pt))
}

// central gynoecium, top view
#let _draw_gynoecium_top(carpels: 5, radius: 0.75) = {
  if carpels == 3 {
    // tricarpellate syncarpous look
    draw.circle((0, 0), radius: radius, fill: gyn-fill, stroke: _gstroke())
    for a in (90deg, 210deg, 330deg) {
      draw.line(
        (0, 0),
        (radius * 0.75 * calc.cos(a), radius * 0.75 * calc.sin(a)),
        stroke: _gstroke(w: 0.5pt),
      )
    }
  } else {
    draw.circle((0, 0), radius: radius, fill: gyn-fill, stroke: _gstroke())
    // star-like stylar branches / carpel hints
    for i in range(0, carpels) {
      let a = i * 360deg / carpels + 90deg
      draw.line(
        (0, 0),
        (radius * 0.72 * calc.cos(a), radius * 0.72 * calc.sin(a)),
        stroke: _gstroke(w: 0.45pt),
      )
    }
  }
}

// --- TOP VIEW FLOWERS ---

// labels: array of dicts, each with keys:
//   from:   (x,y)  — tail of leader line (omit for no line)
//   to:     (x,y)  — head of leader line and text anchor point
//   body:   content — label text; wrap in Touying uncover() for sequential reveal
//   anchor: string  — CeTZ anchor, default "center"
// Coordinates are in canvas units (same as the drawing).
#let flower_top(kind: "dicot", size: 5.2cm, labels: (), symmetry-lines: 0, petal-clr: auto) = {
  canvas(length: size / 10, {
    import draw: *
    let pf = if petal-clr == auto { petal-fill } else { petal-clr }
    let ps = if petal-clr == auto { petal-stroke } else { petal-clr.darken(40%) }

    // background disk (behind everything)
    draw.circle(
      (0, 0),
      radius: 3.4,
      fill: rgb("#e8f5e0"),
      stroke: none,
    )

    if kind == "3-petal" {
      // 3 sepals
      for a in (30deg, 150deg, 270deg) {
        _draw_radial_organ(_sepal_outline(), radius: 1.05, angle: a,
          fill: sepal-fill, stroke: (paint: sepal-stroke, thickness: 0.8pt), scale: 0.9)
      }
      // 3 petals
      for a in (90deg, 210deg, 330deg) {
        _draw_radial_organ(_petal_outline(), radius: 1.45, angle: a,
          fill: pf, stroke: (paint: ps, thickness: 0.9pt), scale: 1.0)
      }
      // 6 stamens
      for a in (0deg, 60deg, 120deg, 180deg, 240deg, 300deg) {
        _draw_radial_stamen(radius: 0.9, angle: a, len: 0.82, anther-scale: 0.85)
      }
      _draw_gynoecium_top(carpels: 3, radius: 0.7)

    } else if kind == "4-petal" {
      // 4 sepals
      for a in (45deg, 135deg, 225deg, 315deg) {
        _draw_radial_organ(_sepal_outline(), radius: 1.05, angle: a,
          fill: sepal-fill, stroke: (paint: sepal-stroke, thickness: 0.8pt), scale: 0.88)
      }
      // 4 petals at cardinal positions
      for a in (90deg, 180deg, 270deg, 0deg) {
        _draw_radial_organ(_petal_outline(), radius: 1.45, angle: a,
          fill: pf, stroke: (paint: ps, thickness: 0.9pt), scale: 1.0)
      }
      // 6 stamens (tetradynamous, like Brassicaceae)
      for a in (30deg, 90deg, 150deg, 210deg, 270deg, 330deg) {
        _draw_radial_stamen(radius: 0.9, angle: a, len: 0.82, anther-scale: 0.82)
      }
      _draw_gynoecium_top(carpels: 2, radius: 0.65)

    } else if kind == "joined" {
      // Sympetalous corolla: single 5-lobed fused disc
      let o-r = 2.85
      let i-r = 1.7
      let pts = ()
      for i in range(10) {
        let a = 90deg + i * 36deg
        let r = if calc.rem(i, 2) == 0 { o-r } else { i-r }
        pts.push((r * calc.cos(a), r * calc.sin(a)))
      }
      draw.catmull(..pts, close: true,
        fill: pf, stroke: (paint: ps, thickness: 0.9pt))
      // inner tube shading
      draw.circle((0, 0), radius: i-r * 0.75,
        fill: pf.darken(12%), stroke: (paint: ps, thickness: 0.45pt))
      // 5 stamens adnate to tube
      for a in (54deg, 126deg, 198deg, 270deg, 342deg) {
        _draw_radial_stamen(radius: 0.85, angle: a, len: 0.75, anther-scale: 0.82)
      }
      _draw_gynoecium_top(carpels: 5, radius: 0.62)

    } else if kind == "many-petal" {
      // 8 petals — represents 7+ petal flowers (Ranunculaceae, Nymphaeaceae etc.)
      for a in range(8) {
        _draw_radial_organ(_petal_outline(), radius: 1.42, angle: a * 45deg,
          fill: pf, stroke: (paint: ps, thickness: 0.9pt), scale: 0.85)
      }
      // Many stamens — two rings
      for a in range(8) {
        _draw_radial_stamen(radius: 0.95, angle: a * 45deg + 22.5deg, len: 0.75, anther-scale: 0.78)
      }
      for a in range(8) {
        _draw_radial_stamen(radius: 0.65, angle: a * 45deg, len: 0.55, anther-scale: 0.68)
      }
      _draw_gynoecium_top(carpels: 5, radius: 0.58)

    } else if kind == "monocot" {
      // outer tepals
      for a in (90deg, 210deg, 330deg) {
        _draw_radial_organ(
          _narrow_tepal_outline(),
          radius: 1.65,
          angle: a,
          fill: tepal-fill,
          stroke: (paint: tepal-stroke, thickness: 0.85pt),
          scale: 1.02,
        )
      }
      // inner tepals
      for a in (30deg, 150deg, 270deg) {
        _draw_radial_organ(
          _narrow_tepal_outline(),
          radius: 1.55,
          angle: a,
          fill: rgb("#f3dc9e"),
          stroke: (paint: tepal-stroke, thickness: 0.8pt),
          scale: 0.92,
        )
      }
      // six stamens
      for a in (0deg, 60deg, 120deg, 180deg, 240deg, 300deg) {
        _draw_radial_stamen(radius: 0.95, angle: a, len: 0.95, anther-scale: 0.9)
      }
      _draw_gynoecium_top(carpels: 3, radius: 0.72)

    } else if kind == "bilabiate" {
      // 5 sepals behind petals
      for a in (54deg, 126deg, 198deg, 270deg, 342deg) {
        _draw_radial_organ(
          _sepal_outline(), radius: 1.05, angle: a,
          fill: sepal-fill, stroke: (paint: sepal-stroke, thickness: 0.8pt), scale: 0.9,
        )
      }
      // upper lip — 2 petals
      for a in (105deg, 75deg) {
        _draw_radial_organ(
          _petal_outline(), radius: 1.40, angle: a,
          fill: pf, stroke: (paint: ps, thickness: 0.9pt), scale: 1.0,
        )
      }
      // lower lip — large central petal + 2 smaller lateral petals
      _draw_radial_organ(
        _petal_outline(), radius: 1.55, angle: 270deg,
        fill: pf, stroke: (paint: ps, thickness: 0.9pt), scale: 1.15,
      )
      for a in (212deg, 328deg) {
        _draw_radial_organ(
          _petal_outline(), radius: 1.38, angle: a,
          fill: pf, stroke: (paint: ps, thickness: 0.9pt), scale: 0.82,
        )
      }
      // 4 stamens (didynamous)
      _draw_radial_stamen(radius: 0.88, angle: 84deg, len: 1.05, anther-scale: 0.9)
      _draw_radial_stamen(radius: 0.88, angle: 96deg, len: 1.05, anther-scale: 0.9)
      _draw_radial_stamen(radius: 0.72, angle: 70deg, len: 0.70, anther-scale: 0.8)
      _draw_radial_stamen(radius: 0.72, angle: 110deg, len: 0.70, anther-scale: 0.8)
      // bicarpellate gynoecium
      _draw_gynoecium_top(carpels: 2, radius: 0.65)
      // bilateral symmetry axis
      line(
        (0, -5.6), (0, 5.9),
        stroke: (paint: rgb("#555"), thickness: 0.9pt, dash: "dashed"),
      )

    } else {
      // sepals behind
      for a in (54deg, 126deg, 198deg, 270deg, 342deg) {
        _draw_radial_organ(
          _sepal_outline(),
          radius: 1.05,
          angle: a,
          fill: sepal-fill,
          stroke: (paint: sepal-stroke, thickness: 0.8pt),
          scale: 0.9,
        )
      }
      // five petals
      for a in (90deg, 162deg, 234deg, 306deg, 18deg) {
        _draw_radial_organ(
          _petal_outline(),
          radius: 1.45,
          angle: a,
          fill: pf,
          stroke: (paint: ps, thickness: 0.9pt),
          scale: 1.0,
        )
      }
      // five stamens alternating with petals
      for a in (54deg, 126deg, 198deg, 270deg, 342deg) {
        _draw_radial_stamen(radius: 0.95, angle: a, len: 0.82, anther-scale: 0.9)
      }
      _draw_gynoecium_top(carpels: 5, radius: 0.7)
    }

    // Optional symmetry axes
    if symmetry-lines > 0 {
      let sym-stroke = (paint: rgb("#555"), thickness: 0.9pt, dash: "dashed")
      let r = 5.7
      for i in range(0, symmetry-lines) {
        let a = 90deg + i * 360deg / symmetry-lines
        line(
          (-r * calc.cos(a), -r * calc.sin(a)),
          ( r * calc.cos(a),  r * calc.sin(a)),
          stroke: sym-stroke,
        )
      }
    }

    // Caller-supplied labels
    let ldr-stroke = (paint: rgb("#444"), thickness: 0.4pt)
    for lbl in labels {
      if "from" in lbl {
        line(lbl.from, lbl.to, stroke: ldr-stroke)
        circle(lbl.from, radius: 0.07, fill: rgb("#444"), stroke: none)
      }
      let anchor = lbl.at("anchor", default: "center")
      content(lbl.to, anchor: anchor, lbl.body)
    }
  })
}

// --- LONGITUDINAL SECTION HELPERS ---

// petal / tepal in side view
#let _side_petal(fill: petal-fill, stroke: _fstroke()) = {
  let pts = (
    (0, 0),
    (0.32, 0.22),
    (0.72, 1.5),
    (0.55, 3.25),
    (0.0, 4.7),
    (-0.55, 3.25),
    (-0.72, 1.5),
    (-0.32, 0.22),
  )
  _draw_closed_catmull(pts, fill: fill, stroke: stroke)
}

#let _side_narrow_tepal(fill: tepal-fill, stroke: (paint: tepal-stroke, thickness: 0.85pt)) = {
  let pts = (
    (0, 0),
    (0.24, 0.18),
    (0.55, 1.2),
    (0.45, 3.0),
    (0.0, 4.85),
    (-0.45, 3.0),
    (-0.55, 1.2),
    (-0.24, 0.18),
  )
  _draw_closed_catmull(pts, fill: fill, stroke: stroke)
}

// superior ovary in longitudinal section
#let _draw_ovary_section(width: 1.4, height: 2.2, locules: 2) = {
  let pts = (
    (0, 0),
    (width * 0.62, 0.18),
    (width * 0.78, height * 0.48),
    (width * 0.52, height * 0.94),
    (0, height),
    (-width * 0.52, height * 0.94),
    (-width * 0.78, height * 0.48),
    (-width * 0.62, 0.18),
  )
  _draw_closed_catmull(pts, fill: gyn-fill, stroke: _gstroke())

  if locules == 3 {
    draw.line((0, 0.28), (0, height * 0.9), stroke: _gstroke(w: 0.5pt))
    draw.line((0, height * 0.52), (width * 0.52, height * 0.28), stroke: _gstroke(w: 0.45pt))
    draw.line((0, height * 0.52), (-width * 0.52, height * 0.28), stroke: _gstroke(w: 0.45pt))
  } else {
    draw.line((0, 0.28), (0, height * 0.92), stroke: _gstroke(w: 0.5pt))
  }

  // ovules
  draw.circle((width * 0.28, height * 0.42), radius: 0.11, fill: rgb("#fff6dd"), stroke: _gstroke(w: 0.35pt))
  draw.circle((-width * 0.28, height * 0.42), radius: 0.11, fill: rgb("#fff6dd"), stroke: _gstroke(w: 0.35pt))
}

#let _draw_style_and_stigma(top-y: -2.0, style-h: 2.25, branches: 1) = {
  let y0 = -top-y
  let y1 = y0 + style-h

  draw.line((0, y0), (0, y1), stroke: _gstroke(w: 0.9pt))

  if branches == 3 {
    // tricarpellate style ending in 3 stigma lobes
    for a in (-32deg, 90deg, 212deg) {
      draw.line(
        (0, y1),
        (0.42 * calc.cos(a), y1 + 0.42 * calc.sin(a)),
        stroke: _gstroke(w: 0.7pt),
      )
      draw.circle(
        (0.42 * calc.cos(a), y1 + 0.42 * calc.sin(a)),
        radius: 0.08,
        fill: gyn-fill,
        stroke: _gstroke(w: 0.45pt),
      )
    }
  } else {
    // simple style with capitate stigma
    draw.circle(
      (0, y1 + 0.16),
      radius: 0.16,
      fill: gyn-fill,
      stroke: _gstroke(w: 0.55pt),
    )
  }
}

#let _draw_stamen_side(x: 0, base-y: 0, h: 2.4, bend: 0.15) = {
  draw.catmull(
    (x, base-y),
    (x + bend, base-y + h * 0.45),
    (x + bend * 0.4, base-y + h),
    stroke: _astroke(w: 0.55pt),
  )

  let ax = x + bend * 0.4
  let ay = base-y + h
  let an = (
    (ax, ay + 0.35),
    (ax + 0.22, ay + 0.18),
    (ax + 0.18, ay - 0.18),
    (ax, ay - 0.35),
    (ax - 0.18, ay - 0.18),
    (ax - 0.22, ay + 0.18),
  )
  _draw_closed_catmull(an, fill: anther-fill, stroke: (paint: anther-stroke, thickness: 0.5pt))
}

#let _side_sepal(fill: sepal-fill, stroke: (paint: sepal-stroke, thickness: 0.8pt)) = {
  let pts = (
    (0, 0),
    (0.18, 0.10),
    (0.40, 0.70),
    (0.34, 1.55),
    (0.0, 2.35),
    (-0.34, 1.55),
    (-0.40, 0.70),
    (-0.18, 0.10),
  )
  _draw_closed_catmull(pts, fill: fill, stroke: stroke)
}

#let _draw_floral_cup(fill: rgb("#e3f1d4"), stroke: (paint: rgb("#a8c28a"), thickness: 0.7pt)) = {
  let pts = (
    (0, 0),
    (1.55, 0.22),
    (1.15, 0.95),
    (0.55, 1.28),
    (0, 1.40),
    (-0.55, 1.28),
    (-1.15, 0.95),
    (-1.55, 0.22),
  )
  _draw_closed_catmull(pts, fill: fill, stroke: stroke)
}

// --- LONGITUDINAL SECTION FLOWERS ---

#let flower_section(kind: "dicot", size: 6.2cm, labels: ()) = {
  canvas(length: size / 10, {
    import draw: *

    // pedicel / floral axis
    draw.line((0, -1.6), (0, 0), stroke: (paint: floral-axis-stroke, thickness: 1.3pt))

    group({
      translate((0, -0.25))
      _draw_floral_cup()
    })

    if kind == "monocot" {
      // outer tepals: more spreading
      group({
        translate((-1.25, -0.05))
        rotate(42deg)
        _side_narrow_tepal(fill: tepal-fill)
      })
      group({
        translate((1.25, -0.05))
        rotate(-42deg)
        _side_narrow_tepal(fill: tepal-fill)
      })

      // inner tepals: slightly higher and less spreading
      group({
        translate((-0.78, 0.42))
        rotate(16deg)
        _side_narrow_tepal(fill: rgb("#f3dc9e"))
      })
      group({
        translate((0.78, 0.42))
        rotate(-16deg)
        _side_narrow_tepal(fill: rgb("#f3dc9e"))
      })

      // ovary
      group({
        translate((0, 0))
        _draw_ovary_section(width: 1.15, height: 1.85, locules: 3)
      })

      // style + stigma lobes
      _draw_style_and_stigma(top-y: -1.85, style-h: 2.55, branches: 3)

      // stamens
      _draw_stamen_side(x: -0.98, base-y: 0.22, h: 2.55, bend: -0.12)
      _draw_stamen_side(x: -0.45, base-y: 0.18, h: 2.20, bend: -0.08)
      _draw_stamen_side(x: 0.45, base-y: 0.18, h: 2.20, bend: 0.08)
      _draw_stamen_side(x: 0.98, base-y: 0.22, h: 2.55, bend: 0.12)

    } else {
      // sepals: very patent
      group({
        translate((-0.85, -0.10))
        rotate(58deg)
        _side_sepal()
      })
      group({
        translate((0.85, -0.10))
        rotate(-58deg)
        _side_sepal()
      })

      // petals: slightly higher, more ascending
      group({
        translate((-0.88, 0.42))
        rotate(16deg)
        _side_petal(fill: petal-fill, stroke: (paint: petal-stroke, thickness: 0.9pt))
      })
      group({
        translate((0.88, 0.42))
        rotate(-16deg)
        _side_petal(fill: petal-fill, stroke: (paint: petal-stroke, thickness: 0.9pt))
      })

      // ovary
      group({
        translate((0, 0))
        _draw_ovary_section(width: 1.28, height: 2.0, locules: 2)
      })

      // style + stigma
      _draw_style_and_stigma(top-y: -2.0, style-h: 2.35, branches: 1)

      // stamens
      _draw_stamen_side(x: -0.95, base-y: 0.18, h: 2.35, bend: -0.12)
      _draw_stamen_side(x: -0.38, base-y: 0.15, h: 2.0, bend: -0.08)
      _draw_stamen_side(x: 0.38, base-y: 0.15, h: 2.0, bend: 0.08)
      _draw_stamen_side(x: 0.95, base-y: 0.18, h: 2.35, bend: 0.12)
    }

    // Caller-supplied labels (same pattern as flower_top)
    let ldr-stroke = (paint: rgb("#444"), thickness: 0.4pt)
    for lbl in labels {
      if "from" in lbl {
        line(lbl.from, lbl.to, stroke: ldr-stroke)
        circle(lbl.from, radius: 0.07, fill: rgb("#444"), stroke: none)
      }
      let anchor = lbl.at("anchor", default: "center")
      content(lbl.to, anchor: anchor, lbl.body)
    }
  })
}

#let labeled_flower(label, body, body-height: 5cm) = {
  align(center)[
    #box(height: body-height, width: 100%)[
      #align(center + horizon)[#body]
    ]
    #v(0.15em)
    #text(size: 12pt)[#label]
  ]
}

// --- Galleries ---

#let flower_top_gallery() = grid(
  columns: 2,
  gutter: 1.4em,
  labeled_flower("Idealised dicot flower (top view)", flower_top(kind: "dicot", size: 8cm), body-height: 8.2cm),
  labeled_flower("Idealised monocot flower (top view)", flower_top(kind: "monocot", size: 8cm), body-height: 8.2cm),
)

#let flower_section_gallery() = grid(
  columns: 2,
  gutter: 1.4em,
  labeled_flower("Idealised dicot flower (longitudinal section)", flower_section(kind: "dicot", size: 8cm), body-height: 7cm),
  labeled_flower("Idealised monocot flower (longitudinal section)", flower_section(kind: "monocot", size: 8cm), body-height: 7cm),
)

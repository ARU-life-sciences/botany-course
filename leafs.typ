#import "@preview/cetz:0.3.4": canvas, draw

#let blade-fill = rgb("#cfe8b4")
#let blade-stroke = rgb("#4f6b3c")
#let vein-stroke = rgb("#6d8a52")
#let hair-stroke = rgb("#6b5a48")

#let _stroke(w: 0.9pt, paint: blade-stroke) = (paint: paint, thickness: w)
#let _vein-stroke(w: 0.7pt) = (paint: vein-stroke, thickness: w)
#let _hair-stroke(w: 0.55pt) = (paint: hair-stroke, thickness: w)

#let _simple_outline(shape: "ovate") = {
  // Right-side only (base → apex). _closed_leaf_path mirrors for left side.
  if shape == "linear" {
    (
      (0, 0),
      (0.55, 1.8),
      (0.70, 4.5),
      (0.48, 7.2),
      (0, 8.6),
    )
  } else if shape == "cordate" {
    // Sinus elevated at (0, 1.4); lobes dip to y≈0 — forces catmull to arch steeply
    // down from sinus to lobe, giving a deep heart-shaped notch.
    // Midrib from y=0 upward visually bridges petiole to sinus naturally.
    (
      (0, 1.4),
      (1.2, 0.0),
      (2.2, 1.0),
      (2.4, 2.8),
      (1.8, 5.5),
      (0, 7.8),
    )
  } else if shape == "elliptic" {
    (
      (0, 0),
      (1.4, 1.2),
      (1.9, 3.0),
      (1.45, 5.8),
      (0, 8.2),
    )
  } else if shape == "obovate" {
    (
      (0, 0),
      (0.8, 1.0),
      (1.4, 2.8),
      (2.0, 5.6),
      (1.2, 7.5),
      (0, 8.2),
    )
  } else if shape == "obcordate" {
    // Wider at top than base; apical notch — lobe above sinus.
    // Sinus (0, 7.2) is lower than lobes (1.2, 8.0) so catmull dips into the notch.
    (
      (0, 0),
      (0.35, 0.8),
      (1.55, 3.2),
      (1.85, 5.8),
      (1.25, 8.0),  // right lobe of apical notch
      (0, 7.2),     // apex sinus (notch bottom)
    )
  } else if shape == "lanceolate" {
    (
      (0, 0),
      (0.7, 1.2),
      (1.25, 3.6),
      (0.9, 6.6),
      (0, 8.7),
    )
  } else {
    (
      (0, 0),
      (1.2, 1.2),
      (2.2, 3.0),
      (1.7, 6.0),
      (0, 8.3),
    )
  }
}

#let _base_adjust(points, base: "cuneate") = {
  if base == "rounded" {
    // Gently convex base — wider and rounder than cuneate
    (
      (0, 0),
      (1.7, 0.4),
      (2.1, 1.3),
      ..points.slice(2, points.len()),
    )
  } else if base == "auriculate" {
    // Small rounded ear-lobes at base (Asteraceae, Brassicaceae)
    (
      (0, 0),
      (1.1, 0.3),
      (1.9, 0.05),
      (1.2, 1.1),
      ..points.slice(2, points.len()),
    )
  } else {
    points
  }
}

#let _serrate_points(width: 2.0, height: 8.0, teeth: 10) = {
  // Sinus slightly inside envelope, tip protruding outward — drawn with draw.line
  // so catmull doesn't round the points into bumps
  let pts = ((0, 0),)
  for i in range(0, 13) {
    let y_sinus = i * height / 13
    let y_tip   = (i + 0.42) * height / 13
    let x_env   = width * calc.sin((y_sinus / height) * 180deg)
    let x_tip   = width * calc.sin((y_tip   / height) * 180deg)
    pts.push((x_env * 0.82, y_sinus))   // sinus — slightly inside envelope
    pts.push((x_tip + 0.38, y_tip))     // tooth tip — clearly outside envelope
  }
  pts.push((0, height))
  pts
}

#let _lobed_points(width: 2.2, height: 8.0, lobes: 3) = {
  let pts = ((0, 0),)
  let step = height / lobes
  for i in range(0, lobes) {
    let y0 = i * step
    let env = calc.sin(((i + 0.5) / lobes) * 180deg)
    let lw = width * env
    let sw = width * 0.28 * env
    pts.push((sw,        y0 + step * 0.08))
    pts.push((lw,        y0 + step * 0.35))
    pts.push((lw * 0.85, y0 + step * 0.60))
    pts.push((sw,        y0 + step * 0.88))
  }
  pts.push((0, height))
  pts
}

#let _closed_leaf_path(points) = {
  let n = points.len()
  let mirrored = ()
  for i in range(0, n) {
    let p = points.at(n - 1 - i)
    mirrored.push((-p.at(0), p.at(1)))
  }

  let full = points + mirrored.slice(1, mirrored.len() - 1)
  full.push(full.at(0))
  full
}

#let _draw_leaf_body(points, fill-color: blade-fill) = {
  let path = _closed_leaf_path(points)
  draw.catmull(
    ..path.slice(0, path.len() - 1),
    close: true,
    stroke: _stroke(),
    fill: fill-color,
  )
}

// Sharp (straight-segment) version for toothed margins — catmull would round the teeth
#let _draw_leaf_body_sharp(points, fill-color: blade-fill) = {
  let path = _closed_leaf_path(points)
  draw.line(
    ..path.slice(0, path.len() - 1),
    close: true,
    stroke: _stroke(),
    fill: fill-color,
  )
}

#let _draw_petiole(len: 1.6) = {
  draw.line((0, 0), (0, -len), stroke: _stroke(w: 1.0pt))
}

#let _draw_midrib(top: 8.0) = {
  draw.line((0, 0), (0, top), stroke: _vein-stroke(w: 0.8pt))
}

#let _leaf_width_at(pts, y) = {
  let n = pts.len()
  for i in range(0, n - 1) {
    let y0 = pts.at(i).at(1)
    let y1 = pts.at(i + 1).at(1)
    if y >= y0 and y <= y1 {
      let t = (y - y0) / (y1 - y0)
      return pts.at(i).at(0) * (1 - t) + pts.at(i + 1).at(0) * t
    }
  }
  if y <= pts.at(0).at(1) { return pts.at(0).at(0) }
  pts.at(n - 1).at(0)
}

#let _draw_parallel_venation(pts, top: 8.0, n: 2) = {
  _draw_midrib(top: top)
  for i in range(1, n + 1) {
    let xb = _leaf_width_at(pts, 0.8) * i / (n + 1)
    let xt = _leaf_width_at(pts, top - 0.4) * i / (n + 1)
    draw.line((xb, 0.8), (xt, top - 0.4), stroke: _vein-stroke(w: 0.45pt))
    draw.line((-xb, 0.8), (-xt, top - 0.4), stroke: _vein-stroke(w: 0.45pt))
  }
}

// Arcuate (campylodromous) venation — Plantago style.
// Veins emerge from the base, arch outward with the leaf width, and converge at the tip.
#let _draw_arcuate_venation(pts, top: 8.0, n: 3) = {
  _draw_midrib(top: top)
  for i in range(1, n + 1) {
    let frac = i / (n + 1)
    // Peak width: scale with actual leaf margin at mid-leaf
    let x_peak = _leaf_width_at(pts, top * 0.45) * frac * 0.88
    let x_base = x_peak * 0.18   // start close to midrib
    let x_tip  = x_peak * 0.12   // converge near tip
    draw.catmull(
      (x_base, 0.4),
      (x_peak * 0.85, top * 0.22),
      (x_peak,        top * 0.48),
      (x_peak * 0.75, top * 0.73),
      (x_tip,         top - 0.5),
      stroke: _vein-stroke(),
    )
    draw.catmull(
      (-x_base, 0.4),
      (-x_peak * 0.85, top * 0.22),
      (-x_peak,        top * 0.48),
      (-x_peak * 0.75, top * 0.73),
      (-x_tip,         top - 0.5),
      stroke: _vein-stroke(),
    )
  }
}

// Sessile (embedded) glands — filled dots scattered over the leaf surface.
// Positions calibrated for ovate/elliptic outlines; all verified inside margin.
#let _draw_sessile_glands(color: rgb("#1c1008")) = {
  let dots = (
    ( 0.4, 1.3), (-0.6, 1.6),
    ( 1.1, 2.1), (-0.3, 2.4),
    ( 0.7, 2.8), (-1.3, 3.1),
    ( 1.7, 3.2), ( 0.2, 3.6),
    (-0.9, 3.9), ( 1.5, 4.3),
    ( 0.5, 4.7), (-1.4, 4.8),
    ( 1.1, 5.2), (-0.6, 5.5),
    ( 1.3, 5.8), ( 0.2, 6.1),
    (-0.8, 6.3), ( 0.6, 6.8),
    (-0.3, 7.2),
  )
  for p in dots {
    draw.circle(p, radius: 0.14, fill: color, stroke: none)
  }
}

#let _draw_net_venation(pts, top: 8.0, n: 5, order: 1) = {
  _draw_midrib(top: top)
  for i in range(1, n + 1) {
    let y = 0.8 + i * (top - 1.4) / (n + 1)
    let dx = _leaf_width_at(pts, y + 0.6) * 0.90
    draw.line((0, y), (dx, y + 0.6), stroke: _vein-stroke())
    draw.line((0, y), (-dx, y + 0.6), stroke: _vein-stroke())

    if order >= 2 {
      let plen = calc.sqrt(dx * dx + 0.36)
      let ux = dx / plen
      let uy = 0.6 / plen
      let ca = calc.cos(45deg)
      let sa = calc.sin(45deg)

      // Upper secondary: rotate primary +45°. If x goes negative (steep primary), flip it.
      let sux-raw = ux * ca - uy * sa
      let sux = if sux-raw < 0 { -sux-raw } else { sux-raw }
      let suy = ux * sa + uy * ca
      let su-n = calc.sqrt(sux * sux + suy * suy)
      let sux = sux / su-n
      let suy = suy / su-n

      // Lower secondary: rotate primary -45°. Mirror of upper about primary axis.
      let sdx-raw = ux * ca + uy * sa
      let sdx = if sdx-raw < 0 { -sdx-raw } else { sdx-raw }
      let sdy = -ux * sa + uy * ca
      let sd-n = calc.sqrt(sdx * sdx + sdy * sdy)
      let sdx = sdx / sd-n
      let sdy = sdy / sd-n

      let sl = plen * 0.42

      for t in (0.28, 0.58) {
        let bx = dx * t
        let by = y + 0.6 * t
        let exu = bx + sux * sl
        let eyu = by + suy * sl
        let exd = bx + sdx * sl * 0.85
        let eyd = by + sdy * sl * 0.85
        draw.line((bx,  by), (exu,  eyu), stroke: _vein-stroke(w: 0.5pt))
        draw.line((-bx, by), (-exu, eyu), stroke: _vein-stroke(w: 0.5pt))
        draw.line((bx,  by), (exd,  eyd), stroke: _vein-stroke(w: 0.5pt))
        draw.line((-bx, by), (-exd, eyd), stroke: _vein-stroke(w: 0.5pt))

        if order >= 3 {
          let sl3 = sl * 0.38
          // Same ±45° rotation logic applied recursively to each secondary direction

          // Off lower secondary (sdx, sdy) — compute first so tuu can mirror tdd
          let tdu-xr = sdx * ca - sdy * sa
          let tdu-x = if tdu-xr < 0 { -tdu-xr } else { tdu-xr }
          let tdu-y = sdx * sa + sdy * ca
          let tdu-n = calc.sqrt(tdu-x * tdu-x + tdu-y * tdu-y)
          let tdu-x = tdu-x / tdu-n
          let tdu-y = tdu-y / tdu-n

          let tdd-xr = sdx * ca + sdy * sa
          let tdd-x = if tdd-xr < 0 { -tdd-xr } else { tdd-xr }
          let tdd-y = -sdx * sa + sdy * ca
          let tdd-n = calc.sqrt(tdd-x * tdd-x + tdd-y * tdd-y)
          let tdd-x = tdd-x / tdd-n
          let tdd-y = tdd-y / tdd-n

          // Off upper secondary (sux, suy)
          // tud: -45° rotation of upper secondary (lower side, toward primary) — works fine
          let tud-xr = sux * ca + suy * sa
          let tud-x = if tud-xr < 0 { -tud-xr } else { tud-xr }
          let tud-y = -sux * sa + suy * ca
          let tud-n = calc.sqrt(tud-x * tud-x + tud-y * tud-y)
          let tud-x = tud-x / tud-n
          let tud-y = tud-y / tud-n

          // tuu: +45° rotation of upper secondary, NO x-flip.
          // Without flip, tuu has negative x → goes upper-inward (toward midrib/apex).
          // This puts tuu on the correct side of the secondary (~70° from it) and
          // mirrors tdd which goes lower-outward on the opposite side.
          let tuu-xr = sux * ca - suy * sa
          let tuu-y = sux * sa + suy * ca
          let tuu-n = calc.sqrt(tuu-xr * tuu-xr + tuu-y * tuu-y)
          let tuu-x = tuu-xr / tuu-n
          let tuu-y = tuu-y / tuu-n

          for t3 in (0.30, 0.65) {
            let txu = bx + sux * sl * t3
            let tyu = by + suy * sl * t3
            draw.line((txu,  tyu), (txu + tuu-x*sl3,  tyu + tuu-y*sl3), stroke: _vein-stroke(w: 0.35pt))
            draw.line((-txu, tyu), (-txu - tuu-x*sl3, tyu + tuu-y*sl3), stroke: _vein-stroke(w: 0.35pt))
            draw.line((txu,  tyu), (txu + tud-x*sl3,  tyu + tud-y*sl3), stroke: _vein-stroke(w: 0.35pt))
            draw.line((-txu, tyu), (-txu - tud-x*sl3, tyu + tud-y*sl3), stroke: _vein-stroke(w: 0.35pt))

            let txd = bx + sdx * sl * 0.85 * t3
            let tyd = by + sdy * sl * 0.85 * t3
            draw.line((txd,  tyd), (txd + tdu-x*sl3,  tyd + tdu-y*sl3), stroke: _vein-stroke(w: 0.35pt))
            draw.line((-txd, tyd), (-txd - tdu-x*sl3, tyd + tdu-y*sl3), stroke: _vein-stroke(w: 0.35pt))
            draw.line((txd,  tyd), (txd + tdd-x*sl3,  tyd + tdd-y*sl3), stroke: _vein-stroke(w: 0.35pt))
            draw.line((-txd, tyd), (-txd - tdd-x*sl3, tyd + tdd-y*sl3), stroke: _vein-stroke(w: 0.35pt))
          }
        }
      }
    }
  }
}

// --- Hair types (all drawn in canvas coordinates) ---

#let _hair_simple(p, angle: 90deg, len: 1.0) = {
  let dx = len * calc.cos(angle)
  let dy = len * calc.sin(angle)
  draw.line(p, (p.at(0) + dx, p.at(1) + dy), stroke: _hair-stroke())
}

// Y-shaped bifurcate hair (Brassicaceae)
#let _hair_forked(p, angle: 90deg, len: 1.0) = {
  let shaft = len * 0.5
  let arm   = len * 0.55
  let sx = shaft * calc.cos(angle)
  let sy = shaft * calc.sin(angle)
  let fork = (p.at(0) + sx, p.at(1) + sy)
  draw.line(p, fork, stroke: _hair-stroke())
  draw.line(fork, (fork.at(0) + arm * calc.cos(angle + 35deg), fork.at(1) + arm * calc.sin(angle + 35deg)), stroke: _hair-stroke())
  draw.line(fork, (fork.at(0) + arm * calc.cos(angle - 35deg), fork.at(1) + arm * calc.sin(angle - 35deg)), stroke: _hair-stroke())
}

// Multi-branched dendritic/stellate hair (Verbascum)
#let _hair_dendritic(p, angle: 90deg, len: 1.0) = {
  let dx = len * calc.cos(angle)
  let dy = len * calc.sin(angle)
  let tip = (p.at(0) + dx, p.at(1) + dy)
  draw.line(p, tip, stroke: _hair-stroke())
  for frac in (0.3, 0.6) {
    let m = (p.at(0) + dx * frac, p.at(1) + dy * frac)
    let bl = len * (0.35 - frac * 0.1)
    for da in (-50deg, 50deg) {
      draw.line(m, (m.at(0) + bl * calc.cos(angle + da), m.at(1) + bl * calc.sin(angle + da)), stroke: _hair-stroke())
    }
  }
}

// Hooked hair — straight shaft, curved hook at tip (Myosotis / many Boraginaceae)
#let _hair_hooked(p, angle: 90deg, len: 1.0) = {
  let shaft = len * 0.75
  let sx = shaft * calc.cos(angle)
  let sy = shaft * calc.sin(angle)
  let base-tip = (p.at(0) + sx, p.at(1) + sy)
  draw.line(p, base-tip, stroke: _hair-stroke())
  // Hook: short arc approximated as two line segments curving sideways
  let hk = len * 0.28
  let h1 = (base-tip.at(0) + hk * calc.cos(angle - 55deg), base-tip.at(1) + hk * calc.sin(angle - 55deg))
  let h2 = (h1.at(0) + hk * 0.6 * calc.cos(angle - 120deg), h1.at(1) + hk * 0.6 * calc.sin(angle - 120deg))
  draw.line(base-tip, h1, stroke: _hair-stroke())
  draw.line(h1, h2, stroke: _hair-stroke())
}

// Glandular hair — straight stalk topped with a round secretory head
#let _hair_glandular(p, angle: 90deg, len: 1.0) = {
  let shaft = len * 0.72
  let sx = shaft * calc.cos(angle)
  let sy = shaft * calc.sin(angle)
  let head = (p.at(0) + sx, p.at(1) + sy)
  draw.line(p, head, stroke: _hair-stroke())
  draw.circle(head, radius: len * 0.20,
    stroke: _hair-stroke(), fill: rgb("#a07840"))
}

// Stellate hair — arms radiating from a short central stalk
#let _hair_stellate(p, angle: 90deg, len: 1.0) = {
  let stalk = len * 0.18
  let cx = p.at(0) + stalk * calc.cos(angle)
  let cy = p.at(1) + stalk * calc.sin(angle)
  draw.line(p, (cx, cy), stroke: _hair-stroke())
  // 7 arms across the upper hemisphere (0°–180° in world space)
  let arm = len * 0.82
  for i in range(0, 7) {
    let a = i * 30deg
    draw.line((cx, cy),
      (cx + arm * calc.cos(a), cy + arm * calc.sin(a)),
      stroke: _hair-stroke())
  }
}

// Standalone illustration: surface line + 3 hairs of given type
#let hair_illustration(kind, size: 3.0cm) = {
  canvas(length: size / 5.0, {
    import draw: *
    // Epidermis surface line
    draw.line((-2.0, 0), (2.0, 0), stroke: (paint: rgb("#555"), thickness: 0.8pt))
    let positions = (-1.1, 0.0, 1.1)
    let angles    = (80deg, 90deg, 100deg)
    for i in range(3) {
      let px = positions.at(i)
      let ang = angles.at(i)
      let p = (px, 0)
      if kind == "simple"         { _hair_simple(p,     angle: ang, len: 1.6) }
      else if kind == "forked"    { _hair_forked(p,     angle: ang, len: 1.6) }
      else if kind == "dendritic" { _hair_dendritic(p,  angle: ang, len: 1.6) }
      else if kind == "hooked"    { _hair_hooked(p,     angle: ang, len: 1.6) }
      else if kind == "glandular" { _hair_glandular(p,  angle: ang, len: 1.6) }
      else if kind == "stellate"  { _hair_stellate(p,   angle: ang, len: 1.6) }
    }
  })
}

#let leaf_simple(
  shape: "ovate",
  margin: "entire",
  base: "cuneate",
  venation: "net",
  venation-order: 1,
  glands: "none",   // "none" | "black" | "orange"
  height: 4.0cm,
) = {
  canvas(length: height / 9.5, {
    import draw: *

    let pts = if margin == "toothed" {
        _serrate_points(
          width: if shape == "linear" { 0.45 } else { 1.8 },
          height: 8.0,
          teeth: 7,
        )
      } else if margin == "lobed" {
        _lobed_points(width: 1.7, height: 8.0, lobes: 3)
      } else {
        _base_adjust(_simple_outline(shape: shape), base: base)
      }

    _draw_petiole()
    if margin == "toothed" {
      _draw_leaf_body_sharp(pts)
    } else {
      _draw_leaf_body(pts)
    }

    let vein_pts = if margin == "lobed" {
      pts
    } else if margin == "toothed" {
      // The sine-envelope sinuses sit at ~71% of the smooth outline near the base;
      // scale x to 65% so veins stay inside across all lateral positions
      let _sm = _simple_outline(shape: shape)
      let _sc = ()
      for _p in _sm { _sc.push((_p.at(0) * 0.65, _p.at(1))) }
      _sc
    } else {
      _simple_outline(shape: shape)
    }
    if venation == "parallel" {
      _draw_parallel_venation(vein_pts, top: 8.0, n: 1)
    } else if venation == "arcuate" {
      _draw_arcuate_venation(vein_pts, top: 8.0, n: 3)
    } else {
      _draw_net_venation(vein_pts, top: 8.0, n: 5, order: venation-order)
    }

    if glands == "black" {
      _draw_sessile_glands(color: rgb("#1c1008"))
    } else if glands == "orange" {
      _draw_sessile_glands(color: rgb("#c45e00"))
    }
  })
}

#let _transform_points(points, x: 0, y: 0, sx: 1, sy: 1) = {
  let out = ()
  for p in points {
    out.push((x + p.at(0) * sx, y + p.at(1) * sy))
  }
  out
}

#let _leaflet_at(x, y, sx: 0.36, sy: 0.36) = {
  // Mirror in local space first, then scale+translate
  let local = _closed_leaf_path(_simple_outline(shape: "lanceolate"))
  let pts = _transform_points(local.slice(0, local.len() - 1), x: x, y: y, sx: sx, sy: sy)
  draw.line((0, y), (x, y), stroke: _stroke(w: 0.7pt))
  draw.catmull(..pts, close: true, stroke: _stroke(), fill: blade-fill)
  draw.line((x, y), (x, y + 8.0 * sy), stroke: _vein-stroke(w: 0.8pt))
}

#let _leaflet_fanned(ox, oy, tilt: 0deg, sc: 0.36) = {
  // Mirror in local space first, then rotate+translate
  let local = _closed_leaf_path(_simple_outline(shape: "lanceolate"))
  let ca = calc.cos(tilt)
  let sa = calc.sin(tilt)
  let pts = ()
  for p in local.slice(0, local.len() - 1) {
    let px = p.at(0) * sc
    let py = p.at(1) * sc
    pts.push((ox + px * ca + py * sa, oy - px * sa + py * ca))
  }
  draw.catmull(..pts, close: true, stroke: _stroke(), fill: blade-fill)
  draw.line(
    (ox, oy),
    (ox + 8.0 * sc * sa, oy + 8.0 * sc * ca),
    stroke: _vein-stroke(w: 0.8pt),
  )
}

#let leaf_compound(
  kind: "pinnate",
  height: 4.3cm,
) = {
  canvas(length: height / 9.7, {
    import draw: *

    if kind == "palmate" {
      draw.line((0, -1.3), (0, 0), stroke: _stroke(w: 1.0pt))
      _leaflet_fanned(0, 0, tilt:   0deg, sc: 0.46)
      _leaflet_fanned(0, 0, tilt:  28deg, sc: 0.41)
      _leaflet_fanned(0, 0, tilt: -28deg, sc: 0.41)
      _leaflet_fanned(0, 0, tilt:  56deg, sc: 0.35)
      _leaflet_fanned(0, 0, tilt: -56deg, sc: 0.35)
    } else {
      draw.line((0, -1.3), (0, 8.4), stroke: _stroke(w: 1.0pt))
      _leaflet_fanned(0, 1.7, tilt: -90deg, sc: 0.28)
      _leaflet_fanned(0, 1.7, tilt:  90deg, sc: 0.28)

      _leaflet_fanned(0, 3.5, tilt: -90deg, sc: 0.31)
      _leaflet_fanned(0, 3.5, tilt:  90deg, sc: 0.31)

      _leaflet_fanned(0, 5.3, tilt: -90deg, sc: 0.34)
      _leaflet_fanned(0, 5.3, tilt:  90deg, sc: 0.34)

      _leaflet_fanned(0, 7.2, tilt:   0deg, sc: 0.40)
    }
  })
}

// Trifoliate compound leaf with obcordate leaflets — Oxalis style.
// glands: true adds orange sessile glands to each leaflet.
#let leaf_oxalis(glands: true, height: 5.5cm) = {
  // Broad obcordate leaflet — wider than tall, apical notch.
  // Sinus (0, 2.20) lower than lobes (1.20, 2.65) → catmull dips into notch.
  let lp = (
    (0, 0),
    (0.45, 0.15),
    (1.70, 1.70),
    (1.85, 2.80),
    (0.40, 2.65),  // right lobe
    (0, 2.20),     // apex sinus
  )
  // Monotonic subset for vein width interpolation (stops before lobe dip)
  let vp = (
    (0, 0),
    (0.45, 0.15),
    (1.70, 1.70),
    (1.85, 2.80),
  )
  // Orange gland positions — recalculated at ≤85% of outline boundary.
  // lp: [0.15,1.70]→x:0.45–1.70 (slope 0.806); [1.70,2.80]→x:1.70–1.85
  let gdots = (
    ( 0.35, 0.25), (-0.40, 0.40),
    ( 0.60, 0.60), (-0.55, 0.80),
    ( 0.82, 0.95), ( 0.10, 1.00),
    (-0.88, 1.15), ( 1.00, 1.30),
    (-0.40, 1.45), ( 1.15, 1.60),
    ( 0.60, 1.80), (-1.20, 1.80),
    ( 0.20, 2.05),
  )

  let draw-leaflet() = {
    _draw_leaf_body(lp)
    _draw_net_venation(vp, top: 2.20, n: 2, order: 1)
    if glands {
      for p in gdots {
        draw.circle(p, radius: 0.10, fill: rgb("#c45e00"), stroke: none)
      }
    }
  }

  // Sessile: all three leaflets radiate directly from top of petiole.
  // Laterals at ±45° from terminal → ~90° angle between each lateral and terminal.
  canvas(length: height / 10, {
    import draw: *

    // Main petiole
    line((0, -1.5), (0, 3.0), stroke: _stroke(w: 1.2pt))

    // Terminal leaflet — straight up
    group({
      translate((0.0, 3.0))
      draw-leaflet()
    })

    // Right lateral — 45° from terminal
    group({
      translate((0.0, 3.0))
      rotate(-105deg)
      draw-leaflet()
    })

    // Left lateral — mirror
    group({
      translate((0.0, 3.0))
      rotate(105deg)
      draw-leaflet()
    })
  })
}

#let labeled_leaf(label, body, body-height: 5cm) = {
  align(center)[
    #box(height: body-height, width: 100%)[
      #align(center + horizon)[#body]
    ]
    #v(0.15em)
    #text(size: 12pt)[#label]
  ]
}

#let hero_leaf() = {
  canvas(length: 0.54cm, {
    import draw: *

    let pts = _transform_points(
      _simple_outline(shape: "ovate"),
      sx: 1.05,
      sy: 1.05,
    )

    _draw_petiole(len: 1.8)
    _draw_leaf_body(pts)
    _draw_net_venation(_transform_points(_simple_outline(shape: "ovate"), sx: 1.05, sy: 1.05), top: 8.4, n: 5)
  })
}

#let leaf_shape_gallery() = grid(
  columns: 3,
  gutter: 1.2em,
  labeled_leaf("Linear",     leaf_simple(shape: "linear",     venation: "parallel", height: 2.4cm), body-height: 3.0cm),
  labeled_leaf("Cordate",    leaf_simple(shape: "cordate",                          height: 2.4cm), body-height: 3.0cm),
  labeled_leaf("Elliptic",   leaf_simple(shape: "elliptic",                         height: 2.4cm), body-height: 3.0cm),
  labeled_leaf("Ovate",      leaf_simple(shape: "ovate",                            height: 2.4cm), body-height: 3.0cm),
  labeled_leaf("Obovate",    leaf_simple(shape: "obovate",                          height: 2.4cm), body-height: 3.0cm),
  labeled_leaf("Lanceolate", leaf_simple(shape: "lanceolate",                       height: 2.4cm), body-height: 3.0cm),
)

#let leaf_margin_gallery() = grid(
  columns: 3,
  gutter: 1.2em,
  labeled_leaf("Entire",  leaf_simple(shape: "ovate", margin: "entire"),  body-height: 5cm),
  labeled_leaf("Toothed", leaf_simple(shape: "ovate", margin: "toothed"), body-height: 5cm),
  labeled_leaf("Lobed",   leaf_simple(shape: "ovate", margin: "lobed"),   body-height: 5cm),
)

#let leaf_base_gallery() = grid(
  columns: 3,
  gutter: 1.4em,
  labeled_leaf("Cuneate",            leaf_simple(shape: "ovate", base: "cuneate"),    body-height: 5cm),
  labeled_leaf("Rounded",            leaf_simple(shape: "ovate", base: "rounded"),    body-height: 5cm),
  labeled_leaf("Hastate / sagittate", leaf_simple(shape: "ovate", base: "auriculate"), body-height: 5cm),
)

#let leaf_venation_gallery() = grid(
  columns: 3,
  gutter: 1.4em,
  labeled_leaf("Parallel (grass-like)",            leaf_simple(shape: "linear", venation: "parallel"),               body-height: 5cm),
  labeled_leaf([Parallel (_Plantago_)],  leaf_simple(shape: "ovate",  venation: "arcuate"),                body-height: 5cm),
  labeled_leaf("Net-veined",          leaf_simple(shape: "ovate",  venation: "net", venation-order: 2), body-height: 5cm),
)

#let leaf_hair_gallery() = grid(
  columns: 3,
  gutter: 1.0em,
  labeled_leaf("Simple hairs (many species)",    hair_illustration("simple"),    body-height: 2.8cm),
  labeled_leaf("Forked hairs (Brassicaceae)",    hair_illustration("forked"),    body-height: 2.8cm),
  labeled_leaf([Dendritic hairs (e.g. _Verbascum_)],    hair_illustration("dendritic"), body-height: 2.8cm),
  labeled_leaf([Hooked hairs (e.g. _Myosotis_)],        hair_illustration("hooked"),    body-height: 2.8cm),
  labeled_leaf("Glandular hairs (many species)", hair_illustration("glandular"), body-height: 2.8cm),
  labeled_leaf([Stellate hairs (e.g. _Hedera_)],   hair_illustration("stellate"),  body-height: 2.8cm),
)

#let leaf_complexity_gallery() = grid(
  columns: 3,
  gutter: 1.2em,
  labeled_leaf("Simple",            leaf_simple(shape: "ovate"),         body-height: 5.5cm),
  labeled_leaf("Compound: 1-pinnate", leaf_compound(kind: "pinnate"),      body-height: 5.5cm),
  labeled_leaf("Compound: palmate", leaf_compound(kind: "palmate"),      body-height: 5.5cm),
)

#let leaf_gland_gallery() = grid(
  columns: 2,
  gutter: 1.2em,
  labeled_leaf([Black scattered glands (e.g. _Hypericum_)], leaf_simple(shape: "elliptic", glands: "black"), body-height: 5.5cm),
  labeled_leaf([Orange scattered glands (e.g. _Oxalis_)], leaf_oxalis(height: 6cm))
)


// Illustrates that every leaf subtends an axillary bud.
// Shows a vertical stem, one leaf with petiole, and a bud in the leaf axil.
#let leaf_axil_illustration(size: 6cm) = {
  canvas(length: size / 10, {
    import draw: *
    let stem-col = rgb("#5a3e28")
    let bud-fill = rgb("#b8d98a")
    let ldr = (paint: rgb("#333"), thickness: 0.42pt)  // leader line stroke

    // Vertical stem
    line((0, 0), (0, 9.5), stroke: (paint: stem-col, thickness: 3.4pt))

    // Node swelling at leaf attachment
    circle((0, 3.5), radius: 0.28, fill: stem-col, stroke: none)

    // Petiole
    line((0, 3.5), (1.5, 4.7), stroke: _stroke(w: 1.25pt))

    // Leaf blade — ovate, rotated so apex continues petiole direction (~35° above horizontal)
    group({
      translate((1.5, 4.7))
      rotate(-55deg)
      let lp = (
        (0, 0),
        (0.85, 0.75),
        (1.3, 2.0),
        (1.0, 3.6),
        (0, 4.5),
      )
      _draw_leaf_body(lp)
      _draw_net_venation(lp, top: 4.5, n: 3, order: 1)
    })

    // Axillary bud — small ovoid sitting in the leaf axil
    group({
      translate((0.22, 3.95))
      rotate(-18deg)
      catmull(
        (0, 0), (0.28, 0.17), (0.34, 0.52), (0.21, 0.88), (0, 1.02),
        (-0.21, 0.88), (-0.34, 0.52), (-0.28, 0.17),
        close: true, fill: bud-fill, stroke: _stroke(w: 0.62pt),
      )
      // Bud scale lines
      line((-0.30, 0.32), (0.30, 0.32), stroke: _stroke(w: 0.36pt))
      line((-0.32, 0.60), (0.32, 0.60), stroke: _stroke(w: 0.36pt))
    })

    // Leader lines and labels
    line((-0.06, 1.8), (-0.65, 1.8), stroke: ldr)
    content((-0.7, 1.8), anchor: "east", text(size: 12pt)[stem])

    line((0.68, 4.55), (1.4, 8.1), stroke: ldr)
    content((1.45, 8.12), anchor: "west", text(size: 12pt)[axillary bud])

    line((0.82, 3.85), (1.4, 3.1), stroke: ldr)
    content((1.45, 3.05), anchor: "west", text(size: 12pt)[petiole])

    line((4.5, 6.9), (5.1, 8.2), stroke: ldr)
    content((5.15, 8.22), anchor: "west", text(size: 12pt)[leaf blade])
  })
}

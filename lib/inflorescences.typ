#import "@preview/cetz:0.3.4": canvas, draw

// ======================================================
// Inflorescence schematic diagrams — lateral (side) view
// All canvases use length: size/8, so 8 units ≈ full size
// ======================================================

// --- colour palette ---
#let _sc  = rgb("#5a3e1b")  // stems / axes
#let _fc  = rgb("#f5d040")  // open flower fill
#let _fcs = rgb("#b08000")  // open flower stroke & centre
#let _bc  = rgb("#8ab554")  // bud fill
#let _bcs = rgb("#4a7a28")  // bud stroke
#let _lc  = rgb("#6d9e42")  // leaf fill
#let _lcs = rgb("#3a6b20")  // leaf stroke
#let _rfc = rgb("#fce88a")  // ray floret fill
#let _dfc = rgb("#e6b818")  // disc floret fill
#let _ivc = rgb("#cfe7b8")  // involucre fill

// --- drawing primitives ---

#let _stem(a, b, w: 1.1pt) = {
  draw.line(a, b, stroke: (paint: _sc, thickness: w))
}

#let _flower(pos, r: 0.28, bud: false) = {
  if bud {
    draw.circle(pos, radius: r * 0.60,
      fill: _bc, stroke: (paint: _bcs, thickness: 0.4pt))
  } else {
    draw.circle(pos, radius: r,
      fill: _fc, stroke: (paint: _fcs, thickness: 0.5pt))
    draw.circle(pos, radius: r * 0.30, fill: _fcs, stroke: none)
  }
}

// Simple pointed leaf from (bx,by) toward (tx,ty), half-width hw
#let _leaf(bx, by, tx, ty, hw: 0.32) = {
  let mx = (bx + tx) * 0.5
  let my = (by + ty) * 0.5
  let dx = tx - bx
  let dy = ty - by
  let ll = calc.sqrt(dx * dx + dy * dy)
  let px = -dy / ll * hw
  let py =  dx / ll * hw
  draw.catmull(
    (bx, by),
    (mx + px, my + py),
    (tx, ty),
    (mx - px, my - py),
    close: true,
    fill: _lc, stroke: (paint: _lcs, thickness: 0.5pt),
  )
}

// Hub marker (small filled circle at branching point)
#let _hub(pos, r: 0.09) = {
  draw.circle(pos, radius: r, fill: _sc, stroke: none)
}

// --- diagram key / legend ---

#let inf_legend(flower-size: 0.55cm) = {
  let open-flower = canvas(length: flower-size, {
    import draw: *
    circle((0, 0), radius: 0.28, fill: _fc, stroke: (paint: _fcs, thickness: 0.5pt))
    circle((0, 0), radius: 0.09, fill: _fcs, stroke: none)
  })
  let bud-sym = canvas(length: flower-size, {
    import draw: *
    circle((0, 0), radius: 0.20, fill: _bc, stroke: (paint: _bcs, thickness: 0.4pt))
  })
  set text(size: 12pt)
  box(
    stroke: (paint: rgb("#aaa"), thickness: 0.5pt),
    inset: (x: 0.5em, y: 0.4em),
    radius: 2pt,
    grid(
      columns: (auto, auto, 0.6em, auto, auto),
      gutter: 0.35em,
      align: horizon,
      open-flower, [open flower],
      [],
      bud-sym,     [bud],
    )
  )
}

// --- labeled wrapper (mirrors labeled_flower / labeled_leaf) ---

#let labeled_inf(label, body, body-height: 5cm) = {
  align(center)[
    #box(height: body-height, width: 100%)[
      #align(center + horizon)[#body]
    ]
    #v(0.15em)
    #text(size: 11pt)[#label]
  ]
}

// ======================================================
// Individual inflorescence functions
// ======================================================

// --- 1a. Pair --- single peduncle forking into two equal pedicels
#let inf_pair(size: 5cm) = canvas(length: size / 8, {
  import draw: *
  let fork = (0.0, 4.0)
  _stem((0, 0), fork)
  _hub(fork)
  _stem(fork, (-1.4, 6.0), w: 0.75pt)
  _stem(fork, ( 1.4, 6.0), w: 0.75pt)
  _flower((-1.4, 6.0), r: 0.38)
  _flower(( 1.4, 6.0), r: 0.38)
})

// --- 1b. Solitary --- single terminal flower on an unbranched stem
#let inf_solitary(size: 5cm) = canvas(length: size / 8, {
  import draw: *
  _stem((0, 0), (0, 7.0))
  // a small bract partway up
  _leaf(0, 2.8, -1.2, 3.8, hw: 0.16)
  _flower((0, 7.0), r: 0.42)
})

// --- 2. Raceme --- stalked flowers (pedicels) along a central axis,
//     youngest flowers at the tip; lower flowers open, upper ones buds
#let inf_raceme(size: 5cm) = canvas(length: size / 8, {
  import draw: *
  _stem((0, 0), (0, 8.2))
  let entries = (
    (1.0,  false),
    (2.0,  false),
    (3.0,  false),
    (4.0,  true),
    (5.0,  true),
    (6.0,  true),
  )
  for (i, e) in entries.enumerate() {
    let y   = e.at(0)
    let bud = e.at(1)
    let s   = if calc.rem(i, 2) == 0 { -1 } else { 1 }
    // pedicel angled upward at ~45° from the main axis
    let px  = s * 1.0
    let py  = y + 1.0
    _stem((0, y), (px, py), w: 0.6pt)
    _flower((px, py), r: 0.25, bud: bud)
  }
})

// --- 3. Spike --- stalkless flowers seated directly on the axis
#let inf_spike(size: 5cm) = canvas(length: size / 8, {
  import draw: *
  _stem((0, 0), (0, 8.2))
  let heights = (1.0, 1.9, 2.8, 3.7, 4.6, 5.5, 6.4)
  for (i, y) in heights.enumerate() {
    _flower((0, y), r: 0.22, bud: i >= 4)
  }
})

// --- 4. Umbel --- all pedicels radiate from one point (the hub)
#let inf_umbel(size: 5cm) = canvas(length: size / 8, {
  import draw: *
  let hub = (0.0, 2.8)
  _stem((0, 0), hub)
  let ray-len = 2.8
  let angles = (30deg, 50deg, 70deg, 90deg, 110deg, 130deg, 150deg)
  for a in angles {
    let fx = hub.at(0) + ray-len * calc.cos(a)
    let fy = hub.at(1) + ray-len * calc.sin(a)
    _stem(hub, (fx, fy), w: 0.6pt)
    _flower((fx, fy), r: 0.25)
  }
  _hub(hub)
})

// --- 5. Compound umbel --- two tiers of branching from a central point
#let inf_compound_umbel(size: 5cm) = canvas(length: size / 8, {
  import draw: *
  let hub1 = (0.0, 1.8)
  _stem((0, 0), hub1)
  let p-len   = 1.9
  let s-len   = 0.85
  let p-ang   = (35deg, 62deg, 90deg, 118deg, 145deg)
  let s-spread = 24deg
  for pa in p-ang {
    let phx = hub1.at(0) + p-len * calc.cos(pa)
    let phy = hub1.at(1) + p-len * calc.sin(pa)
    _stem(hub1, (phx, phy), w: 0.65pt)
    _hub((phx, phy), r: 0.07)
    for ds in (-s-spread, 0deg, s-spread) {
      let sa = pa + ds
      let fx = phx + s-len * calc.cos(sa)
      let fy = phy + s-len * calc.sin(sa)
      _stem((phx, phy), (fx, fy), w: 0.5pt)
      _flower((fx, fy), r: 0.18)
    }
  }
  _hub(hub1)
})

// --- 6. Capitulum (tight head) --- sessile flowers packed on a flat
//     receptacle; no stalks visible between receptacle and flowers
#let inf_capitulum(size: 5cm) = canvas(length: size / 8, {
  import draw: *
  _stem((0, 0), (0, 2.1))
  // receptacle — shallow bowl: flat base, edges curl upward
  draw.catmull(
    (-1.9, 2.1), (0, 2.1), (1.9, 2.1),   // flat bottom
    (2.3, 2.55),                           // right edge curls up
    (1.6, 2.42), (0, 2.34), (-1.6, 2.42), // top surface, slightly concave
    (-2.3, 2.55),                          // left edge curls up
    close: true,
    fill: rgb("#1a1a1a"), stroke: (paint: rgb("#333"), thickness: 0.5pt),
  )
  // single layer of sessile flowers sitting on the receptacle
  for x in (-2.1, -1.5, -0.9, -0.3, 0.3, 0.9, 1.5, 2.1) {
    _flower((x, 2.68), r: 0.22)
  }
})

// --- 7. Axillary --- flowers arising at the junction of leaf and stem
#let inf_axillary(size: 5cm) = canvas(length: size / 8, {
  import draw: *
  _stem((0, 0), (0, 9.5))
  let nodes = (
    (1.6,  1),
    (3.2, -1),
    (4.8,  1),
    (6.4, -1),
  )
  for nd in nodes {
    let y = nd.at(0); let s = nd.at(1)
    _leaf(0, y, s * 2.0, y + 1.6, hw: 0.34)
    _stem((0, y), (s * 2.0, y + 1.6), w: 0.4pt)  // midrib
    _flower((s * 0.38, y + 0.22), r: 0.22)         // axillary flower
  }
})

// --- 8. Cyme (complex group) --- central vertical axis with two levels
//     of opposite branching; each lateral hub sprouts a trio of arms
//     fanning around the branch direction (centre-angle ca)
#let inf_cyme(size: 5cm) = canvas(length: size / 8, {
  import draw: *

  // trio: three branches at ca-45°, ca, ca+45° — flowers only at tips
  let trio = (hub, len, r, ca) => {
    let hx = hub.at(0); let hy = hub.at(1)
    for da in (-45deg, 0deg, 45deg) {
      let a = ca + da
      let t = (hx + len * calc.cos(a), hy + len * calc.sin(a))
      _stem(hub, t, w: 0.55pt)
      _flower(t, r: r)
    }
  }

  // central axis
  _stem((0, 0), (0, 8.5))
  _flower((0, 8.5), r: 0.24)

  // lower branch pair
  let hb1 = (0.0, 2.0)
  _hub(hb1)
  let b1l = (-2.2, 3.8); let b1r = (2.2, 3.8)
  _stem(hb1, b1l, w: 0.8pt);  _stem(hb1, b1r, w: 0.8pt)
  _hub(b1l, r: 0.08);          _hub(b1r, r: 0.08)
  trio(b1l, 1.3, 0.21, 135deg)
  trio(b1r, 1.3, 0.21,  45deg)

  // upper branch pair
  let hb2 = (0.0, 5.2)
  _hub(hb2)
  let b2l = (-1.6, 6.6); let b2r = (1.6, 6.6)
  _stem(hb2, b2l, w: 0.8pt);  _stem(hb2, b2r, w: 0.8pt)
  _hub(b2l, r: 0.08);          _hub(b2r, r: 0.08)
  trio(b2l, 0.9, 0.19, 135deg)
  trio(b2r, 0.9, 0.19,  45deg)
})

// --- Catkin --- pendulous axis with overlapping bract scales
#let inf_catkin(size: 5cm) = canvas(length: size / 8, {
  import draw: *
  _stem((0, 4.8), (0, 7.6))   // peduncle
  _stem((0, 0.5), (0, 4.8))   // axis drawn first; bracts overlay it

  // (y, side, scale) — scale tapers toward tip
  let nodes = (
    (4.40,  1.0, 1.00),
    (3.88, -1.0, 1.00),
    (3.36,  1.0, 1.00),
    (2.84, -1.0, 1.00),
    (2.32,  1.0, 0.88),
    (1.80, -1.0, 0.88),
    (1.28,  1.0, 0.75),
    (0.78, -1.0, 0.68),
  )

  for nd in nodes {
    let y  = nd.at(0)
    let s  = nd.at(1)
    let sc = nd.at(2)

    // stamens: 3 per bract, drawn before bract so bases are hidden
    for j in range(3) {
      let ox = s * (0.24 + j * 0.17) * sc
      draw.line(
        (ox, y + 0.03),
        (ox + s * 0.06, y - 0.26 * sc),
        stroke: (paint: _sc, thickness: 0.28pt)
      )
      // anther (golden dot)
      draw.circle(
        (ox + s * 0.08, y - 0.31 * sc),
        radius: 0.068 * sc,
        fill: _fcs,
        stroke: none
      )
    }

    // bract scale — wider, flatter, tongue-shaped
    draw.catmull(
      (0.0,            y + 0.28 * sc),
      (s * 0.45 * sc,  y + 0.52 * sc),
      (s * 1.12 * sc,  y + 0.26 * sc),
      (s * 1.08 * sc,  y + 0.00),
      (s * 0.82 * sc,  y - 0.18 * sc),
      (s * 0.22 * sc,  y - 0.10 * sc),
      (0.0,            y + 0.08 * sc),
      close: true,
      fill: _lc,
      stroke: (paint: _lcs, thickness: 0.44pt),
    )
  }

  // tapered terminal bud
  draw.catmull(
    (0, 0.62), (-0.20, 0.46), (0, 0.26), (0.20, 0.46),
    close: true,
    fill: _bc, stroke: (paint: _bcs, thickness: 0.42pt)
  )
})

// ======================================================
// Tight head variants
// ======================================================

// Tight head (umbel) — all equal pedicels from one hub, forming a globe
#let inf_tight_umbel(size: 5cm) = canvas(length: size / 8, {
  import draw: *
  let hub = (0.0, 2.2)
  _stem((0, 0), hub)
  _hub(hub)
  let n    = 12
  let rlen = 0.58
  for i in range(0, n) {
    let a  = i * 360deg / n + 90deg
    let fx = hub.at(0) + rlen * calc.cos(a)
    let fy = hub.at(1) + rlen * calc.sin(a)
    _stem(hub, (fx, fy), w: 0.4pt)
    _flower((fx, fy), r: 0.21)
  }
})

// Tight head (capitulum) — compact Asteraceae head; ray + disc florets
#let inf_tight_capitulum(size: 5cm) = inf_capitulum(size: size)

// Tight head (panicle) — flat-topped compound corymb; wide fan of short
//   branched stems with flowers packed across the top
#let inf_tight_panicle(size: 5cm) = canvas(length: size / 8, {
  import draw: *
  let hub = (0.0, 1.8)
  _stem((0, 0), hub)
  _hub(hub)
  let p-angles = (45deg, 67.5deg, 90deg, 112.5deg, 135deg)
  let p-len    = 0.65
  let s-len    = 0.30
  let s-spread = 20deg
  for pa in p-angles {
    let phx = hub.at(0) + p-len * calc.cos(pa)
    let phy = hub.at(1) + p-len * calc.sin(pa)
    _stem(hub, (phx, phy), w: 0.65pt)
    _hub((phx, phy), r: 0.07)
    for ds in (-s-spread, 0deg, s-spread) {
      let sa = pa + ds
      let fx = phx + s-len * calc.cos(sa)
      let fy = phy + s-len * calc.sin(sa)
      _stem((phx, phy), (fx, fy), w: 0.45pt)
      _flower((fx, fy), r: 0.18)
    }
  }
})

// Tight head gallery — 1 × 3 row
#let tight_head_gallery(size: 6.5cm, body-height: 9.5cm) = grid(
  columns: 3,
  gutter: 1.2em,
  labeled_inf([Tight head (umbel; e.g. _Astrantia_)],      inf_tight_umbel(size: size),      body-height: body-height),
  labeled_inf([Tight head (capitulum; e.g. most Asteraceae)],  inf_tight_capitulum(size: size),  body-height: body-height),
  labeled_inf([Tight head (panicle; e.g. many Poaceae)],    inf_tight_panicle(size: size),    body-height: body-height),
)

// --- Galleries by category ---

#let inf_simple_gallery(size: 4.2cm, body-height: 9.5cm) = grid(
  columns: 5,
  gutter: 0.5em,
  labeled_inf([Solitary (e.g. _Papaver_)],       inf_solitary(size: size),  body-height: body-height),
  labeled_inf([Pair (e.g. _Geranium_)],           inf_pair(size: size),      body-height: body-height),
  labeled_inf([Raceme (e.g. _Chamaenerion_)],         inf_raceme(size: size),    body-height: body-height),
  labeled_inf([Spike (e.g. _Triticum_)],          inf_spike(size: size),     body-height: body-height),
  labeled_inf([In leaf axils, (e.g. _Lamium_)],  inf_axillary(size: size),  body-height: body-height),
)

#let inf_complex_gallery(size: 6.5cm, body-height: 9.5cm) = grid(
  columns: 3,
  gutter: 1.0em,
  labeled_inf([Umbel (e.g. _Hedera_)],           inf_umbel(size: size),          body-height: body-height),
  labeled_inf([Compound umbel (e.g. _Anthriscus_],  inf_compound_umbel(size: size), body-height: body-height),
  labeled_inf([Panicle (e.g. _Scrophularia_)],         inf_cyme(size: size),           body-height: body-height),
)

// lib/floral_formula.typ

#let ff-sub(x) = sub(text(size: 0.78em)[#x])
#let ff-sep = [#h(0.15em),#h(0.3em)]

#let join-content(items, sep) = {
  for i in range(items.len()) {
    if i > 0 { sep }
    items.at(i)
  }
}

// ── Symmetry ─────────────────────────────────────────────
#let sym-map = (
  "*": [$ast$],
  "r": [$ast$],
  "radial": [$ast$],
  "X": "X",
  "b": [$arrow.b$],
  "bilateral": [$arrow.b$],
  "z": [$arrow.b$],
  "asym": [$emptyset$],
)

// ── Count formatting ─────────────────────────────────────
#let count(x) = {
  if x == none { none }
  else if type(x) == array {
    x.map(count).join([+])
  } else {
    [#x]
  }
}

// ── Whorls ───────────────────────────────────────────────
#let whorl(letter, n, connate: none, sterile: false) = {
  if n == none { return none }

  let body = [#letter#ff-sub[#count(n)]]
  if sterile { body = [#body •] }

  if connate == "fixed" {
    [(#body)]
  } else if connate == "variable" {
    [(#body\]]
  } else {
    body
  }
}

// ── Gynoecium ────────────────────────────────────────────
#let gynoecium(n, ovary: "s", connate: none, sterile: false) = {
  if n == none { return none }

  if n == 0 or n == "0" {
    return [G#ff-sub[0]]
  }

  let g = if ovary == "s" or ovary == "superior" {
    [#underline[G]]
  } else if ovary == "i" or ovary == "inferior" {
    [G̅]
  } else if ovary == "h" or ovary == "half" or ovary == "variable" {
    [#underline[G̅]]
  } else {
    [G]
  }

  let body = [#g#ff-sub[#count(n)]]
  if sterile { body = [#body •] }

  if connate == "fixed" {
    [(#body)]
  } else if connate == "variable" {
    [(#body\]]
  } else {
    body
  }
}

// ── Floral formula ───────────────────────────────────────
#let floral(
  symmetry: "*",
  tepals: none, tepals-connate: none,
  calyx: none, calyx-connate: none,
  petals: none, petals-connate: none,
  stamens: none, stamens-connate: none, stamens-sterile: false,
  carpels: none, carpels-connate: none,
  ovary: "s",
  carpels-sterile: false,
  fruit: none,
  adnation: (),
) = context {

  let groups = (
    (name: "sym", body: sym-map.at(symmetry, default: [#symmetry])),
    (name: "P", body: whorl("P", tepals, connate: tepals-connate)),
    (name: "K", body: whorl("K", calyx, connate: calyx-connate)),
    (name: "C", body: whorl("C", petals, connate: petals-connate)),
    (name: "A", body: whorl("A", stamens, connate: stamens-connate, sterile: stamens-sterile)),
    (name: "G", body: gynoecium(carpels, ovary: ovary, connate: carpels-connate, sterile: carpels-sterile)),
  ).filter(g => g.body != none)

  let names = groups.map(g => g.name)

  let formula = join-content(groups.map(g => g.body), ff-sep)
  let formula-line = if fruit != none {
    [#formula; #fruit]
  } else {
    formula
  }

  if adnation.len() == 0 {
    formula-line
  } else {

    // ── Measure positions ───────────────────────────────
    let sepw = measure(ff-sep).width
    let starts = ()
    let ends = ()
    let x = 0pt

    for i in range(groups.len()) {
      let w = measure(groups.at(i).body).width
      starts.push(x)
      ends.push(x + w)
      x += w
      if i < groups.len() - 1 {
        x += sepw
      }
    }

    let total-w = measure(formula-line).width

    box(width: total-w, height: 1.8em)[
      #formula-line

      #for adn in adnation {
        let from = names.position(n => n == adn.at("from"))
        let to = names.position(n => n == adn.at("to"))

        if from != none and to != none {
          let start = calc.min(from, to)
          let stop = calc.max(from, to)

          let x0 = starts.at(start) + (ends.at(start) - starts.at(start)) / 2
          let x1 = starts.at(stop) + (ends.at(stop) - starts.at(stop)) / 2
          let span = x1 - x0

          let stroke-style = if adn.at("variable", default: false) {
            (paint: black, thickness: 0.45pt, dash: "dashed")
          } else {
            (paint: black, thickness: 0.45pt)
          }

          // ── Draw bracket ─────────────────────────────
          place(left, dx: x0, dy: 0.25em)[
            #box(width: span, height: 0.42em)[

              // horizontal bar
              #place(bottom)[
                #line(length: span, stroke: stroke-style)
              ]

              // vertical ticks
              #for j in range(start, stop + 1) {
                let mid = starts.at(j) + (ends.at(j) - starts.at(j)) / 2 - x0

                place(left, dx: mid)[
                  #box(
                    width: 0pt,
                    height: 0.42em,
                    stroke: (left: stroke-style)
                  )[]
                ]
              }
            ]
          ]
        }
      }
    ]
  }
}

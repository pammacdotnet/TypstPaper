#import "@preview/ijimai:0.0.5": blueunir
#import "@preview/cetz:0.3.4": *

#canvas(length: 2cm, {
  import draw: content, line

  let scr(it) = text(features: ("ss01",), box($cal(it)$))

  // define colors and line thickness
  //let teal = rgb("008080")
  let teal = blueunir
  //let brown = rgb("A52A2A")
  let brown = blue // Not brown.
  let lt = 0.6pt

  // define the function for the kruskal coordinate wordlines and auxilliary variables
  let nx = 100
  let M = 1
  let Nlines = 4
  let xmax = 2
  let xmin = 0

  let kruskal(x, c) = calc.asin(c * calc.sin(2 * x)).rad() * (2 / calc.pi)

  let wordlines-universe(xoffset, yoffset, color) = {
    for i in range(0, Nlines) {
      let c = 2 * i / (Nlines + 1)
      let cs = calc.sin(c)
      line(stroke: (paint: color, thickness: 0.4pt), ..(
        for x in range(0, nx + 1) {
          let x = xmin + x / nx * (xmax - xmin)
          ((xoffset + x, yoffset - kruskal(x * calc.pi / 4, cs)),)
        }
      ))
      line(stroke: (paint: color, thickness: 0.4pt), ..(
        for x in range(0, nx + 1) {
          let x = xmin + x / nx * (xmax - xmin)
          ((xoffset + x, yoffset + kruskal(x * calc.pi / 4, cs)),)
        }
      ))
      line(stroke: (paint: color, thickness: 0.4pt), ..(
        for x in range(0, nx + 1) {
          let x = xmin + x / nx * (xmax - xmin)
          ((xoffset + 1 - kruskal(x * calc.pi / 4, cs), yoffset + x - 1),)
        }
      ))
      line(stroke: (paint: color, thickness: 0.4pt), ..(
        for x in range(0, nx + 1) {
          let x = xmin + x / nx * (xmax - xmin)
          ((xoffset + 1 + kruskal(x * calc.pi / 4, cs), yoffset + x - 1),)
        }
      ))
    }
  }

  // add the singularity lines first.
  // we do this because then we will overlap other object and we can just fill this with color. Only downside is that the zizag line on the bottom is a bit wonky
  decorations.zigzag(
    line((-1, 1), (+1, 1), (1, -1), (-1, -1)),
    amplitude: .03,
    segments: 101,
    fill: red.lighten(95%),
    stroke: (paint: blueunir, thickness: 0.4mm),
    name: "origin-top",
  )

  // normal lines, plus colors to denote
  line(
    (0, 0),
    (1, 1),
    (2, 0),
    (1, -1),
    (0, 0),
    stroke: (paint: black, thickness: lt),
    fill: blue.lighten(95%),
    name: "universe",
  )
  line(
    (0, 0),
    (-1, 1),
    (-2, 0),
    (-1, -1),
    (0, 0),
    stroke: (paint: black, thickness: lt),
    fill: teal.lighten(95%),
    name: "alt-universe",
  )

  wordlines-universe(0, 0, blue)
  wordlines-universe(-2, 0, teal)

  // manually add wordlines for the inside of the black hole and white hole
  let xoffset = 1
  let yoffset = 1

  for i in range(1, Nlines) {
    let c = 2 * i / (Nlines + 1)
    line(stroke: (paint: brown, thickness: 0.4pt), ..(
      for x in range(0, nx + 1) {
        let x = xmin + x / nx * (xmax - xmin)
        let cs = calc.sin(c)
        ((x - xoffset, -kruskal(x * calc.pi / 4, cs) + yoffset),)
      }
    ))
    line(stroke: (paint: brown, thickness: 0.4pt), ..(
      for x in range(0, nx + 1) {
        let x = xmin + x / nx * (xmax - xmin)
        let cs = calc.sin(c)
        ((x - xoffset, +kruskal(x * calc.pi / 4, cs) - yoffset),)
      }
    ))
  }

  for i in range(0, Nlines) {
    let c = 2 * i / (Nlines + 1)
    let cs = calc.sin(c)
    line(stroke: (paint: brown, thickness: 0.4pt), ..(
      for x in range(0, nx + 1) {
        let x = xmin + x / nx * (xmax - xmin) / 2
        ((1 - xoffset - kruskal(x * calc.pi / 4, cs), x - 1 + yoffset),)
      }
    ))
    line(stroke: (paint: brown, thickness: 0.4pt), ..(
      for x in range(0, nx + 1) {
        let x = xmin + x / nx * (xmax - xmin) / 2
        ((1 - xoffset + kruskal(x * calc.pi / 4, cs), x - 1 + yoffset),)
      }
    ))
    line(stroke: (paint: brown, thickness: 0.4pt), ..(
      for x in range(0, nx + 1) {
        let x = (xmin + xmax) / 2 + x / nx * (xmax - xmin) / 2
        ((1 - xoffset + kruskal(x * calc.pi / 4, cs), x - 1 - yoffset),)
      }
    ))
    line(stroke: (paint: brown, thickness: .4pt), ..(
      for x in range(0, nx + 1) {
        let x = (xmin + xmax) / 2 + x / nx * (xmax - xmin) / 2
        ((1 - xoffset - kruskal(x * calc.pi / 4, cs), x - 1 - yoffset),)
      }
    ))
  }

  // add labels for spacetime regions
  content((rel: (0, 0), to: "universe.centroid"), box(
    fill: blue.lighten(95%),
    inset: 2.5pt,
    radius: 3pt,
    stroke: none,
    [$I$],
  ))

  content((rel: (0, 0), to: "alt-universe.centroid"), box(
    fill: blue.lighten(95%),
    inset: 2.5pt,
    radius: 4pt,
    stroke: none,
    [$I I I$],
  ))

  content((0, +0.63), box(
    fill: red.lighten(95%),
    inset: 2.5pt,
    radius: 4pt,
    stroke: none,
    [$I I$],
  ))

  content((0, -0.63), box(
    fill: red.lighten(95%),
    inset: 2.5pt,
    radius: 7pt,
    stroke: none,
    [$I V$],
  ))

  content((0, 1.15), $r = 0$)
  content((0, -1.15), $r = 0$)
  content(
    (rel: (0.05, 1.05), to: "universe.centroid"),
    $i^(+)$,
    anchor: "west",
  )
  content(
    (rel: (0.5, 0.6), to: "universe.centroid"),
    $scr(I)^(+)$,
    anchor: "west",
  )
  content(
    (rel: (1.05, 0.02), to: "universe.centroid"),
    $i^(0)$,
    anchor: "west",
  )
  content(
    (rel: (0.5, -0.6), to: "universe.centroid"),
    $scr(I)^(-)$,
    anchor: "west",
  )
  content(
    (rel: (0.05, -1.05), to: "universe.centroid"),
    $i^(-)$,
    anchor: "west",
  )

  // redraw lines on top to avoid wordlines getting on  the way
  line((0, 0), (1, 1), (2, 0), (1, -1), (0, 0), stroke: (
    paint: blueunir,
    thickness: 0.4mm,
  ))
  line((0, 0), (-1, 1), (-2, 0), (-1, -1), (0, 0), stroke: (
    paint: blueunir,
    thickness: 0.4mm,
  ))
})

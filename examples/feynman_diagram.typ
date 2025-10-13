#import "@preview/ijimai:1.0.0": blue-unir
#import "@preview/cetz:0.3.4": *

#canvas({
  import draw: circle, content, line, mark
  let marklen = 0.15 // length of the arrowhead
  let mark-scale = 0.7 // scale of the arrowhead (base to tip)
  let r = 0.8 // Radius of the loop
  let fs = 7pt // Font size for math

  let arrow-style = (
    mark: (
      end: "stealth",
      fill: black,
      scale: .5,
      angle: 50deg,
      length: marklen,
      width: .25,
    ),
  )

  let mark-arrow-style = (
    symbol: "stealth",
    fill: blue-unir,
    stroke: .7pt + blue-unir,
    width: .5,
    length: marklen,
    angle: 60deg,
    scale: mark-scale,
  )

  let linemidmark(x1, y1, x2, y2, lname) = {
    line((x1, y1), (x2, y2), name: lname, stroke: blue-unir)
    let angl = calc.atan2(x2 - x1, y2 - y1)
    let xmark = (x1 + x2) / 2 + marklen * calc.cos(angl)
    let ymark = (y1 + y2) / 2 + marklen * calc.sin(angl)
    mark((xmark, ymark), (x2, y2), ..mark-arrow-style)
  }

  let rel-mom-arrow(len, obj, anchor, name) = {
    for i in range(2) {
      let start = (name: obj, anchor: "start")
      difpose.at(i) = (
        (name: obj, anchor: "start").at(i) - (name: obj, anchor: "end").at(i)
      )
    }
    let centroid = (name: obj, anchor: "start")
    let Dx = difpos.at(0)
    let Dy = difpos.at(1)
    let angl = calc.atan2(Dx, Dy)
    let start = centroid + (+len * calc.cos(angl), +marklen * calc.sin(angl))
    let end = centroid + (-len * calc.cos(angl), -marklen * calc.sin(angl))
    line(start, end, ..arrow-style, anchor: anchor, name: name, padding: 5pt)
    content((rel: (-0, 0.3), to: "p1"), $p$)
  }

  linemidmark(-2, 0, -3, 1, "e+1")
  linemidmark(-3, -1, -2, 0, "e-1")
  linemidmark(3, 1, 2, 0, "e+2")
  linemidmark(2, 0, 3, -1, "e-2")

  decorations.wave(
    line((-2, 0), (-r, 0)),
    amplitude: 0.2,
    segments: 3,
    stroke: blue-unir,
    name: "photon1",
  )
  decorations.wave(
    line((r, 0), (2, 0)),
    amplitude: 0.2,
    segments: 3,
    stroke: blue-unir,
    name: "photon2",
  )
  content("e+1.end", anchor: "north-east", padding: 1pt, $e^(+)$)
  content("e-1.start", anchor: "south-east", padding: 1pt, $e^(-)$)
  content("e+2.start", anchor: "north-west", padding: 1pt, $e^(+)$)
  content("e-2.end", anchor: "south-west", padding: 1pt, $e^(-)$)
  content((-r / 2 - 1, -0.3), $gamma$)
  content((+r / 2 + 1, -0.3), $gamma$)
  circle((0, 0), radius: r, fill: white, name: "loop", stroke: blue-unir)
  for pos in (0.25, 0.75) {
    let angle = pos * 360
    // Between base and tip
    let angle-difference = 2 * calc.asin(marklen * mark-scale / (2 * r))
    // Add arrow marks
    mark(
      symbol: "stealth",
      anchor: "base",
      (name: "loop", anchor: (angle) * 1deg),
      (name: "loop", anchor: angle * 1deg + angle-difference),
      ..mark-arrow-style,
    )
  }
})

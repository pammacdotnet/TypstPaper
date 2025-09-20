#let data = (
  // "RUNOFF": (1964, 1980), // https://en.wikipedia.org/wiki/TYPSET_and_RUNOFF
  "Runoff": (1964, 1980), // https://en.wikipedia.org/wiki/TYPSET_and_RUNOFF
  // "troff": (1973, 1989), // https://www.troff.org/history.html
  "Troff": (1973, 1989), // https://www.troff.org/history.html
  "TeX": (1978, 2025), // https://en.wikipedia.org/wiki/TeX
  "LaTeX": (1984, 2025), // https://en.wikipedia.org/wiki/LaTeX
  "SGML": (1986, 2000), // https://en.wikipedia.org/wiki/Standard_Generalized_Markup_Language
  "ConTeXt": (1990, 2025), // https://en.wikipedia.org/wiki/ConTeXt
  "TrueType": (1991, 2025), // https://en.wikipedia.org/wiki/TrueType
  "HTML": (1993, 2025), // https://en.wikipedia.org/wiki/HTML
  "CSS": (1996, 2025), // https://en.wikipedia.org/wiki/CSS
  "XML": (1998, 2025), // https://en.wikipedia.org/wiki/CSS
  "Markdown": (2004, 2025), // https://en.wikipedia.org/wiki/Markdown
  "Typst": (2023, 2025), // https://en.wikipedia.org/wiki/Draft:Typst
)

#import "@preview/lilaq:0.4.0" as lq

#show: lq.cond-set(lq.grid.with(kind: "y"), stroke: none)
#show: lq.cond-set(lq.grid.with(kind: "x"), stroke: 0.3pt + black)
// #show: lq.cond-set(lq.tick.with(kind: "x"), outset: 0pt)
// #show: lq.cond-set(lq.tick.with(kind: "y"), inset: 0pt, outset: 0pt)
// #show lq.selector(lq.tick.with(kind: "y")): lq.set-tick(inset: 0pt, outset: 0pt)
// #show: lq.show_(lq.tick.with(kind: "y"), it => none)
// #show lq.selector(lq.tick.with(kind: "y")): none
#show: lq.set-tick(
  kind: "y",
  inset: 0pt,
  outset: 3pt,
  shorten-sub: 75%,
  stroke: 0.3pt + black,
)
#show: lq.set-diagram(
  width: 8.1cm,
  height: 3cm,
  ylim: (0.5, data.len() + 0.5),
  yaxis: (
    subticks: none,
    mirror: false,
    stroke: 0.3pt + black,
    ticks: data
      .keys()
      .map(std.rotate.with(-15deg, origin: right + horizon))
      .enumerate(start: 1),
  ),
  xaxis: (
    subticks: none,
    mirror: false,
    stroke: none,
    ticks: range(1960, 2021, step: 10).map(n => (n, [#n])),
  ),
)
#set text(9pt)
#show lq.selector(lq.tick-label): set text(0.7em, font: "Liberation Sans")

#lq.diagram(
  lq.hbar(
    data.values().map(x => x.last()),
    range(1, data.len() + 1),
    base: data.values().map(x => x.first()),
    width: (0.9,) * data.len(),
  ),
)

// #pad(left: 0.35cm, block(width: 8cm, image("typesetting systems.svg", width: 99%)))

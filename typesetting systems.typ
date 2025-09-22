#import "@preview/lilaq:0.5.0" as lq

// When each piece of software was first released, and when it stopped updating.
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

#set text(9pt) // For development-only.
#show: lq.cond-set(lq.grid.with(kind: "y"), stroke: none)
#show: lq.cond-set(lq.grid.with(kind: "x"), stroke: 0.3pt + black)
#show lq.selector(lq.tick-label): set text(0.7em, font: "Liberation Sans")
#show: lq.set-tick(
  kind: "y",
  inset: 0pt,
  outset: 3pt,
  shorten-sub: 75%,
  stroke: 0.3pt + black,
)
#show: lq.set-diagram(
  width: 100%,
  yaxis: (subticks: none, mirror: false, stroke: 0.3pt + black),
  xaxis: (subticks: none, mirror: false, stroke: none),
)

#let year = (
  min: calc.min(..data.values().flatten()),
  max: calc.max(..data.values().flatten()),
)
#(year.min-10 = int(year.min / 10) * 10) // Round to 10s.
#lq.diagram(
  height: data.len() * 2.5mm,
  xlim: (year.min-10, year.max),
  ylim: (-0.5, data.len() - 0.5),
  yaxis: (
    ticks: data
      .keys()
      .map(rotate.with(-15deg, origin: right + horizon))
      .enumerate(start: 1),
  ),
  xaxis: (ticks: range(year.min-10, year.max, step: 10).map(n => (n, [#n]))),
  lq.hbar(
    data.values().map(x => x.last()), // Last update year.
    range(data.len()), // Y-axis linear position.
    base: data.values().map(x => x.first()), // Initial release year.
    width: (0.9,) * data.len(),
  ),
)

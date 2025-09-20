#import "@preview/lilaq:0.5.0" as lq
#let (x, y) = lq.load-txt(read("data.csv"))
#lq.diagram(
  width: 100%, height: 25mm,
  lq.plot(x, y, stroke: 2pt),
)

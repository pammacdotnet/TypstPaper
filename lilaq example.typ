#import "@preview/lilaq:0.2.0" as lq
#let (x, y) = lq.load-txt(read("data.csv"))
#show lq.selector(lq.diagram): set text(.9em)
#lq.diagram(lq.plot(x, y), width: 2.7cm, height: 2.2cm)

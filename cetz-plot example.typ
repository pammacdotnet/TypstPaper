#import "@preview/cetz-plot:0.1.3": *
#import "@preview/cetz:0.4.2"
#set text(weight: "bold")
#let colors = (
  blue, aqua, teal,
).map(c => c.lighten(30%))
#cetz.canvas(smartart.cycle.basic(
  ([Reduce], [Reuse], [Recycle]),
  step-style: colors,
  radius: 1.4,
))

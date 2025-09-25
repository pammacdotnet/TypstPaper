#import "@preview/cetz:0.3.4"
#import "@preview/cetz-venn:0.1.3": *
#let myblue = rgb("#94e3ff")
#cetz.canvas(length: 0.84cm, {
  import cetz.draw: *
  rotate(90deg)
  venn2(name: "venn", a-fill: myblue, ab-fill: rgb("#d8f5ff"))
  content("venn.a", [A])
  content("venn.b", [B])
})

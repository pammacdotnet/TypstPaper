#import "@preview/ijimai:2.0.0": blue-unir, blue-unir-soft
#import "@preview/cetz:0.4.2"

#set text(font: "Liberation Sans")
#set table(fill: blue-unir-soft, stroke: 0.5pt, inset: 0.6em)

#let item(..nums) = table(columns: nums.pos().len(), ..nums.pos().map(str))

#cetz.canvas({
  import cetz.draw: *
  import cetz.tree
  let edge-color = rgb("#0300bc")
  set-style(line: (
    stroke: blue-unir,
    mark: (end: (symbol: "stealth", scale: 0.5, fill: edge-color)),
  ))
  tree.tree(name: "t", spread: 0.8, grow: 0.5, (
    item(77, 15, 5, 32, 1, 12),
    (
      item(77, 15, 5),
      (item(77), item(77)),
      (
        item(15, 5),
        item(15),
        item(5),
      ),
    ),
    (
      item(32, 1, 12),
      (
        item(32, 1),
        item(32),
        item(1),
      ),
      (item(12), item(12)),
    ),
  ))
})

#import "@preview/ijimai:3.0.0": blue-unir, blue-unir-soft
#import "@preview/cetz:0.4.2"

#set text(font: "Liberation Sans")
#set table(fill: blue-unir-soft, stroke: 0.5pt, inset: 0.6em)

#let item(..nums) = table(columns: nums.pos().len(), ..nums.pos().map(str))

#cetz.canvas({
  import cetz.draw: *
  import cetz.tree
  let edge-color = rgb("#0300bc")
  let arrow-style = (symbol: "stealth", scale: 0.5, fill: edge-color)
  set-style(line: (stroke: blue-unir, mark: (end: arrow-style)))
  tree.tree(name: "divide", spread: 0.8, grow: 0.5, (
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
  // set-style(line: (mark: (end: none, start: arrow-style)))
  // get-ctx(ctx => {
  //   import cetz.coordinate: *
  //   let (ctx, top, bottom) = resolve(ctx, "divide.north", "divide.south")
  //   let (ctx, second) = resolve(ctx, "divide.0-0")
  //   let height = bottom.at(1) - top.at(1)
  //   let h1 = second.at(1) - top.at(1)
  //   let layers = height / h1
  //   let spread = 1.35
  //   set-origin((1.35 - spread, bottom.at(1) + (layers - 0.5) * h1))
  //   tree.tree(name: "merge", direction: "up", spread: spread, grow: 0.5, (
  //     item(1, 5, 12, 15, 32, 77),
  //     (
  //       item(5, 15, 77),
  //       item(77),
  //       item(5, 15),
  //     ),
  //     (
  //       item(1, 12, 32),
  //       item(1, 32),
  //       item(12),
  //     ),
  //   ))
  // })
  // set-style(line: (mark: (end: arrow-style, start: none)))
  // let connect(a, b, y: 0.3) = line((rel: (0, -y), to: a), (rel: (0, y), to: b))
  // connect("divide.0-0-0-0", "merge.0-0-0")
  // connect("divide.0-0-1-0", "merge.0-0-1")
  // connect("divide.0-0-1-1", "merge.0-0-1")
  // connect("divide.0-1-0-0", "merge.0-1-0")
  // connect("divide.0-1-0-1", "merge.0-1-0")
  // connect("divide.0-1-1-0", "merge.0-1-1")
})

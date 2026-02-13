#import "@preview/ijimai:2.0.0": blue-unir
#import "@preview/matofletcher:0.1.1": *

#diagram(
  spacing: (2mm, 5mm),
  node-stroke: 1pt,
  edge-stroke: 1pt + blue-unir,
  node-inset: 0.1em,
  edge-corner-radius: 0pt,
  mark-scale: 70%,
  {
    import fletcher.shapes: *
    let height = 6mm
    let node-style = (width: height * 2, height: height)
    node = node.with(..node-style)
    edge = edge.with(marks: (none, "|>"))
    let angle-edge(a, b, right: true, ..args) = {
      let angle = if right { "-|" } else { "|-" }
      edge(a, (a, angle, b), b, ..args)
    }
    let zig-zag-edge(a, b) = edge(a, "d", ((), "-|", b), b)
    let flowchart-placer = placer((0, 1), (1, 0))
    let patch-nodes(args) = {
      let (pos, nodes) = args
      nodes = nodes.map(n => n.with(..node-style))
      (pos, nodes)
    }
    let place-new-nodes(..args) = {
      patch-nodes(place-nodes(..args, flowchart-placer))
    }
    let place-answers(spread: 1, dy: 1, ..args) = {
      let placer = placer((1, dy), (-1, dy))
      patch-nodes(place-nodes(..args, spread: spread, placer))
    }
    let place-node(pos, dx, dy) = {
      patch-nodes(place-nodes(pos, 1, placer((dx, dy))))
    }
    let r = (0, 0)
    node(r, shape: pill)[start]
    let ((read-pos,), (read,)) = place-new-nodes(r, 1)
    edge()
    read(shape: parallelogram)[`read` \ `a, b, c`]
    edge()
    let ((q-pos,), (question,)) = place-new-nodes(read-pos, 1)
    question(shape: diamond)[`a > b`]
    let ((yes-pos, no-pos), (yes, no)) = place-answers(q-pos, 2, spread: 1.8)
    angle-edge(q-pos, yes-pos, label: [yes])
    yes(shape: diamond)[`a > c`]
    angle-edge(q-pos, no-pos, label: [no])
    no(shape: diamond)[`b > c`]
    let old-q-pos = q-pos
    let old-no-pos = no-pos
    q-pos = yes-pos
    let ((yes-pos1, no-pos1), (yes, no)) = place-answers(q-pos, 2)
    angle-edge(q-pos, yes-pos1, label: [yes])
    yes[`max = a`]
    angle-edge(q-pos, no-pos1, label: [no])
    no[`max = c`]
    q-pos = old-no-pos
    let ((yes-pos2, no-pos2), (yes, no)) = place-answers(q-pos, 2)
    angle-edge(q-pos, yes-pos2, label: [yes])
    yes[`max = b`]
    angle-edge(q-pos, no-pos2, label: [no])
    no[`max = c`]
    let ((print-pos,), (print,)) = place-node(old-q-pos, 0, 4)
    zig-zag-edge(no-pos1, print-pos)
    zig-zag-edge(yes-pos1, print-pos)
    zig-zag-edge(no-pos2, print-pos)
    zig-zag-edge(yes-pos2, print-pos)
    print(shape: parallelogram)[`print max`]
    let (_, (end,)) = place-new-nodes(print-pos, 1)
    edge()
    end(shape: pill)[end]
  },
)

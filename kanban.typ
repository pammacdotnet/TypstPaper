// SPDX-FileCopyrightText: Copyright (C) 2025 Andrew Voynov
//
// SPDX-License-Identifier: AGPL-3.0-only

#let zip-excessive(grid: (:), ..arrays) = {
  arrays = arrays.pos()
  let max-array-len = calc.max(..arrays.map(x => x.len()))
  // array.zip(..arrays.map(arr => arr + (none,) * (max-array-len - arr.len())))
  arrays
    .map(arr => arr + (none,) * (max-array-len - arr.len()))
    .map(x => std.grid(..grid, ..x))
}

#let kanban-item(hardness, priority, stroke: 0.05em, height: auto, ..args) = {
  let assignee
  let name
  if args.pos().len() == 1 {
    name = args.pos().first()
  } else {
    (assignee, name) = args.pos()
  }
  let rect(fill: gray.darken(50%), color: white, body) = std.rect(
    fill: fill,
    inset: (bottom: 0.3em, rest: 0.2em),
    radius: 0.2em,
    text(color, body),
  )
  assignee = if assignee != none { rect.with(assignee) } else { (..a) => none }
  let stroke = if type(stroke) == color { std.stroke(stroke + 0.05em) } else {
    std.stroke(stroke)
  }
  let left-stroke = std.stroke(
    paint: stroke.paint,
    thickness: stroke.thickness + 0.5em,
    cap: stroke.cap,
    join: stroke.join,
    dash: stroke.dash,
    miter-limit: stroke.miter-limit,
  )
  grid.cell(
    box(
      stroke: (left: left-stroke, rest: stroke),
      inset: (left: stroke.thickness / 2),
      fill: stroke.paint,
      radius: 0.3em,
      box(
        width: 100%,
        height: height,
        fill: white,
        stroke: (rest: stroke),
        inset: 0.5em,
        radius: 0.3em,
        align(
          horizon,
          stack(
            spacing: 0.5em,
            name,
            stack(
              dir: ltr,
              spacing: 0.5em,
              rect(fill: aqua.darken(20%), hardness),
              rect(fill: green.lighten(10%), priority),
              assignee(fill: blue),
            ),
          ),
        ),
      ),
    ),
  )
}

#let kanban-column(name, color: auto, ..items) = {
  (name: name, color: color, items: items.pos())
}

#let kanban(
  width: 100%,
  item-spacing: 0.5em,
  leading: 0.5em,
  font-size: 1em,
  font: (),
  ..args,
) = {
  let cols = args.pos()
  let column-colors = cols.map(x => x.color)
  let column-names = cols
    .enumerate()
    .map(((i, x)) => table.cell(
      stroke: (bottom: stroke(paint: cols.at(i).color, thickness: 1pt)),
      align: left,
      inset: (bottom: 0.5em, rest: 0pt),
      [#x.name (#cols.at(i).items.len())],
    ))
  let column-items = cols.map(x => x.items)
  set text(size: font-size, font: font)
  set par(leading: leading)
  block(
    width: width,
    table(
      columns: (1fr,) * cols.len(),
      stroke: none,
      column-gutter: 1.5em,
      inset: 0pt,
      row-gutter: item-spacing,
      table.header(..column-names),
      ..zip-excessive(
        grid: (row-gutter: item-spacing),
        ..column-items,
      ).flatten(),
    ),
  )
}

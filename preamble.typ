#import "@preview/codly:1.3.0": codly, codly-init, local as codly-local
#import "@preview/codly-languages:0.1.8": codly-languages
#import "@preview/ijimai:3.0.0": blue-unir, blue-unir-soft, ijimai, read-raw
#import "@preview/metalogo:1.2.0"

#let settings(doc) = {
  set par(justification-limits: (tracking: (min: -0.01em, max: 0.005em)))
  show bibliography: set par(
    justification-limits: (tracking: (min: -0.025em, max: 0em)),
  )

  // References to floating figures point to wrong location
  // https://github.com/typst/typst/issues/4359#issuecomment-3564926925
  show figure: it => {
    if it.placement == none { return it }

    // Re-wrap placed figures to include metadata containing
    // the body's location.
    place(it.placement, float: true, scope: it.scope, block(width: 100%, {
      let fields = it.fields()
      _ = fields.remove("scope")
      let body = fields.remove("body")
      let label = fields.remove("label")
      let counter = fields.remove("counter")

      // Need to step back to keep the same number in the new figure.
      counter.update(n => n - 1)

      let meta = context metadata((
        figure-location: it.location(),
        body-location: here(),
      ))

      figure(meta + body, ..fields, placement: none)
    }))
  }

  show ref: it => {
    let fig = it.element
    if fig == none { return it }
    if fig.func() != figure { return it }
    if fig.numbering == none { return it }
    if fig.placement == none { return it }

    // Rebuild reference from scratch.
    let num = numbering(fig.numbering, ..fig.counter.at(fig.location()))
    let supplement = (if it.supplement == auto { fig } else { it }).supplement
    if supplement not in (text(""), [], none) { supplement += [~] }

    // Use location of figure's body for linking.
    let location = query(metadata)
      .find(data => (
        type(data.value) == dictionary
          and data.value.at("figure-location", default: none) == fig.location()
      ))
      .value
      .body-location

    link(location, [#supplement#num])
  }

  show: ijimai.with(
    config: toml("paper.toml"),
    bibliography: "bibliography.yaml",
    read: path => read-raw(path),
  )

  set document(
    description: [The paper source code is available at
      https://github.com/pammacdotnet/TypstPaper and
      https://typst.app/project/rCbyFps722cFtqa8mf84oT.],
  )
  set text(fallback: false, font: (
    "Libertinus Serif",
    "Noto Serif CJK SC",
    "Noto Naskh Arabic UI",
    "Noto Color Emoji",
  ))
  set scale(reflow: true)

  show: codly-init
  // Add note about Noto Color Emoji being bad and glyphs not being centered,
  // or use another one.
  show raw: set text(font: (
    "Fira Code",
    "Noto Sans Mono CJK SC",
    "Kawkab Mono",
    "Noto Color Emoji",
    "New Computer Modern Math",
  ))
  show raw.where(block: true): set text(size: 6.5pt)
  show raw: it => {
    show emph: set text(font: "Fira Mono")
    it
  }
  show raw.where(block: true): set par(justify: false, leading: 0.5em)
  // Respect page margins when border stroke is not zero
  // https://github.com/Dherse/codly/issues/107
  show raw.where(block: true): pad.with(1pt / 2)
  codly(
    zebra-fill: blue-unir-soft,
    number-align: right + horizon,
    number-format: none,
    stroke: stroke(blue-unir),
    languages: codly-languages,
    lang-inset: 0.23em,
    lang-radius: 0.15em,
    lang-outset: (x: 0.29em, y: 0.025em),
    inset: 2pt,
  )

  // Numbering equations in this paper does not make much sense, because a lot of
  // them are inside a figure and might not have enough space for additional
  // numbering. The rest might be in equation-based example but not actually an
  // equation. Lastly, since all of them are part of some example, they are never
  // directly referenced.
  set math.equation(numbering: none)
  show math.equation: set text(font: (
    "New Computer Modern Math",
    "Noto Color Emoji",
  ))

  // Thicker table (v)line becomes longer and exceeds the table bounds/borders
  // https://github.com/typst/typst/issues/4416#issuecomment-3369145808
  show table: it => {
    if it.stroke == none { return it }
    let thickness = it.stroke.thickness
    if thickness == auto { thickness = 1pt }
    set block(clip: true, outset: thickness / 2)
    show table.cell: set block(clip: false)
    show: pad.with(thickness / 2)
    it
  }

  doc
}

#let no-lang = codly-local.with(lang-format: none)
#let line-num = codly-local.with(number-format: n => [#n])
#let name-lang = codly-local.with(lang-format: (name, icon, color) => {
  let b = measure(name)
  box(
    radius: 0.15em,
    fill: color.lighten(80%),
    inset: 0.23em,
    stroke: color + 0.5pt,
    outset: 0pt,
    height: b.height + 0.33em + 0.33em,
    name,
  )
})

// Make text in table header bold. Only applied to first table row.
// Using a global show rule will affect other figures.
#let bold-header(table) = {
  show std.table.cell.where(y: 0): strong
  table
}

// Both looks good/correct only with bold font.
// Buenard font for some reason makes text jump high, hence the `baseline` fix.
// See https://github.com/typst/typst/issues/6769.
#let LaTeX = text(font: "New Computer Modern")[*#metalogo.LaTeX*]
#let typst = text(font: "Buenard", baseline: -0.04em, rgb("#229cac"))[*typst*]

// https://github.com/typst/typst/blob/563c8d3659e80eff6ffbea5a5a4c75115cf733da/crates/typst-library/src/text/raw.rs#L964
#let typst-blue = rgb("#4b69c6")
#let typst-cyan = rgb("#1d6c76")
#let typst-purple = rgb("#8b41b1")

/// Automatically detect language via the file extension.
#let code-block(file) = {
  raw(read(file), lang: file.split(".").last(), block: true)
}

#let code-grid(typ-file, gutter: 0.5em, left-column: 1fr) = {
  let typ = read(typ-file)
  let columns = if left-column == none { () } else { (left-column, 1.0fr) }
  let align = if left-column == none { left } else { horizon }
  grid(
    columns: columns,
    align: align,
    gutter: gutter,
    raw(typ, lang: "typ", block: true), text(size: 7.5pt, include typ-file),
  )
}

// Used with figures that have white background and do not have clear
// visual dimensions.
#let frame(..args) = pad(0.05em / 2, rect(stroke: 0.05em, ..args))
#let frame-round(..args) = {
  pad(0.05em / 2, block(stroke: 0.05em, clip: true, radius: 0.3em, ..args))
}

#let universe-url(package) = {
  "https://typst.app/universe/package/" + lower(package)
}
#let package-link(name) = box(link(universe-url(name), name))
#let api-link(path, ..name) = {
  box(link("https://typst.app/docs/reference/" + path, ..name))
}
#let github-url(user-repo) = "https://github.com/" + user-repo
#let issue(number, body) = {
  link(github-url("typst/typst/issues/" + str(number)), body)
}
#let github-link(user-repo, name) = box(link(github-url(user-repo), name))
#let ctan-link(package-name) = {
  box(link("https://ctan.org/pkg/" + lower(package-name), package-name))
}

/// Useful for removing huge spacing in table cells.
#let unjustify(hyphenate: true, body) = {
  set par(justify: false)
  set text(hyphenate: hyphenate)
  body
}

/// Useful when unjustified table cell spans more lines than justified one.
#let justify(body) = {
  set par(justify: true)
  body
}

/// Change (decrease) font size not only for markup text, but also for raw one.
#let raw-size(size, body) = {
  set text(size)
  show raw: set text(size)
  body
}

#let mathbf(input) = $upright(bold(input))$

#import "@preview/touying:0.5.3": config-page, themes.metropolis, utils
#import metropolis: metropolis-theme

#let place-typst-guy(
  guy: none,
  dx: auto,
  dy: auto,
  align: left + top,
  y-offset,
) = context {
  let dy = if dy == auto { here().position().y - 0.3em } else { dy }
  let dx = if dx == auto { -0.3em } else { dx }
  place(align, dx: dx, dy: dy + y-offset, guy)
}

#let get-max-size(code, size) = {
  let measure = measure.with(width: size.width, height: size.height)
  let a = measure(code)
  let b = measure(eval(code.text, mode: "markup"))
  let max-width = calc.max(a.width, b.width)
  let max-height = calc.max(a.height, b.height)
  (width: max-width, height: max-height)
}

#let center-block(body) = {
  set align(center)
  block({
    set align(left)
    body
  })
}

#let layout-example(result-size: auto, ..args, body) = {
  let delimiter-line = line.with(stroke: (thickness: 0.03em, dash: "dashed"))
  let font-size = args.pos().find(x => type(x) == length)
  set stack(spacing: 1em)
  set text(font-size) if font-size != none
  let code = body.children.find(child => child.func() == raw)
  layout(size => {
    let (width, height) = get-max-size(code, size)
    let wrapper = it => align(left, block(
      width: result-size.first(),
      height: result-size.last(),
      it,
    ))
    center-block(stack(
      code,
      delimiter-line(length: height, angle: 90deg),
      wrapper(eval(code.text, mode: "markup")),
      dir: ltr,
    ))
  })
}

#let template(doc) = {
  show: metropolis-theme.with(config-page(margin: (x: 0pt)))
  show raw: set text(font: "Fira Code")
  show raw: set text(0.95em)
  set text(26pt, font: "Liberation Sans")
  doc
}

#show: template

#utils.last-slide-counter.update(34)
#utils.slide-counter.update(32)

== _Advanced_ styling
#place-typst-guy(
  guy: scale(x: -100%, image("./typst-guy-scientist.png")),
  align: bottom + center,
  dx: 25%,
  dy: 13.3mm,
  0pt,
)

#let example-code = ````typ
#let rgb-lin-grad = gradient.linear(..color.map.rainbow)
#let rgb-con-grad = gradient.conic(..color.map.rainbow)
#let w = 3cm; #set rect(width: w, height: w); #set circle(radius: w / 2)
#rect(width: 100%, height: 1cm, fill: rgb-lin-grad.sharp(5, smoothness: 20%))
#set square(size: 2cm)
#set circle(radius: 1cm)
#stack(dir: ltr, spacing: 1fr,
  square(inset: 0.5em, radius: 0.5em, stroke: rgb-con-grad + 2pt, lorem(3)),
  square(fill: gradient.radial(..color.map.rainbow)),
  circle(fill: gradient.radial(..color.map.magma)),
  circle(fill: gradient.conic(..color.map.magma, center: (20%, 30%))),
  circle(fill: gradient.radial(aqua, white).repeat(4)),
)
#set text(fill: gradient.linear(red, blue))
#set par(justify: true)
#lorem(28)
#let side = 10pt; #let diag = side * calc.sqrt(2)
#let rgb-cube-pattern = tiling(size: (diag, diag), place(
    dx: (diag - side) / 2,
    dy: (diag - side) / 2,
    rotate(45deg, square(size: side, fill: rgb-con-grad)),
))
#align(center, rect(width: 100%, height: diag * 5, fill: rgb-cube-pattern))
#set text(2em)
#let RGB-3D(content) = {
  let rgb-content = text(3em, fill: rgb-lin-grad, content)
  box({
    for n in range(15) {
      place(dx: 0.3pt + 0.3pt * n, dy: -0.3pt + -0.3pt * n, rgb-content)
    }
    text(stroke: black + 0.5pt, rgb-content)
  })
}
This is a gradient on text, but with a #RGB-3D[twist!]
````

#[
  #show: layout-example.with(result-size: (11.5cm, auto), 0.39em)
  #example-code
]

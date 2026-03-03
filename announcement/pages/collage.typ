#let version = sys.inputs.at("version", default: "forum")
#assert(version in ("forum", "discord"))

#let backgrounds = (
  "forum": rgb("#e4e5ea"),
  "discord": rgb("#323339"),
)

#set page(width: auto, height: auto, margin: 0pt, fill: backgrounds.at(version))
#grid(
  columns: 3,
  gutter: 1cm,
  image("page01.png"), image("page06.png"), image("page10.png"),
)

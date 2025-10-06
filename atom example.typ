#import "@preview/atomic:1.0.0": atom
#let atom = atom.with(
  color: rgb("#eaf6fd"),
  orbitals: 0.7,
  center: 0.4,
  step: 0.34)
#atom(8, 16, "O", (2, 6))

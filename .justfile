alias c := compile
alias w := watch

compile:
  typst compile --ignore-system-fonts --font-path fonts paper.typ

watch:
  typst watch --ignore-system-fonts --font-path fonts paper.typ

#import "@preview/diagraph:0.3.6": raw-render
#raw-render(```dot
digraph G {
  rankdir=TD
  LaTeX -> typst
  LaTeX[color=gray, fontname="New Computer Modern", fontsize=18, fontcolor=lightblue]
  typst[color=DodgerBlue, fontname="Buenard", fontsize=18, fontcolor=royalblue]
}
```)

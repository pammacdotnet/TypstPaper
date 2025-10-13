#import "@preview/neoplot:0.0.3" as gp
#gp.exec(```gnuplot
set terminal svg font "Fira Math, 34" size 700,930
set size ratio 2
set border 0
set xzeroaxis linetype 0 linewidth 2
set xtics axis
set xrange [-3:3]
set yrange [-1:9]
set yzeroaxis linetype 0 linewidth 2
set margins 5,5,0,0
plot x**2 lw 6 lc 3 title 'x^2'```)

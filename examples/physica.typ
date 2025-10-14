#import "@preview/physica:0.9.5": *
$
  curl (grad f), tensor(T, -mu, +nu), pdv(f, x, y, [1,2]) \
  H(f) = hmat(f; x, y; delim: "[", big: #true) \
  arrow.l quad arrow.long quad chevron.l.double \
  arrow.r quad arrow.l.long.squiggly
$
The Ehrenfest theorem is:
$
  d/(d t) expval(A) = 1/(i hbar) expval([A, H]) + expval(delta A/(delta t))
$

function Lx = newtonInterpolation(nodes, values, x)
  % x = the points where we compute L
  % L is the lagrange polynomial
  table = lab4OnZoom(nodes, values);
  Lx = x;
  for i = 1:length(x)
    prods = [1 cumprod(x(i) - nodes(1:end-1))];
    Lx(i) = table(1, :) * prods';
  endfor
endfunction

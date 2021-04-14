function table=lab4OnZoom(nodes, values)
  % nodes: x1,...,xn
  % values: f(x1),...,f(xn)
  % table: divided differences
  n = length(nodes);
  table = NaN(n);
  table(:, 1) = values';
  for j = 2:n
    table(1:n-j+1, j) = diff(table(1:n-j+2, j-1))./...
    (nodes'(j:n) - nodes'(1:n-j+1));
  endfor
endfunction

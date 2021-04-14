function lab4problem4
  %sqrt(115); precision = 10^-3
  nodes = [64 100 144];
  values = [8 10 12];
  aitken(nodes, values, 115)
endfunction

% use the formula with the determinant - not sure how it goes
function result = aitken(x, f, x1)
  n = length(x);
  D = x1 - x;
  A(:,1) = f;
  for i = 2:n
      for j = 2:i
          A(i,j) = (D(j-1) * A(i,j-1) - D(i) * A(j-1,j-1)) / (x(i) - x(j-1));
      end
  end 
  result = A(n, n);
endfunction

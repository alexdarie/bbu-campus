function lab4problem1
  nodes = [1 1.5 2 3 4];
  values = [0 0.17609 0.30103 0.47712 0.60206];
  newtonInterpolation(nodes, values, [2.5 3.25])
  
  % maximum interpolation error with 
  % E = max|f(yi) - (N4f)(yi)|
  f = @(x) log10(x); numbers = [];
  for i = 10:35
    numbers = [numbers i/10];
  endfor
  
  % apply log on them
  vals = f(numbers);
  nVals = newtonInterpolation(nodes, values, numbers);
  
  % maximum of vector's absolute difference
  printf("Maximum absolute value: ");
  max(abs(nVals-vals))
endfunction

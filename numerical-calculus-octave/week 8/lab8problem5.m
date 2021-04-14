function lab8problem5
  f = @(x) 1./(4+sin(20*x));
  a = 0; b = pi;
  repsim(f, a, b, 10)
  repsim(f, a, b, 15)
endfunction

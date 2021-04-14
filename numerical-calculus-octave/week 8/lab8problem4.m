function lab8problem4
  f = @(x) x.*log(x);
  a = 1; b = 2; n = 10;
  printf("Should be: 0.636294... ");
  reptrap(f, a, b, n)
endfunction

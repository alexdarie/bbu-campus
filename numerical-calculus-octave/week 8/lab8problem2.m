function lab8problem2
  f = @(x,y) log(x + 2*y);
  printf("Trapezium formula: [given result 0.4295545]");
  doubletrap(f, 1.4, 2, 1, 1.5)
endfunction

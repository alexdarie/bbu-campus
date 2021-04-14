function lab8problem3
  constant_val = 60 * 110 / (110^2 - 75^2);
  c = (75/110)^2;
  f = @(x) (1 - c .* sin(x)) .^ (1 / 2);

  printf("Repeated trapezium formula [3]: ");
  constant_val * reptrap(f, 0, 2*pi, 3)
  
  printf("Repeated trapezium formula [4]: ");
  constant_val * reptrap(f, 0, 2*pi, 4)
  
  printf("Repeated trapezium formula [12]: ");
  constant_val * reptrap(f, 0, 2*pi, 12)
endfunction


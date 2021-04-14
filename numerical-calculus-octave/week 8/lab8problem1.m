function lab8problem1
  % approx. f(x) = 2/(1+x^2)
  clf; hold on; grid on; 
  set(gca,'FontSize',15);
  
  f = @(x) 2 ./ (1 + x.^ 2);
  fplot(f, [0 1]);
  
  x = [0 0 1 1];
  y = [0 f(0) f(1) 0];
  scatter(x, y, 'filled');
  plot(x, y, "LineWidth", 2);
  
  n = 10; a = 0; b = 1;
  printf("Trapezium formula: ");
  reptrap(f, a, b, n)
  
  printf("Simpson's formula: ");
  repsim(f, a, b, n)
  
  printf("Built in function: ");
  quad(f, a, b)
endfunction

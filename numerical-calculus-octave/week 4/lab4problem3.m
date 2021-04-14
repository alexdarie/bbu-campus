function lab4problem3
  clf; hold on; grid on;
 
  % 13 equidistant points
  points = linspace(0, 6, 13);
  
  f = @(x) exp(x).^sin(x);
  fplot(f, [0 6]);
  
  int_points = [0 1 1.2 3 3.6 4 4.8 5.4];
  int_values = arrayfun(f, int_points);
  vls = newtonInterpolation(points, f(points), int_points);
  
  scatter(int_points, vls, 'filled');
  plot(int_points, vls);
  legend("f", "Newton");
endfunction

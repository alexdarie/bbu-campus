function lab3problem3
  clf; grid on; hold on;
  f = @(x) (1 + cos(pi.*x)) ./ (1+x);
  fplot(f, [0 10]);
  
  % create a vector with 21 equally spaced values between 0 and 10
  x = linspace(0, 10, 21);
  
  % apply the function over those values
  y = arrayfun(f, x);
  
  % create a vector with more points 
  points = linspace(0, 10, 200);
  
  % get the LIP's solution with the Barycentric optimization
  ypoints = LagrangeBary2(x, y, points);
  
  % plot the interpolation over the initial points
  plot(points, ypoints);
endfunction

%lab3problem3

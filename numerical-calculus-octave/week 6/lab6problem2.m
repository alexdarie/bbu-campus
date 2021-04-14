function lab6problem2
  axis equal; clf;
  axis([0 2 0 1]);
  grid on; hold on;
  set(gca, "FontSize", 15);
  
  % Get 7 points by drawing
  [x y] = ginput(1); X=x; Y=y;
  for i = 1:6
    plot(x, y, "o", 'MarkerSize', 10);
    [x, y] = ginput(1);
    X = [X x];
    Y = [Y y];
  endfor
  plot(x, y, "o", 'MarkerSize', 10);
  
  % Plot the spline for these nodes
  % YI = spline (X, Y, XI); 'spline' evaluates the spline at the points XI
  nodes = linspace(0, 1, length(X)); XI = linspace(0, 1, 1000);
  spline_x = spline(nodes, X, XI);
  spline_y = spline(nodes, Y, XI);
  plot(spline_x, spline_y);
endfunction

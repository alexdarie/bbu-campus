function lab4problem2
  nodes = [1 2 3 4 5];
  values = [22 23 25 30 28];
  % 2.5 pounds of fertilizer
  newtonInterpolation(nodes, values, [2.5])
  
  clf; hold on; grid on;
  scatter(nodes, values, 'filled');
  plot(nodes, values);
  
  pxs = linspace(1, 5, 200);
  vals = newtonInterpolation(nodes, values, pxs);
  plot(pxs, vals);
  legend('Nodes', "Newton's Interpolation");
endfunction

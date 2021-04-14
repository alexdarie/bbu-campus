function lab6problem1
  nodes = [0 pi/2 pi 3*pi/2 2*pi];
  values = sin(nodes);
  derivatives = cos(nodes);
  sin(pi/4)
  
  % Evaluate the piecewise polynomial structure PP at the points XI
  natural = spline(nodes, [0 values 0]);
  ppval(natural, pi/4)
  
  % Same but for clamped spine
  clamped = spline(nodes, [derivatives(1) values derivatives(end)]);
  ppval(clamped, pi/4)
endfunction

% Print:
%   sin                  (Pi/4) 
%   cubic natural spline (Pi/4)
%   cubic clamped spline (Pi/4)
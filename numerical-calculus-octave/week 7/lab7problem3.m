function err = lab7problem3(k)
  axis equal; clf;
  axis([0 2 0 1]);
  xticks(0:0.1:2);
  grid on; hold on;
  set(gca, "FontSize", 15);
  
  % Get 7 points by drawing
  [x y] = ginput(1); X=x; Y=y;
  while ~isempty([x,y])
    plot(x, y, "o", 'MarkerSize', 10);
    [x, y] = ginput(1);
    X = [X x];
    Y = [Y y];
  endwhile

  coefs_lsq = polyfit(X, Y, k);
  poly_lsq = @(x) polyval(coefs_lsq,x);
  fplot(poly_lsq, [0, 2]);
  legend('off');
  err=norm(Y - poly_lsq(X));
endfunction
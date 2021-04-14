function area = repsim(f, a, b, n)
  h = (b-a)/n;
  
  % range(a+h to b-h with h steps)
  x = a+h:h:b-h;
  
  % range(a+h/2 to b-h/2 with h steps)
  x_mid = a+h/2:h:b-h/2;
  area = h/6*(f(a)+2*sum(f(x))+4*sum(f(x_mid))+f(b));
endfunction

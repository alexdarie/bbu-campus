function area = reptrap(f, a, b, n)
  h = (b-a)/n; 
  
  % range(a+h to b-h with h steps)
  x = a+h:h:b-h;
  
  area = h/2*(f(a)+2*sum(f(x))+f(b));
endfunction

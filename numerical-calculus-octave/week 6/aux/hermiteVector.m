function [v,g]=hermiteVector(nodes,values,der_values,x)
  v=0;
  g=0;
  for i=1:length(x)
    [v(i),g(i)]=hermiteInterp(nodes,values,der_values,x(i));
  endfor
endfunction

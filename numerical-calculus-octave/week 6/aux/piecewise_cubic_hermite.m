function [Hx,der_Hx]=piecewise_cubic_hermite(nodes,values,der_values,x)
  % find x(i) and x(i+1) s.t. x in [x(i), x(i+1)]
  for j=1:length(x)
  i=find(nodes>x(j),1)-1;
  if ~isempty(i)
    [Hx(j),der_Hx(j)]=hermiteInterp([nodes(i) nodes(i+1)],...
  [values(i) values(i+1)],[der_values(i) der_values(i+1)],x(j));
  else
   Hx(j)=values(end);
   der_Hx(j)=der_values(end);
 end
endfor

endfunction

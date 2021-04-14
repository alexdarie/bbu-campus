function [Hx,der_Hx]=hermiteInterp(nodes,values,der_values,x)
  %x=the points where we compute L
  %H is the hermite polynomial
  table=div_diff_double(nodes,values,der_values);
  double_nodes=repelem(nodes,2);
  coefs=table(1,:);
  Hx=coefs(1);
  P=1;
  der_Hx=0;
  der_P=0;
  for k=2:length(coefs)
    der_P=der_P*(x-double_nodes(k-1))+P;
    P=P*(x-double_nodes(k-1));
    Hx=Hx+coefs(k)*P;
    der_Hx=der_Hx+coefs(k)*der_P;
  endfor

endfunction

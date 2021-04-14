function lab8problem6
  constant_val = 2/sqrt(pi);
  f=@(x) exp(-(x.^2));
  
  a=0; b=0.5;
  constant_val * repsim(f,a,b,4)
  constant_val * repsim(f,a,b,10)
endfunction

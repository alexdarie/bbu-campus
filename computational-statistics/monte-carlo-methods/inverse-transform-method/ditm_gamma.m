function A = ditm_gamma(alpha, lambda)  A = 0;  for i = 1 : alpha    A = A + ditm_exp(lambda);  endfor
endfunction

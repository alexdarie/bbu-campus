function X = poisson_special_method(lambda)  U = rand;  X = 0;  while U >= exp(-lambda)    U = U * rand;    X = X + 1;  endwhile
endfunction

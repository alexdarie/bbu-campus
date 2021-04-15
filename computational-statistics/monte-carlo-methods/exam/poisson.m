## Poisson distribution: 'a' represents a materialization of the random variable## while 'A' is a vector containing simulations of such variables. function A = poisson(num_simulations, lambda)  for i = 1 : num_simulations    A(i) = poisson_special_method(lambda);  endforendfunction    
function a = poisson_special_method(lambda)  U = rand;  a = 0;  while U >= exp(-lambda)    U = U * rand;    a = a + 1;  endwhile
endfunction

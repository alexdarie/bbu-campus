function A = gamma(num_simulations, alpha, lambda)
  for i = 1 : num_simulations
    A(i) = gamma_discrete(alpha, lambda);
  endfor
endfunction

function a = gamma_discrete(alpha, lambda)
  a = 0;
  for i = 1 : alpha
    a = a + exp_discrete(lambda);
  endfor
endfunction  

function a = exp_discrete(lambda)
  a = -1/lambda*log(rand);
endfunction

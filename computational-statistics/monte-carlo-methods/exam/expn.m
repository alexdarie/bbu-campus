function A = expn(num_simulations, lambda)
  for i = 1 : num_simulations
    A(i) = exp_discrete(lambda);
  endfor
endfunction

function a = exp_discrete(lambda)
  a = -1/lambda*log(rand);
endfunction


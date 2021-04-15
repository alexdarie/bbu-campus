function A = simulate_gamma(num_simul, alpha, lambda)  for i = 1 : num_simul    A(i) = ditm_gamma(alpha, lambda);  endfor
endfunction

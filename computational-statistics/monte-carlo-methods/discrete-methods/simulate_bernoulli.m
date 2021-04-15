function A = simulate_bernoulli(num_simul, prob)  A = zeros(1, num_simul);  for i = 1 : num_simul    p = rand;    A(i) = p < prob;  endfor
endfunction
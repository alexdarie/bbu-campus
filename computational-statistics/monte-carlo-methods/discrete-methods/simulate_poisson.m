function A = simulate_poisson(num_simul, lambda)  for s = 1 : num_simul    fact = 0;    i = 0;    while rand >= fact      fact = fact + exp(-lambda) * lambda^i/factorial(i);      i = i + 1;    endwhile    A(s) = i;  endfor
endfunction

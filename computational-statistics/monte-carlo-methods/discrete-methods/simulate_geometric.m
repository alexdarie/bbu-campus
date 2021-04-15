function A = simulate_geometric(num_simul, p)  A = zeros(1, num_simul);  for i = 1 : num_simul    while rand >= p      A(i) = A(i) + 1;    endwhile  endfor
endfunction

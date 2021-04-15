function A = bino(num_simulations, n, p)
  for i = 1 : num_simulations
    A(i) = bino_discrete(n, p);
  endfor
endfunction

function a = bino_discrete(num_trials, proba)
  probas = rand(num_trials, 1);
  a = sum(probas < proba);
endfunction

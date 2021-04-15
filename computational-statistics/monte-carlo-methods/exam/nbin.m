function A = nbin(num_simulations, n, p)
  for i = 1 : num_simulations
    A(i) = nbin_discrete(n, p);
  endfor
endfunction
  
function a = nbin_discrete(num_trials, proba)
  for i = 1 : num_trials
    trials_until_r_successes(i) = 0;
    while rand >= proba
      trials_until_r_successes(i) = trials_until_r_successes(i) + 1;
    endwhile
  endfor
  a = sum(trials_until_r_successes);
endfunction


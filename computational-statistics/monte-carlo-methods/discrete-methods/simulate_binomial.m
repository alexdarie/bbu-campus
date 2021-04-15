function A = simulate_binomial(num_simul, trials, prob)  for i = 1 : num_simul    probas = rand(trials, 1);        ## As Geralt of Rivia would say, evil is still evil, lesser, greater.    ## We count the number of successes, because why not, p < pr is how we defined our success.    A(i) = sum(probas < prob);  endfor
endfunction

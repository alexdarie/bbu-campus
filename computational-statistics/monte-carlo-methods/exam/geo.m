function A = geo(num_simulations, p)
  for i = 1 : num_simulations
    A(i) = geo_discrete(p);
  endfor
endfunction

function a = geo_discrete(proba)
  a = 0;
  while rand >= proba
    a = a + 1;
  endwhile
endfunction


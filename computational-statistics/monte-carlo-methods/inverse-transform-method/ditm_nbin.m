function A = ditm_nbin(n, p)  A = 0;  for i = 1 : n    A = A + ditm_geometric(p);  endfor
endfunction

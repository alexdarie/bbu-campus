## err = 0.005, alpha = 0.05

function n = compute_num_simul(err, alpha)
  n = ceil(0.25 * (norminv(alpha, 0, 1) / err)^2);
endfunction
  

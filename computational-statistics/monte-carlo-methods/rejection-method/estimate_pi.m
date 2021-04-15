function estimate_pi(sample_size)  X = 2.*rand(sample_size, 1) - 1;
  Y = 2.*rand(sample_size, 1) - 1;
  accepted = 0;
  for i = 1 : sample_size
    if X(i)^2 + Y(i)^2 <= 1
      accepted = accepted + 1;
    endif
  endfor
  my_pi = 4 * accepted / sample_size;
  fprintf("Estimated Pi := %1.5f, with an error := %e.\n\n", my_pi, abs(pi-my_pi))
endfunction

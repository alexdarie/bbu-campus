## A lab network consisting of 20 computers is attacked by a computer virus. The 
## virus enters each computer with probability 0.4, independently of other 
## computers. Conduct a Monte Carlo study to estimate
##
## a) the probability that the virus entered at least 10 computers;
## b) the expected number of computers attacked by the virus.
## Compare your results with the exact values.

p = 0.4;
n = 20;
num_simul = compute_num_simul(0.005, 0.05);
A = bino(num_simul, n, p);

fprintf("Simulated prob. of the virus to enter at least 10 computers:\nP(A >= 10) := %1.5f\nErr e := %e\n\n", mean(A >= 10), abs(mean(A >= 10) - (1 - binocdf(9, n, p))));
fprintf("Expected number of computers attacked:\nE(A) := %1.5f\nErr e := %e\n\n", mean(A), abs(mean(A) - n*p));

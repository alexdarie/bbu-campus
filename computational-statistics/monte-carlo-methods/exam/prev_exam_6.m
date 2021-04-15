## Five percent of computer parts produced by a certain supplier are defective. A
## company buys 16 such parts. Conduct a Monte Carlo study to estimate:
##
## a. the probability that at least 3 are defective
## b. the average number of defective parts 

p = 0.05;
n = 16;
num_simulations = compute_num_simul(0.005, 0.05);
A = bino(num_simulations, n, p);
fprintf("Simulated prob. P(A >= 3) := %1.5f\nErr e := %e\n\n", mean(A >= 3), abs(mean(A >= 3) - (1 - binocdf(2, n, p))));
fprintf("Average E(A) := %1.5f\nErr e := %e\n\n", mean(A), abs(mean(A) - n*p));

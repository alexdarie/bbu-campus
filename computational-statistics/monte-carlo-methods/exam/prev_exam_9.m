## Computer shutdowns are rare events that occur, on average, at the rate of
## 3 per year. Conduct a Monte Carlo study to estinamte:
##
## a. the probability that it takes exactly 5 months until next computer shutdown
## b. the probability that it takes at least 5 months until next computer shutdown
## c. the average time (in months) between computer shutdowns

lambda = 3/12;
num_simulations = compute_num_simul(0.005, 0.05);
# num_simulations = 1e4
A = expn(num_simulations, lambda);
fprintf("a. Simulated prob. P(A = 5)  := %1.5f\nErr e := %e\n\n", mean(A == 5), abs(mean(A == 5) - exppdf(5, 1/lambda)));
fprintf("b. Simulated prob. P(A >= 5) := %1.5f\nErr e := %e\n\n", mean(A >= 5), abs(mean(A >= 5) - (1 - expcdf(4, 1/lambda))));
fprintf("c. Mean              E(A)    := %1.5f\nErr e := %e\n\n", mean(A), abs(mean(A) - 1/lambda));

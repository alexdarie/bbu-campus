## Messages (rare events) arrive at an electronic message center at random times,
## 1 message every 75 seconds. Conduct a Monte Carlo study to estimate:
## 
## a. the probability that it takes at least 2 minutes until the next message arrives
## b. the average time (in minutes) between message arrivals

lambda = 60/75;
num_simul = compute_num_simul(0.005, 0.05)
A = expn(num_simul, lambda);

fprintf("Simulated prob. P(A >= 2) := %1.5f\nErr e := %e\n\n", mean(A >= 2), abs(mean(A >= 2) - (1 - expcdf(1, 1/lambda))));
fprintf("Average E(A) := %1.5f\nErr e := %e\n\n", mean(A), abs(mean(A) - 1/lambda));


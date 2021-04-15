## Printing jobs arriving at a printer are rare events that occur, on average, every 
## 45 seconds. Conduct a Monte Carlo study to estimate:
##
## a. the probability of at least 10 printing jobs arriving in the next 9 minutes
## b. the average number of printing jobs that arrive in the next 9 minutes

lambda = 60/45 * 9;
num_simul = compute_num_simul(0.005, 0.05);
A = poisson(num_simul, lambda);
fprintf("Simulated prob. P(A >= 10) := %1.5f\nErr e := %e\n\n", mean(A >= 10), abs(mean(A >= 10) - (1 - poisscdf(9, lambda))));
fprintf("Mean E(A) := %1.5f\nErr e := %e\n\n", mean(A), abs(mean(A) - lambda));

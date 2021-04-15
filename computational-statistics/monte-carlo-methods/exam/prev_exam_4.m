## Printing jobs arriving at a printer are rare events that occur at the rate of 
## 3 per minute. Conduct a Monte Carlo study to estimate:
##
## a. the probability that at least 25 seconds pass between printing two consecutive documents
## b. the expected time (in seconds) between printing two consecutive documents 

lambda = 3/60;
num_simul = compute_num_simul(0.005, 0.05);
A = expn(num_simul, lambda);
fprintf("Simulated prob. P(A >= 25) := %1.5f\nErr e := %e\n\n", mean(A >= 25), abs(mean(A >= 25) - (1 - expcdf(25, 1/lambda))));
fprintf("Mean E(A) := %1.5f\nErr e := %e\n\n", mean(A), abs(mean(A) - 1/lambda));

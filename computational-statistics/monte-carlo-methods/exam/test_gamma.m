
err = 1e-2;
alpha = 0.05;
num_simul = compute_num_simul(err, alpha);

alpha = 10;
lambda = 3;

A = gamma(num_simul, alpha, lambda);

fprintf("Simulated prob. P(A<=2) := %1.5f\n", mean(A <= 2))
fprintf("Ground truth    P(A<=2) := %1.5f\n", gamcdf(2, alpha, 1/lambda))
fprintf("Error                   := %e\n\n", abs(mean(A <= 2) - gamcdf(2, alpha, 1/lambda)))

fprintf("Simulated prob. P(A<2) := %1.5f\n", mean(A < 2))
fprintf("Ground truth    P(A<2) := %1.5f\n", gamcdf(1, alpha, 1/lambda))
fprintf("Error                  := %e\n\n", abs(mean(A < 2) - gamcdf(1, alpha, 1/lambda)))

fprintf("Simulated mean  E(A) := %1.5f\n", mean(A))
fprintf("Ground truth    E(A) := %1.5f\n", alpha/lambda)
fprintf("Error                := %e\n\n", abs(mean(A) - alpha/lambda))

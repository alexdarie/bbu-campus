pkg load statistics;lambda = 0.35;err = 0.005;alpha = 0.05;num_simul = ceil(0.25 * (norminv(alpha, 0, 1) / err)^2)A = simulate_exp(num_simul, lambda);fprintf("Simulated prob. P(A<=2) := %1.5f\n", mean(A <= 2))fprintf("Ground truth    P(A<=2) := %1.5f\n", expcdf(2, 1/lambda))fprintf("Error                   := %e\n\n", abs(mean(A <= 2) - expcdf(2, 1/lambda)))fprintf("Simulated prob. P(A<2) := %1.5f\n", mean(A < 2))fprintf("Ground truth    P(A<2) := %1.5f\n", expcdf(1, 1/lambda))fprintf("Error                  := %e\n\n", abs(mean(A < 2) - expcdf(1, 1/lambda)))fprintf("Simulated mean  E(A) := %1.5f\n", mean(A))fprintf("Ground truth    E(A) := %1.5f\n", 1/lambda)fprintf("Error                := %e\n\n", abs(mean(A) - 1/lambda))
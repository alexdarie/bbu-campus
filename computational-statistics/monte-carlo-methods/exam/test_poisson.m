pkg load statistics;

num_simul = 1e5;
lambda = 0.3;

A = poisson(num_simul, lambda);

fprintf("Simulated prob. P(A=2) := %1.5f\n", mean(A == 2))
fprintf("Ground truth    P(A=2) := %1.5f\n", poisspdf(2, lambda))
fprintf("Error                e := %e \n\n", abs(mean(A == 2) - poisspdf(2, lambda)))

fprintf("Simulated prob. P(A<=2) := %1.5f\n", mean(A <= 2))
fprintf("Ground truth    P(A<=2) := %1.5f\n", poisscdf(2, lambda))
fprintf("Error                 e := %e \n\n", abs(mean(A <= 2) - poisscdf(2, lambda)))

fprintf("Simulated prob. P(A<2) := %1.5f\n", mean(A < 2))
fprintf("Ground truth    P(A<2) := %1.5f\n", poisscdf(1, lambda))
fprintf("Error                e := %e \n\n", abs(mean(A < 2) - poisscdf(1, lambda)))

fprintf("Simulated mean E(A) := %1.5f\n", mean(A))
fprintf("Ground truth   E(A) := %1.5f\n", lambda)
fprintf("Error             e := %e \n\n", abs(mean(A) - lambda))

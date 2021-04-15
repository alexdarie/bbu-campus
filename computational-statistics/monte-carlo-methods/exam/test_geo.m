pkg load statistics;

p = 0.5;
A = geo(1e5, p);

fprintf("Simulated prob. P(A=2) := %1.5f\n", mean(A == 2))
fprintf("Ground truth    P(A=2) := %1.5f\n", geopdf(2, p))
fprintf("Error                e := %e \n\n", abs(mean(A == 2) - geopdf(2, p)))

fprintf("Simulated prob. P(A<=2) := %1.5f\n", mean(A <= 2))
fprintf("Ground truth    P(A<=2) := %1.5f\n", geocdf(2, p))
fprintf("Error                 e := %e \n\n", abs(mean(A <= 2) - geocdf(2, p)))

fprintf("Simulated prob. P(A<2) := %1.5f\n", mean(A < 2))
fprintf("Ground truth    P(A<2) := %1.5f\n", geocdf(1, p))
fprintf("Error                e := %e \n\n", abs(mean(A < 2) - geocdf(1, p)))

fprintf("Simulated mean E(A) := %1.5f\n", mean(A))
fprintf("Ground truth   E(A) := %1.5f\n", (1-p)/p)
fprintf("Error             e := %e \n\n", abs(mean(A) - (1-p)/p))

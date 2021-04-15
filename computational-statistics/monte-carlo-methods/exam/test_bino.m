pkg load statistics;

n = 5;
p = 0.5;
A = bino(1e5, n, p);

fprintf("Simulated prob. P(A=2) := %1.5f\n", mean(A == 2))
fprintf("Ground truth    P(A=2) := %1.5f\n", binopdf(2, n, p))
fprintf("Error                e := %e \n\n", abs(mean(A == 2) - binopdf(2, n, p)))

fprintf("Simulated prob. P(A<=2) := %1.5f\n", mean(A <= 2))
fprintf("Ground truth    P(A<=2) := %1.5f\n", binocdf(2, n, p))
fprintf("Error                 e := %e \n\n", abs(mean(A <= 2) - binocdf(2, n, p)))

fprintf("Simulated prob. P(A<2) := %1.5f\n", mean(A < 2))
fprintf("Ground truth    P(A<2) := %1.5f\n", binocdf(1, n, p))
fprintf("Error                e := %e \n\n", abs(mean(A < 2) - binocdf(1, n, p)))

fprintf("Simulated mean E(A) := %1.5f\n", mean(A))
fprintf("Ground truth   E(A) := %1.5f\n", n * p)
fprintf("Error             e := %e \n\n", abs(mean(A) - n * p))

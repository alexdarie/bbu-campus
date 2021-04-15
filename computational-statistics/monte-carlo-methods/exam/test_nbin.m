pkg load statistics;

num_simul = 1e5;
n = 1;
p = 0.5;
A = nbin(num_simul, n, p);

fprintf("Simulated prob. P(A=2) := %1.5f\n", mean(A == 2))
fprintf("Ground truth    P(A=2) := %1.5f\n", nbinpdf(2, n, p))
fprintf("Error                e := %e\n\n", abs(mean(A == 2) - nbinpdf(2, n, p)))

fprintf("Simulated prob. P(A<=2) := %1.5f\n", mean(A <= 2))
fprintf("Ground truth    P(A<=2) := %1.5f\n", nbincdf(2, n, p))
fprintf("Error                 e := %e\n\n", abs(mean(A <= 2) - nbincdf(2, n, p)))

fprintf("Simulated prob. P(A<2) := %1.5f\n", mean(A < 2))
fprintf("Ground truth     P(<2) := %1.5f\n", nbincdf(1, n, p))
fprintf("Error                e := %e\n\n", abs(mean(A < 2) - nbincdf(1, n, p)))

fprintf("Mean              E(A) := %1.5f\n", mean(A))
fprintf("Ground truth    P(A=2) := %1.5f\n", n * (1-p)/p)
fprintf("Error                e := %e\n\n", abs(mean(A) - n * (1-p)/p))


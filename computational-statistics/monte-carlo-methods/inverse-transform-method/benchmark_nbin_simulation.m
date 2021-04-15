pkg load statistics;err = 0.005;alpha = 0.05;num_simul = ceil(0.25*(norminv(alpha, 0, 1) / err)^2)n = 10;p = 0.5;A = simulate_nbin(num_simul, n, p);fprintf("Simulated prob. P(A=2) := %1.5f\n", mean(A == 2))fprintf("Ground truth    P(A=2) := %1.5f\n", nbinpdf(2, n, p))fprintf("Error                  := %e\n\n", abs(mean(A == 2) - nbinpdf(2, n, p)))fprintf("Simulated prob. P(A<=2) := %1.5f\n", mean(A <= 2))fprintf("Ground truth    P(A<=2) := %1.5f\n", nbincdf(2, n, p))fprintf("Error                   := %e\n\n", abs(mean(A <= 2) - nbincdf(2, n, p)))fprintf("Simulated prob. P(A<2) := %1.5f\n", mean(A < 2))fprintf("Ground truth    P(A<2) := %1.5f\n", nbincdf(1, n, p))fprintf("Error                  := %e\n\n", abs(mean(A < 2) - nbincdf(1, n, p)))fprintf("Simulated mean  E(A) := %1.5f\n", mean(A))fprintf("Ground truth    E(A) := %1.5f\n", n * (1-p)/p)fprintf("Error                := %e\n\n", abs(mean(A) - n * (1-p)/p))
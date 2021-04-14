### Lab No. 3, Probability and Statistics
Continuous Random Variables; CDF and Inverse CDF; Quantiles; Approximations of the Binomial Distribution

![](https://github.com/alexdarie/Statistics/blob/master/Screen%20Shot%202019-01-05%20at%202.03.14%20AM.png)

```matlab
%Normal Distribution
mu    = input('μ (mu): ');
sigma = input('σ (sigma > 0): ');
alpha = input('α (0,1): ');
beta  = input('β (0,1): ');

% a1. P(X <= 0)
pa1 = normcdf(0, mu, sigma);

% a2. P(X >= 0) = 1 - P(X <= 0)
pa2 = 1 - pa1;

% Display results for a.
fprintf("Probability a1 -> P(X <= 0) %1.4f\n", pa1);
fprintf("Probability a2 -> P(X >= 0) %1.4f\n", pa2);

% b1. P(-1 < x < 1) = F(1) - F(-1)
pb1 = normcdf(1, mu, sigma) - normcdf(-1, mu, sigma);

% b2. P(X <= -1 OR x >= 1)
pb2 = 1 - pb1;

% Display results for b.
fprintf("Probability b1 -> P(-1 < X < 1) %1.4f\n", pb1);
fprintf("Probability b2 -> P(X <= -1 OR X >= 1) %1.4f\n", pb2);

% c. P (X < xα)
xalpha = norminv(alpha, mu, sigma);
fprintf("The quantile of order alpha is (xα): %1.4f\n", xalpha);

% d. P (X > xβ)
xbeta = norminv(1-beta, mu, sigma);
fprintf("The quantile of order 1-beta is (xβ): %1.4f\n", xbeta);
```

```
% Student distribution
x = 0:.1:10;
degreeOfFreedom = input('degree of freedom: ');

y = tcdf(x, degreeOfFreedom);
plot(x, y, 'Color', 'red', 'LineStyle', '--');

hold on
y2 = tpdf(x, degreeOfFreedom);
plot(x, y2, 'Color', 'blue', 'LineStyle', '--');

hold off
legend('Student, T-distribution cdf', 'Student, T-distribution pdf');
```

```
% Chi square
x = 0:0.01:10;
degreeOfFreedom = input('degree of freedom: ');

y = chi2cdf(x, degreeOfFreedom);
plot(x, y, 'Color', 'red', 'LineStyle', '--');

hold on
y2 = chi2pdf(x, degreeOfFreedom);
plot(x, y2, 'Color', 'blue', 'LineStyle', '--');

hold off
legend('Chi square distribution cdf', 'Chi square distribution pdf');
```

```
% Fischer distribution
x = 0:0.01:10;

degreeOfFreedom1 = input('degree of freedom 1: ');
degreeOfFreedom2 = input('degree of freedom 2: ');

y = fcdf(x, degreeOfFreedom1, degreeOfFreedom2);
plot(x, y, 'Color', 'red', 'LineStyle', '--');

hold on
y2 = fpdf(x, degreeOfFreedom1, degreeOfFreedom2);
plot(x, y2, 'Color', 'blue', 'LineStyle', '--');

hold off
legend('Fischer distribution cdf', 'Fischer distribution pdf');
```

#### 2. Approximations of the Binomial distribution

![](https://github.com/alexdarie/Statistics/blob/master/Screen%20Shot%202019-01-05%20at%2012.32.31%20AM.png)

```matlab
n = input('Number of trials: '); 
p = input('Probability of success: ');
x = 0:n;
X = binopdf(x,n,p); 
[mean, variance] = binostat(n, p);
fprintf ('Stat: \nMean value: %d\nVariance value: %d\nStandard deviation: %d\n', mean, variance, sqrt(variance));

norm1 = normpdf(x, mean, sqrt(variance));
plot(x, norm1, 'LineStyle', '-', 'Color', 'r');

hold on
bar(x, X, 0.1)

hold off
legend('Normal distribution', 'Binomial Model');
title('Approximation of the Binomial Distribution');
xlabel('Normal approximation');
```

![](https://github.com/alexdarie/Statistics/blob/master/Screen%20Shot%202019-01-05%20at%2012.23.30%20AM.png)
> For 50 trials with probability of success of 0.63.<br>
> Stat: 
> Mean value: 3.150000e+01
> Variance value: 1.165500e+01
> Standard deviation: 3.413942e+00

```
n = input('Number of trials: '); 
p = input('Probability of success: ');
x = 0:n;
X = binopdf(x,n,p); 
[mean, variance] = binostat(n, p);
fprintf ('Stat: \nMean value: %d\nVariance value: %d\nStandard deviation: %d\n', mean, variance, sqrt(variance));

poiss1 = poisspdf(x, n*p);
plot(x, poiss1, 'LineStyle', '-', 'Color', 'r');

hold on
bar(x, X, 0.1)

hold off
legend('Normal distribution', 'Binomial Model');
title('Approximation of the Binomial Disctribution');
xlabel('Poisson approximation');
```

![](https://github.com/alexdarie/Statistics/blob/master/Screen%20Shot%202019-01-05%20at%201.59.57%20AM.png)
> For 30 trials with probability of success of 0.05.<br>
> Stat: 
> Mean value:         1.500000e+00
> Variance value:     1.425000e+00
> Standard deviation: 1.193734e+00

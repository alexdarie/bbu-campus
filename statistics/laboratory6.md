### Hypothesis and significance testing for means and variances

For all these problems, find the rejection region, the value of the test statistic and the P-value of the test. 

##### Include (many!!) comments to make it clear what H0 and H1 are and also to interpret your results in words.

1. In a study of the size of various computer systems, the random variable X, the number of files stored (in hundreds of thousands), is considered. If a computer system cannot store at least 9, on average, it does not meet the efficiency standard and has to be replaced. 

These data are obtained:

```
7  7  4  5 9  9
4  12 8  1 8  7 
3  13 2  1 17 7 
12 5  6  2 1  13 
14 10 2  4 9  11
3  5  12 6 10 7
```
> (the data from Problem B.1., Lab nr. 5).

a. Assuming that past experience indicates that σ = 5, at the 5% significance level, does the data suggest that the standard is met? What about at 1%?

```matlab
alpha = input('significance level (in (0, 1)): ');

% miu0 = hypothesis miu
m0 = input('test value: ');

% H0: miu >= m0 
% H1: miu < m0 left-tailed test

% sample data
X = [ 
    7 7 4 5 9 9 ...
    4 12 8 1 8 7 ...
    3 13 2 1 17 7 ...
    12 5 6 2 1 13 ...
    14 10 2 4 9 11 ...
    3 5 12 6 10 7 ...
];

% sigma is known
sigma = 5;

[h, p, ci, zval] = ztest(X, m0, sigma, alpha, -1);
if h == 0
    fprintf('H0 is not rejected, i.e. the standard is met.\n');
else
    fprintf('H1 is rejected, i.e. the standard is not met.\n');
end
    
fprintf('P-value is %1.4f \n', p);
fprintf('Observed value of the test stat. is %1.4f \n', zval);

q1 = norminv(alpha, 0, 1);
fprintf('Rejection region R is (-inf, %3.4f) \n', q1);

fprintf('P-value is %1.4f \n', p);
```

b. Without the assumption on σ, does the data suggest that, on average, the number of files stored exceeds 5.5? (same significance level)

```matlab
alpha = input('significance level (in (0, 1)): ');

%  miu0 = hypothesis miu
m0 = input('test value: ');

% H0: miu <= m0
% H1: miu > m0 right-tailed test

% sample data
X = [ 
    7 7 4 5 9 9 ...
    4 12 8 1 8 7 ...
    3 13 2 1 17 7 ...
    12 5 6 2 1 13 ...
    14 10 2 4 9 11 ...
    3 5 12 6 10 7 ...
];

[h, p, ci, stats] = ttest(X, m0, alpha, 1);
if h == 0
    fprintf('H0 is not rejected, i.e. number of files stored does not exceed 5.5.\n');
else
    fprintf('H1 is rejected, i.e. number of files stored exceeds 5.5.\n');
end
    
fprintf('P-value is %1.4f \n', p);
fprintf('Observed value of the test stat. is %1.4f \n', stats.tstat);

q1 = tinv(1-alpha, stats.df); % sau n-1 in loc de stats.df
fprintf('Rejection region R is (%3.4f, inf) \n', q1);

fprintf('P-value is %1.4f \n', p);
```

c. Without the assumption on σ, does the data suggest that, on average, the number of files stored is exactly 7? (same significance level)

```matlab
alpha = input('significance level (in (0, 1)): ');

% miu0 = hypothesis miu
m0 = input('test value: ');

% H0: miu = m0 
% H1: miu /= m0 left-tailed test

% sample data
X = [ 
    7 7 4 5 9 9 ...
    4 12 8 1 8 7 ...
    3 13 2 1 17 7 ...
    12 5 6 2 1 13 ...
    14 10 2 4 9 11 ...
    3 5 12 6 10 7 ...
];

[h, p, ci, stats] = ttest(X, m0, alpha, 'both');
if h == 0
    fprintf('H0 is not rejected, i.e. number of files stored is exactly 7.\n');
else
    fprintf('H1 is rejected, i.e. number of files stored is not exactly 7.\n');
end
    
fprintf('P-value is %1.4f \n', p);
fprintf('Observed value of the test stat. is %1.4f \n', stats.tstat);

q1 = tinv(1-alpha, stats.df); 
q2 = tinv(alpha, stats.df);
fprintf('Rejection region R is (-inf, %3.4f) (%3.4f, inf) \n', q2, q1);

fprintf('P-value is %1.4f \n', p);
```

2. It is thought that the gas mileage obtained by a particular model of automo- bile will be higher if unleaded premium gasoline is used in the vehicle rather than regular unleaded gasoline. To gather evidence in this matter, 10 cars are randomly se- lected from the assembly line and tested using a specified brand of premium gasoline; 10 others are randomly selected and tested using the brand’s regular gasoline. Tests are conducted under identical controlled conditions and gas mileages for both types of gas are assumed independent and (approximately) normally distributed. 

These data result:

| Premium | Regular |
|---------|---------|
| 22.4 21.7 | 17.7 14.8 | 
| 24.5 23.4 | 19.6 19.6 | 
| 21.6 23.3 | 12.1 14.8 |
| 22.4 21.6 | 15.4 12.6 |
| 24.8 20.0 | 14.0 12.2 |

> (the data from Problem B.2., Lab nr. 5).

a. At the 5% significance level, is there evidence that the variances of the two populations are equal?

```matlab
% we test the variances
alpha = input('significance level: ');

%premium gas
Xpremium = [ 
    22.4 21.7 ...
    24.5 23.4 ...
    21.6 23.3 ...
    22.4 21.6 ...
    24.8 20.0 ...
];

%regular gas
Xregular = [
    17.7 14.8 ...
    19.6 19.6 ...
    12.1 14.8 ...
    15.4 12.6 ...
    14.0 12.2 ...
];

[h, p, ci, stats] = vartest2(Xpremium, Xregular, alpha, 0);
if h == 0
    fprintf('H0 is not rejected, i.e. there is no diff between the two types of gas.\n');
else
    fprintf('H1 is rejected, i.e. there is a diff between the two types of gas.\n');
end

fprintf('P-value is %1.4f \n', p);
fprintf('Observed value of the test stat. is %1.4f \n', stats.fstat);

q1 = finv(alpha/2, stats.df1, stats.df2); % sau n1-1 in loc de stats.df1
q2 = finv(1-(alpha/2), stats.df1, stats.df2); % sau n2-1 in loc de stats.df1

fprintf('Rejection region R is (-inf, %3.4f) U (%3.4f, inf) \n', q1, q2);
```

b. Based on the result in part a., at the same significance level, does gas mileage seem to be higher, on average, when premium gasoline is used?

```matlab
% we test the variances
alpha = input('significance level: ');

%premium gas
Xpremium = [ 
    22.4 21.7 ...
    24.5 23.4 ...
    21.6 23.3 ...
    22.4 21.6 ...
    24.8 20.0 ...
];

%regular gas
Xregular = [
    17.7 14.8 ...
    19.6 19.6 ...
    12.1 14.8 ...
    15.4 12.6 ...
    14.0 12.2 ...
];

% compar mediile de populatie
% H0: miu1 = miu2
% H1: miu1 > miu2 right-tailed

% vartype: 'equal' or 'unequal'
[h, p, ci, stats] = ttest2(Xpremium, Xregular, alpha, 1, 'equal');

if h == 0
    fprintf('H0 is not rejected, i.e. the gas mileage does not seem to be higher for premium.\n');
else
    fprintf('H0 is rejected, i.e. the gas mileage seems to be higher for premium.\n');
end

fprintf('P-value is %e \n', p); % din rezultat inteleg ca mereu ipoteza nula e respinsa
fprintf('Observed value of the test stat. is %1.4f \n', stats.tstat);

q3 = tinv(1-alpha, stats.df);

fprintf('Rejection region R is (%3.4f, inf) \n', q3);
```

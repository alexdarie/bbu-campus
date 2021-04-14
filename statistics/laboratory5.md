1. In a study of the size of various computer systems, the random variable X, the number of files stored (in hundreds of thousands), is considered.

These data are obtained:
```
7  7  4 5 9  9 
4  12 8 1 8  7 
3  13 2 1 17 7 
12 5  6 2 1  13 
14 10 2 4 9  11 
3  5 12 6 10 7 
```


a. Assuming that past experience indicates that σ = 5, find a 100(1−α)% confidence interval for the average number of files stored.

```matlab
sample = [ 
    7 7 4 5 9 9 ...
    4 12 8 1 8 7 ...
    3 13 2 1 17 7 ...
    12 5 6 2 1 13 ...
    14 10 2 4 9 11 ...
    3 5 12 6 10 7 ...
];

% sample size
n = length(sample);

confidanceInterval = input('Give the confidance level (in (0,1 )): ');
alpha = 1 - confidanceInterval;

% the sample mean - POINT ESTIMATOR
sampleMean = mean(sample);

% s = sqrt(Σi=1,n (xi-xbar)^2/n-1)
s = std(sample);

% for σ unkown we use the T-distribution 
df = n-1;
tValue = tinv(alpha/2, df);

% the (1-α)100% confidance level of the form POINT ESTIMATOR ± margin of error is
leftBound  = sampleMean + tValue * (s/sqrt(n));
rightBound = sampleMean - tValue * (s/sqrt(n));

fprintf('We are %d %% sure that the mean value lies in the [%3.5f, %3.5f] interval.\n', confidenceLevel*100, leftBound, rightBound);
```

b. Assuming nothing is known about σ, find a 100(1 − α)% confidence interval for the average number of files stored.

```matlab
sample = [ 
    7 7 4 5 9 9 ...
    4 12 8 1 8 7 ...
    3 13 2 1 17 7 ...
    12 5 6 2 1 13 ...
    14 10 2 4 9 11 ...
    3 5 12 6 10 7 ...
];

% sample size
n = length(sample);

confidanceInterval = input('Give the confidance level (in (0,1 )): ');
alpha = 1 - confidanceInterval;

% the sample mean - POINT ESTIMATOR
sampleMean = mean(sample);

% s = sqrt((Σi=1,n (xi-sampleMean)^2)/n-1)
s = std(sample)

% for σ unkown we use the T-distribution 
df = n-1;
tValue = tinv(aplha/2, df);

% the (1-α)100% confidance level of the form POINT ESTIMATOR ± margin of error is
leftBound  = sampleMean + tValue * (s/sqrt(n));
rightBound = sampleMean - tValue * (s/sqrt(n));

fprintf('We are %d %% sure that the mean value lies in the [%3.5f, %3.5f] interval.\n', confidenceLevel*100, leftBound, rightBound);
```

c. Assuming the number of files stored are approximately normally distributed, find 100(1 − α)% confidence intervals for the variance and for the standard deviation. [https://www.youtube.com/watch?v=DjwFBGiG_sI]

```matlab
sample = [ 
    7 7 4 5 9 9 ...
    4 12 8 1 8 7 ...
    3 13 2 1 17 7 ...
    12 5 6 2 1 13 ...
    14 10 2 4 9 11 ...
    3 5 12 6 10 7 ...
];

% sample size
n = length(sample);

confidanceInterval = input('Give the confidance level (in (0,1 )): ');
alpha = 1 - confidanceInterval;

% compute the variance as Var = (Σi=1,n (xi-sampleMean)^2)/n-1, where sampleMean = (Σi=1,n (xi))/n
var = var(sample);                                  

% be aware that the graph isn't symetric anymore, so you'll need to compute each of the quantiles
chi2R = chi2inv(1-alpha/2, n-1);
chi2L = chi2inv(alpha/2, n-1);        

VarianceLeftBound = (n-1) * var/ chi2R;
VarianceRightBound = (n-1) * var / chi2L;

SDLeftBound = sqrt(VarianceLeftBound);
SDRightBound = sqrt(VarianceRightBound);

fprintf('We are %d %% sure that the variance value lies in the [%3.5f, %3.5f] interval \n while the standard deviation lies in the [%3.5f, %3.5f] interval.\n', confidanceInterval*100, VarianceLeftBound, VarianceRightBound, SDLeftBound, SDRightBound);
```

2. It is thought that the gas mileage obtained by a particular model of automobile will be higher if unleaded premium gasoline is used in the vehicle rather than regular unleaded gasoline. To gather evidence in this matter, 10 cars are randomly selected from the assembly line and tested using a specified brand of premium gasoline; 10 others are randomly selected and tested using the brand’s regular gasoline. Tests are conducted under identical controlled conditions and gas mileages for both types of gas are assumed independent and (approximately) normally distributed. 

These data result:

a. Assuming σ1 = σ2, find a 100(1 − α)% confidence interval for the difference of the true means.

```matlab
confidenceLevel = input('Give the confidence level (in (0, 1)): ');
alpha = 1 - confidenceLevel;

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

premiumSampleSize = length(Xpremium);
regularSampleSize = length(Xregular);

xbar1 = mean(Xpremium);
xbar2 = mean(Xregular);

premiumVariance = var(Xpremium); 
regularVariance = var(Xregular); 

t_value = tinv(alpha/2, premiumSampleSize + regularSampleSize - 2);
variance = ((premiumSampleSize-1) * premiumVariance + (regularSampleSize - 1) * regularVariance) / (premiumSampleSize + regularSampleSize - 2);
sigma = sqrt(variance);

left = xbar1 - xbar2 + t_value * sigma * sqrt(1 / premiumSampleSize + 1 / regularSampleSize);
right = xbar1 - xbar2 - t_value * sigma * sqrt(1 / premiumSampleSize + 1 / regularSampleSize);

fprintf('We are %d percent sure that the mean value lies in the (%3.5f, %3.5f) interval.\n', confidenceLevel*100, left, right)

```

b. Assuming σ1 /= σ2, find a 100(1 − α)% confidence interval for the difference of the true means.

```matlab
confidenceLevel = input('Give the confidence level (in (0, 1)): ');
alpha = 1 - confidenceLevel;

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

n1 = length(Xpremium);
n2 = length(Xregular);

xbar1 = mean(Xpremium);
xbar2 = mean(Xregular);

s_var1 = var(Xpremium); 
s_var2 = var(Xregular); 

%compute n by using c and the formula from the lab paper

c = (s_var1.^2/n1) / (s_var1.^2/n1 + s_var2.^2/n2);
n = (c.^2 / (n1 - 1)) + (1-c).^2 / (n2 - 1);
n = 1/n;

quantile_1 = tinv(1-alpha/2, n);
quantile_2 = tinv(alpha/2, n);

confidenceInterval1 = xbar1 - xbar2 - quantile_1 * sqrt(s_var1^2/n1+s_var2^2/n2);
confidenceInterval2 = xbar1 - xbar2 - quantile_2 * sqrt(s_var1^2/n1+s_var2^2/n2);

fprintf('The difference of the true means lie in the [%3.5f, %3.5f] interval. \n', confidenceInterval1, confidenceInterval2)

```

c. Find a 100(1 − α)% confidence interval for the ratio of the variances. [https://www.youtube.com/watch?v=64hFiLSq3Fg]

```matlab
confidenceLevel = input('Give the confidence level (in (0, 1)): ');
alpha = 1 - confidenceLevel;

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

n1 = length(Xpremium);
n2 = length(Xregular);

s_var1 = var(Xpremium); 
s_var2 = var(Xregular); 

quantile1 = finv(1-alpha/2, n1-1, n2-1);
quantile2 = finv(alpha/2, n1-1, n2-1);

left = 1 / quantile1 * (s_var1.^2 / s_var2.^2);
right = 1 / quantile2 * (s_var1.^2 / s_var2.^2);

fprintf('The ratio of the variances lie in the [%3.5f, %3.5f] interval. \n', left, right)
```

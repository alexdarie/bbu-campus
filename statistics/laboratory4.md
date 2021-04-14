a. Bernoulli Distribution

```
%Simulate Bern(p) random variable
p = input('p in (0,1) = ');
U = rand();
X = U < p;                              %x=1 if U < p, 0 otherwise

%Generate a sample of N variables
N = input('Nr of simulations');         % for examplem 10, 100, 1000
for i = 1:N 
    U = rand();
    X(i) = U < p;
end

%Compare to the Bern distr
UX = unique(X);                         %distinct values of X
hist(X, length(UX));
nX = hist(X, length(UX));
relFreq = nX / N;
```

b. Binomial Distribution

```
%Simulate Bino(n, p) rand variable

n = input('No of trials: ');
p = input('Probability of success: ');

%Generate one
U = rand(n,1);                                          %vector of size n
X = sum(U < p);

%Generate a sample
N = input('Number of simulations (sample size): ');
for i=1:N
    U = rand(n, 1);
    X(i) = sum(U < p);
end

%Compare to the Binomial distribution graphically
UX = unique(X);
nX = hist(X, length(UX));
relfreq = nX/N;
k = 0:n;
pk = binopdf(k, n, p);
clf;
plot(k, pk, 'm*',UX, relfreq, 'ro')
legend('Binomial Distribution', 'Simulation')
```

c. Geometrical Distribution

```
%Simulate geo(p) random variable
p = input('Probability of success = ');
X = 0; %init val
while rand >= p
    X = X+1; %count number of failures
end

%Generate a sample
N = input('Nr of simulations = ');
for i = 1:N 
   X(i) = 0;
   while rand >= p
       X(i) = X(i) + 1;
   end
end

%Compare to the geometric distribution graphically

UX = unique(X);
nX = hist(X, length(UX));
relfreq = nX / N;

k = 0:20; %should be infinite
pk = geopdf(k, p);
plot(k, pk, 'm*', UX, relfreq, 'bo')
legend('Geo distribution', 'Simulation')
```

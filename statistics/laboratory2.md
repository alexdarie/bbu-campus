```matlab
%Values of the parameters
%pdf plot
%n = input('Nr of trials n=');
%p = input('Probability of success p=');
n = 3;
p = 0.5;
xpdf = 0:n;
ypdf = binopdf(xpdf, n, p);

subplot(2, 1, 1);
plot(xpdf, ypdf, '*');

%CDF PLOT
xcdf = 0:0.01:n;
ycdf = binocdf(xcdf, n, p);
subplot(2, 1, 2);
plot(xcdf, ycdf);

%Lab2.2.c)
p1 = binopdf(0, 3, 0.5);
p2 = 1 - binopdf(1, 3, 0.5);
%Lab2.2.d)
p3 = binocdf(2,3, 1/2);
p4 = binocdf(1, 3, 1/2);

%Lab2.2.e)

p5 = 1 - binocdf(0, 3, 1/2);
p6 = 1 - binocdf(1, 3, 1/2);

fprintf('Probability 1 in c) is %1.4f\n', p1);
fprintf('Probability 2 in c) is %1.4f\n', p2);
fprintf('Probability 1 in d) is %1.4f\n', p3);
fprintf('Probability 2 in d) is %1.4f\n', p4);
fprintf('Probability 1 in e) is %1.4f\n', p5);
fprintf('Probability 2 in e) is %1.4f\n', p6);
```

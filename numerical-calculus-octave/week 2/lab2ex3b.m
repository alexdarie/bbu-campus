n = 20;

clf; hold on;
Tnf = @(x) ones(size(x));

for k = 0:n
    Tnf = @(x) Tnf(x) + (1/factorial(k))*x.^k;
    fplot(Tnf, [-1, 3]);
end
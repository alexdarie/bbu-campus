% a) Plot Chebyshev polynomials of the first kind and T1, T2, T3.

figure(1);
n=3;
for k=1:n
    tn=@(t) cos(k*acos(t));
    fplot(tn, [-1, 1]);
    hold on;
end

% b) Plot first n Chebyshev polynomials with the following reccurence
% formula

figure(2);
size = 2;
figure(2)
t = -1:0.01:1;
Tn_1 = 1;
Tn = t;

for n = 1:size-1
   T = Tn*2.*t - Tn_1;
   plot(t, T);
   hold on;
   Tn_1 = Tn;
   Tn = T;
end


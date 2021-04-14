% 1. Evaluate the polynomial p(x) = 2x^3 - 5x^2 - 17x + 21 (Use: polyval)
% 2. Find the roots of the polynomial p(x) = x^3-5x^2 -17*x + 21 (Use:
% roots)

x = 0:0.1:10;
p = x.^3-x+2;
polyval([1 0 -1 2], 2);
p(2)
roots([1 0 -1 2])
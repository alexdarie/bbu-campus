% 1. Check the following operations with vectors.

%line vector
a = [1 2 3];
a = [1 ; 2 ; 3]; 

%column vector 
b = [4 ; 5 ; 6];
b = [4 5 6]';

c = a * b;
d = [4 5 6];
d = b';
e = a.*d;
f = a.^2;
g = a.^d;
v = 1:6;
w = 2 : 3 : 10;
y = 10 : -1 : 0;
exp(a);

%number e
exp(1);
sqrt(a);

m = max(a);
[m, k] = max(a);

h = [-2 -9 8];
k = abs(h);

mean(a);
geomean(a);
sum(a);
prod(a);
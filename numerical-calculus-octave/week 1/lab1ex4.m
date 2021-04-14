% Graphs

% 1. Plot the functions f: [0, 1] -> R, f(x) = e^(10x(x-1)) * sin12Pix, and
% f:[0, 1] -> R, f(x)=3e^(5x^2-1)cos12Pix.

figure(1)
x = 0:0.001:1;
f = exp(10 * x .* (x-1)) .* sin(12 .* pi .* x);
plot(x, f)

figure(2)
g = 3.*exp(5 .* x.^(2)-1) .* cos(12 .* pi .* x);
plot(x, g)

% 2. Plot the epicycloid defined below
% | x(t) = (a+b)*cos(t) - b*cos((a/b+1)*t)
% | y(t) = (a+b)*sin(t) - b*sin((a/b+1)*t)
% t in [0, 10pi]

figure(3)
a = 2;
b = 6;
t = 0:0.1:10*pi;
xt = (a+b).*cos(t)-b.*cos((a/b+1).*t);
yt = (a+b).*sin(t)-b.*sin((a/b+1).*t);
plot(xt, yt);

% 3. Plot, on a single graph, the functions: f1, f2,f3: 
%

figure(4)

x = 0:2*pi;
f1 = cos(x);
f2 = sin(x);
f3 = cos(2*x);

plot(x, f1);
hold on
plot(x, f2);
hold on
plot(x, f3);

% 4. Plot the graph of the function
%         
% f(x) = x^3 + ?1-x, -1 <= x <= 0
%        x^3 - ?1-x, 0 < x <= 1

figure(5)
syms x
f = piecewise(-1<=x<=0, x.^3 + sqrt(1-x), -1<=x<=0, x.^3 - sqrt(1-x));
fplot(f);

% 5. For x in {0, 1, .., 50} plot the function described below.

figure(6)
x = 0:1:10;
g = zeros(numel(x));
for i=1:numel(x)
    if mod(x(i), 2) == 0
        g(i) = x(i).^3 + sqrt(1-x(i));
    else
        g(i) = x(i).^3 - sqrt(1-x(i));
    end
end
plot(x, g);

% 7. Plot the function g: [-2, 2] x [-4, 4] -> R, g(x, y) = e^(-(x-1/2)^2+(y-1/2)^2) 
% (Use: meshgrid, mesh).

x = -2:0.1:2;
y = -4:0.1:4;
[X, Y] = meshgrid(x);
F = exp(-(X-1/2).^2+(Y-1/2).^2);
surf(X, Y, F);


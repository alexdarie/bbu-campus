size = 6;

h = 0.25;
f = sqrt(5.*(x^2)+1);
out = zeros(6);

for i = 0:size
    out(1,i) = eval(f, i);
end

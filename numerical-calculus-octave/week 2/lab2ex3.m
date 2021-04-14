syms x
f = exp(x);

T1 = taylor(f, x, 'Order', 1);
T2 = taylor(f, x, 'Order', 2);
T3 = taylor(f, x, 'Order', 3);
T4 = taylor(f, x, 'Order', 4);
T5 = taylor(f, x, 'Order', 5);
T6 = taylor(f, x, 'Order', 6);

fplot([T1 T2 T3 T4 T5 T6 f]);
xlim([-1 3]);
grid on;

legend('approximation of exp(x) up to O(x^1)',...
       'approximation of exp(x) up to O(x^2)',...
       'approximation of exp(x) up to O(x^3)',...
       'approximation of exp(x) up to O(x^4)',...
       'approximation of exp(x) up to O(x^5)',...
       'approximation of exp(x) up to O(x^6)',...
       'exp(x)','Location','Best')
title('Taylor')

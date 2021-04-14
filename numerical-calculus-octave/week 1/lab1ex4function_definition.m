% 6. Compute the following recursive function:
% g = (1 + 1/(1 + 1/(1 + 1/(...)))   

function f = lab1ex4function_definition(n)
    if n>0
        f = 1 + 1/lab1ex4function_definition(n-1);
    else
        f = 1;
    end
end
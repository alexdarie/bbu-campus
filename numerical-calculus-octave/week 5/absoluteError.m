function absErr = absoluteError(nodes, values, derivatives)  result = 0;  for i=1:length(nodes)    result = result + abs(values(i) - hermiteInterpolation(nodes, values, derivatives, nodes(i)));  endfor  absErr = result;endfunction ##>> nodes=linspace(1,5,15);##>> values=arrayfun(@(x) log(x), nodes);##>> derivatives=arrayfun(@(x) 1/x, nodes);##>> absErr = absoluteError(nodes, values, derivatives)##absErr =    2.7200e-14
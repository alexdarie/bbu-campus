function [a, b] = LinearBestSquaresFunction(nodes, values)
	a = (length(nodes) * sum(nodes .* values) - sum(nodes) * sum(values))/...
		(length(nodes) * sum(nodes .^ 2) - sum(nodes) .^ 2)
	
	b = (sum(nodes .^ 2) * sum(values) - sum(nodes .* values) * sum(nodes))/...
		(length(nodes) * sum(nodes .^ 2) - sum(nodes) .^ 2)
endfunction
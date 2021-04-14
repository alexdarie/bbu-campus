function err = ErrorLinearSquaresFunction(nodes, values, a, b)
	err = sum(values - (nodes * a + b)) .^ 2
endfunction
function lab7problem1
	hours = [1 2 3 4 5 6 7];
	temps = [13 15 20 14 15 13 10];
	
  [a, b] = LinearBestSquaresFunction(hours, temps);
	printf("The value for 8:00 is: ");
	a * 8 + b
	
  err = ErrorLinearSquaresFunction(hours, temps, a, b);
  
	clf; hold on;
	scatter(hours, temps);
	plot(hours, a*hours+b);
endfunction
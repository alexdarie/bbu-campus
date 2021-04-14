function lab7problem2
	nodes = [0 10 20 30 40 60 80 100];
	values = [0.0061 0.0123 0.0234 0.0424 0.0738 0.1992 0.4736 1.0133];
  
	p1 = polyfit(nodes, values, 3)
	p2 = polyfit(nodes, values, 4)
	
  printf("P1 evalutation for 45 is ");
	v1 = polyval(p1, 45)
  
  printf("P1 missed by ");
  aproxErr1 = abs(v1 - 0.095848)
	
  printf("P2 evalutation for 45 is ");
	v2 = polyval(p2, 45)
	
  printf("P2 missed by ");
	aproxErr2 = abs(v2 - 0.095848)
	
  values1 = ones(length(nodes), 1);
	values2 = ones(length(nodes), 1);
	
  for i=1:length(nodes)
		values1(i) = polyval(p1, nodes(i));  
		values2(i) = polyval(p2, nodes(i)); 
	endfor
	
  clf; hold on;
  scatter(nodes, values, 'filled');
	plot(nodes, values, 'r');
	plot(nodes, values1, 'b');
	plot(nodes, values2, 'y');
endfunction
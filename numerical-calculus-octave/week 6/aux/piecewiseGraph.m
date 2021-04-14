function piecewiseGraph
  nodes=[0 3 5 8 13];
  values=[0 225 383 623 993];
  der_values=[75 77 80 74 72];
  clf;
  %not done
  t=linspace(0,13,1000);
  [dist,speed]=piecewise_cubic_hermite(nodes,values,der_values,t);
  
  subplot(1,2,1);
  plot(nodes,speed)
  xlabel("time");ylabel("speed");
  xticks(0:100:1000);yticks(40:10:120);
  grid on;
  
  subplot(1,2,2);
  plot(nodes,dist)
  xlabel("time");ylabel("distance");
  xticks(0:100:1000);yticks(40:10:120);
  grid on;
endfunction

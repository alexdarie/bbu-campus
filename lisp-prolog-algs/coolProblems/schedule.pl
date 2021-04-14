% There you have a very simple university schedule
% that will represent SCH Knowledge Base
schedule(monday, programming).
schedule(tuesday, math).
schedule(tuesday, english).
schedule(wednesday, programming).
schedule(wednesday, spanish).
schedule(thursday, circuits).
schedule(friday, none).

% Also we'll have a label which defines the difficulty
% that will represent DIF Knowledge Base
difficulty(programming, medium).
difficulty(math, hard).
difficulty(english, medium).
difficulty(spanish, easy).
difficulty(circuits, medium).

% And last but not least, we'll have class information
% built based on the SCH and DIF KBs
classInformation(Day, Class, Diff) :-
	schedule(Day, Class),
	difficulty(Class, Diff).

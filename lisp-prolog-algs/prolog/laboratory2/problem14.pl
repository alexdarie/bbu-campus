% This predicate is used for debugging. It is called when we reach the last
% recursive call of the evenSequence predicate.
displayEvenSequenceResult(P, Q)
:-
	format("Sequence start position: %d, length: %d\n", [P, Q]).

% ------------------------------------------------------------------------------
% Flow model:
% evenSequence(
% 	input: 	List,
% 	input: 	Iterator,
% 	input: 	Start,
% 	input: 	Size,
% 	acc: 	P,
% 	acc: 	Q,
% 	output: StartPosition,
% 	output: SequenceSize
% )

% Since we reached the empty list, meaning that we iterate through all the
% elements, we can set the output variables in order to save the result from
% being lost in the recursive stack.
evenSequence([], _, _, _, P, Q, StartPosition, SequenceSize)
:-
	displayEvenSequenceResult(P, Q),
	StartPosition is P,
	SequenceSize is Q.

% On this branch we are going forward and increase the size.
evenSequence(
	[Head | Tail],
	Iterator,
	Start,
	Size,
	P,
	Q,
	StartPosition,
	SequenceSize
)
:-
	Rest is Head mod 2,
	Rest =:= 0,
	UpdatedSize is Size + 1,
	UpdatedIterator is Iterator + 1,
	evenSequence(Tail, UpdatedIterator, Start, UpdatedSize, P, Q, StartPosition,
				 SequenceSize).


% On this branch we are updating the final variables and move to the next
% element.
evenSequence(
	[Head | Tail],
	Iterator,
	Start,
	Size,
	P,
	Q,
	StartPosition,
	SequenceSize
)
:-
	Rest is Head mod 2,
	Rest =:= 1,
	Size > Q,
	UpdatedIterator is Iterator + 1,
	evenSequence(Tail, UpdatedIterator, UpdatedIterator, 0, Start, Size,
				 StartPosition, SequenceSize).



evenSequence(
	[Head | Tail],
	Iterator,
	Start,
	Size,
	P,
	Q,
	StartPosition,
	SequenceSize
)
:-
	Rest is Head mod 2,
	Rest =:= 1,
	Size =< Q,
	UpdatedIterator is Iterator + 1,
	evenSequence(Tail, UpdatedIterator, UpdatedIterator, 0, P, Q,
				 StartPosition, SequenceSize).

% ------------------------------------------------------------------------------
% Flow model:
% parseListSequences(
% input: 	List,
% output: 	UpdateList
% )

parseListSequences([], []).


parseListSequences([Head | Tail], UpdatedList)
:-
	is_list(Head),
	greatestEvenSequence(Head, StartPosition, SequenceSize),
	EndPosition is StartPosition + SequenceSize - 1,
	updateSequence(Head, StartPosition, EndPosition, 0, UpdatedHead),
	parseListSequences(Tail, List),
	UpdatedList = [UpdatedHead | List].


parseListSequences([Head | Tail], UpdatedList)
:-
	number(Head),
	parseListSequences(Tail, List),
	UpdatedList = [Head | List].

% ------------------------------------------------------------------------------
% Flow model:
% updateSequence(
% input: 	List,
% input:    Start,
% input:	End,
% acc:		Iterator,
% output: 	UpdateList
% )
updateSequence([], _, _, _, []).


updateSequence(
	[Head | Tail],
	StartPosition,
	EndPosition,
	Iterator,
	UpdatedList
)
:-
	Iterator >= StartPosition,
	Iterator =< EndPosition,
	UpdatedIterator is Iterator + 1,
	updateSequence(Tail, StartPosition, EndPosition, UpdatedIterator, List),
	UpdatedList = [Head | List].


updateSequence(
	[Head | Tail],
	StartPosition,
	EndPosition,
	Iterator,
	UpdatedList
)
:-
	UpdatedIterator is Iterator + 1,
	updateSequence(Tail, StartPosition, EndPosition, UpdatedIterator, UpdatedList).

% ------------------------------------------------------------------------------
% This is a wrapper for the evenSequence predicate.
% evenSequence(
% 	List: 		[],
% 	Iterator: 	0,
% 	Start: 		0,
% 	Size:		0,
% 	P:			0,
% 	Q: 			0,
% 	output: StartPosition,
% 	output: SequenceSize
% )
greatestEvenSequence(List, StartPosition, SequenceSize)
:-
	evenSequence(List, 0, 0, 0, 0, 0, StartPosition, SequenceSize).

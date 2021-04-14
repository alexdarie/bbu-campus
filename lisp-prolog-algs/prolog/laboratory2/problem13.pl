% ------------------------------------------------------------------------------
% Flow model:
% removeIncreasingSequences(
% 	input: 	 List,
% 	output:  UpdatedList
% )

removeIncreasingSequences([], []).



removeIncreasingSequences(
    [FirstElement, SecondElement, ThirdElement | Tail],
    UpdatedList
)
:-
    FirstElement is SecondElement - 1,
    SecondElement is ThirdElement - 1,
    removeIncreasingSequences([SecondElement, ThirdElement | Tail], UpdatedList).



removeIncreasingSequences(
    [FirstElement, SecondElement, ThirdElement | Tail],
    UpdatedList
)
:-
    FirstElement is SecondElement - 1,
    removeIncreasingSequences([ThirdElement | Tail], UpdatedList).



removeIncreasingSequences(
    [FirstElement, SecondElement, ThirdElement | Tail],
    UpdatedList
)
:-
    removeIncreasingSequences([SecondElement, ThirdElement | Tail], List),
    UpdatedList = [FirstElement | List].



removeIncreasingSequences(
    [FirstElement, SecondElement],
    UpdatedList
)
:-
    FirstElement is SecondElement - 1,
    removeIncreasingSequences([], UpdatedList).


removeIncreasingSequences(
    [FirstElement, SecondElement],
    UpdatedList
)
:-
    removeIncreasingSequences([SecondElement], List),
    UpdatedList = [FirstElement | List].


removeIncreasingSequences([FirstElement], [FirstElement]).

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
	removeIncreasingSequences(Head, UpdatedHead),
    parseListSequences(Tail, List),
	UpdatedList = [UpdatedHead | List].


parseListSequences([Head | Tail], UpdatedList)
:-
	number(Head),
	parseListSequences(Tail, List),
	UpdatedList = [Head | List].

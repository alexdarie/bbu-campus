% KNOWLEDGE BASE
% Flow: select_ith(input, input, input, output).
% 		select_ith(List, Position, Iterator, Item).
% 
select_ith([], _, _, Item) :- 
    Item is -1.
%
select_ith([H|_], Position, Iterator, Item) :-
    Position =:= Iterator,
    Item is H.
%
select_ith([_|T], Position, Iterator, Item) :-
    Position =\= Iterator,
    NewIterator is Iterator + 1,
    select_ith(T, Position, NewIterator, Item).



% KNOWLEDGE BASE
% Flow: diff_size(input, input, output).
% 		diff_size(LeftList, RightList, Result).
% 
diff_size(P, Q, Boolean) :-
    length(P, PLength),
    length(Q, QLength),
    PLength =:= QLength,
    Boolean is 1.
%
diff_size(P, Q, Boolean) :-
    length(P, PLength),
    length(Q, QLength),
    PLength =\= QLength,
    Boolean is 0.



% KNOWLEDGE BASE
% Flow: contains(input, input, output).
% 		contains(LeftList, RightList, Result).
% 
contains(_, [], Result) :-
    Result is 0.
%
contains(Item, [H|_], Result) :-
    Item =:= H,
    Result is 1.
%
contains(Item, [H|T], Result) :-
    Item =\= H,
    contains(Item, T, Result).



% KNOWLEDGE BASE
% Flow: same(input, input, output).
% 		same(LeftList, RightList, Result).
% there is nothing more on the left set to be searched in the right set.
same([], _, Boolean) :-
    Boolean is 1.
% 
same([H|T], Q, Boolean) :-
    contains(H, Q, IsContained),
    IsContained =:= 1,
    same(T, Q, Boolean).
%
same([H|_], Q, Boolean) :-
    contains(H, Q, IsContained),
    IsContained =:= 0,
    Boolean is 0.



% KNOWLEDGE BASE
% Flow: set_equals(input, input, output)
% 		set_equals(LeftList, RightList, Result)
%
set_equals(P, Q, Boolean) :-
    diff_size(P, Q, IsDiff),
    IsDiff =:= 0,
    Boolean is 0.
%
set_equals(P, Q, Boolean) :-
    diff_size(P, Q, IsDiff),
    IsDiff =:= 1,
    same(P, Q, IsSame),
    Boolean is IsSame.



% SECOND IMPLEMENTATION

% KNOWLEDGE BASE
% Flow: select_element(input, input, imput, output)
% 		select_element(L: list, P: integer, I: integer, R: integer)
%
select_element([], _, _, []).
%
select_element([H|_], P, I, R) :- 
    P =:= I, 
    R is H.
%
select_element([_|T], P, I, R) :- 
    P =\= I, 
    I2 is I + 1, 
    selectElement(T, P, I2, R).



% KNOWLEDGE BASE
% Flow: found(input, input, output)
% 		found(E: integer, A: list, R: integer)
%
found(_, [], R) :- 
    R is 0.
%
found(E, [H|_], R) :- 
    H =:= E, 
    R is 1.
%
found(E, [H|T], R) :- 
    H =\= E, 
    found(E, T, R).



% KNOWLEDGE BASE
% Flow: len(input, output).
% 		len(A: list, R: integer)
%
len([], 0).
%
len([_|T], R) :- 
    len(T, RT), 
    R is RT + 1.



% KNOWLEDGE BASE
% Flow: setEquality(input, input, imput, output)
% 		setEquality(A: list, B: list, E: integer, R: integer)
%
setEquality(A, B, _, R):- len(A, RES1), len(B, RES2), RES1 =\= RES2, R is 0.
setEquality([], B, E, R):- len(B, RES), RES =\= E, R is 0.
setEquality([], B, E, R):- len(B, RES), RES =:= E, R is 1.
setEquality([H|T], B, E, R):- found(H, B, RES), RES =:= 1, E2 is E + 1, setEquality(T, B, E2, RT), R is RT.
setEquality([H|T], B, E, R):- found(H, B, RES), RES =:= 0, setEquality(T, B, E, RT), R is RT.

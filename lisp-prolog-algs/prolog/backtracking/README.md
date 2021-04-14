
Permutations 

![ ](https://github.com/alexdarie/Logic-and-functional-programming/blob/master/prolog/backtracking/perm.jpg)

```
perm([], []).
perm([H | T], Result) :-
    perm(T, TR),
    disperse(TR, H, Result).

disperse([], E, [E]).
disperse([H | T], E, [E, H | T]).
disperse([H | T], E, [H | Tr]) :-
    disperse(T, E, Tr).
```

### Combinations

```
comb(0, _, []).
comb(N, [X|T], [X | Comb]) :-
    N > 0,
    N1 is N - 1,
    comb(N1, T, Comb).
comb(N,[_ | T],Comb) :-
    N > 0,
    comb(N, T, Comb).

allComb(L, N, Result) :-
    findall(ResPartialPred, comb(N, L, ResPartialPred), Result).
```

1. Collect all combinations.
```
collectAllComb(_, 0, []).
collectAllComb(L, Size, Result) :-
    Size1 is Size - 1,
    collectAllComb(L, Size1, TR),
    allComb(L, Size, X),
    append(X, TR, Result).
```

2. Collect all combinations of odd/even length.

`<getComb> (<list>, <result>, <1 for odd length, 0 for even length>)`

```
collectAllComb(_, Size, Result) :-
    Size < 0,
    Result = [].
collectAllComb(L, Size, Result) :-
    Size1 is Size - 2,
    collectAllComb(L, Size1, TR),
    allComb(L, Size, X),
    append(X, TR, Result).

getComb(L, R, OddEven) :-
    length(L, Size),
    OddEven is mod(Size, 2),
    collectAllComb(L, Size, R).
getComb(L, R, OddEven) :-
    length(L, Size),
    Size1 is Size - 1,
    collectAllComb(L, Size1, R).
```

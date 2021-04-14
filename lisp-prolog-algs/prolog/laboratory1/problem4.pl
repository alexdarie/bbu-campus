%insertOneAfterEven(L: list, R: list)
%insertOneAfterEven(i, o)
insertOneAfterEven([], []).
insertOneAfterEven([H|T], R):-H mod 2 =:= 0, insertOneAfterEven(T, RT), R=[H, 1|RT].
insertOneAfterEven([H|T], R):-H mod 2 =:= 1, insertOneAfterEven(T, RT), R=[H|RT].

%found(E: integer, A: list, R: integer)
%found(i, i, o)
found(_, [], R):-R is 0.
found(E, [H|_], R):-H=:=E, R is 1.
found(E, [H|T], R):-H=\=E, found(E, T, R).

%setDiff(A: list, B: list, R: list)
%setDiff(i, i, o)
setDiff([], _, []).
setDiff(A, [], A).
setDiff([H|T], B, R):-found(H, B, RES), RES =:= 1, setDiff(T, B, RT), R = RT.
setDiff([H|T], B, R):-found(H, B, RES), RES =:= 0, setDiff(T, B, RT), R = [H|RT].

1. Se defineste in LISP functia F prin (DEFUN F(L) (MAX (CAR L) (CADDR L))) si variabila F prin (SETQ F 10). In ideea redenumirii functiei F se efectueaza (SETQ G 'F). Ce se va obtine prin evaluare formei (G '(8 11 2 3 7 9))? Justificati raspunsul si dati o solutie pentru o astfel de situatie. Justificati solutia data.

```
(DEFUN F (L)
    (MAX (CAR L) (CADDR L))
)

(SETQ F 10)
(SETQ G 'F)

(PRINT (funcall G '(1 2 3)))
```

The majority of Lisps have two namespaces (functions and variables). A name is looked up in the function namespace when it appears as the first element in an S-expression, and in the variable namespace otherwise. This allows you to name your variables without worrying about whether they shadow functions.

A symbol-manipulation program uses symbolic expressions to remember and work with data and procedures, just as people use pencil, paper, and human language to remember and work with data and procedures. A symbol- manipulation program typically has sections that recognize particular symbolic expressions, tear old ones apart, and assemble new ones.

2. 

```
remove([], _, []).
remove([H | T], K, R) :-
    number(H),
    remove(T, K, TR),
    R = [H | TR].
remove([H | T], K, R) :-
    is_list(H),
    length(H, Size),
    1 is mod(Size, 2),
    remove(T, K, TR),
    R = [H | TR].
remove([H | T], K, R) :-
    K =:= 0,
    remove(T, K, TR),
    R = [H | TR].
remove([H | T], K, R) :-
    is_list(H),
    length(H, Size),
    0 is mod(Size, 2),
    K1 is K - 1,
    remove(T, K1, TR),
    R = TR.
```

3. Sa se scrie un program in Prolog care genereaza lista submultimilor de suma S data, cu elementele unei liste. Explicati algoritmul propus.

```
comb(0, _, []).
comb(K, [H | T], R) :-
    K > 0,
    K1 is K - 1,
    comb(K1, T, TR),
    R = [H | TR].
comb(K, [_ | T], R) :-
    K > 0,
    comb(K, T, TR),
    R = TR.

getComb(N, L, R) :-
    findall(OneComb, comb(N, L, OneComb), R).

collectAllComb(L, Size, R) :-
    Size =< 0,
    R = [].
collectAllComb(L, Size, R) :-
    Size > 0,
    Size1 is Size - 1,
    collectAllComb(L, Size1, TR),
    getComb(Size1, L, X),
    append(X, TR, R).

sum([], 0).
sum([H | T], S) :-
    sum(T, TS),
    S is H + TS.

check([], _, []).
check([H | T], Value, R) :-
    sum(H, ListSum),
    Value =:= ListSum,
    check(T, Value, TR),
    R = [H | TR].
check([H | T], Value, R) :-
    check(T, Value, TR),
    R = TR.

main(L, R, Value):-
    length(L, Size),
    collectAllComb(L, Size, R1),
    check(R1, Value, R).
```

4.  Un arbore n-ar se reprezinta in LISP astfel (nod subarbore1 subarbore2). Se cere sa se inlocuiasca nodurile de pe nivelul k din arbore cu o valoare `e` data. Nivelul radacina se considera a fi 0. Indicatie: se va putea folosi o functie MAP.

```
(DEFUN change (L level k e)
    (COND
        ((AND (= k level) (ATOM L)) (LIST e))
        ((ATOM L) (LIST L))
        (T (LIST (APPLY 'APPEND (MAPCAR (lambda(x) (change x (+ 1 level) k e)) L))))
    )
)

(PRINT (change '(a (b (g)) (c (d (e)) (f))) -1 2 'h))
```

5. Se da o lista neliniara. Sa se scrie un program LISP pentru determinarea numarului de subliste de la orice nivel pentru care primul atom numeric la orice nivel este numar par. Prelucrarea se va face folosind a functie MAP. De exemplu, pentru lista (A 3 (B 2) (1 C 4) (D 2 (6 F)) ((G 4) 6)) are 5 astfel de subliste: (B 2), (D 2 (6 F)), (6 F), ((G 4) 6) si (G 4).

```
(DEFUN getFirstNumber (L)
    (COND
        ((NULL L) NIL)
        ((NUMBERP (CAR L)) (CAR L))
        (T (getFirstNumber (CDR L)))
    )
)

(DEFUN getFirstFromAllLevels (L)
    (COND
        ((LISTP L) (APPEND (LIST (getFirstNumber L)) (APPLY 'APPEND (MAPCAR 'getFirstFromAllLevels L))))
        ((ATOM L) NIL)
        (T (APPLY 'APPEND (MAPCAR 'getFirstFromAllLevels L)))
    )
)

(DEFUN countOdd (L)
    (COND
        ((NULL L) 1)
        ((AND (ATOM L) (EQUAL (MOD L 2) 0)) 0)
        ((ATOM L) 1)
        (T (APPLY '+ (MAPCAR 'countOdd L)))
    )
)

(DEFUN good (L)
    (AND (LISTP L) (= (countOdd (getFirstFromAllLevels L)) 0))
)

(DEFUN countLists (L)
    (COND
        ((NULL L) 0)
        ((good L) (progn (PRINT L) (+ 1 (APPLY '+ (MAPCAR 'countLists L)))))
        ((atom L) 0)
        (T (APPLY '+ (MAPCAR 'countLists L)))
    )
)

(PRINT (countLists '(a 3 (b 2) (1 c 4) (d 2 (6 f)) ((g 4) 6)) ))
```

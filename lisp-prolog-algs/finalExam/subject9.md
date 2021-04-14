The subjects are graded as follows: (1) - 1p; (2) - 2p; (3) - 2p; (4) - 2p; (5) - 3p

1. We define in Prolog the following predicate with the flow model `(i, o)`. Explain the logical error in the following sequence, and correct it:
```
f([], 0).
f([H|T], S) :-
    f(T, S1),
    S1 is S - H.
```

2. Write a Prolog program that, given a list of integer numbers and lists of integer numbers, computes the list in reversed order (each sublist is reversed). Explain the proposed algorithm. For example, for [1, [2, 4, 3], 5, [6, 7]] the result is [[7, 6], 5, [3, 4, 2], 1].

3. Write a Prolog program to generate the list of subsets of N elements from a list. Explain the proposed algorithm. For example, if the list is [2, 3, 4], N=2, then we'll have [[2, 3], [2, 4], [3, 4]].

4. Write a Lisp function to return a non-linear list with all occurances of a certain element, e, removed. For example, if the list is (1 (2 A (3 A)) (A)) and e is A, then the result will be (1 (2 (3)) NIL) and if the list is (1 (2 (3))) and e is A, then the result will be the original list.

```
(DEFUN removeAllOcc (L value)
    (COND
        ((NULL L) NIL)
        ((EQUAL (CAR L) value) (removeAllOcc (CDR L) value))
        ((ATOM (CAR L)) (CONS (CAR L) (removeAllOcc (CDR L) value)))
        (T (CONS (removeAllOcc (CAR L) value)
                 (removeAllOcc (CDR L) value)))
    )
)

(PRINT (removeAllOcc '(1 (2 A (3 A)) (A)) 'A))
```

5. Write a Lisp program to determine the number of sublists at any level of a given list, where the last atom (at any level) is non-numeric. The list processing will be done using a MAP function. For example, the list (A (B 2) (1 C 4) (D 1 (6 F)) ((G 4) 6) F) has 2 such sublists: (6 F), (D 1 (6 F)). 

```

(DEFUN good (L)
    (AND (LISTP L) (NOT (NUMBERP (CAR (LAST L)))))
)

(DEFUN count (L)
    (COND
        ((good L) (+ 1 (APPLY '+ (MAPCAR 'count L))))
        ((ATOM L) 0)
        (T (APPLY '+ (MAPCAR 'count L)))
    )
)

(PRINT (count '(A (B 2) (1 C 4) (D 1 (6 F)) ((G 4) 6) F)))
```

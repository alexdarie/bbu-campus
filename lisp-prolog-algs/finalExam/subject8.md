4 .Write a Lisp program and deduce the complexity for the following requirement. Given a linear numerical list, generate a new list with every N-th element removed. For example, for (1 2 3 4 5) and N = 2, the result will be (1 3 5).
```
(DEFUN erase (L pos step)
    (COND
        ((NULL L) NIL)
        ((= (MOD pos step) 0) (erase (CDR L) (+ 1 pos) step))
        (T (CONS (CAR L) (erase (CDR L) (+ 1 pos) step)))
    )
)

(PRINT (erase '(1 2 3 4 5) 1 2))
```

5. Write a Lisp program to determine the number of sublists at any level of a given list, having an odd number of non-numeric atoms on even levels. The superficial level of the list is considered 1. The list processing will be done using a MAP function. For example, the list (A (B 2) (1 C 4) (1 (6 F))) (((G) 4) 6)) has 3 such sublists: the list, (1 (6 F)) and ((G) 4). 

```
(DEFUN countNonNumericAtoms (L)
    (COND
        ((NULL L) 0)
        ((AND (NOT (NUMBERP L)) (ATOM L)) 1)
        ((ATOM L) 0)
        (T (APPLY '+ (MAPCAR 'countNonNumericAtoms L)))
    )
)

(DEFUN getEvenLevels (L cl)
    (COND
        ((AND (= (MOD cl 2) 0) (ATOM L)) (LIST L))
        ((ATOM L) NIL)
        (T (APPLY 'APPEND (MAPCAR (lambda(x) (getEvenLevels x (+ 1 cl))) L)))
    )
)

(DEFUN good (L)
    (AND (LISTP L) (= (MOD (countNonNumericAtoms (getEvenLevels L 0)) 2) 1))
)

(DEFUN countLists (L)
    (COND
        ((good L) (PROGN (PRINT L) (+ 1 (APPLY '+ (MAPCAR 'countLists L)))))
        ((ATOM L) 0)
        (T (APPLY '+ (MAPCAR 'countLists L)))
    )
)

(PRINT (countLists '(A (B 2) (1 C 4) (1 (6 F)) (((G) 4) 6))))
```

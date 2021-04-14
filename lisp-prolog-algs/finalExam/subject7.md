4. Give two recursive implementations for the following requirement: Replace all even numerical values in a given non-linear list with their natural successor. For example, for the list (1 s 4 (2 f (7))) the result is (1 s 5 (3 f (7))).

version 1
```
(DEFUN replaceEven (L)
    (COND
        ((AND (NUMBERP L) (EQUAL (MOD L 2) 0)) (LIST (+ 1 L)))
        ((ATOM L) (LIST L))
        (T (LIST (APPLY 'APPEND (MAPCAR 'replaceEven L))))
    )
)
```

version 2
```
(DEFUN replaceEven (L)
    (COND
        ((AND (NUMBERP L) (EQUAL (MOD L 2) 0)) (+ 1 L))
        ((ATOM L) L)
        (T (CONS (replaceEven (CAR L)) (replaceEven (CDR L)) ))
    )
)
```

run
```
(PRINT (replaceEven '(1 s 4 (2 f (7)))))
```

5. Write a Lisp program to determine the number of sublists of a given list, where the maximal numeric atom on all odd levels is even - the superficial level of the list is considered 1. The list processing will be done using a MAP function. For example, the list (A (B 2) (1 C 4) (1 (6 F))) (((G) 4) 6)) has 4 such sublists: the list, (B 2) (1 C 4), ((G) 4) and (((G) 4) 6).

```
(DEFUN squash (L)
    (COND
        ((NULL L) NIL)
        ((NUMBERP L) (LIST L))
        ((ATOM L) NIL)
        (T (APPLY 'APPEND (MAPCAR 'squash L)))
    )
)

(DEFUN getOddLevels (L cl)
    (COND
        ((AND (= (MOD cl 2) 1) (ATOM L)) (LIST L))
        ((ATOM L) NIL)
        (T (APPLY 'APPEND (MAPCAR (lambda(x) (getOddLevels x (+ 1 cl))) L)))
    )
)

(DEFUN checkMax (L)
    (COND
        ((> (LENGTH (squash (getOddLevels L 0))) 1) (EQUAL (MOD (APPLY 'MAX (squash (getOddLevels L 0))) 2) 0))
        ((= (LENGTH (squash (getOddLevels L 0))) 1) (EQUAL (MOD (CAR (squash (getOddLevels L 0))) 2) 0))
        (T NIL)
    )
)

; The good old good function
(DEFUN good (L)
    (AND (NOT (NULL L)) (AND (LISTP L) (checkMax L)))
)

; The main function for this type of problems. Get the lists and check if they are good for your problem.
(DEFUN countLists (L)
    (COND
        ((good L) (progn (PRINT L) (+ 1 (APPLY '+ (MAPCAR 'countLists L)))))
        ((ATOM L) 0)
        (T (APPLY '+ (MAPCAR 'countLists L)))
    )
)

(PRINT (countLists '(A (B 2) (1 C 4) (1 (6 F)) (((G) 4) 6))))
```

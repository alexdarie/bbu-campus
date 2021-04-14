; c. Write a function to return the set of all the atoms of a list.

(DEFUN squash (L)
    (COND
        ((NULL L) NIL)
        ((ATOM L) (LIST L))
        (T (APPLY 'APPEND (MAPCAR 'squash L)))
    )
)

(DEFUN LTOS (L)
    (COND
        ((NULL L) NIL)
        ((NOT (MEMBER (CAR L) (CDR (MEMBER (CAR L) L)))) (CONS (CAR L) (LTOS (CDR L))))
        (T (LTOS (CDR L)))
    )
)

(PRINT (LTOS (squash '(1 (2 (1 3 (2 4) 3) 1) (1 4)) )))

; d. Write a function to test whether a linear list is a set.

(DEFUN SETP (L)
    (COND
        ((NULL L) T)
        ((MEMBER (CAR L) (CDR (MEMBER (CAR L) L))) NIL)
        (T (AND T (SETP (CDR L))))
    )
)

(PRINT (SETP '(0 1 9)))

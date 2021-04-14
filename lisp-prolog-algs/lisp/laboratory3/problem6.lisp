; Write a function that returns the maximum of numeric atoms in a list, at any level.

(DEFUN listMax (L)
    (COND
        ((NULL L) nil)
        ((ATOM L) L)
        (T (APPLY 'MAX (MAPCAR 'listMax L)))
    )
)

(PRINT (listMax '(9 (1 7) (3 (10 11)))))

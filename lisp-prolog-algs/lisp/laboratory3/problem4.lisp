; Write a function that returns the product of numeric atoms in a list, at any level.

(DEFUN sum (L)
    (COND
        ((NULL L) 1)
        ((NUMBERP L) L)
        ((ATOM L) 1)
        (T (APPLY '* (MAPCAR 'sum L)))
    )
)

(PRINT (sum '(9 1 3 (A B 1) 1 B)))

; Write a function that returns the sum of numeric atoms in a list, at any level.

(DEFUN sum (L)
    (COND
        ((NULL L) 0)
        ((NUMBERP L) L)
        ((ATOM L) 0)
        (T (APPLY '+ (MAPCAR 'sum L)))
    )
)

(PRINT (sum '(9 1 3 (A B 4) 13 B)))

; Write a function that reverses a list together with all its sublists elements, at any level.

(DEFUN my_reverse (L)
    (COND
        ((NULL L) NIL)
        ((ATOM L) L)
        (T (MAPCAR 'my_reverse (reverse L)))
    )
)

(PRINT (my_reverse '((1) (2 3 1) (1 (2 3 (1)))) ))

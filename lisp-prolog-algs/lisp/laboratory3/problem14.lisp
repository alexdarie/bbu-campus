; Write a function that returns the number of atoms in a list, at any level.

(DEFUN countAtoms (L)
    (COND
        ((NULL L) 0)
        ((ATOM L) 1)
        (T (APPLY '+ (MAPCAR 'countAtoms L)))
    )
)

(PRINT (countAtoms '((1) (2 3 1) (1 (2 3 (1)))) ))

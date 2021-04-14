; Write a function to check if an atom is member of a list (the list is non-liniar)

(DEFUN hasAtom (X L)
    (COND
        ((NULL L) 0)
        ((AND (EQUAL L X) (ATOM L)) 1)
        ((ATOM L) 0)
        (T (APPLY '+ (MAPCAR (lambda (L) (hasAtom X L)) L)))
    )
)

(PRINT (hasAtom 0 '(9 (1 2 3) 7 (0))))

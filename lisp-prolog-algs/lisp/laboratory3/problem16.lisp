; Write a function that produces the linear list of all atoms of a given list, from 
; all levels, and written in the same order. Eg.: (((A B) C) (D E)) --> (A B C D E)

(DEFUN linear (L)
    (COND
        ((NULL L) NIL)
        ((ATOM L) (LIST L))
        (T (APPLY 'APPEND (MAPCAR 'linear L)))
    )
)

(PRINT (linear '((1) (2 3 1) (1 (2 3 (1)))) ))

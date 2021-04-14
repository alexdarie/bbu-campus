; b. Write a function to get from a given list the list of all atoms, on any level, but on 
; the same order. For example: (((A B) C) (D E)) ==> (A B C D E)

(DEFUN squash (L)
    (COND 
        ((AND (ATOM L) (NOT (NULL L))) (LIST L))
        ((NOT (NULL L)) (APPEND (squash (CAR L)) (squash (CDR L))))
    )
)

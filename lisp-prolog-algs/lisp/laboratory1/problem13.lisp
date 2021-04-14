; b. Write a function to test if a linear list of integer numbers has a "valley" aspect (a list 
; has a valley aspect if the items decrease to a certain point and then increase. Eg. (10 8 6 17 
; 19 20). A list must have at least 3 elements to fullfill this condition.

(DEFUN valley (L)
(PRINT L)
    (COND
        ((< (LENGTH L) 3) T)
        ((< (CAR L) (CAR (CDR L))) NIL)
        ((< (CAR (LAST L)) (CAR (LAST (BUTLAST L)))) NIL)
        (T (AND T (valley (CDR (BUTLAST L)))))
    )
)

(PRINT (valley '(10 2 7 3 20)))

; c. Build a function that returns the minimum numeric atom from a list, at any level.

(DEFUN squash (L)
    (COND
        ((NULL L) NIL)
        ((NUMBERP L) (LIST L))
        ((ATOM L) NIL)
        (T (APPEND (squash (CAR L)) (squash (CDR L))))
    )
)

(DEFUN transaction (functionName L)
    (APPLY functionName (squash L))
)

(PRINT (transaction 'MIN '(1 (2 (1 A (2 4) 3) 1) (1 4)) ))

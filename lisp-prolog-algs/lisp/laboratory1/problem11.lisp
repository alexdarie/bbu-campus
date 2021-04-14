; b. Write a function to test if a linear list of numbers has a "mountain" aspect (a list 
; has a "mountain" aspect if the items increase to a certain point and then decreases.
; Eg. (10 18 29 17 11 10). The list must have at least 3 atoms to fullfil this criteria.

(DEFUN mountain (L)
(PRINT L)
    (COND
        ((< (LENGTH L) 3) T)
        ((> (CAR L) (CAR (CDR L))) NIL)
        ((> (CAR (LAST L)) (CAR (LAST (BUTLAST L)))) NIL)
        (T (AND T (mountain (CDR (BUTLAST L)))))
    )
)

(PRINT (mountain '(10 18 29 17 11 10)))

; d. Write a function which returns the product of numerical even atoms from a list, to any level.
;

(DEFUN prod (L)
    (COND
        ((NULL L) 1)
        ((AND (NUMBERP (CAR L)) (= (mod (CAR L) 2) 0)) (* (CAR L) (prod (CDR L))))
        (T (prod (CDR L)))
    )
)

(PRINT (prod '(2 N (10 N) 5 4 (3) A)))

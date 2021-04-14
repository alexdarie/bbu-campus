; a. Write a function to return the product of two vectors.
;
; dotProduct(e1..en, v1..vn) = { 0, e1 is nil
;                               e1*v1 + dotProduct(e2..en, v2..vn), otherwise    

(DEFUN dotProduct (v1 v2)
    (COND
        ((NULL v1) 0)
        (T (+ (* (CAR v1) (CAR v2)) (dotProduct (CDR v1) (CDR v2))))
    )
)

(PRINT (dotProduct '(1 3 -1) '(5 -1 -3)))

; b. Write a function to return the maximum value of all the numerical atoms of a list, at any level.

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

(PRINT (transaction 'MAX '(1 (2 (1 A (2 4) 3) 1) (1 4)) ))

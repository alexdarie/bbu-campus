
; c. Write a function to determine the list of all sublists of a given list, on any level. A sublist is either the 
; list itself, or any element that is a list, at any level. Example: (1 2 (3 (4 5) (6 7)) 8 (9 10))  => 5 sublists
; ( (1 2 (3 (4 5) (6 7)) 8 (9 10)) (3 (4 5) (6 7)) (4 5) (6 7) (9 10) )
;
; unlist(e1..en) = { NIL, e1 is nil
;                    e1 U unlist(e1) U unlist(e2..en), e1 is a list
;                    unlist(e2..en), e1 is not a list

(DEFUN unlist (L)
    (COND
        ((NULL L) NIL)
        ((LISTP (CAR L)) (CONS (CAR L)
                               (APPEND (unlist (CAR L))  ; * APPEND to avoid seeing NIL
                                       (unlist (CDR L)))))
        (T (unlist (CDR L)))
    )
)

;* when we reach the end of a list, then the function returns NIL, and if we CONS NIL to a list, we'll
;  got a list containing a NIL value. (APPEND NIL '(1 2)) generates (1 2), while (CONS NIL '(1 2)) generates (NIL 1 2)
(PRINT (unlist '(1 2 (3 (4 5) (6 7)) 8 (9 10)) ))

; second version
(DEFUN unlist (L)
    (COND
        ((NULL L) NIL)
        ((ATOM L) NIL)
        (T (CONS L (APPLY 'APPEND (MAPCAR 'unlist L))))
    )
)

(PRINT (unlist '(1 2 (3 (4 5) (6 7)) 8 (9 10)) ))

; d. Write a function to return the number of all numerical atoms in a list at superficial level.

(DEFUN countNr (L)
    (COND
        ((NULL L) 0)
        ((NUMBERP (CAR L)) (+ 1 (countNr (CDR L))))
        (T (countNr (CDR L)))
    )
)

(PRINT (countNr '(1 N (10 N) 4 (3) A)))

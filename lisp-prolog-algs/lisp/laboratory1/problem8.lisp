; a. Write a function to return the difference of two sets.
;
; my_difference(e1..en, V) = { NIL, E is nil
;                             e1 U my_difference(e2..en, V), e1 not in V
;                             my_difference(e2..en, V), e1 is in V
;

(DEFUN my_difference (E V)
    (COND
        ((NULL E) NIL)
        ((NOT (MEMBER (CAR E) V)) (CONS (CAR E) (my_difference (CDR E) V)))
        (T (my_difference (CDR E) V))
    )
)

(PRINT (my_difference '(0 1 7 8 9) '(1 3 8 9)))

; d. Write a function to return the sum of all numerical atoms in a list at superficial level.

(DEFUN countNr (L)
    (COND
        ((NULL L) 0)
        ((NUMBERP (CAR L)) (+ (CAR L) (countNr (CDR L))))
        (T (countNr (CDR L)))
    )
)

(PRINT (countNr '(1 N (10 N) 4 (3) A)))

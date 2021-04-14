; a. Write a function to return the n-th element of a list, or NIL if such an element does not exist.
;
; my_nth(e1..en) = { NIL, e1 is nil
;                    e1, position = 0 (or 1), position is 1
;                    my_nth(e2..en), position is greater than 1

(DEFUN my_nth (L position)
    (COND
        ((NULL L) NIL)
        ((= position 0) (CAR L))
        (T (my_nth (CDR L) (- position 1)))
    )
)

(PRINT (my_nth '(1 2 4 1 23) 10))

; b. Write a function to check whether an atom E is a member of a list which is not necessarily linear.
;
; present(e1..en) = { T, e1 = ITEM
;                     NIL, e1 is nil
;                     NIL, e1 is an atom
;                     present(e1) OR present(e2..en), otherwise  

(DEFUN present (L item)
    (COND
        ((EQUAL (CAR L) item) T)
        ((ATOM (CAR L)) NIL)
        (T (OR) (present (CAR L) item) (present (CDR L)))
    )
)

(PRINT (present '(1 9 9 7) 1))

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

; d. Write a function to transform a linear list into a set.
;
; LTOS(e1..en) = { NIL, e1 is nil
;                  e1 U LTOS(e2..en), e1 is in (e2..en)
;                  LTOS(e2..en), e1 is not in (e2..en)

(DEFUN LTOS (L)
    (COND
        ((NULL L) NIL)
        ((NOT (MEMBER (CAR L) (CDR (MEMBER (CAR L) L)))) (CONS (CAR L) (LTOS (CDR L))))
        (T (LTOS (CDR L)))
    )
)

(PRINT (LTOS '(1 2 1 1 1)))

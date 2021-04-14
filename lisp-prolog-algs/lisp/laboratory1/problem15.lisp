; a. Write a function to insert an element E on the n-th position of a linear list.

(DEFUN insert (L position E)
    (COND
        ((AND (NULL L) (> position 0)) (LIST E))
        ((= position 0) (CONS E L))
        (T (CONS (CAR L) (insert (CDR L) (- position 1) E)))
    )
)

(PRINT (insert '() 0 9))

; b. Write a function to return the sum of all numerical atoms of a list, at any level.

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

(PRINT (transaction '+ '(1 (2 (1 A (2 4) B) 1) (1 X)) ))

; c. Write a function to return the set of all sublists of a given linear list. 
; For list ((1 2 3)((4 5) 6)) => ((1 2 3) (4 5) ((4 5) 6))

(DEFUN unlist (L)
    (COND
        ((NULL L) NIL)
        ((LISTP (CAR L)) (CONS (CAR L) (APPEND (unlist (CAR L)) (unlist (CDR L)))))
        (T (unlist (CDR L)))
    )
)

(PRINT (unlist '((1 2 3) ((4 5) 6 (1 2 3)))))
; ((1 2 3) ((4 5) 6 (1 2 3)) (4 5) (1 2 3))

(DEFUN LTOS (L)
    (COND
        ((NULL L) NIL)
        ((NOT (is_member (CAR L) (CDR (is_member (CAR L) L)))) (CONS (CAR L) (LTOS (CDR L))))
        (T (LTOS (CDR L)))
    )
)

(DEFUN is_member (E L)
    (COND
        ((NULL L) NIL)
        ((EQUAL (CAR L) E) L)
        (T (is_member E (CDR L)))
    )
)

(PRINT (LTOS (unlist '((1 2 3) ((4 5) 6 (1 2 3))))))
; (((4 5) 6 (1 2 3)) (4 5) (1 2 3))

; d. Write a function to test the equality of two sets, without using the difference of two sets.
;
; intersection(e1..en, V) = { NIL, E is nil
;                             e1 U intersection(e2..en, V), e1 is in V
;                             intersection(e2..en, V), e1 not in V

(DEFUN my_intersection (E V)
    (COND
        ((NULL E) NIL)
        ((MEMBER (CAR E) V) (CONS (CAR E) (my_intersection (CDR E) V)))
        (T (my_intersection (CDR E) V))
    )
)

; my_equality_v1(E, V) = { T, len(E∩V) = len(E) = len(V)
;                          NIL, otherwise

(DEFUN my_equality_v1 (E V)
    (COND
        ((AND (EQUAL (LENGTH (my_intersection E V)) (LENGTH E))
              (EQUAL (LENGTH (my_intersection E V)) (LENGTH V))) T)
        (NIL)
    )
)

(PRINT (my_equality_v1 '(0 1 3 7 8 9) '(1 3 8 0 9 7)))

; my_equality_v2(E, V) = { _equality(E, V), len(E) = len(V)
;                          NIL, otherwise

(DEFUN my_equality_v2 (E V)
    (COND
        ((= (LENGTH E) (LENGTH V)) (_equality E V))
        (NIL)
    )
)

; _equality(e1..en, V) = { T, E is nil (AND V is also nil due to the previous condition)
;                          NIL, e1 not in V
;                          T AND _equality(e2..en, V), e1 in V

(DEFUN _equality (E V)
    (COND
        ((NULL E) T)
        ((NOT (MEMBER (CAR E) V)) NIL)
        (T (AND T (_equality (CDR E) V)))
    )
)

(PRINT (my_equality_v2 '(0 1 3 7 8 9) '(1 3 8 0 9 7)))

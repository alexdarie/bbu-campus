; a. Write a function that inserts in a linear list a given atom A after the 2nd, 4th, 6th, ... element.

(DEFUN sublist (L s e)
    (subseq L s (+ s (+ (- e s) 1)))
)

(DEFUN special_insert (A L)
    (COND
        ((NULL L) NIL)
        ((= (LENGTH L) 1) L)
        (T (APPEND (sublist L 0 1) (CONS A (special_insert A (CDDR L)))))
    )
)

(PRINT (special_insert NIL '(1 2 3 4 5)))

; b. Write a function to get from a given list the list of all atoms, on any level, but reverse the order. For example: (((A B) C) (D E)) ==> (E D C B A)

(DEFUN squash (L)
    (COND 
        ((AND (ATOM L) (NOT (NULL L))) (LIST L))
        ((NOT (NULL L)) (APPEND (squash (CAR L)) (squash (CDR L))))
    )
)

(DEFUN reverse_list (input)
    (IF (> (LENGTH input) 1)
      (progn
          (SETQ returned_list (reverse_list (CDR (REVERSE (CDR (REVERSE input))))))
          (SETQ input (CONS (CAR (LAST input)) (REVERSE (CONS (CAR input) (REVERSE returned_list)))))))
    (return-from reverse_list input)
)

(DEFUN reversed_squash (L)
    (reverse_list (squash (L)))
)

; c. Write a function that returns the greatest common divisor of all numbers in a nonlinear list.
; 
; gcd(a, b) = { a, a-b=0
;               gcd(a, b-a), b>a
;               gcd(a-b, b), a>b
;
; lgcd(e1..en) = { gcd(e1, e2), the list has only two elements
;                  gcd(e1, lgcd(e2..en)), otherwise

(DEFUN squash (L)
    (COND
        ((NULL L) NIL)
        ((ATOM L) (LIST L))
        (T (APPLY 'APPEND (MAPCAR 'squash L)))
    )
)

(DEFUN my_gcd (a b)
    (COND
        ((= (- a b) 0) a)
        ((> a b) (my_gcd (- a b) b))
        (T (my_gcd a (- b a)))
    )
)

(DEFUN lgcd (L)
    (COND
        ((= (LENGTH L) 2) (my_gcd (CAR L) (CADR L)))
        (T (my_gcd (CAR L) (lgcd (CDR L))))
    )
)

(PRINT (lgcd (squash '(12 (102 6) (6 12 36)))))

; d. Write a function that determines the number of occurrences of a given atom in a nonlinear list.
;
; occurrences(e1..en) = { 0, e1 is nil
;                         1 + occurrences(e2..en), e1 = ITEM
;                         occurrences(e2..en), otherwise
;

(DEFUN squash (L)
    (COND
        ((NULL L) NIL)
        ((ATOM L) (LIST L))
        (T (APPLY 'APPEND (MAPCAR 'squash L)))
    )
)

(DEFUN occurrences (ITEM L)
    (COND
        ((NULL L) 0)
        ((= (CAR L) ITEM) (+ 1 (occurrences ITEM (CDR L))))
        (T (occurrences ITEM (CDR L)))
    )
)

(PRINT (occurrences 12 (squash '(12 (102 6) (6 12 36)))))

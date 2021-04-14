; b. Write a function to replace an element E by all elements of a list L1 at all levels of a given list L.

(DEFUN replace (item repl L)
    (COND
        ((NULL L) NIL)
        ((EQUAL item (CAR L)) (CONS repl (replace item repl (CDR L))))
        ((ATOM (CAR L)) (CONS (CAR L) (replace item repl (CDR L))))
        (T (CONS (replace item repl (CAR L)) (replace item repl (CDR L))))
    )
)

(PRINT (replace 1 3 '(1 0 (0 1 (0 (1))) 0 1)))

; d. Write a function to return the greatest common divisor of all numbers in a linear list.
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

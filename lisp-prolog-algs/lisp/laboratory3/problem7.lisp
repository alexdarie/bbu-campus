; Write a function that substitutes an element E with all elements of a list L1 at all levels of a given list L.

(DEFUN replace (L elem repl)
    (COND
        ((NULL L) NIL)
        ((AND (ATOM (CAR L)) (EQUAL (CAR L) elem)) (APPEND repl (replace (CDR L) elem repl)))
        ((ATOM (CAR L)) (CONS (CAR L) (replace (CDR L) elem repl)))
        (T (CONS (replace (CAR L) elem repl) (replace (CDR L) elem repl)))
    )
)

(PRINT (replace '((1 9) 9 (7) (1 2 3)) 2 '(100 101 102)))

; or the same solution as the problem 12

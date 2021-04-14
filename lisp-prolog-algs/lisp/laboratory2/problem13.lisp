; path to a given node X in a tree of type (2)

(DEFUN path (tree L X)
    (COND
        ((NULL tree) NIL)
        ((EQUAL X (CAR tree)) (reverse (CONS (CAR tree) L)))
        (T
           (APPEND
               (path (CADR tree) (CONS (CAR tree) L) X)
               (path (CADDR tree)  (CONS (CAR tree) L) X)
           )
        )
    )
)

(PRINT (path '(a (b (c)) (d (e) (f))) nil 'e))

; or if there are multiple nodes X

(DEFUN path (tree L X)
    (COND
        ((NULL tree) NIL)
        ((EQUAL X (CAR tree)) (LIST (reverse (CONS (CAR tree) L))))
        (T
           (APPEND
               (path (CADR tree) (CONS (CAR tree) L) X)
               (path (CADDR tree)  (CONS (CAR tree) L) X)
           )
        )
    )
)

(PRINT (path '(a (b (e)) (d (e) (f))) nil 'e))

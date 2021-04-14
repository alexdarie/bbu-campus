; 10. Return the level of a node X in a tree of type (2). The level of the root element is 0.

(DEFUN Xlevel (tree level X)
    (COND
        ((NULL tree) NIL)
        ((EQUAL X (CAR tree)) (LIST level))
        (T (APPEND (Xlevel (CADR tree) (+ level 1) X)
                   (Xlevel (CADDR tree) (+ level 1) X)
        ))
    )
)

(PRINT (Xlevel '(a (b (g (h))) (c (d (e) (f)))) 0 'e))

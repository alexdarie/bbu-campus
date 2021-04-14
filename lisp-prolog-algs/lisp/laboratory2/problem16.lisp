(DEFUN depth (tree level)
    (COND
        ((NULL tree) level)
        (T (MAX (depth (CADR tree) (+ level 1))
                (depth (CADDR tree) (+ level 1))))
    )
)

(DEFUN eqTree (tree)
    (COND
        ((NULL tree) T)
        ((> (- (depth (CADR tree) 0) (depth (CADDR tree) 0)) 1) NIL)
        (T (AND (eqTree (CADR tree)) (eqTree (CADDR tree))))
    )
)

(PRINT (eqTree '(a (b (g (h))) (c (d ((e) (f))))) ))

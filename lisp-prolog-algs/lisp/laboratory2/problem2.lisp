; nth level of a tree of type (2)

(DEFUN postorder (tree level givenLevel)
    (COND
        ((NULL tree) NIL)
        ((= level givenLevel) (LIST (CAR tree)))
        (T (progn
           (APPEND (postorder (CADR tree) (+ level 1) givenLevel)
                   (postorder (CADDR tree) (+ level 1) givenLevel)
                   ; (LIST (CAR tree))
           ))
        )
    )
)

(setq givenLevel 2)
(PRINT (postorder '(a (b (c)) (d (e) (f))) 0 givenLevel))

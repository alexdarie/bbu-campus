; Convert a tree of type (2) to type (1).

(DEFUN convert21 (tree)
    (COND
        ((NULL tree) NIL)
        ((= (LENGTH tree) 3) (APPEND (LIST (CAR tree) 2)
                                      (convert21 (CADR tree))
                                      (convert21 (CADDR tree))))
        ((= (LENGTH tree) 2) (APPEND (LIST (CAR tree) 1)
                                      (convert21 (CADR tree))))
        ((= (LENGTH tree) 1) (LIST (CAR tree) 0))
    )
)

(PRINT (convert21 '(a (b (c)) (d (e) (f))) ))

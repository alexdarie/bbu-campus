; Determine the list of nodes accesed in preorder in a tree of type (2).

(DEFUN preorder (tree)
    (COND
        ((NULL tree) NIL)
        (T (APPEND (LIST (CAR tree))
                   (APPEND (preorder (CADR tree)) (preorder (CADDR tree)))
        ))
    )
)

(PRINT (preorder '(a (b (c)) (d (e) (f)))))

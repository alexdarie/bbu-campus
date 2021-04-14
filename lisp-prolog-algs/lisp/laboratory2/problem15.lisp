; Determine the list of nodes accesed in postorder in a tree of type (2).

(DEFUN postorder (tree)
    (COND
        ((NULL tree) NIL)
        (T (APPEND (postorder (CADR tree))
                   (APPEND (postorder (CADDR tree)) (LIST (CAR tree)))
        ))
    )
)

(PRINT (postorder '(a (b (c)) (d (e) (f)))))

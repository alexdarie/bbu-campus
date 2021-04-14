; Return the list of nodes of a tree of type (2) accessed inorder.

(DEFUN inorder (tree)
    (COND
        ((NULL tree) NIL)
        (T (APPEND (inorder (CADR tree))
                   (APPEND (LIST (CAR tree)) (inorder (CADDR tree)))
        ))
    )
)

(PRINT (inorder '(a (b (c)) (d (e) (f)))))

; depth of a tree of type (2)

(DEFUN postorder (tree level)
    (COND
        ((NULL tree) level)
        (T (MAX (postorder (CADR tree) (+ level 1))
                (postorder (CADDR tree) (+ level 1))))
    )
)

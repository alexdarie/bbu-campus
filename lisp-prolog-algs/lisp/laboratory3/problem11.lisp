; Write a function to determine the depth of a list.

(DEFUN depth (L)
    (COND
        ((ATOM L) 0)
        (T (+ 1 (APPLY 'MAX (MAPCAR 'depth L))))
    )
)

(PRINT (depth '((1) (2 3 1) (1 (2 3 (1)))) ))

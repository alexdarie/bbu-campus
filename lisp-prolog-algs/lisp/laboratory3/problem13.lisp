; Define a function that returns the depth of a tree represented as 
; (root list_of_nodes_subtree1 ... list_of_nodes_subtreen)
; Eg. the depth of the tree (a (b (c)) (d) (e (f))) is 3

(DEFUN depth (L)
    (COND
        ((ATOM L) 0)
        (T (+ 1 (APPLY 'MAX (MAPCAR 'depth L))))
    )
)

(PRINT (depth '(a (b (c)) (d) (e (f))) ))

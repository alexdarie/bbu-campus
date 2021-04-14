; Define a function to tests the membership of a node in a n-tree represented as 
; (root list_of_nodes_subtree1 ... list_of_nodes_subtreen)
; Eg. tree is (a (b (c)) (d) (E (f))) and the node is "b" => true

(DEFUN hasNode (X L)
    (COND
        ((NULL L) nil)
        ((AND (EQUAL L X) (ATOM L)) t)
        ((ATOM L) nil)
        (T (reduce (LAMBDA (X Y) (OR X Y)) (MAPCAR (lambda (L) (hasNode X L)) L)))
    )
)

(PRINT (hasNode 'b '(a (b (c)) (d) (E (f))) ))

; Write a function to determine the number of nodes on the level k from a n-tree 
; represented as follows: (root list_nodes_subtree1 ... list_nodes_subtreen)
; Eg: tree is (a (b (c)) (d) (e (f))) and k=1 => 3 nodes

(DEFUN level (L lvl targetLevel)
    (COND
        ((AND (EQUAL lvl targetLevel) (ATOM L)) 1)
        ((ATOM L) 0)
        (T (APPLY '+ (MAPCAR (lambda (L) (level L (+ lvl 1) targetLevel)) L)))
    )
)

; we have to start with -1 as the current level because we use mapcar on the 
; first level too, and it has to be 0
(PRINT (level '((1 9) 9 (7) (1 2 3)) -1 1))

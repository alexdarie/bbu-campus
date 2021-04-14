; Define a function that replaces one node with another one in a n-tree represented 
; as: root list_of_nodes_subtree1... list_of_nodes_subtreen)
; Eg: tree is (a (b (c)) (d) (e (f))) and node 'b' will be replace with 
; node 'g' => tree (a (g (c)) (d) (e (f))))

(DEFUN _replace (L elem repl)
    (COND
        ((NULL L) nil)
        ((EQUAL elem L) repl)
        ((ATOM L) L)
        (T (APPLY 'LIST (MAPCAR (lambda (L) (_replace L elem repl)) L)))
    )
)

(PRINT (_replace '(a (b (c)) (d (e) (f))) 'e 'x ))

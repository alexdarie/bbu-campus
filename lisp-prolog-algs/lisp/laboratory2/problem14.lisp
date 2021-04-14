(defun leftTree(tree n m)
	(cond
		((null tree) nil)
		((> n m) nil)
		(t (append (list (car tree) (cadr tree))
						   (leftTree (cddr tree) (+ n 1) (+ m (cadr tree)))))
	)
)

(defun rightTree(tree n m)
	(cond
		((null tree) nil)
		((> n m) tree)
		(t (rightTree (cddr tree) (+ n 1) (+ m (cadr tree))))
	)
)


(defun postorder (tree)
	(cond
		((null tree) nil)
		(t (append (postorder (leftTree (cddr tree) 0 0))
							 (postorder (rightTree (cddr tree) 0 0))
							 (list (car tree))
							 ))
	)
)

(PRINT (postorder '(A 2 B 1 F 0 C 2 D 1 G 0 E 0)))

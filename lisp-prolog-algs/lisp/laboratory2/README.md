#### Recursive programming in Lisp (2)

1. For a given tree of type (1) return the path from the root node to a certain given node X. 

2. Return the list of nodes on the k-th level of a tree of type (1).

3. Return the number of levels of a tree of type (1).

4. Convert a tree of type (2) to type (1).

5. Return the level (depth) of a node in a tree of type (1). The level of the root element is 0. 

6. Return the list of nodes of a tree of type (1) accessed inorder.

7. Return the level of a node X in a tree of type (1). The level of the root element is 0.

8. Return the list of nodes of a tree of type (2) accessed inorder.

9. Convert a tree of type (1) to type (2).

10. Return the level of a node X in a tree of type (2). The level of the root element is 0.

11. Return the level (and coresponded list of nodes) with maximum number of nodes for a tree of type (2). The level of the root element is 0.

12. Determine the list of nodes accesed in preorder in a tree of type (2).

13. For a given tree of type (2) return the path from the root node to a certain given node X. 14. Determine the list of nodes accesed in postorder in a tree of type (1).

15. Determine the list of nodes accesed in postorder in a tree of type (2).

16. Determine if a tree of type (2) is ballanced (the difference between the depth of two subtrees is equal to 1).



| Algorithm | (1) | (2)|
|-----------|-----|----|
| Inorder search | 6 | 8 |
| Preorder search | -| 12 |
| Postorder search | 14 | 15|
| nth level | 2| 2 |
| Depth | 3| 3 |
| Depth of a node |5 | 5 |
| Path to X | 1 | 13 |
| Check balance |- | 16 |
| Level of node X | 7 | 7 |
| Convert (1) to (2) | 4 | - | 
| Convert (2) to (1) | - | 9 | 
| Level with max nr of nodes |- | 10|


```
(defun leftTree(tree n m)
	(cond
		((or (null tree) (> n m) ) nil)
		(t (cons (car tree) 
			 (cons (cadr tree) 
			       (leftTree (cddr tree) (+ n 1) (+ m (cadr tree))))
		))
	
	)
)

(defun rightTree(tree n m)
	(cond 
		((null tree) nil)
		((> n m) tree)
		(t (rightTree (cddr tree) (+ n 1) (+ m (cadr tree))))
	)
)	


(defun postorderTraversal (tree)
	(cond
		((null tree) nil)
		(t (append (postorderTraversal (leftTree (cddr tree) 0 0)) 
			   (postorderTraversal (rightTree (cddr tree) 0 0)) 
			   (list (car tree))
		))
	)
)
```

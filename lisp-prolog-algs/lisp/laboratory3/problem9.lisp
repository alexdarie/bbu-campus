; Write a function that removes all occurrences of an atom from any level of a list.

(DEFUN my_remove (L elem)
    (COND
        ((ATOM L) L)
        (T (MAPCAR (lambda (L) (my_remove L elem)) (remove elem L)))
    )
)

(PRINT (my_remove (my_remove '((1) (2 3 1) (1 (2 3 (1)))) 1 ) nil))

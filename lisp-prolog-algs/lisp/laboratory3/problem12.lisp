; Write a function that substitutes an element through another one at all levels of a given list.

(DEFUN replace (L elem repl)
    (COND
        ((NULL L) nil)
        ((EQUAL elem L) repl)
        ((ATOM L) L)
        (T (APPLY 'LIST (MAPCAR (lambda (L) (replace L elem repl)) L)))
    )
)

(PRINT (replace '((1 9) 9 (7) (1 (2) 3)) 2 '(100 101 102)))

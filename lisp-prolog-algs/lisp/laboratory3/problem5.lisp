(DEFUN sum (L)
    (COND
        ((NULL L) 0)
        ((AND (numberp L) (= (mod L 2) 0)) L)
        ((AND (numberp L) (= (mod L 2) 1)) (- L))
        ((atom L) 0)
        (T (apply '+ (mapcar 'sum L)))
    )
)

(PRINT (sum '(1 3 2 (4 (5 (6))) 10 ())))

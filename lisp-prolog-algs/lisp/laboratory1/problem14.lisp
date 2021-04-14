; a. Write a function to return the union of two sets.
;
; union(e1..en, V) = { V, E is nil
;                      e1 U union(e2..en, V), e1 not in V
;                      union(e2..en, V), otherwise

(DEFUN my_union (E V)
    (COND
        ((NULL E) V)
        ((NOT (MEMBER (CAR E) V)) (CONS (CAR E) (my_union (CDR E) V)))
        (T (my_union (CDR E) V))
    )
)

(PRINT (my_union '(1 3 8 9) '(0 1 7 8 9)))

; b. Write a function to return the product of all numerical atoms in a list, at any level.

(DEFUN squash (L)
    (COND
        ((NULL L) NIL)
        ((NUMBERP L) (LIST L))
        ((ATOM L) NIL)
        (T (APPEND (squash (CAR L)) (squash (CDR L))))
    )
)

(DEFUN transaction (functionName L)
    (APPLY functionName (squash L))
)

(PRINT (transaction '* '(1 (2 (1 A (2 4) 3) 1) (1 4)) ))

; c. Write a function to sort a linear list without keeping the double values.

; merge sort
(defun _merge (lst-a lst-b)
  (cond ((not lst-a) lst-b)
        ((not lst-b) lst-a)
        ((< (car lst-a) (car lst-b)) (cons (car lst-a) (_merge (cdr lst-a) lst-b)))
        (T (cons (car lst-b) (_merge lst-a (cdr lst-b))))))

(DEFUN sublist (L s e)
    (subseq L s (+ s (+ (- e s) 1)))
)

(DEFUN mergeSort (L i j)
    (if (= i j) (return-from mergeSort L))
    (if (< i j)
        (SETQ L 
              (_merge
                    (mergeSort (sublist L 0 (truncate (- (length L) 1) 2)) i (truncate (+ i j) 2))
                    (mergeSort (sublist L (+ (truncate (- (length L) 1) 2) 1) (- (length L) 1)) (+ (truncate (+ i j) 2) 1) j)
              ))
    )
)

(PRINT (mergeSort '(7 9 1 2) 0 3))

; bubble sort
(defun bubbleSort (list length)
    (if (= length 0)
        (return-from bubbleSort list)
    )

    (loop for i from 0 to (- length 1) do
        (if (> (nth i list) (nth (+ 1 i) list))
            (setf list (swap list i (+ 1 i)))
        )
    )
    (bubbleSort list (- length 1))
)

(defun swap (list leftPosition rightPosition)
    (setf aux (nth leftPosition list))
    (setf (nth leftPosition list) (nth rightPosition list))
    (setf (nth rightPosition list) aux)
    (return-from swap list)
)

(setf list `(0 1 -1 -2 -3 -3))
(PRINT (bubbleSort list (- (length list) 1)))


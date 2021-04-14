; a. Write a function to return the product of two vectors.
;
; dotProduct(e1..en, v1..vn) = { 0, e1 is nil
;                               e1*v1 + dotProduct(e2..en, v2..vn), otherwise    

(DEFUN dotProduct (v1 v2)
    (COND
        ((NULL v1) 0)
        (T (+ (* (CAR v1) (CAR v2)) (dotProduct (CDR v1) (CDR v2))))
    )
)

(PRINT (dotProduct '(1 3 -1) '(5 -1 -3)))

; second version
(DEFUN dotProduct (v1 v2)
    (APPLY '+ (MAPCAR '* v1 v2))
)

(PRINT (dotProduct '(1 3 -1) '(5 -1 -3)))

; b. Write a function to return the depth of a list
(DEFUN depth (S)
    (COND
        ((NULL S) 1)
        ((ATOM S) 0)
        (T (MAX (+ 1 (CAR S)) (CDR S)))
    )
)

; c. Write a function to sort a linear list without keeping the double values.
;
; mergeSort = { ei, i=j
;               merge(mergeSort(ei..e((i+j)/2)), mergeSort(e(1+((i+j)/2))..ej))
;

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

; d. Write a function to return the intersection of two sets.
;
; intersection(e1..en, V) = { NIL, E is nil
;                             e1 U intersection(e2..en, V), e1 is in V
;                             intersection(e2..en, V), e1 not in V

(DEFUN my_intersection (E V)
    (COND
        ((NULL E) NIL)
        ((MEMBER (CAR E) V) (CONS (CAR E) (my_intersection (CDR E) V)))
        (T (my_intersection (CDR E) V))
    )
)

(PRINT (my_intersection '(1 3 8 9) '(0 1 7 8 9)))

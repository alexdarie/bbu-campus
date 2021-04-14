;Convert a tree of type (1) to type (2).

(DEFUN _convert (l stack)
	(COND
      ((NULL l) (CAR stack))
      ((AND (NUMBERP (car l)) (= (CAR l) 0)) (_convert (CONS (LIST (CADR l)) (CDR (CDR l))) stack))
      ((AND (NUMBERP (car l)) (= (CAR l) 1)) (_convert (CONS (LIST (CAR (LAST stack)) (CADR l)) (CDR (CDR l))) (BUTLAST stack)))
      ((AND (NUMBERP (car l)) (= (CAR l) 2)) (_convert (CONS (LIST (CAR (LAST (BUTLAST stack))) (CAR (LAST stack)) (CADR l)) (CDR (CDR l))) (BUTLAST (BUTLAST stack))))
      (T (_convert (CDR l) (CONS (CAR l) stack)))
	)
)

(DEFUN reverse_lists (L)
    (COND
        ((NULL L) NIL)
        ((LISTP (CAR L)) (CONS (reverse_lists (reverse (CAR L))) (reverse_lists (CDR L))))
        (T (CONS (CAR L) (reverse_lists (CDR L))))
    )
)

; convert(l) => converted list
; convert(l1..ln) = reverse(convert(reverse(l), nil)))
(DEFUN convert (l)
	 (reverse_lists (reverse (_convert (reverse l) nil)))
)

(PRINT (convert '(A 0)))
; => '(A)
(PRINT (convert '(A 1 B 0)))
; => '(A (B))
(PRINT (convert '(A 2 B 0 C 2 D 0 E 0)))
; => '(A (B) (C (D) (E)))
(PRINT (convert '(A 2 B 1 C 2 F 0 D 1 E 0 G 0)))
; => (A (B (F)) (C (E) (D (G))))

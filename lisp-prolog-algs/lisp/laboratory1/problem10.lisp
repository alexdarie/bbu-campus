; a. Write a function to return the product of all the numerical atoms from a list, at superficial level.

(DEFUN prod (L)
    (COND
        ((NULL L) 1)
        ((NUMBERP (CAR L)) (* (CAR L) (prod (CDR L))))
        (T (prod (CDR L)))
    )
)

(PRINT (prod '(2 N (10 N) (3) A)))

; b. Write a function to replace the first occurence of an element E in a given list with an other element O.

(DEFUN replace (item repl L)
    (COND
        ((NULL L) NIL)
        ((EQUAL item (CAR L)) (CONS repl (replace item repl (CDR L))))
        ((ATOM (CAR L)) (CONS (CAR L) (replace item repl (CDR L))))
        (T (CONS (replace item repl (CAR L)) (replace item repl (CDR L)))) ;remove this line if is a linear list
    )
)

(PRINT (replace 1 3 '(1 0 (0 1 (0 (1))) 0 1)))

; c. Write a function to compute the result of an arithmetic expression memorised in preorder on a stack. 
; Examples:
; (+ 1 3) ==> 4 (1 + 3)
; (+ * 2 4 3) ==> 11 ((2 * 4) + 3)
; (+ * 2 4 - 5 * 2 2) ==> 9 ((2 * 4) + (5 - (2 * 2))

(DEFUN compute(L numbers)
    (COND
        ((NULL L) (CAR numbers))
        ((NUMBERP (CAR L)) (compute (CDR L) (CONS (CAR L) numbers)))
        ((EQUAL '+ (CAR L)) (progn
                              (SETQ result (+ (CAR numbers) (CAR (CDR numbers))) )
                              (format t "List: ~a Numbers: ~a Result: ~a. ~%" L numbers result)
                              (SETQ numbers (CDDR numbers))
                              (SETQ numbers (CONS result numbers))
                              (format t "Updated numbers: ~a~%" numbers)
                              (compute (CDR L) numbers)
                            ))
        ((EQUAL '- (CAR L)) (progn
                              (SETQ result (- (CAR numbers) (CAR (CDR numbers))))
                              (format t "List: ~a Numbers: ~a Result: ~a. ~%" L numbers result)
                              (SETQ numbers (CDDR numbers))
                              (SETQ numbers (CONS result numbers))
                              (format t "Updated numbers: ~a~%" numbers)
                              (compute (CDR L) numbers)
                            ))
        ((EQUAL '* (CAR L)) (progn
                              (SETQ result (* (CAR numbers) (CAR (CDR numbers))) )
                              (format t "List: ~a Numbers: ~a Result: ~a. ~%" L numbers result)
                              (SETQ numbers (CDDR numbers))
                              (SETQ numbers (CONS result numbers))
                              (format t "Updated numbers: ~a~%" numbers)
                              (compute (CDR L) numbers)
                            ))
        ((EQUAL '/ (CAR L)) (progn
                              (SETQ result (truncate (CAR numbers) (CAR (CDR numbers))) )
                              (format t "List: ~a Numbers: ~a Result: ~a. ~%" L numbers result)
                              (SETQ numbers (CDDR numbers))
                              (SETQ numbers (CONS result numbers))
                              (format t "Updated numbers: ~a~%" numbers)
                              (compute (CDR L) numbers)
                            ))
        (T (progn (PRINT "invalid syntax") (return-from compute 0)))
    )
)

(PRINT (compute (reverse '(+ * 2 4 - 5 * 2 2)) '()))


; d. Write a function to produce the list of pairs (atom n), where atom appears for n times in the parameter 
; list. Example: (A B A B A C A) --> ((A 4) (B 2) (C 1)).

(DEFUN atoms_freq (L)
    (COND
        ((NULL L) NIL)
        ((NOT (get (CAR L) 'freq)) (progn
                                        (setf (get (CAR L) 'freq) 1)
                                        (atoms_freq (CDR L))
            ))
        (T  (progn
                   (setf (get (CAR L) 'freq) (+ 1 (get (CAR L) 'freq)))
                   (atoms_freq (CDR L))
             ))
    )
)

(atoms_freq '(a b c d d a c))
(PRINT (MAPCAR (lambda (X) (LIST X (get X 'freq))) (LTOS '(a b c d d a c))))

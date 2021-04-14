; Problem 4-11: Binary trees can be used to represent arithmetic expressions, as for example:
; (* (+ A B) (- C (I D E)))
; One can write a compiler, or program for translating such an arithmetic expression into the machine 
; language of some computer, using LISP. Suppose for example that the target machine has a set of sequentially 
; numbered registers which can hold temporary results. The machine also has a MOVE instruction for getting values 
; into these registers, and ADD, SUB, MUL and DIV instructions for arithmetically combining values in two registers.
; The above expression, for example, could be translated into the following:
;
; ((MOVE 1A) 
;  (MOVE 2B) 
;  (ADD 1 2) 
;  (MOVE 2 C) 
;  (MOVE 3 D) 
;  (MOVE 4E) 
;  (DIV 3 4) 
;  (SUB 2 3) 
;  (MUL 1 2))
;
; The result is left in register number one. Define COMPILE, which performs this translation.

; Problem 4-10: 
; A mobile is a form of abstract sculpture consisting of parts that move. Usually it contains objects 
; suspended in mid-air by fine wires hanging from horizontal beams. We can define a particularly simple type of mobile 
; recursively as either a suspended object, or a beam with a sub-mobile hanging from each end. If we assume that each 
; beam is suspended from its midpoint, we can represent such a mobile as a binary tree. Single suspended objects are 
; represented by numbers equal to their weight, while more complicated mobiles can be represented by a three-element list. 
; The first element is a number equal to the weight of the beam, while the other two elements represent sub-mobiles attached 
; at the two ends of the beam.
;
; A mobile should be balanced. This means that the two mobiles suspended from opposite ends of each beam must be equal in
; weight. Define MOBILEP, a function which determines whether a mobile is balanced. It returns NIL if it is not, and its 
; total weight if it is. 
;
; So for example:
;
; (MOBILEP '(6 (4 (2 1 1) 4) (2 5 (1 2 2))))) 
; 30


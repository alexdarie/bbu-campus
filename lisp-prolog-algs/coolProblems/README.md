## Genealogic tree

Below is an example of searching for someones grandparents.
```
| ?- parent(P, ioana), parent(GP, P).

GP = ion
P = mihai ? ;

GP = iulia
P = mihai ? ;

GP = ion
P = maria ? ;

GP = mia
P = maria ? ;
```

Let's see an example of printing the result.
```
get_grandchild :-
    parent(ion, C),
    parent(C, GC),
    write('Ion's grandchild is '),
    write(GC).
```

## Geometry

Check if two point form a horisontal line.
```
| ?- horisontal(line(point(1, 0), point(7, 0))).

yes
| ?- horisontal(line(point(1, 1), point(7, 0))).

no
```

Get the result such that it will form a vertical line with the given point.
```
| ?- horisontal(line(point(1, 1), P)).

P = point(_,1)
```
```
| ?- horisontal(line(point(1, 1), point(A, B))).

B = 1
```

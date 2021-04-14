parent(mihai, ioana).
parent(maria, ioana).

parent(ion, mihai).
parent(iulia, mihai).

parent(ion, maria).
parent(mia, maria).

get_grandchild :-
    parent(ion, C),
    parent(C, GC),
    write('Ion\'s grandchild is '),
    write(GC), nl.

get_grandparent :-
    parent(P, ioana),
    parent(GP, P),
    format('~w ~s grandpartent ~n', [GP, "is the"]).

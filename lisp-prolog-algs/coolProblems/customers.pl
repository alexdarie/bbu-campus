% This knowledge base will store details about customers balance.

customer(sally, smith, 125.55).
customer(john, smith, 25.60).

get_balance(FirstName, LastName) :-
    customer(FirstName, LastName, B),
    format('~w ~w has a balance of $~2f ~n', [FirstName, LastName, B]).

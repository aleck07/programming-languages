-module(list_length).
-export([main/0]).

list_length(List) -> list_length(List, 0).
list_length([], Acc) -> Acc;
list_length([_ | T], Acc) -> list_length(T, 1 + Acc).

main() ->
    Len = list_length([1, 2, 3, 4, 5]),
    io:format("~w~n", [Len]).

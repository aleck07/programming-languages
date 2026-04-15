-module(reverse).
-export([main/0]).

rev(List) -> rev(List, []).
rev([], Acc) -> Acc;
rev([H | T], Acc) -> rev(T, [H | Acc]).

main() ->
    List = [1, 2, 3, 4, 5],
    io:format("~w~n", [rev(List)]).

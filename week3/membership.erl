-module(membership).
-export([main/0]).

mem([], _) ->
    false;
mem([H | T], X) ->
    case H of
        X -> true;
        _ -> mem(T, X)
    end.

main() ->
    List = [1, 2, 3, 4, 5],
    io:format("~w~n", [mem(List, 5)]),
    io:format("~w~n", [mem(List, 6)]).
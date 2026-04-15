-module(sum).
-export([main/0]).

sum([]) -> 0;
sum([H | T]) -> H + sum(T).

main() ->
    List = [1,2,3,4,5],
    io:format("~w~n", [sum(List)]).
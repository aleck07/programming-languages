-module(flat).
-export([main/0]).

flat([]) -> [];
flat([H | T]) ->
    case is_list(H) of
        true -> flat(H)++flat(T);
        false -> [H]++flat(T)
    end.

main() ->
    List = [[1,2,3], 4, [5, 6], [[7], [8, 9]]],
    io:format("~w~n", [flat(List)]).
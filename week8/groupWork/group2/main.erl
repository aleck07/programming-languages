-module(main).
-export([main/0]).

main() ->
    Keys = [5, 3, 8, 1, 9, 4, 7, 2],
    T = bst:insert_list(bst:new(), Keys),

    io:format("inserted: ~p~n", [Keys]),
    io:format("size: ~p~n", [bst:size(T)]),
    io:format("min: ~p~n", [bst:min(T)]),
    io:format("max: ~p~n", [bst:max(T)]),
    io:format("height: ~p~n", [bst:height(T)]),

    io:format("contains 4: ~p~n", [bst:contains(T, 4)]),
    io:format("contains 6: ~p~n", [bst:contains(T, 6)]),
    io:format("contains 9: ~p~n", [bst:contains(T, 9)]),
    io:format("contains 5: ~p~n", [bst:contains(T, 5)]),

    io:format("in-order: ~p~n", [bst:to_list(T)]).

-module(main).
-export([main/0]).

main() ->
    S0 = stack:new([cooper, elizabeth, ashley, austin, dalton, tristan, daniel]),

    %% 1. pop()
    {Val1, S1} = stack:pop(S0),
    io:format("popped: ~p~n", [Val1]),

    %% 2. push(matthew)
    S2 = stack:push(S1, matthew),
    io:format("pushed: matthew~n"),

    %% 3. get(2)
    Val3 = stack:get(S2, 2),
    io:format("get(2): ~p~n", [Val3]),

    %% 4. set(2, kameron)
    S3 = stack:set(S2, 2, kameron),
    io:format("set(2, kameron)~n"),

    %% 5. pop()
    {Val5, S4} = stack:pop(S3),
    io:format("popped: ~p~n", [Val5]),

    %% 6. pop()
    {Val6, S5} = stack:pop(S4),
    io:format("popped: ~p~n", [Val6]),

    %% 7. print_td()
    io:format("~nTop-down:~n"),
    stack:print_td(S5),

    %% 8. print_bu()
    io:format("~nBottom-up:~n"),
    stack:print_bu(S5),

    %% 9. Print a fresh, untouched stack both ways as a sanity check.
    Fresh = stack:new([one, two, three]),
    io:format("~nFresh stack top-down:~n"),
    stack:print_td(Fresh),
    io:format("Fresh stack bottom-up:~n"),
    stack:print_bu(Fresh).

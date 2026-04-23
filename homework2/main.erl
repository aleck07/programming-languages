-module(main).
-export([main/0]).

main() ->
    List = [cooper, elizabeth, ashley, austin, dalton, tristan, daniel],
    S1 = stack:new(List),
    {_, S2} = stack:pop(S1),
    S3 = stack:push(S2, matthew),
    GetVal = stack:get(S3, 2),
    io:format("Get value at index 2: ~p~n", [GetVal]),
    S4 = stack:set(S3, 2, kameron),
    {_, S5} = stack:pop(S4),
    {_, S6} = stack:pop(S5),
    io:format("Top down:~n"),
    stack:print_td(S6),
    io:format("Bottom up:~n"),
    stack:print_bu(S6).
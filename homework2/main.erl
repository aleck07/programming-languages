-module(main).
-export([main/0]).

main() ->
    List = [cooper, elizabeth, ashley, austin, dalton, tristan, daniel],
    S1 = stack:new(List),
    {_Val, S2} = stack:pop(S1),
    _ = stack:get(S2, 2),
    S3 = stack:push(S2, mathew),
    S4 = stack:set(S3, 2, kameron),
    S5 = stack:pop(S4),
    S6 = stack:pop(S5),
    io:format("Top down:~n"),
    stack:print_td(S6),
    io:format("Bottom up:~n"),
    stack:print_bu(S6).
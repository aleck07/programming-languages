-module(main).
-export([main/0]).

main() ->
    List = [cooper, elizabeth, ashley, austin, dalton, tristan, daniel],
    S1 = stack:new(List),
    {_Val, S2} = stack:pop(S1),
    GetVal = stack:get(S2, 2),
    io:format("Get value: ~p~n", [GetVal]),
    S3 = stack:push(S2, mathew),
    S4 = stack:set(S3, 2, kameron),
    stack:print_td(S4).
    % S5 = stack:pop(S4),
    % S6 = stack:pop(S5),
    % stack:print_td(S6),
    % stack:print_bu(S6).
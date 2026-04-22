-module(main).
-export([main/0]).

main() ->
    List = [cooper, elizabetch, ashley, asutin, dalton, tristan, daniel],
    S1 = stack:new(List),
    S2 = stack:pop(S1),
    S3 = stack:push(S2, mathew),
    print_td(S3).
    % S4 = stack:set(S3, 2, kameron),
    % S5 = stack:pop(S4),
    % S6 = stack:pop(S5),
    % stack:print_td(S6),
    % stack:print_bu(S6).
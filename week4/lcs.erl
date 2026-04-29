-module(lcs).
-export([main/0]).

lcs([], _) -> [];
lcs(_, []) -> [];
lcs([H|T1], [H|T2]) ->
    [H | lcs(T1, T2)];
lcs([_|T1] = S1, [_|T2] = S2) ->
    LCS1 = lcs(S1, T2),
    LCS2 = lcs(T1, S2),
    case length(LCS1) >= length(LCS2) of
        true -> LCS1;
        false -> LCS2
    end.

main() ->
    S1 = "AGGTAB",
    S2 = "GXTXAYB",
    LCS = lcs(S1, S2),
    io:format("Longest Common Subsequence: ~s~n", [LCS]).
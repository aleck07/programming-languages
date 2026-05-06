-module(mergesort).
-export([main/0, split/1, msort/1, merge/2]).

split([]) -> {[], []};
split([X]) -> {[X], []};
split([X,Y|T]) ->
    {A, B} = split(T),
    {[X|A], [Y|B]}.

msort([]) -> [];
msort([X]) -> [X];
msort(List) ->
    {A,B} = split(List),
merge(msort(A), msort(B)).

merge(X, []) -> X;
merge([], Y) -> Y;
merge([X|TX], [Y|TY]) when X > Y ->
    [Y|merge([X|TX], TY)];
merge([X|TX], [Y|TY]) ->
    [X|merge(TX,[Y|TY])].


main() ->
    Output = msort([67, 41, 69, 420, 888, 1, 43, 23]),
    io:format("~p~n", [Output]).
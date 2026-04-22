-module(fibn).
-export([main/0]).

fib_helper(1, _, B) -> B;
fib_helper(N, A, B) ->
    fib_helper(N - 1, B, A + B).

fibn(0) -> 0;
fibn(1) -> 1;
fibn(N) ->
    fib_helper(N, 0, 1).

main() ->
    N = 5,
    io:format("The ~p-th Fibonacci number is ~p~n", [N, fibn(N)]).
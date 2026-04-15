-module(fib).
-export([main/0]).

fib(0) -> 0;
fib(1) -> 1;
fib(Num) -> fib(Num - 1) + fib(Num - 2).

main() ->
    io:format("~w~n", [fib(15)]).

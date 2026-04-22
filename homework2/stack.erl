-module(stack).
% -export([new/1, push/2, pop/1, get/2, set/3, remove/2, print_td/1, print_bu/1]).
-export([new/1, print_td/1, print_bu/1, push/2, pop/1]).

new([]) -> empty;
new([H | T]) -> {H, new(T)}.

print_td(empty) -> ok;
print_td({H, T}) ->
    io:format("~p~n", [H]),
    print_td(T).

print_bu(empty) -> ok;
print_bu({H, T}) ->
    print_bu(T),
    io:format("~p~n", [H]).

push(empty, X) -> {X, empty};
push({H, T}, X) -> {X, {H, T}}.

pop(empty) -> empty;
pop({_, T}) -> T.
-module(stack).
% -export([new/1, push/2, pop/1, get/2, set/3, remove/2, print_td/1, print_bu/1]).
-export([new/1, print_td/1, print_bu/1, push/2, pop/1, get/2, set/3, remove/2]).

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

push(Stack, Val) -> {Val, Stack}.

pop(empty) -> error;
pop({H, T}) -> {H, T}.

get_helper(Stack, 0) ->
    {Val, _} = pop(Stack),
    Val;

get_helper(Stack, I) ->
    {_, T} = pop(Stack),
    get_helper(T, I - 1).

get(Stack, I) ->
    get_helper(Stack, I).

set_helper(Stack, 0, Val) ->
    {_, T} = pop(Stack),
    push(T, Val);

set_helper(Stack, I, Val) ->
    {H, T} = pop(Stack),
    Dummy = set_helper(T, I - 1, Val),
    push(Dummy, H).

set(Stack, I, Val) ->
    set_helper(Stack, I, Val).

remove_helper(Stack, 0) ->
    {Val, T} = pop(Stack),
    {Val, T};

remove_helper(Stack, I) ->
    {H, T} = pop(Stack),
    {Val, NewT} = remove_helper(T, I - 1),
    {Val, push(NewT, H)}.


remove(Stack, I) ->
    remove_helper(Stack, I).

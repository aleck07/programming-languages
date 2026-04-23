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

pop(empty) -> erlang:error(empty_stack);
pop({H, T}) -> {H, T}.

get_helper(Stack, 0, _) ->
    {Val, _} = pop(Stack),
    Val;

get_helper(Stack, I, Acc) ->
    {H, T} = pop(Stack),
    get_helper(T, I - 1, push(Acc, H)).

get(Stack, I) ->
    get_helper(Stack, I, empty).


set_helper(Stack, 0, Val, Acc) ->
    {_, T} = pop(Stack),
    NewStack = push(T, Val),
    push_all(NewStack, Acc);

set_helper(Stack, I, Val, Acc) ->
    {H, T} = pop(Stack),
    set_helper(T, I - 1, Val, push(Acc, H)).

push_all(Stack, empty) -> Stack;
push_all(Stack, Acc) ->
    {H, T} = pop(Acc),
    push_all(push(Stack, H), T).

set(Stack, I, Val) ->
    set_helper(Stack, I, Val, empty).


remove_helper(Stack, 0, Acc) ->
    {Val, T} = pop(Stack),
    {Val, push_all(T, Acc)};

remove_helper(Stack, I, Acc) ->
    {H, T} = pop(Stack),
    remove_helper(T, I - 1, push(Acc, H)).

remove(Stack, I) ->
    remove_helper(Stack, I, empty).


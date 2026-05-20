-module(stack).
-export([new/1, push/2, pop/1, get/2, set/3, remove/2, print_td/1, print_bu/1]).

%% Convert a list to a stack (tuple-chain).
new([]) ->
    empty;
new([H | T]) ->
    {H, new(T)}.

%% Push a value onto the top of the stack.
push(Stack, Value) ->
    {Value, Stack}. %% value isn't being used?

%% Pop the top element. Returns {Value, NewStack}.
pop(empty) ->
    erlang:error(empty_stack);
pop({Value, Rest}) ->
    {Value, Rest}.

%% Get the I-th element (0-indexed) using a helper stack.
get(Stack, I) ->
    get(Stack, I, empty).

get(empty, _, _Helper) ->
    erlang:error(index_out_of_bounds);
get({Value, _Rest}, 0, _Helper) ->
    Value;
get({Value, Rest}, I, Helper) ->
    get(Rest, I - 1, {Value, Helper}).

%% Set the I-th element using a helper stack.
set(Stack, I, NewValue) ->
    set(Stack, I, NewValue, empty).

set(empty, _, _NewValue, _Helper) ->
    erlang:error(index_out_of_bounds);
set({_OldValue, Rest}, 0, NewValue, Helper) ->
    rebuild(Helper, {NewValue, {Rest}}); %% Not rebuilding with rest of list
set({Value, Rest}, I, NewValue, Helper) ->
    set(Rest, I - 1, NewValue, {Value, Helper}).

%% Remove the I-th element using a helper stack.
%% Returns {RemovedValue, NewStack}.
remove(Stack, I) ->
    remove(Stack, I, empty).

remove(empty, _, _Helper) ->
    erlang:error(index_out_of_bounds);
remove({Value, Rest}, 0, Helper) ->
    {Value, rebuild(Helper, Rest)};
remove({Value, Rest}, I, Helper) ->
    remove(Rest, I - 1, {Value, Helper}).

%% Push all elements from Helper back onto Stack (restores original order).
rebuild(empty, Stack) ->
    Stack;
rebuild({Value, Rest}, Stack) ->
    rebuild(Rest, {Value, Stack}).

%% Print top-down recursively.
print_td(empty) ->
    ok;
print_td({Value, Rest}) ->
    io:format("~p~n", [Value]),
    print_td(Rest).

%% Print bottom-up recursively.
print_bu(empty) ->
    ok;
print_bu({Value, Rest}) -> %% Printing top-down BUGGGG!!!!
    print_bu(Rest),
    io:format("~p~n", [Value]).

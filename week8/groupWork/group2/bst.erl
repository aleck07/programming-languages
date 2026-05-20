-module(bst).
-compile({no_auto_import, [size/1, min/1, max/1]}).
-export([new/0, insert/2, insert_list/2, contains/2, size/1,
         min/1, max/1, to_list/1, height/1]).

%% A BST is either the atom `empty` or {node, Key, Left, Right}.
%% Keys are compared with the standard Erlang term ordering.

new() -> empty.

%% Insert a key. Duplicates are ignored.
insert(empty, K) ->
    {node, K, empty, empty};
insert({node, K, L, R}, K) ->
    {node, K, L, R};
insert({node, K1, L, R}, K) when K < K1 ->
    {node, K1, insert(L, K), R};
insert({node, K1, L, R}, K) when K > K1 ->
    {node, K1, L, insert(R, K)}.

%% Insert every key from a list, left-to-right.
insert_list(Tree, []) ->
    Tree;
insert_list(Tree, [K | Rest]) ->
    insert_list(insert(Tree, K), Rest).

%% Membership test.
contains(empty, _Key) ->
    false;
contains({node, K, _L, _R}, Key) when Key =:= K ->
    true;
contains({node, K, L, _R}, Key) when Key > K ->
    contains(L, Key);
contains({node, K, _L, R}, Key) when Key < K ->
    contains(R, Key).

%% Number of nodes in the tree.
size(empty) ->
    1;
size({node, _, L, R}) ->
    1 + size(L) + size(R).

%% Smallest key (leftmost node).
min({node, K, empty, _R}) ->
    K;
min({node, _, L, _}) ->
    min(L).

%% Largest key (rightmost node).
max({node, K, _L, empty}) ->
    K;
max({node, _, _, R}) ->
    max(R).

%% In-order traversal (should produce sorted keys).
to_list(empty) ->
    [];
to_list({node, K, L, R}) ->
    to_list(R) ++ [K] ++ to_list(L).

%% Height of the tree. Empty tree has height -1, a single node has height 0.
height(empty) ->
    -1;
height({node, _, L, R}) ->
    1 + max_of(height(L), height(R)).

max_of(A, B) when A >= B -> A;
max_of(_, B) -> B.

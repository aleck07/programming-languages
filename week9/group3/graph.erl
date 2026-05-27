-module(graph).
-compile({no_auto_import, [nodes/1]}).
-export([new/0, add_node/2, add_edge/3,
         nodes/1, neighbors/2, has_node/2, has_edge/3,
         node_count/1, edge_count/1]).

%% A graph is represented as a list of {Node, [Neighbor]} pairs.
%% Edges are undirected: if A is a neighbor of B then B is a
%% neighbor of A. Self-loops are not used.
%% A node with no edges has an empty neighbor list.

new() ->
    [].

%% Add a node with no edges. If the node already exists, leave it
%% (and its neighbors) alone.
add_node(G, N) ->
    case has_node(G, N) of
        true  -> G;
        false -> [{N, []} | G]
    end.

%% Add an undirected edge between A and B.
%% Both endpoints must already exist in the graph.
%% Duplicate edges are not added.
add_edge(G, A, B) ->
    G0 = add_neighbor(G, A, B),
    add_neighbor(G0, B, A).

add_neighbor([], _N, _Neighbor) ->
    [];
add_neighbor([{N, Ns} | Rest], N, Neighbor) ->
    case lists:member(Neighbor, Ns) of
        true  -> [{N, Ns} | Rest];
        false -> [{N, Ns ++ [Neighbor]} | Rest]
    end;
add_neighbor([Pair | Rest], N, Neighbor) ->
    [Pair | add_neighbor(Rest, N, Neighbor)].

%% Return all nodes in the graph (insertion order is not significant).
nodes([]) ->
    [];
nodes([{N, _} | Rest]) ->
    [N | nodes(Rest)].

%% Return the neighbors of a given node.
%% Crashes if the node is not in the graph.
neighbors([{N, Ns} | _], N) ->
    Ns;
neighbors([_ | Rest], N) ->
    neighbors(Rest, N).

has_node([], _N) ->
    false;
has_node([{N, _} | _], N) ->
    true;
has_node([_ | Rest], N) ->
    has_node(Rest, N).

has_edge(G, A, B) ->
    case has_node(G, A) of
        true  -> lists:member(B, neighbors(G, A));
        false -> false
    end.

node_count(G) ->
    length(nodes(G)).

%% Count undirected edges. Each edge is stored on both endpoints,
%% so the raw sum of neighbor-list lengths is twice the edge count.
edge_count(G) ->
    sum_degrees(G) / 2.

sum_degrees([]) ->
    0;
sum_degrees([{_, Ns} | Rest]) ->
    length(Ns) + sum_degrees(Rest).

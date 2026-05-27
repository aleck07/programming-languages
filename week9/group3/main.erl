-module(main).
-export([start/0]).

start() ->
    %% Build the test graph:
    %%
    %%       a ---- b
    %%       |      |
    %%       c ---- d ---- e
    %%              |
    %%              f
    %%
    %%       g ---- h
    %%
    %%       i           (isolated)
    %%
    %% 9 nodes, 7 undirected edges, 3 connected components.

    G0 = graph:new(),
    G1 = lists:foldl(fun (N, Acc) -> graph:add_node(Acc, N) end, G0,
                     [a, b, c, d, e, f, g, h, i]),
    G  = lists:foldl(fun ({A, B}, Acc) -> graph:add_edge(Acc, A, B) end, G1,
                     [{a, b}, {a, c}, {b, d}, {c, d}, {d, e}, {d, f}, {g, h}]),

    io:format("Nodes: ~p~n", [lists:sort(graph:nodes(G))]),
    io:format("Node count: ~p~n", [graph:node_count(G)]),
    io:format("Edge count: ~p~n", [graph:edge_count(G)]),
    io:nl(),

    io:format("Neighbors of a: ~p~n", [lists:sort(graph:neighbors(G, a))]),
    io:format("Neighbors of d: ~p~n", [lists:sort(graph:neighbors(G, d))]),
    io:format("Neighbors of i: ~p~n", [lists:sort(graph:neighbors(G, i))]),
    io:nl(),

    io:format("has_edge(a, b): ~p~n", [graph:has_edge(G, a, b)]),
    io:format("has_edge(b, a): ~p~n", [graph:has_edge(G, b, a)]),
    io:format("has_edge(a, e): ~p~n", [graph:has_edge(G, a, e)]),
    io:format("has_edge(d, g): ~p~n", [graph:has_edge(G, d, g)]),
    io:nl(),

    io:format("BFS from a: ~p~n", [traversal:bfs(G, a)]),
    io:format("BFS from f: ~p~n", [traversal:bfs(G, f)]),
    io:format("BFS from i: ~p~n", [traversal:bfs(G, i)]),
    io:format("DFS from a: ~p~n", [traversal:dfs(G, a)]),
    io:nl(),

    io:format("Shortest path a -> e: ~p~n", [traversal:shortest_path(G, a, e)]),
    io:format("Shortest path a -> f: ~p~n", [traversal:shortest_path(G, a, f)]),
    io:format("Shortest path a -> g: ~p~n", [traversal:shortest_path(G, a, g)]),
    io:format("Shortest path i -> a: ~p~n", [traversal:shortest_path(G, i, a)]),
    io:nl(),

    Components = traversal:connected_components(G),
    SortedComps = lists:sort([lists:sort(C) || C <- Components]),
    io:format("Connected components: ~p~n", [SortedComps]),
    io:format("Component count: ~p~n", [length(SortedComps)]),
    io:nl(),

    io:format("Reachable from a: ~p~n", [lists:sort(traversal:reachable_from(G, a))]),
    io:format("Reachable from g: ~p~n", [lists:sort(traversal:reachable_from(G, g))]),
    io:format("Reachable from i: ~p~n", [lists:sort(traversal:reachable_from(G, i))]),
    ok.

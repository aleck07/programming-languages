-module(traversal).
-export([bfs/2, dfs/2, shortest_path/3,
         connected_components/1, reachable_from/2]).

%% Breadth-first traversal starting at Start.
%% Returns a list of nodes in the order they were visited.
bfs(G, Start) ->
    bfs_loop(G, [Start], []).

bfs_loop(_G, [], Visited) ->
    lists:reverse(Visited);
bfs_loop(G, [N | Rest], Visited) ->
    case lists:member(N, Visited) of
        true ->
            bfs_loop(G, Rest, Visited);
        false ->
            Ns = graph:neighbors(G, N),
            bfs_loop(G, Rest ++ Ns, [N | Visited])
    end.

%% Depth-first traversal starting at Start.
%% Returns a list of nodes in the order they were visited.
dfs(G, Start) ->
    lists:reverse(dfs_loop(G, Start, [])).

dfs_loop(G, N, Visited) ->
    case lists:member(N, Visited) of
        true ->
            Visited;
        false ->
            Ns = graph:neighbors(G, N),
            dfs_visit_all(G, Ns, [N | Visited])
    end.

dfs_visit_all(_G, [], Visited) ->
    Visited;
dfs_visit_all(G, [N | Rest], Visited) ->
    Visited1 = dfs_loop(G, N, Visited),
    dfs_visit_all(G, Rest, Visited1).

%% Shortest path from From to To as a list of nodes [From, ..., To].
%% Returns no_path if From and To are not connected.
shortest_path(G, From, To) ->
    sp_loop(G, [[From]], [From], To).

sp_loop(_G, [], _Visited, _To) ->
    no_path;
sp_loop(_G, [[N | _] = Path | _RestPaths], _Visited, To) when N =:= To ->
    %% Paths are stored with the most recent node at the head.
    %% Reverse to report [From, ..., To].
    lists:reverse(Path);
sp_loop(G, [[N | _] = Path | RestPaths], Visited, To) ->
    Ns = graph:neighbors(G, N),
    Unvisited = [X || X <- Ns, not lists:member(X, Visited)],
    NewPaths = [[X | Path] || X <- Unvisited],
    sp_loop(G, RestPaths ++ NewPaths, Visited ++ Unvisited, To).

%% List of connected components. Each component is a list of nodes.
%% Every node in the graph appears in exactly one component.
connected_components(G) ->
    cc_loop(G, graph:nodes(G), []).
    %% OR
    % cc_loop(G, [N || N <- graph:nodes(G), graph:has_node(G, N)], []).

cc_loop(_G, [], Components) ->
    lists:reverse(Components);
cc_loop(G, [N | Rest], Components) ->
    case in_any_component(N, Components) of
        true ->
            cc_loop(G, Rest, Components);
        false ->
            Comp = bfs(G, N),
            cc_loop(G, Rest, [Comp | Components])
    end.

in_any_component(_N, []) ->
    false;
in_any_component(N, [Comp | Rest]) ->
    case lists:member(N, Comp) of
        true  -> true;
        false -> in_any_component(N, Rest)
    end.

%% Set of nodes reachable from Start (including Start itself).
reachable_from(G, Start) ->
    bfs(G, Start).

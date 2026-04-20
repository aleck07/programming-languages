-module(dice).
-export([main/0]).
-export([roll_frequencies/1, pair_frequencies/1, most_common/1]).

% Takes a list of rolls, returns a map of face -> frequency
roll_frequencies(Rolls) ->
    lists:foldl(
        fun(Roll, Acc) ->
            Count = maps:get(Roll, Acc, 0),
            maps:put(Roll, Count + 1, Acc)
        end,
        #{},
        Rolls
    ).

% Takes a list of rolls, returns a nested map of pair frequencies
pair_frequencies(Rolls) ->
    Pairs = lists:zip(lists:droplast(Rolls), tl(Rolls)),
    lists:foldl(
        fun({R1, R2}, Acc) ->
            Inner = maps:get(R1, Acc, #{}),
            Count = maps:get(R2, Inner, 0),
            maps:put(R1, maps:put(R2, Count + 1, Inner), Acc)
        end,
        #{},
        Pairs
    ).

% Takes a map, returns the key with the highest value as {Key, Count}.
most_common(Freqs) ->
    List = maps:to_list(Freqs),
    lists:foldl(
        fun({Key, Count}, {BestKey, BestCount}) ->
            if Count > BestCount -> {Key, Count};
               true -> {BestKey, BestCount}
            end
        end,
        {1, 0},
        List
    ).

main() ->
    N = 1000,
    K = 6,
    Rolls = [rand:uniform(K) || _ <- lists:seq(1, N)],
    Freqs = roll_frequencies(Rolls),
    lists:foreach(
        fun({Face, Count}) ->
            io:format("~p was rolled ~p times~n", [Face, Count])
        end,
        lists:sort(maps:to_list(Freqs))
    ),
    PairFreqs = pair_frequencies(Rolls),
    lists:foreach(
        fun(Face) ->
            Inner = maps:get(Face, PairFreqs, #{}),
            {NextFace, NextCount} = most_common(Inner),
            io:format("~p, most common next roll is ~p (~p times)~n", [Face, NextFace, NextCount])
        end,
        lists:seq(1, K)
    ).
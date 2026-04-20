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
            Pair = {R1, R2},
            Count = maps:get(Pair, Acc, 0),
            maps:put(Pair, Count + 1, Acc)
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
    %% Generate a list of N random rolls (1.. K )
    N = 1000,
    K = 6,
    Rolls = [rand:uniform(K) || _ <- lists:seq(1, N)],
    Freqs = roll_frequencies(Rolls),
    io:format("Roll frequencies: ~p~n", [Freqs]),
    PairFreqs = pair_frequencies(Rolls),
    io:format("Pair frequencies: ~p~n", [PairFreqs]),
    MostCommonRoll = most_common(Freqs),
    io:format("Most common roll: ~p~n", [MostCommonRoll]).
-module(dice).
-export([main/0]).
-export([roll_frequencies/1, pair_frequencies/1, most_common/1]).

%% Generate a list of N random rolls (1.. K )
Rolls = [rand:uniform(K) || _ <- lists:seq(1, N)],

%% Build a frequency map by folding over the rolls
Freqs = lists:foldl(
    fun(Roll, Acc) ->
        Count = maps:get(Roll, Acc, 0),
        maps:put(Roll, Count + 1, Acc)
    end,
    #{},
    Rolls
).

roll_frequencies(List) ->


main() ->
    null.
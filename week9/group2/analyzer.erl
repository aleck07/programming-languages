-module(analyzer).
-export([word_freq/1, longest_word/1, palindromes/1,
         most_frequent/2, least_frequent/2]).

%% Count occurrences of each word.
%% Returns a list of {Word, Count} pairs in first-seen order.
word_freq(Words) ->
    count(Words, []).

count([], Acc) ->
    lists:reverse(Acc);
count([W | Rest], Acc) ->
    case lookup(W, Acc) of
        {ok, N}   -> count(Rest, bump(W, N + 1, Acc));
        not_found -> count(Rest, [{W, 1} | Acc]) % Had {W, 2}
    end.

lookup(_W, []) ->
    not_found;
lookup(W, [{W, N} | _]) ->
    {ok, N};
lookup(W, [_ | Rest]) ->
    lookup(W, Rest).

bump(_W, _N, []) ->
    [];
bump(W, N, [{W, _} | Rest]) ->
    [{W, N} | Rest];
bump(W, N, [Pair | Rest]) ->
    [Pair | bump(W, N, Rest)].

%% Return the longest word in the list.
%% Ties are broken by first occurrence.
longest_word([W | Rest]) ->
    longest(Rest, W).

longest([], Best) ->
    Best;
longest([W | Rest], Best) ->
    case length(W) > length(Best) of % had >=
        true  -> longest(Rest, W);
        false -> longest(Rest, Best)
    end.

%% Return the words that read the same forwards and backwards.
%% Length-1 words (trivial palindromes) are filtered out.
%% Duplicates are preserved if a palindrome appears multiple times.
palindromes(Words) ->
    [W || W <- Words, length(W) >= 2, W =:= lists:reverse(W)].

%% Return the N most frequent words as a list of {Word, Count}.
%% If fewer than N distinct words exist, returns all of them.
most_frequent(Words, N) ->
    Freq = word_freq(Words),
    Sorted = lists:sort(fun({_, A}, {_, B}) -> A >= B end, Freq),
    take(N, Sorted).

%% Return the N least frequent words as a list of {Word, Count}.
least_frequent(Words, N) ->
    Freq = word_freq(Words),
    Sorted = lists:sort(fun({_, A}, {_, B}) -> A =< B end, Freq),
    take(N, Sorted).

take(0, _) -> [];
take(_, []) -> [];
take(N, [H | T]) -> [H | take(N - 1, T)].

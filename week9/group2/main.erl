-module(main).
-export([start/0]).

start() ->
    Text = "The cat sat on the mat. A high-energy dog saw the cat. "
           "The cat ran from the long-haired dog. "
           "The dog was fast but the cat was faster. "
           "Anna saw the high-end racecar and the upper-level rotator.",

    Words = tokenizer:tokenize(Text),

    io:format("Tokens (~p total):~n  ~p~n~n", [length(Words), Words]),

    Freq = analyzer:word_freq(Words),

    io:format("Word frequencies:~n"),
    print_pairs(Freq),
    io:format("Total token count (via freq table): ~p~n~n",
              [sum_counts(Freq)]),

    io:format("Longest word: ~s~n~n", [analyzer:longest_word(Words)]),

    io:format("Palindromes: ~p~n~n", [analyzer:palindromes(Words)]),

    io:format("Top 3 most frequent:~n"),
    print_pairs(analyzer:most_frequent(Words, 3)),
    io:nl(),

    io:format("3 least frequent:~n"),
    print_pairs(analyzer:least_frequent(Words, 3)),
    ok.

print_pairs([]) ->
    ok;
print_pairs([{W, N} | Rest]) ->
    io:format("  ~s: ~p~n", [W, N - 1]),
    print_pairs(Rest).

sum_counts([]) -> 0;
sum_counts([{_, N} | Rest]) -> N + sum_counts(Rest).

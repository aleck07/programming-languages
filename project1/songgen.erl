-module(songgen) .
-export([extract_title/1, remove_superfluous/1, remove_punctuation/1, remove_non_english/1, preprocess/1]).
-export([main/0]).
-export([build_bigrams/1, next_word/2, generate_title/3]).

remove_superfluous(Title) ->
    Pattern = "\\s*([\\(\\[\\{/\\\\_\\-:\"\\`\\+=]|feat\\.).*$",
    re:replace(Title, Pattern, <<"">>, [{return, binary}, unicode]).

remove_punctuation(Title) ->
    Pattern = "[\x{00BF}\x{00A1}?!.;:&$*@%#|]",
    re:replace(Title, Pattern, <<"">>, [global, {return, binary}, unicode]).

remove_non_english(Title) ->
    Pattern = "[^ 'a-zA-Z]",
    re:replace(Title, Pattern, <<"">>, [global, {return, binary}, unicode]).

extract_title(Line) ->
    Parts = binary:split(Line, <<"<SEP>">>, [global]),
    Title = lists:last(Parts),
    re:replace(Title, <<"[\"\\r]+$">>, <<"">>, [{return, binary}]).

preprocess(Line) ->
    L1 = extract_title(Line),
    L2 = remove_superfluous(L1),
    L3 = remove_punctuation(L2),
    remove_non_english(L3).

add_bigrams([], AccMap) -> AccMap;

add_bigrams([W], AccMap) ->
    Inner = maps:get(W, AccMap, #{}),
    maps:put(W, maps:put(<<"$">>, maps:get(<<"$">>, Inner, 0) + 1, Inner), AccMap);

add_bigrams([W1, W2 | Rest], AccMap) ->
    Inner = maps:get(W1, AccMap, #{}),
    NewInner = maps:put(W2, maps:get(W2, Inner, 0) + 1, Inner),
    add_bigrams([W2 | Rest], maps:put(W1, NewInner, AccMap)).

build_bigrams(Titles) ->
    lists:foldl(fun(Title, AccMap) ->
        Words = binary:split(Title, <<" ">>, [global, trim_all]),
        add_bigrams(Words, AccMap)
    end, #{}, Titles).

next_word(Word, Bigrams) ->
    case maps:get(Word, Bigrams, undefined) of
        undefined -> <<"$">>;
        Inner ->
            Sorted = lists:sort(fun({_, C1}, {_, C2}) -> C1 > C2 end, maps:to_list(Inner)),
            N = min(10, length(Sorted)),
            {NextWord, _} = lists:nth(rand:uniform(N), Sorted),
            NextWord
    end.

generate_title(Seed, Bigrams, Max) ->
    Words = gen_words(Seed, Bigrams, Max, #{Seed => true}, [Seed]),
    iolist_to_binary(lists:join(<<" ">>, Words)).

gen_words(_, _, 0, _, Acc) -> lists:reverse(Acc);

gen_words(Word, Bigrams, Max, Used, Acc) ->
    Next = next_word(Word, Bigrams),
    case Next of
        <<"$">>                        -> lists:reverse(Acc);
        _ when is_map_key(Next, Used)  -> lists:reverse(Acc);
        _                              -> gen_words(Next, Bigrams, Max - 1, maps:put(Next, true, Used), [Next | Acc])
    end.

main() ->
    {ok, Data} = file:read_file("tracks.txt"),
    Lines = binary:split(Data, <<"\n">>, [global, trim_all]),
    AllTitles = lists:map(fun preprocess/1, Lines),
    CleanTitles = [T || T <- AllTitles, T =/= <<>>],
    io:format("Extracted Titles: ~p~n", [CleanTitles]),
    Bigrams = build_bigrams(CleanTitles),
    io:format("~p~n", [Bigrams]),
    Seed = <<"love">>,
    GeneratedTitle = generate_title(Seed, Bigrams, 5),
    io:format("Generated Title: ~p~n", [GeneratedTitle]).

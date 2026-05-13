-module(main).
-export([main/0]).

main() ->
    {ok, Data} = file:read_file("test_tracks.txt"),
    Lines = binary:split(Data, <<"\n">>, [global, trim_all]),
    AllTitles = lists:map(fun songgen:preprocess/1, Lines),
    CleanTitles = [T || T <- AllTitles, T =/= <<>>],
    io:format("Extracted Titles: ~p~n", [CleanTitles]),
    Bigrams = songgen:build_bigrams(CleanTitles),
    io:format("~p~n", [Bigrams]),
    Seed = hd(CleanTitles),
    GeneratedTitle = songgen:generate_title(Seed, Bigrams, 5),
    file:write_file("titles.txt", GeneratedTitle).
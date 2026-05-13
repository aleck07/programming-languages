-module(main).
-export([main/0]).

main() ->
    {ok, TrackData} = file:read_file("tracks.txt"),
    Lines = binary:split(TrackData, <<"\n">>, [global, trim_all]),
    AllTitles = lists:map(fun songgen:preprocess/1, Lines),
    CleanTitles = [T || T <- AllTitles, T =/= <<>>],
    Bigrams = songgen:build_bigrams(CleanTitles),
    {ok, SeedData} = file:read_file("seeds.txt"),
    Seeds = binary:split(SeedData, <<"\n">>, [global, trim_all]),
    GeneratedTitles = lists:map(fun(Seed) ->
        songgen:generate_title(Seed, Bigrams, 10)
    end, Seeds),
    Output = iolist_to_binary(lists:join(<<"\n">>, GeneratedTitles)),
    file:write_file("titles.txt", Output).
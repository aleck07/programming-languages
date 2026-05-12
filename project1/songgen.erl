-module(songgen) .
-export([extract_title/1, remove_superfluous/1, remove_punctuation/1, remove_non_english/1, preprocess/1]).
-export([main/0]).
% -export([build_bigrams/1, next_word/2, generate_title/3]).

remove_superfluous(Line) ->
    Pattern = "\\s*([\\(\\[\\{/\\\\_\\-:\"\\`\\+=]|feat\\.).*$",
    re:replace(Line, Pattern, "", [{return, list}, unicode]).


remove_punctuation(Line) ->
    Pattern = "[\x{00BF}\x{00A1}!.;:&$*@%#|]",
    re:replace(Line, Pattern, "", [global, {return, list}, unicode]).

remove_non_english(Line) ->
    Pattern = "[^ 'a-zA-Z]",
    re:replace(Line, Pattern, "", [global, {return, list}, unicode]).

extract_title(Line) ->
    Line1 = remove_superfluous(Line),
    Line2 = remove_punctuation(Line1),
    remove_non_english(Line2).

preprocess(Line) ->
    Strip = string:trim(binary_to_list(Line), trailing, "\r\" \t"),
    Parts = string:split(Strip, "<SEP>", all),
    Title = lists:nth(4, Parts),
    extract_title(Title).

% build_bigrams([Binary]).

% next_word(Word, Bigram).

% generate_title(Binary, Bigram, Max).

% preprocess() ->

main() ->
    {ok, Data} = file:read_file("tracks.txt"),
    Lines = binary:split(Data, <<"\n">>, [global, trim_all]),
    Titles = lists:map(fun preprocess/1, Lines),
    io:format("Extracted Titles: ~p~n", [Titles]).
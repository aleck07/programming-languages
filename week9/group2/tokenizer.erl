-module(tokenizer).
-export([tokenize/1, lowercase/1, strip_punctuation/1, split_words/1]).

%% Tokenize a string into a list of normalized words.
%% Steps: lowercase, replace punctuation with spaces, split on whitespace.
tokenize(Text) ->
    Lower = lowercase(Text),
    Clean = strip_punctuation(Lower),
    split_words(Clean).

%% Convert every uppercase character in a string to lowercase.
lowercase([]) ->
    [];
lowercase([C | Rest]) when C >= $A, C =< $Z ->
    [C + 32 | lowercase(Rest)];
lowercase([C | Rest]) ->
    [C | lowercase(Rest)].

%% Replace each punctuation character with a single space.
%% The downstream splitter will collapse runs of spaces.
strip_punctuation([]) ->
    [];
strip_punctuation([C | Rest]) ->
    case is_punctuation(C) of
        true  -> strip_punctuation(Rest);
        false -> [C | strip_punctuation(Rest)]
    end.

is_punctuation(C) ->
    lists:member(C, ".,;:!?\"'()[]{}-").

%% Split a string into a list of words on whitespace.
%% Empty tokens (from runs of whitespace) are dropped.
split_words(Text) ->
    split_words(Text, [], []).

split_words([], [], Words) ->
    lists:reverse(Words);
split_words([], Current, Words) ->
    lists:reverse([lists:reverse(Current) | Words]);
split_words([C | Rest], Current, Words) when C =:= $\s; C =:= $\t; C =:= $\n ->
    case Current of
        [] -> split_words(Rest, [], Words);
        _  -> split_words(Rest, [], [lists:reverse(Current) | Words])
    end;
split_words([C | Rest], Current, Words) ->
    split_words(Rest, [C | Current], Words).

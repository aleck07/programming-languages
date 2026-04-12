-module(dialogue).
-export([main/0]).
-export([has_dialogue/1, load_lines/1, save_lines/2]).

load_lines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    Lines = binary:split(Data, <<"\n">>, [global, trim_all]),
    Lines.

save_lines(Filename, Lines) ->
    file:write_file(Filename, Lines).
    
has_dialogue(Line) ->
    case re:run(Line, "\".*\"") of
        {match, _} -> true;
        nomatch    -> false
    end.

join_lines([H]) ->
    H;
join_lines([H | T]) ->
    Rest = join_lines(T),
    <<H/binary, "\n", Rest/binary>>.


filter_dialogue([]) -> [];
filter_dialogue([H | T]) ->
    case has_dialogue(H) of
        true  -> [H | filter_dialogue(T)];
        false -> filter_dialogue(T)
    end.

main() ->
    Lines = load_lines("ica1_data.txt"),
    FilteredLines = filter_dialogue(Lines),
    save_lines("dialogue.txt", join_lines(FilteredLines)).
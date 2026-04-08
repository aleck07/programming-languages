-module(dialogue).
-export([main/0]).
-export([has_dialogue/1, load_lines/1, save_lines/2]).

load_lines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    Lines = binary:split(Data, <<"\n">>, [global, trim_all]),
    Lines.

save_lines(Filename, Lines) ->
    file:write_file("dialogue.txt", Lines).
    
has_dialogue(Line) ->
    if 
main() ->
    Lines = load_lines("ica1_data.txt"),
    save_lines(Lines).
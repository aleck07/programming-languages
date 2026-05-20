-module(volcano).
-export([main/0]).
% -export([new_volcano/4, name/1, elevation/1, last_eruption/1, hazard/1]).
% -export([load_volcanoes/1, sort_by_elevation/1, erupted_since/2, total_elevation/1]).

new_volcano(Binary, Elevation, LastEruption, Hazard) ->
    {volcano, Binary, Elevation, LastEruption, Hazard}.

name({volcano, Name, _, _, _}) ->
    Name.

elevation({volcano, _, Elevation, _, _}) ->
    Elevation.

last_eruption({volcano, _, _, LastEruption, _}) ->
    LastEruption.

hazard({volcano, _, _, _, Hazard}) ->
    Hazard.

loader(Line) -> 
    [Name, ElevationStr, LastEruptionStr, HazardStr] = binary:split(Line, <<",">>, [global]),
    Elevation= binary_to_integer(ElevationStr),
    LastEruption = binary_to_integer(LastEruptionStr),
    Hazard = binary_to_integer(HazardStr),
    new_volcano(Name, Elevation, LastEruption, Hazard).

loader_loop([], Acc) -> Acc;
loader_loop([Line | Rest], Acc) ->
    case Line of
        <<>> -> loader_loop(Rest, Acc); % skip empty lines, gives badmatch error
        _ -> 
            Volcano = loader(Line),
            loader_loop(Rest, [Volcano | Acc])
    end.

load_volcanoes(File) ->
    {ok, Data} = file:read_file(File),
    Lines = binary:split(Data, <<"\n">>, [global]),
    loader_loop(Lines, []).

erupted_since(Volcanoes, Year) ->
    

main()->
    LoadedVolcanoes = load_volcanoes("hw5_data.csv"),
    io:format("Loaded Volcanoes: ~p~n", [LoadedVolcanoes]).
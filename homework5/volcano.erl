-module(volcano).
-export([main/0]).
% -export([new_volcano/4, name/1, elevation/1, last_eruption/1, hazard/1]).
% -export([load_volcanoes/1, sort_by_elevation/1, erupted_since/2, total_elevation/1]).

new_volcano(Name, Elevation, LastEruption, Hazard) ->
    {volcano, Name, Elevation, LastEruption, Hazard}.

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

erupted_since([], _Year, List) -> List;
erupted_since([Volcano | Rest], Year, List) ->
    case last_eruption(Volcano) >= Year of
        true -> erupted_since(Rest, Year, [Volcano | List]);
        false -> erupted_since(Rest, Year, List)
    end.

erupted_since(Volcanoes, Year) ->
    erupted_since(Volcanoes, Year, []).

total_elevation([], Sum) -> Sum;
total_elevation([Volcano | Rest], Sum) ->
    total_elevation(Rest, Sum + elevation(Volcano)).
total_elevation(Volcanoes) ->
    total_elevation(Volcanoes, 0).

insert(Volcano, [], WalkedList) -> WalkedList ++ [Volcano];
insert(Volcano, [Element | Rest], WalkedList) ->
    case elevation(Volcano) < elevation(Element) of
        true -> WalkedList ++ [Volcano] ++ [Element] ++ Rest;
        false -> insert(Volcano, Rest, WalkedList ++ [Element])
    end.
insert(Volcano, SortedList) ->
    insert(Volcano, SortedList, []).

sort_by_elevation([], SortedList) -> SortedList;
sort_by_elevation([Volcano | Rest], SortedList) ->
    InsertedList = insert(Volcano, SortedList),
    sort_by_elevation(Rest, InsertedList).

sort_by_elevation([Volcano | Rest]) ->
    sort_by_elevation(Rest, [Volcano]).

main()->
    LoadedVolcanoes = load_volcanoes("hw5_data.csv"),
    io:format("Loaded Volcanoes: ~p~n", [LoadedVolcanoes]),
    VolcanoesEruptedSince2000 = erupted_since(LoadedVolcanoes, 1500),
    io:format("Volcanoes erupted since 2000: ~p~n", [VolcanoesEruptedSince2000]),
    TotalElevation = total_elevation(LoadedVolcanoes),
    io:format("Total elevation of all volcanoes: ~p~n", [TotalElevation]),
    SortedVolcanoes = sort_by_elevation(LoadedVolcanoes),
    io:format("Sorted Volcanoes by Elevation: ~p~n", [SortedVolcanoes]).
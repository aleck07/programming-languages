-module(inventory).
-export([new/0, add_warehouse/3,
         warehouses/1, all_warehouses/1,
         on_hand/3, reserved/3, total/3,
         reserve/3]).

%% Inventory ADT.
%% An inventory is a list of warehouses.
%% A warehouse is {warehouse, Id, Stocks} where Stocks is a list
%% of {Sku, OnHand, Reserved} triples.
%%
%% Invariant: for any sku in any warehouse, OnHand >= 0 and
%% Reserved >= 0. Sum of (OnHand + Reserved) across all warehouses
%% for a given sku stays constant from initial stocking through
%% the program's lifetime — units are not created or destroyed,
%% only moved between the OnHand and Reserved buckets.

new() ->
    [].

add_warehouse(Inv, Id, Stocks) ->
    Inv ++ [{warehouse, Id, Stocks}].

warehouses(Inv) ->
    [Id || {warehouse, Id, _} <- Inv].

all_warehouses(Inv) ->
    Inv.

%% --- Per-warehouse, per-sku lookups ---

on_hand([], _Id, _Sku) ->
    0;
on_hand([{warehouse, Id, S} | _], Id, Sku) ->
    sku_on_hand(S, Sku);
on_hand([_ | Rest], Id, Sku) ->
    on_hand(Rest, Id, Sku).

sku_on_hand([], _Sku) ->
    0;
sku_on_hand([{Sku, OH, _} | _], Sku) ->
    OH;
sku_on_hand([_ | Rest], Sku) ->
    sku_on_hand(Rest, Sku).

reserved([], _Id, _Sku) ->
    0;
reserved([{warehouse, Id, S} | _], Id, Sku) ->
    sku_reserved(S, Sku);
reserved([_ | Rest], Id, Sku) ->
    reserved(Rest, Id, Sku).

sku_reserved([], _Sku) ->
    0;
sku_reserved([{Sku, _, R} | _], Sku) ->
    R;
sku_reserved([_ | Rest], Sku) ->
    sku_reserved(Rest, Sku).

total(Inv, Id, Sku) ->
    on_hand(Inv, Id, Sku) + reserved(Inv, Id, Sku).

%% --- Multi-warehouse reservation ---
%%
%% reserve(Inv, Sku, Qty) attempts to reserve Qty units of Sku,
%% drawing from warehouses in order. Returns:
%%   {ok, NewInv, [{WhId, QtyTakenHere}]}      on success
%%   {error, out_of_stock}                      if total available < Qty
%%
%% If the first warehouse with stock holds enough, the entire
%% allocation comes from that one warehouse. If it does not, the
%% remainder is drawn from subsequent warehouses.
%%
%% On out_of_stock, no partial allocation occurs — the original
%% Inv is returned to the caller (via {error, ...}).

reserve(Inv, Sku, Qty) ->
    take(Inv, Sku, Qty, [], []).

%% take(Remaining, Sku, QtyNeeded, VisitedReversed, AllocsReversed)
take(Remaining, _Sku, 0, Visited, Allocs) ->
    {ok, Visited ++ Remaining, lists:reverse(Allocs)};
take([], _Sku, _Qty, _Visited, _Allocs) ->
    {error, out_of_stock};
take([Wh | Rest], Sku, Qty, Visited, Allocs) ->
    Avail = wh_on_hand(Wh, Sku),
    case Avail of
        0 ->
            take(Rest, Sku, Qty, [Wh | Visited], Allocs);
        _ ->
            Take = min(Avail, Qty),
            Wh1 = wh_reserve(Wh, Sku, Take),
            {warehouse, Id, _} = Wh,
            take(Rest, Sku, Qty - Take,
                 [Wh1 | Visited],
                 [{Id, Take} | Allocs])
    end.

wh_on_hand({warehouse, _, Stocks}, Sku) ->
    sku_on_hand(Stocks, Sku).

wh_reserve({warehouse, Id, Stocks}, Sku, Qty) ->
    {warehouse, Id, dec_stock(Stocks, Sku, Qty)}.

dec_stock([], _Sku, _Qty) ->
    [];
dec_stock([{Sku, OH, R} | Rest], Sku, Qty) ->
    [{Sku, OH - Qty, R} | Rest];
dec_stock([Other | Rest], Sku, Qty) ->
    [Other | dec_stock(Rest, Sku, Qty)].

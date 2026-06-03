-module(fulfillment).
-export([process_all/2]).

%% process_all(Inventory, Orders) -> {NewInventory, NewOrders}
%%
%% For each pending order, in input order:
%%   1. mark_paid       (pending -> paid)
%%   2. reserve stock   (allocate line items across warehouses)
%%   3. mark_shipped    (paid -> shipped, attaching the allocations)
%%
%% If any line in an order cannot be fully reserved, the order is
%% NOT shipped — it remains in the `paid` state with no allocations,
%% and the inventory is rolled back to the state it had before that
%% order. process_all then continues with the next order.
%%
%% The function returns the final inventory and the list of orders
%% in the same input order, each updated to its final state.

process_all(Inv, Orders) ->
    process_all(Inv, Orders, []).

process_all(Inv, [], Done) ->
    {Inv, lists:reverse(Done)};
process_all(Inv, [Order | Rest], Done) ->
    {ok, OPaid} = order:mark_paid(Order),
    case reserve_lines(Inv, order:line_items(OPaid), []) of
        {ok, Inv1, Allocs} ->
            {ok, OShipped} = order:mark_shipped(OPaid, Allocs),
            process_all(Inv1, Rest, [OShipped | Done]);
        {error, _Reason} ->
            %% Rollback: discard Inv1 (any partial reservations from
            %% this order), keep the pre-order Inv. Order stays paid.
            {Inv, lists:reverse([OPaid | Done])}
    end.

%% reserve_lines(Inv, Lines, AccAllocs) ->
%%   {ok, Inv', Allocations}     where Allocations is a list of
%%                               {WhId, Sku, Qty} triples
%%   | {error, Reason}
reserve_lines(Inv, [], Acc) ->
    {ok, Inv, lists:reverse(Acc)};
reserve_lines(Inv, [{Sku, Qty} | Rest], Acc) ->
    case inventory:reserve(Inv, Sku, Qty) of
        {ok, Inv1, WhAllocs} ->
            Tagged = [{WhId, Sku, Q} || {WhId, Q} <- WhAllocs],
            %% Tagged is already in warehouse-order; prepend reversed
            %% so that final lists:reverse(Acc) yields line-then-wh order.
            reserve_lines(Inv1, Rest, lists:reverse(Tagged) ++ Acc);
        {error, R} ->
            {error, R}
    end.

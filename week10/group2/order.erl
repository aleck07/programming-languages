-module(order).
-export([new_from_cart/3,
         id/1, customer/1, customer_id/1, state/1, line_items/1,
         promo/1, allocations/1,
         subtotal_cents/1, tax_cents/1,
         promo_discount_cents/1, tier_discount_cents/1,
         discount_cents/1, shipping_cents/1, total_cents/1,
         mark_paid/1, mark_shipped/2, cancel/1]).

%% Order ADT.
%%   {order, Id, Customer, Lines, Promo,
%%           SubCents, TaxCents, PromoDiscCents, TierDiscCents,
%%           ShipCents, TotalCents,
%%           State, Allocations}
%%
%% States and allowed transitions:
%%   pending -> paid       (mark_paid)
%%   paid    -> shipped    (mark_shipped, with stock allocations)
%%   pending -> cancelled  (cancel)
%%   paid    -> cancelled  (cancel)
%%   shipped : TERMINAL — cannot cancel a shipped order.
%%   cancelled : TERMINAL — cannot cancel twice.
%%
%% Allocations is a list of {WhId, Sku, Qty} triples recording
%% which warehouses supplied each line item. Empty until shipped.

new_from_cart(Id, Cart, Catalog) ->
    Items     = cart:items(Cart),
    Sub       = cart:subtotal_cents(Cart, Catalog),
    Tax       = cart:tax_cents(Cart, Catalog),
    PromoDisc = cart:promo_discount_cents(Cart, Catalog),
    TierDisc  = cart:tier_discount_cents(Cart, Catalog),
    Ship      = cart:shipping_cents(Cart, Catalog),
    Total     = cart:total_cents(Cart, Catalog),
    {order, Id, cart:customer(Cart), Items, cart:promo(Cart),
            Sub, Tax, PromoDisc, TierDisc, Ship, Total,
            pending, []}.

id                  ({order, Id,_,_,_, _,_,_,_,_,_, _,_}) -> Id.
customer            ({order, _,C,_,_, _,_,_,_,_,_, _,_}) -> C.
customer_id         (O) -> customer:id(customer(O)).
line_items          ({order, _,_,L,_, _,_,_,_,_,_, _,_}) -> L.
promo               ({order, _,_,_,P, _,_,_,_,_,_, _,_}) -> P.
subtotal_cents      ({order, _,_,_,_, S,_,_,_,_,_, _,_}) -> S.
tax_cents           ({order, _,_,_,_, _,T,_,_,_,_, _,_}) -> T.
promo_discount_cents({order, _,_,_,_, _,_,D,_,_,_, _,_}) -> D.
tier_discount_cents ({order, _,_,_,_, _,_,_,T,_,_, _,_}) -> T.
shipping_cents      ({order, _,_,_,_, _,_,_,_,H,_, _,_}) -> H.
total_cents         ({order, _,_,_,_, _,_,_,_,_,T, _,_}) -> T.
state               ({order, _,_,_,_, _,_,_,_,_,_, St,_}) -> St.
allocations         ({order, _,_,_,_, _,_,_,_,_,_, _,A}) -> A.

discount_cents(O) ->
    promo_discount_cents(O) + tier_discount_cents(O).

set_state({order, Id,C,L,P, S,T,D1,D2,H,Tot, _,A}, NewState) ->
    {order, Id,C,L,P, S,T,D1,D2,H,Tot, NewState,A}.

set_allocations({order, Id,C,L,P, S,T,D1,D2,H,Tot, St,_}, A) ->
    {order, Id,C,L,P, S,T,D1,D2,H,Tot, St,A}.

%% pending -> paid
mark_paid(Order) ->
    case state(Order) of
        pending ->
            {ok, set_state(Order, paid)};
        Other ->
            {error, {invalid_transition, Other, paid}}
    end.

%% paid -> shipped, recording the supplied allocations.
mark_shipped(Order, Allocations) ->
    case state(Order) of
        paid ->
            O1 = set_allocations(Order, Allocations),
            {ok, set_state(O1, shipped)};
        Other ->
            {error, {invalid_transition, Other, shipped}}
    end.

%% Cancel an order. Allowed from pending or paid only.
%% Shipped orders are terminal and may not be cancelled.
%% Cancelled orders may not be cancelled again.
cancel(Order) ->
    Cancellable = [pending, paid, shipped],
    case lists:member(state(Order), Cancellable) of
        true  -> {ok, set_state(Order, cancelled)};
        false -> {error, {cannot_cancel, state(Order)}}
    end.

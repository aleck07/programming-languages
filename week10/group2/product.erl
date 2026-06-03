-module(product).
-export([new/5, sku/1, name/1, price_cents/1, weight_g/1, category/1]).

%% Product ADT.
%%   {product, Sku, Name, PriceCents, WeightG, Category}
%%
%% Categories: apparel | electronics | books | supplies.
%% Sku is an atom (e.g., widget, gadget, book).

new(Sku, Name, PriceCents, WeightG, Category) ->
    {product, Sku, Name, PriceCents, WeightG, Category}.

sku({product, Sku, _, _, _, _}) ->
    Sku.

name({product, _, Name, _, _, _}) ->
    Name.

price_cents({product, _, _, P, _, _}) ->
    P.

weight_g({product, _, _, W, _, _}) ->
    W.

category({product, _, _, _, _, C}) ->
    C.

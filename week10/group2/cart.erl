-module(cart).
-export([new/2, add_item/3, set_promo/2,
         customer/1, customer_id/1, items/1, promo/1,
         subtotal_cents/2, tax_cents/2, weight_g/2,
         shipping_cents/2,
         promo_discount_cents/2, tier_discount_cents/2,
         discount_cents/2, total_cents/2]).

%% Cart ADT.
%%   {cart, Customer, Items, PromoCode}
%%
%% Customer is a customer record. Items is a list of {Sku, Qty}.
%% The promo code is a string; "" means no promo.

new(Customer, PromoCode) ->
    {cart, Customer, [], PromoCode}.

add_item({cart, C, Items, P}, Sku, Qty) ->
    {cart, C, Items ++ [{Sku, Qty}], P}.

set_promo({cart, C, Items, _}, NewPromo) ->
    {cart, C, Items, NewPromo}.

customer    ({cart, C, _, _}) -> C.
customer_id ({cart, C, _, _}) -> customer:id(C).
items       ({cart, _, I, _}) -> I.
promo       ({cart, _, _, P}) -> P.

%% Look up a product in the catalog by sku.
find_product([], _Sku) ->
    not_found;
find_product([P | Rest], Sku) ->
    case product:sku(P) =:= Sku of
        true  -> P;
        false -> find_product(Rest, Sku)
    end.

%% Per-line subtotal (in cents): unit price times quantity.
line_subtotal_cents({Sku, Qty}, Catalog) ->
    P = find_product(Catalog, Sku),
    product:price_cents(P) * Qty.

subtotal_cents({cart, _, Items, _}, Catalog) ->
    lists:sum([line_subtotal_cents(I, Catalog) || I <- Items]).

%% Per-line tax (in cents). Tax is computed on the pre-discount
%% line subtotal (unit price * qty) using the category's tax rate.
line_tax_cents({Sku, Qty}, Catalog) ->
    P    = find_product(Catalog, Sku),
    Base = product:price_cents(P) * Qty,
    Bps  = pricing:tax_rate_bps(product:category(P)),
    Base * Bps div 10000.

tax_cents({cart, _, Items, _}, Catalog) ->
    lists:sum([line_tax_cents(I, Catalog) || I <- Items]).

%% Cart weight in grams: sum of (unit weight * qty) across lines.
line_weight_g({Sku, Qty}, Catalog) ->
    P = find_product(Catalog, Sku),
    product:weight_g(P) * Qty.

weight_g({cart, _, Items, _}, Catalog) ->
    lists:sum([line_weight_g(I, Catalog) || I <- Items]).

shipping_cents(Cart, Catalog) ->
    pricing:shipping_cents(weight_g(Cart, Catalog)).

%% Promo discount (in cents): percentage off subtotal, by the
%% cart's promo code. Applied to the subtotal only — not to tax
%% or shipping.
promo_discount_cents(Cart, Catalog) ->
    Sub  = subtotal_cents(Cart, Catalog),
    Tax  = tax_cents(Cart, Catalog),
    Ship = shipping_cents(Cart, Catalog),
    pricing:apply_discount(Sub + Tax + Ship, promo(Cart)).

%% Loyalty tier discount (in cents): percentage off subtotal, by
%% the customer's tier. Applied to the subtotal only.
tier_discount_cents(Cart, Catalog) ->
    Sub  = subtotal_cents(Cart, Catalog),
    Tax  = tax_cents(Cart, Catalog),
    Ship = shipping_cents(Cart, Catalog),
    Tier = customer:tier(customer(Cart)),
    Bps  = pricing:tier_discount_bps(Tier),
    (Sub + Tax + Ship) * Bps div 10000.

%% Combined discount (promo + tier).
discount_cents(Cart, Catalog) ->
    promo_discount_cents(Cart, Catalog) + tier_discount_cents(Cart, Catalog).

%% total_cents: subtotal - discount + tax + shipping.
total_cents(Cart, Catalog) ->
    Sub  = subtotal_cents(Cart, Catalog),
    Tax  = tax_cents(Cart, Catalog),
    Ship = shipping_cents(Cart, Catalog),
    Disc = discount_cents(Cart, Catalog),
    Sub + Tax + Ship - Disc.

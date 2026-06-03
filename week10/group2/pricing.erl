-module(pricing).
-export([tax_rate_bps/1, shipping_cents/1,
         promo_pct_bps/1, apply_discount/2,
         tier_discount_bps/1]).

%% Pricing helpers. All money is in integer cents and all rates
%% are in basis points (1 bps = 0.01%, so 800 bps = 8.00%).
%%
%% Categories taxed:
%%   apparel       8.00%
%%   electronics   9.50%
%%   books         0.00%
%%   supplies      6.00%
%% Anything else  0.00%.

tax_rate_bps(Category) ->
    case Category of
        apparel    -> 800;
        electronics-> 950;
        books      -> 0;
        supplies   -> 600;
        _          -> 0
    end.

%% Shipping cost by total order weight (grams).
%%   0g    to  500g:  $4.99
%%   501g  to 1500g:  $7.99
%%   1501g to 5000g:  $12.99
%%   5001g and up:    $19.99
%%
%% Boundaries are inclusive on the upper end: 500g ships at
%% $4.99, not $7.99; 1500g at $7.99; and so on.

shipping_cents(WeightG) when WeightG =<  500  ->  499;
shipping_cents(WeightG) when WeightG =< 1500  ->  799;
shipping_cents(WeightG) when WeightG =< 5000  -> 1299;
shipping_cents(_)                            -> 1999.

%% Promo codes. Each code maps to a percentage discount in
%% basis points to be applied to the cart's subtotal.
%%
%%   "SAVE10"  -> 10.00%
%%   "VIP20"   -> 20.00%
%%
%% An empty string "" or an unknown code yields 0% discount.

promo_pct_bps(Code) ->
    Promos = [{"SAVE10", 1000}, {"VIP20", 2000}],
    case lists:keyfind(Code, 1, Promos) of
        {_, Bps} -> Bps;
        false    -> 0
    end.

%% apply_discount(BaseCents, PromoCode) -> DiscountCents.
%% Returns the discount to subtract from BaseCents.
apply_discount(BaseCents, PromoCode) ->
    Bps = promo_pct_bps(PromoCode),
    BaseCents * Bps div 10000.

%% Loyalty tier discount, in basis points. Applied to the
%% subtotal (before tax and shipping), in addition to any promo
%% discount the cart carries.
%%
%%   bronze    -> 0.00%
%%   silver    -> 2.00%
%%   gold      -> 5.00%
%%   platinum  -> 10.00%
%% Anything else (including invalid tiers) -> 0.00%.
tier_discount_bps(Tier) ->
    case Tier of
        bronze   -> 0;
        silver   -> 200;
        gold     -> 500;
        platinum -> 1000;
        _        -> 0
    end.

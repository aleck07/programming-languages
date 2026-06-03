-module(main).
-export([go/0]).

%% Driver. Builds a small e-commerce scenario, runs the order
%% pipeline through fulfillment, attempts a cancellation, and
%% prints a structured report.

go() ->
    Catalog   = build_catalog(),
    Inv0      = build_inventory(),
    Customers = build_customers(),
    Carts     = build_carts(Customers),
    Orders0   = build_orders(Carts, Catalog),

    print_header("Catalog"),
    lists:foreach(fun(P) -> print_product(P) end, Catalog),
    io:nl(),

    print_header("Customers"),
    lists:foreach(fun(C) -> print_customer(C) end, Customers),
    io:nl(),

    print_header("Initial inventory"),
    print_inventory(Inv0),
    print_stock_totals(Inv0, Catalog),
    io:nl(),

    print_header("Cart pricing"),
    lists:foreach(fun(O) -> print_pricing(O) end, Orders0),
    io:nl(),

    {Inv1, Orders1} = fulfillment:process_all(Inv0, Orders0),

    print_header("Allocations (after fulfillment)"),
    lists:foreach(fun(O) -> print_allocations(O) end, Orders1),
    io:nl(),

    print_header("Cancellation attempts"),
    O2     = lists:nth(2, Orders1),
    {Orders2, _} = try_cancel(Orders1, 2, O2),
    io:nl(),

    print_header("Final inventory"),
    print_inventory(Inv1),
    print_stock_totals(Inv1, Catalog),
    io:nl(),

    print_header("Final order states"),
    lists:foreach(fun(O) -> print_state(O) end, Orders2),
    io:nl(),

    print_header("Revenue (shipped orders only)"),
    Revenue = lists:sum([order:total_cents(O) ||
                           O <- Orders2,
                           order:state(O) =:= shipped]),
    io:format("  $~s~n", [format_cents(Revenue)]),
    ok.

%% --- scenario setup ---

build_catalog() ->
    [product:new(widget, "Widget", 1999,  800, electronics),
     product:new(gadget, "Gadget", 4999, 1500, electronics),
     product:new(book,   "Book",   1299,  500, books),
     product:new(hat,    "Hat",    2499,  200, apparel),
     product:new(pen,    "Pen",     199,   50, supplies)].

build_inventory() ->
    I0 = inventory:new(),
    I1 = inventory:add_warehouse(I0, north,
            [{widget, 10, 0}, {gadget,  5, 0}, {book, 20, 0}]),
    I2 = inventory:add_warehouse(I1, south,
            [{widget,  3, 0}, {gadget, 10, 0}, {hat,  15, 0}]),
    I3 = inventory:add_warehouse(I2, east,
            [{gadget,  2, 0}, {hat,     5, 0}, {book,  8, 0},
             {pen,    50, 0}]),
    I3.

build_customers() ->
    [customer:new(alice, "Alice",  "alice@shop.com",  silver),
     customer:new(bob,   "Bob",    "bob@shop.com",    bronze),
     customer:new(carol, "Carol",  "carol@shop.com",  gold),
     customer:new(dave,  "Dave",   "dave@shop.com",   platinum),
     customer:new(eve,   "Eve",    "eve@shop.com",    bronze)].

find_customer([C | _], Id) when element(2, C) =:= Id -> C;
find_customer([_ | Rest], Id) -> find_customer(Rest, Id);
find_customer([], _) -> not_found.

build_carts(Customers) ->
    Alice = find_customer(Customers, alice),
    Bob   = find_customer(Customers, bob),
    Carol = find_customer(Customers, carol),
    Dave  = find_customer(Customers, dave),
    Eve   = find_customer(Customers, eve),
    C1 = add_items(cart:new(Alice, "SAVE10"),
                   [{widget, 2}, {book, 1}]),
    C2 = add_items(cart:new(Bob,   ""),
                   [{gadget, 6}, {hat, 5}]),
    C3 = add_items(cart:new(Carol, ""),
                   [{pen, 10}, {hat, 1}]),
    C4 = add_items(cart:new(Dave,  "VIP20"),
                   [{widget, 3}, {gadget, 20}]),
    C5 = add_items(cart:new(Eve,   ""),
                   [{book, 1}]),
    [C1, C2, C3, C4, C5].

add_items(Cart, []) -> Cart;
add_items(Cart, [{Sku, Qty} | Rest]) ->
    add_items(cart:add_item(Cart, Sku, Qty), Rest).

build_orders(Carts, Catalog) ->
    build_orders(Carts, Catalog, 1, []).

build_orders([], _Catalog, _N, Acc) ->
    lists:reverse(Acc);
build_orders([Cart | Rest], Catalog, N, Acc) ->
    O = order:new_from_cart(N, Cart, Catalog),
    build_orders(Rest, Catalog, N + 1, [O | Acc]).

try_cancel(Orders, N, Order) ->
    Name = customer:name(order:customer(Order)),
    St   = order:state(Order),
    case order:cancel(Order) of
        {ok, OC} ->
            io:format("  cancel #~w (~s, was ~p): ok -> ~p~n",
                      [N, Name, St, order:state(OC)]),
            {replace_at(Orders, N, OC), OC};
        {error, R} ->
            io:format("  cancel #~w (~s, was ~p): error ~p~n",
                      [N, Name, St, R]),
            {Orders, Order}
    end.

replace_at([_ | T], 1, X) -> [X | T];
replace_at([H | T], N, X) -> [H | replace_at(T, N - 1, X)].

%% --- printing helpers ---

print_header(Title) ->
    io:format("== ~s ==~n", [Title]).

print_product(P) ->
    io:format("  ~-7w ~-9s $~7s  ~5wg  ~p~n",
              [product:sku(P),
               product:name(P),
               format_cents(product:price_cents(P)),
               product:weight_g(P),
               product:category(P)]).

print_inventory(Inv) ->
    lists:foreach(fun({warehouse, Id, Stocks}) ->
        io:format("  ~p:~n", [Id]),
        lists:foreach(fun({Sku, OH, R}) ->
            io:format("    ~-7w on_hand=~3w reserved=~3w~n", [Sku, OH, R])
        end, Stocks)
    end, inventory:all_warehouses(Inv)).

print_stock_totals(Inv, Catalog) ->
    io:format("  total stock per sku (on_hand+reserved across warehouses):~n", []),
    lists:foreach(fun(P) ->
        Sku = product:sku(P),
        T = lists:sum([inventory:total(Inv, Wh, Sku)
                       || Wh <- inventory:warehouses(Inv)]),
        io:format("    ~-7w ~w~n", [Sku, T])
    end, Catalog).

print_customer(C) ->
    io:format("  ~-7w ~-7s ~-20s ~p~n",
              [customer:id(C), customer:name(C),
               customer:email(C), customer:tier(C)]).

print_pricing(O) ->
    Items = [io_lib:format("~wx~w", [Q, Sku]) ||
                {Sku, Q} <- order:line_items(O)],
    ItemsStr = lists:join(", ", Items),
    Cust = order:customer(O),
    Promo = case order:promo(O) of
        ""    -> "(none)";
        Code  -> Code
    end,
    io:format("  #~w (~s, ~p) promo=~s~n",
              [order:id(O), customer:name(Cust),
               customer:tier(Cust), Promo]),
    io:format("    items:        ~s~n", [ItemsStr]),
    io:format("    subtotal:     $~s~n", [format_cents(order:subtotal_cents(O))]),
    io:format("    promo disc:   $~s~n", [format_cents(order:promo_discount_cents(O))]),
    io:format("    tier disc:    $~s~n", [format_cents(order:tier_discount_cents(O))]),
    io:format("    tax:          $~s~n", [format_cents(order:tax_cents(O))]),
    io:format("    shipping:     $~s~n", [format_cents(order:shipping_cents(O))]),
    io:format("    total:        $~s~n", [format_cents(order:total_cents(O))]).

print_allocations(O) ->
    Name = customer:name(order:customer(O)),
    case order:state(O) of
        shipped ->
            io:format("  #~w (~s): shipped~n",
                      [order:id(O), Name]),
            lists:foreach(fun({Wh, Sku, Q}) ->
                io:format("    ~w x ~w from ~p~n", [Q, Sku, Wh])
            end, order:allocations(O));
        Other ->
            io:format("  #~w (~s): ~p (not shipped)~n",
                      [order:id(O), Name, Other])
    end.

print_state(O) ->
    io:format("  #~w (~s): ~p  total=$~s~n",
              [order:id(O), customer:name(order:customer(O)),
               order:state(O),
               format_cents(order:total_cents(O))]).

format_cents(Cents) ->
    Sign  = case Cents < 0 of true -> "-"; false -> "" end,
    Abs   = abs(Cents),
    Whole = Abs div 100,
    Rem   = Abs rem 100,
    lists:flatten(io_lib:format("~s~w.~2..0w", [Sign, Whole, Rem])).

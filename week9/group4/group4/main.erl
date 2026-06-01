-module(main).
-export([start/0]).

start() ->
    L0 = ledger:new(),
    L1 = ledger:add_account(L0, account:new(alice, 100)),
    L2 = ledger:add_account(L1, account:new(bob, 200)),
    L  = ledger:add_account(L2, account:new(carol, 50)),

    io:format("Initial state:~n"),
    print_state(L),

    Transactions = [
        {transfer, alice, bob,   30},   %% normal
        {transfer, bob,   carol, 50},   %% normal
        {transfer, alice, carol, 200},  %% alice has only $70 left here -- insufficient
        {transfer, carol, alice, 25}    %% normal
    ],

    io:format("~nApplying transactions:~n"),
    print_transactions(Transactions),

    LFinal = ledger:apply_all(L, Transactions),

    io:format("~nFinal state:~n"),
    print_state(LFinal),

    io:format("~nDirect balance queries:~n"),
    io:format("  alice: $~p~n", [ledger:balance(LFinal, alice)]),
    io:format("  bob:   $~p~n", [ledger:balance(LFinal, bob)]),
    io:format("  carol: $~p~n", [ledger:balance(LFinal, carol)]),
    ok.

print_state(L) ->
    io:format("  Balances:~n"),
    lists:foreach(
        fun ({Name, B}) -> io:format("    ~s: $~p~n", [Name, B]) end,
        ledger:list_balances(L)),
    io:format("  Total assets: $~p~n", [ledger:total_assets(L)]).

print_transactions([]) ->
    ok;
print_transactions([{transfer, F, T, A} | Rest]) ->
    io:format("  transfer ~s -> ~s: $~p~n", [F, T, A]),
    print_transactions(Rest).

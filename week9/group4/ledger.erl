-module(ledger).
-export([new/0, add_account/2, find/2,
         transfer/4, apply_all/2,
         balance/2, total_assets/1, list_balances/1]).

%% A ledger is a list of accounts.

new() ->
    [].

add_account(Ledger, Account) ->
    [Account | Ledger].

find([], _Name) ->
    not_found;
find([A | Rest], Name) ->
    case account:name(A) =:= Name of
        true  -> A;
        false -> find(Rest, Name)
    end.

%% Transfer Amount from FromName's account to ToName's account.
%% Returns {ok, NewLedger} on success, {error, Reason} otherwise.
%% On error, the ledger is unchanged.
transfer(Ledger, FromName, ToName, Amount) ->
    case find(Ledger, FromName) of
        not_found ->
            {error, {no_such_account, FromName}};
        From ->
            case find(Ledger, ToName) of
                not_found ->
                    {error, {no_such_account, ToName}};
                To ->
                    case account:withdraw(To, Amount) of
                        {error, R} ->
                            {error, R};
                        {ok, To1} ->
                            From1 = account:deposit(From, Amount),
                            L1 = replace(Ledger, FromName, From1),
                            L2 = replace(L1, ToName, To1),
                            {ok, L2}
                    end
            end
    end.

replace([], _Name, _New) ->
    [];
replace([A | Rest], Name, New) ->
    case account:name(A) =:= Name of
        true  -> [A | Rest];
        false -> [A | replace(Rest, Name, New)]
    end.

%% Apply a list of {transfer, From, To, Amount} transactions to a ledger.
%% Failed transfers leave the ledger unchanged and the next transaction
%% continues from the pre-failure state.
apply_all(Ledger, []) ->
    Ledger;
apply_all(Ledger, [{transfer, F, T, A} | Rest]) ->
    case transfer(Ledger, F, T, A) of
        {ok, L1}    -> apply_all(L1, Rest);
        {error, _R} -> Ledger
    end.

balance(Ledger, Name) ->
    case find(Ledger, Name) of
        not_found -> not_found;
        Account   -> account:balance(Account)
    end.

%% Sum of all balances in the ledger.
%% Reads each account's stored balance directly via pattern matching.
total_assets([]) ->
    0;
total_assets([{account, _, B} | Rest]) ->
    B + total_assets(Rest).

list_balances([]) ->
    [];
list_balances([A | Rest]) ->
    [{account:name(A), account:balance(A)} | list_balances(Rest)].

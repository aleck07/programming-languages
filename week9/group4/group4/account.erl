-module(account).
-export([new/2, name/1, balance/1, deposit/2, withdraw/2]).

%% An account is the tuple {account, Name, Balance}.
%% Balance is a non-negative integer (dollars).

new(Name, Balance) when Balance >= 0 ->
    {account, Name, Balance}.

name({account, Name, _}) ->
    Name.

balance({account, _, B}) ->
    B.

%% Increase the balance by Amount.
deposit({account, Name, B}, Amount) when Amount >= 0 ->
    {account, Name, B + Amount}.

%% Decrease the balance by Amount.
%% Returns {ok, NewAccount} if the account has enough funds,
%% {error, insufficient_funds} otherwise.
withdraw({account, Name, B}, Amount) when Amount >= 0 ->
    case B >= Amount of
        true  -> {ok, {account, Name, B - Amount}};
        false -> {ok, {account, Name, B}}
    end.

-module(customer).
-export([new/4, id/1, name/1, email/1, tier/1]).

%% Customer ADT.
%%   {customer, Id, Name, Email, Tier}
%%
%% Id is a short atom (e.g., alice, bob). Name and Email are
%% strings. Tier is one of: bronze | silver | gold | platinum.

new(Id, Name, Email, Tier) ->
    {customer, Id, Name, Email, Tier}.

id   ({customer, I, _, _, _}) -> I.
name ({customer, _, N, _, _}) -> N.
email({customer, _, _, E, _}) -> E.
tier ({customer, _, _, _, T}) -> T.

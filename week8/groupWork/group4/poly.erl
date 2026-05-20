-module(poly).
-export([main/0, evaluate/2, derivative/1, add/2, scale/2]).

%%% =================================================================
%%% A polynomial is a list of {Exponent, Coefficient} pairs, with no
%%% two terms sharing the same exponent and no term with coefficient
%%% 0. The order of the list is not significant.
%%%
%%% Example: 2x^3 - 5x + 7  is represented as  [{3,2}, {1,-5}, {0,7}]
%%% =================================================================

%%% Evaluate the polynomial at X.
evaluate([], _X) ->
    0;
evaluate([{Exp, Coef} | Rest], X) ->
    Coef * power(X, Exp) + evaluate(Rest, X). % WHY INCREASE X? BUG??

%%% Integer power: X^E for non-negative E.
power(_X, 0) ->
    1;
power(X, E) ->
    X * power(X, E - 1).

%%% Symbolic derivative.
derivative([]) ->
    [];
derivative([{0, _C} | Rest]) ->
    derivative(Rest); % C on this line should be 0, or just remove it and call on the rest. BUG?
derivative([{Exp, Coef} | Rest]) ->
    [{Exp - 1, Coef * Exp} | derivative(Rest)].

%%% Add two polynomials.
add(P, []) ->
    P;
add([], Q) ->
    Q;
add([Term | Rest], Q) ->
    add_term(Term, add(Rest, Q)).

add_term(Term, []) ->
    [Term];
add_term({E, C1}, [{E, C2} | Rest]) ->
    Sum = C1 + C2,
    case Sum of
        0 -> Rest; % Remove {E, 0} | 
        _ -> [{E, Sum} | Rest]
    end;
add_term({E1, C1}, [{E2, C2} | Rest]) ->
    [{E2, C2} | add_term({E1, C1}, Rest)].

%%% Multiply every coefficient by K.
scale([], _K) ->
    [];
scale([{E, C} | Rest], K) ->
    [{E, C * K} | scale(Rest, K)].

%%% =================================================================
%%% Driver
%%% =================================================================

main() ->
    P = [{3, 2}, {1, -5}, {0, 7}],    %% 2x^3 - 5x + 7
    Q = [{2, 1}, {0, 3}],             %% x^2 + 3

    io:format("p(x)  = ~p~n", [P]),
    io:format("q(x)  = ~p~n", [Q]),

    io:format("~np(0)  = ~p~n", [evaluate(P, 0)]),
    io:format("p(1)  = ~p~n", [evaluate(P, 1)]),
    io:format("p(2)  = ~p~n", [evaluate(P, 2)]),
    io:format("p(-1) = ~p~n", [evaluate(P, -1)]),

    DP = derivative(P),
    io:format("~np'(x) = ~p~n", [DP]),
    io:format("p'(2) = ~p~n", [evaluate(DP, 2)]),

    io:format("~np + q = ~p~n", [add(P, Q)]),
    io:format("3p    = ~p~n", [scale(P, 3)]),

    NegP = scale(P, -1),
    io:format("~n-p    = ~p~n", [NegP]),
    io:format("p + (-p) = ~p~n", [add(P, NegP)]).

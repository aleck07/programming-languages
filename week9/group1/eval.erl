-module(eval).
-export([eval/1]).

%% Evaluate an arithmetic AST.
%% AST nodes: {num, N}, {op, Op, L, R}, {neg, E}.

eval({num, N}) ->
    N;
eval({neg, E}) ->
    -eval(E);
eval({op, Op, L, R}) ->
    apply_op(Op, eval(L), eval(R)).

apply_op('+', A, B) -> A + B;
apply_op('-', A, B) -> A - B; %% was B - A
apply_op('*', A, B) -> A * B;
apply_op('/', A, B) -> A div B.

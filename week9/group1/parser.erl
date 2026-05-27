-module(parser).
-export([parse/1]).

%% Parse a token list into an AST.
%%
%% Grammar:
%%   expr   := term (('+' | '-') term)*       -- left-associative
%%   term   := unary (('*' | '/') unary)*     -- left-associative
%%   unary  := '-' unary | primary            -- unary minus, right-associative
%%   primary := number | '(' expr ')'
%%
%% AST nodes:
%%   {num, N}
%%   {op, Op, L, R}    where Op is '+', '-', '*', or '/'
%%   {neg, E}          unary negation

parse(Tokens) ->
    {AST, _Rest} = parse_expr(Tokens),
    AST.

%% expr := term (('+' | '-') term)*
parse_expr(Tokens) ->
    {L, T1} = parse_term(Tokens),
    parse_expr_rest(L, T1).

parse_expr_rest(L, ['+' | T]) ->
    {R, T1} = parse_term(T),
    parse_expr_rest({op, '+', L, R}, T1);
parse_expr_rest(L, ['-' | T]) ->
    {R, T1} = parse_expr(T),
    parse_expr_rest({op, '-', L, R}, T1);
parse_expr_rest(L, T) ->
    {L, T}.

%% term := unary (('*' | '/') unary)*
parse_term(Tokens) ->
    {L, T1} = parse_unary(Tokens),
    parse_term_rest(L, T1).

parse_term_rest(L, ['*' | T]) ->
    {R, T1} = parse_unary(T),
    parse_term_rest({op, '*', L, R}, T1);
parse_term_rest(L, ['/' | T]) ->
    {R, T1} = parse_term(T),
    parse_term_rest({op, '/', L, R}, T1);
parse_term_rest(L, T) ->
    {L, T}.

%% unary := '-' unary | primary
parse_unary(['-' | T]) ->
    {E, T1} = parse_unary(T),
    {{op, '-', E, {num, 0}}, T1};
parse_unary(T) ->
    parse_primary(T).

%% primary := number | '(' expr ')'
parse_primary([{num, N} | T]) ->
    {{num, N}, T};
parse_primary(['(' | T]) ->
    {Expr, T1} = parse_expr(T),
    [')' | T2] = T1,
    {Expr, T2}.

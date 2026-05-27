-module(main).
-export([start/0]).

start() ->
    Tests = [
        {"2 + 3 * 4",
         [{num,2}, '+', {num,3}, '*', {num,4}]},

        {"(2 + 3) * 4",
         ['(', {num,2}, '+', {num,3}, ')', '*', {num,4}]},

        {"10 - 3 - 2",
         [{num,10}, '-', {num,3}, '-', {num,2}]},

        {"12 / 6 / 2",
         [{num,12}, '/', {num,6}, '/', {num,2}]},

        {"5 - 2",
         [{num,5}, '-', {num,2}]},

        {"-5",
         ['-', {num,5}]},

        {"5 - -3",
         [{num,5}, '-', '-', {num,3}]},

        {"-2 * 3",
         ['-', {num,2}, '*', {num,3}]}
    ],

    lists:foreach(fun ({Source, Tokens}) ->
        AST = parser:parse(Tokens),
        Value = eval:eval(AST),
        io:format("~s = ~p~n", [Source, Value])
    end, Tests),
    ok.

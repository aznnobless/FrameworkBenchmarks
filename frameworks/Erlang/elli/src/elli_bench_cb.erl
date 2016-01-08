-module(elli_bench_cb).
-export([handle/2, handle_event/3, param_eval/1]).

-include_lib("elli/include/elli.hrl").
-behaviour(elli_handler).

%% 스트링이 넘어간다.

%% This function is poor approach because this function is defined imperative language way.
%% If you are familiar with Erlang, please modify this function
%% Purpose of this function is to distinguish parameter value for the multiple query test.
param_eval(S) ->
    %%I = list_to_integer(S),
    I = 1,
    T = is_integer(S),
    if
        T == false ->
            I = 1;
        T == true ->
            I = 2
    end,
    I.

% param_eval2(S) ->
%     I = string:to_integer(S),
%     trim_param(I).

% trim_param({IntValue, Rest}) ->
%     IntValue;
% trim_param({error, Reason}) ->
%     1.

handle(Req, _Args) ->
    %% Delegate to our handler function
    handle(Req#req.method, elli_request:path(Req), Req).

%% Plaintext test route 
handle('GET', [<<"plaintext">>], _Req) ->
    %% Reply with a normal response. 'ok' can be used instead of '200'
    %% to signal success.
    {ok,[{<<"Content-Type">>, <<"text/plain">>}], <<"Hello, World!">>};

%% Json test route
handle('GET',[<<"json">>], _Req) ->
    %% Reply with a normal response. 'ok' can be used instead of '200'
    %% to signal success.
    {ok, [{<<"Content-Type">>, <<"application/json">>}], jiffy:encode({[{<<"message">>, <<"Hello, World!">>}]})};

%% db test route (Single Database Query)
handle('GET',[<<"db">>], Req) ->
        random:seed(erlang:now()),
        JSON = case elli_request:get_arg(<<"queries">>, Req) of
		undefined ->
			{result_packet, _, _, [[ID, Rand]], _} = emysql:execute(test_pool, db_stmt, [random:uniform(10000)]),
			[{[{<<"id">>, ID}, {<<"randomNumber">>, Rand}]}];
		N ->
			I = list_to_integer(binary_to_list(N)),
			Res = [ {[{<<"id">>, ID}, {<<"randomNumber">>, Rand}]} || 
			        {result_packet, _, _, [[ID, Rand]], _} <- [emysql:execute(test_pool, db_stmt, [random:uniform(10000)]) || _ <- lists:seq(1, I) ]],
			Res
		end,
    {ok, [{<<"Content-Type">>, <<"application/json">>}], jiffy:encode(lists:nth(1,JSON))};

%% Multiple query test route
handle('GET',[<<"query">>], Req) ->
        random:seed(erlang:now()),
        JSON = case elli_request:get_arg(<<"queries">>, Req) of
        undefined ->
            {result_packet, _, _, [[ID, Rand]], _} = emysql:execute(test_pool, db_stmt, [random:uniform(500)]),
            [{[{<<"id">>, ID}, {<<"randomNumber">>, Rand}]}];

        %% TODO : I am not familiar with Erlang, so this solution is sloppy.
        %%        If you understand Erlang well, please update this.
        N ->
            %I = list_to_integer(binary_to_list(N)),
            I = 1,
            try
                I = list_to_integer(N)
            catch error:badarg ->
                false
            end,
            Res = [ {[{<<"id">>, ID}, {<<"randomNumber">>, Rand}]} || 
                    {result_packet, _, _, [[ID, Rand]], _} <- [emysql:execute(test_pool, db_stmt, [random:uniform(500)]) || _ <- lists:seq(1, I) ]],
            Res
        end,
    {ok, [{<<"Content-Type">>, <<"application/json">>}], jiffy:encode(JSON)};

handle(_, _, _Req) ->
    {404, [], <<"Not Found">>}.

%% @doc: Handle request events, like request completed, exception
%% thrown, client timeout, etc. Must return 'ok'.
handle_event(_Event, _Data, _Args) ->
    ok.



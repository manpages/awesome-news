-module(an_sender).

%%-define(NODEBUG, 1).
-include_lib("eunit/include/eunit.hrl").

-behavior(gen_server).

%-compile(export_all).
-export([init/1, code_change/3, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).
-export([start/0, loop/1]).


start() ->
	resource_bootstrap(),
	socket_server:start(?MODULE, 53318, {?MODULE, loop}).

resource_bootstrap() ->
	resource_discovery:add_target_resource_type(an_generic_receiver).

loop(Socket) ->
	?debugHere,
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
			?debugFmt("recv~p", [Data]),
			IOResult = (catch io:format("~ts~n", [unicode:characters_to_list(Data)])),
			?debugFmt("~p", IOResult),
			Json = case catch(jiffy:decode(Data)) of
				{error, Error} -> 
					?debugHere,
            		gen_tcp:send(Socket, <<"Your JSON is fucked up, sir\r\n">>),
					Error;
				X -> 
					?debugFmt("X~p", [X]),
            		gen_tcp:send(Socket, <<"JSON parsed\r\n">>),
					case (catch broadcast(X)) of 
						{'EXIT', Trace} -> 
							?debugFmt("broadcast failed~p", [Trace]),
							gen_tcp:send(Socket, <<"Protocol mismatch or broadcast failiure\r\n">>);
						Result -> Result
					end
			end,
			?debugFmt("decoded~p", [Json]),
            loop(Socket);
        {error, closed} ->
			?debugMsg("hujs."),
            ok
    end.

rediscover(ResourceTypes) -> 
	resource_discovery:add_target_resource_types(
		ResourceTypes
	),
	resource_discovery:trade_resources(),
	?debugMsg("rediscovered").

broadcast(JsonStructure) ->
	?debugMsg("broadcasting"),
	case JsonStructure of 
		{array, TupleList} ->
			?debugFmt("tuplelist~p", [TupleList]),
			ResourceTypes = [X || X <- lists:map(fun ({struct, [X]}) -> erlang:element(1, X) end, TupleList)],
			rediscover(ResourceTypes),
			lists:foreach(
				fun ({struct, [{T,Data}]}) -> 
					?debugFmt("get_resources(~p) -> ~p", [T, resource_discovery:get_resources(T)]),
					lists:foreach(
						fun(Res) -> 
							?debugFmt("sending message ~p from ~p to ~p", [Data, self(), Res]),
							an_receiver:notify(Res, Data)
						end, resource_discovery:get_resources(T)
					)
				end,
				TupleList
			); 
		_ -> error 
	end.


% These are just here to suppress warnings.
handle_call(_Msg, _Caller, State) -> {noreply, State}.
handle_info(_Msg, Library) -> {noreply, Library}.
handle_cast(_Msg, Library) -> {noreply, Library}.
terminate(_Reason, _Library) -> ok.
code_change(_OldVersion, Library, _Extra) -> {ok, Library}.
init(_) -> {ok, []}.

-module(an_receiver).

-include_lib("eunit/include/eunit.hrl").

-behavior(gen_server).

%-compile(export_all).
-export([init/1, code_change/3, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).
-export([start/0, notify/2]).

-define(SERVER, ?MODULE).

start() ->
	{ok, PID} = gen_server:start_link({local, ?SERVER}, ?MODULE, [], []),
	resource_bootstrap(PID).

resource_bootstrap(PID) ->
	resource_discovery:add_local_resource_tuple({an_generic_receiver, PID}).

notify(PID, Data) ->
	?debugFmt("OMAI!!!~p",[Data]),
	gen_server:cast(PID, {notify, Data}),
	ok
.

% These are just here to suppress warnings.
handle_call({notify, Data}, Caller, State) ->
	?debugFmt("FML~p~p", [Caller, Data]),
	{{reply, hujs}, State}
;
handle_call(_Msg, _Caller, State) -> {noreply, State}.
handle_info(_Msg, Library) -> {noreply, Library}.
handle_cast({notify, Data}, State) ->
	?debugFmt("roflmao~p", [Data]),
	os:cmd("export DISPLAY=:0;notify-send " ++ io_lib:format("'Message' '~p'", [Data])),
	{noreply, State}
;
handle_cast(_Msg, Library) -> 
	?debugFmt("roflmao~p", ["!"]),
	{noreply, Library}.
terminate(_Reason, _Library) -> ok.
code_change(_OldVersion, Library, _Extra) -> {ok, Library}.
init(_) -> {ok, []}.



-module(an_receiver).

-behavior(gen_server).

-export([init/1, code_change/3, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).
-export([start/0, notify/2]).

-define(SERVER, ?MODULE).

start() ->
	{ok, PID} = gen_server:start_link({local, ?SERVER}, ?MODULE, [], []),
	resource_bootstrap(PID),
	{ok, PID}.

resource_bootstrap(PID) ->
	resource_discovery:add_local_resource_tuple({an_generic_receiver, PID}).

notify(PID, Data) ->
	gen_server:cast(PID, {notify, Data}),
	ok
.

% These are just here to suppress warnings.
handle_call(_Msg, _Caller, State) -> {noreply, State}.
handle_info(_Msg, State) -> {noreply, State}.
handle_cast({notify, Data}, StdOut) ->
	port_command(StdOut, [Data, "\n"]),
	{noreply, StdOut}
;
handle_cast(_Msg, State) -> 
	{noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.
init(_) -> 
	StdOut = open_port("/dev/stdout", [binary, out]),
	{ok, StdOut}.

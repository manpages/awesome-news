-module(an_receiver_sup).

-include_lib("eunit/include/eunit.hrl").
-behavior(supervisor).

-export([
	start_link/0,
	init/1
]).

-define(SERVER, ?MODULE).

start_link() ->
	?debugHere,
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
	?debugHere,
	RestartStrategy    = one_for_one,
	MaxRestarts        = 1000,
	MaxTimeBetRestarts = 3600,
	SupFlags = {RestartStrategy, MaxRestarts, MaxTimeBetRestarts},

	ChildSpecs = [ 
		{an_receiver, %% we fire generic receiver that writes stuff to stdout
			{an_receiver, start, []},
			permanent,
			1000,
			worker,
			[an_receiver, socket_server]
		}
	],
	{ok, {SupFlags, ChildSpecs}}
.

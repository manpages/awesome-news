-module(an_sender_sup).

-behavior(supervisor).

-export([
	start_link/0,
	init/1
]).

-define(SERVER, ?MODULE).

start_link() ->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
	RestartStrategy    = one_for_one,
	MaxRestarts        = 1000,
	MaxTimeBetRestarts = 3600,
	SupFlags = {RestartStrategy, MaxRestarts, MaxTimeBetRestarts},

	ChildSpecs = [ 
		{an_sender,
			{an_sender, start, []},
			permanent,
			1000,
			worker,
			[an_sender, socket_server]
		}
	],
	{ok, {SupFlags, ChildSpecs}}
.

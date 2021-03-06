-module(an_sender_sup).

-behavior(supervisor).

-export([
	start_link/0,
	init/1
]).

-define(SERVER, ?MODULE).

start_link() ->
	bootstrap(),
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
	RestartStrategy    = one_for_one,
	MaxRestarts        = 1000,
	MaxTimeBetRestarts = 3600,
	SupFlags = {RestartStrategy, MaxRestarts, MaxTimeBetRestarts},

	ChildSpecs = [ %% also dirty as fuck
		{yaws_sup,
			{yaws_sup, start_link, []},
			permanent,
			1000,
			supervisor,
			[yaws_sup]
		}
	],
	{ok, {SupFlags, ChildSpecs}}.

bootstrap() -> %% dirty-dirty
	application:start(resource_discovery),
	resource_discovery:add_target_resource_type(an_generic_receiver).

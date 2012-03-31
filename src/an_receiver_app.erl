-module(an_receiver_app).

-define(NODEBUG, 1).
-include_lib("eunit/include/eunit.hrl").
-behavior(application).

-export([
	start/2,
	stop/1
]).

start (_T, _A) -> 
	X = an_receiver_sup:start_link(),
	?debugFmt("start/2 -> ~p", [X]),
	X.
stop (_S) -> ok.

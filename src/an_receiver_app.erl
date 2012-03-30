-module(an_receiver_app).

-include_lib("eunit/include/eunit.hrl").
-behavior(application).

-export([
	start/2,
	stop/1
]).

start (_T, _A) -> 
	an_receiver_sup:start_link().
stop (_S) -> ok.

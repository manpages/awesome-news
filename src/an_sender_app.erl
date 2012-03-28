-module(an_sender_app).

-include_lib("eunit/include/eunit.hrl").


-export([
	start/2,
	stop/1
]).

start (_T, _A) -> 
	an_sender_sup:start_link().
stop (_S) -> ok.

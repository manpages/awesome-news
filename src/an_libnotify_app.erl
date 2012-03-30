-module(an_libnotify_app).

-include_lib("eunit/include/eunit.hrl").
-behavior(application).

-export([
	start/2,
	stop/1
]).

start (_T, _A) -> 
	an_libnotify_sup:start_link().
stop (_S) -> ok.

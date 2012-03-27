{application,an_sender,
	[
		{description,"Erlang-based notifier"},

		{vsn,"0.1"},

		{modules, [

			%% GENERAL PURPOSE
			json, socket_server,

			%% SENDER
			an_sender, an_sender_sup, an_sender_app
		]},

		{registered,[an_sender_app]},

		{applications, [
			kernel,
			stdlib,
			resource_discovery
		]},

		{mod,{an_sender_app,[]}}
	]
}.

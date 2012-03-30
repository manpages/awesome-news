{application,an_receiver,
	[
		{description,"Generic awesome-news receiver"},

		{vsn,"0.1"},

		{modules, [

			%% GENERAL PURPOSE
			json, socket_server,

			%% RECEIVER
			an_receiver, an_receiver_sup, an_receiver_app
		]},

		{registered,[an_receiver_sup]},

		{applications, [
			kernel,
			stdlib,
			resource_discovery
		]},

		{mod,{an_receiver_app,[]}} 

	]
}.

{application,awesome_news,
	[
		{description,"Erlang-based notifier"},

		{vsn,"0.1"},

		{modules, [

			%% GENERAL PURPOSE
			json, socket_server,

			%% SENDER
			an_sender, an_sender_sup, an_sender_app,

			%% RECEIVER
			an_receiver, an_receiver_sup, an_receiver_app
		]},

		{registered,[]},

		{applications, [
			kernel,
			stdlib,
			resource_discovery
		]}

	]
}.

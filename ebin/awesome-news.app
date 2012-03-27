{application,awesome_news,
	[
		{description,"Erlang-based notifier"},

		{vsn,"0.1"},

		{modules, [
			an_sender
		]},

		{registered,[]},

		{applications, [
			kernel,
			stdlib,
			resource_discovery
		]}

	]
}.

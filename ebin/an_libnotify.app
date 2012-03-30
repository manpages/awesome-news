{application,an_libnotify,
	[
		{description,"awesome-news libnotify piper"},

		{vsn,"0.1"},

		{modules, [

			%% GENERAL PURPOSE
			json,

			%% RECEIVER
			an_libnotify, an_libnotify_sup, an_libnotify_app
		]},

		{registered,[an_libnotify_sup]},

		{applications, [
			kernel,
			stdlib,
			resource_discovery
		]},

		{mod,{an_libnotify_app,[]}} 

	]
}.

return {
	cmdline = {
		format = {
			search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
			search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
		},
	},
	messages = {
		enabled = true,
		view = "mini",
		view_error = "mini",
		view_warn = "mini",
		view_history = "messages",
		view_search = "virtualtext",
	},
}
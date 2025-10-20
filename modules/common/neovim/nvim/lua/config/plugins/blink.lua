require("blink.cmp").setup({
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 50,
		},
		accept = { auto_brackets = { enabled = false } },
		menu = { auto_show = false },
	},
	keymap = {
		["<C-n>"] = { "show", "select_next", "fallback" },
		["<C-p>"] = { "show", "select_prev", "fallback" },
		["<C-y>"] = { "accept", "fallback" },
		["<C-e>"] = { "hide", "fallback" },
	},
})

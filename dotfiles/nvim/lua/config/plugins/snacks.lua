return {
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				matcher = {
					frecency = true,
				},
				debug = {
					scores = true,
				},
				sources = {
					files = {
						hidden = true,
						no_ignore = false,
					},
				},
			},
		},
	},
}

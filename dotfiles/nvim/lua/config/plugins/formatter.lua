return {
	{
		"stevearc/conform.nvim",
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					cs = { "csharpier" },
				},

				format_on_save = {
					timeout_ms = 500,
				},
			})
		end,
	},
}

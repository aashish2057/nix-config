require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
		cs = { "csharpier" },
		tf = { "terraform_fmt" },
		terraform = { "terraform_fmt" },
	},

	format_on_save = {
		timeout_ms = 500,
	},
})

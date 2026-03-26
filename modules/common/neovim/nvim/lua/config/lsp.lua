vim.lsp.config["luals"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		format = {
			enable = false,
		},
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
}

vim.lsp.enable("luals")

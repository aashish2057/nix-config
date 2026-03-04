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

vim.lsp.config["ts_ls"] = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
}

vim.lsp.enable("ts_ls")

vim.lsp.enable("tailwindcss")

vim.lsp.enable("astro")

vim.lsp.config["ty"] = {
	cmd = { "ty", "server" },
	filetypes = { "python" },
}

vim.lsp.enable("ty")

vim.lsp.config["clangd"] = {
	cmd = { "clangd" },
	filetypes = { "c", "cpp" },
}

vim.lsp.enable("clangd")

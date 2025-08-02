----------OPTIONs----------

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt
local keymap = vim.keymap

-- line numbers
opt.number = true
opt.relativenumber = true

-- swap file
opt.swapfile = false

-- appearance
opt.signcolumn = "yes"

----------LSPs----------
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

----------FORMATTERs----------
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},

	format_on_save = {
		timeout_ms = 500,
	},
})

----------PLUGINs----------

-- colorscheme
require("material").setup({
	plugins = {},
})
vim.g.material_style = "deep ocean"
vim.cmd.colorscheme("material")

-- file explorer
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

keymap.set("n", "<leader>n", "<cmd>Oil<cr>")

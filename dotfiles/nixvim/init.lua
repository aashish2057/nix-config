----------OPTIONS----------

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt
local keymap = vim.keymap

-- line numbers
opt.number = true
opt.relativenumber = true

----------PLUGINS----------

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

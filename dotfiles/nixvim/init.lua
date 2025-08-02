-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- line numbers
opt.number = true
opt.relativenumber = true

-- colorscheme
require("material").setup({
	plugins = {},
})
vim.g.material_style = "deep ocean"
vim.cmd.colorscheme("material")

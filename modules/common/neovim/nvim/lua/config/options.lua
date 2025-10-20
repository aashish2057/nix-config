-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- line numbers
opt.number = true
opt.relativenumber = true

-- swap file
opt.swapfile = false

-- appearance
opt.termguicolors = true
opt.signcolumn = "yes"

-- tabs
opt.softtabstop = 4
opt.shiftwidth = 4
opt.tabstop = 4

-- search setttings
opt.ignorecase = true
opt.smartcase = true

-- clipboard
opt.clipboard:append("unnamedplus")

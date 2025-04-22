local opt = vim.opt

-- line numbers
opt.number = true
opt.relativenumber = true

-- tabs & indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

-- line wrapping
opt.linebreak = true

-- search setttings
opt.ignorecase = true
opt.smartcase = true

-- apperance
opt.termguicolors = true
opt.signcolumn = "yes"

opt.clipboard:append("unnamedplus")

require("material").setup({
	plugins = {},
})
vim.g.material_style = "deep ocean"
vim.cmd.colorscheme("material")

local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
vim.api.nvim_set_hl(0, "WinBar", { bg = normal.bg })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = normal.bg })

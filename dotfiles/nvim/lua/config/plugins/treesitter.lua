return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"markdown",
					"nix",
					"c_sharp",
					"typescript",
					"html",
					"javascript",
					"yaml",
					"c",
					"astro",
					"http",
				},
				auto_install = false,
				sync_install = false,
				ignore_install = {},
				modules = {},
				highlight = {
					enable = true,
					disable = function(lang, buf)
						local max_filesize = 100 * 1024
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
}

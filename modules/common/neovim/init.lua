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
local uv = vim.loop or vim.uv
vim.lsp.config("roslyn", {
	filetypes = { "cs" },
	cmd = {
		"Microsoft.CodeAnalysis.LanguageServer",
		"--logLevel",
		"Information",
		"--extensionLogDirectory",
		vim.fs.joinpath(uv.os_tmpdir(), "roslyn_ls/logs"),
		"--stdio",
	},
	settings = {
		["csharp|background_analysis"] = {
			dotnet_compiler_diagnostics_scope = "fullSolution",
		},
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
			csharp_enable_inlay_hints_for_lambda_parameter_types = true,
			csharp_enable_inlay_hints_for_types = true,
			dotnet_enable_inlay_hints_for_indexer_parameters = true,
			dotnet_enable_inlay_hints_for_literal_parameters = true,
			dotnet_enable_inlay_hints_for_object_creation_parameters = true,
			dotnet_enable_inlay_hints_for_other_parameters = true,
			dotnet_enable_inlay_hints_for_parameters = true,
			dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
			dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
			dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
		},
		["csharp|code_lens"] = {
			dotnet_enable_references_code_lens = true,
		},
		["csharp|completion"] = {
			dotnet_show_completion_items_from_unimported_namespaces = true,
		},
		["csharp|formating"] = {
			dotnet_organize_imports_on_format = true,
		},
	},
})

vim.lsp.enable("roslyn")

----------PLUGINs----------
require("lze").load({
	{
		"material.nvim",
		priority = 1000,
		after = function()
			require("material").setup()
			vim.g.material_style = "deep ocean"
			vim.cmd.colorscheme("material")
		end,
	},
	{
		"nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
			})
		end,
	},
	{
		"no-neck-pain.nvim",
		cmd = { "NoNeckPain" },
		keys = {
			{ "<leader>nn", "<cmd>NoNeckPain<cr>", desc = "Toggle NoNeckPain" },
		},
		after = function()
			require("no-neck-pain").setup({
				width = 200,
			})
		end,
	},
	{
		"mini.icons",
		priority = 1000,
		after = function()
			require("mini.icons").setup()
		end,
	},
	{
		"mini.statusline",
		priority = 1000,
		after = function()
			require("mini.statusline").setup()
		end,
	},
	{
		"mini.diff",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("mini.diff").setup()
		end,
	},
	{
		"oil.nvim",
		keys = {
			{ "<leader>n", "<cmd>Oil<cr>", desc = "Open Oil file explorer" },
		},
		after = function()
			require("oil").setup({
				view_options = {
					show_hidden = true,
				},
			})
		end,
	},
	{
		"conform.nvim",
		event = { "BufWritePre" },
		after = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					nix = { "alejandra" },
				},
				format_on_save = {
					timeout_ms = 500,
				},
			})
		end,
	},
	{
		"snacks.nvim",
		keys = {
			{
				"<leader>ff",
				function()
					require("snacks").picker.files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fs",
				function()
					require("snacks").picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>fb",
				function()
					require("snacks").picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>gl",
				function()
					require("snacks").picker.git_log()
				end,
				desc = "Git log",
			},
			{
				"<leader>glf",
				function()
					require("snacks").picker.git_log_file()
				end,
				desc = "Git log file",
			},
		},
		after = function()
			require("snacks").setup({
				picker = {
					matcher = {
						frecency = true,
					},
					debug = {
						scores = true,
					},
					sources = {
						files = {
							hidden = true,
							no_ignore = false,
						},
					},
				},
			})
		end,
	},
	{
		"roslyn.nvim",
		ft = "cs",
		after = function()
			require("roslyn").setup()
		end,
	},
})

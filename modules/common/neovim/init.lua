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

----------KEYMAPs----------
-- show error
keymap.set("n", "<leader>se", "<cmd>lua vim.diagnostic.open_float()<CR>")

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

vim.lsp.config["clangd"] = {
	cmd = { "clangd" },
	filetypes = { "c", "cpp" },
}

vim.lsp.enable("clangd")

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

vim.lsp.config["terraformls"] = {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "tf" },
	init_options = {
		ignoreSingleFileWarning = true,
	},
}

vim.lsp.enable("terraformls")
----------FORMATTERs----------
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
		cs = { "csharpier" },
		tf = { "terraform_fmt" },
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

require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
})

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

keymap.set("n", "<leader>ff", function() -- find files
	require("snacks").picker.files()
end)
keymap.set("n", "<leader>fs", function() -- grep
	require("snacks").picker.grep()
end)
keymap.set("n", "<leader>fb", function() -- buffers
	require("snacks").picker.buffers()
end)
keymap.set("n", "<leader>gl", function() -- list all git logs
	require("snacks").picker.git_log()
end)
keymap.set("n", "<leader>glf", function() -- list all git logs for current file
	require("snacks").picker.git_log_file()
end)
keymap.set("n", "<leader>lr", function() -- list all lsp references
	require("snacks").picker.lsp_references()
end)

-- no neck pain
require("no-neck-pain").setup({
	width = 138,
	autocmds = {
		enableOnVimEnter = true,
	},
})

-- mini
require("mini.diff").setup()
require("mini.icons").setup()
require("mini.statusline").setup()

-- roslyn
local roslyn_setup, roslyn = pcall(require, "roslyn")
if roslyn_setup then
	roslyn.setup()
end

-- blink-cmp
require("blink.cmp").setup({
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 50,
		},
		accept = { auto_brackets = { enabled = false } },
		menu = { auto_show = false },
	},
	keymap = {
		["<C-n>"] = { "show", "select_next", "fallback" },
		["<C-p>"] = { "show", "select_prev", "fallback" },
		["<C-y>"] = { "accept", "fallback" },
		["<C-e>"] = { "hide", "fallback" },
	},
})

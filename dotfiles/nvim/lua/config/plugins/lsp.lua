return {
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	{
		"seblyng/roslyn.nvim",
		ft = "cs",
		opts = {
			filewatching = "roslyn",
			config = {
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
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
			{
				"saghen/blink.cmp",
				dependencies = "rafamadriz/friendly-snippets",

				version = "*",

				opts = {
					keymap = { preset = "default" },

					appearance = {
						use_nvim_cmp_as_default = true,
						nerd_font_variant = "mono",
					},
				},
			},
		},
		config = function()
			vim.diagnostic.config({
				virtual_text = false,
			})
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
				},
				automatic_installation = true,
				automatic_enable = false,
			})
			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
				filetypes = { "lua" },
			})

			require("lspconfig").ts_ls.setup({
				capabilities = capabilities,
			})

			require("roslyn").setup({
				capabilities = capabilities,
			})
		end,
	},
}

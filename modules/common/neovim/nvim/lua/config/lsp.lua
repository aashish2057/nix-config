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

vim.lsp.config["ty"] = {
	cmd = { "ty", "server" },
	filetypes = { "python" },
}

vim.lsp.enable("ty")

vim.lsp.config["clangd"] = {
	cmd = { "clangd" },
	filetypes = { "c", "cpp" },
}

vim.lsp.enable("clangd")

if vim.g.IS_WORK then
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

	vim.lsp.config["terraformls"] = {
		cmd = { "terraform-ls", "serve" },
		filetypes = { "terraform", "tf" },
		init_options = {
			ignoreSingleFileWarning = true,
		},
	}

	vim.lsp.enable("terraformls")
end

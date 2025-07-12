-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap
-- Show diagnostic
keymap.set("n", "<leader>se", "<cmd>lua vim.diagnostic.open_float()<CR>")

-- Clear trailing whitespace in file
keymap.set("n", "<Leader>wc", [[:%s/\s\+$//e<cr>:noh<cr>]])

-- Snacks
keymap.set("n", "<leader>ff", function() -- find files
	Snacks.picker.files()
end)
keymap.set("n", "<leader>fs", function() -- grep
	Snacks.picker.grep()
end)
keymap.set("n", "<leader>fb", function() -- buffers
	Snacks.picker.buffers()
end)
keymap.set("n", "<leader>gs", function() -- git status
	Snacks.picker.git_status()
end)
keymap.set("n", "<leader>gl", function() -- list all git logs
	Snacks.picker.git_log()
end)
keymap.set("n", "<leader>glf", function() -- list all git logs for current file
	Snacks.picker.git_log_file()
end)
keymap.set("n", "<leader>ec", function() -- neovim configuration
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end)
keymap.set("n", "<leader>dc", function()
	vim.cmd(
		"edit "
			.. vim.fn.expand(
				"~/Dev/shelf/src/Shelf.Web/Shelf.Sql/EnvironmentConfigurations/DevConfigurationOverrides.yml"
			)
	)
end)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		keymap.set("n", "grn", vim.lsp.buf.rename)
		keymap.set({ "n", "v" }, "gra", vim.lsp.buf.code_action)
		keymap.set("n", "grr", vim.lsp.buf.references)
		keymap.set("n", "gri", vim.lsp.buf.implementation)
		keymap.set("n", "gO", vim.lsp.buf.document_symbol)
		keymap.set("i", "<C-s>", vim.lsp.buf.signature_help)
	end,
})

vim.g["diagnostics_active"] = true
function Toggle_diagnostics()
	if vim.g.diagnostics_active then
		vim.g.diagnostics_active = false
		vim.diagnostic.enable(false)
	else
		vim.g.diagnostics_active = true
		vim.diagnostic.enable()
	end
end

keymap.set("n", "<leader>d", Toggle_diagnostics)

keymap.set("n", "<leader>n", "<cmd>Oil<cr>")

keymap.set("n", "<leader>ac", function()
	if vim.b.completion == true or vim.b.completion == nil then
		vim.b.completion = false
		vim.notify("Auto Completion Disabled")
	else
		vim.b.completion = true
		vim.notify("Auto Completion Enabled")
	end
end)

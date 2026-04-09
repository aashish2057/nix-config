local keymap = vim.keymap

-- show error
keymap.set("n", "<leader>se", "<cmd>lua vim.diagnostic.open_float()<CR>")

keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")

-- open file explorer
keymap.set("n", "<leader>n", "<cmd>Oil<cr>")

-- find files
keymap.set("n", "<leader>ff", function()
	require("fff").find_files()
end)

-- grep
keymap.set("n", "<leader>fs", function()
	require("fff").live_grep({
		grep = {
			modes = { "plain", "fuzzy", "regex" },
		},
	})
end)

-- buffers
keymap.set("n", "<leader>fb", function()
	require("snacks").picker.buffers()
end)

-- list all git logs
keymap.set("n", "<leader>gl", function()
	require("snacks").picker.git_log()
end)

-- list all git logs for current file
keymap.set("n", "<leader>glf", function()
	require("snacks").picker.git_log_file()
end)

-- list all lsp references
keymap.set("n", "<leader>lr", function()
	require("snacks").picker.lsp_references()
end)

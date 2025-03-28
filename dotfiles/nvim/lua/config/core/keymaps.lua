-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap

-- Show diagnostic
keymap.set("n", "<leader>se", "<cmd>lua vim.diagnostic.open_float()<CR>")

-- Clear trailing whitespace in file
keymap.set("n", "<Leader>wc", [[:%s/\s\+$//e<cr>:noh<cr>]])

-- Telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer
keymap.set("n", "<leader>ec", function() -- list files in ~/Desktop/nix-config directory
  require("telescope.builtin").find_files({
    cwd = vim.fn.expand("~/Dev/nix-config"),
  })
end)

-- Lsp
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
    vim.keymap.set("n", "gr", vim.lsp.buf.definition, { buffer = 0 })
    vim.keymap.set("n", "K", vim.lsp.buf.definition, { buffer = 0 })
  end,
})

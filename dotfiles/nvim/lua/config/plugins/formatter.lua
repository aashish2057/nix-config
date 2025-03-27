return {
  "jayp0521/mason-null-ls.nvim",
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "stylua",
        },
        automatic_installation = true,
      })
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      -- local diagnostics = null_ls.builtins.diagnostics
      local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
      null_ls.setup({
        sources = {
          formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
            filetypes = { "lua" },
          }),
          formatting.alejandra.with({
            filetypes = { "nix" },
          }),
        },

        on_attach = function(current_client, bufnr)
          if current_client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  filter = function(client)
                    return client.name == "null-ls"
                  end,
                  bufnr = bufnr,
                })
              end,
            })
          end
        end,
      })
    end,
  },
}

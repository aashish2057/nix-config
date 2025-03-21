return {
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  {
    "seblyn/roslyn.nvim",
    ft = "cs",
    opts = {},
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
        },
        automatic_installation = true,
      })
      require("lspconfig").lua_ls.setup({
        capabilities = capabilities,
        filetypes = { "lua" },
      })

      require("roslyn").setup({
        capabilities = capabilities,
      })
    end,
  },
}

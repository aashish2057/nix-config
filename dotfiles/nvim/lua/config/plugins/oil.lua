return {
  {
    "stevearc/oil.nvim",
    dependencies = { { "echasnovski/mini.icons" } },
    lazy = false,
    config = function()
      require("oil").setup()
    end,
  },
}

return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require("mini.diff").setup()
      require("mini.git").setup()
      require("mini.icons").setup()

      -- overrides devicons so that telescope uses the icons from mini.icons
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end

      require("mini.statusline").setup()
    end,
  },
}

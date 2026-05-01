{
  pkgs,
  lib,
  username,
  mnw,
  isWork,
  system,
  nvim-nightly,
  ...
}: {
  home-manager.sharedModules = [
    {
      imports = [
        mnw.homeManagerModules.mnw
      ];
      programs.mnw = {
        enable = true;

        neovim = nvim-nightly.packages.${system}.default;

        initLua = ''
          vim.g.IS_WORK = ${
            if isWork
            then "true"
            else "false"
          }
          require("config")
        '';
        aliases = ["vim"];

        extraBinPath = [
          pkgs.lua-language-server
          pkgs.stylua
          pkgs.tree-sitter
          pkgs.fd
        ];

        plugins = {
          dev.config = {
            pure = ./nvim;
          };

          start =
            [
              pkgs.vimPlugins.material-nvim
              pkgs.vimPlugins.no-neck-pain-nvim
              pkgs.vimPlugins.nvim-treesitter.withAllGrammars
              pkgs.vimPlugins.mini-icons
              pkgs.vimPlugins.mini-statusline
              pkgs.vimPlugins.oil-nvim
              pkgs.vimPlugins.conform-nvim
              pkgs.vimPlugins.snacks-nvim
              pkgs.vimPlugins.vim-fugitive
              pkgs.vimPlugins.vim-rhubarb
              pkgs.vimPlugins.blink-cmp
              pkgs.vimPlugins.blink-pairs
              pkgs.vimPlugins.nvim-lspconfig
              pkgs.vimPlugins.fff-nvim
              pkgs.vimPlugins.noice-nvim
              pkgs.vimPlugins.gitsigns-nvim
            ]
            ++ lib.optionals isWork [
              pkgs.vimPlugins.roslyn-nvim
            ];
        };
      };
    }
  ];
}

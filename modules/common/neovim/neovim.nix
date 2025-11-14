{
  pkgs,
  lib,
  username,
  mnw,
  isWork,
  ...
}: {
  home-manager.sharedModules = [
    {
      imports = [
        mnw.homeManagerModules.mnw
      ];
      programs.mnw = {
        enable = true;

        neovim = pkgs.neovim-unwrapped;

        initLua = ''
          vim.g.IS_WORK = ${
            if isWork
            then "true"
            else "false"
          }
          require("config")
        '';
        aliases = ["vim"];

        extraBinPath =
          [
            pkgs.lua-language-server
            pkgs.stylua
            pkgs.typescript-language-server
            pkgs.ty
          ]
          ++ lib.optionals isWork [
            pkgs.roslyn-ls
            pkgs.terraform-ls
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
              pkgs.vimPlugins.mini-diff
              pkgs.vimPlugins.oil-nvim
              pkgs.vimPlugins.conform-nvim
              pkgs.vimPlugins.snacks-nvim
              pkgs.vimPlugins.vim-fugitive
              pkgs.vimPlugins.vim-rhubarb
              pkgs.vimPlugins.blink-cmp
            ]
            ++ lib.optionals isWork [
              pkgs.vimPlugins.roslyn-nvim
            ];
        };
      };
    }
  ];
}

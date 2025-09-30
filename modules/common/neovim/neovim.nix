{
  pkgs,
  pkgs-unstable,
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

        neovim = pkgs-unstable.neovim-unwrapped;

        initLua = builtins.readFile ./init.lua;

        aliases = ["vim"];

        extraBinPath =
          [
            pkgs-unstable.lua-language-server
            pkgs-unstable.stylua
            pkgs-unstable.clang-tools
            pkgs-unstable.typescript-language-server
          ]
          ++ lib.optionals isWork [
            pkgs-unstable.roslyn-ls
            pkgs-unstable.terraform-ls
          ];

        plugins = {
          start =
            [
              pkgs-unstable.vimPlugins.material-nvim
              pkgs-unstable.vimPlugins.no-neck-pain-nvim
              pkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars
              pkgs-unstable.vimPlugins.mini-icons
              pkgs-unstable.vimPlugins.mini-statusline
              pkgs-unstable.vimPlugins.mini-diff
              pkgs-unstable.vimPlugins.oil-nvim
              pkgs-unstable.vimPlugins.conform-nvim
              pkgs-unstable.vimPlugins.snacks-nvim
              pkgs-unstable.vimPlugins.vim-fugitive
              pkgs-unstable.vimPlugins.vim-rhubarb
              pkgs-unstable.vimPlugins.blink-cmp
            ]
            ++ lib.optionals isWork [
              pkgs-unstable.vimPlugins.roslyn-nvim
            ];
        };
      };
    }
  ];
}

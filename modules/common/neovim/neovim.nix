{
  pkgs,
  pkgs-unstable,
  lib,
  username,
  mnw,
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

        # initLua = ''
        #   local roslyn_ls_path = "${pkgs-unstable.roslyn-ls}/lib/roslyn-ls/Microsoft.CodeAnalysis.LanguageServer.dll"
        #   ${builtins.readFile ./init.lua}
        # '';

        aliases = ["vim"];

        extraBinPath = [
          pkgs-unstable.lua-language-server
          pkgs-unstable.stylua
          pkgs-unstable.roslyn-ls
        ];

        plugins = {
          start = [
            pkgs-unstable.vimPlugins.material-nvim
            pkgs-unstable.vimPlugins.oil-nvim
            pkgs-unstable.vimPlugins.conform-nvim
            pkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars
            pkgs-unstable.vimPlugins.snacks-nvim
            pkgs-unstable.vimPlugins.no-neck-pain-nvim
            pkgs-unstable.vimPlugins.mini-diff
            pkgs-unstable.vimPlugins.mini-icons
            pkgs-unstable.vimPlugins.mini-statusline
            pkgs-unstable.vimPlugins.vim-fugitive
            pkgs-unstable.vimPlugins.vim-rhubarb
            pkgs-unstable.vimPlugins.roslyn-nvim
          ];

          opt = [
            # Lazy loaded plugins go here
          ];
        };
      };
    }
  ];
}

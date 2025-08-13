{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";
  };
  outputs = {
    nixpkgs,
    mnw,
    self,
    ...
  }: {
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      default = mnw.lib.wrap pkgs {
        neovim = pkgs.neovim-unwrapped;

        # all files in the `lua/lazy` folder are now autoloaded, so no need
        # for an init.lua in there
        initLua = builtins.readFile ./init.lua;

        extraBinPath = [
          pkgs.lua-language-server
          pkgs.stylua
          pkgs.roslyn-ls
        ];

        plugins = {
          start = [
            pkgs.vimPlugins.material-nvim
            pkgs.vimPlugins.oil-nvim
            pkgs.vimPlugins.conform-nvim
            pkgs.vimPlugins.nvim-treesitter.withAllGrammars
            pkgs.vimPlugins.snacks-nvim
            pkgs.vimPlugins.no-neck-pain-nvim
            pkgs.vimPlugins.mini-diff
            pkgs.vimPlugins.mini-icons
            pkgs.vimPlugins.mini-statusline
            pkgs.vimPlugins.vim-fugitive
            pkgs.vimPlugins.vim-rhubarb
            pkgs.vimPlugins.roslyn-nvim
          ];

          # Anything that you're loading lazily should be put here
          opt = [
            # pkgs.vimPlugins.telescope-nvim
          ];

          # dev.myconfig = {
          #   # you can use lib.fileset to reduce rebuilds here
          #   # https://noogle.dev/f/lib/fileset/toSource
          #   pure = ./.;
          #   impure =
          #     # This is a hack it should be a absolute path
          #     # here it'll only work from this directory
          #     "/' .. vim.uv.cwd()  .. '/nvim";
          # };
        };
      };

      dev = self.packages.x86_64-linux.default.devMode;
    };
  };
}

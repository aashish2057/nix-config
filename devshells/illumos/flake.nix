# Host tools for editing illumos-gate on the homeserver.
#
# The gate's .nvim.lua starts clangd through this flake:
#   nix develop ~/Dev/nix-config/devshells/illumos --command clangd
# It lives here, not in the gate, because Nix ignores untracked files in a
# git repo, and the gate can't track it.
{
  description = "illumos-gate editing tools";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShellNoCC {
      # The unwrapped clangd. The clang-tools wrapper adds Linux glibc
      # headers, which clash with the illumos headers.
      packages = [pkgs.llvmPackages.clang-unwrapped];
    };
  };
}

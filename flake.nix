{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devshell.flakeModule ];
      systems = inputs.nixpkgs.lib.platforms.darwin;
      perSystem =
        { pkgs, ... }:
        {
          devshells.default = {
            motd = "";
            packages = with pkgs; [
              # swift
              swiftpm
              sourcekit-lsp
            ];
          };
        };
    };
}

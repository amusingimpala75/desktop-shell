{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.platforms.darwin;
      perSystem =
        {
          lib,
          pkgs,
          self',
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            inputsFrom = [ self'.packages.desktop-shell ];
            packages = with pkgs; [ swiftpm2nix ];
          };

          packages.default = self'.packages.desktop-shell;
          packages.desktop-shell = pkgs.stdenv.mkDerivation {
            pname = "desktop_shell";
            version = "0.1.0";

            src = lib.fileset.toSource {
              root = ./.;
              fileset = lib.fileset.unions [
                ./Package.swift
                ./Sources
              ];
            };

            nativeBuildInputs = with pkgs; [
              swift
              swiftpm
            ];

            configurePhase = ''
              runHook preConfigure
              ${""} # generated.configure }
              runHook postConfigure
            '';

            installPhase = ''
                runHook preInstall

                # This is a special function that invokes swiftpm to find the location
                # of the binaries it produced.
                binPath="$(swiftpmBinPath)"
                # Now perform any installation steps.
                mkdir -p $out/bin
                cp $binPath/desktop_shell $out/bin/

                runHook postInstall
                '';
          };
        };
    };
}

{
  description = "Haskell development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # GHC version - adjust as needed
        ghcVersion = "963";
        haskellPackages = pkgs.haskell.packages."ghc${ghcVersion}";
      in
      {
        devShells.default = haskellPackages.shellFor {
          packages = p: [
            # Add your package here when you have a .cabal file
            # p.my-package
          ];

          buildInputs =
            with haskellPackages;
            [
              # Compiler and build tools
              ghc
              cabal-install
              stack

              # Language server and IDE support
              haskell-language-server

              # Formatters
              ormolu
              cabal-fmt

              # Linters
              hlint

              # Testing
              hspec-discover

              # REPL enhancements
              haskell-dap
              ghci-dap
            ]
            ++ (with pkgs; [
              # General dev tools
              git
              gnumake

              # Nix tools
              nixfmt
            ]);

          shellHook = ''
            echo "Haskell development environment loaded"
            echo "GHC version: $(ghc --version)"
            echo "Cabal version: $(cabal --version | head -1)"

            # Set up stack to use Nix
            export STACK_IN_NIX_SHELL=1
          '';
        };
      }
    );
}

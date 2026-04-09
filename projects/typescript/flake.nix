{
  description = "TypeScript/Node.js development environment";

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
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Node.js and package managers
            nodejs_24
            yarn
            bun
            pnpm

            # TypeScript
            typescript

            # Development tools
            git

            # Nix tools
            nixfmt
          ];

          shellHook = ''
            echo "TypeScript/Node.js development environment loaded"
            echo "Node version: $(node --version)"
            echo "NPM version: $(npm --version)"
            echo "Yarn version: $(yarn --version)"

            # Add node_modules/.bin to PATH if it exists
            if [ -d "node_modules/.bin" ]; then
              export PATH="$PWD/node_modules/.bin:$PATH"
            fi
          '';
        };
      }
    );
}

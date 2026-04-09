{
  description = "ReScript development environment";

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
            # Node.js for npm packages
            nodejs_24
            yarn

            # ReScript compiler (via npm)
            # Note: Install rescript locally in project: npm install rescript

            # Development tools
            git

            # Nix tools
            nixfmt
          ];

          shellHook = ''
            echo "ReScript development environment loaded"
            echo "Node version: $(node --version)"

            # Check if rescript is installed locally
            if [ -f "node_modules/.bin/rescript" ]; then
              echo "ReScript compiler: $(node_modules/.bin/rescript --version)"
              export PATH="$PWD/node_modules/.bin:$PATH"
            else
              echo "Note: Install rescript locally: npm install rescript"
            fi
          '';
        };
      }
    );
}

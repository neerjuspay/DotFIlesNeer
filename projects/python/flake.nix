{
  description = "Python development environment";

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
            # Python
            python3
            python3Packages.pip
            python3Packages.virtualenv

            # Package managers
            poetry
            uv

            # Development tools
            git

            # Linters and formatters
            ruff
            black
            mypy

            # Nix tools
            nixfmt
          ];

          shellHook = ''
            echo "Python development environment loaded"
            echo "Python version: $(python3 --version)"

            # Create virtualenv if it doesn't exist
            if [ ! -d ".venv" ]; then
              echo "Creating virtual environment..."
              python3 -m venv .venv
            fi

            # Activate virtual environment
            source .venv/bin/activate

            # Upgrade pip
            pip install --upgrade pip setuptools wheel 2>/dev/null || true

            echo "Virtual environment activated at: $(which python)"
          '';
        };
      }
    );
}

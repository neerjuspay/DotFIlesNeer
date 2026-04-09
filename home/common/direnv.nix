# Direnv configuration for per-project environments
{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.direnv = {
    enable = true;

    # Enable nix-direnv for better nix-shell integration
    nix-direnv.enable = true;

    # Zsh integration
    enableZshIntegration = true;

    # Bash integration
    enableBashIntegration = true;

    # Global direnv configuration
    config = {
      global = {
        hide_env_diff = false;
      };
    };

    # Stdlib - custom functions available in all .envrc files
    stdlib = ''
      # Layout for Python projects with virtualenv
      layout_python() {
        local python="''${1:-python3}"
        local venv_dir="$PWD/.venv"
        
        if [[ ! -d "$venv_dir" ]]; then
          log_status "Creating Python virtualenv..."
          "$python" -m venv "$venv_dir"
        fi
        
        export VIRTUAL_ENV="$venv_dir"
        PATH_add "$venv_dir/bin"
      }

      # Layout for Poetry projects
      layout_poetry() {
        PYPROJECT_TOML="''${PYPROJECT_TOML:-pyproject.toml}"
        if [[ ! -f "$PYPROJECT_TOML" ]]; then
          log_status "No pyproject.toml found. Executing poetry init..."
          poetry init
        fi
        
        poetry run echo "Virtual env is available" >&2
        
        local VENV=$(dirname $(poetry run which python))
        export VIRTUAL_ENV="$(echo "$VENV" | rev | cut -d'/' -f2- | rev)"
        export POETRY_ACTIVE=1
        PATH_add "$VENV"
      }

      # Layout for Node projects
      layout_node() {
        if [[ -d "node_modules/.bin" ]]; then
          PATH_add node_modules/.bin
        fi
      }

      # Helper to export secrets from sops-nix
      sops_export() {
        local secret_name="$1"
        local key="''${2:-}"
        local secret_file="/run/user/$(id - u)/secrets/$secret_name"
        
        if [[ -f "$secret_file" ]]; then
          export "$secret_name"="$(cat "$secret_file")"
          log_status "Exported $secret_name"
        else
          log_error "Secret file not found: $secret_file"
        fi
      }
    '';
  };

  # Template .envrc files
  home.file.".config/direnv/templates/nix-flake.envrc".text = ''
    use flake
  '';

  home.file.".config/direnv/templates/python.envrc".text = ''
    layout_python
    dotenv_if_exists .env
  '';

  home.file.".config/direnv/templates/node.envrc".text = ''
    layout_node
    dotenv_if_exists .env
  '';
}

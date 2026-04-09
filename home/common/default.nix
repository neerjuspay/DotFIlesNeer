# Common Home Manager configuration - shared across all hosts
{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  ...
}:

{
  imports = [
    ./packages.nix
    ./git.nix
    ./zsh.nix
    ./tmux.nix
    ./vscode.nix
    ./direnv.nix
    ./ai-tools.nix
    # Uncomment after setting up sops-nix with: sops secrets/secrets.yaml
    # ./secrets.nix
  ];

  # Basic Home Manager settings
  home = {
    inherit username;
    inherit homeDirectory;
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # XDG directories
  xdg.enable = true;

  # User services should restart on config change
  systemd.user.startServices = lib.mkIf pkgs.stdenv.isLinux "sd-switch";
}

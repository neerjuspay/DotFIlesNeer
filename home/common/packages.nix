# Package definitions - organized by category
{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages =
    with pkgs;
    lib.flatten [
      # === Core System Utilities ===
      [
        btop # System monitor
        tmux # Terminal multiplexer
        direnv # Directory environment
        nixfmt # Nix formatter
        htop
        ngrok

      ]

      # === Development Tools ===
      [
        # Editors
        vscode

        # Version Control
        git
        lazygit # TUI for git
        delta # Syntax-highlighting pager for git

        # API Development
        postman

        # Languages & Runtimes
        nodejs_24
        yarn
        bun
        python3
        python3Packages.pip
        python3Packages.virtualenv

        # Containers
        podman

        # Build tools
        gnumake
        cmake
        gcc
      ]

      # === Cloud & DevOps ===
      [
        awscli2
        google-cloud-sdk
        cloudflared
        omnix # Nix helper
      ]

      # === Browsers ===
      [
        google-chrome
        brave
      ]

      # === Communication ===
      [
        slack
      ]

      # === Networking ===
      [
        curl
        wget
        jq # JSON processor
        yq # YAML processor
      ]

      # === Linux-specific (conditional) ===
      (lib.optionals pkgs.stdenv.isLinux [
        warp-terminal # GPU-accelerated terminal (Linux only)
      ])

      # === macOS-specific (conditional) ===
      (lib.optionals pkgs.stdenv.isDarwin [
        # macOS-specific packages can go here
        # e.g., rectangle (window manager), alt-tab, etc.
      ])
    ];
}

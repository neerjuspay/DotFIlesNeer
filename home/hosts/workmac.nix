# WorkMac specific configuration - macOS (aarch64-darwin or x86_64-darwin)
{
  config,
  pkgs,
  lib,
  ...
}:

{
  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS-specific tools can go here
    # mas  # Mac App Store CLI (optional)
  ];

  # Override common settings for work environment
  programs.git.userEmail = lib.mkForce "neer.naredi@juspay.in";

  # macOS-specific session variables
  home.sessionVariables = {
    # Work machine identifier
    MACHINE_TYPE = "workmac";

    # macOS-specific settings
    # BROWSER = "open -a 'Google Chrome'";

    # Clipboard integration for tmux
    TMUX_CLIPBOARD = "pbcopy";
  };

  # macOS-specific configurations
  targets.darwin = {
    # Enable macOS-specific defaults
    defaults = {
      # Disable press-and-hold for keys (allows key repeat)
      NSGlobalDomain.ApplePressAndHoldEnabled = false;

      # Fast key repeat
      NSGlobalDomain.KeyRepeat = 2;
      NSGlobalDomain.InitialKeyRepeat = 15;

      # Dark mode
      AppleInterfaceStyle = "Dark";

      # Show hidden files in Finder
      AppleShowAllExtensions = true;
    };

    # Search settings
    search = "Google";
  };

  # macOS keychain integration for git
  programs.git.extraConfig.credential.helper = "osxkeychain";

  # Pinentry for GPG on macOS
  # Note: On macOS, you'll need to install GPG Suite or use pinentry-mac
  # programs.gpg.enable = true;
  # services.gpg-agent = {
  #   enable = true;
  #   pinentryPackage = pkgs.pinentry_mac;
  # };

  # Zsh specific for macOS
  programs.zsh.initExtra = lib.mkAfter ''
    # macOS-specific aliases
    alias brew-up='brew update && brew upgrade && brew cleanup'
    alias flush-dns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

    # Open files/URLs
    alias open-pwd='open .'

    # iCloud Drive shortcut
    alias icloud='cd ~/Library/Mobile\\ Documents/com~apple~CloudDocs'
  '';

  # Launch agents (macOS equivalent of systemd user services)
  launchd.agents = {
    # Example agent
    # my-agent = {
    #   enable = true;
    #   config = {
    #     ProgramArguments = [ "${pkgs.my-package}/bin/my-daemon" ];
    #     RunAtLoad = true;
    #     KeepAlive = true;
    #   };
    # };
  };

  # Homebrew integration (optional - requires nix-darwin)
  # If using nix-darwin, you can manage Homebrew packages too
  # homebrew = {
  #   enable = true;
  #   brews = [ "coreutils" "gnu-sed" ];
  #   casks = [ "docker" "slack" ];
  #   masApps = {
  #     "Xcode" = 497799835;
  #   };
  # };
}

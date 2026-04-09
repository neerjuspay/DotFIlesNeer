# WorkPC specific configuration - NixOS x86_64-linux
{
  config,
  pkgs,
  lib,
  ...
}:

{
  # NixOS-specific packages
  home.packages = with pkgs; [
    # Linux-only packages
    warp-terminal # GPU terminal (not available on macOS)
  ];

  # Override common settings for work environment
  programs.git.settings.user.email = lib.mkForce "neer.naredi@juspay.in";

  # Work-specific environment variables
  home.sessionVariables = {
    # Work machine identifier
    MACHINE_TYPE = "workpc";

    # Linux-specific paths
    XDG_DOWNLOAD_DIR = "$HOME/Downloads";
    XDG_DOCUMENTS_DIR = "$HOME/Documents";
  };

  # Linux-specific program configurations
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    defaultCacheTtl = 3600;
    enableSshSupport = false;
  };

  # Systemd user services (NixOS only)
  systemd.user.services = {
    # Example: Auto-start a service
    # my-service = {
    #   Unit = {
    #     Description = "My background service";
    #   };
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.my-package}/bin/my-daemon";
    #   };
    #   Install = {
    #     WantedBy = [ "default.target" ];
    #   };
    # };
  };

  # Network proxy settings if behind corporate firewall
  # home.sessionVariables = {
  #   HTTP_PROXY = "http://proxy.company.com:8080";
  #   HTTPS_PROXY = "http://proxy.company.com:8080";
  #   NO_PROXY = "localhost,127.0.0.1,.company.com";
  # };
}

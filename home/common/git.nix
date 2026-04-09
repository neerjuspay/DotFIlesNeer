# Git configuration with GPG signing and multi-account SSH
{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.git = {
    enable = true;

    # User identity - adjust as needed
    settings.user = {
      name = "neernaredi";
      email = lib.mkDefault "neer.naredi@juspay.in"; # Adjust per work/personal
    };

    # Core settings
    settings = {
      core = {
        editor = "code --wait";
        autocrlf = "input";
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        pager = "delta";
      };

      # Delta configuration
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          side-by-side = false;
          syntax-theme = "Dracula";
        };
      };

      # Credential helper
      credential = lib.optionalAttrs pkgs.stdenv.isDarwin {
        helper = "osxkeychain";
      };

      # Push/pull defaults
      push = {
        default = "simple";
        autoSetupRemote = true;
      };

      pull = {
        rebase = true;
      };

      # GPG signing (optional - uncomment if you want signed commits)
      # commit.gpgSign = true;
      # tag.gpgSign = true;
      # user.signingKey = "YOUR_GPG_KEY_ID";

      # Branch management
      branch = {
        autosetupmerge = true;
      };

      # Rebase settings
      rebase = {
        autoSquash = true;
        autoStash = true;
      };

      # Color settings
      color = {
        ui = true;
      };

      # Aliases
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        cp = "cherry-pick";
        d = "diff";
        dc = "diff --cached";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        lga = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        amend = "commit --amend --no-edit";
        save = "stash push -m";
        pop = "stash pop";
      };
    };

    # Ignores
    ignores = [
      # IDE
      ".idea/"
      ".vscode/"
      "*.swp"
      "*.swo"
      "*~"

      # OS
      ".DS_Store"
      "Thumbs.db"

      # Build artifacts
      "dist/"
      "build/"
      "*.exe"
      "*.dll"

      # Dependencies
      "node_modules/"
      ".venv/"
      "vendor/"

      # Logs
      "*.log"
      "logs/"

      # Environment
      ".env"
      ".env.local"
      ".env.*.local"
    ];
  };

  # SSH configuration for multi-account support
  programs.ssh = {
    enable = true;

    # Extra config for SSH agent and key management
    extraConfig = ''
      # Add keys to agent automatically
      AddKeysToAgent yes

      # Use keychain on macOS
      ${lib.optionalString pkgs.stdenv.isDarwin "UseKeychain yes"}

      # Always use SSH protocol for GitHub
      Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes

      # Work-specific GitHub account (if needed)
      # Host github-work
      #   HostName github.com
      #   User git
      #   IdentityFile ~/.ssh/id_ed25519_work
      #   IdentitiesOnly yes
    '';
  };

}

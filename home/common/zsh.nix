# Zsh configuration with Oh-My-Zsh and custom integrations
{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.zsh = {
    enable = true;

    # History configuration
    history = {
      size = 100000;
      save = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      share = true;
      extended = true;
    };

    # Oh-My-Zsh configuration
    oh-my-zsh = {
      enable = true;
      theme = "candy";
      plugins = [
        "git"
        "colorize"
        "podman"
        "rust"
        "history"
        "colored-man-pages"
        "command-not-found"
      ];
      custom = "${config.xdg.configHome}/oh-my-zsh-custom";
    };

    # Additional shell init - runs after oh-my-zsh
    initExtra = ''
      # Source ardra envs if exists (keeping your existing setup)
      [ -f /home/neernaredi/ardraEnvs ] && source /home/neernaredi/ardraEnvs

      # Direnv hook (should already be handled by programs.direnv, but belt-and-suspenders)
      eval "$(direnv hook zsh)" 2>/dev/null || true

      # FZF integration for fuzzy finding
      if command -v fzf &> /dev/null; then
        source <(fzf --zsh)
      fi

      # Better completion
      autoload -Uz compinit && compinit
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

      # Aliases
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias ll='ls -la'
      alias la='ls -A'
      alias l='ls -CF'

      # Nix shortcuts
      alias nix-switch='home-manager switch --flake .'
      alias nix-update='nix flake update'
      alias nix-clean='nix-collect-garbage -d'

      # Editor aliases
      alias v='code'
      alias vi='code'
      alias vim='code'

      # AI tool aliases
      alias oc='opencode'
      alias occ='opencode --continue'
      alias ccc='claude-code'

      # Git shortcuts
      alias gs='git status'
      alias ga='git add'
      alias gc='git commit'
      alias gp='git push'
      alias gl='git pull'
      alias gd='git diff'
      alias gco='git checkout'
      alias gb='git branch'
      alias gr='git remote'

      # Tmux shortcuts
      alias t='tmux'
      alias ta='tmux attach'
      alias tn='tmux new-session'
      alias tls='tmux list-sessions'

      # Quick navigation
      alias proj='cd ~/projects'
      alias dot='cd ~/DotFIlesNeer'

      # Useful functions
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      # Extract any archive
      extract() {
        if [ -f $1 ]; then
          case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      # Enable colors
      export CLICOLOR=1
      export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
    '';

    # Environment variables
    sessionVariables = {
      EDITOR = "code --wait";
      VISUAL = "code";
      PAGER = "less -R";
      LESS = "-R";

      # FZF defaults
      FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border --inline-info";
      FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob '!.git/*'";

      # Bat as man pager (if installed)
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";

      # Add pipx to PATH
      PATH = "$HOME/.local/bin:$PATH";
    };

    # Local additions (per-host customizations can go here)
    profileExtra = "";
  };

  # FZF for fuzzy finding
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];
    defaultCommand = "rg --files --hidden --follow --glob '!.git/*'";
  };

  # Modern replacements for standard tools
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      pager = "less -FR";
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = true;
    git = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ]; # Replace cd with zoxide
  };
}

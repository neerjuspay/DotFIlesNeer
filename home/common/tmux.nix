# Tmux configuration with advanced session management
{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.tmux = {
    enable = true;

    # Use 256 color support
    terminal = "screen-256color";

    # Prefix key (keeping default Ctrl+b, but feel free to change to Ctrl+a)
    prefix = "C-b";

    # Mouse support
    mouse = true;

    # History limit
    historyLimit = 100000;

    # Escape time for Vim users
    escapeTime = 10;

    # Start index at 1 (easier to reach)
    baseIndex = 1;

    # Key bindings
    keyMode = "vi";

    # Custom shortcuts
    extraConfig = ''
      # =============================================
      # General Settings
      # =============================================

      # Faster command sequences
      set -s escape-time 0

      # Increase repeat timeout
      set -g repeat-time 600

      # Focus events enabled for terminals that support them
      set -g focus-events on

      # Super useful when using "grouped sessions" and multi-monitor setup
      setw -g aggressive-resize on

      # =============================================
      # Key Bindings
      # =============================================

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # Split panes using | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # New window with current path
      bind c new-window -c "#{pane_current_path}"

      # Switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Resize panes with prefix + arrow keys
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Vim-style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Swap windows
      bind -r < swap-window -t -1
      bind -r > swap-window -t +1

      # Copy mode shortcuts
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

      # Sync panes (broadcast input to all panes)
      bind S set-window-option synchronize-panes

      # Kill window/pane without confirmation
      bind-key x kill-pane
      bind-key X kill-window

      # =============================================
      # Status Bar
      # =============================================

      # Enable status bar
      set -g status on

      # Update interval
      set -g status-interval 5

      # Position (top or bottom)
      set -g status-position bottom

      # Update interval
      set -g status-interval 5

      # =============================================
      # Window/Pane Settings
      # =============================================

      # Set window notifications
      setw -g monitor-activity on
      set -g visual-activity off

      # Automatic rename
      setw -g automatic-rename on

      # Renumber windows when one is closed
      set -g renumber-windows on

      # =============================================
      # Tmux Plugin Manager (TPM) - Manual Install Required
      # =============================================
      # To use plugins, first install TPM:
      # git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
      # 
      # Then press prefix + I to install plugins

      # List of plugins
      # set -g @plugin 'tmux-plugins/tpm'
      # set -g @plugin 'tmux-plugins/tmux-sensible'
      # set -g @plugin 'tmux-plugins/tmux-resurrect'      # Save/restore sessions
      # set -g @plugin 'tmux-plugins/tmux-continuum'      # Auto-save sessions
      # set -g @plugin 'tmux-plugins/tmux-battery'        # Battery status
      # set -g @plugin 'tmux-plugins/tmux-online-status'  # Online indicator
      # set -g @plugin 'tmux-plugins/tmux-prefix-highlight'

      # Plugin settings
      # set -g @resurrect-capture-pane-contents 'on'
      # set -g @resurrect-strategy-nvim 'session'
      # set -g @continuum-restore 'on'
      # set -g @continuum-save-interval '15'

      # Initialize TMUX plugin manager
      # run '~/.config/tmux/plugins/tpm/tpm'

      # =============================================
      # Platform Specific
      # =============================================

      # macOS clipboard integration
      if-shell 'uname | grep -q Darwin' 'bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"'
      if-shell 'uname | grep -q Darwin' 'bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"'

      # Linux clipboard integration
      if-shell 'uname | grep -q Linux' 'bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"'
      if-shell 'uname | grep -q Linux' 'bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"'

      # =============================================
      # Useful Aliases (for shell)
      # Use these in your shell:
      # alias t='tmux'
      # alias ta='tmux attach'
      # alias tn='tmux new-session'
      # alias tls='tmux list-sessions'
      # =============================================
    '';

    # Plugins to install declaratively
    plugins = with pkgs.tmuxPlugins; [
      # Uncomment to enable:
      # sensible        # Sensible defaults
      # resurrect       # Session save/restore
      # continuum       # Auto-save
      # battery         # Battery indicator
      # prefix-highlight # Show prefix pressed
    ];
  };

  # Tmuxinator-like session definitions can be added via:
  # home.file".config/tmux/sessions/work.tmux".text = ''''
}

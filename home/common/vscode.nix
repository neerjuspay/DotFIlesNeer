# VS Code configuration with extensions and settings
{
  config,
  pkgs,
  lib,
  ...
}:

let
  vscode-extensions = with pkgs.vscode-extensions; [
    # === Language Support ===
    haskell.haskell
    justusadam.language-haskell
    ms-python.python
    ms-python.vscode-pylance

    # === Nix ===
    bbenoist.nix
    jnoortheen.nix-ide
    mkhl.direnv

    # === Themes & Appearance ===
    dracula-theme.theme-dracula
    pkief.material-icon-theme

    # === Editor Enhancements ===
    vscodevim.vim
    eamodio.gitlens
    usernamehw.errorlens

    # === AI Coding Assistants ===
    github.copilot
    github.copilot-chat

    # === Database ===
    cweijan.vscode-database-client2

    # === Productivity ===
    esbenp.prettier-vscode
    davidanson.vscode-markdownlint
    yzhang.markdown-all-in-one

    # === Remote Development ===
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-containers
  ];

in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = vscode-extensions;

      userSettings = {
        "editor.fontSize" = 14;
        "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', Consolas, monospace";
        "editor.fontLigatures" = true;
        "editor.lineHeight" = 1.5;
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.detectIndentation" = true;
        "editor.rulers" = [
          80
          120
        ];
        "editor.wordWrap" = "bounded";
        "editor.wordWrapColumn" = 120;
        "editor.minimap.enabled" = true;
        "editor.scrollBeyondLastLine" = false;
        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = true;
        "editor.codeActionsOnSave" = {
          "source.organizeImports" = "explicit";
        };

        "workbench.colorTheme" = "Dracula";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.tree.indent" = 20;
        "workbench.editor.enablePreview" = false;
        "workbench.editor.tabSizing" = "shrink";
        "workbench.startupEditor" = "welcomePage";

        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "files.exclude" = {
          "**/.git" = true;
          "**/.DS_Store" = true;
          "**/node_modules" = true;
          "**/.venv" = true;
          "**/dist" = true;
          "**/build" = true;
          "**/__pycache__" = true;
        };

        "terminal.integrated.fontFamily" = "'JetBrains Mono', monospace";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.shellIntegration.enabled" = true;

        "git.enableSmartCommit" = true;
        "git.confirmSync" = false;
        "git.openRepositoryInParentFolders" = "always";
        "gitlens.currentLine.enabled" = false;

        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;

        "search.exclude" = {
          "**/node_modules" = true;
          "**/.git" = true;
          "**/.venv" = true;
          "**/dist" = true;
        };

        "prettier.singleQuote" = true;
        "prettier.trailingComma" = "es5";
        "prettier.printWidth" = 100;
        "prettier.tabWidth" = 2;

        "typescript.updateImportsOnFileMove.enabled" = "always";
        "javascript.updateImportsOnFileMove.enabled" = "always";

        "python.analysis.typeCheckingMode" = "basic";
        "python.formatting.provider" = "black";
        "python.linting.enabled" = true;

        "haskell.serverExecutablePath" = "haskell-language-server-wrapper";
        "haskell.formattingProvider" = "ormolu";

        "markdown.extension.toc.levels" = "2..6";

        # Copilot settings
        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = true;
          "markdown" = true;
          "scminput" = false;
        };

        # Nix IDE settings
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.formatterPath" = "nixfmt";

        # direnv integration
        "direnv.restart.automatic" = true;
      };

      keybindings = [
        {
          key = "ctrl+k ctrl+s";
          command = "workbench.action.files.saveAll";
        }
        {
          key = "ctrl+shift+e";
          command = "workbench.view.explorer";
        }
        {
          key = "ctrl+shift+g";
          command = "workbench.view.scm";
        }
        {
          key = "ctrl+shift+x";
          command = "workbench.view.extensions";
        }
        {
          key = "ctrl+shift+t";
          command = "workbench.action.terminal.toggleTerminal";
        }
        {
          key = "f12";
          command = "editor.action.goToDeclaration";
        }
      ];
    };
  };

  home.packages = with pkgs; [ jetbrains-mono ];
}

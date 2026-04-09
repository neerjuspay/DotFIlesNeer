# AI development tools configuration - OpenCode and Claude Code
{
  config,
  pkgs,
  lib,
  ...
}:

{
  # AI tools packages
  home.packages = with pkgs; [
    claude-code
    opencode
    google-cloud-sdk
  ];

  # OpenCode configuration files
  xdg.configFile."opencode/opencode.json".source = ./opencode.json;
  xdg.configFile."opencode/oh-my-openagent.json".source = ./opencode-agents.json;

  # Claude Code configuration (moved from old claude-envs.nix)
  # Environment variables for Vertex AI
  home.sessionVariables = {
    # Vertex AI settings (used by both Claude Code and can be used by OpenCode)
    CLAUDE_CODE_USE_VERTEX = "1";
    CLOUD_ML_REGION = "us-east5";
    ANTHROPIC_VERTEX_PROJECT_ID = "dev-ai-delta";

    # Disable prompt caching if needed
    DISABLE_PROMPT_CACHING = "0";

    # Model region overrides
    VERTEX_REGION_CLAUDE_3_5_HAIKU = "us-central1";
    VERTEX_REGION_CLAUDE_3_5_SONNET = "us-east5";
    VERTEX_REGION_CLAUDE_3_7_SONNET = "us-east5";
    VERTEX_REGION_CLAUDE_4_0_OPUS = "europe-west4";
    VERTEX_REGION_CLAUDE_4_0_SONNET = "us-east5";

    # Default model selection
    ANTHROPIC_MODEL = "claude-sonnet-4-5";
    ANTHROPIC_SMALL_FAST_MODEL = "claude-sonnet-4-5";

    # OpenCode environment
    OPENCODE_CONFIG_DIR = "${config.xdg.configHome}/opencode";
  };

  # Shell aliases for AI tools
  programs.zsh.initExtra = lib.mkAfter ''
        # Claude Code shortcuts
        alias cc='claude-code'
        alias ccc='claude-code --continue'
        
        # OpenCode shortcuts
        alias oc='opencode'
        alias occ='opencode --continue'
        alias ocs='opencode --select-model'
        
        # Quick project initialization with AI context
        ai-init() {
          local project_type="''${1:-generic}"
          echo "Initializing AI-assisted $project_type project..."
          
          # Create .ai-context file for project-specific instructions
          cat > .ai-context << EOF
    # Project Context
    Type: $project_type
    Created: $(date)

    ## Guidelines
    - Follow existing code patterns
    - Ask before making major architectural changes
    - Test changes before suggesting completion

    ## Tech Stack
    $(detect-stack)
    EOF
          echo "Created .ai-context file"
        }
        
        # Helper to detect project stack
        detect-stack() {
          if [[ -f "package.json" ]]; then
            echo "- Node.js/TypeScript"
            cat package.json | grep -E '"(dependencies|devDependencies)"' -A 5 | head -20
          fi
          if [[ -f "Cargo.toml" ]]; then
            echo "- Rust"
          fi
          if [[ -f "*.cabal" ]] || [[ -f "stack.yaml" ]]; then
            echo "- Haskell"
          fi
          if [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]]; then
            echo "- Python"
          fi
        }
  '';

  # Note: For gcloud auth, run:
  # gcloud auth login
  # gcloud auth application-default login
  # gcloud config set project dev-ai-delta
  # gcloud services enable aiplatform.googleapis.com
}

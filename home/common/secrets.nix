# Secrets management with sops-nix
{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Sops-nix configuration
  sops = {
    # Default location of the encrypted secrets file
    defaultSopsFile = ../../secrets/secrets.yaml;

    # Age key for decryption
    # Will look for age key at standard location
    age = {
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      # Generate from SSH key: ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
      generateKey = false;
    };

    # Secrets definition
    # These will be decrypted and made available as files in /run/user/<uid>/secrets/
    secrets = {
      # Juspay API key for OpenCode
      juspay_api_key = {
        # Exported as JUSPAY_API_KEY environment variable
      };

      # AWS credentials (if needed)
      aws_access_key_id = { };
      aws_secret_access_key = { };

      # GitHub token
      github_token = { };

      # Generic API keys
      openai_api_key = { };

      # Cloudflare token (if needed)
      cloudflare_api_token = { };
    };
  };

  # Export secrets as environment variables
  home.sessionVariables = {
    # These will be set from sops secrets
    # Note: The actual values are populated at activation time
  };

  # Alternative: Use shell integration to load secrets
  # programs.zsh.initExtra = lib.mkAfter ''
  #   # Load secrets from sops
  #   export JUSPAY_API_KEY=$(cat /run/user/$(id - u)/secrets/juspay_api_key 2>/dev/null || echo "")
  # '';
}

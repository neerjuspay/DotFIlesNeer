{
  pkgs,
  lib,
  ...
}:
{

  # auth needs to be completed with google cloud sdk
  # gcloud auth login
  # gcloud auth application-default login
  # gcloud config set project dev-ai-delta
  # gcloud services enable aiplatform.googleapis.com

  home.packages = with pkgs; [
    claude-code
    google-cloud-sdk
  ];

  home.sessionVariables = {
    CLAUDE_CODE_USE_VERTEX = 1;
    CLOUD_ML_REGION = "us-east5";
    ANTHROPIC_VERTEX_PROJECT_ID = "dev-ai-delta";

    # Optional: Disable prompt caching if needed
    DISABLE_PROMPT_CACHING = 0;

    # Optional: Override regions for specific models
    VERTEX_REGION_CLAUDE_3_5_HAIKU = "us-central1";
    VERTEX_REGION_CLAUDE_3_5_SONNET = "us-east5";
    VERTEX_REGION_CLAUDE_3_7_SONNET = "us-east5";
    VERTEX_REGION_CLAUDE_4_0_OPUS = "europe-west4";
    VERTEX_REGION_CLAUDE_4_0_SONNET = "us-east5";

    ANTHROPIC_MODEL = "claude-sonnet-4-5";
    ANTHROPIC_SMALL_FAST_MODEL = "claude-sonnet-4-5";

  };
}
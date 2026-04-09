# Project-Specific Configuration Guide

## Approach 1: Simple .envrc (Recommended for most projects)

Create a `.envrc` file in each project root:

```bash
# ~/projects/my-api/.envrc
# Load the project-specific environment

# Add local scripts to PATH
PATH_add ./scripts
PATH_add ./node_modules/.bin

# Project aliases
alias test='npm test'
alias build='npm run build'
alias dev='npm run dev'
alias deploy='./scripts/deploy.sh'

# Project environment variables
export API_URL="http://localhost:3000"
export DATABASE_URL="postgresql://localhost/myapp_dev"

# Load secrets from .env file if it exists
dotenv_if_exists .env

# Or load from sops-nix (when you set it up)
# sops_export myproject_api_key API_KEY
```

Then run:
```bash
cd ~/projects/my-api
direnv allow  # One-time approval
```

Now every time you `cd` into the project, your aliases and env vars are ready!

## Approach 2: Project-Specific Zsh File (For complex setups)

Create a `.project.zsh` file in your project:

```bash
# ~/projects/my-haskell-app/.project.zsh
# Project-specific zsh configuration

# Aliases
alias hs-build='cabal build'
alias hs-test='cabal test'
alias hs-run='cabal run'
alias hs-repl='cabal repl'

# Functions
hs-watch() {
  find src -name '*.hs' | entr -c cabal build
}

hs-lint() {
  hlint src/
  ormolu --mode check $(find src -name '*.hs')
}

# Environment
export GHC_OPTIONS="-Wall -Werror"
export CABAL_BUILDDIR="dist-newstyle"

# Project-specific PATH
export PATH="$PWD/.cabal/bin:$PATH"

# Welcome message
echo "🚀 Haskell Project: $(basename $PWD)"
echo "💡 Available commands: hs-build, hs-test, hs-run, hs-watch, hs-lint"
```

Load it in your `.envrc`:
```bash
# ~/projects/my-haskell-app/.envrc
source_up  # Load parent .envrc if exists
source .project.zsh
use flake  # Or use nix
```

## Approach 3: Centralized Project Profiles (Store in dotfiles repo)

Add to your dotfiles:

```bash
# ~/DotFIlesNeer/home/common/zsh.nix - add to initExtra
programs.zsh.initExtra = lib.mkAfter ''
  # Function to load project-specific config
  load-project-config() {
    local project_name=$(basename "$PWD")
    local config_file="${config.home.homeDirectory}/.config/zsh/projects/${project_name}.zsh"
    
    if [[ -f "$config_file" ]]; then
      source "$config_file"
      echo "Loaded project config: $project_name"
    fi
  }
  
  # Auto-load on directory change
  chpwd_functions+=(load-project-config)
'';
```

Then create project configs:
```bash
mkdir -p ~/.config/zsh/projects

# ~/.config/zsh/projects/work-api.zsh
alias api-test='pytest tests/'
alias api-logs='tail -f logs/app.log'
alias api-db='psql $DATABASE_URL'

# ~/.config/zsh/projects/personal-site.zsh
alias site-build='hugo --minify'
alias site-serve='hugo server -D'
alias site-deploy='rsync -avz public/ server:/var/www/html/'
```

## Approach 4: SQL/Query Files Directory

Create a queries directory structure:

```bash
mkdir -p ~/projects/my-api/queries

# ~/projects/my-api/queries/users.sql
-- Get active users
SELECT id, email, created_at
FROM users
WHERE status = 'active'
ORDER BY created_at DESC
LIMIT 100;

# ~/projects/my-api/queries/dashboard.sql
-- Dashboard metrics
WITH stats AS (
  SELECT 
    COUNT(*) as total_users,
    COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '24 hours') as new_today
  FROM users
)
SELECT * FROM stats;
```

Add a helper function to your zsh config:

```bash
# In home/common/zsh.nix - add to initExtra
sql-run() {
  local query_file="$1"
  local db_url="''${2:-$DATABASE_URL}"
  
  if [[ -f "$query_file" ]]; then
    psql "$db_url" -f "$query_file"
  else
    echo "Query file not found: $query_file"
    return 1
  fi
}

sql-list() {
  if [[ -d "queries" ]]; then
    ls -la queries/
  else
    echo "No queries/ directory found"
  fi
}
```

Usage:
```bash
cd ~/projects/my-api
sql-list
sql-run queries/users.sql
sql-run queries/dashboard.sql
```

## Approach 5: Using the Projects Template System

Your dotfiles already have project templates. Extend them:

```bash
# Edit: ~/DotFIlesNeer/projects/haskell/flake.nix
# Add custom scripts:

let
  project-scripts = pkgs.writeShellScriptBin "project-init" ''
    echo "Initializing Haskell project..."
    cabal init --interactive
    mkdir -p scripts queries
    echo '#!/bin/bash' > scripts/build.sh
    echo 'cabal build' >> scripts/build.sh
    chmod +x scripts/build.sh
  '';
in
{
  devShells.default = pkgs.mkShell {
    buildInputs = [ 
      # ... existing packages ...
      project-scripts 
    ];
    
    shellHook = ''
      # ... existing hook ...
      
      # Project-specific aliases
      alias watch='find src -name "*.hs" | entr -c cabal build'
      alias format='ormolu --mode inplace $(find src -name "*.hs")'
      alias lint='hlint src/'
      
      # Create .envrc template if missing
      if [[ ! -f .envrc ]]; then
        cat > .envrc << 'EOF'
    use flake
    export PROJECT_ROOT=$(pwd)
    alias build='cabal build'
    alias test='cabal test'
    alias run='cabal run'
    EOF
        echo "Created .envrc template. Run: direnv allow"
      fi
    '';
  };
}
```

## Best Practices

### 1. Version Control Strategy

**Commit to dotfiles repo:**
- Reusable project templates
- Common project aliases/functions
- SQL query patterns

**Keep in project repo:**
- Project-specific `.envrc`
- Project-specific `.project.zsh`
- Project-specific SQL queries
- Sensitive environment variables (use `.env` not committed)

### 2. Sensitive Data Handling

Don't commit secrets! Use:

```bash
# .envrc (committed)
export API_URL="https://api.example.com"
dotenv_if_exists .env.local

# .env.local (NOT committed, in .gitignore)
API_KEY=sk-secret123
DATABASE_PASSWORD=hunter2
```

Or use sops-nix when ready:
```bash
# .envrc
sops_export myproject_secrets
```

### 3. Sharing Across Machines

Since `.envrc` is per-project and usually committed:
```bash
# Use conditional logic for machine-specific things
if [[ "$MACHINE_TYPE" == "workpc" ]]; then
  export API_URL="http://workpc-local:3000"
elif [[ "$MACHINE_TYPE" == "workmac" ]]; then
  export API_URL="http://workmac-local:3000"
fi
```

### 4. Quick Commands Reference

Add to your global zsh config:

```bash
# Project navigation
alias pj='cd ~/projects'
alias pj-list='ls ~/projects'

# Quick project switch with fzf
pj-switch() {
  local dir=$(find ~/projects -maxdepth 1 -type d | fzf)
  [[ -n "$dir" ]] && cd "$dir"
}

# Initialize new project from template
pj-init() {
  local name="$1"
  local template="''${2:-default}"
  
  mkdir -p ~/projects/"$name"
  cd ~/projects/"$name"
  nix flake init -t ~/DotFIlesNeer#"$template"
  git init
  echo "Created project: $name"
}
```

## Example: Complete Project Setup

Let's set up a real project:

```bash
# 1. Create project directory
mkdir -p ~/projects/work-dashboard
cd ~/projects/work-dashboard

# 2. Create .envrc
cat > .envrc << 'EOF'
# Load nix flake
use flake

# Project configuration
export PROJECT_NAME="work-dashboard"
export API_URL="http://localhost:8080"
export DATABASE_URL="postgresql://localhost/dashboard"

# Aliases
alias dev='npm run dev'
alias build='npm run build'
alias test='npm run test'
alias lint='npm run lint'

# Database helpers
alias db-connect='psql $DATABASE_URL'
alias db-migrate='npm run db:migrate'
alias db-seed='npm run db:seed'

# Load local overrides
dotenv_if_exists .env.local
EOF

# 3. Create queries directory
mkdir -p queries
cat > queries/active-users.sql << 'EOF'
SELECT 
  u.id,
  u.email,
  u.last_login,
  COUNT(s.id) as session_count
FROM users u
LEFT JOIN sessions s ON u.id = s.user_id
WHERE u.active = true
GROUP BY u.id, u.email, u.last_login
ORDER BY u.last_login DESC;
EOF

# 4. Create scripts directory
mkdir -p scripts
cat > scripts/setup.sh << 'EOF'
#!/bin/bash
set -e

echo "Setting up work-dashboard..."
npm install
npm run db:migrate
npm run db:seed
echo "Done! Run: npm run dev"
EOF
chmod +x scripts/setup.sh

# 5. Allow direnv
direnv allow

# 6. Test
which dev    # Should show alias
dev          # Runs npm run dev
db-connect   # Opens psql
```

## Troubleshooting

### Direnv not loading?
```bash
direnv status        # Check status
direnv allow         # Re-approve
direnv reload        # Force reload
```

### Zsh functions not available?
Make sure `.envrc` is sourced or functions are in global zsh config.

### Want to temporarily disable?
```bash
direnv deny    # Disable for this dir
eval "$(direnv export bash)"  # One-time load
```

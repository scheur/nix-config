#!/bin/bash
# Migrate existing configuration to Nix management

set -euo pipefail

echo "🔄 VectorOpsAI Configuration Migration"
echo "===================================="

# Backup existing configurations
echo "📦 Backing up existing configurations..."
mkdir -p ~/.config-backup-$(date +%Y%m%d)

# Backup shell configs
[[ -f ~/.zshrc ]] && cp ~/.zshrc ~/.config-backup-$(date +%Y%m%d)/
[[ -f ~/.zshenv ]] && cp ~/.zshenv ~/.config-backup-$(date +%Y%m%d)/
[[ -d ~/.config/nushell ]] && cp -r ~/.config/nushell ~/.config-backup-$(date +%Y%m%d)/
[[ -d ~/.config/starship.toml ]] && cp ~/.config/starship.toml ~/.config-backup-$(date +%Y%m%d)/
[[ -d ~/.config/ghostty ]] && cp -r ~/.config/ghostty ~/.config-backup-$(date +%Y%m%d)/

echo "✅ Configurations backed up to ~/.config-backup-$(date +%Y%m%d)/"

# Update Git configuration
if [[ -f ~/.gitconfig ]]; then
    echo "📝 Extracting Git configuration..."
    git_name=$(git config --global user.name || echo "")
    git_email=$(git config --global user.email || echo "")
    
    if [[ -n "$git_email" ]]; then
        echo "Found Git email: $git_email"
        echo "Updating home.nix with your Git configuration..."
        sed -i '' "s/your-email@example.com/$git_email/g" ~/dev/Github/nix-config/modules/home.nix
    fi
fi

# Detect installed tools and suggest additions
echo ""
echo "🔍 Detecting installed tools..."

# Check for additional Homebrew casks
if command -v brew &> /dev/null; then
    echo "📦 Installed Homebrew casks not in configuration:"
    brew list --cask | while read cask; do
        if ! grep -q "\"$cask\"" ~/dev/Github/nix-config/modules/darwin.nix; then
            echo "  - $cask"
        fi
    done
fi

# Check for cargo-installed tools
if command -v cargo &> /dev/null; then
    echo ""
    echo "🦀 Cargo-installed tools to consider adding:"
    ls ~/.cargo/bin/ 2>/dev/null | grep -v "^cargo" | head -10 || true
fi

echo ""
echo "🎯 Next Steps:"
echo "1. Review and update ~/dev/Github/nix-config/modules/home.nix with your preferences"
echo "2. Add any missing tools to the configuration"
echo "3. Run: cd ~/dev/Github/nix-config && darwin-rebuild switch --flake ."
echo "4. Restart your terminal"
echo ""
echo "💡 Your old configurations are safely backed up and can be restored if needed!"

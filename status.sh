#!/bin/bash
# Check current configuration status

echo "🔍 VectorOpsAI Configuration Status"
echo "=================================="
echo ""

# Check Nix installation
if command -v nix &> /dev/null; then
    echo "✅ Nix installed: $(nix --version)"
else
    echo "❌ Nix not installed"
fi

# Check if using nix-darwin
if command -v darwin-rebuild &> /dev/null; then
    echo "✅ nix-darwin installed"
else
    echo "❌ nix-darwin not installed (configs still using dotfiles)"
fi

# Check current configurations
echo ""
echo "📁 Current Configuration Locations:"
echo ""

# Terminal configs
if [[ -f ~/.config/ghostty/config ]]; then
    if [[ -L ~/.config/ghostty/config ]]; then
        echo "✅ Ghostty: Managed by Nix (symlinked)"
    else
        echo "📄 Ghostty: Traditional dotfile"
    fi
else
    echo "❌ Ghostty: Not configured"
fi

# Shell configs
if [[ -f ~/.zshrc ]]; then
    if [[ -L ~/.zshrc ]]; then
        echo "✅ Zsh: Managed by Nix (symlinked)"
    else
        echo "📄 Zsh: Traditional dotfile"
    fi
fi

if [[ -f ~/.config/nushell/config.nu ]]; then
    if [[ -L ~/.config/nushell/config.nu ]]; then
        echo "✅ Nushell: Managed by Nix (symlinked)"
    else
        echo "📄 Nushell: Traditional dotfile"
    fi
fi

if [[ -f ~/.config/starship.toml ]]; then
    if [[ -L ~/.config/starship.toml ]]; then
        echo "✅ Starship: Managed by Nix (symlinked)"
    else
        echo "📄 Starship: Traditional dotfile"
    fi
fi

# Check for Homebrew packages
echo ""
echo "📦 Package Management:"
if command -v brew &> /dev/null; then
    brew_count=$(brew list --cask 2>/dev/null | wc -l | tr -d ' ')
    echo "🍺 Homebrew casks installed: $brew_count"
fi

# Show migration status
echo ""
if [[ -L ~/.zshrc ]] || [[ -L ~/.config/nushell/config.nu ]]; then
    echo "✅ Status: Migrated to Nix management"
else
    echo "⚠️  Status: Still using traditional dotfiles"
    echo ""
    echo "To migrate to Nix:"
    echo "1. cd ~/dev/Github/nix-config"
    echo "2. ./migrate.sh"
    echo "3. darwin-rebuild switch --flake ."
fi

echo ""
echo "📍 Configuration repository: ~/dev/Github/nix-config"

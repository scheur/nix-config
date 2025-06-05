#!/bin/bash
# VectorOpsAI macOS Bootstrap Script
# This script sets up a fresh macOS machine with our complete development environment

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 VectorOpsAI macOS Environment Setup${NC}"
echo "====================================="

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This script is only for macOS${NC}"
    exit 1
fi

# Get the macOS machine name
MACHINE_NAME=$(scutil --get ComputerName | tr ' ' '-')
echo -e "${GREEN}✓ Detected machine: $MACHINE_NAME${NC}"

# Install Xcode Command Line Tools if needed
if ! xcode-select -p &> /dev/null; then
    echo -e "${BLUE}📦 Installing Xcode Command Line Tools...${NC}"
    xcode-select --install
    echo "Press any key when Xcode Command Line Tools installation is complete..."
    read -n 1 -s
fi

# Install Nix if not already installed
if ! command -v nix &> /dev/null; then
    echo -e "${BLUE}📦 Installing Nix...${NC}"
    curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
    
    # Source Nix
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
    echo -e "${GREEN}✓ Nix already installed${NC}"
fi

# Enable flakes and nix-command
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Clone the configuration repository
echo -e "${BLUE}📥 Cloning configuration repository...${NC}"
if [[ ! -d "$HOME/dev/Github/nix-config" ]]; then
    mkdir -p "$HOME/dev/Github"
    git clone https://github.com/scheur/nix-config.git "$HOME/dev/Github/nix-config"
else
    echo -e "${GREEN}✓ Configuration already cloned${NC}"
    cd "$HOME/dev/Github/nix-config" && git pull
fi

# Update machine name in flake.nix if different
cd "$HOME/dev/Github/nix-config"
if ! grep -q "darwinConfigurations.\"$MACHINE_NAME\"" flake.nix; then
    echo -e "${BLUE}🔧 Updating configuration for machine: $MACHINE_NAME${NC}"
    sed -i '' "s/Diederiks-MacBook-Air/$MACHINE_NAME/g" flake.nix
fi

# Build and activate the configuration
echo -e "${BLUE}🏗️  Building configuration...${NC}"
nix build .#darwinConfigurations."$MACHINE_NAME".system

echo -e "${BLUE}🚀 Activating configuration...${NC}"
./result/sw/bin/darwin-rebuild switch --flake .

# Install Homebrew if not already installed (required for casks)
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}🍺 Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Setup Rust
if ! command -v rustup &> /dev/null; then
    echo -e "${BLUE}🦀 Installing Rust...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Create required directories
echo -e "${BLUE}📁 Creating directory structure...${NC}"
mkdir -p "$HOME/dev/Github"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/Desktop/Screenshots"

# Final setup
echo -e "${BLUE}🔧 Running final setup...${NC}"

# Set default shell to zsh (if not already)
if [[ "$SHELL" != "/bin/zsh" ]]; then
    chsh -s /bin/zsh
fi

# Success!
echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Test your setup with: nix --version && brew --version"
echo "3. Switch to nushell anytime with: nu"
echo "4. Update configuration with: nrs (alias for darwin-rebuild switch)"
echo ""
echo -e "${BLUE}🚀 Welcome to your declarative macOS environment!${NC}"

# 🚀 VectorOpsAI macOS Development Environment

A fully declarative macOS configuration using Nix, nix-darwin, and Home Manager.

## 🎯 What This Does

This repository contains a complete, reproducible macOS development environment that includes:

### System Level (via nix-darwin)
- 🍎 macOS system preferences (Dock, Finder, keyboard, trackpad)
- 🍺 Homebrew packages and casks management
- 🔐 Touch ID for sudo
- 📁 Directory structure creation

### User Level (via Home Manager)
- 🐚 Shell configuration (zsh + nushell)
- 🌙 Tokyo Night themed terminal stack
- 🛠️ Modern CLI tools (eza, bat, ripgrep, fd, etc.)
- 📝 Git configuration
- 🦀 Rust development environment
- ☁️ AWS tools
- 🎨 Starship prompt
- 🔐 **AWS Secrets Manager integration** (auto-loads API keys)

## 🚀 Quick Start

### Fresh Machine Setup

```bash
# One-liner to bootstrap everything
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/nix-config/main/bootstrap.sh | bash
```

### Existing Nix Installation

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/nix-config.git ~/dev/Github/nix-config
cd ~/dev/Github/nix-config

# Build and activate
darwin-rebuild switch --flake .
```

## 📁 Repository Structure

```
nix-config/
├── flake.nix              # Main flake configuration
├── flake.lock             # Locked dependencies
├── bootstrap.sh           # Setup script for new machines
├── modules/
│   ├── darwin.nix         # System-level macOS configuration
│   ├── home.nix           # User-level configuration
│   └── configs/           # Configuration files
│       ├── ghostty/       # Terminal emulator config
│       ├── nushell/       # Nushell shell configs
│       └── aws-secrets.sh # AWS Secrets Manager integration
└── README.md
```

## 🔐 AWS Secrets Integration

This configuration **automatically loads AWS secrets** from Secrets Manager:

- ✅ Fetches the `api-keys` secret on shell startup
- ✅ Exports all keys as environment variables
- ✅ Excludes `GITHUB_TOKEN` as requested
- ✅ Works in both zsh and nushell
- ✅ Shows loaded keys: `✅ AWS secrets loaded: ANTHROPIC_API_KEY, VOYAGE_API_KEY, ...`

**Requirements:**
- AWS CLI (included in config)
- AWS credentials configured
- IAM permission to read `api-keys` secret

See [AWS_SECRETS_INTEGRATION.md](./AWS_SECRETS_INTEGRATION.md) for details.

## 🛠️ Included Tools

### Terminal Stack
- **Ghostty** - Modern terminal emulator with Tokyo Night theme
- **Starship** - Beautiful prompt with git integration
- **Nushell** - Modern shell built in Rust
- **Zsh** - Default shell with plugins

### Development Tools
- **Just** - Command runner
- **Rust** toolchain with cargo plugins
- **AWS CLI** and SAM CLI
- **Terraform** - Infrastructure as Code
- **Docker** - Containerization
- **Git** with delta diff viewer

### Modern CLI Replacements
- `eza` → `ls` (with tree view, icons, git status)
- `bat` → `cat` (syntax highlighting)
- `ripgrep` → `grep` (faster, better)
- `fd` → `find` (intuitive syntax)
- `dust` → `du` (visual disk usage)
- `bottom` → `top` (better resource monitor)
- `tealdeer` → `man` (practical examples)

### Productivity Apps
- **Cursor** - AI-powered code editor
- **Arc** - Modern browser
- **Raycast** - Spotlight replacement
- **1Password** - Password manager
- **Obsidian** - Knowledge management

## 🎯 Usage

### Daily Commands

```bash
# Update your configuration
nrs  # Alias for: darwin-rebuild switch --flake ~/dev/Github/nix-config

# Switch to nushell
nu

# Common aliases (work in both shells)
dev   # cd ~/dev/Github
bb    # cd ~/dev/Github/building-blocks
j     # just
jl    # just --list
```

### Making Changes

1. Edit configuration files in `modules/`
2. Test changes: `darwin-rebuild build --flake .`
3. Apply changes: `darwin-rebuild switch --flake .`
4. Commit and push to GitHub

### Adding New Packages

#### System packages (Homebrew)
Edit `modules/darwin.nix`:
```nix
homebrew.casks = [
  # ... existing casks ...
  "new-app-name"
];
```

#### CLI tools (Nix)
Edit `modules/home.nix`:
```nix
home.packages = with pkgs; [
  # ... existing packages ...
  new-tool-name
];
```

## 🔧 Customization

### Machine-Specific Configuration

The flake automatically detects your machine name. To add machine-specific settings:

```nix
# In flake.nix
darwinConfigurations."Your-Machine-Name" = darwin.lib.darwinSystem {
  # ... configuration ...
};
```

### Personal Information

Update these in `modules/home.nix`:
- Git user name and email
- AWS configuration
- Any personal preferences

## 🚨 Troubleshooting

### Nix daemon not running
```bash
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

### Homebrew packages not installing
```bash
brew update && brew upgrade
```

### Configuration not applying
```bash
# Check for errors
darwin-rebuild check --flake .

# Force rebuild
darwin-rebuild switch --flake . --option eval-cache false
```

### AWS Secrets not loading
Check the error message:
- `⚠️ AWS CLI not found` → AWS CLI not in PATH
- `⚠️ AWS credentials not configured` → Run `aws configure`
- `⚠️ Could not fetch 'api-keys'` → Check IAM permissions

## 🔄 Keeping Up to Date

```bash
# Update flake inputs
nix flake update

# Apply updates
darwin-rebuild switch --flake .
```

## 🤝 Contributing

1. Fork this repository
2. Create your feature branch
3. Test thoroughly on your machine
4. Submit a pull request

## 📝 License

MIT - Feel free to use this as a template for your own configuration!

---

**Note**: Remember to update `YOUR_USERNAME` with your GitHub username before using!

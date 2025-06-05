# VectorOpsAI Nix Configuration Architecture

```mermaid
graph TD
    A[New macOS Machine] -->|curl bootstrap.sh| B[Bootstrap Script]
    
    B --> C[Install Nix]
    B --> D[Install XCode CLI Tools]
    B --> E[Clone nix-config repo]
    
    E --> F[flake.nix]
    
    F --> G[nix-darwin]
    F --> H[home-manager]
    
    G --> I[System Configuration]
    I --> I1[macOS Settings]
    I --> I2[Homebrew Packages]
    I --> I3[System Security]
    I --> I4[Directory Structure]
    
    H --> J[User Configuration]
    J --> J1[Shell Setup]
    J --> J2[Terminal Config]
    J --> J3[Dev Tools]
    J --> J4[Git Config]
    J --> J5[Modern CLI Tools]
    
    J1 --> K[zsh + nushell]
    J2 --> L[Ghostty + Starship]
    J3 --> M[Rust + AWS + Docker]
    
    G --> N[darwin-rebuild]
    H --> N
    N --> O[Activated System]
    
    style A fill:#f9f,stroke:#333,stroke-width:4px
    style O fill:#9f9,stroke:#333,stroke-width:4px
    style F fill:#bbf,stroke:#333,stroke-width:2px
```

## Configuration Flow

1. **Entry Point**: `bootstrap.sh` handles everything
2. **Nix Flake**: Central configuration in `flake.nix`
3. **Two Managers**:
   - `nix-darwin`: System-level macOS settings
   - `home-manager`: User-level applications and dotfiles
4. **Single Command**: `darwin-rebuild switch` applies everything

## Key Benefits

- 🔄 **Reproducible**: Exact same setup every time
- 📦 **Declarative**: Configuration as code
- 🚀 **Fast**: Parallel installation
- 🔒 **Atomic**: All-or-nothing updates
- ↩️ **Rollback**: Easy recovery from bad changes

## Files Overview

```
nix-config/
├── 🚀 bootstrap.sh          # One-liner setup script
├── ❄️  flake.nix            # Main configuration
├── 🔒 flake.lock           # Pinned versions
├── 📖 README.md            # Documentation
├── 🔄 migrate.sh           # Migration helper
└── modules/
    ├── 🍎 darwin.nix       # macOS + Homebrew
    ├── 🏠 home.nix         # User environment
    └── 📁 configs/         # App configurations
        ├── ghostty/        # Terminal settings
        └── nushell/        # Shell settings
```

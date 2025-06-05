{ config, pkgs, ... }:

{
  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "scheur" ];
      max-jobs = 10;
      cores = 0;
    };
    
    # Garbage collection
    gc = {
      automatic = true;
      interval = { Weekday = 7; };
      options = "--delete-older-than 30d";
    };
  };

  # System packages (available to all users)
  environment.systemPackages = with pkgs; [
    # Essential tools
    git
    vim
    curl
    wget
    gnupg
    
    # Terminal tools
    terminal-notifier
    mas  # Mac App Store CLI
  ];

  # Homebrew management
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";  # Remove everything not listed
    };
    
    # Taps
    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/services"
    ];
    
    # Brew packages
    brews = [
      "awscli"
      "terraform"
      "node"
      "pnpm"
      "rustup"
      "uv"  # Python package manager
    ];
    
    # Cask applications
    casks = [
      # Development
      "ghostty"
      "cursor"
      "visual-studio-code"
      "docker"
      
      # Browsers
      "arc"
      "google-chrome"
      
      # Productivity
      "raycast"
      "1password"
      "obsidian"
      
      # Communication
      "slack"
      "zoom"
      
      # Utilities
      "cleanmymac"
      "bartender"
    ];
  };

  # macOS system defaults
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      minimize-to-application = true;
      show-recents = false;
      tilesize = 48;
      wvous-bl-corner = 1;  # Disabled
      wvous-br-corner = 1;  # Disabled
      wvous-tl-corner = 1;  # Disabled
      wvous-tr-corner = 1;  # Disabled
    };
    
    # Finder
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };
    
    # Global
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };
    
    # Login window
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };
    
    # Screenshots
    screencapture.location = "~/Desktop/Screenshots";
    
    # Trackpad
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  # Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Create required directories
  system.activationScripts.postUserActivation.text = ''
    # Screenshots directory
    mkdir -p ~/Desktop/Screenshots
    
    # Development directories
    mkdir -p ~/dev/Github
    mkdir -p ~/.config
    mkdir -p ~/.local/bin
  '';

  # Auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;

  # Used for backwards compatibility
  system.stateVersion = 4;
}

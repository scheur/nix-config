{ config, pkgs, lib, inputs, ... }:

{
  # Home Manager configuration
  home = {
    username = "scheur";
    homeDirectory = "/Users/scheur";
    stateVersion = "23.11";
    
    # Session variables
    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "cursor";
      AWS_DEFAULT_REGION = "us-east-1";
      RUSTUP_HOME = "$HOME/.rustup";
      CARGO_HOME = "$HOME/.cargo";
    };
    
    # Session path
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "/opt/homebrew/bin"
    ];
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Terminal Stack
  programs = {
    # Zsh configuration
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      
      sessionVariables = {
        AWS_DEFAULT_REGION = "us-east-1";
      };
      
      shellAliases = {
        ll = "ls -la";
        gs = "git status";
        gp = "git pull";
        gcp = "git add . && git commit -m \"$1\" && git push";
        dev = "cd ~/dev/Github";
        bb = "cd ~/dev/Github/building-blocks";
      };
      
      initExtra = ''
        # Load AWS secrets from Secrets Manager (except GITHUB_TOKEN)
        if [[ -f "$HOME/.config/aws-secrets.sh" ]]; then
          source "$HOME/.config/aws-secrets.sh"
        fi
        
        # Source Claude Code MCP if available
        if [[ -f "$HOME/.claude/claude-code-mcp.sh" ]]; then
          source "$HOME/.claude/claude-code-mcp.sh"
        fi
        
        # Initialize tools
        eval "$(zoxide init zsh)"
        eval "$(atuin init zsh)"
        eval "$(direnv hook zsh)"
        
        echo "🚀 VectorOpsAI development environment ready!"
      '';
    };
    
    # Nushell configuration
    nushell = {
      enable = true;
      
      configFile.text = ''
        # Load from existing config
        ${builtins.readFile ./configs/nushell/config.nu}
      '';
      
      envFile.text = ''
        # Load AWS secrets on startup
        def load-aws-secrets [] {
            if ("/Users/scheur/.config/aws-secrets.nu" | path exists) {
                source ~/.config/aws-secrets.nu
            }
        }
        
        # Load secrets when shell starts
        load-aws-secrets
        
        # Load from existing env
        ${builtins.readFile ./configs/nushell/env.nu}
      '';
    };
    
    # Starship prompt
    starship = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      
      settings = {
        # Tokyo Night preset inline
        format = ''
          [░▒▓](#a3aed2)\
          [  ](bg:#a3aed2 fg:#090c0c)\
          [](bg:#769ff0 fg:#a3aed2)\
          $directory\
          [](fg:#769ff0 bg:#394260)\
          $git_branch\
          $git_status\
          [](fg:#394260 bg:#212736)\
          $nodejs\
          $rust\
          $golang\
          $php\
          [](fg:#212736 bg:#1d2230)\
          $time\
          [ ](fg:#1d2230)\
          \n$character
        '';
        
        directory = {
          style = "fg:#e3e5e5 bg:#769ff0";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = " ";
            "Pictures" = " ";
          };
        };
        
        git_branch = {
          symbol = "";
          style = "bg:#394260";
          format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
        };
        
        git_status = {
          style = "bg:#394260";
          format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
        };
        
        nodejs = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
        };
        
        rust = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
        };
        
        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:#1d2230";
          format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
        };
      };
    };
    
    # Git configuration
    git = {
      enable = true;
      userName = "Diederik Scheur";
      userEmail = "51237749+scheur@users.noreply.github.com";
      
      aliases = {
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      };
      
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = false;
        core.editor = "vim";
      };
    };
    
    # GitHub CLI
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
    
    # Modern CLI tools
    eza = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      icons = true;
      git = true;
      
      extraOptions = [
        "--tree"
        "--level=2"
        "--git-ignore"
      ];
    };
    
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        style = "numbers,changes,header";
      };
    };
    
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
      ];
    };
    
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    
    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      
      settings = {
        auto_sync = false;
        sync_frequency = "5m";
        search_mode = "fuzzy";
        style = "compact";
      };
    };
    
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
    
    # Terminal multiplexer
    tmux = {
      enable = true;
      shortcut = "a";
      baseIndex = 1;
      terminal = "screen-256color";
      
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        pain-control
        sessionist
        {
          plugin = tokyo-night-tmux;
          extraConfig = ''
            set -g @tokyo-night-tmux_window_id_style digital
          '';
        }
      ];
    };
  };

  # Packages to install
  home.packages = with pkgs; [
    # Core development tools
    just
    watchexec
    hyperfine
    tokei
    
    # Rust development
    cargo-edit
    cargo-watch
    cargo-nextest
    bacon
    
    # Terminal tools
    ripgrep
    fd
    sd
    dust
    bottom
    procs
    tealdeer
    
    # File management
    yazi
    
    # Network tools
    httpie
    curlie
    xh
    dog
    
    # JSON/YAML tools
    jq
    yq
    
    # Git tools
    delta
    gitui
    gh
    
    # AWS tools
    awscli2
    aws-sam-cli
    
    # Container tools
    lazydocker
    dive
    
    # Misc
    neofetch
    glow  # Markdown viewer
  ];

  # Configuration files
  home.file = {
    # Ghostty configuration
    ".config/ghostty/config".text = ''
      ${builtins.readFile ./configs/ghostty/config}
    '';
    
    # AWS secrets loading script (bash/zsh version)
    ".config/aws-secrets.sh".source = ./configs/aws-secrets.sh;
    ".config/aws-secrets.sh".executable = true;
    
    # AWS secrets loading script (nushell version)
    ".config/aws-secrets.nu".text = ''
      # Load AWS secrets from Secrets Manager for Nushell
      def load-aws-secrets [] {
          # Check if AWS CLI is available
          let aws_exists = (which aws | length) > 0
          if not $aws_exists {
              echo "⚠️  AWS CLI not found. Skipping secrets loading."
              return
          }
          
          # Check AWS credentials
          let can_auth = (do -i { aws sts get-caller-identity } | complete | get exit_code) == 0
          if not $can_auth {
              echo "⚠️  AWS credentials not configured. Skipping secrets loading."
              return
          }
          
          # Fetch the api-keys secret
          let region = ($env.AWS_DEFAULT_REGION? | default "us-east-1")
          let secret_result = (do -i { 
              aws secretsmanager get-secret-value --secret-id "api-keys" --region $region --query 'SecretString' --output text 
          } | complete)
          
          if $secret_result.exit_code != 0 {
              echo "⚠️  Could not fetch 'api-keys' from AWS Secrets Manager"
              return
          }
          
          let secret_json = $secret_result.stdout
          
          # Parse JSON and set environment variables (except GITHUB_TOKEN)
          let secrets = ($secret_json | from json)
          for key in ($secrets | columns) {
              if $key != "GITHUB_TOKEN" {
                  let value = ($secrets | get $key)
                  load-env { $key: $value }
              }
          }
          
          # List loaded variables (without values for security)
          let loaded_vars = ($secrets | columns | where $it != "GITHUB_TOKEN" | str join ", ")
          if ($loaded_vars | str length) > 0 {
              echo $"✅ AWS secrets loaded: ($loaded_vars)"
          }
      }
    '';
    
    # Git ignore
    ".gitignore_global".text = ''
      .DS_Store
      *.swp
      *.swo
      *~
      .idea/
      .vscode/
      target/
      node_modules/
      .env
      .env.local
    '';
  };

  # Shell aliases that work across all shells
  home.shellAliases = {
    # Enhanced ls using eza
    ls = "eza --tree --git-ignore --icons --level=2";
    ll = "eza -la --tree --git-ignore --icons --level=2";
    la = "eza -la --tree --git-ignore --icons --all --level=2";
    tree = "eza --tree --git-ignore --icons";
    
    # Git shortcuts
    g = "git";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gpl = "git pull";
    gco = "git checkout";
    gd = "git diff";
    gb = "git branch";
    gl = "git log --oneline --graph --decorate";
    
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    
    # Development shortcuts
    dev = "cd ~/dev/Github";
    bb = "cd ~/dev/Github/building-blocks";
    
    # Nix shortcuts
    nd = "nix develop";
    nf = "nix flake";
    ns = "nix shell";
    nrs = "darwin-rebuild switch --flake ~/dev/Github/nix-config";
    
    # Just shortcuts
    j = "just";
    jl = "just --list";
    
    # Better defaults
    cat = "bat";
    find = "fd";
    grep = "rg";
    du = "dust";
    top = "btm";
    htop = "btm";
    man = "tldr";
  };
}

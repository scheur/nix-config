{
  description = "VectorOpsAI macOS Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, nixvim, ... }@inputs: {
    # macOS system configuration
    darwinConfigurations."Diederiks-MacBook-Air" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";  # M1/M2 Mac
      
      modules = [
        ./modules/darwin.nix
        
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.scheur = import ./modules/home.nix;
            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];
    };
    
    # Standalone home-manager configuration (for non-NixOS systems)
    homeConfigurations."scheur" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [ ./modules/home.nix ];
      extraSpecialArgs = { inherit inputs; };
    };
  };
}

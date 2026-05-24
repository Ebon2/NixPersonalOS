{
  description = "NixOS + Home Manager configuration";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, ... }@inputs:
  let
    userConfig = import ./user.nix;
    diskConfig = import ./disk.nix;
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs userConfig diskConfig; };
      
      modules = [
        ./hosts/nixos/default.nix
        ./hosts/nixos/hardware-configuration.nix

        disko.nixosModules.disko
        ./hosts/nixos/disko.nix
        
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension  = "bak-$(date +%Y%m%d%H%M%S)";
            useGlobalPkgs        = true;
            useUserPackages      = true;
            extraSpecialArgs     = { inherit inputs userConfig; };
            users.${userConfig.username} = import ./home/default.nix; 
          };
        }
      ];
    };
  };
}
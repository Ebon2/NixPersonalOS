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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    userConfig = import ./user.nix;
    diskConfig = import ./disk.nix;
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs userConfig; };   # ← disponible en todos los módulos NixOS
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
            extraSpecialArgs     = { inherit inputs userConfig; };  # ← disponible en HM
            users.${userConfig.username} = import ./home/default.nix;  # ← username dinámico
          };
        }
      ];
    };
  };
}
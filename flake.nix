{
  description = "NixOS + Home Manager configuration";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    userConfig = import ./user.nix;   # ← único punto de entrada
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs userConfig; };   # ← disponible en todos los módulos NixOS
      modules = [
        ./hosts/nixos/default.nix
        ./hosts/nixos/hardware-configuration.nix

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
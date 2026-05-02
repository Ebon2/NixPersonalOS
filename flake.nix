{
  description = "NixOS + Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Descomenta si quieres Hyprland bleeding-edge
    # hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos/default.nix
          ./hosts/nixos/hardware-configuration.nix

          # Home Manager como módulo NixOS (recomendado: todo en un rebuild)
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;   # Usa el mismo nixpkgs del sistema
              useUserPackages = true; # Instala paquetes en /etc/profiles/per-user
              backupFileExtension = "bak"; # En vez de fallar, renombra conflictos
              extraSpecialArgs = { inherit inputs; };
              users.angel = import ./home/default.nix;
            };
          }
        ];
      };
    };
  };
}

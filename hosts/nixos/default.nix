{ config, pkgs, inputs, ... }:

{
  imports = [
    # Sistema
    #../../modules/system/boot.nix
    ../../modules/system/kernel.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/users.nix
    ../../modules/system/environment.nix

    # Hardware
    ../../modules/hardware/amd-gpu.nix

    # Desktop (nivel sistema — habilita el compositor)
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/plasma.nix
    ../../modules/desktop/x11.nix

    # Servicios
    ../../modules/services/audio.nix
    ../../modules/services/printing.nix
    ../../modules/services/bluetooth.nix
    ../../modules/services/power.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/system.nix
    ../../modules/services/cleaner.nix
    ../../modules/services/virtualbox.nix
    ../../modules/services/ollama.nix

    # Paquetes del sistema (lo que NO puede ir en home-manager)
    ../../modules/programs/system-packages.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "ventoy/1.1.10" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}

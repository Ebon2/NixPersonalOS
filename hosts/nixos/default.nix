{ config, pkgs, inputs, ... }:

{
  imports = [
    # Módulos del sistema
    ../../modules/system/boot.nix
    ../../modules/system/kernel.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/users.nix
    ../../modules/system/environment.nix
    ../../modules/system/user-configs.nix  # Gestión de dotfiles
    
    # Hardware
    ../../modules/hardware/amd-gpu.nix
    
    # Desktop environment - AMBOS HABILITADOS
    # SDDM te permitirá elegir entre ellos al hacer login
    ../../modules/desktop/plasma.nix    # KDE Plasma 6 (X11 y Wayland)
    ../../modules/desktop/x11.nix
    ../../modules/desktop/hyprland.nix  # Hyprland (Wayland)
    
    # Servicios
    ../../modules/services/audio.nix
    ../../modules/services/printing.nix
    ../../modules/services/bluetooth.nix
    ../../modules/services/power.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/system.nix
    ../../modules/services/cleaner.nix
    ../../modules/services/virtualbox.nix  # VirtualBox con kernel zen
    ../../modules/services/ollama.nix

    # Programas
    ../../modules/programs/firefox.nix
    ../../modules/programs/packages.nix
  ];

  # Configuración general del sistema
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "ventoy/1.1.10" ];

  # Habilitar flakes y nix command experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Estado del sistema - NO CAMBIAR después de la instalación inicial
  system.stateVersion = "25.11";
}

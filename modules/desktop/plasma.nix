{ config, pkgs, ... }:

{
  # KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Display Manager (SDDM) con soporte multi-sesión
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;  # Habilitar Wayland
    
    # Configuración para mostrar sesiones disponibles
    settings = {
      General = {
        # Recordar última sesión
        RememberSession = true;
      };
      
      # Tema de SDDM
      Theme = {
        Current = "breeze";
      };
    };
  };

  # Habilitar sesión X11 de Plasma (además de Wayland)
#  services.xserver.desktopManager.plasma5.enable = false;  # Asegurar que solo Plasma 6
  
  # Asegurar que ambas sesiones estén disponibles en SDDM
  services.displayManager.defaultSession = "plasma";  # Sesión por defecto
  
  # NOTA: Con esta configuración, SDDM mostrará:
  # - Plasma (Wayland) - default
  # - Plasma (X11)
  # - Hyprland (si está habilitado en hyprland.nix)
  # El usuario puede elegir en el selector de sesión de SDDM

  # Paquetes adicionales de KDE que podrías querer
  environment.systemPackages = with pkgs; [
    # Aplicaciones KDE
    kdePackages.kate
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.ark  # Gestor de archivos comprimidos
    kdePackages.okular  # Visor de PDFs
    kdePackages.gwenview  # Visor de imágenes
    kdePackages.spectacle  # Capturas de pantalla
    
    # Utilidades
    kdePackages.kdeconnect-kde  # Integración con Android
    kdePackages.partitionmanager  # Gestor de particiones
    kdePackages.kcalc  # Calculadora
    
    # Agrega más según necesites

    # Soporte para thumbnails de diferentes formatos
    kdePackages.ffmpegthumbs
    kdePackages.kimageformats
    kdePackages.kio-extras
  ];
}

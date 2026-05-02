{ config, pkgs, inputs, ... }:

{
  # Hyprland - Wayland compositor tiling
  # Para activar:
  # 1. Descomenta la importación en hosts/nixos/default.nix
  # 2. Rebuild el sistema
  # 3. En SDDM, selecciona "Hyprland" antes de login

  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  # Paquetes del ecosistema Hyprland
  environment.systemPackages = with pkgs; [
    # Core Hyprland tools
    hyprlock              # Screen locker
    hyprpaper             # Wallpaper daemon
    hypridle              # Idle daemon
    hyprshot              # Screenshot tool
    
    # Bar y notificaciones
    waybar                # Status bar
    dunst                 # Notification daemon
    
    # Launchers y menus
    rofi          # Application launcher
    wofi                  # Alternative launcher
    
    # Wallpapers
    awww                  # Animated wallpapers
    waypaper              # Wallpaper manager
    
    # Terminal
    kitty                 # Terminal emulator
    foot                  # Alternative terminal
    
    # Screenshot y screen sharing
    grim                  # Screenshot
    slurp                 # Area selector
    swappy                # Screenshot editor
    wl-clipboard          # Clipboard manager
    cliphist              # Clipboard history
    
    # Logout menu
    wlogout               # Logout menu
    
    # Display config
    wlr-randr             # Display config tool
    nwg-look              # GTK theme switcher
    
    # Portal para screen sharing
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    
    # Brightness control
    brightnessctl         # Brightness control
    
    # Media control
    playerctl             # Media player control
    
    # Polkit authentication agent
    polkit_gnome
    
    # Network Manager Applet
    networkmanagerapplet
    
    # Bluetooth
    blueman
  ];

  # XDG Desktop Portal para Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "hyprland" "gtk" ];
      };
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
    };
  };

  # Variables de entorno para Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";              # Para apps Electron
#    WLR_NO_HARDWARE_CURSORS = "1";     # Si tienes problemas con el cursor
    MOZ_ENABLE_WAYLAND = "1";          # Firefox en Wayland
#    QT_QPA_PLATFORM = "wayland";       # Qt apps en Wayland
#    SDL_VIDEODRIVER = "wayland";       # SDL apps en Wayland
#    CLUTTER_BACKEND = "wayland";       # Clutter apps en Wayland
#    XDG_CURRENT_DESKTOP = "Hyprland";
#    XDG_SESSION_DESKTOP = "Hyprland";
#    XDG_SESSION_TYPE = "wayland";
  };

  # Polkit para autenticación gráfica
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Configuración de usuario para Hyprland
  # Las configs personalizadas están en /etc/nixos/static/hypr
  # Después del rebuild, ejecuta: install-user-configs
  # Esto copiará las configs a ~/.config/hypr
}

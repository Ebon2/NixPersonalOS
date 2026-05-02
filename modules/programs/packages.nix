{ config, pkgs, ... }:

{

  # Paquetes instalados a nivel de sistema
  environment.systemPackages = with pkgs; [
    # === HERRAMIENTAS BÁSICAS DEL SISTEMA ===
    vim
    neovim
    nano
    wget
    curl
    jq
    git
    htop
    btop
    tree
    unzip
    unrar
    zip
    p7zip
    rsync
    pv
    zapzap
    spotify
    bubblewrap
    
    # === MONITORING Y SYSTEM INFO ===
    pciutils          # lspci
    usbutils          # lsusb
    lshw              # Información de hardware
    inxi              # Info del sistema
    fastfetch         # Info del sistema (mejor que neofetch)
    hwinfo            # Hardware info detallado
    dmidecode         # DMI table decoder
    lsscsi            # List SCSI devices
    smartmontools     # HDD/SSD health
    steam-run 
    brightnessctl

    # === AMD GPU TOOLS ===
    amdgpu_top        # Monitor GPU AMD
    mesa-demos        # glxinfo, glxgears
    vulkan-tools      # vulkaninfo
    
    # === NETWORK TOOLS ===
    networkmanager
    networkmanagerapplet
    bind              # DNS tools (dig, nslookup)
    dnsmasq           # DNS/DHCP server
    iperf3            # Network performance
    nethogs           # Network monitor per proceso
    ethtool           # Ethernet config
    inetutils         # telnet, ftp, etc
    
    # === SHELL Y TERMINAL ===
    fish              # Shell moderno
    zsh               # Shell alternativo
    starship          # Prompt personalizable
    atuin             # History sync
    tldr              # Man pages simplificadas
    tmux              # Terminal multiplexer
    kitty             # Terminal emulator
    
    # === FILE MANAGERS ===
    ranger            # Terminal file manager
    broot             # Terminal file navigator
    duf               # df mejorado
    
    # === DESARROLLO - GENERAL ===
    #gcc
    #gnumake
    #cmake
    #gdb
    #valgrind          # Memory debugger
    #doxygen           # Documentation
    git
    

    # === DESARROLLO - LENGUAJES ===
    #python3
    #python312Packages.pip
    jdk21             # Java 21
    #maven             # Java build tool
    
    # === DESARROLLO - TOOLS ===
    docker            # Lo configuraremos después
    docker-compose
    jetbrains-toolbox
    vscode
    jetbrains.idea
    jetbrains.idea-oss
    jetbrains.clion
    jetbrains.pycharm
    bruno

    # === MULTIMEDIA ===
    vlc
    ffmpeg
    cava              # Audio visualizer
    pavucontrol       # PulseAudio/PipeWire control
    
    # === OFFICE Y PRODUCTIVIDAD ===
    onlyoffice-desktopeditors
    obsidian
    zotero            # Reference manager
    
    # === GRÁFICOS ===
    gimp
    
    # === COMUNICACIÓN ===
    discord
    
    # === GAMING ===
    gamemode
    mangohud
    prismlauncher # Minecraft Launcher
    # wine configurado abajo
    
    # === BROWSERS ===
    firefox
    brave
    # zen-browser no está en nixpkgs oficial
    
    # === UTILIDADES ===
    bitwarden-desktop # Password manager
    obs-studio        # Screen recording
#    ventoy            # Bootable USB
    timeshift         # System backup
    
    # === HYPRLAND ECOSYSTEM (si usas Hyprland) ===
#    hyprland        # Ya se configura en hyprland.nix
#    hyprlock
#    hyprpaper
#    hypridle
#    hyprshot
#    waybar
#    waypaper
#    rofi
#    dunst
#    grim
#    slurp
#    swappy
#    swww
#    cliphist
#    wlogout
    
    # === EXTRAS Y FUN ===
    cmatrix           # Matrix effect
    figlet            # ASCII art text
#    pipes          # Animated pipes
    clock-rs         # Terminal clock
    
    # === ARCHIVING TOOLS === 
#    ark               # KDE archive manager

    # Wine con soporte de 32 bits
    wine
    winetricks
    
     #ollama-cpu #se declara en modules/services/ollama.nix (junto al servicio)
  ];

  # === WINE CONFIGURATION ===
  # Hardware acceleration para wine
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Fuentes
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
#    noto-fonts-cjk           # Fuentes asiáticas
#    noto-fonts-extra
    liberation_ttf
    fira-code
    fira-code-symbols
    fira                     # Fira Sans
    dejavu_fonts
    font-awesome             # Iconos
#    bitstream-vera           # Fuente clásica
#    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # Programas especiales que necesitan configuración adicional
  
  # === STEAM ===

#  programs.steam.enable = true;
#  programs.steam = {
#    enable = true;
#    package = pkgs.steam.override {
#      extraCompatPackages = with pkgs; [ proton-ge-bin ];
#    };


#    remotePlay.openFirewall = true;
#    dedicatedServer.openFirewall = true;
#    gamescopeSession.enable = true;  # Gamescope compositor
#  };

#  security.unprivilegedUsernsClone = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];

  # === GAMEMODE ===
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # === FISH SHELL ===
  programs.fish.enable = true;

  # === ZSH ===
  programs.zsh.enable = true;

  # === DOCKER ===
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    storageDriver = "overlay2";  # Cambia a "overlay2" si no usas btrfs
  };


  # VirtualBox → ver modules/services/virtualbox.nix
}

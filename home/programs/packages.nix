{ pkgs, ... }:

# ─────────────────────────────────────────────────────────────────
# Paquetes del usuario — instalados en ~/.nix-profile
# Aquí va todo lo que era environment.systemPackages pero pertenece
# al usuario, no al sistema.
# ─────────────────────────────────────────────────────────────────
{
  home.packages = with pkgs; [

    # ── Herramientas básicas ────────────────────────────────────
    wget curl jq tree rsync pv bat
    unzip unrar zip p7zip openssl

    # ── Monitoring / System info ────────────────────────────────
    pciutils usbutils lshw inxi hwinfo dmidecode lsscsi smartmontools
    htop btop ntopng
    fastfetch

    # ── AMD GPU ─────────────────────────────────────────────────
    amdgpu_top
    mesa-demos     # glxinfo, glxgears
    vulkan-tools   # vulkaninfo

    # ── Red ──────────────────────────────────────────────────────
    networkmanagerapplet
    bind dnsmasq iperf3 nethogs ethtool inetutils

    # ── Terminal / Shell ─────────────────────────────────────────
    starship
    atuin
    tldr
    tmux
    # kitty → configurado en programs/kitty.nix
    # fish  → configurado en programs/fish.nix

    # ── Gestores de archivos ─────────────────────────────────────
    yazi
    ffmpeg
    unar
    poppler
    fd
    ripgrep
    fzf
    eza
    thunar
    broot
    duf

    # thunar
    thunar
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
    
    ffmpegthumbnailer
    file-roller
    # ── Desarrollo ───────────────────────────────────────────────
    jdk21
    docker-compose
    jetbrains-toolbox
    vscode
    # IDE → descomenta los que uses:
    jetbrains.idea
    # jetbrains.idea-community
    jetbrains.clion
    jetbrains.pycharm
    bruno            # API client

    # ── Multimedia ───────────────────────────────────────────────
    vlc
    ffmpeg
    cava
    pavucontrol
    steam-run
    brightnessctl

    # ── Productividad ────────────────────────────────────────────
    onlyoffice-desktopeditors
    obsidian
    zotero
    pgmodeler

    # ── Gráficos ─────────────────────────────────────────────────
    gimp

    # ── Comunicación ─────────────────────────────────────────────
    vesktop
    zapzap          # WhatsApp
    spotify

    # ── Gaming ───────────────────────────────────────────────────
    mangohud
    prismlauncher   # Minecraft

    # ── Navegadores ──────────────────────────────────────────────
    brave
    # firefox → configurado en programs/firefox.nix

    # ── Utilidades ───────────────────────────────────────────────
    bitwarden-desktop
    obs-studio
    timeshift
    bubblewrap

    # ── Extras / Fun ─────────────────────────────────────────────
    cmatrix
    figlet
    clock-rs
    home-manager

    # ── KDE (si usas Plasma) ─────────────────────────────────────
    kdePackages.kate
  ];
}

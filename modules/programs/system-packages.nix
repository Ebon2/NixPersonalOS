# ─────────────────────────────────────────────────────────────────
# PAQUETES A NIVEL SISTEMA
# Solo van aquí cosas que realmente necesitan ser sistema:
#   - herramientas que necesitan setuid/capabilities
#   - paquetes usados antes de login (en TTY)
#   - fuentes (se compilan en el font cache del sistema)
#   - virtualización
# El resto va en home/programs/
# ─────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  # ── Shells ─────────────────────────────────────────────────────
  # Deben estar en el sistema para que /etc/shells los incluya
  programs.fish.enable = true;
  programs.zsh.enable  = true;

  # ── Direnv ─────────────────────────────────────────────────────
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ── Docker ─────────────────────────────────────────────────────
  virtualisation.docker = {
    enable       = true;
    enableOnBoot = true;
    storageDriver = "overlay2";
  };

  # ── Flatpak ────────────────────────────────────────────────────
  services.flatpak.enable = true;

  # ── Gamemode ───────────────────────────────────────────────────
  programs.gamemode = {
    enable       = true;
    enableRenice = true;
  };

  # ── Wine (necesita 32-bit libs del sistema) ────────────────────
  environment.systemPackages = with pkgs; [
    wine
    winetricks
  ];

  hardware.graphics = {
    enable    = true;
    enable32Bit = true;
  };

  # ── Fuentes ────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    fira
    dejavu_fonts
    font-awesome
    # Descomenta para soporte asiático:
    # noto-fonts-cjk
    # Para Nerd Fonts (iconos en terminal):
    # (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # ── Steam (opcional) ───────────────────────────────────────────
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    remotePlay.openFirewall = true;
  };
}

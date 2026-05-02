{ config, pkgs, inputs, ... }:

# ─────────────────────────────────────────────────────────────────
# HOME MANAGER — Punto de entrada para el usuario "angel"
#
# Arquitectura:
#   home/
#   ├── default.nix          ← este archivo
#   ├── programs/
#   │   ├── packages.nix     ← todos los paquetes del usuario
#   │   ├── firefox.nix      ← firefox + extensiones + políticas
#   │   ├── fish.nix         ← shell, aliases, funciones
#   │   ├── kitty.nix        ← terminal emulator
#   │   ├── neovim.nix       ← nvim (o enlaza el init.lua de static)
#   │   ├── git.nix          ← git config
#   │   └── misc.nix         ← btop, fastfetch, atuin, starship...
#   └── desktop/
#       ├── hyprland.nix     ← wayland compositor config
#       ├── waybar.nix       ← status bar
#       ├── rofi.nix         ← launcher
#       └── theme.nix        ← GTK, cursors, iconos
# ─────────────────────────────────────────────────────────────────

{
  imports = [
    ./programs/packages.nix
    ./programs/firefox.nix
    ./programs/fish.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/git.nix
    ./programs/misc.nix
    ./desktop/hyprland.nix
    ./desktop/waybar.nix
    ./desktop/rofi.nix
    ./desktop/theme.nix
  ];

  # ── Identidad ──────────────────────────────────────────────────
  home.username = "angel";
  home.homeDirectory = "~";

  # ── Versión de Home Manager ────────────────────────────────────
  # NO cambiar después de la instalación inicial
  home.stateVersion = "25.11";

  # ── Variables de entorno del usuario ──────────────────────────
  home.sessionVariables = {
    EDITOR   = "nvim";
    VISUAL   = "nvim";
    BROWSER  = "brave";
    TERMINAL = "kitty";

    # XDG
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_CACHE_HOME  = "$HOME/.cache";

    # Qt
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_WAYLAND_RECONNECT = "1";

    # Wayland / Electron
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";

    # Color
    COLORTERM = "truecolor";
  };

  # ── PATH extra ─────────────────────────────────────────────────
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.local/share/JetBrains/Toolbox/scripts"
  ];

  # ── Directorios que deben existir ─────────────────────────────
  home.file."Imágenes/Screenshots/.keep".text = "";
  home.file."Temp/.keep".text = "";

  # ── Activar home-manager command ───────────────────────────────
  programs.home-manager.enable = true;
}

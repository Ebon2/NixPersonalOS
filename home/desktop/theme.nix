{ pkgs, ... }:

# ─────────────────────────────────────────────────────────────────
# Tema GTK, cursores e iconos — gestionado por Home Manager
# ─────────────────────────────────────────────────────────────────

{
  # ── GTK ────────────────────────────────────────────────────────
  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-mocha-green-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "green" ];
        variant  = "mocha";
      };
    };

    iconTheme = {
      name    = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name    = "Qogir-dark";
      package = pkgs.qogir-icon-theme;
      size    = 24;
    };

    font = {
      name = "Fira Sans";
      size = 11;
    };

    #gtk3.extraConfig = {
    #  gtk-application-prefer-dark-theme = true;
    #};

    #gtk4.extraConfig = {
    #  gtk-application-prefer-dark-theme = true;
    #};

    gtk3.theme = null;
    gtk4.theme = null;
  };

  # ── Qt ─────────────────────────────────────────────────────────
  qt = {
    enable          = true;
    platformTheme.name = "gtk";  # Hereda el tema de GTK
    style.name      = "kvantum";
  };

  # ── Cursor X11 ────────────────────────────────────────────────
  home.pointerCursor = {
    name    = "Qogir-dark";
    package = pkgs.qogir-icon-theme;
    size    = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}

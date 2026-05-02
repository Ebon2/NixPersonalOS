{ ... }:

# ─────────────────────────────────────────────────────────────────
# Kitty — gestionado por Home Manager
# El config de static/kitty/kitty.conf se migra aquí.
# ─────────────────────────────────────────────────────────────────

{
  programs.kitty = {
    enable = true;

    font = {
      name = "monospace";
      size = 12;
    };

    settings = {
      # Shell integration (fish lo hace manualmente)
      shell_integration = "no-rc";

      # Transparencia
      background_opacity = "0.6";

      # Cursor
      cursor            = "#f8f8f2";
      cursor_text_color = "background";

      # Selección
      selection_background = "#44475a";
      selection_foreground = "#ffffff";

      # URLs
      url_color = "#8be9fd";

      # Foreground / Background — Dracula
      foreground = "#f8f8f2";
      background = "#282a36";

      # Tabs
      active_tab_foreground = "#282a36";
    };

    # Colores Dracula
    extraConfig = ''
      # Dracula color scheme
      color0  #21222c
      color1  #ff5555
      color2  #50fa7b
      color3  #f1fa8c
      color4  #bd93f9
      color5  #ff79c6
      color6  #8be9fd
      color7  #f8f8f2
      color8  #6272a4
      color9  #ff6e6e
      color10 #69ff94
      color11 #ffffa5
      color12 #d6acff
      color13 #ff92df
      color14 #a4ffff
      color15 #ffffff
    '';
  };
}

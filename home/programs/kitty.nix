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
    background_opacity   = "0.6";
    shell_integration    = "no-rc";
    cursor_text_color    = "background";
  };
    # Colores Dracula
    extraConfig = ''
      include ~/.config/kitty/current-theme.conf
    '';
  };

  xdg.configFile."kitty/current-theme.conf".source = ../../static/kitty/current-theme.conf;

}

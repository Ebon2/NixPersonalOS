{ ... }:

{
  programs.rofi = {
    enable = true;
    # terminal = "kitty";

    # Aplica el tema catppuccin que tienes en static/rofi/themes/
    theme = "~/.config/rofi/themes/catppuccin.rasi";
    # O bien: tema inline
  };

  # Enlaza toda la carpeta rofi de static (incluye temas y config.rasi)
  xdg.configFile."rofi" = {
    source    = ../../static/rofi;
    recursive = true;
  };

  # Wofi-power
  xdg.configFile."wofi-power" = {
    source    = ../../static/wofi-power;
    recursive = true;
  };
}

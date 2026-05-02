{ ... }:

# ─────────────────────────────────────────────────────────────────
# Waybar — dos opciones:
#
# OPCIÓN A (actual): enlaza static/waybar/ completo.
#   Editas modules.jsonc y style.css directamente, como siempre.
#
# OPCIÓN B (declarativa): migra config/modules a programs.waybar.settings
#   Más verboso pero todo en Nix.
# ─────────────────────────────────────────────────────────────────

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;  # Activa si prefieres systemd user service

    # OPCIÓN B — descomenta y borra el xdg.configFile de abajo:
    # style  = builtins.readFile ../../static/waybar/style.css;
    # settings = [ (builtins.fromJSON (builtins.readFile ../../static/waybar/modules.jsonc)) ];
  };

  # OPCIÓN A — enlaza los estáticos tal cual
  xdg.configFile."waybar" = {
    source    = ../../static/waybar;
    recursive = true;
  };
}

{ pkgs, ... }:

# ─────────────────────────────────────────────────────────────────
# Neovim — dos estrategias, elige una:
#
# ESTRATEGIA A (recomendada si tu init.lua es largo/complejo):
#   Enlaza static/nvim/ directamente con xdg.configFile.
#   Lazy.nvim sigue funcionando igual.
#
# ESTRATEGIA B:
#   Migra todo a programs.neovim en Nix puro (más declarativo
#   pero requiere reescribir los plugins en Nix).
#
# Por defecto usa Estrategia A. Cambia a B si quieres control total.
# ─────────────────────────────────────────────────────────────────

{
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;
    withRuby      = false;
    withPython3   = false;

    # Paquetes de sistema que neovim necesita (LSPs, formatters, etc.)
    extraPackages = with pkgs; [
      # LSPs — descomenta los que uses:
      lua-language-server
      nil               # Nix LSP
      rust-analyzer
      jdt-language-server  # Java
      pyright

      # Herramientas
      ripgrep    # Para telescope
      fd         # Para telescope
      tree-sitter
      nodejs     # Para algunos plugins
    ];
  };

  # ── Estrategia A: enlaza static/nvim/ ─────────────────────────
  # El init.lua de static/ se enlaza a ~/.config/nvim/
  # Lazy.nvim descarga y gestiona los plugins como siempre.
  xdg.configFile."nvim" = {
    source    = ../../static/nvim;
    recursive = true;   # Enlaza el directorio completo
  };

  # ── Estrategia B: config inline ───────────────────────────────
  # Descomenta esto y comenta la sección de arriba si prefieres
  # tener la config en Nix:
  #
  # programs.neovim.extraLuaConfig = builtins.readFile ../../static/nvim/init.lua;
}

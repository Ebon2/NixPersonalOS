{ pkgs, ... }:

# ─────────────────────────────────────────────────────────────────
# Miscelánea — programas pequeños configurados via programs.*
# ─────────────────────────────────────────────────────────────────

{
  # ── Btop ───────────────────────────────────────────────────────
  programs.btop = {
    enable = true;
    # La config de static/btop/btop.conf se migra aquí
    settings = {
      color_theme      = "Default";
      theme_background = true;
      vim_keys         = true;
      update_ms        = 2000;
      proc_sorting     = "cpu lazy";
      proc_tree        = false;
    };
  };

  # ── Fastfetch ──────────────────────────────────────────────────
  # Usamos xdg.configFile para enlazar el jsonc existente
  xdg.configFile."fastfetch/config.jsonc".source = ../../static/fastfetch/config.jsonc;

  # ── Atuin ──────────────────────────────────────────────────────
  programs.atuin = {
    enable         = true;
    enableFishIntegration = false; # Lo hacemos manual en fish.nix para evitar doble init
    settings = {
      auto_sync    = true;
      sync_frequency = "5m";
      search_mode  = "fuzzy";
    };
  };

  # ── Starship (prompt — alternativa al prompt custom de fish) ───
  # Descomenta si prefieres starship en vez del prompt manual de fish.nix
   programs.starship = {
    enable = true;

    settings = {
      add_newline = false;

      format = "$directory$git_branch$git_status$nodejs$python$rust\n$character";
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };

      directory = {
        style = "cyan bold";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        symbol = " ";
        style = "magenta bold";
      };

      git_status = {
        style = "red";
        conflicted = "💥";
        modified = "";
        staged = "✓";
        untracked = "?";
      };

      nodejs = {
        symbol = "⬢ ";
        style = "green";
      };

      python = {
        symbol = "🐍 ";
        style = "yellow";
      };

      rust = {
        symbol = "🦀 ";
        style = "orange";
      };
    };
  };


  # ── Ranger ─────────────────────────────────────────────────────
  # Los configs de static/ranger/ se enlazan directamente
  xdg.configFile."ranger" = {
    source    = ../../static/ranger;
    recursive = true;
  };

  # ── Rofi (config base) ─────────────────────────────────────────
  # El tema se gestiona en desktop/rofi.nix
  # Aquí enlazamos el config.rasi de static/ y los temas
  # (ver home/desktop/rofi.nix)

  # ── Wlogout ────────────────────────────────────────────────────
  xdg.configFile."wlogout" = {
    source    = ../../static/wlogout;
    recursive = true;
  };

  # ── Waypaper ───────────────────────────────────────────────────
  xdg.configFile."waypaper/config.ini".source = ../../static/waypaper/config.ini;
  xdg.configFile."cava/config".source = ../../static/cava/config;
}

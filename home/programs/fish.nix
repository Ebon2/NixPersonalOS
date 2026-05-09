{ pkgs, ... }:

# ─────────────────────────────────────────────────────────────────
# Fish Shell — gestionado por Home Manager
#
# Las funciones de static/fish/functions/ se migran aquí.
# Home Manager genera ~/.config/fish/config.fish y las funciones
# automáticamente — NO edites esos archivos a mano.
# ─────────────────────────────────────────────────────────────────

{
  programs.fish = {
    enable = true;

    # ── Greeting ────────────────────────────────────────────────
    interactiveShellInit = ''
      set -g fish_greeting
      fastfetch

      # Atuin — historia sincronizada (desactivado dentro de nix-shell)
      if not set -q IN_NIX_SHELL
        atuin init fish | source
      end

      # Kitty shell integration
      if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION no-rc
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
      end
    '';

    # ── Variables ───────────────────────────────────────────────
    shellInit = ''
      set -gx DIRENV_LOG_FORMAT ""
      set -gx DIRENV_LOG_LEVEL off
    '';

    # ── Aliases ─────────────────────────────────────────────────
    shellAliases = {
      # Nix
      nrb   = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      nrbt  = "sudo nixos-rebuild test --flake /etc/nixos#nixos";
      ngen  = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      ngc   = "sudo nix-collect-garbage -d";
      nupd  = "nix flake update /etc/nixos";

      # Herramientas
      ls    = "ls --color=auto";
      ll    = "ls -la --color=auto";
      cat   = "bat";
      grep  = "grep --color=auto";
      vim   = "nvim";
      fm    = "Y";
    };

    # ── Funciones (migradas de static/fish/functions/) ───────────
    functions = {

      # Prompt personalizado
      fish_prompt = {
        body = ''
          set -l last_status $status
          set -l cwd (prompt_pwd)

          if test $last_status -ne 0
            set status_indicator (set_color red)"✗ "
          else
            set status_indicator (set_color green)"✓ "
          end

          echo -n (set_color cyan)"[" (set_color yellow)$USER (set_color normal)"@" (set_color magenta)(hostname) (set_color cyan)"]" (set_color blue)" $cwd " $status_indicator (set_color normal)
          echo ""
          echo -n (set_color cyan)"❯ " (set_color normal)
        '';
      };

      # Reloj en terminal
      clock = {
        body = "clock-rs -t -s";
      };

      # Montar dispositivo
      mnt = {
        body = ''
          if test (count $argv) -lt 2
            echo "Uso: mnt <dispositivo> <punto_de_montaje>"
            return 1
          end
          sudo mount $argv[1] $argv[2]
          echo "Montado $argv[1] en $argv[2]"
        '';
      };

      # Desmontar
      umnt = {
        body = ''
          if test (count $argv) -lt 1
            echo "Uso: umnt <punto_de_montaje>"
            return 1
          end
          sudo umount $argv[1]
          echo "Desmontado $argv[1]"
        '';
      };

      # Ver espacio de montajes
      mnt-space = {
        body = "df -h | grep -v tmpfs | grep -v udev";
      };

      # Abrir imagen en kitty
      icat = {
        body = "kitty +kitten icat $argv";
      };

      # Rebuild NixOS
      Nix_Rebuild_System = {
        body = ''
          echo "Rebuilding NixOS..."
          sudo nixos-rebuild switch --flake /etc/nixos#nixos $argv
        '';
      };

      # Ver generaciones
      Nix_See_Generations = {
        body = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      };

      # Perfiles de energía
      Power_Performance = {
        body = "sudo powerprofilesctl set performance && echo 'Modo: Performance'";
      };

      Power_Balanced = {
        body = "sudo powerprofilesctl set balanced && echo 'Modo: Balanced'";
      };

      Power_Saver = {
        body = "sudo powerprofilesctl set power-saver && echo 'Modo: Power Saver'";
      };

      Power_Get = {
        body = "powerprofilesctl get";
      };

      # Temperatura CPU
      Temp = {
        body = "sensors | grep 'Core\\|Tdie'";
      };

      # CAVA en terminal
      CAVA = {
        body = "kitty --class cava-term -e cava &";
      };

      # Svim — sudo nvim
      Svim = {
        body = "sudo -E nvim $argv";
      };

      # Compilar C rápido
      CRun = {
        body = ''
          if test (count $argv) -lt 1
            echo "Uso: CRun <archivo.c> [args...]"
            return 1
          end
          set -l src $argv[1]
          set -l out /tmp/(basename $src .c)
          gcc -O2 -o $out $src && $out $argv[2..-1]
        '';
      };

      Y = {
        body = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")

          yazi $argv --cwd-file = "$tmp"

          if test -f "$tmp"
              set cwd (cat "$tmp")

              if test -n "$cwd"; and test "$cwd" != "$PWD"
                  cd "$cwd"
              end
          end

          rm -f "$tmp"
        '';
      };
      
      mi_funcion = {
        body = ''
          echo "Hola desde fish"
          $argv
        '';
      };
    };

    # ── Colores Dracula ──────────────────────────────────────────
    # (Equivalente a static/fish/conf.d/fish_frozen_theme.fish)
    plugins = [
      # Si quieres instalar plugins via fisherman/fisher:
      # { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];
  };

  # ── Colores del tema (via home.file para fish_variables) ───────
  # Los colores Dracula se configuran directamente en interactiveShellInit
  # o puedes usar xdg.configFile para copiar fish_variables:
  xdg.configFile."fish/fish_variables".source = ../../static/fish/fish_variables;
}

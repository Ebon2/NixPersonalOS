{ pkgs, userConfig, ... }:
{
  programs.fish = {
    enable = true;

    # ── PATH de usuario ─────────────────────────────────────────
    # Antes estaba en fish_variables (universal) — ahora en shellInit
    shellInit = ''
      fish_add_path ~/.local/bin
      fish_add_path ~/.local/share/JetBrains/Toolbox/scripts

      set -gx DIRENV_LOG_FORMAT ""
      set -gx DIRENV_LOG_LEVEL off

      # ── Tema Matrix ─────────────────────────────────────────
      set --global fish_color_normal        c8ffc8
      set --global fish_color_command       00ff41
      set --global fish_color_keyword       39ff14
      set --global fish_color_quote         7abf7a
      set --global fish_color_redirection   00cc33
      set --global fish_color_end           00e676
      set --global fish_color_error         ff3333
      set --global fish_color_param         c8ffc8
      set --global fish_color_comment       3d5c3d
      set --global fish_color_operator      00ff41
      set --global fish_color_escape        00ffcc
      set --global fish_color_autosuggestion 1a331a
      set --global fish_color_valid_path    --underline
      set --global fish_color_search_match  --background=0f3a0f
      set --global fish_color_selection     --background=0f3a0f
      set --global fish_color_cancel        ff3333 --reverse
      set --global fish_color_option        b8ff00
      set --global fish_color_host          00ff41
      set --global fish_color_user          39ff14
      set --global fish_color_cwd           00cc33
      set --global fish_color_status        ff3333
      set --global fish_pager_color_prefix          00ff41
      set --global fish_pager_color_completion      c8ffc8
      set --global fish_pager_color_description     3d5c3d
      set --global fish_pager_color_progress        3d5c3d
      set --global fish_pager_color_selected_prefix 00ff41
      set --global fish_pager_color_selected_completion c8ffc8
      set --global fish_pager_color_selected_background --background=0f3a0f
      set --global fish_pager_color_selected_description 7abf7a
    '';

    # ── Greeting ────────────────────────────────────────────────
    interactiveShellInit = ''
      set -g fish_greeting
      fastfetch

      if not set -q IN_NIX_SHELL
        atuin init fish | source
      end

      if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION no-rc
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
      end
    '';

    # ── Aliases ─────────────────────────────────────────────────
    shellAliases = {
      nrb  = "sudo nixos-rebuild switch --flake ~/nixos_config#nixos";
      nrbt = "sudo nixos-rebuild test --flake ~/nixos_config#nixos";
      ngen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      ngc  = "sudo nix-collect-garbage -d";
      nupd = "nix flake update ~/nixos_config";
      ls   = "ls --color=auto";
      ll   = "ls -la --color=auto";
      cat  = "bat";
      grep = "grep --color=auto";
      vim  = "nvim";
      fm   = "Y";
      please = "sudo";
      FUCKING = "sudo";
      SYBAU = "sudo";
    };

    # ── Funciones ───────────────────────────────────────────────
    functions = {

      fish_prompt = {
        body = ''
          set -l last_status $status
          set -l cwd (prompt_pwd)

          if test $last_status -ne 0
            set status_indicator (set_color red)"✗ "
          else
            set status_indicator (set_color 00ff41)"✓ "
          end

          echo -n (set_color 00cc33)"[ "(set_color 39ff14)$USER(set_color c8ffc8)" @ "(set_color 00ff41)(hostname)(set_color 00cc33)" ] "(set_color 7abf7a)"$cwd "(set_color normal)$status_indicator(set_color normal)
          echo ""
          echo -n (set_color 00ff41)"❯ "(set_color normal)
        '';
      };

      clock       = { body = "clock-rs -t -s"; };
      icat        = { body = "kitty +kitten icat $argv"; };
      Svim        = { body = "sudo -E nvim $argv"; };
      Power_Get   = { body = "powerprofilesctl get"; };
      Temp        = { body = "sensors | grep 'Core\\|Tdie'"; };
      mnt-space   = { body = "df -h | grep -v tmpfs | grep -v udev"; };

      CAVA = { body = "kitty --class cava-term -e cava &"; };

      Cmatrix = {
        body = ''
          kitty --title "Matrix" fish -c "
              kitty @ set-background-opacity 1.0;
              cmatrix;
              kitty @ set-background-opacity 0.75
          "
        '';
      };

      Power_Performance = { body = "sudo powerprofilesctl set performance && echo 'Modo: Performance'"; };
      Power_Balanced    = { body = "sudo powerprofilesctl set balanced && echo 'Modo: Balanced'"; };
      Power_Saver       = { body = "sudo powerprofilesctl set power-saver && echo 'Modo: Power Saver'"; };

      Nix_Rebuild_System    = { body = "sudo nixos-rebuild switch --flake ~/nixos_config#nixos"; };
      Nix_Test_Configuration = { body = "sudo nixos-rebuild test --flake ~/nixos_config#nixos --no-reexec"; };
      Nix_See_Generations   = { body = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system"; };

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
          yazi $argv --cwd-file="$tmp"
          if test -f "$tmp"
            set cwd (cat "$tmp")
            if test -n "$cwd"; and test "$cwd" != "$PWD"
              cd "$cwd"
            end
          end
          rm -f "$tmp"
        '';
      };
    };

    plugins = [];
  };
}
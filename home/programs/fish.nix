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
        zoxide init fish | source
      end

      if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION no-rc
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
      end
    '';

    # ── Aliases ─────────────────────────────────────────────────
    shellAliases = {
      nrb     = "sudo nixos-rebuild switch --flake ~/nixos_config#nixos";
      nrbt    = "sudo nixos-rebuild test --flake ~/nixos_config#nixos";
      ngen    = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      ngc     = "sudo nix-collect-garbage -d";
      nupd    = "nix flake update ~/nixos_config";
      ls      = "ls --color=auto";
      ll      = "ls -la --color=auto";
      cat     = "bat";
      Server  = "ssh angel@rojas-Server";
      grep    = "grep --color=auto";
      vim     = "nvim";
      fm      = "Y";
      please  = "sudo";
      FUCKING = "sudo";
      SYBAU   = "sudo";
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

      Cava = { body = "kitty --class cava-term -e cava &"; };

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
      Nix_Init_Labs = {
        body = ''
          set languajes jvm cpp python network reversing debug web go rust

          set flake_path ~/labs
          
          for l in $languajes
              nix develop "$flake_path#$l" \
                  --profile $flake_path/.profiles/$l \
                  --command echo "The $l laboratory as ready to use"
          end
        '';
      };
      Nix_Open_Lab = {
        body = ''
          set name NONE
          if set -q argv[1]
              set name (string lower $argv[1])
          end
          
          set program code 
          if set -q argv[2] 
              set program $argv[2]
          end
          
          set shell_path ~/labs/.profiles
          set lab_path ~/labs

          set OPEN_TERMINAL none 0 terminal
          
          set JAVA java jvm kt
          set CPP cpp c++ c
          set PY py python
          set NW nw network
          set RE re reversing
          set DB db debug
          set WEB web
          set GO go
          set RS rs rust
          
          switch $name
              case $JAVA
                  set languaje jvm
              case $CPP
                  set languaje cpp
              case $PY
                  set languaje python
              case $NW
                  set languaje network
              case $RE
                  set languaje reversing
              case $DB
                  set languaje debug
              case $WEB
                  set languaje web
              case $GO
                  set languaje go
              case $RS
                  set languaje rust

              case '*'
                  echo "Comando invalido"
                  echo "===== Posibles comandos ===== "
                  echo " - JVM $JAVA"
                  echo " - CPP $CPP"
                  echo " - PY $PY"
                  echo " - NETWORK $NW"
                  echo " - REVERSING $RE"
                  echo " - DEBUG $DB"
                  echo " - WEB $WEB"
                  echo " - GO $GO"
                  echo " - RUST $RS"
                  return 1
          end
          
          set base_command nix develop "$lab_path#$languaje" \
              --profile "$shell_path/$languaje"

          switch (string lower $program)
              case $OPEN_TERMINAL
                  $base_command
              case '*'
                  $base_command -c $program "$lab_path/$languaje"
                  exit
          end
        '';
      };

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

      No_Lock = {
        body = ''
          echo "Bloqueando suspensión por inactividad..."
            systemd-inhibit --what=idle:sleep \
                --who="No Lock" \
                --why="Suspensión temporal desactivada por el usuario" \
                sleep infinity &
            set inhibitor_pid $last_pid
            echo ""
            echo "Suspensión congelada. Escribe 'q' para restaurar."
            while true
                read -l input
                if test "$input" = q
                    break
                end
            end
            echo "Restaurando comportamiento normal..."
            kill $inhibitor_pid
            echo "Listo."
        '';
      };
    };

    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }

      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }

      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }

      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }

      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }

      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }
    ];
  };
}
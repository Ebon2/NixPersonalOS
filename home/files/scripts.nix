{ pkgs, ... }:

let
  mkScript = name: text:
    pkgs.writeShellApplication {
      inherit name text;
    };
in {
  home.packages = [
    (mkScript "nix-rs" ''
      sudo nixos-rebuild switch --flake ~/nixos_config#nixos
    '')

    (mkScript "nix-rt" ''
      sudo nixos-rebuild test --flake ~/nixos_config#nixos --no-reexec
    '')

    (mkScript "nix-gen" ''
      sudo nix-env \
        --list-generations \
        --profile /nix/var/nix/profiles/system
    '')

    (mkScript "nix-gc" ''
      sudo nix-collect-garbage -d
    '')

    (mkScript "nix-up" ''
      nix flake update --flake ~/nixos_config
    '')

    (mkScript "nix-install-temp" ''
      nix shell nixpkgs#"$1"
    '')

    (mkScript "nix-il" ''
      languages=("jvm" "cpp" "python" "network" "reversing" "debug" "web" "go" "rust")

      flake_path="$HOME/labs"

      for l in "''${languages[@]}"; do
        nix develop "$flake_path#$l" \
          --profile "$flake_path/.profiles/$l" \
          --command true
      done
    '')

    (mkScript "nix-ol" ''
      set -euo pipefail

      name="''${1:-none}"
      program="''${2:-code}"

      name="''${name,,}"
      program="''${program,,}"

      shell_path="$HOME/labs/.profiles"
      lab_path="$HOME/labs"

      OPEN_TERMINAL=("none" "0" "terminal")

      contains() {
          local val="$1"; shift
          for item in "$@"; do
              [[ "$item" == "$val" ]] && return 0
          done
          return 1
      }

      resolve_lang() {
          case "$1" in
              java|jvm|kt) echo "jvm" ;;
              cpp|c++|c) echo "cpp" ;;
              py|python) echo "python" ;;
              nw|network) echo "network" ;;
              re|reversing) echo "reversing" ;;
              db|debug) echo "debug" ;;
              web) echo "web" ;;
              go) echo "go" ;;
              rs|rust) echo "rust" ;;
              *)
                  echo ""
                  return 1
              ;;
          esac
      }

      language="$(resolve_lang "$name")"

      if [[ -z "$language" ]]; then
          echo "Comando invalido"
          echo "Opciones: java/cpp/python/network/reversing/debug/web/go/rust"
          exit 1
      fi

      base_cmd=(
          nix develop "$lab_path#$language"
          --profile "$shell_path/$language"
      )

      # -----------------------------
      # MODOS
      # -----------------------------

      # 1. Solo entrar al entorno
      if [[ -z "$program" ]]; then
          exec "''${base_cmd[@]}"

      # 2. Abrir terminal/editor “neutral”
      elif contains "$program" "''${OPEN_TERMINAL[@]}"; then
          exec "''${base_cmd[@]}"

      # 3. Ejecutar programa dentro del entorno
      else
          exec "''${base_cmd[@]}" --command bash -lc "$program $lab_path/$language" 
      fi
    '')

    (mkScript "matrix" ''
      kitty --title "Matrix" fish -c "
        kitty @ set-background-opacity 1.0;
        cmatrix;
        kitty @ set-background-opacity 0.75
      "
    '')

    (mkScript "game-launch" ''
      exec gamescope \
        -f \
        -F fsr \
        -w 1920 -h 1200 \
        -- mangohud gamemoderun "$@"
    '')
    
    (mkScript "mode-saver" ''
      sudo powerprofilesctl set power-saver && echo 'Mode: saver'
    '')
    (mkScript "mode-performance" ''
      sudo powerprofilesctl set performance && echo 'Mode: Performance'
    '')
    (mkScript "mode-balanced" ''
      sudo powerprofilesctl set balanced && echo 'Mode: balanced'
    '')
    (mkScript "get-mode" ''
      powerprofilesctl get
    '')
    
  ];
}

{ pkgs, ... }:

let mkScript = name: text:
  pkgs.writeShellScriptBin name text;

in {
  home.packages = [
    (mkScript "Nix_RB" ''
      sudo nixos-rebuild switch --flake ~/nixos_config#nixos
    '')

    (mkScript "Nix_RBT" ''
      sudo nixos-rebuild test --flake ~/nixos_config#nixos --no-reexec
    '')

    (mkScript "Nix_Gen" ''
      sudo nix-env \
        --list-generations \
        --profile /nix/var/nix/profiles/system
    '')

    (mkScript "Nix_GC" ''
      sudo nix-collect-garbage -d
    '')

    (mkScript "Nix_Up" ''
      nix flake update ~/nixos_config
    '')

    (mkScript "Cmatrix" ''
      kitty --title "Matrix" fish -c "
        kitty @ set-background-opacity 1.0;
        cmatrix;
        kitty @ set-background-opacity 0.75
      "
    '')
  ];
}
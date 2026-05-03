function Nix_Rebuild_System --description="Rebuild NixOS con flakes"
    cd /etc/nixos
    sudo nixos-rebuild switch --flake .#nixos
    
end

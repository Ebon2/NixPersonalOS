function Nix_Save_Configs
    cd ~/.config
    sudo rm -rf /etc/nixos/static
    sudo mkdir /etc/nixos/static/
    sudo cp -r atuin btop fastfetch fish hypr kitty ranger rofi waybar waypaper wlogout wofi-power nvim /etc/nixos/static/
    ~
end

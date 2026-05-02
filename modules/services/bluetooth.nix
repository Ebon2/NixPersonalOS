{ config, pkgs, ... }:

{
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;  # Características experimentales
      };
    };
  };

  # Blueman (GUI para Bluetooth en KDE/Hyprland)
  services.blueman.enable = true;

  # Paquetes adicionales de Bluetooth
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
  ];
}

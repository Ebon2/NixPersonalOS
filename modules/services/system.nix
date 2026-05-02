{ config, pkgs, lib, ... }:

{
  # Avahi - mDNS/DNS-SD (descubrimiento de servicios en red local)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # Time synchronization
  services.timesyncd.enable = lib.mkDefault true;

  # Trim para SSDs (mejora rendimiento)
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Thermald (gestión térmica para Intel - comenta si usas AMD)
  # services.thermald.enable = true;

  # Fwupd - Firmware updates
  services.fwupd.enable = true;

  # Locate database (búsqueda rápida de archivos)
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "hourly";
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Optimizar store
  nix.settings = {
    auto-optimise-store = true;
  };
}

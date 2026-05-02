{ config, pkgs, ... }:

{
  # CUPS - Sistema de impresión
  services.printing = {
    enable = true;
    
    # Drivers adicionales
    drivers = with pkgs; [
      # gutenprint      # Drivers genéricos
      # hplip           # HP
      # epson-escpr     # Epson
      # brlaser         # Brother
      # samsung-unified-linux-driver  # Samsung
    ];
  };

  # Descubrimiento automático de impresoras en red
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Paquetes útiles para impresión
  environment.systemPackages = with pkgs; [
    # system-config-printer  # GUI para configurar impresoras
  ];
}

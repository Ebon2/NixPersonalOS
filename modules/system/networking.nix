{ config, pkgs, ... }:

{
  # Nombre del host
  networking.hostName = "nixos";

  # NetworkManager (recomendado para desktop)
  networking.networkmanager.enable = true;

  # ===== WIFI (descomenta si prefieres wpa_supplicant) =====
  # networking.wireless.enable = true;
  # networking.wireless.networks = {
  #   "TU-RED-WIFI" = {
  #     psk = "tu-contraseña";
  #   };
  # };

  # Configuración de proxy (si lo necesitas)
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Firewall
  networking.firewall = {
    enable = true;
    # Abre puertos específicos si los necesitas
     allowedTCPPorts = [ 53317 80 443 ];
     allowedUDPPorts = [ 53317 ];
  };

  # DNS personalizado (opcional)
  # networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Habilitar SSH (descomenta si lo necesitas)
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;  # Solo con llaves
      PermitRootLogin = "no";
    };
  };
}

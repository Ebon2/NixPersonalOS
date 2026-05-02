{ config, pkgs, ... }:

{
  # Tailscale - VPN mesh network
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";  # Permite routing y exit nodes
  };

  # Abrir puerto para Tailscale
  networking.firewall = {
    checkReversePath = "loose";  # Necesario para Tailscale
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # Para usar Tailscale después de instalar:
  # sudo tailscale up
  # sudo tailscale status
}

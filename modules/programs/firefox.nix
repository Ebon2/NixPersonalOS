{ config, pkgs, ... }:

{
  # Habilitar Firefox
  programs.firefox = {
    enable = true;
    
    # Preferencias por defecto (opcional)
    # preferences = {
    #   "browser.startup.homepage" = "https://nixos.org";
    #   "browser.search.defaultenginename" = "DuckDuckGo";
    #   "browser.urlbar.placeholderName" = "DuckDuckGo";
    #   "privacy.trackingprotection.enabled" = true;
    # };

    # Políticas empresariales (opcional)
    # policies = {
    #   DisableTelemetry = true;
    #   DisableFirefoxStudies = true;
    #   DontCheckDefaultBrowser = true;
    #   DisablePocket = true;
    # };
  };

  # Paquetes relacionados con navegación
  environment.systemPackages = with pkgs; [
    # Navegadores alternativos
    # chromium
    # google-chrome
    # brave
    # vivaldi
    
    # Extensiones útiles (algunas requieren configuración manual)
    # firefox-addons.ublock-origin
    # firefox-addons.bitwarden
  ];
}

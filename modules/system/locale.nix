{ config, pkgs, ... }:

{
  # Zona horaria
  time.timeZone = "America/Mexico_City";

  # Configuración regional
  i18n.defaultLocale = "es_MX.UTF-8";

  # Locales adicionales (si necesitas inglés u otros)
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_MX.UTF-8";
    LC_IDENTIFICATION = "es_MX.UTF-8";
    LC_MEASUREMENT = "es_MX.UTF-8";
    LC_MONETARY = "es_MX.UTF-8";
    LC_NAME = "es_MX.UTF-8";
    LC_NUMERIC = "es_MX.UTF-8";
    LC_PAPER = "es_MX.UTF-8";
    LC_TELEPHONE = "es_MX.UTF-8";
    LC_TIME = "es_MX.UTF-8";
  };

  # Configuración del teclado para la consola (TTY)
  console = {
    keyMap = "la-latin1";  # Layout latinoamericano
    # font = "Lat2-Terminus16";  # Descomenta para cambiar la fuente de la consola
  };
}

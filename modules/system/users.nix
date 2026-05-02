{ config, pkgs, ... }:

{
  # Define tu usuario principal
  users.users.angel = {
    isNormalUser = true;
    description = "username";
    
    # Grupos importantes:
    # - wheel: permite usar sudo
    # - networkmanager: gestionar redes
    # - video: acceso a dispositivos de video
    # - audio: acceso a dispositivos de audio
    # - docker: usar Docker sin sudo
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    
    # Paquetes específicos del usuario
    packages = with pkgs; [
      kdePackages.kate
      # Paquetes adicionales del usuario aquí
    ];

    # Shell por defecto - Fish
    shell = pkgs.fish;
  };

  # IMPORTANTE: Define tu contraseña con 'passwd' después de instalar
  # o configura hashedPassword aquí (genera con: mkpasswd -m sha-512)
  # users.users.angel.hashedPassword = "TU-HASH-AQUI";

  # Permitir sudo sin contraseña (CUIDADO, solo para testing)
  # security.sudo.wheelNeedsPassword = false;
}

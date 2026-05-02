{ config, pkgs, ... }:

{
  users.users.angel = {
    isNormalUser = true;
    description  = "username";
    extraGroups  = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    shell        = pkgs.fish;
    # Home Manager gestiona los dotfiles; no se necesita packages aquí
    # (úsalo solo para paquetes que dependan de privilegios del sistema)
  };

  # Genera la contraseña con: mkpasswd -m sha-512
  users.users.angel.hashedPassword = "HASHED_PASSWORD_AQUI";
}

{ userConfig, config, pkgs, ... }:

{
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description  = userConfig.description;
    extraGroups  = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    shell        = pkgs.fish;
    hashedPassword = userConfig.hashedPassword;
  };
  # Genera la contraseña con: mkpasswd -m sha-512
}

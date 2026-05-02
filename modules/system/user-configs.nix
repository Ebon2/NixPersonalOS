{ config, pkgs, lib, ... }:

let
  user = "angel";
  homeDir = "/home/${user}";
  staticPath = ../../static;
in
{
  # Copiar configs SOLO si no existen
  system.activationScripts.installUserConfigs = lib.mkAfter ''
    if [ -d "${homeDir}" ]; then
      mkdir -p ${homeDir}/.config
      mkdir -p ${homeDir}/Imágenes/Screenshots
      mkdir -p ${homeDir}/Temp

      for dir in hypr waybar fish kitty btop ranger waypaper rofi wlogout fastfetch atuin wofi-power nvim; do
        if [ ! -d "${homeDir}/.config/$dir" ]; then
          echo "Instalando $dir en .config"
          cp -r --no-preserve=mode,ownership ${staticPath}/$dir ${homeDir}/.config/ 
          chown -R ${user}:users ${homeDir}/.config/$dir
	  chmod -R u+rwX ${homeDir}/.config/$dir
        fi
      done

      chown -R ${user}:users ${homeDir}/.config
      chmod -R u+w ${homeDir}/.config
    fi
  '';
}

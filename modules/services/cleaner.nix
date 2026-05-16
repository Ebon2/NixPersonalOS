{ userConfig, config, pkgs, lib, ... }:
let
  user = userConfig.username;
in
{
  systemd.services.cleanup-temp = {
    description = "Limpia ~/Temp cada lunes a las 15:00";
    serviceConfig = {
      Type = "oneshot";
      User = user;
    };
    script = ''
      ${pkgs.findutils}/bin/find /home/${user}/Temp -mindepth 1 \
        ! -name "flake.nix" \
        ! -name ".envrc" \
        -delete
    '';
  };

  systemd.timers.cleanup-temp = {
    description = "Timer para limpiar ~/Temp";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Mon 15:00";
      Persistent = true;
    };
  };
}

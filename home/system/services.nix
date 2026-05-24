{ pkgs, inputs, ... }:

let
  mkApp =
    {
      name,
      pkg,
      target,
      bin ? name,
      autoStart ? true,
    }:
    {
      Unit = {
        Description = name;
        PartOf = [ "${target}.target" ];
      };

      Service = {
        ExecStart = "${pkg}/bin/${bin}";
        Restart = "on-failure";
      };
    }
    // (
      if autoStart then {
        Install.WantedBy = [
          "${target}.target"
        ];
      } else { }
    );

in
{
  systemd.user.services = {
    zapzap = mkApp {
      name = "ZapZap";
      pkg = pkgs.zapzap;
      target = "online";
    };

    spotify = mkApp {
      name = "Spotify";
      pkg = pkgs.spotify;
      target = "online";
    };

    brave = mkApp {
      name = "Brave";
      pkg = pkgs.brave;
      target = "online";
      autoStart = false;
    };

    zen = mkApp {
      name = "Zen";
      pkg = inputs.zen-browser.packages.${pkgs.system}.default;
      target = "online";
      autoStart = false;
    };

    discord = mkApp {
      name = "Vesktop";
      pkg = pkgs.vesktop;
      target = "gaming";
    };

    steam = mkApp {
      name = "Steam";
      pkg = pkgs.steam;
      target = "gaming";
    };

    code = mkApp {
      name = "VSC";
      pkg = pkgs.code;
      target = "work";
    };
  };
}
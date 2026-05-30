{ pkgs, config, ... }:
{
  home.packages = [ pkgs.swayosd ];

  services.swayosd = {
    enable    = true;
    topMargin = 0.9;
    stylePath = "${config.home.homeDirectory}/.config/swayosd/style.css";
  };

  xdg.configFile."swayosd/style.css".text = ''
    window {
        background-color: rgba(13, 15, 13, 0.88);
        border-radius: 30px;
        border: 1px solid rgba(0, 255, 65, 0.3);
        padding: 8px 16px;
    }

    progressbar {
        min-width: 200px;
        min-height: 6px;
    }

    progressbar > trough {
        border-radius: 4px;
        background-color: rgba(26, 51, 26, 0.8);
    }

    progressbar > trough > progress {
        border-radius: 4px;
        background-color: #00ff41;
        box-shadow: 0 0 6px rgba(0, 255, 65, 0.5);
    }

    image {
        color: #00ff41;
        margin: 0 8px;
    }

    label {
        color: #c8ffc8;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
    }
  '';
  home.file.".config/swayosd/.keep".text = "";

}
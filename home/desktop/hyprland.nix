{ pkgs, ... }:

# ─────────────────────────────────────────────────────────────────
# Hyprland — configuración del usuario via Home Manager
#
# wayland.windowManager.hyprland genera ~/.config/hypr/hyprland.conf
# a partir de los settings declarados aquí.
#
# ESTRATEGIA: los archivos de static/hypr/conf/ se enlazan tal cual.
# Hyprland los carga via "source =".  Esto te permite seguir editando
# keybinding.conf, window.conf, etc. directamente si quieres,
# o migrarlos a Nix gradualmente.
# ─────────────────────────────────────────────────────────────────

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;  # Integra con systemd --user (recomendado)

    settings = {
      # ── Monitor ───────────────────────────────────────────────
      # Descomenta y ajusta a tu monitor:
      # monitor = "DP-1,2560x1440@144,0x0,1";
      monitor = ",preferred,auto,1";  # Auto-detect

      # ── General ───────────────────────────────────────────────
      general = {
        gaps_in            = 5;
        gaps_out           = 10;
        border_size        = 2;
        "col.active_border"   = "rgba(bd93f9ff) rgba(ff79c6ff) 45deg";
        "col.inactive_border" = "rgba(44475aaa)";
        layout             = "dwindle";
      };

      # ── Autostart ─────────────────────────────────────────────
      exec-once = [
        "~/.config/hypr/scripts/xdg.sh"
        "systemctl --user start polkit-gnome-authentication-agent-1 || /run/current-system/sw/libexec/polkit-gnome-authentication-agent-1"
        "dunst"
        "~/.config/hypr/scripts/gtk.sh"
        "hypridle"
        "wl-paste --watch cliphist store"
        "awww-daemon"
        "sleep 1.5 && awww img ~/.config/hypr/wp.png --transition-type grow --transition-pos 0.5,0.5 --transition-duration 2 --transition-fps 60"
        "nm-applet --indicator"
        "blueman-applet"
        "hyprctl setcursor Qogir-dark 24"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];

      # ── Input ─────────────────────────────────────────────────
      input = {
        kb_layout = "us";
        # kb_variant = "intl";  # Para teclas con acentos
        follow_mouse        = 1;
        touchpad.natural_scroll = true;
        sensitivity         = 0;
      };

      # ── Dwindle layout ────────────────────────────────────────
      dwindle = {
        pseudotile    = true;
        preserve_split = true;
      };

      # ── Variables de entorno Wayland ──────────────────────────
      env = [
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "GDK_BACKEND,wayland,x11"
        "MOZ_ENABLE_WAYLAND,1"
        "MOZ_DBUS_REMOTE,1"
        "IDEA_USE_X11,1"
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "EDITOR,nvim"
        "TERMINAL,kitty"
        "NIXOS_OZONE_WL,1"
        "XCURSOR_THEME,Qogir-dark"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,Qogir-dark"
        "HYPRCURSOR_SIZE,24"
        "GTK_THEME,catppuccin-mocha-blue-standard"
      ];
    };

    # ── Configs extra (carga los archivos de static/hypr/conf/) ─
    # Esto se añade al final del hyprland.conf generado.
    extraConfig = ''
      # Carga todos los sub-configs (igual que tu hyprland.conf original)
      source = ~/.config/hypr/conf/monitor.conf
      source = ~/.config/hypr/conf/cursor.conf
      source = ~/.config/hypr/conf/keyboard.conf
      source = ~/.config/hypr/conf/window.conf
      source = ~/.config/hypr/conf/decoration.conf
      source = ~/.config/hypr/conf/layout.conf
      source = ~/.config/hypr/conf/misc.conf
      source = ~/.config/hypr/conf/keybinding.conf
      source = ~/.config/hypr/conf/animation.conf
      source = ~/.config/hypr/conf/intellij-flickering-fix.conf
      source = ~/.config/hypr/conf/electron-flickering-fix.conf
      source = ~/.config/hypr/conf/custom.conf
    '';
  };

  # ── Enlaza los archivos de static/hypr/ ───────────────────────
  # HM gestiona hyprland.conf; el resto lo enlazamos de static/
  xdg.configFile = {
    "hypr/conf".source          = ../../static/hypr/conf;
    "hypr/scripts".source       = ../../static/hypr/scripts;
    "hypr/hyprpaper.conf".source = ../../static/hypr/hyprpaper.conf;
    "hypr/hyprlock.conf".source  = ../../static/hypr/hyprlock.conf;
    "hypr/hypridle.conf".source  = ../../static/hypr/hypridle.conf;
    #"hypr/wp.png".source         = ../../static/hypr/wp.png;
    "hypr/wp.jpg".source         = ../../static/hypr/wp.jpg;
  };
}

{ pkgs, ... }:

# ─────────────────────────────────────────────────────────────────
# Firefox — gestionado completamente por Home Manager
#
# CÓMO AÑADIR EXTENSIONES
# ────────────────────────
# 1. Busca el ID en addons.mozilla.org → "Detalles técnicos"
#    o en: https://nur.nix-community.org/repos/rycee/
#
# 2. Añade al bloque extensions.packages:
#      pkgs.nur.repos.rycee.firefox-addons.<nombre>
#
# IDs conocidos (pkgs.nur.repos.rycee.firefox-addons.*):
#   ublock-origin      → bloqueador de anuncios
#   bitwarden          → gestor de contraseñas
#   sponsorblock       → salta patrocinios en YouTube
#   return-youtube-dislike
#   darkreader         → modo oscuro universal
#   vimium             → navegación teclado estilo vim
#   tree-style-tab     → pestañas verticales
#
# NOTA: Para usar NUR debes añadirlo como input en flake.nix:
#   nur.url = "github:nix-community/NUR";
# y pasarlo en specialArgs. Ver comentario al final.
# ─────────────────────────────────────────────────────────────────

{
  programs.firefox = {
    enable = true;
    configPath = "$XDG_CONFIG_HOME/mozilla/firefox";

    # ── Políticas (se aplican a nivel empresa, el usuario no puede cambiarlas) ──
    policies = {
      DisableTelemetry          = true;
      DisableFirefoxStudies     = true;
      DontCheckDefaultBrowser   = true;
      DisablePocket             = true;
      DisableFirefoxAccounts    = false;  # Pon true si no usas sync
      OverrideFirstRunPage      = "";
      OverridePostUpdatePage    = "";

      # Extensiones instaladas por políticas (no gestionadas por Nix,
      # pero se instalan automáticamente)
      # ExtensionSettings = {
      #   "uBlock0@raymondhill.net" = {
      #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      #     installation_mode = "force_installed";
      #   };
      # };
    };

    # ── Perfiles ──────────────────────────────────────────────────────────────
    profiles = {
      default = {
        id      = 0;
        name    = "default";
        isDefault = true;

        # ── Preferencias ────────────────────────────────────────
        settings = {
          # Página de inicio
          "browser.startup.homepage"        = "about:blank";
          "browser.newtabpage.enabled"      = false;

          # Búsqueda
          "browser.search.defaultenginename" = "DuckDuckGo";
          "browser.urlbar.placeholderName"   = "DuckDuckGo";

          # Privacidad
          "privacy.trackingprotection.enabled"              = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "network.cookie.cookieBehavior"                   = 1;

          # Rendimiento / Wayland
          "gfx.webrender.all"     = true;
          "media.ffmpeg.vaapi.enabled" = true;  # VA-API (aceleración AMD)

          # UI
          "browser.tabs.closeWindowWithLastTab" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Telemetría (ya la desactivamos en políticas, doble seguro)
          "datareporting.healthreport.uploadEnabled" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        };

        # ── Extensiones via NUR ─────────────────────────────────
        # Para activar, añade NUR al flake (ver abajo) y descomenta:
        #
        # extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        #   ublock-origin
        #   bitwarden
        #   sponsorblock
        #   darkreader
        #   return-youtube-dislike
        # ];

        # ── User Chrome (CSS custom) ────────────────────────────
        # userChrome = ''
        #   /* Oculta la barra de pestañas si usas tree-style-tab */
        #   #TabsToolbar { visibility: collapse !important; }
        # '';
      };

      # Puedes añadir más perfiles:
      # work = {
      #   id   = 1;
      #   name = "work";
      # };
    };
  };
}

# ─────────────────────────────────────────────────────────────────
# CÓMO AÑADIR NUR AL FLAKE
# En flake.nix, inputs:
#
#   nur = {
#     url = "github:nix-community/NUR";
#     inputs.nixpkgs.follows = "nixpkgs";
#   };
#
# En outputs → specialArgs: { inherit inputs nur; }
# En home-manager → extraSpecialArgs: { inherit inputs; nur = inputs.nur; }
#
# En home/programs/firefox.nix recibe nur como parámetro:
#   { pkgs, nur, ... }:
# ─────────────────────────────────────────────────────────────────

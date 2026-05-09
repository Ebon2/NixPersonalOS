{ pkgs, ... }:

# ── Thunar (file manager) ───────────────────────────────────────
{
  programs.thunar = {
    enable = true;

    plugins = with pkgs.xfce; [
      thunar-archive-plugin   # clic derecho → comprimir/extraer (como Dolphin)
      thunar-media-tags-plugin # metadatos de audio/video en propiedades
      thunar-volman            # automontaje de USB/discos (como Dolphin)
    ];
  };

  # Servicios necesarios para que las extensiones funcionen
  services.gvfs.enable = true;   # montaje de redes SMB, MTP, trash
  services.tumbler.enable = true; # thumbnails de imágenes, video, PDF

  xdg.configFile."Thunar/thunarrc".text = ''
    [Configuration]
    DefaultView=ThunarDetailsView
    LastShowHidden=FALSE
    LastSidebarWidth=200
    LastSortColumn=THUNAR_COLUMN_NAME
    LastSortOrder=GTK_SORT_ASCENDING
    MiscShowDeleteAction=TRUE
    MiscMiddleClickInTabsOpensFolder=TRUE
    MiscTabsOpenNewWindow=FALSE
    MiscSingleClick=FALSE
    SidebarVisible=TRUE
    StatusbarVisible=TRUE
    LocationBarVisible=TRUE
    ShortcutsIconSize=GTK_ICON_SIZE_SMALL_TOOLBAR
  '';
}
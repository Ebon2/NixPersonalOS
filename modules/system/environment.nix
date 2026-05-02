{ config, pkgs, ... }:

{
  # Variables de entorno globales del sistema
  environment.sessionVariables = {
    # Editor por defecto
    EDITOR = "nvim";
    VISUAL = "nvim";
    
    # Browser por defecto
    BROWSER = "brave";
    
    # GTK configuración
    GTK2_RC_FILES = "$HOME/.gtkrc-2.0:$HOME/.config/gtkrc-2.0";
    
    # XDG Base Directory
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    
    # Qt configuración
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_WAYLAND_RECONNECT = "1";
    
    # Para aplicaciones Electron en Wayland
    NIXOS_OZONE_WL = "1";
    
    # Color support
    COLORTERM = "truecolor";
    
    # Java Toolbox path (se agrega automáticamente al PATH)
    # El PATH ya incluye ~/.local/share/JetBrains/Toolbox/scripts
  };

  # Agregar paths al PATH del sistema
  environment.systemPackages = [ pkgs.bash ];  # Asegurar bash disponible
  
  # Variables de sesión específicas para cada shell
  programs.fish.shellInit = ''
    # Fish-specific configuration
    set -gx SHELL ${pkgs.fish}/bin/fish
    
    # Add JetBrains Toolbox to PATH
    fish_add_path $HOME/.local/share/JetBrains/Toolbox/scripts
  '';

  programs.zsh.shellInit = ''
    # ZSH-specific configuration
    export SHELL=${pkgs.zsh}/bin/zsh
    
    # Add JetBrains Toolbox to PATH
    export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"
  '';

  # Bash
  programs.bash.shellInit = ''
    # Bash-specific configuration
    export SHELL=${pkgs.bash}/bin/bash
    
    # Add JetBrains Toolbox to PATH
    export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"
  '';
}

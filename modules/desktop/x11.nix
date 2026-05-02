{ config, pkgs, ... }:

{
  # Habilitar el servidor X11
  services.xserver = {
    enable = true;

    # Configuración del teclado en X11
    xkb = {
      layout = "latam";
      variant = "deadtilde";
      # options = "grp:alt_shift_toggle";  # Cambiar layout con Alt+Shift
    };

    # Touchpad (para laptops)
    # libinput.enable = true;
    # libinput.touchpad = {
    #   tapping = true;
    #   naturalScrolling = true;
    #   disableWhileTyping = true;
    # };

    # Driver de video - CONFIGURADO EN hardware/amd-gpu.nix
    # Los videoDrivers se configuran en el módulo específico de GPU
    deviceSection = '' 
      Option "TearFree" "true"
      Option "DRI" "3"
      Option "VariableRefresh" "true"
    '';
    
  };

    services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  boot.initrd.kernelModules = [ "amdgpu" ];

  # Aceleración de hardware para video
  # Esto se configura en hardware/amd-gpu.nix para AMD
  # Para Intel o NVIDIA, crea módulos similares
}

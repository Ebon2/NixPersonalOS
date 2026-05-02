{ config, pkgs, lib, ... }:

{
  # ===== CONFIGURACIÓN DE VM (VirtualBox) =====
  # Descomenta esta sección para usar en la VM
  # boot.loader.grub = {
  #   enable = true;
  #   device = "/dev/sda";  # Disco de la VM
  #   useOSProber = true;
  # };

  # ===== CONFIGURACIÓN PARA PC REAL =====
  
  # ===== OPCIÓN 1: DUAL BOOT con Windows (RECOMENDADO) =====
  # Usa GRUB con os-prober para detectar Windows automáticamente
#  boot.loader.grub = {
#    enable = false;
#    device = "nodev";          # No instalar en MBR
#    efiSupport = true;         # Soporte UEFI
#    useOSProber = true;        # ← CRÍTICO: Detecta Windows y otros OS
#    efiInstallAsRemovable = false;
#  };

#  boot.loader.systemd-boot.enable = true;

 
#  boot.loader.efi = {
#    canTouchEfiVariables = true;
#    efiSysMountPoint = "/boot";
#  };

  # ===== OPCIÓN 2: Solo NixOS (sin Windows) =====
  # Si NO tienes Windows o quieres usar systemd-boot
  # Comenta la sección de arriba y descomenta esta:
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ===== OPCIÓN 3: BIOS Legacy (PCs antiguos) =====
  # boot.loader.grub = {
  #   enable = true;
  #   device = "/dev/sda";  # Tu disco principal
  #   useOSProber = true;
  # };

  # Configuraciones adicionales de boot
  boot.tmp.cleanOnBoot = true;
  boot.kernelParams = [
    # Descomenta según necesites:
    # "quiet"           # Menos logs en boot
    # "splash"          # Mostrar splash screen
    # "nomodeset"       # Si tienes problemas con drivers de video
  ];

  swapDevices = [{
    device = "/swapfile";
    size = 8192;
  }];

  boot.kernel.sysctl = {
    "user.max_user_namespaces" = 1048576;  
    "user.max_mnt_namespaces" = 1048576;
    "user.max_pid_namespaces" = 1048576;
    "user.max_net_namespaces" = 1048576;
    "user.max_uts_namespaces" = 1048576;
    "user.max_ipc_namespaces" = 1048576;
    "user.max_cgroup_namespaces" = 1048576;
    "user.max_time_namespaces" = 1048576;
    
    "kernel.unprivileged_userns_clone" = 1;
  };

  security.pam.loginLimits = [
    {
      domain = "angel";
      type = "soft";
      item = "nproc";
      value = "1048576";
    }
    {
      domain = "angel";
      type = "hard";
      item = "nproc";
      value = "1048576";
    }
  ];
  
  systemd.services.ollama.serviceConfig = {
    DynamicUser    = lib.mkOverride 0 false;
    User           = lib.mkOverride 0 "ollama";
    Group          = lib.mkOverride 0 "ollama";
    ReadWritePaths = lib.mkOverride 0 [ "/var/lib/ollama" ];
    ProtectHome    = lib.mkOverride 0 false;
  };

  users.users.ollama = {
    isSystemUser = true;
    group        = "ollama";
    home         = "/var/lib/ollama";
    createHome   = true;
    description  = "Ollama service user";
  };
  users.groups.ollama = {};

  # Cambia "angel" por tu usuario real
  users.users.angel.extraGroups = [ "ollama" ];

  systemd.tmpfiles.rules = [
    "d /var/lib/ollama        0755 ollama ollama -"
    "d /var/lib/ollama/models 0775 ollama ollama -"
  ];

  boot.enableContainers = true;

}

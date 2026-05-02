{ config, pkgs, ... }:

{
  # === DRIVERS AMD GPU ===
  
  # Habilitar drivers AMDGPU (open source)
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Hardware acceleration y Vulkan
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Para juegos de 32 bits
    
    extraPackages = with pkgs; [
#      amdvlk           # Vulkan driver AMD oficial
#      rocmPackages.clr.icd  # OpenCL
      vulkan-validation-layers
    ];
    
    # Para aplicaciones de 32 bits (gaming)
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-validation-layers
    ];
  };

#  hardware.amdgpu.amdvlk.enable = true;
#  hardware.amdgpu.amdvlk.support32Bit.enable = true;
 
 # Seleccionar driver Vulkan por defecto
  # Opción 1: AMDVLK (driver oficial AMD)
#  environment.variables.AMD_VULKAN_ICD = "RADV";
  
  # Opción 2: RADV (driver Mesa - recomendado para gaming)
   environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

  # Variables de entorno para AMD
  environment.sessionVariables = {
    # Force RADV (recomendado para gaming)
    AMD_VULKAN_ICD = "RADV";
    
    # Habilitar Vulkan layers
    # VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
  };

  # Paquetes útiles para AMD
  environment.systemPackages = with pkgs; [
    # Monitoring
    amdgpu_top       # Monitor en tiempo real
    radeontop        # Alternativa
    
    # Tools
    clinfo           # Info OpenCL
    vulkan-tools     # vulkaninfo, vkcube
    
    # ROCm (para compute/ML - opcional)
    # rocmPackages.rocm-smi
  ];

  # Overclock/Undervolt (CoreCtrl o similar)
  # programs.corectrl = {
  #   enable = true;
  #   gpuOverclock.enable = true;
  # };
  # users.users.angel.extraGroups = [ "corectrl" ];

  # NOTAS:
  # - RADV (Mesa): Mejor para gaming, más maduro
  # - AMDVLK: Driver oficial AMD, puede ser mejor para workstation
  # - Para cambiar entre drivers, usa AMD_VULKAN_ICD variable
}

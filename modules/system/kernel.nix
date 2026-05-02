{ config, pkgs, ... }:

{
  # Kernel por defecto: Linux LTS (Long Term Support)
  # Más estable y con soporte extendido
#  boot.kernelPackages = pkgs.linuxPackages;  # LTS

  # ===== KERNEL ZEN =====
  # Optimizado para desktop con mejores tiempos de respuesta.
  #
  # NOTA (abril 2026): linuxPackages_zen apunta a la rama 6.19.x.
  # VirtualBox 7.2.6 no compila contra 6.19 sin el patch de
  # virtualbox.nix (ver modules/services/virtualbox.nix).
  # Si el patch inline falla, usa el fallback de abajo.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # ===== FALLBACK: Zen 6.12 (última rama estable compatible con VBox) =====
  # Si el patch de 6.19 da problemas, comenta la línea de arriba
  # y descomenta esta:
  # boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Otros kernels disponibles:
  # pkgs.linuxPackages_latest     # Última versión estable
  # pkgs.linuxPackages_hardened   # Enfocado en seguridad
  # pkgs.linuxPackages_xanmod     # Otra opción optimizada para desktop

  # Módulos del kernel a cargar
  boot.kernelModules = [
    # Agrega módulos específicos aquí si los necesitas
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    # Paquetes extra del kernel (como drivers adicionales)
    # Ejemplo: cuando agregues drivers NVIDIA, AMD, etc.
  ];

  # Parámetros del kernel
  boot.kernel.sysctl = {
    # Optimizaciones de red
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";
    
    # Configuración de swap (ajusta según tu RAM)
    "vm.swappiness" = 10;  # Usar menos swap (útil con mucha RAM)
    
    # Seguridad
    "kernel.dmesg_restrict" = true;
  };
}

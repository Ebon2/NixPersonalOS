{ config, pkgs, lib, ... }:

# ===== VIRTUALBOX CON KERNEL ZEN (incluyendo 6.19) =====
#
# PROBLEMA (abril 2026):
#   VirtualBox 7.2.6 NO compila contra kernel 6.19.x (zen incluido)
#   porque el commit 6276c67 del kernel 6.19 movió los símbolos
#   cr4_update_irqsoff, cr4_read_shadow y __flush_tlb_all al namespace
#   privado de KVM (module:kvm,kvm-amd,kvm-intel). Los módulos
#   out-of-tree no pueden importarlo directamente.
#
#   Rastreado en:
#     https://github.com/VirtualBox/virtualbox/issues/467
#     https://github.com/NixOS/nixpkgs/issues/491434
#
# SOLUCIÓN:
#   Overlay que parchea el fuente de VirtualBox para añadir
#   MODULE_IMPORT_NS() antes de compilar los módulos del kernel.
#   Basado en el patch de rpmfusion para Fedora/openSUSE.
#
#   Oracle aún no ha incorporado el fix en la rama 7.2 oficial
#   (abril 2026), por lo que el overlay es necesario hasta que
#   nixpkgs actualice VirtualBox con el parche incluido.

let
  # Patch que añade MODULE_IMPORT_NS para los símbolos KVM en kernel 6.19+
  vboxKernel619Patch = pkgs.fetchpatch {
    name   = "virtualbox-kernel-6.19-kvm-namespace.patch";
    url    = "https://github.com/rpmfusion/VirtualBox-kmod/raw/master/kernel-6.19.patch";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # sustituir tras primer build
  };

in
{
  # ── Overlay: parchea VirtualBox para kernel 6.19 ──────────────────────
  nixpkgs.overlays = [
    (final: prev: {
      # Solo aplica el override en la familia de paquetes del kernel activo
      linuxPackages_zen = prev.linuxPackages_zen.extend (lpFinal: lpPrev: {
        virtualbox = lpPrev.virtualbox.overrideAttrs (old: {
          patches = (old.patches or []) ++ [
            # Patch inline equivalente al de rpmfusion (no requiere descarga externa):
            # Añade MODULE_IMPORT_NS() en SUPDrv-linux.c para kernel 6.19+
            (pkgs.writeText "vbox-kvm-ns-6.19.patch" ''
--- a/src/VBox/HostDrivers/Support/linux/SUPDrv-linux.c
+++ b/src/VBox/HostDrivers/Support/linux/SUPDrv-linux.c
@@ -103,6 +103,15 @@ static struct file_operations g_FileOpsVBoxDrv = {
     .unlocked_ioctl = VBoxDrvLinuxIOCtl,
 };
 
+#if RTLNX_VER_MIN(6,19,0)
+/* kernel 6.19 commit 6276c67: restricts KVM symbols to private namespace */
+# if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
+MODULE_IMPORT_NS("module:kvm");
+MODULE_IMPORT_NS("module:kvm-amd");
+MODULE_IMPORT_NS("module:kvm-intel");
+# endif
+#endif
+
 /** The file_operations for the VBoxDrvU device node. */
 static struct file_operations g_FileOpsVBoxDrvU = {
'')
          ];
        });
      });
    })
  ];

  # ── Configuración del host VirtualBox ────────────────────────────────
  virtualisation.virtualbox.host = {
    enable = true;

    # Extension Pack: USB 2/3, RDP, cifrado de disco.
    # Requiere aceptar licencia Oracle (allowUnfree = true en default.nix).
    enableExtensionPack = true;
  };

  # Usuario con acceso a VMs
  users.extraGroups.vboxusers.members = [ "angel" ];

  # Regla udev para USB passthrough en VMs
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", MODE="0664", GROUP="vboxusers"
  '';

  # ── FALLBACK: si el patch no funciona, cambiar a zen 6.18 ─────────────
  # Descomenta estas líneas en kernel.nix en su lugar:
  #
  #   boot.kernelPackages = pkgs.linuxPackages_6_12;  # zen estable más reciente
  #                                                    # compatible con vbox
  #
  # O fija el kernel zen a 6.18 con:
  #   boot.kernelPackages = pkgs.linuxPackages_zen;
  #   boot.kernelPackages.kernel.version  -- verificar que sea < 6.19
}

# ─────────────────────────────────────────────────────────────────
# hosts/nixos/disko.nix
#
# Recibe `diskConfig` vía specialArgs (inyectado desde flake.nix).
# Lee disk.nix y construye el layout GPT automáticamente.
#
# Modos:
#   dualBoot = false → ESP (512M) + swap + root (resto del disco)
#   dualBoot = true  → solo swap + root; EFI de Windows se monta aparte
# ─────────────────────────────────────────────────────────────────
{ diskConfig, lib, ... }:

let
  inherit (diskConfig) disk dualBoot efiPartition swapSize;
  # nixPartition puede no existir en configs antiguas → fallback ""
  nixPartition = diskConfig.nixPartition or "";
in
{
  disko.devices =

    # ════════════════════════════════════════════════════════════════
    # MODO LIMPIO — disko controla el disco completo
    # Crea: ESP (512M) + swap + root (resto)
    # ════════════════════════════════════════════════════════════════
    lib.mkIf (!dualBoot) {
      disk.main = {
        device = disk;
        type   = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type         = "filesystem";
                format       = "vfat";
                mountpoint   = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size    = swapSize;
              content = {
                type          = "swap";
                discardPolicy = "both";
                resumeDevice  = true;
              };
            };
            root = {
              size    = "100%";
              content = {
                type         = "filesystem";
                format       = "ext4";
                mountpoint   = "/";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    }

    //

    # ════════════════════════════════════════════════════════════════
    # MODO DUAL BOOT — disko opera SOLO sobre nixPartition
    # La partición EFI de Windows se monta pero no se toca.
    # nixPartition se trata como un "disco" virtual: disko la
    # reformatea internamente con LVM o simplemente la divide en
    # swap + root usando su tipo "nodev" + contenido directo.
    # ════════════════════════════════════════════════════════════════
    (lib.mkIf dualBoot {
      disk.nixos = {
        # Apuntamos directamente a la partición libre, no al disco.
        # disko la tratará como superficie en blanco y creará
        # una tabla de particiones dentro de ella con swap + root.
        device = nixPartition;
        type   = "disk";
        content = {
          type = "gpt";
          partitions = {
            swap = {
              size    = swapSize;
              content = {
                type          = "swap";
                discardPolicy = "both";
                resumeDevice  = true;
              };
            };
            root = {
              size    = "100%";
              content = {
                type         = "filesystem";
                format       = "ext4";
                mountpoint   = "/";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    });

  # ── Dual boot: declarar el mount de la EFI de Windows en /boot ───
  # disko NO formatea ni toca esta partición.
  # NixOS la monta en /boot para que systemd-boot pueda escribir
  # las entradas del bootloader junto a las de Windows.
  fileSystems = lib.mkIf dualBoot {
    "/boot" = {
      device  = efiPartition;
      fsType  = "vfat";
      options = [ "umask=0077" ];
    };
  };
}

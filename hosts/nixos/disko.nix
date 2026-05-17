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
in
{
  disko.devices = {

    disk.main = {
      device = disk;
      type   = "disk";

      content = {
        type = "gpt";

        partitions =
          # ── Partición EFI (solo instalación limpia) ──────────────
          lib.optionalAttrs (!dualBoot) {
            ESP = {
              size = "512M";
              type = "EF00";        # EFI System Partition (gdisk code)
              content = {
                type         = "filesystem";
                format       = "vfat";
                mountpoint   = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
          }

          //

          # ── Swap ─────────────────────────────────────────────────
          {
            swap = {
              size    = swapSize;
              content = {
                type          = "swap";
                discardPolicy = "both";  # trim + discard en NVMe
                resumeDevice  = true;    # habilita hibernate
              };
            };

            # ── Root (ocupa el resto del disco) ──────────────────
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
  };

  # ── Dual boot: montar la partición EFI de Windows (sin tocarla) ──
  # disko no formatea ni crea esta partición; solo la referencia para
  # que systemd la monte en /boot/efi durante el boot.
  fileSystems = lib.mkIf dualBoot {
    "/boot/efi" = {
      device  = efiPartition;
      fsType  = "vfat";
      options = [ "umask=0077" "noauto" "x-systemd.automount" ];
    };
  };
}

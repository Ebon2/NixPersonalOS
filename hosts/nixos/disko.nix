{ diskConfig, lib, ... }:
let
  inherit (diskConfig) disk dualBoot efiPartition swapSize;

  # Modo dualBoot obliga a definir las particiones de root y swap
  rootPartition = diskConfig.rootPartition or
    (throw "En modo dualBoot debes definir 'rootPartition' (ej. /dev/nvme0n1p5)");
  swapPartition = diskConfig.swapPartition or
    (throw "En modo dualBoot debes definir 'swapPartition' (ej. /dev/nvme0n1p6)");
in
{
  disko.devices = lib.mkMerge [
    # ═══════════════════════════════════════════════
    # MODO LIMPIO (dualBoot = false)
    # Disko gestiona TODO el disco: crea ESP, swap y root
    # ═══════════════════════════════════════════════
    (lib.mkIf (!dualBoot) {
      disk.main = {
        device = disk;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = swapSize;
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    })

    # ═══════════════════════════════════════════════
    # MODO DUAL BOOT (dualBoot = true)
    # Solo formatea las particiones existentes, sin tocar la tabla GPT
    # ═══════════════════════════════════════════════
    (lib.mkIf dualBoot {
      # Partición root como dispositivo único (ext4)
      root = {
        type = "disk";          # Se trata como un disco entero a formatear
        device = rootPartition; # /dev/nvme0n1p5
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
          mountOptions = [ "noatime" ];
        };
      };
      # Partición swap como dispositivo único
      swap = {
        type = "disk";
        device = swapPartition; # /dev/nvme0n1p6
        content = {
          type = "swap";
          discardPolicy = "both";
          resumeDevice = true;
        };
      };
    })
  ];

  # ═══════════════════════════════════════════════
  # EFI de Windows: solo se monta, NUNCA se formatea
  # ═══════════════════════════════════════════════
  fileSystems = lib.mkIf dualBoot {
    "/boot" = {
      device = efiPartition;  # La EFI que ya existe (p.ej. /dev/nvme0n1p1)
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
  };
}
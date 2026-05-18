# ─────────────────────────────────────────────────────────────────
# disk.nix  —  Único punto de entrada para la configuración de disco
# Igual que user.nix pero para particionado (disko)
# ─────────────────────────────────────────────────────────────────
{
  # Ruta del disco a particionar (lsblk para confirmarlo)
  disk = "/dev/nvme0n1";

  # true  → dual boot con Windows: NO se crea partición EFI nueva,
  #         se monta la partición EFI existente de Windows.
  # false → instalación limpia: disko crea su propia partición EFI.
  dualBoot = false;

  # Solo relevante si dualBoot = true.
  # Partición EFI de Windows que se montará en /boot
  # Ejemplo: "/dev/nvme0n1p1"
  efiPartition = "/dev/nvme0n1p1";

  # Solo relevante si dualBoot = true.
  # Partición LIBRE que creaste desde Windows para NixOS.
  # Disko la borrará y creará swap + root dentro de ella.
  # Ejemplo: "/dev/nvme0n1p5"
  nixPartition = "/dev/nvme0n1p5";

  # Tamaño del swap. Tu script lo sobreescribirá con el valor correcto.
  # Formato disko: "4G", "8G", "16G", etc.
  swapSize = "8G";
}

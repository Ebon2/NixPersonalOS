#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────────
# install.sh  —  Instalador interactivo NixPersonalOS
# Modos:
#   Instalación limpia  → disko opera sobre el disco completo
#   Dual Boot           → disko opera solo sobre una partición libre
#                         (la EFI de Windows se reutiliza, sin tocarla)
# ─────────────────────────────────────────────────────────────────

REPO_DIR="/tmp/nixos-config"
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

header() { echo -e "\n${CYAN}══ $1 ${NC}"; }
ok()     { echo -e "${GREEN}✓ $1${NC}"; }
warn()   { echo -e "${YELLOW}⚠ $1${NC}"; }
die()    { echo -e "${RED}✗ $1${NC}"; exit 1; }
info()   { echo -e "  ${BOLD}$1${NC}"; }

# ─── 0. Verificaciones previas ────────────────────────────────────
header "Verificando entorno"

[[ -d "$REPO_DIR" ]] || die "No se encontró $REPO_DIR. Clona el repo primero."
command -v mkpasswd &>/dev/null || die "mkpasswd no encontrado. Instálalo: nix shell nixpkgs#whois"

export NIX_CONFIG="experimental-features = nix-command flakes"
ok "Entorno OK"

# ─── 1. Modo de instalación ───────────────────────────────────────
header "Modo de instalación"
echo ""
echo -e "  ${BOLD}[1]${NC} Instalación limpia   — borra el disco completo y crea todo desde cero"
echo -e "  ${BOLD}[2]${NC} Dual Boot             — conserva Windows, usa solo una partición libre"
echo ""
read -rp "Elige modo [1/2]: " mode
[[ "$mode" == "1" || "$mode" == "2" ]] || die "Opción inválida. Elige 1 o 2."

# ════════════════════════════════════════════════════════════════════
# MODO 1 — INSTALACIÓN LIMPIA
# ════════════════════════════════════════════════════════════════════
if [[ "$mode" == "1" ]]; then
  dualBoot="false"

  header "Selección de disco (instalación limpia)"
  echo ""
  lsblk -o NAME,SIZE,TYPE,MODEL
  echo ""
  read -rp "Disco a usar (ej: /dev/nvme0n1): " disk
  [[ -b "$disk" ]] || die "'$disk' no es un dispositivo de bloque válido."

  read -rp "Tamaño del swap en GB (solo el número, ej: 8): " swmp
  [[ "$swmp" =~ ^[0-9]+$ ]] || die "El tamaño debe ser un número entero."
  swapSize="${swmp}G"

  efiPartition="${disk}p1"  # placeholder, no se usa en limpio
  nixPartition=""           # placeholder

  echo ""
  warn "¡ADVERTENCIA! Esto borrará ${disk} completamente incluyendo todos sus datos."
  read -rp "Escribe 'si' para confirmar: " confirm
  [[ "$confirm" == "si" ]] || die "Instalación cancelada."

# ════════════════════════════════════════════════════════════════════
# MODO 2 — DUAL BOOT
# ════════════════════════════════════════════════════════════════════
else
  dualBoot="true"

  header "Dual Boot — Selección de disco"
  echo ""
  lsblk -o NAME,SIZE,TYPE,MODEL
  echo ""
  read -rp "Disco donde está Windows (ej: /dev/nvme0n1): " disk
  [[ -b "$disk" ]] || die "'$disk' no es un dispositivo de bloque válido."

  # ── Mostrar particiones del disco elegido ─────────────────────
  header "Particiones actuales de $disk"
  echo ""
  lsblk -o NAME,SIZE,FSTYPE,PARTLABEL,MOUNTPOINT "$disk"
  echo ""
  echo -e "  ${YELLOW}Importante:${NC} Crea la partición libre desde Windows (Administrador de"
  echo -e "  discos → Reducir volumen) ${BOLD}antes${NC} de continuar, y déjala sin formato."
  echo -e "  Esa partición vacía será donde se instale NixOS (swap + root)."
  echo ""

  # ── Partición EFI de Windows ──────────────────────────────────
  info "¿Cuál es la partición EFI de Windows?"
  info "Busca la que tiene FSTYPE=vfat y suele ser la primera (ej: ${disk}p1)"
  echo ""
  read -rp "Partición EFI de Windows (ej: ${disk}p1): " efiPartition
  [[ -b "$efiPartition" ]] || die "'$efiPartition' no existe."

  efi_fstype=$(lsblk -no FSTYPE "$efiPartition" 2>/dev/null || true)
  if [[ "$efi_fstype" != "vfat" ]]; then
    warn "La partición '$efiPartition' tiene tipo '$efi_fstype', no 'vfat'."
    warn "Asegúrate de que sea la partición EFI correcta antes de continuar."
    read -rp "¿Continuar de todas formas? [s/N]: " force_efi
    [[ "${force_efi,,}" == "s" || "${force_efi,,}" == "y" ]] || die "Instalación cancelada."
  else
    ok "Partición EFI confirmada ($efiPartition, vfat)"
  fi

  echo ""

  # ── Partición libre para NixOS ────────────────────────────────
  info "¿Cuál es la partición libre que usará NixOS?"
  info "Debe aparecer sin FSTYPE (sin formato) en la tabla de arriba."
  info "Ej: si ves '└─nvme0n1p5' vacía, escribe: ${disk}p5"
  echo ""
  read -rp "Partición para NixOS (ej: ${disk}p5): " nixPartition
  [[ -b "$nixPartition" ]] || die "'$nixPartition' no existe."

  [[ "$nixPartition" == "$efiPartition" ]] && \
    die "La partición de NixOS no puede ser la misma que la EFI."

  nix_fstype=$(lsblk -no FSTYPE "$nixPartition" 2>/dev/null || true)
  nix_mount=$(lsblk -no MOUNTPOINT "$nixPartition" 2>/dev/null || true)

  if [[ -n "$nix_mount" ]]; then
    die "'$nixPartition' está montada en '$nix_mount'. Desmóntala primero."
  fi

  if [[ -n "$nix_fstype" ]]; then
    warn "'$nixPartition' ya tiene sistema de archivos: $nix_fstype"
    warn "Su contenido se BORRARÁ al continuar."
    read -rp "¿Continuar? [s/N]: " force_part
    [[ "${force_part,,}" == "s" || "${force_part,,}" == "y" ]] || die "Instalación cancelada."
  fi

  read -rp "Tamaño del swap en GB (solo el número, ej: 8): " swmp
  [[ "$swmp" =~ ^[0-9]+$ ]] || die "El tamaño debe ser un número entero."
  swapSize="${swmp}G"

  echo ""
  warn "¡ADVERTENCIA! Esto borrará SOLO '$nixPartition'."
  warn "Windows ($disk, particiones restantes) quedará intacto."
  read -rp "Escribe 'si' para confirmar: " confirm
  [[ "$confirm" == "si" ]] || die "Instalación cancelada."
fi

# ─── 2. Usuario ───────────────────────────────────────────────────
header "Configuración de usuario"

read -rp "Nombre de usuario (sin espacios, ej: angel): " username
[[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]] || die "Usuario inválido. Solo minúsculas, números, guiones."

read -rp "Nombre completo: " fullName
read -rp "Correo electrónico: " mail
read -rp "Descripción del usuario (puede dejarse en blanco): " description
read -rp "Rama git por defecto (Enter = main): " gitBranch
gitBranch="${gitBranch:-main}"

echo ""
warn "Introduce la contraseña que usarás en NixOS:"
hashedPassword=$(mkpasswd -m sha-512) || die "Error generando contraseña."
ok "Contraseña hasheada correctamente"

# ─── 3. Resumen ───────────────────────────────────────────────────
header "Resumen — verifica antes de continuar"
echo ""
if [[ "$dualBoot" == "false" ]]; then
  echo -e "  Modo:             ${YELLOW}Instalación limpia${NC}"
  echo -e "  Disco:            ${YELLOW}$disk${NC} (completo)"
else
  echo -e "  Modo:             ${YELLOW}Dual Boot${NC}"
  echo -e "  Disco:            ${YELLOW}$disk${NC}"
  echo -e "  EFI Windows:      ${YELLOW}$efiPartition${NC}  ← no se toca"
  echo -e "  Partición NixOS:  ${YELLOW}$nixPartition${NC}  ← se borrará"
fi
echo -e "  Swap:             ${YELLOW}$swapSize${NC}"
echo -e "  Usuario:          ${YELLOW}$username${NC}"
echo -e "  Nombre:           ${YELLOW}$fullName${NC}"
echo -e "  Correo:           ${YELLOW}$mail${NC}"
echo -e "  Rama git:         ${YELLOW}$gitBranch${NC}"
echo ""

# ─── 4. Escribir disk.nix ─────────────────────────────────────────
header "Generando disk.nix"

cat > "$REPO_DIR/disk.nix" << EOF
{
  disk         = "$disk";
  dualBoot     = $dualBoot;
  efiPartition = "$efiPartition";
  nixPartition = "${nixPartition:-}";
  swapSize     = "$swapSize";
}
EOF
ok "disk.nix generado"

# ─── 5. Escribir user.nix ─────────────────────────────────────────
header "Generando user.nix"

cat > "$REPO_DIR/user.nix" << EOF
{
  username         = "$username";
  fullName         = "$fullName";
  email            = "$mail";
  description      = "$description";
  hashedPassword   = "$hashedPassword";
  gitDefaultBranch = "$gitBranch";
}
EOF
ok "user.nix generado"

# ─── 6. Particionar con disko ─────────────────────────────────────
header "Particionando con disko"

if [[ "$dualBoot" == "false" ]]; then
  info "Modo limpio: disko opera sobre el disco completo ($disk)"
else
  info "Modo dual boot: disko opera solo sobre $nixPartition"
fi
echo ""

sudo nix run github:nix-community/disko/latest -- \
  --mode disko \
  --flake "$REPO_DIR#nixos"

ok "Particionado y montado en /mnt"

# ─── 7. Montar EFI de Windows en /mnt/boot (solo dual boot) ───────
if [[ "$dualBoot" == "true" ]]; then
  header "Montando EFI de Windows"
  sudo mkdir -p /mnt/boot
  sudo mount "$efiPartition" /mnt/boot
  ok "EFI montada en /mnt/boot ($efiPartition)"
fi

# ─── 8. Hardware configuration ────────────────────────────────────
header "Generando hardware-configuration.nix"

sudo nixos-generate-config --no-filesystems --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix \
   "$REPO_DIR/hosts/nixos/hardware-configuration.nix"

ok "hardware-configuration.nix copiado al repo"

# ─── 9. Instalar NixOS ────────────────────────────────────────────
header "Instalando NixOS"

sudo nixos-install \
  --flake "$REPO_DIR#nixos" \
  --no-root-passwd

ok "NixOS instalado correctamente"

# ─── 10. Limpieza ─────────────────────────────────────────────────
header "Limpiando"
rm -- "$0"
ok "install.sh eliminado del sistema"

# ─── 11. Reboot ───────────────────────────────────────────────────
echo ""
echo -e "${GREEN}════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Instalación completa. Retira el USB.      ${NC}"
echo -e "${GREEN}════════════════════════════════════════════${NC}"
echo ""
read -rp "Presiona Enter para reiniciar..."
reboot
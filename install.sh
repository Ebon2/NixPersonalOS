#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────────
# install.sh  —  Instalador interactivo NixPersonalOS
# Llena disk.nix y user.nix, particiona con disko e instala NixOS
# ─────────────────────────────────────────────────────────────────

REPO_DIR="/tmp/nixos-config"
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

header() { echo -e "\n${CYAN}══ $1 ${NC}"; }
ok()     { echo -e "${GREEN}✓ $1${NC}"; }
warn()   { echo -e "${YELLOW}⚠ $1${NC}"; }
die()    { echo -e "${RED}✗ $1${NC}"; exit 1; }

# ─── 0. Verificaciones previas ────────────────────────────────────
header "Verificando entorno"

[[ -d "$REPO_DIR" ]] || die "No se encontró $REPO_DIR. Clona el repo primero."
command -v mkpasswd &>/dev/null || die "mkpasswd no encontrado. Instálalo: nix shell nixpkgs#whois"

export NIX_CONFIG="experimental-features = nix-command flakes"
ok "Entorno OK"

# ─── 1. Disco ─────────────────────────────────────────────────────
header "Configuración de disco"

echo ""
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
echo ""

read -rp "Disco a particionar (ej: /dev/nvme0n1): " disk
[[ -b "$disk" ]] || die "'$disk' no es un dispositivo de bloque válido."

read -rp "Tamaño del swap en GB (solo el número, ej: 8): " swmp
[[ "$swmp" =~ ^[0-9]+$ ]] || die "El tamaño debe ser un número entero."
swapSize="${swmp}G"         # ← sin espacios alrededor del =

read -rp "¿Dual Boot con Windows? [s/N]: " answ
answ="${answ,,}"            # lowercase
if [[ "$answ" == "s" || "$answ" == "y" ]]; then
  dualBoot="true"
  echo ""
  lsblk -o NAME,SIZE,FSTYPE,LABEL "$disk"
  echo ""
  read -rp "Partición EFI de Windows (ej: ${disk}p1): " efiPartition
  [[ -b "$efiPartition" ]] || die "'$efiPartition' no existe."
else
  dualBoot="false"
  efiPartition="${disk}p1"  # valor placeholder, no se usará
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

# ─── 3. Confirmación ──────────────────────────────────────────────
header "Resumen — verifica antes de continuar"
echo ""
echo -e "  Disco:          ${YELLOW}$disk${NC}"
echo -e "  Swap:           ${YELLOW}$swapSize${NC}"
echo -e "  Dual Boot:      ${YELLOW}$dualBoot${NC}"
[[ "$dualBoot" == "true" ]] && echo -e "  EFI Windows:    ${YELLOW}$efiPartition${NC}"
echo -e "  Usuario:        ${YELLOW}$username${NC}"
echo -e "  Nombre:         ${YELLOW}$fullName${NC}"
echo -e "  Correo:         ${YELLOW}$mail${NC}"
echo -e "  Rama git:       ${YELLOW}$gitBranch${NC}"
echo ""
warn "¡ESTO BORRARÁ $disk COMPLETAMENTE!"
read -rp "¿Continuar? Escribe 'si' para confirmar: " confirm
[[ "$confirm" == "si" ]] || die "Instalación cancelada."

# ─── 4. Escribir disk.nix ─────────────────────────────────────────
header "Generando disk.nix"

cat > "$REPO_DIR/disk.nix" << EOF
{
  disk         = "$disk";
  dualBoot     = $dualBoot;
  efiPartition = "$efiPartition";
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
header "Particionando disco con disko"

sudo nix run github:nix-community/disko/latest -- \
  --mode disko \
  --flake "$REPO_DIR#nixos"

ok "Disco particionado y montado en /mnt"

# ─── 7. Hardware configuration ────────────────────────────────────
header "Generando hardware-configuration.nix"

sudo nixos-generate-config --no-filesystems --root /mnt

cp /mnt/etc/nixos/hardware-configuration.nix \
   "$REPO_DIR/hosts/nixos/hardware-configuration.nix"

ok "hardware-configuration.nix copiado al repo"

# ─── 8. Instalar NixOS ────────────────────────────────────────────
header "Instalando NixOS"

sudo nixos-install \
  --flake "$REPO_DIR#nixos" \
  --no-root-passwd

ok "NixOS instalado correctamente"

# ─── 9. Auto-eliminar del sistema (no del repo) ───────────────────
# El repo clonado en /tmp es temporal. El install.sh sigue existiendo
# en GitHub; aquí solo borramos la copia local del live USB.
header "Limpiando"
rm -- "$0"
ok "install.sh eliminado del sistema"
 
# ─── 10. Reboot ───────────────────────────────────────────────────
echo ""
echo -e "${GREEN}════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Instalación completa. Retira el USB.      ${NC}"
echo -e "${GREEN}════════════════════════════════════════════${NC}"
echo ""
read -rp "Presiona Enter para reiniciar..."
reboot
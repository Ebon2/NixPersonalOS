# Manual de trabajo — NixOS + Home Manager
> username · nixos-unstable · Hyprland · Fish · Catppuccin Mocha

---

## Arquitectura del repositorio

```
nixos_config/
├── flake.nix                        ← inputs + outputs (nixos + home-manager)
├── hosts/
│   └── nixos/
│       ├── default.nix              ← importa todos los módulos del sistema
│       └── hardware-configuration.nix
│
├── modules/                         ← SISTEMA (root / servicios globales)
│   ├── system/
│   │   ├── boot.nix
│   │   ├── kernel.nix
│   │   ├── locale.nix
│   │   ├── networking.nix
│   │   ├── users.nix                ← define el usuario angel
│   │   └── environment.nix
│   ├── hardware/
│   │   └── amd-gpu.nix
│   ├── desktop/
│   │   ├── hyprland.nix             ← habilita el COMPOSITOR a nivel sistema
│   │   ├── plasma.nix
│   │   └── x11.nix
│   ├── services/
│   │   ├── audio.nix, bluetooth.nix, power.nix ...
│   └── programs/
│       └── system-packages.nix      ← solo lo que DEBE ser del sistema
│
├── home/                            ← HOME MANAGER (usuario angel)
│   ├── default.nix                  ← punto de entrada HM
│   ├── programs/
│   │   ├── packages.nix             ← home.packages (paquetes de usuario)
│   │   ├── firefox.nix              ← programs.firefox (extensiones, políticas)
│   │   ├── fish.nix                 ← programs.fish (aliases, funciones)
│   │   ├── kitty.nix                ← programs.kitty
│   │   ├── neovim.nix               ← programs.neovim + enlace a static/nvim
│   │   ├── git.nix                  ← programs.git
│   │   └── misc.nix                 ← btop, atuin, fastfetch, ranger...
│   └── desktop/
│       ├── hyprland.nix             ← wayland.windowManager.hyprland (config usuario)
│       ├── waybar.nix               ← programs.waybar
│       ├── rofi.nix                 ← programs.rofi
│       └── theme.nix                ← gtk, qt, cursores
│
└── static/                          ← archivos "crudos" que se enlazan
    ├── hypr/                        ← conf/, scripts/, wallpapers
    ├── waybar/                      ← config, modules.jsonc, style.css, scripts/
    ├── fish/                        ← fish_variables (colores)
    ├── nvim/                        ← init.lua + lazy-lock.json
    ├── kitty/                       ← solo de referencia (HM lo genera)
    ├── rofi/                        ← config.rasi + temas
    ├── ranger/                      ← rc.conf, rifle.conf, etc.
    ├── fastfetch/                   ← config.jsonc
    ├── wlogout/                     ← layout + style.css
    ├── waypaper/                    ← config.ini
    └── wofi-power/                  ← power.sh + style.css
```

---

## Regla de oro: ¿dónde va cada cosa?

| ¿Qué es?                                      | Dónde va                          |
|-----------------------------------------------|-----------------------------------|
| Servicio systemd global, driver, kernel param | `modules/`                        |
| Programa que necesita setuid / capabilities   | `modules/programs/system-packages.nix` |
| Shell (fish/zsh/bash) — registro en /etc/shells | `modules/` (`programs.fish.enable`) |
| Fuentes del sistema                           | `modules/programs/system-packages.nix` |
| Wine, Docker, VirtualBox                      | `modules/`                        |
| Tu editor, terminal, browser                  | `home/programs/`                  |
| Dotfiles de apps de usuario                   | `home/` via `programs.*` o `xdg.configFile` |
| Configuración de Hyprland (usuario)           | `home/desktop/hyprland.nix`       |
| Archivos grandes que no vale la pena migrar   | `static/` → enlazados via `xdg.configFile` |

---

## Comandos del día a día

### Rebuild completo (sistema + home manager)
```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

> Home Manager se aplica automáticamente dentro del rebuild de NixOS.
> **Un solo comando, un solo rebuild.**

### Solo aplicar cambios de Home Manager (sin tocar el sistema)
```bash
home-manager switch --flake /etc/nixos#angel
```
Útil cuando solo cambiaste algo en `home/`. Más rápido que el rebuild completo.

### Test antes de aplicar (no activa el boot entry)
```bash
sudo nixos-rebuild test --flake /etc/nixos#nixos
```

### Ver generaciones del sistema
```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Rollback del sistema
```bash
sudo nixos-rebuild switch --rollback
# o selecciona la generación anterior en el boot loader
```

### Rollback de Home Manager
```bash
home-manager generations        # lista generaciones HM
home-manager switch --flake /etc/nixos#angel --generation <N>
```

### Actualizar flake.lock (actualiza todos los inputs)
```bash
nix flake update /etc/nixos
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

### Actualizar un solo input (ej: solo home-manager)
```bash
nix flake update home-manager --flake /etc/nixos
```

### Garbage collection
```bash
sudo nix-collect-garbage -d     # borra todas las generaciones antiguas
nix store optimise              # deduplica el store (ahorra espacio)
```

---

## Cómo añadir un paquete de usuario

Abre `home/programs/packages.nix` y añade a `home.packages`:

```nix
home.packages = with pkgs; [
  # ... existentes ...
  zed-editor   # ← nuevo
];
```

Luego:
```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
# o más rápido:
home-manager switch --flake /etc/nixos#angel
```

---

## Cómo añadir extensiones a Firefox

### Opción 1: NUR (recomendado, declarativo)

1. Añade NUR al `flake.nix`:
```nix
inputs = {
  # ... existentes ...
  nur = {
    url = "github:nix-community/NUR";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

2. Pásalo en `extraSpecialArgs` de home-manager:
```nix
home-manager.extraSpecialArgs = { inherit inputs; nur = inputs.nur.legacyPackages.x86_64-linux; };
```

3. En `home/programs/firefox.nix`, recibe `nur` y añade extensiones:
```nix
{ pkgs, nur, ... }:
{
  programs.firefox.profiles.default.extensions.packages = [
    nur.repos.rycee.firefox-addons.ublock-origin
    nur.repos.rycee.firefox-addons.bitwarden
    nur.repos.rycee.firefox-addons.sponsorblock
    nur.repos.rycee.firefox-addons.darkreader
    nur.repos.rycee.firefox-addons.return-youtube-dislike
  ];
}
```

Busca extensiones disponibles en: https://nur.nix-community.org/repos/rycee/

### Opción 2: Política de empresa (sin NUR)

En `programs.firefox.policies.ExtensionSettings`:
```nix
policies.ExtensionSettings = {
  "uBlock0@raymondhill.net" = {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
    installation_mode = "force_installed";
  };
};
```

### Opción 3: Instalar manualmente

Para extensiones que no están en NUR, instálalas desde about:addons.
No serán declarativas pero tampoco las perderás al rebuild.

---

## Cómo añadir un programa con `programs.*`

Home Manager tiene módulos para cientos de programas. Siempre que puedas, usa `programs.X` en vez de solo añadir a `home.packages`:

```nix
# En home/programs/misc.nix o un archivo nuevo:
programs.zoxide = {
  enable = true;
  enableFishIntegration = true;
};

programs.fzf = {
  enable = true;
  enableFishIntegration = true;
};

programs.bat = {
  enable = true;
  config.theme = "Dracula";
};
```

Busca módulos disponibles: https://home-manager-options.extranix.com/

---

## Cómo editar Hyprland

### Archivos que puedes editar directamente (en static/)
Estos son symlinks gestionados por HM; edítalos libremente:
- `static/hypr/conf/keybinding.conf` — atajos
- `static/hypr/conf/window.conf` — reglas de ventanas
- `static/hypr/conf/decoration.conf` — sombras, blur
- `static/hypr/conf/animation.conf` — animaciones
- `static/hypr/conf/monitor.conf` — resolución/posición

Después de editar: `hyprctl reload` (sin rebuild).

### Para recargar Hyprland desde fish
```bash
hyprctl reload
```

### Para recargar Waybar
```bash
~/.config/waybar/launch.sh
# o el keybinding: SUPER+SHIFT+B
```

### Para añadir una aplicación al autostart
En `home/desktop/hyprland.nix`, en `settings.exec-once`:
```nix
exec-once = [
  # ... existentes ...
  "spotify"
];
```

---

## Cómo añadir funciones de Fish

En `home/programs/fish.nix`, en el bloque `functions`:

```nix
functions = {
  mi_funcion = {
    body = ''
      echo "Hola desde fish"
      $argv
    '';
  };
};
```

O para aliases simples:
```nix
shellAliases = {
  k = "kubectl";
  dc = "docker-compose";
};
```

---

## Migración gradual de static/ a Nix

El flujo recomendado para migrar un config de `static/` a declarativo:

1. **Primero**: deja el `xdg.configFile` apuntando a static/ (ya configurado)
2. **Cuando quieras migrar**: reemplaza el `xdg.configFile` por `programs.X.settings = { ... }`
3. **Nunca edites** los archivos en `~/.config/` directamente si HM los gestiona (los sobreescribirá)

### Ejemplo: migrar btop
```nix
# ANTES (en misc.nix):
xdg.configFile."btop/btop.conf".source = ../../static/btop/btop.conf;

# DESPUÉS:
programs.btop = {
  enable = true;
  settings = {
    vim_keys = true;
    update_ms = 2000;
  };
};
```

---

## Flujo de trabajo recomendado

```
1. Edita el archivo .nix correspondiente
   ↓
2. sudo nixos-rebuild switch --flake /etc/nixos#nixos
   (o home-manager switch si solo cambias home/)
   ↓
3. Si algo falla → sudo nixos-rebuild switch --rollback
   ↓
4. Commit al repo: git add -A && git commit -m "feat: ..."
```

### Alias útiles para fish (ya están en fish.nix)
```bash
nrb    # nixos-rebuild switch
nrbt   # nixos-rebuild test
ngen   # ver generaciones
ngc    # garbage collect
nupd   # flake update
```

---

## Resolución de conflictos

### "File already exists"
Home Manager no puede crear un symlink porque el archivo ya existe:
```bash
# El archivo está en home-manager.backupFileExtension = "bak"
# así que lo renombrará automáticamente. Si sigue fallando:
rm ~/.config/archivo-conflictivo
home-manager switch --flake /etc/nixos#angel
```

### Verificar qué gestiona HM
```bash
home-manager packages     # lista paquetes
ls -la ~/.config/hypr/    # los symlinks apuntan al nix store
```

### Ver el config generado
```bash
cat ~/.config/hypr/hyprland.conf   # generado por HM
cat ~/.config/fish/config.fish     # generado por HM
```

---

## Estructura de commits sugerida

```
feat: añadir zoxide y fzf a fish
fix: corregir monitor resolution en hyprland
chore: nix flake update
refactor: migrar btop de static a programs.btop
```

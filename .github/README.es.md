# Cromatóforo

**Arch · Hyprland 0.56 · pywal16**

[![Licencia: MIT](https://img.shields.io/badge/licencia-MIT-blue.svg)](../LICENSE)
[![English](https://img.shields.io/badge/README-English-lightgrey)](README.md)

Un cromatóforo es la célula de pigmento con la que un cefalópodo toma el color de
lo que tiene detrás. Esto hace lo mismo con un escritorio: un Wayland sobre Arch
en el que **todo el sistema se pinta a partir del wallpaper**. Cambias el fondo y
la barra, el lanzador, el terminal, el prompt, las notificaciones, el editor, el
navegador y las aplicaciones GTK y Qt adoptan la paleta en la misma pasada.

## Galería

Las mismas pantallas con dos wallpapers, sin tocar ni una línea de configuración
entre una columna y otra. Pincha en cualquiera para verla entera.

| | akira | kyogre |
|---|---|---|
| **Escritorio** | ![escritorio con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/escritorio-akira.jpg) | ![escritorio con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/escritorio-kyogre.jpg) |
| **fastfetch** | ![fastfetch con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/fastfetch-akira.jpg) | ![fastfetch con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/fastfetch-kyogre.jpg) |
| **Thunar (GTK)** | ![thunar con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/thunar-akira.jpg) | ![thunar con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/thunar-kyogre.jpg) |
| **Code - OSS** | ![code con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/code-akira.jpg) | ![code con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/code-kyogre.jpg) |
| **Zen Browser** | ![zen con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/zen-akira.jpg) | ![zen con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/zen-kyogre.jpg) |
| **hyprlock** | ![hyprlock con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/hyprlock-akira.jpg) | ![hyprlock con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/hyprlock-kyogre.jpg) |

## Cómo funciona

```
wallpaper ──► wal ──► ~/.cache/wal/* ──► cada programa
```

`~/.config/hypr/scripts/wall.sh` pone el fondo, lanza pywal y recarga cada
programa. Los mapeos de color están en `~/.config/wal/templates/`: para cambiar
cómo se usa un color se toca la plantilla, nunca el config final del programa.

- **Cambia al vuelo:** Hyprland, waybar, wofi, swaync, wlogout, kitty, starship,
  apps GTK3/GTK4, hyprlock, Code - OSS, Obsidian y las terminales abiertas.
- **Al volver a abrirlo:** apps Qt6, btop, cava, fzf, eza, yazi, lazygit, Zen
  Browser y, de forma opcional, Steam y Spotify.
- **Se queda como está, a propósito:** DaVinci Resolve, Discord y los temas de
  iconos y cursor.

`~/.config/hypr/scripts/theme-status.sh` revisa la cadena entera y sale con
error si algún programa se ha quedado atrás.

## Instalación

Es un **repo bare**: los ficheros viven donde los leen los programas, sin enlaces
simbólicos.

```bash
git clone --bare https://github.com/jorgeress/cromatoforo.git "$HOME/.dotfiles"
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot checkout                                  # sobrescribe los ficheros que ya existan
dot config status.showUntrackedFiles no

~/.local/bin/dotfiles-bootstrap --paquetes    # paquetes, GTK, Qt, Zen; idempotente, con --dry-run
chsh -s /usr/bin/zsh

awww-daemon &
~/.config/hypr/scripts/wall.sh /ruta/a/un/wallpaper.jpg
~/.config/hypr/scripts/theme-status.sh
```

Si `dot checkout` se queja de que sobrescribiría ficheros, muévelos antes o usa
`dot checkout -f`.

## Ajustes propios sin tocar el repo

Dos ficheros opcionales que se cargan al final si existen, así que lo que pongas
en ellos gana a todo y un `dot pull` nunca da conflictos:

| Fichero | Lo carga | Para qué |
|---|---|---|
| `~/.config/hypr/local.lua` | el final de `hyprland.lua` | atajos, monitores, reglas de ventana |
| `~/.config/shell/local.sh` | el final de `aliases.sh` | tus alias y funciones (bash y zsh) |

Si `local.lua` tiene un error, Hyprland sigue con la config del repo y avisa con
una notificación.

## Atajos principales

Modificador: `SUPER`.

| Atajo | Acción |
|---|---|
| `SUPER + Return` / `E` / `B` / `R` | kitty / Thunar / Zen / lanzador |
| `SUPER + Q` | cerrar ventana |
| `SUPER + F` / `V` | pantalla completa / flotante |
| `SUPER + h j k l` | mover el foco (`+ SHIFT` mueve la ventana) |
| `SUPER + 1..9` | ir al escritorio (`+ SHIFT` lleva la ventana) |
| `SUPER + W` / `SUPER + SHIFT + W` | wallpaper aleatorio / elegir wallpaper |
| `PRINT` | recorte de pantalla al portapapeles |
| `SUPER + CTRL + L` / `Q` | bloquear / menú de apagado |

## Dependencias

Todo lo que usa la configuración, listo para `pacman -S --needed -`, en
`~/.config/pkglists/` (lo instala `dotfiles-bootstrap --paquetes`).

- **Núcleo:** `hyprland` `waybar` `wofi` `kitty` `hyprlock` `hypridle` `swaync`
  `wlogout` `awww` `python-pywal16` `qt5ct` `qt6ct`
- **Utilidades:** `starship` `btop` `cava` `fastfetch` `thunar` `cliphist`
  `wl-clipboard` `grim` `slurp` `playerctl` `brightnessctl` `imagemagick` `jq`
- **Fuente:** `ttf-jetbrains-mono-nerd` (imprescindible para los glifos de la
  barra y el prompt)
- **Opcional:** `steam` con [Adwaita-for-Steam](https://github.com/tkashkin/Adwaita-for-Steam),
  y `spicetify-cli` para Spotify. Si no están, los scripts no hacen nada.

## Licencia

MIT, ver [LICENSE](../LICENSE).

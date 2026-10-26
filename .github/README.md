# Cromatóforo

**Arch · Hyprland 0.56 · pywal16**

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../LICENSE)
[![Español](https://img.shields.io/badge/README-Espa%C3%B1ol-lightgrey)](README.es.md)

A chromatophore is the pigment cell a cephalopod uses to take on the colour of
whatever is behind it. This does the same to a desktop: a Wayland setup on Arch
where **the whole system is painted from the wallpaper**. Change the background
and the bar, launcher, terminal, prompt, notifications, editor, browser and GTK
and Qt apps pick up the new palette in the same pass.

## Gallery

Same screens, two wallpapers, not a single line of config changed between the
columns. Click any image for the full size.

| | akira | kyogre |
|---|---|---|
| **Desktop** | ![desktop with akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/escritorio-akira.jpg) | ![desktop with kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/escritorio-kyogre.jpg) |
| **fastfetch** | ![fastfetch with akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/fastfetch-akira.jpg) | ![fastfetch with kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/fastfetch-kyogre.jpg) |
| **Thunar (GTK)** | ![thunar with akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/thunar-akira.jpg) | ![thunar with kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/thunar-kyogre.jpg) |
| **Code - OSS** | ![code with akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/code-akira.jpg) | ![code with kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/code-kyogre.jpg) |
| **Zen Browser** | ![zen with akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/zen-akira.jpg) | ![zen with kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/zen-kyogre.jpg) |
| **hyprlock** | ![hyprlock with akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/hyprlock-akira.jpg) | ![hyprlock with kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/hyprlock-kyogre.jpg) |

## How it works

```
wallpaper ──► wal ──► ~/.cache/wal/* ──► every program
```

`~/.config/hypr/scripts/wall.sh` sets the wallpaper, runs pywal and reloads
each program. The colour mappings live in `~/.config/wal/templates/`: to change
how a colour is used, edit the template, never the program's final config.

- **Updates live:** Hyprland, waybar, wofi, swaync, wlogout, kitty, starship,
  GTK3/GTK4 apps, hyprlock, Code - OSS, Obsidian and open terminals.
- **On the next launch:** Qt6 apps, btop, cava, fzf, eza, yazi, lazygit, Zen
  Browser, and optionally Steam and Spotify.
- **Left alone on purpose:** DaVinci Resolve, Discord, and the icon and cursor
  themes.

`~/.config/hypr/scripts/theme-status.sh` checks the whole chain and exits
non-zero if any consumer is out of date.

## Installation

This is a **bare repo**: files live where programs read them, with no symlinks.

```bash
git clone --bare https://github.com/jorgeress/cromatoforo.git "$HOME/.dotfiles"
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot checkout                                  # overwrites existing files
dot config status.showUntrackedFiles no

~/.local/bin/dotfiles-bootstrap --paquetes    # packages, GTK, Qt, Zen; idempotent, has --dry-run
chsh -s /usr/bin/zsh

awww-daemon &
~/.config/hypr/scripts/wall.sh /path/to/a/wallpaper.jpg
~/.config/hypr/scripts/theme-status.sh
```

If `dot checkout` complains about files it would overwrite, move them first or
use `dot checkout -f`.

## Customising without touching the repo

Two optional files are loaded last if they exist, so whatever you put in them
wins, and `dot pull` never conflicts:

| File | Loaded by | For |
|---|---|---|
| `~/.config/hypr/local.lua` | the end of `hyprland.lua` | binds, monitors, window rules |
| `~/.config/shell/local.sh` | the end of `aliases.sh` | your own aliases and functions (bash and zsh) |

If `local.lua` has an error, Hyprland keeps the repo config and shows a
notification.

## Main keybindings

Modifier: `SUPER`.

| Keys | Action |
|---|---|
| `SUPER + Return` / `E` / `B` / `R` | kitty / Thunar / Zen / launcher |
| `SUPER + Q` | close window |
| `SUPER + F` / `V` | fullscreen / floating |
| `SUPER + h j k l` | move focus (`+ SHIFT` moves the window) |
| `SUPER + 1..9` | go to workspace (`+ SHIFT` sends the window) |
| `SUPER + W` / `SUPER + SHIFT + W` | random wallpaper / pick a wallpaper |
| `PRINT` | region screenshot to the clipboard |
| `SUPER + CTRL + L` / `Q` | lock / power menu |

## Dependencies

Everything the config uses, ready for `pacman -S --needed -`, in
`~/.config/pkglists/` (installed by `dotfiles-bootstrap --paquetes`).

- **Core:** `hyprland` `waybar` `wofi` `kitty` `hyprlock` `hypridle` `swaync`
  `wlogout` `awww` `python-pywal16` `qt5ct` `qt6ct`
- **Tools:** `starship` `btop` `cava` `fastfetch` `thunar` `cliphist`
  `wl-clipboard` `grim` `slurp` `playerctl` `brightnessctl` `imagemagick` `jq`
- **Font:** `ttf-jetbrains-mono-nerd` (required for the bar and prompt glyphs)
- **Optional:** `steam` with [Adwaita-for-Steam](https://github.com/tkashkin/Adwaita-for-Steam),
  and `spicetify-cli` for Spotify. Without them the scripts simply do nothing.

## License

MIT, see [LICENSE](../LICENSE).

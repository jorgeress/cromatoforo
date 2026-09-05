# cromatóforo

**Arch · Hyprland 0.56 · pywal16**

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Hyprland 0.56](https://img.shields.io/badge/Hyprland-0.56-3b6ea5)
![pywal16](https://img.shields.io/badge/pywal16-color-8a5cf6)
[![Español](https://img.shields.io/badge/README-Espa%C3%B1ol-lightgrey)](README.md)

A chromatophore is the pigment cell a cephalopod uses to take on the colour of
whatever is behind it. This does the same to a desktop: a full Wayland setup on
Arch where **the entire system is painted from the wallpaper**. Change the
background and the bar, the launcher, the terminal, the prompt, the
notifications, the power menu, the system monitor, the editor, the browser and
every GTK and Qt app pick up the new palette in the same pass.

> This is a condensed English version. **The full documentation is in Spanish**
> in [README.md](README.md): per-app customisation, keybindings, how to test a
> change without breaking your session, and a long "traps and findings" section
> that is the most useful part of this repo.

Reference machine: MSI Stealth 15 (i7-13620H + hybrid RTX 4060), eDP-2 1920x1080
@ 144 Hz, scale 1. Everything documented here was measured on it, nothing is
listed as "should work".

---

## How the colour system works

One single source of truth: the wallpaper.

```
wallpaper.jpg
     │
     └── wal -i ──► ~/.cache/wal/
                      ├── colors-hypr.lua      → hyprland.lua        (dofile)
                      ├── colors-gtk.css       → waybar, wofi, swaync,
                      │                          wlogout, GTK3, GTK4  (@import)
                      ├── colors-hyprlock.conf → hyprlock            (source)
                      ├── colors-kitty.conf    → kitty               (include)
                      ├── starship.toml        → starship            (STARSHIP_CONFIG)
                      ├── zsh-colors.zsh       → zsh plugins         (sourced)
                      ├── shell-tools.sh       → fzf, eza            (sourced)
                      ├── yazi-theme.toml      → yazi                (symlink)
                      ├── lazygit-theme.yml    → lazygit             (LG_CONFIG_FILE)
                      ├── obsidian.css         → Obsidian            (copied to vault)
                      ├── pywal.theme          → btop                (symlink)
                      ├── cava-config          → cava                (symlink)
                      ├── colors-qt.conf       → qt5ct/qt6ct → Qt apps
                      ├── colors-steam.css     → Steam               (copied to steamui)
                      ├── spicetify-color.ini  → Spotify             (copied to theme)
                      ├── colors-vscode-custom → Code - OSS          (merged into settings.json)
                      ├── colors-zen.css       → Zen Browser         (symlinked userChrome)
                      └── sequences            → live terminals
```

The templates that produce those files live in `~/.config/wal/templates/`.
**To change how colours are mapped, edit a template, never the target app's
config.** `~/.config/hypr/scripts/wall.sh` does the whole pass: sets the
wallpaper with `awww`, regenerates the palette, and reloads every consumer.

## What gets themed

**Live, on `SUPER+W`:** Hyprland (borders, shadows, glow), waybar, wofi, swaync,
wlogout, kitty, starship, GTK3/GTK4 apps, hyprlock, Code - OSS, Obsidian, and
every open terminal.

**On reopen or with a short delay:** Qt6 apps such as OBS (1-2 s), btop, cava,
zsh plugins, fzf, eza, Steam, Spotify, Zen Browser, yazi, lazygit.

**Deliberately left alone:** DaVinci Resolve (its colour grading depends on a
neutral UI), Discord (would need a client mod, against their ToS), icons and
cursor (recolouring a full icon theme per wallpaper is expensive and looks bad).

The Spanish README documents the exact mechanism and reload trigger for each one.

## Install on a fresh machine

This is a **bare repo**: files live where the programs actually read them, with
no symlink farm and no package directory.

```bash
# 1. Clone as bare
git clone --bare https://github.com/jorgeress/cromatoforo.git "$HOME/.dotfiles"

# 2. Temporary alias for this shell
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# 3. Check out the files (careful: overwrites existing ones)
dot checkout

# 4. Keep 'dot status' from listing every untracked file in $HOME
dot config status.showUntrackedFiles no

# 5. Everything mechanical in one go: GTK dconf settings, the absolute Qt
#    schema path, Zen's userChrome hookup and the Spotify watcher.
#    Idempotent, and --dry-run tells you what it would do.
~/.local/bin/dotfiles-bootstrap

# 6. Packages (or `dotfiles-bootstrap --paquetes`, which runs both)
sudo pacman -S --needed - < ~/.config/pkglists/pkgs-repo.txt
paru -S --needed - < ~/.config/pkglists/pkgs-aur.txt

# 6b. zsh as the login shell (bash stays for scripts)
chsh -s /usr/bin/zsh

# 7. First palette
mkdir -p ~/Pictures/wallpapers   # put your images there
awww-daemon &
~/.config/hypr/scripts/wall.sh ~/Pictures/wallpapers/whatever.jpg

# 8. Optional: Steam and Spotify
~/.config/hypr/scripts/steam-theme.sh   --status
~/.config/hypr/scripts/spotify-theme.sh --status

# 9. Check the whole thing at once
~/.config/hypr/scripts/theme-status.sh
```

If step 3 complains about overwriting files, move them out of the way first or
accept the loss with `dot checkout -f`.

## Layout

```
.config/hypr/scripts/   wall.sh (the full repaint), wallpicker, per-app themers,
                        theme-status.sh (one-shot health check of the theming)
.config/wal/templates/  THE TEMPLATES. Where every colour comes from
.config/waybar wofi kitty swaync wlogout fastfetch btop cava gtk-3.0 gtk-4.0
.config/qt5ct qt6ct     Qt palette bridge
.config/shell/          env.sh + aliases.sh, shared by zsh and bash
.local/bin/             gtk-apply, qt-apply, zen-apply, obsidian-apply,
                        dotfiles-bootstrap, widgets
```

## Dependencies

Full, regenerable lists live in `~/.config/pkglists/` (`pkglist` alias).

**Core:** `hyprland` `waybar` `wofi` `kitty` `hyprlock` `hypridle` `hyprshot`
`hyprpicker` `swaync` `wlogout` `awww` (the successor to swww) `python-pywal16`

**Utilities:** `cliphist` `wl-clipboard` `grim` `slurp` `playerctl`
`brightnessctl` `thunar` `starship` `btop` `cava` `fastfetch` `imagemagick` `jq`

**Toolkit theming:** `qt5ct` `qt6ct`. Kvantum is installed but unused:
`style=Fusion` plus a custom palette is enough.

**Optional:** [Adwaita-for-Steam](https://github.com/tkashkin/Adwaita-for-Steam)
for Steam, `spicetify-cli` (AUR) for Spotify. If they are missing the scripts
exit quietly and everything else still works.

**Font:** `ttf-jetbrains-mono-nerd`, required: waybar, wofi, wlogout, starship
and fastfetch all draw their glyphs from it.

## Credits

Built on [pywal16](https://github.com/eylles/pywal16),
[Hyprland](https://hyprland.org), [waybar](https://github.com/Alexays/Waybar),
[Adwaita-for-Steam](https://github.com/tkashkin/Adwaita-for-Steam) and
[spicetify](https://spicetify.app).

## License

MIT, see [LICENSE](LICENSE).

# ─────────────────────────────────────────────────────────────
#  env.sh — variables de entorno. POSIX puro: lo leen zsh (.zshenv),
#  bash (.bash_profile) y cualquier cosa que haga `. env.sh`.
#  Aquí NO van alias ni funciones: eso es aliases.sh.
# ─────────────────────────────────────────────────────────────

# ── PATH ────────────────────────────────────────────────────
# Sin duplicar si se lee dos veces (zsh relee .zshenv en subshells).
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
esac
case ":$PATH:" in
    *":$HOME/.cargo/bin:"*) ;;
    *) [ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:$PATH" ;;
esac
export PATH

# ── Editor ──────────────────────────────────────────────────
# nvim si está, vim si no. Antes esto era `export EDITOR=nvim` a pelo y
# neovim no está instalado en esta máquina: `fe` y `git commit` sin -m
# fallaban con "nvim: command not found".
if command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi
export VISUAL="$EDITOR"
export MANPAGER='sh -c "col -bx | bat -l man -p"'

# ── Prompt ──────────────────────────────────────────────────
# starship relee este fichero en cada prompt, y pywal lo regenera al
# cambiar de wallpaper: por eso el prompt cambia de color solo.
export STARSHIP_CONFIG="$HOME/.cache/wal/starship.toml"

# ── XDG ─────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# ── Wayland ─────────────────────────────────────────────────
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM="wayland;xcb"
export ELECTRON_OZONE_PLATFORM_HINT=auto

# ─────────────────────────────────────────────────────────────
#  aliases.sh — source desde ~/.bashrc o ~/.zshrc:
#     [ -f ~/.config/shell/aliases.sh ] && . ~/.config/shell/aliases.sh
# ─────────────────────────────────────────────────────────────

# ── Paquetes ────────────────────────────────────────────────
alias up='paru -Syu'
alias upa='paru -Syu --devel'          # incluye paquetes -git
alias pi='paru -S'
alias pr='paru -Rns'
alias pq='paru -Qs'                    # buscar en lo instalado
alias ps_='paru -Ss'                   # buscar en repos
alias pinfo='pacman -Qi'
alias pfiles='pacman -Ql'
alias whoowns='pacman -Qo'             # qué paquete trae este fichero
alias orphans='pacman -Qdtq | ifne sudo pacman -Rns -'
alias pacclean='paru -Sc && paccache -rk2'
alias mirrors='sudo reflector --country Spain,France,Portugal --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
alias pkglist='pacman -Qqe > ~/.config/pkglists/pkgs-repo.txt && pacman -Qqem > ~/.config/pkglists/pkgs-aur.txt && echo "listas actualizadas"'
alias bigpkgs='expac -H M "%m\t%n" $(pacman -Qqe) | sort -h | tail -25'

# ── Sistema ─────────────────────────────────────────────────
alias jctl='journalctl -p 3 -xb'
alias jfollow='journalctl -f'
alias failed='systemctl --failed'
alias ufailed='systemctl --user --failed'
alias boottime='systemd-analyze blame | head -20'
alias ports='ss -tulpn'
alias temps='watch -n2 sensors'
alias myip='curl -s ifconfig.me && echo'

# ── Ficheros ────────────────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias lt3='eza --tree --level=3 --icons'
alias cat='bat -pp'
alias catt='bat'                       # con números y cabecera
alias df='duf'
alias du='du -h --max-depth=1 | sort -h'
alias mkd='mkdir -pv'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── Git ─────────────────────────────────────────────────────
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'

# ── Dotfiles (bare repo) ────────────────────────────────────
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias dots='dot status -sb'
alias dota='dot add'
alias dotc='dot commit -m'
alias dotp='dot push'
alias dotl='dot log --oneline -15'

# ── Snapper ─────────────────────────────────────────────────
alias snaps='sudo snapper -c root list'
alias snaph='sudo snapper -c home list'
alias snap='sudo snapper -c root create -d'
alias snapdiff='sudo snapper -c root status'

# ── Hyprland ────────────────────────────────────────────────
alias hyprlog='tail -f $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log'
alias hyprerr='hyprctl rollinglog | grep -iE "err|warn"'
alias hyprmon='hyprctl monitors'
alias hyprwin='hyprctl clients | grep -E "class|title"'
alias hyprreload='hyprctl reload'
alias hyprver='hyprctl version | head -3'
# Averiguar la class de una ventana para escribir window_rules
alias hyprclass='hyprctl activewindow | grep -E "^\s+(class|title|initialClass)"'

# ── GPU híbrida ─────────────────────────────────────────────
alias nv='prime-run'
alias gpus='ls -l /dev/dri/by-path'
alias nvsmi='watch -n1 nvidia-smi'
alias whichgpu='glxinfo | grep -i "opengl renderer"'

# ── Paleta / rice ───────────────────────────────────────────
alias wall='~/.config/hypr/scripts/wall.sh'
alias wallr='~/.config/hypr/scripts/wall.sh random'
alias palette='wal --preview'
alias recolor='wal -i "$(cat ~/.cache/current_wallpaper)" -n -q && hyprctl reload'
alias barreload='pkill -SIGUSR2 waybar'
alias barlog='pkill waybar; waybar'    # ver errores de waybar en consola

# ── Vídeo / YouTube ─────────────────────────────────────────
alias ffprobe-info='ffprobe -v error -show_format -show_streams'
alias resolve='prime-run /opt/resolve/bin/resolve'

# ─────────────────────────────────────────────────────────────
#  FUNCIONES
# ─────────────────────────────────────────────────────────────

# Extraer cualquier archivo comprimido
extract() {
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.tar.xz)  tar xJf "$1" ;;
        *.tar.zst) tar --zstd -xf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.zip)     unzip "$1" ;;
        *.7z)      7z x "$1" ;;
        *.rar)     unrar x "$1" ;;
        *)         echo "No sé extraer '$1'" ;;
    esac
}

# Buscar y editar con fzf + preview
fe() {
    local f
    f=$(fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always {}') && "${EDITOR:-nvim}" "$f"
}

# Matar proceso interactivamente
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    [ -n "$pid" ] && echo "$pid" | xargs kill -${1:-9}
}

# Backup rápido de un fichero antes de tocarlo
bak() { cp -v "$1" "$1.bak-$(date +%Y%m%d-%H%M%S)"; }

# Qué se instaló recientemente (útil para depurar qué rompió algo)
recentpkgs() {
    grep -i installed /var/log/pacman.log | tail -"${1:-25}"
}

# fastfetch con dot art rotatorio: coge uno al azar de
# ~/.config/fastfetch/logos/ en cada ejecución. Si la carpeta está vacía,
# cae al logo fijo que apunta config.jsonc.
# Si el fichero ya trae códigos ANSI propios usa file-raw, y si no file,
# que es el que sustituye $1..$9 por la paleta de pywal.
fastfetch() {
    local dir="$HOME/.config/fastfetch/logos" logo type
    logo=$(find "$dir" -maxdepth 1 -type f ! -name '.*' 2>/dev/null | shuf -n1)
    if [ -z "$logo" ]; then
        command fastfetch "$@"
        return
    fi
    if grep -qU $'\x1b' "$logo" 2>/dev/null; then type=file-raw; else type=file; fi
    # Ojo: es --logo FICHERO. En fastfetch 2.67 quitaron --logo-source del CLI.
    command fastfetch --logo-type "$type" --logo "$logo" "$@"
}

# Ver todos los dot art de golpe, para elegir cuáles te quedas
fflogos() {
    local f
    for f in "$HOME"/.config/fastfetch/logos/*; do
        [ -f "$f" ] || continue
        printf '\n\033[1m── %s ──\033[0m\n' "$(basename "$f")"
        command fastfetch --logo-type file --logo "$f" --structure title
    done
}

# ─────────────────────────────────────────────────────────────
#  ARRANQUE
# ─────────────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='sh -c "col -bx | bat -l man -p"'

# Colores de pywal en cada terminal nueva
[ -f "$HOME/.cache/wal/sequences" ] && (cat "$HOME/.cache/wal/sequences" &)

# Prompt: la config la genera pywal desde ~/.config/wal/templates/starship.toml
export STARSHIP_CONFIG="$HOME/.cache/wal/starship.toml"
command -v starship >/dev/null && eval "$(starship init "$(basename "$SHELL")")"
command -v zoxide   >/dev/null && eval "$(zoxide init "$(basename "$SHELL")")"

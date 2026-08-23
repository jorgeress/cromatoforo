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

# fastfetch con dot art rotatorio y centrado automatico.
#
# Coge un dibujo al azar de ~/.config/fastfetch/logos/, mide su alto y su
# ancho, mide tambien el bloque de datos, y con eso calcula:
#   - padding-top:  centra el dibujo verticalmente respecto a los datos
#   - padding-left: centra el conjunto entero en la ventana
#
# Si el fichero trae codigos ANSI propios usa file-raw, y si no file, que es
# el que sustituye $1..$9 por la paleta de pywal.
#
# Medir el bloque cuesta una ejecucion extra de fastfetch, unos 50 ms.
fastfetch() {
    local dir="$HOME/.config/fastfetch/logos" logo type arg

    # Si pides un logo a mano, no hay nada que sortear ni que calcular:
    # los rellenos se calcularian sobre el dibujo equivocado.
    for arg in "$@"; do
        case "$arg" in
            -l|--logo|--logo-type|--file|--file-raw|--data|--data-raw|--raw|--sixel|--kitty*)
                command fastfetch "$@"; return ;;
        esac
    done

    # FF_LOGO fuerza uno concreto, para previsualizar: FF_LOGO=flor.txt fastfetch
    if [ -n "${FF_LOGO:-}" ]; then
        logo="$dir/$FF_LOGO"
        [ -f "$logo" ] || logo="$FF_LOGO"
        [ -f "$logo" ] || { echo "fastfetch: no encuentro '$FF_LOGO'" >&2; return 1; }
    else
        logo=$(find "$dir" -maxdepth 1 -type f ! -name '.*' 2>/dev/null | shuf -n1)
    fi

    if [ -z "$logo" ]; then
        command fastfetch "$@"
        return
    fi
    if grep -qU $'\x1b' "$logo" 2>/dev/null; then type=file-raw; else type=file; fi

    # Medidas del dibujo. length() de awk cuenta caracteres, no bytes,
    # siempre que la locale sea UTF-8; el braille ocupa una columna.
    local art_h art_w
    read -r art_h art_w < <(
        sed 's/\x1b\[[0-9;]*[A-Za-z]//g' "$logo" |
        awk '{ n = length($0); if (n > m) m = n } END { print NR, m+0 }'
    )

    # Medidas del bloque de datos. fastfetch alinea los valores con un
    # escape \033[NG (ir a la columna N), asi que el ancho real de una
    # linea es N mas lo que venga detras.
    local info_h info_w
    read -r info_h info_w < <(
        command fastfetch --logo none 2>/dev/null |
        awk '{
            line = $0; w = 0
            if (match(line, /\033\[[0-9]+G/)) {
                col  = substr(line, RSTART+2, RLENGTH-3) + 0
                rest = substr(line, RSTART+RLENGTH)
                gsub(/\033\[[0-9;]*[A-Za-z]/, "", rest)
                w = col + length(rest)
            } else {
                gsub(/\033\[[0-9;]*[A-Za-z]/, "", line)
                w = length(line)
            }
            if (w > m) m = w
        } END { print NR, m+0 }'
    )
    [ -n "$info_h" ] || { info_h=25; info_w=67; }

    # Centrado vertical. Solo aplica si el dibujo es mas bajo que los datos:
    # fastfetch no tiene padding vertical para el lado de los modulos, y
    # --structure permitiria anteponer breaks pero descarta las claves del
    # JSON, asi que con un dibujo mas alto se queda arriba y ya esta.
    local pad_top=0
    [ "$art_h" -lt "$info_h" ] && pad_top=$(( (info_h - art_h) / 2 ))

    # Centrado horizontal del conjunto en la ventana
    local pad_right=4 pad_left=2 cols total
    cols=${COLUMNS:-0}
    [ "$cols" -gt 0 ] 2>/dev/null || cols=$(tput cols 2>/dev/null || echo 80)
    total=$(( art_w + pad_right + info_w ))
    [ "$cols" -gt "$(( total + 4 ))" ] && pad_left=$(( (cols - total) / 2 ))

    command fastfetch --logo-type "$type" --logo "$logo" \
        --logo-padding-top "$pad_top" \
        --logo-padding-left "$pad_left" \
        --logo-padding-right "$pad_right" "$@"
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

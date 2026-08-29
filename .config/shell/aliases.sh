# ─────────────────────────────────────────────────────────────
#  aliases.sh: alias y funciones de shell INTERACTIVO.
#  Lo sourcean ~/.bashrc y ~/.zshrc. Las variables de entorno NO van
#  aquí: están en ~/.config/shell/env.sh, que se lee al hacer login.
#
#  Debe funcionar en bash Y en zsh. Nada de mapfile, ${arr[0]} ni
#  shopt: si necesitas algo específico de un shell, mételo en el
#  .bashrc / .zshrc correspondiente.
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

# yazi: al salir con Q deja la shell en el ultimo directorio que estabas viendo.
# Es la integracion que recomienda yazi; sin ella navegas y vuelves donde estabas.
#
# OJO: aqui NO se puede usar `cat` para leer el fichero. En este mismo fichero
# `cat` esta aliaseado a `bat -pp`, y dentro de una funcion el alias se expande
# igual. Por eso se lee con `read`, que ademas es POSIX y no lanza un proceso.
y() {
    yazi_tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    yazi --cwd-file="$yazi_tmp" "$@"
    IFS= read -r yazi_cwd < "$yazi_tmp"
    [ -n "$yazi_cwd" ] && [ "$yazi_cwd" != "$PWD" ] && cd -- "$yazi_cwd"
    rm -f -- "$yazi_tmp"
    unset yazi_tmp yazi_cwd
}

# lazygit sobre el repo bare de dotfiles, con las mismas rutas que el alias dot.
alias lazydot='lazygit --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'

# Ficha tecnica de un fichero de audio o video: codec, perfil, formato de pixel,
# muestreo, canales. Es lo que uno buscaria en mediainfo, pero con ffprobe, que
# ya viene con ffmpeg. mediainfo se descarto porque su libmediainfo arrastra
# graphviz, y graphviz arrastra ghostscript, gd, gts y netpbm: unos 200 MB para
# leer una cabecera.
#
# Util sobre todo antes de meter algo en Resolve, que es tiquismiquis con los
# formatos (de ahi que exista audio2resolve).
codec() {
    [ -n "${1:-}" ] || { echo "uso: codec FICHERO"; return 1; }
    ffprobe -v error -hide_banner \
        -show_entries format=format_name,duration,size,bit_rate \
        -show_entries stream=index,codec_type,codec_name,profile,width,height,pix_fmt,r_frame_rate,sample_rate,channels \
        -of default=noprint_wrappers=1 -- "$1"
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

# fastfetch con dot art rotatorio, centrado y ajustado al ancho de la ventana.
#
# fastfetch pinta el dibujo y luego salta a una columna fija para los datos.
# Si los dos juntos no caben, las lineas se parten contra el borde y se
# desmonta el dibujo entero. No hay opcion que lo evite, asi que se mide
# antes y se elige modo:
#
#   cabe dibujo + datos  ->  lado a lado, el conjunto centrado
#   cabe solo el dibujo  ->  dibujo arriba centrado, datos debajo
#   ni eso               ->  sin dibujo
#
# Y el sorteo entra solo entre los dibujos que caben: en una ventana media
# salen los estrechos, y ninguno sale partido.
#
# Si el fichero trae codigos ANSI propios usa file-raw, y si no file, que es
# el que sustituye $1..$9 por la paleta de pywal.
#
# Medir el bloque de datos cuesta una ejecucion extra de fastfetch, unos
# 50 ms. Va con --pipe false porque en modo tuberia fastfetch quita colores
# y barras, y entonces el ancho medido no seria el que se va a pintar.
fastfetch() {
    local dir="$HOME/.config/fastfetch/logos"
    local pad_right=4 pad_left_min=2
    local arg logo type

    # Si pides un logo a mano, no hay nada que sortear ni que calcular:
    # los rellenos se calcularian sobre el dibujo equivocado.
    for arg in "$@"; do
        case "$arg" in
            -l|--logo|--logo-type|--file|--file-raw|--data|--data-raw|--raw|--sixel|--kitty*)
                command fastfetch "$@"; return ;;
        esac
    done

    # Ancho de la ventana. COLUMNS solo lo exporta bash en interactivo.
    local cols
    cols=${COLUMNS:-0}
    [ "$cols" -gt 0 ] 2>/dev/null || cols=$(tput cols 2>/dev/null || echo 80)

    # Bloque de datos, guardado entero para poder reusarlo si toca apilar.
    local info_out info_h info_w
    info_out=$(command fastfetch --logo none --pipe false "$@" 2>/dev/null)

    # fastfetch alinea los valores con un escape \033[NG (ir a la columna N),
    # asi que el ancho real de una linea es N mas lo que venga detras.
    read -r info_h info_w < <(
        printf '%s\n' "$info_out" |
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
    [ "${info_h:-0}" -gt 0 ] 2>/dev/null || { info_h=25; info_w=67; }

    # Inventario "alto ancho ruta". FF_LOGO fuerza uno concreto, para
    # previsualizar: FF_LOGO=flor.txt fastfetch
    local -a candidates=()
    local f
    if [ -n "${FF_LOGO:-}" ]; then
        logo="$dir/$FF_LOGO"
        [ -f "$logo" ] || logo="$FF_LOGO"
        [ -f "$logo" ] || { echo "fastfetch: no encuentro '$FF_LOGO'" >&2; return 1; }
        candidates=("$logo")
    else
        for f in "$dir"/*; do
            [ -f "$f" ] && [ -s "$f" ] && candidates+=("$f")
        done
    fi

    # Carpeta vacia: los datos solos, sin dar la lata.
    if [ ${#candidates[@]} -eq 0 ]; then
        printf '%s\n' "$info_out"
        return
    fi

    # length() de awk cuenta caracteres, no bytes, mientras la locale sea
    # UTF-8; el braille ocupa una columna.
    local inventory
    inventory=$(
        awk 'FNR == 1 && NR > 1 { print h, w, f }
             FNR == 1          { f = FILENAME; h = 0; w = 0 }
             {
                 gsub(/\033\[[0-9;]*[A-Za-z]/, "")
                 h = FNR
                 n = length($0)
                 if (n > w) w = n
             }
             END { if (f != "") print h, w, f }' "${candidates[@]}" 2>/dev/null
    )

    # Reparto en dos cestas: los que caben al lado de los datos y los que
    # solo caben de ancho, para ponerlos encima.
    local side="" top="" h w path
    while read -r h w path; do
        [ -n "$path" ] && [ "${w:-0}" -gt 0 ] 2>/dev/null || continue
        [ $(( w + pad_left_min + pad_right + info_w )) -le "$cols" ] &&
            side+="$h $w $path"$'\n'
        [ "$w" -le "$cols" ] && top+="$h $w $path"$'\n'
    done <<< "$inventory"

    local pick="" stacked=0
    if [ -n "$side" ]; then
        pick=$(printf '%s' "$side" | shuf -n1)
    elif [ -n "$top" ]; then
        pick=$(printf '%s' "$top" | shuf -n1)
        stacked=1
    fi

    # Ventana demasiado estrecha hasta para el dibujo mas pequeno: los datos
    # solos, que es lo unico que se lee bien ahi.
    if [ -z "$pick" ]; then
        printf '%s\n' "$info_out"
        return
    fi

    local art_h art_w
    read -r art_h art_w logo <<< "$pick"
    if grep -qU $'\x1b' "$logo" 2>/dev/null; then type=file-raw; else type=file; fi

    if [ "$stacked" -eq 1 ]; then
        # Dibujo arriba, centrado. --structure break pinta el logo y nada
        # mas; es la unica forma de sacarlo suelto.
        command fastfetch --logo-type "$type" --logo "$logo" \
            --logo-padding-top 0 \
            --logo-padding-left "$(( (cols - art_w) / 2 ))" \
            --logo-padding-right 0 \
            --structure break
        # Los datos van pegados a la izquierda a proposito: fastfetch los
        # coloca con columnas absolutas y cualquier sangrado los descuadra.
        printf '%s\n' "$info_out"
        return
    fi

    # Centrado vertical. Solo aplica si el dibujo es mas bajo que los datos:
    # fastfetch no tiene padding vertical para el lado de los modulos, y
    # --structure permitiria anteponer breaks pero descarta las claves del
    # JSON, asi que con un dibujo mas alto se queda arriba y ya esta.
    local pad_top=0
    [ "$art_h" -lt "$info_h" ] && pad_top=$(( (info_h - art_h) / 2 ))

    # Centrado horizontal del conjunto en la ventana
    local pad_left=$pad_left_min total
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
        command fastfetch --logo-type file --logo "$f" --structure break
    done
}

# ─────────────────────────────────────────────────────────────
#  ARRANQUE
# ─────────────────────────────────────────────────────────────

# Colores de pywal en cada terminal nueva
[ -f "$HOME/.cache/wal/sequences" ] && (cat "$HOME/.cache/wal/sequences" &)

# Colores de fzf y eza. Generado por pywal desde
# ~/.config/wal/templates/shell-tools.sh. Entra en shells NUEVAS, igual que
# los plugins de zsh: fzf lee FZF_DEFAULT_OPTS al arrancar y eza EZA_COLORS.
[ -f "$HOME/.cache/wal/shell-tools.sh" ] && . "$HOME/.cache/wal/shell-tools.sh"

# Qué shell está corriendo AHORA. Ojo: $SHELL es el del /etc/passwd, no
# este; usarlo aquí rompía bash en cuanto zsh pasó a ser el login shell.
if   [ -n "${ZSH_VERSION:-}" ];  then _cur_shell=zsh
elif [ -n "${BASH_VERSION:-}" ]; then _cur_shell=bash
else _cur_shell=sh; fi

# Prompt: la config la genera pywal desde ~/.config/wal/templates/starship.toml
# (STARSHIP_CONFIG se exporta en env.sh)
command -v starship >/dev/null && eval "$(starship init $_cur_shell)"
command -v zoxide   >/dev/null && eval "$(zoxide init $_cur_shell)"
unset _cur_shell

# ─────────────────────────────────────────────────────────────
#  VÍDEO: proyectos en ~/video
# ─────────────────────────────────────────────────────────────

# Nuevo proyecto: clona _plantilla con el siguiente número libre.
#   newvid arch-install  ->  ~/video/002-arch-install/
newvid() {
    [ -n "$1" ] || { echo "uso: newvid <nombre-en-kebab-case>"; return 1; }
    local n d
    n=$(printf "%03d" $(( $(find ~/video -maxdepth 1 -type d -name '[0-9]*' | wc -l) + 1 )))
    d=~/video/"$n-$1"
    [ -e "$d" ] && { echo "ya existe: $d"; return 1; }
    cp -r ~/video/_plantilla "$d" || return 1
    sed -i "1s|.*|# ${1//-/ }|" "$d/notas.md"
    cd "$d" && echo "→ $d"
}

# Saltar a un proyecto por número o trozo del nombre:  cdvid 002  |  cdvid arch
cdvid() {
    local d
    d=$(find ~/video -maxdepth 1 -type d -name "*$1*" ! -name '_*' | head -1)
    [ -n "$d" ] && cd "$d" || echo "no encuentro '$1' en ~/video"
}

# 01-footage -> 02-proxies en DNxHR LB. Sin argumentos usa esas dos carpetas
# del proyecto actual; con argumentos, los ficheros que le pases.
mkproxies() {
    local out="02-proxies" src=() f base
    if [ $# -gt 0 ]; then
        src=("$@")
    else
        [ -d 01-footage ] || { echo "no estoy en un proyecto (falta 01-footage/)"; return 1; }
        src=()
        while IFS= read -r f; do src+=("$f"); done < <(
            find 01-footage -maxdepth 1 -type f \
                \( -iname '*.mp4' -o -iname '*.mov' -o -iname '*.mkv' -o -iname '*.avi' \) | sort)
    fi
    [ ${#src[@]} -gt 0 ] || { echo "nada que convertir"; return 1; }
    mkdir -p "$out"
    for f in "${src[@]}"; do
        base=$(basename "${f%.*}")
        [ -f "$out/$base.mov" ] && { echo "skip  $base"; continue; }
        echo "==> $base"
        ffmpeg -hide_banner -loglevel error -stats -i "$f" \
            -c:v dnxhd -profile:v dnxhr_lb -pix_fmt yuv422p \
            -c:a pcm_s16le -ar 48000 \
            "$out/$base.mov" || echo "FALLO en $f"
    done
    echo "listo → $out ($(du -sh "$out" | cut -f1))"
}

# Exportar el proyecto de Resolve abierto no se puede desde fuera, pero sí
# recordar dónde va: backups/ del proyecto actual.
alias drpdir='echo "Resolve → Project Manager → click derecho → Export Project → $PWD/backups/"'

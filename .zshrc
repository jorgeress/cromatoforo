# ─────────────────────────────────────────────────────────────
#  ~/.zshrc — shell interactivo.
#
#  Reparto de responsabilidades:
#    ~/.zshenv                    entorno (vía ~/.config/shell/env.sh)
#    ~/.zprofile                  login: autoarranque de Hyprland en tty1
#    ~/.zshrc                     esto: opciones, historia, completado, plugins
#    ~/.config/shell/aliases.sh   alias y funciones, compartidos con bash
#
#  bash sigue existiendo para scripts (#!/usr/bin/env bash). Cambiar el
#  login shell no toca a los scripts: cada uno usa su shebang.
# ─────────────────────────────────────────────────────────────

# ── Historia ────────────────────────────────────────────────
HISTFILE="$XDG_STATE_HOME/zsh/history"
[ -d "${HISTFILE:h}" ] || mkdir -p "${HISTFILE:h}"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY          # guarda timestamp y duración
setopt INC_APPEND_HISTORY        # escribe al momento, no al salir
setopt SHARE_HISTORY             # historia compartida entre terminales
setopt HIST_IGNORE_ALL_DUPS      # un comando repetido solo aparece una vez
setopt HIST_IGNORE_SPACE         # " comando" no se guarda
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY               # expandir !! y dejarlo editable, no ejecutarlo

# ── Navegación ──────────────────────────────────────────────
setopt AUTO_CD                   # ".." o "/etc" sin escribir cd
setopt AUTO_PUSHD                # cada cd apila; luego `cd -2`
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# ── Globbing ────────────────────────────────────────────────
setopt EXTENDED_GLOB             # **/, ^patrón, (#i)...
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT         # 002.mov antes que 010.mov
unsetopt NOMATCH                 # un glob sin resultados no aborta el comando

# ── Varios ──────────────────────────────────────────────────
setopt INTERACTIVE_COMMENTS      # poder pegar comandos con # sin que pete
setopt NO_BEEP
setopt NO_FLOW_CONTROL           # libera Ctrl-S / Ctrl-Q

# ── Completado ──────────────────────────────────────────────
fpath=(/usr/share/zsh/site-functions $fpath)
autoload -Uz compinit
# compinit revisa permisos de fpath entero en cada arranque (~200 ms).
# Con la caché de menos de un día, se salta la revisión (-C).
if [[ -n "$XDG_CACHE_HOME"/zsh/zcompdump(#qN.mh-24) ]]; then
    compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump"
else
    mkdir -p "$XDG_CACHE_HOME/zsh"
    compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
fi

zstyle ':completion:*' menu select                       # menú navegable con flechas
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' special-dirs true                 # completar . y ..
zstyle ':completion:*:kill:*' force-list always

# ── Teclas ──────────────────────────────────────────────────
bindkey -e                                               # emacs, como en bash
# Buscar en la historia con lo ya escrito (flechas arriba/abajo)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[1;5C' forward-word                           # Ctrl-→
bindkey '^[[1;5D' backward-word                          # Ctrl-←
bindkey '^[[3~'   delete-char
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^H'      backward-kill-word                     # Ctrl-Backspace

# ── Alias y funciones (compartidos con bash) ────────────────
[ -f "$HOME/.config/shell/aliases.sh" ] && . "$HOME/.config/shell/aliases.sh"

# ── pywal16: colores de los plugins ─────────────────────────
# Generado por wal desde ~/.config/wal/templates/zsh-colors.zsh.
# Tiene que ir ANTES de cargar los plugins: define las variables que
# ellos leen al inicializarse.
[ -f "$HOME/.cache/wal/zsh-colors.zsh" ] && . "$HOME/.cache/wal/zsh-colors.zsh"

# ── Plugins ─────────────────────────────────────────────────
# syntax-highlighting debe ir el ÚLTIMO de todos: engancha el ZLE y
# cualquier cosa que lo modifique después se pierde.
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
    . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
    . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf: Ctrl-R historia, Ctrl-T ficheros, Alt-C cd
command -v fzf >/dev/null && source <(fzf --zsh) 2>/dev/null

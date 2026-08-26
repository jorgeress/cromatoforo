# Autogenerado por pywal. NO editar a mano.
# Fuente:  ~/.config/wal/templates/zsh-colors.zsh
# Destino: ~/.cache/wal/zsh-colors.zsh
#
# Se sourcea desde ~/.zshrc ANTES de los plugins.
# En este fichero NO puede haber llaves literales: pywal lo pasa por
# str.format() y una llave suelta aborta la generacion entera.

# ── zsh-autosuggestions ─────────────────────────────────────
# La sugerencia en gris apagado: color8 es el "brillante negro" de la
# paleta, el unico que queda legible sin competir con lo que escribes.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg={color8}'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ── zsh-syntax-highlighting ─────────────────────────────────
typeset -gA ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Comando valido / invalido: el par verde-rojo de la paleta.
ZSH_HIGHLIGHT_STYLES[command]='fg={color2},bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg={color2},bold'
ZSH_HIGHLIGHT_STYLES[function]='fg={color2},bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg={color2},bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg={color2},underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg={color1},bold'

# Rutas: subrayado si existe, sin subrayar si aun no.
ZSH_HIGHLIGHT_STYLES[path]='fg={color4},underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg={color4}'

ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg={color3}'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg={color3}'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg={color3}'
ZSH_HIGHLIGHT_STYLES[backtick-quoted-argument]='fg={color3}'

ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg={color5}'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg={color5}'

ZSH_HIGHLIGHT_STYLES[redirection]='fg={color6}'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg={color6}'
ZSH_HIGHLIGHT_STYLES[comment]='fg={color8},italic'
ZSH_HIGHLIGHT_STYLES[assign]='fg={color7}'
ZSH_HIGHLIGHT_STYLES[default]='fg={color7}'

# Parentesis y corchetes: se van alternando por nivel de anidamiento.
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg={color4},bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg={color5},bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg={color6},bold'
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg={color1},bold'

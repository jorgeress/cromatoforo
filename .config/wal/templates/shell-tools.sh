# Autogenerado por pywal. NO editar a mano.
# Fuente:  ~/.config/wal/templates/shell-tools.sh
# Destino: ~/.cache/wal/shell-tools.sh
#
# Colores de fzf y eza. Se sourcea desde ~/.config/shell/aliases.sh, o sea
# que es POSIX: nada de arrays ni de sustitucion global de bash.
#
# DOS TRAMPAS QUE SE CRUZAN AQUI, LEE ESTO ANTES DE TOCAR NADA:
#
# 1. pywal usa las llaves como marcador. Una llave suelta aborta la generacion
#    de ESTE fichero y te deja el anterior sin avisar. Para que salga una llave
#    literal hay que DOBLARLA en la plantilla.
#
# 2. Y aqui hacen falta llaves de verdad, porque en zsh "$var:tr=..." no es
#    texto: zsh lee ":t" como su modificador de parametro (cola de la ruta) y
#    revienta con "bad substitution". Pasa con :t :r :u :h :a :e y mas, o sea
#    con casi todas las claves de eza. Con llaves alrededor del nombre se lee
#    como lo que es.
#
# De ahi que abajo se vea el nombre entre llaves DOBLES: en la plantilla van
# dobles, en el fichero generado salen simples y zsh lo entiende.

# ── fzf ──────────────────────────────────────────────────────
# fzf SI acepta hex directamente (comprobado con la 0.74.3).
#
# bg y bg+ van a -1 a proposito: -1 significa "el fondo del terminal", asi que
# la ventana de fzf hereda la transparencia de kitty en vez de pintar un
# rectangulo opaco encima. Si algun dia quieres que destaque, cambia bg+.
#
# Los colores de fzf son decoracion pura: marco, cursor, prompt y resaltado de
# coincidencia. No codifican informacion, y por eso aqui se tematiza todo sin
# reparos. Con eza no pasa lo mismo, ver abajo.
FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded --info=inline"
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=fg:{color7},bg:-1,hl:{color4}"
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=fg+:{color15},bg+:-1,hl+:{color6}"
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=info:{color3},prompt:{color2},pointer:{color5}"
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=marker:{color1},spinner:{color3},header:{color8}"
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=border:{color8},gutter:-1"
export FZF_DEFAULT_OPTS

# ── eza ──────────────────────────────────────────────────────
# AQUI SOLO VAN LOS METADATOS, Y ES DELIBERADO.
#
# Los colores de tipo de fichero de eza (di=directorio, ex=ejecutable, ln=
# enlace...) y los de estado de git SIGNIFICAN algo: los lees sin pensar. Si
# les impones una paleta sacada de una foto puedes acabar con directorios y
# ficheros del mismo tono y perder informacion. Esos se dejan como estan, que
# es lo que dice el apartado "No sigue la paleta, y no es un descuido" del
# README.
#
# Lo que si se tematiza son las columnas que solo son ruido visual: permisos,
# tamano, propietario, fecha y cabeceras.
#
# eza NO acepta hex y lo ignora EN SILENCIO. Comprobado: con da=#ff0000 la
# fecha sale sin ningun escape ANSI. Hay que darle 38;2;R;G;B. pywal solo sabe
# emitir "R,G,B" con comas, de ahi el tr de abajo: un unico subshell al abrir
# la shell, que es mas barato que ocho.
_wal_eza="ur=38;2;{color3.rgb}:uw=38;2;{color1.rgb}:ux=38;2;{color2.rgb}:ue=38;2;{color2.rgb}"
_wal_eza="${{_wal_eza}}:gr=38;2;{color3.rgb}:gw=38;2;{color1.rgb}:gx=38;2;{color2.rgb}"
_wal_eza="${{_wal_eza}}:tr=38;2;{color3.rgb}:tw=38;2;{color1.rgb}:tx=38;2;{color2.rgb}"
_wal_eza="${{_wal_eza}}:sn=38;2;{color6.rgb}:sb=38;2;{color8.rgb}"
_wal_eza="${{_wal_eza}}:uu=38;2;{color5.rgb}:un=38;2;{color8.rgb}"
_wal_eza="${{_wal_eza}}:gu=38;2;{color5.rgb}:gn=38;2;{color8.rgb}"
_wal_eza="${{_wal_eza}}:da=38;2;{color4.rgb}"
_wal_eza="${{_wal_eza}}:hd=38;2;{color8.rgb}"
_wal_eza="${{_wal_eza}}:xa=38;2;{color8.rgb}"
EZA_COLORS="$(printf '%s' "${{_wal_eza}}" | tr ',' ';')"
export EZA_COLORS
unset _wal_eza

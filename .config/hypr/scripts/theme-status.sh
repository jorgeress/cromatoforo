#!/usr/bin/env bash
# theme-status.sh: dice de un vistazo si el tematizado esta entero.
#
# Uso:
#   theme-status.sh              informe completo
#   theme-status.sh --templates  solo las plantillas, callado salvo que falle
#
# POR QUE EXISTE
#   wall.sh lanza los themers en segundo plano y con la salida a /dev/null:
#
#       "$HOME/.config/hypr/scripts/steam-theme.sh" >/dev/null 2>&1 &
#
#   Eso esta bien (no quieres ruido en cada cambio de fondo) pero significa que
#   un themer roto falla en SILENCIO, en cada cambio, para siempre. Paso de
#   verdad: steam-theme.sh lanzaba install.py sin ponerse en su directorio y
#   reventaba entero sin que se notara.
#
#   Casi todo lo de aqui falla callado: pywal se come una plantilla con una
#   llave suelta y te deja la anterior, eza ignora un color en hex sin decir
#   nada, GTK cae al tema claro sin avisar. Comprobar cuesta un segundo.
#
# EL MODO --templates
#   Lo llama wall.sh despues de generar la paleta. Compara la fecha de cada
#   fichero del cache con la de ~/.cache/wal/colors, que pywal reescribe
#   siempre. Si una plantilla es mas vieja, es que no se regenero: ahi tienes
#   la llave suelta.
set -uo pipefail

CACHE="${HOME}/.cache/wal"
TPL_DIR="${HOME}/.config/wal/templates"
REF="${CACHE}/colors"
FALLOS=0

if [ -t 1 ]; then OK=$'\033[32mok\033[0m'; MAL=$'\033[31mMAL\033[0m'; NA=$'\033[90m-\033[0m'
else OK="ok"; MAL="MAL"; NA="-"; fi

linea() { printf "  %-26s %s\n" "$1" "$2"; }

# Comprueba si un programa que YA ESTA CORRIENDO arranco antes de la paleta
# actual. Es la diferencia entre "el fichero esta bien" y "lo que estas viendo
# esta bien", y sin esto el informe daba ok a Steam y a Zen llevando dia y
# medio con la paleta vieja en memoria.
#
# La fecha de arranque se saca de /proc/PID, no de `ps -o lstart`, porque ese
# la imprime en el idioma de la sesion y `date -d` no sabe leer "vie ago 28".
proceso_al_dia() { # nombre visible, patron para pgrep, modo (-x o -f)
    local pid ref arr
    if [ "$3" = "-f" ]; then pid="$(pgrep -f "$2" | head -1)"; else pid="$(pgrep -x "$2" | head -1)"; fi
    [ -n "$pid" ] || { linea "$1" "$NA  no esta abierto"; return 0; }
    ref="$(stat -c %Y "$REF")"
    arr="$(stat -c %Y "/proc/$pid")"
    if [ "$arr" -gt "$ref" ]; then
        linea "$1" "$OK  abierto tras la paleta"
    else
        linea "$1" "$MAL  CORRIENDO CON LA PALETA VIEJA, reinicialo"
        FALLOS=$((FALLOS+1))
    fi
}
comprueba() { # nombre, condicion ya evaluada (0/1), detalle
    if [ "$2" -eq 0 ]; then linea "$1" "$OK${3:+  $3}"
    else linea "$1" "$MAL${3:+  $3}"; FALLOS=$((FALLOS+1)); fi
}

# ── plantillas ───────────────────────────────────────────────
plantillas_rancias() {
    [ -f "$REF" ] || { echo "SIN-PALETA"; return; }
    local ref_t; ref_t=$(stat -c %Y "$REF")
    local malas=""
    for tpl in "$TPL_DIR"/*; do
        [ -f "$tpl" ] || continue
        local n out; n=$(basename "$tpl"); out="${CACHE}/${n}"
        if [ ! -f "$out" ] || [ "$(stat -c %Y "$out")" -lt "$ref_t" ]; then
            malas="${malas}${malas:+ }${n}"
        fi
    done
    echo "$malas"
}

if [ "${1:-}" = "--templates" ]; then
    malas="$(plantillas_rancias)"
    [ -z "$malas" ] && exit 0
    notify-send -u critical -a pywal "Plantillas sin generar" \
        "No se regeneraron: ${malas}. Suele ser una llave sin doblar." 2>/dev/null
    echo "pywal no regenero: ${malas}" >&2
    exit 1
fi

echo
echo "PLANTILLAS DE PYWAL"
n_tpl=$(find "$TPL_DIR" -maxdepth 1 -type f | wc -l)
malas="$(plantillas_rancias)"
if [ -z "$malas" ]; then comprueba "las $n_tpl generadas" 0 "paleta de $(date -d @"$(stat -c %Y "$REF")" '+%d %b %H:%M')"
else comprueba "sin regenerar" 1 "$malas"; fi

echo
echo "SE REPINTAN SOLOS"
[ -L "$HOME/.config/btop/themes/pywal.theme" ]; comprueba "btop (enlace)" $?
[ -L "$HOME/.config/cava/config" ];             comprueba "cava (enlace)" $?
grep -q "cache/wal/colors-gtk.css" "$HOME/.config/gtk-3.0/gtk.css" 2>/dev/null
comprueba "GTK3 (import)" $?
grep -q "^color_scheme_path=$HOME/.cache/wal/colors-qt.conf" "$HOME/.config/qt6ct/qt6ct.conf" 2>/dev/null
comprueba "Qt6 (color_scheme_path)" $?
[ -f "$CACHE/shell-tools.sh" ] && grep -q "shell-tools.sh" "$HOME/.config/shell/aliases.sh"
comprueba "fzf y eza" $? "en shells nuevas"

echo
echo "HAY QUE REABRIR EL PROGRAMA"
# Zen: enlace al cache + la pref sin la cual Gecko ignora el userChrome
ZEN="$HOME/.config/zen"
if [ -f "$ZEN/profiles.ini" ]; then
    PROF=$(awk -F= '/^Path=/ {sub(/^Path=/,""); print; exit}' "$ZEN/profiles.ini")
    [ "$(readlink -f "$ZEN/$PROF/chrome/userChrome.css" 2>/dev/null)" = "$CACHE/colors-zen.css" ]
    comprueba "Zen (userChrome)" $?
    grep -qs "legacyUserProfileCustomizations.*true" "$ZEN/$PROF/prefs.js" "$ZEN/$PROF/user.js"
    comprueba "Zen (pref legacy)" $? "sin esto lo ignora"
else linea "Zen" "$NA  sin perfil"; fi

# Steam: el instalador COPIA el css, no lo enlaza, asi que puede quedar viejo
SUI="$HOME/.local/share/Steam/steamui"
if [ -d "$SUI" ]; then
    grep -q "Adwaita-for-Steam" "$SUI/css/library.css" 2>/dev/null
    comprueba "Steam (parcheado)" $?
    cmp -s "$CACHE/colors-steam.css" "$SUI/adwaita/custom.css"
    comprueba "Steam (paleta al dia)" $? "si no: steam-theme.sh"
else linea "Steam" "$NA  no instalado"; fi

# Spotify: Apps/xpui/ = parcheado; Apps/xpui.spa = viene del .deb sin parchear
SPO="$HOME/.local/share/spotify-launcher/install/usr/share/spotify"
if [ -d "$SPO" ]; then
    [ -d "$SPO/Apps/xpui" ]
    comprueba "Spotify (parcheado)" $? "$([ -f "$SPO/Apps/xpui.spa" ] && echo 'una actualizacion se lo llevo')"
    # OJO: comparar el color.ini copiado NO sirve, porque la copia se hace
    # siempre y coincide siempre. Lo que importa es lo que spicetify dejo
    # INYECTADO en el bundle, que solo se actualiza al aplicar; y aplicar solo
    # ocurre con Spotify cerrado. Asi que se lee --spice-main de dentro y se
    # compara con el color0 de la paleta.
    spice_main="$(grep -rhoE '\-\-spice-main:\s*#[0-9a-fA-F]{6}' "$SPO/Apps/xpui/"*.css 2>/dev/null | head -1 | grep -oE '#[0-9a-fA-F]{6}' | tr 'A-F' 'a-f')"
    pal_bg="$(head -1 "$REF" 2>/dev/null | tr 'A-F' 'a-f')"
    [ -n "$spice_main" ] && [ "$spice_main" = "$pal_bg" ]
    comprueba "Spotify (bundle al dia)" $? "${spice_main:-?} vs ${pal_bg:-?}"
    vig=$(systemctl --user is-active spotify-theme.path 2>/dev/null) || true
    [ "$vig" = "active" ]; comprueba "Spotify (vigilante)" $? "${vig:-desconocido}"
else linea "Spotify" "$NA  no instalado"; fi

# yazi y lazygit: enlaces al cache, asi que la paleta siempre esta al dia; lo
# unico que hace falta es reabrir el programa.
if command -v yazi >/dev/null 2>&1; then
    [ "$(readlink -f "$HOME/.config/yazi/theme.toml" 2>/dev/null)" = "$CACHE/yazi-theme.toml" ]
    comprueba "yazi (enlace del tema)" $?
else linea "yazi" "$NA  no instalado"; fi

if command -v lazygit >/dev/null 2>&1; then
    [ "$(readlink -f "$HOME/.config/lazygit/config.yml" 2>/dev/null)" = "$CACHE/lazygit-config.yml" ]
    comprueba "lazygit (enlace)" $?
else linea "lazygit" "$NA  no instalado"; fi

# Obsidian: el snippet vive DENTRO del vault, cuya ruta la elige el usuario, asi
# que hay que preguntarle a obsidian-apply. Se COPIA, no se enlaza (ver el
# comentario de obsidian-apply), asi que lo que se comprueba es que el
# contenido coincida con el del cache.
if command -v obsidian >/dev/null 2>&1; then
    if [ -f "$HOME/.config/obsidian/obsidian.json" ]; then
        sal="$("$HOME/.local/bin/obsidian-apply" --status 2>/dev/null | grep -c "enlace=si activo=si")"
        tot="$("$HOME/.local/bin/obsidian-apply" --status 2>/dev/null | grep -c "enlace=")"
        [ "${sal:-0}" -gt 0 ] && [ "${sal:-0}" -eq "${tot:-1}" ]
        comprueba "Obsidian (snippet)" $? "${sal:-0}/${tot:-0} vaults"
    else linea "Obsidian" "$NA  sin abrir todavia"; fi
else linea "Obsidian" "$NA  no instalado"; fi

echo
echo "LO QUE ESTAS VIENDO AHORA MISMO"
# Aqui no se miran ficheros sino procesos: un Steam abierto desde ayer tiene la
# paleta de ayer por muy al dia que este su CSS en disco.
proceso_al_dia "Steam abierto"   "steam"   -x
proceso_al_dia "Zen abierto"     "zen-bin" -f
proceso_al_dia "Spotify abierto" "spotify" -x

echo
echo "SE REPINTA EN CALIENTE"
if [ -f "$HOME/.config/Code - OSS/User/settings.json" ]; then
    n=$(grep -c '"#' "$HOME/.config/Code - OSS/User/settings.json" 2>/dev/null || echo 0)
    [ "$n" -gt 50 ]; comprueba "Code - OSS" $? "$n colores"
else linea "Code - OSS" "$NA  sin settings.json"; fi

echo
if [ "$FALLOS" -eq 0 ]; then echo "  todo en orden"; else echo "  $FALLOS cosa(s) que mirar"; fi
echo
exit $(( FALLOS > 0 ? 1 : 0 ))

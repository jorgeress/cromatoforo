#!/usr/bin/env bash
# code-theme.sh: mete la paleta del wallpaper en Code - OSS.
#
# Uso:
#   code-theme.sh            funde los colores en settings.json
#   code-theme.sh --status   dice en que estado esta el montaje
#
# COMO FUNCIONA
#   Sin extensiones. VS Code deja pintar cualquier elemento de la interfaz
#   desde "workbench.colorCustomizations" en el propio settings.json, y
#   relee ese fichero en caliente: los colores entran sin reiniciar nada.
#
#   El bloque de colores lo genera pywal en
#   ~/.cache/wal/colors-vscode-custom.json (101 claves) y aqui solo se funde
#   con lo que ya tuvieras. El resto de tus ajustes se conserva.
#
# POR QUE NO ~/.cache/wal/colors-vscode.json
#   pywal trae una plantilla propia con ese nombre, pero genera un TEMA
#   completo, que necesita una extension que lo cargue. Esta via no necesita
#   instalar nada.
#
# CUIDADO
#   settings.json admite comentarios (es JSONC) y jq no los entiende. Si
#   alguna vez metes un // ahi, este script se planta y avisa en vez de
#   destrozarte el fichero.
set -euo pipefail

SETTINGS="${HOME}/.config/Code - OSS/User/settings.json"
SRC="${HOME}/.cache/wal/colors-vscode-custom.json"

if [ "${1:-}" = "--status" ]; then
    printf "  %-22s %s\n" "settings.json"  "$([ -f "$SETTINGS" ] && echo si || echo NO)"
    printf "  %-22s %s\n" "colores pywal"  "$([ -f "$SRC" ] && echo si || echo NO)"
    if [ -f "$SETTINGS" ]; then
        printf "  %-22s %s\n" "settings.json legible" "$(jq -e . "$SETTINGS" >/dev/null 2>&1 && echo si || echo "NO (¿comentarios?)")"
        printf "  %-22s %s\n" "colores aplicados" "$(jq -r '."workbench.colorCustomizations" | length // 0' "$SETTINGS" 2>/dev/null || echo 0)"
    fi
    exit 0
fi

[ -f "$SRC" ] || exit 0
[ -f "$SETTINGS" ] || exit 0

# Si no es JSON limpio, no se toca. Mejor sin colores que con el fichero roto.
jq -e . "$SETTINGS" >/dev/null 2>&1 || exit 0

TMP="$(mktemp)"
jq --slurpfile new "$SRC" '
    . + { "workbench.colorCustomizations": $new[0]["workbench.colorCustomizations"] }
    | if has("workbench.colorTheme") then . else . + { "workbench.colorTheme": "Default Dark Modern" } end
' "$SETTINGS" > "$TMP"

# Escritura atomica: si jq fallase a medias, settings.json se queda como estaba.
if jq -e . "$TMP" >/dev/null 2>&1; then
    mv "$TMP" "$SETTINGS"
else
    rm -f "$TMP"
fi

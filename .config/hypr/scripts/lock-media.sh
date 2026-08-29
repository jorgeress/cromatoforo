#!/usr/bin/env bash
# lock-media.sh: linea de reproduccion para hyprlock.
# Sale vacio si no hay nada sonando, para que la pantalla de bloqueo no
# muestre una linea huerfana.
#
# OJO: con varios reproductores abiertos (Spotify + navegador), un
# `playerctl status` a secas coge un reproductor y `playerctl metadata`
# puede coger otro, mezclando el estado de uno con la cancion del otro.
# Por eso aqui se elige UN reproductor y se le pregunta todo a el.
set -uo pipefail

command -v playerctl >/dev/null || exit 0

PLAYER=""
STATE=""

# Prioridad: el que este sonando. Si ninguno suena, el primero pausado.
while read -r p; do
    [ -n "$p" ] || continue
    s=$(playerctl -p "$p" status 2>/dev/null) || continue
    if [ "$s" = "Playing" ]; then
        PLAYER="$p"; STATE="$s"; break
    elif [ "$s" = "Paused" ] && [ -z "$PLAYER" ]; then
        PLAYER="$p"; STATE="$s"
    fi
done < <(playerctl -l 2>/dev/null)

[ -n "$PLAYER" ] || exit 0

case "$STATE" in
    Playing) ICON="󰐊" ;;
    Paused)  ICON="󰏤" ;;
    *)       exit 0 ;;
esac

INFO=$(playerctl -p "$PLAYER" metadata --format '{{artist}} — {{title}}' 2>/dev/null)
INFO="${INFO# — }"          # sin artista
INFO="${INFO% — }"          # sin titulo
[ -n "$INFO" ] || exit 0

# Recorta lo muy largo para que no se salga de la pantalla
MAX=60
if [ "${#INFO}" -gt "$MAX" ]; then
    INFO="${INFO:0:$MAX}…"
fi

printf '%s  %s\n' "$ICON" "$INFO"

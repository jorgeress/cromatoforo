#!/usr/bin/env bash
# lock-battery.sh — linea de bateria para hyprlock.
# Sale vacio si el equipo no tiene bateria, para no dejar un hueco raro.
set -uo pipefail

BAT=$(find /sys/class/power_supply -maxdepth 1 -name 'BAT*' | head -n1)
[ -n "$BAT" ] || exit 0

CAP=$(cat "$BAT/capacity" 2>/dev/null) || exit 0
ST=$(cat "$BAT/status" 2>/dev/null || echo Unknown)

# Glifos por decil de carga (Nerd Font)
ICONS=(󰂎 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)
IDX=$(( CAP / 10 ))
[ "$IDX" -gt 10 ] && IDX=10
ICON="${ICONS[$IDX]}"

case "$ST" in
    Charging)      ICON="󰂄" ;;
    Full)          ICON="󰁹" ;;
    "Not charging") ICON="󰚥" ;;   # conectado pero sin cargar
esac

printf '%s  %s%%\n' "$ICON" "$CAP"

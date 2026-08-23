#!/usr/bin/env bash
# wall.sh — cambia wallpaper y repinta TODO el sistema con su paleta.
# Uso: wall.sh random | pick | restore | /ruta/a/imagen.jpg
set -euo pipefail

WALLDIR="${HOME}/Pictures/wallpapers"
STATE="${HOME}/.cache/current_wallpaper"

pick_random() { find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | shuf -n1; }

case "${1:-random}" in
    random)  WALL="$(pick_random)" ;;
    pick)    WALL="$(find "$WALLDIR" -type f | wofi --dmenu -p 'Wallpaper')" ;;
    restore) WALL="$(cat "$STATE" 2>/dev/null || pick_random)" ;;
    *)       WALL="$1" ;;
esac

[ -f "$WALL" ] || { notify-send "wall.sh" "No encuentro: $WALL"; exit 1; }
echo "$WALL" > "$STATE"

# 1. Wallpaper con transición
awww img "$WALL" \
    --transition-type grow \
    --transition-pos 0.9,0.9 \
    --transition-duration 1.2 \
    --transition-fps 60

# 2. Generar la paleta (esto escribe todos los ~/.cache/wal/*)
wal -i "$WALL" -n -q

# 3. Recargar cada consumidor de la paleta
hyprctl reload >/dev/null                       # Hyprland relee colors-hypr.lua
pkill -SIGUSR2 waybar || waybar & disown        # waybar recarga estilos
swaync-client --reload-css || true              # centro de notificaciones
pkill -SIGUSR1 kitty || true                    # kitty relee colores en caliente

# Consumidores que NO necesitan recarga explicita aqui:
#   starship  -> STARSHIP_CONFIG apunta a ~/.cache/wal/starship.toml y starship
#                relee el fichero en cada prompt, asi que entra solo.
#   btop      -> ~/.config/btop/themes/pywal.theme es un enlace al cache;
#                coge el tema nuevo al arrancar.
#   cava      -> ~/.config/cava/config es un enlace al cache. cava solo recarga
#                con la tecla 'c' (colores) o 'r'; no acepta senales, y mandarle
#                SIGUSR1 lo mataria.
#   wlogout   -> lee su CSS al lanzarse.

# 4. Colores en terminales ya abiertas
for tty in /dev/pts/*; do
    [ -w "$tty" ] && cat "${HOME}/.cache/wal/sequences" > "$tty" 2>/dev/null || true
done


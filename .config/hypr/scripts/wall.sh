#!/usr/bin/env bash
# wall.sh: cambia wallpaper y repinta TODO el sistema con su paleta.
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

# 2b. Comprobar que TODAS las plantillas se regeneraron.
#
# pywal aborta un fichero entero, sin escribirlo, cuando encuentra un {...}
# que no sabe parsear (por ejemplo un "a { color: red }" de CSS en linea, cuyo
# contenido no empieza por letra). Eso deja el fichero ANTERIOR en su sitio y
# solo lo dice por logging, que aqui va a /dev/null. O sea que sin esto te
# quedas con la paleta vieja en una aplicacion y no te enteras.
#
# El comprobador compara la fecha de cada fichero del cache con la de
# ~/.cache/wal/colors, que pywal reescribe siempre. Avisa por notificacion.
"${HOME}/.config/hypr/scripts/theme-status.sh" --templates || true

# 3. Recargar cada consumidor de la paleta
hyprctl reload >/dev/null                       # Hyprland relee colors-hypr.lua
pkill -SIGUSR2 waybar || waybar & disown        # waybar recarga estilos
swaync-client --reload-css || true              # centro de notificaciones
pkill -SIGUSR1 kitty || true                    # kitty relee colores en caliente

# Qt (qt6ct): el plugin vigila ~/.config/qt6ct/qt6ct.conf, NO el esquema de
# color al que apunta. Regenerar colors-qt.conf no repinta nada; hay que
# tocar el .conf para que el watcher se entere. Comprobado con una app Qt6
# de prueba: sin touch la paleta no se movia; con touch entra 1-2 s despues.
touch "${HOME}/.config/qt6ct/qt6ct.conf" 2>/dev/null || true

# Steam y Spotify: no son GTK ni Qt, hay que parchearlos aparte. Los dos
# scripts salen sin hacer nada si el programa no esta instalado, y ninguno
# reinicia la aplicacion por su cuenta (ver los comentarios de cada uno).
"${HOME}/.config/hypr/scripts/steam-theme.sh"   >/dev/null 2>&1 &
"${HOME}/.config/hypr/scripts/spotify-theme.sh" >/dev/null 2>&1 &

# Code - OSS: funde los colores en settings.json. VS Code relee ese fichero
# en caliente, asi que el editor abierto se repinta solo.
"${HOME}/.config/hypr/scripts/code-theme.sh" >/dev/null 2>&1 &

# Consumidores que NO necesitan recarga explicita aqui:
#   starship  -> STARSHIP_CONFIG apunta a ~/.cache/wal/starship.toml y starship
#                relee el fichero en cada prompt, asi que entra solo.
#   btop      -> ~/.config/btop/themes/pywal.theme es un enlace al cache;
#                coge el tema nuevo al arrancar.
#   cava      -> ~/.config/cava/config es un enlace al cache. cava solo recarga
#                con la tecla 'c' (colores) o 'r'; no acepta senales, y mandarle
#                SIGUSR1 lo mataria.
#   wlogout   -> lee su CSS al lanzarse.
#   zsh       -> ~/.cache/wal/zsh-colors.zsh (autosuggestions y syntax-
#                highlighting) se lee al abrir la shell. Las terminales ya
#                abiertas conservan los colores viejos de los plugins; el
#                resto del tema (fondo, paleta ANSI, prompt) si cambia.
#   steam     -> el CSS entra al arrancar el cliente. NO se reinicia solo:
#                steam-theme.sh --restart lo hace a mano cuando quieras.
#   spotify   -> igual. spotify-theme.sh solo aplica si Spotify esta cerrado;
#                --force lo aplica de todas formas.
#   zen       -> chrome/userChrome.css es un enlace a ~/.cache/wal/colors-zen.css,
#                asi que la paleta nueva ya esta ahi. Pero Firefox y sus forks
#                no recargan el CSS del chrome en caliente: entra al reiniciar
#                el navegador. Enganchado una vez con `zen-apply`.

# 4. Colores en terminales ya abiertas
for tty in /dev/pts/*; do
    [ -w "$tty" ] && cat "${HOME}/.cache/wal/sequences" > "$tty" 2>/dev/null || true
done


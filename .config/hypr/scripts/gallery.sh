#!/usr/bin/env bash
# gallery.sh: genera las capturas de la galeria del README.
#
#   gallery.sh [n]          captura el escritorio con n wallpapers distintos
#                           (por defecto 3, elegidos al azar de ~/Pictures/wallpapers)
#   gallery.sh w1.jpg w2.png ...   usa exactamente esos wallpapers
#   gallery.sh --hyprlock   ademas, captura hyprlock en un compositor headless
#   gallery.sh --solo-hyprlock  solo el bloqueo, sin tocar tu escritorio ni tu
#                           wallpaper. Util para repetir esa captura sola.
#   gallery.sh --margen N   espera N segundos antes de empezar (por defecto 0),
#                           para darte tiempo a cambiar de espacio de trabajo y
#                           dejar el escritorio como quieras que salga
#
# Salida: ~/Pictures/screenshots/gallery/
#
# CAMBIA TU WALLPAPER mientras corre, y lo deja como estaba al terminar (tambien
# si lo cortas con Ctrl+C). Cierra o minimiza lo que no quieras que salga en la
# foto antes de lanzarlo.
#
# hyprlock NUNCA se captura en la sesion real: se levanta un Hyprland headless
# de usar y tirar, igual que hace hyprlock-test.sh. Si esa parte falla, no pasa
# nada: las capturas del escritorio ya estan hechas.
set -uo pipefail

WALLDIR="${HOME}/Pictures/wallpapers"
OUT="${HOME}/Pictures/screenshots/gallery"
WALLSH="${HOME}/.config/hypr/scripts/wall.sh"
ESPERA=4        # transicion de awww (1.2 s) + repintado + watcher de Qt (1-2 s)

command -v grim >/dev/null || { echo "falta grim (pacman -S grim)"; exit 1; }
[ -x "$WALLSH" ] || { echo "no encuentro $WALLSH"; exit 1; }

HYPRLOCK=0
SOLO_LOCK=0
MARGEN=0
args=()
esperando_margen=0
for a in "$@"; do
    if [ "$esperando_margen" -eq 1 ]; then MARGEN="$a"; esperando_margen=0; continue; fi
    case "$a" in
        --hyprlock) HYPRLOCK=1 ;;
        --solo-hyprlock) HYPRLOCK=1; SOLO_LOCK=1 ;;
        --margen)   esperando_margen=1 ;;
        *) args+=("$a") ;;
    esac
done

mkdir -p "$OUT"

# Guardar el wallpaper actual para devolverlo al final, pase lo que pase.
ORIG="$(cat "${HOME}/.cache/current_wallpaper" 2>/dev/null || true)"
restaurar() {
    if [ -n "$ORIG" ] && [ -f "$ORIG" ]; then
        echo "▶ devolviendo tu wallpaper: $(basename "$ORIG")"
        "$WALLSH" "$ORIG" >/dev/null 2>&1
    fi
}
trap restaurar EXIT

if [ "$SOLO_LOCK" -eq 1 ]; then
    WALLS=()
else
# Que wallpapers usar
if [ ${#args[@]} -eq 1 ] && [[ ${args[0]} =~ ^[0-9]+$ ]]; then
    mapfile -t WALLS < <(find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | shuf -n "${args[0]}")
elif [ ${#args[@]} -gt 0 ]; then
    WALLS=("${args[@]}")
else
    mapfile -t WALLS < <(find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | shuf -n 3)
fi
[ ${#WALLS[@]} -gt 0 ] || { echo "no hay wallpapers en $WALLDIR"; exit 1; }
fi

if [ "$SOLO_LOCK" -eq 0 ] && [ "$MARGEN" -gt 0 ] 2>/dev/null; then
    echo "▶ empiezo en $MARGEN s: coloca el escritorio como quieras que salga"
    sleep "$MARGEN"
fi

[ "$SOLO_LOCK" -eq 0 ] && echo "▶ ${#WALLS[@]} capturas del escritorio en $OUT"
i=0
for w in "${WALLS[@]}"; do
    [ -f "$w" ] || { echo "  ✗ no existe: $w"; continue; }
    i=$((i + 1))
    nombre="$(basename "${w%.*}")"
    destino="$OUT/$(printf '%02d' "$i")-$nombre.png"
    echo "  → $nombre"
    "$WALLSH" "$w" >/dev/null 2>&1
    sleep "$ESPERA"
    grim "$destino" && echo "    $destino"
done

[ "$HYPRLOCK" -eq 1 ] || exit 0

# ── hyprlock, en un compositor headless ──────────────────────────────────────
echo "▶ hyprlock en un Hyprland headless (tu sesion no se bloquea)"
TMP=$(mktemp -d)
limpiar_headless() {
    [ -n "${HLPID:-}" ] && kill "$HLPID" 2>/dev/null
    [ -n "${SIG:-}" ] && { sleep 1; rm -rf "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr/$SIG"; }
    rm -rf "$TMP"
}
trap 'limpiar_headless; restaurar' EXIT

# Mismo tamano que la pantalla real, para que la captura encaje con las demas.
printf 'misc { disable_hyprland_logo = true }\n' > "$TMP/min.conf"

instancias() { hyprctl instances -j | python3 -c 'import sys,json;print(" ".join(x["instance"] for x in json.load(sys.stdin)))'; }
antes=$(instancias)

# Ojo: AQ_HEADLESS_ONLY=1 no sirve de nada aqui. Con WAYLAND_DISPLAY puesto,
# Hyprland coge igualmente el backend Wayland y monta una ventana anidada
# (WAYLAND-1) del tamano que le da la gana: 936x1002 o 1888x1002 segun el dia.
# Y quitando WAYLAND_DISPLAY no arranca, revienta con "CBackend::create()
# failed!" porque sin DRM no le queda backend.
#
# Lo que si funciona: dejar que arranque anidado y pedirle DENTRO una salida
# headless con 'hyprctl output create headless'. Esa nace a 1920x1080 clavados
# y se fotografia con 'grim -o'. De paso los avisos del compositor de pruebas
# se quedan en la ventana anidada y no salen en la foto.
Hyprland -c "$TMP/min.conf" >"$TMP/hyprland.log" 2>&1 &
HLPID=$!

SIG=""
for _ in $(seq 1 30); do
    sleep 0.5
    for x in $(instancias); do
        [[ " $antes " == *" $x "* ]] || { SIG=$x; break 2; }
    done
done
[ -n "$SIG" ] || { echo "  ✗ el compositor de pruebas no arranco:"; tail -10 "$TMP/hyprland.log"; exit 1; }

WD=$(hyprctl instances -j | python3 -c "import sys,json;print([x['wl_socket'] for x in json.load(sys.stdin) if x['instance']=='$SIG'][0])")

# Salida headless de 1920x1080 dentro del compositor de pruebas.
HYPRLAND_INSTANCE_SIGNATURE="$SIG" hyprctl output create headless >/dev/null
sleep 1
SALIDA=$(HYPRLAND_INSTANCE_SIGNATURE="$SIG" hyprctl monitors -j | python3 -c 'import sys,json
n=[m["name"] for m in json.load(sys.stdin) if "HEADLESS" in m["name"]]
print(n[0] if n else "")')
[ -n "$SALIDA" ] || { echo "  ✗ no se pudo crear la salida headless"; exit 1; }

# Tu hyprlock.conf usa 'path = screenshot', o sea el escritorio difuminado. En
# un compositor headless no hay escritorio que fotografiar y sale todo negro,
# que no es lo que ves al bloquear. Se apunta al wallpaper directamente: el
# desenfoque, el ruido y el contraste son los mismos, asi que el resultado es
# el que sale de verdad.
CONF_LOCK="$TMP/hyprlock.conf"
sed "s|^\( *path *= *\)screenshot *$|\1${ORIG}|" \
    "${HOME}/.config/hypr/hyprlock.conf" > "$CONF_LOCK"

# El locale va explicito: con 'env -i' a secas se pierde LC_TIME y la fecha
# del bloqueo sale en ingles ("Saturday, 05 de September"), que no es lo que
# se ve en la sesion real.
env -i HOME="$HOME" USER="$USER" PATH="$PATH" XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
    LANG="${LANG:-}" LC_ALL="${LC_ALL:-}" LC_TIME="${LC_TIME:-}" \
    WAYLAND_DISPLAY="$WD" HYPRLAND_INSTANCE_SIGNATURE="$SIG" \
    hyprlock -c "$CONF_LOCK" --grace 0 >"$TMP/hyprlock.log" 2>&1 &
sleep 4   # que pinte el avatar, el reloj, la bateria y la linea de reproduccion

if WAYLAND_DISPLAY="$WD" grim -o "$SALIDA" "$OUT/99-hyprlock.png" 2>"$TMP/grim.log"; then
    echo "    $OUT/99-hyprlock.png"
else
    echo "  ✗ grim no pudo capturar el headless:"; cat "$TMP/grim.log"
fi

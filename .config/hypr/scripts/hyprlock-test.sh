#!/usr/bin/env bash
# Prueba hyprlock.conf en un Hyprland headless de usar y tirar.
# NUNCA bloquea tu sesión real: si la config está rota, te enteras aquí.
#   uso: hyprlock-test.sh [ruta-config]   (por defecto ~/.config/hypr/hyprlock.conf)
set -uo pipefail

CONF="${1:-$HOME/.config/hypr/hyprlock.conf}"
[[ -r $CONF ]] || { echo "no puedo leer $CONF"; exit 2; }

TMP=$(mktemp -d)
cleanup() {
    [[ -n ${HLPID:-} ]] && kill "$HLPID" 2>/dev/null
    [[ -n ${SIG:-} ]] && { sleep 1; rm -rf "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr/$SIG"; }
    rm -rf "$TMP"
}
trap cleanup EXIT
printf 'misc { disable_hyprland_logo = true }\n' > "$TMP/min.conf"

before=$(hyprctl instances -j | python3 -c 'import sys,json;print(" ".join(i["instance"] for i in json.load(sys.stdin)))')

echo "▶ arrancando compositor headless de pruebas..."
AQ_HEADLESS_ONLY=1 Hyprland -c "$TMP/min.conf" >"$TMP/hyprland.log" 2>&1 &
HLPID=$!

SIG=""
for _ in $(seq 1 30); do
    sleep 0.5
    for i in $(hyprctl instances -j | python3 -c 'import sys,json;print(" ".join(x["instance"] for x in json.load(sys.stdin)))'); do
        [[ " $before " == *" $i "* ]] || { SIG=$i; break 2; }
    done
done
[[ -n $SIG ]] || { echo "✗ el compositor de pruebas no arrancó:"; tail -20 "$TMP/hyprland.log"; exit 1; }

WD=$(hyprctl instances -j | python3 -c "import sys,json;print([x['wl_socket'] for x in json.load(sys.stdin) if x['instance']=='$SIG'][0])")
echo "▶ lanzando hyprlock contra $WD (10 s)..."

# El locale va explicito. Con 'env -i' a secas se pierde LC_TIME, y entonces
# esto prueba un bloqueo con la fecha en otro idioma que el que veras al
# bloquear de verdad: '%A, %d de %B' pasa de "sabado, 05 de septiembre" a
# "Saturday, 05 de September".
out=$(env -i HOME="$HOME" USER="$USER" PATH="$PATH" XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
      LANG="${LANG:-}" LC_ALL="${LC_ALL:-}" LC_TIME="${LC_TIME:-}" \
      WAYLAND_DISPLAY="$WD" HYPRLAND_INSTANCE_SIGNATURE="$SIG" \
      timeout 10 hyprlock -v -c "$CONF" --grace 0 2>&1)
rc=$?

echo "$out" | grep -vi 'TRACE' | grep -iE 'error|does not exist|invalid|no such|failed to' \
    && echo "── (avisos arriba: revísalos, aunque no siempre son fatales)"
if [[ $rc -eq 124 ]]; then
    echo "✓ OK: hyprlock aguantó 10 s sin morir. Config usable."
else
    echo "✗ hyprlock SALIÓ solo (código $rc), se te quedaría la pantalla roja. NO la uses:"
    echo "$out" | tail -20
fi
exit $(( rc == 124 ? 0 : 1 ))

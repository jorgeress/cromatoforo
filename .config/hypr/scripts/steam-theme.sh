#!/usr/bin/env bash
# steam-theme.sh — repinta el cliente de Steam con la paleta del wallpaper.
#
# Uso:
#   steam-theme.sh            aplica el tema (silencioso si Steam no esta)
#   steam-theme.sh --restart  aplica y reinicia Steam para verlo ya
#   steam-theme.sh --update   actualiza Adwaita-for-Steam y reaplica
#   steam-theme.sh --status   dice en que estado esta el montaje
#
# COMO FUNCIONA
#   Steam no es GTK ni Qt: su interfaz es Chromium (CEF), asi que el tema del
#   sistema no le llega. Se parchea inyectando CSS en steamui/.
#
#   Usamos el instalador oficial de Adwaita-for-Steam, que admite un CSS
#   propio con --custom-css. Ese CSS es ~/.cache/wal/colors-steam.css, que
#   pywal regenera en cada cambio de wallpaper a partir de la plantilla
#   ~/.config/wal/templates/colors-steam.css.
#
#   El instalador COPIA el CSS dentro de steamui, no lo enlaza: por eso hay
#   que volver a lanzarlo cada vez que cambia la paleta.
#
# POR QUE NO MILLENNIUM
#   Millennium tambien vale, pero en el AUR el paquete se llama `millennium`
#   (no `millennium-steam-patcher`, que no existe) y compila desde fuente con
#   bun + rust + cmake. El propio Adwaita-for-Steam recomienda su instalador y
#   lista Millennium como soporte de terceros. Menos piezas, menos que romper.
#
# LIMITE CONOCIDO
#   Steam NO repinta en caliente. El CSS nuevo entra al arrancar el cliente.
#   Por eso wall.sh solo regenera y aplica; no reinicia Steam nunca por su
#   cuenta (imagina que te lo cierre en mitad de una partida).
#
# ACTUALIZACIONES
#   Adwaita-for-Steam es un clon de git, asi que no hay nada que te avise
#   cuando sale una version nueva. Y hace falta: el skin se rompe cuando Valve
#   cambia la interfaz del cliente, y las releases van a rachas (4.0 a 4.4 en
#   tres semanas de julio de 2026, y antes casi un ano sin tocar nada).
#
#   Solucion: este script comprueba si hay novedades UNA VEZ AL DIA como mucho
#   y te lo dice por notificacion. Nunca hace `git pull` solo: es codigo que se
#   inyecta en tu cliente de Steam, y eso se actualiza a mano y mirando.
set -euo pipefail

ADW_DIR="${HOME}/.local/share/adwaita-for-steam"
CSS="${HOME}/.cache/wal/colors-steam.css"
STAMP="${HOME}/.cache/adwaita-for-steam.checked"
MODE="${1:-apply}"

have_steam()   { command -v steam >/dev/null 2>&1; }
have_adwaita() { [ -x "${ADW_DIR}/install.py" ]; }

apply_theme() {
    # OJO: install.py resuelve sus rutas (adwaita/, adwaita/VERSION...) contra el
    # DIRECTORIO ACTUAL, no contra la suya. Lanzarlo desde fuera revienta con
    # FileNotFoundError: 'adwaita/VERSION'. De ahi el subshell con cd.
    # Y --target default porque sin el prueba tambien flatpak y snap, y avisa
    # por stderr de que no existen: ruido en cada cambio de fondo desde wall.sh.
    (
        cd "$ADW_DIR" || exit 1
        python ./install.py \
            --target default \
            --color-theme adwaita \
            --color-scheme dark \
            --accent-color theme \
            --custom-css "$CSS" >/dev/null
    )
}

# Comprueba si el repo local se ha quedado atras. Silencioso salvo que haya
# algo nuevo. El fichero de sello evita ir a la red en cada cambio de fondo.
check_updates() {
    [ -d "${ADW_DIR}/.git" ] || return 0
    if [ -f "$STAMP" ] && [ "$(( $(date +%s) - $(stat -c %Y "$STAMP") ))" -lt 86400 ]; then
        return 0
    fi
    touch "$STAMP"
    git -C "$ADW_DIR" fetch --quiet --tags origin 2>/dev/null || return 0
    local behind
    behind="$(git -C "$ADW_DIR" rev-list --count HEAD..@{u} 2>/dev/null || echo 0)"
    if [ "$behind" -gt 0 ]; then
        notify-send "Adwaita-for-Steam" \
            "Hay $behind commits nuevos. Actualiza con: steam-theme.sh --update"
    fi
}

if [ "$MODE" = "--status" ]; then
    printf "  %-22s %s\n" "steam"                "$(have_steam   && echo si || echo NO)"
    printf "  %-22s %s\n" "adwaita-for-steam"    "$(have_adwaita && echo "si ($ADW_DIR)" || echo "NO")"
    printf "  %-22s %s\n" "css de la paleta"     "$([ -f "$CSS" ] && echo si || echo NO)"
    if [ -d "${ADW_DIR}/.git" ]; then
        printf "  %-22s %s\n" "version local"    "$(git -C "$ADW_DIR" describe --tags --always 2>/dev/null || echo '?')"
        printf "  %-22s %s\n" "commits por detras" "$(git -C "$ADW_DIR" rev-list --count HEAD..@{u} 2>/dev/null || echo '? (haz fetch)')"
    fi
    have_adwaita || cat <<'HELP'

  Para montarlo:
      sudo pacman -S steam
      git clone https://github.com/tkashkin/Adwaita-for-Steam.git \
          ~/.local/share/adwaita-for-steam
      ~/.config/hypr/scripts/steam-theme.sh --restart
HELP
    exit 0
fi

# En el camino automatico (wall.sh) callarse es lo correcto: la mayoria de las
# maquinas no tendran Steam y no queremos ruido en cada cambio de fondo.
have_steam   || exit 0
have_adwaita || exit 0
[ -f "$CSS" ] || exit 0

if [ "$MODE" = "--update" ]; then
    git -C "$ADW_DIR" pull --ff-only || { echo "El pull no fue limpio; míralo a mano."; exit 1; }
    touch "$STAMP"
fi

apply_theme
check_updates

if [ "$MODE" = "--restart" ] && pgrep -x steam >/dev/null; then
    steam -shutdown >/dev/null 2>&1 || true
    # steam -shutdown vuelve enseguida pero el cliente tarda en morir del todo;
    # arrancar antes de tiempo deja dos instancias peleandose por el socket.
    for _ in $(seq 20); do
        pgrep -x steam >/dev/null || break
        sleep 0.5
    done
    setsid steam >/dev/null 2>&1 &
fi

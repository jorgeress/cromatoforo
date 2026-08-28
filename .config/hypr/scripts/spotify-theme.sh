#!/usr/bin/env bash
# spotify-theme.sh — repinta Spotify con la paleta del wallpaper.
#
# Uso:
#   spotify-theme.sh             copia la paleta; aplica solo si Spotify esta cerrado
#   spotify-theme.sh --force     aplica siempre (Spotify se recarga y hay que reabrirlo)
#   spotify-theme.sh --if-stale  aplica SOLO si una actualizacion se llevo el parche
#   spotify-theme.sh --status    dice en que estado esta el montaje
#
# COMO FUNCIONA
#   Spotify es Electron: ni GTK ni Qt, asi que hay que parchear su bundle.
#   spicetify lo hace. Nosotros solo aportamos el color.ini, que sale de la
#   plantilla ~/.config/wal/templates/spicetify-color.ini.
#
#   Adrede NO instalamos ninguna extension ni el Marketplace: una extension es
#   JavaScript corriendo dentro del contexto de la app, o sea con acceso a los
#   tokens de tu sesion de Spotify. Un color.ini son datos y nada mas. Mantenlo
#   asi.
#
# DOS TRAMPAS DE spotify-launcher
#   1. El cliente NO vive en /opt como con el paquete `spotify` del AUR, sino
#      en ~/.local/share/spotify-launcher/install/usr/share/spotify. Es del
#      usuario, asi que aqui NO hace falta el `sudo chmod a+wr` que piden todas
#      las guias. Eso es una suerte y no un detalle: ese chmod deja el binario
#      de Spotify escribible por cualquier proceso local, que es escalada de
#      privilegios en una maquina multiusuario y un sitio comodo donde
#      persistir. Nos lo saltamos por construccion.
#   2. spotify-launcher reextrae el .deb en cada actualizacion y se lleva por
#      delante el parche, EN SILENCIO. Spotify publica cada 1-3 semanas.
#
# EL ARREGLO DE LA TRAMPA 2 (--if-stale)
#   La senal de deteccion es binaria y no hay que fiarse de fechas ni versiones:
#   spicetify EXTRAE Apps/xpui.spa a un directorio Apps/xpui/ y borra el .spa.
#   O sea:
#       Apps/xpui/      existe  ->  parcheado
#       Apps/xpui.spa   existe  ->  recien salido del .deb, SIN parchear
#   Nunca los dos. Comprobado a mano con `spicetify restore` y `backup apply`.
#
#   Quien dispara la comprobacion es una unidad `path` de systemd de usuario
#   que vigila state.json (ver spotify-theme.path). Ese fichero lo reescribe el
#   launcher en CADA arranque, tenga o no actualizacion, asi que el disparador
#   es tonto y barato y toda la decision vive aqui.
#
# POR QUE NO VALE `spicetify backup apply` A SECAS
#   Con el bundle YA parcheado, ese comando dice "A backup is available",
#   NO HACE NADA Y DEVUELVE 0. Un `cmd || respaldo` nunca cae al respaldo y te
#   quedas creyendo que aplicaste. Hay que elegir el comando segun el estado:
#       sin parchear -> `backup apply`  (borra la copia vieja, rehace y aplica)
#       parcheado    -> `apply`         (solo reinyecta el color)
#   Y ademas comprobar el resultado por POSCONDICION (is_patched), no por
#   codigo de salida, precisamente porque el codigo de salida miente.
#
# SIEMPRE CON -n (--no-restart)
#   Sin ese flag, spicetify REINICIA Spotify al aplicar, y lo ARRANCA aunque
#   estuviera cerrado. Este script corre desde wall.sh y desde una unidad de
#   systemd, o sea por detras: que eso te abra el reproductor solo es de las
#   cosas mas desconcertantes que puede hacer un ordenador. Con -n no toca
#   nunca el proceso; la notificacion ya te dice que reinicies.
set -euo pipefail

SPOTIFY_DIR="${HOME}/.local/share/spotify-launcher/install/usr/share/spotify"
APPS="${SPOTIFY_DIR}/Apps"
STATE="${HOME}/.local/share/spotify-launcher/state.json"
THEME_DIR="${HOME}/.config/spicetify/Themes/pywal"
SRC="${HOME}/.cache/wal/spicetify-color.ini"
STAMP="${HOME}/.cache/spotify-theme.applied"
MODE="${1:-auto}"

have_spicetify() { command -v spicetify >/dev/null 2>&1; }

is_patched() { [ -d "${APPS}/xpui" ]; }
# Rancio = el bundle esta en su forma empaquetada, que es como sale del .deb.
is_stale()   { [ -f "${APPS}/xpui.spa" ]; }

spotify_version() {
    sed -n 's/.*"version":"\([^"]*\)".*/\1/p' "$STATE" 2>/dev/null || echo "?"
}

if [ "$MODE" = "--status" ]; then
    printf "  %-22s %s\n" "spicetify"        "$(have_spicetify && echo si || echo NO)"
    printf "  %-22s %s\n" "cliente spotify"  "$([ -d "$SPOTIFY_DIR" ] && echo si || echo NO)"
    printf "  %-22s %s\n" "tema pywal"       "$([ -f "$THEME_DIR/color.ini" ] && echo si || echo NO)"
    printf "  %-22s %s\n" "spotify corriendo" "$(pgrep -x spotify >/dev/null && echo si || echo no)"
    printf "  %-22s %s\n" "version spotify"  "$(spotify_version)"
    if [ -f "$STAMP" ]; then
        printf "  %-22s %s\n" "aplicado el"   "$(date -d "@$(stat -c %Y "$STAMP")" '+%Y-%m-%d %H:%M')"
        printf "  %-22s %s\n" "parche vigente" "$(is_patched && echo si || echo 'NO (una actualizacion se lo llevo)')"
    else
        printf "  %-22s %s\n" "aplicado el"   "nunca"
    fi
    # OJO: `systemctl is-active` imprime el estado Y devuelve codigo != 0 cuando
    # no esta activo, asi que un `|| echo` de respaldo saca DOS palabras.
    vig="$(systemctl --user is-active spotify-theme.path 2>/dev/null)" || true
    printf "  %-22s %s\n" "vigilante"        "${vig:-desconocido}"
    have_spicetify || cat <<'HELP'

  Para montarlo:
      paru -S spicetify-cli
      ~/.config/hypr/scripts/spotify-theme.sh --force
      systemctl --user enable --now spotify-theme.path
HELP
    exit 0
fi

have_spicetify || exit 0
[ -f "$SRC" ] || exit 0

if [ "$MODE" = "--if-stale" ]; then
    is_stale || exit 0
    # El disparador salta EN MITAD de la actualizacion: el launcher escribe
    # state.json y sigue extrayendo. Parchear un arbol a medio extraer deja
    # Spotify en pantalla blanca, asi que esperamos a que termine.
    # OJO con el pgrep: "spotify-launcher" son 16 caracteres y el nombre de
    # proceso del kernel se trunca a 15, asi que `pgrep -x spotify-launcher` no
    # casa NUNCA (avisa por stderr y devuelve vacio). Con -f casamos la linea de
    # comandos, pero exigiendo que el nombre acabe ahi: el propio Spotify corre
    # desde .../spotify-launcher/install/... y si no, lo confundiriamos con el.
    for _ in $(seq 60); do
        pgrep -f '(^|/)spotify-launcher( |$)' >/dev/null || break
        sleep 1
    done
fi

mkdir -p "$THEME_DIR"
cp "$SRC" "$THEME_DIR/color.ini"

# spicetify no adivina la ruta de spotify-launcher: hay que fijarla una vez.
if [ -d "$SPOTIFY_DIR" ]; then
    spicetify config spotify_path "$SPOTIFY_DIR" >/dev/null 2>&1 || true
fi
spicetify config current_theme pywal color_scheme pywal >/dev/null 2>&1 || true

# Aplicar es lento (segundos) y obliga a reabrir Spotify. En el camino
# automatico solo se hace si Spotify esta cerrado: asi el cambio de wallpaper
# no te tira el reproductor a mitad de cancion. Con --if-stale se aplica
# igualmente, porque el parche YA no esta: no hay nada que romper.
if [ "$MODE" = "--force" ] || [ "$MODE" = "--if-stale" ] || ! pgrep -x spotify >/dev/null; then
    if is_stale; then
        # Bundle empaquetado: spicetify borra la copia caducada, rehace una de
        # los ficheros nuevos y aplica. No hay que borrar nada a mano.
        spicetify -n backup apply >/dev/null 2>&1 || true
    else
        spicetify -n apply >/dev/null 2>&1 || true
    fi

    if is_patched; then
        # El sello se pone DESPUES de aplicar, para que su mtime quede por
        # encima del de xpui.spa que acaba de reescribir spicetify.
        printf 'spotify=%s\naplicado=%s\n' "$(spotify_version)" "$(date -Is)" > "$STAMP"
        if [ "$MODE" = "--if-stale" ]; then
            notify-send -a Spotify -t 8000 "Tema reaplicado" \
                "Una actualizacion de Spotify se habia llevado el parche. Reinicia Spotify para verlo."
        fi
    elif [ "$MODE" = "--if-stale" ]; then
        # Fallo tipico: spicetify aun no soporta la version nueva de Spotify.
        notify-send -a Spotify -u critical -t 10000 "No se pudo reaplicar el tema" \
            "spicetify fallo con Spotify $(spotify_version). Suele ser que va por detras; mira si hay version nueva de spicetify-cli."
    fi
fi

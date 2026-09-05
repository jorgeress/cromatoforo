# cromatóforo

**Arch · Hyprland 0.56 · pywal16**

[![Licencia: MIT](https://img.shields.io/badge/licencia-MIT-blue.svg)](LICENSE)
![Hyprland 0.56](https://img.shields.io/badge/Hyprland-0.56-3b6ea5)
![pywal16](https://img.shields.io/badge/pywal16-color-8a5cf6)
[![English](https://img.shields.io/badge/README-English-lightgrey)](README.en.md)

Un cromatóforo es la célula de pigmento con la que un cefalópodo toma el color de
lo que tiene detrás. Esto hace lo mismo con un escritorio: es la configuración
completa de un Wayland sobre Arch en la que
**todo el sistema se pinta a partir del wallpaper**. Cambias el fondo y la barra,
el lanzador, el terminal, el prompt, las notificaciones, el menú de apagado, el
monitor de sistema, el editor, el navegador y las aplicaciones GTK y Qt adoptan
su paleta en la misma pasada.

Lo que sigue al fondo y lo que no está en
[Qué se tematiza y qué no](#qué-se-tematiza-y-qué-no), medido en este equipo.

Equipo de referencia: MSI Stealth 15 (i7-13620H + RTX 4060 híbrida), pantalla
eDP-2 de 1920x1080 a 144 Hz, escala 1.

---

## Galería

Las mismas nueve pantallas con dos paletas opuestas. **Entre una columna y otra
no se ha tocado ni una línea de configuración**: lo único que cambia es el
wallpaper, y con él la barra, el prompt, el explorador, el editor, el navegador,
Spotify y Steam.

A la izquierda `akira.png`, rojo y muy saturado. A la derecha `kyogre.png`,
turquesa frío. Las capturas están reducidas: pincha en cualquiera para verla
entera.

| | akira | kyogre |
|---|---|---|
| **Escritorio** | ![escritorio con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/escritorio-akira.jpg) | ![escritorio con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/escritorio-kyogre.jpg) |
| **fastfetch** | ![fastfetch con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/fastfetch-akira.jpg) | ![fastfetch con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/fastfetch-kyogre.jpg) |
| **widgets** | ![widgets con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/widgets-akira.jpg) | ![widgets con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/widgets-kyogre.jpg) |
| **btop** | ![btop con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/btop-akira.jpg) | ![btop con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/btop-kyogre.jpg) |
| **Thunar (GTK)** | ![thunar con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/thunar-akira.jpg) | ![thunar con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/thunar-kyogre.jpg) |
| **Code - OSS** | ![code con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/code-akira.jpg) | ![code con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/code-kyogre.jpg) |
| **Zen Browser** | ![zen con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/zen-akira.jpg) | ![zen con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/zen-kyogre.jpg) |
| **Spotify** | ![spotify con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/spotify-akira.jpg) | ![spotify con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/spotify-kyogre.jpg) |
| **Steam** | ![steam con akira](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/steam-akira.jpg) | ![steam con kyogre](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/steam-kyogre.jpg) |

Y la pantalla de bloqueo, que saca su color del mismo sitio:

![hyprlock](https://raw.githubusercontent.com/jorgeress/cromatoforo/media/galeria/hyprlock.jpg)

Las de hyprlock no se pueden hacer con `Shift+Print`, claro: se capturan desde
un Hyprland de usar y tirar con una salida headless dentro, que es lo mismo que
monta [`hyprlock-test.sh`](.config/hypr/scripts/hyprlock-test.sh).

---

## Índice

- [Galería](#galería)
- [El sistema de color](#el-sistema-de-color)
- [Qué se tematiza y qué no](#qué-se-tematiza-y-qué-no)
- [Instalación en una máquina nueva](#instalación-en-una-máquina-nueva)
- [Estructura](#estructura)
  - [El reparto entre zsh y bash](#el-reparto-entre-zsh-y-bash)
- [Atajos de teclado](#atajos-de-teclado)
- [Personalización](#personalización)
  - [Wallpaper y paleta](#wallpaper-y-paleta)
  - [Dot art de fastfetch](#dot-art-de-fastfetch)
  - [Waybar](#waybar)
  - [Efectos de Hyprland](#efectos-de-hyprland)
  - [Prompt (starship)](#prompt-starship)
  - [btop y cava](#btop-y-cava)
  - [GTK](#gtk)
  - [Qt](#qt)
  - [Steam](#steam)
  - [Spotify](#spotify)
  - [Code - OSS](#code---oss)
  - [Zen Browser](#zen-browser)
  - [wlogout y swaync](#wlogout-y-swaync)
  - [hyprlock](#hyprlock)
- [Juegos](#juegos)
- [Cómo probar un cambio](#cómo-probar-un-cambio)
- [Trampas y hallazgos](#trampas-y-hallazgos)
- [Lo que no se versiona](#lo-que-no-se-versiona)
- [Dependencias](#dependencias)

---

## El sistema de color

Un solo origen de verdad: el wallpaper.

```
wallpaper.jpg
     │
     └── wal -i ──► ~/.cache/wal/
                      ├── colors-hypr.lua      → hyprland.lua        (dofile)
                      ├── colors-gtk.css       → waybar, wofi, swaync,
                      │                          wlogout, GTK3, GTK4  (@import)
                      ├── colors-hyprlock.conf → hyprlock            (source)
                      ├── colors-kitty.conf    → kitty               (include)
                      ├── starship.toml        → starship            (STARSHIP_CONFIG)
                      ├── zsh-colors.zsh       → plugins de zsh      (source en .zshrc)
                      ├── shell-tools.sh       → fzf y eza           (source en aliases.sh)
                      ├── yazi-theme.toml      → yazi                (enlace simbólico)
                      ├── lazygit-theme.yml    → lazygit             (`LG_CONFIG_FILE`)
                      ├── obsidian.css         → Obsidian            (copiado al vault)
                      ├── pywal.theme          → btop                (enlace simbólico)
                      ├── cava-config          → cava                (enlace simbólico)
                      ├── colors-qt.conf       → qt5ct/qt6ct → OBS y
                      │                          demás apps Qt        (ruta en el .conf)
                      ├── colors-steam.css     → Steam               (copiado a steamui)
                      ├── spicetify-color.ini  → Spotify             (copiado al tema)
                      ├── colors-vscode-custom → Code - OSS          (fundido en settings.json)
                      ├── colors-zen.css       → Zen Browser         (enlace a userChrome.css)
                      └── sequences            → terminales abiertas
```

Las plantillas que producen esos ficheros están en `~/.config/wal/templates/`.
**Si quieres cambiar cómo se mapean los colores, se toca ahí, nunca en el config
del programa final.**

`~/.config/hypr/scripts/wall.sh` hace la pasada completa: cambia el fondo con
`awww`, regenera la paleta y recarga a cada consumidor.

Cuatro consumidores no necesitan recarga explícita, y está documentado dentro del
propio `wall.sh` para que nadie la añada por error:

| Programa | Por qué no hace falta |
|---|---|
| starship | `STARSHIP_CONFIG` apunta al caché y starship relee el fichero en cada prompt |
| btop | `~/.config/btop/themes/pywal.theme` es un enlace al caché; lo coge al arrancar |
| cava | `~/.config/cava/config` es un enlace al caché; recarga con la tecla `c` |
| plugins de zsh | `~/.zshrc` sourcea el caché al abrir la shell; las ya abiertas se quedan con los colores viejos hasta un `exec zsh` |
| Steam | el CSS se lee al arrancar el cliente. `wall.sh` lo regenera pero **no reinicia Steam**: te lo cerraría en mitad de una partida |
| Spotify | igual. `spotify-theme.sh` reaplica cuando la paleta de dentro del bundle no coincide con la actual, esté abierto o no |

Y uno que **sí** necesita un empujón raro, `qt6ct`: el plugin vigila
`~/.config/qt6ct/qt6ct.conf`, no el esquema de color al que ese fichero apunta.
Regenerar `colors-qt.conf` no repinta nada. Por eso `wall.sh` hace `touch` del
`.conf`: es lo que despierta al vigilante. Ver [trampas](#trampas-y-hallazgos).

**Ojo con `zsh-colors.zsh`:** pywal pasa las plantillas por `str.format()`, así que
ahí no puede haber llaves literales. Por eso el fichero usa `ZSH_HIGHLIGHT_STYLES[x]`
con corchetes y no interpola nada con `${...}`: una llave suelta aborta la
generación de **todas** las plantillas, no solo de esa.

> **Aviso sobre cava:** no le mandes `SIGUSR1` para recargar. No lo soporta, y la
> acción por defecto de esa señal es terminar el proceso.

---

## Qué se tematiza y qué no

Estado real, comprobado en este equipo. Nada de "debería funcionar".

### Cambia solo, al vuelo (SUPER+W y ya)

| Programa | Vía | Notas |
|---|---|---|
| Hyprland | `colors-hypr.lua` | bordes, sombras, glow |
| waybar | `colors-gtk.css` | `SIGUSR2` |
| wofi | `colors-gtk.css` | lee el CSS al lanzarse |
| swaync | `colors-gtk.css` | `swaync-client --reload-css` |
| wlogout | `colors-gtk.css` | lee el CSS al lanzarse |
| kitty | `colors-kitty.conf` | `SIGUSR1`, repinta en caliente |
| starship | `starship.toml` | relee en cada prompt |
| GTK3 / GTK4 | `colors-gtk.css` | Thunar, pavucontrol, GIMP, nwg-look |
| hyprlock | `colors-hyprlock.conf` | al bloquear |
| **Code - OSS** | `colors-vscode-custom.json` | VS Code relee `settings.json` en caliente |
| **Obsidian** | `obsidian.css` | recarga los snippets en caliente. Hay que **copiar** el fichero al vault, no enlazarlo: su vigilante mira el directorio y un enlace no cambia de metadatos |
| terminales abiertas | `sequences` | paleta ANSI y fondo |

### Cambia, pero con retraso o al reabrir

| Programa | Cuándo entra | Por qué |
|---|---|---|
| **Apps Qt6** (OBS Studio, qt6ct) | 1-2 s después del cambio | el `touch` de `qt6ct.conf` despierta al vigilante del plugin |
| btop | al arrancar | el tema es un enlace al caché |
| cava | al pulsar `c` o al arrancar | no acepta señales de recarga |
| plugins de zsh | en shells nuevas | `.zshrc` sourcea el caché al abrir |
| **fzf** y **eza** | en shells nuevas | `aliases.sh` sourcea el caché; fzf lee `FZF_DEFAULT_OPTS` y eza `EZA_COLORS` al arrancar |
| **Steam** | al arrancar el cliente | CSS inyectado en `steamui/`, no recarga en caliente |
| **Spotify** | tras `spicetify apply` y reabrir | hay que reparchear el bundle de Electron |
| **Zen Browser** | al reiniciar el navegador | Firefox y sus forks no recargan el CSS del chrome en caliente |
| **yazi** | al reabrirlo | lee `theme.toml` al arrancar |
| **lazygit** | al reabrirlo | lee su config al arrancar. **No va enlazado**: ver la trampa de abajo |

### No sigue la paleta, y no es un descuido

| Programa | Por qué |
|---|---|
| DaVinci Resolve | Qt con estilo propio incrustado. **No se toca**: es la herramienta de trabajo y su corrección de color depende de que la interfaz sea neutra |
| Discord | Electron sin CSS de usuario. Necesitaría un mod de cliente (Vencord/OpenAsar), que va contra sus términos de servicio |
| Iconos y cursor | Adwaita fijo. Recolorear un tema de iconos entero en cada cambio de fondo es caro y queda mal |

### Aplicaciones Qt5

`QT_QPA_PLATFORMTHEME=qt6ct` **solo** vale para Qt6: una app Qt5 busca un plugin
con ese nombre, no lo encuentra y se queda con su aspecto de fábrica. El fichero
`~/.config/qt5ct/qt5ct.conf` está puesto y apunta al mismo esquema, así que para
una app Qt5 suelta basta con lanzarla así:

```bash
QT_QPA_PLATFORMTHEME=qt5ct la-app
```

En este equipo ahora mismo no hay ninguna app Qt5 de uso diario, por eso la
variable global se queda en `qt6ct`.

---

## Instalación en una máquina nueva

Esto es un **repo bare**: los ficheros viven directamente donde los programas los
leen, sin copias ni enlaces simbólicos hacia un directorio de paquetes.

```bash
# 1. Clonar como bare
git clone --bare https://github.com/jorgeress/cromatoforo.git "$HOME/.dotfiles"

# 2. Alias temporal para esta shell
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# 3. Volcar los ficheros (cuidado: sobrescribe los que ya existan)
dot checkout

# 4. Que 'dot status' no liste los miles de ficheros sin versionar del home
dot config status.showUntrackedFiles no

# 5. Todo lo mecánico de una vez: dconf de GTK, la ruta absoluta de Qt, el
#    userChrome de Zen y el vigilante de Spotify. Es idempotente, y con
#    --dry-run te dice qué haría sin tocar nada.
~/.local/bin/dotfiles-bootstrap

# 6. Paquetes (o `dotfiles-bootstrap --paquetes`, que hace estos dos)
sudo pacman -S --needed - < ~/.config/pkglists/pkgs-repo.txt
paru -S --needed - < ~/.config/pkglists/pkgs-aur.txt

# 6b. zsh como shell de trabajo (bash se queda para los scripts)
chsh -s /usr/bin/zsh

# 7. Primera paleta
mkdir -p ~/Pictures/wallpapers   # mete ahí tus imágenes
awww-daemon &
~/.config/hypr/scripts/wall.sh ~/Pictures/wallpapers/loquesea.jpg

# 8. Opcional: Steam y Spotify (ver sus apartados en Personalización)
~/.config/hypr/scripts/steam-theme.sh   --status
~/.config/hypr/scripts/spotify-theme.sh --status

# 9. Comprobarlo todo de una vez
~/.config/hypr/scripts/theme-status.sh
```

El alias definitivo (`dot`, más `dots`, `dota`, `dotc`, `dotp`, `dotl`) ya viene
en `~/.config/shell/aliases.sh`, que cargan tanto `~/.zshrc` como `~/.bashrc`.

Si el paso 3 se queja de que sobrescribiría ficheros, muévelos antes o acepta la
pérdida con `dot checkout -f`.

---

## Estructura

```
.config/
├── hypr/
│   ├── hyprland.lua          config principal, API Lua de 0.55+
│   ├── hyprlock.conf         pantalla de bloqueo
│   ├── hypridle.conf         apagado de pantalla e idle
│   └── scripts/
│       ├── wall.sh           cambia fondo + repinta todo el sistema
│       ├── wallpicker.sh     selector visual de fondos (wofi con miniaturas)
│       ├── steam-theme.sh    inyecta la paleta en el cliente de Steam
│       ├── spotify-theme.sh  inyecta la paleta en Spotify (spicetify)
│       ├── theme-status.sh   dice de un vistazo si el tematizado esta entero
│       ├── code-theme.sh     funde la paleta en el settings.json de Code
│       ├── hyprlock-test.sh  prueba hyprlock en headless, nunca en tu sesion
│       ├── hyprlock-rescue.sh rescate si hyprlock se queda colgado
│       ├── lock-battery.sh   linea de bateria para hyprlock
│       └── lock-media.sh     linea de reproduccion para hyprlock
├── waybar/                   barra: config.jsonc + style.css
├── wofi/                     lanzador: config + style.css
├── kitty/                    terminal
├── swaync/                   centro de notificaciones
├── wlogout/                  menú de apagado: layout + style.css
├── fastfetch/
│   ├── config.jsonc          módulos elegidos
│   ├── logo.txt              logo de reserva
│   └── logos/                ← tus dot art van aquí
├── btop/                     monitor de sistema
├── cava/                     visualizador de audio (enlace al caché)
├── gtk-3.0/  gtk-4.0/        tematizado de las apps GTK
├── qt5ct/  qt6ct/            tematizado de las apps Qt (apuntan al caché)
├── wal/templates/            LAS PLANTILLAS. El origen de todos los colores
├── shell/
│   ├── env.sh                variables de entorno (POSIX, zsh y bash)
│   └── aliases.sh            alias y funciones (zsh y bash)
├── systemd/user/
│   ├── spotify-theme.path    vigila si una actualizacion se llevo el parche
│   └── spotify-theme.service lo reaplica  (hay que `systemctl --user enable`)
├── MangoHud/MangoHud.conf    HUD de juegos; oculto, Shift_R+F12 lo saca
├── gamemode.ini              GameMode; lee los comentarios antes de tocarlo
└── pkglists/                 listas de paquetes, regenerables con `pkglist`
.local/bin/
├── widgets                   eye candy propio
├── gtk-apply                 reaplica los ajustes GTK que viven en dconf
├── qt-apply                  arregla la ruta absoluta del esquema Qt
├── zen-apply                 engancha el perfil de Zen al userChrome de pywal
├── obsidian-apply            engancha el snippet de pywal al vault de Obsidian
└── dotfiles-bootstrap        deja una maquina recien clonada lista
.zshenv       lee env.sh; se ejecuta siempre, hasta en scripts
.zprofile     login: arranca Hyprland en la tty1
.zshrc        opciones, historia, completado, teclas, plugins
.bashrc       bash interactivo; lee los mismos env.sh y aliases.sh
.bash_profile login de bash; arranca Hyprland igual que .zprofile
```

### El reparto entre zsh y bash

zsh es el shell **interactivo**; bash se queda para los **scripts**, que llevan su
propio `#!/usr/bin/env bash` y por tanto no dependen del login shell.

Lo que comparten los dos vive en `~/.config/shell/`, en POSIX estricto:

| Fichero | Qué lleva | Cuándo se lee |
|---|---|---|
| `env.sh` | `PATH`, `EDITOR`, `XDG_*`, `STARSHIP_CONFIG` | login (`.zshenv` / `.bash_profile`) |
| `aliases.sh` | alias y funciones | interactivo (`.zshrc` / `.bashrc`) |

Por eso `aliases.sh` no puede usar `mapfile`, `shopt` ni indexar arrays con `[0]`:
zsh los cuenta desde 1. Si necesitas algo propio de un shell, va en su `rc`.

**Red de seguridad:** si zsh se rompe, `bash -l` da un entorno equivalente, porque
lee esos mismos dos ficheros.

**Trampa del `chsh`:** el autoarranque de Hyprland estaba solo en `.bash_profile`.
Al pasar el login shell a zsh ese fichero deja de leerse y arrancas en una tty
pelada. Por eso el `exec start-hyprland` está duplicado en `.zprofile`, a propósito.

---

## Atajos de teclado

Modificador: `SUPER`.

### Lanzar cosas

| Atajo | Acción |
|---|---|
| `SUPER + Return` | kitty |
| `SUPER + E` | thunar |
| `SUPER + B` | zen-browser |
| `SUPER + R` | wofi (lanzador de aplicaciones) |
| `SUPER + N` | centro de notificaciones |
| `SUPER + Y` | historial del portapapeles |

### Ventanas

| Atajo | Acción |
|---|---|
| `SUPER + Q` | cerrar |
| `SUPER + SHIFT + Q` | matar |
| `SUPER + F` | pantalla completa |
| `SUPER + V` | flotante |
| `SUPER + P` | pseudo |
| `SUPER + J` | alternar el sentido del split |
| `SUPER + G` | agrupar / desagrupar |
| `SUPER + h j k l` | mover el foco (o flechas) |
| `SUPER + SHIFT + h j k l` | mover la ventana |
| `SUPER + click izq / der` | arrastrar / redimensionar |

### Escritorios

| Atajo | Acción |
|---|---|
| `SUPER + 1..9` | ir al escritorio |
| `SUPER + SHIFT + 1..9` | llevar la ventana al escritorio |
| `SUPER + rueda` | escritorio anterior / siguiente |
| `SUPER + S` | escritorio especial ("magic") |
| `SUPER + SHIFT + S` | llevar la ventana al especial |

### Sistema y capturas

| Atajo | Acción |
|---|---|
| `PRINT` | recorte de región al portapapeles |
| `SHIFT + PRINT` | pantalla completa a `~/Pictures/screenshots` |
| `SUPER + SHIFT + C` | cuentagotas de color |
| `SUPER + CTRL + L` | bloquear |
| `SUPER + CTRL + Q` | menú de apagado |
| `SUPER + W` | wallpaper aleatorio |
| `SUPER + SHIFT + W` | elegir wallpaper |

Las teclas multimedia y de brillo van con `locked = true`, o sea que funcionan
también con la pantalla bloqueada.

---

## Personalización

### Wallpaper y paleta

`SUPER + W` coge uno al azar de `~/Pictures/wallpapers`; `SUPER + SHIFT + W` abre
un selector con miniaturas. Ambos acaban llamando a `wall.sh`, que regenera todo.

Para cambiar **cómo** se derivan los colores, edita las plantillas de
`~/.config/wal/templates/` y regenera con `wal -R -n -q`. Lee antes la sección de
[trampas](#trampas-y-hallazgos): las plantillas tienen una peculiaridad con las
llaves.

### Dot art de fastfetch

**Dónde:** `~/.config/fastfetch/logos/`. Un dibujo por fichero. El nombre y la
extensión dan igual; solo se ignoran los que empiezan por punto.

La función `fastfetch` de `aliases.sh` coge **uno al azar en cada ejecución**. No
hay que registrar nada al añadir uno nuevo: basta con dejar el fichero ahí.
Detecta sola si el arte trae códigos ANSI propios (usa `file-raw` y los respeta) o
si es texto plano (usa `file`, que sustituye `$1`...`$9` por la paleta de pywal, con
lo que el dibujo sigue al wallpaper).

`fflogos` los muestra todos seguidos con su nombre, sin datos al lado, para
descartar rápido.

**Tamaños.** Medidos en este equipo, no estimados:

| Magnitud | Valor |
|---|---|
| Celda de kitty (JetBrainsMono 13) | 10,4 × 23,86 px |
| kitty maximizada en eDP-2 (1888×1002) | **181 columnas × 42 filas** |
| Bloque de datos de fastfetch | **25 líneas**, ~67 columnas |
| Relleno del logo | 2 columnas a la izquierda, 4 a la derecha |

De ahí sale el presupuesto con la ventana maximizada: `2 + arte + 4 + 67 ≤ 181`,
o sea hasta 108 columnas de arte. Pasarse ya no rompe nada (el dibujo se va
arriba o no sale), pero cuanto más ancho, menos veces sale al lado de los datos:

- **Ancho recomendado: hasta ~90 columnas.** Punto dulce entre 40 y 70.
- **Alto máximo: ~40 líneas** antes de que la salida no quepa en la ventana.
  Punto dulce entre 20 y 30, que es lo que equilibra con las 25 líneas de datos.

Por qué no apurar el ancho: las 67 columnas las fija la línea del `CPU`, que es
constante, pero **la línea `Sonando` varía con el título de la canción** y con un
título largo se pasa de ahí. El margen es para eso.

El arte en braille (`⣿⠿⠛`) cuenta como un carácter por columna, así que el ancho
en caracteres es directamente el ancho en columnas.

**Se ajusta al ancho de la ventana.** fastfetch pinta el dibujo y luego salta a
una columna fija para los datos. Si los dos juntos no caben, las líneas se parten
contra el borde y el dibujo se desmonta; no hay opción de fastfetch que lo evite.
Así que la función mide primero y elige modo:

| Cabe en la ventana | Modo |
|---|---|
| `2 + arte + 4 + datos` | **lado a lado**, el conjunto centrado |
| solo el ancho del arte | **dibujo arriba** centrado, datos debajo |
| ni eso | **sin dibujo**, solo los datos |

Y el **sorteo entra solo entre los dibujos que caben** en el modo elegido: en una
ventana media salen los estrechos, y ninguno sale partido. Con la ventana
maximizada (181 columnas) entran todos.

En el modo apilado los datos van pegados a la izquierda a propósito: fastfetch
los coloca con columnas absolutas (`\033[NG`), y cualquier sangrado que se les
ponga delante los descuadra.

En modo lado a lado sigue habiendo **centrado vertical**: `--logo-padding-top`
centra el dibujo respecto a los datos cuando el dibujo es más bajo. Si es **más
alto** se queda alineado arriba y continúa por debajo. No es un descuido:
fastfetch no tiene relleno vertical para el lado de los módulos, y `--structure`
permitiría anteponer líneas en blanco pero **descarta las claves definidas en el
JSON** (saldría `Host` en vez de `Equipo`). Si quieres un dibujo alto
perfectamente centrado, recórtalo a 25 líneas o menos.

Medir el bloque cuesta una ejecución extra de fastfetch, unos 50 ms. Es
imperceptible y evita tener números cableados que se quedan obsoletos en cuanto
tocas los módulos. Va con `--pipe false`: en modo tubería fastfetch quita colores
y barras, y entonces el ancho medido no sería el que se va a pintar.

**Límite de abajo:** por debajo de ~68 columnas ya no es el dibujo lo que estorba,
sino el propio bloque de datos, que es lo que mide de ancho. Ahí no hay nada que
recortar salvo módulos.

**Previsualizar uno concreto** sin esperar a que salga por sorteo:

```bash
FF_LOGO=flor.txt fastfetch
```

Si pasas tú un `--logo`, `--file` o similar, la función se aparta y llama a
fastfetch directamente: calcular los rellenos con el dibujo sorteado mientras se
muestra otro daría un montaje descuadrado.

Si algún día prefieres una imagen de verdad en vez de ASCII, kitty soporta el
protocolo gráfico: sería `"type": "kitty"` y la ruta del PNG en `config.jsonc`.

### Waybar

Módulos en `config.jsonc`, aspecto en `style.css`. El diseño es de **islas
flotantes**: `window#waybar` es transparente y cada grupo de módulos lleva su
propio fondo redondeado.

Eso obliga a una regla de capa en `hyprland.lua`:

```lua
hl.layer_rule({ name = "blur-waybar", match = { namespace = "^waybar$" },
                blur = true, ignore_alpha = 0.5 })
```

`ignore_alpha = 0.5` es lo que hace que **el desenfoque solo se aplique a las
islas** (alpha 0,75) y no a los huecos vacíos (alpha 0), que si no emborronarían
el fondo de pantalla. Si cambias la opacidad de `@bg_rgb` en la plantilla, ajusta
también ese umbral para que quede por debajo.

### Efectos de Hyprland

En el bloque `decoration` de `hyprland.lua`:

| Ajuste | Qué hace |
|---|---|
| `blur` | desenfoque de fondo. `size`, `passes`, `vibrancy` |
| `glow` | halo de color en la ventana activa. Novedad de 0.56 |
| `motion_blur` | estela al mover y redimensionar. Novedad de 0.56 |
| `shadow` | sombra |
| `rounding` | redondeo de esquinas |

El glow coge su gradiente de `C.glow_a` / `C.glow_b`, definidos en la plantilla
`colors-hypr.lua`. La animación `glowangle` (con `style = "loop"`) debería rotar
el ángulo del gradiente.

> **Sin confirmar:** que la rotación de `glowangle` funcione de verdad. El halo se
> pinta y coge los colores correctos, pero no llegué a verificar que el gradiente
> gire. Trátalo como pendiente.

Para probar valores en caliente sin editar el fichero, usa `hyprctl eval` (ver
[trampas](#trampas-y-hallazgos)).

### Prompt (starship)

Se edita en `~/.config/wal/templates/starship.toml`, **no** en
`~/.cache/wal/starship.toml`, que es el generado.

Trae directorio con sustituciones de icono por carpeta, rama y estado de git,
duración del comando a partir de 2 s, y versiones de python/node/rust/go cuando
toca. El `❯` cambia de color con el estado de salida.

### btop y cava

Ambos consumen un fichero generado, enlazado desde el caché:

- `~/.config/btop/themes/pywal.theme` → `~/.cache/wal/pywal.theme`
- `~/.config/cava/config` → `~/.cache/wal/cava-config`

Para tocarlos, edita las plantillas correspondientes y regenera. El gradiente de
cava usa solo `color0`-`color8` a propósito: ver [trampas](#trampas-y-hallazgos).

### GTK

`gtk-3.0/` y `gtk-4.0/` llevan cada uno un `settings.ini` (tema, iconos, fuente,
cursor) y un `gtk.css` con las reglas de color.

Los `gtk.css` están escritos con **reglas explícitas sobre widgets**, no
redefiniendo los colores internos de Adwaita. Es feo pero es lo único que
funciona; la explicación está en [trampas](#trampas-y-hallazgos).

Iconos y cursor son Adwaita porque es lo único instalado. Si instalas algo como
`papirus-icon-theme`, cámbialo en los dos `settings.ini` y en `gtk-apply`.

### Qt

Las aplicaciones Qt no leen nada de GTK. El puente es `qt6ct`, que sí acepta un
esquema de color externo, y ahí es donde entra pywal:

```
~/.config/wal/templates/colors-qt.conf
        │  wal -i
        ▼
~/.cache/wal/colors-qt.conf          ← 21 colores ARGB por fila
        ▲
        │  color_scheme_path (ruta absoluta)
~/.config/qt6ct/qt6ct.conf           ← estático, se versiona
```

Tres cosas que hay que respetar o no funciona:

1. **`style=Fusion`.** Es el único estilo que aplica la paleta personalizada
   entera. Con el estilo por defecto entra a medias.
2. **`custom_palette=true`.** Sin esto ignora `color_scheme_path`.
3. **La ruta es absoluta y no expande `$HOME`.** Por eso existe `qt-apply`.

Para cambiar el mapeo de colores se toca la plantilla, nunca `qt6ct.conf`.

Quién se beneficia hoy: **OBS Studio** (Qt6), el propio `qt6ct` y cualquier
cosa Qt6 que instales. DaVinci Resolve no, y es a propósito.

### Steam

Steam **no es GTK ni Qt**: su interfaz es Chromium empaquetado (CEF), así que el
tema del sistema no le llega. Hay que inyectarle CSS.

Montaje (una sola vez):

```bash
sudo pacman -S steam
git clone https://github.com/tkashkin/Adwaita-for-Steam.git \
    ~/.local/share/adwaita-for-steam
# Abre Steam una vez y cierralo: hasta que no exista ~/.local/share/Steam el
# instalador del tema no tiene donde escribir.
~/.config/hypr/scripts/steam-theme.sh --restart
```

Clónalo **completo**, sin `--depth 1`: `--status` usa `git describe --tags` y
`rev-list HEAD..@{u}`, y con un clon superficial los dos mienten.

A partir de ahí, cada `SUPER+W` regenera `~/.cache/wal/colors-steam.css` (un
*color theme* de Adwaita-for-Steam con la paleta del fondo) y lo reinstala. El
cliente lo coge **al arrancar**: `wall.sh` no reinicia Steam nunca por su cuenta.
Para verlo ya, `steam-theme.sh --restart`.

`steam-theme.sh --status` dice qué falta, qué versión tienes y cuántos commits
te faltan.

**Mantenerlo al día.** Es un clon de git, así que nada te avisa cuando sale una
versión nueva, y hace falta, porque el skin se rompe cuando Valve cambia la
interfaz del cliente. El ritmo va a rachas: de la 4.0 a la 4.4 en tres semanas de
julio de 2026, y antes de eso casi un año sin tocar nada.

`steam-theme.sh` comprueba si hay novedades **una vez al día como mucho** (un
fichero de sello en `~/.cache` evita ir a la red en cada `SUPER+W`) y te lo dice
con `notify-send`. Nunca hace `git pull` solo: es código que se inyecta en tu
cliente de Steam, y eso se actualiza a mano y mirando el diff.

```bash
steam-theme.sh --update    # git pull --ff-only y reaplica
```

**Las otras dos opciones**, por si el día de mañana prefieres otra cosa:

| | Avisa de actualizaciones | Encaja con pywal |
|---|---|---|
| Instalador + este script | sí, por notificación diaria | sí, es lo que hay montado |
| `adwsteamgtk` (AUR, 16 votos) | sí, vía `paru -Syu` | no: es una GUI, no se puede guionizar |
| Millennium | sí, avisa dentro del cliente | sí, mismo formato de CSS |

`adwsteamgtk` es la única de las tres que se actualiza con el sistema, pero es un
envoltorio gráfico: no hay manera de meterle un CSS nuevo desde `wall.sh`.

**Por qué gana nuestro CSS.** El tema base (`adwaita`) trae sus propios colores
con `!important`, así que el orden del cascade decide. Comprobado ya con Steam
instalado, no solo leyendo el código: el parche que se inyecta en `steamui` importa primero el tema y
**después** `config.css`, que es donde cae nuestro `custom.css`. Al ir el último
entre declaraciones igual de específicas, gana. Además, el import del colortheme
solo se emite `if self.color_theme != "adwaita"`, así que pasando `-c adwaita` no
hay ningún colortheme compitiendo: solo el nuestro.

**Sobre Millennium: por qué no, y qué lo cambiaría.**

Millennium es la alternativa más nombrada y es un proyecto sano (4.238 estrellas,
MIT, C++, en desarrollo activo). No se descarta por malo. Se descarta por cómo
encaja aquí.

*1. Se instala secuestrando una biblioteca.* Su script de instalación hace:

```bash
ln -sf /usr/lib/millennium/libmillennium_bootstrap_x86.so \
       "$HOME/.local/share/Steam/ubuntu12_32/libXtst.so.6"
```

Sustituye la `libXtst.so.6` que Steam trae (la del *X11 Test Extension*) por la
suya. Steam la carga creyendo que es la de X11 y así entra Millennium en el
proceso. Antes usaba `LD_PRELOAD`; el propio script limpia esos restos.

*2. De ahí sale el riesgo que de verdad importa.* Si algo se rompe con el
inyector, **Steam puede no arrancar**: le falta una biblioteca que espera cargar.
Con la vía del CSS, lo peor que pasa es que Steam se vea feo, y el instalador
tiene `--uninstall`. Un fallo cosmético frente a un fallo que te deja sin cliente.

*3. Compilar cuesta y aun así vas por detrás.* El paquete `millennium` del AUR se
construye desde fuente con `cmake`, `ninja`, `rust`, `bun` y una pila de
dependencias `lib32`. Y está clavado a un commit concreto en la 3.4.1, mientras
arriba ya van por la v3.5.0-beta.2: solo en agosto de 2026 salieron la 3.4.0, la
3.4.1 y dos betas de la 3.5.

*4. Y ahora lo interesante: la ventaja real que tendría.* Millennium tiene un
fichero `quick.css` en `$MILLENNIUM__CONFIG_PATH`, un vigilante inotify sobre él
(`src/util/file_watcher.cc`) y una función `OnQuickCssFileChanged` expuesta al
cliente que reinyecta el CSS en todos los popups **sin reiniciar Steam**. Eso es
exactamente lo único que a este montaje le falta.

Salvo que hoy no funciona: `Core_WatchQuickCss` solo aparece declarado en
`utils/ffi.ts` y en los ficheros de prueba. **Nada del frontend llama nunca a
`registerWatcher`.** El vigilante existe en el backend y no lo arranca nadie, así
que la ruta en vivo solo se dispara escribiendo en el editor de Millennium.

O sea que está a una línea de ser mejor opción que esto. **El día que lo
conecten, merece la pena cambiarse**, porque el repintado en caliente es lo único
que la vía del instalador no puede dar. Mientras tanto, no.

*5. Detalle de nomenclatura.* En el AUR el paquete es **`millennium`** (o
`millennium-bin`). `millennium-steam-patcher` **no existe**, aunque circule mucho
ese nombre.

Si algún día te pasas, la plantilla de pywal vale igual: `quick.css` admite el
mismo CSS de variables `--adw-*` que generamos ahora.

**Reglas de ventana.** Van en `hyprland.lua` y son tan importantes como el tema.
Steam es XWayland y sus menús desplegables se abren sin título y con tamaño cero:
Hyprland les quita el foco al soltar el ratón y el menú desaparece. La traducción
a la API Lua de 0.56 de la receta clásica del wiki:

```
stayfocused, class:^(steam)$, title:^()$   →   stay_focused = true
minsize 1 1, class:^(steam)$, title:^()$   →   min_size     = "1 1"
```

**GPU.** En las opciones de lanzamiento de cada juego:

```
prime-run %command%                 # usa la 4060 en vez de la Intel
prime-run mangohud %command%        # + monitor de rendimiento
```

Aquí `prime-run` sí es lo que quieres, al contrario que con DaVinci Resolve
(ver [trampas](#trampas-y-hallazgos)).

### Spotify

También Electron, también hay que parchear el bundle. La herramienta es
`spicetify`:

```bash
paru -S spicetify-cli
~/.config/hypr/scripts/spotify-theme.sh --force
systemctl --user enable --now spotify-theme.path   # ver mas abajo: reaplicado automatico
```

El tercer comando **hace falta**: el enlace de `default.target.wants/` que crea
`systemctl enable` es estado de systemd, no configuracion, y no se versiona.
Sin el, las unidades estan en el repo pero dormidas.

`SUPER+W` regenera `~/.cache/wal/spicetify-color.ini` y lo copia al tema
`~/.config/spicetify/Themes/pywal/`.

**Cuándo se aplica el parche.** Durante un tiempo la regla fue "solo si Spotify
está cerrado", para no tirarte el reproductor a mitad de canción. Esa regla
tenía sentido cuando `spicetify apply` reiniciaba Spotify, pero desde que todo
va con `-n` ya no lo toca nunca, y la restricción se quedó ahí haciendo daño:

> Cambiabas de fondo con Spotify abierto → se copiaba el `color.ini` pero no se
> aplicaba → cerrabas Spotify → **seguía con los colores viejos para siempre**,
> porque el `color.ini` ya coincidía y nadie volvía a intentarlo.

Ahora la condición es la correcta: se aplica cuando el `--spice-main` que hay
**inyectado en el bundle** no coincide con el `color0` de la paleta. Eso arregla
el caso de arriba y de paso evita reaplicar por gusto. Si Spotify está abierto,
los colores nuevos los ves al reabrirlo.

**Lo caro no es el tiempo, es el reinicio.** Medido en este equipo: el trabajo
gordo de `spicetify apply` es descomprimir, parchear y recomprimir
`Apps/xpui.spa`, que son 11 MB comprimidos, 39 MB y 543 ficheros al abrirlo. Ese
ciclo tarda **~1 s**, y el `apply` completo unos pocos segundos contando el
arranque del proceso y la copia de seguridad.

O sea que no molesta por lento. Molesta porque Spotify carga ese bundle **al
arrancar**: para ver el color nuevo hay que cerrarlo y abrirlo. Por eso el script
no lo hace mientras esté sonando algo.

**Si quisieras color en vivo**, existe: `spicetify watch -l` levanta un vigilante
que se conecta al depurador remoto de Spotify y le manda un reload cuando cambia
el `color.ini`. Pero pide `spicetify enable-devtools` (que parchea `offline.bnk`)
y dejar un demonio corriendo. Para un cambio de wallpaper no compensa; para
diseñar un tema, sí.

Dos cosas propias de `spotify-launcher` que no salen en las guías:

1. El cliente **no está en `/opt`**, sino en
   `~/.local/share/spotify-launcher/install/usr/share/spotify`. Como es del
   usuario, aquí **no hace falta** el `sudo chmod a+wr` que piden todos los
   tutoriales (escritos para el paquete `spotify` del AUR). Lo que sí hace falta
   es decirle la ruta a spicetify, y de eso se encarga el script.
2. `spotify-launcher` reextrae el `.deb` en cada actualización y **se lleva por
   delante el parche**, en silencio. Spotify publica cada 1-3 semanas, así que
   pasa a menudo. No es un fallo del montaje: es cómo funciona el launcher.

**Eso está resuelto y no hay que hacer nada.** La unidad `spotify-theme.path`
vigila el `state.json` del launcher y lanza `spotify-theme.sh --if-stale`. El
disparador es tonto a propósito (ese fichero se reescribe en **cada** arranque,
haya actualización o no) y toda la decisión vive en el script.

La señal de detección es binaria y no depende de fechas ni de versiones:
spicetify **extrae** `Apps/xpui.spa` a un directorio `Apps/xpui/` y borra el
`.spa`. Así que:

| En el disco | Significa |
|---|---|
| `Apps/xpui/` | parcheado |
| `Apps/xpui.spa` | recién salido del `.deb`, sin parchear |

Nunca están los dos. Cuando salta, el script espera a que `spotify-launcher`
termine de extraer (parchear un árbol a medio extraer deja Spotify en pantalla
blanca), reaplica y te avisa por notificación de que reinicies Spotify.

Todo esto va con `spicetify -n`: sin ese flag spicetify **reinicia Spotify al
aplicar, y lo abre aunque estuviera cerrado**. Corriendo desde `wall.sh` y desde
una unidad de systemd, eso significaría que cambiar de fondo de pantalla te
puede abrir el reproductor.

### Code - OSS

**Sin instalar ninguna extensión.** VS Code deja repintar cualquier elemento de
su interfaz desde `workbench.colorCustomizations`, en el propio `settings.json`,
y relee ese fichero en caliente: el editor abierto cambia de color solo.

`code-theme.sh` funde las 101 claves que genera pywal con lo que ya tuvieras en
`settings.json`, sin tocar el resto de tus ajustes. La primera vez fija también
`workbench.colorTheme` a `Default Dark Modern` como base sobre la que pintar; si
ya tenías un tema puesto, lo respeta.

Se genera desde `colors-vscode-custom.json`, **no** desde el `colors-vscode.json`
que trae pywal de serie: ese produce un tema completo que necesita una extensión
que lo cargue.

Una precaución dentro del script: `settings.json` admite comentarios (es JSONC) y
`jq` no los entiende. Si algún día metes un `//` ahí, el script se planta y avisa
en vez de destrozarte el fichero.

### Zen Browser

Zen es un fork de Firefox, así que se pinta con `userChrome.css`. Dos cosas hay
que saber antes:

**No usa las variables de Firefox.** `--toolbar-bgcolor`,
`--tab-selected-bgcolor` y `--lwt-sidebar-background-color` no aparecen ni una
vez en su `omni.ja`. Zen tiene su propio juego `--zen-*`. Los nombres de la
plantilla salen de mirar el binario instalado, no de una guía:

```bash
unzip -p /opt/zen-browser-bin/browser/omni.ja | grep -o -- '--zen-[a-z-]*' | sort -u
```

Si Zen se actualiza y algo deja de pintarse, ese es el sitio donde mirar.

**Hay que activar una pref o el CSS se ignora en silencio.** De eso y de enlazar
el perfil se encarga `zen-apply`, que se ejecuta una vez:

```bash
~/.local/bin/zen-apply
```

Enlaza `chrome/userChrome.css` al fichero del caché, así que a partir de ahí cada
cambio de fondo ya está ahí. Pero **el chrome no recarga en caliente**: entra al
reiniciar el navegador.

Zen tiene además su propio selector de color en ajustes. Si lo tocas ahí, puede
pelearse con estas reglas.

### wlogout y swaync

- **wlogout:** `layout` define los seis botones (etiqueta, acción, glifo, tecla) y
  `style.css` el aspecto. Ojo: wlogout **rellena la rejilla por columnas**, así
  que el orden del fichero sale traspuesto en pantalla. El layout ya está escrito
  contando con eso. Los lanzadores pasan `-b 3` y márgenes.
- **swaync:** `config.json` para posición, tamaños y widgets; `style.css` para el
  aspecto. Tras tocar el CSS, `swaync-client --reload-css` responde con
  `success: true` o con el error de parseo, que va bien para validar.

### hyprlock

`hyprlock.conf` usa **hyprlang, no Lua**, y toma los colores de
`~/.cache/wal/colors-hyprlock.conf`.

Lleva reloj, fecha, saludo, campo de contraseña, y tres cosas mas:

- **Avatar.** Deja una imagen cuadrada (PNG o JPG) en `~/.face`. Si el fichero no
  existe, hyprlock simplemente no dibuja el circulo y sigue funcionando con
  normalidad: no hay que tocar la config para quitarlo ni para ponerlo. El tamano
  y el borde se ajustan en el bloque `image`.
- **Bateria**, arriba a la derecha, via `lock-battery.sh`. Sale vacia si el equipo
  no tiene bateria.
- **Reproduccion**, abajo al centro, via `lock-media.sh`. Sale vacia si no hay
  nada sonando, para no dejar una linea huerfana.

Los dos scripts se pueden ejecutar sueltos en un terminal para ver que devuelven,
que es la forma comoda de probarlos sin bloquear la pantalla.

> Para probar cambios en el bloqueo sin quedarte fuera: lanza
> `hyprlock --grace 300` y cierra el proceso con `pkill hyprlock` desde otra
> parte. El `grace` alto es la red de seguridad, porque durante esos segundos
> cualquier tecla lo descarta sin contrasena.

---

## Juegos

Esto no va de colores, va de que los juegos usen la tarjeta correcta.

**Este portátil es Optimus muxless.** El panel lo pinta la Intel (`card2-eDP-2`,
driver `i915`); el eDP de la NVIDIA está desconectado y `boot_vga` es la Intel.
Consecuencia práctica: **un juego arranca en la UHD Graphics y no te avisa**. Lo
único que notas es que va mal, y culpas al juego.

Por eso, en las opciones de lanzamiento de cada juego en Steam:

```
prime-run gamemoderun mangohud %command%
```

`prime-run` (del paquete `nvidia-prime`) es lo no negociable: exporta
`__NV_PRIME_RENDER_OFFLOAD=1`, `__GLX_VENDOR_LIBRARY_NAME=nvidia` y
`__VK_LAYER_NV_optimus=NVIDIA_only`.

Medido en esta máquina, que es distinto de lo que suele contarse:

| | Sin `prime-run` | Con `prime-run` |
|---|---|---|
| OpenGL (`glxinfo -B`) | Mesa Intel (RPL-P) | NVIDIA RTX 4060 |
| Vulkan, dispositivo 0 | Intel (RPL-P) | NVIDIA RTX 4060 |
| Vulkan, dispositivo 1 | NVIDIA RTX 4060 | Intel (RPL-P) |

O sea: para **OpenGL es obligatorio**, sin discusión, o va en la Intel.

Para **Vulkan** el efecto real es **reordenar, no esconder**. `__VK_LAYER_NV_optimus`
actúa sobre la capa de NVIDIA, no sobre el ICD de Mesa, así que la Intel se sigue
enumerando; lo que cambia es quién es el dispositivo 0. Importa igual: DXVK y
vkd3d prefieren la GPU discreta por su cuenta, pero un juego Vulkan nativo que
coja `physicalDevices[0]` sin mirar se llevaría la Intel. Con `prime-run` deja de
depender de la suerte.

**Cómo comprobar que funcionó.** `~/.config/MangoHud/MangoHud.conf` arranca
oculto y se conmuta con `Shift_R+F12`. Lleva `gpu_name` activado justo para esto:
si ahí pone Intel, te falta el `prime-run`. También muestra el 1% low
(`fps_metrics=avg,0.01`), que es el número que explica los tirones; la media
miente.

Sin lanzar ningún juego:

```bash
prime-run vulkaninfo --summary | grep deviceName    # necesita vulkan-tools
```

**GameMode hace menos de lo que promete aquí, y es a propósito.**
`~/.config/gamemode.ini` deja el gobernador en paz (`desiredgov=powersave`): con
`intel_pstate` en modo activo, "powersave" no es lento (sube a turbo bajo carga
en milisegundos), mientras que "performance" clava `min_perf_pct` al 100% y en un
chasis delgado le roba presupuesto térmico a la GPU, que es quien suele ser el
cuello de botella. `renice`/`ioprio` van a 0 porque `gamemoded` corre como
servicio de usuario con `RLIMIT_NICE` a 0 y no puede poner prioridades
negativas; pedírselo solo llena el log.

Lo que sí aporta, y es la única razón para entrar en el grupo `gamemode`, es
**`split_lock_mitigate`**. El kernel lo trae a 1 y penaliza durísimo a los
procesos que hacen atómicos desalineados, cosa que varios juegos de Windows bajo
Proton hacen; se nota como tirones periódicos que ningún ajuste gráfico arregla.
GameMode lo pone a 0 mientras juegas y lo restaura al salir, pero necesita
permiso:

```bash
sudo usermod -aG gamemode $USER
```

**No hace falta cerrar sesión**, aunque todas las guías lo digan: la regla de
`/usr/share/polkit-1/rules.d/gamemode.rules` usa `subject.isInGroup("gamemode")`,
y polkit resuelve los grupos por UID contra la base de datos del sistema, no por
las credenciales del proceso. Surte efecto al momento.

Comprobarlo de verdad, que es más útil que `gamemoded -t`:

```bash
sysctl -n kernel.split_lock_mitigate          # 1
gamemoderun sleep 6 &
sleep 2; sysctl -n kernel.split_lock_mitigate # 0  <- funciona
wait; sysctl -n kernel.split_lock_mitigate    # 1  <- restaurado
```

No hay sección `[gpu]` en el `.ini`: con `apply_gpu_optimisations` puesto a
cualquier cosa que no sea la cadena literal `accept-responsibility`, gamemode
escupe un ERROR y `gamemoded -t` falla. Sin la sección el comportamiento es el
mismo (apagado) y sin ruido.

---

## Cómo probar un cambio

Regla general: **mirar el resultado, no suponerlo**. Casi todo aquí falla en
silencio: GTK cae al tema claro sin avisar, hyprlock ignora una opción
inexistente sin más, pywal se come una llave, eza descarta un color en hex sin
rechistar. Comprobar cuesta diez segundos.

### Cómo reabrir cada programa de verdad

No todos se cierran igual, y con uno de ellos lo que parece cerrarlo no lo
cierra:

| | Cómo |
|---|---|
| **Steam** | `steam-theme.sh --restart`. `SUPER+Q` **no vale**: es `window.close()`, o sea lo mismo que la X, y Steam se va a la bandeja con doce procesos vivos y el CSS viejo cargado |
| **Zen** | Cerrar la ventana basta. Si se resiste, `pkill -x zen-bin` |
| **Spotify** | Cerrar la ventana basta |
| **Code - OSS**, **Obsidian** | Nada, se repintan solos |

### Lo primero: `theme-status.sh`

```bash
~/.config/hypr/scripts/theme-status.sh
```

Recorre las plantillas, los enlaces de btop y cava, el `@import` de GTK, la ruta
absoluta de Qt, el `userChrome` de Zen con su pref, el parcheo de Steam y de
Spotify, el snippet de Obsidian y los colores de Code - OSS. Sale con código
distinto de cero si algo falla, así que sirve dentro de un script.

**Y comprueba también los procesos abiertos**, que es distinto de comprobar los
ficheros. Un Steam abierto desde ayer tiene la paleta de ayer por muy al día que
esté su CSS en disco, y durante un tiempo el informe daba `ok` a eso. La sección
*"lo que estás viendo ahora mismo"* compara la fecha de arranque de cada proceso
(sacada de `/proc/PID`, no de `ps -o lstart`, que la imprime en el idioma de la
sesión y `date -d` no sabe leerla) con la de la paleta.

En la misma línea, la comprobación de Spotify no mira el `color.ini` copiado
sino el `--spice-main` que spicetify dejó **inyectado en el bundle**. Comparar
la copia no valía para nada: se hace siempre y coincide siempre, mientras que
aplicar solo ocurre con Spotify cerrado.

Existe porque `wall.sh` lanza los themers en segundo plano y con la salida a
`/dev/null`. Eso está bien (no quieres ruido en cada `SUPER+W`) pero significa
que un themer roto falla **en silencio y para siempre**. Pasó de verdad:
`steam-theme.sh` lanzaba el instalador sin ponerse en su directorio y reventaba
entero sin que se notara nada.

### Hyprland (`hyprland.lua`)

```bash
cp ~/.config/hypr/hyprland.lua{,.bak}   # o el alias: bak ~/.config/hypr/hyprland.lua
hyprctl reload
hyprerr                                  # alias de: hyprctl rollinglog | grep -iE "err|warn"
```

Si algo peta y te quedas sin sesión usable, desde una TTY (`Ctrl+Alt+F2`):
`cp ~/.config/hypr/hyprland.lua.bak ~/.config/hypr/hyprland.lua`.

Para tantear un valor sin editar el fichero: `hyprctl eval '...'` (ver
[trampas](#trampas-y-hallazgos)).

### hyprlock

**Nunca lo lances a pelo para probar**: si el cambio rompe algo, te quedas fuera.

```bash
hyprlock --grace 300      # 5 min en los que cualquier tecla lo descarta
# desde otra terminal, o volviendo con Alt+Tab:
pkill hyprlock
```

El `grace` alto es la red de seguridad por si el `pkill` no llega. Para revisar
errores de configuración, lánzalo redirigiendo: `hyprlock --grace 300 > /tmp/hl.log 2>&1 &`
y luego `grep -i "does not exist" /tmp/hl.log`.

Los dos scripts de las etiquetas se prueban sueltos, sin bloquear nada:

```bash
~/.config/hypr/scripts/lock-battery.sh
~/.config/hypr/scripts/lock-media.sh
```

### Aplicaciones GTK (Thunar y compañía)

Los cambios de tema **solo se leen al arrancar**, y Thunar deja un demonio vivo
en segundo plano, así que relanzarlo sin más no basta:

```bash
thunar -q && thunar        # -q mata el demonio primero
zenity --info --text=prueba   # para probar el lado GTK4/libadwaita
```

Si dudas de si un color ha entrado de verdad, hazle una captura y mide el píxel:

```bash
grim /tmp/t.png && magick /tmp/t.png -crop 40x10+900+400 +repage \
    -resize 1x1 -format "%[hex:p{0,0}]\n" info:
```

Cuidado con **dónde** mides: la vista de ficheros tiene fondo propio, distinto del
de la ventana.

### waybar

```bash
barlog     # alias: mata waybar y la relanza en primer plano, con sus errores a la vista
```

Los errores de CSS y de módulos salen ahí. `Ctrl+C` y `waybar &` para volver.

### swaync

```bash
swaync-client --reload-css          # responde "success: true" o el error de parseo
notify-send "Prueba" "Cuerpo de la notificación"
swaync-client -t -sw                # abrir el centro de notificaciones
```

### wlogout

Se puede lanzar sin miedo: **`Esc` lo cierra** sin ejecutar nada.

```bash
wlogout -b 3 -T 300 -B 300 -L 200 -R 200
```

### fastfetch

```bash
FF_LOGO=flor.txt fastfetch    # forzar un dot art concreto
fflogos                        # ver todos con su nombre
fastfetch --logo none          # solo el bloque de datos
```

Si un módulo sale vacío, pruébalo aislado: `fastfetch --logo none -s bateria`.

### Prompt, btop, cava

- starship: `exec zsh` recarga la shell actual.
- plugins de zsh: los colores de `zsh-autosuggestions` y `zsh-syntax-highlighting`
  se leen al abrir la shell, así que las terminales ya abiertas se quedan con los
  viejos. `exec zsh` también los actualiza.
- btop y cava: arrancarlos y ya. cava recarga colores con la tecla `c`.

### Paleta entera

```bash
wall ~/Pictures/wallpapers/loquesea.jpg   # cambia fondo y repinta todo
recolor                                    # regenera la paleta del fondo actual
```

### Aplicaciones Qt

Sin instalar nada más, se comprueba con `qt6ct`: ábrelo, cambia de wallpaper y
mira si la ventana se repinta un par de segundos después.

Para verlo en negro sobre blanco, una app Qt6 de doce líneas que imprime la
paleta que le llega:

```bash
cat > /tmp/pal.cpp <<'EOF'
#include <QApplication>
#include <QPalette>
#include <cstdio>
int main(int argc, char **argv) {
    QApplication app(argc, argv);
    printf("Window %s\n", app.palette().color(QPalette::Window).name().toUtf8().constData());
    return 0;
}
EOF
g++ -fPIC /tmp/pal.cpp -o /tmp/pal $(pkg-config --cflags --libs Qt6Widgets)
QT_QPA_PLATFORM=offscreen /tmp/pal        # debe coincidir con color0 de la paleta
```

Si sale `#efefef`, el gris de fábrica de Qt, es que el plugin no está entrando:
revisa `QT_QPA_PLATFORMTHEME` y luego `qt-apply`.

### Steam, Spotify y Code - OSS

```bash
~/.config/hypr/scripts/steam-theme.sh   --status
~/.config/hypr/scripts/spotify-theme.sh --status
~/.config/hypr/scripts/code-theme.sh    --status
```

Los tres dicen qué pieza falta. Code debería decir `colores aplicados 101`.

### Zen Browser

```bash
ls -l ~/.config/zen/*/chrome/userChrome.css   # tiene que ser un enlace al caché
grep legacy ~/.config/zen/*/user.js           # y la pref tiene que estar
```

Si las dos cosas están y aun así no cambia, es que estás mirando otro perfil: ver
[trampas](#trampas-y-hallazgos). Recuerda que ninguno de los dos programas repinta
en caliente: hay que reabrirlos.

### Antes de commitear

```bash
dots        # qué ha cambiado
dotd        # el diff
dota <fichero> && dotc "mensaje" && dotp
```

## Trampas y hallazgos

Cosas que costaron tiempo y que no salen en las guías al uso. Comprobadas en este
equipo, no copiadas de un tutorial.

### La API Lua de Hyprland 0.55+

`hyprctl dispatch` habla Lua. La sintaxis vieja **no funciona**:

```bash
hyprctl dispatch movetoworkspace 3                     # ✗ ya no
hyprctl dispatch 'hl.dsp.window.move({ workspace = 3 })'   # ✓
```

`hyprctl keyword` está muerto: responde *"keyword can't work with non-legacy
parsers. Use eval."*. Para cambiar opciones en caliente:

```bash
hyprctl eval 'hl.config({ decoration = { glow = { range = 40 } } })'
```

**Verifica siempre los nombres** antes de escribirlos, porque muchísimo material
de internet está desactualizado:

```bash
hyprctl descriptions | grep -i <cosa>     # opciones de configuración
grep -i <cosa> /usr/share/hypr/stubs/hl.meta.lua   # la API Lua completa
```

Ese fichero de stubs es la mejor documentación que hay: lleva todos los campos de
`HL.LayerRuleSpec`, `HL.WindowRuleSpec`, los dispatchers, etc.

### En Hyprland, "speed" es duración

En las animaciones, `speed` **no** es velocidad: es la duración en décimas de
segundo. `speed = 60` son 6 segundos. Un `speed = 1.2` en un `glowangle` con
`style = "loop"` no es un giro lento: son 120 ms por vuelta, un estroboscopio.

### Las plantillas de pywal: llaves dobladas y funciones de color

Cualquier llave literal en `~/.config/wal/templates/` hay que **duplicarla**:

```
return {{        →  emite  return {
${{count}}       →  emite  ${count}
```

Ya mordió con `colors-hypr.lua`, con las variables de git de `starship.toml` y
con el CSS de Steam, que es casi todo llaves.

Dos matices que valen su peso en oro y que no están en la documentación de
pywal, salidos de leer `pywal/export.py` de la versión instalada:

1. **Ya no es `str.format()`.** pywal16 trae su propio analizador, y eso le da
   una gramática que `str.format` no puede tener: `color '.' función(args)* '.'
   propiedad`. O sea que esto funciona y ahorra escribir colores a mano:

   ```
   {color0.lighten(8)}          # aclara un 8 %
   {color0.darken(50).rgb}      # oscurece y luego lo da como "r, g, b"
   {color7.strip}               # hex sin almohadilla, para spicetify
   {color0.hex_argb}            # #AARRGGBB, para Qt
   ```

   El montaje de Qt, Steam y Spotify se apoya entero en esto: de un `color0` y
   un `color7` salen los quince tonos intermedios que piden esos formatos.

2. **Un error de sintaxis solo tumba SU fichero**, no todos. `template()` hace
   `return` en cuanto no puede analizar un marcador, así que el resto de
   plantillas se generan igual. Peor todavía: el fichero de salida **se queda
   con la versión anterior**, así que el síntoma es "esta app no cambia de
   color" y no un error.

   Pero no toda llave rompe, y la diferencia importa. Probado a propósito:

   | En la plantilla | Qué pasa |
   |---|---|
   | `a { color: red }` (CSS en línea) | El contenido no empieza por letra, no parsea: **aborta el fichero entero** |
   | `{noexiste}` | Parsea pero el color no existe: lo deja literal y **sigue** |
   | `{` suelta, sin cerrar | No casa con el regex, pasa tal cual, **no rompe nada** |

   O sea que el peligro de verdad es meter CSS con llaves en la misma línea.
   Ya no hace falta acordarse de comprobarlo: `wall.sh` llama a
   `theme-status.sh --templates` después de cada `wal`, que compara la fecha de
   cada fichero del caché con la de `~/.cache/wal/colors` y te avisa por
   notificación de las que no se regeneraron.

### btrfs: una imagen de máquina virtual se fragmenta hasta lo absurdo

Medido en este equipo, no leído en ningún sitio. Un fichero de 200 MB, 400
escrituras de 64 K en posiciones aleatorias (que es lo que hace una VM todo el
rato: su registro, su swap, sus temporales):

| | extents |
|---|---|
| Con copy-on-write, o sea por defecto | **1907** |
| Con `chattr +C` | **1** |

Un *extent* es un trozo contiguo. Con 1907, leer ese fichero de punta a punta
son 1907 saltos en vez de uno.

La causa es que btrfs **nunca sobrescribe**: cuando cambias un bloque, escribe
el dato nuevo en otro sitio libre y reapunta el índice. Para las instantáneas de
snapper eso es justo lo que las hace gratis, pero una imagen de disco virtual es
el peor caso posible, porque son millones de escrituras sueltas dentro de un
fichero enorme. Y no se estabiliza: con solo 400 escrituras ya subió de 1599 a
1907.

`chattr +C` apaga el CoW y, de paso, la compresión. Las dos interesan apagadas:
comprimir un disco virtual es trabajo tirado porque dentro ya hay datos
comprimidos.

**Hay que hacerlo antes de crear nada**, porque el atributo solo lo heredan los
ficheros nuevos:

```bash
mkdir -p ~/vm
chattr +C ~/vm
lsattr -d ~/vm      # tiene que salir una C
```

Y luego decirle a libvirt que use ese directorio, en vez de
`/var/lib/libvirt/images`, que está en `/` y **sí lo cubre snapper**: cada
instantánea se llevaría una copia de tus discos virtuales.

```bash
virsh -c qemu:///system pool-define /dev/stdin <<'EOF'
<pool type='dir'><name>vm</name><target><path>/home/TUUSUARIO/vm</path></target></pool>
EOF
virsh -c qemu:///system pool-autostart vm && virsh -c qemu:///system pool-start vm
```

Dos cosas más que muerden con libvirt en un portátil de un solo usuario:

1. La red `default` viene **inactiva y sin autoarranque**. Es la causa número
   uno de "mi VM no tiene internet":
   `virsh -c qemu:///system net-start default && virsh -c qemu:///system net-autostart default`
2. Con `qemu:///system`, QEMU corre como `libvirt-qemu`, y `/home/usuario` es
   `drwx------`. O sea que **no puede entrar en `~/vm`**. Se arregla poniendo
   `user` y `group` a tu usuario en `/etc/libvirt/qemu.conf`. Rebaja la
   seguridad (una fuga de la VM aterriza con tus permisos), pero la alternativa
   es aflojar los permisos de tu carpeta personal, que es peor.

### Nunca enlaces al caché un fichero que el programa reescribe

lazygit dejó esto claro de golpe. Su configuración empezó siendo una plantilla
de pywal enlazada desde `~/.config/lazygit/config.yml`, siguiendo el mismo
patrón que `cava-config` y `starship.toml`. Y al primer arranque:

```
The user config file /home/j0r/.config/lazygit/config.yml must be migrated.
- Moved git.paging object to git.pagers array
- Renamed git.pagers to git.diffRenderers
Config file saved successfully
```

**lazygit escribe en su fichero de configuración.** Al ser un enlace, esa
migración cayó dentro del fichero generado en `~/.cache/wal/`. Y el siguiente
`SUPER+W` lo habría regenerado desde la plantilla con el esquema viejo, así que
lazygit volvería a migrar. Aviso en cada arranque, para siempre, y la migración
perdiéndose cada vez.

La regla que sale de aquí: **un fichero del caché de pywal solo puede enlazarse
si el programa lo trata como de solo lectura.** btop, cava y yazi cumplen; leen
al arrancar y no escriben nunca. lazygit no.

El arreglo es separar lo que escribe cada uno:

| | Quién manda |
|---|---|
| `~/.config/lazygit/config.yml` | lazygit. Fichero normal, versionado, que él puede migrar |
| `~/.cache/wal/lazygit-theme.yml` | pywal. Solo colores, que lazygit no migra |

Y se fusionan con la variable `LG_CONFIG_FILE`, que acepta una lista separada
por comas y donde **manda el último**, o sea la paleta:

```sh
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.cache/wal/lazygit-theme.yml"
```

Comprobado que la variable se lee de verdad metiendo a propósito un YAML roto
en la lista: lazygit sale con código 1 y el error de parseo. Sin esa prueba,
"no dio error" no habría demostrado nada.

### eza ignora los colores en hex sin decir nada

`EZA_COLORS` **no acepta `#RRGGBB`**. Y no se queja: simplemente no colorea.

```
EZA_COLORS="da=#ff0000"        →  root 19 ago 21:17          (sin un solo escape)
EZA_COLORS="da=38;2;255;0;0"   →  root ^[[38;2;255;0;0m19 ago 21:17^[[0m
```

Hay que darle ANSI `38;2;R;G;B`. Como pywal solo sabe emitir `"R,G,B"` con
comas, `shell-tools.sh` monta la cadena entera y le pasa un `tr ',' ';'`: un
único subshell al abrir la shell en vez de ocho.

fzf sí acepta hex, así que en el mismo fichero conviven los dos formatos.

### En zsh, `$var:t` no es texto: es un modificador

Al escribir la plantilla de eza, esto reventaba solo en zsh:

```sh
_wal_eza="$_wal_eza:tr=38;2;153,149,133"     # zsh: bad substitution
```

zsh lee `:t` como su modificador de parámetro (la cola de una ruta), y lo mismo
con `:r`, `:u`, `:h`, `:a`, `:e`... que son casi todas las claves de eza. La
solución es rodear el nombre de llaves, `${_wal_eza}`.

Y ahí se cruzan las dos trampas de este README: esas llaves hay que **doblarlas
en la plantilla** para que pywal las deje pasar. En `shell-tools.sh` se ve
`${{_wal_eza}}`, que genera `${_wal_eza}`, que es lo que zsh entiende.

### En zsh, `local path` te deja sin `PATH`

El fastfetch con dot art salía sin dibujo, y por toda pista esto:

```
fastfetch:91: command not found: shuf
```

Con `shuf` en `/usr/bin/shuf` y `/usr/bin` en el `PATH`. La función hacía:

```sh
local side="" top="" h w path      # ← aquí
while read -r h w path; do ...
```

En zsh `path` es el array ligado a `PATH`, así que `local path` no crea una
variable nueva: crea una copia local **vacía** y deja el `PATH` en nada durante
toda la función. En bash no pasa, porque ahí `path` es una variable corriente.

Lo que hizo el diagnóstico más largo de lo necesario es que el síntoma apuntaba
al sitio equivocado: `command fastfetch`, dentro de la misma función y con el
mismo `PATH` vacío, seguía funcionando, porque zsh ya lo tenía en su tabla de
hash de una llamada anterior. O sea que fastfetch se ejecutaba y solo fallaba
`shuf`, y parecía un problema del dibujo cuando era del `PATH`.

La variable pasó a llamarse `ruta`. Los otros nombres atados de zsh que conviene
no usar como locales: `cdpath`, `fpath`, `manpath`, `prompt`, `status`.

### `color9`-`color15` suelen ser duplicados

En la mayoría de paletas que genera pywal, `color9`-`color15` son copias exactas
de `color1`-`color7`. Para un gradiente de 8 pasos con valores distintos hay que
tirar solo de `color0`-`color8`. Es lo que hace el de cava.

### GTK: dos trampas encadenadas

1. **`Adwaita-dark` no es un nombre de tema válido en GTK3.** Al ponerlo en
   `gtk-theme-name`, GTK no avisa por stderr: cae silenciosamente al Adwaita
   **claro**. Lo correcto es `Adwaita` a secas más
   `gtk-application-prefer-dark-theme=1` y `color-scheme=prefer-dark`.

2. **Redefinir los colores del tema no surte efecto.** Ni
   `@define-color theme_bg_color @bg;` en GTK 3.24.52, ni
   `@define-color window_bg_color @bg;` ni las variables `--window-bg-color` en
   libadwaita 1.9.3. Las reglas del tema siguen resolviendo sus propios colores.
   Lo único que entra son las **reglas explícitas** sobre widgets.

Comprobado midiendo píxeles sobre ventanas reales: con una regla directa el fondo
daba `#131313` (el `@bg` con la opacidad 0,92 de ventana), y con el override de
nombre `#353535`, el gris de fábrica.

> Al verificar esto, **cuidado con dónde mides**: la vista de ficheros de Thunar
> tiene su propio fondo, distinto del de la ventana. Medir ahí lleva a concluir
> que el `@import` está roto cuando no lo está.

### Qt: el vigilante mira el `.conf`, no el esquema

`qt6ct` recarga en caliente, pero vigila `~/.config/qt6ct/qt6ct.conf` y **no** el
fichero al que apunta `color_scheme_path`. Como nuestro `.conf` es estático y lo
que cambia es el esquema del caché, regenerar la paleta no repintaba nada.

La solución es un `touch` del `.conf` en `wall.sh`. Comprobado con una app Qt6
mínima que imprimía `QPalette::Window` cada segundo mientras se cambiaba el
esquema por debajo:

```
t=2s  se cambia colors-qt.conf     → sigue con el color viejo
t=5s  touch qt6ct.conf             → sigue con el color viejo
t=7s                                 entra el nuevo
```

Es decir: sin `touch` no entra nunca, y con `touch` tarda un par de segundos.

Y tres ajustes de `qt6ct.conf` que son obligatorios, no preferencias:
`style=Fusion` (los demás estilos aplican la paleta a medias),
`custom_palette=true` (sin esto ignora la ruta) y la ruta **absoluta**, porque
qt6ct no expande `~` ni `$HOME`. De ahí `qt-apply`.

### Los nombres de las reglas de ventana cambian en la API Lua

Las `windowrule` de toda la vida no se traducen solas. Y como
`hl.window_rule` **sí** valida los campos, se puede preguntar sin miedo:

```bash
hyprctl eval 'hl.window_rule({ match = { class = "^(zzz)$" }, no_border = true })'
# error: hl.window_rule: unknown field 'no_border'
```

Comprobado así, en 0.56.2:

| Config clásica | API Lua |
|---|---|
| `stayfocused` | `stay_focused = true` |
| `minsize 1 1` | `min_size = "1 1"` |
| `idleinhibit fullscreen` | `idle_inhibit = "fullscreen"` |
| `noblur`, `noshadow` | `no_blur`, `no_shadow` |
| `noborder` | **no existe**: usa `border_size = 0` |
| `content game` | **no existe** como `content_type` |

Un campo inválido aborta la regla entera, no solo ese campo. Y un
`hyprctl reload` limpia lo que hayas metido con `eval`, así que probar es gratis.

### `profiles.ini` de Firefox: manda `[Install]`, no `Default=1`

`zen-apply` enganchó el CSS al perfil equivocado a la primera. En este equipo
`profiles.ini` tiene dos perfiles:

```ini
[Profile1]
Path=3xhn7edd.Default Profile
Default=1                          ← vacío, nunca se ha abierto

[Install15B76BAA26BA15E7]
Default=q2d7lhxs.Default (release) ← este es el que abre el navegador
```

El `Default=1` de un `[ProfileN]` es el mecanismo antiguo. Lo que decide qué
perfil abre **esta instalación** es la clave `Default=` de la sección
`[InstallXXXX]`. Fiarse del primero engancha el `userChrome.css` a un perfil que
el navegador no abre nunca, y el síntoma es que no pasa absolutamente nada: ni un
error, ni un aviso.

`zen-apply` mira las tres cosas en orden: `[Install]`, luego el perfil que tenga
`prefs.js` (o sea, el que se ha usado alguna vez) y por último el primero.

Y la pref: sin
`toolkit.legacyUserProfileCustomizations.stylesheets = true`, Firefox y todos sus
forks **ignoran `userChrome.css` sin decir nada**. Se pone en `user.js` y no en
`prefs.js`, porque `prefs.js` lo reescribe el navegador al cerrarse: editarlo con
Zen abierto no sirve de nada.

### pywal procesa TODO lo que haya en `templates/`

Incluidos los `.bak`. Había un `colors-hypr.lua.bak` en la carpeta de plantillas
y pywal le estaba generando religiosamente su `~/.cache/wal/colors-hypr.lua.bak`
en cada cambio de fondo. No rompe nada, pero ensucia el caché y confunde. La
carpeta de plantillas es solo para plantillas.

### `millennium-steam-patcher` no existe

Circula mucho ese nombre para el inyector de temas de Steam. En el AUR el
paquete es **`millennium`** (o `millennium-bin`, en beta). Además compila desde
fuente con `bun`, `rust` y `cmake`. Por eso aquí se usa el instalador oficial de
Adwaita-for-Steam, que es lo que el propio proyecto recomienda.

### hyprlock: `grace` y `no_fade_in` no son opciones de config

En hyprlock 0.9.6 no existen dentro del bloque `general`. Ponerlas ahi da
`config option <general:grace> does not exist` y **se ignoran en silencio** salvo
que mires el log. Son flags de linea de comandos:

```bash
hyprlock --grace 2 --no-fade-in
```

Por eso los tres sitios que lanzan hyprlock (el bind `SUPER+CTRL+L`, `hypridle` y
el boton de wlogout) pasan `--grace 2`.

### playerctl con varios reproductores mezcla la informacion

Con Spotify y un navegador abiertos a la vez, `playerctl status` puede responder
por un reproductor y `playerctl metadata` por otro: acabas mostrando el estado de
uno con la cancion del otro. Hay que elegir **un** reproductor y preguntarle todo
a el, que es lo que hace `lock-media.sh` (prioriza el que este sonando, y si
ninguno suena coge el primero pausado).

### fastfetch 2.67 quitó `--logo-source`

Las opciones de módulo por CLI desaparecieron. Ahora es:

```bash
fastfetch --logo-type file --logo /ruta/al/arte.txt    # ✓
fastfetch --logo-source /ruta/al/arte.txt              # ✗ error
```

### Hardware híbrido y DaVinci Resolve

Hyprland renderiza en la Intel; la NVIDIA se usa bajo demanda con `prime-run`.

> **No toques la configuración de GPU ni instales `opencl-nvidia`.** DaVinci
> Resolve solo funciona con la Intel en modo Auto en este equipo.

El orden de las tarjetas en `/dev/dri/cardN` **cambia entre arranques**. Si hay
que fijarlo, usar las rutas de `ls -l /dev/dri/by-path`, nunca `cardN`.

---

## Lo que no se versiona

Las reglas están en `~/.dotfiles/info/exclude`. Con
`status.showUntrackedFiles=no` esas reglas no cambian lo que ves en `dot status`,
pero **sí protegen de un `dot add -A` descuidado**, que es justo cuando se cuela
algo que no debe.

| Qué | Por qué |
|---|---|
| `~/.ssh/`, `~/.gnupg/`, `.config/gh/hosts.yml` | **credenciales**. `hosts.yml` guarda el token de GitHub en claro |
| `.config/obs-studio/plugin_config/obs-websocket/` | puede llevar la contraseña del websocket |
| `~/.claude/`, `.claude.json` | estado de la herramienta, y puede incluir historial |
| `~/.cache/wal/` | generado. Se reconstruye con `wal` |
| `~/Pictures/wallpapers/` | binarios pesados |
| `*.bak`, `*.disabled` | copias de seguridad de trabajo |
| Ajustes de `gsettings` | viven en dconf, que es binario. Los reaplica `gtk-apply` |
| `~/.config/fastfetch/logos/*` | el arte es cosa tuya. Solo se versiona la carpeta |
| discord, spotify, zen, GIMP, Code - OSS | estado de aplicación, no configuración |
| `.config/Blackmagic Design/`, `.config/Unknown Organization/` | configuración de DaVinci Resolve. **No se toca** (ver [trampas](#trampas-y-hallazgos)) |

**OBS Studio** está sin versionar a propósito: ahora mismo su configuración son
los valores por defecto (perfil y colección de escenas «Untitled»). Cuando tengas
escenas de verdad, merece la pena añadir `global.ini`, `user.ini` y
`basic/scenes/`, pero nunca `plugin_config/obs-websocket/`.

**Qt ya está resuelto.** `~/.config/qt5ct/qt5ct.conf` y
`~/.config/qt6ct/qt6ct.conf` se versionan y apuntan al esquema que genera pywal;
`qt-apply` arregla la ruta absoluta al desplegar. `Kvantum` sigue instalado pero
sin usar: sobra teniendo `style=Fusion` con paleta personalizada.

---

## Dependencias

Las listas completas y actualizables están en `~/.config/pkglists/`, y se
regeneran con el alias `pkglist`.

**Núcleo:** `hyprland` `waybar` `wofi` `kitty` `hyprlock` `hypridle` `hyprshot`
`hyprpicker` `swaync` `wlogout` `awww` (sucesor de swww) `python-pywal16`

**Utilidades:** `cliphist` `wl-clipboard` `grim` `slurp` `playerctl`
`brightnessctl` `thunar` `starship` `btop` `cava` `fastfetch` `imagemagick` `jq`

**Tematizado de toolkits:** `qt5ct` `qt6ct` (el puente de la paleta a las apps
Qt). `kvantum` está instalado pero **no se usa**: con `style=Fusion` y paleta
personalizada sobra.

**Opcionales, para Steam y Spotify:** `steam` más el repo
[Adwaita-for-Steam](https://github.com/tkashkin/Adwaita-for-Steam) clonado en
`~/.local/share/adwaita-for-steam`; `spicetify-cli` (AUR) para Spotify. Si no
están, los scripts salen sin hacer nada y el resto del sistema funciona igual.

**Sin dependencias extra:** Code - OSS y Zen Browser se tematizan con lo que ya
traen (`workbench.colorCustomizations` y `userChrome.css`). No hace falta ni una
extensión ni `pywalfox`.

**Fuentes:** `ttf-jetbrains-mono-nerd` (imprescindible: los glifos de waybar,
wofi, wlogout, starship y fastfetch salen de ahí)

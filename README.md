# dotfiles — Arch · Hyprland 0.56 · pywal16

Configuración completa de un escritorio Wayland sobre Arch, con una idea de fondo:
**todo el sistema se pinta a partir del wallpaper**. Cambias el fondo y la barra,
el lanzador, el terminal, el prompt, las notificaciones, el menú de apagado, el
monitor de sistema y hasta las aplicaciones GTK adoptan su paleta en la misma
pasada.

Equipo de referencia: MSI Stealth 15 (i7-13620H + RTX 4060 híbrida), pantalla
eDP-2 de 1920x1080 a 144 Hz, escala 1.

---

## Índice

- [El sistema de color](#el-sistema-de-color)
- [Instalación en una máquina nueva](#instalación-en-una-máquina-nueva)
- [Estructura](#estructura)
- [Atajos de teclado](#atajos-de-teclado)
- [Personalización](#personalización)
  - [Wallpaper y paleta](#wallpaper-y-paleta)
  - [Dot art de fastfetch](#dot-art-de-fastfetch)
  - [Waybar](#waybar)
  - [Efectos de Hyprland](#efectos-de-hyprland)
  - [Prompt (starship)](#prompt-starship)
  - [btop y cava](#btop-y-cava)
  - [GTK](#gtk)
  - [wlogout y swaync](#wlogout-y-swaync)
  - [hyprlock](#hyprlock)
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
                      ├── pywal.theme          → btop                (enlace simbólico)
                      ├── cava-config          → cava                (enlace simbólico)
                      └── sequences            → terminales abiertas
```

Las plantillas que producen esos ficheros están en `~/.config/wal/templates/`.
**Si quieres cambiar cómo se mapean los colores, se toca ahí, nunca en el config
del programa final.**

`~/.config/hypr/scripts/wall.sh` hace la pasada completa: cambia el fondo con
`awww`, regenera la paleta y recarga a cada consumidor.

Tres consumidores no necesitan recarga explícita, y está documentado dentro del
propio `wall.sh` para que nadie la añada por error:

| Programa | Por qué no hace falta |
|---|---|
| starship | `STARSHIP_CONFIG` apunta al caché y starship relee el fichero en cada prompt |
| btop | `~/.config/btop/themes/pywal.theme` es un enlace al caché; lo coge al arrancar |
| cava | `~/.config/cava/config` es un enlace al caché; recarga con la tecla `c` |

> **Aviso sobre cava:** no le mandes `SIGUSR1` para recargar. No lo soporta, y la
> acción por defecto de esa señal es terminar el proceso.

---

## Instalación en una máquina nueva

Esto es un **repo bare**: los ficheros viven directamente donde los programas los
leen, sin copias ni enlaces simbólicos hacia un directorio de paquetes.

```bash
# 1. Clonar como bare
git clone --bare https://github.com/jorgeress/dotfiles.git "$HOME/.dotfiles"

# 2. Alias temporal para esta shell
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# 3. Volcar los ficheros (cuidado: sobrescribe los que ya existan)
dot checkout

# 4. Que 'dot status' no liste los miles de ficheros sin versionar del home
dot config status.showUntrackedFiles no

# 5. Los ajustes que viven en dconf y no se pueden versionar
~/.local/bin/gtk-apply

# 6. Paquetes
sudo pacman -S --needed - < ~/.config/pkglists/pkgs-repo.txt
paru -S --needed - < ~/.config/pkglists/pkgs-aur.txt

# 7. Primera paleta
mkdir -p ~/Pictures/wallpapers   # mete ahí tus imágenes
awww-daemon &
~/.config/hypr/scripts/wall.sh ~/Pictures/wallpapers/loquesea.jpg
```

El alias definitivo (`dot`, más `dots`, `dota`, `dotc`, `dotp`, `dotl`) ya viene
en `~/.config/shell/aliases.sh`, que `~/.bashrc` carga.

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
├── wal/templates/            LAS PLANTILLAS. El origen de todos los colores
├── shell/aliases.sh          alias, funciones y arranque de shell
└── pkglists/                 listas de paquetes, regenerables con `pkglist`
.local/bin/
├── widgets                   eye candy propio
└── gtk-apply                 reaplica los ajustes GTK que viven en dconf
.bashrc
```

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
si es texto plano (usa `file`, que sustituye `$1`…`$9` por la paleta de pywal, con
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
o sea hasta 108 columnas de arte. Pasarse ya no rompe nada — el dibujo se va
arriba o no sale —, pero cuanto más ancho, menos veces sale al lado de los datos:

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
cava usa solo `color0`–`color8` a propósito: ver [trampas](#trampas-y-hallazgos).

### GTK

`gtk-3.0/` y `gtk-4.0/` llevan cada uno un `settings.ini` (tema, iconos, fuente,
cursor) y un `gtk.css` con las reglas de color.

Los `gtk.css` están escritos con **reglas explícitas sobre widgets**, no
redefiniendo los colores internos de Adwaita. Es feo pero es lo único que
funciona; la explicación está en [trampas](#trampas-y-hallazgos).

Iconos y cursor son Adwaita porque es lo único instalado. Si instalas algo como
`papirus-icon-theme`, cámbialo en los dos `settings.ini` y en `gtk-apply`.

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

## Cómo probar un cambio

Regla general: **mirar el resultado, no suponerlo**. Casi todo aquí falla en
silencio — GTK cae al tema claro sin avisar, hyprlock ignora una opción
inexistente sin más, pywal se come una llave. Comprobar cuesta diez segundos.

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

- starship: `exec bash` recarga la shell actual.
- btop y cava: arrancarlos y ya. cava recarga colores con la tecla `c`.

### Paleta entera

```bash
wall ~/Pictures/wallpapers/loquesea.jpg   # cambia fondo y repinta todo
recolor                                    # regenera la paleta del fondo actual
```

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

### Las plantillas de pywal pasan por `str.format()`

Cualquier llave literal en `~/.config/wal/templates/` hay que **duplicarla**:

```
return {{        →  emite  return {
${{count}}       →  emite  ${count}
```

Si no, `wal -R` peta con `KeyError` o se come la llave, y el fallo aparece luego
en el programa consumidor, lejos de la causa. Ya mordió con `colors-hypr.lua` y
con las variables de git de `starship.toml`.

### `color9`–`color15` suelen ser duplicados

En la mayoría de paletas que genera pywal, `color9`–`color15` son copias exactas
de `color1`–`color7`. Para un gradiente de 8 pasos con valores distintos hay que
tirar solo de `color0`–`color8`. Es lo que hace el de cava.

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
`basic/scenes/` — pero nunca `plugin_config/obs-websocket/`.

**Qt está sin configurar.** `QT_QPA_PLATFORMTHEME=qt6ct` está puesto en
`hyprland.lua`, pero no existen ni `~/.config/qt6ct` ni `~/.config/Kvantum`, así
que las aplicaciones Qt van con su aspecto por defecto y no siguen la paleta. Es
el equivalente Qt del agujero que tenía GTK.

---

## Dependencias

Las listas completas y actualizables están en `~/.config/pkglists/`, y se
regeneran con el alias `pkglist`.

**Núcleo:** `hyprland` `waybar` `wofi` `kitty` `hyprlock` `hypridle` `hyprshot`
`hyprpicker` `swaync` `wlogout` `awww` (sucesor de swww) `python-pywal16`

**Utilidades:** `cliphist` `wl-clipboard` `grim` `slurp` `playerctl`
`brightnessctl` `thunar` `starship` `btop` `cava` `fastfetch` `imagemagick` `jq`

**Fuentes:** `ttf-jetbrains-mono-nerd` (imprescindible: los glifos de waybar,
wofi, wlogout, starship y fastfetch salen de ahí)

-- ╔══════════════════════════════════════════════════════════════╗
-- ║  hyprland.lua — Hyprland 0.55+                               ║
-- ║  Colores dinámicos vía pywal16                               ║
-- ╚══════════════════════════════════════════════════════════════╝

---------------------------------------------------------------
---- COLORES (pywal) ------------------------------------------
---------------------------------------------------------------
-- Carga ~/.cache/wal/colors-hypr.lua. Si aún no has ejecutado
-- `wal` nunca, usa un fallback para que Hyprland no reviente.

local HOME = os.getenv("HOME")

local fallback = {
    border_active_a = "rgba(88c0d0ff)",
    border_active_b = "rgba(5e81acff)",
    border_inactive = "rgba(3b425266)",
    shadow          = "rgba(0a0e1499)",
    c0 = "#0a0e14", c4 = "#88c0d0", c7 = "#d8dee9",
}

local ok, C = pcall(dofile, HOME .. "/.cache/wal/colors-hypr.lua")
if not ok or type(C) ~= "table" then C = fallback end

---------------------------------------------------------------
---- MONITORES ------------------------------------------------
---------------------------------------------------------------
-- MSI Stealth 15: la interna suele ser eDP-1.
-- Comprueba el nombre real con: hyprctl monitors

hl.monitor({
    output   = "eDP-2",
    mode     = "1920x1080@144",
    position = "auto",
    scale    = 1,
})

-- Cualquier monitor externo, auto
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

---------------------------------------------------------------
---- PROGRAMAS ------------------------------------------------
---------------------------------------------------------------
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "wofi --show drun"
local browser     = "firefox"

---------------------------------------------------------------
---- VARIABLES DE ENTORNO -------------------------------------
---------------------------------------------------------------
hl.env("XCURSOR_SIZE",    "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

-- HÍBRIDA INTEL/NVIDIA: fuerza que Hyprland renderice en la Intel.
-- IMPORTANTE: el orden de las cards CAMBIA entre arranques.
-- Verifica con: ls -l /dev/dri/by-path
-- y usa las rutas by-path, no cardN, si te baila.
-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card0")

---------------------------------------------------------------
---- AUTOSTART ------------------------------------------------
---------------------------------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    -- Restaura el último wallpaper y su paleta
    hl.exec_cmd(HOME .. "/.config/hypr/scripts/wall.sh restore")
end)

---------------------------------------------------------------
---- ASPECTO --------------------------------------------------
---------------------------------------------------------------
hl.config({
    general = {
        gaps_in     = 6,
        gaps_out    = 14,
        border_size = 2,
        col = {
            active_border   = { colors = { C.border_active_a, C.border_active_b }, angle = 45 },
            inactive_border = C.border_inactive,
        },
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding        = 12,
        rounding_power  = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.92,

        shadow = {
            enabled      = true,
            range        = 24,
            render_power = 3,
            color        = C.shadow,
        },

        -- Motion blur (0.56): estela al mover/redimensionar ventanas.
        motion_blur = {
            enabled = true,
            samples = 7,
        },

        -- Glow con gradiente animado (0.56). El angulo lo rota "glowangle".
        glow = {
            enabled        = true,
            range          = 14,
            render_power   = 3,
            color          = { colors = { C.glow_a, C.glow_b }, angle = 0 },
            color_inactive = C.glow_inactive,
        },

        blur = {
            enabled            = true,
            size               = 8,
            passes             = 3,
            new_optimizations  = true,
            xray               = false,
            noise              = 0.02,
            contrast           = 1.1,
            brightness         = 0.9,
            vibrancy           = 0.20,
            vibrancy_darkness  = 0.5,
            popups             = true,
        },
    },

    animations = { enabled = true },

    dwindle = {
        preserve_split = true,
        smart_split    = false,
    },

    input = {
        kb_layout  = "es",
        kb_options = "caps:escape",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll  = true,
            disable_while_typing = true,
            tap_to_click    = true,
        },
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },


    xwayland = {
        force_zero_scaling = true,
    },
})

---------------------------------------------------------------
---- ANIMACIONES ----------------------------------------------
---------------------------------------------------------------
hl.curve("wind",       { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("winIn",      { type = "bezier", points = { {0.1, 1.1},  {0.1, 1.1}  } })
hl.curve("winOut",     { type = "bezier", points = { {0.3, -0.3}, {0, 1}      } })
hl.curve("liner",      { type = "bezier", points = { {1, 1},      {1, 1}      } })
hl.curve("overshot",   { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.1}  } })
hl.curve("bouncy",     { type = "spring", mass = 1, stiffness = 90, dampening = 12 })

hl.animation({ leaf = "global",       enabled = true, speed = 8,   bezier = "wind" })
hl.animation({ leaf = "windows",      enabled = true, speed = 6,   spring = "bouncy" })
hl.animation({ leaf = "windowsIn",    enabled = true, speed = 6,   bezier = "winIn",  style = "popin 85%" })
hl.animation({ leaf = "windowsOut",   enabled = true, speed = 5,   bezier = "winOut", style = "popin 85%" })
hl.animation({ leaf = "border",       enabled = true, speed = 10,  bezier = "liner" })
hl.animation({ leaf = "glowangle",    enabled = true, speed = 60,  bezier = "liner", style = "loop" })
hl.animation({ leaf = "fade",         enabled = true, speed = 6,   bezier = "liner" })
hl.animation({ leaf = "layers",       enabled = true, speed = 5,   bezier = "overshot", style = "slide" })
hl.animation({ leaf = "workspaces",   enabled = true, speed = 6,   bezier = "wind",     style = "slidevert" })

---------------------------------------------------------------
---- REGLAS ---------------------------------------------------
---------------------------------------------------------------
hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Diálogos y utilidades flotantes
for _, cls in ipairs({ "pavucontrol", "blueman-manager", "nm-connection-editor",
                       "org.gnome.Calculator", "nwg-look", "qt6ct", "thunar" }) do
    hl.window_rule({ match = { class = "^(" .. cls .. ")$" }, float = true })
end

-- DaVinci Resolve: sin blur ni redondeo, opacidad plena.
-- Los colores del grade NO se tocan.
hl.window_rule({
    name  = "resolve-clean",
    match = { class = "^(resolve)$" },
    opacity  = "1.0 override",
    rounding = 0,
    no_blur  = true,
})

-- Terminal semitransparente, el resto opaco
hl.window_rule({ match = { class = "^(kitty)$" }, opacity = "0.88 0.80" })

-- Picture-in-picture siempre encima
hl.window_rule({
    name  = "pip",
    match = { title = "^(Picture-in-Picture)$" },
    float = true, pin = true, size = "480 270", move = "100%-500 100%-300",
})

-- Blur para la barra y el launcher
-- ignore_alpha: solo se difumina lo que tenga alpha >= 0.5 (las islas, 0.75).
-- Los huecos vacios de la barra (transparentes) dejan ver el fondo limpio.
hl.layer_rule({ name = "blur-waybar", match = { namespace = "^waybar$" },   blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ name = "blur-wofi",   match = { namespace = "^wofi$" },     blur = true })
hl.layer_rule({ name = "blur-swaync", match = { namespace = "^swaync.*$" }, blur = true })

---------------------------------------------------------------
---- KEYBINDS -------------------------------------------------
---------------------------------------------------------------
local M = "SUPER"

-- Aplicaciones
hl.bind(M .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(M .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(M .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(M .. " + R",      hl.dsp.exec_cmd(menu))
hl.bind(M .. " + N",      hl.dsp.exec_cmd("swaync-client -t -sw"))

-- Ventanas
hl.bind(M .. " + Q",           hl.dsp.window.close())
hl.bind(M .. " + SHIFT + Q",   hl.dsp.window.kill())
hl.bind(M .. " + F",           hl.dsp.window.fullscreen())
hl.bind(M .. " + V",           hl.dsp.window.float({ action = "toggle" }))
hl.bind(M .. " + P",           hl.dsp.window.pseudo())
hl.bind(M .. " + J",           hl.dsp.layout("togglesplit"))
hl.bind(M .. " + G",           hl.dsp.group.toggle())

-- Foco (vim + flechas)
hl.bind(M .. " + h", hl.dsp.focus({ direction = "left"  }))
hl.bind(M .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(M .. " + k", hl.dsp.focus({ direction = "up"    }))
hl.bind(M .. " + j", hl.dsp.focus({ direction = "down"  }))
hl.bind(M .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(M .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(M .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(M .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- Mover ventana
hl.bind(M .. " + SHIFT + h", hl.dsp.window.move({ direction = "left"  }))
hl.bind(M .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(M .. " + SHIFT + k", hl.dsp.window.move({ direction = "up"    }))
hl.bind(M .. " + SHIFT + j", hl.dsp.window.move({ direction = "down"  }))

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(M .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(M .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end
hl.bind(M .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(M .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Scratchpad
hl.bind(M .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(M .. " + SHIFT + S", function()
    hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
end)

-- Ratón
hl.bind(M .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(M .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Capturas
hl.bind("PRINT",            hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind("SHIFT + PRINT",    hl.dsp.exec_cmd("hyprshot -m output -o ~/Pictures/screenshots"))
hl.bind(M .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Portapapeles
hl.bind(M .. " + Y", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))

-- Bloqueo / salida
hl.bind(M .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(M .. " + CTRL + Q", hl.dsp.exec_cmd("wlogout -b 3 -T 300 -B 300 -L 200 -R 200"))

-- Wallpaper: cambia imagen Y repinta toda la paleta del sistema
hl.bind(M .. " + W",         hl.dsp.exec_cmd(HOME .. "/.config/hypr/scripts/wall.sh random"))
hl.bind(M .. " + SHIFT + W", hl.dsp.exec_cmd(HOME .. "/.config/hypr/scripts/wallpicker.sh"))

-- Multimedia
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),     { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                    { locked = true, repeating = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

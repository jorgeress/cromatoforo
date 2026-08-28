-- Autogenerado por pywal. NO editar a mano.
-- Destino: ~/.cache/wal/colors-hypr.lua
return {{
    bg       = "{color0}",
    fg       = "{color7}",
    c0 = "{color0}", c1 = "{color1}", c2 = "{color2}", c3 = "{color3}",
    c4 = "{color4}", c5 = "{color5}", c6 = "{color6}", c7 = "{color7}",
    c8 = "{color8}", c9 = "{color9}", c10 = "{color10}", c11 = "{color11}",
    c12 = "{color12}", c13 = "{color13}", c14 = "{color14}", c15 = "{color15}",

    -- Formato rgba() de Hyprland: hex sin almohadilla + alpha.
    -- El darken(50) es a proposito: con la paleta cruda el borde activo
    -- y su glow tiraban demasiado del ojo. Sube o baja ESE numero (y el
    -- alpha del glow) si quieres mas o menos brillo; no toques el cache.
    border_active_a = "rgba({color4.darken(50).strip}ff)",
    border_active_b = "rgba({color6.darken(50).strip}ff)",
    border_inactive = "rgba({color8.strip}66)",
    shadow          = "rgba({color0.strip}99)",

    -- Glow (0.56): halo de la ventana activa. Alpha manda la intensidad.
    glow_a          = "rgba({color4.darken(50).strip}66)",
    glow_b          = "rgba({color6.darken(50).strip}66)",
    glow_inactive   = "rgba({color8.strip}00)",
}}

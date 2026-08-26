# ~/.zprofile — login shell de zsh.
#
# OJO: esto es el equivalente de ~/.bash_profile. El autoarranque de
# Hyprland vivía allí; al pasar el login shell a zsh, bash_profile ya no
# se lee y sin esta copia arrancas en una tty pelada.
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec start-hyprland
fi

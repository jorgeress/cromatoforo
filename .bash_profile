#
# ~/.bash_profile — login shell de bash.
#
# El autoarranque de Hyprland vive AQUÍ y en ~/.zprofile. Los dos, a
# propósito: el login shell es zsh, pero si algún día vuelves a bash con
# chsh, esto tiene que seguir funcionando sin tocar nada.
#
[[ -f ~/.config/shell/env.sh ]] && . ~/.config/shell/env.sh
[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec start-hyprland
fi

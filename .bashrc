#
# ~/.bashrc: bash interactivo.
#
# zsh es el shell de trabajo (ver ~/.zshrc). bash se queda para scripts
# y como red de seguridad: si zsh se rompe, `bash -l` sigue dando un
# entorno idéntico porque ambos leen los mismos dos ficheros:
#   ~/.config/shell/env.sh      entorno
#   ~/.config/shell/aliases.sh  alias y funciones
#

# Si no es interactivo, no hacer nada
[[ $- != *i* ]] && return

[ -f ~/.config/shell/env.sh ]     && . ~/.config/shell/env.sh
[ -f ~/.config/shell/aliases.sh ] && . ~/.config/shell/aliases.sh

# Historia (el equivalente de lo que hace ~/.zshrc para zsh)
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend checkwinsize globstar

# Prompt de emergencia: si starship no está, que al menos se vea la ruta.
# Cuando starship carga (desde aliases.sh) sobrescribe esto.
PS1='[\u@\h \W]\$ '

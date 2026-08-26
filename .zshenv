# ~/.zshenv — se lee SIEMPRE (interactivo, no interactivo, scripts).
# Solo entorno; nada que imprima ni que tarde.
[ -f "$HOME/.config/shell/env.sh" ] && . "$HOME/.config/shell/env.sh"

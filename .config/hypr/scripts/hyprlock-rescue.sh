#!/usr/bin/env bash
# Rescate desde otra TTY cuando se te queda la pantalla de "lockscreen crashed".
# Limpia el estado en TODAS las instancias vivas de Hyprland (sin adivinar el índice).
set -uo pipefail
n=0
while read -r idx sig pid; do
    [[ -z ${sig:-} ]] && continue
    printf 'instancia %s (pid %s): ' "$idx" "$pid"
    r=$(hyprctl -i "$idx" eval 'hl.clear_crashed_lockscreen()' 2>&1)
    case $r in
        *"not locked"*) echo "ya estaba libre" ;;
        ok)             echo "✓ lockscreen colgado limpiado" ;;
        *)              echo "$r" ;;
    esac
    n=$((n+1))
done < <(hyprctl instances -j | python3 -c '
import sys,json
for i,x in enumerate(json.load(sys.stdin)): print(i, x["instance"], x["pid"])')
pkill -x hyprlock 2>/dev/null
for s in $(loginctl list-sessions --no-legend | awk "{print \$1}"); do loginctl unlock-session "$s" 2>/dev/null; done
echo "listo: $n instancia(s) limpiadas. Vuelve con Ctrl+Alt+F1/F2."

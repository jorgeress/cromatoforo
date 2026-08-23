#!/usr/bin/env bash
WALLDIR="${HOME}/Pictures/wallpapers"
cd "$WALLDIR" || exit 1
SEL=$(for f in *.{jpg,jpeg,png}; do
        [ -f "$f" ] && echo -e "img:$WALLDIR/$f:text:$f"
      done | wofi --dmenu --show dmenu --allow-images --insensitive \
                  --columns 3 --width 900 --height 600 \
                  --define image_size=200 -p "" | sed 's/^.*text://')
[ -n "$SEL" ] && "${HOME}/.config/hypr/scripts/wall.sh" "$WALLDIR/$SEL"

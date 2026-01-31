#!/bin/bash

# Screenshot script using maim + slop
# Click for fullscreen, drag for area selection

DIR="$HOME/Downloads"
FILENAME="$DIR/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

# slop returns geometry; if width/height are 0, user clicked (fullscreen)
# otherwise they dragged (area selection)
read -r X Y W H < <(slop -f '%x %y %w %h' 2>/dev/null)

if [ -z "$X" ]; then
    # User cancelled (ESC)
    exit 0
fi

if [ "$W" -lt 10 ] && [ "$H" -lt 10 ]; then
    # Click detected - fullscreen
    maim "$FILENAME"
else
    # Drag detected - area selection
    maim -g "${W}x${H}+${X}+${Y}" "$FILENAME"
fi

if [ -f "$FILENAME" ]; then
    # Copy to clipboard
    xclip -selection clipboard -t image/png < "$FILENAME"
    
    # Notify with click action to open in ranger (run in background)
    # dunstify returns "1" for timeout/dismiss, "2" for action clicked
    (
        ACTION=$(dunstify "Screenshot saved" "$(basename "$FILENAME")\nClick to open" -i "$FILENAME" \
            -A "default,Open" -t 5000 -b)
        [ "$ACTION" = "2" ] && alacritty -e ranger --selectfile="$FILENAME"
    ) &
fi

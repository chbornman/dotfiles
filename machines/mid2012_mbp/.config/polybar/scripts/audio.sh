#!/bin/bash

case $1 in
    --toggle)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    --up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    --down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    --menu)
        # Show audio sinks in rofi for selection
        sinks=$(pactl list sinks | grep -E "Sink #|Description:" | paste - - | \
            sed 's/Sink #//;s/\s*Description: /: /')
        
        selected=$(echo "$sinks" | rofi -dmenu -i -p "Audio Output" -theme-str 'window {width: 500px;}')
        
        if [ -n "$selected" ]; then
            sink_num=$(echo "$selected" | cut -d: -f1 | tr -d ' ')
            pactl set-default-sink "$sink_num"
        fi
        ;;
    *)
        # Default: show volume status
        mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | grep -o "yes\|no")
        if [ "$mute" = "yes" ]; then
            echo "muted"
        else
            volume=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | head -1 | awk '{print $5}' | tr -d '%')
            echo "${volume}%"
        fi
        ;;
esac

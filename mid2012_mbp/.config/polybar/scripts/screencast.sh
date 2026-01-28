#!/bin/bash

# Toggle screen recording with ffmpeg
# No GUI - just start/stop with hotkey

PIDFILE="/tmp/screencast.pid"
DIR="$HOME/Downloads"

is_recording() {
    [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null
}

start_recording() {
    FILENAME="$DIR/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"

    # Get screen resolution
    RES=$(xdpyinfo | grep dimensions | awk '{print $2}')

    ffmpeg -y -f x11grab -framerate 30 -video_size "$RES" -i :0.0 \
        -c:v libx264 -preset ultrafast -crf 23 \
        "$FILENAME" >/dev/null 2>&1 &

    echo $! > "$PIDFILE"
    notify-send "Recording started" "$(basename "$FILENAME")"
}

stop_recording() {
    if is_recording; then
        kill -INT "$(cat "$PIDFILE")" 2>/dev/null
        sleep 0.5  # Wait for ffmpeg to finish writing
        SAVED_FILE=$(ls -t "$DIR"/recording_*.mp4 2>/dev/null | head -1)
        rm -f "$PIDFILE"
        
        # Notify with click action to open in ranger (run in background)
        (
            ACTION=$(dunstify "Recording saved" "$(basename "$SAVED_FILE")" \
                -A "1,Open" -t 5000 -b)
            [ "$ACTION" = "1" ] || [ "$ACTION" = "2" ] && alacritty -e ranger --selectfile="$SAVED_FILE"
        ) &
    fi
}

case "$1" in
    --toggle)
        if is_recording; then
            stop_recording
        else
            start_recording
        fi
        ;;
    *)
        if is_recording; then
            echo "REC"
        else
            echo ""
        fi
        ;;
esac

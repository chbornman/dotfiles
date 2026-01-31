#!/bin/bash

case $1 in
    --menu)
        # Open impala in terminal
        setsid -f alacritty -e /home/caleb/.cargo/bin/impala >/dev/null 2>&1
        ;;
    *)
        # Default: show current connection using iwd
        SSID=$(iwctl station wlan0 show 2>/dev/null | grep "Connected network" | awk '{print $3}')
        if [ -n "$SSID" ]; then
            echo "$SSID"
        else
            echo "off"
        fi
        ;;
esac

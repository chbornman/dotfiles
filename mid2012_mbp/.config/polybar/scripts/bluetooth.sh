#!/bin/bash

case $1 in
    --toggle)
        if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
            bluetoothctl power off
        else
            bluetoothctl power on
        fi
        ;;
    --menu)
        # Open bluetui in terminal
        setsid -f alacritty -e /home/caleb/.cargo/bin/bluetui >/dev/null 2>&1
        ;;
    *)
        # Default: show status
        if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
            connected=$(bluetoothctl info 2>/dev/null | grep "Name:" | cut -d' ' -f2-)
            if [ -n "$connected" ]; then
                echo "$connected"
            else
                echo "on"
            fi
        else
            echo "off"
        fi
        ;;
esac

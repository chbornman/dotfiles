#!/bin/bash

# Get the focused window info
focused=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true)')
app_id=$(echo "$focused" | jq -r '.app_id // empty')
pid=$(echo "$focused" | jq -r '.pid // empty')

# Check if focused window is a terminal (ghostty)
if [[ "$app_id" == "com.mitchellh.ghostty" ]] && [[ -n "$pid" ]]; then
    # Terminal is focused - type nvim into it
    # Use ydotool to simulate typing (Wayland equivalent of xdotool)
    if command -v ydotool &> /dev/null; then
        ydotool type 'nvim' && ydotool key 28:1 28:0  # 28 is Enter key
    else
        # Fallback: use wtype if available
        if command -v wtype &> /dev/null; then
            wtype 'nvim' && wtype -k Return
        else
            # Last resort: open new terminal at current directory
            shell_pid=$(pgrep -P "$pid" | head -1)
            if [[ -n "$shell_pid" ]]; then
                cwd=$(readlink -f "/proc/$shell_pid/cwd" 2>/dev/null)
            fi
            cwd="${cwd:-$HOME}"
            swaymsg exec "ghostty --working-directory=\"$cwd\" nvim"
        fi
    fi
else
    # No terminal focused, open nvim at home directory
    swaymsg exec "ghostty --working-directory=\"$HOME\" nvim"
fi

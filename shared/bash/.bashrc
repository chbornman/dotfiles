# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
export PATH="/opt/flutter/bin:$PATH"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH="$HOME/.local/bin:$PATH"

# Source user-specific bash prompt config (overrides omarchy defaults)
if [ -f "$HOME/.config/bash/prompt" ]; then
	source "$HOME/.config/bash/prompt"
fi

# Source env file if it exists
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
export SAL_USE_VCLPLUGIN=gtk3

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Use LLVM 19 by default (for ROCM compatibility)
export PATH="/usr/lib/llvm19/bin:$PATH"

# pnpm
export PNPM_HOME="/home/caleb/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

alias get_idf='. $HOME/esp/esp-idf/export.sh'

# Ruby gems
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"

# Set terminal title to show running command
case "$TERM" in
    xterm*|ghostty*|vte*|alacritty*|foot*)
        # Show username@hostname:pwd when idle
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/#$HOME/~}\007"'
        # Show the running command when executing
        trap 'echo -ne "\033]0;${BASH_COMMAND}\007"' DEBUG
        ;;
esac
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim

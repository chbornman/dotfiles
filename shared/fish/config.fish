# Fish shell configuration
# Migrated from ~/.bashrc

# Environment variables
set -gx CHROME_EXECUTABLE /usr/bin/google-chrome-stable
set -gx ANDROID_HOME "$HOME/Android/Sdk"
set -gx SAL_USE_VCLPLUGIN gtk3
set -gx BUN_INSTALL "$HOME/.bun"
set -gx PNPM_HOME "$HOME/.local/share/pnpm"

# PATH additions
# Fish has a cleaner way to add to PATH - fish_add_path prevents duplicates
fish_add_path "$HOME/.local/share/gem/ruby/3.4.0/bin"
fish_add_path "$PNPM_HOME"
fish_add_path "/usr/lib/llvm19/bin"
fish_add_path "$HOME/.bun/bin"
fish_add_path "$BUN_INSTALL/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$ANDROID_HOME/cmdline-tools/latest/bin"
fish_add_path "$ANDROID_HOME/platform-tools"
fish_add_path "$ANDROID_HOME/emulator"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "/opt/flutter/bin"
fish_add_path "$HOME/.lmstudio/bin"

# Aliases
# Add your custom aliases here

# Starship prompt (native Fish support!)
# You're using Starship with Capstan Cloud theme - it works perfectly with Fish
if type -q starship
    starship init fish | source
end

# Note: env file doesn't exist, skipping

# Cargo is already in PATH via fish_add_path above, no need to source .cargo/env

# Fish-specific enhancements
# Disable the greeting message
set -g fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
    
    # Custom key binding: Ctrl+Space accepts autosuggestion and executes
    bind ctrl-space 'commandline -f accept-autosuggestion execute'
end

# Set terminal title to show running command
function fish_title
    # Show the current command when running, otherwise show pwd
    if set -q argv[1]
        echo $argv[1]
    else
        prompt_pwd
    end
end
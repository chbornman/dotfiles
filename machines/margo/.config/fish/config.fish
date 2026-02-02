# Fish shell configuration for Caleb
# Migrated from bash config

# Only run in interactive shells
if not status is-interactive
    return
end

# Initialize starship prompt
starship init fish | source

# Initialize zoxide
zoxide init fish | source

# Editor
set -gx EDITOR nvim
set -gx SUDO_EDITOR $EDITOR
set -gx BAT_THEME ansi

# Chrome/Flutter
set -gx CHROME_EXECUTABLE /usr/bin/google-chrome-stable

# Android SDK
set -gx ANDROID_HOME $HOME/Android/Sdk

# Bun
set -gx BUN_INSTALL $HOME/.bun

# pnpm
set -gx PNPM_HOME $HOME/.local/share/pnpm

# Omarchy
set -gx OMARCHY_PATH $HOME/.local/share/omarchy

# LibreOffice GTK3
set -gx SAL_USE_VCLPLUGIN gtk3

# PATH configuration (order matters - first entries take priority)
fish_add_path --prepend $OMARCHY_PATH/bin
fish_add_path --prepend $HOME/.cargo/bin
fish_add_path --prepend $HOME/.local/bin
fish_add_path --prepend $HOME/.local/share/gem/ruby/3.4.0/bin
fish_add_path --prepend $PNPM_HOME
fish_add_path --prepend /usr/lib/llvm19/bin
fish_add_path --prepend $BUN_INSTALL/bin
fish_add_path --prepend /opt/flutter/bin
fish_add_path --prepend $ANDROID_HOME/emulator
fish_add_path --prepend $ANDROID_HOME/platform-tools
fish_add_path --prepend $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path --append $HOME/.lmstudio/bin

# Source uv environment if it exists
if test -f $HOME/.local/share/../bin/env.fish
    source $HOME/.local/share/../bin/env.fish
end

# Source cargo environment if it exists
if test -f $HOME/.cargo/env.fish
    source $HOME/.cargo/env.fish
end

# Margo machine-specific fish config
# Arch Linux desktop with NVIDIA, Android SDK, etc.

# Chrome/Flutter
set -gx CHROME_EXECUTABLE /usr/bin/google-chrome-stable

# Android SDK
set -gx ANDROID_HOME $HOME/Android/Sdk

# Bun
set -gx BUN_INSTALL $HOME/.bun

# pnpm
set -gx PNPM_HOME $HOME/.local/share/pnpm

# LibreOffice GTK3
set -gx SAL_USE_VCLPLUGIN gtk3

# PATH (machine-specific additions)
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

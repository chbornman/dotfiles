# Margo machine-specific fish configuration
# This extends the shared fish config

# Initialize zoxide for smart directory navigation
if type -q zoxide
    zoxide init fish | source
end

# Omarchy-specific paths
set -gx OMARCHY_PATH $HOME/.local/share/omarchy
fish_add_path --prepend $OMARCHY_PATH/bin

# Editor settings
set -gx EDITOR nvim
set -gx SUDO_EDITOR $EDITOR
set -gx BAT_THEME ansi

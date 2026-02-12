# Asahi machine-specific fish config
# Fedora ARM laptop (Apple Silicon)

# OpenCode
fish_add_path $HOME/.opencode/bin

# Bun
set -gx BUN_INSTALL $HOME/.bun
fish_add_path $BUN_INSTALL/bin

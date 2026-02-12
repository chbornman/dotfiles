# Fish shell configuration - shared across machines
# Machine-specific env/PATH goes in fish-machine.fish (sourced below)

# Only run in interactive shells
if not status is-interactive
    return
end

# ============================================================================
# SHARED ENVIRONMENT
# ============================================================================

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR $EDITOR
set -gx BAT_THEME ansi

# ============================================================================
# SHARED PATH
# ============================================================================

fish_add_path --prepend $HOME/.cargo/bin
fish_add_path --prepend $HOME/.local/bin

# ============================================================================
# PROMPT
# ============================================================================

if type -q starship
    starship init fish | source
end

# ============================================================================
# ZOXIDE
# ============================================================================

if type -q zoxide
    zoxide init fish | source
end

# ============================================================================
# KEYBINDINGS
# ============================================================================

# Ctrl+Space accepts autosuggestion and executes
bind ctrl-space 'commandline -f accept-autosuggestion execute'

# ============================================================================
# SHELL SETTINGS
# ============================================================================

set -g fish_greeting

function fish_title
    if set -q argv[1]
        echo $argv[1]
    else
        prompt_pwd
    end
end

# ============================================================================
# SOURCE MACHINE-SPECIFIC CONFIG
# ============================================================================

if test -f ~/.config/fish/fish-machine.fish
    source ~/.config/fish/fish-machine.fish
end

# Source cargo environment if it exists
if test -f $HOME/.cargo/env.fish
    source $HOME/.cargo/env.fish
end

#!/bin/bash
# Dotfiles installer - symlinks shared and machine-specific configs
# Detects machine by hostname: margo, asahi

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTNAME=$(hostname)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn()   { echo -e "${YELLOW}[!!]${NC} $1"; }
error()  { echo -e "${RED}[ERR]${NC} $1"; }
header() { echo -e "\n${BLUE}===${NC} $1"; }

# Create a symlink, backing up existing files
link() {
    local src="$1"
    local dst="$2"

    if [ ! -e "$src" ]; then
        warn "Source does not exist: $src"
        return
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$dst")"

    # Skip if destination already points to the correct source
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        info "$(basename "$dst") → $src (already linked)"
        return
    fi

    # Resolve the real path of src to detect circular links
    local real_src
    real_src="$(realpath "$src")"
    local real_dst_dir
    real_dst_dir="$(realpath "$(dirname "$dst")")"

    # Handle existing files
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        # Don't back up if the real paths match (same file via dir symlink)
        local real_dst
        real_dst="$(realpath "$dst")"
        if [ "$real_src" = "$real_dst" ]; then
            info "$(basename "$dst") → $src (already correct)"
            return
        fi
        local backup="${dst}.bak.$(date +%Y%m%d_%H%M%S)"
        warn "Backing up $dst → $backup"
        mv "$dst" "$backup"
    fi

    ln -s "$src" "$dst"
    info "$(basename "$dst") → $src"
}

# Determine machine
detect_machine() {
    case "$HOSTNAME" in
        margo*)  echo "margo" ;;
        asahi*)  echo "asahi" ;;
        *)
            warn "Unknown hostname '$HOSTNAME'. Specify machine as argument."
            echo ""
            ;;
    esac
}

install_shared() {
    header "Shared configs"

    # Hyprland shared configs (sourced by machine hyprland.conf)
    mkdir -p ~/.config/hypr/shared
    link "$DOTFILES/shared/hypr/hyprland.conf"  ~/.config/hypr/shared/hyprland.conf
    link "$DOTFILES/shared/hypr/bindings.conf"   ~/.config/hypr/shared/bindings.conf
    link "$DOTFILES/shared/hypr/windows.conf"    ~/.config/hypr/shared/windows.conf
    link "$DOTFILES/shared/hypr/hypridle.conf"   ~/.config/hypr/shared/hypridle.conf

    # Hyprlock
    link "$DOTFILES/shared/hyprlock/hyprlock.conf" ~/.config/hypr/hyprlock.conf

    # Waybar
    mkdir -p ~/.config/waybar
    link "$DOTFILES/shared/waybar/config"    ~/.config/waybar/config
    link "$DOTFILES/shared/waybar/style.css" ~/.config/waybar/style.css

    # Waybar-hovermenu
    mkdir -p ~/.config/waybar-hovermenu
    link "$DOTFILES/shared/waybar-hovermenu/config.toml" ~/.config/waybar-hovermenu/config.toml

    # Yazi
    mkdir -p ~/.config/yazi
    link "$DOTFILES/shared/yazi/yazi.toml"   ~/.config/yazi/yazi.toml
    link "$DOTFILES/shared/yazi/theme.toml"  ~/.config/yazi/theme.toml
    link "$DOTFILES/shared/yazi/keymap.toml" ~/.config/yazi/keymap.toml

    # GTK themes (Capstan Cloud)
    mkdir -p ~/.config/gtk-3.0
    link "$DOTFILES/shared/gtk-3.0/gtk.css" ~/.config/gtk-3.0/gtk.css
    mkdir -p ~/.config/gtk-4.0
    link "$DOTFILES/shared/gtk-4.0/gtk.css" ~/.config/gtk-4.0/gtk.css

    # Ghostty
    mkdir -p ~/.config/ghostty
    link "$DOTFILES/shared/ghostty/config" ~/.config/ghostty/config

    # Mako
    mkdir -p ~/.config/mako
    link "$DOTFILES/shared/mako/config" ~/.config/mako/config

    # Wofi
    mkdir -p ~/.config/wofi
    link "$DOTFILES/shared/wofi/config"    ~/.config/wofi/config
    link "$DOTFILES/shared/wofi/style.css" ~/.config/wofi/style.css

    # Fish
    mkdir -p ~/.config/fish
    link "$DOTFILES/shared/fish/config.fish" ~/.config/fish/config.fish

    # Starship
    link "$DOTFILES/shared/starship/starship.toml" ~/.config/starship.toml

    # Shared scripts — link each into ~/.local/bin
    # If ~/.local/bin is a dir symlink (into machines/<x>/.local/bin),
    # we create symlinks to shared scripts inside that target directory.
    mkdir -p ~/.local/bin
    for script in "$DOTFILES"/shared/scripts/*; do
        if [ -f "$script" ]; then
            link "$script" ~/.local/bin/"$(basename "$script")"
        fi
    done

    # Nvim (stow-style, if the shared nvim dir has .config/nvim structure)
    if [ -d "$DOTFILES/shared/nvim/.config/nvim" ]; then
        link "$DOTFILES/shared/nvim/.config/nvim" ~/.config/nvim
    elif [ -d "$DOTFILES/nvim/.config/nvim" ]; then
        link "$DOTFILES/nvim/.config/nvim" ~/.config/nvim
    fi

    # Git
    if [ -f "$DOTFILES/shared/git/.gitconfig" ]; then
        link "$DOTFILES/shared/git/.gitconfig" ~/.gitconfig
    fi

    # Tmux
    if [ -f "$DOTFILES/shared/tmux/.tmux.conf" ]; then
        link "$DOTFILES/shared/tmux/.tmux.conf" ~/.tmux.conf
    fi

    # Claude
    if [ -d "$DOTFILES/shared/claude/.claude" ]; then
        link "$DOTFILES/shared/claude/.claude" ~/.claude
    elif [ -d "$DOTFILES/claude/.claude" ]; then
        link "$DOTFILES/claude/.claude" ~/.claude
    fi
}

install_machine() {
    local machine="$1"
    local machine_dir="$DOTFILES/machines/$machine"

    if [ ! -d "$machine_dir" ]; then
        error "Machine directory not found: $machine_dir"
        exit 1
    fi

    header "Machine: $machine"

    # Hyprland entry point and machine config
    link "$machine_dir/hyprland.conf"  ~/.config/hypr/hyprland.conf
    link "$machine_dir/machine.conf"   ~/.config/hypr/machine.conf
    link "$machine_dir/autostart.conf" ~/.config/hypr/autostart.conf

    # Machine-specific scripts (skip symlinks — those are shared script entries)
    if [ -d "$machine_dir/.local/bin" ]; then
        for script in "$machine_dir/.local/bin"/*; do
            if [ -f "$script" ] && [ ! -L "$script" ]; then
                link "$script" ~/.local/bin/"$(basename "$script")"
            fi
        done
    fi

    # Machine-specific fish
    if [ -f "$machine_dir/fish-machine.fish" ]; then
        link "$machine_dir/fish-machine.fish" ~/.config/fish/fish-machine.fish
    fi
}

install_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [ ! -d "$tpm_dir" ]; then
        info "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi
}

# ============================================================================
# MAIN
# ============================================================================

echo "=========================================="
echo "  Dotfiles Installer"
echo "=========================================="

MACHINE="${1:-$(detect_machine)}"

if [ -z "$MACHINE" ]; then
    echo
    echo "Usage: $0 <machine>"
    echo "  Machines: margo, asahi"
    exit 1
fi

echo "Machine: $MACHINE"
echo "Dotfiles: $DOTFILES"

install_shared
install_machine "$MACHINE"
install_tpm

header "Done!"
echo
echo "Next steps:"
echo "  1. Reload fish: source ~/.config/fish/config.fish"
echo "  2. Reload Hyprland: SUPER+SHIFT+C"
echo "  3. Open tmux and press prefix + I to install plugins"
echo "  4. Open nvim to let Lazy.nvim install plugins"
echo
echo "Greetd setup (requires sudo):"
echo "  sudo cp $DOTFILES/shared/greetd/config.toml /etc/greetd/config.toml"
echo "  sudo systemctl disable sddm"
echo "  sudo systemctl enable greetd"
echo

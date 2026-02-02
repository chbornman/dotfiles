#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_PACKAGES=(tmux nvim claude bash fish starship git)
HOSTNAME=$(hostname)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
header() { echo -e "${BLUE}[====]${NC} $1"; }

# Check if stow is installed
check_stow() {
    if ! command -v stow &> /dev/null; then
        error "GNU Stow is not installed."
        echo "Install it with your package manager:"
        echo "  Arch:   sudo pacman -S stow"
        echo "  Ubuntu: sudo apt install stow"
        echo "  macOS:  brew install stow"
        exit 1
    fi
}

# Backup existing config if it exists and isn't a symlink
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        warn "Backing up existing $target to $backup"
        mv "$target" "$backup"
    elif [[ -L "$target" ]]; then
        # Remove existing symlink
        rm "$target"
    fi
}

# Stow a package from a specific directory
stow_package() {
    local pkg="$1"
    local stow_dir="$2"
    info "Stowing $pkg from $stow_dir..."

    case "$pkg" in
        tmux)
            backup_if_exists "$HOME/.tmux.conf"
            ;;
        nvim)
            backup_if_exists "$HOME/.config/nvim"
            ;;
        claude)
            backup_if_exists "$HOME/.claude"
            ;;
        bash)
            backup_if_exists "$HOME/.bashrc"
            backup_if_exists "$HOME/.bash_profile"
            backup_if_exists "$HOME/.config/bash"
            ;;
        fish)
            backup_if_exists "$HOME/.config/fish/config.fish"
            backup_if_exists "$HOME/.config/fish/fish_plugins"
            backup_if_exists "$HOME/.config/fish/fish_variables"
            backup_if_exists "$HOME/.config/fish/functions"
            backup_if_exists "$HOME/.config/fish/completions"
            ;;
        starship)
            backup_if_exists "$HOME/.config/starship.toml"
            ;;
        git)
            backup_if_exists "$HOME/.gitconfig"
            ;;
        margo)
            # Margo machine (Omarchy/Hyprland)
            # Hyprland
            backup_if_exists "$HOME/.config/hypr/hyprland.conf"
            backup_if_exists "$HOME/.config/hypr/bindings.conf"
            backup_if_exists "$HOME/.config/hypr/monitors.conf"
            backup_if_exists "$HOME/.config/hypr/input.conf"
            backup_if_exists "$HOME/.config/hypr/envs.conf"
            backup_if_exists "$HOME/.config/hypr/windows.conf"
            backup_if_exists "$HOME/.config/hypr/looknfeel.conf"
            backup_if_exists "$HOME/.config/hypr/autostart.conf"
            backup_if_exists "$HOME/.config/hypr/hypridle.conf"
            backup_if_exists "$HOME/.config/hypr/hyprlock.conf"
            backup_if_exists "$HOME/.config/hypr/hyprsunset.conf"
            backup_if_exists "$HOME/.config/hypr/nvidia-fixes.conf"
            backup_if_exists "$HOME/.config/hypr/xdph.conf"
            # Waybar
            backup_if_exists "$HOME/.config/waybar/config.jsonc"
            backup_if_exists "$HOME/.config/waybar/style.css"
            # Terminal
            backup_if_exists "$HOME/.config/ghostty/config"
            # Fish
            backup_if_exists "$HOME/.config/fish/config.fish"
            backup_if_exists "$HOME/.config/fish/conf.d/margo.fish"
            backup_if_exists "$HOME/.config/fish/conf.d/aliases.fish"
            backup_if_exists "$HOME/.config/fish/functions"
            # Other
            backup_if_exists "$HOME/.config/starship.toml"
            backup_if_exists "$HOME/.config/btop/btop.conf"
            backup_if_exists "$HOME/.config/walker/config.toml"
            ;;
        asahi|mid2012_mbp|i3)
            # Machine-specific packages - backup all config directories
            backup_if_exists "$HOME/.config/sway"
            backup_if_exists "$HOME/.config/waybar"
            backup_if_exists "$HOME/.config/mako"
            backup_if_exists "$HOME/.config/swaylock"
            backup_if_exists "$HOME/.config/i3"
            backup_if_exists "$HOME/.config/polybar"
            backup_if_exists "$HOME/.config/rofi"
            backup_if_exists "$HOME/.config/alacritty"
            backup_if_exists "$HOME/.config/dunst"
            backup_if_exists "$HOME/.local/bin"
            ;;
    esac

    stow -d "$stow_dir" -t "$HOME" "$pkg"
}

# Install TPM (Tmux Plugin Manager)
install_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ ! -d "$tpm_dir" ]]; then
        info "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
        info "TPM installed. Press prefix + I in tmux to install plugins."
    else
        info "TPM already installed."
    fi
}

# List available packages
list_packages() {
    header "Available Packages:"
    echo
    echo "Shared packages (work on all machines):"
    for pkg in "${SHARED_PACKAGES[@]}"; do
        if [[ -d "$DOTFILES_DIR/shared/$pkg" ]]; then
            echo "  - $pkg"
        fi
    done
    echo
    echo "Machine-specific packages:"
    if [[ -d "$DOTFILES_DIR/machines" ]]; then
        for machine in "$DOTFILES_DIR/machines"/*; do
            if [[ -d "$machine" ]]; then
                echo "  - $(basename "$machine")"
            fi
        done
    fi
    echo
    info "Current hostname: $HOSTNAME"
    echo
}

# Main
main() {
    echo "=========================================="
    echo "  Dotfiles Installation Script"
    echo "=========================================="
    echo

    check_stow

    cd "$DOTFILES_DIR"

    # Show help if requested
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "Usage: $0 [OPTIONS] [PACKAGES...]"
        echo
        echo "Options:"
        echo "  -h, --help     Show this help message"
        echo "  -l, --list     List available packages"
        echo "  shared         Install all shared packages"
        echo "  <machine>      Install machine-specific package (e.g., asahi, mid2012_mbp)"
        echo
        echo "Examples:"
        echo "  $0 shared asahi           # Install shared packages + asahi configs"
        echo "  $0 tmux nvim              # Install only tmux and nvim from shared"
        echo "  $0                        # Install all shared packages for current machine"
        exit 0
    fi

    # List packages if requested
    if [[ "$1" == "-l" || "$1" == "--list" ]]; then
        list_packages
        exit 0
    fi

    # Determine what to install
    INSTALL_SHARED=false
    MACHINE_PACKAGES=()
    SELECTED_SHARED=()

    if [[ $# -eq 0 ]]; then
        # No args: install all shared packages
        INSTALL_SHARED=true
        SELECTED_SHARED=("${SHARED_PACKAGES[@]}")
    else
        # Parse arguments
        for arg in "$@"; do
            if [[ "$arg" == "shared" ]]; then
                INSTALL_SHARED=true
                SELECTED_SHARED=("${SHARED_PACKAGES[@]}")
            elif [[ -d "$DOTFILES_DIR/machines/$arg" ]]; then
                MACHINE_PACKAGES+=("$arg")
            elif [[ -d "$DOTFILES_DIR/shared/$arg" ]]; then
                SELECTED_SHARED+=("$arg")
            else
                warn "Package '$arg' not found, skipping..."
            fi
        done
    fi

    # Install shared packages
    if [[ ${#SELECTED_SHARED[@]} -gt 0 ]]; then
        header "Installing shared packages..."
        for pkg in "${SELECTED_SHARED[@]}"; do
            if [[ -d "$DOTFILES_DIR/shared/$pkg" ]]; then
                stow_package "$pkg" "$DOTFILES_DIR/shared"
            fi
        done
    fi

    # Install machine-specific packages
    if [[ ${#MACHINE_PACKAGES[@]} -gt 0 ]]; then
        header "Installing machine-specific packages..."
        for machine in "${MACHINE_PACKAGES[@]}"; do
            if [[ -d "$DOTFILES_DIR/machines/$machine" ]]; then
                stow_package "$machine" "$DOTFILES_DIR/machines"
            fi
        done
    fi

    # Post-install tasks
    install_tpm

    echo
    info "Installation complete!"
    echo
    echo "Next steps:"
    echo "  1. Restart your shell or run: source ~/.bashrc"
    echo "  2. Open tmux and press prefix + I to install plugins"
    echo "  3. Open nvim to let Lazy.nvim install plugins"
}

main "$@"

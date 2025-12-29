#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(tmux nvim claude ghostty bash starship git)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

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

# Stow a package
stow_package() {
    local pkg="$1"
    info "Stowing $pkg..."

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
        ghostty)
            backup_if_exists "$HOME/.config/ghostty"
            ;;
        bash)
            backup_if_exists "$HOME/.bashrc"
            backup_if_exists "$HOME/.bash_profile"
            backup_if_exists "$HOME/.config/bash"
            ;;
        starship)
            backup_if_exists "$HOME/.config/starship.toml"
            ;;
        git)
            backup_if_exists "$HOME/.gitconfig"
            ;;
    esac

    stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
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

# Main
main() {
    echo "=========================================="
    echo "  Dotfiles Installation Script"
    echo "=========================================="
    echo

    check_stow

    cd "$DOTFILES_DIR"

    # Allow selecting specific packages or all
    if [[ $# -gt 0 ]]; then
        PACKAGES=("$@")
    fi

    for pkg in "${PACKAGES[@]}"; do
        if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
            stow_package "$pkg"
        else
            warn "Package '$pkg' not found, skipping..."
        fi
    done

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

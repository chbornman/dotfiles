# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

This repository is organized into **shared** configurations (work on all machines) and **machine-specific** configurations (tailored for individual systems):

```
dotfiles/
├── shared/              # Configs that work everywhere
│   ├── tmux/           # Terminal multiplexer
│   ├── nvim/           # Neovim with AstroNvim
│   ├── bash/           # Shell configuration
│   ├── git/            # Git config & aliases
│   ├── starship/       # Prompt theme
│   └── claude/         # Claude Code CLI
├── machines/           # Machine-specific configs
│   ├── asahi/         # Asahi Linux (Apple Silicon, Sway/Wayland)
│   ├── mid2012_mbp/   # MacBook Pro 2012 (i3/X11)
│   └── ...            # Add your own machines!
├── install.sh
└── README.md
```

## Included Configurations

### Shared Packages (All Machines)

| Package | Description |
|---------|-------------|
| `tmux` | Terminal multiplexer with vi mode, TPM plugins |
| `nvim` | AstroNvim setup with 67+ plugins, full LSP support |
| `claude` | Claude Code CLI settings |
| `bash` | Bash shell config with custom prompt |
| `fish` | Fish shell config with starship, zoxide integration |
| `starship` | Starship prompt with git status |
| `git` | Git config with aliases, rebase strategy |

### Machine-Specific Packages

| Machine | Description | Window Manager |
|---------|-------------|----------------|
| `margo` | Desktop workstation (Omarchy/Arch) | Hyprland (Wayland) |
| `asahi` | Asahi Linux on Apple Silicon | Sway (Wayland) |
| `mid2012_mbp` | MacBook Pro Mid-2012 | i3wm (X11) |

## Installation

### Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- Git

```bash
# Arch Linux
sudo pacman -S stow

# Ubuntu/Debian
sudo apt install stow

# macOS
brew install stow
```

### Setup

```bash
# Clone the repo
git clone https://github.com/chbornman/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install shared configs + machine-specific configs
./install.sh shared margo           # For Margo desktop (Omarchy/Hyprland)
./install.sh shared asahi           # For Asahi Linux machine
./install.sh shared mid2012_mbp     # For old MacBook Pro

# Or install only shared packages
./install.sh shared

# Or install specific packages
./install.sh tmux nvim starship

# List available packages
./install.sh --list
```

The install script will:
1. Back up any existing configs (with timestamp)
2. Create symlinks via GNU Stow
3. Install TPM (Tmux Plugin Manager)

### Post-Install

1. **Shell**: Restart or `source ~/.bashrc`
2. **Tmux**: Open tmux, press `C-Space + I` to install plugins
3. **Neovim**: Open nvim, Lazy.nvim will auto-install plugins

## Adding Your Own Machine

To add configs for a new machine:

```bash
cd ~/dotfiles/machines
mkdir my-desktop
cd my-desktop

# Create the directory structure matching your home directory
mkdir -p .config/{i3,polybar,whatever}
mkdir -p .local/bin

# Copy your configs
cp ~/.config/i3/config .config/i3/
cp ~/.local/bin/my-script .local/bin/

# Back to dotfiles root and install
cd ~/dotfiles
./install.sh shared my-desktop
```

## Updating

To pull latest changes and re-stow:

```bash
cd ~/dotfiles
git pull
./install.sh
```

## Uninstalling

```bash
cd ~/dotfiles

# Uninstall shared packages
stow -d shared -t "$HOME" -D tmux nvim bash starship git claude

# Uninstall machine-specific packages
stow -d machines -t "$HOME" -D asahi
```

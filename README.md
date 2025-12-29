# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Included Configurations

| Package | Description |
|---------|-------------|
| `tmux` | Terminal multiplexer with vi mode, TPM plugins |
| `nvim` | AstroNvim setup with 67+ plugins, full LSP support |
| `claude` | Claude Code CLI settings |
| `ghostty` | Ghostty terminal emulator |
| `bash` | Bash shell config with custom prompt |
| `starship` | Starship prompt with git status |
| `git` | Git config with aliases, rebase strategy |

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

# Install all packages
./install.sh

# Or install specific packages
./install.sh tmux nvim starship
```

The install script will:
1. Back up any existing configs
2. Create symlinks via stow
3. Install TPM (Tmux Plugin Manager)

### Post-Install

1. **Shell**: Restart or `source ~/.bashrc`
2. **Tmux**: Open tmux, press `C-Space + I` to install plugins
3. **Neovim**: Open nvim, Lazy.nvim will auto-install plugins

## Structure

```
dotfiles/
├── tmux/
│   └── .tmux.conf
├── nvim/
│   └── .config/nvim/
├── claude/
│   └── .claude/
├── ghostty/
│   └── .config/ghostty/
├── bash/
│   ├── .bashrc
│   ├── .bash_profile
│   └── .config/bash/
├── starship/
│   └── .config/starship.toml
├── git/
│   └── .gitconfig
├── install.sh
└── README.md
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
stow -D tmux nvim claude ghostty bash starship git
```

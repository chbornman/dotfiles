# Margo - Desktop Workstation Configuration

Machine-specific configuration for the main desktop workstation running Omarchy (Arch Linux with Hyprland).

## System Info

- **Hostname**: margo
- **OS**: Omarchy (Arch Linux)
- **Architecture**: x86_64 (AMD/Intel)
- **Window Manager**: Hyprland (Wayland compositor)
- **Status Bar**: Waybar
- **Terminal**: Ghostty
- **Shell**: Fish
- **Prompt**: Starship

## Included Configs

### Hyprland (`~/.config/hypr/`)

| File | Description |
|------|-------------|
| `hyprland.conf` | Main config, sources other files |
| `bindings.conf` | Keybindings including whisper dictation |
| `monitors.conf` | Display configuration |
| `input.conf` | Keyboard/mouse settings |
| `envs.conf` | Environment variables |
| `windows.conf` | Window rules |
| `looknfeel.conf` | Appearance (gaps, borders, animations) |
| `autostart.conf` | Startup applications |
| `hypridle.conf` | Idle behavior (dim, lock, suspend) |
| `hyprlock.conf` | Lock screen appearance |
| `hyprsunset.conf` | Night light / blue light filter |
| `nvidia-fixes.conf` | NVIDIA-specific fixes |
| `xdph.conf` | XDG portal settings |

### Waybar (`~/.config/waybar/`)

- `config.jsonc` - Bar layout with custom whisper module
- `style.css` - Styling with whisper indicator states

### Fish Shell (`~/.config/fish/`)

- `config.fish` - Main config with PATH, environment, starship, zoxide
- `conf.d/aliases.fish` - Aliases (ls, git, tools)
- `conf.d/margo.fish` - Machine-specific settings
- `functions/` - Custom functions:
  - `cd.fish` - Smart cd with zoxide
  - `n.fish` - nvim shortcut
  - `open.fish` - xdg-open wrapper
  - `compress.fish` - tar.gz compression
  - `img2jpg.fish`, `img2jpg-small.fish`, `img2png.fish` - Image conversion
  - `transcode-video-1080p.fish`, `transcode-video-4K.fish` - Video transcoding
  - `iso2sd.fish`, `format-drive.fish` - Drive utilities

### Other Configs

- `ghostty/config` - Terminal settings
- `starship.toml` - Prompt theme
- `btop/btop.conf` - System monitor
- `walker/config.toml` - App launcher

## Key Features

### Whisper Dictation (asahi-whisper-daemon)

Voice dictation system using whisper.cpp:

| Key | Action |
|-----|--------|
| SUPER+D | Toggle streaming mode (live VAD transcription) |
| SUPER+SHIFT+D | Toggle press-to-record mode |

Waybar indicator:
- Left-click: Toggle streaming
- Right-click: Switch models

### Custom Keybindings

| Key | Action |
|-----|--------|
| SUPER+Return | Terminal (Ghostty) |
| SUPER+F | File manager (Nautilus) |
| SUPER+B | Browser (Zen) |
| SUPER+D | Streaming dictation |
| SUPER+SHIFT+D | Press-to-record dictation |
| SUPER+M | Music (Spotify) |
| SUPER+N | Editor |
| SUPER+O | Obsidian |

## Installation

```bash
cd ~/dotfiles
./install.sh shared margo
chsh -s /usr/bin/fish
```

## Dependencies

### Core
- hyprland, waybar, ghostty
- fish, starship, zoxide, eza, fzf, bat
- btop, walker

### Whisper Dictation

Located at `~/projects/asahi-whisper-daemon/`:
- whisper.cpp (built with SDL2)
- Python: sounddevice, numpy, scipy
- wtype, ncat

## Post-Installation

1. Set fish as default shell: `chsh -s /usr/bin/fish`
2. Enable whisper service: `systemctl --user enable --now whisper.service`
3. Restart waybar: `omarchy-restart-waybar`
4. Log out/in for shell change to take effect

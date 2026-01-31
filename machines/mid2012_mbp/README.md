# Mid-2012 MacBook Pro - i3 Configuration

Machine-specific configuration for running i3wm on a Mid-2012 MacBook Pro (MacBookPro9,2) with Ubuntu.

## Theme: Capstan Cloud

All configs use the Capstan Cloud color palette for a consistent look:

| Token         | Hex       | Usage                             |
| ------------- | --------- | --------------------------------- |
| `neutral-950` | `#0f0e0e` | Deepest background (login screen) |
| `neutral-900` | `#1a1917` | Page/screen background            |
| `neutral-800` | `#262422` | Card/container background         |
| `neutral-700` | `#393634` | Elevated surfaces, borders        |
| `neutral-600` | `#524f4c` | Subtle borders                    |
| `neutral-400` | `#8c8985` | Muted/placeholder text            |
| `neutral-300` | `#b8b5b0` | Secondary text                    |
| `neutral-200` | `#d4d2cd` | Light borders                     |
| `neutral-100` | `#f7f7f5` | Primary text (dark mode)          |
| `brass-400`   | `#d4a366` | Primary accent                    |
| `brass-300`   | `#f8ce9b` | Lighter accent                    |
| `brass-600`   | `#6d4925` | Darker accent                     |
| `error`       | `#ff4d4f` | Error/urgent states               |
| `success`     | `#52c41a` | Success states                    |

## Hardware

- **Model:** MacBook Pro Mid-2012 (MacBookPro9,2)
- **Display:** Built-in LVDS-1 + external DP-2
- **Audio:** Intel HDA (snd_hda_intel)
- **WiFi:** Broadcom BCM4331 (using iwd)
- **Keyboard:** Apple keyboard with function keys

## Keybindings

### Window Management (Mod = Super/Command)

| Binding             | Action                              |
| ------------------- | ----------------------------------- |
| `Mod+Return`        | Open terminal (Alacritty)           |
| `Mod+q`             | Close focused window                |
| `Mod+h/j/k/l`       | Focus left/down/up/right            |
| `Mod+Shift+h/j/k/l` | Move window left/down/up/right      |
| `Mod+\`             | Split horizontal                    |
| `Mod+-`             | Split vertical                      |
| `Mod+F11`           | Toggle fullscreen                   |
| `Mod+s`             | Stacking layout                     |
| `Mod+w`             | Tabbed layout                       |
| `Mod+e`             | Toggle split layout                 |
| `Mod+Shift+Space`   | Toggle floating                     |
| `Mod+d`             | Focus mode toggle (tiling/floating) |
| `Mod+r`             | Enter resize mode                   |
| `Mod+m`             | Move workspace to other monitor     |
| `Mod+i`             | Toggle polybar visibility           |

### Workspaces

| Binding         | Action                           |
| --------------- | -------------------------------- |
| `Mod+1-0`       | Switch to workspace 1-10         |
| `Mod+Shift+1-0` | Move container to workspace 1-10 |

Workspaces 1-3 are assigned to LVDS-1 (built-in), 4-6 to DP-2 (external).

### Applications

| Binding            | Action                            |
| ------------------ | --------------------------------- |
| `Mod+Space`        | Application launcher (rofi)       |
| `Mod+b`            | Zen Browser                       |
| `Mod+a`            | Claude AI (in browser)            |
| `Mod+f`            | File manager (ranger in terminal) |
| `Mod+n`            | WiFi manager (impala TUI)         |
| `Mod+Shift+b`      | Bluetooth manager (bluetui)       |
| `Mod+o`            | OpenCode                          |
| `Mod+Shift+s`      | LocalSend                         |
| `F3` (XF86LaunchA) | Nautilus                          |
| `F4` (XF86LaunchB) | Ranger                            |

### Media Keys

| Key                        | Action                      |
| -------------------------- | --------------------------- |
| `F1` (Brightness Down)     | Decrease screen brightness  |
| `F2` (Brightness Up)       | Increase screen brightness  |
| `F5` (Kbd Brightness Down) | Decrease keyboard backlight |
| `F6` (Kbd Brightness Up)   | Increase keyboard backlight |
| `F10` (Mute)               | Toggle audio mute           |
| `F11` (Volume Down)        | Decrease volume 5%          |
| `F12` (Volume Up)          | Increase volume 5%          |

### Screenshots & Recording

| Binding         | Action                                   |
| --------------- | ---------------------------------------- |
| `Mod+Eject`     | Screenshot (click=fullscreen, drag=area) |
| `Mod+Alt+Eject` | Toggle screen recording                  |

Screenshots and recordings save to `~/Downloads/` and copy to clipboard.

### i3 Management

| Binding       | Action              |
| ------------- | ------------------- |
| `Mod+Shift+c` | Reload i3 config    |
| `Mod+Shift+r` | Restart i3 in-place |
| `Mod+Shift+e` | Exit i3 (logout)    |

### LightDM Lock Screen

| Binding  | Action         |
| -------- | -------------- |
| `Meta+s` | Shutdown       |
| `Meta+r` | Restart        |
| `Meta+h` | Hibernate      |
| `Meta+u` | Suspend        |
| `Meta+e` | Cycle sessions |

## Installed Configs

### Window Manager & Bar

- **i3** - Tiling window manager
- **polybar** - Status bar (bottom)
- **rofi** - Application launcher

### Terminal & Shell

- **alacritty** - GPU-accelerated terminal
- **starship** - Shell prompt
- **tmux** - Terminal multiplexer

### Notifications

- **dunst** - Notification daemon

### Login

- **lightdm** - Display manager
- **lightdm-mini-greeter** - Minimal greeter

### File Management

- **ranger** - Terminal file manager
- **nautilus** - GUI file manager

### Development

- **opencode** - AI coding assistant TUI (with custom Capstan theme)

### Utilities

- **impala** - WiFi TUI (iwd frontend)
- **bluetui** - Bluetooth TUI
- **wiremix** - PipeWire/PulseAudio mixer TUI
- **maim/slop** - Screenshot tools
- **ffmpeg** - Screen recording
- **brightnessctl** - Brightness control

## Scripts

Located in `~/.local/bin/`:

| Script    | Description                             |
| --------- | --------------------------------------- |
| `vol`     | Volume control with notifications       |
| `bright`  | Screen brightness with log-scale steps  |
| `kbright` | Keyboard backlight with log-scale steps |

Located in `~/.config/polybar/scripts/`:

| Script          | Description                                   |
| --------------- | --------------------------------------------- |
| `audio.sh`      | Volume status for polybar, rofi sink selector |
| `wifi.sh`       | WiFi status, opens impala on click            |
| `bluetooth.sh`  | Bluetooth status, opens bluetui on click      |
| `screenshot.sh` | Screenshot with area/fullscreen detection     |
| `screencast.sh` | Toggle screen recording                       |

## Installation

This folder uses GNU Stow. Since configs go to multiple locations:

```bash
# Configs that go to ~/.config and ~/.local
cd ~/dotfiles
stow -t ~ mid2012_mbp

# LightDM config requires sudo (goes to /etc)
sudo cp mid2012_mbp/etc/lightdm/lightdm-mini-greeter.conf /etc/lightdm/

# OpenCode theme (already at ~/.config/opencode/themes/capstan.json)
# Set in opencode.json: "theme": "capstan"
```

## Dependencies

```bash
# Core
sudo apt install i3 polybar rofi dunst alacritty lightdm lightdm-mini-greeter

# Utilities
sudo apt install brightnessctl maim slop xclip ffmpeg nautilus

# From cargo
cargo install impala bluetui wiremix

# Fonts
sudo apt install fonts-jetbrains-mono
```

## Display Configuration

Uses `autorandr` for automatic display configuration:

- LVDS-1: Built-in 1280x800 display
- DP-2: External display via Thunderbolt/Mini DisplayPort

Workspaces are pinned:

- 1, 2, 3 -> LVDS-1
- 4, 5, 6 -> DP-2

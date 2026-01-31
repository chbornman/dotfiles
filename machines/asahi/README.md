# Asahi Linux Configuration

Machine-specific configuration for Asahi Linux running on Apple Silicon.

## System Info

- **OS**: Asahi Linux (Fedora-based)
- **Architecture**: ARM64 (Apple Silicon)
- **Window Manager**: Sway (Wayland compositor)
- **Status Bar**: Waybar
- **Notifications**: Mako
- **Screen Locker**: Swaylock
- **Theme**: Capstan Cloud color palette

## Included Configs

### Window Manager & Desktop
- **Sway** (`~/.config/sway/config`) - Tiling Wayland compositor
- **Waybar** (`~/.config/waybar/`) - Status bar with system info
- **Mako** (`~/.config/mako/config`) - Notification daemon
- **Swaylock** (`~/.config/swaylock/config`) - Screen locker
- **Ghostty** (`~/.config/ghostty/config`) - Terminal emulator with Capstan OpenCode theme

### Utility Scripts (`~/.local/bin/`)
- **bright** - Screen brightness control with fine-grained low-end steps
  - 5% steps above 5% brightness
  - 1% steps below 5% for precise control
  - Press down at 0% to turn off display (DPMS)
  - Press up when off to turn display back on
- **kbright** - Keyboard backlight control (10% steps)
- **vol** - Volume control with notifications (5% steps)

## Key Features

### Brightness Control
The brightness script has been customized for better low-light control:
- **100% → 5%**: 5% increments (normal adjustment)
- **5% → 0%**: 1% increments (fine-grained control)
- **0% + down**: Display power off via DPMS
- **Off + up**: Display power on

### Idle Management
Automatic power saving timeline:
- **4.5 min**: Dim to 10% (warning)
- **5 min**: Lock screen
- **5.5 min**: Display off (DPMS)
- **15 min**: System suspend

### Theme
All components use the Capstan color palette for a cohesive look:
- **Capstan Cloud**: Used for Sway, Waybar, Mako (lighter, UI-focused)
- **Capstan OpenCode**: Used for Ghostty terminal (darker background: `#0f0e0d` for reduced eye strain)

## Installation

```bash
cd ~/dotfiles
./install.sh shared asahi
```

## Hardware Notes

- Uses `apple-panel-bl` for display backlight (range: 0-500)
- Uses `kbd_backlight` for keyboard backlight (range: 0-255)
- Brightness controls mapped to F1/F2 (XF86MonBrightness{Down,Up})
- Keyboard backlight mapped to F5/F6 (XF86KbdBrightness{Down,Up})

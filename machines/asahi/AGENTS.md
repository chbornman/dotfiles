# Asahi Linux Setup

Fedora running on Apple Silicon (Asahi Linux) with Hyprland as the Wayland compositor.

## Dotfiles

All configs live in `~/dotfiles/machines/asahi/` and are symlinked to their respective locations.

## Key Configs

- **Hyprland**: `~/.config/hypr/hyprland.conf` - window manager config, keybindings, window rules
- **Waybar**: `~/.config/waybar/config` and `style.css` - status bar
- **Wofi**: `~/.config/wofi/config` and `style.css` - app launcher (centered, rounded corners)
- **Ghostty**: `~/.config/ghostty/config` - terminal emulator
- **Mako**: `~/.config/mako/config` - notifications

## Waybar Setup

The waybar uses a custom event-driven module system with hover menus.

### Module Pattern

Custom modules use loop scripts that output JSON and respond to pin state changes:

```
~/.local/bin/waybar-<name>-loop    # Outputs JSON, watches for state changes via inotifywait
~/.local/bin/<name>-terminal-menu  # Opens floating terminal menu on hover
~/.local/bin/waybar-menu-pin       # Toggles pinned state on click
~/.local/bin/waybar-menu-close     # Closes menus on hover-leave (unless pinned)
```

### Pin State

- `/tmp/waybar-menu-pinned` contains the name of the currently pinned module
- Pinned modules get highlighted (gold background) via the `.pinned` CSS class
- Clicking a pinned module closes its menu and removes the pin

### JSON Output Format

```json
{"text":"display text","class":"pinned","alt":"pinned","percentage":100}
```

- `text`: What displays in waybar
- `class`: CSS class for styling (empty or "pinned")
- `alt`/`percentage`: Additional state info

### Adding New Modules

1. Create `~/.local/bin/waybar-<name>-loop` script (copy from existing, e.g., `waybar-localsend-loop`)
2. Add module to `~/.config/waybar/config`:
   ```json
   "custom/<name>": {
       "exec": "~/.local/bin/waybar-<name>-loop",
       "return-type": "json",
       "format": "{}",
       "on-click": "~/.local/bin/<name>-toggle"
   }
   ```
3. Add to modules-left or modules-right array
4. Add CSS styling for `#custom-<name>` and `#custom-<name>.pinned`

### Floating Windows

Non-terminal apps (like LocalSend) need:
- Window rules in hyprland.conf for float/size/position
- A toggle script that checks if window exists, closes or opens accordingly
- The ydotool mouse jiggle trick to prevent hover-leave issues:
  ```bash
  ydotool mousemove -x 1 -y 0
  ydotool mousemove -x -1 -y 0
  ```

## Theme: Capstan Cloud

A dark theme with warm brass/gold accents inspired by vintage nautical instruments. The palette draws from Ant Design's color system for semantic colors.

### Core Colors

| Role | Hex | Usage |
|------|-----|-------|
| **Primary Background** | `#1a1917` | Main UI surfaces, windows, panels |
| **Darker Background** | `#0f0e0d` | Terminal bg, sidebars, headers (recessed areas) |
| **Elevated Background** | `#262422` | Hover states, input fields, raised elements |
| **Hover Background** | `#393634` | Secondary hover, inactive borders |

### Brass/Gold Accent Scale

| Role | Hex | Usage |
|------|-----|-------|
| **Dark Brass** | `#4a3828` | Selected items, active workspace buttons |
| **Dark Brass Hover** | `#5a4535` | Hover on selected items |
| **Primary Brass** | `#d4a366` | Main accent - borders, active states, cursor, progress bars |
| **Light Gold** | `#ffd591` | Bright accent, terminal bright yellow |

### Text Colors

| Role | Hex | Usage |
|------|-----|-------|
| **Primary** | `#f7f7f5` | Main text, headings, foreground |
| **Muted** | `#8c8985` | Secondary text, placeholders, icons, disabled |
| **On Accent** | `#1a1917` | Text on brass/gold backgrounds |

### Semantic Colors (Ant Design)

| Role | Normal | Bright | Usage |
|------|--------|--------|-------|
| **Error/Red** | `#ff4d4f` | `#ff7875` | Critical states, urgent notifications, recording |
| **Warning/Yellow** | `#faad14` | - | Warnings, battery low |
| **Success/Green** | `#95de64` | `#b7eb8f` | Success states, confirmations |
| **Info/Blue** | `#597ef7` | `#85a5ff` | Informational, links |
| **Magenta** | `#b37feb` | `#d3adf7` | Decorative, special states |
| **Cyan** | `#5cdbd3` | `#87e8de` | Decorative, special states |

### Border Colors

- **Active**: `#d4a366` (brass) - focused inputs, active windows
- **Inactive**: `#393634` - unfocused elements, dividers

### Application

When theming new applications, follow this pattern:
- Window/panel backgrounds: `#1a1917`
- Headers/sidebars: `#0f0e0d`
- Hover states: `#262422` (light) or `#393634` (medium)
- Selected items: `#4a3828` background with `#d4a366` accent
- Active/focused borders: `#d4a366`
- Primary text: `#f7f7f5`, secondary: `#8c8985`

### Themed Applications

- Hyprland (window borders)
- Waybar (status bar)
- Wofi (launcher)
- Ghostty (terminal)
- Mako (notifications)
- GTK4/Nautilus (`~/.config/gtk-4.0/gtk.css`)

## Key Bindings

- `$mod` = Super key
- `$mod + Space` = Wofi launcher
- `$mod + Return` = Ghostty terminal
- `$mod + q` = Close window
- `$mod + 1-9` = Switch workspace
- `$mod + Shift + 1-9` = Move window to workspace
- `$mod + h/j/k/l` = Focus navigation (vim-style)
- `$mod + Shift + h/j/k/l` = Move window

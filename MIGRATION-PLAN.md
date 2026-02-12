# Dotfiles Migration Plan: Remove Omarchy, Unify Configs

## Goal
Remove omarchy dependency on margo, unify keybinds and configs between margo (Arch, x86_64, NVIDIA) and asahi (Fedora, ARM, Apple Silicon). Asahi's standalone Hyprland config is the reference standard.

## New Dotfiles Structure

```
~/dotfiles/
├── shared/
│   ├── hypr/
│   │   ├── hyprland.conf          # Shared base (appearance, animations, dwindle, misc, shared env)
│   │   ├── bindings.conf          # Unified keybinds (identical on both machines)
│   │   ├── windows.conf           # Shared window rules (PiP, wofi, waybar menus, ghostty opacity)
│   │   └── hypridle.conf          # Shared idle config (timings, lock/sleep behavior)
│   ├── waybar/
│   │   ├── config                 # Shared waybar module layout (hovermenu-based)
│   │   └── style.css              # Capstan Cloud waybar theme
│   ├── waybar-hovermenu/
│   │   └── config.toml            # Shared hovermenu config (modules, sizes, positions)
│   ├── ghostty/
│   │   └── config                 # Capstan Cloud terminal theme + settings
│   ├── mako/
│   │   └── config                 # Capstan Cloud notification theme
│   ├── wofi/
│   │   ├── config                 # Wofi launcher config
│   │   └── style.css              # Capstan Cloud wofi theme
│   ├── hyprlock/
│   │   └── hyprlock.conf          # Shared lock screen config
│   ├── scripts/
│   │   ├── screenshot             # Shared (grim+slurp, works everywhere)
│   │   ├── screenrecord           # Shared (wf-recorder, works everywhere)
│   │   └── vol                    # Shared (pactl, works everywhere)
│   ├── fish/
│   │   └── config.fish            # Shared fish config
│   ├── starship/
│   │   └── starship.toml          # Capstan Cloud prompt theme
│   ├── nvim/                      # (existing, keep as-is)
│   ├── git/                       # (existing, keep as-is)
│   ├── tmux/                      # (existing, keep as-is)
│   └── claude/                    # (existing, keep as-is)
├── machines/
│   ├── margo/
│   │   ├── hyprland.conf          # Entry point: sources shared + machine.conf + autostart.conf
│   │   ├── machine.conf           # NVIDIA env, monitors, Wacom tablet, input overrides
│   │   ├── autostart.conf         # Margo-specific autostart
│   │   ├── .local/bin/
│   │   │   ├── bright             # Margo brightness script (different backlight device)
│   │   │   └── kbright            # Margo keyboard backlight script
│   │   └── fish-machine.fish      # Margo-specific PATH/env (NVIDIA, Android SDK, etc.)
│   ├── asahi/
│   │   ├── hyprland.conf          # Entry point: sources shared + machine.conf + autostart.conf
│   │   ├── machine.conf           # Monitor, touchpad sensitivity, asahi-specific input
│   │   ├── autostart.conf         # Asahi-specific autostart (ydotool permissions, etc.)
│   │   ├── .local/bin/
│   │   │   ├── bright             # Asahi brightness (apple-panel-bl device)
│   │   │   └── kbright            # Asahi keyboard backlight
│   │   └── fish-machine.fish      # Asahi-specific PATH/env (opencode, bun)
│   └── i3/                        # (keep as-is, untouched)
├── install.sh                     # Updated symlink installer (detects machine by hostname)
└── README.md
```

## Unified Keybinds (shared/hypr/bindings.conf)

Based on asahi config as the standard. App commands use variables ($browser, $obsidian, etc.) set in each machine's machine.conf.

| Key | Action |
|-----|--------|
| `SUPER+Return` | ghostty terminal |
| `SUPER+Space` | wofi --show drun |
| `SUPER+Q` | Close window |
| `SUPER+B` | Browser (zen) |
| `SUPER+SHIFT+B` | Bluetui |
| `SUPER+C` | Google Calendar in browser |
| `SUPER+G` | Gmail in browser |
| `SUPER+F` | File manager (yazi in ghostty) |
| `SUPER+SHIFT+F` | Nautilus |
| `SUPER+O` | Obsidian |
| `SUPER+A` | OpenCode (in ghostty) |
| `SUPER+M` | Mailtui (in ghostty) |
| `SUPER+T` | Telegram |
| `SUPER+Y` | YouTube in browser |
| `SUPER+N` | Nextcloud |
| `SUPER+SHIFT+S` | LocalSend |
| `SUPER+D` | Whisper dictation toggle |
| `SUPER+SHIFT+D` | Whisper dictation stream |
| `SUPER+P / SHIFT+P / ALT+P` | Screenshot area/screen/window |
| `SUPER+R / SHIFT+R / ALT+R` | Screenrecord area/screen/window |
| `SUPER+V` | Paste workaround (wtype) |
| `SUPER+Backspace` | Forward delete |
| `SUPER+H/J/K/L` | Focus (vim-style) |
| `SUPER+Arrow` | Focus (arrow keys) |
| `SUPER+SHIFT+H/J/K/L` | Move window |
| `SUPER+SHIFT+Arrow` | Move window (arrows) |
| `SUPER+\` | Toggle split orientation |
| `SUPER+1-0` | Switch workspace |
| `SUPER+SHIFT+1-0` | Move to workspace |
| `SUPER+SHIFT+M` | Move workspace to other monitor |
| `SUPER+-/=` | Horizontal resize |
| `SUPER+SHIFT+-/=` | Vertical resize |
| `SUPER+I` | Toggle waybar |
| `SUPER+Escape` | Lock screen (hyprlock) |
| `SUPER+SHIFT+C` | Reload config |
| `SUPER+SHIFT+E` | Exit Hyprland |
| `SUPER+F11` / `CTRL+Return` | Fullscreen |
| `SUPER+SHIFT+Space` | Toggle floating |
| Media keys | Volume (vol script) |
| Brightness keys | Brightness (bright script) |
| `SHIFT+Brightness` | Keyboard backlight (kbright) |
| `SUPER+mouse` | Move/resize windows |
| 3-finger swipe | Switch workspace |

## Machine-Specific Variables (set in machine.conf)

### Margo (Arch, native packages)
```
$browser = zen-browser
$obsidian = obsidian
$localsend = localsend
$opencode = /home/caleb/.local/bin/opencode
$mailtui = /home/caleb/.cargo/bin/mailtui
$telegram = telegram-desktop
$nextcloud = nextcloud
```

### Asahi (Fedora, mostly flatpak)
```
$browser = flatpak run app.zen_browser.zen
$obsidian = ~/.local/bin/obsidian
$localsend = flatpak run org.localsend.localsend_app
$opencode = /home/caleb/.local/bin/opencode
$mailtui = /home/caleb/.cargo/bin/mailtui
$telegram = flatpak run org.telegram.desktop -- tg://resolve?domain=claudiusclaudius_bot
$nextcloud = nextcloud
```

## Packages Needed on Margo

Already installed: grim, slurp, wl-clipboard, mako, hyprlock, hypridle, swaybg, ghostty, waybar, hyprland

Need to install:
- `wofi` (pacman)
- `wf-recorder` (pacman)
- `jq` (likely already installed, needed by screenshot script)

Need to build from source:
- `waybar-hovermenu` from https://github.com/chbornman/waybar-hovermenu (cargo build --release)

## Shared Config Details

### Waybar (shared/waybar/)
Uses asahi's hovermenu-based config as the standard. Modules: workspaces, mail, localsend, whisper, screenshot, screenrecord on left; audio, cpu, battery, bluetooth, network, calendar on right. All custom modules use `hovermenu-ctl` for click/hover behavior.

### Waybar-hovermenu (shared/waybar-hovermenu/config.toml)
Based on asahi's config. Modules: audio (pavucontrol), bluetooth (bluetui), network (impala), cpu (btop), battery (powertui), mail (mailtui), calendar (calentui), localsend. Terminal command uses ghostty.

### Ghostty (shared/ghostty/config)
Capstan Cloud color scheme from asahi. Background #0f0e0d, foreground #f7f7f5, brass cursor #d4a366. Font: monospace 11pt. Background opacity 0.9. Margo adds numpad enter mapping and scroll speed overrides in machine-specific section.

### Mako (shared/mako/config)
Capstan Cloud notification theme from asahi. Top-center anchor, brass border, dark background. Screenshot/screenrecord click handlers. 10s default timeout, critical = no timeout.

### Wofi (shared/wofi/)
Centered launcher, 500x400, Capstan Cloud dark theme with brass accent selection.

### Hyprlock (shared/hyprlock/hyprlock.conf)
Pure black background, centered password field, brass border, Capstan Cloud colors.

### Fish (shared/fish/config.fish)
Shared: starship init, Ctrl+Space binding (accept-autosuggestion execute), EDITOR=nvim, zoxide init. Sources machine-specific fish-machine.fish for PATH and env vars.

### Starship (shared/starship/starship.toml)
Capstan Cloud prompt: brass success symbol, muted git branch, compact 2-dir truncation.

### Scripts (shared/scripts/)
- `screenshot`: grim+slurp, area/screen/window modes, copies to clipboard, sends notification
- `screenrecord`: wf-recorder with toggle support, area/screen/window modes
- `vol`: pactl volume control with notification OSD (shared, no hardware-specific bits)

### Machine-Specific Scripts
- `bright`: Separate per machine (asahi uses apple-panel-bl, margo uses different device)
- `kbright`: Separate per machine (different kbd_backlight devices)

## Install Script (install.sh)

Detects machine by hostname. Symlinks:
1. Shared configs → ~/.config/hypr/shared/, ~/.config/waybar/, ~/.config/ghostty/, ~/.config/mako/, ~/.config/wofi/, ~/.config/hypr/hyprlock.conf, ~/.config/starship.toml, ~/.config/waybar-hovermenu/
2. Machine entry point → ~/.config/hypr/hyprland.conf
3. Machine configs → ~/.config/hypr/machine.conf, ~/.config/hypr/autostart.conf
4. Shared scripts → ~/.local/bin/screenshot, ~/.local/bin/screenrecord, ~/.local/bin/vol
5. Machine scripts → ~/.local/bin/bright, ~/.local/bin/kbright
6. Fish config → ~/.config/fish/config.fish (shared), machine fish sourced from it

## Execution Steps

### DONE:
- [x] Create directory structure
- [x] Write shared/hypr/hyprland.conf (appearance, layout, env)
- [x] Write shared/hypr/bindings.conf (unified keybinds)
- [x] Write shared/hypr/windows.conf (window rules)
- [x] Write shared/hypr/hypridle.conf (idle behavior)

### TODO:
- [ ] Write shared/waybar/config (hovermenu-based waybar)
- [ ] Write shared/waybar/style.css (Capstan Cloud waybar theme)
- [ ] Write shared/waybar-hovermenu/config.toml
- [ ] Write shared/ghostty/config (Capstan Cloud terminal)
- [ ] Write shared/mako/config (notifications)
- [ ] Write shared/wofi/config and style.css
- [ ] Write shared/hyprlock/hyprlock.conf
- [ ] Write shared/starship/starship.toml
- [ ] Write shared/fish/config.fish
- [ ] Write shared/scripts/screenshot
- [ ] Write shared/scripts/screenrecord
- [ ] Write shared/scripts/vol
- [ ] Write machines/margo/hyprland.conf (entry point)
- [ ] Write machines/margo/machine.conf (NVIDIA, monitors, Wacom, app variables)
- [ ] Write machines/margo/autostart.conf
- [ ] Write machines/margo/.local/bin/bright
- [ ] Write machines/margo/.local/bin/kbright
- [ ] Write machines/margo/fish-machine.fish
- [ ] Write machines/asahi/hyprland.conf (entry point)
- [ ] Write machines/asahi/machine.conf (touchpad, input, app variables)
- [ ] Write machines/asahi/autostart.conf
- [ ] Write machines/asahi/.local/bin/bright (already exists in dotfiles)
- [ ] Write machines/asahi/.local/bin/kbright (already exists in dotfiles)
- [ ] Write machines/asahi/fish-machine.fish
- [ ] Update install.sh
- [ ] Install missing packages on margo (wofi, wf-recorder)
- [ ] Clone and build waybar-hovermenu for x86_64
- [ ] Run install script on margo
- [ ] Test: reload Hyprland, verify keybinds, waybar, wofi, screenshots
- [ ] Remove omarchy packages: pacman -R aether omarchy-chromium omarchy-keyring omarchy-nvim omarchy-walker
- [ ] Remove ~/.local/share/omarchy/ and ~/.config/omarchy/ and ~/.config/walker/
- [ ] Clean omarchy repo from /etc/pacman.conf

## Omarchy Removal (final step, after everything works)

1. Remove omarchy repo from /etc/pacman.conf
2. `sudo pacman -R aether omarchy-chromium omarchy-keyring omarchy-nvim omarchy-walker`
3. `rm -rf ~/.local/share/omarchy/`
4. `rm -rf ~/.config/omarchy/`
5. `rm -rf ~/.config/walker/`
6. Remove OMARCHY_PATH from fish config
7. Remove omarchy bin from PATH

# Asahi Audio Troubleshooting

MacBook Pro J316 speakers on Asahi Linux use a safety-critical DSP pipeline:
`PipeWire → j316-convolver (filter chain) → ALSA → speakersafetyd`

## Symptoms of a Crashed Audio Stack

- YouTube/browser plays video but no sound comes out
- `pw-play` hangs or times out
- Journal shows: `spa.alsa: hw:AppleJ316,0p: snd_pcm_avail after recover: Broken pipe`
- `wpctl status` shows no browser streams, or streams stuck without output

## Quick Fix

### 1. Restart PipeWire

```bash
systemctl --user restart pipewire wireplumber pipewire-pulse
```

### 2. Reconnect Browser Audio

After restarting PipeWire, the browser (Zen) loses its PipeWire connection.
**Pause and play** the video/audio in the browser tab — this forces it to reconnect.

If that doesn't work, reload the tab or restart the browser.

### 3. Verify

```bash
# Should complete instantly with a bell sound
pw-play /usr/share/sounds/freedesktop/stereo/bell.oga

# Should show browser stream and convolver filter chain
wpctl status
```

## What NOT to Do

- **Never** adjust raw ALSA speaker volumes directly
- **Never** touch internal filter chain node volumes (the j316-convolver pipeline)
- **Never** disable or stop `speakersafetyd` — it protects the speakers from hardware damage
- **Never** delete `/etc/wireplumber/wireplumber.conf.d/51-disable-suspend.conf` — ALSA suspend causes reconnect issues on this hardware

## If Restart Doesn't Fix It

Check if WirePlumber state got corrupted again:

```bash
# Back up and nuke WirePlumber state
cp -r ~/.local/state/wireplumber ~/.local/state/wireplumber.bak-$(date +%s)
rm -f ~/.local/state/wireplumber/stream-properties
rm -f ~/.local/state/wireplumber/default-nodes
rm -f ~/.local/state/wireplumber/default-routes

# Full restart
systemctl --user restart pipewire wireplumber pipewire-pulse
```

## Key Components

| Component | Purpose |
|-----------|---------|
| `pipewire` | Audio server |
| `wireplumber` | Session manager (policy, routing, state) |
| `pipewire-pulse` | PulseAudio compatibility layer |
| `speakersafetyd` | Speaker safety daemon (system service) |
| `j316-convolver` | DSP filter chain for speaker EQ/limiting |
| `asahi-limit-volume.lua` | WirePlumber script that caps volume for safety |
| `~/.local/bin/vol` | Volume script (direct 0-100%, capped at 100%) |

## Root Cause History

The original audio breakage was caused by **wiremix** (a PipeWire mixer GUI) crushing
internal DSP filter chain volumes to near-zero. WirePlumber persisted these broken values
in `~/.local/state/wireplumber/stream-properties`. wiremix has been uninstalled and
replaced with **pavucontrol**. Subsequent crashes have been transient ALSA PCM "Broken pipe"
errors that resolve with a PipeWire restart.

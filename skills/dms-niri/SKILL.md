---
description: >
  Configure, install, or troubleshoot DankMaterialShell with niri, omarchy, or Hyprland.
  Triggers: "setup DMS", "configure niri", "DMS won't start", "niri config help",
  "DMS cache issue", "DMS version mismatch".
---

# DMS + niri Setup & Troubleshooting

## Quick Start

1. Install DMS via `curl -fsSL https://install.danklinux.com | sh`
2. Run `dms setup` to deploy default configs
3. Add includes to `~/.config/niri/config.kdl`:
   ```kdl
   include "dms/colors.kdl"
   include "dms/layout.kdl"
   include "dms/alttab.kdl"
   include "dms/binds.kdl"
   ```
4. Enable systemd service: `systemctl --user enable --now dms`

## niri Integration

### Config Structure

- `~/.config/niri/config.kdl` — main config
- `~/.config/niri/dms/` — DMS sub-configs (binds, colors, layout, alttab)
- `dms setup` writes these files if they're empty

### Key Bindings

```kdl
binds {
    Mod+Space { spawn "dms" "ipc" "call" "spotlight" "toggle" }
    Mod+V { spawn "dms" "ipc" "call" "clipboard" "toggle" }
    Mod+M { spawn "dms" "ipc" "call" "processlist" "focusOrToggle" }
    Mod+Comma { spawn "dms" "ipc" "call" "settings" "focusOrToggle" }
}
```

### Layer Rules

```kdl
layer-rule {
    match namespace="^quickshell$"
    place-within-backdrop true
}
```

## Omarchy Integration

### Config Structure
- `~/.config/omarchy/config.kdl` — main config
- `~/.config/omarchy/dms/` — DMS sub-configs

### Setup
```kdl
include "dms/colors.kdl"
include "dms/layout.kdl"
include "dms/binds.kdl"
```

### Key Bindings
```kdl
binds {
    Mod+Space { spawn "dms" "ipc" "call" "spotlight" "toggle" }
    Mod+V { spawn "dms" "ipc" "call" "clipboard" "toggle" }
}
```

## Hyprland Integration

### Config Structure
- `~/.config/hypr/hyprland.conf` — main config
- `~/.config/hypr/dms/` — DMS sub-configs

### Setup
```
source = ~/.config/hypr/dms/colors.conf
source = ~/.config/hypr/dms/layout.conf
source = ~/.config/hypr/dms/binds.conf
```

### Key Bindings
```
bind = SUPER, Space, exec, dms ipc call spotlight toggle
bind = SUPER, V, exec, dms ipc call clipboard toggle
bind = SUPER, M, exec, dms ipc call processlist focusOrToggle
```

## DMS Commands

| Command | Description |
|---------|-------------|
| `dms run` | Launch (foreground) |
| `dms run -d` | Launch as daemon |
| `dms restart` | Restart shell |
| `dms kill` | Kill shell |
| `dms doctor` | Diagnose installation |
| `dms version` | Show version |
| `dms setup` | Deploy default configs |
| `dms setup binds` | Deploy keybinds only |

## Env Vars (DMS_*)

- `DMS_SOCKET` — custom IPC socket path
- `DMS_DISABLE_MATUGEN` — disable dynamic theming
- `DMS_DISABLE_CAVA` — disable audio visualizer
- `DMS_DISABLE_LAYER` — disable layer effects
- `DMS_DANKBAR_LAYER` — bar layer (bottom/overlay/background/top)
- `DMS_POPOUT_LAYER` — popout layer
- `DMS_MODAL_LAYER` — modal layer
- `DMS_OSD_LAYER` — OSD layer (overlay default)
- `DMS_NOTIFICATION_LAYER` — notification layer
- `DMS_DISABLE_POLKIT` — disable polkit integration
- `DMS_PREFERRED_BATTERY` — force battery device
- `DMS_RUN_GREETER` — greeter mode
- `DMS_GREET_CFG_DIR` — greeter config dir

## Troubleshooting

### Version Mismatch
- CLI: `/usr/bin/dms` (Go binary)
- UI: `/usr/share/quickshell/dms/VERSION` (QML source)
- Fix: copy both binary AND QML source from release assets

### Cache Issues
```bash
rm -rf ~/.cache/dms/* ~/.cache/quickshell/qmlcache
pkill dms
dms restart
```

### Double Launch
- If using systemd, remove `dms run` from compositor config
- If using manual, disable systemd: `systemctl --user disable --now dms`

### QML Source Update (v1.5+)
```bash
curl -sL "https://github.com/AvengeMedia/DankMaterialShell/releases/download/v1.5.0/dms-qml.tar.gz" -o /tmp/dms-qml.tar.gz
tar xzf /tmp/dms-qml.tar.gz -C /tmp/dms-qml --no-same-permissions
sudo cp -r /tmp/dms-qml/* /usr/share/quickshell/dms/
```

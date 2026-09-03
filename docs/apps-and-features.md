# Apps and Features Inventory

This is a pruning checklist for the current NixOS/Home Manager setup.

Legend:
- `Keep`: still clearly part of the configured workflow.
- `Review`: installed/enabled, but worth checking whether you still use it.
- `Host`: only applies to a specific host.

## Hosts

| Item | Status | Notes |
| --- | --- | --- |
| `laptop` | Keep | Dell Precision 5570 hardware module, GRUB EFI boot, mobile power services, IOLab udev rules. |
| `desktop` | Keep | GRUB boot, workstation desktop stack, TLP enabled, `power-profiles-daemon` disabled. |

## System Features

| Item | Status | Notes |
| --- | --- | --- |
| Nix flakes and `nix-ld` | Keep | Enables flakes, `nix-command`, store optimisation, weekly GC, and generic Linux toolchain compatibility. |
| NetworkManager | Keep | Main network stack. |
| Avahi/mDNS | Review | Useful for `.local` devices such as printers; remove if you do not use local discovery. |
| PipeWire | Keep | ALSA, PulseAudio compatibility, WirePlumber, and RTKit. |
| Hyprland | Keep | Wayland compositor and session. |
| DMS greeter/shell | Keep | Login greeter and shell services tied to Hyprland. |
| XDG portals | Keep | Hyprland and GTK portals for desktop integration. |
| Bluetooth/Blueman | Review | Keep if you use Bluetooth devices. |
| GVfs/Nautilus integration | Keep | File manager and mount integration. |
| Printing | Review | Brother and HP IPP queues are configured; remove if no longer needed. |
| Tailscale | Review | Enabled by default on workstation hosts. |
| Docker | Review | Enabled and starts on boot. |
| Firmware updates | Keep | `fwupd` enabled. |
| Fonts | Keep | Noto, Font Awesome, JetBrainsMono Nerd Font, Symbols Nerd Font. |

## System Packages

| Package | Status | Notes |
| --- | --- | --- |
| `vim`, `git` | Keep | Base tools. |
| `usbutils`, `pciutils`, `lm_sensors`, `lshw`, `smartmontools`, `parted`, `hdparm` | Review | Hardware/debug tools; prune any you do not use. |
| `bluez` | Keep | Bluetooth stack. |

## Home CLI Tools

| Package | Status | Notes |
| --- | --- | --- |
| `curl`, `wget`, `jq`, `ripgrep`, `fd`, `bat`, `eza`, `unzip`, `zip`, `tree` | Keep | General CLI tools. |
| `gum`, `glow`, `comma`, `pdfgrep`, `yt-dlp` | Review | Nice-to-have utilities; good pruning candidates if unused. |
| `btop`, `htop` | Review | Two process monitors; consider keeping one. |
| `kubectl`, `kubeseal`, `teleport`, `glab` | Review | DevOps/GitLab tools; remove if not used recently. |
| `python3`, `platformio-core`, `openocd`, `avrdude` | Keep | Embedded/PlatformIO workflow. |

## Desktop Apps

| App | Status | Notes |
| --- | --- | --- |
| Firefox, Google Chrome | Review | Two browsers; consider whether both are needed. |
| VS Code | Keep | PlatformIO and MATLAB integration configured. |
| Signal Desktop | Review | Messaging. |
| Discord | Review | Messaging/voice. |
| Spotify | Review | Music. |
| Nautilus | Keep | Default directory opener. |
| OneDrive | Review | Sync client; remove if unused. |
| draw.io | Review | Diagramming. |
| Surfer | Review | Installed desktop app; verify current use. |
| KiCad, Fritzing | Review | Electronics/CAD tools. |
| GThumb | Review | Image viewer/organizer. |
| Mixxx | Review | DJ/audio app; also used for laptop udev package. |
| MATLAB | Keep | Custom FHS package and VS Code MATLAB extension. |

## Wayland and Session Tools

| Package/Feature | Status | Notes |
| --- | --- | --- |
| `foot` | Keep | Terminal, server mode enabled, config in `rsc/foot.ini`. |
| `wl-clipboard`, `grim`, `slurp`, `swappy`, `wtype` | Keep | Clipboard, screenshots, annotation, typing automation. |
| `brightnessctl`, `playerctl`, `pulseaudio` | Keep | Bound in Hyprland for brightness/media/audio controls. |
| `hypridle` | Keep | Started from Hyprland `exec-once`. |
| Wallpaper service | Keep | Uses `rsc/background.jpg`. |
| Polkit GNOME, udiskie, GNOME keyring | Keep | Session auth, removable media, secrets. |

## Audio Tools

| Package/Feature | Status | Notes |
| --- | --- | --- |
| EasyEffects | Keep | Session service enabled. |
| `lsp-plugins`, `calf` | Review | Audio plugin collections; remove if not used in EasyEffects or DAW work. |

## Home Programs and Settings

| Item | Status | Notes |
| --- | --- | --- |
| Zsh, oh-my-zsh, Starship | Keep | Default shell for `raskil`, configured like `nixos-dendritic-config`. |
| Git | Keep | User `RKildegaard <rasmuskildegaard20@gmail.com>`. |
| GitHub CLI | Keep | Credential helper enabled. |
| Direnv and nix-direnv | Keep | Development shell workflow, with zsh integration enabled. |
| GTK/QT dark theme | Keep | Adwaita dark, Adwaita icons, Bibata cursor. |
| XDG MIME defaults | Keep | Directories open in Nautilus. |
| `template-menu` script | Review | Installed from `rsc/template-menu`; remove if not used. |
## Pruning Shortlist

Good first candidates to review:

- Duplicate/overlapping tools: `btop` vs `htop`, Firefox vs Chrome.
- Specialty desktop apps: `surfer`, `fritzing`, `mixxx`, `drawio`, `gthumb`.
- Service-style apps: `onedrive`, `tailscale`, Docker-on-boot.
- DevOps tools: `kubectl`, `kubeseal`, `teleport`, `glab`.
- Audio plugin bundles: `lsp-plugins`, `calf`.

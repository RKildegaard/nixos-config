# NixOS Config

This repo is split into a few simple parts.

- `flake.nix`
  Main entry point. This is what builds the systems.

- `hosts/`
  One folder per machine.
  `hosts/common/` is shared system setup.
  `hosts/laptop/` and `hosts/desktop/` are machine-specific.

- `modules/nixos/`
  Shared NixOS modules.
  This is where system settings are split into smaller files.

- `profiles/`
  Reusable groups of settings.
  These are imported by hosts when needed.

- `home/raskil/`
  Home Manager config for the user `raskil`.

- `home/raskil/common/`
  Shared user defaults.

- `home/raskil/packages/`
  User packages.

- `home/raskil/programs/`
  Program setup like git, foot, vscode, theme, and scripts.

- `home/raskil/services/`
  User services.

- `home/raskil/desktop/`
  Desktop setup.
  Hyprland config lives here.

- `home/raskil/hosts/`
  User settings that change per machine.
  Right now this is mainly monitor setup.


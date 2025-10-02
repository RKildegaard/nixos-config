{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/common.nix
    ../../modules/system/locale.nix
    ../../modules/system/users.nix
    ../../modules/system/packages.nix
    ../../modules/system/devtools.nix
    ../../modules/system/greetd.nix
    ../../modules/system/wayland-hyprland.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.tlp.enable = true;

  # NVIDIA or AMD specific stuff would live here (not in common modules).
}


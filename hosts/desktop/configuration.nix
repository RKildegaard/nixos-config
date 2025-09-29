{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/greetd.nix
  ];

  networking.hostName = "desktop";
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";  # adjust if needed
    useOSProber = true;
  };

  # Desktop-specific (example)
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = false;
}


{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/greetd.nix
  ];

  networking.hostName = "laptop";
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";  # adjust if needed
    useOSProber = true;
  };

  # Laptop-specific QoL
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;
  services.tlp.enable = true;  # power saving
}


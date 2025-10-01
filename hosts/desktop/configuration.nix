{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/greetd.nix
  ];

  networking.hostName = "desktop";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
  };
  
  services.blueman.enable = true;
  services.tlp.enable = true; 
}


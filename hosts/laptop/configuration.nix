{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/greetd.nix
  ];

  networking.hostName = "laptop";
  boot.loader.grub = {
    	enable = true;
    	device = "nodev";
	efiSupport = true;
  };
 
  boot.loader.efi = {
	canTouchEfiVariables = true;
	efiSysMountPoint = "/boot/efi";
  };  
 
  services.blueman.enable = true;
  services.tlp.enable = false;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
}


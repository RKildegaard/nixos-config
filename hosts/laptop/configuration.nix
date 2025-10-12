{ config, lib, pkgs, nixos-hardware, ... }:

{
  imports = [
    ./hardware-configuration.nix
    

    nixos-hardware.nixosModules.dell-precision-5570

    ../../modules/system/common.nix
    ../../modules/system/locale.nix
    ../../modules/system/users.nix
    ../../modules/system/packages.nix
    ../../modules/system/devtools.nix
    ../../modules/system/greetd.nix
    ../../modules/system/wayland-hyprland.nix
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
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.twingate.enable = lib.mkDefault true;

  system.stateVersion = "25.05";
}


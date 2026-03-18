{ config, pkgs, lib, ... }:

{
  boot.tmp.cleanOnBoot = true;
  powerManagement.enable = true;

  # CPU
  hardware.cpu = {
    intel.updateMicrocode = lib.mkDefault true;
    amd.updateMicrocode = lib.mkDefault true;
  };

  # GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.printing.enable = lib.mkDefault false;
  hardware.sane.enable = lib.mkDefault false;
  security.polkit.enable = true;
  services.dbus.implementation = lib.mkForce "dbus";
  services.fwupd.enable = true;
}

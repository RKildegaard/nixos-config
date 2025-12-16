{ lib, pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services.gnome.gnome-settings-daemon.enable = true;
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  services.blueman.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint hplip ];
  };

  services.twingate.enable = lib.mkDefault true;
}

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
  services.udev.packages = [
    pkgs.gnome-settings-daemon
    (pkgs.writeTextFile {
      name = "kvmfr";
      text = ''
        SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/70-kvmfr.rules";
    })
  ];
  services.blueman.enable = true;
  services.gvfs.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint hplip ];
  };

  services.tailscale.enable = lib.mkDefault true;
}

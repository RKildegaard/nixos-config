{
  flake.modules.nixos.packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      vim
      git
      usbutils
      pciutils
      lm_sensors
      bluez
      lshw
      smartmontools
      parted
      hdparm
    ];
  };
}

{ nixos-hardware, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    nixos-hardware.nixosModules.dell-precision-5570
    ../../profiles/workstations/graphical.nix
    ../../profiles/workstations/mobile.nix
  ];

  networking.hostName = "laptop";

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  services.udev.extraRules = ''
    # IOLab CDC-ACM serial port
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1881", ATTRS{idProduct}=="0400", \
      MODE="0664", GROUP="dialout", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"

    # Also tag the USB interface so ModemManager ignores the parent
    SUBSYSTEM=="usb", ATTR{idVendor}=="1881", ATTR{idProduct}=="0400", \
      ENV{ID_MM_DEVICE_IGNORE}="1"
  '';

  system.stateVersion = "25.05";
}

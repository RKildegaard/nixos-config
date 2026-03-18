{ ... }:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ../../profiles/workstations/graphical.nix
  ];

  networking.hostName = "desktop";

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
  };

  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false;

  system.stateVersion = "25.05";
}

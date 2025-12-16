{ ... }:
{
  imports = [
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

  system.stateVersion = "25.05";
}

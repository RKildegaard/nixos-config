{ lib, ... }:

{
  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}

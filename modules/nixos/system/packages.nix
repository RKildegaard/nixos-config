{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lshw
    smartmontools
    parted
    wineWowPackages.stable
    winetricks
    hdparm
  ];
}


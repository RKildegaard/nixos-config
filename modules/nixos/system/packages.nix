{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lshw
    smartmontools
    parted
    hdparm
  ];
}


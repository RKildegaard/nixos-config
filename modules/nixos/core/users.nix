{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  users.users.raskil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "docker" "dialout" "kvm" "libvirtd" ];
    shell = pkgs.bashInteractive;
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = lib.mkDefault true;
}

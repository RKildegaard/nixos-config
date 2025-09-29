{ pkgs, ... }:
{
  users.users.raskil = {
    isNormalUser = true;
    description = "Rasmus Kildegaard";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
}


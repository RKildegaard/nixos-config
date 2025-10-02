{ config, pkgs, lib, ... }:

{

  imports = [
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./hyprland.nix
    ./waybar.nix
    ./mako.nix
  ];

  home.stateVersion = "24.11";

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 20;
    gtk.enable = true;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.configFile."wofi/scale-manager.css".source = ./files/wofi/scale-manager.css;

  xdg.userDirs.enable = true;

  programs.bash.enable = true;
}


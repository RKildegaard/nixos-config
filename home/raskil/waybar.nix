{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
  };

  xdg.configFile."waybar/config".source = ./files/waybar/config;
  xdg.configFile."waybar/style.css".source = ./files/waybar/style.css;
}


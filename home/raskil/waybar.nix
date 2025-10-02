{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    # If you prefer HM-inline JSON:
    # settings = [ { ... } ];
    # style = '' ... '';

    # We’ll link your existing files instead:
  };

  xdg.configFile."waybar/config".source = ./files/waybar/config;
  xdg.configFile."waybar/style.css".source = ./files/waybar/style.css;
}


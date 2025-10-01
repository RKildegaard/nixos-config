{ pkgs, lib, ... }:
{
  # Hyprland + XWayland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

}


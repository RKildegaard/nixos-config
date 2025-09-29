{ pkgs, lib, ... }:
{
  # No X11
  services.xserver.enable = lib.mkForce false;

  # Hyprland + XWayland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

}


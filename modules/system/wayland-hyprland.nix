{ config, pkgs, lib, ... }:

{
  # No Xorg display manager; greetd + Wayland only
  services.xserver.enable = false;

  # Hyprland packages + session file
  programs.hyprland = {
    enable = true;
    # package = pkgs.hyprland; # (pin here if desired)
    xwayland.enable = true;
  };

  # Portals: prioritize hyprland, then gtk
  xdg.portal = {
    enable = true;
    # Using the hyprland portal + gtk portal avoids electron/firefox issues
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = [ "hyprland" "gtk" ];
  };

  # Input methods, if you need them (commented by default)
  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk fcitx5-configtool ];
  # };

  # Video accel for Wayland (generic; specific GPUs can extend in hosts/*)
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Seat management for pure Wayland TTY login flows
  services.seatd.enable = true;

  # Env that only makes sense for Wayland/Hyprland — keep it here instead of HM
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_NO_HARDWARE_CURSORS = "1"; # helps some iGPU/NVIDIA combos; remove if not needed
  };
}


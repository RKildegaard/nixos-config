{ config, lib, pkgs, ... }:

let
  hyprlandSession = pkgs.runCommand "hyprland-session-only" {
    passthru.providedSessions = [ "hyprland" ];
  } ''
    mkdir -p "$out/share/wayland-sessions"
    cp ${config.programs.hyprland.package}/share/wayland-sessions/hyprland.desktop \
      "$out/share/wayland-sessions/"
  '';
in

{
  services.xserver.enable = false;

  programs.hyprland = {
    enable = true;
    withUWSM = false;
    xwayland.enable = true;
  };

  programs.dms-shell = {
    enable = true;
    systemd.target = "hyprland-session.target";
  };

  services.displayManager = {
    defaultSession = "hyprland";
    sessionPackages = lib.mkForce [ hyprlandSession ];
  };

  services.seatd.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}

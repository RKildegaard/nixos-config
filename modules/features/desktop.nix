{
  flake.modules.nixos.desktop = {config, lib, pkgs, ...}: let
    hyprlandSession = pkgs.runCommand "hyprland-session-only" {
      passthru.providedSessions = ["hyprland"];
    } ''
      mkdir -p "$out/share/wayland-sessions"
      cp ${config.programs.hyprland.package}/share/wayland-sessions/hyprland.desktop \
        "$out/share/wayland-sessions/"
    '';
  in {
    services = {
      xserver.enable = false;
      seatd.enable = true;

      displayManager = {
        defaultSession = "hyprland";
        sessionPackages = lib.mkForce [hyprlandSession];

        dms-greeter = {
          enable = true;
          compositor.name = "hyprland";
          configHome = "/home/raskil";
        };
      };
    };

    programs = {
      hyprland = {
        enable = true;
        withUWSM = false;
        xwayland.enable = true;
      };

      dms-shell = {
        enable = true;
        systemd.target = "hyprland-session.target";
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = [
        "hyprland"
        "gtk"
      ];
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}

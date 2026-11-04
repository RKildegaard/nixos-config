{inputs, ...}: {
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

        dux-greeter = {
          enable = true;
          compositor.name = "hyprland";
          configHome = "/home/raskil";
        };
      };
    };

    programs = {
      appimage = {
        enable = true;
        binfmt = true;
      };

      hyprland = {
        enable = true;
        withUWSM = false;
        xwayland.enable = true;
      };

      dux-shell = {
        enable = true;
        systemd.target = "hyprland-session.target";
        plugins.quickCapture = {
          enable = true;
          src = inputs.quickCapture + "/quickCapture";
        };
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
      # DMS owns the active Hyprland Lua configuration and leaves kb_layout
      # empty, so make the inherited XKB layout explicit.
      XKB_DEFAULT_LAYOUT = "dk";
      XKB_DEFAULT_VARIANT = "";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
      HYPRCURSOR_THEME = "Bibata-Modern-Ice";
      HYPRCURSOR_SIZE = "24";
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}

{ config, pkgs, lib, ... }:
let
  bg = "${config.xdg.configHome}/hypr/background.jpg";
in
{
  # Applet/agents — use HM services instead of exec-once
  services.polkit-gnome.enable = true;
  services.udiskie.enable = true;
  services.network-manager-applet.enable = true;

  # Notifications
  services.mako.enable = true;

  # Wallpaper daemon (replaces manual hyprpaper exec)
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      preload = [ bg ];
      wallpaper = [ ",${bg}" ];  # default on all monitors
    };
  };

  # Ensure wallpaper file is deployed
  xdg.configFile."hypr/background.jpg".source = ./files/hypr/background.jpg;

  # Clipboard history watcher (wl-paste -> cliphist) as a user service
  systemd.user.services."cliphist-store" = {
    Unit = {
      Description = "wl-paste watcher that stores clipboard to cliphist";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}


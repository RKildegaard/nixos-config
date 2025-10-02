{ config, pkgs, lib, ... }:
let
  bg = "${config.xdg.configHome}/hypr/background.jpg";
in
{
  services.polkit-gnome.enable = true;
  services.udiskie.enable = true;
  services.network-manager-applet.enable = true;

  services.mako.enable = true;

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      preload = [ bg ];
      wallpaper = [ ",${bg}" ];  # default on all monitors
    };
  };

  xdg.configFile."hypr/background.jpg".source = ./files/hypr/background.jpg;

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


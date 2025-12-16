{ config, pkgs, ... }:
let
  bg = "${config.xdg.configHome}/hypr/background.jpg";
in
{
  services.polkit-gnome.enable = true;
  services.udiskie.enable = true;
  services.gnome-keyring.enable = true;
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      preload = [ bg ];
      wallpaper = [ ",${bg}" ];  # default on all monitors
    };
  };

  xdg.configFile."hypr/background.jpg".source = ../files/hypr/background.jpg;

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

  systemd.user.services."gnome-settings-daemon" = {
    Unit = {
      Description = "GNOME Settings Daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.gnome-settings-daemon}/libexec/gnome-settings-daemon";
      Restart = "on-failure";
      Environment = [
        "XDG_CURRENT_DESKTOP=GNOME"
        "GNOME_SHELL_SESSION_MODE=gnome"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.easyeffects = {
    Unit = {
      Description = "EasyEffects session service";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      Restart = "on-failure";
      Environment = [
        "PIPEWIRE_QUANTUM=128/48000"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

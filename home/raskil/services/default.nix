{ lib, pkgs, ... }:
let
  waitForHyprland = "${pkgs.bash}/bin/bash -lc 'i=0; while [ \"$i\" -lt 50 ]; do if [ -n \"$WAYLAND_DISPLAY\" ] && [ -S \"$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY\" ] && ${pkgs.hyprland}/bin/hyprctl monitors >/dev/null 2>&1; then exit 0; fi; i=$((i + 1)); ${pkgs.coreutils}/bin/sleep 0.2; done; echo \"Hyprland is not ready for DMS\" >&2; exit 1'";
in
{
  services.polkit-gnome.enable = true;
  services.udiskie.enable = true;
  services.gnome-keyring.enable = true;

  xdg.configFile."systemd/user/dms.service.d/override.conf".text = ''
    [Unit]
    After=hyprland-session.target
    After=wallpaper.service
    Wants=wallpaper.service

    [Service]
    ExecStartPre=
    ExecStartPre=${waitForHyprland}
    RestartSec=3
  '';

  systemd.user.services.easyeffects = {
    Unit = {
      Description = "EasyEffects session service";
      After = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      Restart = "on-failure";
      Environment = [
        "PIPEWIRE_QUANTUM=128/48000"
      ];
    };
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };
}

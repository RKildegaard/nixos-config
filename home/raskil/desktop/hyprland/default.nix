{ config, pkgs, ... }:
let
  bg = "${config.xdg.configHome}/hypr/background.jpg";
in
{
  xdg.configFile."hypr/background.jpg".source = ./background.jpg;

  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Desktop wallpaper";
      After = [ "hyprland-session.target" ];
      PartOf = [ "hyprland-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${bg} -m fill";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      input = {
        kb_layout = "dk";
        follow_mouse = 1;

        accel_profile = "adaptive";
        force_no_accel = 0;
        sensitivity = 0.0;

        touchpad = {
          natural_scroll = true;
          "tap-to-click" = true;
          disable_while_typing = true;
        };
      };


      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "rgba(ff6600ee) rgba(0080ffee) 45deg";
        "col.inactive_border" = "rgba(2a3366aa)";
        layout = "dwindle";
      };


      decoration = {
        rounding = 0;

        blur = {
          enabled = true;
          size = 6;
          passes = 2;
        };

        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = "rgba(0080ff22)";
        };
      };


      animations = {
        enabled = true;
        bezier = [
          "ease,0.05,0.9,0.1,1.0"
        ];
        animation = [
          "windows, 1, 7, ease, slide"
          "border, 1, 10, ease"
          "fade, 1, 7, ease"
          "workspaces, 1, 6, ease, slide"
        ];
      };


      env = [
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "HYPRCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];


      "$mod" = "SUPER";

      bind = [
  
        "$mod, RETURN, exec, foot"
        "$mod, D, exec, dms ipc call spotlight toggle"
        "$mod, C, exec, code"
        "$mod, A, exec, easyeffects -w presets"
        "$mod SHIFT, A, exec, sh -c 'pw-cli set-node-prop ladspa_output.eq node.pause true'"
        "$mod CTRL, A, exec, sh -c 'pw-cli set-node-prop ladspa_output.eq node.pause false'"
        "$mod, Q, killactive"
        "$mod, F, fullscreen, 1"
        "$mod, Space, togglefloating"

  
        "$mod, V, exec, dms ipc call clipboard toggle"

  
        "$mod, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod, SHIFT+S, exec, grim ~/Pictures/$(date +%F_%H-%M-%S).png"

  
        "$mod, B, exec, dms ipc call bar toggle"

  
        "$mod, SHIFT+R, exec, hyprctl reload"
        "$mod, SHIFT+E, exec, hyprctl dispatch exit"
        "$mod, CTRL+L, exec, dms ipc call lock lock"
        "$mod ALT, L, exec, dms ipc call lock lock"

  
        "$mod, ESCAPE, exec, dms ipc call powermenu toggle"

  
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

  
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

  
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

  
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

  
        "$mod, grave, togglespecialworkspace"
        "$mod SHIFT, grave, movetoworkspace, special"
      ];


      bindl = [
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute,        exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioPlay,        exec, playerctl play-pause"
        ", XF86AudioStop,        exec, playerctl stop"

        ", XF86MonBrightnessUp,   exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

  
        ", F3, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", F2, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", F1, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", F4, exec, playerctl play-pause"

        ", F7, exec, brightnessctl set +5%"
        ", F6, exec, brightnessctl set 5%-"
      ];


      exec-once = [
        "hypridle"
      ];
    };
  };
}

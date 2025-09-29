{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";
      env = [
  	"XCURSOR_THEME,Bibata-Modern-Classic"
  	"XCURSOR_SIZE,20"
	"HYPRCURSOR_THEME,Bibata-Modern-Classic"
  	"HYPRCURSOR_SIZE,20"
      ];


      exec-once = [
        "/run/current-system/sw/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
        "nm-applet"
        "blueman-applet"
        "udiskie --tray"
        "mako"
        "hyprpaper"
        "wl-paste --watch cliphist store"
        "waybar"
        # "way-displays --tray"
      ];

      input = {
        kb_layout = "dk";
        follow_mouse = 1;

        accel_profile = "adaptive";
        force_no_accel = 0;
        sensitivity = 0.0;

        touchpad = {
          natural_scroll = false;
          "tap-to-click" = true;
          disable_while_typing = true;
        };
      };

      general = {
        gaps_in = 3;
        gaps_out = 6;
        border_size = 1;
        "col.active_border" = "rgba(33ccffdd)";
        "col.inactive_border" = "rgba(666666aa)";
      };

      decoration = {
        rounding = 0;
        blur = { enabled = false; };
        # shadow = false;   # <- removed to avoid 'decorations:shadow' error
      };

      bind = [
        "SUPER, RETURN, exec, foot"
        "SUPER, D, exec, wofi --show drun"
        "SUPER, C, exec, code"
        "SUPER, Q, killactive"
        "SUPER, F, fullscreen"
        "SUPER, H, movefocus, l"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"
        "SUPER, L, movefocus, r"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
        "SUPER, grave, togglespecialworkspace"
        "SUPER SHIFT, grave, movetoworkspace, special"
        "SUPER, ESCAPE, exec, ~/.local/bin/powermenu"
        "SUPER, B, exec, sh -c 'pkill waybar; waybar &'"
        "SUPER, SHIFT+R, exec, hyprctl reload"
        "SUPER, SHIFT+E, exec, hyprctl dispatch exit"
        "SUPER, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SUPER, SHIFT+S, exec, grim ~/Pictures/$(date +%F_%H-%M-%S).png"
        "SUPER, V, exec, bash -lc 'cliphist list | wofi --dmenu | cliphist decode | wl-copy'"
      ];

      binde = [
        ",XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ",XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ",XF86AudioMute,        exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ",XF86MonBrightnessUp,   exec, brightnessctl set +5%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
    };
  };

  programs.waybar.enable = true;
  programs.foot.enable = true;
  programs.rofi.enable = false;
}


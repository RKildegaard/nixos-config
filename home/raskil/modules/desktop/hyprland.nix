{ pkgs, ... }:
{
  xdg.configFile."hypr/hyprlock.conf".source = ../../files/hyprlock.conf;

  wayland.windowManager.hyprland = {
    enable = true;
    # Use systemd user units for session/autostarts
    systemd.enable = true;

    settings = {
      # --- Monitors (safe default) ---
      monitor = [ ",preferred,auto,1.5" ];

      # --- Input ---
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

      # --- General window look/feel ---
      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "rgba(89b4faee)";
        "col.inactive_border" = "rgba(313244aa)";
        layout = "dwindle";
      };

      # --- Decoration (Hyprland 0.4x style) ---
      decoration = {
        rounding = 8;

        blur = {
          enabled = true;
          size = 6;
          passes = 2;
        };

        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = "rgba(00000066)";
        };
      };

      # --- Animations ---
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

      # --- Env from user scope only if you want to override HM cursor ---
      env = [
        "XCURSOR_SIZE,20"
        "HYPRCURSOR_SIZE,20"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      # --- Keybinds ---
      "$mod" = "SUPER";

      bind = [
        # apps / actions
        "$mod, RETURN, exec, foot"
        "$mod, D, exec, wofi --show drun"
        "$mod, C, exec, code"
        "$mod, A, exec, easyeffects -w presets"
        "$mod SHIFT, A, exec, sh -c 'pw-cli set-node-prop ladspa_output.eq node.pause true'"
        "$mod CTRL, A, exec, sh -c 'pw-cli set-node-prop ladspa_output.eq node.pause false'"
        "$mod, Q, killactive"
        "$mod, F, fullscreen, 1"
        "$mod, Space, togglefloating"

        # clipboard menu (cliphist + wofi)
        "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

        # screenshots
        "$mod, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod, SHIFT+S, exec, grim ~/Pictures/$(date +%F_%H-%M-%S).png"

        # waybar quick restart
        "$mod, B, exec, sh -c 'pkill waybar || true; ${pkgs.waybar}/bin/waybar &'"

        # hypr controls
        "$mod, SHIFT+R, exec, hyprctl reload"
        "$mod, SHIFT+E, exec, hyprctl dispatch exit"
        "$mod, CTRL+L, exec, lockscreen"
        "$mod ALT, L, exec, lockscreen"

        # powermenu (your packaged script)
        "$mod, ESCAPE, exec, powermenu"

        # focus movement
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        # move windows
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        # workspaces 1–10
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

        # move to workspace
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

        # special workspace
        "$mod, grave, togglespecialworkspace"
        "$mod SHIFT, grave, movetoworkspace, special"
      ];

      # media/brightness keys (work even when a window has focus)
      bindl = [
        # XF86 media keys
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute,        exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioPlay,        exec, playerctl play-pause"
        ", XF86AudioStop,        exec, playerctl stop"

        ", XF86MonBrightnessUp,   exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

        # Raw F-keys (for boards mapping brightness/volume to F1–F7)
        ", F3, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", F2, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", F1, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", F4, exec, playerctl play-pause"

        ", F7, exec, brightnessctl set +5%"
        ", F6, exec, brightnessctl set 5%-"
      ];

      # Minimal exec-once: most daemons are managed by HM services
      exec-once = [
        "waybar"
        "hypridle"
      ];
    };
  };
}

{ config, pkgs, lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    # If your system-level `programs.hyprland.enable = true;` is set already,
    # this HM module just handles user config.
    # If you want to pin a package here:
    # package = pkgs.hyprland;

    settings = {
      # --- Monitors (example) ---
      # monitor = [
      #   "eDP-1,1920x1200@60,0x0,1"
      #   "HDMI-A-1,2560x1440@144,1920x0,1"
      # ];

      # --- Inputs ---
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = { natural_scroll = "yes"; tap-to-click = "yes"; };
      };

      # --- General ---
      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "rgba(89b4faee)";
        "col.inactive_border" = "rgba(313244aa)";
        layout = "dwindle";
      };

      # --- Decoration ---
      decoration = {
        rounding = 8;
        blur = { enabled = true; size = 6; passes = 2; };
        drop_shadow = true;
        shadow_range = 20;
      };

      # --- Animations (optional nice defaults) ---
      animations = {
        enabled = true;
        bezier = [
          "ease,0.05,0.9,0.1,1.0"
          "overshot,0.05,0.9,0.1,1.1"
        ];
        animation = [
          "windows, 1, 7, ease, slide"
          "border, 1, 10, ease"
          "fade, 1, 7, ease"
          "workspaces, 1, 6, overshot, slide"
        ];
      };

      # --- Environment (keep here only if not set system-wide) ---
      env = [
        "XCURSOR_SIZE,20"
        "HYPRCURSOR_SIZE,20"
      ];

      # --- Binds ---
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, foot"
        "$mod, Q, killactive"
        "$mod, E, exec, wofi --show drun"
        "$mod, Space, togglefloating"
        "$mod, F, fullscreen, 1"
        "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        "$mod, P, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
      ];

      # --- Exec-once ---
      # Keep exec-once minimal; most things are HM services now.
      exec-once = [
        "waybar"   # Waybar is a user app; we’ll manage its files via HM below
      ];
    };
  };
}


{ config, pkgs, ... }:

{
  home.username = "raskil";
  home.homeDirectory = "/home/raskil";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    foot
    wofi
    waybar
    hyprpaper
    wlogout     # <— logout menu
    grim slurp  # screenshots
    wl-clipboard
    brightnessctl
    pavucontrol
  ];
  
   programs.vscode = {
    enable = true;
    package = pkgs.vscode; # or pkgs.vscodium if you prefer FOSS build

    # Handy extensions to start
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-toolsai.jupyter
      ms-vscode.cpptools
      rust-lang.rust-analyzer
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      golang.go
      ms-azuretools.vscode-docker
      streetsidesoftware.code-spell-checker
    ];

    userSettings = {
      "window.titleBarStyle" = "custom";
      "window.zoomLevel" = 0;
      "editor.fontLigatures" = false;

      # Wayland niceties for Electron
      "terminal.integrated.defaultProfile.linux" = "bash";
      "workbench.startupEditor" = "none";
    };
  };

  # Make sure Electron apps get Wayland by default in your session too
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "waybar"
        "hyprpaper"
      ];

      input = { kb_layout = "dk"; };

      general = {
        gaps_in = 5;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee)";
        "col.inactive_border" = "rgba(595959aa)";
      };

      decoration = { rounding = 10; };

      #  KEYBINDINGS
      bind = [
        # Apps
        "SUPER, RETURN, exec, foot"
        "SUPER, D, exec, wofi --show drun"
	"SUPER, C, exec, code"

        # Window mgmt
        "SUPER, Q, killactive"
        "SUPER, F, fullscreen"

        # Focus (HJKL like i3/vim)
        "SUPER, H, movefocus, l"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"
        "SUPER, L, movefocus, r"

        # Workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, SHIFT+1, movetoworkspace, 1"
        "SUPER, SHIFT+2, movetoworkspace, 2"
        "SUPER, SHIFT+3, movetoworkspace, 3"
        "SUPER, SHIFT+4, movetoworkspace, 4"

        # Hyprland session control
        "SUPER, ESCAPE, exec, wlogout -p layer-shell --buttons-per-row 2"   # logout/reboot/shutdown menu
        "SUPER, SHIFT+E, exec, hyprctl dispatch exit"   # exit Hyprland
        "SUPER, SHIFT+R, exec, hyprctl reload"          # reload Hyprland config

        # Screenshots
        "SUPER, S, exec, grim -g \"$(slurp)\" - | wl-copy"  # area to clipboard
      ];
    };
  };

  programs.waybar.enable = true;
  programs.foot.enable = true;

  # Optional: minimal wlogout layout/theme
  xdg.configFile."wlogout/layout".text = ''
    {
      "label": "lock",
      "action": "loginctl lock-session",
      "text": "Lock"
    }
    {
      "label": "logout",
      "action": "hyprctl dispatch exit",
      "text": "Logout"
    }
    {
      "label": "reboot",
      "action": "systemctl reboot",
      "text": "Reboot"
    }
    {
      "label": "shutdown",
      "action": "systemctl poweroff",
      "text": "Shutdown"
    }
  '';

  # (Style is optional; wlogout works without it. Add later if you want pretty buttons.)
}

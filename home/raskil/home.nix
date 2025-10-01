{ config, pkgs, ... }:

{
  home.username = "raskil";
  home.homeDirectory = "/home/raskil";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    foot
    wofi
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

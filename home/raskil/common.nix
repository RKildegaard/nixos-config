{ config, pkgs, ... }:
{
  home.username = "raskil";
  home.homeDirectory = "/home/raskil";
  home.stateVersion = "25.05";

  # Load your Hyprland HM settings (keybinds, exec-once, etc.)
  imports = [ ./hyprland.nix ];

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "20";
    HYPRCURSOR_THEME = "Bibata-Modern-Classic";
    HYPRCURSOR_SIZE = "20";
  };


  home.packages = with pkgs; [
    # Wayland session apps
    foot
    wofi waybar hyprpaper mako cliphist

    # Tray apps & helpers started in Hyprland exec-once
    networkmanagerapplet
    blueman
    udiskie
    pavucontrol

    # Display tools
    way-displays
    wlr-randr
    jq

    # Theming tools
    nwg-look
    libsForQt5.qt5ct
    qt6ct
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
    gtk.enable = true;  # write GTK settings & ~/.icons/default
    x11.enable = true;  # write X settings too
  };


  # ----- Qt theming -----
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "Adwaita-Dark";
  };

  programs.vscode = { enable = true; package = pkgs.vscode; };

  # ----- Repo -> $HOME mappings -----
  xdg.configFile."waybar/config".source           = ./waybar/config;
  xdg.configFile."waybar/style.css".source        = ./waybar/style.css;
  xdg.configFile."mako/config".source             = ./mako/config;
  xdg.configFile."hypr/hyprpaper.conf".source     = ./hypr/hyprpaper.conf;
  xdg.configFile."wofi/scale-manager.css".source  = ./wofi/scale-manager.css;

  home.file.".local/bin/powermenu"       = { source = ./scripts/powermenu;       executable = true; };
  home.file.".local/bin/display-manager" = { source = ./scripts/display-manager; executable = true; };

  # ----- kanshi (deprecated schema, but works) -----
  services.kanshi = {
    enable = true;
    profiles = {
      mobile = {
        outputs = [
          { criteria = "eDP-1";   mode = "1920x1080@60Hz"; position = "0,0"; scale = 1.0; }
        ];
      };
      docked = {
        outputs = [
          { criteria = "HDMI-A-1"; mode = "2560x1440@144Hz"; position = "0,0"; scale = 1.0; }
          { criteria = "eDP-1";    status = "disable"; }
        ];
      };
    };
  };
}


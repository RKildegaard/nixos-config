{ pkgs, self, ... }:
let
  footConfig = ../files/foot/foot.ini;
  powermenuScript = ../files/bin/powermenu;
  thermalScript = ../files/bin/waybar-thermal;
  lockScript = ../files/bin/lockscreen;
  gnomeHubScript = ../files/bin/gnome-control-hub;
  system = pkgs.stdenv.hostPlatform.system;
in
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "RKildegaard";
      email = "rasmuskildegaard20@gmail.com";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.foot = {
    enable = true;
    server.enable = true;
  };
  xdg.configFile."foot/foot.ini".source = footConfig;

  programs.wofi.enable = true;
  programs.vscode.enable = true;
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    gtk3.extraConfig."gtk-application-prefer-dark-theme" = 1;
    gtk4.extraConfig."gtk-application-prefer-dark-theme" = 1;
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "Adwaita-dark";
    icon-theme = "Adwaita";
  };
  xdg.configFile."wofi/config".source = ../files/wofi/config;
  xdg.configFile."wofi/style.css".source = ../files/wofi/style.css;
  xdg.configFile."wofi/powermenu.css".source = ../files/wofi/powermenu.css;
  xdg.configFile."wofi/scale-manager.css".source = ../files/wofi/scale-manager.css;

  xdg.desktopEntries."raskil-settings" = {
    name = "System Settings";
    comment = "Configure system & desktop";
    exec = "raskil-settings";
    icon = "preferences-system";
    categories = [ "Settings" "System" ];
    terminal = false;
  };

  xdg.desktopEntries."gnome-control-center" = {
    name = "System Settings (GNOME)";
    exec = "gnome-control-hub";
    noDisplay = true;
    terminal = false;
    categories = [ "Settings" ];
  };

  home.packages = [
    self.packages.${system}.raskil-settings
    (pkgs.writeShellApplication {
      name = "powermenu";
      runtimeInputs = [ pkgs.wofi pkgs.systemd pkgs.coreutils ];
      text = builtins.readFile powermenuScript;
    })
    (pkgs.writeShellApplication {
      name = "waybar-thermal";
      runtimeInputs = [ pkgs.coreutils pkgs.gawk ];
      text = builtins.readFile thermalScript;
    })
    (pkgs.writeShellApplication {
      name = "lockscreen";
      runtimeInputs = [ pkgs.coreutils pkgs.systemd ];
      text = builtins.readFile lockScript;
    })
    (pkgs.writeShellApplication {
      name = "gnome-control-hub";
      runtimeInputs = [ pkgs.gnome-control-center ];
      text = builtins.readFile gnomeHubScript;
    })
    pkgs.hyprlock
  ];
}

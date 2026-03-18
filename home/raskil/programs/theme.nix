{ pkgs, ... }:
let
  cursorThemeName = "Bibata-Modern-Ice";
in
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = cursorThemeName;
    package = pkgs.bibata-cursors;
    size = 24;
  };

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
    cursor-theme = cursorThemeName;
    cursor-size = 24;
  };
}

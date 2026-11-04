{...}: {
  flake.modules.homeManager.theme = {pkgs, ...}: {
    # Dux generates these colors from the selected wallpaper. These imports
    # opt GTK into Dux theming while leaving Dux free to refresh its palette.
    xdg.configFile."gtk-3.0/gtk.css".text = ''
      @import url("dank-colors.css");
    '';
    xdg.configFile."gtk-4.0/gtk.css".text = ''
      @import url("dank-colors.css");
    '';

    home.packages = with pkgs; [
      adw-gtk3
      bibata-cursors
    ];
  };
}

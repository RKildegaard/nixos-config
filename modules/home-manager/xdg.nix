{
  flake.modules.homeManager.xdg = {
    xdg.mimeApps = {
      enable = true;
      associations.added = {};
      defaultApplications = {
        "inode/directory" = ["org.gnome.Nautilus.desktop"];
        "application/x-gnome-saved-search" = ["org.gnome.Nautilus.desktop"];
      };
    };

    xdg.configFile."mimeapps.list".force = true;
    xdg.dataFile."applications/mimeapps.list".force = true;
  };
}

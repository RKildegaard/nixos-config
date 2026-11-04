{
  flake.modules.homeManager.xdg = {
    programs.dux-files = {
      enable = true;
      portal = {
        enable = true;
        preferred = true;
        desktop = "hyprland";
      };
    };

    xdg.mimeApps = {
      enable = true;
      associations.added = {};
      defaultApplications = {
        "inode/directory" = ["dev.duxlabs.files.desktop"];
        "application/x-gnome-saved-search" = ["dev.duxlabs.files.desktop"];
      };
    };

    xdg.configFile."mimeapps.list".force = true;
    xdg.dataFile."applications/mimeapps.list".force = true;
  };
}

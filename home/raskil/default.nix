{ config, pkgs, lib, ... }:

{
  # This module is imported by your flake under home-manager.users.raskil
  # Keep HM-specific, user-scoped bits here and split details into the files below.

  imports = [
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./hyprland.nix
    ./waybar.nix
    ./mako.nix
  ];

  # Set once and then leave it. Bump only when you *really* intend to.
  home.stateVersion = "24.11";

  # Consistent cursor via HM (GTK + Wayland)
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    size = 20;
    gtk.enable = true;
  };

  # If you previously set NIXOS_OZONE_WL system-wide, you can omit this.
  # If you prefer it here (user scope), keep it and remove from system.
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Link non-program configs that aren’t covered by dedicated program modules
  xdg.configFile."wofi/scale-manager.css".source = ./files/wofi/scale-manager.css;

  # Maintain a tidy XDG layout
  xdg.userDirs.enable = true;

  # Optional: shell defaults (comment out if you use zsh/fish elsewhere)
  programs.bash.enable = true;
}


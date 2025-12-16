{ config, pkgs, lib, ... }:
{
  imports = [
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/services.nix
    ./modules/desktop
    ./modules/settings.nix
  ];

  home.stateVersion = "24.11";

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.configFile."wofi/scale-manager.css".source = ./files/wofi/scale-manager.css;

  xdg.userDirs.enable = true;

  programs.bash.enable = true;

  home.activation.cleanupGtkrc = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f "${config.home.homeDirectory}/.gtkrc-2.0"
  '';
}

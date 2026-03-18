{ config, lib, ... }:
{
  home.stateVersion = "24.11";

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.userDirs.enable = true;

  programs.bash.enable = true;

  home.activation.cleanupGtkrc = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f "${config.home.homeDirectory}/.gtkrc-2.0"
  '';
}

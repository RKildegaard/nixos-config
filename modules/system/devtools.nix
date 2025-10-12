{ pkgs, lib, config, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      warn-dirty = false;

    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  programs.git.enable = true;

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;
}


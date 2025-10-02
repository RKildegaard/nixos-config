{ pkgs, lib, ... }:

{
  # Nix & store hygiene
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      warn-dirty = false;
      # substituters / trusted-public-keys can be added here if you use Cachix
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Containers (pick one; docker or podman). Docker here matches your earlier setup.
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Developer QoL (system-level). User tooling stays in HM.
  programs.git.enable = true;

  # Kernel tweaks (optional)
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;
}


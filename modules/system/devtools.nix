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

  sops.age.keyFile = "/var/lib/sops-nix/age/keys.txt";
  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  sops.secrets.github_token = {
    owner = "root";
    mode = "0400";
  };

  sops.templates."nix-netrc".content = ''
    machine github.com
      login x-oauth-basic
      password {{ .github_token }}
  '';
  sops.templates."nix-netrc".mode = "0400";

  environment.etc."nix/netrc" = {
    source = config.sops.templates."nix-netrc".path;
    mode = "0400";
  };

  nix.settings.netrc-file = "/etc/nix/netrc";

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  programs.git.enable = true;

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;
}


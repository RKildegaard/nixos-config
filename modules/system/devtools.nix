{ pkgs, lib, config, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      warn-dirty = false;

      # ❌ REMOVE the old access-tokens with builtins.readFile here
      # access-tokens = [ ... ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # ---- sops-nix wiring ----
  sops.age.keyFile = "/var/lib/sops-nix/age/keys.txt";
  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  # Decrypt the raw token (not used directly in nix.settings)
  sops.secrets.github_token = {
    owner = "root";
    mode = "0400";
  };

  # Render a netrc using the secret at activation time
  sops.templates."nix-netrc".content = ''
    machine github.com
      login x-oauth-basic
      password {{ .github_token }}
  '';
  sops.templates."nix-netrc".mode = "0400";

  # Install the rendered netrc to /etc so nix-daemon can use it
  environment.etc."nix/netrc" = {
    source = config.sops.templates."nix-netrc".path;
    mode = "0400";
  };

  # Point Nix at the netrc
  nix.settings.netrc-file = "/etc/nix/netrc";

  # ---- the rest of your module ----
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  programs.git.enable = true;

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;
}


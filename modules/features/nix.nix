{inputs, ...}: {
  flake.modules.nixos.nix = {
    nixpkgs.overlays = [
      inputs.self.overlays.default
    ];

    programs = {
      git.enable = true;
      nix-ld.enable = true;
    };

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
        warn-dirty = false;
        trusted-users = [
          "root"
          "@wheel"
        ];
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };
  };
}

{inputs, ...}: let
  user = "raskil";
  inherit (inputs.self.lib) zsh;
in {
  flake.modules.nixos.raskil = {lib, ...}: {
    imports = [
      (zsh user)
    ];

    nixpkgs.config.allowUnfree = true;

    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
        "input"
        "docker"
        "dialout"
        "libvirtd"
        "kvm"
      ];
    };

    security.sudo = {
      enable = true;
      wheelNeedsPassword = lib.mkDefault true;
    };

    home-manager.users.${user} = {
      home = {
        username = user;
        homeDirectory = "/home/${user}";
      };
    };

    home-manager.sharedModules = with inputs.self.modules.homeManager; [
      common
      packages
      cli
      foot
      theme
      vscode
      xdg
      scripts
      matlab
      hyprland
      services
      inputs.dfiles.homeModules.dux-files
    ];
  };
}

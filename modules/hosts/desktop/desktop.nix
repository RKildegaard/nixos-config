{inputs, ...}: {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.desktopHost
    ];
  };

  flake.modules.nixos.desktopHost = {
    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "desktop";
    system.stateVersion = "25.05";

    imports = with inputs.self.modules.nixos; [
      base
      nix
      locale
      network
      sound
      fonts
      packages
      virtualization
      desktop
      workstation
      homeManager
      raskil
    ];

    home-manager.sharedModules = [
      {
        wayland.windowManager.hyprland.settings.monitor = [
          ",preferred,auto,1.5"
        ];
      }
    ];

    boot.loader.grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
    };

    services = {
      tlp.enable = true;
      power-profiles-daemon.enable = false;
    };
  };
}

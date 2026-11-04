{inputs, ...}: {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.desktopHost
    ];
  };

  flake.modules.nixos.desktopHost = {
    pkgs,
    ...
  }: {
    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "desktop";
    system.stateVersion = "25.05";

    # The AMD GPU drives the physical DP/HDMI connectors on this machine.
    # Without its firmware, amdgpu aborts during initialization.
    hardware.firmware = [pkgs.linux-firmware];
    hardware.graphics.enable = true;    

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
      efiSupport = true;
      useOSProber = true;
    };

    boot.loader.efi.canTouchEfiVariables = true;

    services = {
      tlp.enable = true;
      power-profiles-daemon.enable = false;
    };
  };
}

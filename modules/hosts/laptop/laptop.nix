{
  inputs,
  ...
}: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.laptop
    ];
  };

  flake.modules.nixos.laptop = {
    lib,
    pkgs,
    ...
  }: {
    nixpkgs.hostPlatform = "x86_64-linux";

    networking.hostName = "laptop";
    system.stateVersion = "25.05";

    hardware = {
      facter = {
        reportPath = ./facter.json;

        # NetworkManager owns runtime network configuration on this host.
        detected.dhcp.enable = false;

        # The report was generated while the dGPU was bound to vfio-pci;
        # keep that stale passthrough driver out of initrd.
        detected.boot.graphics.kernelModules = lib.mkForce ["i915"];
      };

      # The Precision 5570 hardware profile defaults to xe on newer kernels,
      # but this machine is currently more stable on i915.
      intelgpu.driver = lib.mkForce "i915";
    };

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
      mobile
      homeManager
      raskil
      inputs.nixos-hardware.nixosModules.dell-precision-5570
    ];

    boot.loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };

    home-manager.sharedModules = [
      {
        wayland.windowManager.hyprland.settings.monitor = [
          "eDP-1,preferred,auto,1.25"
          "DP-2,preferred,auto,1.6"
          ",preferred,auto,1.5"
        ];
      }
    ];

    services.udev = {
      packages = [pkgs.mixxx];
      extraRules = ''
        # IOLab CDC-ACM serial port
        SUBSYSTEM=="tty", ATTRS{idVendor}=="1881", ATTRS{idProduct}=="0400", \
          MODE="0664", GROUP="dialout", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"

        # Also tag the USB interface so ModemManager ignores the parent
        SUBSYSTEM=="usb", ATTR{idVendor}=="1881", ATTR{idProduct}=="0400", \
          ENV{ID_MM_DEVICE_IGNORE}="1"
      '';
    };
  };
}

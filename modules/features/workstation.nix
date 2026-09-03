{
  flake.modules.nixos.workstation = {lib, pkgs, ...}: {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };

    services = {
      gnome.gnome-settings-daemon.enable = true;
      blueman.enable = true;
      gvfs.enable = true;
      tailscale.enable = lib.mkDefault true;

      udev.packages = [
        pkgs.gnome-settings-daemon
        pkgs.platformio-core
        pkgs.openocd
      ];

      printing = {
        enable = true;
        browsed.enable = false;
        drivers = with pkgs; [
          gutenprint
          hplip
        ];
      };
    };

    # The printer ensure service fails activation when mDNS printers are offline.
    # Keep CUPS and drivers enabled, but add printers manually or with discovery.
  };

  flake.modules.nixos.mobile = {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}

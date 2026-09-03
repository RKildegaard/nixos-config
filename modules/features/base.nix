{
  flake.modules.nixos.base = {config, lib, pkgs, ...}: {
    boot.tmp.cleanOnBoot = true;
    powerManagement.enable = true;

    hardware = {
      cpu = {
        intel.updateMicrocode = lib.mkDefault true;
        amd.updateMicrocode = lib.mkDefault true;
      };

      graphics = {
        enable = true;
        enable32Bit = true;
      };

      sane.enable = lib.mkDefault false;
    };

    services = {
      printing.enable = lib.mkDefault false;
      dbus.implementation = lib.mkForce "dbus";
      fwupd.enable = true;
    };

    security.polkit.enable = true;
  };
}

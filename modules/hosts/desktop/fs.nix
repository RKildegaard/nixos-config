{
  flake.modules.nixos.desktopHost = {lib, ...}: {
    boot.initrd.availableKernelModules = [
      "ata_piix"
      "mptspi"
      "uhci_hcd"
      "ehci_pci"
      "ahci"
      "sd_mod"
      "sr_mod"
    ];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/b56d63ba-9474-4362-9d07-4fbd71c035a3";
      fsType = "ext4";
    };

    swapDevices = [];
    networking.useDHCP = lib.mkDefault true;
  };
}
